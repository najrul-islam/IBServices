using CFEMSDB.DB;
using IBCore.Data;
using IBCore.DataModels;
using IBCore.Enums;
using Microsoft.Extensions.Configuration;
using MQTTProcessor;
using MQTTProcessor.Processor;
using Newtonsoft.Json;
using RBEProcessor.Models;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using uPLibrary.Networking.M2Mqtt.Messages;

namespace RBEProcessor.Services;

public interface IRBEService
{
    public IRBEService InitiateMQTTConnection();
    public void Execute();
}



public class RBEService : IRBEService
{
    private readonly IConfiguration _config;
    private readonly IBDBContext _db;
    private MQTTClient _mqtt;
    //private MqttProcessInfo _mqttConfiguration;
    private IMQTTConnProcessor _mqttConnProcessor;
    private TimeZoneInfo _tz;

    public RBEService(IConfiguration config, IBDBContext db , IMQTTConnProcessor mQTTConnProcessor)
    {
        _config = config;
        _db = db;
        _mqttConnProcessor = mQTTConnProcessor;
    }


    public IRBEService InitiateMQTTConnection()
    {
        //_mqttConfiguration = new MqttProcessInfo
        //{
        //    BrokerHost = _config.GetSection("MQTT:BrokerHostname").Value,
        //    ClientId = _config.GetSection("MQTT:ClientId").Value,
        //    Password = _config.GetSection("MQTT:Password").Value,
        //    Username = _config.GetSection("MQTT:Username").Value,
        //    ClearSession = false,
        //    DbConnectionString = _config.GetConnectionString("DefaultConnection")
        //};

        //_mqttConnProcessor = new MQTTConnProcessor(new string[] { "sg/sj/24k/willowglen/data/+" }, _mqttConfiguration);
        _tz = _mqttConnProcessor.TimezoneProcessor(_config.GetSection("Timezone").Value);
        _mqtt = _mqttConnProcessor.ProcessMqtt();

        return this;
    }


    public void Execute()
    {
        if (_mqtt != null)
        {
            _mqtt.MessageReceived += MessageReceived;
            _mqtt.ConnectionClosed += _mqttConnProcessor.ConnectionClosed;
        }

        void MessageReceived(object sender, MqttMsgPublishEventArgs e)
        {
            try
            {
                string payload = Encoding.UTF8.GetString(e.Message);
                //Ignor messages are not from data topic. 
                if (e.Topic.Contains("/data"))
                {
                    string json = payload;
                    //Quick check if message isn't in JSON format will skip the message
                    if (!json.Trim().StartsWith("{"))
                    {
                        return;
                    }
                    LM_DataPackage_RBE rbePkg;
                    try
                    {
                        rbePkg = JsonConvert.DeserializeObject<LM_DataPackage_RBE>(json);
                        switch (rbePkg.data_type)
                        {
                            case (int)DataTypeEnum.rbe: // rbe

                                Console.ForegroundColor = ConsoleColor.DarkGreen;
                                Console.WriteLine($"{TimeZoneInfo.ConvertTime(DateTimeOffset.Now, _tz).ToString("yyyy-MM-ddTHH:mm:sszzz")} - Data Received, Topic: {e.Topic}, Payload: {payload}");
                                Console.ForegroundColor = ConsoleColor.White;

                                if (rbePkg is not null)
                                {
                                    RbeMessageProcessing(rbePkg);
                                }
                                break;
                        }
                    }
                    catch (Exception)
                    {
                        Console.WriteLine("Data package failed to deserialize from JSON.");
                        return;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception on MessageReceived(): {ex}");
            }
        }

        void RbeMessageProcessing(LM_DataPackage_RBE rbePkg)
        {
            var rbeMessageList = (from rbe in rbePkg.data orderby rbe.lmd_id, rbe.rbe_datetime select rbe).ToList();
            string assetType = "RTU";

            if (assetType == "RTU")
            {
                foreach (var rbeMessage in rbeMessageList)
                {
                    rbeMessage.rbe_datetime = TimeZoneInfo.ConvertTime(rbeMessage.rbe_datetime, _tz);
                    //using (var db = new IBDBContext(_mqttConfiguration.DbConnectionString))
                    //{
                        try
                        {
                            //db save
                            if (UpdateRBEToDB(rbeMessage))
                            {
                                Console.WriteLine("RBE Successfully inserted to db.");
                            }
                            else
                            {
                                Console.WriteLine("Error while insert inserted to db.");
                            }
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine(ex.ToString());
                        }
                    //}
                }
            }
        }

        bool UpdateRBEToDB(rbe_data rbeMessage)
        {
            // begin transaction
            using (var transaction = _db.Database.BeginTransaction())
            {
                try
                {
                    //get Equipment
                    TblEquipment equipmentRbeLatest = _db.TblEquipments.FirstOrDefault(c => c.ColRtuIdFk == rbeMessage.lmd_id && c.ColRtuNumber == rbeMessage.lmd_no);
                    if (equipmentRbeLatest is null)
                    {
                        Console.WriteLine("Invalid rtu_id or rtu_number.");
                    }
                    else
                    {
                        #region Update tbl_object_bits

                        //Convert hex to bit
                        List<ObjectBits> bitArrRbelo = PrepareHexToBit(rbeMessage.rbelo);
                        //get low bit from db
                        TblObjectBit objectBitRbelo = _db.TblObjectBits.FirstOrDefault(x => x.ColRtuIdFk == equipmentRbeLatest.ColRtuIdFk && x.ColEquipmentIdFk == equipmentRbeLatest.ColEquipmentId && x.ColIsAbove64 == false);

                        if (objectBitRbelo is not null && bitArrRbelo is not null)
                        {
                            objectBitRbelo = PrepareObjectBitDataToUpdate(rbeMessage.rbelo, equipmentRbeLatest.ColLatestRbelo, objectBitRbelo, bitArrRbelo, rbeMessage.rbe_datetime);

                            //update low bit
                            _db.Update(objectBitRbelo);
                            //latest rbelo
                            equipmentRbeLatest.ColLastRbelo = equipmentRbeLatest.ColLatestRbelo ?? rbeMessage.rbelo;
                            equipmentRbeLatest.ColLatestRbelo = rbeMessage.rbelo;

                            //if Equipment is RS485 (above 64 bit)
                            if (equipmentRbeLatest.ColDeviceType == 20 && !string.IsNullOrEmpty(rbeMessage.rbehi))
                            {
                                //Bit
                                List<ObjectBits> bitArrRbehi = PrepareHexToBit(rbeMessage.rbehi);
                                //Get high bit from db
                                TblObjectBit objectBitRbehi = _db.TblObjectBits.FirstOrDefault(x => x.ColRtuIdFk == equipmentRbeLatest.ColRtuIdFk && x.ColEquipmentIdFk == equipmentRbeLatest.ColEquipmentId && x.ColIsAbove64 == true);

                                if (objectBitRbehi is not null && bitArrRbehi is not null)
                                {
                                    objectBitRbehi = PrepareObjectBitDataToUpdate(rbeMessage.rbehi, equipmentRbeLatest.ColLatestRbehi, objectBitRbehi, bitArrRbehi, rbeMessage.rbe_datetime);

                                    //updae high bit
                                    _db.Update(objectBitRbehi);
                                }

                                //update latest rbehi
                                equipmentRbeLatest.ColLastRbehi = equipmentRbeLatest.ColLatestRbehi ?? rbeMessage.rbehi;
                                equipmentRbeLatest.ColLatestRbehi = rbeMessage.rbehi;
                            }

                        }
                        #endregion

                        // update latest rbe;
                        _db.Update(equipmentRbeLatest);

                        _db.SaveChanges();
                        // if successfullly execute then commit transaction
                    }
                    transaction.Commit();
                    return true;
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Error while updating..." + ex.ToString());
                    transaction.Rollback();
                    return false;
                }
            }

        }

        TblObjectBit PrepareObjectBitDataToUpdate(string rbeLatest, string rbeLast, TblObjectBit objectBit, List<ObjectBits> bitArrRbe, DateTime rbeDateTime)
        {
            var bitDiff = XORingBinaries(rbeLatest, rbeLast).ToCharArray();

            for (int i = 0; i < bitDiff.Length; i++)
            {
                if (bitDiff[i].ToString() == "1")
                {
                    int colIndex = (i + 1);
                    PropertyInfo bitColumn = typeof(TblObjectBit).GetProperty($"ColBit{colIndex}");
                    PropertyInfo bitDateColumn = typeof(TblObjectBit).GetProperty($"ColBit{colIndex}Date");
                    bitColumn.SetValue(objectBit, bitArrRbe?.FirstOrDefault(x => x.BitIndex == colIndex)?.Bit ?? false);
                    bitDateColumn.SetValue(objectBit, rbeDateTime);
                }

            }
            return objectBit;
        }

        //
        List<ObjectBits> PrepareHexToBit(string originalHexStr)
        {
            string stringHexRbe = PrepareHexStr(originalHexStr);
            string bitHexRbe = string.Join(string.Empty, Regex.Replace(stringHexRbe, @"\s+", "").Select(c => Convert.ToString(Convert.ToInt32(c.ToString(), 16), 2).PadLeft(4, '0')));
            char[] bitChars = bitHexRbe.ToCharArray();

            // check 8 Byte RBE Message is valid or missing any bit
            if (bitChars.Count() != 64)
            {
                Console.WriteLine("TRU RBE byte Invalid");
                return null;
            }
            List<ObjectBits> bitArrRbelo = bitHexRbe.Select((c, i) => { return new ObjectBits { BitIndex = i + 1, BitChar = c, Bit = c == '1' }; }).ToList();
            return bitArrRbelo;
        }

        string PrepareHexToBitStr(string originalHexStr)
        {
            string stringHexRbe = PrepareHexStr(originalHexStr);
            string bitHexRbe = string.Join(string.Empty, Regex.Replace(stringHexRbe, @"\s+", "").Select(c => Convert.ToString(Convert.ToInt32(c.ToString(), 16), 2).PadLeft(4, '0')));
            return bitHexRbe;
        }

        //Prepare hex string to "00 00 00 00 00 00 00 00" format
        string PrepareHexStr(string originalHexStr)
        {
            string newHex = null;
            if (!string.IsNullOrEmpty(originalHexStr))
            {
                originalHexStr = originalHexStr.Trim().Replace("0x", string.Empty);
                var list = Enumerable.Range(0, originalHexStr.Trim().Length / 2)
                    .Select(i => originalHexStr.Trim().Substring(i * 2, 2))
                    .ToList();
                newHex = string.Join(" ", list);
            }
            return newHex;
        }

        string XORingBinaries(string latestRBE, string lastRBE)
        {
            string ans = "";

            var rbeLatestBits = PrepareHexToBitStr(latestRBE);
            var rbeLastBits = PrepareHexToBitStr(lastRBE);

            for (int i = 0; i < rbeLatestBits.Length; i++)
            {
                ans += rbeLatestBits[i] == rbeLastBits[i] ? "0" : "1";
            }
            return ans;
        }

    }

}

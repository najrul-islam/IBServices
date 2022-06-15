using CFEMSDB.DB;
using CFEMSDB.Utility;
using IBCore.Data;
using IBCore.DataModels;
using IBCore.Enums;
using Microsoft.Extensions.Configuration;
using MQTTProcessor;
using MQTTProcessor.Processor;
using Newtonsoft.Json;
using System.Text;
using uPLibrary.Networking.M2Mqtt.Messages;

namespace HBTProcessor.Services;

public interface IHBTService
{
    public IHBTService InitiateMQTTConnection();
    public  void Execute();
}



public class HBTService : IHBTService
{
    private readonly IConfiguration _config;
    private readonly IBDBContext _db;
    private MQTTClient _mqtt;
    //private MqttProcessInfo _mqttConfiguration;
    private IMQTTConnProcessor _mqttConnProcessor;
    private TimeZoneInfo _tz;

    public HBTService(IConfiguration config, IBDBContext db, IMQTTConnProcessor mQTTConnProcessor)
    {
        _config = config;
        _db = db;
        _mqttConnProcessor = mQTTConnProcessor;
    }


    public IHBTService InitiateMQTTConnection()
    {
        //_mqttConfiguration = new MqttProcessInfo
        //{
        //    BrokerHost = _config.GetSection("MQTT:BrokerHostname").Value,
        //    ClientId = _config.GetSection("MQTT:ClientId").Value,
        //    Password = _config.GetSection("MQTT:Password").Value,
        //    Username = _config.GetSection("MQTT:Username").Value,
        //    ClearSession = false,
        //    //DbConnectionString = _config.GetConnectionString("DefaultConnection")
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

                    if (!json.Trim().StartsWith("{")) return;

                    HeartBeat hbtData;
                    try
                    {
                        hbtData = JsonConvert.DeserializeObject<HeartBeat>(json);

                        foreach (var item in hbtData.data)
                        {
                            var hbt = new TblEntityHeartbeat
                            {
                                ColLastHeartbeatDatetime = item.heartbeat_datetime,
                                ColIsDg = false,
                                ColIsRtu = false,
                                ColIsEquipment = false,
                                ColJsonText = JsonConvert.SerializeObject(hbtData)
                            };
                            switch (hbtData.data_type)
                            {
                                case (int)HeartbeatDataType.DG:
                                    Console.WriteLine($"{TimeZoneInfo.ConvertTime(DateTimeOffset.Now, _tz).ToString("yyyy-MM-ddTHH:mm:sszzz")} - DG Heartbeat Received, Topic: {e.Topic}, Payload: {payload}");
                                    hbt.ColEntityIdFk = Common.GetDGSetupId(item.dg_id, _config.GetConnectionString("DefaultConnection"));
                                    hbt.ColIsDg = true;
                                    UpdateHeartbeatToDB(hbt, hbtData.data_type, item.lmd_no);
                                    break;
                                case (int)HeartbeatDataType.Device:
                                    Console.WriteLine($"{TimeZoneInfo.ConvertTime(DateTimeOffset.Now, _tz).ToString("yyyy-MM-ddTHH:mm:sszzz")} - Device Heartbeat Received, Topic: {e.Topic}, Payload: {payload}");

                                    if (item.lmd_no == 0) // RTU
                                    {
                                        hbt.ColEntityIdFk = item.lmd_id;
                                        hbt.ColIsRtu = true;
                                    }
                                    else // Equipment
                                    {
                                        hbt.ColEntityIdFk = Common.GetEquipmentId(item.lmd_id, item.lmd_no, _config.GetConnectionString("DefaultConnection"));
                                        hbt.ColIsEquipment = true;
                                    }
                                    UpdateHeartbeatToDB(hbt, hbtData.data_type, item.lmd_no);
                                    break;
                                case (int)HeartbeatDataType.VM_STATUS:
                                    Console.WriteLine($"{TimeZoneInfo.ConvertTime(DateTimeOffset.Now, _tz).ToString("yyyy-MM-ddTHH:mm:sszzz")} - VM Status Received, Topic: {e.Topic}, Payload: {payload}");
                                    UpdateVMStatusToDB(/*_mqttConfiguration.DbConnectionString,*/ item);
                                    return;
                                default:
                                    break;
                            }

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
                Console.WriteLine($"Exception on MessageReceived(): {ex.Message}");
            }

        }

        void UpdateHeartbeatToDB(TblEntityHeartbeat hbt, int data_type, int lmd_no)
        {
            //using (var db = new IBDBContext(_mqttConfiguration.DbConnectionString))
            //{
                try
                {
                    var updatedEntity = _db.TblEntityHeartbeats.FirstOrDefault(x => x.ColEntityIdFk == hbt.ColEntityIdFk);

                    if (updatedEntity != null)
                    {
                        updatedEntity.ColJsonText = hbt.ColJsonText;
                        updatedEntity.ColLastHeartbeatDatetime = hbt.ColLastHeartbeatDatetime;
                        _db.Update(updatedEntity);
                        _db.SaveChanges();
                    }
                    else
                    {
                        _db.Add(hbt);
                        _db.SaveChanges();
                    }

                    switch (data_type)
                    {
                        case (int)HeartbeatDataType.DG:
                            TblDgSetup dg = _db.TblDgSetups.FirstOrDefault(x => x.ColDgSetupId.ToString() == hbt.ColEntityIdFk);
                            dg.ColIsOnline = true;
                            _db.Update(dg);
                            _db.SaveChanges();
                            break;
                        case (int)HeartbeatDataType.Device:
                            if (lmd_no == 0)
                            {
                                TblRtu rtu = _db.TblRtus.FirstOrDefault(x => x.ColRtuId == hbt.ColEntityIdFk);
                                rtu.ColIsOnline = true;
                                _db.Update(rtu);
                            }
                            else
                            {
                                TblEquipment eq = _db.TblEquipments.FirstOrDefault(x => x.ColEquipmentId == hbt.ColEntityIdFk);
                                eq.ColIsOnline = true;
                                _db.Update(eq);
                            }
                            _db.SaveChanges();
                            break;
                        default:
                            break;

                    }

                    Console.WriteLine("Heartbeat save successful!");
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Error Occured to save hertbeat!! Error: " + ex.Message);
                }

            //}
        }
    }

    private void UpdateVMStatusToDB(/*string cs,*/ HeartbeatData item)
    {
        //using (var db = new IBDBContext(cs))
        //{
            TblDgVmSetup vm = _db.TblDgVmSetups.FirstOrDefault(x => x.ColDgVmId == item.vm_id);
            vm.ColVmStatus = Convert.ToByte(item.status);
            vm.ColIsOnline = item.status == 0 ? false : true;
            _db.Update(vm);
            _db.SaveChanges();
        //}
    }
}

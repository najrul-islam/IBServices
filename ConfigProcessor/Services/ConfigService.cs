using CFEMSDB.DB;
using IBCore.Data;
using IBCore.DataModels;
using IBCore.Enums;
using Microsoft.Extensions.Configuration;
using MQTTProcessor;
using MQTTProcessor.Processor;
using Newtonsoft.Json;
using System.Text;
using uPLibrary.Networking.M2Mqtt.Messages;

namespace ConfigProcessor.Services;

public interface IConfigService
{
    public IConfigService InitiateMQTTConnection();
    public void Execute();
}



public class ConfigService : IConfigService
{
    private readonly string _topicPrefix;
    private readonly string[] _TopicsToSubscribe;

    private readonly IConfiguration _config;
    private readonly IBDBContext _db;
    private MQTTClient _mqtt;
    //private MqttProcessInfo _mqttConfiguration;
    private IMQTTConnProcessor _mqttConnProcessor;
    private TimeZoneInfo _tz;

    public ConfigService(IConfiguration config, IBDBContext db, IMQTTConnProcessor mQTTConnProcessor)
    {
        _config = config;
        _db = db;
        _mqttConnProcessor = mQTTConnProcessor;
    }


    public IConfigService InitiateMQTTConnection()
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

        //_mqttConnProcessor = new MQTTConnProcessor(_TopicsToSubscribe, _mqttConfiguration);
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
                    if (!json.Trim().StartsWith("{")) return;

                    LM_DataPackage dataPkg;
                    try
                    {
                        dataPkg = JsonConvert.DeserializeObject<LM_DataPackage>(json);
                        switch (dataPkg.data_type)
                        {
                            case (int)DataTypeEnum.device_config_request: //device_config_request
                                                                          // Log received raw data
                                Console.WriteLine($"{TimeZoneInfo.ConvertTime(DateTimeOffset.Now, _tz).ToString("yyyy-MM-ddTHH:mm:sszzz")} - Device Config Request Received, Topic: {e.Topic}, Payload: {payload}");

                                LM_DataPackage_Device_Config_Request dcePkg = JsonConvert.DeserializeObject<LM_DataPackage_Device_Config_Request>(json);
                                if (dcePkg != null)
                                {
                                    DeviceConfigRequestProcessing(dcePkg);
                                }
                                break;
                            case (int)DataTypeEnum.dg_config_request: // dg_config_request
                                Console.WriteLine($"{TimeZoneInfo.ConvertTime(DateTimeOffset.Now, _tz).ToString("yyyy-MM-ddTHH:mm:sszzz")} - DG Config Request Received, Topic: {e.Topic}, Payload: {payload}");

                                LM_DataPackage_DG_Config_Request dgconPkg = JsonConvert.DeserializeObject<LM_DataPackage_DG_Config_Request>(json);
                                if (dgconPkg != null)
                                {
                                    DGConfigRequestProcessing(dgconPkg);
                                }
                                break;
                        }
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Data package failed to deserialize from JSON: {ex.ToString()}");
                        return;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception on MessageReceived(): {ex.ToString()}");
            }
        }

        void SendMessage(LM_Package pkg, string topic)
        {
            try
            {
                if (typeof(LM_CommandPackage) == pkg.GetType()) InjectCommandName(pkg as LM_CommandPackage);
                string message = JsonConvert.SerializeObject(pkg, Formatting.Indented);
                Thread.Sleep(1); // sleep 0.001 second to prevent of .NET MQTT client deadlcok.  
                _mqtt.Publish(topic, Encoding.UTF8.GetBytes(message));
                Console.WriteLine($"Message Sent, topic {topic}, payload {message}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception on SendMessage: {ex}");
            }
        }

        //DEVICE CONFIG
        void DeviceConfigRequestProcessing(LM_DataPackage_Device_Config_Request dcePkg)
        {
            var dceList = (from dhb in dcePkg.data orderby dhb.lmd_id select dhb).ToList();
            try
            {
                foreach (var dce in dceList)
                {
                    try
                    {
                        //using (var db = new IBDBContext(_mqttConfiguration.DbConnectionString))
                        //{
                            var rtu = _db.TblRtus.Where(r => r.ColRtuId == dce.lmd_id).FirstOrDefault();

                            var dg = (from l in _db.TblRtus
                                      join d in _db.TblDgSetups on l.ColDgSetupIdFk equals d.ColDgSetupId.ToString()
                                      join m in _db.TblDgMaintenanceCompanies on d.ColDgMaintenanceCompanyIdFk equals m.ColDgMaintenanceCompanyId.ToString()
                                      where l.ColRtuId == dce.lmd_id
                                      select new
                                      {
                                          colDGId = d.ColDgId,
                                          colMaintenanceCompanyName = m.ColDgMaintenanceCompanyName
                                      }).FirstOrDefault();

                            string commandTopic = _topicPrefix + dg.colMaintenanceCompanyName.ToLower() + "/cmd/" + dg.colDGId;

                            int dayNightFlag = rtu.ColDayNightFlag == true ? 1 : 0;
                            var rbeLatestDic = new List<Dictionary<string, string>>();
                            var rbeLatest = _db.TblEquipments.Where(r => r.ColRtuIdFk == dce.lmd_id).ToList();
                            foreach (var item in rbeLatest)
                            {
                                string rbe = "0x0000000000000000";
                                rbe = item.ColLastRbelo ?? rbe;
                                //rbe high
                                if (item.ColDeviceType == 20)
                                {
                                    string rbehi = item.ColLastRbehi?.Replace("0x", string.Empty) ?? "0000000000000000";
                                    rbe = $"{rbe}{rbehi}";
                                }
                                var dic = new Dictionary<string, string>
                                        {
                                            { $"{item.ColRtuNumber}", rbe }
                                        };
                                rbeLatestDic.Add(dic);
                            }

                            //create enable_device command
                            LM_CommandPackage cmdPkg = new LM_CommandPackage();
                            cmdPkg.timestamp = TimeZoneInfo.ConvertTime(DateTimeOffset.Now, _tz).ToString("yyyy-MM-ddTHH:mm:sszzz");
                            cmdPkg.target_list = new string[] { dce.lmd_id };

                            LM_CommandPackage.Command command = new LM_CommandPackage.Command();
                            command.command_type = (int)CommandTypeEnum.send_device_config;
                            command.parameters.Add("day_night_flag", dayNightFlag);
                            command.parameters.Add("last_rbe", rbeLatestDic);
                            cmdPkg.commands.Add(command);

                            //send a command 
                            SendMessage(cmdPkg, commandTopic);
                        //}
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex.ToString());
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Class Name : DataProcessing Method Name : DeviceConfigRequestProcessing -- " + ex.ToString() + "");
            }
        }

        //DG CONFIG
        void DGConfigRequestProcessing(LM_DataPackage_DG_Config_Request dgconPkg)
        {
            try
            {
                var dgConfigData = (from d in dgconPkg.data orderby d.dg_id select d).ToList();

                foreach (var data in dgConfigData)
                {
                    //using (var db = new IBDBContext(_mqttConfiguration.DbConnectionString))
                    //{
                        var dgDetail = (from d in _db.TblDgSetups
                                        join v in _db.TblDgVmSetups on d.ColDgVmSetupIdFk equals v.ColDgVmSetupId.ToString()
                                        join m in _db.TblDgMaintenanceCompanies on d.ColDgMaintenanceCompanyIdFk equals m.ColDgMaintenanceCompanyId.ToString()
                                        where d.ColDgId == data.dg_id
                                        && v.ColDgVmId == data.vm_id
                                        && v.ColVmStatus == 1 // active
                                        select new
                                        {
                                            d.ColConfiugrationFileHash,
                                            m.ColDgMaintenanceCompanyName
                                        }).FirstOrDefault();

                        if (dgDetail == null)
                        {
                            Console.WriteLine($"DG not found using DG ID: {data.dg_id} and VM ID: {data.vm_id}");
                        }

                        if (!string.IsNullOrEmpty(dgDetail?.ColConfiugrationFileHash) && !string.IsNullOrWhiteSpace(dgDetail?.ColConfiugrationFileHash))
                        {
                            // send_dg_config commadn
                            LM_CommandPackage cmdPkgg = new LM_CommandPackage();
                            cmdPkgg.timestamp = TimeZoneInfo.ConvertTime(DateTimeOffset.Now, _tz).ToString("yyyy-MM-ddTHH:mm:sszzz");
                            cmdPkgg.target_list = new string[] { data.dg_id };
                            LM_CommandPackage.Command commanddd = new LM_CommandPackage.Command();
                            commanddd.command_type = (int)CommandTypeEnum.send_dg_config;
                            commanddd.parameters.Add("file_hash", dgDetail.ColConfiugrationFileHash);
                            cmdPkgg.commands.Add(commanddd);
                            //send a command
                            SendMessage(cmdPkgg, $"{_topicPrefix}{dgDetail.ColDgMaintenanceCompanyName.ToLower()}/cmd/{data.dg_id}");
                        }
                        else
                        {
                            Console.WriteLine($"DG Configuration not found using DG ID: {data.dg_id} and VM ID: {data.vm_id}");
                        }
                    //}
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }

        void InjectCommandName(LM_CommandPackage cmdPkg)
        {
            foreach (LM_CommandPackage.Command command in cmdPkg.commands)
            {
                int type = command.command_type;
                command.command_name =
                    type == 0 ? "ib_heartbeat" :
                    type == 1 ? "enable_disable_device" :
                    type == 2 ? "issue_test" :
                    type == 3 ? "set_mask_value" :
                    type == 4 ? "set_day_night_flag" :
                    type == 5 ? "reqeust_lift_status" :
                    type == 6 ? "add_device_to_dg" :
                    type == 7 ? "remove_device_from_dg" :
                    type == 8 ? "send_device_config" :
                    type == 9 ? "test_status_ack" :
                    type == 10 ? "reset_credential" :
                    type == 11 ? "change_mode" :
                    type == 21 ? "send_dg_config" :
                    "unknow_command";
            }
        }
    }

}

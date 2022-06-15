using CFEMSDB.DB;
using IBCore.DataModels;
using IBSimulatorWeb.Models;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MQTTProcessor.Processor;
using Newtonsoft.Json;
using System.Text;

namespace IBSimulatorWeb.Pages
{
    public class DevicesModel : PageModel
    {
        private readonly ILogger<DevicesModel> _logger;
        private readonly IConfiguration _configuration;
        private readonly IBDBContext _db;
        private readonly IMQTTConnProcessor _mqttConnProcessor;
        public string _status;
        //private readonly MQTTClient _mQTTClient;
        public DevicesModel(ILogger<DevicesModel> logger, IConfiguration configuration, IBDBContext db, IMQTTConnProcessor mQTTConnProcessor)//,MQTTClient mQTTClient 
        {
            _logger = logger;
            _configuration = configuration;
            _db = db;
            _mqttConnProcessor = mQTTConnProcessor;
            //_mQTTClient = mQTTClient;
        }

        public List<TblEquipment> GetDevices()
        {
            //using (var db = new IBDBContext(_configuration.GetConnectionString("DefaultConnection")))
            //{
                var equipments = new List<TblEquipment>();
                return equipments = _db.TblEquipments.ToList();
            //}
        }
        public void OnPostCheckLiftStatus(string rtuId, string targetLift = "all")
        {
            //#region configuration
            //var mqttConfiguration = new MqttProcessInfo
            //{
            //    BrokerHost = _configuration.GetSection("MQTT:BrokerHostname").Value,
            //    ClientId = _configuration.GetSection("MQTT:ClientId").Value,
            //    Password = _configuration.GetSection("MQTT:Password").Value,
            //    Username = _configuration.GetSection("MQTT:Username").Value,
            //    ClearSession = false,
            //    //DbConnectionString = _configuration.GetConnectionString("DefaultConnection")
            //};
            //#endregion configuration

            string dgId = "";
            List<string> targetLmdList = new List<string>();
            List<Command> commands = new List<Command>();
            Command com = new Command
            {
                command_name = "request_lift_status",
                command_type = 5,
                parameters = new Parameters()
            };
            commands.Add(com);

            //using (var db = new IBDBContext(_configuration.GetConnectionString("DefaultConnection")))
            //{
                var dgData = (from rtu in _db.TblRtus
                              join dg in _db.TblDgSetups
                                   on rtu.ColDgSetupIdFk equals dg.ColDgSetupId.ToString() into g
                              from d in g.DefaultIfEmpty()
                              where rtu.ColRtuId == rtuId
                              select new { DgSetupId = d.ColDgSetupId, DgId = d.ColDgId }).FirstOrDefault();

                dgId = dgData.DgId;

                if (targetLift == "all")
                {
                    targetLmdList = _db.TblRtus.Where(e => e.ColDgSetupIdFk == dgData.DgSetupId.ToString()).Select(e => e.ColRtuId).Distinct().ToList();
                }
                else
                {
                    targetLmdList.Add(rtuId);
                }
            //}

            var topic_name = "sg/sj/24k/willowglen/cmd/" + dgId;
            //var mqttConnProcessor = new MQTTConnProcessor(new string[] { "sg/sj/24k/willowglen/cmd+" }, mqttConfiguration);
            var tz = _mqttConnProcessor.TimezoneProcessor(_configuration.GetSection("Timezone").Value);

            var deviceStatus = new DeviceStatus
            {
                timestamp = TimeZoneInfo.ConvertTime(DateTimeOffset.Now, tz).ToString("yyyy-MM-ddTHH:mm:sszzz"),
                target_list = targetLmdList,
                commands = commands
            };
            _status = JsonConvert.SerializeObject(deviceStatus, Formatting.Indented);
            try
            {
                var mqtt = _mqttConnProcessor.ProcessMqtt();

                if (mqtt != null)
                {
                    try
                    {
                        mqtt.Publish(topic_name, Encoding.UTF8.GetBytes(_status));
                        Console.WriteLine($"Message Sent, topic {topic_name}, payload {_status}");
                    }
                    catch (Exception ex)
                    {

                        Console.WriteLine($"Exception on Lift Status Command: {ex.ToString()}");
                    }

                }
            }
            catch (Exception ex)
            {

                throw;
            }
        }
    }
}

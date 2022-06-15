using CFEMSDB.DB;
using IBSimulatorWeb.Extensions;
using IBSimulatorWeb.Models;
using IBSimulatorWeb.Utility;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MQTTProcessor.Processor;
using Newtonsoft.Json;
using System.Text;

namespace IBSimulatorWeb.Pages
{
    public class UpdateDeviceIPModel : PageModel
    {
        private readonly ILogger<UpdateDeviceIPModel> _logger;
        private readonly IConfiguration _configuration;
        private readonly IBDBContext _db;
        private readonly IHttpClient _httpClient;
        private readonly IMQTTConnProcessor _mqttConnProcessor;
        public List<TblRtu> rtus;
        public string _updateDeviceIP;
        public UpdateDeviceIPModel(ILogger<UpdateDeviceIPModel> logger, IConfiguration configuration, IBDBContext db, IMQTTConnProcessor mQTTConnProcessor, IHttpClient httpClient)//,MQTTClient mQTTClient 
        {
            _logger = logger;
            _configuration = configuration;
            _db = db;
            _mqttConnProcessor = mQTTConnProcessor;
            _httpClient = httpClient;
        }

        public void GetRtus()
        {
            //using (var db = new IBDBContext(_configuration.GetConnectionString("DefaultConnection")))
            //{
            rtus = new List<TblRtu>();
            rtus = _db.TblRtus.ToList();
            //}
        }
        public void OnGet()
        {
            GetRtus();
        }

        public async void OnPostUpdateDeviceIP(string rtuId, string rtuNewIpAddress)
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
            List<string> targetRTUList = new List<string>();
            List<UpdateDeviceIPCommand> commands = new List<UpdateDeviceIPCommand>();
            UpdateDeviceIPCommand com = new UpdateDeviceIPCommand
            {
                command_name = "update_device_ip",
                command_type = 23,
                parameters = new UpdateDeviceIPParameters()
            };
            commands.Add(com);

            //using (var db = new IBDBContext(_configuration.GetConnectionString("DefaultConnection")))
            //{
            var dg = (from d in _db.TblDgSetups
                      join rtu in _db.TblRtus.Where(x => x.ColRtuId.Equals(rtuId))
                           on d.ColDgSetupId.ToString() equals rtu.ColDgSetupIdFk
                      select new
                      {
                          d.ColDgId,
                          rtu.ColRtuId,
                          rtu.ColRtuIpAddress,
                          d.ColDgSetupId
                      }).FirstOrDefault();

            targetRTUList.Add(dg.ColRtuId);
            dgId = dg.ColDgId;
            com.parameters = new UpdateDeviceIPParameters() { new_ip = rtuNewIpAddress ?? dg.ColRtuIpAddress };

            var selectedRtu = _db.TblRtus.FirstOrDefault(x => x.ColRtuId == dg.ColRtuId);
            if (selectedRtu is not null)
            {
                var modifiedDGs = new string[] { dg.ColDgSetupId.ToString() };
                string res = await CommonUtility.UpdateConfigurationFile(modifiedDGs, _httpClient, _db);
                selectedRtu.ColRtuIpAddress = rtuNewIpAddress ?? dg.ColRtuIpAddress;
                _db.Update(selectedRtu);
                _db.SaveChanges();
            }
            //}

            GetRtus();

            var topic_name = "sg/sj/24k/willowglen/cmd/" + dgId;
            //var mqttConnProcessor = new MQTTConnProcessor(new string[] { "sg/sj/24k/willowglen/cmd+" }, mqttConfiguration);
            var tz = _mqttConnProcessor.TimezoneProcessor(_configuration.GetSection("Timezone").Value);

            var updateDeviceIP = new UpdateDeviceIP
            {
                timestamp = TimeZoneInfo.ConvertTime(DateTimeOffset.Now, tz).ToString("yyyy-MM-ddTHH:mm:sszzz"),
                target_list = targetRTUList,
                commands = commands
            };
            _updateDeviceIP = JsonConvert.SerializeObject(updateDeviceIP, Formatting.Indented);
            try
            {
                var mqtt = _mqttConnProcessor.ProcessMqtt();
                if (mqtt != null)
                {
                    try
                    {
                        mqtt.Publish(topic_name, Encoding.UTF8.GetBytes(_updateDeviceIP));
                        Console.WriteLine($"Message Sent, topic {topic_name}, payload {_updateDeviceIP}");
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Exception on Lift Status Command: {ex}");
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

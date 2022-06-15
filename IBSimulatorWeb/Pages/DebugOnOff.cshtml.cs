using CFEMSDB.DB;
using IBCore.DataModels;
using IBSimulatorWeb.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MQTTProcessor;
using MQTTProcessor.Processor;
using Newtonsoft.Json;
using System.Text;
using uPLibrary.Networking.M2Mqtt.Messages;

namespace IBSimulatorWeb.Pages
{
    public class DebugOnOffModel : PageModel
    {
        private readonly ILogger<DebugOnOffModel> _logger;
        private readonly IConfiguration _configuration;
        private readonly IBDBContext _db;
        private readonly IMQTTConnProcessor _mqttConnProcessor;
        public string _debugOnOff;
        public DebugOnOffModel(ILogger<DebugOnOffModel> logger, IConfiguration configuration, IBDBContext db, IMQTTConnProcessor mQTTConnProcessor)//,MQTTClient mQTTClient 
        {
            _logger = logger;
            _configuration = configuration;
            _db = db;
            _mqttConnProcessor = mQTTConnProcessor;
        }

        public List<TblDgSetup> GetDG()
        {
            //using (var db = new IBDBContext(_configuration.GetConnectionString("DefaultConnection")))
            //{
                var dgs = new List<TblDgSetup>();
                return dgs = _db.TblDgSetups.ToList();
            //}
        }
        public void OnPostDebugOnOff(string dgId, string dgSetupId)
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

            //string dgId = "";
            List<string> targetDGList = new List<string>();
            List<DebugOnOffCommand> commands = new List<DebugOnOffCommand>();
            DebugOnOffCommand com = new DebugOnOffCommand
            {
                command_name = "debug_on_off",
                command_type = 24,
                parameters = new DebugOnOffParameters()
            };
            commands.Add(com);

            //using (var db = new IBDBContext(_configuration.GetConnectionString("DefaultConnection")))
            //{
                string onOrOff = "off";
                var dg = _db.TblDgSetups.FirstOrDefault(x => x.ColDgSetupId.ToString() == dgSetupId);
                if(dg != null)
                {
                    dg.ColIsDebug = !dg.ColIsDebug;
                    _db.Update(dg);
                    _db.SaveChanges();
                    onOrOff = dg.ColIsDebug == true? "on" : "off";
                }
                targetDGList.Add(dgId);
                com.parameters.flag = onOrOff;
            //}

            var topic_name = "sg/sj/24k/willowglen/cmd/" + dgId;
            //var mqttConnProcessor = new MQTTConnProcessor(new string[] { "sg/sj/24k/willowglen/cmd+" }, mqttConfiguration);
            var tz = _mqttConnProcessor.TimezoneProcessor(_configuration.GetSection("Timezone").Value);

            var debugOnOff = new DebugOnOff
            {
                timestamp = TimeZoneInfo.ConvertTime(DateTimeOffset.Now, tz).ToString("yyyy-MM-ddTHH:mm:sszzz"),
                target_list = targetDGList,
                commands = commands
            };
            _debugOnOff = JsonConvert.SerializeObject(debugOnOff, Formatting.Indented);
            try
            {
                var mqtt = _mqttConnProcessor.ProcessMqtt();
                if (mqtt != null)
                {
                    try
                    {
                        mqtt.Publish(topic_name, Encoding.UTF8.GetBytes(_debugOnOff));
                        Console.WriteLine($"Message Sent, topic {topic_name}, payload {_debugOnOff}");
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

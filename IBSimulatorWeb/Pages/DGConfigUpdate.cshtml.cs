using CFEMSDB.DB;
using IBCore.DataModels;
using IBSimulatorWeb.Extensions;
using IBSimulatorWeb.Models;
using IBSimulatorWeb.Utility;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MQTTProcessor.Processor;
using Newtonsoft.Json;
using System.Text;

namespace IBSimulatorWeb.Pages
{
    public class DGConfigUpdateModel : PageModel
    {
        private readonly ILogger<DGConfigUpdateModel> _logger;
        private readonly IConfiguration _configuration;
        private readonly IBDBContext _db;
        private readonly IMQTTConnProcessor _mqttConnProcessor;
        public string _updateDGConfigRemove;
        public string _updateDGConfigAdd;
        private readonly IHttpClient _httpClient;
        public DGConfigUpdateModel(ILogger<DGConfigUpdateModel> logger, IConfiguration configuration, IBDBContext db, IMQTTConnProcessor mQTTConnProcessor, IHttpClient httpClient)//,MQTTClient mQTTClient 
        {
            _logger = logger;
            _configuration = configuration;
            _db = db;
            _mqttConnProcessor = mQTTConnProcessor;
            _httpClient = httpClient;
        }

        public List<TblDgSetup> GetDG()
        {
            //using (var db = new IBDBContext(_configuration.GetConnectionString("DefaultConnection")))
            //{
            var dgs = new List<TblDgSetup>();
            return dgs = _db.TblDgSetups.ToList();
            //}
        }
        public List<TblRtu> GetRtu()
        {
            //using (var db = new IBDBContext(_configuration.GetConnectionString("DefaultConnection")))
            //{
            var rtus = new List<TblRtu>();
            return rtus = _db.TblRtus.ToList();
            //}
        }

        public async void OnPostUpdateDGConfig(string rtuId, string dgSetupId)
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
            //Remove
            List<string> targetDGListRemove = new List<string>();
            List<DGConfigCommand> commandsRemove = new List<DGConfigCommand>();
            DGConfigCommand comRemove = new DGConfigCommand
            {
                command_name = "update_dg_config",
                command_type = 22,
                parameters = new DGConfigParameters()
            };
            commandsRemove.Add(comRemove);
            var topic_nameRemove = "sg/sj/24k/willowglen/cmd/";
            //Add
            List<string> targetDGListAdd = new List<string>();
            List<DGConfigCommand> commandsAdd = new List<DGConfigCommand>();
            DGConfigCommand comAdd = new DGConfigCommand
            {
                command_name = "update_dg_config",
                command_type = 22,
                parameters = new DGConfigParameters()
            };
            commandsAdd.Add(comAdd);
            var topic_nameAdd = "sg/sj/24k/willowglen/cmd/";

            //using (var db = new IBDBContext(_configuration.GetConnectionString("DefaultConnection")))
            //{
            //Remove
            var currentDg = (from rtu in _db.TblRtus.Where(x => x.ColRtuId == rtuId)
                             join dg in _db.TblDgSetups
                                on rtu.ColDgSetupIdFk equals dg.ColDgSetupId.ToString()
                             select
                             new
                             {
                                 dg.ColDgId,
                                 dg.ColDgSetupId,
                                 rtu.ColRtuId
                             }).FirstOrDefault();
            var removeRtuList = _db.TblRtus.FirstOrDefault(e => e.ColRtuId == rtuId);
            targetDGListRemove.Add(currentDg.ColDgId);

            comRemove.parameters.remove_list = new string[] { removeRtuList.ColRtuId };
            comRemove.parameters.add_list = new List<DgConfigAddList>();
            topic_nameRemove = topic_nameRemove + currentDg.ColDgId;

            if (removeRtuList != null)
            {
                var modifiedDGs = new string[] { removeRtuList.ColDgSetupIdFk, dgSetupId };
                string res = await CommonUtility.UpdateConfigurationFile(modifiedDGs,_httpClient,_db);
                if (res == "ok")
                {
                    removeRtuList.ColDgSetupIdFk = dgSetupId;
                    _db.Update(removeRtuList);
                    _db.SaveChanges();
                }
                else
                {
                    Console.WriteLine("Error Occured on Update Configuration File");
                    return;
                }

            }

            //Add
            var newDg = (from rtu in _db.TblRtus
                         join dg in _db.TblDgSetups.Where(x => x.ColDgSetupId.ToString() == dgSetupId)
                            on rtu.ColDgSetupIdFk equals dg.ColDgSetupId.ToString()
                         select
                         new
                         {
                             dg.ColDgId,
                             dg.ColDgSetupId,
                             rtu.ColRtuId
                         }).FirstOrDefault();

            var dgConfigAddList = (from dg in _db.TblDgSetups.Where(x => x.ColDgSetupId.ToString() == dgSetupId)
                                   join rtu in _db.TblRtus
                                        on dg.ColDgSetupId.ToString() equals rtu.ColDgSetupIdFk
                                   join eq in _db.TblEquipments
                                         on rtu.ColRtuId equals eq.ColRtuIdFk
                                   join eqgroup in _db.TblEquipmentGroups
                                        on eq.ColEquipmentGroupIdFk equals eqgroup.ColEquipmentGroupId.ToString()
                                   group new { eq, eqgroup, rtu.ColRtuId, rtu.ColRtuIpAddress }
                                   by rtu.ColRtuId into g
                                   select new DgConfigAddList
                                   {
                                       lmd = new DgConfigLMD
                                       {
                                           lmd_id = g.FirstOrDefault().ColRtuId,
                                           ipaddress = g.FirstOrDefault().ColRtuIpAddress
                                       },
                                       devices = g.Select(s =>
                                          new DgConfigDevices()
                                          {
                                              type = s.eqgroup.ColEquipmentGroupTitle,
                                              baudrate = s.eq.ColBaudrate,
                                              rbelo = s.eq.ColLastRbelo,
                                              rbehi = s.eq.ColLastRbehi,
                                              lmd_no = s.eq.ColRtuNumber
                                          }).ToList()
                                   }).ToList();

            targetDGListAdd.Add(newDg.ColDgId);

            comAdd.parameters.remove_list = Array.Empty<object>();
            comAdd.parameters.add_list = dgConfigAddList;
            topic_nameAdd = topic_nameAdd + newDg.ColDgId;

            //}


            //var mqttConnProcessor = new MQTTConnProcessor(new string[] { "sg/sj/24k/willowglen/cmd+" }, mqttConfiguration);
            var tz = _mqttConnProcessor.TimezoneProcessor(_configuration.GetSection("Timezone").Value);

            var updateDGConfigRemove = new UpdateDGConfig
            {
                timestamp = TimeZoneInfo.ConvertTime(DateTimeOffset.Now, tz).ToString("yyyy-MM-ddTHH:mm:sszzz"),
                target_list = targetDGListRemove,
                commands = commandsRemove
            };

            var updateDGConfigAdd = new UpdateDGConfig
            {
                timestamp = TimeZoneInfo.ConvertTime(DateTimeOffset.Now, tz).ToString("yyyy-MM-ddTHH:mm:sszzz"),
                target_list = targetDGListAdd,
                commands = commandsAdd
            };
            _updateDGConfigRemove = JsonConvert.SerializeObject(updateDGConfigRemove, Formatting.Indented);
            _updateDGConfigAdd = JsonConvert.SerializeObject(updateDGConfigAdd, Formatting.Indented);
            try
            {
                var mqtt = _mqttConnProcessor.ProcessMqtt();
                if (mqtt != null)
                {
                    try
                    {
                        mqtt.Publish(topic_nameRemove, Encoding.UTF8.GetBytes(_updateDGConfigRemove));
                        Console.WriteLine($"Message Sent, topic {topic_nameRemove}, payload {_updateDGConfigRemove}");
                        mqtt.Publish(topic_nameAdd, Encoding.UTF8.GetBytes(_updateDGConfigAdd));
                        Console.WriteLine($"Message Sent, topic {topic_nameAdd}, payload {_updateDGConfigAdd}");
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

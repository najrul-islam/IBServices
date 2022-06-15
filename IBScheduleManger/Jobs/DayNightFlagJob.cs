using CFEMSDB.DB;
using IBScheduleManger.Models;
using IBScheduleManger.Services;
using MQTTProcessor;
using Newtonsoft.Json;
using Quartz;
using System.Text;

namespace IBScheduleManger.Jobs
{
    internal class DayNightFlagJob : IJob, IMQTTPublisher
    {
        private readonly ILogger<DayNightFlagJob> _logger;
        //private readonly IConfiguration _config;
        private readonly MQTTInitiatorSourceContent _initiator;
        private readonly IBDBContext _db;
        private TimeZoneInfo _tz;
        public DayNightFlagJob(ILogger<DayNightFlagJob> logger, /*IConfiguration config,*/ MQTTInitiatorSourceContent initiator, IBDBContext db)
        {
            _logger = logger;
            //_config = config;
            _initiator = initiator;
            _db = db;
        }
        public Task Execute(IJobExecutionContext context)
        {
            var init = _initiator.InitiateMQTTConnection();
            _tz = init._tz;
            string res = SendCommandToMQTT(init._mqtt);

            if (res == "Success")
            {
                _logger.LogInformation($"Log Job: at {TimeZoneInfo.ConvertTime(DateTimeOffset.Now, _tz).ToString("yyyy-MM-ddTHH:mm:sszzz")} and Jobtype: {context.JobDetail.JobType}");
            }

            return Task.CompletedTask;
        }

        public string SendCommandToMQTT(MQTTClient mqtt)
        {
            try
            {
                if (mqtt != null)
                {

                    //using (var db = new IBDBContext(_config["ConnectionStrings:DefaultConnection"]))
                    //{
                        var dgRtuData = (from rtu in _db.TblRtus
                                         join dg in _db.TblDgSetups on rtu.ColDgSetupIdFk equals dg.ColDgSetupId.ToString() into g
                                         from d in g.DefaultIfEmpty()
                                         where rtu.ColIsActive == true && d.ColIsActive == true
                                         select new { RTUId = rtu.ColRtuId, DgId = d.ColDgId, DayNightFlag = rtu.ColDayNightFlag }).Distinct().ToList();

                        List<Command> commands = new List<Command>();
                        var ibHbtCommand = new Command
                        {
                            command_type = 4,
                            command_name = "set_day_night_flag",
                            parameters = new Parameters
                            {
                                flag = 0
                            }
                        };

                        commands.Add(ibHbtCommand);

                        var commandModel = new CommandsModel
                        {
                            timestamp = TimeZoneInfo.ConvertTime(DateTimeOffset.Now, _tz).ToString("yyyy-MM-ddTHH:mm:sszzz"),
                            target_list = new string[] { },
                            commands = commands,
                        };

                        var dgs = dgRtuData.Select(x => x.DgId).Distinct().ToArray();

                        for (int i = 0; i < dgs.Length; i++)
                        {
                            var dayTargetList = dgRtuData.Where(x => x.DgId == dgs[i] && x.DayNightFlag == true).Select(x => x.RTUId).ToArray();
                            var nightTargetList = dgRtuData.Where(x => x.DgId == dgs[i] && x.DayNightFlag == false).Select(x => x.RTUId).ToArray();

                            string topic_name = "sg/sj/24k/willowglen/cmd/" + dgs[i];

                            if (dayTargetList.Length > 0) PublishDayNightFlag(mqtt, commandModel, dayTargetList, topic_name);

                            if (nightTargetList.Length > 0) PublishDayNightFlag(mqtt, commandModel, nightTargetList, topic_name);
                        }
                    //}
                }

                return "Success";
            }
            catch (Exception ex)
            {
                _logger.LogInformation($"Error occured: at {TimeZoneInfo.ConvertTime(DateTimeOffset.Now, _tz).ToString("yyyy-MM-ddTHH:mm:sszzz")} on Jobtype: DayNightFlag and Exception: " + ex.Message);
                return null;
            }

        }

        private void PublishDayNightFlag(MQTTClient mqtt, CommandsModel commandModel, string[] dayTargetList, string topic_name)
        {
            commandModel.target_list = dayTargetList;
            var commandPayload = JsonConvert.SerializeObject(commandModel, Formatting.Indented);
            mqtt.Publish(topic_name, Encoding.UTF8.GetBytes(commandPayload));
            Console.WriteLine($"Message Sent, topic {topic_name}, payload {commandPayload}");
        }
    }
}

using CFEMSDB.DB;
using IBScheduleManger.Models;
using IBScheduleManger.Services;
using MQTTProcessor;
using Newtonsoft.Json;
using Quartz;
using System.Text;

namespace IBScheduleManger.Jobs
{
    internal class IBHeartbeatJob : IJob, IMQTTPublisher
    {
        private readonly ILogger<IBHeartbeatJob> _logger;
        //private readonly IConfiguration _config;
        private readonly MQTTInitiatorSourceContent _initiator;
        private readonly IBDBContext _db;
        private TimeZoneInfo _tz;
        public IBHeartbeatJob(ILogger<IBHeartbeatJob> logger, /*IConfiguration config,*/ MQTTInitiatorSourceContent initiator, IBDBContext db)
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
                List<Command> commands = new List<Command>();
                var ibHbtCommand = new Command
                {
                    command_type = 0,
                    command_name = "ib_heartbeat",
                    parameters = new object()

                };
                commands.Add(ibHbtCommand);

                var commandModel = new CommandsModel
                {
                    timestamp = TimeZoneInfo.ConvertTime(DateTimeOffset.Now, _tz).ToString("yyyy-MM-ddTHH:mm:sszzz"),
                    asset_class = "default",
                    target_list = new string[] { },
                    commands = commands,
                };

                var commandPayload = JsonConvert.SerializeObject(commandModel, Formatting.Indented);

                if (mqtt != null)
                {
                    var dgs = new string[] { };
                    //using (var db = new IBDBContext(_config["ConnectionStrings:DefaultConnection"]))
                    //{
                        dgs = _db.TblDgSetups.Where(x => x.ColIsActive == true).Select(x => x.ColDgId).Distinct().ToArray();
                    //}

                    for (int i = 0; i < dgs.Length; i++)
                    {
                        string topic_name = "sg/sj/24k/willowglen/cmd/" + dgs[i];
                        mqtt.Publish(topic_name, Encoding.UTF8.GetBytes(commandPayload));
                        Console.WriteLine($"Message Sent, topic {topic_name}, payload {commandPayload}");
                    }
                }

                return "Success";
            }
            catch (Exception ex)
            {
                _logger.LogInformation($"Error occured: at {TimeZoneInfo.ConvertTime(DateTimeOffset.Now, _tz).ToString("yyyy-MM-ddTHH:mm:sszzz")} on Jobtype: IBHeartbeat and Exception: " + ex.Message);
                return null;
            }

        }
    }
}

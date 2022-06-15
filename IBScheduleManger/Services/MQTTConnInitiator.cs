using CFEMSDB.DB;
using IBCore.DataModels;
using IBScheduleManger.Models;
using MQTTProcessor;
using MQTTProcessor.Processor;
using Newtonsoft.Json;
using System.Text;

namespace IBScheduleManger.Services
{
    public abstract class MQTTInitiatorSourceContent
    {
        public abstract MQTTInitiatorService InitiateMQTTConnection();
    }

    public interface IMQTTPublisher
    {
        string SendCommandToMQTT(MQTTClient mqtt);
    }

    public class MQTTInitiatorService : MQTTInitiatorSourceContent
    {
        private readonly IConfiguration _config;
        private readonly ILogger<MQTTInitiatorService> _logger;
        private readonly IMQTTConnProcessor _mqttConnProcessor;
        public MQTTClient _mqtt;
        public TimeZoneInfo _tz;

        public MQTTInitiatorService(IConfiguration config, ILogger<MQTTInitiatorService> logger ,IMQTTConnProcessor mQTTConnProcessor)
        {
            _config = config;
            _logger = logger;
            _mqttConnProcessor = mQTTConnProcessor;
        }
        public override MQTTInitiatorService InitiateMQTTConnection()
        {
            _tz = _mqttConnProcessor.TimezoneProcessor(_config.GetSection("Timezone").Value);
            _mqtt = _mqttConnProcessor.ProcessMqtt();

            return this;
        }
    }
}

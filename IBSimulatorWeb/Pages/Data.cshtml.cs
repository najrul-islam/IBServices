using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MQTTProcessor;
using Newtonsoft.Json;
using System.Text;
using uPLibrary.Networking.M2Mqtt.Messages;

namespace IBSimulatorWeb.Pages
{
    public class DataModel : PageModel
    {
        private readonly ILogger<DataModel> _logger;
        private readonly IConfiguration _configuration;
        //private readonly MQTTClient _mQTTClient;
        MQTTClient mqttConnection;
        public DataModel(ILogger<DataModel> logger,
            IConfiguration configuration
            //MQTTClient mQTTClient
            )
        {
            _logger = logger;
            _configuration = configuration;
            //_mQTTClient = mQTTClient;
        }

        public void OnGet()
        {

        }

        public void OnPost()
        {
            var topic_name = Request.Form["topic_name"].FirstOrDefault() ?? "sg/sj/24k/willowglen/data/DG001";
            var payload = Request.Form["payload"].FirstOrDefault();
            var data = Request.Form["data"].FirstOrDefault();
            string[] topics = new string[] { topic_name };
            // Configurations
            var brokerHost = _configuration.GetSection("MQTT:BrokerHostname").Value ?? "localhost";
            var clientId = _configuration.GetSection("MQTT:ClientId").Value ?? "mqttjs_4afc714c9b";
            var password = _configuration.GetSection("MQTT:Password").Value ?? "public";
            var username = _configuration.GetSection("MQTT:Username").Value ?? "admin";
            //var dbConnectionString = _configuration.GetConnectionString("DefaultConnection");
            var clearSession = false;
            string timezone = _configuration.GetSection("Timezone").Value;

            try
            {
                Console.WriteLine("Connecting to broker.....");
                mqttConnection = ConnectWithBroker(brokerHost, clientId, password, username, clearSession);

                if (mqttConnection != null && mqttConnection.IsConnected)
                {
                    Console.WriteLine($"Successfuly connected with broker {brokerHost}, Client: {clientId}");
                    Console.ForegroundColor = ConsoleColor.DarkGreen;
                    SendMessage(payload ?? @"{data: hello }", topic_name);
                    Console.WriteLine($"Successfuly send message {payload} to topic {topic_name}");
                    Console.ForegroundColor = ConsoleColor.White;
                }
                else
                {
                    Console.WriteLine($"Cannot connect with the broker {brokerHost}");
                }
                Console.WriteLine("==========================================================");

                /*if (_mQTTClient.IsConnected)
                {
                    SendMessage(payload ?? @"{data: hello }", topic_name);
                }*/
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error occoured " + ex.Message);
            }
        }

        MQTTClient ConnectWithBroker(string brokerHost, string clientId, string password, string username, bool clearSession)
        {
            var connection = new MQTTClient(brokerHost, clientId, password, username, clearSession);
            connection.Connect();
            return connection;
        }
        void MessageReceived(object sender, MqttMsgPublishEventArgs e)
        {
            try
            {
                string payload = Encoding.UTF8.GetString(e.Message);
                //SendMessage(payload, topics.FirstOrDefault());
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error occoured " + ex.Message);
            }
        }

        void SendMessage(string pkg, string topic)
        {
            try
            {
                //if (typeof(LM_CommandPackage) == pkg.GetType()) InjectCommandName(pkg as LM_CommandPackage);
                //Trace.TraceInformation("Broker connection is " + (client.IsConnected ? "on" : "off"));
                string message = JsonConvert.SerializeObject(pkg, Formatting.Indented);
                //Trace.TraceInformation("Message publishing ... ");
                //Trace.TraceInformation(string.Format("{0} in QoS{1}", topic, qosLevel));
                //Thread.Sleep(1); // sleep 0.001 second to prevent of .NET MQTT client deadlcok.  
                mqttConnection.Publish(topic, Encoding.UTF8.GetBytes(pkg));
                //_mQTTClient.Publish(topic, Encoding.UTF8.GetBytes(pkg));
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception on SendMessage: {ex.ToString()}");
            }
        }
    }
}

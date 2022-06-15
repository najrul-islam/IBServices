using IBCore.DataModels;
using System;
using System.Threading;
using static uPLibrary.Networking.M2Mqtt.MqttClient;

namespace MQTTProcessor.Processor
{
    public interface IMQTTConnProcessor
    {
        void ConnectionClosed(object sender, ConnectionClosedEventHandler e);
        MQTTClient ProcessMqtt();
        TimeZoneInfo TimezoneProcessor(string timezone);
    }

    public class MQTTConnProcessor : IMQTTConnProcessor
    {
        static MQTTClient mqttConnection;
        private MqttProcessInfo _mqttInfo;
        private string[] _topicsToSubscribe;
        public MQTTConnProcessor(string[] TopicsToSubscribe, MqttProcessInfo mqttInfo)
        {
            _mqttInfo = mqttInfo;
            _topicsToSubscribe = TopicsToSubscribe;
        }

        public TimeZoneInfo TimezoneProcessor(string timezone)
        {
            try
            {
                return TimeZoneInfo.FindSystemTimeZoneById(timezone);

            }
            catch (Exception ex)
            {

                Console.WriteLine($"Exception on Setting Timezone: {ex.ToString()}");
                return null;
            }
        }

        public MQTTClient ProcessMqtt()
        {
            try
            {
                Console.WriteLine("==========================================================");
                Console.WriteLine("Connecting to broker.....please wait for 10 second");
                //Thread.Sleep(10000);
                Thread.Sleep(2000);

                mqttConnection = ConnectWithBroker(_mqttInfo.BrokerHost, _mqttInfo.ClientId, _mqttInfo.Password, _mqttInfo.Username, _mqttInfo.ClearSession);

                if (mqttConnection != null && mqttConnection.IsConnected)
                {
                    mqttConnection.Subscribe(_topicsToSubscribe);
                    Console.WriteLine($"Successfuly connected with broker {_mqttInfo.ClientId}");
                }
                else
                {
                    Console.WriteLine($"Cannot connect with the broker {_mqttInfo.ClientId}");
                    return null;
                }

                Console.WriteLine("==========================================================");
                return mqttConnection;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
                return null;
            }

        }

        private MQTTClient ConnectWithBroker(string brokerHost, string clientId, string password, string username, bool clearSession)
        {
            var connection = new MQTTClient(brokerHost, clientId, password, username, clearSession);
            connection.Connect();
            return connection;
        }

        private void ReconnectWithBroker()
        {
            Console.WriteLine($"Connection closed from {_mqttInfo.ClientId}");
            Console.WriteLine($"Reconnecting with {_mqttInfo.ClientId}.....Please wait for 10 second");
            Thread.Sleep(10000);
            ConnectWithBroker(_mqttInfo.BrokerHost, _mqttInfo.ClientId, _mqttInfo.Password, _mqttInfo.Username, _mqttInfo.ClearSession);
        }

        public void ConnectionClosed(object sender, ConnectionClosedEventHandler e)
        {
            ReconnectWithBroker();
        }

    }
}

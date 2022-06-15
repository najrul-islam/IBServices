using System;
using uPLibrary.Networking.M2Mqtt;
using uPLibrary.Networking.M2Mqtt.Messages;
using static uPLibrary.Networking.M2Mqtt.MqttClient;

namespace MQTTProcessor
{
    public class MQTTClient : IDisposable
    {
        private bool _disposed = false;
        private MqttClient _client;
        private byte subscribeQoSLevel = MqttMsgBase.QOS_LEVEL_EXACTLY_ONCE;
        private byte publishQoSLevel = MqttMsgBase.QOS_LEVEL_EXACTLY_ONCE;

        #region Constructors
        public MQTTClient() { }
        /// <summary>
        /// Create an instance of MqttProcessor class with configuration for the broker
        /// </summary>
        /// <param name="brokerUrl">Broker host URL</param>
        /// <param name="clientId">Id of the client who will connect with the broker</param>
        /// <param name="password">Password of the client who will connect with the broker</param>
        /// <param name="username">(Optional) username of the client who will connect with the broker, deafult is client Id</param>
        /// <param name="port">Port of the broker, default is 8883</param>
        public MQTTClient(string brokerUrl, string clientId, string password, string username = null, bool clearSession = true, int port = 8883)
        {
            this.BrokerUrl = brokerUrl;
            this.ClientId = clientId;
            this.Password = password;
            if (username == null)
            {
                this.Username = clientId;
            }
            else
            {
                this.Username = username;
            }
            this.Port = port;
            this.ClearSession = clearSession;
        }
        #endregion

        #region Properties
        /// <summary>
        /// Gets or sets broker host URL
        /// </summary>
        public string BrokerUrl { get; set; }

        /// <summary>
        /// Gets of sets the client Id
        /// </summary>
        public string ClientId { get; set; }

        /// <summary>
        /// Gets of sets the username
        /// </summary>
        public string Username { get; set; }

        /// <summary>
        /// Gets or sets the password
        /// </summary>
        public string Password { get; set; }

        /// <summary>
        /// Gets or sets the port of the broker
        /// </summary>
        public int Port { get; set; }

        /// <summary>
        /// Gets the true if client connected otherwise false
        /// </summary>
        public bool IsConnected
        {
            get
            {
                return _client.IsConnected;
            }
        }

        public bool ClearSession { get; set; }

        #endregion

        #region Methods
        /// <summary>
        /// Create an MqttClient and open connection with the broker
        /// </summary>
        /// <returns>
        /// MqttClient with open connection with the broker
        /// </returns>
        public MqttClient Connect()
        {
            //_client = new MqttClient(this.BrokerUrl, this.Port, true, null, null, MqttSslProtocols.TLSv1_2, (a, b, c, d) => { return true; });
            _client = new MqttClient(this.BrokerUrl, this.Port, true, null, null, MqttSslProtocols.None, (a, b, c, d) => { return true; });

            try
            {
                if (!_client.IsConnected)
                {
                    _client.Connect(this.ClientId, this.Username, this.Password, this.ClearSession, 60);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return _client;
        }

        /// <summary>
        /// Subscribe to a topic
        /// </summary>
        /// <param name="topic">Topic to subscribe</param>
        public void Subscribe(string topic)
        {
            Subscribe(new string[] { topic });
        }

        /// <summary>
        /// Subscribe to a collection of topics
        /// </summary>
        /// <param name="topics">Collection of topics to subscribe</param>
        public void Subscribe(string[] topics)
        {
            byte[] qosLevels = new byte[topics.Length];

            for (int i = 0; i < qosLevels.Length; i++)
            {
                qosLevels[i] = subscribeQoSLevel;
            }

            Subscribe(topics, qosLevels);
        }

        /// <summary>
        /// Subscribe to a collection of topics
        /// </summary>
        /// <param name="topics">Collection of topics to subscribe</param>
        /// <param name="qosLevels">QoS level of the subcribed topics collection</param>
        public void Subscribe(string[] topics, byte[] qosLevels)
        {
            try
            {
                if (_client.IsConnected)
                {
                    _client.Subscribe(topics, qosLevels);
                    _client.MqttMsgPublishReceived += client_MqttMsgPublishReceived;
                }
                else
                {
                    throw new Exception("No open connection. Connect with broker before subscribe");
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        /// <summary>
        /// Unsubscribe from a topic
        /// </summary>
        /// <param name="topic">Topic to unsubscribe</param>
        public void Unsubscribe(string topic)
        {
            Unsubscribe(new string[] { topic });
        }

        /// <summary>
        /// Unsubscribe from a collection of topics
        /// </summary>
        /// <param name="topics">Collection of topics to unsubscribe</param>
        public void Unsubscribe(string[] topics)
        {
            try
            {
                if (_client.IsConnected)
                {
                    _client.Unsubscribe(topics);
                    _client.MqttMsgPublishReceived += null;
                }
                else
                {
                    throw new Exception("No open connection. Connect with broker before unsubscribe");
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Publish message to a topic
        /// </summary>
        /// <param name="topic">Topic to which the message will publish</param>
        /// <param name="message">The message to publish</param>
        public void Publish(string topic, byte[] message)
        {
            try
            {
                if (_client.IsConnected)
                {
                    _client.Publish(topic, message, publishQoSLevel, false);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void client_MqttMsgPublishReceived(object sender, MqttMsgPublishEventArgs e)
        {
            // Raise message received event handler
            MessageReceived?.Invoke(this, e);
        }

        private void Client_ConnectionClosed(object sender, ConnectionClosedEventHandler e)
        {
            ConnectionClosed?.Invoke(this, e);
        }

        #endregion

        #region Events
        public event EventHandler<MqttMsgPublishEventArgs> MessageReceived;
        public event EventHandler<ConnectionClosedEventHandler> ConnectionClosed;
        #endregion

        #region Object dispose
        // Public implementation of Dispose pattern callable by consumers.
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        // Protected implementation of Dispose pattern.
        protected virtual void Dispose(bool disposing)
        {
            if (_disposed)
                return;

            if (disposing)
            {
                // Free any other managed objects here.
            }

            // Free any unmanaged objects here.
            if (_client.IsConnected)
            {
                _client.Disconnect();
                _client = null;
            }
            _disposed = true;
        }

        // Finalizer by destructor
        ~MQTTClient()
        {
            Dispose(false);
        }
        #endregion
    }
}

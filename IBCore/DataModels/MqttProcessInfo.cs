namespace IBCore.DataModels
{
    public class MqttProcessInfo
    {
        public string BrokerHost { get; set; }
        public string ClientId { get; set; }
        public string Password { get; set; }
        public string Username { get; set; }
        public bool ClearSession { get; set; }
        //public string DbConnectionString { get; set; }
    }
}

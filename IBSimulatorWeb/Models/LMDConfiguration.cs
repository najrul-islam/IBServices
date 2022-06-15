using Newtonsoft.Json;

namespace IBSimulatorWeb.Models
{
    public class Device
    {
        public string type { get; set; }
        public int? baudrate { get; set; }
        public string rbelo { get; set; }
        public string rbehi { get; set; }

        [JsonProperty("lmd-no")]
        public short? LmdNo { get; set; }
    }

    public class Lmd
    {
        [JsonProperty("lmd-id")]
        public string LmdId { get; set; }
        public string ipaddress { get; set; }
        public int? enabledisablestatus { get; set; }
    }

    public class LMDConfiguration
    {
        public Lmd lmd { get; set; }
        public List<Device> devices { get; set; }
    }
}

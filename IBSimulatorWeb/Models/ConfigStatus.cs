using Newtonsoft.Json;

namespace IBSimulatorWeb.Models
{
    #region UpdateDGConfig

    public class UpdateDGConfig
    {
        public string timestamp { get; set; }
        public object target_list { get; set; }
        public List<DGConfigCommand> commands { get; set; }
    }

    public class DGConfigCommand
    {
        public int command_type { get; set; }
        public string command_name { get; set; }
        public DGConfigParameters parameters { get; set; }
    }
    public class DGConfigParameters
    {
        public object remove_list { get; set; }
        public List<DgConfigAddList> add_list { get; set; }
    }
    public class DgConfigAddList
    {
        public DgConfigLMD lmd { get; set; }
        public List<DgConfigDevices> devices { get; set; }
    }
    public class DgConfigLMD
    {
        public string lmd_id { get; set; }
        public string ipaddress { get; set; }
    }
    public class DgConfigDevices
    {
        public string type { get; set; }
        public int? baudrate { get; set; }
        public string rbelo { get; set; }
        public string rbehi { get; set; }
        [JsonProperty("lmd-no")]
        public short? lmd_no { get; set; }
    }
    #endregion


    #region UpdateDeviceIP

    public class UpdateDeviceIP
    {
        public string timestamp { get; set; }
        public object target_list { get; set; }
        public List<UpdateDeviceIPCommand> commands { get; set; }
    }

    public class UpdateDeviceIPCommand
    {
        public int command_type { get; set; }
        public string command_name { get; set; }
        public UpdateDeviceIPParameters parameters { get; set; }
    }
    public class UpdateDeviceIPParameters
    {
        public string new_ip { get; set; }
    }
    #endregion


    #region DebugOnOff
    public class DebugOnOff
    {
        public string timestamp { get; set; }
        public object target_list { get; set; }
        public List<DebugOnOffCommand> commands { get; set; }
    }

    public class DebugOnOffCommand
    {
        public int command_type { get; set; }
        public string command_name { get; set; }
        public DebugOnOffParameters parameters { get; set; }
    }
    public class DebugOnOffParameters
    {
        public string flag { get; set; }
    }

    #endregion
}

namespace IBSimulatorWeb.Models
{
    public class Command
    {
        public int command_type { get; set; }
        public string command_name { get; set; }
        public Parameters parameters { get; set; }
    }

    public class Parameters
    {
    }

    public class DeviceStatus
    {
        public string timestamp { get; set; }
        public object target_list { get; set; }
        public List<Command> commands { get; set; }
    }
}

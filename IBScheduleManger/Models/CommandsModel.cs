using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IBScheduleManger.Models
{
    public class CommandBase
    {
        public string timestamp { get; set; }
        public string asset_class { get; set; }
        public string [] target_list { get; set; }
    }
    public class Command
    {
        public int command_type { get; set; }
        public string command_name { get; set; }
        public object parameters { get; set; }
    }

    public class Parameters {
        public int flag { get; set; }
    }

    public class CommandsModel: CommandBase
    {
        public List<Command> commands { get; set; }
    }
}

using Newtonsoft.Json.Linq;
using System.Collections.Generic;

namespace IBCore.Data
{
    public abstract class LM_Package
    {
        public string timestamp;
        //public string asset_class = "default";
    }

    public class LM_CommandPackage : LM_Package
    {
        public class Command
        {
            public int command_type;
            public string command_name;
            private Dictionary<string, object> _parameters;
            public Dictionary<string, object> parameters
            {
                get
                {
                    if (_parameters == null)
                        _parameters = new Dictionary<string, object>();
                    return _parameters;
                }
                set
                {
                    _parameters = value;
                }
            }
        }
        //private Dictionary<string, JArray> _target_list;
        private string[] _target_list;
        private List<Command> _commands;
        public string[] target_list
        {
            get
            {
                if (_target_list == null)
                    _target_list = new string[] { };
                return _target_list;
            }
            set
            {
                _target_list = value;
            }
        }
        public List<Command> commands
        {
            get
            {
                if (_commands == null)
                    _commands = new List<Command>();
                return _commands;
            }
            set
            {
                _commands = value;
            }
        }
    }
}

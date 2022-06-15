using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IBCore.Data
{
    public class BELLBOXHBTPackage
    {
        public DateTime timestamp { get; set; }
        public int data_type { get; set; }
        public List<BELLBOXData> data { get; set; }
    }

    public class BELLBOXData
    {
        public string device_id { get; set; }
        public DateTime heartbeat_datetime { get; set; }
        public List<int> flag { get; set; }
        public List<int> lifts { get; set; }
    }
}
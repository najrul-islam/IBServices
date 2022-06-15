using System;
using System.Collections.Generic;
using System.Text;

namespace IBCore.DataModels
{
    public class SmartHubDto
    {
        public int Type { get; set; }
        public string TimeStamp { get; set; }
        public string PostalCode { get; set; }
        public int LMDCode { get; set; }
        public string LiftCode { get; set; }
        public int RBE { get; set; }
        public int Flag { get; set; }
        public int LiftFaults { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Text;

namespace DGHealthManager.Models
{
    public class VMDetail
    {
        public string VMId { get; set; }
        public string DGId { get; set; }
        //public int MaintenanceCompanyId { get; set; }
        public string MaintenanceCompanyId { get; set; }
        public string VMHostAddress { get; set; }
        public string VMUsername { get; set; }
        public int VMStatus { get; set; }
    }
}

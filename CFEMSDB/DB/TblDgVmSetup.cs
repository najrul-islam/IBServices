using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblDgVmSetup
    {
        public Guid ColDgVmSetupId { get; set; }
        public string? ColDgVmId { get; set; }
        public string? ColDgMaintenanceCompanyIdFk { get; set; }
        public string? ColHostAddress { get; set; }
        public string? ColHostUsername { get; set; }
        public string? ColDescription { get; set; }
        public byte? ColVmStatus { get; set; }
        public bool? ColIsActive { get; set; }
        public bool? ColIsOnline { get; set; }
    }
}

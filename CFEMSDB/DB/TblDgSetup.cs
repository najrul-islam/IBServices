using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblDgSetup
    {
        public Guid ColDgSetupId { get; set; }
        public string? ColDgId { get; set; }
        public string? ColDgVmSetupIdFk { get; set; }
        public string? ColDgMaintenanceCompanyIdFk { get; set; }
        public string? ColConfiugrationFileHash { get; set; }
        public string? ColDescription { get; set; }
        public bool? ColIsOnline { get; set; }
        public bool? ColIsActive { get; set; }
        public bool? ColIsDebug { get; set; }
    }
}

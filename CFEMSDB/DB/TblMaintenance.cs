using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblMaintenance
    {
        public string ColMaintenanceId { get; set; } = null!;
        public string? ColBuildingId { get; set; }
        public string? ColEquipmentContractMapIdFk { get; set; }
        public string? ColDeviceTypeIdFk { get; set; }
        public string? ColDeviceIdentificationLetterIdFk { get; set; }
        public string? ColMaintenanceEntryBy { get; set; }
        public DateTime? ColMaintenanceEntryDate { get; set; }
    }
}

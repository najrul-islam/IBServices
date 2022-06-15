using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblAnalogValue
    {
        public string ColBuildingIdFk { get; set; } = null!;
        public string ColEquipmentIdFk { get; set; } = null!;
        public string ColDeviceIdFk { get; set; } = null!;
        public double? ColAnalogValue { get; set; }
        public string? ColAnalogUnit { get; set; }
    }
}

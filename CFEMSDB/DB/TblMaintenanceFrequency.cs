using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblMaintenanceFrequency
    {
        public string? ColDeviceCategoryIdFk { get; set; }
        public string? ColDeviceTypeIdFk { get; set; }
        public bool? ColIsFrequencyWeekly { get; set; }
        public bool? ColIsFrequencyMontly { get; set; }
        public bool? ColIsFrequencyQuarterly { get; set; }
        public bool? ColIsFrequencySemiAnually { get; set; }
        public bool? ColIsFrequencyAnually { get; set; }
        public bool? ColIsKeySwitchApplicable { get; set; }
    }
}

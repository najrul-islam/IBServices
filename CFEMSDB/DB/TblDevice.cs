using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblDevice
    {
        public string ColDeviceId { get; set; } = null!;
        public string? ColEquipmentIdFk { get; set; }
        public string? ColDeviceDesc { get; set; }
        public string? ColDeviceCategoryIdFk { get; set; }
        public string? ColDeviceTypeIdFk { get; set; }
        public string? ColDeviceSubTypeIdFk { get; set; }
        public string? ColDeviceIdentificationGroupIdFk { get; set; }
        public string? ColDeviceIdentificationLetterIdFk { get; set; }
        public bool? ColIsActive { get; set; }
    }
}

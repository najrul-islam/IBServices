using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblBitmap
    {
        public Guid ColBitmapId { get; set; }
        public string? ColEquipmentIdFk { get; set; }
        public string? ColDeviceIdFk { get; set; }
        public bool? ColIsMonitorByDevice { get; set; }
        public bool? ColIsAbove64 { get; set; }
        public short? ColBitStart { get; set; }
        public short? ColBitEnd { get; set; }
        public string? ColAlarmDescription { get; set; }
        public string? ColOperatingScheduleIdFk { get; set; }
        public string? ColBitType { get; set; }
        public bool? ColIsStatusInvert { get; set; }
        public bool? ColIsIfdBit { get; set; }
        public byte? ColOperationHr { get; set; }
        public bool? ColMask { get; set; }
        public string? ColAnalogUnit { get; set; }
        public bool? ColAvRpt { get; set; }
        public bool? IsItscAlarmActivated { get; set; }
    }
}

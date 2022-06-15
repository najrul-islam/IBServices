using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblRtu
    {
        public string ColRtuId { get; set; } = null!;
        public string? ColBuildingIdFk { get; set; }
        public string? ColConfigIdFk { get; set; }
        public string? ColDgSetupIdFk { get; set; }
        public string? ColRtuIpAddress { get; set; }
        public int? ColBaudrate { get; set; }
        public string? ColHardwareVersion { get; set; }
        public string? ColDvrType { get; set; }
        public string? ColDvrIpAddress { get; set; }
        public string? ColDvrTerm { get; set; }
        public string? ColIemsDvrIp { get; set; }
        public string? ColRemarks { get; set; }
        public DateTime? ColSetupDate { get; set; }
        public bool? ColEnabledisablestatus { get; set; }
        public bool? ColDayNightFlag { get; set; }
        public bool? ColIsOnline { get; set; }
        public bool? ColIsActive { get; set; }
    }
}

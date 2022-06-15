using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblEquipment
    {
        public string ColEquipmentId { get; set; } = null!;
        public string? ColEquipmentGroupIdFk { get; set; }
        public string? ColRtuIdFk { get; set; }
        public string? ColEquipmentTitle { get; set; }
        public short? ColRtuNumber { get; set; }
        public int? ColBaudrate { get; set; }
        public short? ColDeviceType { get; set; }
        public string? ColLetter { get; set; }
        public string? ColLastRbelo { get; set; }
        public string? ColLastRbehi { get; set; }
        public string? ColRemarks { get; set; }
        public bool? ColIsRs485 { get; set; }
        public bool? ColIsSmsActivated { get; set; }
        public DateTime? ColCommissionDate { get; set; }
        public bool? ColIsOnline { get; set; }
        public bool? ColIsActive { get; set; }
        public string? ColLatestRbelo { get; set; }
        public string? ColLatestRbehi { get; set; }
    }
}

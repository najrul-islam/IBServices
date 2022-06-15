using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblMaintenanceDetail
    {
        public string ColMaintenanceDetailsId { get; set; } = null!;
        public string? ColMaintenanceDetailsParentId { get; set; }
        public string? ColMaintenanceIdFk { get; set; }
        public string? ColMaintenanceType { get; set; }
        public string? ColFrequency { get; set; }
        public DateTime? ColStartDate { get; set; }
        public DateTime? ColEndDate { get; set; }
        public string? ColStatus { get; set; }
        public int? ColDuration { get; set; }
        public string? ColReason { get; set; }
        public DateTime? ColCompletionDate { get; set; }
        public string? ColRemarks { get; set; }
        public bool? ColIsLtaGranted { get; set; }
        public string? ColLtaGrantedBy { get; set; }
        public DateTime? ColLtaGrantedDate { get; set; }
        public string? ColUpdateBy { get; set; }
        public DateTime? ColUpdateDate { get; set; }
    }
}

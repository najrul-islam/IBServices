using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblAlarm
    {
        public string ColAlarmCaseId { get; set; } = null!;
        public string? ColBuildingIdFk { get; set; }
        public string? ColBuildingTitle { get; set; }
        public string? ColEquipmentIdFk { get; set; }
        public string? ColDeviceIdFk { get; set; }
        public string? ColDeviceDesc { get; set; }
        public string? ColContractorCompanyIdFk { get; set; }
        public string? ColContractIdFk { get; set; }
        public string? ColBitType { get; set; }
        public string? ColAlertType { get; set; }
        public byte? ColProcessFlag { get; set; }
        public DateTime? ColAlarmSetDate { get; set; }
        public string? ColAnalogUnit { get; set; }
        public double? ColAnalogValue { get; set; }
        public string? ColAlarmDesc { get; set; }
        public DateTime? ColAlarmClearDate { get; set; }
        public DateTime? ColArrivalDate { get; set; }
        public string? ColFaultCodeFk { get; set; }
        public string? ColReportDesc { get; set; }
        public DateTime? ColReportDate { get; set; }
        public string? ColReportBy { get; set; }
        public DateTime? ColAcknwledgeDate { get; set; }
        public string? ColAcknwledgeBy { get; set; }
        public DateTime? ColClosedDate { get; set; }
        public string? ColClosedBy { get; set; }
        public DateTime? ColLtaVerifyDate { get; set; }
        public string? ColLtaVerifyBy { get; set; }
        public string? ColLtaRemarks { get; set; }
        public bool? ColMask { get; set; }
        public bool? ColIsDiagnosisPoint { get; set; }
        public string? ColDiagnosisRuleIdFk { get; set; }
        public bool? ColIsOnTest { get; set; }
    }
}

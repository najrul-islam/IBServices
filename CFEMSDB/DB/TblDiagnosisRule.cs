using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblDiagnosisRule
    {
        public Guid ColDiagnosisRulesId { get; set; }
        public string? ColEquipmentIdFk { get; set; }
        public string? ColDiagnosisRulesTitle { get; set; }
        public string? ColDiagnosisAlarmDescription { get; set; }
        public string? ColDiagnosisBitType { get; set; }
        public bool? ColIsActive { get; set; }
    }
}

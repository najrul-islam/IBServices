using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblDiagnosisRulesDetail
    {
        public Guid ColDiagnosisRuleDetailsId { get; set; }
        public string? ColDiagnosisRulesIdFk { get; set; }
        public string? ColBitmapIdFk { get; set; }
        public short? ColDurationMinutes { get; set; }
        public string? ColConditionalOperator { get; set; }
    }
}

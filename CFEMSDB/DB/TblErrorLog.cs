using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblErrorLog
    {
        public Guid ColLogId { get; set; }
        public string? ColLogDescription { get; set; }
        public DateTime? ColEntryDate { get; set; }
        public int? ColErrorNumber { get; set; }
        public int? ColErrorSeverity { get; set; }
        public int? ColErrorState { get; set; }
        public string? ColErrorProcedure { get; set; }
        public int? ColErrorLine { get; set; }
    }
}

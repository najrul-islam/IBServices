using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblLog
    {
        public Guid ColLogId { get; set; }
        public string? ColLogDescription { get; set; }
        public DateTime? ColEntryDate { get; set; }
    }
}

using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblAlarmCaseIdGenerator
    {
        public byte? ColYear { get; set; }
        public byte? ColDayOfYear { get; set; }
        public byte? ColHour { get; set; }
        public byte? ColMinute { get; set; }
        public int? ColMaxCaseNo { get; set; }
    }
}

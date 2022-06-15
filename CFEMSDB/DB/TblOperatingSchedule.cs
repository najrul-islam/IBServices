using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblOperatingSchedule
    {
        public Guid? ColOperatingScheduleId { get; set; }
        public string? ColOperatingScheduleTitle { get; set; }
        public TimeSpan? ColOpertaingTimeStart { get; set; }
        public TimeSpan? ColOpertaingTimeEnd { get; set; }
    }
}

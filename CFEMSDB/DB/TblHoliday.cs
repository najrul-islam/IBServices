using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblHoliday
    {
        public int? ColHolidayYear { get; set; }
        public DateTime? ColHolidayStartDate { get; set; }
        public DateTime? ColHolidayEndDate { get; set; }
        public string? ColHolidayTitle { get; set; }
        public bool? ColIsActive { get; set; }
    }
}

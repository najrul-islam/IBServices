using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblFaultCode
    {
        public Guid ColFaultCodeId { get; set; }
        public string ColFaultCode { get; set; } = null!;
        public string ColFaultCodeTitle { get; set; } = null!;
        public string ColDeviceCategoryIdFk { get; set; } = null!;
    }
}

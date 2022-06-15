using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblDeviceSubType
    {
        public Guid ColDeviceSubTypeId { get; set; }
        public string? ColDeviceTypeIdFk { get; set; }
        public string? ColDeviceSubTypeTitle { get; set; }
    }
}

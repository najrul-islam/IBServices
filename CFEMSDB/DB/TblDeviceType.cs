using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblDeviceType
    {
        public Guid? ColDeviceTypeId { get; set; }
        public string? ColDeviceTypeTitle { get; set; }
        public string? ColDeviceCategoryIdFk { get; set; }
        public bool? ColIsActive { get; set; }
    }
}

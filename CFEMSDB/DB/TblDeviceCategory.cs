using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblDeviceCategory
    {
        public Guid? ColDeviceCategoryId { get; set; }
        public string? ColDeviceCategoryTitle { get; set; }
        public string? ColEquipmentGroupIdFk { get; set; }
        public bool? ColIsActive { get; set; }
    }
}

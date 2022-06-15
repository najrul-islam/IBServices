using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblEquipmentGroup
    {
        public Guid ColEquipmentGroupId { get; set; }
        public string? ColEquipmentGroupTitle { get; set; }
        public bool? ColIsActive { get; set; }
    }
}

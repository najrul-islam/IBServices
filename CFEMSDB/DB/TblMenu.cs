using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblMenu
    {
        public Guid ColMenuId { get; set; }
        public string? ColMenuName { get; set; }
        public string? ColUrl { get; set; }
        public string? ColIcon { get; set; }
        public string? ColParentId { get; set; }
        public bool? ColIsParent { get; set; }
        public bool? ColIsGroup { get; set; }
        public string? ColGroupId { get; set; }
        public bool? ColIsActive { get; set; }
        public DateTime? ColTimestamp { get; set; }
    }
}

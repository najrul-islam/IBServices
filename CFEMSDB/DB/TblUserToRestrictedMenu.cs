using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblUserToRestrictedMenu
    {
        public string? ColUserIdFk { get; set; }
        public string? ColMenuIdFk { get; set; }
        public bool? ColIsActive { get; set; }
        public DateTime? ColTimestamp { get; set; }
    }
}

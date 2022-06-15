using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblUserToMenu
    {
        public string? ColUserIdFk { get; set; }
        public string? ColMenuIdFk { get; set; }
        public bool? ColIsActive { get; set; }
        public DateTime? ColTimestamp { get; set; }
    }
}

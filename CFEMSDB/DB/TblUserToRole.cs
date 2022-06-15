using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblUserToRole
    {
        public string? ColRoleIdFk { get; set; }
        public string? ColUserIdFk { get; set; }
        public bool? ColIsActive { get; set; }
    }
}

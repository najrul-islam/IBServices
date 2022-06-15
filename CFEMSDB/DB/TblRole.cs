using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblRole
    {
        public Guid ColRoleId { get; set; }
        public string? ColRoleName { get; set; }
        public bool? ColIsSmsRoles { get; set; }
        public string? ColMenuIdFk { get; set; }
        public bool? ColIsActive { get; set; }
    }
}

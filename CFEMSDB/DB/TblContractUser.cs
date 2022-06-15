using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblContractUser
    {
        public string? ColContractorCompanyIdFk { get; set; }
        public string? ColContractIdFk { get; set; }
        public string? ColUserIdFk { get; set; }
        public string? ColSmsRoleIdFk { get; set; }
        public byte? ColSmsRoleSeqNo { get; set; }
    }
}

using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblContract
    {
        public Guid ColContractId { get; set; }
        public string ColContractNbr { get; set; } = null!;
        public string? ColContractorCompanyIdFk { get; set; }
        public DateTime? ColContractStart { get; set; }
        public DateTime? ColContractEnd { get; set; }
        public bool? ColIsContractValid { get; set; }
        public byte? ColResponseHr { get; set; }
        public byte? ColRepairHr { get; set; }
    }
}

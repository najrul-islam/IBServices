using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblContractorCompany
    {
        public Guid ColContractorCompanyId { get; set; }
        public string? ColCompanyName { get; set; }
        public string? ColContractorCompanyCode { get; set; }
        public string? ColCompanyAddress { get; set; }
        public bool? ColIsActive { get; set; }
    }
}

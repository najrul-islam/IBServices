using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblSite
    {
        public string ColSiteId { get; set; } = null!;
        public string? ColAddressCode { get; set; }
        public string? ColPostalCode { get; set; }
        public string? ColAddress { get; set; }
        public bool? ColIsActive { get; set; }
    }
}

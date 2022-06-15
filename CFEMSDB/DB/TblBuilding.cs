using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblBuilding
    {
        public string ColBuildingId { get; set; } = null!;
        public string? ColAddressCode { get; set; }
        public string? ColBuildingTitle { get; set; }
        public string? ColAddress { get; set; }
        public string? ColPostalCode { get; set; }
        public string? ColBuildingType { get; set; }
        public string? ColAssetNo { get; set; }
        public string? ColLtaId { get; set; }
        public DateTime? ColIssInstallDate { get; set; }
        public bool? ColIsActive { get; set; }
        public bool? ColIsOnTest { get; set; }
    }
}

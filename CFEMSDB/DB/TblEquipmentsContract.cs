using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblEquipmentsContract
    {
        public Guid? ColEquipmentContractMapId { get; set; }
        public string? ColEquipmentsIdFk { get; set; }
        public string? ColContractIdFk { get; set; }
        public string? ColDeviceCategoryIdFk { get; set; }
        public DateTime? ColEntryDate { get; set; }
    }
}

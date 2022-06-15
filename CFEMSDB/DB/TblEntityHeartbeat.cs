using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;

namespace CFEMSDB.DB
{
    public partial class TblEntityHeartbeat
    {
        public Guid ColEntityHeartbeatId { get; set; }
        public string? ColEntityIdFk { get; set; }
        public DateTime? ColLastHeartbeatDatetime { get; set; }
        public string? ColModules { get; set; }
        public string? ColJsonText { get; set; }
        public bool? ColIsDg { get; set; }
        public bool? ColIsRtu { get; set; }
        public bool? ColIsEquipment { get; set; }
    }
}

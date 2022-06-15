using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblConfig
    {
        public Guid ColConfigId { get; set; }
        public string? ColConfigType { get; set; }
        public bool? ColIsActive { get; set; }
    }
}

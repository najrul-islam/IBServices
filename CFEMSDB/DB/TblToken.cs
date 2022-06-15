using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblToken
    {
        public Guid ColTokenId { get; set; }
        public string? ColValue { get; set; }
        public DateTime? ColCreatedDate { get; set; }
        public string? ColUserId { get; set; }
        public DateTime? ColLastModifiedDate { get; set; }
        public DateTime? ColExpiryTime { get; set; }
    }
}

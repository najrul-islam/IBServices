using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblUser
    {
        public Guid ColUserId { get; set; }
        public string? ColUserName { get; set; }
        public string? ColFullName { get; set; }
        public string? ColEmail { get; set; }
        public string? ColSmsPhoneNbr { get; set; }
        public string? ColPassword { get; set; }
        public string? ColPasswordSalt { get; set; }
        public string? ColOtp { get; set; }
        public int? ColOtpExpiryTime { get; set; }
        public bool? ColIsActive { get; set; }
        public string? ColEntryBy { get; set; }
        public DateTime? ColEntryDate { get; set; }
        public string? ColUpdatedBy { get; set; }
        public DateTime? ColUpdatedDate { get; set; }
        public bool? ColIsDeleted { get; set; }
        public string? ColDeletedBy { get; set; }
    }
}

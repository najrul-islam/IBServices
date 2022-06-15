using System;
using System.Collections.Generic;

namespace CFEMSDB.DB
{
    public partial class TblDeviceIdentificationLetter
    {
        public Guid? ColDeviceIdentificationLetterId { get; set; }
        public string? ColDeviceIdentificationLetterTitle { get; set; }
        public string? ColDeviceIdentificationGroupIdFk { get; set; }
        public bool? ColIsActive { get; set; }
    }
}

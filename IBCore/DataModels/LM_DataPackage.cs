using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IBCore.Data
{
    public class PayloadBase
    {
        public DateTime timestamp { get; set; }
        public int data_type { get; set; }
    }

    public class HeartbeatData
    {
        public string dg_id { get; set; }
        public string lmd_id { get; set; }
        public string vm_id { get; set; }
        public DateTime heartbeat_datetime { get; set; }

        [JsonProperty("lmd-no")]
        public int lmd_no { get; set; }
        public int status { get; set; }
    }


    public class HeartBeat : PayloadBase
    {
        public List<HeartbeatData> data { get; set; }
    }

    public class LM_DataPackage
    {
        public DateTime timestamp;
        public int data_type;
        public string data_name;
        //public string raw_json;
    }


    #region LMD

    public class rbe_data
    {
        //public string device_id;
        public DateTime rbe_datetime;
        //public int lift_number;
        //public string rbe;
        public string alarm;
        public int ack;
        //new
        public string lmd_id;
        public string rbelo;
        public string rbehi;
        [JsonProperty("lmd-no")]
        public int lmd_no;
    }

    public class dg_heartbeat_data
    {
        public string device_id;
        public DateTime heartbeat_datetime;
    }

    public class device_heartbeat_data
    {
        //public string device_id;
        public string dg_id;
        public DateTime heartbeat_datetime;
    }

    public class report_to_ib_data
    {
        public string invitation_id;
        public string expect_device_id;
    }

    public class device_config_request_data
    {
        //public string device_id;
        public string lmd_id;
    }

    public class DG_config_request_data
    {
        public string dg_id { get; set; }
        public string vm_id { get; set; }
    }

    public class learning_mode_file_data
    {
        public string device_id;
        public string file_encoding;
    }

    public class LM_DataPackage_RBE : LM_DataPackage
    {
        public List<rbe_data> data;
    }

    public class LM_DataPackage_DG_Heartbeat : LM_DataPackage
    {
        public List<dg_heartbeat_data> data;
    }

    public class LM_DataPackage_Device_Heartbeat : LM_DataPackage
    {
        public List<device_heartbeat_data> data;
    }

    public class LM_DataPackage_Device_Config_Request : LM_DataPackage
    {
        public List<device_config_request_data> data;
    }

    public class LM_DataPackage_DG_Config_Request : LM_DataPackage
    {
        public List<DG_config_request_data> data;
    }

    public class LM_DataPackage_Report_To_IB : LM_DataPackage
    {
        public List<report_to_ib_data> data;
    }

    public class LM_DataPackage_Learning_Mode_File : LM_DataPackage
    {
        public List<learning_mode_file_data> data;
    }

    public class BELLBOXRbePackage
    {
        public DateTime timestamp;
        public int data_type;
        public List<rbe_data> data;
    }

    #endregion

    #region LMPD

    #region Heartbeat
    public class LMPD_Heartbeat_Package : LM_DataPackage
    {
        public List<LMPD_Heartbeat_Data> data { get; set; }
    }

    public class LMPD_Heartbeat_Data
    {
        public string device_id { get; set; }
        public int learn_mode { get; set; }
        public int ota_mode { get; set; }
        public DateTime? last_cmd_time { get; set; }
        public DateTime heartbeat_datetime { get; set; }
        public List<LMPD_Module> modules { get; set; }

    }

    public class LMPD_Module
    {
        public string moduleName { get; set; }
        public string message { get; set; }
        public string version { get; set; }
        public string timestamp { get; set; }

    }
    #endregion

    #region RBE

    public class LMPD_RBE_Package : LM_DataPackage
    {
        public List<LMPD_RBE_Data> data { get; set; }
    }

    public class LMPD_RBE_Data
    {
        public string device_id { get; set; }
        public string module_id { get; set; }
        public int rbe_type { get; set; }
        public DateTime rbe_datetime { get; set; }
        public int rbe_flag { get; set; }
        public string details { get; set; }

    }

    #endregion

    #region Trip Data

    public class LMPD_TripSummaryData_Package : LM_DataPackage
    {
        public List<LMPD_TripSummary_Data> data { get; set; }
    }

    public class LMPD_TripSummary_Data
    {
        public string device_id { get; set; }
        public string file_encoding { get; set; }
        public string ext { get; set; }

    }

    public class LMPD_TripBasedData_Package : LM_DataPackage
    {
        public List<LMPD_TripBased_Data> data { get; set; }
    }

    public class LMPD_TripBased_Data : LMPD_TripSummary_Data
    {
        public DateTime trip_time { get; set; }

    }

    public class LMPD_TripRawData_Package : LM_DataPackage
    {
        public List<LMPD_TripRaw_Data> data { get; set; }
    }

    public class LMPD_TripRaw_Data : LMPD_TripBased_Data
    {
        public string trip_id { get; set; }

    }

    #endregion

    #region OTA ACK

    public class LM_DataPackage_OTA_Ack : LM_DataPackage
    {
        public List<LM_Data_OTA_Ack> data { get; set; }
    }

    public class LM_Data_OTA_Ack
    {
        public string device_id { get; set; }
        public string file_hash { get; set; }
        public int status { get; set; }
        public int exit_code { get; set; }
        public string software_version { get; set; }
        public string message { get; set; }
    }

    #endregion

    #endregion
}
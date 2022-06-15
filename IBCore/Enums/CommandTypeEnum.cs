using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IBCore.Enums
{
    public enum CommandTypeEnum
    {
        ib_heartbeat = 0, // To send IB heartbeat to DG
        //enable_disable_device = 1, // 
        //issue_test = 2, // 
        //set_mask_value = 3, // 
        set_day_night_flag = 4, //To set Day or Night Flag
        request_lift_status = 5, //To request for lift status
        send_device_config = 8, //To send device configure to DG
        //test_status_ack = 9, // 
        send_dg_config = 21, //To send DG configuration
        update_dg_config = 22, //To Update configuration of DG
        update_device_ip = 23, //To Update IP address of LMD to DG
        debug_on_off = 24 //To enable or disable syslogging of all MQTT exchanges between IB and DG 
    }
}

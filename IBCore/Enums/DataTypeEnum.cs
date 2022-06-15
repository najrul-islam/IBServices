using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IBCore.Enums
{
    public enum DataTypeEnum
    {
        dg_heartbeat = 0, //To send DG heartbeat
        device_heartbeat = 1, // To send LMD heartbeat
        rbe = 2, //To send RBE 
        device_config_request = 3, // To request IB for LMD config, whereupon IB will respond with send_device_config
        dg_config_request = 10, // To request IB for DG config, whereupon IB will respond with send_dg_config
        vm_status = 11 //To report VM health status to IB
    }
}

using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Text;

namespace IBCore.DataModels
{

    public class TsLoadSetting
    {
        [JsonProperty("40042")]
        public int? L40042 { get; set; }
        [JsonProperty("40040")]
        public double? L40040 { get; set; }
        [JsonProperty("40036")]
        public int? L40036 { get; set; }
        [JsonProperty("40034")]
        public int? L40034 { get; set; }
        [JsonProperty("40038")]
        public int? L40038 { get; set; }
    }

    public class RideQuality
    {
        public double? rq_max_jerk { get; set; }
        public double? rq_max_acc { get; set; }
        public double? rq_max_dec { get; set; }
        public double? rq_acc_init_jerk { get; set; }
        public double? rq_acc_roll_jerk { get; set; }
        public double? rq_dec_init_jerk { get; set; }
        public double? rq_dec_out_jerk { get; set; }
        public double? rq_max_velocity { get; set; }
        public double? rq_A95_acc { get; set; }
        public double? rq_A95_dec { get; set; }
        public double? rq_A95_velocity { get; set; }
        public double? rq_max_p2p_hori_vib_x { get; set; }
        public double? rq_max_p2p_hori_vib_y { get; set; }
        public double? rq_A95_p2p_hori_vib_x { get; set; }
        public double? rq_A95_p2p_hori_vib_y { get; set; }
        public double? rq_fft_vibration_x { get; set; }
        public double? rq_fft_vibration_y { get; set; }
        public double? rq_fft_vibration_z { get; set; }
        public double? rq_displacement { get; set; }
        public string rq_trip_start_time { get; set; }
        public string rq_trip_end_time { get; set; }
        public string rq_trip_cons_start_time { get; set; }
        public string rq_trip_cons_end_time { get; set; }
        public string rq_boundary_one { get; set; }
        public string rq_boundary_two { get; set; }
        public double? rq_duration { get; set; }
        public int? rq_short { get; set; }
        public bool? rq_missing { get; set; }
        public string rq_direction { get; set; }
        public double? rq_acc_displacement { get; set; }
        public double? rq_cons_displacement { get; set; }
        public double? rq_dec_displacement { get; set; }
        public double? rq_fft_dom_freq_x { get; set; }
        public double? rq_fft_dom_freq_y { get; set; }
        public double? rq_fft_dom_freq_z { get; set; }



        public double? rq_max_p2p_hori_vib_z_con { get; set; }
        public double? rq_max_p2p_hori_vib_z_noncon { get; set; }
        public double? rq_A95_p2p_hori_vib_z_noncon { get; set; }
        public double? rq_A95_p2p_hori_vib_z_con { get; set; }
        //public int? rq_ad_abnormal_acc_init_flag { get; set; }
        public double? rq_ad_abnormal_acc_init_flag { get; set; }
        //public int? rq_ad_abnormal_dec_flag { get; set; }
        public double? rq_ad_abnormal_dec_flag { get; set; }

    }

    public class Load
    {
        public int? ls_load_sensor_01 { get; set; }
        public int? ls_load_sensor_02 { get; set; }
        public int? ls_load_sensor_03 { get; set; }
        public int? ls_load_sensor_04 { get; set; }
        public int? ls_load_sensor_05 { get; set; }
        public int? ls_load_sensor_06 { get; set; }
        public int? ls_load_sensor_07 { get; set; }
        public int? ls_load_sensor_08 { get; set; }
        public int? ls_load_sensor_09 { get; set; }
        public int? ls_load_sensor_10 { get; set; }
        public int? ls_load_sensor_11 { get; set; }
        public int? ls_load_sensor_12 { get; set; }
        public int? ls_net_load { get; set; }
        public int? ls_over_load { get; set; }
        public int? ls_full_load { get; set; }
        public int? ls_empty_load { get; set; }
        public int? ls_diff_load { get; set; }
        public int? ls_slack_rope { get; set; }
        public int? ls_empty_cabin_weight { get; set; }
        public double? ls_max_diff_load { get; set; }
        public double? ls_shaft_efficiency { get; set; }
        public double? ls_rated_load_pct { get; set; }

    }

    public class Door
    {
        public int ds_door_movement_ID { get; set; }
        public string ds_start_time { get; set; }
        public string ds_end_time { get; set; }
        public int? ds_landing_floor { get; set; }
        public string ds_before_or_after_trip { get; set; }
        public string ds_door_movement { get; set; }
        public double ds_duration { get; set; }
        public int ds_door_movement_complete { get; set; }
    }

    public class Anomaly
    {
        public double? ad_rq_max_acc { get; set; }
        public double? ad_rq_max_dec { get; set; }
    }

    public class Trip
    {
        public string ts_lmpd { get; set; }
        public DateTime? ts_start_time { get; set; }
        public DateTime? ts_end_time { get; set; }
        public string ts_start_position { get; set; }
        public string ts_end_position { get; set; }
        public string ts_accl_data_filepath { get; set; }
        public string ts_load_data_filepath { get; set; }
        public string ts_sound_data_filepath { get; set; }
        public string ts_range_data_filepath { get; set; }
        public string ts_mag_data_filepath { get; set; }
        public string ts_magaccl_data_filepath { get; set; }
        public string ts_repc_params_filepath { get; set; }
        public string ts_lift_config_filepath { get; set; }
        public TsLoadSetting ts_load_setting { get; set; }
        public int? ts_under_maintenance { get; set; }
        public RideQuality RideQuality { get; set; }
        public Load Load { get; set; }
        public List<Door> Door { get; set; }
        public Anomaly Anomalies { get; set; }

    }

}

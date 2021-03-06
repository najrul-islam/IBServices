USE [master]
GO
/****** Object:  Database [cfemsdb1]    Script Date: 18/05/2022 11:59:19 ******/
CREATE DATABASE [cfemsdb1]
GO
USE [cfemsdb1]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_binary_to_decimal]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_binary_to_decimal] (@binstr varchar(8))
RETURNS int
AS
begin
declare @Cnt tinyint, @len tinyint, @val int;

    set @Cnt = 1;
    set @len = len(ltrim(@binstr));
    set @val = convert(tinyint, substring(@binstr,@len,1));
    while @Cnt < @len
    	begin
    		set @val= @val + power(convert(tinyint, substring(@binstr,@len - @Cnt, 1)) * 2, @Cnt);
    		set @Cnt = @Cnt + 1;
    	end;
	RETURN @val;
end;
GO
/****** Object:  UserDefinedFunction [dbo].[fn_binary_to_float]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_binary_to_float] (@binstr varchar(16))
RETURNS float
AS
begin
	declare @Cnt tinyint, @len tinyint, @num int, @deci tinyint, @val float;
    set @Cnt = 1;
    set @len = len(ltrim(@binstr));
    set @deci = convert(tinyint, substring(@binstr,@len,1));
    while @Cnt < 4
    	begin
    		set @deci= @deci + power(convert(tinyint, substring(@binstr,@len - @Cnt, 1)) * 2, @Cnt);
    		set @Cnt = @Cnt + 1;
    	end;
	set @len = @len -4;
	set @Cnt = 1;
	set @num = convert(int, substring(@binstr, @len,1));
	while @Cnt < @len
		begin
			set @num = @num + power(convert(tinyint, substring(@binstr, @len-@Cnt, 1)) * 2, @Cnt);
			set @Cnt = @Cnt + 1;
		end;
	if @deci > 9
		set @deci = 9;
	set @val = @num + @deci * 0.1;
	RETURN @val;
end;

--=====================================
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dt_to_unix]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_dt_to_unix] (@datetime datetime2(3))
RETURNS bigint
AS
BEGIN
	DECLARE @unix_res bigint;
    SET @unix_res=(SELECT DATEDIFF_BIG(MILLISECOND,'1970-01-01 00:00:00.000', @datetime));
	RETURN @unix_res;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[fn_singapore_time]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_singapore_time] ()
RETURNS datetime
AS
BEGIN
	DECLARE @res datetime;
    SELECT @res=DATEADD(hour,8,GETUTCDATE());
	RETURN @res;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[fn_unix_to_dt]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_unix_to_dt] (@unix bigint)
RETURNS datetime2(3)
AS
BEGIN
	DECLARE @datetime_res datetime2(3);
	SET @datetime_res=(SELECT DATEADD(MILLISECOND, @unix % 1000, DATEADD(SECOND, @unix / 1000, '19700101')));
	RETURN @datetime_res;
END;
GO
/****** Object:  Table [dbo].[tbl_alarm_case_id_generator]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_alarm_case_id_generator](
	[col_year] [tinyint] NULL,
	[col_day_of_year] [tinyint] NULL,
	[col_hour] [tinyint] NULL,
	[col_minute] [tinyint] NULL,
	[col_max_case_no] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_alarms]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_alarms](
	[col_alarm_case_id] [varchar](50) NOT NULL,
	[col_building_id_fk] [varchar](36) NULL,
	[col_building_title] [varchar](250) NULL,
	[col_equipment_id_fk] [varchar](30) NULL,
	[col_device_id_fk] [varchar](30) NULL,
	[col_device_desc] [varchar](250) NULL,
	[col_contractor_company_id_fk] [varchar](36) NULL,
	[col_contract_id_fk] [varchar](36) NULL,
	[col_bit_type] [varchar](10) NULL,
	[col_alert_type] [varchar](30) NULL,
	[col_process_flag] [tinyint] NULL,
	[col_alarm_set_date] [datetime] NULL,
	[col_analog_unit] [varchar](5) NULL,
	[col_analog_value] [float] NULL,
	[col_alarm_desc] [varchar](500) NULL,
	[col_alarm_clear_date] [datetime] NULL,
	[col_arrival_date] [datetime] NULL,
	[col_fault_code_fk] [varchar](36) NULL,
	[col_report_desc] [varchar](250) NULL,
	[col_report_date] [datetime] NULL,
	[col_report_by] [varchar](36) NULL,
	[col_acknwledge_date] [datetime] NULL,
	[col_acknwledge_by] [varchar](36) NULL,
	[col_closed_date] [datetime] NULL,
	[col_closed_by] [varchar](36) NULL,
	[col_lta_verify_date] [datetime] NULL,
	[col_lta_verify_by] [varchar](36) NULL,
	[col_lta_remarks] [varchar](250) NULL,
	[col_mask] [bit] NULL,
	[col_is_diagnosis_point] [bit] NULL,
	[col_diagnosis_rule_id_fk] [varchar](36) NULL,
	[col_is_on_test] [bit] NULL,
 CONSTRAINT [PK_tbl_alarms] PRIMARY KEY CLUSTERED 
(
	[col_alarm_case_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_analog_values]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_analog_values](
	[col_building_id_fk] [varchar](36) NOT NULL,
	[col_equipment_id_fk] [varchar](36) NOT NULL,
	[col_device_id_fk] [varchar](36) NOT NULL,
	[col_analog_value] [float] NULL,
	[col_analog_unit] [varchar](5) NULL,
 CONSTRAINT [PK_tbl_analog_values] PRIMARY KEY CLUSTERED 
(
	[col_building_id_fk] ASC,
	[col_equipment_id_fk] ASC,
	[col_device_id_fk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_bit_description]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_bit_description](
	[col_icd_short_code] [varchar](30) NULL,
	[col_icd_short_code_defination] [varchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_bitmap]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_bitmap](
	[col_bitmap_id] [uniqueidentifier] NOT NULL,
	[col_equipment_id_fk] [varchar](30) NULL,
	[col_device_id_fk] [varchar](30) NULL,
	[col_is_monitor_by_device] [bit] NULL,
	[col_is_above64] [bit] NULL,
	[col_bit_start] [smallint] NULL,
	[col_bit_end] [smallint] NULL,
	[col_alarm_description] [varchar](500) NULL,
	[col_operating_schedule_id_fk] [varchar](36) NULL,
	[col_bit_type] [varchar](30) NULL,
	[col_is_status_invert] [bit] NULL,
	[col_is_ifd_bit] [bit] NULL,
	[col_operation_hr] [tinyint] NULL,
	[col_mask] [bit] NULL,
	[col_analog_unit] [varchar](5) NULL,
	[col_av_rpt] [bit] NULL,
	[is_itsc_alarm_activated] [bit] NULL,
 CONSTRAINT [PK_tbl_lta_bitmap] PRIMARY KEY CLUSTERED 
(
	[col_bitmap_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_buildings]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_buildings](
	[col_building_id] [varchar](30) NOT NULL,
	[col_address_code] [varchar](5) NULL,
	[col_building_title] [varchar](250) NULL,
	[col_address] [varchar](300) NULL,
	[col_postal_code] [varchar](30) NULL,
	[col_building_type] [varchar](30) NULL,
	[col_asset_no] [varchar](50) NULL,
	[col_lta_id] [varchar](30) NULL,
	[col_iss_install_date] [datetime] NULL,
	[col_is_active] [bit] NULL,
	[col_is_on_test] [bit] NULL,
 CONSTRAINT [PK_tbl_buildings] PRIMARY KEY CLUSTERED 
(
	[col_building_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_configs]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_configs](
	[col_config_id] [uniqueidentifier] NOT NULL,
	[col_config_type] [varchar](30) NULL,
	[col_is_active] [bit] NULL,
 CONSTRAINT [PK_tbl_configs] PRIMARY KEY CLUSTERED 
(
	[col_config_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_contract_users]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_contract_users](
	[col_contractor_company_id_fk] [varchar](36) NULL,
	[col_contract_id_fk] [varchar](36) NULL,
	[col_user_id_fk] [varchar](36) NULL,
	[col_sms_role_id_fk] [varchar](36) NULL,
	[col_sms_role_seq_no] [tinyint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_contractor_company]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_contractor_company](
	[col_contractor_company_id] [uniqueidentifier] NOT NULL,
	[col_company_name] [varchar](150) NULL,
	[col_contractor_company_code] [varchar](30) NULL,
	[col_company_address] [varchar](200) NULL,
	[col_is_active] [bit] NULL,
 CONSTRAINT [PK_tbl_lta_contractor_company] PRIMARY KEY CLUSTERED 
(
	[col_contractor_company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_contracts]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_contracts](
	[col_contract_id] [uniqueidentifier] NOT NULL,
	[col_contract_nbr] [varchar](30) NOT NULL,
	[col_contractor_company_id_fk] [varchar](36) NULL,
	[col_contract_start] [datetime] NULL,
	[col_contract_end] [datetime] NULL,
	[col_is_contract_valid] [bit] NULL,
	[col_response_hr] [tinyint] NULL,
	[col_repair_hr] [tinyint] NULL,
PRIMARY KEY CLUSTERED 
(
	[col_contract_nbr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_device_category]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_device_category](
	[col_device_category_id] [uniqueidentifier] NULL,
	[col_device_category_title] [varchar](150) NULL,
	[col_equipment_group_id_fk] [varchar](36) NULL,
	[col_is_active] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_device_identfication_group]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_device_identfication_group](
	[col_device_identification_group_id] [uniqueidentifier] NULL,
	[col_device_identfication_group_title] [varchar](30) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_device_identification_letter]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_device_identification_letter](
	[col_device_identification_letter_id] [uniqueidentifier] NULL,
	[col_device_identification_letter_title] [varchar](150) NULL,
	[col_device_identification_group_id_fk] [varchar](36) NULL,
	[col_is_active] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_device_sub_type]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_device_sub_type](
	[col_device_sub_type_id] [uniqueidentifier] NOT NULL,
	[col_device_type_id_fk] [varchar](36) NULL,
	[col_device_sub_type_title] [varchar](500) NULL,
 CONSTRAINT [PK_tbl_device_type_description] PRIMARY KEY CLUSTERED 
(
	[col_device_sub_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_device_type]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_device_type](
	[col_device_type_id] [uniqueidentifier] NULL,
	[col_device_type_title] [varchar](150) NULL,
	[col_device_category_id_fk] [varchar](36) NULL,
	[col_is_active] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_devices]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_devices](
	[col_device_id] [varchar](30) NOT NULL,
	[col_equipment_id_fk] [varchar](30) NULL,
	[col_device_desc] [varchar](250) NULL,
	[col_device_category_id_fk] [varchar](36) NULL,
	[col_device_type_id_fk] [varchar](36) NULL,
	[col_device_sub_type_id_fk] [varchar](36) NULL,
	[col_device_identification_group_id_fk] [varchar](36) NULL,
	[col_device_identification_letter_id_fk] [varchar](36) NULL,
	[col_is_active] [bit] NULL,
 CONSTRAINT [PK_tbl_devices] PRIMARY KEY CLUSTERED 
(
	[col_device_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_dg_maintenance_company]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_dg_maintenance_company](
	[col_dg_maintenance_company_id] [uniqueidentifier] NOT NULL,
	[col_dg_maintenance_company_name] [varchar](100) NULL,
 CONSTRAINT [PK_tbl_dg_maintenance_company] PRIMARY KEY CLUSTERED 
(
	[col_dg_maintenance_company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_dg_setup]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_dg_setup](
	[col_dg_setup_id] [uniqueidentifier] NOT NULL,
	[col_dg_id] [varchar](30) NULL,
	[col_dg_vm_setup_id_fk] [varchar](36) NULL,
	[col_dg_maintenance_company_id_fk] [varchar](36) NULL,
	[col_confiugration_file_hash] [varchar](max) NULL,
	[col_description] [varchar](250) NULL,
	[col_is_online] [bit] NULL,
	[col_is_active] [bit] NULL,
 CONSTRAINT [PK_tbl_dg_setup] PRIMARY KEY CLUSTERED 
(
	[col_dg_setup_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_dg_vm_setup]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_dg_vm_setup](
	[col_dg_vm_setup_id] [uniqueidentifier] NOT NULL,
	[col_dg_vm_id] [varchar](30) NULL,
	[col_host_address] [varchar](30) NULL,
	[col_host_username] [varchar](30) NULL,
	[col_description] [varchar](250) NULL,
	[col_vm_status] [tinyint] NULL,
	[col_is_active] [bit] NULL,
	[col_is_online] [bit] NULL,
 CONSTRAINT [PK_tbl_dg_vm_setup] PRIMARY KEY CLUSTERED 
(
	[col_dg_vm_setup_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_diagnosis_rules]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_diagnosis_rules](
	[col_diagnosis_rules_id] [uniqueidentifier] NOT NULL,
	[col_equipment_id_fk] [varchar](36) NULL,
	[col_diagnosis_rules_title] [varchar](150) NULL,
	[col_diagnosis_alarm_description] [varchar](250) NULL,
	[col_diagnosis_bit_type] [varchar](10) NULL,
	[col_is_active] [bit] NULL,
 CONSTRAINT [PK_tbl_diagnosis_rules] PRIMARY KEY CLUSTERED 
(
	[col_diagnosis_rules_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_diagnosis_rules_details]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_diagnosis_rules_details](
	[col_diagnosis_rule_details_id] [uniqueidentifier] NOT NULL,
	[col_diagnosis_rules_id_fk] [varchar](36) NULL,
	[col_bitmap_id_fk] [varchar](36) NULL,
	[col_duration_minutes] [smallint] NULL,
	[col_conditional_operator] [varchar](30) NULL,
 CONSTRAINT [PK_tbl_diagnosis_rules_details] PRIMARY KEY CLUSTERED 
(
	[col_diagnosis_rule_details_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_entity_heartbeat]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_entity_heartbeat](
	[col_entity_heartbeat_id] [uniqueidentifier] NOT NULL,
	[col_entity_id_fk] [varchar](36) NULL,
	[col_last_heartbeat_datetime] [datetime] NULL,
	[col_modules] [varchar](30) NULL,
	[col_json_text] [varchar](max) NULL,
	[col_is_dg] [bit] NULL,
	[col_is_rtu] [bit] NULL,
	[col_is_equipment] [bit] NULL,
 CONSTRAINT [PK_tbl_entity_heartbeat] PRIMARY KEY CLUSTERED 
(
	[col_entity_heartbeat_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_equipment_group]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_equipment_group](
	[col_equipment_group_id] [uniqueidentifier] NOT NULL,
	[col_equipment_group_title] [varchar](150) NULL,
	[col_is_active] [bit] NULL,
 CONSTRAINT [PK_tbl_device_group] PRIMARY KEY CLUSTERED 
(
	[col_equipment_group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_equipments]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_equipments](
	[col_equipment_id] [varchar](30) NOT NULL,
	[col_equipment_group_id_fk] [varchar](36) NULL,
	[col_rtu_id_fk] [varchar](30) NULL,
	[col_equipment_title] [varchar](50) NULL,
	[col_rtu_number] [smallint] NULL,
	[col_baudrate] [int] NULL,
	[col_device_type] [smallint] NULL,
	[col_letter] [varchar](4) NULL,
	[col_last_rbelo] [varchar](100) NULL,
	[col_last_rbehi] [varchar](100) NULL,
	[col_remarks] [varchar](500) NULL,
	[col_is_rs485] [bit] NULL,
	[col_is_sms_activated] [bit] NULL,
	[col_commission_date] [datetime] NULL,
	[col_is_online] [bit] NULL,
	[col_is_active] [bit] NULL,
 CONSTRAINT [PK_tbl_equipments] PRIMARY KEY CLUSTERED 
(
	[col_equipment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_equipments_contracts]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_equipments_contracts](
	[col_equipment_contract_map_id] [uniqueidentifier] NULL,
	[col_equipments_id_fk] [varchar](30) NULL,
	[col_contract_id_fk] [varchar](36) NULL,
	[col_device_category_id_fk] [varchar](36) NULL,
	[col_entry_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_error_logs]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_error_logs](
	[col_log_id] [uniqueidentifier] NOT NULL,
	[col_log_description] [varchar](500) NULL,
	[col_entry_date] [datetime] NULL,
	[col_error_number] [int] NULL,
	[col_error_severity] [int] NULL,
	[col_error_state] [int] NULL,
	[col_error_procedure] [varchar](100) NULL,
	[col_error_line] [int] NULL,
 CONSTRAINT [PK_tbl_logs] PRIMARY KEY CLUSTERED 
(
	[col_log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_fault_code]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_fault_code](
	[col_fault_code_id] [uniqueidentifier] NOT NULL,
	[col_fault_code] [varchar](30) NOT NULL,
	[col_fault_code_title] [varchar](150) NOT NULL,
	[col_device_category_id_fk] [varchar](36) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_holidays]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_holidays](
	[col_holiday_year] [int] NULL,
	[col_holiday_start_date] [datetime] NULL,
	[col_holiday_end_date] [datetime] NULL,
	[col_holiday_title] [varchar](500) NULL,
	[col_is_active] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_logs]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_logs](
	[col_log_id] [uniqueidentifier] NOT NULL,
	[col_log_description] [varchar](500) NULL,
	[col_entry_date] [datetime] NULL,
 CONSTRAINT [PK_tbl_logs_1] PRIMARY KEY CLUSTERED 
(
	[col_log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_maintenance]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_maintenance](
	[col_maintenance_id] [varchar](30) NOT NULL,
	[col_building_id] [varchar](30) NULL,
	[col_equipment_contract_map_id_fk] [varchar](36) NULL,
	[col_device_type_id_fk] [varchar](36) NULL,
	[col_device_identification_letter_id_fk] [varchar](36) NULL,
	[col_maintenance_entry_by] [varchar](36) NULL,
	[col_maintenance_entry_date] [datetime] NULL,
 CONSTRAINT [PK_tbl_maintenance] PRIMARY KEY CLUSTERED 
(
	[col_maintenance_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_maintenance_details]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_maintenance_details](
	[col_maintenance_details_id] [varchar](30) NOT NULL,
	[col_maintenance_details_parent_id] [varchar](36) NULL,
	[col_maintenance_id_fk] [varchar](36) NULL,
	[col_maintenance_type] [varchar](30) NULL,
	[col_frequency] [varchar](30) NULL,
	[col_start_date] [datetime] NULL,
	[col_end_date] [datetime] NULL,
	[col_status] [varchar](10) NULL,
	[col_duration] [int] NULL,
	[col_reason] [varchar](255) NULL,
	[col_completion_date] [datetime] NULL,
	[col_remarks] [varchar](255) NULL,
	[col_is_lta_granted] [bit] NULL,
	[col_lta_granted_by] [varchar](36) NULL,
	[col_lta_granted_date] [datetime] NULL,
	[col_update_by] [varchar](36) NULL,
	[col_update_date] [datetime] NULL,
 CONSTRAINT [PK_tbl_maintenance_details] PRIMARY KEY CLUSTERED 
(
	[col_maintenance_details_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_maintenance_frequency]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_maintenance_frequency](
	[col_device_category_id_fk] [varchar](36) NULL,
	[col_device_type_id_fk] [varchar](36) NULL,
	[col_is_frequency_weekly] [bit] NULL,
	[col_is_frequency_montly] [bit] NULL,
	[col_is_frequency_quarterly] [bit] NULL,
	[col_is_frequency_semi_anually] [bit] NULL,
	[col_is_frequency_anually] [bit] NULL,
	[col_is_key_switch_applicable] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_menus]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_menus](
	[col_menu_id] [uniqueidentifier] NOT NULL,
	[col_menu_name] [varchar](50) NULL,
	[col_url] [varchar](250) NULL,
	[col_icon] [varchar](30) NULL,
	[col_parent_id] [varchar](36) NULL,
	[col_is_parent] [bit] NULL,
	[col_is_group] [bit] NULL,
	[col_group_id] [varchar](36) NULL,
	[col_is_active] [bit] NULL,
	[col_timestamp] [datetime] NULL,
 CONSTRAINT [PK_tbl_menus] PRIMARY KEY CLUSTERED 
(
	[col_menu_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_object_bits]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_object_bits](
	[col_building_id_fk] [varchar](36) NOT NULL,
	[col_rtu_id_fk] [varchar](36) NOT NULL,
	[col_equipment_id_fk] [varchar](36) NOT NULL,
	[col_is_above64] [bit] NOT NULL,
	[col_ifd_bit_1] [bit] NULL,
	[col_ifd_bit_2] [bit] NULL,
	[col_ifd_bit_3] [bit] NULL,
	[col_ifd_bit_4] [bit] NULL,
	[col_ifd_bit_5] [bit] NULL,
	[col_ifd_bit_6] [bit] NULL,
	[col_ifd_bit_7] [bit] NULL,
	[col_ifd_bit_8] [bit] NULL,
	[col_ifd_bit_9] [bit] NULL,
	[col_ifd_bit_10] [bit] NULL,
	[col_ifd_bit_11] [bit] NULL,
	[col_ifd_bit_12] [bit] NULL,
	[col_ifd_bit_13] [bit] NULL,
	[col_ifd_bit_14] [bit] NULL,
	[col_ifd_bit_15] [bit] NULL,
	[col_ifd_bit_16] [bit] NULL,
	[col_ifd_bit_1_date] [datetime] NULL,
	[col_ifd_bit_2_date] [datetime] NULL,
	[col_ifd_bit_3_date] [datetime] NULL,
	[col_ifd_bit_4_date] [datetime] NULL,
	[col_ifd_bit_5_date] [datetime] NULL,
	[col_ifd_bit_6_date] [datetime] NULL,
	[col_ifd_bit_7_date] [datetime] NULL,
	[col_ifd_bit_8_date] [datetime] NULL,
	[col_ifd_bit_9_date] [datetime] NULL,
	[col_ifd_bit_10_date] [datetime] NULL,
	[col_ifd_bit_11_date] [datetime] NULL,
	[col_ifd_bit_12_date] [datetime] NULL,
	[col_ifd_bit_13_date] [datetime] NULL,
	[col_ifd_bit_14_date] [datetime] NULL,
	[col_ifd_bit_15_date] [datetime] NULL,
	[col_ifd_bit_16_date] [datetime] NULL,
	[col_bit_1] [bit] NULL,
	[col_bit_2] [bit] NULL,
	[col_bit_3] [bit] NULL,
	[col_bit_4] [bit] NULL,
	[col_bit_5] [bit] NULL,
	[col_bit_6] [bit] NULL,
	[col_bit_7] [bit] NULL,
	[col_bit_8] [bit] NULL,
	[col_bit_9] [bit] NULL,
	[col_bit_10] [bit] NULL,
	[col_bit_11] [bit] NULL,
	[col_bit_12] [bit] NULL,
	[col_bit_13] [bit] NULL,
	[col_bit_14] [bit] NULL,
	[col_bit_15] [bit] NULL,
	[col_bit_16] [bit] NULL,
	[col_bit_17] [bit] NULL,
	[col_bit_18] [bit] NULL,
	[col_bit_19] [bit] NULL,
	[col_bit_20] [bit] NULL,
	[col_bit_21] [bit] NULL,
	[col_bit_22] [bit] NULL,
	[col_bit_23] [bit] NULL,
	[col_bit_24] [bit] NULL,
	[col_bit_25] [bit] NULL,
	[col_bit_26] [bit] NULL,
	[col_bit_27] [bit] NULL,
	[col_bit_28] [bit] NULL,
	[col_bit_29] [bit] NULL,
	[col_bit_30] [bit] NULL,
	[col_bit_31] [bit] NULL,
	[col_bit_32] [bit] NULL,
	[col_bit_33] [bit] NULL,
	[col_bit_34] [bit] NULL,
	[col_bit_35] [bit] NULL,
	[col_bit_36] [bit] NULL,
	[col_bit_37] [bit] NULL,
	[col_bit_38] [bit] NULL,
	[col_bit_39] [bit] NULL,
	[col_bit_40] [bit] NULL,
	[col_bit_41] [bit] NULL,
	[col_bit_42] [bit] NULL,
	[col_bit_43] [bit] NULL,
	[col_bit_44] [bit] NULL,
	[col_bit_45] [bit] NULL,
	[col_bit_46] [bit] NULL,
	[col_bit_47] [bit] NULL,
	[col_bit_48] [bit] NULL,
	[col_bit_49] [bit] NULL,
	[col_bit_50] [bit] NULL,
	[col_bit_51] [bit] NULL,
	[col_bit_52] [bit] NULL,
	[col_bit_53] [bit] NULL,
	[col_bit_54] [bit] NULL,
	[col_bit_55] [bit] NULL,
	[col_bit_56] [bit] NULL,
	[col_bit_57] [bit] NULL,
	[col_bit_58] [bit] NULL,
	[col_bit_59] [bit] NULL,
	[col_bit_60] [bit] NULL,
	[col_bit_61] [bit] NULL,
	[col_bit_62] [bit] NULL,
	[col_bit_63] [bit] NULL,
	[col_bit_64] [bit] NULL,
	[col_bit_1_date] [datetime] NULL,
	[col_bit_2_date] [datetime] NULL,
	[col_bit_3_date] [datetime] NULL,
	[col_bit_4_date] [datetime] NULL,
	[col_bit_5_date] [datetime] NULL,
	[col_bit_6_date] [datetime] NULL,
	[col_bit_7_date] [datetime] NULL,
	[col_bit_8_date] [datetime] NULL,
	[col_bit_9_date] [datetime] NULL,
	[col_bit_10_date] [datetime] NULL,
	[col_bit_11_date] [datetime] NULL,
	[col_bit_12_date] [datetime] NULL,
	[col_bit_13_date] [datetime] NULL,
	[col_bit_14_date] [datetime] NULL,
	[col_bit_15_date] [datetime] NULL,
	[col_bit_16_date] [datetime] NULL,
	[col_bit_17_date] [datetime] NULL,
	[col_bit_18_date] [datetime] NULL,
	[col_bit_19_date] [datetime] NULL,
	[col_bit_20_date] [datetime] NULL,
	[col_bit_21_date] [datetime] NULL,
	[col_bit_22_date] [datetime] NULL,
	[col_bit_23_date] [datetime] NULL,
	[col_bit_24_date] [datetime] NULL,
	[col_bit_25_date] [datetime] NULL,
	[col_bit_26_date] [datetime] NULL,
	[col_bit_27_date] [datetime] NULL,
	[col_bit_28_date] [datetime] NULL,
	[col_bit_29_date] [datetime] NULL,
	[col_bit_30_date] [datetime] NULL,
	[col_bit_31_date] [datetime] NULL,
	[col_bit_32_date] [datetime] NULL,
	[col_bit_33_date] [datetime] NULL,
	[col_bit_34_date] [datetime] NULL,
	[col_bit_35_date] [datetime] NULL,
	[col_bit_36_date] [datetime] NULL,
	[col_bit_37_date] [datetime] NULL,
	[col_bit_38_date] [datetime] NULL,
	[col_bit_39_date] [datetime] NULL,
	[col_bit_40_date] [datetime] NULL,
	[col_bit_41_date] [datetime] NULL,
	[col_bit_42_date] [datetime] NULL,
	[col_bit_43_date] [datetime] NULL,
	[col_bit_44_date] [datetime] NULL,
	[col_bit_45_date] [datetime] NULL,
	[col_bit_46_date] [datetime] NULL,
	[col_bit_47_date] [datetime] NULL,
	[col_bit_48_date] [datetime] NULL,
	[col_bit_49_date] [datetime] NULL,
	[col_bit_50_date] [datetime] NULL,
	[col_bit_51_date] [datetime] NULL,
	[col_bit_52_date] [datetime] NULL,
	[col_bit_53_date] [datetime] NULL,
	[col_bit_54_date] [datetime] NULL,
	[col_bit_55_date] [datetime] NULL,
	[col_bit_56_date] [datetime] NULL,
	[col_bit_57_date] [datetime] NULL,
	[col_bit_58_date] [datetime] NULL,
	[col_bit_59_date] [datetime] NULL,
	[col_bit_60_date] [datetime] NULL,
	[col_bit_61_date] [datetime] NULL,
	[col_bit_62_date] [datetime] NULL,
	[col_bit_63_date] [datetime] NULL,
	[col_bit_64_date] [datetime] NULL,
 CONSTRAINT [PK_tbl_object_bits] PRIMARY KEY CLUSTERED 
(
	[col_building_id_fk] ASC,
	[col_rtu_id_fk] ASC,
	[col_equipment_id_fk] ASC,
	[col_is_above64] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_operating_schedule]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_operating_schedule](
	[col_operating_schedule_id] [uniqueidentifier] NULL,
	[col_operating_schedule_title] [varchar](150) NULL,
	[col_opertaing_time_start] [time](0) NULL,
	[col_opertaing_time_end] [time](0) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_role_to_menu]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_role_to_menu](
	[col_role_id_fk] [varchar](36) NULL,
	[col_menu_id_fk] [varchar](36) NULL,
	[col_is_active] [bit] NULL,
	[col_timestamp] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_roles]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_roles](
	[col_role_id] [uniqueidentifier] NOT NULL,
	[col_role_name] [varchar](50) NULL,
	[col_is_sms_roles] [bit] NULL,
	[col_menu_id_fk] [varchar](36) NULL,
	[col_is_active] [bit] NULL,
 CONSTRAINT [PK_tbl_roles] PRIMARY KEY CLUSTERED 
(
	[col_role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_rs485_valuedefine]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_rs485_valuedefine](
	[col_rs485_valuedefine_id] [uniqueidentifier] NOT NULL,
	[col_bi_int] [int] NOT NULL,
	[col_bi_description] [varchar](350) NULL,
 CONSTRAINT [PK_tbl_rs485_valuedefine] PRIMARY KEY CLUSTERED 
(
	[col_rs485_valuedefine_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_rtu]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_rtu](
	[col_rtu_id] [varchar](30) NOT NULL,
	[col_building_id_fk] [varchar](30) NULL,
	[col_config_id_fk] [varchar](36) NULL,
	[col_dg_setup_id_fk] [varchar](36) NULL,
	[col_rtu_ip_address] [varchar](150) NULL,
	[col_baudrate] [int] NULL,
	[col_hardware_version] [varchar](30) NULL,
	[col_dvr_type] [varchar](30) NULL,
	[col_dvr_ip_address] [varchar](150) NULL,
	[col_dvr_term] [varchar](30) NULL,
	[col_iems_dvr_ip] [varchar](150) NULL,
	[col_remarks] [varchar](500) NULL,
	[col_setup_date] [datetime] NULL,
	[col_enabledisablestatus] [bit] NULL,
	[col_day_night_flag] [bit] NULL,
	[col_is_online] [bit] NULL,
	[col_is_active] [bit] NULL,
 CONSTRAINT [PK_tbl_rtu] PRIMARY KEY CLUSTERED 
(
	[col_rtu_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_sites]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_sites](
	[col_site_id] [varchar](30) NOT NULL,
	[col_address_code] [varchar](50) NULL,
	[col_postal_code] [varchar](50) NULL,
	[col_address] [varchar](300) NULL,
	[col_is_active] [bit] NULL,
 CONSTRAINT [PK_tbl_sites] PRIMARY KEY CLUSTERED 
(
	[col_site_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_tokens]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_tokens](
	[col_token_id] [uniqueidentifier] NOT NULL,
	[col_value] [varchar](50) NULL,
	[col_created_date] [datetime] NULL,
	[col_user_id] [varchar](36) NULL,
	[col_last_modified_date] [datetime] NULL,
	[col_expiry_time] [datetime] NULL,
 CONSTRAINT [PK_tbl_tokens] PRIMARY KEY CLUSTERED 
(
	[col_token_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_user_to_menu]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_user_to_menu](
	[col_user_id_fk] [varchar](36) NULL,
	[col_menu_id_fk] [varchar](36) NULL,
	[col_is_active] [bit] NULL,
	[col_timestamp] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_user_to_restricted_menu]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_user_to_restricted_menu](
	[col_user_id_fk] [varchar](36) NULL,
	[col_menu_id_fk] [varchar](36) NULL,
	[col_is_active] [bit] NULL,
	[col_timestamp] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_user_to_role]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_user_to_role](
	[col_role_id_fk] [varchar](36) NULL,
	[col_user_id_fk] [varchar](36) NULL,
	[col_is_active] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_users]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_users](
	[col_user_id] [uniqueidentifier] NOT NULL,
	[col_user_name] [varchar](100) NULL,
	[col_full_name] [varchar](150) NULL,
	[col_email] [varchar](50) NULL,
	[col_sms_phone_nbr] [varchar](20) NULL,
	[col_password] [varchar](500) NULL,
	[col_password_salt] [varchar](100) NULL,
	[col_otp] [varchar](20) NULL,
	[col_otp_expiry_time] [int] NULL,
	[col_is_active] [bit] NULL,
	[col_entry_by] [varchar](36) NULL,
	[col_entry_date] [datetime] NULL,
	[col_updated_by] [varchar](36) NULL,
	[col_updated_date] [datetime] NULL,
	[col_is_deleted] [bit] NULL,
	[col_deleted_by] [varchar](36) NULL,
 CONSTRAINT [PK_tbl_users] PRIMARY KEY CLUSTERED 
(
	[col_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 130, 20, 5, 1)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 131, 11, 5, 1)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 131, 11, 5, 2)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 133, 9, 5, 1)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 134, 1, 5, 1)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 133, 23, 5, 2)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 133, 23, 5, 3)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 133, 23, 5, 4)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 134, 1, 5, 2)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 134, 1, 5, 3)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 134, 1, 5, 5)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 133, 23, 5, 6)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 133, 23, 5, 7)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 133, 23, 5, 9)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 133, 23, 5, 10)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 133, 23, 5, 12)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 134, 1, 5, 7)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 134, 1, 5, 4)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 133, 23, 5, 5)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 133, 23, 5, 8)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 133, 23, 5, 11)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 134, 1, 5, 6)
INSERT [dbo].[tbl_alarm_case_id_generator] ([col_year], [col_day_of_year], [col_hour], [col_minute], [col_max_case_no]) VALUES (22, 134, 1, 5, 8)
INSERT [dbo].[tbl_alarms] ([col_alarm_case_id], [col_building_id_fk], [col_building_title], [col_equipment_id_fk], [col_device_id_fk], [col_device_desc], [col_contractor_company_id_fk], [col_contract_id_fk], [col_bit_type], [col_alert_type], [col_process_flag], [col_alarm_set_date], [col_analog_unit], [col_analog_value], [col_alarm_desc], [col_alarm_clear_date], [col_arrival_date], [col_fault_code_fk], [col_report_desc], [col_report_date], [col_report_by], [col_acknwledge_date], [col_acknwledge_by], [col_closed_date], [col_closed_by], [col_lta_verify_date], [col_lta_verify_by], [col_lta_remarks], [col_mask], [col_is_diagnosis_point], [col_diagnosis_rule_id_fk], [col_is_on_test]) VALUES (N'A220580030-040874', N'S013B001', N'Bukit Merah Central', N'S013RTU01EQ004', N'S013RTU01EQ004D005', N'ESCALATOR 1 STOP ITSELF', N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', N'89BE2D96-D561-485A-B055-15E53D558C76', N'DI', N'SMS0', 0, CAST(N'2022-05-13T18:50:10.277' AS DateTime), NULL, NULL, N'ESCALATOR 1 STOP ITSELF', CAST(N'2022-05-13T20:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, 0)
INSERT [dbo].[tbl_alarms] ([col_alarm_case_id], [col_building_id_fk], [col_building_title], [col_equipment_id_fk], [col_device_id_fk], [col_device_desc], [col_contractor_company_id_fk], [col_contract_id_fk], [col_bit_type], [col_alert_type], [col_process_flag], [col_alarm_set_date], [col_analog_unit], [col_analog_value], [col_alarm_desc], [col_alarm_clear_date], [col_arrival_date], [col_fault_code_fk], [col_report_desc], [col_report_date], [col_report_by], [col_acknwledge_date], [col_acknwledge_by], [col_closed_date], [col_closed_by], [col_lta_verify_date], [col_lta_verify_by], [col_lta_remarks], [col_mask], [col_is_diagnosis_point], [col_diagnosis_rule_id_fk], [col_is_on_test]) VALUES (N'A220580030-040875', N'S013B001', N'Bukit Merah Central', N'S013RTU01EQ003', N'S013RTU01EQ003D004', N'LIFT TRIP', N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', N'A21B086F-A084-4367-B992-C92EC1D85F79', N'DA', N'SMS0', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime), NULL, NULL, N'LIFT 1 TRIP', CAST(N'2022-05-13T20:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, 0)
INSERT [dbo].[tbl_alarms] ([col_alarm_case_id], [col_building_id_fk], [col_building_title], [col_equipment_id_fk], [col_device_id_fk], [col_device_desc], [col_contractor_company_id_fk], [col_contract_id_fk], [col_bit_type], [col_alert_type], [col_process_flag], [col_alarm_set_date], [col_analog_unit], [col_analog_value], [col_alarm_desc], [col_alarm_clear_date], [col_arrival_date], [col_fault_code_fk], [col_report_desc], [col_report_date], [col_report_by], [col_acknwledge_date], [col_acknwledge_by], [col_closed_date], [col_closed_by], [col_lta_verify_date], [col_lta_verify_by], [col_lta_remarks], [col_mask], [col_is_diagnosis_point], [col_diagnosis_rule_id_fk], [col_is_on_test]) VALUES (N'A221311105-000001', N'S013B001', N'Bukit Merah Central', N'S013RTU01EQ001', N'S013RTU01EQ001D011', N'CCTV IMAGE LOSS', N'31F1BE2C-AF0D-4AA6-BED7-C31F5838C27A', N'EA19ADFA-D45C-481F-ABF8-74C85BEE52E7', N'DA', N'SMS0', 0, CAST(N'2022-05-13T18:50:10.277' AS DateTime), NULL, NULL, N'CCTV IMAGE LOSS', NULL, CAST(N'2022-05-13T18:50:10.277' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, 1)
INSERT [dbo].[tbl_alarms] ([col_alarm_case_id], [col_building_id_fk], [col_building_title], [col_equipment_id_fk], [col_device_id_fk], [col_device_desc], [col_contractor_company_id_fk], [col_contract_id_fk], [col_bit_type], [col_alert_type], [col_process_flag], [col_alarm_set_date], [col_analog_unit], [col_analog_value], [col_alarm_desc], [col_alarm_clear_date], [col_arrival_date], [col_fault_code_fk], [col_report_desc], [col_report_date], [col_report_by], [col_acknwledge_date], [col_acknwledge_by], [col_closed_date], [col_closed_by], [col_lta_verify_date], [col_lta_verify_by], [col_lta_remarks], [col_mask], [col_is_diagnosis_point], [col_diagnosis_rule_id_fk], [col_is_on_test]) VALUES (N'A221330905-000001', N'S013B001', N'Bukit Merah Central', N'S013RTU01EQ003', N'S013RTU01EQ003D008', N'KEY SWITCH LIFT', N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', N'A21B086F-A084-4367-B992-C92EC1D85F79', N'DI', N'SMS0', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime), NULL, NULL, N'KEY SWITCH LIFT', CAST(N'2022-05-16T15:31:52.847' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, 1)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'd93f525a-89af-4569-a3cb-03276e9214df', N'S013RTU01EQ001', N'S013RTU01EQ001D002', 1, 0, 31, 31, N'MAIN INCOMING Y- PHASE TRIP', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'1202cb09-ed97-4ca1-94c8-095606c0139e', N'S013RTU01EQ001', N'S013RTU01EQ001D017', 1, 0, 12, 12, N'RTU POWER FAIL', N'98CC6CDC-EAF3-468B-92C3-D16583A4D944', N'DI', 1, 0, 0, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'3d30c298-a62f-441f-a160-0a9c519aee9f', N'S013RTU03EQ001', N'S013RTU03EQ001D009', 1, 0, 7, 7, N'(Esc 1) Earth leakage alarm', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'3f115883-588c-4548-8546-0c9620ce9431', N'S013RTU03EQ001', N'S013RTU03EQ001D001', 1, 0, 23, 23, N'(Esc 1) Auxiliary brake pad status alarm', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'ff301b05-597c-45ac-8a6c-0d3a475948f7', N'S013RTU01EQ001', N'S013RTU01EQ001D005', 1, 0, 28, 28, N'LIGHTING 2 STATUS', N'98CC6CDC-EAF3-468B-92C3-D16583A4D944', N'DI', 1, 0, 0, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'9c60adcb-6691-4b6b-8aa8-0f1589cb46f4', N'S013RTU03EQ001', N'S013RTU03EQ001D021', 1, 0, 43, 43, N'(Esc 1) Floor plate opened alarm, upper', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'9cd1679e-f3e2-41be-bba4-11dce1702a29', N'S013RTU02EQ001', N'S013RTU02EQ001D001', 1, 0, 1, 5, N'Lift Breakdown. Please Check.', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'5cd2eaf0-f054-425b-b87d-184b2ecc708a', N'S013RTU03EQ001', N'S013RTU03EQ001D011', 1, 0, 51, 51, N'(Esc 1) Emergency stop alarm, middle', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 1)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'55570183-9044-4a11-b24e-197e28404e75', N'S013RTU03EQ001', N'S013RTU03EQ001D029', 1, 0, 26, 26, N'(Esc 1) Handrail speed -  15% alarm, right', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'0d463e69-0a88-45bd-bea3-1cfb73718cf4', N'S013RTU01EQ003', N'S013RTU01EQ003D006', 1, 0, 8, 8, N'LIFT INTERCOM ACTIVATED', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DI', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'1d153dd9-6c6d-4790-a0fb-1dbe3b669cd4', N'S013RTU01EQ001', N'S013RTU01EQ001D015', 1, 1, 47, 47, N'DIMM 2 FAIL', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'1dcecffb-f8f8-45d9-a21e-1e3e81143a70', N'S013RTU03EQ001', N'S013RTU03EQ001D048', 1, 0, 8, 8, N'(Esc 1) PCB board communication fault alarm', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'88b7e0c1-c26a-4c46-85c9-219101dd036f', N'S013RTU03EQ001', N'S013RTU03EQ001D028', 1, 0, 32, 32, N'(Esc 1) Handrail inlet safety switch, upper right', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'6706dc4f-28e0-48c3-8789-21bee81ecdf4', N'S013RTU03EQ001', N'S013RTU03EQ001D007', 1, 0, 12, 12, N'(Esc 1) EBOS/UPS fault alarm', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'051e0ce0-4d47-41e9-85ae-241b32fefea6', N'S013RTU02EQ001', N'S013RTU02EQ001D007', 1, 0, 16, 16, N'Passenger Trapped (PTRP)', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 1)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'02a0db7d-263d-4cf7-96f9-288cd4a95f0c', N'S013RTU03EQ001', N'S013RTU03EQ001D017', 1, 0, 2, 2, N'(Esc 1) Escalator Up Direction Status', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DI', 0, 0, 0, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'a6c43c33-f665-47eb-9fef-28fb54d7b8b2', N'S013RTU02EQ001', N'S013RTU02EQ001D019', 1, 0, 51, 51, N'I/O Serial Comm Cable Faulty (SPA 14)', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'4caaeae3-a77f-410c-91f5-294c85c11544', N'S013RTU02EQ001', N'S013RTU02EQ001D016', 1, 0, 28, 28, N'ARD Battery Voltage Low (ABL)', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'3802a38d-d219-4676-b918-3147aa4e01d8', N'S013RTU01EQ003', N'S013RTU01EQ003D002', 1, 0, 17, 17, N'LIFT MAINTENANCE MODE', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DI', 1, 0, 24, 0, NULL, 1, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'71669117-3549-4881-b5bc-34a52abf4fb1', N'S013RTU03EQ001', N'S013RTU03EQ001D041', 1, 0, 60, 60, N'(Esc 1) Motion sensor fault alarm, lower', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DI', 0, 0, 0, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'1673c6d1-c738-472f-9b53-34b5fd0f6abb', N'S013RTU01EQ001', N'S013RTU01EQ001D018', 1, 0, 6, 6, N'KEY SWITCH RTU', N'98CC6CDC-EAF3-468B-92C3-D16583A4D944', N'DI', 0, 0, 0, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'701630eb-46fb-4316-9271-3519b9470ee5', N'S013RTU03EQ001', N'S013RTU03EQ001D008', 1, 0, 64, 64, N'(Esc 1) ESC RS485 I/O Comm Failure', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'69ce2ae1-3f0d-4407-8d09-399e55d1e275', N'S013RTU01EQ003', N'S013RTU01EQ003D007', 1, 0, 7, 7, N'LIFT ALARM BELL ACTIVATED', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'd52d9072-07d6-499b-840b-3c4869c6d752', N'S013RTU03EQ001', N'S013RTU03EQ001D045', 1, 0, 14, 14, N'(Esc 1) Motor overload alarm', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'8a8b0d97-83d4-467a-919e-3cd6db06fcab', N'S013RTU03EQ001', N'S013RTU03EQ001D005', 1, 0, 45, 45, N'(Esc 1) Comb plate safety switch alarm, upper left', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'9b83b3cd-054a-485a-9899-4270aba15ca8', N'S013RTU03EQ001', N'S013RTU03EQ001D015', 1, 0, 4, 4, N'(Esc 1) Escalator Maintenance Status', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DI', 0, 0, 0, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'd1efed1d-a0b9-4f2c-aa4c-432c3cccbda2', N'S013RTU03EQ001', N'S013RTU03EQ001D061', 1, 0, 42, 42, N'(Esc 1) Step upthrust safety switch alarm, lower', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'9769adab-fe09-46de-965b-4425172a7189', N'S013RTU01EQ001', N'S013RTU01EQ001D001', 1, 0, 32, 32, N'MAIN INCOMING R- PHASE TRIP', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'75c374fc-2eb3-4dc9-bdf8-44c6b5b83db5', N'S013RTU03EQ001', N'S013RTU03EQ001D002', 1, 0, 22, 22, N'(Esc 1) Auxiliary brake status alarm', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DI', 0, 0, 0, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'80cb90c0-771e-4749-9d04-45ded6e0b52f', N'S013RTU03EQ001', N'S013RTU03EQ001D058', 1, 0, 40, 40, N'(Esc 1) Step chain tension alarm, right', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'7d882431-71f0-4475-bd79-492db68ac04a', N'S013RTU02EQ001', N'S013RTU02EQ001D003', 1, 0, 10, 10, N'ARD Failure (ARDF)', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'12961ebd-6fdb-4010-83a4-49ffff987f64', N'S013RTU01EQ001', N'S013RTU01EQ001D008', 1, 0, 5, 5, N'CCTV MAIN INCOMING SUPPLY', N'98CC6CDC-EAF3-468B-92C3-D16583A4D944', N'DI', 1, 0, 0, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'dbafa204-146d-45c4-b252-4f064c489c05', N'S013RTU03EQ001', N'S013RTU03EQ001D025', 1, 0, 33, 33, N'(Esc 1) Handrail inlet safety switch, lower left', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'c13fc2bf-ff1e-416b-93d9-54703330ca27', N'S013RTU03EQ001', N'S013RTU03EQ001D040', 1, 0, 35, 35, N'(Esc 1) Missing step alarm-upper', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'5c38f4b4-9547-480d-b230-54babc67b5c4', N'S013RTU01EQ001', N'S013RTU01EQ001D010', 1, 0, 3, 3, N'CCTV HARD DISK MALFUNCTION', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'd35b24ce-a865-4730-95d7-5a71ddbb849a', N'S013RTU03EQ001', N'S013RTU03EQ001D037', 1, 0, 21, 21, N'(Esc 1) Mechanical brake pad status alarm', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'd7644f90-e956-4f80-b99b-5b2091377aaa', N'S013RTU01EQ001', N'S013RTU01EQ001D013', 1, 0, 11, 11, N'KEY SWITCH ME', N'98CC6CDC-EAF3-468B-92C3-D16583A4D944', N'DI', 0, 0, 0, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'2fbfd810-151a-4a20-b65b-5dda3608cd8a', N'S013RTU02EQ001', N'S013RTU02EQ001D013', 1, 0, 25, 25, N'EBOPS Battery Voltage High (EBH)', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'48fb6c83-ae01-440a-bd98-60b988b2635c', N'S013RTU03EQ001', N'S013RTU03EQ001D059', 1, 0, 38, 38, N'(Esc 1) Step sag safety switch alarm, lower', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'6b05740e-fdd8-42ef-bde1-68057a2b38cb', N'S013RTU01EQ003', N'S013RTU01EQ003D004', 1, 0, 15, 15, N'LIFT TRIP', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'36c35a39-9f98-4b13-a5a0-69403dac2439', N'S013RTU02EQ001', N'S013RTU02EQ001D018', 1, 0, 32, 32, N'TOI', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DI', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'c0f3eaef-a109-4e49-9333-6b217a86ca78', N'S013RTU03EQ001', N'S013RTU03EQ001D024', 1, 0, 28, 28, N'(Esc 1) Handrail inconsistent speed alarm, right', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'8d725e0e-f0c7-4133-b74a-6fb8c66d1416', N'S013RTU02EQ001', N'S013RTU02EQ001D010', 1, 0, 19, 19, N'Car Door Open (CDO)', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'9b28f155-e4b2-4029-91b2-73d955089788', N'S013RTU03EQ001', N'S013RTU03EQ001D046', 1, 0, 16, 16, N'(Esc 1) Motor overspeed alarm', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'41efc6ff-a4f1-4395-8f09-7560490133b3', N'S013RTU02EQ001', N'S013RTU02EQ001D017', 1, 0, 31, 31, N'Sensor Fault (EBF)', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DI', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'ede60420-0273-45fa-a5f2-7745420e79fe', N'S013RTU03EQ001', N'S013RTU03EQ001D036', 1, 0, 13, 13, N'(Esc 1) Main drive chain fault alarm', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'bfc0b7f8-dee9-42b3-b77d-7794c59e261e', N'S013RTU01EQ004', N'S013RTU01EQ004D004', 1, 0, 64, 64, N'ESCALATOR 1 STOP ITSELF', N'98CC6CDC-EAF3-468B-92C3-D16583A4D944', N'DI', 0, 0, 0, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'e693f28e-903b-45cf-945f-77a02da69df5', N'S013RTU02EQ001', N'S013RTU02EQ001D014', 1, 0, 26, 26, N'EBOPS Battery Voltage Low (EBL)', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'506a3de4-2e91-44d0-8f1b-788106723958', N'S013RTU03EQ001', N'S013RTU03EQ001D044', 1, 0, 15, 15, N'(Esc 1) Motor overheat alarm', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'f5d8096c-4de1-487d-b998-7895fd87744d', N'S013RTU03EQ001', N'S013RTU03EQ001D057', 1, 0, 39, 39, N'(Esc 1) Step chain tension alarm, left', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'561a9509-69c2-49fe-9e2c-7ee453844791', N'S013RTU01EQ004', N'S013RTU01EQ004D003', 1, 0, 22, 22, N'ESCALATOR DOWN DIRECTION', N'98CC6CDC-EAF3-468B-92C3-D16583A4D944', N'DI', 0, 0, 19, 0, NULL, 1, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'bdb37c96-565e-4302-96ea-811ca9d22ec2', N'S013RTU01EQ001', N'S013RTU01EQ001D016', 1, 0, 13, 13, N'RTU LOW BATT', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 1, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'abb46af2-6e31-495c-be73-81e8e6d67555', N'S013RTU01EQ004', N'S013RTU01EQ004D005', 1, 0, 10, 10, N'KEY SWITCH ESCALATOR', N'98CC6CDC-EAF3-468B-92C3-D16583A4D944', N'DI', 0, 0, 0, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'8723a5be-bcaf-4898-82d5-82225f1e0ec5', N'S013RTU02EQ001', N'S013RTU02EQ001D015', 1, 0, 27, 27, N'ARD Battery Voltage High (ABH)', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'cf70505f-bbab-44e4-b168-84d716f8d2f9', N'S013RTU03EQ001', N'S013RTU03EQ001D019', 1, 0, 49, 49, N'(Esc 1) Flood sensor alarm', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'8d3fa470-3ca9-4ebd-85da-885568964379', N'S013RTU01EQ001', N'S013RTU01EQ001D003', 1, 0, 30, 30, N'MAIN INCOMING B-PHASE TRIP', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'0895e7a7-14cd-4922-8ad6-895d0796053c', N'S013RTU03EQ001', N'S013RTU03EQ001D050', 1, 0, 9, 9, N'(Esc 1) Safety circuit Opened alarm', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DI', 0, 0, 0, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'364f7fbd-b857-47c6-a470-89c7b92566b4', N'S013RTU01EQ001', N'S013RTU01EQ001D006', 1, 0, 27, 27, N'LIGHTING 3 STATUS', N'98CC6CDC-EAF3-468B-92C3-D16583A4D944', N'DI', 1, 0, 0, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'975b12cf-e6a9-4099-9fc7-8d6d2d7ac7f8', N'S013RTU03EQ001', N'S013RTU03EQ001D039', 1, 0, 36, 36, N'(Esc 1) Missing step alarm-lower', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'8b8c9767-b257-444c-b88e-8fc991ad7697', N'S013RTU03EQ001', N'S013RTU03EQ001D047', 1, 0, 17, 17, N'(Esc 1) Motor reverse direction alarm', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'c11f0d80-dc22-42d3-b8e7-90d48881bc04', N'S013RTU02EQ001', N'S013RTU02EQ001D011', 1, 0, 8, 8, N'Water Level Sensor Activated', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'ea809e92-40e3-4729-b1f8-92e1db133941', N'S013RTU02EQ001', N'S013RTU02EQ001D012', 1, 0, 22, 22, N'Lift Maintenance Switch (LM)', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DI', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'2bcbce4c-1074-4494-9252-940fd8a25ee6', N'S013RTU03EQ001', N'S013RTU03EQ001D022', 1, 0, 19, 19, N'(Esc 1) Gearbox oil level low alarm', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'448b5847-ff0d-4eeb-b5d5-9688a4d629f2', N'S013RTU03EQ001', N'S013RTU03EQ001D060', 1, 0, 37, 37, N'(Esc 1) Step sag safety switch alarm, upper', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'405a93b3-d8ca-4439-b150-9701e9f6c5c6', N'S013RTU03EQ001', N'S013RTU03EQ001D030', 1, 0, 25, 25, N'(Esc 1) Handrail speed - 15% alarm, left', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'b8b9dfc9-b0f8-449b-a0ca-97ca17b0bf85', N'S013RTU01EQ003', N'S013RTU01EQ003D003', 1, 0, 16, 16, N'LIFT EMERGENCY OPERATION HOMING', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'f7cec816-810c-478c-9b1a-9a17755b93e8', N'S013RTU03EQ001', N'S013RTU03EQ001D038', 1, 0, 20, 20, N'(Esc 1) Mechanical brake status alarm', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DI', 0, 0, 0, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'2ca273a3-576f-4471-81d6-9c0084306d2d', N'S013RTU03EQ001', N'S013RTU03EQ001D034', 1, 0, 10, 10, N'(Esc 1) Inverter fault alarm', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'0785edb5-5286-4f1a-9dfd-a471b07cc28a', N'S013RTU01EQ004', N'S013RTU01EQ004D002', 1, 0, 23, 23, N'ESCALATOR UP DIRECTION', N'98CC6CDC-EAF3-468B-92C3-D16583A4D944', N'DI', 0, 0, 19, 0, NULL, 1, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'e3429091-788a-4ca2-a815-a7694c393537', N'S013RTU03EQ001', N'S013RTU03EQ001D032', 1, 0, 30, 30, N'(Esc 1) Handrail tension/ Broken alarm, right', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'a067f88c-895b-415a-a611-a76e7ccb164b', N'S013RTU03EQ001', N'S013RTU03EQ001D049', 1, 0, 6, 6, N'(Esc 1) Phase reverse/loss alarm', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'9ac4bf33-057e-4130-839e-a9d30f3f9e18', N'S013RTU03EQ001', N'S013RTU03EQ001D031', 1, 0, 29, 29, N'(Esc 1) Handrail tension/ Broken alarm, left', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'c33e6eb8-6401-4c78-b216-aa5ffff9c911', N'S013RTU03EQ001', N'S013RTU03EQ001D006', 1, 0, 46, 46, N'(Esc 1) Comb plate safety switch alarm,upper right', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'5b99fd0a-d34c-4eca-9317-aa8c021e82bd', N'S013RTU02EQ001', N'S013RTU02EQ001D006', 1, 0, 15, 15, N'Main Riser Switched Off (MOF)', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'ee287934-ed55-4494-a0ce-b01f6767fa8b', N'S013RTU03EQ001', N'S013RTU03EQ001D023', 1, 0, 27, 27, N'(Esc 1) Handrail inconsistent speed alarm, left', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'aad15b7c-ecfb-4c17-a72c-b1019ea82c88', N'S013RTU03EQ001', N'S013RTU03EQ001D010', 1, 0, 52, 52, N'(Esc 1) Emergency stop alarm, lower', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 1)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'ead5ef85-60bc-4fe4-a2ae-b2841c5e99b3', N'S013RTU03EQ001', N'S013RTU03EQ001D043', 1, 0, 18, 18, N'(Esc 1) Motor inconsistent speed alarm', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'a3b7e009-a045-4c90-99ce-b38640149aef', N'S013RTU03EQ001', N'S013RTU03EQ001D004', 1, 0, 48, 48, N'(Esc 1) Comb plate safety switch alarm,lower right', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'3ee5dbdd-52ea-4865-95c2-bd2b5e68ff34', N'S013RTU01EQ001', N'S013RTU01EQ001D012', 1, 0, 59, 59, N'CCTV ON BATT > 2 HOURS - CHK SITE', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'5765bb48-de9a-407e-89ae-bd6ce7bc2a89', N'S013RTU03EQ001', N'S013RTU03EQ001D016', 1, 0, 1, 1, N'(Esc 1) Escalator ON/OFF Status', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DI', 1, 0, 0, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'75d007ec-52a6-41db-aed0-c27cd04c5b6a', N'S013RTU02EQ001', N'S013RTU02EQ001D005', 1, 0, 14, 14, N'Lift Riser Failure (LRF)', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'35f00280-181a-4244-bbba-c2fea20199e7', N'S013RTU03EQ001', N'S013RTU03EQ001D035', 1, 0, 11, 11, N'(Esc 1) Inverter no run signal alarm', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DI', 0, 0, 0, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'c4c5af0c-0791-47ed-b6c8-c93228231aa2', N'S013RTU02EQ001', N'S013RTU02EQ001D002', 1, 0, 9, 9, N'ARD Isolation Switch', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'fd78698b-da0d-4c26-8b86-cab197cca8de', N'S013RTU03EQ001', N'S013RTU03EQ001D051', 1, 0, 57, 57, N'(Esc 1) Skirt panel safety switch alarm,lower left', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'c3054802-da9b-43ce-9ec8-cc862eceb4d3', N'S013RTU03EQ001', N'S013RTU03EQ001D012', 1, 0, 50, 50, N'(Esc 1) Emergency stop alarm, upper', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 1)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'd394e403-e9e8-432f-a686-cceab023f7fb', N'S013RTU03EQ001', N'S013RTU03EQ001D033', 1, 0, 5, 5, N'(Esc 1) Incoming power supply ON/OFF status', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'190f6542-8aeb-41e9-be95-cd8e48c44db1', N'S013RTU03EQ001', N'S013RTU03EQ001D020', 1, 0, 44, 44, N'(Esc 1) Floor plate opened alarm, lower', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'6261d285-4721-4ebe-b458-d40c892f4dc8', N'S013RTU02EQ001', N'S013RTU02EQ001D008', 1, 0, 17, 17, N'Motor Room Intrusion (MRI)', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DI', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'97c91064-0743-4c9c-90a7-d47a07ee7cba', N'S013RTU03EQ001', N'S013RTU03EQ001D053', 1, 0, 58, 58, N'(Esc 1) Skirt panel safety switchalarm,lower right', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'a44bbaac-f4cd-481d-b5c0-da9075749a34', N'S013RTU01EQ001', N'S013RTU01EQ001D011', 1, 0, 2, 2, N'CCTV IMAGE LOSS', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'df035b45-9e87-486e-b334-deee6296368a', N'S013RTU02EQ001', N'S013RTU02EQ001D020', 1, 0, 13, 13, N'Power Failuer (PSF)', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'1e045553-56d4-4686-9a07-defddd273622', N'S013RTU01EQ003', N'S013RTU01EQ003D005', 1, 0, 14, 14, N'LIFT POWER', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 1, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'7fe70b9f-8b33-4a91-81f6-e14a1d87d8ed', N'S013RTU03EQ001', N'S013RTU03EQ001D062', 1, 0, 41, 41, N'(Esc 1) Step upthrust safety switch alarm, upper', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'b10058c2-a47f-4c23-93e1-e57a57f0dc4b', N'S013RTU01EQ001', N'S013RTU01EQ001D019', 1, 0, 1, 1, N'RTU Comm', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 1, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'60a60cfe-8b4e-458a-9826-e68dbc5c2184', N'S013RTU01EQ001', N'S013RTU01EQ001D009', 1, 0, 4, 4, N'CCTV POWER STATUS - DC', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 1, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'8931fff8-f21c-444f-bb4e-e8f67af78044', N'S013RTU03EQ001', N'S013RTU03EQ001D042', 1, 0, 59, 59, N'(Esc 1) Motion sensor fault alarm, upper', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DI', 0, 0, 0, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'316c5777-cb82-4a74-95b2-ee053a36943b', N'S013RTU02EQ001', N'S013RTU02EQ001D004', 1, 0, 11, 11, N'Lift Parked (LPK)', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DI', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'e7edd1c8-c905-4725-a597-ee1f3a7eaa41', N'S013RTU03EQ001', N'S013RTU03EQ001D027', 1, 0, 31, 31, N'(Esc 1) Handrail inlet safety switch, upper left', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'a770c3d0-62f6-41f6-b0d7-eee5e9e5209e', N'S013RTU01EQ001', N'S013RTU01EQ001D007', 1, 0, 26, 26, N'LIGHTING ELCB TRIP', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'deb72696-ad06-4d27-b8e6-ef1bc5b4a945', N'S013RTU03EQ001', N'S013RTU03EQ001D013', 1, 0, 3, 3, N'(Esc 1) Escalator Down Direction Status', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DI', 0, 0, 0, 0, NULL, 0, 0)
GO
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'65ababf9-6454-49bf-bae9-f0264457db48', N'S013RTU03EQ001', N'S013RTU03EQ001D052', 1, 0, 56, 56, N'(Esc 1) Skirt panel safety switch,middle right', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'1b414e2e-5fef-464c-a24b-f0a26ab9cb4f', N'S013RTU01EQ004', N'S013RTU01EQ004D001', 1, 0, 24, 24, N'ESCALATOR RUN STATUS', N'98CC6CDC-EAF3-468B-92C3-D16583A4D944', N'DI', 1, 0, 19, 0, NULL, 1, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'757b529e-7343-4666-8fd1-f0ea95015bd2', N'S013RTU03EQ001', N'S013RTU03EQ001D026', 1, 0, 34, 34, N'(Esc 1) Handrail inlet safety switch, lower right', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'96adea41-1a69-47d5-990c-f1fdab39b593', N'S013RTU03EQ001', N'S013RTU03EQ001D003', 1, 0, 47, 47, N'(Esc 1) Comb plate safety switch alarm, lower left', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'3ea30e42-7d69-4ebe-a34f-f2b431f25cd7', N'S013RTU01EQ001', N'S013RTU01EQ001D004', 1, 0, 29, 29, N'LIGHTING 1 STATUS', N'98CC6CDC-EAF3-468B-92C3-D16583A4D944', N'DI', 1, 0, 0, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'de092a4b-bc74-4e11-872f-f3fe219b003d', N'S013RTU03EQ001', N'S013RTU03EQ001D056', 1, 0, 53, 53, N'(Esc 1) Skirt panel safety switchalarm,upper right', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'706a8df4-a837-497b-8836-f642dba8ba76', N'S013RTU01EQ003', N'S013RTU01EQ003D001', 1, 0, 18, 18, N'LIFT STATUS', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DI', 1, 0, 19, 0, NULL, 1, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'3c6c6b3c-8b8f-4239-bfb8-f6c63b0fe333', N'S013RTU03EQ001', N'S013RTU03EQ001D055', 1, 0, 54, 54, N'(Esc 1) Skirt panel safety switchalarm,upper left', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'316e6c1b-7fe2-471c-b468-f85f8bf7265c', N'S013RTU03EQ001', N'S013RTU03EQ001D014', 1, 0, 61, 61, N'(Esc 1) Escalator Fault (DA)', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 0, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'6a6c5956-0ee3-4a2b-9a1e-fa6fae3bfd25', N'S013RTU01EQ003', N'S013RTU01EQ003D008', 1, 0, 1, 1, N'KEY SWITCH LIFT', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DI', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'fdf675c1-f0b4-4e2d-bbef-fb6c609dcfdd', N'S013RTU02EQ001', N'S013RTU02EQ001D009', 1, 0, 18, 18, N'Landing Door Open (LDO)', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'd584f25f-f375-477d-8f6e-fc8d1625228e', N'S013RTU03EQ001', N'S013RTU03EQ001D018', 1, 0, 24, 24, N'(Esc 1) Exceed permitted stopping distance alarm', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'4df8c361-71a4-4bfd-874c-fe19ab02789c', N'S013RTU03EQ001', N'S013RTU03EQ001D054', 1, 0, 55, 55, N'(Esc 1) Skirt panel safety switchalarm,middle left', N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_bitmap] ([col_bitmap_id], [col_equipment_id_fk], [col_device_id_fk], [col_is_monitor_by_device], [col_is_above64], [col_bit_start], [col_bit_end], [col_alarm_description], [col_operating_schedule_id_fk], [col_bit_type], [col_is_status_invert], [col_is_ifd_bit], [col_operation_hr], [col_mask], [col_analog_unit], [col_av_rpt], [is_itsc_alarm_activated]) VALUES (N'c78c5434-09a4-42b8-a655-ff3434da6734', N'S013RTU01EQ001', N'S013RTU01EQ001D014', 1, 1, 48, 48, N'DIMM 1 FAIL', N'E7D557BE-9DF6-4F2B-B098-BEFEAE774A7E', N'DA', 0, 0, 24, 0, NULL, 0, 0)
INSERT [dbo].[tbl_buildings] ([col_building_id], [col_address_code], [col_building_title], [col_address], [col_postal_code], [col_building_type], [col_asset_no], [col_lta_id], [col_iss_install_date], [col_is_active], [col_is_on_test]) VALUES (N'S013B001', N'S013', N'Bukit Merah Central', N'Bukit Merah Central / Linking Bus Interchange & NTUC', NULL, N'POB', N'242', N'52714', CAST(N'2022-04-24T22:17:10.223' AS DateTime), 1, 0)
INSERT [dbo].[tbl_buildings] ([col_building_id], [col_address_code], [col_building_title], [col_address], [col_postal_code], [col_building_type], [col_asset_no], [col_lta_id], [col_iss_install_date], [col_is_active], [col_is_on_test]) VALUES (N'S013B002', N'S013', N'Holland Road / Queensway / Farrer Road', N'Holland Road / Queensway / Farrer Road', NULL, N'POB', N'242', N'52714', CAST(N'2022-04-24T22:17:10.223' AS DateTime), 1, 0)
INSERT [dbo].[tbl_configs] ([col_config_id], [col_config_type], [col_is_active]) VALUES (N'78bebe73-4900-43fe-ae08-35f9ec82aae7', N'1-To-Many', 1)
INSERT [dbo].[tbl_configs] ([col_config_id], [col_config_type], [col_is_active]) VALUES (N'5a0d7014-f078-46b8-b1e1-c74cdcb686fa', N'Master-Slave', 1)
INSERT [dbo].[tbl_contract_users] ([col_contractor_company_id_fk], [col_contract_id_fk], [col_user_id_fk], [col_sms_role_id_fk], [col_sms_role_seq_no]) VALUES (N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', N'A21B086F-A084-4367-B992-C92EC1D85F79', N'082DEB74-E343-4E58-9763-89477AC448FF', N'BD6F2DB4-945C-4F09-87B2-FCE42A9615D0', 1)
INSERT [dbo].[tbl_contract_users] ([col_contractor_company_id_fk], [col_contract_id_fk], [col_user_id_fk], [col_sms_role_id_fk], [col_sms_role_seq_no]) VALUES (N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', N'A21B086F-A084-4367-B992-C92EC1D85F79', N'CDBC74A7-5317-4795-A6A4-8BA0D363D63C', N'F4E8E437-E05F-46B1-AF0B-DE40CCC70303', 2)
INSERT [dbo].[tbl_contract_users] ([col_contractor_company_id_fk], [col_contract_id_fk], [col_user_id_fk], [col_sms_role_id_fk], [col_sms_role_seq_no]) VALUES (N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', N'A21B086F-A084-4367-B992-C92EC1D85F79', N'A08A8AD4-850C-4DCC-898B-B577BB1FDADE', N'D2222674-2318-41FD-83D5-F387ED64A3AE', 3)
INSERT [dbo].[tbl_contract_users] ([col_contractor_company_id_fk], [col_contract_id_fk], [col_user_id_fk], [col_sms_role_id_fk], [col_sms_role_seq_no]) VALUES (N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', N'A21B086F-A084-4367-B992-C92EC1D85F79', N'8CDB9375-765A-489F-BE5B-52F5F9738EA4', N'8ADC2C85-E674-4047-B0B0-B11629B9588A', 4)
INSERT [dbo].[tbl_contract_users] ([col_contractor_company_id_fk], [col_contract_id_fk], [col_user_id_fk], [col_sms_role_id_fk], [col_sms_role_seq_no]) VALUES (N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', N'A21B086F-A084-4367-B992-C92EC1D85F79', N'F1463A18-7F27-4EB0-AD24-917A9DB605EC', N'8ADC2C85-E674-4047-B0B0-B11629B9588A', 4)
INSERT [dbo].[tbl_contract_users] ([col_contractor_company_id_fk], [col_contract_id_fk], [col_user_id_fk], [col_sms_role_id_fk], [col_sms_role_seq_no]) VALUES (N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', N'89BE2D96-D561-485A-B055-15E53D558C76', N'082DEB74-E343-4E58-9763-89477AC448FF', N'BD6F2DB4-945C-4F09-87B2-FCE42A9615D0', 1)
INSERT [dbo].[tbl_contract_users] ([col_contractor_company_id_fk], [col_contract_id_fk], [col_user_id_fk], [col_sms_role_id_fk], [col_sms_role_seq_no]) VALUES (N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', N'A21B086F-A084-4367-B992-C92EC1D85F79', N'372F3E6C-0527-48D1-BBE2-F076A5D9C1E1', N'E21DEC1A-2243-4968-9F47-F3DC59607F5D', 5)
INSERT [dbo].[tbl_contract_users] ([col_contractor_company_id_fk], [col_contract_id_fk], [col_user_id_fk], [col_sms_role_id_fk], [col_sms_role_seq_no]) VALUES (N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', N'A21B086F-A084-4367-B992-C92EC1D85F79', N'49B02BC8-1EFE-4622-BAD3-48673FF791F3', N'09D73372-DA78-4173-81C3-431245558EC2', 6)
INSERT [dbo].[tbl_contract_users] ([col_contractor_company_id_fk], [col_contract_id_fk], [col_user_id_fk], [col_sms_role_id_fk], [col_sms_role_seq_no]) VALUES (N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', N'A21B086F-A084-4367-B992-C92EC1D85F79', N'E9D03A99-DDEF-40C9-B81B-2126742E52DB', N'09D73372-DA78-4173-81C3-431245558EC2', 6)
INSERT [dbo].[tbl_contract_users] ([col_contractor_company_id_fk], [col_contract_id_fk], [col_user_id_fk], [col_sms_role_id_fk], [col_sms_role_seq_no]) VALUES (N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', N'89BE2D96-D561-485A-B055-15E53D558C76', N'CDBC74A7-5317-4795-A6A4-8BA0D363D63C', N'F4E8E437-E05F-46B1-AF0B-DE40CCC70303', 2)
INSERT [dbo].[tbl_contract_users] ([col_contractor_company_id_fk], [col_contract_id_fk], [col_user_id_fk], [col_sms_role_id_fk], [col_sms_role_seq_no]) VALUES (N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', N'89BE2D96-D561-485A-B055-15E53D558C76', N'A08A8AD4-850C-4DCC-898B-B577BB1FDADE', N'D2222674-2318-41FD-83D5-F387ED64A3AE', 3)
INSERT [dbo].[tbl_contract_users] ([col_contractor_company_id_fk], [col_contract_id_fk], [col_user_id_fk], [col_sms_role_id_fk], [col_sms_role_seq_no]) VALUES (N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', N'89BE2D96-D561-485A-B055-15E53D558C76', N'8CDB9375-765A-489F-BE5B-52F5F9738EA4', N'8ADC2C85-E674-4047-B0B0-B11629B9588A', 4)
INSERT [dbo].[tbl_contract_users] ([col_contractor_company_id_fk], [col_contract_id_fk], [col_user_id_fk], [col_sms_role_id_fk], [col_sms_role_seq_no]) VALUES (N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', N'89BE2D96-D561-485A-B055-15E53D558C76', N'F1463A18-7F27-4EB0-AD24-917A9DB605EC', N'8ADC2C85-E674-4047-B0B0-B11629B9588A', 4)
INSERT [dbo].[tbl_contract_users] ([col_contractor_company_id_fk], [col_contract_id_fk], [col_user_id_fk], [col_sms_role_id_fk], [col_sms_role_seq_no]) VALUES (N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', N'89BE2D96-D561-485A-B055-15E53D558C76', N'372F3E6C-0527-48D1-BBE2-F076A5D9C1E1', N'E21DEC1A-2243-4968-9F47-F3DC59607F5D', 5)
INSERT [dbo].[tbl_contract_users] ([col_contractor_company_id_fk], [col_contract_id_fk], [col_user_id_fk], [col_sms_role_id_fk], [col_sms_role_seq_no]) VALUES (N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', N'89BE2D96-D561-485A-B055-15E53D558C76', N'49B02BC8-1EFE-4622-BAD3-48673FF791F3', N'09D73372-DA78-4173-81C3-431245558EC2', 6)
INSERT [dbo].[tbl_contract_users] ([col_contractor_company_id_fk], [col_contract_id_fk], [col_user_id_fk], [col_sms_role_id_fk], [col_sms_role_seq_no]) VALUES (N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', N'89BE2D96-D561-485A-B055-15E53D558C76', N'E9D03A99-DDEF-40C9-B81B-2126742E52DB', N'09D73372-DA78-4173-81C3-431245558EC2', 6)
INSERT [dbo].[tbl_contractor_company] ([col_contractor_company_id], [col_company_name], [col_contractor_company_code], [col_company_address], [col_is_active]) VALUES (N'3f889ebf-4b3b-4197-988a-04c0378267e2', N'ATS', N'ATS', N' ', 1)
INSERT [dbo].[tbl_contractor_company] ([col_contractor_company_id], [col_company_name], [col_contractor_company_code], [col_company_address], [col_is_active]) VALUES (N'e4c8865b-df85-4ea7-891e-04cad4af5d06', N'Fonda', N'FON', N' ', 1)
INSERT [dbo].[tbl_contractor_company] ([col_contractor_company_id], [col_company_name], [col_contractor_company_code], [col_company_address], [col_is_active]) VALUES (N'c9c75831-46b7-48c5-82cc-0b85ba2cd60c', N'Chevalier', N'CHE', N'BLK 344 JURONG EAST STREET 31 #01-43 ( 600344 )', 1)
INSERT [dbo].[tbl_contractor_company] ([col_contractor_company_id], [col_company_name], [col_contractor_company_code], [col_company_address], [col_is_active]) VALUES (N'68db7b96-1c83-4aaa-bfbd-0e2485aa8c8b', N'GIMS', N'GIM', N'GIMS', 1)
INSERT [dbo].[tbl_contractor_company] ([col_contractor_company_id], [col_company_name], [col_contractor_company_code], [col_company_address], [col_is_active]) VALUES (N'cba24851-892b-43e3-ac11-170cc2d8bac7', N'STPL', N'STP', N'Temporary contract', 1)
INSERT [dbo].[tbl_contractor_company] ([col_contractor_company_id], [col_company_name], [col_contractor_company_code], [col_company_address], [col_is_active]) VALUES (N'422e437b-f650-46a0-8c43-280668110dd8', N'Guthrie', N'GUT', N'NULL', 1)
INSERT [dbo].[tbl_contractor_company] ([col_contractor_company_id], [col_company_name], [col_contractor_company_code], [col_company_address], [col_is_active]) VALUES (N'c2a52928-04de-4436-b252-382d09a55bf3', N'XJ', N'XJ ', N'NULL', 1)
INSERT [dbo].[tbl_contractor_company] ([col_contractor_company_id], [col_company_name], [col_contractor_company_code], [col_company_address], [col_is_active]) VALUES (N'68f64181-ba08-41f0-bed2-52f52e79bb04', N'9G', N'9G ', N'105 Sims Avenue #09-08 Chancerlodge Complex S387429', 1)
INSERT [dbo].[tbl_contractor_company] ([col_contractor_company_id], [col_company_name], [col_contractor_company_code], [col_company_address], [col_is_active]) VALUES (N'057ec97e-0eb0-40a2-8ea2-643d80f79813', N'SemiTech', N'SEM', N'', 1)
INSERT [dbo].[tbl_contractor_company] ([col_contractor_company_id], [col_company_name], [col_contractor_company_code], [col_company_address], [col_is_active]) VALUES (N'2568d530-c03a-48d0-91d2-70ed2cd2feeb', N'DE108A-KSH', N'DE1', N'DE108A-KSH', 1)
INSERT [dbo].[tbl_contractor_company] ([col_contractor_company_id], [col_company_name], [col_contractor_company_code], [col_company_address], [col_is_active]) VALUES (N'5606c94e-6633-4e10-a588-a8cedcea4914', N'SquireMech', N'SQU', N'SquireMech', 1)
INSERT [dbo].[tbl_contractor_company] ([col_contractor_company_id], [col_company_name], [col_contractor_company_code], [col_company_address], [col_is_active]) VALUES (N'356f57c1-1870-426e-a35f-aed51b48bc37', N'DUMMY', N'DUM', N'DUMMY CONTRACTOR', 1)
INSERT [dbo].[tbl_contractor_company] ([col_contractor_company_id], [col_company_name], [col_contractor_company_code], [col_company_address], [col_is_active]) VALUES (N'31f1be2c-af0d-4aa6-bed7-c31f5838c27a', N'Surbana', N'SUR', N'NULL', 1)
INSERT [dbo].[tbl_contractor_company] ([col_contractor_company_id], [col_company_name], [col_contractor_company_code], [col_company_address], [col_is_active]) VALUES (N'f58a252d-e839-41aa-b9d1-c889b86fbedf', N'DE108A-KSH-KONE', N'DE2', N'DE108-AKSH-KONE', 1)
INSERT [dbo].[tbl_contractor_company] ([col_contractor_company_id], [col_company_name], [col_contractor_company_code], [col_company_address], [col_is_active]) VALUES (N'400a926e-a7c1-4e0e-8017-e607d07a7ee5', N'Kone', N'KON', N'Kone', 1)
INSERT [dbo].[tbl_contractor_company] ([col_contractor_company_id], [col_company_name], [col_contractor_company_code], [col_company_address], [col_is_active]) VALUES (N'ac2c1d63-9bf5-4601-8e9b-f06d7b582500', N'OTIS', N'OTI', N'', 1)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'bc65f6e0-99ff-4915-8076-c3575edb3d50', N'D18716', N'68DB7B96-1C83-4AAA-BFBD-0E2485AA8C8B', CAST(N'2020-10-22T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 1, 1, 2)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'94189b64-b601-4e5d-afac-5bdbbbe533be', N'DE108A-KSH', N'2568D530-C03A-48D0-91D2-70ED2CD2FEEB', CAST(N'2020-12-13T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 1, 1, 2)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'128efbe6-8baf-4d75-b162-468b8a9a73cc', N'DE108A-KSH-KONE', N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', CAST(N'2020-12-13T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 1, 1, 24)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'e5c511c7-2317-4657-863a-559efce9b4e1', N'ER365', N'C2A52928-04DE-4436-B252-382D09A55BF3', CAST(N'1900-01-01T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 1, 1, 24)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'8f755640-2740-416c-ad6a-a55403d0f32b', N'ER382', N'057EC97E-0EB0-40A2-8EA2-643D80F79813', CAST(N'2018-10-17T00:00:00.000' AS DateTime), CAST(N'2020-12-01T00:00:00.000' AS DateTime), 1, 1, 2)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'19b3ca25-aee8-4ab6-a49c-8a9374214013', N'ER439', N'C9C75831-46B7-48C5-82CC-0B85BA2CD60C', CAST(N'1900-01-01T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 1, 1, 24)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'93bf0a5a-3b15-4a38-b14f-e65e3604a865', N'RP191', N'C2A52928-04DE-4436-B252-382D09A55BF3', CAST(N'1900-01-01T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 0, 1, 24)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'cd3ab7c6-ffcc-4f87-965a-ca0340dca1fc', N'RP225A', N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', CAST(N'2019-06-01T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 1, 1, 24)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'885a9faa-d766-4619-b966-a1beafadf5f9', N'RP260C', N'422E437B-F650-46A0-8C43-280668110DD8', CAST(N'1900-01-01T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 0, 1, 2)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'7c30bfdb-bf5e-4571-8c16-741f1dc36aee', N'RP260E', N'3F889EBF-4B3B-4197-988A-04C0378267E2', CAST(N'1900-01-01T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 0, 1, 2)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'ebc636e7-bb2f-441b-95ab-25d45db8e0fd', N'RP260N', N'E4C8865B-DF85-4EA7-891E-04CAD4AF5D06', CAST(N'1900-01-01T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 0, 1, 2)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'9e65bf39-637f-4c8f-aa44-895c95684278', N'RP260W', N'E4C8865B-DF85-4EA7-891E-04CAD4AF5D06', CAST(N'1900-01-01T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 0, 1, 2)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'63fd9ad9-6d68-4ba4-af28-7885e2f36f6f', N'STPL01', N'CBA24851-892B-43E3-AC11-170CC2D8BAC7', CAST(N'2018-07-16T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 1, 1, 2)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'1aeda0bd-16ca-4f10-9fde-9860a5df3f3a', N'STPLD', N'356F57C1-1870-426E-A35F-AED51B48BC37', CAST(N'2020-12-01T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 1, 0, 0)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'6a223d83-256c-490d-bc5a-42c1667d0021', N'T271A', N'AC2C1D63-9BF5-4601-8E9B-F06D7B582500', CAST(N'2019-12-01T00:00:00.000' AS DateTime), CAST(N'2020-05-31T00:00:00.000' AS DateTime), 0, 1, 24)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'38dbae2f-fcf8-4ebf-bf69-8f040a3fdc4a', N'T371A', N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', CAST(N'2020-12-17T00:00:00.000' AS DateTime), CAST(N'2024-12-31T00:00:00.000' AS DateTime), 0, 1, 7)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'2deacf58-7831-48ca-83cc-c5a46dedc5b4', N'TR118', N'68F64181-BA08-41F0-BED2-52F52E79BB04', CAST(N'1900-01-01T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 0, 1, 24)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'ea19adfa-d45c-481f-abf8-74c85bee52e7', N'TR255', N'31F1BE2C-AF0D-4AA6-BED7-C31F5838C27A', CAST(N'1900-01-01T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 1, 1, 24)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'10e598b4-3632-46ab-8dc9-d4bf5d486769', N'TR287', N'C2A52928-04DE-4436-B252-382D09A55BF3', CAST(N'1900-01-01T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 1, 1, 24)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'5ea1ad50-8759-42e0-a89d-a8b428f65a74', N'TR302C', N'E4C8865B-DF85-4EA7-891E-04CAD4AF5D06', CAST(N'2019-06-01T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 1, 1, 2)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'85927fe6-d57d-41e9-8fdc-ea29748ee5ad', N'TR302E', N'3F889EBF-4B3B-4197-988A-04C0378267E2', CAST(N'2019-06-01T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 1, 1, 2)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'e5d4beda-edc3-47cf-8430-162a49a6830b', N'TR302N', N'422E437B-F650-46A0-8C43-280668110DD8', CAST(N'2019-06-01T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 1, 1, 2)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'4ea4458e-3ca2-4a4e-b14d-5ea190cb1bc8', N'TR302W', N'E4C8865B-DF85-4EA7-891E-04CAD4AF5D06', CAST(N'2019-06-01T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 1, 1, 2)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'0bf9e24b-36d2-44a1-8aa2-21c9606fcb32', N'TR329', N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', CAST(N'2019-06-15T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 1, 1, 24)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'c6c72a16-d84e-4056-837e-296f3215df03', N'TR360', N'AC2C1D63-9BF5-4601-8E9B-F06D7B582500', CAST(N'2020-06-01T00:00:00.000' AS DateTime), CAST(N'2022-12-31T00:00:00.000' AS DateTime), 1, 0, 24)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'a21b086f-a084-4367-b992-c92ec1d85f79', N'TR389', N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', CAST(N'2022-03-01T00:00:00.000' AS DateTime), CAST(N'2027-12-31T00:00:00.000' AS DateTime), 1, 1, 7)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'89be2d96-d561-485a-b055-15e53d558c76', N'TR390', N'400A926E-A7C1-4E0E-8017-E607D07A7EE5', CAST(N'2022-03-01T00:00:00.000' AS DateTime), CAST(N'2027-12-31T00:00:00.000' AS DateTime), 1, 1, 7)
INSERT [dbo].[tbl_contracts] ([col_contract_id], [col_contract_nbr], [col_contractor_company_id_fk], [col_contract_start], [col_contract_end], [col_is_contract_valid], [col_response_hr], [col_repair_hr]) VALUES (N'896b1353-0e11-4b50-87c5-3c1246b57322', N'UNKNOWN', N'5606C94E-6633-4E10-A588-A8CEDCEA4914', CAST(N'2018-11-01T00:00:00.000' AS DateTime), CAST(N'2019-12-31T00:00:00.000' AS DateTime), 1, 1, 2)
INSERT [dbo].[tbl_device_category] ([col_device_category_id], [col_device_category_title], [col_equipment_group_id_fk], [col_is_active]) VALUES (N'16eeb431-7a8a-47f0-b0d5-3470732bebb6', N'ELECTRICAL', N'3D40D3E0-3357-4136-AE63-06998D94C43A', 1)
INSERT [dbo].[tbl_device_category] ([col_device_category_id], [col_device_category_title], [col_equipment_group_id_fk], [col_is_active]) VALUES (N'dbee28d0-fa8f-49bc-8c85-048a88911b95', N'MECHPUMP', N'3D40D3E0-3357-4136-AE63-06998D94C43A', 1)
INSERT [dbo].[tbl_device_category] ([col_device_category_id], [col_device_category_title], [col_equipment_group_id_fk], [col_is_active]) VALUES (N'14c49177-021b-4141-912f-b83f92aa9a57', N'DVRCAMERA', N'A5FAD96D-BCAA-4541-A6A0-1753D3E8A227', 1)
INSERT [dbo].[tbl_device_category] ([col_device_category_id], [col_device_category_title], [col_equipment_group_id_fk], [col_is_active]) VALUES (N'37db5642-83c8-43ab-9bb4-eabdaf5c90d0', N'ESCALATOR', N'A826F9F0-315A-450A-A18A-2F0EC0ED2442', 1)
INSERT [dbo].[tbl_device_category] ([col_device_category_id], [col_device_category_title], [col_equipment_group_id_fk], [col_is_active]) VALUES (N'e9eda476-fc54-412d-a75a-0d914a5784a0', N'UPSRTU', N'A5FAD96D-BCAA-4541-A6A0-1753D3E8A227', 1)
INSERT [dbo].[tbl_device_category] ([col_device_category_id], [col_device_category_title], [col_equipment_group_id_fk], [col_is_active]) VALUES (N'51bfedbf-7824-42ec-a6ce-cb7cc84997fa', N'LIFT', N'DD34DB2B-86CD-4390-ABA6-2D45540E6CD0', 1)
INSERT [dbo].[tbl_device_category] ([col_device_category_id], [col_device_category_title], [col_equipment_group_id_fk], [col_is_active]) VALUES (N'c84a84c9-6b5d-4c1f-9f26-3641f1dcd062', N'LIFT DVR', N'DD34DB2B-86CD-4390-ABA6-2D45540E6CD0', 1)
INSERT [dbo].[tbl_device_identfication_group] ([col_device_identification_group_id], [col_device_identfication_group_title]) VALUES (N'b168f9c6-2c53-4aca-ab2d-9e1eee279f26', N'CCTV')
INSERT [dbo].[tbl_device_identfication_group] ([col_device_identification_group_id], [col_device_identfication_group_title]) VALUES (N'ae951838-b656-44d4-a61d-73ebf5176107', N'ESCALATOR')
INSERT [dbo].[tbl_device_identfication_group] ([col_device_identification_group_id], [col_device_identfication_group_title]) VALUES (N'bd708297-fa3b-49d3-a510-c084609c13b0', N'RTU KEY')
INSERT [dbo].[tbl_device_identfication_group] ([col_device_identification_group_id], [col_device_identfication_group_title]) VALUES (N'38897aee-0f44-4dd8-9597-47cd20d922b8', N'LIFT')
INSERT [dbo].[tbl_device_identfication_group] ([col_device_identification_group_id], [col_device_identfication_group_title]) VALUES (N'832eb740-d240-4372-a9e2-47b36f395319', N'LIGHTING')
INSERT [dbo].[tbl_device_identfication_group] ([col_device_identification_group_id], [col_device_identfication_group_title]) VALUES (N'697b70d0-402a-46f9-b342-14befbbce02e', N'ELECTRICAL')
INSERT [dbo].[tbl_device_identfication_group] ([col_device_identification_group_id], [col_device_identfication_group_title]) VALUES (N'5cfeabae-3c8c-4f00-9e9c-bb950a9267b3', N'RTU')
INSERT [dbo].[tbl_device_identfication_group] ([col_device_identification_group_id], [col_device_identfication_group_title]) VALUES (N'5f016081-f48e-4f9f-8296-136e37a4ba63', N'DIMM')
INSERT [dbo].[tbl_device_identfication_group] ([col_device_identification_group_id], [col_device_identfication_group_title]) VALUES (N'7b567968-41aa-4031-a8fd-a1f8341baefe', N'KEY SWITCH')
INSERT [dbo].[tbl_device_identification_letter] ([col_device_identification_letter_id], [col_device_identification_letter_title], [col_device_identification_group_id_fk], [col_is_active]) VALUES (N'42cec7cb-dfd9-4b95-a321-6d1bad219950', N'CCTV', N'b168f9c6-2c53-4aca-ab2d-9e1eee279f26', 1)
INSERT [dbo].[tbl_device_identification_letter] ([col_device_identification_letter_id], [col_device_identification_letter_title], [col_device_identification_group_id_fk], [col_is_active]) VALUES (N'd8c17170-24b0-47c5-a4ad-9f484b58784b', N'Esc E1', N'ae951838-b656-44d4-a61d-73ebf5176107', 1)
INSERT [dbo].[tbl_device_identification_letter] ([col_device_identification_letter_id], [col_device_identification_letter_title], [col_device_identification_group_id_fk], [col_is_active]) VALUES (N'891269fe-87cd-4ad7-850f-5e46200dcf33', N'RTU KEY', N'7b567968-41aa-4031-a8fd-a1f8341baefe', 1)
INSERT [dbo].[tbl_device_identification_letter] ([col_device_identification_letter_id], [col_device_identification_letter_title], [col_device_identification_group_id_fk], [col_is_active]) VALUES (N'b4cf701a-e5c7-45f8-8c59-18c7e801ba65', N'LIFT 1', N'38897aee-0f44-4dd8-9597-47cd20d922b8', 1)
INSERT [dbo].[tbl_device_identification_letter] ([col_device_identification_letter_id], [col_device_identification_letter_title], [col_device_identification_group_id_fk], [col_is_active]) VALUES (N'7fef50f8-a3ab-449d-8c67-0a9316b6539b', N'LIGHT 1', N'832eb740-d240-4372-a9e2-47b36f395319', 1)
INSERT [dbo].[tbl_device_identification_letter] ([col_device_identification_letter_id], [col_device_identification_letter_title], [col_device_identification_group_id_fk], [col_is_active]) VALUES (N'435399be-ef3e-42c7-8981-0d32037dcdde', N'LIGHT 2', N'832eb740-d240-4372-a9e2-47b36f395319', 1)
INSERT [dbo].[tbl_device_identification_letter] ([col_device_identification_letter_id], [col_device_identification_letter_title], [col_device_identification_group_id_fk], [col_is_active]) VALUES (N'9d1d4a91-62d6-4780-9295-1216a34e044b', N'LIGHT 3', N'832eb740-d240-4372-a9e2-47b36f395319', 1)
INSERT [dbo].[tbl_device_identification_letter] ([col_device_identification_letter_id], [col_device_identification_letter_title], [col_device_identification_group_id_fk], [col_is_active]) VALUES (N'8e153e8e-69c3-4104-9288-b516d25d49ec', N'LIGHTING', N'697b70d0-402a-46f9-b342-14befbbce02e', 1)
INSERT [dbo].[tbl_device_identification_letter] ([col_device_identification_letter_id], [col_device_identification_letter_title], [col_device_identification_group_id_fk], [col_is_active]) VALUES (N'f26c2266-7210-49fb-9a88-7172052aaff7', N'ELECTRICAL', N'697b70d0-402a-46f9-b342-14befbbce02e', 1)
INSERT [dbo].[tbl_device_identification_letter] ([col_device_identification_letter_id], [col_device_identification_letter_title], [col_device_identification_group_id_fk], [col_is_active]) VALUES (N'e09276e6-4db1-4978-8fbd-5fd85096a07c', N'DIMM 1', N'5f016081-f48e-4f9f-8296-136e37a4ba63', 1)
INSERT [dbo].[tbl_device_identification_letter] ([col_device_identification_letter_id], [col_device_identification_letter_title], [col_device_identification_group_id_fk], [col_is_active]) VALUES (N'20767c84-1aac-41c7-a705-3ecbca1c73d0', N'DIMM 2', N'5f016081-f48e-4f9f-8296-136e37a4ba63', 1)
INSERT [dbo].[tbl_device_identification_letter] ([col_device_identification_letter_id], [col_device_identification_letter_title], [col_device_identification_group_id_fk], [col_is_active]) VALUES (N'fb82c5c1-e510-4845-84bd-d0deaf907566', N'RTU', N'5cfeabae-3c8c-4f00-9e9c-bb950a9267b3', 1)
INSERT [dbo].[tbl_device_identification_letter] ([col_device_identification_letter_id], [col_device_identification_letter_title], [col_device_identification_group_id_fk], [col_is_active]) VALUES (N'9c4c6f5a-9db1-4994-a410-a0dd46f3c266', N'M&E KEY', N'7b567968-41aa-4031-a8fd-a1f8341baefe', 1)
INSERT [dbo].[tbl_device_identification_letter] ([col_device_identification_letter_id], [col_device_identification_letter_title], [col_device_identification_group_id_fk], [col_is_active]) VALUES (N'58431c40-91e4-4dfa-87b0-091e5c8c2be7', N'ESCALATOR KEY', N'ae951838-b656-44d4-a61d-73ebf5176107', 1)
INSERT [dbo].[tbl_device_identification_letter] ([col_device_identification_letter_id], [col_device_identification_letter_title], [col_device_identification_group_id_fk], [col_is_active]) VALUES (N'd9b740a4-4402-4cd6-a571-8ab3e1c24c62', N'LIFT KEY', N'38897aee-0f44-4dd8-9597-47cd20d922b8', 1)
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'd8758af3-9fb6-4818-8e09-03ca41be9622', N'A490FFE4-8D55-4A45-AA44-43FC83DB80D3', N'MSWB')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'7ebf5446-0882-499a-829b-09834fb2a143', N'11098184-6C5A-4482-AB58-779452F7D1D2', N'Tunnel Light')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'69a4f1d8-0cba-4b12-b063-15d0e136a8fc', N'7463C496-C80F-47AD-BB7B-A0DB3AA949F7', N'ME KEY')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'9130f885-f632-4a32-a785-1612c2031bd1', N'1625E12E-CB09-4867-AAA4-FDB19FBDAF6A', N'RTU KEY')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'1b2c93b7-628b-468d-ad97-18fb37e9920b', N'40C86DF0-5B75-4D05-82AB-DEC97444A031', N'Main Switch Board')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'22df63a1-0159-42db-9f21-1dd1691d7305', N'27F4BEA7-DAFC-4B85-B1AE-DDA245953D67', N'Fire Alarm')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'f6c71321-9c9c-48dc-aa3a-2a51f6c2862a', N'62E1F911-47ED-4470-A9BC-2F485E01B18A', N'Main Switch Board')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'aa501bd6-778f-4eb4-adfd-2b47229f7d43', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'Escalator')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'2841735e-656d-4749-9d11-2f62adc9bd19', N'C7AAF0A2-3C59-4393-946D-7268B71806BC', N'Digital Video Recorder')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'c7814e15-fd83-47bd-92ab-337337479521', N'D52A9DEB-F348-4002-BB08-93C3BAE2E845', N'ACK Indicator')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'ffe3ead9-26c9-4dda-b737-3ac2e8cae9ab', N'5ADECD77-3282-4CE7-9E31-EC2D4A97CACA', N'LT Room')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'9f97e5b4-986e-4be3-8475-3ec1be10cf88', N'B8402674-1C9F-43ED-A6F7-5539CF8F4565', N'Earth Leakage Circuit Breaker')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'2205f1f7-48d0-490d-851d-49f418df3b81', N'0CA65F2F-B772-403E-8454-BD111882F670', N'Sump Pump')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'd6d0b621-a180-42be-9178-537aead5ff7c', N'0CA65F2F-B772-403E-8454-BD111882F670', N'Dewater Pump')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'0237f9d6-1513-4c11-a346-547d4c8f7a01', N'8AB106B5-A479-442A-AE77-5AB3AED315C3', N'Electrical Distribution Board')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'30bf3565-48f6-49c5-afec-556acb19aa5e', N'A3F9A91E-B0F4-49E5-AC25-6121A6ABE9BE', N'Digital Video Recorder')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'7b04b349-b6a3-407a-b7f3-57a95f326685', N'287A6A4F-580D-405C-BC90-195A22F30432', N'Main Switch Board')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'9bdf64d9-5320-4ed1-b82b-58901688d1a3', N'E32378CB-468E-4218-B2F1-19D43A239DEB', N'Light')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'a819b726-2018-46c7-8ab6-5a524399c934', N'032A1811-3A17-4DF5-AFCA-58CC4EE6B5E6', N'Fan')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'452d985c-0622-4bfa-b8c6-60dc4717476d', N'A92BCAC3-09BB-4E38-AA5E-665578F160AF', N'Pump')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'ce9d2813-c347-4de3-8cc7-664cd9addadc', N'B1B849D0-763A-46BE-BFBC-2ACD41323843', N'Air Circuit Breaker')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'00ad53b0-6f40-488d-b4fb-672d4d567712', N'3EED7123-7282-4255-AE17-84A4F7DEFBAD', N'Reserved')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'fbc8e74d-df55-41ee-911c-6a00b6986464', N'23985D84-6CA6-4F4B-A104-C1CBFABEDD1D', N'Ramp Light')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'a731340a-ac8f-4d9f-a81e-6ae9fcf789c3', N'032A1811-3A17-4DF5-AFCA-58CC4EE6B5E6', N'Exhaust Fan')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'2bade5bb-6704-40c1-a442-6d33c95576ef', N'80C93DA3-13D5-4FA5-A343-3A43A8697D69', N'UPS')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'ea6fb80f-48b7-4c10-9a4b-828ddeea4317', N'C151404A-99F7-4E45-A9A9-DDBDB7FEDB4B', N'Air-Conditioning & Mechanical Ventilation Systems')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'8e11ea66-f7d1-4195-ae15-876d493ed91b', N'53FCCFBC-BD55-47FD-9B67-147D4F85C69D', N'RTU')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'923798ba-530a-4252-a5f5-88060cc27af5', N'EC87DDA5-9924-49E4-9AE0-7F4CDD778420', N'Pump')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'de612a50-b975-49d2-a7bb-8a54b7926fda', N'5E3464FB-C721-4C92-BC74-B9CEC07D9EF2', N'Stairlift')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'3546843e-22ce-4e6c-8eec-8f846a0bdd59', N'7B30A030-EDF5-469F-BC86-9832E4897719', N'Light Long')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'dcd85d5a-e5fd-4c0f-937c-9409fe3d7cb6', N'F6B42A17-1AAC-4569-8995-5437BFB464ED', N'Ventilation')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'cd326c00-ae60-4e18-a8b5-99bfbd6fc86f', N'81850B41-FA34-4D23-8DD9-00487051B985', N'Moulded Case Circuit Breaker')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'99cf39c2-ce33-4970-af4f-9c5d6e313780', N'0CA65F2F-B772-403E-8454-BD111882F670', N'Drain Pump')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'084f3513-b256-4bd8-a5a3-9e7fcb67c570', N'E6732624-441F-4827-BA11-2A4930876C75', N'LIFT KEY')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'8d797d2d-bd0b-4a95-8ee2-9fbb977dfb94', N'840719F6-A89F-48C5-B2B9-E56AC8C0B3C6', N'Miniature Circuit Breaker')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'3600d090-5db8-4353-8778-aa4ed5c26409', N'0CA65F2F-B772-403E-8454-BD111882F670', N'Sump Pit')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'c2cd797f-0976-4238-8f95-ab6b7a1e4517', N'55424383-20B3-49DE-84F7-88B221913DDC', N'Miscellaneous')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'9b98c95c-8e5a-4940-901c-b44f6d5f7ee4', N'0CA65F2F-B772-403E-8454-BD111882F670', N'Standby Pump')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'fcce2cd2-cb1a-487e-b293-b888617acac6', N'E0B8FD8C-CD3F-4629-BBDD-4AA3C9ADF14D', N'ESC KEY')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'a5b7ab70-09c3-4b7b-99f7-bdddf213982b', N'057DFF0F-F6A5-4EE0-9C7D-81BE753D377D', N'Light Short')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'46177465-6da7-47c6-bb12-d49a161d704b', N'E66B406F-E2B0-46B6-A96C-3367D6D9ABBF', N'Power')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'6632366d-3ba6-4d32-bb15-dbd0c8c95798', N'F4C9AE31-279C-427C-B83C-74080A31F98D', N'Residual Current Circuit Breaker')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'98d779a1-d547-4267-b8bd-dd476770597f', N'0CA65F2F-B772-403E-8454-BD111882F670', N'Storage Pump')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'bfcc5347-8625-4af8-9169-e61680b09b59', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'Lift')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'ecd58fe1-4170-4ba2-8f8b-ef0a2bb5bebe', N'0CA65F2F-B772-403E-8454-BD111882F670', N'Duty Pump')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'ba8481e2-ac1c-489f-b7eb-f261ce2cb1fc', N'3060E2A3-996F-4754-BFC2-EF56073C73CE', N'Main Outgoing Supply')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'b1ccac0b-72e6-4935-b94d-f2cc7d14aedb', N'0CA65F2F-B772-403E-8454-BD111882F670', N'Pump')
INSERT [dbo].[tbl_device_sub_type] ([col_device_sub_type_id], [col_device_type_id_fk], [col_device_sub_type_title]) VALUES (N'ba43d668-22b4-49fc-995d-f7b7c69b3a4c', N'68CDDC3E-BB10-468F-8A86-8A332810DEC3', N'Diesel Electric Generator')
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'd52a9deb-f348-4002-bb08-93c3bae2e845', N'ACK INDICATOR', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'c151404a-99f7-4e45-a9a9-ddbdb7fedb4b', N'ACMV', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'8ab106b5-a479-442a-ae77-5ab3aed315c3', N'DB', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'0ca65f2f-b772-403e-8454-bd111882f670', N'PUMP', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'c7aaf0a2-3c59-4393-946d-7268b71806bc', N'DVR', N'14C49177-021B-4141-912F-B83F92AA9A57', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'b8402674-1c9f-43ed-a6f7-5539cf8f4565', N'ELCB', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'9e065ce8-7083-4c41-ac26-4638b0bdcfee', N'ESCALATOR', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'032a1811-3a17-4df5-afca-58cc4ee6b5e6', N'FAN', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'68cddc3e-bb10-468f-8a86-8a332810dec3', N'GENSET ELECTRICAL', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'1625e12e-cb09-4867-aaa4-fdb19fbdaf6a', N'KEY SWITCH STATUS (RTU)', N'E9EDA476-FC54-412D-A75A-0D914A5784A0', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'c24007ff-2db4-4b95-90fe-b9c8ff5d7018', N'LIFT', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'e32378cb-468e-4218-b2f1-19d43a239deb', N'LIGHT', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'5adecd77-3282-4ce7-9e31-ec2d4a97caca', N'LT ROOM', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'840719f6-a89f-48c5-b2b9-e56ac8c0b3c6', N'MCB', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'287a6a4f-580d-405c-bc90-195a22f30432', N'MSB', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'40c86df0-5b75-4d05-82ab-dec97444a031', N'MSB OG', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'a490ffe4-8d55-4a45-aa44-43fc83db80d3', N'MSWB', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'e66b406f-e2b0-46b6-a96c-3367d6d9abbf', N'POWER', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'a92bcac3-09bb-4e38-aa5e-665578f160af', N'PU', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'23985d84-6ca6-4f4b-a104-c1cbfabedd1d', N'RAMP LIGHT', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'53fccfbc-bd55-47fd-9b67-147d4f85c69d', N'RTU', N'E9EDA476-FC54-412D-A75A-0D914A5784A0', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'5e3464fb-c721-4c92-bc74-b9cec07d9ef2', N'STAIRLIFT', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'11098184-6c5a-4482-ab58-779452f7d1d2', N'TUNNEL LIGHT', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'80c93da3-13d5-4fa5-a343-3a43a8697d69', N'UPS', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'f6b42a17-1aac-4569-8995-5437bfb464ed', N'VENTILATION', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'7463c496-c80f-47ad-bb7b-a0db3aa949f7', N'KEY SWITCH STATUS (ME)', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'e0b8fd8c-cd3f-4629-bbdd-4aa3c9adf14d', N'KEY SWITCH STATUS (ESC)', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'e6732624-441f-4827-ba11-2a4930876c75', N'KEY SWITCH STATUS (LIFT)', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'a3f9a91e-b0f4-49e5-ac25-6121a6abe9be', N'LIFT DVR', N'C84A84C9-6B5D-4C1F-9F26-3641F1DCD062', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'7b30a030-edf5-469f-bc86-9832e4897719', N'LIGHT LONG', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'057dff0f-f6a5-4ee0-9c7d-81be753d377d', N'LIGHT SHORT', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'b1b849d0-763a-46be-bfbc-2acd41323843', N'ACB', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'f4c9ae31-279c-427c-b83c-74080a31f98d', N'RCCB', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'ec87dda5-9924-49e4-9ae0-7f4cdd778420', N'ANTI-MALARIA', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'27f4bea7-dafc-4b85-b1ae-dda245953d67', N'FIRE ALARM', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'3060e2a3-996f-4754-bfc2-ef56073c73ce', N'MAIN OG', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'81850b41-fa34-4d23-8dd9-00487051b985', N'MCCB', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'62e1f911-47ed-4470-a9bc-2f485e01b18a', N'MSCB', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'55424383-20b3-49de-84f7-88b221913ddc', N'MISC', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'3eed7123-7282-4255-ae17-84a4f7defbad', N'RESERVED', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', 1)
INSERT [dbo].[tbl_device_type] ([col_device_type_id], [col_device_type_title], [col_device_category_id_fk], [col_is_active]) VALUES (N'1500c205-7710-4cf1-897d-c23a551bff84', N'GENSET MECHPUMP', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ001D001', N'S013RTU01EQ001', N'MAIN INCOMING R- PHASE TRIP', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'E66B406F-E2B0-46B6-A96C-3367D6D9ABBF', N'46177465-6DA7-47C6-BB12-D49A161D704B', N'697b70d0-402a-46f9-b342-14befbbce02e', N'F26C2266-7210-49FB-9A88-7172052AAFF7', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ001D002', N'S013RTU01EQ001', N'MAIN INCOMING Y- PHASE TRIP', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'E66B406F-E2B0-46B6-A96C-3367D6D9ABBF', N'46177465-6DA7-47C6-BB12-D49A161D704B', N'697b70d0-402a-46f9-b342-14befbbce02e', N'F26C2266-7210-49FB-9A88-7172052AAFF7', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ001D003', N'S013RTU01EQ001', N'MAIN INCOMING B-PHASE TRIP', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'E66B406F-E2B0-46B6-A96C-3367D6D9ABBF', N'46177465-6DA7-47C6-BB12-D49A161D704B', N'697b70d0-402a-46f9-b342-14befbbce02e', N'F26C2266-7210-49FB-9A88-7172052AAFF7', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ001D004', N'S013RTU01EQ001', N'LIGHTING 1 STATUS', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'E32378CB-468E-4218-B2F1-19D43A239DEB', N'9BDF64D9-5320-4ED1-B82B-58901688D1A3', N'832eb740-d240-4372-a9e2-47b36f395319', N'7FEF50F8-A3AB-449D-8C67-0A9316B6539B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ001D005', N'S013RTU01EQ001', N'LIGHTING 2 STATUS', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'E32378CB-468E-4218-B2F1-19D43A239DEB', N'9BDF64D9-5320-4ED1-B82B-58901688D1A3', N'832EB740-D240-4372-A9E2-47B36F395319', N'435399BE-EF3E-42C7-8981-0D32037DCDDE', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ001D006', N'S013RTU01EQ001', N'LIGHTING 3 STATUS', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'E32378CB-468E-4218-B2F1-19D43A239DEB', N'9BDF64D9-5320-4ED1-B82B-58901688D1A3', N'832EB740-D240-4372-A9E2-47B36F395319', N'9D1D4A91-62D6-4780-9295-1216A34E044B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ001D007', N'S013RTU01EQ001', N'LIGHTING ELCB TRIP', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'E32378CB-468E-4218-B2F1-19D43A239DEB', N'9BDF64D9-5320-4ED1-B82B-58901688D1A3', N'697B70D0-402A-46F9-B342-14BEFBBCE02E', N'8E153E8E-69C3-4104-9288-B516D25D49EC', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ001D008', N'S013RTU01EQ001', N'CCTV MAIN INCOMING SUPPLY', N'14C49177-021B-4141-912F-B83F92AA9A57', N'C7AAF0A2-3C59-4393-946D-7268B71806BC', N'2841735E-656D-4749-9D11-2F62ADC9BD19', N'b168f9c6-2c53-4aca-ab2d-9e1eee279f26', N'42CEC7CB-DFD9-4B95-A321-6D1BAD219950', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ001D009', N'S013RTU01EQ001', N'CCTV POWER STATUS - DC', N'14C49177-021B-4141-912F-B83F92AA9A57', N'C7AAF0A2-3C59-4393-946D-7268B71806BC', N'2841735E-656D-4749-9D11-2F62ADC9BD19', N'b168f9c6-2c53-4aca-ab2d-9e1eee279f26', N'42CEC7CB-DFD9-4B95-A321-6D1BAD219950', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ001D010', N'S013RTU01EQ001', N'CCTV HARD DISK MALFUNCTION', N'14C49177-021B-4141-912F-B83F92AA9A57', N'C7AAF0A2-3C59-4393-946D-7268B71806BC', N'2841735E-656D-4749-9D11-2F62ADC9BD19', N'b168f9c6-2c53-4aca-ab2d-9e1eee279f26', N'42CEC7CB-DFD9-4B95-A321-6D1BAD219950', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ001D011', N'S013RTU01EQ001', N'CCTV IMAGE LOSS', N'14C49177-021B-4141-912F-B83F92AA9A57', N'C7AAF0A2-3C59-4393-946D-7268B71806BC', N'2841735E-656D-4749-9D11-2F62ADC9BD19', N'b168f9c6-2c53-4aca-ab2d-9e1eee279f26', N'42CEC7CB-DFD9-4B95-A321-6D1BAD219950', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ001D012', N'S013RTU01EQ001', N'CCTV ON BATT > 2 HOURS - CHK SITE', N'14C49177-021B-4141-912F-B83F92AA9A57', N'C7AAF0A2-3C59-4393-946D-7268B71806BC', N'2841735E-656D-4749-9D11-2F62ADC9BD19', N'b168f9c6-2c53-4aca-ab2d-9e1eee279f26', N'42CEC7CB-DFD9-4B95-A321-6D1BAD219950', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ001D013', N'S013RTU01EQ001', N'KEY SWITCH ME', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', N'7463C496-C80F-47AD-BB7B-A0DB3AA949F7', N'69A4F1D8-0CBA-4B12-B063-15D0E136A8FC', N'7b567968-41aa-4031-a8fd-a1f8341baefe', N'9C4C6F5A-9DB1-4994-A410-A0DD46F3C266', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ001D014', N'S013RTU01EQ001', N'DIMM 1 FAIL', N'E9EDA476-FC54-412D-A75A-0D914A5784A0', N'53FCCFBC-BD55-47FD-9B67-147D4F85C69D', N'8E11EA66-F7D1-4195-AE15-876D493ED91B', N'5f016081-f48e-4f9f-8296-136e37a4ba63', N'E09276E6-4DB1-4978-8FBD-5FD85096A07C', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ001D015', N'S013RTU01EQ001', N'DIMM 2 FAIL', N'E9EDA476-FC54-412D-A75A-0D914A5784A0', N'53FCCFBC-BD55-47FD-9B67-147D4F85C69D', N'8E11EA66-F7D1-4195-AE15-876D493ED91B', N'5F016081-F48E-4F9F-8296-136E37A4BA63', N'20767C84-1AAC-41C7-A705-3ECBCA1C73D0', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ001D016', N'S013RTU01EQ001', N'RTU LOW BATT', N'E9EDA476-FC54-412D-A75A-0D914A5784A0', N'53FCCFBC-BD55-47FD-9B67-147D4F85C69D', N'8E11EA66-F7D1-4195-AE15-876D493ED91B', N'5cfeabae-3c8c-4f00-9e9c-bb950a9267b3', N'FB82C5C1-E510-4845-84BD-D0DEAF907566', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ001D017', N'S013RTU01EQ001', N'RTU POWER FAIL', N'E9EDA476-FC54-412D-A75A-0D914A5784A0', N'53FCCFBC-BD55-47FD-9B67-147D4F85C69D', N'8E11EA66-F7D1-4195-AE15-876D493ED91B', N'5cfeabae-3c8c-4f00-9e9c-bb950a9267b3', N'FB82C5C1-E510-4845-84BD-D0DEAF907566', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ001D018', N'S013RTU01EQ001', N'KEY SWITCH RTU', N'E9EDA476-FC54-412D-A75A-0D914A5784A0', N'1625E12E-CB09-4867-AAA4-FDB19FBDAF6A', N'9130F885-F632-4A32-A785-1612C2031BD1', N'7B567968-41AA-4031-A8FD-A1F8341BAEFE', N'891269FE-87CD-4AD7-850F-5E46200DCF33', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ001D019', N'S013RTU01EQ001', N'RTU COMM FAILURE', N'E9EDA476-FC54-412D-A75A-0D914A5784A0', N'53FCCFBC-BD55-47FD-9B67-147D4F85C69D', N'8E11EA66-F7D1-4195-AE15-876D493ED91B', N'5CFEABAE-3C8C-4F00-9E9C-BB950A9267B3', N'FB82C5C1-E510-4845-84BD-D0DEAF907566', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ003D001', N'S013RTU01EQ003', N'LIFT STATUS', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897aee-0f44-4dd8-9597-47cd20d922b8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ003D002', N'S013RTU01EQ003', N'LIFT MAINTENANCE MODE', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897aee-0f44-4dd8-9597-47cd20d922b8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ003D003', N'S013RTU01EQ003', N'LIFT EMERGENCY OPERATION HOMING', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897aee-0f44-4dd8-9597-47cd20d922b8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ003D004', N'S013RTU01EQ003', N'LIFT TRIP', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897aee-0f44-4dd8-9597-47cd20d922b8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ003D005', N'S013RTU01EQ003', N'LIFT POWER', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897aee-0f44-4dd8-9597-47cd20d922b8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ003D006', N'S013RTU01EQ003', N'LIFT INTERCOM ACTIVATED', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897aee-0f44-4dd8-9597-47cd20d922b8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ003D007', N'S013RTU01EQ003', N'LIFT ALARM BELL ACTIVATED', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897aee-0f44-4dd8-9597-47cd20d922b8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ003D008', N'S013RTU01EQ003', N'KEY SWITCH LIFT', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'E6732624-441F-4827-BA11-2A4930876C75', N'084F3513-B256-4BD8-A5A3-9E7FCB67C570', N'38897AEE-0F44-4DD8-9597-47CD20D922B8', N'D9B740A4-4402-4CD6-A571-8AB3E1C24C62', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ004D001', N'S013RTU01EQ004', N'KEY SWITCH ESCALATOR', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'E0B8FD8C-CD3F-4629-BBDD-4AA3C9ADF14D', N'FCCE2CD2-CB1A-487E-B293-B888617ACAC6', N'AE951838-B656-44D4-A61D-73EBF5176107', N'58431C40-91E4-4DFA-87B0-091E5C8C2BE7', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ004D002', N'S013RTU01EQ004', N'ESCALATOR RUN STATUS', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'ae951838-b656-44d4-a61d-73ebf5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ004D003', N'S013RTU01EQ004', N'ESCALATOR UP DIRECTION', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'ae951838-b656-44d4-a61d-73ebf5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ004D004', N'S013RTU01EQ004', N'ESCALATOR DOWN DIRECTION', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'ae951838-b656-44d4-a61d-73ebf5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU01EQ004D005', N'S013RTU01EQ004', N'ESCALATOR 1 STOP ITSELF', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'ae951838-b656-44d4-a61d-73ebf5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU02EQ001D001', N'S013RTU02EQ001', N'Lift Breakdown. Please Check.', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897AEE-0F44-4DD8-9597-47CD20D922B8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU02EQ001D002', N'S013RTU02EQ001', N'(Lift 1) ARD Disabled', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897AEE-0F44-4DD8-9597-47CD20D922B8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU02EQ001D003', N'S013RTU02EQ001', N'(Lift 1) ARD Failure', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897AEE-0F44-4DD8-9597-47CD20D922B8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU02EQ001D004', N'S013RTU02EQ001', N'(Lift 1) Lift Parked', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897AEE-0F44-4DD8-9597-47CD20D922B8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU02EQ001D005', N'S013RTU02EQ001', N'(Lift 1) Lift Isolator Power Failure', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897AEE-0F44-4DD8-9597-47CD20D922B8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU02EQ001D006', N'S013RTU02EQ001', N'(Lift 1) Lift Controller Power Failure', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897AEE-0F44-4DD8-9597-47CD20D922B8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU02EQ001D007', N'S013RTU02EQ001', N'(Lift 1) Passenger Trapped', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897AEE-0F44-4DD8-9597-47CD20D922B8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU02EQ001D008', N'S013RTU02EQ001', N'(Lift 1) Motor Room Intrusion', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897AEE-0F44-4DD8-9597-47CD20D922B8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU02EQ001D009', N'S013RTU02EQ001', N'(Lift 1) Landing Door Open', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897AEE-0F44-4DD8-9597-47CD20D922B8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU02EQ001D010', N'S013RTU02EQ001', N'(Lift 1) Car Door Open', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897AEE-0F44-4DD8-9597-47CD20D922B8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU02EQ001D011', N'S013RTU02EQ001', N'(Lift 1) Water Level Sensor Activated', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897AEE-0F44-4DD8-9597-47CD20D922B8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU02EQ001D012', N'S013RTU02EQ001', N'(Lift 1) Lift Maintenance Switch (LM)', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'E6732624-441F-4827-BA11-2A4930876C75', N'084F3513-B256-4BD8-A5A3-9E7FCB67C570', N'38897AEE-0F44-4DD8-9597-47CD20D922B8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU02EQ001D013', N'S013RTU02EQ001', N'(Lift 1) EBOPS Battery Voltage High', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897AEE-0F44-4DD8-9597-47CD20D922B8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU02EQ001D014', N'S013RTU02EQ001', N'(Lift 1) EBOPS Battery Voltage Low', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897AEE-0F44-4DD8-9597-47CD20D922B8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU02EQ001D015', N'S013RTU02EQ001', N'(Lift 1) ARD Battery Voltage High', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897AEE-0F44-4DD8-9597-47CD20D922B8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU02EQ001D016', N'S013RTU02EQ001', N'(Lift 1) ARD Battery Voltage Low', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897AEE-0F44-4DD8-9597-47CD20D922B8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU02EQ001D017', N'S013RTU02EQ001', N'(Lift 1) Sensor Fault', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897AEE-0F44-4DD8-9597-47CD20D922B8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU02EQ001D018', N'S013RTU02EQ001', N'(Lift 1) TOI', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897AEE-0F44-4DD8-9597-47CD20D922B8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU02EQ001D019', N'S013RTU02EQ001', N'(Lift 1) Lift RS485 I/O Comm Failure', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', N'BFCC5347-8625-4AF8-9169-E61680B09B59', N'38897AEE-0F44-4DD8-9597-47CD20D922B8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU02EQ001D020', N'S013RTU02EQ001', N'(Lift 1) Main Power Supply Failure', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'E66B406F-E2B0-46B6-A96C-3367D6D9ABBF', N'46177465-6DA7-47C6-BB12-D49A161D704B', N'38897AEE-0F44-4DD8-9597-47CD20D922B8', N'B4CF701A-E5C7-45F8-8C59-18C7E801BA65', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D001', N'S013RTU03EQ001', N'(Esc 1) Auxiliary brake pad status alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D002', N'S013RTU03EQ001', N'(Esc 1) Auxiliary brake status alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D003', N'S013RTU03EQ001', N'(Esc 1) Comb plate safety switch alarm-lower left', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D004', N'S013RTU03EQ001', N'(Esc 1) Comb plate safety switch alarm-lower right', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D005', N'S013RTU03EQ001', N'(Esc 1) Comb plate safety switch alarm-upper left', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D006', N'S013RTU03EQ001', N'(Esc 1) Comb plate safety switch alarm-upper right', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D007', N'S013RTU03EQ001', N'(Esc 1) EBOS/UPS fault alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D008', N'S013RTU03EQ001', N'(Esc 1) ESC RS485 I/O Comm Failure', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D009', N'S013RTU03EQ001', N'(Esc 1) Earth leakage alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D010', N'S013RTU03EQ001', N'(Esc 1) Emergency stop alarm-lower', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D011', N'S013RTU03EQ001', N'(Esc 1) Emergency stop alarm-middle', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D012', N'S013RTU03EQ001', N'(Esc 1) Emergency stop alarm-upper', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D013', N'S013RTU03EQ001', N'(Esc 1) Escalator Down Direction Status', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D014', N'S013RTU03EQ001', N'(Esc 1) Escalator Fault', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D015', N'S013RTU03EQ001', N'(Esc 1) Escalator Maintenance Status', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D016', N'S013RTU03EQ001', N'(Esc 1) Escalator ON/OFF Status', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D017', N'S013RTU03EQ001', N'(Esc 1) Escalator Up Direction Status', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D018', N'S013RTU03EQ001', N'(Esc 1) Exceed permitted stopping distance alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D019', N'S013RTU03EQ001', N'(Esc 1) Flood sensor alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D020', N'S013RTU03EQ001', N'(Esc 1) Floor plate opened alarm-lower', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D021', N'S013RTU03EQ001', N'(Esc 1) Floor plate opened alarm-upper', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D022', N'S013RTU03EQ001', N'(Esc 1) Gearbox oil level low alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D023', N'S013RTU03EQ001', N'(Esc 1) Handrail inconsistent speed alarm-left', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D024', N'S013RTU03EQ001', N'(Esc 1) Handrail inconsistent speed alarm-right', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D025', N'S013RTU03EQ001', N'(Esc 1) Handrail inlet safety switch-lower left', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D026', N'S013RTU03EQ001', N'(Esc 1) Handrail inlet safety switch-lower right', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D027', N'S013RTU03EQ001', N'(Esc 1) Handrail inlet safety switch-upper left', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D028', N'S013RTU03EQ001', N'(Esc 1) Handrail inlet safety switch-upper right', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D029', N'S013RTU03EQ001', N'(Esc 1) Handrail speed -  15% alarm-right', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D030', N'S013RTU03EQ001', N'(Esc 1) Handrail speed - 15% alarm-left', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D031', N'S013RTU03EQ001', N'(Esc 1) Handrail tension/ Broken alarm-left', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D032', N'S013RTU03EQ001', N'(Esc 1) Handrail tension/ Broken alarm-right', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D033', N'S013RTU03EQ001', N'(Esc 1) Incoming power supply ON/OFF status', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D034', N'S013RTU03EQ001', N'(Esc 1) Inverter fault alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D035', N'S013RTU03EQ001', N'(Esc 1) Inverter no run signal alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D036', N'S013RTU03EQ001', N'(Esc 1) Main drive chain fault alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D037', N'S013RTU03EQ001', N'(Esc 1) Mechanical brake pad status alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D038', N'S013RTU03EQ001', N'(Esc 1) Mechanical brake status alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D039', N'S013RTU03EQ001', N'(Esc 1) Missing step alarm-lower', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D040', N'S013RTU03EQ001', N'(Esc 1) Missing step alarm-upper', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D041', N'S013RTU03EQ001', N'(Esc 1) Motion sensor fault alarm-lower', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D042', N'S013RTU03EQ001', N'(Esc 1) Motion sensor fault alarm-upper', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D043', N'S013RTU03EQ001', N'(Esc 1) Motor inconsistent speed alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D044', N'S013RTU03EQ001', N'(Esc 1) Motor overheat alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D045', N'S013RTU03EQ001', N'(Esc 1) Motor overload alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D046', N'S013RTU03EQ001', N'(Esc 1) Motor overspeed alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D047', N'S013RTU03EQ001', N'(Esc 1) Motor reverse direction alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D048', N'S013RTU03EQ001', N'(Esc 1) PCB board communication fault alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
GO
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D049', N'S013RTU03EQ001', N'(Esc 1) Phase reverse/loss alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D050', N'S013RTU03EQ001', N'(Esc 1) Safety circuit Opened alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D051', N'S013RTU03EQ001', N'(Esc 1) Skirt panel safety switch alarm-lower left', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D052', N'S013RTU03EQ001', N'(Esc 1) Skirt panel safety switch-middle right', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D053', N'S013RTU03EQ001', N'(Esc 1) Skirt panel safety switchalarm-lower right', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D054', N'S013RTU03EQ001', N'(Esc 1) Skirt panel safety switchalarm-middle left', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D055', N'S013RTU03EQ001', N'(Esc 1) Skirt panel safety switchalarm-upper left', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D056', N'S013RTU03EQ001', N'(Esc 1) Skirt panel safety switchalarm-upper right', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D057', N'S013RTU03EQ001', N'(Esc 1) Step chain tension alarm-left', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D058', N'S013RTU03EQ001', N'(Esc 1) Step chain tension alarm-right', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D059', N'S013RTU03EQ001', N'(Esc 1) Step sag safety switch alarm-lower', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D060', N'S013RTU03EQ001', N'(Esc 1) Step sag safety switch alarm-upper', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D061', N'S013RTU03EQ001', N'(Esc 1) Step upthrust safety switch alarm-lower', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_devices] ([col_device_id], [col_equipment_id_fk], [col_device_desc], [col_device_category_id_fk], [col_device_type_id_fk], [col_device_sub_type_id_fk], [col_device_identification_group_id_fk], [col_device_identification_letter_id_fk], [col_is_active]) VALUES (N'S013RTU03EQ001D062', N'S013RTU03EQ001', N'(Esc 1) Step upthrust safety switch alarm-upper', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'AA501BD6-778F-4EB4-ADFD-2B47229F7D43', N'AE951838-B656-44D4-A61D-73EBF5176107', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', 1)
INSERT [dbo].[tbl_dg_maintenance_company] ([col_dg_maintenance_company_id], [col_dg_maintenance_company_name]) VALUES (N'5e79c0af-c34c-4075-a829-69f9a8e1e206', N'DG Maintenance Company B')
INSERT [dbo].[tbl_dg_maintenance_company] ([col_dg_maintenance_company_id], [col_dg_maintenance_company_name]) VALUES (N'94723d7f-6b83-45b8-a982-fac99ac03c44', N'DG Maintenance Company A')
INSERT [dbo].[tbl_dg_setup] ([col_dg_setup_id], [col_dg_id], [col_dg_vm_setup_id_fk], [col_dg_maintenance_company_id_fk], [col_confiugration_file_hash], [col_description], [col_is_online], [col_is_active]) VALUES (N'e9a643e4-a431-4f3b-97f5-382f638a0959', N'DG001', N'68BDD035-B9E4-4967-95E1-B6CCFDBC39AF', N'5e79c0af-c34c-4075-a829-69f9a8e1e206', N'e0d123e5f316bef78bfdf5a008837577', NULL, 1, 1)
INSERT [dbo].[tbl_dg_setup] ([col_dg_setup_id], [col_dg_id], [col_dg_vm_setup_id_fk], [col_dg_maintenance_company_id_fk], [col_confiugration_file_hash], [col_description], [col_is_online], [col_is_active]) VALUES (N'0e10ac49-bbc1-4a7d-ad78-ef5d9bed41da', N'DG002', N'68BDD035-B9E4-4967-95E1-B6CCFDBC39AF', N'94723d7f-6b83-45b8-a982-fac99ac03c44', N'e0d123e5f316bef78bfdf5a008837577', NULL, 1, 1)
INSERT [dbo].[tbl_dg_setup] ([col_dg_setup_id], [col_dg_id], [col_dg_vm_setup_id_fk], [col_dg_maintenance_company_id_fk], [col_confiugration_file_hash], [col_description], [col_is_online], [col_is_active]) VALUES (N'0f35f0ab-2c7e-468a-86d0-f18db874e6c3', N'DG003', N'0328A463-0116-4834-B0CE-AD215542F524', N'5e79c0af-c34c-4075-a829-69f9a8e1e206', N'e0d123e5f316bef78bfdf5a008837577', NULL, 1, 1)
INSERT [dbo].[tbl_dg_vm_setup] ([col_dg_vm_setup_id], [col_dg_vm_id], [col_host_address], [col_host_username], [col_description], [col_vm_status], [col_is_active], [col_is_online]) VALUES (N'148be736-eb9f-4957-b559-a95b85523a9e', N'VM003', N'192.168.199.232', N'vm2_admin', NULL, 0, 1, 0)
INSERT [dbo].[tbl_dg_vm_setup] ([col_dg_vm_setup_id], [col_dg_vm_id], [col_host_address], [col_host_username], [col_description], [col_vm_status], [col_is_active], [col_is_online]) VALUES (N'0328a463-0116-4834-b0ce-ad215542f524', N'VM002', N'192.168.198.231', N'vm2_admin', NULL, 1, 1, 1)
INSERT [dbo].[tbl_dg_vm_setup] ([col_dg_vm_setup_id], [col_dg_vm_id], [col_host_address], [col_host_username], [col_description], [col_vm_status], [col_is_active], [col_is_online]) VALUES (N'68bdd035-b9e4-4967-95e1-b6ccfdbc39af', N'VM001', N'192.168.200.233', N'vm1_admin', NULL, 1, 1, 1)
INSERT [dbo].[tbl_diagnosis_rules] ([col_diagnosis_rules_id], [col_equipment_id_fk], [col_diagnosis_rules_title], [col_diagnosis_alarm_description], [col_diagnosis_bit_type], [col_is_active]) VALUES (N'f972e862-ad70-4aa4-97df-4d2561b96440', N'S013RTU01EQ003', N'KEY SWITCH (LIFT) ON > 2 HOURS - CHK SITE', N'KEY SWITCH (LIFT) ON > 2 HOURS - CHK SITE', N'DA', 1)
INSERT [dbo].[tbl_diagnosis_rules_details] ([col_diagnosis_rule_details_id], [col_diagnosis_rules_id_fk], [col_bitmap_id_fk], [col_duration_minutes], [col_conditional_operator]) VALUES (N'060c1c0e-a806-4b18-bff0-1b2fc8b16715', N'f972e862-ad70-4aa4-97df-4d2561b96440', N'6A6C5956-0EE3-4A2B-9A1E-FA6FAE3BFD25', 120, N'>=')
INSERT [dbo].[tbl_entity_heartbeat] ([col_entity_heartbeat_id], [col_entity_id_fk], [col_last_heartbeat_datetime], [col_modules], [col_json_text], [col_is_dg], [col_is_rtu], [col_is_equipment]) VALUES (N'ba515931-b15c-440b-8e45-1f3c502904eb', N'S013RTU01EQ002', CAST(N'2022-05-14T20:50:10.277' AS DateTime), NULL, NULL, 0, 0, 1)
INSERT [dbo].[tbl_entity_heartbeat] ([col_entity_heartbeat_id], [col_entity_id_fk], [col_last_heartbeat_datetime], [col_modules], [col_json_text], [col_is_dg], [col_is_rtu], [col_is_equipment]) VALUES (N'0d5a7e82-1b8d-42fb-8e71-48c994615e0f', N'S013RTU01EQ001', CAST(N'2022-05-14T20:50:10.277' AS DateTime), NULL, NULL, 0, 0, 1)
INSERT [dbo].[tbl_entity_heartbeat] ([col_entity_heartbeat_id], [col_entity_id_fk], [col_last_heartbeat_datetime], [col_modules], [col_json_text], [col_is_dg], [col_is_rtu], [col_is_equipment]) VALUES (N'65ed1e79-4c35-4e58-b7be-57717bf06f87', N'0E10AC49-BBC1-4A7D-AD78-EF5D9BED41DA', CAST(N'2022-05-14T20:50:10.277' AS DateTime), NULL, NULL, 1, 0, 0)
INSERT [dbo].[tbl_entity_heartbeat] ([col_entity_heartbeat_id], [col_entity_id_fk], [col_last_heartbeat_datetime], [col_modules], [col_json_text], [col_is_dg], [col_is_rtu], [col_is_equipment]) VALUES (N'8a287f6b-e093-4865-afe1-8a65629b5152', N'S013RTU01EQ005', CAST(N'2022-05-14T20:50:10.277' AS DateTime), NULL, NULL, 0, 0, 1)
INSERT [dbo].[tbl_entity_heartbeat] ([col_entity_heartbeat_id], [col_entity_id_fk], [col_last_heartbeat_datetime], [col_modules], [col_json_text], [col_is_dg], [col_is_rtu], [col_is_equipment]) VALUES (N'17d018f5-b782-46f8-9aae-8b08f96e31b9', N'S013RTU01EQ006', CAST(N'2022-05-14T20:50:10.277' AS DateTime), NULL, NULL, 0, 0, 1)
INSERT [dbo].[tbl_entity_heartbeat] ([col_entity_heartbeat_id], [col_entity_id_fk], [col_last_heartbeat_datetime], [col_modules], [col_json_text], [col_is_dg], [col_is_rtu], [col_is_equipment]) VALUES (N'b1e1dd41-c1be-4310-8ea8-96ebe9023272', N'S013RTU01EQ004', CAST(N'2022-05-14T20:50:10.277' AS DateTime), NULL, NULL, 0, 0, 1)
INSERT [dbo].[tbl_entity_heartbeat] ([col_entity_heartbeat_id], [col_entity_id_fk], [col_last_heartbeat_datetime], [col_modules], [col_json_text], [col_is_dg], [col_is_rtu], [col_is_equipment]) VALUES (N'fdda5cfd-c0c2-45cc-851f-beb67bbefc7e', N'S013RTU03', CAST(N'2022-05-14T20:50:10.277' AS DateTime), NULL, NULL, 0, 1, 0)
INSERT [dbo].[tbl_entity_heartbeat] ([col_entity_heartbeat_id], [col_entity_id_fk], [col_last_heartbeat_datetime], [col_modules], [col_json_text], [col_is_dg], [col_is_rtu], [col_is_equipment]) VALUES (N'46000a2b-0fb2-4589-b0d5-d43404b1b539', N'E9A643E4-A431-4F3B-97F5-382F638A0959', CAST(N'2022-05-14T20:50:10.277' AS DateTime), NULL, NULL, 1, 0, 0)
INSERT [dbo].[tbl_entity_heartbeat] ([col_entity_heartbeat_id], [col_entity_id_fk], [col_last_heartbeat_datetime], [col_modules], [col_json_text], [col_is_dg], [col_is_rtu], [col_is_equipment]) VALUES (N'eccb3bb4-7680-46e5-807d-d49e826b692c', N'S013RTU02', CAST(N'2022-05-14T20:50:10.277' AS DateTime), NULL, NULL, 0, 1, 0)
INSERT [dbo].[tbl_entity_heartbeat] ([col_entity_heartbeat_id], [col_entity_id_fk], [col_last_heartbeat_datetime], [col_modules], [col_json_text], [col_is_dg], [col_is_rtu], [col_is_equipment]) VALUES (N'd392ec6f-0e46-4e5c-b47b-e0ef6054cbea', N'0F35F0AB-2C7E-468A-86D0-F18DB874E6C3', CAST(N'2022-05-14T20:50:10.277' AS DateTime), NULL, NULL, 1, 0, 0)
INSERT [dbo].[tbl_entity_heartbeat] ([col_entity_heartbeat_id], [col_entity_id_fk], [col_last_heartbeat_datetime], [col_modules], [col_json_text], [col_is_dg], [col_is_rtu], [col_is_equipment]) VALUES (N'c2828a3e-9684-4652-b647-ed0a7b4c3faa', N'S013RTU01EQ003', CAST(N'2022-05-14T20:50:10.277' AS DateTime), NULL, NULL, 0, 0, 1)
INSERT [dbo].[tbl_entity_heartbeat] ([col_entity_heartbeat_id], [col_entity_id_fk], [col_last_heartbeat_datetime], [col_modules], [col_json_text], [col_is_dg], [col_is_rtu], [col_is_equipment]) VALUES (N'64901743-6282-43f3-a953-ef06092891a4', N'e9a643e4-a431-4f3b-97f5-382f638a0959', CAST(N'2022-01-15T21:05:45.000' AS DateTime), NULL, N'{"data":[{"id":"DG001","heartbeat_datetime":"2022-01-15T21:05:45+06:00","rtu_no":0}],"timestamp":"2022-01-15T21:05:45+06:00","data_type":0}', 1, 0, 0)
INSERT [dbo].[tbl_entity_heartbeat] ([col_entity_heartbeat_id], [col_entity_id_fk], [col_last_heartbeat_datetime], [col_modules], [col_json_text], [col_is_dg], [col_is_rtu], [col_is_equipment]) VALUES (N'932e9aa9-effc-4778-888f-f445a8e09261', N'S013RTU01', CAST(N'2022-05-14T20:50:10.277' AS DateTime), NULL, NULL, 0, 1, 0)
INSERT [dbo].[tbl_equipment_group] ([col_equipment_group_id], [col_equipment_group_title], [col_is_active]) VALUES (N'3d40d3e0-3357-4136-ae63-06998d94c43a', N'M&E Digital', 1)
INSERT [dbo].[tbl_equipment_group] ([col_equipment_group_id], [col_equipment_group_title], [col_is_active]) VALUES (N'a5fad96d-bcaa-4541-a6a0-1753d3e8a227', N'M&E Analog', 1)
INSERT [dbo].[tbl_equipment_group] ([col_equipment_group_id], [col_equipment_group_title], [col_is_active]) VALUES (N'dd34db2b-86cd-4390-aba6-2d45540e6cd0', N'LIFT', 1)
INSERT [dbo].[tbl_equipment_group] ([col_equipment_group_id], [col_equipment_group_title], [col_is_active]) VALUES (N'a826f9f0-315a-450a-a18a-2f0ec0ed2442', N'ESCALATOR', 1)
INSERT [dbo].[tbl_equipments] ([col_equipment_id], [col_equipment_group_id_fk], [col_rtu_id_fk], [col_equipment_title], [col_rtu_number], [col_baudrate], [col_device_type], [col_letter], [col_last_rbelo], [col_last_rbehi], [col_remarks], [col_is_rs485], [col_is_sms_activated], [col_commission_date], [col_is_online], [col_is_active]) VALUES (N'S013RTU01EQ001', N'3D40D3E0-3357-4136-AE63-06998D94C43A', N'S013RTU01', N'M&E Digital', 1, 2400, 20, N'01', N'0x0E0180805CE000000E0180805CE00000', N'0x0E0180805CE000000E0180805CE00000', N'M&E, LIFT, ESCALATOR', 0, 1, CAST(N'2022-05-14T20:50:10.277' AS DateTime), 1, 1)
INSERT [dbo].[tbl_equipments] ([col_equipment_id], [col_equipment_group_id_fk], [col_rtu_id_fk], [col_equipment_title], [col_rtu_number], [col_baudrate], [col_device_type], [col_letter], [col_last_rbelo], [col_last_rbehi], [col_remarks], [col_is_rs485], [col_is_sms_activated], [col_commission_date], [col_is_online], [col_is_active]) VALUES (N'S013RTU01EQ002', N'A5FAD96D-BCAA-4541-A6A0-1753D3E8A227', N'S013RTU01', N'M&E Analog', 4, 2400, 20, N'01', N'0x0E0180805CE000000E0180805CE00000', N'0x0E0180805CE000000E0180805CE00000', N'M&E Analog', 0, 1, CAST(N'2022-05-14T20:50:10.277' AS DateTime), 1, 1)
INSERT [dbo].[tbl_equipments] ([col_equipment_id], [col_equipment_group_id_fk], [col_rtu_id_fk], [col_equipment_title], [col_rtu_number], [col_baudrate], [col_device_type], [col_letter], [col_last_rbelo], [col_last_rbehi], [col_remarks], [col_is_rs485], [col_is_sms_activated], [col_commission_date], [col_is_online], [col_is_active]) VALUES (N'S013RTU01EQ003', N'DD34DB2B-86CD-4390-ABA6-2D45540E6CD0', N'S013RTU01', N'Lift', 4, 2400, 19, N'01', N'0x0E0180805CE000000E0180805CE00000', NULL, N'LIFT', 0, 1, CAST(N'2022-05-14T20:50:10.277' AS DateTime), 1, 1)
INSERT [dbo].[tbl_equipments] ([col_equipment_id], [col_equipment_group_id_fk], [col_rtu_id_fk], [col_equipment_title], [col_rtu_number], [col_baudrate], [col_device_type], [col_letter], [col_last_rbelo], [col_last_rbehi], [col_remarks], [col_is_rs485], [col_is_sms_activated], [col_commission_date], [col_is_online], [col_is_active]) VALUES (N'S013RTU01EQ004', N'A826F9F0-315A-450A-A18A-2F0EC0ED2442', N'S013RTU01', N'ESC', 4, 2400, 19, N'01', N'0x0E0180805CE000000E0180805CE00000', NULL, N'ESC', 0, 1, CAST(N'2022-05-14T20:50:10.277' AS DateTime), 1, 1)
INSERT [dbo].[tbl_equipments] ([col_equipment_id], [col_equipment_group_id_fk], [col_rtu_id_fk], [col_equipment_title], [col_rtu_number], [col_baudrate], [col_device_type], [col_letter], [col_last_rbelo], [col_last_rbehi], [col_remarks], [col_is_rs485], [col_is_sms_activated], [col_commission_date], [col_is_online], [col_is_active]) VALUES (N'S013RTU02EQ001', N'DD34DB2B-86CD-4390-ABA6-2D45540E6CD0', N'S013RTU02', N'LIFT', 7, 2400, 19, N'A', N'0x0E0180805CE000000E0180805CE00000', NULL, N'LIFT (RS485)', 1, 1, CAST(N'2022-05-14T20:50:10.277' AS DateTime), 1, 1)
INSERT [dbo].[tbl_equipments] ([col_equipment_id], [col_equipment_group_id_fk], [col_rtu_id_fk], [col_equipment_title], [col_rtu_number], [col_baudrate], [col_device_type], [col_letter], [col_last_rbelo], [col_last_rbehi], [col_remarks], [col_is_rs485], [col_is_sms_activated], [col_commission_date], [col_is_online], [col_is_active]) VALUES (N'S013RTU03EQ001', N'A826F9F0-315A-450A-A18A-2F0EC0ED2442', N'S013RTU03', N'ESC', 13, 2400, 19, N'01', N'0x0E0180805CE000000E0180805CE00000', NULL, N'ESCALATOR (RS485)', 1, 1, CAST(N'2022-05-14T20:50:10.277' AS DateTime), 1, 1)
INSERT [dbo].[tbl_equipments_contracts] ([col_equipment_contract_map_id], [col_equipments_id_fk], [col_contract_id_fk], [col_device_category_id_fk], [col_entry_date]) VALUES (N'cc5eb4ff-4dab-45f7-b064-96765b8f0372', N'S013RTU01EQ004', N'89BE2D96-D561-485A-B055-15E53D558C76', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', CAST(N'2022-05-14T20:50:10.277' AS DateTime))
INSERT [dbo].[tbl_equipments_contracts] ([col_equipment_contract_map_id], [col_equipments_id_fk], [col_contract_id_fk], [col_device_category_id_fk], [col_entry_date]) VALUES (N'bee01293-8dbf-46c6-8a16-eadf714e8fd1', N'S013RTU01EQ004', N'EA19ADFA-D45C-481F-ABF8-74C85BEE52E7', N'E9EDA476-FC54-412D-A75A-0D914A5784A0', CAST(N'2022-05-14T20:50:10.277' AS DateTime))
INSERT [dbo].[tbl_equipments_contracts] ([col_equipment_contract_map_id], [col_equipments_id_fk], [col_contract_id_fk], [col_device_category_id_fk], [col_entry_date]) VALUES (N'52519015-a8d3-4f00-bfc7-118b686e0a11', N'S013RTU01EQ003', N'5EA1AD50-8759-42E0-A89D-A8B428F65A74', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', CAST(N'2022-05-14T20:50:10.277' AS DateTime))
INSERT [dbo].[tbl_equipments_contracts] ([col_equipment_contract_map_id], [col_equipments_id_fk], [col_contract_id_fk], [col_device_category_id_fk], [col_entry_date]) VALUES (N'217bfb73-6a7a-431e-9e8b-441ac22f35a5', N'S013RTU01EQ003', N'A21B086F-A084-4367-B992-C92EC1D85F79', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', CAST(N'2022-05-14T20:50:10.277' AS DateTime))
INSERT [dbo].[tbl_equipments_contracts] ([col_equipment_contract_map_id], [col_equipments_id_fk], [col_contract_id_fk], [col_device_category_id_fk], [col_entry_date]) VALUES (N'13514748-dab2-467d-b14f-dd55c80892f8', N'S013RTU01EQ003', N'EA19ADFA-D45C-481F-ABF8-74C85BEE52E7', N'E9EDA476-FC54-412D-A75A-0D914A5784A0', CAST(N'2022-05-14T20:50:10.277' AS DateTime))
INSERT [dbo].[tbl_equipments_contracts] ([col_equipment_contract_map_id], [col_equipments_id_fk], [col_contract_id_fk], [col_device_category_id_fk], [col_entry_date]) VALUES (N'cc3052e3-782c-4ed6-936b-46ce1611047f', N'S013RTU01EQ001', N'EA19ADFA-D45C-481F-ABF8-74C85BEE52E7', N'14C49177-021B-4141-912F-B83F92AA9A57', CAST(N'2022-05-14T20:50:10.277' AS DateTime))
INSERT [dbo].[tbl_equipments_contracts] ([col_equipment_contract_map_id], [col_equipments_id_fk], [col_contract_id_fk], [col_device_category_id_fk], [col_entry_date]) VALUES (N'69225334-82bd-4d66-bbc1-6029627ebdaf', N'S013RTU01EQ001', N'5EA1AD50-8759-42E0-A89D-A8B428F65A74', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', CAST(N'2022-05-14T20:50:10.277' AS DateTime))
INSERT [dbo].[tbl_equipments_contracts] ([col_equipment_contract_map_id], [col_equipments_id_fk], [col_contract_id_fk], [col_device_category_id_fk], [col_entry_date]) VALUES (N'c56e6cb4-110a-41d7-bf93-36654ecdc569', N'S013RTU01EQ001', N'89BE2D96-D561-485A-B055-15E53D558C76', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', CAST(N'2022-05-14T20:50:10.277' AS DateTime))
INSERT [dbo].[tbl_equipments_contracts] ([col_equipment_contract_map_id], [col_equipments_id_fk], [col_contract_id_fk], [col_device_category_id_fk], [col_entry_date]) VALUES (N'61ba0fa1-2654-43fe-8791-2efc359c55ce', N'S013RTU01EQ001', N'A21B086F-A084-4367-B992-C92EC1D85F79', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', CAST(N'2022-05-14T20:50:10.277' AS DateTime))
INSERT [dbo].[tbl_equipments_contracts] ([col_equipment_contract_map_id], [col_equipments_id_fk], [col_contract_id_fk], [col_device_category_id_fk], [col_entry_date]) VALUES (N'e57feadb-740b-4b01-84ea-e5b8f6ab5892', N'S013RTU01EQ001', N'5EA1AD50-8759-42E0-A89D-A8B428F65A74', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', CAST(N'2022-05-14T20:50:10.277' AS DateTime))
INSERT [dbo].[tbl_equipments_contracts] ([col_equipment_contract_map_id], [col_equipments_id_fk], [col_contract_id_fk], [col_device_category_id_fk], [col_entry_date]) VALUES (N'bba9b725-0413-49ea-9018-3b8e2a2be63e', N'S013RTU01EQ001', N'EA19ADFA-D45C-481F-ABF8-74C85BEE52E7', N'E9EDA476-FC54-412D-A75A-0D914A5784A0', CAST(N'2022-05-14T20:50:10.277' AS DateTime))
INSERT [dbo].[tbl_equipments_contracts] ([col_equipment_contract_map_id], [col_equipments_id_fk], [col_contract_id_fk], [col_device_category_id_fk], [col_entry_date]) VALUES (N'ff5b959a-31cb-4b9c-955c-9a484858744f', N'S013RTU01EQ005', N'5EA1AD50-8759-42E0-A89D-A8B428F65A74', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', CAST(N'2022-05-14T20:50:10.277' AS DateTime))
INSERT [dbo].[tbl_equipments_contracts] ([col_equipment_contract_map_id], [col_equipments_id_fk], [col_contract_id_fk], [col_device_category_id_fk], [col_entry_date]) VALUES (N'3af26ab5-2e2f-4a39-aeff-0c534132994c', N'S013RTU01EQ005', N'A21B086F-A084-4367-B992-C92EC1D85F79', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', CAST(N'2022-05-14T20:50:10.277' AS DateTime))
INSERT [dbo].[tbl_equipments_contracts] ([col_equipment_contract_map_id], [col_equipments_id_fk], [col_contract_id_fk], [col_device_category_id_fk], [col_entry_date]) VALUES (N'89afea5e-bc8e-4f72-9dae-d8875ff97cdc', N'S013RTU01EQ005', N'EA19ADFA-D45C-481F-ABF8-74C85BEE52E7', N'E9EDA476-FC54-412D-A75A-0D914A5784A0', CAST(N'2022-05-14T20:50:10.277' AS DateTime))
INSERT [dbo].[tbl_equipments_contracts] ([col_equipment_contract_map_id], [col_equipments_id_fk], [col_contract_id_fk], [col_device_category_id_fk], [col_entry_date]) VALUES (N'4daac8e4-3a68-4988-a6c6-71d5052d18d2', N'S013RTU01EQ006', N'89BE2D96-D561-485A-B055-15E53D558C76', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', CAST(N'2022-05-14T20:50:10.277' AS DateTime))
INSERT [dbo].[tbl_equipments_contracts] ([col_equipment_contract_map_id], [col_equipments_id_fk], [col_contract_id_fk], [col_device_category_id_fk], [col_entry_date]) VALUES (N'8daed1ac-4bb0-49c0-bec4-0eb21ceb917e', N'S013RTU01EQ006', N'EA19ADFA-D45C-481F-ABF8-74C85BEE52E7', N'E9EDA476-FC54-412D-A75A-0D914A5784A0', CAST(N'2022-05-14T20:50:10.277' AS DateTime))
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'162f0898-9c87-481e-ad60-5986d3aa78b0', N'0000', N'Lift Incoming supply status', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'a35cda60-4b19-4047-bb24-3ba50b0816c1', N'0001', N'Air-con run status', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'4513ff5b-e62f-4c16-b5e1-c3489f0b900e', N'0001', N'Genset run status', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'9f7887b3-bfa4-4fdd-84f4-395a2c7ce5ba', N'0001', N'Mechanical Ventilation fan trip', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'60fff7d4-416a-4ab9-8963-d9790f81fc65', N'0001', N'ON/OFF status', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'6e46fc51-bb7d-4984-845b-f6f2207af1c2', N'0001', N'ON/OFF status', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'5467e559-064c-44fa-a4c3-0d7bf0c1de85', N'0001', N'Pump trip', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'00641ac0-3d9d-4cab-8656-3ee28f13d458', N'0001', N'UPS run status', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'c5127f80-9640-45a1-9fbd-d3c46b1ede92', N'0002', N'Flood Sensor alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'86a01431-0c1d-42b0-a940-9b45e3c9f794', N'0002', N'Flood Sensor alarm', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'933b954b-7161-4606-9603-01ec574f75ba', N'0002', N'Pump stop', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'deb8c5ba-1b7e-4e43-8931-ff1f79ffae26', N'0003', N'Cyclical Replacement', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'a943afd0-e3b6-4ad7-b2eb-2e186873d0ef', N'0003', N'EBOPS Trips/faulty', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'0d31a989-3c09-4437-9f31-8b75bb780673', N'0003', N'EBOPS Trips/faulty', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'943e9634-2ffa-45de-b12b-fea4432b0d0d', N'0004', N'DVR Main incoming supply status (230V AC)', N'14C49177-021B-4141-912F-B83F92AA9A57')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'0f6815f1-005c-458c-b28a-588903ff26ef', N'0004', N'DVR Main incoming supply status (230V AC)', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'ca5e0c10-77ab-4b5d-87b1-f1f9d5289840', N'0004', N'Overhaul', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'45a5d234-721f-451d-97cc-d87d88508aae', N'0005', N'Controller Power Status', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'aff236d9-3ac6-4587-a24d-b7e95b5045e3', N'0005', N'DVR Power status (12V DC)', N'14C49177-021B-4141-912F-B83F92AA9A57')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'7c7ccb3d-9508-4f69-82e3-092792ec5e80', N'0005', N'DVR Power status (12V DC)', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'151fbafb-f528-4e71-ba6f-5200411bc9bd', N'0006', N'Circuit breaker', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'693ace4a-8f74-4735-ad52-042213811792', N'0006', N'DVR Fail Alarm', N'14C49177-021B-4141-912F-B83F92AA9A57')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'697d3743-57e3-431f-a990-19f2b9823744', N'0006', N'DVR Fail Alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'ab6bce58-9d3c-4073-9da7-b1e8b3384970', N'0007', N'Hard disk full alarm', N'14C49177-021B-4141-912F-B83F92AA9A57')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'4ac549e2-744b-4672-86f9-23ae051c547f', N'0007', N'Hard disk full alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'04caa296-2d5a-4d51-86a5-41780f53f25c', N'0007', N'MCB/Fuse', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'bf29f18f-5611-47a4-bf3e-846167646e2e', N'0008', N'Hard disk malfunction alarm', N'14C49177-021B-4141-912F-B83F92AA9A57')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'64e9a6c5-e2bf-4c5d-b3e5-a3310a398b43', N'0008', N'Hard disk malfunction alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'cf93c4b3-9b6d-4f5f-b0fb-374dc1c06e21', N'0008', N'Transformer', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'b63326e2-a0c4-4f18-8032-0a7ba7d3b557', N'0009', N'Image loss alarm', N'14C49177-021B-4141-912F-B83F92AA9A57')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'1a520d7b-b9e4-44b8-ba0a-b285d2de195d', N'0009', N'Image loss alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'75c4c1dc-6ab0-4744-8913-55fb8248222b', N'0009', N'PCB', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'9d7162e5-d869-44d0-899b-4c4d4cea232c', N'0010', N'Camera supply status', N'14C49177-021B-4141-912F-B83F92AA9A57')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'84e8ba64-9b5d-4577-8cbb-69034c57b88d', N'0010', N'Camera supply status', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'06aef7a3-75cb-4ee9-84f3-12a7e394d4c1', N'0010', N'PLC', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'5221d497-a0c3-4bb8-b773-701c83e4ca09', N'0011', N'Camera trip alarm', N'14C49177-021B-4141-912F-B83F92AA9A57')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'b63f3160-4b40-408e-893e-bfcad013b320', N'0011', N'Camera trip alarm', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'eb8316f6-09ad-48b7-93ee-4d2b78db99d7', N'0011', N'Filter', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'b76f812b-49ab-4008-a813-99bd96a85452', N'0012', N'Camera Spoiled', N'14C49177-021B-4141-912F-B83F92AA9A57')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'22969866-abb8-452c-83dd-c43b779f20d2', N'0012', N'Contactors', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'515e8fc9-4668-4bcb-9d73-eaa241e7bace', N'0012', N'Ride comfort', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'f87430a7-2c8a-4a30-8ade-23dc4e8600eb', N'0012', N'Ride comfort', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'58d407a3-986a-47ce-a7e3-b7f03ffb54bb', N'0013', N'OMS (Please State the Reason)', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'3c06438d-420e-4b83-8c12-2cec9a99b535', N'0013', N'OMS (Please State the Reason)', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'bfac51f4-ffdc-40c3-baea-9f032937804a', N'0013', N'OMS (Please State the Reason)', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'9b14d72e-3b9e-41e2-ab24-a1871ddfafdb', N'0013', N'Resistors', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'6ac08847-ed35-4d41-8b96-14c741bfd936', N'0014', N'Rectifier', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'46a6e772-14bf-45c6-b5b8-8c523eead1c5', N'0014', N'Repair', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'43f5943c-6b7c-4bbb-b84e-394557c2a61b', N'0014', N'Repair', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'ca03e675-6048-45f7-8088-af4d6bd280ca', N'0014', N'Repair', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'de9e5d05-0291-4dd8-a7fc-c70ed32010d9', N'0015', N'Cyclical Replacement', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'c758c540-bc5c-477a-8a01-77cc10a666aa', N'0015', N'Cyclical Replacement', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'3d556da1-b906-4731-8c0b-342f80510d45', N'0015', N'OCR (Over current relay/protection)', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'7a30fc26-86eb-4614-b162-abf1d2fd051e', N'0016', N'Leakage current detection', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'd8b5ecaa-3895-4dc8-8628-7901fd5e5b26', N'0016', N'Overhaul', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'40e291f6-aaea-468d-ae36-88a2b5699fb0', N'0016', N'Overhaul', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'6ce562dd-9b37-490e-9463-0be2d141a294', N'0017', N'Annual Servicing/Testing', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'beb69a83-4486-4d74-ae77-4350c91f5538', N'0017', N'Annual Servicing/Testing', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'55bd5772-6068-4820-a606-cd85053f1668', N'0017', N'Phase monitor device', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'e36ece98-a7ab-4641-aecc-b4f6d6bb2b24', N'0017', N'Yearly Servicing/Testing', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'13b99de3-a9ae-4d77-9eb6-13df6394719a', N'0018', N'Condenser', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'cd0eed80-7b9f-4de1-aac3-b17cf0991486', N'0018', N'Monthly Servicing/Testing', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'6be577b6-2fc9-4c70-8351-03399ca55a9d', N'0018', N'Monthly Servicing/Testing', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'3bc1c5d6-69f7-49bf-9295-71f4f004ee2c', N'0019', N'Ventilation Fan', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'd680ee4b-2a64-41b0-a8fb-1971c5db9eca', N'0020', N'ELR trip', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'fb771aae-8fc5-4e57-b3f9-5c0e0bae9c5d', N'0021', N'Meter', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'ca58d2be-4a12-4e35-9807-9196cefdfd7c', N'0022', N'Pump windings', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'c6e04aa8-764c-4948-84d1-97db5dd47747', N'0023', N'Pump temperature monitor/device', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'bc6be43f-093a-4d4b-94c8-b744f778ea6c', N'0024', N'Pump sensor', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'3f666bd8-c0a1-4c8c-82f0-890b315df882', N'0025', N'Standby start sensor', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'cf022efe-fb30-448f-8d88-0d74b67637e6', N'0026', N'Duty start sensor', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'f9537726-0b1f-4db3-8563-81268c9fd410', N'0027', N'Dewater start sensor', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'c4bb9685-f3ca-4186-ab1f-baf3ac346496', N'0028', N'Dewater stop sensor', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'dc2ab5b0-2fe4-467e-9f15-c9dc869c0fb4', N'0029', N'Diversion pipe choke', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'9cb97a6f-bb38-445a-9ddf-1750258ce1e5', N'0030', N'Mechanical Ventilation fan stop', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'c2eb78e8-7264-4cbe-8a2c-c8d912acc414', N'0031', N'Air velocity/air flow rate', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'1696b5f7-d951-4323-bd83-86d0fa3d3dff', N'0032', N'noise level', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'8c213479-72a3-4a5d-9216-5a9210bff5cf', N'0033', N'Cyclical Replacement', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'caf15e91-8371-465b-b2c8-14a3ad5ad22b', N'0034', N'Overhaul', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'149b4ce4-ade8-4586-b144-e0fe38b83efa', N'0035', N'Fan windings', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'91aae95f-25cc-40d1-80b9-4dc1487653ae', N'0036', N'Fan temperature monitor/device', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'23a05ec4-e97b-40c1-b981-7932e725527d', N'0037', N'Fan belt', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'bfb269a1-4966-4cd2-b707-3917badda764', N'0038', N'Silencers', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'965fcb5c-b2bb-4430-a964-396a0cd179c4', N'0039', N'Air flow', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'5f7a6783-bfa4-4ca2-a5b7-eee44ccae324', N'0040', N'Genset trip alarm', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'ddf3fb10-4d59-44a7-bee4-fccab1152a22', N'0041', N'Genset Hz', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'cbd3306a-9783-4235-8ca5-979c5c020250', N'0042', N'Genset Red Amp', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'dab7a53b-694c-4520-af12-98dcd539dd1f', N'0043', N'Genset Yellow Amp', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'd3a7d8b0-4f59-4c11-8839-a4aefde53f41', N'0044', N'Genset Blue Amp', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'db37b85d-3af8-41f4-9ed0-266b95be2c5a', N'0045', N'Genset Red Voltage', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'1a085020-e851-40a8-9f07-ec0337b72ab6', N'0046', N'Genset Yellow Voltage', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'c13d9c41-5e3b-4e69-8f1b-cc6e2c2ec666', N'0047', N'Genset Blue Voltage', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'3ccec1b9-4781-4fcb-b49f-9b1567188506', N'0048', N'Cyclical Replacement', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'cebd5a6d-6435-4268-a3ee-c7a22012ee1b', N'0049', N'Overhaul', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'aa0ec23d-44c7-4563-9b1e-d30659164bed', N'0050', N'Motor windings', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'5aa65292-2efd-4970-9f7e-2032bc0dd949', N'0051', N'Genset monitoring device/meter', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'2793be2d-fe1d-420b-82f6-893456dc9c36', N'0052', N'Radiator temperature/coolant', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'17530aaa-41d4-4b5a-af60-e79031362f8d', N'0053', N'Exhaust Fan', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'7ac6a5c5-b639-4ad7-b8f4-888ab89e7828', N'0054', N'Exhaust Fan filter', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'a924ac78-4b35-468f-8594-616491658d67', N'0055', N'Genset battery', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
GO
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'25679145-4b8e-40f7-9a40-f5a82f65ff0a', N'0056', N'Genset day tank low fuel alarm', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'9cfd40c2-f65b-4768-a568-6b9a791fad4a', N'0057', N'Genset storage tank high fuel alarm', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'4bcb2b3e-01c8-4920-a739-efb0048ee056', N'0058', N'Genset high temperature alarm', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'6fdac4ae-da97-4f9a-8da2-158371b13524', N'0059', N'Genset low oil pressure alarm', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'6293f019-dbe7-4685-bcd6-7b5367b82016', N'0060', N'Genset overload alarm', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'eda6ef5a-0aab-4fed-8467-a410854e14c6', N'0061', N'Genset overcurrent alarm', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'28be74ec-ff87-4409-b317-cbf5cc433b0d', N'0062', N'Genset earth fault trip alarm', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'a9c65b19-6c6d-4b99-9f44-8c2c64bb69c4', N'0063', N'Air filter', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'56b12267-e63c-43de-93ed-6adc3d83a3da', N'0064', N'Oil filter', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'4e1383c2-6bf6-49d6-a68a-77e25f4c8cd3', N'0065', N'V-belt', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'ad893cab-df31-4dd2-8aa9-a01e2b9225f0', N'0066', N'Air-con trip alarm', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'1c068997-64b6-4a1f-8b7f-209e3cda3395', N'0067', N'Cyclical Replacement', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'20d7338e-3e6e-4547-b492-305637231ad4', N'0068', N'Overhaul', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'3eccba53-c15a-4db5-aa88-fdf5c35b6a4b', N'0069', N'AVR Automatic Volatage Regulator)', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'b8aaffa1-a3df-4d39-83bb-c9acdc163e47', N'0070', N'Air-con monitoring device', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'7563baca-f134-49e2-a8ed-ebe5c6f3372d', N'0071', N'Filter', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'5982e288-0b1a-4017-81cb-153bbee440d6', N'0072', N'Compressor trip', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'b6bf289b-576c-4189-8602-0e892c51dba7', N'0073', N'UPS trip alarm', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'15f1d4c0-bb29-4a70-b6dd-a4065052c9a9', N'0074', N'Cyclical Replacement', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'83018359-772e-44a1-9e43-0ba871de012f', N'0075', N'Overhaul', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'22df1c6c-66c5-4286-bbba-8747632a7962', N'0076', N'Relays', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'04fd2544-9585-44e8-876f-060459bdc38e', N'0077', N'Timers', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'7f2162c3-c42a-4de1-95bf-d02ff9538f18', N'0078', N'Indication light', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'77f53c54-efa9-46d0-b747-0f15e29d55d4', N'0079', N'Starter', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'787a6e2b-5c7f-4d4b-ba2e-9f5bbf7286c8', N'0080', N'UPS monitoring device', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'fb1ba3af-d036-4c9d-81da-fca17b9650da', N'0081', N'Exhaust Fan filter', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'e1e181ae-dceb-4bfd-a4a3-704f969c64b2', N'0082', N'UPS battery', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'116a4889-6649-4012-a60c-2c615ccda2f3', N'0083', N'UPS battery charger fail alarm', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'a16699ba-4366-4ded-ae24-327cceb1fb60', N'0084', N'UPS battery electrolyte level', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'a37043a3-0b2f-4d99-9652-e4a668eb3cf9', N'0085', N'UPS high temperature alarm', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'061343b1-e1a6-4595-9871-b3f249ac8659', N'0086', N'UPS overcurrent alarm', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'4400cb10-6fb8-4f1a-88c4-36cff2a0ce39', N'0100', N'Controller', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'9610d828-a324-4009-9f65-b4d17d5dee34', N'0100', N'Controller Power Status', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'923b837a-3489-416f-be6e-eebba5a1fc8f', N'0101', N'Circuit breaker', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'1f666a4e-484a-40d4-83fd-354b7de1e736', N'0101', N'Relays', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'219de70f-12ec-46b8-9c41-ebc6e9740799', N'0102', N'Contactors', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'01f5e255-662d-44eb-b27f-9fbd72d63aa5', N'0102', N'MCB/Fuse', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'394a065b-5d8b-49d7-b941-991fa22ce968', N'0103', N'Resistors', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'1de39bca-d4d5-4bf1-86f1-b145c7dd11b0', N'0103', N'Transformer', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'cde39f2e-131a-4b35-887c-5ecc45340b9d', N'0104', N'Fuse', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'f9ebd32e-7b18-4c77-9f2c-1c84a579da76', N'0104', N'PCB', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'40f3ef7c-83fd-4229-9f90-f0b6f9af2246', N'0105', N'Inverter/Frequency convertor', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'0d396aa6-1332-4f26-b050-fe87c8f4c420', N'0105', N'Selectors', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'3da6668d-06b4-4d47-8574-bc569978b400', N'0106', N'Inverter/Frequency convertor filter', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'33c27636-863d-4e1d-9e3d-2f361e932e91', N'0106', N'OCR', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'65e25418-17ec-4424-8510-f6d589a54d2c', N'0107', N'Contactors', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'2808b19d-152c-4abd-a3ab-93768c839e73', N'0107', N'Timers', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'cb1ab7b4-a263-4e63-aa01-1a9cf7a5be57', N'0108', N'PCB', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'67cbe1c3-dde6-4962-bc31-9d6412dad246', N'0108', N'Resistors', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'4263bbbd-e33e-42d9-bc07-e994105b5b1d', N'0109', N'Rectifier', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'f347ef8f-b669-4158-953a-61f9f6827c52', N'0109', N'Transformer', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'6f2ad4c1-a5f7-478c-befb-81a261984679', N'0110', N'OCR (Over current relay/protection)', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'6b479835-977e-4052-aa78-19ab9c188ca9', N'0110', N'Rectifier', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'7ef7dee9-f8aa-43e4-af61-72181574410d', N'0111', N'Condenser', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'651e01e6-52ad-4ffa-849d-4b25442db87d', N'0111', N'Leakage current detection', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'667ca958-cf02-494c-91e2-50c8510c26ec', N'0112', N'Phase monitor device', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'58f9f778-1fd6-4e10-93a4-a4e8454c6a54', N'0112', N'Wiring', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'733cb6e9-c3f1-4c4e-9240-5fc1185969ac', N'0113', N'Brake module', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'3475b72e-cae9-437d-9573-b74a7bf483f9', N'0113', N'Vector Drive', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'44c89ec4-0633-4e21-a087-5dab0ee7a5ac', N'0114', N'AVR', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'771a5670-11fd-46a7-b712-48a7f60b465f', N'0114', N'Relays', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'e12523ae-9ce4-464a-9bae-3760fca55114', N'0115', N'MCB', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'6cf8fc33-759d-4ee1-a1ca-f5b14802194d', N'0115', N'Ventilation Fan', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'9b1e04ca-dfeb-47c3-9443-0c5862721ef6', N'0116', N'Timers', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'e027f3ef-4088-4121-addf-ee5c3f46a702', N'0116', N'UCMP', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'55bea023-4b31-4422-9592-caf8228f5764', N'0117', N'Wiring/terminal', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'38c9c214-cdb3-4377-824f-f6c24cd2f97c', N'0118', N'RCCB/ELCB trip', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'cc67c251-d931-459d-960a-7f3ad42ed6ff', N'0123', N'Auto start/stop device', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'298a5306-253a-4f93-8e6a-de8439fc810e', N'0200', N'Air-con', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'59d3b7a8-afe8-4061-975a-b5b57a2c8470', N'0200', N'Gear box', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'f29c3241-3c0b-4234-accf-f28f1d21ba3c', N'0200', N'Genset', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'4c5c6873-eac0-47f5-b6dd-9dd4811475a9', N'0200', N'Mechanical fan', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'c10fcc89-3bcc-410f-ac58-c36bb1d6c174', N'0200', N'Pump', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'3a399b5c-98e9-4cf8-ba48-8bb22a1b61d4', N'0200', N'Traction machine', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'5d24c809-82ff-47ee-a6ad-979c431bb6e2', N'0200', N'UPS', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'88e022e9-2c14-4e38-b5da-e56a680607e9', N'0201', N'Gear box oil level sensor/device', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'63afbc39-bc0b-4f99-8aba-53dfa211baa9', N'0201', N'Traction motor', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'5d696cbe-efb0-4915-b8e2-d9ac5566ae0f', N'0202', N'Air-con temperature sensor', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'1d8e0659-cf82-4371-a7c9-5c0711549726', N'0202', N'Exhaust Fan', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'653a6b4b-5aad-4195-9edc-768fe0beaa21', N'0202', N'Fan bearing', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'24480780-9a4c-4fde-b095-2f03c2e2a681', N'0202', N'Motor bearing', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'dc053803-bad1-4554-a0c2-8b0fc0f1bfb4', N'0202', N'Motor windings', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'339fa254-7cf4-4d8c-b1f2-160dad2f2e26', N'0202', N'Oil seals', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'f6830345-10d7-4cee-8a7a-fc63af8f16f9', N'0202', N'Pump bearing', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'2ae269ec-371c-435e-8c9d-a7c397123888', N'0203', N'Brake', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'874eb3bc-3ebb-49e8-90bf-4dc6554ad800', N'0203', N'Traction motor', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'b9673b48-f5f5-4ebb-85d2-ecf90a1f1ed1', N'0204', N'Main sheave', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'2336416f-543e-48e3-aba1-0bfede9b6b8e', N'0204', N'Traction motor windings', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'06d389e4-7388-4658-b639-9d63a8900021', N'0205', N'Secondary sheave', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'7bed158d-7ce0-4427-b7a3-f40f632816a5', N'0205', N'Traction motor bearing', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'eb20b94a-898f-4ef2-9d78-8b166f897dd1', N'0206', N'Bearing', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'1b9813d1-1092-4d01-8971-6d50732aae0f', N'0206', N'Motor temperature monitor/device', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'518e60f3-14f3-4d4f-b24c-9d59b388b687', N'0207', N'Bushes', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'052e14bc-07d2-4399-bead-91e912103c34', N'0207', N'Pulse Encoder', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'b36c3e58-6e39-45cb-881f-a9a91e6d3441', N'0208', N'Genset battery charger fail alarm', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'1f059c1d-01c5-4e28-ae0c-8a915946defe', N'0208', N'Mechanical brake', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'3a125fd7-0702-4cdc-9209-4a464447eb0c', N'0208', N'Oil seals', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'5ea95d5d-8a37-4e54-8321-4d0c537347fe', N'0208', N'UPS overload alarm', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'9220a789-21d0-4680-9b6e-f660e22648c8', N'0209', N'Fan blower', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'5af3c36f-aa44-4efe-a783-fbbd3af5e944', N'0209', N'Mecchanical brake switch/device', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
GO
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'a5de2a47-dcba-42d6-85e7-f9015378bfb8', N'0210', N'Air filter', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'4b63cf40-6138-4208-aec4-129c43c57d2f', N'0210', N'Auxiliary brake', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'b5638bea-9088-4624-ad0a-38989f276f1b', N'0210', N'Genset day tank high fuel alarm', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'37dc95d0-f744-4dd8-8a3b-536461623c8f', N'0210', N'Pulse Encoder', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'23d12ba4-6d0d-47ad-8465-a39a4239349a', N'0211', N'Auxiliary brake switch/device', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'e6125dfc-2289-43b4-a77d-a3a425a6d31d', N'0211', N'Genset storage tank low fuel alarm', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'cdcf92ba-fa4c-4deb-84db-e4f59549cab8', N'0212', N'Main drive chain sprocket', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'd9910521-e83f-455e-8fd9-e4ba4e5c4dd8', N'0213', N'Main drive chain', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'a7263d91-00a7-467b-9d46-c870932bf5c5', N'0214', N'Main drive chain safety device', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'8fac4101-bef3-474d-890b-35a4a6b34334', N'0215', N'Main drive shaft sprocket', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'1605a63e-c91c-4805-8dfc-3a0ed1932301', N'0216', N'Main drive shaft sprocket locking device', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'0c169dd3-04bd-4046-ade9-73c2e50d190f', N'0217', N'Main drive shaft sprocket locking safety switch', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'8af1604f-ab59-4980-9224-46184586f5bd', N'0300', N'Inner decks and skirt', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'98b199cb-7475-4a30-ac7c-29c86d947749', N'0300', N'MG set', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'1d414d95-37c4-4813-ae9e-9d3195709a1c', N'0301', N'Anti-vibration isolators', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'8d1091e3-fd29-4e1b-8cf8-d44391259bc4', N'0301', N'High level sensor', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'717228a7-73f4-4812-8a70-4b45df33bba4', N'0301', N'Inner solid panel', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'652c7777-9bf1-4858-9982-fdac2e275f28', N'0302', N'Inner glass panel', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'8259eecf-edee-4fd7-bedb-bdc18521935a', N'0303', N'Skirt brushes', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'fabb7cba-7f0c-43cc-b744-73d09d990603', N'0304', N'Demarcation /step gap light', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'7b20286b-eb8b-424b-af18-55f5e0f09d9e', N'0304', N'Low level ensor', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'ea18e0a2-d79c-4840-aee5-be68c8748f67', N'0305', N'Cut off sensor', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'cd0cae37-229e-4ded-bce0-f69ea4234f29', N'0305', N'Safety signs (pictographs)', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'10ce87f9-5990-4fa6-8d87-d113bb753f66', N'0306', N'Indication light (Arrow & No entry)', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'fe34f764-2a0c-4d02-bada-95452ec1f49d', N'0307', N'Headguards/infills/defectors.', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'c94d1af0-01f7-461a-bfa5-6a06e5179fa4', N'0308', N'Comb light', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'0140945f-5769-4c30-8bbc-0a31c9b76a48', N'0309', N'Floor plate', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'88b9f71f-0880-4532-8399-6fbbabd4690d', N'0310', N'Floor plate switch lower', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'd01e535a-0e84-413c-9941-906d7816806a', N'0311', N'Floor plate switch upper', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'cef21ae5-926d-4f8f-bef5-0ddc7990fed9', N'0312', N'E-stop lower', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'a6af33a5-8b76-44b1-bc99-c99c01dc09b8', N'0313', N'E-stop middle', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'43fb2443-bac2-4a3e-bb6e-6e57b13aa56e', N'0314', N'E-stop upper', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'b95ad251-87e4-432e-8543-fcb29adc45f8', N'0315', N'Skirt Panel safety switch lower', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'63ae52fc-839a-42ac-b209-33bb0ceff23b', N'0316', N'Skirt Panel safety switch middle', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'51ac1993-edf0-46a0-8d59-bbb63848fd1a', N'0317', N'Skirt Panel safety switch upper', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'c3a53ddb-0659-4a05-af7a-117e2e3be567', N'0318', N'Comb plate cover lower', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'4d8f5399-739e-44e5-96ea-ebb6566f1e80', N'0319', N'Comb plate cover upper', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'62a778d5-92f6-4dd9-b804-e785b5fba468', N'0320', N'Comb plate safety switch lower', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'3cb0036a-f2e4-4177-bccc-0b2a3671873c', N'0321', N'Comb plate safety switch upper', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'5f0a01c1-bc3f-4af4-a02f-616777d6f3a6', N'0322', N'Handrail inlet safety switch lower', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'4a127e1b-1677-4677-bb00-4991d4b3ba33', N'0323', N'Handrail inlet safety switch upper', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'278eb8ce-2704-4575-bc9b-198b296faa22', N'0324', N'Motion Detection sensor lower', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'a99de028-4bb5-48cb-8a40-5d4317171fef', N'0325', N'Motion Detection sensor upper', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'2102d5cb-579b-4396-80a4-6bd3c75c7531', N'0400', N'Corridor lighting out of order', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'8243c4dc-cebb-4d48-b44b-5cad25d339c9', N'0400', N'Governor', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'0f6110af-c61d-4747-83e7-674a353cebe3', N'0400', N'Step', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'f086d8c5-1d4a-4686-87d8-f9959a833d33', N'0401', N'Starter Defective', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'40a436d4-fda9-4935-96c9-3827162b82c7', N'0401', N'Step slider block/shoe', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'ea5ce8d9-0fc6-4964-ad68-27f3f5bf14d4', N'0402', N'Step yellow dermacation', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'f6802fac-e17d-4372-aa76-51113d3b3018', N'0402', N'Tube ( D ) 0.6', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'da17ac7a-7289-464b-b097-87d313d94bb3', N'0403', N'Step roller', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'2b6cf843-c206-4063-af63-60c43201fc44', N'0403', N'Tube ( D ) 1.2', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'9a6591bc-5ed4-41ee-9c29-a06d9d222c3e', N'0404', N'Step sag monitor lower', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'15fe244a-9f78-4280-bdb6-fd5f0bf6d620', N'0404', N'Tube ( W ) 0.6', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'fb67ed5f-3319-430b-87a2-d2273029836b', N'0405', N'Step sag monitor upper', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'225f280f-3c90-4211-abb5-7b31cf3c1e76', N'0405', N'Tube ( W ) 1.2', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'e6075e9c-400e-4228-9858-80baef86020d', N'0406', N'Missing step safety device lower', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'14423dfd-f627-4d84-a1f4-22bcc081e84c', N'0406', N'PLC tube', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'c5feabc5-f29d-4718-af56-d1fd7d645a89', N'0407', N'Ballast', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'9570cbd5-f9d8-49d7-826f-e8615da6ec58', N'0407', N'Missing step safety device upper', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'0cbe450c-b085-4482-ade0-2aa791c82069', N'0408', N'Step lift/upthrust safety switch lower', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'cd8b2ae7-7c8e-42c8-aad3-64c0b98967a7', N'0409', N'Step lift/upthrust safety switch upper', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'7eaf6a68-a85e-4a72-81d3-d193539026fc', N'0410', N'Step chain', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'58cf0c38-9fdb-43d3-8e10-8fce7f8f70c0', N'0411', N'Step chain roller', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'7c6a0e04-5711-4d13-89ba-bc7d8a1803f1', N'0412', N'Step chain tension', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'10701f47-2991-4acf-9425-ebd4f332df64', N'0413', N'Step chain tension safety switch', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'8094159e-f335-4452-b75c-63ef3a0100b0', N'0414', N'Step chain tension carriage', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'98445876-beec-4087-9505-9c42e3162f11', N'0415', N'Step guide', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'264fe89b-332f-4d95-a87f-80a0bc0a91d6', N'0416', N'Step chain guide', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'0d13891a-06f1-4b69-a1b2-a942c6bedb20', N'0500', N'Handrail', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'22e88bd6-1240-4139-b464-7d65b1c6e3d4', N'0500', N'No elect. supply', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'032e3088-abb7-4141-8723-c4b4edc527a1', N'0500', N'Travelling cables', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'dcaf57a2-8202-4b99-9bc7-4b72674f3be8', N'0501', N'BI connector Loose/Burn', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'cdcab33c-0517-4651-a7e4-43ba069d6a59', N'0501', N'Handrail tension', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'274348cb-8bbd-4ca6-a470-156f70a949b6', N'0502', N'Handrail tension monitor device', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'32c22820-3a3d-4276-bc31-4e87218f8297', N'0502', N'SW/RM MCCB/MCB Tripped', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'46285f70-ba11-4818-aea0-bd3efcd762c1', N'0503', N'Handrail guide', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'88abe546-8fbc-423d-b37f-a78e0f191f6f', N'0503', N'Tenant Internal Fault', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'fa924bc4-3d2c-4dd1-adad-a32291b032a7', N'0504', N'Handrail guide roller', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'721470c3-d7ec-4773-921d-d3409d4b09db', N'0505', N'Handrail drive wheel/V-belt', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'8d1f05da-b6b6-4cde-8a5d-9fd58c9cd036', N'0506', N'Handrail pressure roller', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'6dbfc42d-ab50-4c24-91fc-fad244a30967', N'0507', N'Handrail newel roller/bearing lower', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'ec89281d-d231-4366-9fd0-821d2d2a193d', N'0508', N'Handrail newel roller/bearing upper', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'1ba50888-522e-490d-8664-4df311176c78', N'0509', N'Handrail newel sheave bearing lower', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'd12346e7-bc20-4c2a-bb24-ad888816938c', N'0510', N'Handrail newel sheave bearing upper', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'13fd6f13-3a9a-4b85-bd90-888b016e459a', N'0511', N'Handrail speed monitor device', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'1a86bc27-04ee-4aa3-9027-2656aea638b7', N'0512', N'Handrail broken monitor device', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'f798639a-51bc-40a6-96b2-bef968be7346', N'0600', N'Car park lighting out of order', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'52b8d18a-033c-4997-9fa7-e71be04d453e', N'0600', N'Wire ropes', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'42428e28-3cad-460d-9895-a811bfe556f3', N'0601', N'BULB Defective', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'09beefc7-e3ac-41d1-a858-089e62e551a9', N'0602', N'Ballast Defective', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'41df3708-4afa-4964-a5c3-146acc8d6108', N'0603', N'SW/RM T/Switch not ON', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'32ecd697-2559-4cf3-953c-dd6352a9f94b', N'0700', N'Car cage/door operation', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'8f36e4b3-022b-4e77-96c0-8560c3aa7fde', N'0700', N'Lighting O3 ( other than corridor and car park)', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'26bf2921-534d-4c09-9d70-35e9dc1f9812', N'0701', N'Car door / OTL switch defective', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'893295b0-e631-4ffa-ac11-6bf208bc3393', N'0701', N'Ripple Receiver Defective', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'980a4850-ae6d-46e0-8c71-3db3275a01b8', N'0702', N'Safety edge', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'2b2548a4-aec7-4a06-9b72-70c164033740', N'0702', N'Time Switch', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'95dbc9af-58cf-4c6a-9f82-a498db499667', N'0703', N'MCCB/ELCB Reset', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'831d2fae-f99c-45e0-a038-f274cdc2915a', N'0704', N'Car push button', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
GO
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'd236ceee-8283-48c2-8fd9-fb7417683c2a', N'0709', N'Door motor', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'70546869-f1c9-4e37-9948-f6280249a64d', N'0710', N'Door pulley', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'0e15e1d1-99c6-4525-b5d0-eafbbed811f5', N'0712', N'CAR DOOR SILL', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'83ee401a-7637-4e55-bfe8-63c145426c82', N'0713', N'Car door shoe', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'b94fda42-b001-4748-80af-9fa2335a0d92', N'0714', N'Car door switch', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'c1dcd61f-f682-4ce7-975e-72e279d1a9b3', N'0715', N'Door chain / door belt', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'b988e8a3-d8fb-4910-bfc8-0595a0232381', N'0716', N'Door sensor', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'72883630-c0e0-43bd-8c0a-f9c67e541a24', N'0717', N'Overload Switch', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'8e5c4450-9923-48af-ae8e-a0377a9adb17', N'0718', N'Trap Door Switch', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'75123c63-227b-4146-b281-44c8f7477d1d', N'0800', N'Landing door', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'9cc9e00a-623f-4384-b973-6422b4ad9440', N'0801', N'Landing door hanger roller', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'dd89ccd5-7eb4-41df-8a30-489709aa92f9', N'0802', N'Landing door shoes', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'23c24108-0738-47a1-9fe5-f28a12fa9959', N'0803', N'Landing door lock', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'41cb1bac-6069-4f34-b86b-b8528f342e7d', N'0804', N'Landing door sill', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'2d7f3a2c-c622-4f58-8e56-1c0fd19b4532', N'0806', N'Landing door push button', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'a096d83f-2d17-4652-96d0-bb17915c5b94', N'0807', N'Landing door weight', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'1bd42cb7-6c60-4dba-bbaa-8f09b442c6b2', N'0900', N'Safety catch mechanism', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'ee34016e-c140-4063-92ed-1843dd432a6e', N'0901', N'Safety catch jaws', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'0db99c6d-8b23-4b0c-bb9d-58de9d0974ee', N'0902', N'Safety catch rollers', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'cd459d0c-cec4-475e-b1b7-9b42f3ba1058', N'0903', N'SOS switch', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'268378cc-1c4d-4fcd-8d5a-dec318e07d7b', N'1000', N'Hoistway', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'f4088983-83ae-4426-a973-309f4441c0cd', N'1001', N'Inductor', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'9d143476-8780-4621-b15b-a7b6c2fc666c', N'1002', N'Limit switches', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'2bd587c5-79eb-4b9c-8455-a0044388fb40', N'1003', N'Guide rails', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'072d993f-ab12-495b-8ab3-321df071260e', N'1004', N'Guide shoes (car/cwt)', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'823f4743-fdb6-4528-b6e0-5b61a60ac204', N'1005', N'Compensating chain /rope', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'5b7c3bef-bdab-4650-bd0e-7493f76376e7', N'1006', N'Governor Tension Pulley Switch', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'af37f9f2-65cb-4e27-b8f3-b133a4594c0c', N'1100', N'Anti-crime siren', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'83edd12e-385d-4cf0-ba94-6d4176a1d453', N'1200', N'EBOPS Trips/faulty', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'29ab1494-8a4e-475a-9744-9260ebdf214d', N'1300', N'ARD fault', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'afee1cdf-891d-4e17-b66b-1992c90e7876', N'1401', N'Door sill stuck by objects', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'23279c29-fe71-4db3-a3c7-1429c7a6457f', N'1402', N'Push button jammed', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'9df3a563-fc47-412f-9c96-1b3b0e307b99', N'1403', N'Door forced out of track', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'12aa4279-a70a-4664-81fa-7da5365dde6d', N'1404', N'Fireman switch', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'38a6c8ed-0b98-4edc-96a0-6d3468f8cab1', N'1405', N'Activation Of Fire Alarm (Not By Authority)', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'a4987de1-410e-4f59-8a44-94c4e3c45b0b', N'1499', N'Other defects caused by vandalism', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'afdcb804-9edc-4faa-bc57-eef7171d82eb', N'1500', N'False Call', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'3c19359a-c92b-48a5-ae40-ad8a35c814c6', N'1500', N'False call', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'a4af822a-c154-4e39-aa13-00e7aaef7e26', N'1501', N'Fault clear upon arrival', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'8a7b2837-1af6-46dd-a5fd-4c17303da8c9', N'1600', N'Under-voltage / no power supply', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'39dcdc97-7f3e-415a-ba58-31edb8319ff9', N'1700', N'Fault cleared before arrival/despatch', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'2f344324-f256-4186-a63d-d42368dc2146', N'1701', N'Servicing / Minor Repair', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'acc5b7b5-74fb-476f-9a17-61d9426250e3', N'1702', N'TMS work in progress', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'75f9351f-1317-429c-af6a-022fff368a30', N'1703', N'Lift switched off by TC/BO', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'07d6ef3f-8c04-4702-8acd-7f0f4dcf9463', N'1704', N'Fan noisy / not working', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'82767d7b-d824-4313-85b9-051e240dd0aa', N'1705', N'Car light not working', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'52a27c5d-bb72-4a4f-91b9-272ef0fbcd83', N'1706', N'Indicator light not working or blown', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'9542964d-9643-4744-b86c-8127c3e4b789', N'1707', N'Lift jerky /noisy', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'6207f55f-015c-4504-a9e4-7d6dbddd7124', N'1708', N'Alarm bell not working', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'bc39290b-2d8d-403a-b9e9-b0a443bc9a48', N'1709', N'Door slammed on closing', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'7ce74355-6f34-4822-8eb0-47c44350a85c', N'1710', N'Lift smelly /dirty/ UDD activated', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'0eaf90b8-da02-4dbe-8718-8ac10a680980', N'1711', N'Poor leveling', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'b821ca5c-16c9-484f-85af-e78afb064b0d', N'1712', N'Animal/Key /etc in lift pit', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'83ac4e94-af8b-4c4f-b7c3-575594eb65d6', N'1713', N'Elcb (Machine Room) Tripped', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'1750c92c-aa89-4255-9737-b7d6515dac65', N'1714', N'MRI - Door Contact faulty', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'cecb2a66-17e6-4e46-b7d3-0529b22ffa7d', N'1715', N'MRI - Door Contact missing', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'32498c5a-ebca-4ec8-9841-fa32b0a4ed30', N'1716', N'MRI - Door missing', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'3c1498ed-5cfc-4316-bfba-e20ff85792ba', N'1717', N'MRI - LM key not inserted', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'e04ede6e-fad8-4f60-a4e3-52bac98a3d93', N'1718', N'MRI - LM keyswitch faulty', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'21fe7f84-ebf7-4fde-9e78-a8dd1094eece', N'1719', N'MRI - EBOPS voltage problem', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'b377e3a6-c9d6-4509-ba26-2a983a4c259c', N'1800', N'Other types of breakdown', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'0508971b-d555-4ee2-b3aa-bfff8c3b6dd5', N'1801', N'Overrun', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'8e1308d6-acf1-46ab-9f64-eaa7b5e9c9d5', N'1900', N'Close Lift Fault', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'31d352e3-5c3c-43d4-8058-953fb062af54', N'2000', N'Spare', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'c32d16dc-3312-465e-98bf-4f8088a08905', N'2100', N'MIC Tripped', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'4f0ef186-6650-4a15-a127-4fa31115d836', N'2101', N'Door opening error code', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'acc2e8ae-7d6b-4bc0-a673-263b0281f3df', N'2102', N'Door closing error code', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'63765ff0-e536-4968-962d-4a3808e8da1c', N'2103', N'Speed control error code', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'b8d973f0-c89c-4510-9b65-7a2f81bfeead', N'2104', N'Deceleration error code', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'f92df87f-a91e-44db-ac0c-e95650d12c55', N'2105', N'Leveling error code', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'7ac2039c-4347-410d-8554-b9cfacbf71f4', N'2106', N'Acceleration error code', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'51b47222-7ed7-4885-af7f-49c7e462c43a', N'5001', N'Replacement of car cage', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'94632072-509d-4f2a-8037-a11c0143b59e', N'5002', N'Major repair of car cage', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'474452ff-93fd-47da-88af-cf7ef5331a88', N'5003', N'Replacement/addition of travelling cables', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'ad5b2835-8c42-4bc2-88da-c785bd914625', N'5004', N'Replacement of main wire rope', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'3090aaef-33be-4f45-9f98-c7668304d811', N'5005', N'Replacement/regrove of main sheave', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'58b75aa2-cf23-4d4b-a409-bcf0e712bc2d', N'5006', N'Replacement of main rope and sheave', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'4773c70a-9ea8-469f-9f1b-666001411700', N'5007', N'Replacement of secondary sheave/bearing', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'f91ec756-8830-4da0-897e-42c9a878a9a3', N'5008', N'Replacement of governor rope', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'1339ecd4-788b-4d5f-96ab-ec75cb184e0b', N'5009', N'Replacement of governor pulley/bearing', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'3a5303b6-ef5b-458a-b3b2-3c6fe6e539a2', N'5010', N'Rewinding of main motor', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'e9c8f1ff-6c5c-400e-98f1-d12d269afe12', N'5011', N'Replacement of Worm gear', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'711a8c2d-12fe-47b4-849d-dc8c2c3c655f', N'5012', N'Replacement of worm shaft', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'cd7647e3-b8e0-4e84-873b-26bf72ccc7fe', N'5013', N'Replacement of worm gear & shaft', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'9fdb0231-dcde-484a-8edc-d501131d49a6', N'5014', N'Replacement of worm bearing/bush', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'1df76989-4e3d-498f-9b73-4ba54183b10f', N'5015', N'Replacement of stand bearing/bush', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'a023341b-799b-4e57-827c-00d008ba9992', N'5016', N'Replacement of motor bearing/bush', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'f49ab25c-bf69-4cf9-b980-2fcb0eabbbad', N'5017', N'Replacement of thrust bearing', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'0c543dc3-a390-4341-9b6e-3dc3b62935c9', N'5018', N'Replacement of oil real', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'd7ff5922-f9e8-44d0-bb93-86dcffdc084a', N'5019', N'Replacement of brake wiring', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'6ad5bbc3-618b-4155-b5d0-dd528cdd0d89', N'5020', N'Replacement of PVC tiling', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'cbba53cc-aa50-4fc8-b5c6-00076f31ce36', N'5021', N'Replacement/repair of car door', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'e538cb98-5f8c-4cd6-b963-ece3d2f492c5', N'5022', N'Replacement/repair of car door sill', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'bbb81aba-d9d6-4752-b53e-386ec605b037', N'5023', N'Replacement/repair of car panel & formica', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'66e88031-c889-4bdb-9795-70e0041c1d38', N'5024', N'Replacement/repair of car platform', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'b056805c-2fcb-4be8-9c72-476374e4e84d', N'5025', N'Replacement/repair of landing door', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'f6dd20f9-a882-4907-8a82-64c226a4c563', N'5026', N'Replacement/repair of landing door sill', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'c44c4170-bac6-4fb3-a1e2-78ddafddb2d8', N'5027', N'Replacement/repair of landing door jamb', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'ff82d5df-d72a-4122-82f0-595d0ad73acc', N'5028', N'Burnt car cage', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'9d705f62-04d7-44f5-99d4-c5b0c2bb98de', N'5029', N'Car cage wet', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
GO
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'98904f3a-ff50-4db1-8341-cb991f12baf5', N'5030', N'Safety gear not working', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'fe7d4d6c-0d9b-4510-9675-e219d40dc983', N'5031', N'Car top & lift pit wet', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'19d2b175-1309-47d0-bdf7-6c9b8452c8cf', N'5032', N'Alarm/siren not working', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'd65bd75b-e2bf-4659-901b-ee0d216245cd', N'5099', N'others major fault/repair', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'b9031e93-c2d3-4873-bd27-e25ee352bffe', N'8888', N'Testing', N'14C49177-021B-4141-912F-B83F92AA9A57')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'dd777872-008b-49be-9108-99a4a0378b4d', N'8888', N'Testing', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'f5a73f21-c7da-40fe-807d-055caa8c5a8e', N'8888', N'Testing', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'96da4f89-9a11-40bd-8af7-098ec2cafd06', N'8888', N'Testing', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'7b950c50-ff14-4d58-8bd6-ba0dac8558c9', N'8888', N'Testing', N'C84A84C9-6B5D-4C1F-9F26-3641F1DCD062')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'342a57ba-2271-46c5-8d71-5ea759778f7a', N'8888', N'Testing', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'398ea358-f064-4223-b400-7497b6e42968', N'8888', N'Testing', N'E9EDA476-FC54-412D-A75A-0D914A5784A0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'dfc80850-93db-4093-a25e-6fa7b4506670', N'9000', N'Servicing', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'62709fc7-3759-4896-a4bf-19e06c96ea99', N'9000', N'Servicing', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'69c46eb3-8f04-4628-82c3-4912129f49df', N'9900', N'Fault not known (mainswitch off by LEU/unknown)', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'cc991641-71ab-4647-8939-8c05c7f4139c', N'9999', N'Others', N'14C49177-021B-4141-912F-B83F92AA9A57')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'cdf97664-5c3c-46e9-9e92-be1fa6f90ffc', N'9999', N'Others', N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'fdd63ee0-639e-49c3-a00e-450f00c55202', N'9999', N'Others', N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'6b75589b-484a-4a97-9001-45079bd6a134', N'9999', N'Others', N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'a3a183ab-5fd5-4a38-963d-39052d3c6900', N'9999', N'Others', N'C84A84C9-6B5D-4C1F-9F26-3641F1DCD062')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'47418c1e-ffcf-4f74-a3b7-60b0d43b5d9f', N'9999', N'Others', N'DBEE28D0-FA8F-49BC-8C85-048A88911B95')
INSERT [dbo].[tbl_fault_code] ([col_fault_code_id], [col_fault_code], [col_fault_code_title], [col_device_category_id_fk]) VALUES (N'f74e4326-3dba-4899-9d60-d4e7dd1c1910', N'9999', N'Others', N'E9EDA476-FC54-412D-A75A-0D914A5784A0')
INSERT [dbo].[tbl_holidays] ([col_holiday_year], [col_holiday_start_date], [col_holiday_end_date], [col_holiday_title], [col_is_active]) VALUES (2022, CAST(N'2022-05-13T20:50:10.277' AS DateTime), CAST(N'2022-05-14T20:50:10.277' AS DateTime), N'GOOD FRIDAY', 1)
INSERT [dbo].[tbl_holidays] ([col_holiday_year], [col_holiday_start_date], [col_holiday_end_date], [col_holiday_title], [col_is_active]) VALUES (2022, CAST(N'2022-05-13T20:50:10.277' AS DateTime), CAST(N'2022-05-14T20:50:10.277' AS DateTime), N'NEW YEAR HOLIDAY', 1)
INSERT [dbo].[tbl_holidays] ([col_holiday_year], [col_holiday_start_date], [col_holiday_end_date], [col_holiday_title], [col_is_active]) VALUES (2022, CAST(N'2022-05-13T20:50:10.277' AS DateTime), CAST(N'2022-05-14T20:50:10.277' AS DateTime), N'CHINESE NEW YEAR HOLIDAY', 1)
INSERT [dbo].[tbl_holidays] ([col_holiday_year], [col_holiday_start_date], [col_holiday_end_date], [col_holiday_title], [col_is_active]) VALUES (2022, CAST(N'2022-05-13T20:50:10.277' AS DateTime), CAST(N'2022-05-14T20:50:10.277' AS DateTime), N'LABOUR DAY', 1)
INSERT [dbo].[tbl_holidays] ([col_holiday_year], [col_holiday_start_date], [col_holiday_end_date], [col_holiday_title], [col_is_active]) VALUES (2022, CAST(N'2022-05-13T20:50:10.277' AS DateTime), CAST(N'2022-05-14T20:50:10.277' AS DateTime), N'HARI RAYA PUASA', 1)
INSERT [dbo].[tbl_holidays] ([col_holiday_year], [col_holiday_start_date], [col_holiday_end_date], [col_holiday_title], [col_is_active]) VALUES (2022, CAST(N'2022-05-13T20:50:10.277' AS DateTime), CAST(N'2022-05-14T20:50:10.277' AS DateTime), N'LABOR DAY HOLIDAY', 1)
INSERT [dbo].[tbl_holidays] ([col_holiday_year], [col_holiday_start_date], [col_holiday_end_date], [col_holiday_title], [col_is_active]) VALUES (2022, CAST(N'2022-05-13T20:50:10.277' AS DateTime), CAST(N'2022-05-14T20:50:10.277' AS DateTime), N'VESAK DAY HOLIDAY', 1)
INSERT [dbo].[tbl_holidays] ([col_holiday_year], [col_holiday_start_date], [col_holiday_end_date], [col_holiday_title], [col_is_active]) VALUES (2022, CAST(N'2022-05-13T20:50:10.277' AS DateTime), CAST(N'2022-05-14T20:50:10.277' AS DateTime), N'HARI RAYA HAJI', 1)
INSERT [dbo].[tbl_holidays] ([col_holiday_year], [col_holiday_start_date], [col_holiday_end_date], [col_holiday_title], [col_is_active]) VALUES (2022, CAST(N'2022-05-13T20:50:10.277' AS DateTime), CAST(N'2022-05-14T20:50:10.277' AS DateTime), N'NATIONAL DAY', 1)
INSERT [dbo].[tbl_holidays] ([col_holiday_year], [col_holiday_start_date], [col_holiday_end_date], [col_holiday_title], [col_is_active]) VALUES (2022, CAST(N'2022-05-13T20:50:10.277' AS DateTime), CAST(N'2022-05-14T20:50:10.277' AS DateTime), N'DEEPAVALI', 1)
INSERT [dbo].[tbl_holidays] ([col_holiday_year], [col_holiday_start_date], [col_holiday_end_date], [col_holiday_title], [col_is_active]) VALUES (2022, CAST(N'2022-05-13T20:50:10.277' AS DateTime), CAST(N'2022-05-14T20:50:10.277' AS DateTime), N'CHRISTMAS HOLIDAY', 1)
INSERT [dbo].[tbl_logs] ([col_log_id], [col_log_description], [col_entry_date]) VALUES (N'07dee114-7cee-436b-a46e-4a43600f5b63', N'Hello', CAST(N'2022-05-17T14:55:28.280' AS DateTime))
INSERT [dbo].[tbl_maintenance] ([col_maintenance_id], [col_building_id], [col_equipment_contract_map_id_fk], [col_device_type_id_fk], [col_device_identification_letter_id_fk], [col_maintenance_entry_by], [col_maintenance_entry_date]) VALUES (N'MS-20220501-0001', N'S013B001', N'CC5EB4FF-4DAB-45F7-B064-96765B8F0372', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', N'D8C17170-24B0-47C5-A4AD-9F484B58784B', N'SYSTEM', CAST(N'2022-05-13T20:50:10.277' AS DateTime))
INSERT [dbo].[tbl_maintenance_details] ([col_maintenance_details_id], [col_maintenance_details_parent_id], [col_maintenance_id_fk], [col_maintenance_type], [col_frequency], [col_start_date], [col_end_date], [col_status], [col_duration], [col_reason], [col_completion_date], [col_remarks], [col_is_lta_granted], [col_lta_granted_by], [col_lta_granted_date], [col_update_by], [col_update_date]) VALUES (N'MS-20220501-0001L01', N'MS-20220501-0001L01', N'MS-20220501-0001', N'PM', N'M', CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T19:50:10.277' AS DateTime), N'P', 1, N'sample reason', CAST(N'2022-05-13T19:50:10.277' AS DateTime), N'Planned preventive maintenance schedule', 1, N'lta3', CAST(N'2022-05-13T20:50:10.277' AS DateTime), N'lta3', CAST(N'2022-05-13T20:50:10.277' AS DateTime))
INSERT [dbo].[tbl_maintenance_details] ([col_maintenance_details_id], [col_maintenance_details_parent_id], [col_maintenance_id_fk], [col_maintenance_type], [col_frequency], [col_start_date], [col_end_date], [col_status], [col_duration], [col_reason], [col_completion_date], [col_remarks], [col_is_lta_granted], [col_lta_granted_by], [col_lta_granted_date], [col_update_by], [col_update_date]) VALUES (N'MS-20220501-0001L02', N'MS-20220501-0001L01', N'MS-20220501-0001', N'EOT', N'M', CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T20:50:10.277' AS DateTime), N'P', 2, N'sample reason', CAST(N'2022-05-13T20:50:10.277' AS DateTime), N'Time Extended Planned preventive maintenance schedule', 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'14C49177-021B-4141-912F-B83F92AA9A57', N'C7AAF0A2-3C59-4393-946D-7268B71806BC', 0, 1, 0, 0, 0, 1)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'B1B849D0-763A-46BE-BFBC-2ACD41323843', 0, 0, 1, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'8AB106B5-A479-442A-AE77-5AB3AED315C3', 0, 0, 1, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'B8402674-1C9F-43ED-A6F7-5539CF8F4565', 0, 0, 1, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'68CDDC3E-BB10-468F-8A86-8A332810DEC3', 0, 1, 0, 1, 1, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'E32378CB-468E-4218-B2F1-19D43A239DEB', 0, 0, 1, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'7B30A030-EDF5-469F-BC86-9832E4897719', 0, 0, 1, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'5ADECD77-3282-4CE7-9E31-EC2D4A97CACA', 0, 0, 0, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'3060E2A3-996F-4754-BFC2-EF56073C73CE', 0, 0, 1, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'840719F6-A89F-48C5-B2B9-E56AC8C0B3C6', 0, 0, 1, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'81850B41-FA34-4D23-8DD9-00487051B985', 0, 0, 1, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'287A6A4F-580D-405C-BC90-195A22F30432', 0, 0, 1, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'40C86DF0-5B75-4D05-82AB-DEC97444A031', 0, 0, 1, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'62E1F911-47ED-4470-A9BC-2F485E01B18A', 0, 0, 1, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'E66B406F-E2B0-46B6-A96C-3367D6D9ABBF', 0, 0, 1, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'23985D84-6CA6-4F4B-A104-C1CBFABEDD1D', 0, 0, 1, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'F4C9AE31-279C-427C-B83C-74080A31F98D', 0, 0, 1, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'11098184-6C5A-4482-AB58-779452F7D1D2', 0, 0, 0, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'16EEB431-7A8A-47F0-B0D5-3470732BEBB6', N'80C93DA3-13D5-4FA5-A343-3A43A8697D69', 0, 1, 0, 0, 0, 1)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'9E065CE8-7083-4C41-AC26-4638B0BDCFEE', 0, 1, 0, 0, 1, 1)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'37DB5642-83C8-43AB-9BB4-EABDAF5C90D0', N'E0B8FD8C-CD3F-4629-BBDD-4AA3C9ADF14D', 0, 0, 0, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'E6732624-441F-4827-BA11-2A4930876C75', 0, 0, 0, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'51BFEDBF-7824-42EC-A6CE-CB7CC84997FA', N'C24007FF-2DB4-4B95-90FE-B9C8FF5D7018', 0, 1, 0, 0, 1, 1)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'C84A84C9-6B5D-4C1F-9F26-3641F1DCD062', N'A3F9A91E-B0F4-49E5-AC25-6121A6ABE9BE', 0, 0, 0, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', N'C151404A-99F7-4E45-A9A9-DDBDB7FEDB4B', 0, 1, 1, 0, 1, 1)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', N'EC87DDA5-9924-49E4-9AE0-7F4CDD778420', 1, 0, 0, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', N'0CA65F2F-B772-403E-8454-BD111882F670', 0, 1, 1, 1, 1, 1)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', N'0CA65F2F-B772-403E-8454-BD111882F670', 0, 0, 0, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', N'032A1811-3A17-4DF5-AFCA-58CC4EE6B5E6', 0, 1, 1, 0, 1, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', N'032A1811-3A17-4DF5-AFCA-58CC4EE6B5E6', 0, 1, 1, 0, 1, 1)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', N'1500C205-7710-4CF1-897D-C23A551BFF84', 0, 1, 0, 0, 0, 1)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', N'7463C496-C80F-47AD-BB7B-A0DB3AA949F7', 0, 0, 0, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', N'A92BCAC3-09BB-4E38-AA5E-665578F160AF', 0, 0, 0, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', N'5E3464FB-C721-4C92-BC74-B9CEC07D9EF2', 0, 0, 0, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'DBEE28D0-FA8F-49BC-8C85-048A88911B95', N'F6B42A17-1AAC-4569-8995-5437BFB464ED', 0, 1, 1, 0, 1, 1)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'E9EDA476-FC54-412D-A75A-0D914A5784A0', N'1625E12E-CB09-4867-AAA4-FDB19FBDAF6A', 0, 0, 0, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'E9EDA476-FC54-412D-A75A-0D914A5784A0', N'53FCCFBC-BD55-47FD-9B67-147D4F85C69D', 0, 1, 0, 0, 0, 0)
INSERT [dbo].[tbl_maintenance_frequency] ([col_device_category_id_fk], [col_device_type_id_fk], [col_is_frequency_weekly], [col_is_frequency_montly], [col_is_frequency_quarterly], [col_is_frequency_semi_anually], [col_is_frequency_anually], [col_is_key_switch_applicable]) VALUES (N'E9EDA476-FC54-412D-A75A-0D914A5784A0', N'80C93DA3-13D5-4FA5-A343-3A43A8697D69', 0, 1, 0, 0, 1, 1)
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'0e4d53e6-0b3e-4a86-a601-08d786c44fa0', N'Site & Escalation List', N'/quick-access/administration/site-escalation', NULL, N'd5a2023e-7d18-4f16-aafa-6246ed347b0e', 0, 0, N'0', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'b8ae8521-97b9-4e08-9d2c-1ad7986245cb', N'Notifications', N'/quick-access/maintenance/notifications', NULL, N'11326c33-25cb-459e-8f34-d3ab42cd8e3f', 0, 0, N'0', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'f0a5b7b1-31a8-46d8-be51-230840926cf2', N'Bit Map Table', N'/quick-access/administration/bit-map-table', NULL, N'd5a2023e-7d18-4f16-aafa-6246ed347b0e', 0, 0, N'0', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'55cc6c20-bdb9-443c-a75c-27549b27b083', N'Creation', N'/quick-access/maintenance/creation', NULL, N'11326c33-25cb-459e-8f34-d3ab42cd8e3f', 0, 0, N'0', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'66399b92-5495-4117-ac59-32a7dbd7a1cc', N'LTA Module', N'', N'engineering', N'0', 1, 0, N'0caabdce-36aa-4f39-b514-9ded6120083a', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'8e5c59e5-1fdc-439f-9b99-3334891689d2', N'Graph', N'/quick-access/maintenance/graph', NULL, N'11326c33-25cb-459e-8f34-d3ab42cd8e3f', 0, 0, N'0', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'86f77556-3ee7-4b1b-a1f9-3f08f2bdb891', N'Unclosed Cases', N'/alarm-actions/unclosed-alarm', N'notifications_off', N'0', 1, 0, N'46c73412-cb45-47ff-91d2-87f20987baaa', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'232018de-a648-48af-9f91-54adcdc5e7d9', N'Alarm Status Report', N'/quick-access/reports/alarm-status-report', NULL, N'd748369a-73fe-4f6f-b7ed-d96d68808af2', 0, 0, N'0', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'4609ba7c-ea51-4476-a76a-55bd01a080de', N'Monthly Availability Report', N'/quick-access/reports/monthly-availability-report', NULL, N'd748369a-73fe-4f6f-b7ed-d96d68808af2', 0, 0, N'0', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'd5a2023e-7d18-4f16-aafa-6246ed347b0e', N'Administration', N'', N'settings', N'0', 1, 0, N'0caabdce-36aa-4f39-b514-9ded6120083a', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'6c300678-dbff-470f-bc36-683c11a74084', N'Site Information', N'/quick-access/site-information', NULL, N'd5a2023e-7d18-4f16-aafa-6246ed347b0e', 0, 0, N'0', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'c29c1c9e-c17f-4a40-ae37-687937248869', N'Late Response Report', N'/quick-access/reports/late-response-report', NULL, N'd748369a-73fe-4f6f-b7ed-d96d68808af2', 0, 0, N'0', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'8543de7e-0829-4bbd-94f9-70d600d3b1fb', N'Menu-Child-1', N'/menu-child-1', NULL, N'4f0edbc0-9094-4f99-ab0c-a95921674ebf', 0, 0, N'0', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'8aa13834-4790-401c-91c0-71a900c2c4d9', N'Unclear Alarm', N'/alarm-actions/unclear-alarm', N'notifications_paused', N'0', 1, 0, N'46c73412-cb45-47ff-91d2-87f20987baaa', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'0f1730d7-d4f9-4249-acbc-742cabf0caad', N'Reference Tables', N'/quick-access/reference-tables', NULL, N'4f0edbc0-9094-4f99-ab0c-a95921674ebf', 0, 0, N'0', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'cf886b33-2eb7-4ec3-8316-76899beba1bb', N'Daily Fault Report Form-1', N'/quick-access/reports/dfr-form1', NULL, N'd748369a-73fe-4f6f-b7ed-d96d68808af2', 0, 0, N'0', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'caabca31-a62f-443a-88be-84d06c6b5280', N'View Device Alarms/Status', N'/quick-access/administration/view-device-alarms', NULL, N'd5a2023e-7d18-4f16-aafa-6246ed347b0e', 0, 0, N'0', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'46c73412-cb45-47ff-91d2-87f20987baaa', N'Alarm Actions', NULL, NULL, N'0', 0, 1, N'0', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'c48ea1f5-9926-45c0-8fbd-8824200310eb', N'Search Alarm/Status History', N'/quick-access/lta/search-alarm-history', NULL, N'66399b92-5495-4117-ac59-32a7dbd7a1cc', 0, 0, N'0', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'2de0e508-25f6-4017-9b2b-9bedb94bbb3c', N'Feedback List', N'/quick-access/lta/lta-feedback-list', NULL, N'66399b92-5495-4117-ac59-32a7dbd7a1cc', 0, 0, N'0', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'0caabdce-36aa-4f39-b514-9ded6120083a', N'Quick Access', NULL, NULL, N'0', 0, 1, N'0', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'c69674e2-88fd-47ad-b74a-a21caead9838', N'Monitoring', N'/quick-access/maintenance/monitoring', NULL, N'11326c33-25cb-459e-8f34-d3ab42cd8e3f', 0, 0, N'0', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'4f0edbc0-9094-4f99-ab0c-a95921674ebf', N'Reference Tables', N'', N'calendar_view_month', N'0', 1, 0, N'0caabdce-36aa-4f39-b514-9ded6120083a', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'546208bb-3ecf-4d33-a638-be66401e4f2f', N'Dashboard', N'/quick-access/dashboard', N'shopping_cart', N'0', 1, 0, N'0caabdce-36aa-4f39-b514-9ded6120083a', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'11326c33-25cb-459e-8f34-d3ab42cd8e3f', N'Maintenance Module', N'', N'event', N'0', 1, 0, N'0caabdce-36aa-4f39-b514-9ded6120083a', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'd748369a-73fe-4f6f-b7ed-d96d68808af2', N'Reports', N'', N'insert_chart_outlined', N'0', 1, 0, N'0caabdce-36aa-4f39-b514-9ded6120083a', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'01bfa2b9-bcad-4ba3-b72b-ebda957088e2', N'LTA2 Module', N'', N'Ico', N'0', 1, 0, N'0caabdce-36aa-4f39-b514-9ded6120083a', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'89632ec6-51a6-4ac9-8dea-f21c469f98b9', N'Daily Fault Report Form-2', N'/quick-access/reports/dfr-form2', NULL, N'd748369a-73fe-4f6f-b7ed-d96d68808af2', 0, 0, N'0', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_menus] ([col_menu_id], [col_menu_name], [col_url], [col_icon], [col_parent_id], [col_is_parent], [col_is_group], [col_group_id], [col_is_active], [col_timestamp]) VALUES (N'ee60b2ad-4720-4acc-8de8-ff6e63609173', N'New Alarm', N'/alarm-actions/new-alarm', N'notification_active', N'0', 1, 0, N'46c73412-cb45-47ff-91d2-87f20987baaa', 1, CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_object_bits] ([col_building_id_fk], [col_rtu_id_fk], [col_equipment_id_fk], [col_is_above64], [col_ifd_bit_1], [col_ifd_bit_2], [col_ifd_bit_3], [col_ifd_bit_4], [col_ifd_bit_5], [col_ifd_bit_6], [col_ifd_bit_7], [col_ifd_bit_8], [col_ifd_bit_9], [col_ifd_bit_10], [col_ifd_bit_11], [col_ifd_bit_12], [col_ifd_bit_13], [col_ifd_bit_14], [col_ifd_bit_15], [col_ifd_bit_16], [col_ifd_bit_1_date], [col_ifd_bit_2_date], [col_ifd_bit_3_date], [col_ifd_bit_4_date], [col_ifd_bit_5_date], [col_ifd_bit_6_date], [col_ifd_bit_7_date], [col_ifd_bit_8_date], [col_ifd_bit_9_date], [col_ifd_bit_10_date], [col_ifd_bit_11_date], [col_ifd_bit_12_date], [col_ifd_bit_13_date], [col_ifd_bit_14_date], [col_ifd_bit_15_date], [col_ifd_bit_16_date], [col_bit_1], [col_bit_2], [col_bit_3], [col_bit_4], [col_bit_5], [col_bit_6], [col_bit_7], [col_bit_8], [col_bit_9], [col_bit_10], [col_bit_11], [col_bit_12], [col_bit_13], [col_bit_14], [col_bit_15], [col_bit_16], [col_bit_17], [col_bit_18], [col_bit_19], [col_bit_20], [col_bit_21], [col_bit_22], [col_bit_23], [col_bit_24], [col_bit_25], [col_bit_26], [col_bit_27], [col_bit_28], [col_bit_29], [col_bit_30], [col_bit_31], [col_bit_32], [col_bit_33], [col_bit_34], [col_bit_35], [col_bit_36], [col_bit_37], [col_bit_38], [col_bit_39], [col_bit_40], [col_bit_41], [col_bit_42], [col_bit_43], [col_bit_44], [col_bit_45], [col_bit_46], [col_bit_47], [col_bit_48], [col_bit_49], [col_bit_50], [col_bit_51], [col_bit_52], [col_bit_53], [col_bit_54], [col_bit_55], [col_bit_56], [col_bit_57], [col_bit_58], [col_bit_59], [col_bit_60], [col_bit_61], [col_bit_62], [col_bit_63], [col_bit_64], [col_bit_1_date], [col_bit_2_date], [col_bit_3_date], [col_bit_4_date], [col_bit_5_date], [col_bit_6_date], [col_bit_7_date], [col_bit_8_date], [col_bit_9_date], [col_bit_10_date], [col_bit_11_date], [col_bit_12_date], [col_bit_13_date], [col_bit_14_date], [col_bit_15_date], [col_bit_16_date], [col_bit_17_date], [col_bit_18_date], [col_bit_19_date], [col_bit_20_date], [col_bit_21_date], [col_bit_22_date], [col_bit_23_date], [col_bit_24_date], [col_bit_25_date], [col_bit_26_date], [col_bit_27_date], [col_bit_28_date], [col_bit_29_date], [col_bit_30_date], [col_bit_31_date], [col_bit_32_date], [col_bit_33_date], [col_bit_34_date], [col_bit_35_date], [col_bit_36_date], [col_bit_37_date], [col_bit_38_date], [col_bit_39_date], [col_bit_40_date], [col_bit_41_date], [col_bit_42_date], [col_bit_43_date], [col_bit_44_date], [col_bit_45_date], [col_bit_46_date], [col_bit_47_date], [col_bit_48_date], [col_bit_49_date], [col_bit_50_date], [col_bit_51_date], [col_bit_52_date], [col_bit_53_date], [col_bit_54_date], [col_bit_55_date], [col_bit_56_date], [col_bit_57_date], [col_bit_58_date], [col_bit_59_date], [col_bit_60_date], [col_bit_61_date], [col_bit_62_date], [col_bit_63_date], [col_bit_64_date]) VALUES (N'S013B001', N'S013RTU01', N'S013RTU01EQ001', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_object_bits] ([col_building_id_fk], [col_rtu_id_fk], [col_equipment_id_fk], [col_is_above64], [col_ifd_bit_1], [col_ifd_bit_2], [col_ifd_bit_3], [col_ifd_bit_4], [col_ifd_bit_5], [col_ifd_bit_6], [col_ifd_bit_7], [col_ifd_bit_8], [col_ifd_bit_9], [col_ifd_bit_10], [col_ifd_bit_11], [col_ifd_bit_12], [col_ifd_bit_13], [col_ifd_bit_14], [col_ifd_bit_15], [col_ifd_bit_16], [col_ifd_bit_1_date], [col_ifd_bit_2_date], [col_ifd_bit_3_date], [col_ifd_bit_4_date], [col_ifd_bit_5_date], [col_ifd_bit_6_date], [col_ifd_bit_7_date], [col_ifd_bit_8_date], [col_ifd_bit_9_date], [col_ifd_bit_10_date], [col_ifd_bit_11_date], [col_ifd_bit_12_date], [col_ifd_bit_13_date], [col_ifd_bit_14_date], [col_ifd_bit_15_date], [col_ifd_bit_16_date], [col_bit_1], [col_bit_2], [col_bit_3], [col_bit_4], [col_bit_5], [col_bit_6], [col_bit_7], [col_bit_8], [col_bit_9], [col_bit_10], [col_bit_11], [col_bit_12], [col_bit_13], [col_bit_14], [col_bit_15], [col_bit_16], [col_bit_17], [col_bit_18], [col_bit_19], [col_bit_20], [col_bit_21], [col_bit_22], [col_bit_23], [col_bit_24], [col_bit_25], [col_bit_26], [col_bit_27], [col_bit_28], [col_bit_29], [col_bit_30], [col_bit_31], [col_bit_32], [col_bit_33], [col_bit_34], [col_bit_35], [col_bit_36], [col_bit_37], [col_bit_38], [col_bit_39], [col_bit_40], [col_bit_41], [col_bit_42], [col_bit_43], [col_bit_44], [col_bit_45], [col_bit_46], [col_bit_47], [col_bit_48], [col_bit_49], [col_bit_50], [col_bit_51], [col_bit_52], [col_bit_53], [col_bit_54], [col_bit_55], [col_bit_56], [col_bit_57], [col_bit_58], [col_bit_59], [col_bit_60], [col_bit_61], [col_bit_62], [col_bit_63], [col_bit_64], [col_bit_1_date], [col_bit_2_date], [col_bit_3_date], [col_bit_4_date], [col_bit_5_date], [col_bit_6_date], [col_bit_7_date], [col_bit_8_date], [col_bit_9_date], [col_bit_10_date], [col_bit_11_date], [col_bit_12_date], [col_bit_13_date], [col_bit_14_date], [col_bit_15_date], [col_bit_16_date], [col_bit_17_date], [col_bit_18_date], [col_bit_19_date], [col_bit_20_date], [col_bit_21_date], [col_bit_22_date], [col_bit_23_date], [col_bit_24_date], [col_bit_25_date], [col_bit_26_date], [col_bit_27_date], [col_bit_28_date], [col_bit_29_date], [col_bit_30_date], [col_bit_31_date], [col_bit_32_date], [col_bit_33_date], [col_bit_34_date], [col_bit_35_date], [col_bit_36_date], [col_bit_37_date], [col_bit_38_date], [col_bit_39_date], [col_bit_40_date], [col_bit_41_date], [col_bit_42_date], [col_bit_43_date], [col_bit_44_date], [col_bit_45_date], [col_bit_46_date], [col_bit_47_date], [col_bit_48_date], [col_bit_49_date], [col_bit_50_date], [col_bit_51_date], [col_bit_52_date], [col_bit_53_date], [col_bit_54_date], [col_bit_55_date], [col_bit_56_date], [col_bit_57_date], [col_bit_58_date], [col_bit_59_date], [col_bit_60_date], [col_bit_61_date], [col_bit_62_date], [col_bit_63_date], [col_bit_64_date]) VALUES (N'S013B001', N'S013RTU01', N'S013RTU01EQ003', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime), CAST(N'2022-05-13T18:50:10.277' AS DateTime))
INSERT [dbo].[tbl_operating_schedule] ([col_operating_schedule_id], [col_operating_schedule_title], [col_opertaing_time_start], [col_opertaing_time_end]) VALUES (N'98cc6cdc-eaf3-468b-92c3-d16583a4d944', N'Regular 1 (19)', CAST(N'05:00:00' AS Time), CAST(N'23:59:59' AS Time))
INSERT [dbo].[tbl_operating_schedule] ([col_operating_schedule_id], [col_operating_schedule_title], [col_opertaing_time_start], [col_opertaing_time_end]) VALUES (N'e7d557be-9df6-4f2b-b098-befeae774a7e', N'Regular 2 (24)', CAST(N'00:00:00' AS Time), CAST(N'23:59:59' AS Time))
INSERT [dbo].[tbl_operating_schedule] ([col_operating_schedule_id], [col_operating_schedule_title], [col_opertaing_time_start], [col_opertaing_time_end]) VALUES (N'd5a59f82-69b9-4689-8fea-7d072aee61ab', N'Schedule 1', CAST(N'07:00:00' AS Time), CAST(N'19:59:59' AS Time))
INSERT [dbo].[tbl_operating_schedule] ([col_operating_schedule_id], [col_operating_schedule_title], [col_opertaing_time_start], [col_opertaing_time_end]) VALUES (N'39ffb7e4-4516-4b86-b139-f7986b90044c', N'Schedule 2', CAST(N'12:00:00' AS Time), CAST(N'17:59:59' AS Time))
INSERT [dbo].[tbl_operating_schedule] ([col_operating_schedule_id], [col_operating_schedule_title], [col_opertaing_time_start], [col_opertaing_time_end]) VALUES (N'54b2f035-0192-4816-bdcc-00580b7ba901', N'Schedule 3', CAST(N'18:00:00' AS Time), CAST(N'07:59:59' AS Time))
INSERT [dbo].[tbl_operating_schedule] ([col_operating_schedule_id], [col_operating_schedule_title], [col_opertaing_time_start], [col_opertaing_time_end]) VALUES (N'53679a44-f7bd-4e16-8476-3ce36ce0f2fd', N'Schedule 4', CAST(N'18:00:00' AS Time), CAST(N'07:59:59' AS Time))
INSERT [dbo].[tbl_operating_schedule] ([col_operating_schedule_id], [col_operating_schedule_title], [col_opertaing_time_start], [col_opertaing_time_end]) VALUES (N'29172d68-4a85-40af-8edb-09d7543b677d', N'Schedule 5', CAST(N'19:00:00' AS Time), CAST(N'07:59:59' AS Time))
INSERT [dbo].[tbl_operating_schedule] ([col_operating_schedule_id], [col_operating_schedule_title], [col_opertaing_time_start], [col_opertaing_time_end]) VALUES (N'c5d87eed-e4dd-4df6-a191-0e693b7e86b5', N'Schedule 6', CAST(N'08:00:00' AS Time), CAST(N'22:59:59' AS Time))
INSERT [dbo].[tbl_roles] ([col_role_id], [col_role_name], [col_is_sms_roles], [col_menu_id_fk], [col_is_active]) VALUES (N'2aaba4fb-8853-47a3-8814-209f844ad9ce', N'LTA', 0, N'546208BB-3ECF-4D33-A638-BE66401E4F2F', 1)
INSERT [dbo].[tbl_roles] ([col_role_id], [col_role_name], [col_is_sms_roles], [col_menu_id_fk], [col_is_active]) VALUES (N'09d73372-da78-4173-81c3-431245558ec2', N'LTA2', 1, N'546208BB-3ECF-4D33-A638-BE66401E4F2F', 1)
INSERT [dbo].[tbl_roles] ([col_role_id], [col_role_name], [col_is_sms_roles], [col_menu_id_fk], [col_is_active]) VALUES (N'1f1b2a1b-3e5c-47a7-86ea-7b2f17d54c97', N'Admin', 0, N'546208BB-3ECF-4D33-A638-BE66401E4F2F', 1)
INSERT [dbo].[tbl_roles] ([col_role_id], [col_role_name], [col_is_sms_roles], [col_menu_id_fk], [col_is_active]) VALUES (N'2bb75332-5ab4-41bd-a62a-84e1b777ed2c', N'Contractor', 0, N'546208BB-3ECF-4D33-A638-BE66401E4F2F', 1)
INSERT [dbo].[tbl_roles] ([col_role_id], [col_role_name], [col_is_sms_roles], [col_menu_id_fk], [col_is_active]) VALUES (N'8adc2c85-e674-4047-b0b0-b11629b9588a', N'SP', 1, N'546208BB-3ECF-4D33-A638-BE66401E4F2F', 1)
INSERT [dbo].[tbl_roles] ([col_role_id], [col_role_name], [col_is_sms_roles], [col_menu_id_fk], [col_is_active]) VALUES (N'f4e8e437-e05f-46b1-af0b-de40ccc70303', N'ENGR', 1, N'546208BB-3ECF-4D33-A638-BE66401E4F2F', 1)
INSERT [dbo].[tbl_roles] ([col_role_id], [col_role_name], [col_is_sms_roles], [col_menu_id_fk], [col_is_active]) VALUES (N'd2222674-2318-41fd-83d5-f387ed64a3ae', N'PM', 1, N'546208BB-3ECF-4D33-A638-BE66401E4F2F', 1)
INSERT [dbo].[tbl_roles] ([col_role_id], [col_role_name], [col_is_sms_roles], [col_menu_id_fk], [col_is_active]) VALUES (N'e21dec1a-2243-4968-9f47-f3dc59607f5d', N'LTA1', 1, N'546208BB-3ECF-4D33-A638-BE66401E4F2F', 1)
INSERT [dbo].[tbl_roles] ([col_role_id], [col_role_name], [col_is_sms_roles], [col_menu_id_fk], [col_is_active]) VALUES (N'bd6f2db4-945c-4f09-87b2-fce42a9615d0', N'CC', 1, N'546208BB-3ECF-4D33-A638-BE66401E4F2F', 1)
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'4b61d2b4-9993-4e49-a18d-008bd3382624', 2, N'RS485 Signal Board Issue')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'65f7ad49-e612-4947-8477-01345cc692d5', 16, N'Lift Breakdown. Please Check.')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'46ca10cb-fae9-4b6d-86bc-060180a2d742', 13, N'Lift Fault 13')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'257297f3-5c20-490c-9838-0f364ebcd62b', 6, N'Lift Controller Board Issue')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'58c1175a-e5a4-4606-a99e-1579cc31471b', 31, N'Lift Fault 31')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'7a3ecb4b-b145-4685-9441-23f0313e7d97', 25, N'Lift Fault 25')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'0454378a-70de-41f0-865c-2ddb53d0916b', 15, N'Car Call Button Jammed')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'832ffea3-1188-4390-8b32-3b94e83a3d9a', 4, N'Lift Power Issue')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'e83c0689-78c2-40f3-8192-41ca1591f4f6', 24, N'Lift Fault 24')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'48c742a4-b2ec-4515-abb0-455f36a26876', 3, N'Trap door opens without inserting LM Key')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'b90ec46f-26bd-4a5e-acde-471d44ee0ed9', 1, N'RS485 Signal Board Power Supply')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'6575e635-b80b-4708-856d-5833bc466882', 10, N'Lift Fault 10')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'3eb1278b-f89f-4df5-8dd3-595a4dd17a03', 21, N'Lift Fault 21')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'b24c901f-af98-46d5-be31-5c3b28c6b880', 11, N'Door Opening Problem')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'f63a485b-993e-4216-9aed-5de98542eeb8', 26, N'Lift Fault 26')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'0fca1183-4068-437a-916e-600842fcd138', 12, N'Door Closing Problem')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'6cc7ee57-a289-4d53-a45a-65bf80dbdd7f', 0, N'Lift Running Well')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'06870e44-e1a1-4625-8800-7acbaffa16fd', 30, N'Lift Fault 30')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'506f5159-23b6-464e-86dc-7f517d5c0549', 29, N'Lift Fault 29')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'59cb120c-494d-47ca-9729-806d25978b47', 22, N'Lift Fault 22')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'f8897761-d45d-463f-86dc-ad62d1ed6b46', 8, N'Hall Button Jammed')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'56f83f50-a336-4fda-b481-addf84f9960f', 9, N'Lift Fault 9')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'104925b1-3bad-46c6-93c6-b2b2e01b6a45', 28, N'Lift Fault 28')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'90cc9a66-6048-4f39-83c4-b8fe2f72ff0d', 19, N'Door Lock Shorted')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'51bd64fb-bd8d-4010-9816-bc8619b73e3f', 20, N'EBOPS Fuse (alm bell,siren & pts) OC')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'bb8956f4-411f-420f-b154-c9b56f7851ac', 27, N'Lift Fault 27')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'ca126c45-5bcd-4515-9937-cde59367a13c', 7, N'Lift Over/Under Speed')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'a82b9fa9-8b66-4488-b2b7-d1b8df3c848f', 14, N'Lift Fault 14')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'a358f830-e9ac-4615-8368-d37aa0368c6a', 17, N'Lift Fault 17')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'7a4214c0-5d5c-4cbb-ad94-d7fa3aec1851', 23, N'Lift Fault 23')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'87b18964-6dad-42c5-b102-e1e7a3abbccb', 18, N'Lift Fault 18')
INSERT [dbo].[tbl_rs485_valuedefine] ([col_rs485_valuedefine_id], [col_bi_int], [col_bi_description]) VALUES (N'11e7c4b7-6723-44a8-a8ce-ea97f08059b7', 5, N'Safety Line interrupted')
INSERT [dbo].[tbl_rtu] ([col_rtu_id], [col_building_id_fk], [col_config_id_fk], [col_dg_setup_id_fk], [col_rtu_ip_address], [col_baudrate], [col_hardware_version], [col_dvr_type], [col_dvr_ip_address], [col_dvr_term], [col_iems_dvr_ip], [col_remarks], [col_setup_date], [col_enabledisablestatus], [col_day_night_flag], [col_is_online], [col_is_active]) VALUES (N'S013RTU01', N'S013B001', N'78BEBE73-4900-43FE-AE08-35F9EC82AAE7', N'E9A643E4-A431-4F3B-97F5-382F638A0959', N'10.5.21.10', 2400, N'WGND', N'WGT', N'5.21.10.15', N'7', N'85269412', N'Test Remarks', CAST(N'2022-04-24T22:29:07.933' AS DateTime), 1, NULL, 1, 1)
INSERT [dbo].[tbl_rtu] ([col_rtu_id], [col_building_id_fk], [col_config_id_fk], [col_dg_setup_id_fk], [col_rtu_ip_address], [col_baudrate], [col_hardware_version], [col_dvr_type], [col_dvr_ip_address], [col_dvr_term], [col_iems_dvr_ip], [col_remarks], [col_setup_date], [col_enabledisablestatus], [col_day_night_flag], [col_is_online], [col_is_active]) VALUES (N'S013RTU02', N'S013B001', N'78BEBE73-4900-43FE-AE08-35F9EC82AAE7', N'E9A643E4-A431-4F3B-97F5-382F638A0959', N'10.5.21.11', 2400, N'WGND', N'WGT', N'5.21.10.16', N'7', N'85269414', N'Test Remarks', CAST(N'2022-04-24T22:29:07.933' AS DateTime), 1, NULL, 1, 1)
INSERT [dbo].[tbl_rtu] ([col_rtu_id], [col_building_id_fk], [col_config_id_fk], [col_dg_setup_id_fk], [col_rtu_ip_address], [col_baudrate], [col_hardware_version], [col_dvr_type], [col_dvr_ip_address], [col_dvr_term], [col_iems_dvr_ip], [col_remarks], [col_setup_date], [col_enabledisablestatus], [col_day_night_flag], [col_is_online], [col_is_active]) VALUES (N'S013RTU03', N'S013B001', N'78BEBE73-4900-43FE-AE08-35F9EC82AAE7', N'0E10AC49-BBC1-4A7D-AD78-EF5D9BED41DA', N'10.5.21.12', 2400, N'WGND', N'WGT', N'5.21.10.17', N'7', N'85269416', N'Test Remarks', CAST(N'2022-04-24T22:29:07.933' AS DateTime), 1, NULL, 1, 1)
INSERT [dbo].[tbl_sites] ([col_site_id], [col_address_code], [col_postal_code], [col_address], [col_is_active]) VALUES (N'S013', N'C', N'52714', N'Bukit Merah Central / Linking Bus Interchange & NTUC', 1)
INSERT [dbo].[tbl_users] ([col_user_id], [col_user_name], [col_full_name], [col_email], [col_sms_phone_nbr], [col_password], [col_password_salt], [col_otp], [col_otp_expiry_time], [col_is_active], [col_entry_by], [col_entry_date], [col_updated_by], [col_updated_date], [col_is_deleted], [col_deleted_by]) VALUES (N'e9d03a99-ddef-40c9-b81b-2126742e52db', N'lta3', N'LTA 03', N'lta3@cfems.com', N'321456789', N'a7rAsHLRREwWBai8TAmV/kkaQoV9WmZ0cAKiJDyNTG9wiziXJBpOISB3C+9ujiycx/7ETMB/mGemltBx/3TMVQ==', N'Y2ZlbXM=', NULL, NULL, 1, N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), 0, NULL)
INSERT [dbo].[tbl_users] ([col_user_id], [col_user_name], [col_full_name], [col_email], [col_sms_phone_nbr], [col_password], [col_password_salt], [col_otp], [col_otp_expiry_time], [col_is_active], [col_entry_by], [col_entry_date], [col_updated_by], [col_updated_date], [col_is_deleted], [col_deleted_by]) VALUES (N'bd255a25-1f53-4a45-9594-39e25dd7be45', N'ltakone', N'LTA Kone', N'ltakone@cfems.com', N'213456789', N'a7rAsHLRREwWBai8TAmV/kkaQoV9WmZ0cAKiJDyNTG9wiziXJBpOISB3C+9ujiycx/7ETMB/mGemltBx/3TMVQ==', N'Y2ZlbXM=', NULL, NULL, 1, N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), 0, NULL)
INSERT [dbo].[tbl_users] ([col_user_id], [col_user_name], [col_full_name], [col_email], [col_sms_phone_nbr], [col_password], [col_password_salt], [col_otp], [col_otp_expiry_time], [col_is_active], [col_entry_by], [col_entry_date], [col_updated_by], [col_updated_date], [col_is_deleted], [col_deleted_by]) VALUES (N'49b02bc8-1efe-4622-bad3-48673ff791f3', N'lta 2', N'LTA 02', N'lta2@cfems.com', N'987654321', N'a7rAsHLRREwWBai8TAmV/kkaQoV9WmZ0cAKiJDyNTG9wiziXJBpOISB3C+9ujiycx/7ETMB/mGemltBx/3TMVQ==', N'Y2ZlbXM=', NULL, NULL, 1, N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), 0, NULL)
INSERT [dbo].[tbl_users] ([col_user_id], [col_user_name], [col_full_name], [col_email], [col_sms_phone_nbr], [col_password], [col_password_salt], [col_otp], [col_otp_expiry_time], [col_is_active], [col_entry_by], [col_entry_date], [col_updated_by], [col_updated_date], [col_is_deleted], [col_deleted_by]) VALUES (N'8cdb9375-765a-489f-be5b-52f5f9738ea4', N'ltakone4', N'LTA Kone 04', N'ltakone@cfems.com', N'213546789', N'a7rAsHLRREwWBai8TAmV/kkaQoV9WmZ0cAKiJDyNTG9wiziXJBpOISB3C+9ujiycx/7ETMB/mGemltBx/3TMVQ==', N'Y2ZlbXM=', NULL, NULL, 1, N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), 0, NULL)
INSERT [dbo].[tbl_users] ([col_user_id], [col_user_name], [col_full_name], [col_email], [col_sms_phone_nbr], [col_password], [col_password_salt], [col_otp], [col_otp_expiry_time], [col_is_active], [col_entry_by], [col_entry_date], [col_updated_by], [col_updated_date], [col_is_deleted], [col_deleted_by]) VALUES (N'046c3a6c-a516-4adc-b453-63da04866432', N'admin', N'Administrator', N'admin@cfems.com', N'123456789', N'a7rAsHLRREwWBai8TAmV/kkaQoV9WmZ0cAKiJDyNTG9wiziXJBpOISB3C+9ujiycx/7ETMB/mGemltBx/3TMVQ==', N'Y2ZlbXM=', NULL, NULL, 1, N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), 0, NULL)
INSERT [dbo].[tbl_users] ([col_user_id], [col_user_name], [col_full_name], [col_email], [col_sms_phone_nbr], [col_password], [col_password_salt], [col_otp], [col_otp_expiry_time], [col_is_active], [col_entry_by], [col_entry_date], [col_updated_by], [col_updated_date], [col_is_deleted], [col_deleted_by]) VALUES (N'082deb74-e343-4e58-9763-89477ac448ff', N'ltakone1', N'LTA Kone 01', N'ltakone@cfems.com', N'213546789', N'a7rAsHLRREwWBai8TAmV/kkaQoV9WmZ0cAKiJDyNTG9wiziXJBpOISB3C+9ujiycx/7ETMB/mGemltBx/3TMVQ==', N'Y2ZlbXM=', NULL, NULL, 1, N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), 0, NULL)
INSERT [dbo].[tbl_users] ([col_user_id], [col_user_name], [col_full_name], [col_email], [col_sms_phone_nbr], [col_password], [col_password_salt], [col_otp], [col_otp_expiry_time], [col_is_active], [col_entry_by], [col_entry_date], [col_updated_by], [col_updated_date], [col_is_deleted], [col_deleted_by]) VALUES (N'cdbc74a7-5317-4795-a6a4-8ba0d363d63c', N'ltakone2', N'LTA Kone 02', N'ltakone@cfems.com', N'213546789', N'a7rAsHLRREwWBai8TAmV/kkaQoV9WmZ0cAKiJDyNTG9wiziXJBpOISB3C+9ujiycx/7ETMB/mGemltBx/3TMVQ==', N'Y2ZlbXM=', NULL, NULL, 1, N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), 0, NULL)
INSERT [dbo].[tbl_users] ([col_user_id], [col_user_name], [col_full_name], [col_email], [col_sms_phone_nbr], [col_password], [col_password_salt], [col_otp], [col_otp_expiry_time], [col_is_active], [col_entry_by], [col_entry_date], [col_updated_by], [col_updated_date], [col_is_deleted], [col_deleted_by]) VALUES (N'f1463a18-7f27-4eb0-ad24-917a9db605ec', N'ltakone5', N'LTA Kone 05', N'ltakone@cfems.com', N'213546789', N'a7rAsHLRREwWBai8TAmV/kkaQoV9WmZ0cAKiJDyNTG9wiziXJBpOISB3C+9ujiycx/7ETMB/mGemltBx/3TMVQ==', N'Y2ZlbXM=', NULL, NULL, 1, N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), 0, NULL)
INSERT [dbo].[tbl_users] ([col_user_id], [col_user_name], [col_full_name], [col_email], [col_sms_phone_nbr], [col_password], [col_password_salt], [col_otp], [col_otp_expiry_time], [col_is_active], [col_entry_by], [col_entry_date], [col_updated_by], [col_updated_date], [col_is_deleted], [col_deleted_by]) VALUES (N'4bfb14b6-c0d1-481b-9b44-a0c823b9f88f', N'abc1', N'ABC 1', N'abc@a.com', N'213546789', N'a7rAsHLRREwWBai8TAmV/kkaQoV9WmZ0cAKiJDyNTG9wiziXJBpOISB3C+9ujiycx/7ETMB/mGemltBx/3TMVQ==', N'Y2ZlbXM=', NULL, NULL, 1, N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), 0, NULL)
INSERT [dbo].[tbl_users] ([col_user_id], [col_user_name], [col_full_name], [col_email], [col_sms_phone_nbr], [col_password], [col_password_salt], [col_otp], [col_otp_expiry_time], [col_is_active], [col_entry_by], [col_entry_date], [col_updated_by], [col_updated_date], [col_is_deleted], [col_deleted_by]) VALUES (N'a08a8ad4-850c-4dcc-898b-b577bb1fdade', N'ltakone3', N'LTA Kone 03', N'ltakone@cfems.com', N'213546789', N'a7rAsHLRREwWBai8TAmV/kkaQoV9WmZ0cAKiJDyNTG9wiziXJBpOISB3C+9ujiycx/7ETMB/mGemltBx/3TMVQ==', N'Y2ZlbXM=', NULL, NULL, 1, N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), 0, NULL)
INSERT [dbo].[tbl_users] ([col_user_id], [col_user_name], [col_full_name], [col_email], [col_sms_phone_nbr], [col_password], [col_password_salt], [col_otp], [col_otp_expiry_time], [col_is_active], [col_entry_by], [col_entry_date], [col_updated_by], [col_updated_date], [col_is_deleted], [col_deleted_by]) VALUES (N'372f3e6c-0527-48d1-bbe2-f076a5d9c1e1', N'lta 1', N'LTA 01', N'lta1@cfems.com', N'123456798', N'a7rAsHLRREwWBai8TAmV/kkaQoV9WmZ0cAKiJDyNTG9wiziXJBpOISB3C+9ujiycx/7ETMB/mGemltBx/3TMVQ==', N'Y2ZlbXM=', NULL, NULL, 1, N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), N'admin', CAST(N'2022-05-13T18:50:10.277' AS DateTime), 0, NULL)
ALTER TABLE [dbo].[tbl_bitmap] ADD  CONSTRAINT [DF_tbl_lta_bitmap_col_bitmap_id]  DEFAULT (newid()) FOR [col_bitmap_id]
GO
ALTER TABLE [dbo].[tbl_buildings] ADD  CONSTRAINT [DF_tbl_buildings_building_id]  DEFAULT (newid()) FOR [col_building_id]
GO
ALTER TABLE [dbo].[tbl_configs] ADD  CONSTRAINT [DF_tbl_configs_config_id]  DEFAULT (newid()) FOR [col_config_id]
GO
ALTER TABLE [dbo].[tbl_contractor_company] ADD  CONSTRAINT [DF_tbl_lta_contractor_company_col_contractor_company_id]  DEFAULT (newid()) FOR [col_contractor_company_id]
GO
ALTER TABLE [dbo].[tbl_contracts] ADD  DEFAULT (newid()) FOR [col_contract_id]
GO
ALTER TABLE [dbo].[tbl_device_category] ADD  DEFAULT (newid()) FOR [col_device_category_id]
GO
ALTER TABLE [dbo].[tbl_device_identfication_group] ADD  CONSTRAINT [DF_Table_1_col_device_identification_letter_id]  DEFAULT (newid()) FOR [col_device_identification_group_id]
GO
ALTER TABLE [dbo].[tbl_device_identification_letter] ADD  DEFAULT (newid()) FOR [col_device_identification_letter_id]
GO
ALTER TABLE [dbo].[tbl_device_sub_type] ADD  CONSTRAINT [DF_Table_1_col_device_description_id]  DEFAULT (newid()) FOR [col_device_sub_type_id]
GO
ALTER TABLE [dbo].[tbl_device_type] ADD  CONSTRAINT [DF__tbl_devic__col_d__43D61337]  DEFAULT (newid()) FOR [col_device_type_id]
GO
ALTER TABLE [dbo].[tbl_device_type] ADD  CONSTRAINT [DF_tbl_device_type_col_is_active]  DEFAULT ((0)) FOR [col_is_active]
GO
ALTER TABLE [dbo].[tbl_dg_maintenance_company] ADD  CONSTRAINT [DF_tbl_dg_maintenance_company_col_dg_maintenance_company_id]  DEFAULT (newid()) FOR [col_dg_maintenance_company_id]
GO
ALTER TABLE [dbo].[tbl_dg_setup] ADD  CONSTRAINT [DF_tbl_dg_setup_col_dg_setup_id]  DEFAULT (newid()) FOR [col_dg_setup_id]
GO
ALTER TABLE [dbo].[tbl_dg_vm_setup] ADD  CONSTRAINT [DF_tbl_dg_vm_setup_col_dg_vm_setup_id]  DEFAULT (newid()) FOR [col_dg_vm_setup_id]
GO
ALTER TABLE [dbo].[tbl_diagnosis_rules] ADD  CONSTRAINT [DF_tbl_diagnosis_rules_col_diagnosis_rules_id]  DEFAULT (newid()) FOR [col_diagnosis_rules_id]
GO
ALTER TABLE [dbo].[tbl_diagnosis_rules_details] ADD  CONSTRAINT [DF_tbl_diagnosis_rules_details_col_diagnosis_rule_details_id]  DEFAULT (newid()) FOR [col_diagnosis_rule_details_id]
GO
ALTER TABLE [dbo].[tbl_entity_heartbeat] ADD  CONSTRAINT [DF_tbl_entity_heartbeat_col_entity_heartbeat_id
col_entity_heartbeat_idcol_entity_heartbeat_id
col_entity_heartbeat_id]  DEFAULT (newid()) FOR [col_entity_heartbeat_id]
GO
ALTER TABLE [dbo].[tbl_equipment_group] ADD  DEFAULT (newid()) FOR [col_equipment_group_id]
GO
ALTER TABLE [dbo].[tbl_equipments_contracts] ADD  CONSTRAINT [DF_tbl_equipments_contracts_col_equipment_contract_map_id]  DEFAULT (newid()) FOR [col_equipment_contract_map_id]
GO
ALTER TABLE [dbo].[tbl_equipments_contracts] ADD  CONSTRAINT [DF_tbl_equipments_contracts_col_entry_date]  DEFAULT ([dbo].[fn_singapore_time]()) FOR [col_entry_date]
GO
ALTER TABLE [dbo].[tbl_error_logs] ADD  CONSTRAINT [DF_tbl_logs_col_log_id]  DEFAULT (newid()) FOR [col_log_id]
GO
ALTER TABLE [dbo].[tbl_error_logs] ADD  CONSTRAINT [DF_tbl_logs_col_entry_date]  DEFAULT ([dbo].[fn_singapore_time]()) FOR [col_entry_date]
GO
ALTER TABLE [dbo].[tbl_fault_code] ADD  DEFAULT (newid()) FOR [col_fault_code_id]
GO
ALTER TABLE [dbo].[tbl_logs] ADD  CONSTRAINT [DF_tbl_logs_col_log_id_1]  DEFAULT (newid()) FOR [col_log_id]
GO
ALTER TABLE [dbo].[tbl_logs] ADD  CONSTRAINT [DF_tbl_logs_col_entry_date_1]  DEFAULT ([dbo].[fn_singapore_time]()) FOR [col_entry_date]
GO
ALTER TABLE [dbo].[tbl_menus] ADD  CONSTRAINT [DF_tbl_menus_col_menu_id]  DEFAULT (newid()) FOR [col_menu_id]
GO
ALTER TABLE [dbo].[tbl_operating_schedule] ADD  CONSTRAINT [DF__tbl_lta_s__col_s__503BEA1C]  DEFAULT (newid()) FOR [col_operating_schedule_id]
GO
ALTER TABLE [dbo].[tbl_roles] ADD  DEFAULT (newid()) FOR [col_role_id]
GO
ALTER TABLE [dbo].[tbl_rs485_valuedefine] ADD  CONSTRAINT [DF_tbl_rs485_valuedefine_col_rs485_valuedefine_id]  DEFAULT (newid()) FOR [col_rs485_valuedefine_id]
GO
ALTER TABLE [dbo].[tbl_sites] ADD  CONSTRAINT [DF_tbl_sites_site_id]  DEFAULT (newid()) FOR [col_site_id]
GO
ALTER TABLE [dbo].[tbl_tokens] ADD  CONSTRAINT [DF_Table_1_token_id]  DEFAULT (newid()) FOR [col_token_id]
GO
ALTER TABLE [dbo].[tbl_users] ADD  CONSTRAINT [DF_tbl_users_user_id]  DEFAULT (newid()) FOR [col_user_id]
GO
ALTER TABLE [dbo].[tbl_users] ADD  CONSTRAINT [DF_tbl_users_col_entry_date]  DEFAULT ([dbo].[fn_singapore_time]()) FOR [col_entry_date]
GO
/****** Object:  StoredProcedure [dbo].[sp_error_logs_collector]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_error_logs_collector]
AS
DECLARE 
	@err_msg varchar(500),
	@err_nbr int,
	@err_severity int,
	@err_state int,
	@err_line int,
	@err_procedure varchar(100);
	
SELECT
	@err_msg=ERROR_MESSAGE(),  
	@err_nbr= ERROR_NUMBER(),  
	@err_severity= ERROR_SEVERITY(),  
	@err_state = ERROR_STATE(),  
	@err_line= ERROR_LINE(),  
	@err_procedure =  ERROR_PROCEDURE();

INSERT INTO dbo.tbl_error_logs(col_log_description,col_error_number,col_error_severity,col_error_state,col_error_procedure,col_error_line)
values(@err_msg, @err_nbr, @err_severity, @err_state, @err_procedure, @err_line);
GO
/****** Object:  StoredProcedure [dbo].[sp_insert_alarms]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_insert_alarms] @building_id varchar(36), @equipment_id varchar(36), @bit_nbr tinyint, @is_above64 bit, @bit_val bit, @is_ifd_bit bit=0
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;
		DECLARE @device_id varchar(36), @bit_type varchar(30), @is_status_invert bit, @operating_schedule_id varchar(36), @bit_mask bit, @bit_start smallint, @bit_end smallint, @bit_desc varchar(500), @alarm_date datetime, @analog_unit varchar(5), @device_category varchar(150), @device_type varchar(150), @device_sub_type varchar (500), @building_title varchar(250), @device_desc varchar(250),@is_on_test bit;

		IF EXISTS(
					SELECT  bm.* 
					FROM  tbl_bitmap bm 
					WHERE bm.col_equipment_id_fk = @equipment_id 
					AND (bm.col_bit_start = @bit_nbr OR bm.col_bit_end = @bit_nbr) 
					AND bm.col_is_above64 = @is_above64 
					AND bm.col_is_ifd_bit=@is_ifd_bit
				)
			SELECT
				@device_id=bm.col_device_id_fk,
				@bit_type = bm.col_bit_type,
				@is_status_invert=bm.col_is_status_invert,
				@operating_schedule_id = bm.col_operating_schedule_id_fk,
				@bit_mask = bm.col_mask, 
				@bit_start = bm.col_bit_start,
				@bit_end=bm.col_bit_end,
				@bit_desc = bm.col_alarm_description,
				@analog_unit=bm.col_analog_unit
			FROM tbl_bitmap bm
			WHERE bm.col_equipment_id_fk = @equipment_id 
			AND (bm.col_bit_start = @bit_nbr OR bm.col_bit_end = @bit_nbr) 
			AND bm.col_is_above64 = @is_above64 
			AND bm.col_is_ifd_bit=@is_ifd_bit;
		ELSE
			SELECT 
				@device_id=bm.col_device_id_fk,
				@bit_type = bm.col_bit_type,
				@is_status_invert=bm.col_is_status_invert,
				@operating_schedule_id = bm.col_operating_schedule_id_fk,
				@bit_mask = bm.col_mask, 
				@bit_start = bm.col_bit_start,
				@bit_end=bm.col_bit_end,
				@bit_desc = bm.col_alarm_description,
				@analog_unit=bm.col_analog_unit
			FROM  tbl_bitmap bm
			WHERE bm.col_equipment_id_fk = @equipment_id 
			AND (@bit_nbr BETWEEN bm.col_bit_start AND bm.col_bit_end) 
			AND bm.col_is_above64 = @is_above64 
			AND bm.col_is_ifd_bit=@is_ifd_bit;

		SELECT
			@device_desc=d.col_device_desc,
			@device_category= dc.col_device_category_title, 
			@device_type= dt.col_device_type_title, 
			@device_sub_type= dst.col_device_sub_type_title 
		FROM tbl_devices d 
		LEFT JOIN dbo.tbl_device_category dc ON d.col_device_category_id_fk=dc.col_device_category_id 
		LEFT JOIN dbo.tbl_device_type dt ON d.col_device_type_id_fk=dt.col_device_type_id 
		LEFT JOIN dbo.tbl_device_sub_type dst ON d.col_device_sub_type_id_fk=dst.col_device_sub_type_id 
		WHERE d.col_equipment_id_fk=@equipment_id 
		AND d.col_device_id=@device_id;

		SELECT @alarm_date = ([dbo].[fn_singapore_time]());
		SELECT @building_title= col_building_title,@is_on_test=col_is_on_test FROM tbl_buildings WHERE col_building_id=@building_id;

		IF @operating_schedule_id IS NOT NULL
			BEGIN 
				DECLARE @curr_time time(0), @start_time time(0), @end_time time(0);
				SET @curr_time =CAST(([dbo].[fn_singapore_time]()) AS time(0));
				SELECT @start_time = col_opertaing_time_start, @end_time = col_opertaing_time_end FROM tbl_operating_schedule WHERE col_operating_schedule_id =	@operating_schedule_id;
			
				IF (@curr_time NOT BETWEEN @start_time AND @end_time)
					RETURN;

			END; 

		IF (@bit_val = 1 AND @is_status_invert = 0) OR (@bit_val = 0 AND @is_status_invert = 1) --AND @bit_mask=0 --Need to check proper placement of @bit_mask check
			BEGIN
				PRINT 'New Alarm';
				IF EXISTS(SELECT * FROM tbl_alarms WHERE col_building_id_fk = @building_id AND col_device_id_fk = @device_id AND col_alarm_clear_date IS NULL AND col_closed_date IS NULL)-- OR @bit_mask=1
					BEGIN
						RETURN;
					END;
				ELSE
					BEGIN
						DECLARE @alarm_case_id varchar(50), @analog_value float, @is_rs485 bit, @equipment_group varchar(30), @contractor_company_id varchar(36), @contract_id varchar(36);

						--CaseIdGeneration
						EXEC [sp_insert_case_id] @alarm_case_id output;

						--KeySwitch
						EXEC [dbo].[sp_process_masking] @device_sub_type,@equipment_id,1;

						SELECT 
							@equipment_group=eqgrp.col_equipment_group_title ,
							@is_rs485=eq.col_is_rs485
						FROM dbo.tbl_equipments eq 
						LEFT JOIN dbo.tbl_equipment_group eqgrp ON	eq.col_equipment_group_id_fk=eqgrp.col_equipment_group_id 
						WHERE eq.col_equipment_id=@equipment_id;

						--LiftRS485
						IF @is_rs485 =1 AND @equipment_group='LIFT' AND @bit_nbr BETWEEN 4 AND 8
							BEGIN 
								DECLARE @bi_description varchar(350), @bi_int int, @bit_str varchar(10);
								SELECT 
									@bit_str=CONVERT(char(1),col_bit_8)+CONVERT(char(1),col_bit_7)+CONVERT(char(1),col_bit_6)+CONVERT(char(1),col_bit_5)+CONVERT(char(1),col_bit_4) 
								FROM tbl_object_bits 
								WHERE col_equipment_id_fk=@equipment_id;

								SET @bi_int=dbo.fn_binary_to_decimal(@bit_str);
								select @bi_description= col_bi_description from tbl_rs485_valuedefine where  col_bi_int = @bi_int;
								IF @bi_int != 0
									update tbl_bitmap set col_alarm_description = @bi_description where col_device_id_fk = @device_id;
							END;

						--AnalogPoint
						IF @bit_type='AI'
							BEGIN
								PRINT 'Analog points';
								EXEC dbo.sp_lta_process_analog_bits @equipment_id,@bit_end,@is_above64,@analog_value output;

								PRINT 'Analog latest value insert/update section';
								IF EXISTS(SELECT * FROM dbo.tbl_analog_values WHERE col_building_id_fk=@building_id AND col_equipment_id_fk=@equipment_id AND col_device_id_fk =@device_id)
									BEGIN
										UPDATE [dbo].[tbl_analog_values] 
										SET [col_analog_value]=@analog_value 
										WHERE col_building_id_fk=@building_id 
										AND col_equipment_id_fk=@equipment_id 
										AND col_device_id_fk =@device_id;
									END;
								ELSE
									BEGIN
										INSERT INTO [dbo].[tbl_analog_values] ([col_building_id_fk] ,[col_equipment_id_fk] ,[col_device_id_fk] ,[col_analog_value] ,[col_analog_unit]) VALUES (@building_id,@equipment_id,@device_id,@analog_value,@analog_unit);
									END;
							END

						--AlarmInsertion
						SELECT 
							@contract_id=con.col_contract_id, 
							@contractor_company_id=con.col_contractor_company_id_fk  
						FROM tbl_devices d 
						LEFT JOIN tbl_equipments_contracts eqcon ON d.col_equipment_id_fk=eqcon.col_equipments_id_fk AND d.col_device_category_id_fk=eqcon.col_device_category_id_fk 
						LEFT JOIN tbl_contracts con ON eqcon.col_contract_id_fk=con.col_contract_id 
						WHERE d.col_equipment_id_fk=@equipment_id 
						AND d.col_device_id=@device_id;

						INSERT INTO dbo.tbl_alarms(	
													[col_alarm_case_id],
													[col_building_id_fk],
													[col_building_title],
													[col_equipment_id_fk],
													[col_device_id_fk],
													[col_device_desc],
													[col_contractor_company_id_fk],
													[col_contract_id_fk],
													[col_bit_type],
													[col_alarm_set_date],
													[col_analog_unit],
													[col_analog_value],
													[col_alarm_desc],
													[col_mask],
													[col_is_on_test]
												)
										VALUES(	
												@alarm_case_id,
												@building_id,
												@building_title,
												@equipment_id,
												@device_id,
												@device_desc,
												@contractor_company_id,
												@contract_id,
												@bit_type,
												@alarm_date,
												@analog_unit,
												@analog_value,
												@bit_desc,
												@bit_mask,
												@is_on_test
											);
					END;
			END;
		ELSE
			BEGIN
				PRINT 'Alarm Clear';
				--KeySwitch
				EXEC [dbo].[sp_process_masking] @device_sub_type,@equipment_id,0;

				--AlarmClear
				UPDATE dbo.tbl_alarms SET col_alarm_clear_date=@alarm_date WHERE col_building_id_fk = @building_id AND col_device_id_fk = @device_id AND col_alarm_clear_date IS NULL;
			END;
		COMMIT TRANSACTION;  
	END TRY
	BEGIN CATCH
         -- report exception
        EXEC [dbo].[sp_error_logs_collector];
        
        -- Test if the transaction is uncommittable.  
        IF (XACT_STATE()) = -1  
        BEGIN  
            PRINT  N'The transaction is in an uncommittable state.' +  
                    'Rolling back transaction.'  
            ROLLBACK TRANSACTION;  
        END;    
	END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_insert_case_id]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_insert_case_id](@alarm_case_id varchar(50) output)
as
BEGIN
	BEGIN TRY

		DECLARE @year varchar(10),@day_of_year varchar(10),@hour varchar(10),@minute varchar(10), @max_alarm_case_no varchar(MAX);
		SELECT 
			@year=FORMAT(([dbo].[fn_singapore_time]()), 'yy'),  
			@day_of_year=FORMAT(datepart(dayofyear,([dbo].[fn_singapore_time]())),'000'), 
			@hour= FORMAT(([dbo].[fn_singapore_time]()),'HH'), 
			@minute= FORMAT(([dbo].[fn_singapore_time]()),'MM');
		SELECT @max_alarm_case_no =CONVERT(varchar,ISNULL(MAX(col_max_case_no),0)+1) FROM tbl_alarm_case_id_generator WHERE col_year=@year and col_day_of_year=@day_of_year;

		INSERT INTO dbo.[tbl_alarm_case_id_generator]([col_year] ,[col_day_of_year] ,[col_hour] ,[col_minute] ,[col_max_case_no]) Values(@year,@day_of_year,@hour,@minute,@max_alarm_case_no);

		IF LEN(@max_alarm_case_no) < 6
			SET @max_alarm_case_no=FORMAT(CONVERT(int,@max_alarm_case_no),'000000');
		SET @alarm_case_id  ='A'+@year+@day_of_year+@hour+@minute+'-'+@max_alarm_case_no;

	END TRY
	BEGIN CATCH
        -- report exception
    EXEC [dbo].[sp_error_logs_collector]; 

	END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_lta_process_analog_bits]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_lta_process_analog_bits](@equipment_id varchar(36),@bit_end smallint,@is_avobe64 bit, @analog_value float output)
AS 
BEGIN
	BEGIN TRY
		DECLARE @quota tinyint, @analog_binary_bit_str varchar(16);
		DECLARE 
			@bit_1 bit, @bit_2 bit, @bit_3 bit, @bit_4 bit, @bit_5 bit, @bit_6 bit, @bit_7 bit, @bit_8 bit, 
			@bit_9 bit, @bit_10 bit, @bit_11 bit, @bit_12 bit, @bit_13 bit, @bit_14 bit, @bit_15 bit, @bit_16 bit, 
			@bit_17 bit, @bit_18 bit, @bit_19 bit, @bit_20 bit, @bit_21 bit, @bit_22 bit, @bit_23 bit, @bit_24 bit, 
			@bit_25 bit, @bit_26 bit, @bit_27 bit, @bit_28 bit, @bit_29 bit, @bit_30 bit, @bit_31 bit, @bit_32 bit, 
			@bit_33 bit, @bit_34 bit, @bit_35 bit, @bit_36 bit, @bit_37 bit, @bit_38 bit, @bit_39 bit, @bit_40 bit,
			@bit_41 bit, @bit_42 bit, @bit_43 bit, @bit_44 bit, @bit_45 bit, @bit_46 bit, @bit_47 bit, @bit_48 bit,
			@bit_49 bit, @bit_50 bit, @bit_51 bit, @bit_52 bit, @bit_53 bit, @bit_54 bit, @bit_55 bit, @bit_56 bit, 
			@bit_57 bit, @bit_58 bit, @bit_59 bit, @bit_60 bit, @bit_61 bit, @bit_62 bit, @bit_63 bit, @bit_64 bit;
	
		SET @quota = @bit_end / 16;

		IF @quota=1
			BEGIN
				SELECT 
					@bit_1=col_bit_1,@bit_2=col_bit_2, @bit_3=col_bit_3, @bit_4=col_bit_4, @bit_5=col_bit_5, @bit_6=col_bit_6, @bit_7=col_bit_7, @bit_8=col_bit_8,
					@bit_9=col_bit_9, @bit_10=col_bit_10, @bit_11=col_bit_11, @bit_12=col_bit_12, @bit_13=col_bit_13, @bit_14=col_bit_14, @bit_15=col_bit_15, @bit_16=col_bit_16 
				FROM tbl_object_bits 
				WHERE col_equipment_id_fk=@equipment_id 
				AND col_is_above64 = @is_avobe64;

				SET @analog_binary_bit_str = convert(char(1), @bit_1) + convert(char(1), @bit_2)+ convert(char(1), @bit_3)+ convert(char(1), @bit_4)+ convert(char(1), @bit_5)+ convert(char(1), @bit_6)+ convert(char(1), @bit_7)+ convert(char(1), @bit_8)+ convert(char(1), @bit_9)+ convert(char(1), @bit_10)+ convert(char(1), @bit_11)+ convert(char(1), @bit_12)+ convert(char(1), @bit_13)+ convert(char(1), @bit_14)+ convert(char(1), @bit_15)+ convert(char(1), @bit_16);
			END;
		ELSE IF @quota=2
			BEGIN
				SELECT 
					@bit_17=col_bit_17, @bit_18=col_bit_18, @bit_19=col_bit_19, @bit_20=col_bit_20, @bit_21=col_bit_21, @bit_22=col_bit_22, @bit_23=col_bit_23, @bit_24=col_bit_24, 
					@bit_25=col_bit_25, @bit_26=col_bit_26, @bit_27=col_bit_27, @bit_28=col_bit_28, @bit_29=col_bit_29, @bit_30=col_bit_30, @bit_31=col_bit_31, @bit_32=col_bit_32 
				FROM tbl_object_bits 
				WHERE col_equipment_id_fk=@equipment_id 
				AND col_is_above64 = @is_avobe64;
			
				SET @analog_binary_bit_str = convert(char(1), @bit_17) + convert(char(1), @bit_18)+ convert(char(1), @bit_19)+ convert(char(1), @bit_20)+ convert(char(1), @bit_21)+ convert(char(1), @bit_22)+ convert(char(1), @bit_23)+ convert(char(1), @bit_24)+ convert(char(1), @bit_25)+ convert(char(1), @bit_26)+ convert(char(1), @bit_27)+ convert(char(1), @bit_28)+ convert(char(1), @bit_29)+ convert(char(1), @bit_30)+ convert(char(1), @bit_31)+ convert(char(1), @bit_32);
			END;
		ELSE IF @quota=3
			BEGIN
				SELECT 
					@bit_33=col_bit_33, @bit_34=col_bit_34, @bit_35=col_bit_35, @bit_36=col_bit_36, @bit_37=col_bit_37, @bit_38=col_bit_38, @bit_39=col_bit_39, @bit_40=col_bit_40,
					@bit_41=col_bit_41, @bit_42=col_bit_42, @bit_43=col_bit_43, @bit_44=col_bit_44, @bit_45=col_bit_45, @bit_46=col_bit_46, @bit_47=col_bit_47, @bit_48=col_bit_48 
				FROM tbl_object_bits 
				WHERE col_equipment_id_fk=@equipment_id 
				AND col_is_above64 = @is_avobe64;

				SET @analog_binary_bit_str = convert(char(1), @bit_33) + convert(char(1), @bit_34)+ convert(char(1), @bit_35)+ convert(char(1), @bit_36)+ convert(char(1), @bit_37)+ convert(char(1), @bit_38)+ convert(char(1), @bit_39)+ convert(char(1), @bit_40)+ convert(char(1), @bit_41)+ convert(char(1), @bit_42)+ convert(char(1), @bit_43)+ convert(char(1), @bit_44)+ convert(char(1), @bit_45)+ convert(char(1), @bit_46)+ convert(char(1), @bit_47)+ convert(char(1), @bit_48);
			END;
		ELSE IF @quota=4
			BEGIN
				SELECT 
					@bit_49=col_bit_49,@bit_50=col_bit_50, @bit_51=col_bit_51, @bit_52=col_bit_52, @bit_53=col_bit_53, @bit_54=col_bit_54, @bit_55=col_bit_55, @bit_56=col_bit_56,  
					@bit_57=col_bit_57, @bit_58=col_bit_58, @bit_59=col_bit_59, @bit_60=col_bit_60, @bit_61=col_bit_61, @bit_62=col_bit_62, @bit_63=col_bit_63, @bit_64=col_bit_64 
				FROM tbl_object_bits 
				WHERE col_equipment_id_fk=@equipment_id 
				AND col_is_above64 = @is_avobe64;

				SET @analog_binary_bit_str = convert(char(1), @bit_49) + convert(char(1), @bit_50)+ convert(char(1), @bit_51)+ convert(char(1), @bit_52)+ convert(char(1), @bit_53)+ convert(char(1), @bit_54)+ convert(char(1), @bit_55)+ convert(char(1), @bit_56)+ convert(char(1), @bit_57)+ convert(char(1), @bit_58)+ convert(char(1), @bit_59)+ convert(char(1), @bit_60)+ convert(char(1), @bit_61)+ convert(char(1), @bit_62)+ convert(char(1), @bit_63)+ convert(char(1), @bit_64);
			END;
		ELSE
			print 'There is something error, @@quota not integer';

		SET @analog_value=dbo.fn_binary_to_float(@analog_binary_bit_str);
	END TRY
	BEGIN CATCH
        -- report exception
    EXEC [dbo].[sp_error_logs_collector]; 

	END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_process_dignosis_rules]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[sp_process_dignosis_rules](@init_val tinyint)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;
		DECLARE @counter int, @max_id int, @alarm_case_id varchar(50);
		DECLARE @tmp_dianosis TABLE (id int Identity(1,1), diagnosis_rule_id varchar(36));

		INSERT INTO @tmp_dianosis(diagnosis_rule_id)
		SELECT DISTINCT 
			dr.col_diagnosis_rules_id
		FROM tbl_diagnosis_rules dr
		WHERE dr.col_is_active=1;

		SELECT @counter = min(id) , @max_id = max(id) FROM @tmp_dianosis;
 
		WHILE(@Counter IS NOT NULL AND @counter <= @max_id)
			BEGIN
				DECLARE @dd_counter int=0, @dd_max_id int, @dd_rules_res bit=0;
				DECLARE @tmp_dianosis_details TABLE (ddid int Identity(1,1), alarm_set_date datetime, allowed_minute int,operator varchar(10));

				INSERT INTO @tmp_dianosis_details(alarm_set_date,allowed_minute,operator)
				SELECT DISTINCT 
					ta.col_alarm_set_date,
					drd.col_duration_minutes,
					drd.col_conditional_operator 
				FROM tbl_diagnosis_rules_details drd 
				LEFT JOIN tbl_diagnosis_rules dr ON drd.col_diagnosis_rules_id_fk=dr.col_diagnosis_rules_id 
				LEFT JOIN tbl_bitmap tb ON drd.col_bitmap_id_fk=tb.col_bitmap_id 
				LEFT JOIN tbl_alarms ta ON tb.col_device_id_fk=ta.col_device_id_fk 
				WHERE dr.col_diagnosis_rules_id=(SELECT diagnosis_rule_id FROM @tmp_dianosis WHERE id=@counter) 
				AND ta.col_alarm_clear_date IS NULL 
				AND ta.col_mask=0;

				SELECT @dd_counter = min(ddid) , @dd_max_id = max(ddid)  FROM @tmp_dianosis_details;
				WHILE(@dd_counter IS NOT NULL AND @dd_counter <= @dd_max_id)
					BEGIN
						DECLARE @set_time datetime, @minute_spend int, @allowed_minute int, @operator varchar(10);
						SELECT @set_time=alarm_set_date,@allowed_minute=allowed_minute,@operator=operator FROM @tmp_dianosis_details WHERE ddid=@dd_counter;
						SET @minute_spend= DATEDIFF(MINUTE,@set_time,dbo.fn_singapore_time());
						IF @operator='>='
							IF @allowed_minute >= @minute_spend
								SET @dd_rules_res=1;
							ELSE
								RETURN;
						ELSE IF @operator='<='
							IF @allowed_minute <= @minute_spend
								SET @dd_rules_res=1;
							ELSE
								RETURN;
						ELSE IF @operator='='
							IF @allowed_minute = @minute_spend
								SET @dd_rules_res=1;
							ELSE
								RETURN;
						ELSE IF @operator='!=' OR @operator='<>'
							IF @allowed_minute != @minute_spend 
								SET @dd_rules_res=1;
							ELSE
								RETURN;
						ELSE IF @operator='<'
							IF @allowed_minute < @minute_spend
								SET @dd_rules_res=1;
							ELSE
								RETURN;
						ELSE IF @operator='>'
							IF @allowed_minute > @minute_spend 
								SET @dd_rules_res=1;
							ELSE
								RETURN;

						SET @dd_counter += 1;
					END;

				IF @dd_rules_res=1
					BEGIN
						IF EXISTS(SELECT * FROM tbl_alarms WHERE col_diagnosis_rule_id_fk=(SELECT td.diagnosis_rule_id FROM @tmp_dianosis td WHERE id=@counter) AND col_alarm_clear_date IS NULL AND col_closed_date IS NULL)
							RETURN;

						PRINT 'INSERT ALARM';
						DECLARE @building_id varchar(36), @building_title varchar(250), @is_ontest bit, @equipment_id varchar(36), @diagnosis_bit_type bit, @diagnosis_rules_id varchar(36), @contract_id varchar(36), @contractor_company_id varchar(36), @diagnosis_alarm_desc  varchar(250);

						EXEC [sp_insert_case_id] @alarm_case_id output;

						SELECT 
							@building_id=rtu.col_building_id_fk,
							@equipment_id=dr.col_equipment_id_fk,
							@diagnosis_bit_type=dr.col_diagnosis_bit_type,
							@diagnosis_rules_id=dr.col_diagnosis_rules_id,
							@contract_id=eqcon.col_contract_id_fk,
							@contractor_company_id=con.col_contractor_company_id_fk,
							@diagnosis_alarm_desc=dr.col_diagnosis_alarm_description
						FROM dbo.tbl_diagnosis_rules dr 
						LEFT JOIN tbl_equipments eq on dr.col_equipment_id_fk=eq.col_equipment_id
						LEFT JOIN tbl_rtu rtu on eq.col_rtu_id_fk=rtu.col_rtu_id
						LEFT JOIN tbl_equipments_contracts eqcon on dr.col_equipment_id_fk=eqcon.col_equipments_id_fk
						LEFT JOIN tbl_contracts con on eqcon.col_contract_id_fk=con.col_contract_id
						WHERE dr.col_diagnosis_rules_id=(SELECT diagnosis_rule_id FROM @tmp_dianosis WHERE id=@counter);

						SELECT @building_title=col_building_title, @is_ontest=col_is_on_test FROM tbl_buildings WHERE col_building_id=@building_id;

						INSERT INTO dbo.tbl_alarms(
													[col_alarm_case_id],
													[col_building_id_fk],
													[col_building_title],
													[col_equipment_id_fk],
													[col_device_id_fk],
													[col_contractor_company_id_fk],
													[col_contract_id_fk],
													[col_bit_type],
													[col_alarm_set_date],
													[col_analog_unit],
													[col_analog_value],
													[col_alarm_desc],
													[col_is_diagnosis_point],
													[col_diagnosis_rule_id_fk],
													[col_mask],
													[col_is_on_test]
												) 
										VALUES(
												@alarm_case_id,
												@building_id,
												@building_title,
												@equipment_id,
												NULL,
												@contractor_company_id,
												@contract_id,
												@diagnosis_bit_type,
												dbo.fn_singapore_time(),
												NULL,
												NULL,
												1,
												@diagnosis_rules_id,
												@diagnosis_alarm_desc,
												0,
												@is_ontest
											);

						--Need to take care of ANALOG Diagnosis Points
					END;
				ELSE
					BEGIN
						PRINT 'Alarm clear';
						UPDATE dbo.tbl_alarms SET col_alarm_clear_date=dbo.fn_singapore_time() WHERE col_diagnosis_rule_id_fk = (SELECT diagnosis_rule_id FROM @tmp_dianosis WHERE id=@counter) AND col_alarm_clear_date IS NULL;
					END;
				SET @counter += 1;  
			END;
		COMMIT TRANSACTION;  
	END TRY
	BEGIN CATCH
	 -- report exception
        EXEC [dbo].[sp_error_logs_collector];
        
        -- Test if the transaction is uncommittable.  
        IF (XACT_STATE()) = -1  
        BEGIN  
            PRINT  N'The transaction is in an uncommittable state.' +  
                    'Rolling back transaction.'  
            ROLLBACK TRANSACTION;  
        END;  
	END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_process_masking]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[sp_process_masking](@device_sub_type varchar(500),@equipment_id varchar(36),@mask_value bit)
as
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;
		IF @device_sub_type in ('ESC KEY','LIFT KEY','ME KEY','RTU KEY')
			BEGIN
				IF @device_sub_type ='ME KEY'
					BEGIN
						UPDATE tb SET tb.col_mask=@mask_value 
						FROM tbl_bitmap tb 
						LEFT JOIN tbl_devices d ON tb.col_device_id_fk=d.col_device_id 
						LEFT JOIN tbl_device_category tc ON d.col_device_category_id_fk=tc.col_device_category_id 
						WHERE d.col_equipment_id_fk=@equipment_id 
						AND tc.col_device_category_title != 'UPSRTU';
						IF @mask_value=0
							UPDATE ta SET ta.col_mask=0 
							FROM tbl_alarms ta 
							LEFT JOIN tbl_devices d ON ta.col_device_id_fk=d.col_device_id 
							LEFT JOIN tbl_device_category tc ON d.col_device_category_id_fk=tc.col_device_category_id 
							WHERE ta.col_equipment_id_fk=@equipment_id  
							AND ta.col_alarm_clear_date is NULL 
							AND tc.col_device_category_title != 'UPSRTU'; 
					END;
				ELSE IF @device_sub_type ='RTU KEY'
					BEGIN
						UPDATE tb SET tb.col_mask=@mask_value 
						FROM tbl_bitmap tb 
						LEFT JOIN tbl_devices d ON tb.col_device_id_fk=d.col_device_id 
						LEFT JOIN tbl_device_category tc ON d.col_device_category_id_fk=tc.col_device_category_id 
						WHERE d.col_equipment_id_fk=@equipment_id 
						AND tc.col_device_category_title = 'UPSRTU';
						IF @mask_value=0
							UPDATE ta SET ta.col_mask=0 
							FROM tbl_alarms ta 
							LEFT JOIN tbl_devices d ON ta.col_device_id_fk=d.col_device_id 
							LEFT JOIN tbl_device_category tc ON d.col_device_category_id_fk=tc.col_device_category_id 
							WHERE ta.col_equipment_id_fk=@equipment_id  
							AND ta.col_alarm_clear_date is NULL 
							AND tc.col_device_category_title = 'UPSRTU';
					END;
				ELSE
					BEGIN
						UPDATE tbl_bitmap SET col_mask=@mask_value WHERE col_equipment_id_fk=@equipment_id;
						IF @mask_value=0
							UPDATE tbl_alarms SET col_mask=0 WHERE col_equipment_id_fk=@equipment_id AND col_alarm_clear_date is NULL;
					END;
			END;
		ELSE
			RETURN;
		COMMIT TRANSACTION;  
	END TRY
	BEGIN CATCH
	 -- report exception
        EXEC [dbo].[sp_error_logs_collector];
        
        -- Test if the transaction is uncommittable.  
        IF (XACT_STATE()) = -1  
        BEGIN  
            PRINT  N'The transaction is in an uncommittable state.' +  
                    'Rolling back transaction.'  
            ROLLBACK TRANSACTION;  
        END;  

	END CATCH
END;
GO
/****** Object:  Trigger [dbo].[tr_update_object_bits]    Script Date: 18/05/2022 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   TRIGGER [dbo].[tr_update_object_bits]
ON [dbo].[tbl_object_bits]  
AFTER UPDATE
AS
BEGIN TRY
	DECLARE @building_id varchar(36), @equipment_id varchar(36), @is_above64 bit, @ifd_bit_1 bit, @ifd_bit_9 bit;
	DECLARE	@bit_1 bit, @bit_2 bit, @bit_3 bit, @bit_4 bit, @bit_5 bit, @bit_6 bit, @bit_7 bit, @bit_8 bit, 
			@bit_9 bit, @bit_10 bit, @bit_11 bit, @bit_12 bit, @bit_13 bit, @bit_14 bit, @bit_15 bit, @bit_16 bit, 
			@bit_17 bit, @bit_18 bit, @bit_19 bit, @bit_20 bit, @bit_21 bit, @bit_22 bit, @bit_23 bit, @bit_24 bit, 
			@bit_25 bit, @bit_26 bit, @bit_27 bit, @bit_28 bit, @bit_29 bit, @bit_30 bit, @bit_31 bit, @bit_32 bit, 
			@bit_33 bit, @bit_34 bit, @bit_35 bit, @bit_36 bit, @bit_37 bit, @bit_38 bit, @bit_39 bit, @bit_40 bit,
			@bit_41 bit, @bit_42 bit, @bit_43 bit, @bit_44 bit, @bit_45 bit, @bit_46 bit, @bit_47 bit, @bit_48 bit,
			@bit_49 bit, @bit_50 bit, @bit_51 bit, @bit_52 bit, @bit_53 bit, @bit_54 bit, @bit_55 bit, @bit_56 bit, 
			@bit_57 bit, @bit_58 bit, @bit_59 bit, @bit_60 bit, @bit_61 bit, @bit_62 bit, @bit_63 bit, @bit_64 bit;

	SELECT  @building_id=col_building_id_fk, @equipment_id=col_equipment_id_fk, @is_above64=col_is_above64, @ifd_bit_1=col_ifd_bit_1, @ifd_bit_9=col_ifd_bit_9,
			@bit_1=col_bit_1,@bit_2=col_bit_2, @bit_3=col_bit_3, @bit_4=col_bit_4, @bit_5=col_bit_5, @bit_6=col_bit_6, @bit_7=col_bit_7, @bit_8=col_bit_8, 
			@bit_9=col_bit_9, @bit_10=col_bit_10, @bit_11=col_bit_11, @bit_12=col_bit_12, @bit_13=col_bit_13, @bit_14=col_bit_14, @bit_15=col_bit_15, @bit_16=col_bit_16, 
			@bit_17=col_bit_17, @bit_18=col_bit_18, @bit_19=col_bit_19, @bit_20=col_bit_20, @bit_21=col_bit_21, @bit_22=col_bit_22, @bit_23=col_bit_23, @bit_24=col_bit_24, 
			@bit_25=col_bit_25, @bit_26=col_bit_26, @bit_27=col_bit_27, @bit_28=col_bit_28, @bit_29=col_bit_29, @bit_30=col_bit_30, @bit_31=col_bit_31, @bit_32=col_bit_32, 
			@bit_33=col_bit_33, @bit_34=col_bit_34, @bit_35=col_bit_35, @bit_36=col_bit_36, @bit_37=col_bit_37, @bit_38=col_bit_38, @bit_39=col_bit_39, @bit_40=col_bit_40,
			@bit_41=col_bit_41, @bit_42=col_bit_42, @bit_43=col_bit_43, @bit_44=col_bit_44, @bit_45=col_bit_45, @bit_46=col_bit_46, @bit_47=col_bit_47, @bit_48=col_bit_48,
			@bit_49=col_bit_49, @bit_50=col_bit_50, @bit_51=col_bit_51, @bit_52=col_bit_52, @bit_53=col_bit_53, @bit_54=col_bit_54, @bit_55=col_bit_55, @bit_56=col_bit_56, 
			@bit_57=col_bit_57, @bit_58=col_bit_58, @bit_59=col_bit_59, @bit_60=col_bit_60, @bit_61=col_bit_61, @bit_62=col_bit_62, @bit_63=col_bit_63, @bit_64=col_bit_64
	FROM INSERTED;

		IF UPDATE(col_bit_1)  BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 1,  @is_above64,@bit_1 END;
		IF UPDATE(col_bit_2)  BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 2,  @is_above64,@bit_2 END;
		IF UPDATE(col_bit_3)  BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 3,  @is_above64,@bit_3 END;
		IF UPDATE(col_bit_4)  BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 4,  @is_above64,@bit_4 END;
		IF UPDATE(col_bit_5)  BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 5,  @is_above64,@bit_5 END;
		IF UPDATE(col_bit_6)  BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 6,  @is_above64,@bit_6 END;
		IF UPDATE(col_bit_7)  BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 7,  @is_above64,@bit_7 END;
		IF UPDATE(col_bit_8)  BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 8,  @is_above64,@bit_8 END;
		IF UPDATE(col_bit_9)  BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 9,  @is_above64,@bit_9 END;
		IF UPDATE(col_bit_10) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 10, @is_above64,@bit_10 END;
		IF UPDATE(col_bit_11) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 11, @is_above64,@bit_11 END;
		IF UPDATE(col_bit_12) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 12, @is_above64,@bit_12 END;
		IF UPDATE(col_bit_13) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 13, @is_above64,@bit_13 END;
		IF UPDATE(col_bit_14) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 14, @is_above64,@bit_14 END;
		IF UPDATE(col_bit_15) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 15, @is_above64,@bit_15 END;
		IF UPDATE(col_bit_16) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 16, @is_above64,@bit_16 END;
		IF UPDATE(col_bit_17) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 17, @is_above64,@bit_17 END;
		IF UPDATE(col_bit_18) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 18, @is_above64,@bit_18 END;
		IF UPDATE(col_bit_19) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 19, @is_above64,@bit_19 END;
		IF UPDATE(col_bit_20) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 20, @is_above64,@bit_20 END;
		IF UPDATE(col_bit_21) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 21, @is_above64,@bit_21 END;
		IF UPDATE(col_bit_22) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 22, @is_above64,@bit_22 END;
		IF UPDATE(col_bit_23) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 23, @is_above64,@bit_23 END;
		IF UPDATE(col_bit_24) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 24, @is_above64,@bit_24 END;
		IF UPDATE(col_bit_25) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 25, @is_above64,@bit_25 END;
		IF UPDATE(col_bit_26) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 26, @is_above64,@bit_26 END;
		IF UPDATE(col_bit_27) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 27, @is_above64,@bit_27 END;
		IF UPDATE(col_bit_28) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 28, @is_above64,@bit_28 END;
		IF UPDATE(col_bit_29) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 29, @is_above64,@bit_29 END;
		IF UPDATE(col_bit_30) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 30, @is_above64,@bit_30 END;
		IF UPDATE(col_bit_31) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 31, @is_above64,@bit_31 END;
		IF UPDATE(col_bit_32) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 32, @is_above64,@bit_32 END;
		IF UPDATE(col_bit_33) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 33, @is_above64,@bit_33 END;
		IF UPDATE(col_bit_34) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 34, @is_above64,@bit_34 END;
		IF UPDATE(col_bit_35) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 35, @is_above64,@bit_35 END;
		IF UPDATE(col_bit_36) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 36, @is_above64,@bit_36 END;
		IF UPDATE(col_bit_37) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 37, @is_above64,@bit_37 END;
		IF UPDATE(col_bit_38) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 38, @is_above64,@bit_38 END;
		IF UPDATE(col_bit_39) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 39, @is_above64,@bit_39 END;
		IF UPDATE(col_bit_40) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 40, @is_above64,@bit_40 END;
		IF UPDATE(col_bit_41) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 41, @is_above64,@bit_41 END;
		IF UPDATE(col_bit_42) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 42, @is_above64,@bit_42 END;
		IF UPDATE(col_bit_43) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 43, @is_above64,@bit_43 END;
		IF UPDATE(col_bit_44) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 44, @is_above64,@bit_44 END;
		IF UPDATE(col_bit_45) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 45, @is_above64,@bit_45 END;
		IF UPDATE(col_bit_46) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 46, @is_above64,@bit_46 END;
		IF UPDATE(col_bit_47) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 47, @is_above64,@bit_47 END;
		IF UPDATE(col_bit_48) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 48, @is_above64,@bit_48 END;
		IF UPDATE(col_bit_49) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 49, @is_above64,@bit_49 END;
		IF UPDATE(col_bit_50) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 50, @is_above64,@bit_50 END;
		IF UPDATE(col_bit_51) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 51, @is_above64,@bit_51 END;
		IF UPDATE(col_bit_52) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 52, @is_above64,@bit_52 END;
		IF UPDATE(col_bit_53) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 53, @is_above64,@bit_53 END;
		IF UPDATE(col_bit_54) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 54, @is_above64,@bit_54 END;
		IF UPDATE(col_bit_55) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 55, @is_above64,@bit_55 END;
		IF UPDATE(col_bit_56) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 56, @is_above64,@bit_56 END;
		IF UPDATE(col_bit_57) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 57, @is_above64,@bit_57 END;
		IF UPDATE(col_bit_58) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 58, @is_above64,@bit_58 END;
		IF UPDATE(col_bit_59) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 59, @is_above64,@bit_59 END;
		IF UPDATE(col_bit_60) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 60, @is_above64,@bit_60 END;
		IF UPDATE(col_bit_61) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 61, @is_above64,@bit_61 END;
		IF UPDATE(col_bit_62) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 62, @is_above64,@bit_62 END;
		IF UPDATE(col_bit_63) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 63, @is_above64,@bit_63 END;
		IF UPDATE(col_bit_64) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 64, @is_above64,@bit_64 END;
		IF UPDATE(col_ifd_bit_1) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 1, @is_above64,@ifd_bit_1,1 END;
		IF UPDATE(col_ifd_bit_9) BEGIN  EXEC sp_insert_alarms @building_id, @equipment_id, 9, @is_above64,@ifd_bit_9,1 END;
END TRY
BEGIN CATCH
	-- report exception
	EXEC [dbo].[sp_error_logs_collector];
END CATCH
GO
ALTER TABLE [dbo].[tbl_object_bits] ENABLE TRIGGER [tr_update_object_bits]
GO
USE [master]
GO
ALTER DATABASE [cfemsdb1] SET  READ_WRITE 
GO

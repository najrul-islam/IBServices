using Microsoft.EntityFrameworkCore;

namespace CFEMSDB.DB;

public partial class IBDBContext : DbContext
{
    private readonly string _connectionString;

    public IBDBContext(string connectionString)
    {
        _connectionString = connectionString;
    }
    public IBDBContext()
    {
    }

    public IBDBContext(DbContextOptions<IBDBContext> options)
        : base(options)
    {
    }

    public virtual DbSet<TblAlarm> TblAlarms { get; set; } = null!;
    public virtual DbSet<TblAlarmCaseIdGenerator> TblAlarmCaseIdGenerators { get; set; } = null!;
    public virtual DbSet<TblAnalogValue> TblAnalogValues { get; set; } = null!;
    public virtual DbSet<TblBitDescription> TblBitDescriptions { get; set; } = null!;
    public virtual DbSet<TblBitmap> TblBitmaps { get; set; } = null!;
    public virtual DbSet<TblBuilding> TblBuildings { get; set; } = null!;
    public virtual DbSet<TblConfig> TblConfigs { get; set; } = null!;
    public virtual DbSet<TblContract> TblContracts { get; set; } = null!;
    public virtual DbSet<TblContractUser> TblContractUsers { get; set; } = null!;
    public virtual DbSet<TblContractorCompany> TblContractorCompanies { get; set; } = null!;
    public virtual DbSet<TblDevice> TblDevices { get; set; } = null!;
    public virtual DbSet<TblDeviceCategory> TblDeviceCategories { get; set; } = null!;
    public virtual DbSet<TblDeviceIdentficationGroup> TblDeviceIdentficationGroups { get; set; } = null!;
    public virtual DbSet<TblDeviceIdentificationLetter> TblDeviceIdentificationLetters { get; set; } = null!;
    public virtual DbSet<TblDeviceSubType> TblDeviceSubTypes { get; set; } = null!;
    public virtual DbSet<TblDeviceType> TblDeviceTypes { get; set; } = null!;
    public virtual DbSet<TblDgMaintenanceCompany> TblDgMaintenanceCompanies { get; set; } = null!;
    public virtual DbSet<TblDgSetup> TblDgSetups { get; set; } = null!;
    public virtual DbSet<TblDgVmSetup> TblDgVmSetups { get; set; } = null!;
    public virtual DbSet<TblDiagnosisRule> TblDiagnosisRules { get; set; } = null!;
    public virtual DbSet<TblDiagnosisRulesDetail> TblDiagnosisRulesDetails { get; set; } = null!;
    public virtual DbSet<TblEntityHeartbeat> TblEntityHeartbeats { get; set; } = null!;
    public virtual DbSet<TblEquipment> TblEquipments { get; set; } = null!;
    public virtual DbSet<TblEquipmentGroup> TblEquipmentGroups { get; set; } = null!;
    public virtual DbSet<TblEquipmentsContract> TblEquipmentsContracts { get; set; } = null!;
    public virtual DbSet<TblErrorLog> TblErrorLogs { get; set; } = null!;
    public virtual DbSet<TblFaultCode> TblFaultCodes { get; set; } = null!;
    public virtual DbSet<TblHoliday> TblHolidays { get; set; } = null!;
    public virtual DbSet<TblLog> TblLogs { get; set; } = null!;
    public virtual DbSet<TblMaintenance> TblMaintenances { get; set; } = null!;
    public virtual DbSet<TblMaintenanceDetail> TblMaintenanceDetails { get; set; } = null!;
    public virtual DbSet<TblMaintenanceFrequency> TblMaintenanceFrequencies { get; set; } = null!;
    public virtual DbSet<TblMenu> TblMenus { get; set; } = null!;
    public virtual DbSet<TblObjectBit> TblObjectBits { get; set; } = null!;
    public virtual DbSet<TblOperatingSchedule> TblOperatingSchedules { get; set; } = null!;
    public virtual DbSet<TblRole> TblRoles { get; set; } = null!;
    public virtual DbSet<TblRoleToMenu> TblRoleToMenus { get; set; } = null!;
    public virtual DbSet<TblRs485Valuedefine> TblRs485Valuedefines { get; set; } = null!;
    public virtual DbSet<TblRtu> TblRtus { get; set; } = null!;
    public virtual DbSet<TblSite> TblSites { get; set; } = null!;
    public virtual DbSet<TblToken> TblTokens { get; set; } = null!;
    public virtual DbSet<TblUser> TblUsers { get; set; } = null!;
    public virtual DbSet<TblUserToMenu> TblUserToMenus { get; set; } = null!;
    public virtual DbSet<TblUserToRestrictedMenu> TblUserToRestrictedMenus { get; set; } = null!;
    public virtual DbSet<TblUserToRole> TblUserToRoles { get; set; } = null!;

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        if (!optionsBuilder.IsConfigured)
        {
            optionsBuilder.UseSqlServer(_connectionString);
        }
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<TblAlarm>(entity =>
        {
            entity.HasKey(e => e.ColAlarmCaseId);

            entity.ToTable("tbl_alarms");

            entity.Property(e => e.ColAlarmCaseId)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("col_alarm_case_id");

            entity.Property(e => e.ColAcknwledgeBy)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_acknwledge_by");

            entity.Property(e => e.ColAcknwledgeDate)
                .HasColumnType("datetime")
                .HasColumnName("col_acknwledge_date");

            entity.Property(e => e.ColAlarmClearDate)
                .HasColumnType("datetime")
                .HasColumnName("col_alarm_clear_date");

            entity.Property(e => e.ColAlarmDesc)
                .HasMaxLength(500)
                .IsUnicode(false)
                .HasColumnName("col_alarm_desc");

            entity.Property(e => e.ColAlarmSetDate)
                .HasColumnType("datetime")
                .HasColumnName("col_alarm_set_date");

            entity.Property(e => e.ColAlertType)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_alert_type");

            entity.Property(e => e.ColAnalogUnit)
                .HasMaxLength(5)
                .IsUnicode(false)
                .HasColumnName("col_analog_unit");

            entity.Property(e => e.ColAnalogValue).HasColumnName("col_analog_value");

            entity.Property(e => e.ColArrivalDate)
                .HasColumnType("datetime")
                .HasColumnName("col_arrival_date");

            entity.Property(e => e.ColBitType)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("col_bit_type");

            entity.Property(e => e.ColBuildingIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_building_id_fk");

            entity.Property(e => e.ColBuildingTitle)
                .HasMaxLength(250)
                .IsUnicode(false)
                .HasColumnName("col_building_title");

            entity.Property(e => e.ColClosedBy)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_closed_by");

            entity.Property(e => e.ColClosedDate)
                .HasColumnType("datetime")
                .HasColumnName("col_closed_date");

            entity.Property(e => e.ColContractIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_contract_id_fk");

            entity.Property(e => e.ColContractorCompanyIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_contractor_company_id_fk");

            entity.Property(e => e.ColDeviceDesc)
                .HasMaxLength(250)
                .IsUnicode(false)
                .HasColumnName("col_device_desc");

            entity.Property(e => e.ColDeviceIdFk)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_device_id_fk");

            entity.Property(e => e.ColDiagnosisRuleIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_diagnosis_rule_id_fk");

            entity.Property(e => e.ColEquipmentIdFk)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_equipment_id_fk");

            entity.Property(e => e.ColFaultCodeFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_fault_code_fk");

            entity.Property(e => e.ColIsDiagnosisPoint).HasColumnName("col_is_diagnosis_point");

            entity.Property(e => e.ColIsOnTest).HasColumnName("col_is_on_test");

            entity.Property(e => e.ColLtaRemarks)
                .HasMaxLength(250)
                .IsUnicode(false)
                .HasColumnName("col_lta_remarks");

            entity.Property(e => e.ColLtaVerifyBy)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_lta_verify_by");

            entity.Property(e => e.ColLtaVerifyDate)
                .HasColumnType("datetime")
                .HasColumnName("col_lta_verify_date");

            entity.Property(e => e.ColMask).HasColumnName("col_mask");

            entity.Property(e => e.ColProcessFlag).HasColumnName("col_process_flag");

            entity.Property(e => e.ColReportBy)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_report_by");

            entity.Property(e => e.ColReportDate)
                .HasColumnType("datetime")
                .HasColumnName("col_report_date");

            entity.Property(e => e.ColReportDesc)
                .HasMaxLength(250)
                .IsUnicode(false)
                .HasColumnName("col_report_desc");
        });

        modelBuilder.Entity<TblAlarmCaseIdGenerator>(entity =>
        {
            entity.HasNoKey();

            entity.ToTable("tbl_alarm_case_id_generator");

            entity.Property(e => e.ColDayOfYear).HasColumnName("col_day_of_year");

            entity.Property(e => e.ColHour).HasColumnName("col_hour");

            entity.Property(e => e.ColMaxCaseNo).HasColumnName("col_max_case_no");

            entity.Property(e => e.ColMinute).HasColumnName("col_minute");

            entity.Property(e => e.ColYear).HasColumnName("col_year");
        });

        modelBuilder.Entity<TblAnalogValue>(entity =>
        {
            entity.HasKey(e => new { e.ColBuildingIdFk, e.ColEquipmentIdFk, e.ColDeviceIdFk });

            entity.ToTable("tbl_analog_values");

            entity.Property(e => e.ColBuildingIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_building_id_fk");

            entity.Property(e => e.ColEquipmentIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_equipment_id_fk");

            entity.Property(e => e.ColDeviceIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_device_id_fk");

            entity.Property(e => e.ColAnalogUnit)
                .HasMaxLength(5)
                .IsUnicode(false)
                .HasColumnName("col_analog_unit");

            entity.Property(e => e.ColAnalogValue).HasColumnName("col_analog_value");
        });

        modelBuilder.Entity<TblBitDescription>(entity =>
        {
            entity.HasNoKey();

            entity.ToTable("tbl_bit_description");

            entity.Property(e => e.ColIcdShortCode)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_icd_short_code");

            entity.Property(e => e.ColIcdShortCodeDefination)
                .HasMaxLength(250)
                .IsUnicode(false)
                .HasColumnName("col_icd_short_code_defination");
        });

        modelBuilder.Entity<TblBitmap>(entity =>
        {
            entity.HasKey(e => e.ColBitmapId)
                .HasName("PK_tbl_lta_bitmap");

            entity.ToTable("tbl_bitmap");

            entity.Property(e => e.ColBitmapId)
                .HasColumnName("col_bitmap_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColAlarmDescription)
                .HasMaxLength(500)
                .IsUnicode(false)
                .HasColumnName("col_alarm_description");

            entity.Property(e => e.ColAnalogUnit)
                .HasMaxLength(5)
                .IsUnicode(false)
                .HasColumnName("col_analog_unit");

            entity.Property(e => e.ColAvRpt).HasColumnName("col_av_rpt");

            entity.Property(e => e.ColBitEnd).HasColumnName("col_bit_end");

            entity.Property(e => e.ColBitStart).HasColumnName("col_bit_start");

            entity.Property(e => e.ColBitType)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_bit_type");

            entity.Property(e => e.ColDeviceIdFk)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_device_id_fk");

            entity.Property(e => e.ColEquipmentIdFk)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_equipment_id_fk");

            entity.Property(e => e.ColIsAbove64).HasColumnName("col_is_above64");

            entity.Property(e => e.ColIsIfdBit).HasColumnName("col_is_ifd_bit");

            entity.Property(e => e.ColIsMonitorByDevice).HasColumnName("col_is_monitor_by_device");

            entity.Property(e => e.ColIsStatusInvert).HasColumnName("col_is_status_invert");

            entity.Property(e => e.ColMask).HasColumnName("col_mask");

            entity.Property(e => e.ColOperatingScheduleIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_operating_schedule_id_fk");

            entity.Property(e => e.ColOperationHr).HasColumnName("col_operation_hr");

            entity.Property(e => e.IsItscAlarmActivated).HasColumnName("is_itsc_alarm_activated");
        });

        modelBuilder.Entity<TblBuilding>(entity =>
        {
            entity.HasKey(e => e.ColBuildingId);

            entity.ToTable("tbl_buildings");

            entity.Property(e => e.ColBuildingId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_building_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColAddress)
                .HasMaxLength(300)
                .IsUnicode(false)
                .HasColumnName("col_address");

            entity.Property(e => e.ColAddressCode)
                .HasMaxLength(5)
                .IsUnicode(false)
                .HasColumnName("col_address_code");

            entity.Property(e => e.ColAssetNo)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("col_asset_no");

            entity.Property(e => e.ColBuildingTitle)
                .HasMaxLength(250)
                .IsUnicode(false)
                .HasColumnName("col_building_title");

            entity.Property(e => e.ColBuildingType)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_building_type");

            entity.Property(e => e.ColIsActive).HasColumnName("col_is_active");

            entity.Property(e => e.ColIsOnTest).HasColumnName("col_is_on_test");

            entity.Property(e => e.ColIssInstallDate)
                .HasColumnType("datetime")
                .HasColumnName("col_iss_install_date");

            entity.Property(e => e.ColLtaId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_lta_id");

            entity.Property(e => e.ColPostalCode)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_postal_code");
        });

        modelBuilder.Entity<TblConfig>(entity =>
        {
            entity.HasKey(e => e.ColConfigId);

            entity.ToTable("tbl_configs");

            entity.Property(e => e.ColConfigId)
                .HasColumnName("col_config_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColConfigType)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_config_type");

            entity.Property(e => e.ColIsActive).HasColumnName("col_is_active");
        });

        modelBuilder.Entity<TblContract>(entity =>
        {
            entity.HasKey(e => e.ColContractNbr)
                .HasName("PK__tbl_cont__FF9AB54329F28E5E");

            entity.ToTable("tbl_contracts");

            entity.Property(e => e.ColContractNbr)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_contract_nbr");

            entity.Property(e => e.ColContractEnd)
                .HasColumnType("datetime")
                .HasColumnName("col_contract_end");

            entity.Property(e => e.ColContractId)
                .HasColumnName("col_contract_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColContractStart)
                .HasColumnType("datetime")
                .HasColumnName("col_contract_start");

            entity.Property(e => e.ColContractorCompanyIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_contractor_company_id_fk");

            entity.Property(e => e.ColIsContractValid).HasColumnName("col_is_contract_valid");

            entity.Property(e => e.ColRepairHr).HasColumnName("col_repair_hr");

            entity.Property(e => e.ColResponseHr).HasColumnName("col_response_hr");
        });

        modelBuilder.Entity<TblContractUser>(entity =>
        {
            entity.HasNoKey();

            entity.ToTable("tbl_contract_users");

            entity.Property(e => e.ColContractIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_contract_id_fk");

            entity.Property(e => e.ColContractorCompanyIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_contractor_company_id_fk");

            entity.Property(e => e.ColSmsRoleIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_sms_role_id_fk");

            entity.Property(e => e.ColSmsRoleSeqNo).HasColumnName("col_sms_role_seq_no");

            entity.Property(e => e.ColUserIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_user_id_fk");
        });

        modelBuilder.Entity<TblContractorCompany>(entity =>
        {
            entity.HasKey(e => e.ColContractorCompanyId)
                .HasName("PK_tbl_lta_contractor_company");

            entity.ToTable("tbl_contractor_company");

            entity.Property(e => e.ColContractorCompanyId)
                .HasColumnName("col_contractor_company_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColCompanyAddress)
                .HasMaxLength(200)
                .IsUnicode(false)
                .HasColumnName("col_company_address");

            entity.Property(e => e.ColCompanyName)
                .HasMaxLength(150)
                .IsUnicode(false)
                .HasColumnName("col_company_name");

            entity.Property(e => e.ColContractorCompanyCode)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_contractor_company_code");

            entity.Property(e => e.ColIsActive).HasColumnName("col_is_active");
        });

        modelBuilder.Entity<TblDevice>(entity =>
        {
            entity.HasKey(e => e.ColDeviceId);

            entity.ToTable("tbl_devices");

            entity.Property(e => e.ColDeviceId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_device_id");

            entity.Property(e => e.ColDeviceCategoryIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_device_category_id_fk");

            entity.Property(e => e.ColDeviceDesc)
                .HasMaxLength(250)
                .IsUnicode(false)
                .HasColumnName("col_device_desc");

            entity.Property(e => e.ColDeviceIdentificationGroupIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_device_identification_group_id_fk");

            entity.Property(e => e.ColDeviceIdentificationLetterIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_device_identification_letter_id_fk");

            entity.Property(e => e.ColDeviceSubTypeIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_device_sub_type_id_fk");

            entity.Property(e => e.ColDeviceTypeIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_device_type_id_fk");

            entity.Property(e => e.ColEquipmentIdFk)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_equipment_id_fk");

            entity.Property(e => e.ColIsActive).HasColumnName("col_is_active");
        });

        modelBuilder.Entity<TblDeviceCategory>(entity =>
        {
            entity.HasNoKey();

            entity.ToTable("tbl_device_category");

            entity.Property(e => e.ColDeviceCategoryId)
                .HasColumnName("col_device_category_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColDeviceCategoryTitle)
                .HasMaxLength(150)
                .IsUnicode(false)
                .HasColumnName("col_device_category_title");

            entity.Property(e => e.ColEquipmentGroupIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_equipment_group_id_fk");

            entity.Property(e => e.ColIsActive).HasColumnName("col_is_active");
        });

        modelBuilder.Entity<TblDeviceIdentficationGroup>(entity =>
        {
            entity.HasNoKey();

            entity.ToTable("tbl_device_identfication_group");

            entity.Property(e => e.ColDeviceIdentficationGroupTitle)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_device_identfication_group_title");

            entity.Property(e => e.ColDeviceIdentificationGroupId)
                .HasColumnName("col_device_identification_group_id")
                .HasDefaultValueSql("(newid())");
        });

        modelBuilder.Entity<TblDeviceIdentificationLetter>(entity =>
        {
            entity.HasNoKey();

            entity.ToTable("tbl_device_identification_letter");

            entity.Property(e => e.ColDeviceIdentificationGroupIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_device_identification_group_id_fk");

            entity.Property(e => e.ColDeviceIdentificationLetterId)
                .HasColumnName("col_device_identification_letter_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColDeviceIdentificationLetterTitle)
                .HasMaxLength(150)
                .IsUnicode(false)
                .HasColumnName("col_device_identification_letter_title");

            entity.Property(e => e.ColIsActive).HasColumnName("col_is_active");
        });

        modelBuilder.Entity<TblDeviceSubType>(entity =>
        {
            entity.HasKey(e => e.ColDeviceSubTypeId)
                .HasName("PK_tbl_device_type_description");

            entity.ToTable("tbl_device_sub_type");

            entity.Property(e => e.ColDeviceSubTypeId)
                .HasColumnName("col_device_sub_type_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColDeviceSubTypeTitle)
                .HasMaxLength(500)
                .IsUnicode(false)
                .HasColumnName("col_device_sub_type_title");

            entity.Property(e => e.ColDeviceTypeIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_device_type_id_fk");
        });

        modelBuilder.Entity<TblDeviceType>(entity =>
        {
            entity.HasNoKey();

            entity.ToTable("tbl_device_type");

            entity.Property(e => e.ColDeviceCategoryIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_device_category_id_fk");

            entity.Property(e => e.ColDeviceTypeId)
                .HasColumnName("col_device_type_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColDeviceTypeTitle)
                .HasMaxLength(150)
                .IsUnicode(false)
                .HasColumnName("col_device_type_title");

            entity.Property(e => e.ColIsActive)
                .HasColumnName("col_is_active")
                .HasDefaultValueSql("((0))");
        });

        modelBuilder.Entity<TblDgMaintenanceCompany>(entity =>
        {
            entity.HasKey(e => e.ColDgMaintenanceCompanyId);

            entity.ToTable("tbl_dg_maintenance_company");

            entity.Property(e => e.ColDgMaintenanceCompanyId)
                .HasColumnName("col_dg_maintenance_company_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColDgMaintenanceCompanyName)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("col_dg_maintenance_company_name");
        });

        modelBuilder.Entity<TblDgSetup>(entity =>
        {
            entity.HasKey(e => e.ColDgSetupId);

            entity.ToTable("tbl_dg_setup");

            entity.Property(e => e.ColDgSetupId)
                .HasColumnName("col_dg_setup_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColConfiugrationFileHash)
                .IsUnicode(false)
                .HasColumnName("col_confiugration_file_hash");

            entity.Property(e => e.ColDescription)
                .HasMaxLength(250)
                .IsUnicode(false)
                .HasColumnName("col_description");

            entity.Property(e => e.ColDgId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_dg_id");

            entity.Property(e => e.ColDgMaintenanceCompanyIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_dg_maintenance_company_id_fk");

            entity.Property(e => e.ColDgVmSetupIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_dg_vm_setup_id_fk");

            entity.Property(e => e.ColIsActive).HasColumnName("col_is_active");

            entity.Property(e => e.ColIsOnline).HasColumnName("col_is_online");

            entity.Property(e => e.ColIsDebug).HasColumnName("col_is_debug");
        });

        modelBuilder.Entity<TblDgVmSetup>(entity =>
        {
            entity.HasKey(e => e.ColDgVmSetupId);

            entity.ToTable("tbl_dg_vm_setup");

            entity.Property(e => e.ColDgVmSetupId)
                .HasColumnName("col_dg_vm_setup_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColDescription)
                .HasMaxLength(250)
                .IsUnicode(false)
                .HasColumnName("col_description");

            entity.Property(e => e.ColDgVmId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_dg_vm_id");

            entity.Property(e => e.ColDgMaintenanceCompanyIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_dg_maintenance_company_id_fk");

            entity.Property(e => e.ColHostAddress)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_host_address");

            entity.Property(e => e.ColHostUsername)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_host_username");

            entity.Property(e => e.ColIsActive).HasColumnName("col_is_active");

            entity.Property(e => e.ColIsOnline).HasColumnName("col_is_online");

            entity.Property(e => e.ColVmStatus).HasColumnName("col_vm_status");
        });

        modelBuilder.Entity<TblDiagnosisRule>(entity =>
        {
            entity.HasKey(e => e.ColDiagnosisRulesId);

            entity.ToTable("tbl_diagnosis_rules");

            entity.Property(e => e.ColDiagnosisRulesId)
                .HasColumnName("col_diagnosis_rules_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColDiagnosisAlarmDescription)
                .HasMaxLength(250)
                .IsUnicode(false)
                .HasColumnName("col_diagnosis_alarm_description");

            entity.Property(e => e.ColDiagnosisBitType)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("col_diagnosis_bit_type");

            entity.Property(e => e.ColDiagnosisRulesTitle)
                .HasMaxLength(150)
                .IsUnicode(false)
                .HasColumnName("col_diagnosis_rules_title");

            entity.Property(e => e.ColEquipmentIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_equipment_id_fk");

            entity.Property(e => e.ColIsActive).HasColumnName("col_is_active");
        });

        modelBuilder.Entity<TblDiagnosisRulesDetail>(entity =>
        {
            entity.HasKey(e => e.ColDiagnosisRuleDetailsId);

            entity.ToTable("tbl_diagnosis_rules_details");

            entity.Property(e => e.ColDiagnosisRuleDetailsId)
                .HasColumnName("col_diagnosis_rule_details_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColBitmapIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_bitmap_id_fk");

            entity.Property(e => e.ColConditionalOperator)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_conditional_operator");

            entity.Property(e => e.ColDiagnosisRulesIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_diagnosis_rules_id_fk");

            entity.Property(e => e.ColDurationMinutes).HasColumnName("col_duration_minutes");
        });

        modelBuilder.Entity<TblEntityHeartbeat>(entity =>
        {
            entity.HasKey(e => e.ColEntityHeartbeatId);

            entity.ToTable("tbl_entity_heartbeat");

            entity.Property(e => e.ColEntityHeartbeatId)
                .HasColumnName("col_entity_heartbeat_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColEntityIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_entity_id_fk");

            entity.Property(e => e.ColIsDg).HasColumnName("col_is_dg");

            entity.Property(e => e.ColIsEquipment).HasColumnName("col_is_equipment");

            entity.Property(e => e.ColIsRtu).HasColumnName("col_is_rtu");

            entity.Property(e => e.ColJsonText)
                .IsUnicode(false)
                .HasColumnName("col_json_text");

            entity.Property(e => e.ColLastHeartbeatDatetime)
                .HasColumnType("datetime")
                .HasColumnName("col_last_heartbeat_datetime");

            entity.Property(e => e.ColModules)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_modules");
        });

        modelBuilder.Entity<TblEquipment>(entity =>
        {
            entity.HasKey(e => e.ColEquipmentId);

            entity.ToTable("tbl_equipments");

            entity.Property(e => e.ColEquipmentId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_equipment_id");

            entity.Property(e => e.ColBaudrate).HasColumnName("col_baudrate");

            entity.Property(e => e.ColCommissionDate)
                .HasColumnType("datetime")
                .HasColumnName("col_commission_date");

            entity.Property(e => e.ColDeviceType).HasColumnName("col_device_type");

            entity.Property(e => e.ColEquipmentGroupIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_equipment_group_id_fk");

            entity.Property(e => e.ColEquipmentTitle)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("col_equipment_title");

            entity.Property(e => e.ColIsActive).HasColumnName("col_is_active");

            entity.Property(e => e.ColIsOnline).HasColumnName("col_is_online");

            entity.Property(e => e.ColIsRs485).HasColumnName("col_is_rs485");

            entity.Property(e => e.ColIsSmsActivated).HasColumnName("col_is_sms_activated");

            entity.Property(e => e.ColLastRbehi)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("col_last_rbehi");

            entity.Property(e => e.ColLastRbelo)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("col_last_rbelo");

            entity.Property(e => e.ColLetter)
                .HasMaxLength(4)
                .IsUnicode(false)
                .HasColumnName("col_letter");

            entity.Property(e => e.ColRemarks)
                .HasMaxLength(500)
                .IsUnicode(false)
                .HasColumnName("col_remarks");

            entity.Property(e => e.ColRtuIdFk)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_rtu_id_fk");

            entity.Property(e => e.ColRtuNumber).HasColumnName("col_rtu_number");

            entity.Property(e => e.ColLatestRbehi)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("col_latest_rbehi");

            entity.Property(e => e.ColLatestRbelo)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("col_latest_rbelo");
        });

        modelBuilder.Entity<TblEquipmentGroup>(entity =>
        {
            entity.HasKey(e => e.ColEquipmentGroupId)
                .HasName("PK_tbl_device_group");

            entity.ToTable("tbl_equipment_group");

            entity.Property(e => e.ColEquipmentGroupId)
                .HasColumnName("col_equipment_group_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColEquipmentGroupTitle)
                .HasMaxLength(150)
                .IsUnicode(false)
                .HasColumnName("col_equipment_group_title");

            entity.Property(e => e.ColIsActive).HasColumnName("col_is_active");
        });

        modelBuilder.Entity<TblEquipmentsContract>(entity =>
        {
            entity.HasNoKey();

            entity.ToTable("tbl_equipments_contracts");

            entity.Property(e => e.ColContractIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_contract_id_fk");

            entity.Property(e => e.ColDeviceCategoryIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_device_category_id_fk");

            entity.Property(e => e.ColEntryDate)
                .HasColumnType("datetime")
                .HasColumnName("col_entry_date")
                .HasDefaultValueSql("([dbo].[fn_singapore_time]())");

            entity.Property(e => e.ColEquipmentContractMapId)
                .HasColumnName("col_equipment_contract_map_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColEquipmentsIdFk)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_equipments_id_fk");
        });

        modelBuilder.Entity<TblErrorLog>(entity =>
        {
            entity.HasKey(e => e.ColLogId)
                .HasName("PK_tbl_logs");

            entity.ToTable("tbl_error_logs");

            entity.Property(e => e.ColLogId)
                .HasColumnName("col_log_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColEntryDate)
                .HasColumnType("datetime")
                .HasColumnName("col_entry_date")
                .HasDefaultValueSql("([dbo].[fn_singapore_time]())");

            entity.Property(e => e.ColErrorLine).HasColumnName("col_error_line");

            entity.Property(e => e.ColErrorNumber).HasColumnName("col_error_number");

            entity.Property(e => e.ColErrorProcedure)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("col_error_procedure");

            entity.Property(e => e.ColErrorSeverity).HasColumnName("col_error_severity");

            entity.Property(e => e.ColErrorState).HasColumnName("col_error_state");

            entity.Property(e => e.ColLogDescription)
                .HasMaxLength(500)
                .IsUnicode(false)
                .HasColumnName("col_log_description");
        });

        modelBuilder.Entity<TblFaultCode>(entity =>
        {
            entity.HasNoKey();

            entity.ToTable("tbl_fault_code");

            entity.Property(e => e.ColDeviceCategoryIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_device_category_id_fk");

            entity.Property(e => e.ColFaultCode)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_fault_code");

            entity.Property(e => e.ColFaultCodeId)
                .HasColumnName("col_fault_code_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColFaultCodeTitle)
                .HasMaxLength(150)
                .IsUnicode(false)
                .HasColumnName("col_fault_code_title");
        });

        modelBuilder.Entity<TblHoliday>(entity =>
        {
            entity.HasNoKey();

            entity.ToTable("tbl_holidays");

            entity.Property(e => e.ColHolidayEndDate)
                .HasColumnType("datetime")
                .HasColumnName("col_holiday_end_date");

            entity.Property(e => e.ColHolidayStartDate)
                .HasColumnType("datetime")
                .HasColumnName("col_holiday_start_date");

            entity.Property(e => e.ColHolidayTitle)
                .HasMaxLength(500)
                .IsUnicode(false)
                .HasColumnName("col_holiday_title");

            entity.Property(e => e.ColHolidayYear).HasColumnName("col_holiday_year");

            entity.Property(e => e.ColIsActive).HasColumnName("col_is_active");
        });

        modelBuilder.Entity<TblLog>(entity =>
        {
            entity.HasKey(e => e.ColLogId)
                .HasName("PK_tbl_logs_1");

            entity.ToTable("tbl_logs");

            entity.Property(e => e.ColLogId)
                .HasColumnName("col_log_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColEntryDate)
                .HasColumnType("datetime")
                .HasColumnName("col_entry_date")
                .HasDefaultValueSql("([dbo].[fn_singapore_time]())");

            entity.Property(e => e.ColLogDescription)
                .HasMaxLength(500)
                .IsUnicode(false)
                .HasColumnName("col_log_description");
        });

        modelBuilder.Entity<TblMaintenance>(entity =>
        {
            entity.HasKey(e => e.ColMaintenanceId);

            entity.ToTable("tbl_maintenance");

            entity.Property(e => e.ColMaintenanceId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_maintenance_id");

            entity.Property(e => e.ColBuildingId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_building_id");

            entity.Property(e => e.ColDeviceIdentificationLetterIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_device_identification_letter_id_fk");

            entity.Property(e => e.ColDeviceTypeIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_device_type_id_fk");

            entity.Property(e => e.ColEquipmentContractMapIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_equipment_contract_map_id_fk");

            entity.Property(e => e.ColMaintenanceEntryBy)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_maintenance_entry_by");

            entity.Property(e => e.ColMaintenanceEntryDate)
                .HasColumnType("datetime")
                .HasColumnName("col_maintenance_entry_date");
        });

        modelBuilder.Entity<TblMaintenanceDetail>(entity =>
        {
            entity.HasKey(e => e.ColMaintenanceDetailsId);

            entity.ToTable("tbl_maintenance_details");

            entity.Property(e => e.ColMaintenanceDetailsId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_maintenance_details_id");

            entity.Property(e => e.ColCompletionDate)
                .HasColumnType("datetime")
                .HasColumnName("col_completion_date");

            entity.Property(e => e.ColDuration).HasColumnName("col_duration");

            entity.Property(e => e.ColEndDate)
                .HasColumnType("datetime")
                .HasColumnName("col_end_date");

            entity.Property(e => e.ColFrequency)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_frequency");

            entity.Property(e => e.ColIsLtaGranted).HasColumnName("col_is_lta_granted");

            entity.Property(e => e.ColLtaGrantedBy)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_lta_granted_by");

            entity.Property(e => e.ColLtaGrantedDate)
                .HasColumnType("datetime")
                .HasColumnName("col_lta_granted_date");

            entity.Property(e => e.ColMaintenanceDetailsParentId)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_maintenance_details_parent_id");

            entity.Property(e => e.ColMaintenanceIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_maintenance_id_fk");

            entity.Property(e => e.ColMaintenanceType)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_maintenance_type");

            entity.Property(e => e.ColReason)
                .HasMaxLength(255)
                .IsUnicode(false)
                .HasColumnName("col_reason");

            entity.Property(e => e.ColRemarks)
                .HasMaxLength(255)
                .IsUnicode(false)
                .HasColumnName("col_remarks");

            entity.Property(e => e.ColStartDate)
                .HasColumnType("datetime")
                .HasColumnName("col_start_date");

            entity.Property(e => e.ColStatus)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("col_status");

            entity.Property(e => e.ColUpdateBy)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_update_by");

            entity.Property(e => e.ColUpdateDate)
                .HasColumnType("datetime")
                .HasColumnName("col_update_date");
        });

        modelBuilder.Entity<TblMaintenanceFrequency>(entity =>
        {
            entity.HasNoKey();

            entity.ToTable("tbl_maintenance_frequency");

            entity.Property(e => e.ColDeviceCategoryIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_device_category_id_fk");

            entity.Property(e => e.ColDeviceTypeIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_device_type_id_fk");

            entity.Property(e => e.ColIsFrequencyAnually).HasColumnName("col_is_frequency_anually");

            entity.Property(e => e.ColIsFrequencyMontly).HasColumnName("col_is_frequency_montly");

            entity.Property(e => e.ColIsFrequencyQuarterly).HasColumnName("col_is_frequency_quarterly");

            entity.Property(e => e.ColIsFrequencySemiAnually).HasColumnName("col_is_frequency_semi_anually");

            entity.Property(e => e.ColIsFrequencyWeekly).HasColumnName("col_is_frequency_weekly");

            entity.Property(e => e.ColIsKeySwitchApplicable).HasColumnName("col_is_key_switch_applicable");
        });

        modelBuilder.Entity<TblMenu>(entity =>
        {
            entity.HasKey(e => e.ColMenuId);

            entity.ToTable("tbl_menus");

            entity.Property(e => e.ColMenuId)
                .HasColumnName("col_menu_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColGroupId)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_group_id");

            entity.Property(e => e.ColIcon)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_icon");

            entity.Property(e => e.ColIsActive).HasColumnName("col_is_active");

            entity.Property(e => e.ColIsGroup).HasColumnName("col_is_group");

            entity.Property(e => e.ColIsParent).HasColumnName("col_is_parent");

            entity.Property(e => e.ColMenuName)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("col_menu_name");

            entity.Property(e => e.ColParentId)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_parent_id");

            entity.Property(e => e.ColTimestamp)
                .HasColumnType("datetime")
                .HasColumnName("col_timestamp");

            entity.Property(e => e.ColUrl)
                .HasMaxLength(250)
                .IsUnicode(false)
                .HasColumnName("col_url");
        });

        modelBuilder.Entity<TblObjectBit>(entity =>
        {
            entity.HasKey(e => new { e.ColBuildingIdFk, e.ColRtuIdFk, e.ColEquipmentIdFk, e.ColIsAbove64 });

            entity.ToTable("tbl_object_bits");

            entity.Property(e => e.ColBuildingIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_building_id_fk");

            entity.Property(e => e.ColRtuIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_rtu_id_fk");

            entity.Property(e => e.ColEquipmentIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_equipment_id_fk");

            entity.Property(e => e.ColIsAbove64).HasColumnName("col_is_above64");

            entity.Property(e => e.ColBit1).HasColumnName("col_bit_1");

            entity.Property(e => e.ColBit10).HasColumnName("col_bit_10");

            entity.Property(e => e.ColBit10Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_10_date");

            entity.Property(e => e.ColBit11).HasColumnName("col_bit_11");

            entity.Property(e => e.ColBit11Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_11_date");

            entity.Property(e => e.ColBit12).HasColumnName("col_bit_12");

            entity.Property(e => e.ColBit12Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_12_date");

            entity.Property(e => e.ColBit13).HasColumnName("col_bit_13");

            entity.Property(e => e.ColBit13Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_13_date");

            entity.Property(e => e.ColBit14).HasColumnName("col_bit_14");

            entity.Property(e => e.ColBit14Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_14_date");

            entity.Property(e => e.ColBit15).HasColumnName("col_bit_15");

            entity.Property(e => e.ColBit15Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_15_date");

            entity.Property(e => e.ColBit16).HasColumnName("col_bit_16");

            entity.Property(e => e.ColBit16Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_16_date");

            entity.Property(e => e.ColBit17).HasColumnName("col_bit_17");

            entity.Property(e => e.ColBit17Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_17_date");

            entity.Property(e => e.ColBit18).HasColumnName("col_bit_18");

            entity.Property(e => e.ColBit18Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_18_date");

            entity.Property(e => e.ColBit19).HasColumnName("col_bit_19");

            entity.Property(e => e.ColBit19Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_19_date");

            entity.Property(e => e.ColBit1Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_1_date");

            entity.Property(e => e.ColBit2).HasColumnName("col_bit_2");

            entity.Property(e => e.ColBit20).HasColumnName("col_bit_20");

            entity.Property(e => e.ColBit20Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_20_date");

            entity.Property(e => e.ColBit21).HasColumnName("col_bit_21");

            entity.Property(e => e.ColBit21Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_21_date");

            entity.Property(e => e.ColBit22).HasColumnName("col_bit_22");

            entity.Property(e => e.ColBit22Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_22_date");

            entity.Property(e => e.ColBit23).HasColumnName("col_bit_23");

            entity.Property(e => e.ColBit23Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_23_date");

            entity.Property(e => e.ColBit24).HasColumnName("col_bit_24");

            entity.Property(e => e.ColBit24Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_24_date");

            entity.Property(e => e.ColBit25).HasColumnName("col_bit_25");

            entity.Property(e => e.ColBit25Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_25_date");

            entity.Property(e => e.ColBit26).HasColumnName("col_bit_26");

            entity.Property(e => e.ColBit26Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_26_date");

            entity.Property(e => e.ColBit27).HasColumnName("col_bit_27");

            entity.Property(e => e.ColBit27Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_27_date");

            entity.Property(e => e.ColBit28).HasColumnName("col_bit_28");

            entity.Property(e => e.ColBit28Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_28_date");

            entity.Property(e => e.ColBit29).HasColumnName("col_bit_29");

            entity.Property(e => e.ColBit29Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_29_date");

            entity.Property(e => e.ColBit2Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_2_date");

            entity.Property(e => e.ColBit3).HasColumnName("col_bit_3");

            entity.Property(e => e.ColBit30).HasColumnName("col_bit_30");

            entity.Property(e => e.ColBit30Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_30_date");

            entity.Property(e => e.ColBit31).HasColumnName("col_bit_31");

            entity.Property(e => e.ColBit31Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_31_date");

            entity.Property(e => e.ColBit32).HasColumnName("col_bit_32");

            entity.Property(e => e.ColBit32Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_32_date");

            entity.Property(e => e.ColBit33).HasColumnName("col_bit_33");

            entity.Property(e => e.ColBit33Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_33_date");

            entity.Property(e => e.ColBit34).HasColumnName("col_bit_34");

            entity.Property(e => e.ColBit34Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_34_date");

            entity.Property(e => e.ColBit35).HasColumnName("col_bit_35");

            entity.Property(e => e.ColBit35Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_35_date");

            entity.Property(e => e.ColBit36).HasColumnName("col_bit_36");

            entity.Property(e => e.ColBit36Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_36_date");

            entity.Property(e => e.ColBit37).HasColumnName("col_bit_37");

            entity.Property(e => e.ColBit37Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_37_date");

            entity.Property(e => e.ColBit38).HasColumnName("col_bit_38");

            entity.Property(e => e.ColBit38Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_38_date");

            entity.Property(e => e.ColBit39).HasColumnName("col_bit_39");

            entity.Property(e => e.ColBit39Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_39_date");

            entity.Property(e => e.ColBit3Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_3_date");

            entity.Property(e => e.ColBit4).HasColumnName("col_bit_4");

            entity.Property(e => e.ColBit40).HasColumnName("col_bit_40");

            entity.Property(e => e.ColBit40Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_40_date");

            entity.Property(e => e.ColBit41).HasColumnName("col_bit_41");

            entity.Property(e => e.ColBit41Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_41_date");

            entity.Property(e => e.ColBit42).HasColumnName("col_bit_42");

            entity.Property(e => e.ColBit42Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_42_date");

            entity.Property(e => e.ColBit43).HasColumnName("col_bit_43");

            entity.Property(e => e.ColBit43Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_43_date");

            entity.Property(e => e.ColBit44).HasColumnName("col_bit_44");

            entity.Property(e => e.ColBit44Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_44_date");

            entity.Property(e => e.ColBit45).HasColumnName("col_bit_45");

            entity.Property(e => e.ColBit45Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_45_date");

            entity.Property(e => e.ColBit46).HasColumnName("col_bit_46");

            entity.Property(e => e.ColBit46Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_46_date");

            entity.Property(e => e.ColBit47).HasColumnName("col_bit_47");

            entity.Property(e => e.ColBit47Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_47_date");

            entity.Property(e => e.ColBit48).HasColumnName("col_bit_48");

            entity.Property(e => e.ColBit48Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_48_date");

            entity.Property(e => e.ColBit49).HasColumnName("col_bit_49");

            entity.Property(e => e.ColBit49Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_49_date");

            entity.Property(e => e.ColBit4Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_4_date");

            entity.Property(e => e.ColBit5).HasColumnName("col_bit_5");

            entity.Property(e => e.ColBit50).HasColumnName("col_bit_50");

            entity.Property(e => e.ColBit50Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_50_date");

            entity.Property(e => e.ColBit51).HasColumnName("col_bit_51");

            entity.Property(e => e.ColBit51Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_51_date");

            entity.Property(e => e.ColBit52).HasColumnName("col_bit_52");

            entity.Property(e => e.ColBit52Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_52_date");

            entity.Property(e => e.ColBit53).HasColumnName("col_bit_53");

            entity.Property(e => e.ColBit53Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_53_date");

            entity.Property(e => e.ColBit54).HasColumnName("col_bit_54");

            entity.Property(e => e.ColBit54Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_54_date");

            entity.Property(e => e.ColBit55).HasColumnName("col_bit_55");

            entity.Property(e => e.ColBit55Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_55_date");

            entity.Property(e => e.ColBit56).HasColumnName("col_bit_56");

            entity.Property(e => e.ColBit56Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_56_date");

            entity.Property(e => e.ColBit57).HasColumnName("col_bit_57");

            entity.Property(e => e.ColBit57Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_57_date");

            entity.Property(e => e.ColBit58).HasColumnName("col_bit_58");

            entity.Property(e => e.ColBit58Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_58_date");

            entity.Property(e => e.ColBit59).HasColumnName("col_bit_59");

            entity.Property(e => e.ColBit59Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_59_date");

            entity.Property(e => e.ColBit5Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_5_date");

            entity.Property(e => e.ColBit6).HasColumnName("col_bit_6");

            entity.Property(e => e.ColBit60).HasColumnName("col_bit_60");

            entity.Property(e => e.ColBit60Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_60_date");

            entity.Property(e => e.ColBit61).HasColumnName("col_bit_61");

            entity.Property(e => e.ColBit61Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_61_date");

            entity.Property(e => e.ColBit62).HasColumnName("col_bit_62");

            entity.Property(e => e.ColBit62Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_62_date");

            entity.Property(e => e.ColBit63).HasColumnName("col_bit_63");

            entity.Property(e => e.ColBit63Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_63_date");

            entity.Property(e => e.ColBit64).HasColumnName("col_bit_64");

            entity.Property(e => e.ColBit64Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_64_date");

            entity.Property(e => e.ColBit6Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_6_date");

            entity.Property(e => e.ColBit7).HasColumnName("col_bit_7");

            entity.Property(e => e.ColBit7Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_7_date");

            entity.Property(e => e.ColBit8).HasColumnName("col_bit_8");

            entity.Property(e => e.ColBit8Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_8_date");

            entity.Property(e => e.ColBit9).HasColumnName("col_bit_9");

            entity.Property(e => e.ColBit9Date)
                .HasColumnType("datetime")
                .HasColumnName("col_bit_9_date");

            entity.Property(e => e.ColIfdBit1).HasColumnName("col_ifd_bit_1");

            entity.Property(e => e.ColIfdBit10).HasColumnName("col_ifd_bit_10");

            entity.Property(e => e.ColIfdBit10Date)
                .HasColumnType("datetime")
                .HasColumnName("col_ifd_bit_10_date");

            entity.Property(e => e.ColIfdBit11).HasColumnName("col_ifd_bit_11");

            entity.Property(e => e.ColIfdBit11Date)
                .HasColumnType("datetime")
                .HasColumnName("col_ifd_bit_11_date");

            entity.Property(e => e.ColIfdBit12).HasColumnName("col_ifd_bit_12");

            entity.Property(e => e.ColIfdBit12Date)
                .HasColumnType("datetime")
                .HasColumnName("col_ifd_bit_12_date");

            entity.Property(e => e.ColIfdBit13).HasColumnName("col_ifd_bit_13");

            entity.Property(e => e.ColIfdBit13Date)
                .HasColumnType("datetime")
                .HasColumnName("col_ifd_bit_13_date");

            entity.Property(e => e.ColIfdBit14).HasColumnName("col_ifd_bit_14");

            entity.Property(e => e.ColIfdBit14Date)
                .HasColumnType("datetime")
                .HasColumnName("col_ifd_bit_14_date");

            entity.Property(e => e.ColIfdBit15).HasColumnName("col_ifd_bit_15");

            entity.Property(e => e.ColIfdBit15Date)
                .HasColumnType("datetime")
                .HasColumnName("col_ifd_bit_15_date");

            entity.Property(e => e.ColIfdBit16).HasColumnName("col_ifd_bit_16");

            entity.Property(e => e.ColIfdBit16Date)
                .HasColumnType("datetime")
                .HasColumnName("col_ifd_bit_16_date");

            entity.Property(e => e.ColIfdBit1Date)
                .HasColumnType("datetime")
                .HasColumnName("col_ifd_bit_1_date");

            entity.Property(e => e.ColIfdBit2).HasColumnName("col_ifd_bit_2");

            entity.Property(e => e.ColIfdBit2Date)
                .HasColumnType("datetime")
                .HasColumnName("col_ifd_bit_2_date");

            entity.Property(e => e.ColIfdBit3).HasColumnName("col_ifd_bit_3");

            entity.Property(e => e.ColIfdBit3Date)
                .HasColumnType("datetime")
                .HasColumnName("col_ifd_bit_3_date");

            entity.Property(e => e.ColIfdBit4).HasColumnName("col_ifd_bit_4");

            entity.Property(e => e.ColIfdBit4Date)
                .HasColumnType("datetime")
                .HasColumnName("col_ifd_bit_4_date");

            entity.Property(e => e.ColIfdBit5).HasColumnName("col_ifd_bit_5");

            entity.Property(e => e.ColIfdBit5Date)
                .HasColumnType("datetime")
                .HasColumnName("col_ifd_bit_5_date");

            entity.Property(e => e.ColIfdBit6).HasColumnName("col_ifd_bit_6");

            entity.Property(e => e.ColIfdBit6Date)
                .HasColumnType("datetime")
                .HasColumnName("col_ifd_bit_6_date");

            entity.Property(e => e.ColIfdBit7).HasColumnName("col_ifd_bit_7");

            entity.Property(e => e.ColIfdBit7Date)
                .HasColumnType("datetime")
                .HasColumnName("col_ifd_bit_7_date");

            entity.Property(e => e.ColIfdBit8).HasColumnName("col_ifd_bit_8");

            entity.Property(e => e.ColIfdBit8Date)
                .HasColumnType("datetime")
                .HasColumnName("col_ifd_bit_8_date");

            entity.Property(e => e.ColIfdBit9).HasColumnName("col_ifd_bit_9");

            entity.Property(e => e.ColIfdBit9Date)
                .HasColumnType("datetime")
                .HasColumnName("col_ifd_bit_9_date");
        });

        modelBuilder.Entity<TblOperatingSchedule>(entity =>
        {
            entity.HasNoKey();

            entity.ToTable("tbl_operating_schedule");

            entity.Property(e => e.ColOperatingScheduleId)
                .HasColumnName("col_operating_schedule_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColOperatingScheduleTitle)
                .HasMaxLength(150)
                .IsUnicode(false)
                .HasColumnName("col_operating_schedule_title");

            entity.Property(e => e.ColOpertaingTimeEnd)
                .HasColumnType("time(0)")
                .HasColumnName("col_opertaing_time_end");

            entity.Property(e => e.ColOpertaingTimeStart)
                .HasColumnType("time(0)")
                .HasColumnName("col_opertaing_time_start");
        });

        modelBuilder.Entity<TblRole>(entity =>
        {
            entity.HasKey(e => e.ColRoleId);

            entity.ToTable("tbl_roles");

            entity.Property(e => e.ColRoleId)
                .HasColumnName("col_role_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColIsActive).HasColumnName("col_is_active");

            entity.Property(e => e.ColIsSmsRoles).HasColumnName("col_is_sms_roles");

            entity.Property(e => e.ColMenuIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_menu_id_fk");

            entity.Property(e => e.ColRoleName)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("col_role_name");
        });

        modelBuilder.Entity<TblRoleToMenu>(entity =>
        {
            entity.HasNoKey();

            entity.ToTable("tbl_role_to_menu");

            entity.Property(e => e.ColIsActive).HasColumnName("col_is_active");

            entity.Property(e => e.ColMenuIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_menu_id_fk");

            entity.Property(e => e.ColRoleIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_role_id_fk");

            entity.Property(e => e.ColTimestamp)
                .HasColumnType("datetime")
                .HasColumnName("col_timestamp");
        });

        modelBuilder.Entity<TblRs485Valuedefine>(entity =>
        {
            entity.HasKey(e => e.ColRs485ValuedefineId);

            entity.ToTable("tbl_rs485_valuedefine");

            entity.Property(e => e.ColRs485ValuedefineId)
                .HasColumnName("col_rs485_valuedefine_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColBiDescription)
                .HasMaxLength(350)
                .IsUnicode(false)
                .HasColumnName("col_bi_description");

            entity.Property(e => e.ColBiInt).HasColumnName("col_bi_int");
        });

        modelBuilder.Entity<TblRtu>(entity =>
        {
            entity.HasKey(e => e.ColRtuId);

            entity.ToTable("tbl_rtu");

            entity.Property(e => e.ColRtuId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_rtu_id");

            entity.Property(e => e.ColBaudrate).HasColumnName("col_baudrate");

            entity.Property(e => e.ColBuildingIdFk)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_building_id_fk");

            entity.Property(e => e.ColConfigIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_config_id_fk");

            entity.Property(e => e.ColDayNightFlag).HasColumnName("col_day_night_flag");

            entity.Property(e => e.ColDgSetupIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_dg_setup_id_fk");

            entity.Property(e => e.ColDvrIpAddress)
                .HasMaxLength(150)
                .IsUnicode(false)
                .HasColumnName("col_dvr_ip_address");

            entity.Property(e => e.ColDvrTerm)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_dvr_term");

            entity.Property(e => e.ColDvrType)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_dvr_type");

            entity.Property(e => e.ColEnabledisablestatus).HasColumnName("col_enabledisablestatus");

            entity.Property(e => e.ColHardwareVersion)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_hardware_version");

            entity.Property(e => e.ColIemsDvrIp)
                .HasMaxLength(150)
                .IsUnicode(false)
                .HasColumnName("col_iems_dvr_ip");

            entity.Property(e => e.ColIsActive).HasColumnName("col_is_active");

            entity.Property(e => e.ColIsOnline).HasColumnName("col_is_online");

            entity.Property(e => e.ColRemarks)
                .HasMaxLength(500)
                .IsUnicode(false)
                .HasColumnName("col_remarks");

            entity.Property(e => e.ColRtuIpAddress)
                .HasMaxLength(150)
                .IsUnicode(false)
                .HasColumnName("col_rtu_ip_address");

            entity.Property(e => e.ColSetupDate)
                .HasColumnType("datetime")
                .HasColumnName("col_setup_date");
        });

        modelBuilder.Entity<TblSite>(entity =>
        {
            entity.HasKey(e => e.ColSiteId);

            entity.ToTable("tbl_sites");

            entity.Property(e => e.ColSiteId)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("col_site_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColAddress)
                .HasMaxLength(300)
                .IsUnicode(false)
                .HasColumnName("col_address");

            entity.Property(e => e.ColAddressCode)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("col_address_code");

            entity.Property(e => e.ColIsActive).HasColumnName("col_is_active");

            entity.Property(e => e.ColPostalCode)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("col_postal_code");
        });

        modelBuilder.Entity<TblToken>(entity =>
        {
            entity.HasKey(e => e.ColTokenId);

            entity.ToTable("tbl_tokens");

            entity.Property(e => e.ColTokenId)
                .HasColumnName("col_token_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColCreatedDate)
                .HasColumnType("datetime")
                .HasColumnName("col_created_date");

            entity.Property(e => e.ColExpiryTime)
                .HasColumnType("datetime")
                .HasColumnName("col_expiry_time");

            entity.Property(e => e.ColLastModifiedDate)
                .HasColumnType("datetime")
                .HasColumnName("col_last_modified_date");

            entity.Property(e => e.ColUserId)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_user_id");

            entity.Property(e => e.ColValue)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("col_value");
        });

        modelBuilder.Entity<TblUser>(entity =>
        {
            entity.HasKey(e => e.ColUserId);

            entity.ToTable("tbl_users");

            entity.Property(e => e.ColUserId)
                .HasColumnName("col_user_id")
                .HasDefaultValueSql("(newid())");

            entity.Property(e => e.ColDeletedBy)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_deleted_by");

            entity.Property(e => e.ColEmail)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("col_email");

            entity.Property(e => e.ColEntryBy)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_entry_by");

            entity.Property(e => e.ColEntryDate)
                .HasColumnType("datetime")
                .HasColumnName("col_entry_date")
                .HasDefaultValueSql("([dbo].[fn_singapore_time]())");

            entity.Property(e => e.ColFullName)
                .HasMaxLength(150)
                .IsUnicode(false)
                .HasColumnName("col_full_name");

            entity.Property(e => e.ColIsActive).HasColumnName("col_is_active");

            entity.Property(e => e.ColIsDeleted).HasColumnName("col_is_deleted");

            entity.Property(e => e.ColOtp)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("col_otp");

            entity.Property(e => e.ColOtpExpiryTime).HasColumnName("col_otp_expiry_time");

            entity.Property(e => e.ColPassword)
                .HasMaxLength(500)
                .IsUnicode(false)
                .HasColumnName("col_password");

            entity.Property(e => e.ColPasswordSalt)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("col_password_salt");

            entity.Property(e => e.ColSmsPhoneNbr)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("col_sms_phone_nbr");

            entity.Property(e => e.ColUpdatedBy)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_updated_by");

            entity.Property(e => e.ColUpdatedDate)
                .HasColumnType("datetime")
                .HasColumnName("col_updated_date");

            entity.Property(e => e.ColUserName)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("col_user_name");
        });

        modelBuilder.Entity<TblUserToMenu>(entity =>
        {
            entity.HasNoKey();

            entity.ToTable("tbl_user_to_menu");

            entity.Property(e => e.ColIsActive).HasColumnName("col_is_active");

            entity.Property(e => e.ColMenuIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_menu_id_fk");

            entity.Property(e => e.ColTimestamp)
                .HasColumnType("datetime")
                .HasColumnName("col_timestamp");

            entity.Property(e => e.ColUserIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_user_id_fk");
        });

        modelBuilder.Entity<TblUserToRestrictedMenu>(entity =>
        {
            entity.HasNoKey();

            entity.ToTable("tbl_user_to_restricted_menu");

            entity.Property(e => e.ColIsActive).HasColumnName("col_is_active");

            entity.Property(e => e.ColMenuIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_menu_id_fk");

            entity.Property(e => e.ColTimestamp)
                .HasColumnType("datetime")
                .HasColumnName("col_timestamp");

            entity.Property(e => e.ColUserIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_user_id_fk");
        });

        modelBuilder.Entity<TblUserToRole>(entity =>
        {
            entity.HasNoKey();

            entity.ToTable("tbl_user_to_role");

            entity.Property(e => e.ColIsActive).HasColumnName("col_is_active");

            entity.Property(e => e.ColRoleIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_role_id_fk");

            entity.Property(e => e.ColUserIdFk)
                .HasMaxLength(36)
                .IsUnicode(false)
                .HasColumnName("col_user_id_fk");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}

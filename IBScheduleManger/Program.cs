using Quartz;
using Quartz.Impl;
using Quartz.Spi;
using IBScheduleManger.JobFactory;
using IBScheduleManger.Jobs;
using IBScheduleManger.Models;
using IBScheduleManger.Schedular;
using IBScheduleManger.Services;
using CFEMSDB.DB;
using Microsoft.EntityFrameworkCore;
using MQTTProcessor.Processor;
using IBCore.DataModels;

var environmentName = "Development"; //Environment.GetEnvironmentVariable("DOTNET_ENVIRONMENT");
var configuration = new ConfigurationBuilder()
     .SetBasePath(Directory.GetCurrentDirectory())
     .AddJsonFile($"appsettings.json", optional: false, reloadOnChange: true)
     .AddJsonFile($"appsettings.{environmentName}.json", optional: true, reloadOnChange: true);

var config = configuration.Build();

//mqtt configuration 
var mqttConfiguration = new MqttProcessInfo
{
    BrokerHost = config.GetSection("MQTT:BrokerHostname").Value,
    ClientId = config.GetSection("MQTT:ClientId").Value,
    Password = config.GetSection("MQTT:Password").Value,
    Username = config.GetSection("MQTT:Username").Value,
    ClearSession = false
};

var topicsToSubscribe = new string[] { "sg/sj/24k/willowglen/cmd/+" };

IHost host = Host.CreateDefaultBuilder(args)
    .ConfigureServices(services =>
    {
        //services.AddHostedService<Worker>();

        services.AddSingleton<IJobFactory, ScheduleJobFactory>();
        services.AddSingleton<ISchedulerFactory, StdSchedulerFactory>();

        #region Adding JobType
        services.AddSingleton<DayNightFlagJob>();
        services.AddSingleton<IBHeartbeatJob>();
        services.AddSingleton<DeviceStatusJob>();
        services.AddSingleton<MQTTInitiatorSourceContent, MQTTInitiatorService>();
        services.AddDbContext<IBDBContext>(options =>
               options.UseSqlServer(config.GetConnectionString("DefaultConnection")), ServiceLifetime.Singleton);
        services.AddSingleton<IMQTTConnProcessor, MQTTConnProcessor>(mcp => new MQTTConnProcessor(topicsToSubscribe, mqttConfiguration));
        #endregion

        #region Adding Jobs 
        List<JobMetadata> jobMetadatas = new List<JobMetadata>();

        jobMetadatas.Add(new JobMetadata(Guid.NewGuid(), typeof(IBHeartbeatJob), config["Jobs:IBHeartbeat:Name"], config["Jobs:IBHeartbeat:Cron"]));
        jobMetadatas.Add(new JobMetadata(Guid.NewGuid(), typeof(DeviceStatusJob), config["Jobs:DeviceStatus:Name"], config["Jobs:DeviceStatus:Cron"]));
        jobMetadatas.Add(new JobMetadata(Guid.NewGuid(), typeof(DayNightFlagJob), config["Jobs:DayNightFlag:Name"], config["Jobs:DayNightFlag:Cron"]));

        services.AddSingleton(jobMetadatas);
        #endregion

        services.AddHostedService<JobSchedular>();
    })
    .Build();

await host.RunAsync();

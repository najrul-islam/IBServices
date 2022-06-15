using CFEMSDB.DB;
using HBTProcessor.Services;
using IBCore.DataModels;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using MQTTProcessor.Processor;

namespace HBTProcessor.DI;

internal static class ServicesRegister
{
    public static IServiceCollection AddRegisteredServices(this IServiceCollection services, IConfiguration configuration)
    {
        var topicsToSubscribe = new string[] { "sg/sj/24k/willowglen/data/+" };
        var mqttConfiguration = new MqttProcessInfo
        {
            BrokerHost = configuration.GetSection("MQTT:BrokerHostname").Value,
            ClientId = configuration.GetSection("MQTT:ClientId").Value,
            Password = configuration.GetSection("MQTT:Password").Value,
            Username = configuration.GetSection("MQTT:Username").Value,
            ClearSession = false,
            //DbConnectionString = _config.GetConnectionString("DefaultConnection")
        };

        return services.AddDbContext<IBDBContext>(options =>
               options.UseSqlServer(
                   configuration.GetConnectionString("DefaultConnection")))
                .AddSingleton<IMQTTConnProcessor, MQTTConnProcessor>(mcp => new MQTTConnProcessor(topicsToSubscribe, mqttConfiguration))
                .AddSingleton<IHBTService, HBTService>();
    }
       

}
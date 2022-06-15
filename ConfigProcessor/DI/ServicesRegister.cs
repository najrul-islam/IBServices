using CFEMSDB.DB;
using ConfigProcessor.Services;
using IBCore.DataModels;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using MQTTProcessor.Processor;

namespace ConfigProcessor.DI;

internal static class ServicesRegister
{
    public static IServiceCollection AddRegisteredServices(this IServiceCollection services, IConfiguration configuration)
    {
        var topicPrefix = "sg/sj/24k/";
        var topicsToSubscribe = new string[]
        {
                //topicPrefix + "willowglen/data",
                topicPrefix + "willowglen/data/+"
        };
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
                .AddSingleton<IConfigService, ConfigService>();
    }

       

}

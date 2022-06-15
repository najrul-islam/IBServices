using Microsoft.Extensions.Configuration;

namespace RBEProcessor.DI;

internal static class ConfigurationRegister
{
    public static IConfigurationBuilder AddRegisteredConfigurations(this IConfigurationBuilder configBuilder, string environmentName) => 
        configBuilder.AddJsonFile($"appsettings.json", optional: false, reloadOnChange: true)
                    .AddJsonFile($"appsettings.{environmentName}.json", optional: true, reloadOnChange: true);

}

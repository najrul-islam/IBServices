using DGHealthManager.DI;
using DGHealthManager.Services;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

#region configuration

var environmentName = "Development" /*Environment.GetEnvironmentVariable("DOTNET_ENVIRONMENT")*/ ;

// Set configurations file
var configuration = new ConfigurationBuilder()
     .SetBasePath(Directory.GetCurrentDirectory())
     .AddRegisteredConfigurations(environmentName);

var config = configuration.Build();

#endregion

#region DI

var services = new ServiceCollection()
    .AddSingleton<IConfiguration>(config)
    .AddRegisteredServices(config);

var serviceProvider = services.BuildServiceProvider();
#endregion

#region Exceute
serviceProvider.GetService<IDGHealthService>()?
               .SettingTimeZone()
               .Execute();
#endregion
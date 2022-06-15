using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using RBEProcessor.DI;
using RBEProcessor.Services;

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
serviceProvider.GetService<IRBEService>()?
               .InitiateMQTTConnection()
               .Execute();
#endregion
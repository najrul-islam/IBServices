using CFEMSDB.DB;
using IBCore.DataModels;
using IBSimulatorWeb.Extensions;
using Microsoft.EntityFrameworkCore;
using MQTTProcessor.Processor;

var builder = WebApplication.CreateBuilder(args);

#region mqttconfiguration
var mqttConfiguration = new MqttProcessInfo
{
    BrokerHost = builder.Configuration.GetSection("MQTT:BrokerHostname").Value,
    ClientId = builder.Configuration.GetSection("MQTT:ClientId").Value,
    Password = builder.Configuration.GetSection("MQTT:Password").Value,
    Username = builder.Configuration.GetSection("MQTT:Username").Value,
    ClearSession = false,
    //DbConnectionString = _configuration.GetConnectionString("DefaultConnection")
};

var topicsToSubscribe = new string[] { "sg/sj/24k/willowglen/cmd+" };
#endregion configuration

// Add services to the container.
builder.Services.AddDbContext<IBDBContext>(options =>
               options.UseSqlServer(
                   builder.Configuration.GetConnectionString("DefaultConnection")),ServiceLifetime.Singleton)
                .AddSingleton<IMQTTConnProcessor, MQTTConnProcessor>(mcp => new MQTTConnProcessor(topicsToSubscribe, mqttConfiguration))
                .AddRefitPollyForPullClient(builder.Configuration);


builder.Services.AddRazorPages();

//builder.Services.AddSingleton<MQTTProcessor.MQTTClient>();

//connecting to broker
//connectToBroker();


var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapRazorPages();

app.Run();

#region Connect to MQQTT Broker
/*void connectToBroker()
{
    var brokerHost = builder.Configuration.GetSection("MQTT:BrokerHostname").Value ?? "localhost";
    var clientId = builder.Configuration.GetSection("MQTT:ClientId").Value ?? "mqttjs_4afc714c9e";
    var password = builder.Configuration.GetSection("MQTT:Password").Value ?? "public";
    var username = builder.Configuration.GetSection("MQTT:Username").Value ?? "admin";
    var clearSession = false;
    string timezone = builder.Configuration.GetSection("Timezone").Value;
    // Build the intermediate service provider
    var sp = builder.Services.BuildServiceProvider();
    var mQTTClient = sp.GetService<MQTTProcessor.MQTTClient>();
    mQTTClient.BrokerUrl = brokerHost;
    mQTTClient.ClientId = clientId;
    mQTTClient.Password = password;
    mQTTClient.Username = username;
    mQTTClient.ClearSession = clearSession;
    mQTTClient.Port = 8883;
    Console.WriteLine("Connecting to broker.....");
    mQTTClient.Connect();
    if (mQTTClient != null && mQTTClient.IsConnected)
    {
        Console.WriteLine($"Successfuly connected with broker {brokerHost}");
    }
    else
    {
        Console.WriteLine($"Cannot connect with the broker {brokerHost}");
    }
    Console.WriteLine("==========================================================");
}*/

#endregion
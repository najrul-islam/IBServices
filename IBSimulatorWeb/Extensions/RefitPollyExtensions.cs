using Polly;
using Refit;

namespace IBSimulatorWeb.Extensions
{
    public static class RefitPollyExtensions
    {
        public static IServiceCollection AddRefitPollyForPullClient(this IServiceCollection services, IConfiguration config)
        {
            services.AddHttpClient("file_server_client", c =>
            {
                c.BaseAddress = new Uri(config["FilerServer:ApiUrl"]);
            })
            .AddTypedClient(c => RestService.For<IHttpClient>(c))
            .AddTransientHttpErrorPolicy(p => p.WaitAndRetryAsync(int.Parse(config["FilerServer:Retry"]), _ => TimeSpan.FromMilliseconds(int.Parse(config["FilerServer:Wait"])), (result, timeSpan, retryCount, context) =>
            {
                //Log.Warning($"Request failed: {result.Exception.Message}. Wait {timeSpan.TotalSeconds}s before retry. Retry attempt {retryCount}.");
            }));

            return services;
        }
    }
}


using CFEMSDB.DB;
using DGHealthManager.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace DGHealthManager.DI;

internal static class ServicesRegister
{
    public static IServiceCollection AddRegisteredServices(this IServiceCollection services, IConfiguration configuration) =>
        services.AddDbContext<IBDBContext>(options =>
               options.UseSqlServer(
                   configuration.GetConnectionString("DefaultConnection")))
                .AddSingleton<IDGHealthService, DGHealthService>();

}
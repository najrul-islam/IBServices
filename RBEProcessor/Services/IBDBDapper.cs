using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;

namespace RBEProcessor.Services;

public class IBDBDapper
{
    private readonly IConfiguration _configuration;

    public IBDBDapper(IConfiguration configuration) => _configuration = configuration;

    public IDbConnection GetDbConnection() => new SqlConnection(_configuration["ConnectionStrings:DefaultConnection"]);
}
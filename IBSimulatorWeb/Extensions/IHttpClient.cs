using Microsoft.AspNetCore.Mvc;
using Refit;

namespace IBSimulatorWeb.Extensions
{
    public interface IHttpClient
    {
        [Multipart]
        [Post("/{path}")]
        [QueryUriFormat(UriFormat.Unescaped)]
        Task<string> UpdateConfigFile(string path, [AliasAs("file.json")] FileStream stream);
        
        [Delete("/{path}")]
        [QueryUriFormat(UriFormat.Unescaped)]
        Task<bool> DeleteExistingConfigFile(string path);
    }
}

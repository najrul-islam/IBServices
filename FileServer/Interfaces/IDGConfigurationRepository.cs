namespace FileServer.Interfaces;

public interface IDGConfigurationRepository
{
    Task<Stream> Get(string fileName);
    Task<string> Post(IFormFile file);
    Task<bool> Delete(string fileHash);
}

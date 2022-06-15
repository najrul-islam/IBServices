using FileServer.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FileServer.Controllers
{
    [ApiVersion("1.0")]
    [Route("api/v{version:apiVersion}/[controller]")]
    [ApiController]
    public class DGConfigurationController : ControllerBase
    {
        private readonly IDGConfigurationRepository _dgConfigurationRepository;

        public DGConfigurationController(IDGConfigurationRepository dgConfigurationRepository)
        {
            _dgConfigurationRepository = dgConfigurationRepository;
        }

        [HttpGet]
        public async Task<IActionResult> Get(string apiKey, string fileHash)
        {
            if (apiKey == "1c852fac-4271-42b7-b0x91-48d7579ecdee")
            {
                string fileName = $"{fileHash}.json";
                Stream stream = new MemoryStream();

                try
                {
                    stream = await _dgConfigurationRepository.Get(fileName);

                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Exception in DG configuration file download: {ex.ToString()}");
                }

                stream.Position = 0;
                return new FileStreamResult(stream, "application/octet-stream") { FileDownloadName = fileName };
            }
            else
            {
                Console.WriteLine($"Exception in DG configuration file download. Unauthorized, tried to access using wrong apiKey: {apiKey}");
                return Unauthorized();
            }
        }

        [HttpPost]
        public async Task<IActionResult> Post(string apiKey)
        {
            if (apiKey == "1c852fac-4271-42b7-b0x91-48d7579ecdee")
            {
                if (Request.Form.Files.Count > 0)
                {
                    string fileHash = string.Empty;

                    try
                    {
                        fileHash = await _dgConfigurationRepository.Post(Request.Form.Files[0]);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Exception in DG configuration file upload: {ex.ToString()}");
                    }

                    return Ok(fileHash);
                }
                else
                {
                    Console.WriteLine($"Exception in DG configuration file upload: No file provided");
                    return BadRequest("No file");
                }
            }
            else
            {
                Console.WriteLine($"Exception in DG configuration file upload. Unauthorized, tried to access using wrong apiKey: {apiKey}");
                return Unauthorized();
            }
        }

        [HttpDelete]
        public async Task<IActionResult> Delete(string apiKey, string fileHash)
        {
            if (apiKey == "1c852fac-4271-42b7-b0x91-48d7579ecdee")
            {
                bool deleted = false;
                try
                {
                    deleted = await _dgConfigurationRepository.Delete(fileHash);

                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Exception in DG configuration file delete: {ex.ToString()}");
                }

                return Ok(deleted);
            }
            else
            {
                Console.WriteLine($"Exception in DG configuration file delete. Unauthorized, tried to access using wrong apiKey: {apiKey}");
                return Unauthorized();
            }
        }
    }
}


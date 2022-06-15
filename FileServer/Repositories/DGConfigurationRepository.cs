using Azure;
using Azure.Storage.Files.Shares;
using Azure.Storage.Files.Shares.Models;
using FileServer.Interfaces;
using System.Security.Cryptography;

namespace FileServer.Repositories
{
    public class DGConfigurationRepository : IDGConfigurationRepository
    {
        private readonly IConfiguration _configuration;
        private string _azureStorageConnectionString;
        private string _shareName;
        private string _directoryName;
        private string _uplaodFodlerName = "Upload";

        public DGConfigurationRepository(IConfiguration configuration)
        {
            _configuration = configuration;
            _azureStorageConnectionString = _configuration.GetSection("AzureStorage:StorageConnectionString").Value;
            _shareName = _configuration.GetSection("AzureStorage:ShareName").Value;
            _directoryName = _configuration.GetSection("AzureStorage:DirectoryName").Value;
        }

        public async Task<Stream> Get(string fileName)
        {
            Stream stream = new MemoryStream();

            try
            {
                ShareClient share = new ShareClient(_azureStorageConnectionString, _shareName);

                if(share.Exists())
                {
                    ShareDirectoryClient directory = share.GetDirectoryClient(_directoryName);

                    if (directory.Exists())
                    {
                        ShareFileClient cloudFile = directory.GetFileClient(fileName);

                        if (cloudFile.Exists())
                        {
                            ShareFileDownloadInfo downloadInfo = cloudFile.Download();
                            await downloadInfo.Content.CopyToAsync(stream);
                        }
                    }
                    else
                    {
                        directory.Create();
                    }
                }
                else
                {
                    share.Create();
                }

                return stream;
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }

        public async Task<string> Post(IFormFile formFile)
        {
            string fileHash = string.Empty;
            string localFile = $"{_uplaodFodlerName}/{formFile.FileName}";

            DeleteFile(localFile);

            FileStream saveFileStream = File.Create(localFile);
            await formFile.CopyToAsync(saveFileStream);
            saveFileStream.Close();

            FileStream hashStream = File.OpenRead(localFile);
            fileHash = GetMD5HashFromStream(hashStream);
            string fileName = $"{fileHash}.json";
            hashStream.Close();

            ShareDirectoryClient dgConfigCloudDIrectory = GetDGConfigurationDirectory();

            ShareFileClient dgConfigCloudFile = dgConfigCloudDIrectory.GetFileClient(fileName);
            await dgConfigCloudFile.DeleteIfExistsAsync();


            using (FileStream openFIleStream = File.OpenRead(localFile))
            {

                dgConfigCloudFile.Create(openFIleStream.Length);
                dgConfigCloudFile.UploadRange(
                    new HttpRange(0, openFIleStream.Length),
                    openFIleStream);
            }

            DeleteFile(localFile);

            return fileHash;
        }

        public async Task<bool> Delete(string fileHash)
        {
            string fileName = $"{fileHash}.json";

            ShareDirectoryClient dgConfigCloudDIrectory = GetDGConfigurationDirectory();
            ShareFileClient dgConfigCloudFile = dgConfigCloudDIrectory.GetFileClient(fileName);
            await dgConfigCloudFile.DeleteIfExistsAsync();

            if (!dgConfigCloudFile.Exists())
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        private ShareDirectoryClient GetDGConfigurationDirectory()
        {
            ShareClient share = new ShareClient(_azureStorageConnectionString, _shareName);

            if (!share.Exists())
            {
                share.Create();
            }

            ShareDirectoryClient directory = share.GetDirectoryClient(_directoryName);

            if (!directory.Exists())
            {
                directory.Create();
            }

            return directory;
        }

        private static string GetMD5HashFromStream(Stream stream)
        {
            string hash = string.Empty;

            using (var md5 = MD5.Create())
            {
                hash = BitConverter.ToString(md5.ComputeHash(stream)).Replace("-", string.Empty).ToLower();
            }

            return hash;
        }

        //private void ClearDirectory(string folderPath)
        //{
        //    if (Directory.Exists(folderPath))
        //    {
        //        var files = Directory.GetFiles(folderPath);
        //        foreach (var file in files)
        //        {
        //            DeleteFile(file);
        //        }
        //    }
        //    else
        //    {
        //        Console.WriteLine($"{DateTime.UtcNow} - {folderPath} doesn't exist, unable to clear it");
        //    }
        //}

        private void DeleteFile(string path)
        {
            try
            {
                if (File.Exists(path))
                {
                    File.Delete(path);
                    Console.WriteLine($"{DateTime.UtcNow} - Deleted Trip Data File: {path}");
                }
                else
                {
                    Console.WriteLine($"{DateTime.UtcNow} - Exception on DeleteFile(), File: {path} doesn't exist");
                }


            }
            catch (Exception ex)
            {
                Console.WriteLine($"{DateTime.UtcNow} - Exception on DeleteFile(), File: {path}, Exception: {ex.Message}");
            }
        }
    }
}

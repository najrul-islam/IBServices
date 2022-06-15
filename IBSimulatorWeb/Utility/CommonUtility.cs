using CFEMSDB.DB;
using IBSimulatorWeb.Extensions;
using IBSimulatorWeb.Models;
using Newtonsoft.Json;

namespace IBSimulatorWeb.Utility
{
    public static class CommonUtility
    {
        public static async Task<string> UpdateConfigurationFile(string[] modifiedDGs,IHttpClient _httpClient, IBDBContext _db)
        {
            try
            {
                foreach (var modifiedDG in modifiedDGs)
                {
                    List<LMDConfiguration> lmdConfigs = new();
                    var lmdDatas = _db.TblRtus.Where(x => x.ColDgSetupIdFk == modifiedDG && x.ColIsActive == true).ToList();

                    foreach (var lmdData in lmdDatas)
                    {
                        LMDConfiguration lmdConfig = new();

                        var lmd = new Lmd
                        {
                            LmdId = lmdData.ColRtuId,
                            ipaddress = lmdData.ColRtuIpAddress
                        };

                        var devices = _db.TblEquipments.Where(x => x.ColRtuIdFk == lmdData.ColRtuId).Select(x => new Device { type = x.ColDeviceType.ToString(), baudrate = x.ColBaudrate, LmdNo = x.ColRtuNumber, rbelo = x.ColLatestRbelo, rbehi = x.ColLatestRbehi }).ToList();

                        lmdConfig.lmd = lmd;
                        lmdConfig.devices = devices;
                        lmdConfigs.Add(lmdConfig);
                    }

                    string json = JsonConvert.SerializeObject(lmdConfigs);
                    var path = Directory.GetCurrentDirectory() + "\\Upload\\" + modifiedDG + ".json";
                    System.IO.File.WriteAllText(path, json);
                    var file = System.IO.File.OpenRead(path);

                    var res = await _httpClient.UpdateConfigFile("api/v1.0/DGConfiguration?apiKey=1c852fac-4271-42b7-b0x91-48d7579ecdee", file);

                    if (res != null)
                    {
                        var dgData = _db.TblDgSetups.Where(x => x.ColDgSetupId.ToString() == modifiedDG).FirstOrDefault();
                        await _httpClient.DeleteExistingConfigFile($"api/v1.0/DGConfiguration?apiKey=1c852fac-4271-42b7-b0x91-48d7579ecdee&fileHash={dgData.ColConfiugrationFileHash}");

                        dgData.ColConfiugrationFileHash = res.ToString();
                        _db.Update(dgData);
                        _db.SaveChanges();
                    }


                }
                return "ok";
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error Occured on Update Configuration File. Error:" + ex);
                return "fail";
            }
        }

    }
}

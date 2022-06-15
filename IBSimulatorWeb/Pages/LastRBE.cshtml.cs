using CFEMSDB.DB;
using IBSimulatorWeb.Models;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Newtonsoft.Json;
using System.Collections;
using System.Globalization;

namespace IBSimulatorWeb.Pages
{
    public class LastRBEModel : PageModel
    {
        private readonly ILogger<LastRBEModel> _logger;
        //private readonly IConfiguration _configuration;
        private readonly IBDBContext _db;
        public List<TblBuilding> _buildings = new();
        public List<TblRtu> _rtus = new();
        public List<TblEquipment> _equipments = new();
        public List<TblEquipment> _selectedEquipments = new();
        public string selectedBuildingId = "0";
        public string selectedRtuId = "0";
        public string selectedEquipmentId = "0";
        public List<BitChanges> bitChangeList = new List<BitChanges>();
        public string bitChangeListJson = "";
        public LastRBEModel(ILogger<LastRBEModel> logger, IConfiguration configuration, IBDBContext db)//,MQTTClient mQTTClient 
        {
            _logger = logger;
            //_configuration = configuration;
            _db = db;
        }
        public void OnGet()
        {
            GetList();
        }
        private void GetList()
        {
            //using (var db = new IBDBContext(_configuration.GetConnectionString("DefaultConnection")))
            //{
                var buildings = new List<TblBuilding>();
                _buildings = _db.TblBuildings.ToList();
                var rtus = new List<TblRtu>();
                _rtus = _db.TblRtus
                    .Where(x => x.ColBuildingIdFk == selectedBuildingId)
                    .ToList();
                var equipments = new List<TblEquipment>();
                _equipments = _db.TblEquipments
                    .Where(x => x.ColRtuIdFk == selectedRtuId)
                    .ToList();
                _selectedEquipments = _db.TblEquipments
                   .Where(x => x.ColEquipmentId == selectedEquipmentId)
                   .ToList();
            //}
        }
        public void OnPostFilterEquipment()
        {
            selectedBuildingId = Request.Form["buildings"].FirstOrDefault();
            selectedRtuId = Request.Form["rtus"].FirstOrDefault();
            selectedEquipmentId = Request.Form["equipments"].FirstOrDefault();
            GetList();

            if (_selectedEquipments?.Count == 1)
            {
                string lastRbelo = _selectedEquipments.FirstOrDefault()?.ColLastRbelo ?? "";
                string lastRbehi = _selectedEquipments.FirstOrDefault()?.ColLastRbehi ?? "";
                string latestRbelo = _selectedEquipments.FirstOrDefault()?.ColLatestRbelo ?? "";
                string latestRbehi = _selectedEquipments.FirstOrDefault()?.ColLatestRbehi ?? "";

                //RBELo
                var lastRbeLoBitArry = ConvertHexToBitArray(lastRbelo);
                var latestRbeLoBitArry = ConvertHexToBitArray(latestRbelo);
                
                //RBEHi
                var lastRbeHiBitArry = ConvertHexToBitArray(lastRbehi);
                var latestRbeHiBitArry = ConvertHexToBitArray(latestRbehi);

                //low bit calculation
                if (lastRbeLoBitArry != null && latestRbeLoBitArry != null)
                {
                    // XOR Old rbelo with new rbe
                    var _rbeXorLoBitArray = lastRbeLoBitArry.Xor(latestRbeLoBitArry);

                    for (int i = _rbeXorLoBitArray.Count - 1; i >= 0; i--)
                    {
                        bool bit = _rbeXorLoBitArray.Get(i);
                        if (bit)
                        {
                            BitChanges bitChange = new BitChanges
                            {
                                bit_nbr = _rbeXorLoBitArray.Count - i,
                                bit_status = latestRbeLoBitArry[i] == true ? 1 : 0,
                            };
                            bitChangeList.Add(bitChange);
                        }
                    }
                }
                //high bit calculation
                if (lastRbeHiBitArry != null && latestRbeHiBitArry != null)
                {
                    // XOR Old rbehi with new rbe
                    var _rbeXorHiBitArray = lastRbeHiBitArry.Xor(latestRbeHiBitArry);

                    for (int i = _rbeXorHiBitArray.Count - 1; i >= 0; i--)
                    {
                        bool bit = _rbeXorHiBitArray.Get(i);
                        if (bit)
                        {
                            BitChanges bitChange = new BitChanges
                            {
                                bit_nbr = _rbeXorHiBitArray.Count - i + 64,
                                bit_status = latestRbeHiBitArry[i] == true ? 1 : 0,
                            };
                            bitChangeList.Add(bitChange);
                        }
                    }
                }
                bitChangeListJson = JsonConvert.SerializeObject(bitChangeList ?? new List<BitChanges>(), Formatting.Indented);
            }

            BitArray ConvertHexToBitArray(string rbeByteMsg)
            {
                try
                {
                    rbeByteMsg = rbeByteMsg.Replace("0x", "");
                    var int64 = long.Parse(rbeByteMsg, NumberStyles.HexNumber);
                    var bytes = BitConverter.GetBytes(int64);
                    var bitArray = new BitArray(bytes);

                    return bitArray;
                }
                catch (Exception ex)
                {
                    return null;
                }
            }
        }
    }
}

using CFEMSDB.DB;

namespace CFEMSDB.Utility
{
    public static class Common
    {
        public static string GetEquipmentId(string rtuId, int rtuNo, string cs)
        {
            using (var db = new IBDBContext(cs))
            {
                string eqId = db.TblEquipments.FirstOrDefault(x => x.ColRtuIdFk == rtuId && x.ColRtuNumber == rtuNo).ColEquipmentId;
                return eqId;
            }
        }

        public static string GetDGSetupId(string dgId, string cs)
        {
            using (var db = new IBDBContext(cs))
            {
                string dgSetupId = db.TblDgSetups.FirstOrDefault(x => x.ColDgId == dgId).ColDgSetupId.ToString();
                return dgSetupId;
            }
        }
    }
}

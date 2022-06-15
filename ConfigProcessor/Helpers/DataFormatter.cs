namespace ConfigProcessor.Helpers;

public class DataFormatter
{
    public static string GetHLMDLiftId(string liftId)
    {
        if (liftId == null)
        {
            return null;
        }
        else
        {
            if (liftId == string.Empty)
            {
                return string.Empty;
            }
            else
            {
                return liftId.Substring(0, liftId.Length - 1) + "H" + liftId[liftId.Length - 1];
            }
        }


    }
}
using System;
using System.Collections.Generic;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using log4net;

namespace CityParkWS
{
    public class AhuzotHoffApi
    {
        private static String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
        protected static readonly ILog log = LogManager.GetLogger(typeof(AhuzotHoffApi));
        private readonly static int UNKNOWN = -1;
        private readonly static int VACANT = 4;
        private readonly static int OCCUPIED = 0;
        private readonly static int CLOSED = 0;
        private readonly static String ServiceProvider = "ahuzot";


        private static int stateToNum(String state)
        {
            if (state == null || "".EndsWith(state))
                return UNKNOWN;
            switch (state)
            {
                case "פנוי":
                    return VACANT;
                case "מלא":
                    return OCCUPIED;
                case "מעט":
                    return VACANT;
                case "סגור":
                    return CLOSED;
                case "פעיל":
                    return UNKNOWN;
                case "חינם":
                    return UNKNOWN;     
                default:
                    return UNKNOWN;
            }

        }

        public static void updateAllCarParkStatus(String ahuzotUser, String ahuzotPassword, String fWSPwd)
        {
            ahuzot.parkinfo.CP ahuzotApi = new ahuzot.parkinfo.CP();
            String refStr = "";
            ahuzot.parkinfo.CarParkDynamicDetails[] data = ahuzotApi.GetAllCarParkStatus(ahuzotUser, ahuzotPassword, ref refStr, fWSPwd);
            try
            {
                log.Info("Updating all Ahuzot Hof parkings status.");
                using (SqlConnection con = new SqlConnection(conStr))
                {
                    con.Open();
                    using (SqlCommand updateCmd = new SqlCommand())
                    {
                        updateCmd.CommandTimeout = 600;
                        foreach (ahuzot.parkinfo.CarParkDynamicDetails parking in data)
                        {
                            int parkingStatus = stateToNum(parking.InformationToShow);
                            int externalId = parking.AhuzotCode;
                            String updateSql = String.Format(
                                @"UPDATE [citypark].[dbo].[Parking] SET Current_Pnuyot = {1} ,[Editdate] = CURRENT_TIMESTAMP WHERE externalid = {0}"
                            , externalId, parkingStatus);

                            updateCmd.Connection = con;
                            updateCmd.CommandText = updateSql;

                            updateCmd.ExecuteNonQuery();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                log.Error(ex.Message);
                return;
            }
            log.Info("Finished updating ahuzot hof status.");
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand insertCmd = new SqlCommand())
                {
                    insertCmd.CommandTimeout = 200;
                    String updateSql = String.Format(
                        @"INSERT INTO [CITYPARK].[dbo].[ServiceProviderLog]
                                       ([ServiceProvider]
                                       ,[API]
                                       ,[AccessDate])
                                 VALUES
                                       ('{0}'
                                       ,'{1}'
                                       ,CURRENT_TIMESTAMP)", ServiceProvider, "GetAllCarParkStatus");
                    insertCmd.Connection = con;
                    insertCmd.CommandText = updateSql;
                    con.Open();
                    insertCmd.ExecuteNonQuery();
                }
            }
        }

        public static void updateServiceProviderLog(String methodName, String sessionId, int externalId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(conStr))
                {
                    using (SqlCommand insertCmd = new SqlCommand())
                    {
                        insertCmd.CommandTimeout = 200;
                        String updateSql = String.Format(
                            @"INSERT INTO [CITYPARK].[dbo].[ServiceProviderLog]
                                       ([ServiceProvider]
                                       ,[API]
                                       ,[AccessDate]
                                       ,[sessionId]
                                        ,[externalId])
                                 VALUES
                                       ('{0}'
                                       ,'{1}'
                                       ,CURRENT_TIMESTAMP,'{2}',{3})", ServiceProvider, methodName, sessionId, externalId);
                        insertCmd.Connection = con;
                        insertCmd.CommandText = updateSql;
                        con.Open();
                        insertCmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                log.Error("Can not update ServiceProviderLog. "+ex.Message);
            }
        }
        

        public static void getAllCarParkDetails(String ahuzotUser, String ahuzotPassword, String fWSPwd)
        {
            ahuzot.parkinfo.CP ahuzotApi = new ahuzot.parkinfo.CP();
            String refStr = "";
            ahuzot.parkinfo.CarParkStaticDetails[] data = ahuzotApi.GetAllCarParkDetails(ahuzotUser, ahuzotPassword, ref refStr, fWSPwd);
            foreach (ahuzot.parkinfo.CarParkStaticDetails parking in data)
            {
                log.Info("----------------------------------------");
                log.Info(parking +"~Address:"+parking.Address +"~AhuzotCode:"+parking.AhuzotCode +"~ControllerID:"+parking.ControllerID +
                    "~DailyFee:"+parking.DailyFee +"~DailyFeeWindow:"+parking.DailyFeeWindow +"~DaytimeFee:"+parking.DaytimeFee +
                    "~DaytimeFeeWindow:" + parking.DaytimeFeeWindow + "~Extra01:" + parking.Extra01 + "~Extra02:" + parking.Extra02 +
                    "~Extra03:" + parking.Extra03 + "~Extra04:" + parking.Extra04 +
                    "~Extra05:" + parking.Extra05 + "~FeeComments:" + parking.FeeComments +
                    "~Latitude:" + parking.GPSLattitude + "~Longitude:" + parking.GPSLongitude +
                    "~MaximumPublicOccupancy:" + "" + parking.MaximumPublicOccupancy + "~MaximumSubscriberOccupancy:" + parking.MaximumSubscriberOccupancy
                    + "~MonthFeeForDailySubscriber:" + parking.MonthFeeForDailySubscriber +
                    "~MonthFeeForDailySubscriberWindow:" + parking.MonthFeeForDailySubscriberWindow + "~MonthFeeForNightlySubscriber:" + parking.MonthFeeForNightlySubscriber +
                    "~MonthFeeForNightlySubscriberWindow:" + parking.MonthFeeForNightlySubscriberWindow + "~Name:" + parking.Name +
                    "~NighttimeFee:" + parking.NighttimeFee + "~NighttimeFeeWindow:" + parking.NighttimeFeeWindow + "~OpenWindow:" + parking.OpenWindow );
            }

            /* using (SqlConnection con = new SqlConnection(conStr))
             {
                 using (SqlCommand cmd = new SqlCommand())
                 {

                     String sql = String.Format(
                         @"SELECT COUNT(*)
                             FROM CITYPARK.[dbo].[StreetParking] where Date > dateadd(hh, {0}, getdate())", 2);
                     cmd.Connection = con;
                     cmd.CommandType = CommandType.Text;
                     cmd.CommandText = sql;
                     con.Open();

                 }
             }*/
        }
    }
}
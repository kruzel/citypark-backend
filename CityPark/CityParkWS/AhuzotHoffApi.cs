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



        public static void getAllCarParkStatus(String ahuzotUser, String ahuzotPassword, String fWSPwd)
        {
            ahuzot.parkinfo.CP ahuzotApi = new ahuzot.parkinfo.CP();
            String refStr = "";
            ahuzot.parkinfo.CarParkDynamicDetails[] data = ahuzotApi.GetAllCarParkStatus(ahuzotUser, ahuzotPassword, ref refStr, fWSPwd);
            foreach (ahuzot.parkinfo.CarParkDynamicDetails parking in data)
            {
                String parkingStatus = parking.InformationToShow;
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
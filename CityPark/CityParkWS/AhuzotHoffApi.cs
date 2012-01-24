using System;
using System.Collections.Generic;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;

namespace CityParkWS
{
    public class AhuzotHoffApi
    {
        private static String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;



        public static void getAllCarParkStatus(String ahuzotUser, String ahuzotPassword, String fWSPwd)
        {
            ahuzot.parkinfo.CP ahuzotApi = new ahuzot.parkinfo.CP();
            String refStr = "";
            ahuzot.parkinfo.CarParkDynamicDetails[] data = ahuzotApi.GetAllCarParkStatus(ahuzotUser, ahuzotPassword, ref refStr, fWSPwd);
            foreach (ahuzot.parkinfo.CarParkDynamicDetails parking in data)
            {
                String parkingStatus = parking.InformationToShow;
            }

            using (SqlConnection con = new SqlConnection(conStr))
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
            }
        }
    }
}
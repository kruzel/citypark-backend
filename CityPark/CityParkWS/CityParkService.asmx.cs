using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Services;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Security.Cryptography;
using System.Web.Services.Protocols;
using System.Xml;
using System.Timers;
using System.Data;
using log4net;
using log4net.Core;
using System.Threading;

namespace CityParkWS
{    
    /// <summary>
    /// This is the API for CityPark services, to find parking place in realtime
    /// </summary>
    [WebService(Namespace = "http://citypark.co.il/ws/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    public class CityParkService : System.Web.Services.WebService
    {
        
        private static Boolean PredictionAlgorithmEnabled = false;
        private static String userDemo = "demo@citypark.co.il";

        private static String ahuzotUser = "wsu-ofer";
        private static String ahuzotPassword = "Oferk@756";
        private static String fWSPwd = "10fd90e7004c6499fe86146fc888eee62c2d1e1ae0bf7a1c34c3346cec15fada";
        
        //Timer task properties
        private static DateTime lastRan = DateTime.Today.AddHours(-24);
        private static System.Timers.Timer timer = null;
        private static System.Timers.Timer updateDataTimer = null;
        private static Boolean timerSPRunning = false;

        private static float TPhigh = 30 * 60;//in seconds
        private static int RADIUS = 500;//in meter

        private static Dictionary<String, SessionDataWrapper> sessionMap = null;
        private static SegmentSessionMap segmentSessionMap = null;
        private static String USER_NOT_FOUND = "NO USER FOUND";
        private static String USER_ALREADY_EXISTS = "USER ALREADY EXISTS";
        private static String START_PAYMENT = "START_PAYMENT";
        private static String STOP_PAYMENT = "STOP_PAYMENT";
        private static String ACKNOWLEDGED = "ACKNOWLEDGED";
        private static String FAILED = "FAILED";
        private static String UNVERIFIED = "UNVERIFIED";
        private static String USER_NOT_AUTHENTICATE = "User is not authenticated, Please login to the system!";

        protected static readonly ILog log = LogManager.GetLogger(typeof(CityParkService));

        public CityParkService()
        {            
            if (segmentSessionMap == null)
            {
                log4net.Config.XmlConfigurator.Configure();//need to be just once
                log.Info("--------------------------------");
                log.Info("Application init ...");
                
                segmentSessionMap = new SegmentSessionMap();
            }
            if (sessionMap == null)
            {
                sessionMap = new Dictionary<String, SessionDataWrapper>();
            }
            if (timer == null || !timer.Enabled)
            {
                log.Info("Create timer ...");
                timer = new System.Timers.Timer(240000);//four minute
                timer.Elapsed += new ElapsedEventHandler(timer_Elapsed);
                timer.Start();
            }
            if (updateDataTimer == null || !updateDataTimer.Enabled)
            {
                log.Info("Create integration timer ...");
                updateDataTimer = new System.Timers.Timer(600000);//10 minutes
                updateDataTimer.Elapsed += new ElapsedEventHandler(updateDataFromIntegrations);
                updateDataTimer.Start();
                log.Info("--------------------------------");
            }
        }

        void updateDataFromIntegrations(object sender, ElapsedEventArgs e)
        {
            try
            {
                //Update Ahuzot hoff parking lots status
                AhuzotHoffApi.updateAllCarParkStatus(ahuzotUser, ahuzotPassword, fWSPwd);
            }
            catch (Exception ex)
            {
                log.Error("updateAllCarParkStatus error: " + ex.Message);
            }
            try
            {
                //Reset all parking lots ,except of Ahozot Hoff and CenteralPrak, to UNKNOWN status
                resetGarages();
            }
            catch (Exception ex)
            {
                log.Error("Error while reset the current_pnuyot in DB:" + ex.Message);
            }
        }

        void timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            //Algo:
            cleanSWT();
            List<String> keys = new List<String>(sessionMap.Keys);
            for (int i = 0; i < keys.Count; i++)
            {
                try
                {
                    String sessionIdKey = keys[i];
                    DateTime dateTime = sessionMap[sessionIdKey].sessionData.LastUpdate;
                    if (DateTime.Now.Subtract(dateTime).TotalMinutes >= 10)
                    {
                        //algo: remove user from segmentWaitList and from segments
                        segmentSessionMap.removeSessionDataFromAllSegments(sessionIdKey);
                        sessionMap.Remove(sessionIdKey);
                    }
                }
                catch (Exception ex)
                {
                    log.Error("removeSessionDataFromAllSegments error: "+ex.Message);
                }
            }
            //if the stored procedures are still running
            if (timerSPRunning)
            {
                log.Warn("The stored procedures are still running");
                return;
            }
            DateTime scheduledRun = DateTime.Today.AddHours(1);//1am aka 01:00
            DateTime scheduledRunTop = DateTime.Today.AddHours(4);//4am aka 04:00

            if (DateTime.Now.CompareTo(scheduledRun) > 0 && DateTime.Now.CompareTo(scheduledRunTop) < 0)
            {
                double sinceLastRun = DateTime.Now.Subtract(lastRan).TotalHours;
                log.Info(sinceLastRun+" hours has passed since last SP.");
                if (sinceLastRun > 23)
                {
                    try
                    {
                        callStoredProcedures();
                    }
                    catch (Exception ex)
                    {
                        log.Error("callStoredProcedures() :" + ex.Message);
                        timerSPRunning = false;
                    }
                    lastRan = DateTime.Now;
                }
            }
        }

        private void callStoredProcedures()
        {
            timerSPRunning = true;
            log.Info("Starting the background process...");
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
            try
            {
                using (SqlConnection con = new SqlConnection(conStr))
                {
                    using (var command = new SqlCommand("[CITYPARK].[dbo].algoDataProcessAndMoveToHistory", con)
                    {
                        CommandType = CommandType.StoredProcedure
                    })
                    {
                        log.Info("Execute SP - algoDataProcessAndMoveToHistory");
                        con.Open();
                        command.CommandTimeout = 3600;
                        command.ExecuteNonQuery();
                        con.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                log.Error("algoDataProcessAndMoveToHistory :" + ex.Message);
            }

            try
            {
                using (SqlConnection con = new SqlConnection(conStr))
                {
                    using (var command = new SqlCommand("[CITYPARK].[dbo].updateSegmentUsingAuditPayment", con)
                    {
                        CommandType = CommandType.StoredProcedure
                    })
                    {
                        log.Info("Execute SP - updateSegmentUsingAuditPayment");
                        con.Open();
                        command.CommandTimeout = 3600;
                        command.ExecuteNonQuery();
                        con.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                log.Error("updateSegmentUsingAuditPayment :" + ex.Message);
            }

            try
            {
                using (SqlConnection con = new SqlConnection(conStr))
                {
                    using (var command = new SqlCommand("[CITYPARK].[dbo].oldAlgoUpdateStreetParkingWithSegment", con)
                    {
                        CommandType = CommandType.StoredProcedure
                    })
                    {
                        log.Info("Execute SP - oldAlgoUpdateStreetParkingWithSegment");
                        con.Open();
                        command.CommandTimeout = 3600;
                        command.ExecuteNonQuery();
                        con.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                log.Error("oldAlgoUpdateStreetParkingWithSegment :" + ex.Message);
            }
            log.Info("Finished the background process.");
            timerSPRunning = false;
        }

        private Boolean isDemoUser(String sessionId)
        {
            try
            {
                return userDemo.Equals(sessionMap[sessionId].sessionData.UserName);
                //return true;
            }
            catch (Exception ex)
            {
                log.Error("Demo user error:"+ex.Message);
                return false;
            }
        }

        [WebMethod(Description = "Administration:updade garages reset")]
        public String resetGarageStatus(String user, String pwd)
        {
            try
            {
                if (user.Trim().Equals("ranbrandes") && pwd.Trim().Equals("@ss@fB2-8-10pwd"))
                {
                    return resetGarages();
                }
            }
            catch (Exception ex)
            {
                log.Error(ex.Message);
                return "Error";
            }
            return "Nothing !";
        }

        private String resetGarages()
        {
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conStr))
            {

                using (SqlCommand updateCmd = new SqlCommand())
                {
                    String updateSql =
                        @"declare  @DD DATETIME
                            SET @DD = DateADD(mi, -5, Current_TimeStamp)
                            UPDATE [CITYPARK].[dbo].[Parking]
                               SET [Current_Pnuyot] = -1 ,[Editdate] = CURRENT_TIMESTAMP
                             WHERE  Current_Pnuyot >= 0
                                and Editdate < @DD
                                and (parkid is null or parkId not in ('ahuzot','centralpark'))";
                    updateCmd.Connection = con;
                    updateCmd.CommandText = updateSql;
                    con.Open();
                    updateCmd.ExecuteNonQuery();
                    log.Info("Finished executing reset garages status.");
                    return "Done";
                }
            }
        }

        [WebMethod(Description = "Administration:Returns the sessionData")]
        public List<SessionData> getSessionData(String user, String pwd)
        {
            List<SessionData> list = new List<SessionData>();
            if (user.Trim().Equals("ranbrandes") && pwd.Trim().Equals("@ss@fB2-8-10pwd"))
            {
                foreach (SessionDataWrapper sd in sessionMap.Values)
                {
                    list.Add(sd.sessionData);
                }
            }
            return list;
        }

        [WebMethod(Description = "Administration:getAhouzot")]
        public void adminGetAhuzotHofData(String user, String pwd)
        {
            if (user.Trim().Equals("ranbrandes") && pwd.Trim().Equals("@ss@fB2-8-10pwd"))
                AhuzotHoffApi.getAllCarParkDetails(ahuzotUser,ahuzotPassword,fWSPwd);
        }

        [WebMethod(Description = "Administration:getAhouzot status")]
        public void adminGetAhuzotHofStatus(String user, String pwd)
        {
            if (user.Trim().Equals("ranbrandes") && pwd.Trim().Equals("@ss@fB2-8-10pwd"))
                AhuzotHoffApi.updateAllCarParkStatus(ahuzotUser, ahuzotPassword, fWSPwd);
        }

        [WebMethod(Description = "Administration:invoke SP")]
        public void adminSPInvoke(String user, String pwd)
        {
            if (user.Trim().Equals("ranbrandes") && pwd.Trim().Equals("@ss@fB2-8-10pwd"))
                callStoredProcedures();
        }


        [WebMethod(Description = "Administration:Set and get configuration data")]
        public List<String> config(String user, String pwd, String key, String value)
        {
            List<String> list = new List<String>();
            if (user.Trim().Equals("ranbrandes") && pwd.Trim().Equals("@ss@fB2-8-10pwd"))
            {
                switch (key.Trim())
                {
                    case "ahuzotPassword":
                        ahuzotPassword = value;
                        list.Add("Ahuzot Hoff integration password has changed!");
                        break;
                    case "RADIUS":
                        RADIUS = Int32.Parse(value);
                        break;
                    case "log":
                        if (value.Equals("INFO")) LogManager.GetRepository().Threshold = Level.Info;
                        if (value.Equals("DEBUG")) LogManager.GetRepository().Threshold = Level.Debug;
                        break;
                    case "TPhigh":
                        TPhigh = Int32.Parse(value);
                        break;
                    case "Algorithm":
                        PredictionAlgorithmEnabled = Boolean.Parse(value);
                        break;
                    default:
                        break;
                }
                list.Add("demo user:" + userDemo);
                list.Add("Algorithm (PredictionAlgorithmEnabled):" + PredictionAlgorithmEnabled);
                list.Add("RADIUS:" + RADIUS);
                list.Add("TPhigh:" + TPhigh);
                list.Add("timerSPRunning:" + timerSPRunning);
                list.Add("last update time(SP):" + lastRan);
                list.Add("Ahuzot Integration User:" + ahuzotUser);
            }
            return list;
        }

        private String getLanguage(String language)
        {
            if (language == null||"".Equals(language.Trim()))
                return "he";
            return language.ToLower();
        }


        [WebMethod(Description = "Return all garages data within the current location in radius of the given distance")]
        public List<Parking> findAllGarageParkingDataByLatitudeLongitude(String sessionId, float latitude, float longitude, int distance, String language)
        {//and parkingtype='חניון בחינם' or parkingtype='חניון בתשלום'   
            if (!authenticateUser(sessionId))//sessionId.Equals(Session["userId"]))
            {
                //HttpContext.Current.Response.StatusCode = 401;
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                    "findAllGarageParkingDataByLatitudeLongitude",
                                    USER_NOT_AUTHENTICATE,
                                    "401",
                                    "findAllGarageParkingDataByLatitudeLongitude");
            }
            language = getLanguage(language);   
            Boolean demo = isDemoUser(sessionId);
            Random random = null;
            if (demo)
            {
                random = new Random();
            }
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    /*String searchSql = String.Format(
                     @"DECLARE
                        @NOW geography 
                        SET
                        @NOW = geography::Point({0}, {1},4326) 
                        SELECT
                        top 200.*, b.firstHourPrice, b.extraQuarterPrice, b.allDayPrice, 
                        @NOW.STDistance(geography::Point(latitude,longitude,4326)) as Distance 
                        FROM CITYPARK.[dbo].[Parking] as a, CITYPARK.[dbo].[parking_shortrange] b 
                        where a.parkingID=b.parkId 
                        and DATEPART(dw, GETDATE()) between 
                        Case when fromDay='א' then 1
                        when fromDay='ב' then 2
                        when fromDay='ג' then 3
                        when fromDay='ד' then 4
                        when fromDay='ה' then 5
                        when fromDay='ו' then 6
                        when fromDay='שבת' then 7
                        End 

                        and Case when toDay='א' then 1
                        when toDay='ב' then 2
                        when toDay='ג' then 3
                        when toDay='ד' then 4
                        when toDay='ה' then 5
                        when toDay='ו' then 6
                        when toDay='שבת' then 7
                        End

                        and DATENAME(hour, GETDATE())>=CAST(b.fromHour AS int)and DATENAME(hour, GETDATE())<=CAST(b.toHour AS int)
                        and Heniontype='חניון' and @NOW.STDistance(geography::Point(latitude,longitude,4326))<={2}
                        order by Distance asc", latitude, longitude, distance);// and Current_Pnuyot>0 and isnumeric (b.firsthourprice)=1*/
                    String searchSql = String.Format(
                     @"DECLARE  @USER geography = geography::Point({0}, {1},4326) 
                       DECLARE @Date DATETIME 
                        SET @Date = GETDATE()
                            SELECT top 200.*,
                            CASE WHEN DATEPART(dw, @Date) BETWEEN 1 and 5 and DATENAME(hour, @Date)< Weekday_OneTimeHour 
		                    THEN (select WeekDay_FirstHourPrice)
                            WHEN DATEPART(dw, @Date) BETWEEN 1 and 5 and DATENAME(hour, @Date)>=Weekday_OneTimeHour and Weekday_OneTimeHour>1
			                    THEN (select Weekday_OneTimePrice)
                            WHEN DATEPART(dw, @Date)=6 and DATENAME(hour, @Date)<Friday_OneTimeHour
		                        THEN (select Friday_FirstHourPrice)
                            WHEN DATEPART(dw, @Date)=6 and DATENAME(hour, @Date)>=Friday_OneTimeHour and Friday_OneTimeHour>1
			                    THEN (select Friday_OneTimePrice)
                            WHEN DATEPART(dw, @Date)=7 and DATENAME(hour, @Date)<Saturday_FirstHourPrice
			                    THEN (select Saturday_FirstHourPrice)
                            WHEN DATEPART(dw, @Date)=7 and DATENAME(hour, @Date)>=Saturday_OneTimeHour and Saturday_OneTimeHour >1
			                    THEN (select Saturday_OneTimePrice)
                           END AS FirstHourPrice,
       
                           CASE WHEN DATEPART(dw, @Date) BETWEEN 1 and 5 and DATENAME(hour, @Date)< Weekday_OneTimeHour
		                    THEN (select WeekDay_extraQuarterPrice)
                            WHEN DATEPART(dw, @Date) BETWEEN 1 and 5 and DATENAME(hour, @Date)>=Weekday_OneTimeHour and Weekday_OneTimeHour>1
			                    THEN 0
                            WHEN DATEPART(dw, @Date)=6 and DATENAME(hour, @Date)<Friday_OneTimeHour
		                        THEN (select Friday_extraQuarterPrice)
                            WHEN DATEPART(dw, @Date)=6 and DATENAME(hour, @Date)>=Friday_OneTimeHour and Friday_OneTimeHour>1
			                    THEN 0
                            WHEN DATEPART(dw, @Date)=7 and DATENAME(hour, @Date)<Saturday_FirstHourPrice
			                    THEN (select Saturday_extraQuarterPrice)
                            WHEN DATEPART(dw, @Date)=7 and DATENAME(hour, @Date)>=Saturday_OneTimeHour and Saturday_OneTimeHour >1
			                    THEN 0
                            END AS extraQuarterPrice,
       
                             ROUND(@USER.STDistance(geography::Point(latitude,longitude,4326)),0) as Distance,
                             allDayPrice
        
                           FROM [CITYPARK].[dbo].[Parking]
			                    WHERE Heniontype='חניון'
                                and @USER.STDistance(geography::Point(latitude,longitude,4326))<{2}
                                order by Distance,vip asc", latitude, longitude, distance);// and Current_Pnuyot>0 and isnumeric (b.firsthourprice)=1
                    cmd.Connection = con;
                    cmd.CommandText = searchSql;
                    con.Open();
                    List<Parking> parkingList = new List<Parking>();
                    using (SqlDataReader sqlDataReader = cmd.ExecuteReader())
                    {
                        if (sqlDataReader.HasRows)
                        {
                            while (sqlDataReader.Read())
                            {
                                String parkingID = sqlDataReader["parkingID"].ToString();
                                String qHouseNumber = sqlDataReader["house_number"].ToString();
                                if ("NULL".Equals(qHouseNumber) || "".Equals(qHouseNumber.Trim())) qHouseNumber = "0";
                                int parkingIdInt = Convert.ToInt32(parkingID);
                                int houseNumInt = Convert.ToInt32(qHouseNumber);
                                Parking parking = new Parking(parkingIdInt,
                                    sqlDataReader["name"].ToString(),
                                    sqlDataReader["City"].ToString(),
                                    sqlDataReader["street_name"].ToString(),
                                    houseNumInt,
                                    sqlDataReader["latitude"].ToString(),
                                    sqlDataReader["longitude"].ToString());
                                parking.Comment = sqlDataReader["comment"].ToString();
                                parking.Owner = sqlDataReader["parkId"].ToString();
                                parking.Coupon_text = sqlDataReader["coupon_text"].ToString();
                                parking.Current_Pnuyot = sqlDataReader["current_Pnuyot"].ToString();
                                parking.Image = sqlDataReader["image"].ToString();
                                parking.Image2 = sqlDataReader["image2"].ToString();
                                parking.Withlock = sqlDataReader["Withlock"].ToString();
                                parking.Underground = sqlDataReader["Underground"].ToString();
                                parking.Nolimit = sqlDataReader["Nolimit"].ToString();
                                parking.Roof = sqlDataReader["Roof"].ToString();
                                parking.Criple = sqlDataReader["Criple"].ToString();
                                parking.Toshav = sqlDataReader["toshav"].ToString();
                                parking.Jenion = sqlDataReader["jenion"].ToString();
                                parking.FirstHourPrice = sqlDataReader["firstHourPrice"].ToString();
                                parking.ExtraQuarterPrice = sqlDataReader["extraQuarterPrice"].ToString();
                                parking.AllDayPrice = sqlDataReader["allDayPrice"].ToString();
                                parking.Distance = Convert.ToInt32(sqlDataReader["Distance"].ToString());
                                if ("ahuzot".Equals(parking.Owner))
                                {
                                    try
                                    {
                                        String externalIdStr = sqlDataReader["externalid"].ToString();
                                        if ("NULL".Equals(externalIdStr) || "".Equals(externalIdStr.Trim())) externalIdStr = "-1";
                                        int externalId = Convert.ToInt32(externalIdStr);
                                        new Thread(() => AhuzotHoffApi.updateServiceProviderLog("findAllGarageParkingDataByLatitudeLongitude", sessionId, externalId)).Start();
                                    }
                                    catch (Exception e)
                                    {
                                        log.Error(e.Message);
                                    }
                                }
                                if (demo)
                                {
                                    parking.Current_Pnuyot = random.Next(-1, 10) + "";
                                    if (parking.FirstHourPrice == "" || parking.FirstHourPrice == "NULL" || parking.FirstHourPrice == "0")
                                    {
                                        parking.FirstHourPrice = "25";
                                    }
                                }
                                parkingList.Add(parking);
                            }
                        }
                        else
                        {
                            return null;
                        }
                    }
                    return parkingList;
                }
            }
        }


        [WebMethod(Description = "Return all POI within the current location in radius of the given distance")]
        public List<POI> findPOIByLatitudeLongitude(String sessionId, float latitude, float longitude, int distance, String type, String subType,String language)
        {
            if (!authenticateUser(sessionId))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                    "findPOIByLatitudeLongitude",
                                    USER_NOT_AUTHENTICATE,
                                    "401",
                                    "findPOIByLatitudeLongitude");
            }
            language = getLanguage(language);   
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {

                    String subTypeRewrite = "";
                    if (!"".Equals(subType))
                    {
                        subTypeRewrite = " and sub_type='" + subType + "'";
                    }
                    String loginSql = String.Format(
                        @"DECLARE
                            @NOW geography
                            --User Location Parameter
                            SET @NOW = geography::Point({0},{1},4326)
                            -- Real time user location after geocoded (address to coordinates)
                            SELECT TOP 10 *,
                            @NOW.STDistance(geography::Point(latitude,longitude,4326)) as Distance
                            FROM Poi where type = '{2}'{3} and @NOW.STDistance(geography::Point(latitude,longitude,4326))<={4} 
                            order by Distance asc;", latitude, longitude, type, subTypeRewrite, distance);
                    cmd.Connection = con;
                    cmd.CommandText = loginSql;
                    con.Open();
                    List<POI> poiList = new List<POI>();
                    using (SqlDataReader sqlDataReader = cmd.ExecuteReader())
                    {
                        if (sqlDataReader.HasRows)
                        {
                            while (sqlDataReader.Read())
                            {
                                POI poi = new POI();
                                poi.Type = sqlDataReader["type"].ToString();
                                poi.SubType = sqlDataReader["sub_type"].ToString();
                                poi.Name = sqlDataReader["name"].ToString();
                                poi.City = sqlDataReader["city"].ToString();
                                poi.StreetName = sqlDataReader["street_name"].ToString();
                                String houseNum = sqlDataReader["house_number"].ToString();
                                if ("NULL".Equals(houseNum)) houseNum = "0";
                                poi.HouseNumber = Convert.ToInt32(houseNum);
                                poi.Comment = sqlDataReader["comment"].ToString();
                                poi.Image = sqlDataReader["image"].ToString();
                                poi.Longitude = sqlDataReader["longitude"].ToString();
                                poi.Latitude = sqlDataReader["latitude"].ToString();
                                poiList.Add(poi);
                            }
                        }
                        else
                        {
                            return null;
                        }
                    }
                    return poiList;
                }
            }
        }

        [WebMethod(Description = "Return filtered list of all garages within the current location in radius of the given distance")]
        public List<Parking> findGarageParkingFilteredByParams(String sessionId, float latitude, float longitude, int distance,
            String payment, String nolimit, String withlock, String tatkarkait, String roof, String toshav, String criple,String language)
        {
            if (!authenticateUser(sessionId))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                    "findGarageParkingFilteredByParams",
                                    USER_NOT_AUTHENTICATE,
                                    "401",
                                    "findGarageParkingFilteredByParams");
            }
            language = getLanguage(language);   
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    String paramsSql = Utils.getParkingParams(payment, nolimit, withlock, tatkarkait, roof, toshav, criple);
                    String loginSql = String.Format(
                     @"DECLARE  @USER geography = geography::Point({0}, {1},4326) 
                       DECLARE @Date DATETIME
                        SET @Date = GETDATE()
                            SELECT top 200.*,
                            CASE WHEN DATEPART(dw, @Date) BETWEEN 1 and 5 and DATENAME(hour, @Date)< Weekday_OneTimeHour 
		                    THEN (select WeekDay_FirstHourPrice)
                            WHEN DATEPART(dw, @Date) BETWEEN 1 and 5 and DATENAME(hour, @Date)>=Weekday_OneTimeHour and Weekday_OneTimeHour>1
			                    THEN (select Weekday_OneTimePrice)
                            WHEN DATEPART(dw, @Date)=6 and DATENAME(hour, @Date)<Friday_OneTimeHour
		                        THEN (select Friday_FirstHourPrice)
                            WHEN DATEPART(dw, @Date)=6 and DATENAME(hour, @Date)>=Friday_OneTimeHour and Friday_OneTimeHour>1
			                    THEN (select Friday_OneTimePrice)
                            WHEN DATEPART(dw, @Date)=7 and DATENAME(hour, @Date)<Saturday_FirstHourPrice
			                    THEN (select Saturday_FirstHourPrice)
                            WHEN DATEPART(dw, @Date)=7 and DATENAME(hour, @Date)>=Saturday_OneTimeHour and Saturday_OneTimeHour >1
			                    THEN (select Saturday_OneTimePrice)
                           END AS FirstHourPrice,
       
                           CASE WHEN DATEPART(dw, @Date) BETWEEN 1 and 5 and DATENAME(hour, @Date)< Weekday_OneTimeHour
		                    THEN (select WeekDay_extraQuarterPrice)
                            WHEN DATEPART(dw, @Date) BETWEEN 1 and 5 and DATENAME(hour, @Date)>=Weekday_OneTimeHour and Weekday_OneTimeHour>1
			                    THEN 0
                            WHEN DATEPART(dw, @Date)=6 and DATENAME(hour, @Date)<Friday_OneTimeHour
		                        THEN (select Friday_extraQuarterPrice)
                            WHEN DATEPART(dw, @Date)=6 and DATENAME(hour, @Date)>=Friday_OneTimeHour and Friday_OneTimeHour>1
			                    THEN 0
                            WHEN DATEPART(dw, @Date)=7 and DATENAME(hour, @Date)<Saturday_FirstHourPrice
			                    THEN (select Saturday_extraQuarterPrice)
                            WHEN DATEPART(dw, @Date)=7 and DATENAME(hour, @Date)>=Saturday_OneTimeHour and Saturday_OneTimeHour >1
			                    THEN 0
                            END AS extraQuarterPrice,
       
                             @USER.STDistance(geography::Point(latitude,longitude,4326)) as Distance,
                             allDayPrice
        
                           FROM [CITYPARK].[dbo].[Parking]
			                    WHERE Heniontype='חניון'
                                and @USER.STDistance(geography::Point(latitude,longitude,4326))<{2}{3}
                                order by Distance,vip asc", latitude, longitude, distance, paramsSql);//note: "and Current_Pnuyot>0" and isnumeric (b.firsthourprice)=1 was removed

                    cmd.Connection = con;
                    cmd.CommandText = loginSql;
                    con.Open();

                    List<Parking> parkingList = new List<Parking>();
                    using (SqlDataReader sqlDataReader = cmd.ExecuteReader())
                    {
                        if (sqlDataReader.HasRows)
                        {
                            while (sqlDataReader.Read())
                            {
                                String parkingID = sqlDataReader["parkingID"].ToString();
                                String qHouseNumber = sqlDataReader["house_number"].ToString();
                                if ("NULL".Equals(qHouseNumber) || "".Equals(qHouseNumber.Trim())) qHouseNumber = "0";
                                Parking parking = new Parking(Convert.ToInt32(parkingID),
                                    sqlDataReader["name"].ToString(),
                                    sqlDataReader["City"].ToString(),
                                    sqlDataReader["street_name"].ToString(),
                                    Convert.ToInt32(qHouseNumber),
                                    sqlDataReader["latitude"].ToString(),
                                    sqlDataReader["longitude"].ToString());
                                parking.Comment = sqlDataReader["comment"].ToString();
                                parking.Coupon_text = sqlDataReader["coupon_text"].ToString();
                                parking.Current_Pnuyot = sqlDataReader["current_Pnuyot"].ToString();
                                parking.Image = sqlDataReader["image"].ToString();
                                parking.Image2 = sqlDataReader["image2"].ToString();
                                parking.Withlock = sqlDataReader["Withlock"].ToString();
                                parking.Underground = sqlDataReader["Underground"].ToString();
                                parking.Nolimit = sqlDataReader["Nolimit"].ToString();
                                parking.Roof = sqlDataReader["Roof"].ToString();
                                parking.Criple = sqlDataReader["Criple"].ToString();
                                parking.Toshav = sqlDataReader["toshav"].ToString();
                                parking.Jenion = sqlDataReader["jenion"].ToString();
                                parking.FirstHourPrice = sqlDataReader["firstHourPrice"].ToString();
                                parking.ExtraQuarterPrice = sqlDataReader["extraQuarterPrice"].ToString();
                                parking.AllDayPrice = sqlDataReader["allDayPrice"].ToString();
                                parking.Owner = sqlDataReader["parkId"].ToString();
                                if ("ahuzot".Equals(parking.Owner))
                                {
                                    try
                                    {
                                        String externalIdStr = sqlDataReader["externalid"].ToString();
                                        if ("NULL".Equals(externalIdStr) || "".Equals(externalIdStr.Trim())) externalIdStr = "-1";
                                        int externalId = Convert.ToInt32(externalIdStr);
                                        new Thread(() => AhuzotHoffApi.updateServiceProviderLog("findGarageParkingFilteredByParams", sessionId, externalId)).Start();
                                    }
                                    catch (Exception e) 
                                    {
                                        log.Error(e.Message);
                                    }
                                }

                                parkingList.Add(parking);
                            }
                        }
                        else
                        {
                            return null;
                        }
                    }
                    return parkingList;
                }
            }
        }


        [WebMethod(Description = "Returns data for a specific parking garage")]
        public Parking fetchGarageParkingById(String sessionId, int parkingId,String language)
        {
            if (!authenticateUser(sessionId))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                    "fetchGarageParkingById",
                                    USER_NOT_AUTHENTICATE,
                                    "401",
                                    "fetchGarageParkingById");
            }
            language = getLanguage(language);   
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
            Parking parking = null;            
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    /*String fetchDataSql = String.Format(
                     @"SELECT *,
                        priceTbl.firstHourPrice, 
                        priceTbl.extraQuarterPrice, 
                        priceTbl.allDayPrice  
                        FROM
                        CITYPARK.[dbo].[Parking] as parkingTbl, 
                        CITYPARK.[dbo].[parking_shortrange] as priceTbl 
                        where parkingTbl.parkingID='{0}' and parkingTbl.parkingID=priceTbl.parkId", parkingId); //This is the old SQL*/

                    String fetchDataSql = String.Format(
                        @"DECLARE @Date DATETIME
                            SET @Date = GETDATE()	
                           SELECT top 1.*,
                            CASE WHEN DATEPART(dw, @Date) BETWEEN 1 and 5 and DATENAME(hour, @Date)< Weekday_OneTimeHour 
		                    THEN (select WeekDay_FirstHourPrice)
                            WHEN DATEPART(dw, @Date) BETWEEN 1 and 5 and DATENAME(hour, @Date)>=Weekday_OneTimeHour and Weekday_OneTimeHour>1
			                    THEN (select Weekday_OneTimePrice)
                            WHEN DATEPART(dw, @Date)=6 and DATENAME(hour, @Date)<Friday_OneTimeHour
		                        THEN (select Friday_FirstHourPrice)
                            WHEN DATEPART(dw, @Date)=6 and DATENAME(hour, @Date)>=Friday_OneTimeHour and Friday_OneTimeHour>1
			                    THEN (select Friday_OneTimePrice)
                            WHEN DATEPART(dw, @Date)=7 and DATENAME(hour, @Date)<Saturday_FirstHourPrice
			                    THEN (select Saturday_FirstHourPrice)
                            WHEN DATEPART(dw, @Date)=7 and DATENAME(hour, @Date)>=Saturday_OneTimeHour and Saturday_OneTimeHour >1
			                    THEN (select Saturday_OneTimePrice)
                           END AS FirstHourPrice,
       
                           CASE WHEN DATEPART(dw, @Date) BETWEEN 1 and 5 and DATENAME(hour, @Date)< Weekday_OneTimeHour
		                    THEN (select WeekDay_extraQuarterPrice)
                            WHEN DATEPART(dw, @Date) BETWEEN 1 and 5 and DATENAME(hour, @Date)>=Weekday_OneTimeHour and Weekday_OneTimeHour>1
			                    THEN 0
                            WHEN DATEPART(dw, @Date)=6 and DATENAME(hour, @Date)<Friday_OneTimeHour
		                        THEN (select Friday_extraQuarterPrice)
                            WHEN DATEPART(dw, @Date)=6 and DATENAME(hour, @Date)>=Friday_OneTimeHour and Friday_OneTimeHour>1
			                    THEN 0
                            WHEN DATEPART(dw, @Date)=7 and DATENAME(hour, @Date)<Saturday_FirstHourPrice
			                    THEN (select Saturday_extraQuarterPrice)
                            WHEN DATEPART(dw, @Date)=7 and DATENAME(hour, @Date)>=Saturday_OneTimeHour and Saturday_OneTimeHour >1
			                    THEN 0
                            END AS extraQuarterPrice,
                            allDayPrice        
                           FROM [CITYPARK].[dbo].[Parking]
			                    WHERE parkingID ='{0}'", parkingId);
                    cmd.Connection = con;
                    cmd.CommandText = fetchDataSql;
                    con.Open();
                    using (SqlDataReader sqlDataReader = cmd.ExecuteReader())
                    {
                        if (sqlDataReader.HasRows)
                        {
                            while (sqlDataReader.Read())
                            {
                                String parkingID = sqlDataReader["parkingID"].ToString();
                                String qHouseNumber = sqlDataReader["house_number"].ToString();
                                if ("NULL".Equals(qHouseNumber) || "".Equals(qHouseNumber.Trim())) qHouseNumber = "0";
                                int parkingIdInt = Convert.ToInt32(parkingID);
                                int houseNumInt = Convert.ToInt32(qHouseNumber);
                                parking = new Parking(parkingIdInt,
                                    sqlDataReader["name"].ToString(),
                                    sqlDataReader["City"].ToString(),
                                    sqlDataReader["street_name"].ToString(),
                                    houseNumInt,
                                    sqlDataReader["latitude"].ToString(),
                                    sqlDataReader["longitude"].ToString());
                                parking.Comment = sqlDataReader["comment"].ToString();
                                parking.Coupon_text = sqlDataReader["coupon_text"].ToString();
                                parking.Current_Pnuyot = sqlDataReader["current_Pnuyot"].ToString();
                                parking.Image = sqlDataReader["image"].ToString();
                                parking.Image2 = sqlDataReader["image2"].ToString();
                                parking.Withlock = sqlDataReader["Withlock"].ToString();
                                parking.Underground = sqlDataReader["Underground"].ToString();
                                parking.Nolimit = sqlDataReader["Nolimit"].ToString();
                                parking.Roof = sqlDataReader["Roof"].ToString();
                                parking.Criple = sqlDataReader["Criple"].ToString();
                                parking.Toshav = sqlDataReader["toshav"].ToString();
                                parking.Jenion = sqlDataReader["jenion"].ToString();
                                parking.FirstHourPrice = sqlDataReader["firstHourPrice"].ToString();
                                parking.ExtraQuarterPrice = sqlDataReader["extraQuarterPrice"].ToString();
                                parking.AllDayPrice = sqlDataReader["allDayPrice"].ToString();
                                if("ahuzot".Equals(parking.Owner))
                                {
                                    try
                                    {
                                        String externalIdStr = sqlDataReader["externalid"].ToString();
                                        if ("NULL".Equals(externalIdStr) || "".Equals(externalIdStr.Trim())) externalIdStr = "-1";
                                        int externalId = Convert.ToInt32(externalIdStr);
                                        new Thread(() => AhuzotHoffApi.updateServiceProviderLog("fetchGarageParkingById", sessionId, externalId)).Start();
                                    }
                                    catch (Exception e) 
                                    {
                                        log.Error(e.Message);
                                    }
                                }
                            }
                        }
                    }
                }
            }          
            return parking;
        }


        [WebMethod(Description = "Set parking status")]
        public int udpateGarageStatus(String sessionId,int parkingId ,int status)
        {
            if (!authenticateUser(sessionId))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                    "udpateGarageStatus",
                                    USER_NOT_AUTHENTICATE,
                                    "401",
                                    "udpateGarageStatus");
            }
            try
            {
                String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
                using (SqlConnection con = new SqlConnection(conStr))
                {

                    using (SqlCommand updateCmd = new SqlCommand())
                    {
                        String updateSql = String.Format(
                            @"UPDATE [CITYPARK].[dbo].[Parking]
                               SET [Current_Pnuyot] = {1} , [Editdate] = CURRENT_TIMESTAMP    
                                WHERE parkingID ='{0}'",
                            parkingId, status);
                        updateCmd.Connection = con;
                        updateCmd.CommandText = updateSql;
                        con.Open();
                        updateCmd.ExecuteNonQuery();
                    }
                }
                log.Info("Udpate garage status - User:" + sessionId + ", parkingID:" + parkingId + ", status:" + status);
                return status;
            }
            catch (Exception ex)
            {
                log.Error(ex.Message);
                return -1;
            }
            
        }




        [WebMethod(Description = "Login to CityPark WebService")]
        public SessionData login(String username, String password)
        {
            //byte[] asciiBytes = ASCIIEncoding.ASCII.GetBytes(password);
            //byte[] hashedBytes = MD5CryptoServiceProvider.Create().ComputeHash(asciiBytes);
            //string hashedString = BitConverter.ToString(hashedBytes).Replace("-", "").ToLower();
            ////// hashString == 202cb962ac59075b964b07152d234b70

            System.Security.Cryptography.MD5CryptoServiceProvider x = new System.Security.Cryptography.MD5CryptoServiceProvider();
            byte[] bs = System.Text.Encoding.UTF8.GetBytes(password);
            bs = x.ComputeHash(bs);
            System.Text.StringBuilder s = new System.Text.StringBuilder();
            foreach (byte b in bs)
            {
                s.Append(b.ToString("x2").ToLower());
            }
            password = s.ToString();

            // return password + "  \n  " + hashedString;

            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
            String responseStr = USER_NOT_FOUND;
            int id = -1;
            int count = -9999;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {

                    String loginSql = String.Format(
                        @"SELECT * FROM USERS WHERE Usersname = '{0}' and Password = '{1}'",
                        username,
                        password);
                    cmd.Connection = con;
                    cmd.CommandText = loginSql;
                    con.Open();
                    using (SqlDataReader sqlDataReader = cmd.ExecuteReader())
                    {
                        if (sqlDataReader.HasRows)
                        {
                            sqlDataReader.Read();
                            responseStr = sqlDataReader["Email"].ToString();
                            id = Int32.Parse(sqlDataReader["Id"].ToString());
                            String countSrt = sqlDataReader["count"].ToString();
                            if (countSrt.Equals("") || countSrt.ToLower().Equals("null"))
                            {
                                count = 0;
                            }
                            else
                            {
                                try
                                {
                                    count = Int32.Parse(countSrt);
                                }
                                catch (Exception ex)
                                {
                                    log.Error(ex.Message);
                                }
                            }
                        }
                    }
                    if (responseStr == USER_NOT_FOUND)
                    {
                        return new SessionData(USER_NOT_FOUND);
                    }
                }
                if (id != -1) //just double check 

                    using (SqlCommand updateCmd = new SqlCommand())
                    {
                        count = count + 1;
                        String updateSql = String.Format(
                            @"UPDATE USERS SET LastLogin =  CURRENT_TIMESTAMP , count={1} WHERE Id = '{0}'",
                            id, count);
                        updateCmd.Connection = con;
                        updateCmd.CommandText = updateSql;
                        // Then connection is already opened so there is no need to do con.Open();
                        updateCmd.ExecuteNonQuery();
                    }
            }

            String sessionId = id.ToString() + "T" + DateTime.Now.Millisecond;
            SessionData sessionData = new SessionData(responseStr, id, sessionId);
            sessionMap.Add(sessionId, new SessionDataWrapper(sessionData));
            log.Info("User "+username +" has created a new session :"+sessionId);
            return sessionData;
        }

        [WebMethod(Description = "Register to CityPark System, email will be the uid in the system")]
        public string register(String email, String password, String firstName, String familyName, String phoneNumber, String licensesPlate, String paymentService)
        {
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;

            //check if user already exists in the system
            SessionData sessionData = login(email, password);
            if (!sessionData.SessionId.Equals(USER_NOT_FOUND))
            {
                return USER_ALREADY_EXISTS;
            }
            //insert new user
            //first encrypt password
            System.Security.Cryptography.MD5CryptoServiceProvider x = new System.Security.Cryptography.MD5CryptoServiceProvider();
            byte[] bs = System.Text.Encoding.UTF8.GetBytes(password);
            bs = x.ComputeHash(bs);
            System.Text.StringBuilder s = new System.Text.StringBuilder();
            foreach (byte b in bs)
            {
                s.Append(b.ToString("x2").ToLower());
            }
            password = s.ToString();
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    String insertSql = String.Format(
                        @"INSERT INTO  [citypark].[dbo].[Users]
                            ([Name]
                            ,[Familyname]                            
                            ,[Usersname]
                            ,[Password]
                            ,[Date]
                            ,[Phone]
                            ,[cellular]
                            ,[Email]
                            ,[Users9Level]
                            ,[Confirmed]
                            ,[LastLogin]
                            ,[other1]
                            ,[other7]
                            ,[SiteID]
                            ,[count])
                        VALUES
                            ('{2}'
                            ,'{3}'
                            ,'{0}'
                            ,'{1}'                         
                            ,CURRENT_TIMESTAMP
                            ,'{4}'
                            ,'{4}'
                            ,'{0}'
                            ,8
                            ,1
                            ,CURRENT_TIMESTAMP
                            ,'{5}'
                            ,'{6}'
                            ,30
                            ,0)", email /*0*/, password, firstName, familyName, phoneNumber/*4*/, licensesPlate, paymentService);
                    cmd.Connection = con;
                    cmd.CommandText = insertSql;
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            return email;
        }


        [WebMethod(Description = "Get all users data")]
        public User getUserData(String sessionId)
        {
            if (!authenticateUser(sessionId))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                   "getUserData",
                                   USER_NOT_AUTHENTICATE,
                                   "401",
                                   "getUserData");
            }
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
            User user = new User();
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    String selectSql = String.Format(
                        @"SELECT [Name]
                            ,[Familyname]                            
                            ,[Usersname]
                            ,[Password]
                            ,[Date]
                            ,[Phone]
                            ,[cellular]
                            ,[Email]
                            ,[Users9Level]
                            ,[Confirmed]
                            ,[LastLogin]
                            ,[other1]
                            ,[other7]
                            ,[SiteID]
                        FROM USERS where Id ='{0}'", sessionMap[sessionId].sessionData.UserId);
                    cmd.Connection = con;
                    cmd.CommandText = selectSql;
                    con.Open();
                    using (SqlDataReader sqlDataReader = cmd.ExecuteReader())
                    {
                        if (sqlDataReader.HasRows)
                        {
                            while (sqlDataReader.Read())
                            {
                                user.Name = sqlDataReader["Name"].ToString();
                                user.Familyname = sqlDataReader["Familyname"].ToString();
                                user.Usersname = sqlDataReader["Usersname"].ToString();
                                user.Phone = sqlDataReader["Phone"].ToString();
                                user.Email = sqlDataReader["Email"].ToString();
                                user.LicensePlate = sqlDataReader["other1"].ToString();
                                user.PaymentProvider = sqlDataReader["other7"].ToString();

                            }
                        }
                    }
                }
            }

            return user;
        }



        [WebMethod(Description = "Gets the location data (City,Street,Parking zone..)")]
        public LocationData getParkingAreaZone(String sessionId, float latitude, float longitude,String paymentServiceName,String language)
        {
            if (!authenticateUser(sessionId))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                   "getLocationData",
                                   USER_NOT_AUTHENTICATE,
                                   "401",
                                   "getLocationData");
            }
            language = getLanguage(language);   
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;

            String city = null;
            String street = null;
            String houseNum = null;
            String parkingZone = null;

            LocationData ret = null;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    String loginSql = String.Format(
                        @"DECLARE
                            @NOW geography
                            --User Location Coordinates
                            SET @NOW = geography::Point({0}, {1},4326)
                            -- Real time user location after geocoded (address to coordinates)
                            SELECT top 1 *,
                            @NOW.STDistance(geography::Point(latitude,longitude,4326)) as Distance
                            FROM [citypark].[dbo].[Streets] where latitude is not null and longitude is not null order by Distance asc"
                        , latitude, longitude);
                    cmd.Connection = con;
                    cmd.CommandText = loginSql;
                    con.Open();
                    using (SqlDataReader sqlDataReader = cmd.ExecuteReader())
                    {
                        if (sqlDataReader.HasRows)
                        {
                            while (sqlDataReader.Read())
                            {
                                city = sqlDataReader["City"].ToString();
                                street = sqlDataReader["Street"].ToString();
                                houseNum = sqlDataReader["house_number"].ToString();
                                parkingZone = sqlDataReader["Parking_Zone"].ToString();
                                if ("NULL".Equals(parkingZone) || "".Equals(parkingZone)) parkingZone = "1";
                                ret = new LocationData(city, street, houseNum, parkingZone, sqlDataReader["latitude"].ToString(),
                                    sqlDataReader["longitude"].ToString());
                            }
                        }
                    }
                }
                PaymentServiceProvider psp = getPaymentServices(paymentServiceName,language);
                if (psp != null)
                {
                    ret.PaymentServiceStatus = psp.Status;
                }
                return ret;
            }

        }

        private void reportStreetParkingStatus(float latitude, float longitude, Boolean released, String segmentUnique)
        {
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;

            String city = "";
            String street = "";
            String houseNum = "";
            /**using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    String loginSql = String.Format(
                        @"DECLARE
                            @NOW geography
                            --User Location Coordinates
                            SET @NOW = geography::Point({0}, {1},4326)
                            -- Real time user location after geocoded (address to coordinates)
                            SELECT top 1 *,
                            @NOW.STDistance(geography::Point(latitude,longitude,4326)) as Distance
                            FROM [citypark].[dbo].[Streets] where latitude is not null and longitude is not null order by Distance asc"
                        , latitude, longitude);
                    cmd.Connection = con;
                    cmd.CommandText = loginSql;
                    con.Open();
                    SqlDataReader sqlDataReader = cmd.ExecuteReader();
                    if (sqlDataReader.HasRows)
                    {
                        while (sqlDataReader.Read())
                        {
                            city = sqlDataReader["City"].ToString();
                            street = sqlDataReader["Street"].ToString();
                            houseNum = sqlDataReader["house_number"].ToString();
                        }
                    }
                }
            }*/

            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    String insertSql = String.Format(
                        @"INSERT INTO [citypark].[dbo].[StreetParking]
                           ([Text]
                           ,[Category]
                           ,[City]
                           ,[Street]
                           ,[House_Number]
                           ,[latitude]
                           ,[longitude]
                           ,[Date]
                           ,[SegementUniqueId]
                           ,[Released])
                        VALUES
                           (''
                           ,''
                           ,'{0}'
                           ,'{1}'
                           ,'{2}'
                           ,{3}
                           ,{4}
                           ,CURRENT_TIMESTAMP
                           ,'{5}'
                           ,'{6}')", city, street, houseNum, latitude, longitude, segmentUnique, released);
                    cmd.Connection = con;
                    cmd.CommandText = insertSql;
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        [WebMethod(Description = "Reports that the client has parked, still has not paid")]
        public Boolean reportStreetParking(String sessionId, float latitude, float longitude)
        {
            if (!authenticateUser(sessionId))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                   "reportStreetParkingByLatitudeLongitude",
                                   USER_NOT_AUTHENTICATE,
                                   "401",
                                   "reportStreetParkingByLatitudeLongitude");
            }
            try
            {
                //SQL: SearchParkingSegment searchParkingSegment = getParkingSegment(latitude, longitude);
                reportStreetParkingStatus(latitude, longitude, false, "");
                //todo: Algo2 not calculate the segment on real time just once a day/week when we calculate the predication
                try
                {
                    int count = -1;//this was the old algorithm data calcSegmentParkingRate(searchParkingSegment);
                    String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
                    using (SqlConnection con = new SqlConnection(conStr))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {

                            DateTime now = DateTime.Now;
                            String insertSql = String.Format(@"INSERT INTO [CITYPARK].[dbo].[AlgoData]
                                        ([SegmentUnique]
                                        ,[Latitude]
                                        ,[Longitude]
                                        ,[Day]
                                        ,[Hour]
                                        ,[Count]
                                        ,[ReportDate]
                                        ,[Success]
                                        ,[SessionId])
                                    VALUES
                                        ('{0}'
                                        ,'{1}'
                                        ,'{2}'
                                        ,{3}
                                        ,{4}
                                        ,{5}
                                        ,CURRENT_TIMESTAMP
                                        ,'True'
                                        ,'{6}')", "", latitude, longitude, (int)now.DayOfWeek/*0 for Sunday*/, now.Hour, count, sessionId);

                            cmd.Connection = con;
                            cmd.CommandText = insertSql;
                            con.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
                catch (Exception ex)
                {
                    log.Error("reportStreetParkingByLat..Long.. add to algoData table failed, " + ex.Message);
                }
                //Algo:
                //removed due to new algorithm :calcSWT(searchParkingSegment, calcSegmentParkingRate(searchParkingSegment), RADIUS);
                userStartParkingEvent(sessionId);
            }
            catch (Exception ex)
            {
                log.Error("SessionId :" + sessionId + " ,reportStreetParking Error:" + ex.Message);
                return false;
            }
            return true;
        }

        [WebMethod(Description = "Reports the clients location,Also uses as a session keep alive")]
        public Boolean reportLocation(String sessionId, float latitude, float longitude)
        {
            if (!authenticateUser(sessionId))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                   "reportSearchLocation",
                                   USER_NOT_AUTHENTICATE,
                                   "401",
                                   "reportSearchLocation");
            }
            SessionData sd = sessionMap[sessionId].sessionData;
            try
            {
                String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
                using (SqlConnection con = new SqlConnection(conStr))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        String insertSql = String.Format(
                         @"INSERT INTO [CITYPARK].[dbo].[ReportLocation]
                           ([userId]
                           ,[actiondate]
                           ,[latitude]
                           ,[longitude]
                           ,[sessionId])
                        VALUES
                           ({0}
                           ,CURRENT_TIMESTAMP
                           ,{1}
                           ,{2}
                           ,'{3}')", sd.UserId, latitude, longitude, sessionId);
                        cmd.Connection = con;
                        cmd.CommandText = insertSql;
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

            }
            catch (Exception ex)
            {
                log.Error("SessionId :" + sessionId + " ,reportLocation SQL Error:" + ex.Message);
            }

            try
            {
                //Algo2:                
                //SearchParkingSegment sps = getParkingSegment(latitude, longitude);
                //1)Add to the session map the current location and the last location and current segment,keep the current and last timestamp
                sd.setCurrentLocationAndUpdateTime(latitude, longitude);
                //2) update lastVisit time for current
                //SQL: sps.LastVisit = DateTime.Now;
                //3)if user changed segment 
                if (true/*SQL: sd.updateCurrentSegment(sps.SegmentUnique)*/)
                {
                    //3.a)calc the segmentParking rate calcSegmentParkingRate()
                    //SQL:SearchParkingSegment previousSegment = segmentSessionMap.getSearchParkingSegment(sd.PreviousSegment);
                    int previousSegmentRate = -1;//this was the old algorithm data calcSegmentParkingRate(previousSegment);
                    //old algorithm
                    //3.b)calculate SWT calcSWT(segment,rate) for the former segment
                    //calcSWT(previousSegment, previousSegmentRate,RADIUS);

                    try
                    {
                        String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
                        using (SqlConnection con = new SqlConnection(conStr))
                        {
                            using (SqlCommand cmd = new SqlCommand())
                            {

                                DateTime now = DateTime.Now;
                                String insertSql = String.Format(@"INSERT INTO [CITYPARK].[dbo].[AlgoData]
                                        ([SegmentUnique]
                                        ,[Latitude]
                                        ,[Longitude]
                                        ,[Day]
                                        ,[Hour]
                                        ,[Count]
                                        ,[ReportDate]
                                        ,[Success]
                                        ,[SessionId])
                                    VALUES
                                        ('{0}'
                                        ,'{1}'
                                        ,'{2}'
                                        ,{3}
                                        ,{4}
                                        ,{5}
                                        ,CURRENT_TIMESTAMP
                                        ,'False'
                                        ,'{6}')", "", sd.LastLatitude, sd.LastLongitude, (int)now.DayOfWeek/*0 for Sunday*/, now.Hour, previousSegmentRate, sessionId);

                                cmd.Connection = con;
                                cmd.CommandText = insertSql;
                                con.Open();
                                cmd.ExecuteNonQuery();
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        log.Error("reportLocation..Long.. add to algoData table failed, " + ex.Message);
                    }
                }
            }
            catch (Exception ex)
            {
                log.Error("SessionId :" + sessionId + " ,reportLocation Error:" + ex.Message);
                return false;
            }
            return true;
        }

        [WebMethod(Description = "Reports that the client has started to pay for the parking, Note:operationStatus values:ACKNOWLEDGED,FAILED,UNVERIFIED")]
        public Boolean reportStartPayment(String sessionId, String paymentProviderName, float latitude, float longitude, String operationStatus)
        {
            if (!authenticateUser(sessionId))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                   "reportStartPayment",
                                   USER_NOT_AUTHENTICATE,
                                   "401",
                                   "reportStartPayment");
            }
            SessionData sd = sessionMap[sessionId].sessionData;
            //SQL:
            /*try
            {
                SearchParkingSegment sps = getParkingSegment(latitude, longitude);
                String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;

                using (SqlConnection con = new SqlConnection(conStr))
                {
                    using (SqlCommand updateCmd = new SqlCommand())
                    {

                        String updateSql = String.Format(
                            @"UPDATE [citypark].[dbo].[Segment] SET Parking = 'PAID' WHERE SegmentUnique = '{0}'",
                            sps.SegmentUnique);
                        updateCmd.Connection = con;
                        updateCmd.CommandText = updateSql;
                        con.Open();
                        updateCmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                log.Error(ex.Message);
            }*/
            return reportPayment(sessionMap[sessionId].sessionData.UserId, paymentProviderName, latitude, longitude, operationStatus, START_PAYMENT, DateTime.Now);

        }

        [WebMethod(Description = "Reports that the client has stopped paying for the parking, Note:operationStatus values:ACKNOWLEDGED,FAILED,UNVERIFIED")]
        public Boolean reportStopPayment(String sessionId, String paymentProviderName, float latitude, float longitude, String operationStatus)
        {
            if (!authenticateUser(sessionId))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                   "reportStopPayment",
                                   USER_NOT_AUTHENTICATE,
                                   "401",
                                   "reportStopPayment");
            }
            SessionData data = sessionMap[sessionId].sessionData;
            return reportPayment(data.UserId, paymentProviderName, latitude, longitude, operationStatus, STOP_PAYMENT, DateTime.Now);

        }

        private Boolean reportPayment(int userId, String paymentProvider, float latitude, float longitude, String status, String operation, DateTime currentTime)
        {
            String statusStr = status.Trim().ToUpper();
            if (!statusStr.Equals(ACKNOWLEDGED) &&
                !statusStr.Equals(FAILED) &&
                !statusStr.Equals(UNVERIFIED))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                  "reportPayment",
                                  "The operationStatus value is wrong, the value can be only: ACKNOWLEDGED, FAILED, UNVERIFIED",
                                  "400",
                                  "reportPayment");
            }

            try
            {
                String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;

                using (SqlConnection con = new SqlConnection(conStr))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        String insertSql = String.Format(
                            @"INSERT INTO [citypark].[dbo].[PaymentAudit]
                            ([userId]
                            ,[paymentservice]
                            ,[actiondate]
                            ,[latitude]
                            ,[longitude]
                            ,[action]
                            ,[status])
                        VALUES
                           ({0}
                           ,'{1}'
                           ,CURRENT_TIMESTAMP
                           ,{3}
                           ,{4}
                           ,'{5}'
                           ,'{6}')", userId, paymentProvider, currentTime, latitude, longitude, operation, status);
                        cmd.Connection = con;
                        cmd.CommandText = insertSql;
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                log.Error("UserId :" + userId + " ,reportPayment Error:" + ex.Message);
                return false;
            }
            return true;
        }

        [WebMethod(Description = "Get all payment services")]
        public List<PaymentServiceProvider> getAllPaymentServices(String language)
        {
            language = getLanguage(language);   
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {

                    String sql = String.Format(
                        @"SELECT * FROM [citypark].[dbo].[PaymentService]");
                    cmd.Connection = con;
                    cmd.CommandText = sql;
                    con.Open();

                    List<PaymentServiceProvider> pspList = new List<PaymentServiceProvider>();
                    using (SqlDataReader sqlDataReader = cmd.ExecuteReader())
                    {
                        if (sqlDataReader.HasRows)
                        {
                            while (sqlDataReader.Read())
                            {
                                PaymentServiceProvider psp = new PaymentServiceProvider();
                                psp.ServiceName = sqlDataReader["service_name"].ToString();
                                psp.Phone = sqlDataReader["phone"].ToString();
                                psp.Website = sqlDataReader["website"].ToString();
                                psp.Description = sqlDataReader["description"].ToString();
                                psp.Paymethod = sqlDataReader["paymethod"].ToString();
                                psp.TemplateStart = sqlDataReader["templateStart"].ToString();
                                psp.TemplateEnd = sqlDataReader["templateEnd"].ToString();
                                psp.Status = sqlDataReader["status"].ToString();
                                pspList.Add(psp);
                            }
                        }
                        else
                        {
                            return null;
                        }
                    }
                    return pspList;
                }
            }
        }

        private PaymentServiceProvider getPaymentServices(String name,String language)
        {
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {

                    String sql = String.Format(
                        @"SELECT * FROM [citypark].[dbo].[PaymentService] where service_name = '{0}'",name);
                    cmd.Connection = con;
                    cmd.CommandText = sql;
                    con.Open();

                    
                    using (SqlDataReader sqlDataReader = cmd.ExecuteReader())
                    {
                        if (sqlDataReader.HasRows)
                        {
                            while (sqlDataReader.Read())
                            {
                                PaymentServiceProvider psp = new PaymentServiceProvider();
                                psp.ServiceName = sqlDataReader["service_name"].ToString();
                                psp.Phone = sqlDataReader["phone"].ToString();
                                psp.Website = sqlDataReader["website"].ToString();
                                psp.Description = sqlDataReader["description"].ToString();
                                psp.Paymethod = sqlDataReader["paymethod"].ToString();
                                psp.TemplateStart = sqlDataReader["templateStart"].ToString();
                                psp.TemplateEnd = sqlDataReader["templateEnd"].ToString();
                                psp.Status = sqlDataReader["status"].ToString();
                                return psp;
                            }
                        }
                        else
                        {
                            return null;
                        }
                    }
                    return null;
                }
            }
        }


        [WebMethod(Description = "Return all garages and off street parking at from current location in radius of the given distance")]
        public List<ParkingPoint> findGarageParkingByLatitudeLongitude(String sessionId, float latitude, float longitude, int distance,String language)
        {//and parkingtype='חניון בחינם' or parkingtype='חניון בתשלום'   
            if (!authenticateUser(sessionId))//sessionId.Equals(Session["userId"]))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                    "findParkingByLatitudeLongitude",
                                    USER_NOT_AUTHENTICATE,
                                    "401",
                                    "findParkingByLatitudeLongitude");
            }
            language = getLanguage(language);   
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    //see findAllGarageParkingDataByLatitudeLongitude commented sql for the old sql logic
                    String searchSql = String.Format(
                     @"DECLARE  @USER geography = geography::Point({0}, {1},4326) 
                        DECLARE @Date DATETIME
                        SET @Date = GETDATE()	
                            SELECT top 200.*,
                            CASE WHEN DATEPART(dw, @Date) BETWEEN 1 and 5 and DATENAME(hour, @Date)< Weekday_OneTimeHour 
		                    THEN (select WeekDay_FirstHourPrice)
                            WHEN DATEPART(dw, @Date) BETWEEN 1 and 5 and DATENAME(hour, @Date)>=Weekday_OneTimeHour and Weekday_OneTimeHour>1
			                    THEN (select Weekday_OneTimePrice)
                            WHEN DATEPART(dw, @Date)=6 and DATENAME(hour, @Date)<Friday_OneTimeHour
		                        THEN (select Friday_FirstHourPrice)
                            WHEN DATEPART(dw, @Date)=6 and DATENAME(hour, @Date)>=Friday_OneTimeHour and Friday_OneTimeHour>1
			                    THEN (select Friday_OneTimePrice)
                            WHEN DATEPART(dw, @Date)=7 and DATENAME(hour, @Date)<Saturday_FirstHourPrice
			                    THEN (select Saturday_FirstHourPrice)
                            WHEN DATEPART(dw, @Date)=7 and DATENAME(hour, @Date)>=Saturday_OneTimeHour and Saturday_OneTimeHour >1
			                    THEN (select Saturday_OneTimePrice)
                           END AS FirstHourPrice,
       
                           CASE WHEN DATEPART(dw, @Date) BETWEEN 1 and 5 and DATENAME(hour, @Date)< Weekday_OneTimeHour
		                    THEN (select WeekDay_extraQuarterPrice)
                            WHEN DATEPART(dw, @Date) BETWEEN 1 and 5 and DATENAME(hour, @Date)>=Weekday_OneTimeHour and Weekday_OneTimeHour>1
			                    THEN 0
                            WHEN DATEPART(dw, @Date)=6 and DATENAME(hour, @Date)<Friday_OneTimeHour
		                        THEN (select Friday_extraQuarterPrice)
                            WHEN DATEPART(dw, @Date)=6 and DATENAME(hour, @Date)>=Friday_OneTimeHour and Friday_OneTimeHour>1
			                    THEN 0
                            WHEN DATEPART(dw, @Date)=7 and DATENAME(hour, @Date)<Saturday_FirstHourPrice
			                    THEN (select Saturday_extraQuarterPrice)
                            WHEN DATEPART(dw, @Date)=7 and DATENAME(hour, @Date)>=Saturday_OneTimeHour and Saturday_OneTimeHour >1
			                    THEN 0
                            END AS extraQuarterPrice,
       
                             @USER.STDistance(geography::Point(latitude,longitude,4326)) as Distance,
                             allDayPrice
        
                           FROM [CITYPARK].[dbo].[Parking]
			                    WHERE Heniontype='חניון'
                                and @USER.STDistance(geography::Point(latitude,longitude,4326))<{2}
                                order by Distance,vip asc", latitude, longitude, distance);
                    cmd.Connection = con;
                    cmd.CommandText = searchSql;
                    con.Open();
                    Boolean demo =  isDemoUser(sessionId);
                    List<ParkingPoint> parkingList = new List<ParkingPoint>();
                    using (SqlDataReader sqlDataReader = cmd.ExecuteReader())
                    {
                        if (sqlDataReader.HasRows)
                        {
                            Random random = new Random();
                            while (sqlDataReader.Read())
                            {
                                String parkingID = sqlDataReader["parkingID"].ToString();
                                String qHouseNumber = sqlDataReader["house_number"].ToString();
                                if ("NULL".Equals(qHouseNumber) || "".Equals(qHouseNumber.Trim())) qHouseNumber = "0";
                                int parkingIdInt = Convert.ToInt32(parkingID);
                                int houseNumInt = Convert.ToInt32(qHouseNumber);
                                ParkingPoint parking = new ParkingPoint(parkingIdInt,
                                    sqlDataReader["name"].ToString(),                                   
                                    sqlDataReader["latitude"].ToString(),
                                    sqlDataReader["longitude"].ToString());
                                parking.availability = sqlDataReader["current_Pnuyot"].ToString();
                                parking.owner = sqlDataReader["parkId"].ToString();
                                parking.firstHourPrice = sqlDataReader["firstHourPrice"].ToString();
                                if ("NULL".Equals(parking.firstHourPrice) || "".Equals(parking.firstHourPrice.Trim())) parking.firstHourPrice = sqlDataReader["allDayPrice"].ToString();
                                if ("ahuzot".Equals(parking.owner))
                                {
                                    try
                                    {
                                        String externalIdStr = sqlDataReader["externalid"].ToString();
                                        if ("NULL".Equals(externalIdStr) || "".Equals(externalIdStr.Trim())) externalIdStr = "-1";
                                        int externalId = Convert.ToInt32(externalIdStr);
                                        new Thread(() => AhuzotHoffApi.updateServiceProviderLog("findGarageParkingByLatitudeLongitude", sessionId, externalId)).Start();
                                    }
                                    catch (Exception e) 
                                    {
                                        log.Error(e.Message);
                                    }
                                }
                                 if (demo)
                                {
                                    parking.availability = random.Next(-1, 10) + "";
                                    if (parking.firstHourPrice == "" || parking.firstHourPrice == "NULL" || parking.firstHourPrice == "0")
                                    {
                                        parking.firstHourPrice = "25";
                                    }
                                }
                                parkingList.Add(parking);
                            }
                        }
                        else
                        {
                            return null;
                        }
                    }
                    return parkingList;
                }
            }
        }

        [WebMethod(Description = "Return on street parking prediction in street segments")]
        public List<StreetSegment> getStreetParkingPrediction(String sessionId, float latitude, float longitude, int distance)
        {
            if (!authenticateUser(sessionId))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                    "getStreetParkingPrediction",
                                    USER_NOT_AUTHENTICATE,
                                    "401",
                                    "getStreetParkingPrediction");
            }

            float distanceKm = ((float)distance) / 1000f;
            Boolean demo = isDemoUser(sessionId);
            List<StreetSegment> segList = new List<StreetSegment>();

            //Algo2: 
            if (!PredictionAlgorithmEnabled && !demo)//if not demo user and the prediction algo should not work 
            {
                return segList;
            }
            //get all segments and distance from current session and store on sessionData for cache usage
            Dictionary<String, DistancePredictionWrapper> segmentDistance = getAllSegmentsInRange(latitude, longitude, distanceKm);
            //Add user to SegementWaitingUsersList (only if not exist in waiting list)
            assignSessionToSegments(segmentDistance, sessionMap[sessionId]);


            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {//todo:This SQL should be as getAllSegmentsInRange(..) logic or use the existing return value from getAllSegmentsInRange(..)
                    String sql = String.Format(@"DECLARE @UserLat float = {0}
                            DECLARE @UserLong float = {1}
                            SELECT * FROM [CITYPARK].[dbo].[StreetSegmentLine] a
                            where SQRT  ( POWER((a.StartLatitude - @UserLat) * COS(@UserLat/180) * 40000 / 360, 2) 
                            + POWER((a.StartLongitude -@UserLong) * 40000 / 360, 2)) < {2}  
                            AND 
                                  SQRT  ( POWER((a.endLatitude - @UserLat) * COS(@UserLat/180) * 40000 / 360, 2) 
                            + POWER((a.endLongitude -@UserLong) * 40000 / 360, 2)) < {2} order by SegmentUnique", latitude, longitude, distanceKm);
                    cmd.Connection = con;
                    cmd.CommandTimeout = 1200;
                    cmd.CommandText = sql;
                    con.Open();
                    using (SqlDataReader sqlDataReader = cmd.ExecuteReader())
                    {
                        if (sqlDataReader.HasRows)
                        {
                            Random random = new Random();
                            while (sqlDataReader.Read())
                            {
                                StreetSegmentLine ssl = new StreetSegmentLine();
                                ssl.StartLatitude = sqlDataReader["StartLatitude"].ToString();
                                ssl.StartLongitude = sqlDataReader["StartLongitude"].ToString();
                                ssl.EndLatitude = sqlDataReader["EndLatitude"].ToString();
                                ssl.EndLongitude = sqlDataReader["EndLongitude"].ToString();
                                ssl.SegmentUnique = sqlDataReader["SegmentUnique"].ToString();
                                StreetSegment sSeg = null;
                                foreach (StreetSegment ss in segList)
                                {
                                    if (ss.SegmentUnique.Equals(ssl.SegmentUnique))
                                    {
                                        sSeg = ss;
                                        break;
                                    }
                                }
                                if (sSeg != null)
                                {
                                    sSeg.add(ssl);
                                }
                                else
                                {
                                    float probability = segmentDistance[ssl.SegmentUnique].calcProbability();
                                    if (probability >= 0 || demo)
                                    {
                                        if (demo)
                                        {
                                            probability = random.Next(0, 100);
                                        }
                                        sSeg = new StreetSegment(ssl.SegmentUnique, probability);
                                        sSeg.add(ssl);
                                        segList.Add(sSeg);
                                    }
                                }

                            }
                        }
                    }
                }
            }
            return segList;
        }


        [WebMethod(Description = "Add released parking spots")]
        public Boolean reportStreetParkingRelease(String sessionId, float latitude, float longitude)
        {
            if (!authenticateUser(sessionId))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                    "addParkingReleases",
                                    USER_NOT_AUTHENTICATE,
                                    "401",
                                    "addParkingReleases");
            }
            try
            {
                reportStreetParkingStatus(latitude, longitude, true, "");
            }
            catch (Exception ex)
            {
                log.Error("SessionId :" + sessionId + " ,reportStreetParkingRelease Error:" + ex.Message);
                return false;
            }
            return true;
        }


        [WebMethod(Description = "List of lately (2 min) released parking spots")]
        public List<Parking> getParkingReleases(String sessionId, float latitude, float longitude, int distance,String language)
        {
            if (!authenticateUser(sessionId))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                    "getParkingReleases",
                                    USER_NOT_AUTHENTICATE,
                                    "401",
                                    "getParkingReleases");
            }
            language = getLanguage(language);   
            List<Parking> parkingList = new List<Parking>();
            Boolean demo = isDemoUser(sessionId);
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;

            if (demo)
            {
                using (SqlConnection con = new SqlConnection(conStr))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        String sql = String.Format(@"DECLARE @UserLat float = {0}
                            DECLARE @UserLong float = {1}
                            SELECT * FROM [CITYPARK].[dbo].[StreetSegmentLine] a
                            where SQRT  ( POWER((a.StartLatitude - @UserLat) * COS(@UserLat/180) * 40000 / 360, 2) 
                            + POWER((a.StartLongitude -@UserLong) * 40000 / 360, 2)) < {2}", latitude, longitude, (float)distance / 1000f);
                        cmd.Connection = con;
                        cmd.CommandText = sql;
                        con.Open();
                        using (SqlDataReader sqlDataReader = cmd.ExecuteReader())
                        {
                            if (sqlDataReader.HasRows)
                            {
                                Random random = new Random();
                                int i = 1;
                                while (sqlDataReader.Read())
                                {
                                    if (i % 2 == 0)
                                    {
                                        Parking p = new Parking();
                                        p.Latitude = sqlDataReader["StartLatitude"].ToString();
                                        p.Longitude = sqlDataReader["StartLongitude"].ToString();
                                        parkingList.Add(p);
                                    }
                                    i++;
                                }
                            }
                        }
                    }
                }
                /*  Random random = new Random();
                  for (int i = 0; i < 30; i++)
                  {
                      float lat = random.Next(-90, 90);//0.00x
                      if (lat == 0) lat = 1;
                      lat = lat / 10000f;
                      lat = lat + latitude;
                      float lng = random.Next(-90, 90);//0.00x
                      if (lng == 0) lng = 1;
                      lng = lng / 10000f;
                      lng = lng + longitude;
                      Parking p = new Parking();
                      p.Latitude = lat + "";
                      p.Longitude = lng + "";
                      parkingList.Add(p);
                  }                */
                return parkingList;
            }

            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    String loginSql = String.Format(
                        @"DECLARE @NOW geography
                               --User Location Coordinates
                               SET @NOW = geography::Point({0}, {1},4326)
                               -- Real time user location after geocoded (address to coordinates)
                               SELECT top 200 *,
                               @NOW.STDistance(geography::Point(latitude,longitude,4326)) as Distance
                               FROM [citypark].[dbo].[StreetParking]
                               WHERE @NOW.STDistance(geography::Point(latitude,longitude,4326))<={2}                            
                               and datediff(mi,Date,CURRENT_TIMESTAMP)< 2 and Released = 1 order by Distance asc", latitude, longitude, distance/*in meter*/);
                    cmd.Connection = con;
                    cmd.CommandText = loginSql;
                    con.Open();
                    using (SqlDataReader sqlDataReader = cmd.ExecuteReader())
                    {
                        if (sqlDataReader.HasRows)
                        {
                            while (sqlDataReader.Read())
                            {
                                Parking parking = new Parking();
                                parking.Latitude = sqlDataReader["latitude"].ToString();
                                parking.Longitude = sqlDataReader["longitude"].ToString();
                                /*parking.City = sqlDataReader["City"].ToString();
                                parking.StreetName = sqlDataReader["Street"].ToString();
                                String houseNum = sqlDataReader["House_Number"].ToString();                            
                                if (!houseNum.Trim().Equals(""))
                                    parking.HouseNumber = Convert.ToInt32(houseNum);*/
                                parkingList.Add(parking);
                            }
                        }
                    }
                    return parkingList;
                }
            }
        }




        private Boolean authenticateUser(String sessionId)
        {
            try
            {
                if (sessionMap[sessionId.Trim()] != null)
                {
                    SessionDataWrapper sdw = sessionMap[sessionId.Trim()];
                    sdw.sessionData.LastUpdate = DateTime.Now;
                    sessionMap[sessionId.Trim()] = sdw;
                    return true;
                }
            }
            catch (Exception ex)
            {
                log.Error("Session Id :" + sessionId + " is not authenticated");
                return false;
            }
            log.Error("SessionId :" + sessionId + " is not authenticated");
            return false;
        }




        /*   [WebMethod]
           public List<Parking> findStreetParkingByLatitudeLongitude(float latitude, float longitude, int distance)
           {//and parkingtype='חניון בחינם' or parkingtype='חניון בתשלום'           
               String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
               using (SqlConnection con = new SqlConnection(conStr))
               {
                   using (SqlCommand cmd = new SqlCommand())
                   {
                       String loginSql = String.Format(
                           @"DECLARE @NOW geography
                               --User Location Coordinates
                               SET @NOW = geography::Point({0}, {1},4326)
                               -- Real time user location after geocoded (address to coordinates)
                               SELECT top 10 *,
                               @NOW.STDistance(geography::Point(latitude,longitude,4326)) as Distance
                               FROM [citypark].[dbo].[StreetParking]
                               WHERE @NOW.STDistance(geography::Point(latitude,longitude,4326))<={2}                            
                               and datediff(mi,Date,CURRENT_TIMESTAMP)< 3 order by Distance asc", latitude, longitude, distance);
                       cmd.Connection = con;
                       cmd.CommandText = loginSql;
                       con.Open();
                       SqlDataReader sqlDataReader = cmd.ExecuteReader();
                       List<Parking> parkingList = new List<Parking>();
                       if (sqlDataReader.HasRows)
                       {
                           while (sqlDataReader.Read())
                           {
                               Parking parking = new Parking();
                               parking.Latitude = sqlDataReader["latitude"].ToString();
                               parking.Longitude = sqlDataReader["longitude"].ToString();
                               parking.City = sqlDataReader["City"].ToString();
                               parking.StreetName = sqlDataReader["Street"].ToString();
                               parking.HouseNumber = Convert.ToInt32(sqlDataReader["House_Number"].ToString());
                               parkingList.Add(parking);
                           }
                       }
                       else
                       {
                           return null;
                       }
                       return parkingList;
                   }
               }
           }
            
            
        [WebMethod]
        public void reportTweetByLatitudeLongitude(float latitude, float longitude,int category)
        {        
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;

            String city = null;
            String street = null;
            String houseNum = null;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    String loginSql = String.Format(
                        @"DECLARE
                            @NOW geography
                            --User Location Coordinates
                            SET @NOW = geography::Point({0}, {1},4326)
                            -- Real time user location after geocoded (address to coordinates)
                            SELECT top 1 *,
                            @NOW.STDistance(geography::Point(latitude,longitude,4326)) as Distance
                            FROM [citypark].[dbo].[Streets] where latitude is not null and longitude is not null order by Distance asc"
                        , latitude, longitude);
                    cmd.Connection = con;
                    cmd.CommandText = loginSql;
                    con.Open();
                    SqlDataReader sqlDataReader = cmd.ExecuteReader();
                    if (sqlDataReader.HasRows)
                    {
                        while (sqlDataReader.Read())
                        {
                            city = sqlDataReader["City"].ToString();
                            street = sqlDataReader["Street"].ToString();
                            houseNum = sqlDataReader["house_number"].ToString();
                        }
                    }
                }
            }


            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    String insertSql = String.Format(
                        @"INSERT INTO  [citypark].[dbo].[Parkingtweets]
                           ([Text]
                           ,[Category]
                           ,[City]
                           ,[Street]
                           ,[House_Number]
                           ,[Date]
                           ,[SiteID])
                        VALUES
                           (''                         
                           ,'{0}'
                           ,'{1}'
                           ,'{2}'
                           ,'{3}'                         
                           ,CURRENT_TIMESTAMP
                           ,30)", TweetReport.getCategoryAsString(category),
                                               city,
                                               street,
                                               houseNum);
                    cmd.Connection = con;
                    cmd.CommandText = insertSql;
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        [WebMethod]
        public List<TweetReport> getAllTweets()
        {
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {

                    String sql = String.Format(
                        @"SELECT TOP 20 [Text]
                          ,[Category]
                          ,[City]
                          ,[Street]
                          ,[House_Number]
                          ,[Date]     
                      FROM [citypark].[dbo].[Parkingtweets] order by Date desc");
                    cmd.Connection = con;
                    cmd.CommandText = sql;
                    con.Open();
                    SqlDataReader sqlDataReader = cmd.ExecuteReader();
                    List<TweetReport> tweetList = new List<TweetReport>();
                    if (sqlDataReader.HasRows)
                    {
                        while (sqlDataReader.Read())
                        {
                            TweetReport tw = new TweetReport();
                            tw.City = sqlDataReader["City"].ToString();
                            tw.HouseNumber = sqlDataReader["house_number"].ToString();
                            tw.Street = sqlDataReader["street"].ToString();
                            tw.Text = sqlDataReader["text"].ToString();
                            tw.Category = TweetReport.getCategoryAsInt(sqlDataReader["Category"].ToString());
                            tweetList.Add(tw);
                        }
                    }
                    else
                    {
                        return null;
                    }
                    return tweetList;
                }
            }
        }
         
          [WebMethod]
        public List<Parking> findParkingByAddress(String city, String street, int houseNumber,int distance)
        {//and parkingtype='חניון בחינם' or parkingtype='חניון בתשלום'
            int delta = 10;
            int lHouseNumber = houseNumber - delta;
            if (houseNumber < delta)
                lHouseNumber = 0;
            int hHouseNumber = houseNumber + delta;
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    String loginSql = String.Format(
                        @"DECLARE @latitude float, @longitude float, @NOW geography
                            SELECT @latitude = latitude , @longitude = longitude
                            FROM Streets
                            WHERE city like '%{0}%' and street like '%{1}%' and house_number between {2} and {3} 
                            and longitude is not null and latitude is not null
                            SET @NOW = geography::Point(@latitude, @longitude,4326)
                            SELECT TOP 10 *,
                            @NOW.STDistance(geography::Point(Latitude,Longitude,4326)) as Distance
                            FROM Parking 
                            WHERE @NOW.STDistance(geography::Point(latitude,longitude,4326))<={4}                            
                            and Current_Pnuyot>0 order by Distance asc", city, street, lHouseNumber, hHouseNumber, distance);
                    cmd.Connection = con;
                    cmd.CommandText = loginSql;
                    con.Open();
                    SqlDataReader sqlDataReader = cmd.ExecuteReader();
                    List<Parking> parkingList = new List<Parking>();
                    if (sqlDataReader.HasRows)
                    {
                        while (sqlDataReader.Read())
                        {
                            String parkingID = sqlDataReader["parkingID"].ToString();
                            String qName = sqlDataReader["name"].ToString();
                            String qHouseNumber = sqlDataReader["house_number"].ToString();
                            String qStreet = sqlDataReader["street_name"].ToString();
                            String latitude = sqlDataReader["latitude"].ToString();
                            String longitude = sqlDataReader["longitude"].ToString();
                            if ("NULL".Equals(qHouseNumber)) qHouseNumber = "0";
                            Parking parking = new Parking(Convert.ToInt32(parkingID), qName, city, qStreet, Convert.ToInt32(qHouseNumber), latitude, longitude);
                            parking.Comment = sqlDataReader["comment"].ToString();
                            parking.Coupon_text = sqlDataReader["coupon_text"].ToString();
                            parking.Current_Pnuyot = sqlDataReader["current_Pnuyot"].ToString();
                            parking.Image = sqlDataReader["image"].ToString();
                            parking.Image2 = sqlDataReader["image2"].ToString();                           
                            parking.Withlock = sqlDataReader["Withlock"].ToString();
                            parking.Underground = sqlDataReader["Underground"].ToString();
                            parking.Nolimit = sqlDataReader["Nolimit"].ToString();
                            parking.Roof = sqlDataReader["Roof"].ToString();
                            parkingList.Add(parking);
                        }
                    }
                    else
                    {
                        return null;
                    }
                    return parkingList;
                }
            }
        }
        


           */


        /// <summary>
        /// This is the logic when user has parked.
        /// </summary>
        /// <returns></returns>
        protected void userStartParkingEvent(String sessionId)
        {
            //Algo2:
            //1)remove user from  segment waiting list
            try
            {
                SessionDataWrapper sdw = sessionMap[sessionId];
                segmentSessionMap.removeSessionDataFromAll(sdw.sessionData.SessionId, new List<String>(sdw.SegmentDistanceAndPredictionMap.Keys));
            }
            catch (Exception ex)
            {
                log.Error("SessionId :" + sessionId + " ,userStartParkingEvent Error:" + ex.Message);
            }
        }

        private SearchParkingSegment getParkingSegment(float lat, float lon)
        {
            //Algo:
            //Select from segment
            //todo:fix the SQL logic
            SearchParkingSegment sps = null;
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    String sql = String.Format(@"DECLARE @UserLat float = {0}
                            DECLARE @UserLong float = {1}
                            SELECT TOP 1 SQRT  ( POWER((a.StartLatitude - @UserLat) * COS(@UserLat/180) * 40000 / 360, 2) 
                                + POWER((a.StartLongitude -@UserLong) * 40000 / 360, 2)) as distance,*
                            FROM [CITYPARK].[dbo].[StreetSegmentLine] a   
                                order by distance", lat, lon);
                    cmd.Connection = con;
                    cmd.CommandText = sql;
                    con.Open();
                    using (SqlDataReader sqlDataReader = cmd.ExecuteReader())
                    {
                        if (sqlDataReader.HasRows)
                        {
                            while (sqlDataReader.Read())
                            {
                                StreetSegmentLine ssl = new StreetSegmentLine();
                                ssl.StartLatitude = sqlDataReader["StartLatitude"].ToString();
                                ssl.StartLongitude = sqlDataReader["StartLongitude"].ToString();
                                ssl.EndLatitude = sqlDataReader["EndLatitude"].ToString();
                                ssl.EndLongitude = sqlDataReader["EndLongitude"].ToString();
                                ssl.SegmentUnique = sqlDataReader["SegmentUnique"].ToString();
                                sps = new SearchParkingSegment(-1, ssl.SegmentUnique);
                                break;
                            }
                        }
                    }
                }
            }
            return segmentSessionMap.getSearchParkingSegment(sps);
        }

        private int getSegmentUsersCount(SearchParkingSegment searchParkingSegment)
        {
            return segmentSessionMap.countSegmentUsers(searchParkingSegment);
        }

        /**
         *Recalculate SegmentParkingRate (++)
         * */
        private int calcSegmentParkingRate(SearchParkingSegment sps)
        {
            //Algo:            
            //count and return how many start parking in last DELTA T
            int previousSegmentRate = 0;
            int delta = -1;//last houre
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {

                    String sql = String.Format(
                        @"SELECT COUNT(*)
                            FROM CITYPARK.[dbo].[StreetParking] where Date > dateadd(hh, {0}, getdate()) and SegementUniqueId='{1}'", delta, sps.SegmentUnique);
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = sql;
                    con.Open();
                    previousSegmentRate = (Int32)cmd.ExecuteScalar();
                }
            }
            return previousSegmentRate;
        }

        private void cleanSWT()
        {
            //Algo:
            //for each segment in waitingList
            // if( waitingList[segment].lastUpdate<timeConstant)
            //     waitingList.remove(segment); //or set SWT to -1 
            segmentSessionMap.cleanTimeOutSegments();
        }

        /**
         * Returns all segments in range sorted by distance and also the prediction value acording to the current hour and day
         */
        private Dictionary<String, DistancePredictionWrapper> getAllSegmentsInRange(float lat, float lon, float distanceKm)
        {
            //todo: make it better SQL
            Dictionary<String, DistancePredictionWrapper> segmentInRange = new Dictionary<String, DistancePredictionWrapper>();
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;

            String dayOfTheWeekColumn = (int)DateTime.Now.DayOfWeek <= 4 ? "wd_h" + DateTime.Now.Hour : "we_h" + DateTime.Now.Hour;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {

                    /*        String sqlJoin = String.Format(
                                @"DECLARE @UserLat float = {0}
                                    DECLARE @UserLong float = {1}
                                    SELECT distinct seg.SegmentUnique ,
                                            SQRT  ( POWER((a.StartLatitude - @UserLat) * COS(@UserLat/180) * 40000 / 360, 2) 
                                                + POWER((a.StartLongitude -@UserLong) * 40000 / 360, 2)) as distance,
                                            seg.* 
                                    FROM [CITYPARK].[dbo].[StreetSegmentLine] a
                                        INNER JOIN [CITYPARK].[dbo].[Segment] as seg
                                        ON a.SegmentUnique=seg.SegmentUnique
                                    WHERE 
                                            SQRT  ( POWER((a.StartLatitude - @UserLat) * COS(@UserLat/180) * 40000 / 360, 2)                             
                                              + POWER((a.StartLongitude -@UserLong) * 40000 / 360, 2)) < {2}", lat, lon, distanceKm);
             =================================================
             
                     SELECT distinct top 100 seg.SegmentUnique ,
        min( SQRT  ( POWER((a.StartLatitude - @UserLat) * COS(@UserLat/180) * 40000 / 360, 2)  + POWER((a.StartLongitude -@UserLong) * 40000 / 360, 2)) )as distance
        FROM [CITYPARK].[dbo].[StreetSegmentLine] a
        INNER JOIN [CITYPARK].[dbo].[Segment] as seg
        ON a.SegmentUnique=seg.SegmentUnique
        WHERE SQRT  ( POWER((a.StartLatitude - @UserLat) * COS(@UserLat/180) * 40000 / 360, 2)                            
          + POWER((a.StartLongitude -@UserLong) * 40000 / 360, 2)) < 0.5
          group by seg.SegmentUnique
          order by distance asc
             ============================================
                     
                     * String sql = String.Format(@"DECLARE @UserLat float = {0}
                            DECLARE @UserLong float = {1}
                            SELECT distinct a.SegmentUnique, a.{3} as prediction,
                                SQRT  ( POWER((a.StartLatitude - @UserLat) * COS(@UserLat/180) * 40000 / 360, 2) 
                            + POWER((a.StartLongitude -@UserLong) * 40000 / 360, 2)) as distance
                            FROM [CITYPARK].[dbo].[SegmentAndStreetLineView] a
                            where SQRT  ( POWER((a.StartLatitude - @UserLat) * COS(@UserLat/180) * 40000 / 360, 2) 
                            + POWER((a.StartLongitude -@UserLong) * 40000 / 360, 2)) < {2} order by distance", lat, lon,distanceKm,dayOfTheWeekColumn);
             
             
                     */



                    String sql = String.Format(@"DECLARE @UserLat float = {0}
                            DECLARE @UserLong float = {1}
                        SELECT distinct a.SegmentUnique, a.{3} as prediction,
                           min( SQRT  ( POWER((a.StartLatitude - @UserLat) * COS(@UserLat/180) * 40000 / 360, 2) 
                        + POWER((a.StartLongitude -@UserLong) * 40000 / 360, 2))) as distance
    
                        FROM [CITYPARK].[dbo].[SegmentAndStreetLineView] a
                        where SQRT  ( POWER((a.StartLatitude - @UserLat) * COS(@UserLat/180) * 40000 / 360, 2) 
                        + POWER((a.StartLongitude -@UserLong) * 40000 / 360, 2)) < {2} 
                        group by a.SegmentUnique,a.{3}
                        order by distance", lat, lon, distanceKm, dayOfTheWeekColumn);
                    cmd.Connection = con;
                    cmd.CommandText = sql;
                    con.Open();
                    using (SqlDataReader sqlDataReader = cmd.ExecuteReader())
                    {
                        if (sqlDataReader.HasRows)
                        {
                            while (sqlDataReader.Read())
                            {
                                try
                                {
                                    String segUnqSql = sqlDataReader["SegmentUnique"].ToString();
                                    if (!segmentInRange.ContainsKey(segUnqSql))
                                    {
                                        String p = sqlDataReader["prediction"].ToString();
                                        float prediction;
                                        if ("NULL".Equals(p) || "".Equals(p.Trim()))
                                        {
                                            prediction = -1;
                                        }
                                        else
                                        {
                                            prediction = float.Parse(p);
                                        }

                                        if (!segmentInRange.ContainsKey(segUnqSql))
                                        {
                                            segmentInRange.Add(segUnqSql, new DistancePredictionWrapper(float.Parse(sqlDataReader["distance"].ToString()) * 1000, prediction));//in meters
                                        }
                                    }

                                }
                                catch (Exception ex)
                                {
                                    log.Error("Got error while creating segment in range map." + ex.Message);
                                }
                            }
                        }
                    }
                }
            }
            return segmentInRange;
        }

        private void assignSessionToSegments(Dictionary<String, DistancePredictionWrapper> segmentDistance, SessionDataWrapper sessionDataWrapper)
        {/*add to sessionData list with distance!!, and assign to each segment*/
            //remove from each segment the session data                       
            segmentSessionMap.removeSessionDataFromAll(sessionDataWrapper.sessionData.SessionId, new List<String>(sessionDataWrapper.SegmentDistanceAndPredictionMap.Keys));
            //add to sessionData list with distance
            sessionDataWrapper.SegmentDistanceAndPredictionMap = segmentDistance;
            List<String> newSegments = new List<String>(segmentDistance.Keys);
            foreach (String key in newSegments)
            {
                //get search parking segment and if not exists create one
                SearchParkingSegment sps = segmentSessionMap.getSearchParkingSegment(key);
                //assign the session data to the search parking segment
                segmentSessionMap.addSessionDataToSegment(sessionDataWrapper.sessionData.SessionId, sps);
            }

        }

        private float calcSWT(SearchParkingSegment segment, int rate, int radius)
        {
            float SWT = 0;
            if (rate > 0 && segmentSessionMap.countSegmentUsers(segment) > 0)
            {
                //Algo:
                //calulate SWT
                //for each user in the segment waiting list [[1/(sum[user distance from segment/searchRadiusConstant ])]/waitingList[segment].count]/rate
                int waitingListCount = segmentSessionMap.countSegmentUsers(segment);
                List<String> sdList = segmentSessionMap.getSegmetsSessionDataList(segment.SegmentUnique);
                float tmpDistanceDivRadius = 0;
                foreach (String sd in sdList)
                {
                    if (sessionMap.ContainsKey(sd))
                    {
                        Dictionary<String, DistancePredictionWrapper> sdMap = sessionMap[sd].SegmentDistanceAndPredictionMap;
                        if (sdMap != null && sdMap.ContainsKey(segment.SegmentUnique))
                        {
                            float distance = sdMap[segment.SegmentUnique].distance;
                            tmpDistanceDivRadius += distance / radius;
                        }
                    }
                }
                SWT = (1 / tmpDistanceDivRadius) * waitingListCount / rate;
                //store the data SWT in the segment map 
                segment.SWT = SWT;
                return SWT;
            }
            else
            {
                return TPhigh;//30 minutes
            }
        }
    }

}
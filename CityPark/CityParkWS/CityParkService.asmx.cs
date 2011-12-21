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
        private static Timer timer = null;

        private static Dictionary<String, SessionData> sessionMap = null;
        private static SegmentSessionMap segmentSessionMap = null;
        private static String USER_NOT_FOUND = "NO USER FOUND";
        private static String USER_ALREADY_EXISTS = "USER ALREADY EXISTS";
        private static String START_PAYMENT = "START_PAYMENT";
        private static String STOP_PAYMENT = "STOP_PAYMENT";
        private static String ACKNOWLEDGED = "ACKNOWLEDGED";
        private static String FAILED = "FAILED";
        private static String UNVERIFIED = "UNVERIFIED";
        private static String USER_NOT_AUTHENTICATE = "User is not authenticated, Please login to the system!";


        public CityParkService()
        {
            if (segmentSessionMap == null)
            {
                segmentSessionMap = new SegmentSessionMap();
            }
            if (sessionMap == null)
            {
                sessionMap = new Dictionary<String, SessionData>();
            }
            if (timer == null || !timer.Enabled)
            {
                timer = new Timer(120000);//two minute
                timer.Elapsed += new ElapsedEventHandler(timer_Elapsed);
                timer.Start();
            } 
        }

        void timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            List<String> keys = new List<String>(sessionMap.Keys);
            for (int i = 0; i < keys.Count; i++)
            {                
                String sessionIdKey = keys[i];
                DateTime dateTime = sessionMap[sessionIdKey].LastUpdate;
                if (DateTime.Now.Subtract(dateTime).TotalMinutes >= 30)
                {
                    //algo: remove user from segmentWaitList and from segments
                    segmentSessionMap.removeSessionDataFromAll(sessionMap[sessionIdKey]);
                    sessionMap.Remove(sessionIdKey);
                }
            }
        }

        [WebMethod(Description = "Return all garages data within the current location in radius of the given distance")]
        public List<Parking> findAllGarageParkingDataByLatitudeLongitude(String sessionId, float latitude, float longitude, int distance)
        {//and parkingtype='חניון בחינם' or parkingtype='חניון בתשלום'   
            if (!authenticateUser(sessionId))//sessionId.Equals(Session["userId"]))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                    "findAllGarageParkingDataByLatitudeLongitude",
                                    USER_NOT_AUTHENTICATE,
                                    "401",
                                    "findAllGarageParkingDataByLatitudeLongitude");
            }
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    String searchSql = String.Format(
                     @"DECLARE
                        @NOW geography 
                        SET
                        @NOW = geography::Point({0}, {1},4326) 
                        SELECT
                        top 200.*,

                        b.firstHourPrice, 
                        b.extraQuarterPrice, 
                        b.allDayPrice, 
                        @NOW.STDistance(geography::Point(latitude,longitude,4326)) as Distance 
                        FROM
                        CITYPARK.[dbo].[Parking] as a, 
                        CITYPARK.[dbo].[parking_shortrange] b 
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
                        and Heniontype='חניון'
                        and @NOW.STDistance(geography::Point(latitude,longitude,4326))<={2}
                        order by Distance asc", latitude, longitude, distance);// and Current_Pnuyot>0 and isnumeric (b.firsthourprice)=1
                    cmd.Connection = con;
                    cmd.CommandText = searchSql;
                    con.Open();
                    SqlDataReader sqlDataReader = cmd.ExecuteReader();
                    List<Parking> parkingList = new List<Parking>();
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
                            parking.Coupon_text = sqlDataReader["coupon_text"].ToString();
                            parking.Current_Pnuyot = sqlDataReader["current_Pnuyot"].ToString();
                            parking.Image = sqlDataReader["image"].ToString();
                            parking.Image2 = sqlDataReader["image2"].ToString();
                            parking.Withlock = sqlDataReader["Withlock"].ToString();
                            parking.Underground = sqlDataReader["Underground"].ToString();
                            parking.Nolimit = sqlDataReader["Nolimit"].ToString();
                            parking.Roof = sqlDataReader["Roof"].ToString();
                            parking.FirstHourPrice = sqlDataReader["firstHourPrice"].ToString();
                            parking.ExtraQuarterPrice = sqlDataReader["extraQuarterPrice"].ToString();
                            parking.AllDayPrice = sqlDataReader["allDayPrice"].ToString();
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


        [WebMethod(Description = "Return all POI within the current location in radius of the given distance")]
        public List<POI> findPOIByLatitudeLongitude(String sessionId,float latitude, float longitude, int distance, String type, String subType)
        {
            if (!authenticateUser(sessionId))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                    "findPOIByLatitudeLongitude",
                                    USER_NOT_AUTHENTICATE,
                                    "401",
                                    "findPOIByLatitudeLongitude");
            }
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
                    SqlDataReader sqlDataReader = cmd.ExecuteReader();
                    List<POI> poiList = new List<POI>();
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
                    return poiList;
                }
            }
        }

        [WebMethod(Description = "Return filtered list of all garages within the current location in radius of the given distance")]
        public List<Parking> findGarageParkingFilteredByParams(String sessionId,float latitude, float longitude, int distance,
            String payment, String nolimit, String withlock, String tatkarkait, String roof, String toshav, String criple)
        {
            if (!authenticateUser(sessionId))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                    "findGarageParkingFilteredByParams",
                                    USER_NOT_AUTHENTICATE,
                                    "401",
                                    "findGarageParkingFilteredByParams");
            }
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    String paramsSql = Utils.getParkingParams(payment, nolimit, withlock, tatkarkait, roof, toshav, criple);
                    String loginSql = String.Format(
                        @"DECLARE @NOW geography
                            --User Location Coordinates
                            SET @NOW = geography::Point({0}, {1},4326)
                            -- Real time user location after geocoded (address to coordinates)
                            SELECT top 1000 *,
                            b.firstHourPrice, 
							b.extraQuarterPrice, 
							b.allDayPrice, 
                            @NOW.STDistance(geography::Point(latitude,longitude,4326)) as Distance
                            FROM 
                            CITYPARK.[dbo].[Parking] as a, 
							CITYPARK.[dbo].[parking_shortrange] b                            
                            WHERE 
                            a.parkingID=b.parkId 
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
							and Heniontype='חניון'
							and @NOW.STDistance(geography::Point(latitude,longitude,4326))<={2}{3}
							order by Distance asc", latitude, longitude, distance, paramsSql);//note: "and Current_Pnuyot>0" and isnumeric (b.firsthourprice)=1 was removed
                       
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
                            parking.FirstHourPrice = sqlDataReader["firstHourPrice"].ToString();
                            parking.ExtraQuarterPrice = sqlDataReader["extraQuarterPrice"].ToString();
                            parking.AllDayPrice = sqlDataReader["allDayPrice"].ToString();
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


        [WebMethod(Description = "Returns data for a specific parking garage")]
        public Parking fetchGarageParkingById(String sessionId, int parkingId)
        {
            if (!authenticateUser(sessionId))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                    "fetchGarageParkingById",
                                    USER_NOT_AUTHENTICATE,
                                    "401",
                                    "fetchGarageParkingById");
            }
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
            Parking parking = null;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    String fetchDataSql = String.Format(
                     @"SELECT *,
                        priceTbl.firstHourPrice, 
                        priceTbl.extraQuarterPrice, 
                        priceTbl.allDayPrice  
                        FROM
                        CITYPARK.[dbo].[Parking] as parkingTbl, 
                        CITYPARK.[dbo].[parking_shortrange] as priceTbl 
                        where parkingTbl.parkingID='{0}' and parkingTbl.parkingID=priceTbl.parkId", parkingId);
                    cmd.Connection = con;
                    cmd.CommandText = fetchDataSql;
                    con.Open();
                    SqlDataReader sqlDataReader = cmd.ExecuteReader();
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
                            parking.FirstHourPrice = sqlDataReader["firstHourPrice"].ToString();
                            parking.ExtraQuarterPrice = sqlDataReader["extraQuarterPrice"].ToString();
                            parking.AllDayPrice = sqlDataReader["allDayPrice"].ToString();
                        }
                    }
                }
            }
            return parking;
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
                    SqlDataReader sqlDataReader = cmd.ExecuteReader();
                    if (sqlDataReader.HasRows)
                    {
                        sqlDataReader.Read();
                        responseStr = sqlDataReader["Email"].ToString();
                        id = Int32.Parse(sqlDataReader["Id"].ToString());
                    }
                    sqlDataReader.Close();
                    if (responseStr == USER_NOT_FOUND)
                    {
                        return new SessionData(USER_NOT_FOUND);
                    }
                }
                if (id != -1) //just double check                  
                    using (SqlCommand updateCmd = new SqlCommand())
                    {
                        String updateSql = String.Format(
                            @"UPDATE USERS SET LastLogin =  CURRENT_TIMESTAMP WHERE Id = '{0}'",
                            id);
                        updateCmd.Connection = con;
                        updateCmd.CommandText = updateSql;
                        // Then connection is already opened so there is no need to do con.Open();
                        updateCmd.ExecuteNonQuery();
                    }                   
            }

            String sessionId = id.ToString() + "T" + DateTime.Now.Millisecond;
            SessionData sessionData = new SessionData(responseStr, id,sessionId);
            sessionMap.Add(sessionId, sessionData);
           
            return sessionData;
        }

        [WebMethod(Description = "Register to CityPark System, email will be the uid in the system")]
        public string register(String email, String password, String firstName, String familyName, String phoneNumber,String licensesPlate,String paymentService)
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
                            ,[SiteID])
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
                            ,30)", email /*0*/, password, firstName, familyName, phoneNumber/*4*/,licensesPlate,paymentService);
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
                        FROM USERS where Id ='{0}'",sessionMap[sessionId].UserId);
                    cmd.Connection = con;
                    cmd.CommandText = selectSql;
                    con.Open();
                    SqlDataReader sqlDataReader = cmd.ExecuteReader();
                    if (sqlDataReader.HasRows)
                    {
                        while (sqlDataReader.Read())
                        {
                            user.Name=sqlDataReader["Name"].ToString();
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

            return user;
        }

        
            
        [WebMethod(Description = "Gets the location data (City,Street,Parking zone..)")]
        public LocationData getParkingAreaZone(String sessionId, float latitude, float longitude)
        {
            if (!authenticateUser(sessionId))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                   "getLocationData",
                                   USER_NOT_AUTHENTICATE,
                                   "401",
                                   "getLocationData");
            }
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;

            String city = null;
            String street = null;
            String houseNum = null;
            String parkingZone = null;

            LocationData ret = null ;
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
                            parkingZone = sqlDataReader["Parking_Zone"].ToString();
                            if ("NULL".Equals(parkingZone)||"".Equals(parkingZone)) parkingZone = "1";
                            ret = new LocationData(city, street, houseNum, parkingZone, sqlDataReader["latitude"].ToString(),
                                sqlDataReader["longitude"].ToString());
                        }
                    }
                }
                return ret;
            }
          
        }


        [WebMethod(Description = "Reports that the client has parked, still has not paid")]
        public void reportStreetParkingByLatitudeLongitude(String sessionId, float latitude, float longitude)
        {
            if (!authenticateUser(sessionId))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                   "reportStreetParkingByLatitudeLongitude",
                                   USER_NOT_AUTHENTICATE,
                                   "401",
                                   "reportStreetParkingByLatitudeLongitude");
            }
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

            SearchParkingSegment searchParkingSegment = getParkingSegment(latitude,longitude);
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
                           ,[SegementUniqueId])
                        VALUES
                           (''
                           ,''
                           ,'{0}'
                           ,'{1}'
                           ,{2}
                           ,{3}
                           ,{4}
                           ,CURRENT_TIMESTAMP
                           ,'{5}')", city, street, houseNum, latitude, longitude,searchParkingSegment.SegmentUnique);
                    cmd.Connection = con;
                    cmd.CommandText = insertSql;
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            //algo:
            userStartParkingEvent(sessionId,latitude, longitude, false, searchParkingSegment);
        }
            
        [WebMethod(Description = "Reports the clients location")]
        public Boolean reportSearchLocation(String sessionId, float latitude, float longitude)
        {    
            if (!authenticateUser(sessionId))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                   "reportSearchLocation",
                                   USER_NOT_AUTHENTICATE,
                                   "401",
                                   "reportSearchLocation");
            }
           
            try
            {
                //algo:
                SessionData sd = sessionMap[sessionId];
                SearchParkingSegment sps = getParkingSegment(latitude, longitude);
                //1)Add to the session map the current location and the last location and current segment,keep the current and last timestamp
                sd.setCurrentLocationAndUpdateTime(latitude, longitude);                
                //2) keep the current and last timestamp
                sps.LastUpdate = DateTime.Now;
                //3)if user changed segment 
                if (sd.updateCurrentSegment(sps.SegmentUnique))
                {
                    //3.a)calc the segmentParking rate calcSegmentParkingRate()
                    SearchParkingSegment previousSegment = segmentSessionMap.getSearchParkingSegment(sd.PreviousSegment);
                    int previousSegmentRate = calcSegmentParkingRate(previousSegment);
                    //3.b)calculate SWT calcSWT(segment,rate) for the former segment
                }
                
                
                
                
                

                
                                
            }
            catch (Exception ex)
            {
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
            SessionData sd = sessionMap[sessionId];
            return reportPayment(sessionMap[sessionId].UserId,paymentProviderName, latitude, longitude, operationStatus, START_PAYMENT, DateTime.Now);
            
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
            SessionData data = sessionMap[sessionId];
            return reportPayment(data.UserId, paymentProviderName, latitude, longitude, operationStatus, STOP_PAYMENT, DateTime.Now);

        }

        private Boolean reportPayment(int userId,String paymentProvider,float latitude, float longitude,String status,String operation,DateTime currentTime)
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
                           ,'{2}'
                           ,{3}
                           ,{4}
                           ,'{5}'
                           ,'{6}')",userId,paymentProvider,currentTime,latitude,longitude,operation,status);
                        cmd.Connection = con;
                        cmd.CommandText = insertSql;
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }catch(Exception ex){
                return false;
            }
            return true;
        }

        [WebMethod(Description = "Get all payment services")]
        public List<PaymentServiceProvider> getAllPaymentServices()
        {
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
                    SqlDataReader sqlDataReader = cmd.ExecuteReader();
                    List<PaymentServiceProvider> pspList = new List<PaymentServiceProvider>();
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
                            pspList.Add(psp);
                        }
                    }
                    else
                    {
                        return null;
                    }
                    return pspList;
                }
            }
        }


        [WebMethod(Description = "Return all garages and off street parking at from current location in radius of the given distance")]
        public List<Parking> findGarageParkingByLatitudeLongitude(String sessionId, float latitude, float longitude, int distance)
        {//and parkingtype='חניון בחינם' or parkingtype='חניון בתשלום'   
            if (!authenticateUser(sessionId))//sessionId.Equals(Session["userId"]))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                    "findParkingByLatitudeLongitude",
                                    USER_NOT_AUTHENTICATE,
                                    "401",
                                    "findParkingByLatitudeLongitude");
            }
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    String searchSql = String.Format(
                     @"DECLARE
                        @NOW geography 
                        SET
                        @NOW = geography::Point({0}, {1},4326) 
                        SELECT
                        top 200.*,

                        b.firstHourPrice, 
                        b.extraQuarterPrice, 
                        b.allDayPrice, 
                        @NOW.STDistance(geography::Point(latitude,longitude,4326)) as Distance 
                        FROM
                        CITYPARK.[dbo].[Parking] as a, 
                        CITYPARK.[dbo].[parking_shortrange] b 
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
                        and Heniontype='חניון'
                        and @NOW.STDistance(geography::Point(latitude,longitude,4326))<={2}
                        order by Distance asc", latitude, longitude, distance);// and Current_Pnuyot>0 and isnumeric (b.firsthourprice)=1
                    cmd.Connection = con;
                    cmd.CommandText = searchSql;
                    con.Open();
                    SqlDataReader sqlDataReader = cmd.ExecuteReader();
                    List<Parking> parkingList = new List<Parking>();
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
                            //parking.Comment = sqlDataReader["comment"].ToString();
                            //parking.Coupon_text = sqlDataReader["coupon_text"].ToString();
                            parking.Current_Pnuyot = sqlDataReader["current_Pnuyot"].ToString();
                            //parking.Image = sqlDataReader["image"].ToString();
                            //parking.Image2 = sqlDataReader["image2"].ToString();
                            //parking.Withlock = sqlDataReader["Withlock"].ToString();
                            //parking.Underground = sqlDataReader["Underground"].ToString();
                            //parking.Nolimit = sqlDataReader["Nolimit"].ToString();
                            //parking.Roof = sqlDataReader["Roof"].ToString();
                            parking.FirstHourPrice = sqlDataReader["firstHourPrice"].ToString();
                            parking.ExtraQuarterPrice = sqlDataReader["extraQuarterPrice"].ToString();
                            parking.AllDayPrice = sqlDataReader["allDayPrice"].ToString();
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

        [WebMethod(Description = "Return on street parking prediction in street segments")]
        public List<SearchParkingSegment> getStreetParkingPrediction(String sessionId, float latitude, float longitude, int distance)
        {
            if (!authenticateUser(sessionId))
            {
                throw Utils.RaiseException(Context.Request.Url.AbsoluteUri,
                                    "getStreetParkingPrediction",
                                    USER_NOT_AUTHENTICATE,
                                    "401",
                                    "getStreetParkingPrediction");
            }
            //todo:
            //1)Fetch all lines distinced by segmentUnique order by distance.
            //2)register user on the waiting list foreach segmentUnique (counter logic only).
            //  2.a) - when user should be removed from list/map:
            //          2.a.1)timeout (20 min) - session managment
            //          2.a.2)start parking
            //          2.a.3)segment maintanence interval using the cleanSWT()

            //3)for each segments in search radius return USWT[user,segment]=(distance from segment/radius)*SWT[segment]
            List<SearchParkingSegment> segList = new List<SearchParkingSegment>();
            for (int i = 0; i < 3; i++)
            {
                segList.Add(new SearchParkingSegment(i + 1, latitude + 0.0002f * i, longitude + 0.0002f * i, latitude + 0.001f * i + 0.001f, longitude + 0.0001f * i + 0.001f, (i + 1 / (i + 1)) * 100,"32.3223223,34.343434343"));
            }
            return segList;
        }



        private Boolean authenticateUser(String sessionId)
        {
            try
            {
                if (sessionMap[sessionId.Trim()]!=null)
                    return true;
            }
            catch (Exception ex)
            {
                return false;
            }
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
        /// 
        /// </summary>
        /// <param name="lat"></param>
        /// <param name="lon"></param>
        /// <param name="userPaidForParking"></param>
        /// <returns></returns>
        protected void userStartParkingEvent(String sessionId, float lat, float lon, Boolean userPaidForParking, SearchParkingSegment searchParkingSegment)
        {
            //todo:
            //1)remove user from  segment waiting list
        }

        private SearchParkingSegment getParkingSegment(float lat, float lon)
        {
            //todo:
            //Select from segment
            SearchParkingSegment sps =  new SearchParkingSegment();
            sps = segmentSessionMap.getSearchParkingSegment(sps);
            return sps;
        }

        /**
         * SWT = FP * SegmentUsersCount / SegmentParkingRate
         * */
        private float calcSegmentWaitTime(int userCount, int parkingRate, float parkingWaitTimeFactor)
        {
            return parkingWaitTimeFactor * userCount / parkingRate;
        }

        private int getSegmentUsersCount(SearchParkingSegment searchParkingSegment)
        {
            return segmentSessionMap.countSegmentUsers(searchParkingSegment);
        }

        /**
         *Recalculate SegmentParkingRate (++)
         * */
        private int calcSegmentParkingRate(SearchParkingSegment sps)
        {//todo: need to check if this SQL works!!!
            //also:
            //udpate SWT updateTime
            sps.LastUpdate = DateTime.Now;
            //count and return how many start parking in last DELTA T
            int previousSegmentRate = 0;
            DateTime delta = DateTime.Now;
            delta.AddMinutes(60);
            String conStr = ConfigurationManager.ConnectionStrings["CityParkCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {

                    String sql = String.Format(
                        @"SELECT COUNT(*)
                            FROM [CITYPARK].[dbo].[StreetParking] where [Date] >={0}",delta);
                    cmd.Connection = con;
                    cmd.CommandText = sql;
                    con.Open();
                    previousSegmentRate = (int)cmd.ExecuteScalar();                   
                }
            }

            return previousSegmentRate;
        }

        private void cleanSWT()
        {
            //todo:
            //for each segment in waitingList
            // if( waitingList[segment].lastUpdate<timeConstant)
            //     waitingList.remove(segment); //or set SWT to -1 
        }

        private float calcSWT(SearchParkingSegment segment,float rate)
        {           
            
            if (rate <= 0)
            {
                return 30 * 60;
            }
            else //todo: if(waitingList[segment].count>0)
            {
                //todo:
                //calulate SWT
                //for each user in the segment waiting list [[1/(sum[user distance from segment/searchRadiosConstant ])]/waitingList[segment].count]/rate
                //store the data SWT in the segment map
            }
            return 0;
        }
    }

}
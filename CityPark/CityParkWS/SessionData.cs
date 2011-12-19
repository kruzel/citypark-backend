using System;
using System.Collections.Generic;
using System.Web;

namespace CityParkWS
{
    public class SessionData
    {
       
        public String SessionId { get; set; }
        public DateTime LastUpdate { get; set; }
        public Int32 UserId { get; set; }
        public String UserName { get; set; }
        
        public SessionData(String sessionIdStr) 
        {
            LastUpdate = DateTime.Now;
            SessionId = sessionIdStr;
        }
        public SessionData() { }

        public SessionData(String userNameStr, Int32 id, String sessionIdStr)
        {
            LastUpdate = DateTime.Now;
            UserId = id;
            SessionId = sessionIdStr;
            UserName = userNameStr;
        }

    }
}
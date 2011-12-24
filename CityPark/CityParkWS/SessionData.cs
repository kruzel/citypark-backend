﻿using System;
using System.Collections.Generic;
using System.Web;

namespace CityParkWS
{
    public class SessionData
    {
       
        public String SessionId { get; set; }
        public DateTime LastUpdate { get; set; }
        public DateTime PreviousUpdate { get; set; }
        public Int32 UserId { get; set; }
        public String UserName { get; set; }
        public float LastLongitude { get; set; }
        public float LastLatitude { get; set; }
        public float CurrentLongitude { get; set; }
        public float CurrentLatitude { get; set; }
        public String CurrentSegment { get; set; }
        public String PreviousSegment { get; set; }
        
        
        public SessionData(String sessionIdStr) 
        {
            LastUpdate = DateTime.Now;
            SessionId = sessionIdStr;
            CurrentSegment = "";
            PreviousSegment = "";
        }
        public SessionData() 
        {
            CurrentSegment = "";
            PreviousSegment = "";
        }

        public void setCurrentLocationAndUpdateTime(float latitude, float longitude)
        {
            LastLatitude = CurrentLatitude;
            LastLongitude = CurrentLongitude;
            CurrentLatitude = latitude;
            CurrentLongitude = longitude;
            PreviousUpdate = LastUpdate;
            LastUpdate = DateTime.Now;
        }

        public SessionData(String userNameStr, Int32 id, String sessionIdStr)
        {
            LastUpdate = DateTime.Now;
            UserId = id;
            SessionId = sessionIdStr;
            UserName = userNameStr;
        }

        /// <summary>
        /// Update the current segment if there was a change in segments
        /// </summary>
        /// <param name="spsUnique"></param>
        /// <returns>true if there was a change</returns>
        public Boolean updateCurrentSegment(String spsUnique)
        {
            if (spsUnique.Equals(CurrentSegment))
            {
                return false;
            }
            PreviousSegment = CurrentSegment;
            CurrentSegment = spsUnique;
            //return true if both contains segmentUnique value!!
            return !PreviousSegment.Equals("");
        }

    }
}
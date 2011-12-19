using System;
using System.Collections.Generic;
using System.Web;

namespace CityParkWS
{
    public class SearchParkingSegment
    {
        public float StartLongitude{ get; set; }
        public float StartLatitude { get; set; }
        public float EndLongitude { get; set; }
        public float EndLatitude { get; set; }
        public Int32 Id { get; set; }
        public Int32 SearchTime { get; set; }
        public String SegmentUnique { set; get; } 
        
        public SearchParkingSegment() { }
        public SearchParkingSegment(Int32 id,float startLat,float startLong,
                              float endLat, float endLong, Int32 searchTime,String segId)
        {
            Id = id;
            StartLatitude = startLat;
            StartLongitude = startLong;
            EndLatitude = endLat;
            EndLongitude = endLong;
            SearchTime = searchTime;
            SegmentUnique = segId;
        }

    }
}
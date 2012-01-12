using System;
using System.Collections.Generic;
using System.Web;

namespace CityParkWS
{
    public class SessionDataWrapper
    {
        public SessionData sessionData { get; set; }
        public Dictionary<String, DistancePredictionWrapper> SegmentDistanceAndPredictionMap { get; set; }//key:segmentUnique value:distance
        public SessionDataWrapper(SessionData sd)
        {
            sessionData = sd;
            SegmentDistanceAndPredictionMap = new Dictionary<string, DistancePredictionWrapper>();
        }

    }
}
using System;
using System.Collections.Generic;
using System.Web;

namespace CityParkWS
{
    public class StreetSegmentLine
    {
      public String SegmentUnique{get;set;}
      public String Name{get;set;}
      public String Oneway{get;set;}
      public String StartLatitude{get;set;}
      public String StartLongitude{get;set;}
      public String EndLatitude{get;set;}
      public String EndLongitude{get;set;}
      public String Highway { get; set; }

      public StreetSegmentLine() { }
    }
}
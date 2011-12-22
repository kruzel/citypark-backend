using System;
using System.Collections.Generic;
using System.Web;

namespace CityParkWS
{
    public class SearchParkingSegment
    {   
        public Int32 SWT { get; set; }
        public String SegmentUnique { set; get; }
        public DateTime LastUpdate { set; get; }
        
        public SearchParkingSegment() { }
        public SearchParkingSegment(Int32 swt,String segUnique)
        {
            LastUpdate = DateTime.Now;
            SWT = swt;
            SegmentUnique = segUnique;
        }

    }
}
using System;
using System.Collections.Generic;
using System.Web;

namespace CityParkWS
{
    public class SearchParkingSegment
    {   
        public float SWT { get; set; }
        public String SegmentUnique { set; get; }
        public DateTime LastVisit { set; get; }
        
        public SearchParkingSegment() 
        {
            SWT = -1;
        }
        public SearchParkingSegment(float swt,String segUnique)
        {
            LastVisit = DateTime.Now;
            SWT = swt;
            SegmentUnique = segUnique;
        }

    }
}
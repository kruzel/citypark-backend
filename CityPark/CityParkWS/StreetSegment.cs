using System;
using System.Collections.Generic;
using System.Web;

namespace CityParkWS
{
    public class StreetSegment
    {
        public String SegmentUnique { get; set; }
        public float SWT { get; set; }
        public List<StreetSegmentLine> SegmentLine{get;set;}

        public StreetSegment() 
        {
            SegmentLine = new List<StreetSegmentLine>();
        }
        public StreetSegment(String unique, float swt)
        {
            SegmentUnique = unique;
            SWT = swt;
            SegmentLine = new List<StreetSegmentLine>();
        }

        public void add(StreetSegmentLine ssl)
        {
            SegmentLine.Add(ssl);
        }

    }
}
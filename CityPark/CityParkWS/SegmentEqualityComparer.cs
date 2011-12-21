using System;
using System.Collections.Generic;
using System.Web;

namespace CityParkWS
{
    public class SegmentEqualityComparer : IEqualityComparer <SearchParkingSegment>
    {
        public bool Equals(SearchParkingSegment a, SearchParkingSegment b)
        {
            return a.SegmentUnique.Equals(b.SegmentUnique);
        }

        public int GetHasCode(SearchParkingSegment x)
        {
            return x.SegmentUnique.GetHashCode();
        }
    }
}
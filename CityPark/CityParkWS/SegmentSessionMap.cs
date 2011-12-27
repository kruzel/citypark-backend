using System;
using System.Collections.Generic;
using System.Web;

namespace CityParkWS
{
    public class SegmentSessionMap
    {
        private Dictionary<String, SearchParkingSegmentDetails> segmentToSessionMap;//segmentUnique as key

        private class SearchParkingSegmentDetails
        {
            public SearchParkingSegment sps { get; set; }
            public List<String> sessionList { get; set; }

            public SearchParkingSegmentDetails(SearchParkingSegment pSps, List<String> pSessionList)
            {
                sps = pSps;
                sessionList = pSessionList;
            }

        }

        /// <summary>
        /// Returns the segment session list
        /// </summary>
        /// <param name="sps"></param>
        /// <returns></returns>
        public List<String> getSegmetsSessionDataList(String sps)
        {
            if (segmentToSessionMap.ContainsKey(sps))
            {
                return segmentToSessionMap[sps].sessionList;
            }
            return new List<String>();
        }

        /// <summary>
        /// Clean the  timeout segments, where last visit is greater than 30 min.
        /// </summary>
        /// <returns></returns>
        public int cleanTimeOutSegments()
        {
            int count = 0;
            foreach (SearchParkingSegmentDetails spsd in segmentToSessionMap.Values)
            {
                if (DateTime.Now.Subtract(spsd.sps.LastVisit).TotalMinutes > 30)
                {                    
                    spsd.sps.SWT = -1;
                    //No need to udpate the sessionList
                    count++;
                }

            }
           
            return count;
        }

        public SegmentSessionMap()
        {            
            segmentToSessionMap = new Dictionary<String, SearchParkingSegmentDetails>();//new SegmentEqualityComparer()
        }

        /// <summary>
        /// Get the search parking segment is exists and if not create it
        /// </summary>
        /// <param name="sps">SearchParkingSegment</param>
        /// <returns>SearchParkingSegment</returns>
        public SearchParkingSegment getSearchParkingSegment(SearchParkingSegment sps)
        {
            if (segmentToSessionMap.ContainsKey(sps.SegmentUnique))
            {
                return segmentToSessionMap[sps.SegmentUnique].sps;
            }

            segmentToSessionMap.Add(sps.SegmentUnique, new SearchParkingSegmentDetails(sps,new List<String>()));
            return sps;
        }

        /// <summary>
        /// Get the search parking segment is exists and if not create it
        /// </summary>
        /// <param name="sps">SearchParkingSegment</param>
        /// <returns>SearchParkingSegment</returns>
        public SearchParkingSegment getSearchParkingSegment(String spsName)
        {
            if (segmentToSessionMap.ContainsKey(spsName))
            {
                return segmentToSessionMap[spsName].sps;
            }
            SearchParkingSegment sps = new SearchParkingSegment(-1,spsName);
            segmentToSessionMap.Add(sps.SegmentUnique, new SearchParkingSegmentDetails(sps, new List<String>()));
            return sps;
        }

        /// <summary>
        /// Count the sessions in current segment
        /// </summary>
        /// <param name="segment"></param>
        /// <returns></returns>
        public int countSegmentUsers(SearchParkingSegment segment)
        {
            if(segmentToSessionMap.ContainsKey(segment.SegmentUnique))
            {
                return segmentToSessionMap[segment.SegmentUnique].sessionList.Count;
            }
            return 0;
        }

        

        /// <summary>
        /// Remove the session data from all segments
        /// </summary>
        /// <param name="sessionData"></param>
        /// <returns>count of removed from segment and -1 if there was an error</returns>
        public int removeSessionDataFromAllSegments(String sessionData)
        {
            int count = 0;
            try
            {                
                foreach (SearchParkingSegmentDetails sg in segmentToSessionMap.Values)
                {
                    if(sg.sessionList.Remove(sessionData)) count++;
                }
            }
            catch (Exception ex)
            {
                count = -1;
                Console.WriteLine("removeSessionDataFromAllSegments " + ex.Message);
            }
            return count;
        }

        /// <summary>
        /// Remove the session data from all segments in the list
        /// </summary>
        /// <param name="sessionData"></param>
        public void removeSessionDataFromAll(String sessionData,List<String> segmentList)
        {
            try
            {
                //remove from all segements user lists
                foreach (String segment in segmentList)
                {                    
                    if (segmentToSessionMap.ContainsKey(segment))
                    {
                        segmentToSessionMap[segment].sessionList.Remove(sessionData);
                    }                   
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("removeSessionDataFromAll " + ex.Message);
            }
        }

        
        /// <summary>
        /// Add the session to segment
        /// </summary>
        /// <param name="sessionData"></param>
        /// <param name="segment"></param>
        public void addSessionDataToSegment(String sessionData,SearchParkingSegment segment)
        {
            try
            {
                if (segmentToSessionMap.ContainsKey(segment.SegmentUnique))
                {
                    SearchParkingSegmentDetails spsd = segmentToSessionMap[segment.SegmentUnique];
                    if (!spsd.sessionList.Contains(sessionData))
                    {
                        spsd.sessionList.Add(sessionData);
                    }
                }
                else 
                {
                    segment = getSearchParkingSegment(segment);
                    segmentToSessionMap[segment.SegmentUnique].sessionList.Add(sessionData);
                }
            }
            catch (Exception ex) { }
        }
    }
}
using System;
using System.Collections.Generic;
using System.Web;

namespace CityParkWS
{
    public class SegmentSessionMap
    {
        private Dictionary<String, SearchParkingSegmentDetails> segmentToSessionMap;//segmentUnique as key
        private Dictionary<String, List<SearchParkingSegment>> userToSegmentMap;//SessionData

        private class SearchParkingSegmentDetails
        {
            public SearchParkingSegment sps { get; set; }
            public List<SessionData> sessionList { get; set; }

            public SearchParkingSegmentDetails(SearchParkingSegment pSps, List<SessionData> pSessionList)
            {
                sps = pSps;
                sessionList = pSessionList;
            }

        }

        public List<SessionData> getSegmetsSessionDataList(String sps)
        {
            if (segmentToSessionMap.ContainsKey(sps))
            {
                return segmentToSessionMap[sps].sessionList;
            }
            return new List<SessionData>();
        }

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
            userToSegmentMap = new Dictionary<String, List<SearchParkingSegment>>();// (new SessionDataEqualityComparer());
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

            segmentToSessionMap.Add(sps.SegmentUnique, new SearchParkingSegmentDetails(sps,new List<SessionData>()));
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
            segmentToSessionMap.Add(sps.SegmentUnique, new SearchParkingSegmentDetails(sps, new List<SessionData>()));
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
        /// Remove the session data from all maps
        /// </summary>
        /// <param name="sessionData"></param>
        public void removeSessionDataFromAll(SessionData sessionData)
        {
            try
            {
                if (userToSegmentMap.ContainsKey(sessionData.UserName))
                {
                    List<SearchParkingSegment> segmentList = userToSegmentMap[sessionData.UserName];
                    //remvoe from all segements user lists
                    foreach (SearchParkingSegment sg in segmentList)
                    {
                        removeSessionDataFromSegment(sessionData, sg);
                    }
                    //remove from users list
                    userToSegmentMap.Remove(sessionData.UserName);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("removeSessionDataFromAll " + ex.Message);
            }
        }

        /// <summary>
        /// Remove the sessions from the search parking segment
        /// </summary>
        /// <param name="sessionData"></param>
        /// <param name="segment"></param>
        public void removeSessionDataFromSegment(SessionData sessionData, SearchParkingSegment segment)
        {
            try
            {
                if (segmentToSessionMap.ContainsKey(segment.SegmentUnique))
                {
                    List<SessionData> list = segmentToSessionMap[segment.SegmentUnique].sessionList;
                    if (userToSegmentMap.ContainsKey(sessionData.UserName))
                    {
                        List<SearchParkingSegment> spsList = userToSegmentMap[sessionData.UserName];
                        List<SearchParkingSegment> newSpsList = new List<SearchParkingSegment>();
                        foreach (SearchParkingSegment sps in spsList)
                        {
                            if (!sps.SegmentUnique.Equals(segment.SegmentUnique))
                            {
                                newSpsList.Add(sps);//new list without the segment
                            }
                        }
                        userToSegmentMap[sessionData.UserName] = newSpsList;
                    }
                    list.Remove(sessionData);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("removeSessionDataFromSegment "+ex.Message);
            }
        }

        /// <summary>
        /// Add the session to segment
        /// </summary>
        /// <param name="sessionData"></param>
        /// <param name="segment"></param>
        public void addSessionDataToSegment(SessionData sessionData,SearchParkingSegment segment)
        {
            try
            {
                segment = getSearchParkingSegment(segment);
                if (userToSegmentMap.ContainsKey(sessionData.UserName))
                {
                    List<SearchParkingSegment> list = userToSegmentMap[sessionData.UserName];
                    Boolean existsOnList = false;
                    foreach (SearchParkingSegment searchParkingSegment in list)
                    {
                        if (searchParkingSegment.SegmentUnique.Equals(segment.SegmentUnique))
                        {
                            existsOnList = true;
                        }
                    }
                    if (existsOnList.Equals(false))
                    {
                        list.Add(segment);
                    }

                }
                else //if (!userToSegmentMap.ContainsKey(sessionData.UserName))
                {
                    List<SearchParkingSegment> list = new List<SearchParkingSegment>();
                    list.Add(segment);
                    userToSegmentMap.Add(sessionData.UserName, list);
                }
                //ADD TO SEGMENT2SESSION MAP
                if (segmentToSessionMap.ContainsKey(segment.SegmentUnique))
                {
                    List<SessionData> slist = segmentToSessionMap[segment.SegmentUnique].sessionList;
                    Boolean existsOnList = false;
                    foreach (SessionData sessionD in slist)
                    {
                        if (sessionD.UserName.Equals(sessionData.UserName))
                        {
                            existsOnList = true;
                        }
                    }
                    if (existsOnList.Equals(false))
                    {
                        slist.Add(sessionData);
                    }
                }
                else
                {
                    List<SessionData> list = new List<SessionData>();
                    list.Add(sessionData);
                    segmentToSessionMap.Add(segment.SegmentUnique, new SearchParkingSegmentDetails(segment, list));

                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("addSessionDataToSegment " + ex.Message);
            }
        }

    }
}
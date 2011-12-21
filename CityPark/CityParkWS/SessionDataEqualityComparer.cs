using System;
using System.Collections.Generic;
using System.Web;

namespace CityParkWS
{
    public class SessionDataEqualityComparer : IEqualityComparer<SessionData>
    {
        public bool Equals(SessionData a, SessionData b)
        {
            return a.SessionId.Equals(b.SessionId);
        }

        public int GetHashCode(SessionData x)
        {
            return x.SessionId.GetHashCode();
        }
    }
}
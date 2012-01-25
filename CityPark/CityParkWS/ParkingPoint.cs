using System;
using System.Collections.Generic;
using System.Web;

namespace CityParkWS
{
    public class ParkingPoint
    {
        public String name { get; set; }       
        public String latitude { get; set; }
        public String longitude { get; set; }
        public int parkingId { get; set; }
        public String owner { get; set; }
        public String availability { get; set; }
        public String firstHourPrice { get; set; }

        public ParkingPoint(int parkingId,
            String name,           
            String latitude,
            String longitude)
        {
            this.parkingId = parkingId;
            this.name = name;          
            this.longitude = longitude;
            this.latitude = latitude;
        }

        public ParkingPoint() { }
    }
}
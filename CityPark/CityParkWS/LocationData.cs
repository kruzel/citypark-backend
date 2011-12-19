using System;
using System.Collections.Generic;
using System.Web;

namespace CityParkWS
{
    public class LocationData
    {
        public String City { get; set; }
        public String Street { get; set; }
        public String HouseNum { get; set; }
        public String ParkingZone { get; set; }
        public String Longitude { get; set; }
        public String Latitude { get; set; }

        public LocationData() { }

        public LocationData(String city, String street,String houseNum ,String parkingZone,String lat,String longi) 
        {
            City = city;
            Street = street;
            HouseNum = houseNum;
            ParkingZone = parkingZone;
            Latitude = lat;
            Longitude = longi;
        }

    }
}
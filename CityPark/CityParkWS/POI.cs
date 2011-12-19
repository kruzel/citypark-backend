using System;
using System.Collections.Generic;
using System.Web;

namespace CityParkWS
{
    public class POI
    {
        private String type;
        private String subType;                
        private String name;
        private String city;
        private String streetName;
        private int houseNumber;
        private String longitude;
        private String latitude;
        private String image;
        private String comment;


        public String Name
        {
            get { return name; }
            set { name = value; }
        }        

        public String City
        {
            get { return city; }
            set { city = value; }
        }
       

        public String StreetName
        {
            get { return streetName; }
            set { streetName = value; }
        }
        
        public int HouseNumber
        {
            get { return houseNumber; }
            set { houseNumber = value; }
        }
       
        public String Longitude
        {
            get { return longitude; }
            set { longitude = value; }
        }
        

        public String Latitude
        {
            get { return latitude; }
            set { latitude = value; }
        }
        

        public String Image
        {
            get { return image; }
            set { image = value; }
        }
        

        public String Comment
        {
            get { return comment; }
            set { comment = value; }
        }

        public String Type
        {
            get { return type; }
            set { type = value; }
        }
        

        public String SubType
        {
            get { return subType; }
            set { subType = value; }
        }

        public POI() { }


    }
}
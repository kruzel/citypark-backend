using System;
using System.Collections.Generic;
using System.Web;

namespace CityParkWS
{
    public class User
    {
        public User() { }

        public String Name { get; set; }
        public String Familyname { get; set; }
        public String Usersname { get; set; }
        public String Phone { get; set; }
        public String Email { get; set; }
        public String LicensePlate { get; set; }
        public String PaymentProvider { get; set; }
    }
}
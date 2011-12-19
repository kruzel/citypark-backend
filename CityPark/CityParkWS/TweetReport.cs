using System;
using System.Collections.Generic;
using System.Web;

namespace CityParkWS
{
    public class TweetReport
    {
        private String text;        
        public String Text
        {
            get { return text; }
            set { text = value; }
        }
        private int category;

        public int Category
        {
            get { return category; }
            set { category = value; }
        }
        private String city;

        public String City
        {
            get { return city; }
            set { city = value; }
        }
        private String street;

        public String Street
        {
            get { return street; }
            set { street = value; }
        }
        private String houseNumber;

        public String HouseNumber
        {
            get { return houseNumber; }
            set { houseNumber = value; }
        }
        private String date;

        public String Date
        {
            get { return date; }
            set { date = value; }
        }
        public TweetReport() { }

        public static int getCategoryAsInt(String cat)
        {
            if (cat.Equals("חנייה פנוייה")) return 1;
            if (cat.Equals("מפנה חניה עוד 5 דקות")) return 2;
            if (cat.Equals("פקח באזור")) return 3;
            if (cat.Equals("גרר באזור")) return 4;

            if (cat.Equals("מצוקת חניה באזור")) return 5;
            return 4;
        }

        public static String getCategoryAsString(int cat)
        {
            if (cat==1) return "חנייה פנוייה";

            if (cat == 2) return "מפנה חניה עוד 5 דקות"; ;

            if (cat == 3) return "פקח באזור";

            if (cat==4) return "גרר באזור";

            if (cat==5) return "מצוקת חניה באזור";

            return "גרר באזור";
        }
    }
}
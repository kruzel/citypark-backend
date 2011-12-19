using System;
using System.Collections.Generic;
using System.Web;

namespace CityParkWS
{
    /**
     * Parking is a reflection of the Parking table
     * Parking(String parkingId, String parkId, String name, String city, String streetName, int houseNumber, String latitude, String longitude)
     * */
    public class Parking
    {
        private int parkingId;    
        private String name;
        private String city;
        private String streetName;
        private int houseNumber;
        private String longitude;
        private String latitude;

        private String numberofparks;
        private String tel;
        private String fax;
        private String email;
        private String onlymail;
        private String comment;
        private String payment;
        private String image;
        private String image2;
        private String startDate;
        private String endDate;
        private String parkingtype;
        private String contactname;
        private String hourly;
        private String daily;
        private String weekly;
        private String monthly;
        private String yearly;
        private String price;
        private String pricefortime;
        private String cartype;
        private String manuytype;
        private String payments;
        private String cc;
        private String cash;
        private String cheak;
        private String paypal;
        private String lelohagbalatheshbon;
        private String majsom;
        private String tatkarkait;
        private String jenion;
        private String criple;
        private String nolimit;
        private String henion;
        private String withlock;
        private String underground;
        private String roof;
        private String vip;
        private String toshav;
        private String coupon;
        private String coupon_text;
        private String current_Pnuyot;
        private String siteID;
        private String heniontype;
        private String firstHourPrice;
        private String extraQuarterPrice;
        private String allDayPrice;

       
        public Parking() { }


        public Parking(int parkingId,
            String name,
            String city,
            String streetName,
            int houseNumber,
            String latitude,
            String longitude)
        {
            this.parkingId = parkingId;
            this.name = name;
            this.city = city;
            this.streetName = streetName;
            this.houseNumber = houseNumber;
            this.longitude = longitude;
            this.latitude = latitude;
        }

        public Parking(int parkingId, 
            String name, 
            String city, 
            String streetName, 
            int houseNumber, 
            String latitude, 
            String longitude,
            String numberofparks,
            String tel,
            String fax,
            String email,
            String onlymail,
            String comment,
            String payment,
            String image,
            String image2,
            String startDate,
            String endDate,
            String parkingtype,
            String contactname,
            String hourly,
            String daily,
            String weekly,
            String monthly,
            String yearly,
            String price,
            String pricefortime,
            String cartype,
            String manuytype,
            String payments,
            String cc,
            String cash,
            String cheak,
            String paypal,
            String lelohagbalatheshbon,
            String majsom,
            String tatkarkait,
            String jenion,
            String criple,
            String nolimit,
            String henion,
            String withlock,
            String underground,
            String roof,
            String vip,
            String toshav,
            String coupon,
            String coupon_text,
            String current_Pnuyot,
            String siteID,
            String heniontype)
        {
            this.parkingId = parkingId;
            this.name = name;
            this.city = city;
            this.streetName = streetName;
            this.houseNumber = houseNumber;
            this.longitude = longitude;
            this.latitude = latitude;
            this.numberofparks = numberofparks ;
            this.tel = tel ;
            this.fax = fax ;
            this.email =  email;
            this.onlymail = onlymail ;
            this.comment =  comment;
            this.payment = payment ;
            this.image = image ;
            this.image2 = image2 ;
            this.startDate = startDate ;
            this.endDate =  endDate;
            this.parkingtype =  parkingtype;
            this.contactname = contactname ;
            this.hourly = hourly ;
            this.daily =  daily;
            this.weekly = weekly ;
            this.monthly =  monthly;
            this.yearly =  yearly;
            this.price = price ;
            this.pricefortime = pricefortime ;
            this.cartype = cartype ;
            this.manuytype = manuytype ;
            this.payments = payments ;
            this.cc =  cc;
            this.cash = cash ;
            this.cheak =  cheak;
            this.paypal =  paypal;
            this.lelohagbalatheshbon = lelohagbalatheshbon ;
            this.majsom = majsom ;
            this.tatkarkait = tatkarkait ;
            this.jenion = jenion ;
            this.criple =  criple;
            this.nolimit = nolimit ;
            this.henion = henion ;
            this.withlock = withlock ;
            this.underground = underground ;
            this.roof =  roof;
            this.vip =  vip;
            this.toshav = toshav ;
            this.coupon =  coupon;
            this.coupon_text =  coupon_text;
            this.current_Pnuyot =  current_Pnuyot;
            this.siteID =  siteID;
            this.heniontype = heniontype;
        }

        public int ParkingId
        {
            get { return parkingId; }
            set { parkingId = value; }
        }

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

        public String Numberofparks
        {
            get { return numberofparks; }
            set { numberofparks = value; }
        }
        public String Tel
        {
            get { return tel; }
            set { tel = value; }
        }
        public String Fax
        {
            get { return fax; }
            set { fax = value; }
        }
        public String Email
        {
            get { return email; }
            set { email = value; }
        }
        public String Onlymail
        {
            get { return onlymail; }
            set { onlymail = value; }
        }
        public String Comment
        {
            get { return comment; }
            set { comment = value; }
        }
        public String Payment
        {
            get { return payment; }
            set { payment = value; }
        }
        public String Image
        {
            get { return image; }
            set { image = value; }
        }
        public String Image2
        {
            get { return image2; }
            set { image2 = value; }
        }
        public String StartDate
        {
            get { return startDate; }
            set { startDate = value; }
        }
        public String EndDate
        {
            get { return endDate; }
            set { endDate = value; }
        }
        public String Parkingtype
        {
            get { return parkingtype; }
            set { parkingtype = value; }
        }
        public String Contactname
        {
            get { return contactname; }
            set { contactname = value; }
        }
        public String Hourly
        {
            get { return hourly; }
            set { hourly = value; }
        }
        public String Daily
        {
            get { return daily; }
            set { daily = value; }
        }
        public String Weekly
        {
            get { return weekly; }
            set { weekly = value; }
        }
        public String Monthly
        {
            get { return monthly; }
            set { monthly = value; }
        }
        public String Yearly
        {
            get { return yearly; }
            set { yearly = value; }
        }
        public String Price
        {
            get { return price; }
            set { price = value; }
        }
        public String Pricefortime
        {
            get { return pricefortime; }
            set { pricefortime = value; }
        }

        public String Cartype
        {
            get { return cartype; }
            set { cartype = value; }
        }

        public String Manuytype
        {
            get { return manuytype; }
            set { manuytype = value; }
        }

        public String Payments
        {
            get { return payments; }
            set { payments = value; }
        }

        public String Cc
        {
            get { return cc; }
            set { cc = value; }
        }

        public String Cash
        {
            get { return cash; }
            set { cash = value; }
        }

        public String Cheak
        {
            get { return cheak; }
            set { cheak = value; }
        }

        public String Paypal
        {
            get { return paypal; }
            set { paypal = value; }
        }

        public String Lelohagbalatheshbon
        {
            get { return lelohagbalatheshbon; }
            set { lelohagbalatheshbon = value; }
        }

        public String Majsom
        {
            get { return majsom; }
            set { majsom = value; }
        }

        public String Tatkarkait
        {
            get { return tatkarkait; }
            set { tatkarkait = value; }
        }
        
        public String Jenion
        {
            get { return jenion; }
            set { jenion = value; }
        }

        public String Criple
        {
            get { return criple; }
            set { criple = value; }
        }

        public String Nolimit
        {
            get { return nolimit; }
            set { nolimit = value; }
        }

        public String Henion
        {
            get { return henion; }
            set { henion = value; }
        }

        public String Withlock
        {
            get { return withlock; }
            set { withlock = value; }
        }

        public String Underground
        {
            get { return underground; }
            set { underground = value; }
        }

        public String Roof
        {
            get { return roof; }
            set { roof = value; }
        }

        public String Vip
        {
            get { return vip; }
            set { vip = value; }
        }

        public String Toshav
        {
            get { return toshav; }
            set { toshav = value; }
        }

        public String Coupon
        {
            get { return coupon; }
            set { coupon = value; }
        }

        public String Coupon_text
        {
            get { return coupon_text; }
            set { coupon_text = value; }
        }

        public String Current_Pnuyot
        {
            get { return current_Pnuyot; }
            set { current_Pnuyot = value; }
        }

        public String SiteID
        {
            get { return siteID; }
            set { siteID = value; }
        }
        public String Heniontype
        {
            get { return heniontype; }
            set { heniontype = value; }
        }

        public String AllDayPrice
        {
            get { return allDayPrice; }
            set { allDayPrice = value; }
        }

        public String ExtraQuarterPrice
        {
            get { return extraQuarterPrice; }
            set { extraQuarterPrice = value; }
        }

        public String FirstHourPrice
        {
            get { return firstHourPrice; }
            set { firstHourPrice = value; }
        }


    }
  
}
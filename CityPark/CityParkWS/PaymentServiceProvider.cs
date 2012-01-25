using System;
using System.Collections.Generic;
using System.Web;

namespace CityParkWS
{//DataBase Table [PaymentService]: [service_name],[phone],[website],[description]
    
    public class PaymentServiceProvider
    {
        private String serviceName;
        public string Status { get; set; }

        public String ServiceName
        {
            get { return serviceName; }
            set { serviceName = value; }
        }
        private String phone;

        public String Phone
        {
            get { return phone; }
            set { phone = value; }
        }
        private String website;

        public String Website
        {
            get { return website; }
            set { website = value; }
        }
        private String description;

        public String Description
        {
            get { return description; }
            set { description = value; }
        }

        private String paymethod;
        public String Paymethod
        {
            get { return paymethod; }
            set { paymethod = value; }
        }

        private String templateStart;
        public String TemplateStart
        {
            get { return templateStart; }
            set { templateStart = value; }
        }

        private String templateEnd;
        public String TemplateEnd
        {
            get { return templateEnd; }
            set { templateEnd = value; }
        }



        public PaymentServiceProvider() { }



        
    }
}
using System;
using System.Collections.Generic;
using System.Web;
using System.Xml;
using System.Web.Services.Protocols;
using System.Net;

namespace CityParkWS
{
    public class Utils
    {

        public static SoapException RaiseException(/*HttpResponse response,*/
                                   string uri,
                                   string webServiceNamespace,
                                   string errorMessage,
                                   string errorNumber,
                                   string errorSource)
        {
            XmlQualifiedName faultCodeLocation = null;
            //Identify the location of the FaultCode
            faultCodeLocation = SoapException.ClientFaultCode;

            XmlDocument xmlDoc = new XmlDocument();
            //Create the Detail node
            XmlNode rootNode = xmlDoc.CreateNode(XmlNodeType.Element,
                               SoapException.DetailElementName.Name,
                               SoapException.DetailElementName.Namespace);
            //Build specific details for the SoapException
            //Add first child of detail XML element.
            XmlNode errorNode = xmlDoc.CreateNode(XmlNodeType.Element, "Error",
                                                  webServiceNamespace);
            //Create and set the value for the ErrorNumber node
            XmlNode errorNumberNode =
              xmlDoc.CreateNode(XmlNodeType.Element, "ErrorNumber",
                                webServiceNamespace);
            errorNumberNode.InnerText = errorNumber;
            //Create and set the value for the ErrorMessage node
            XmlNode errorMessageNode = xmlDoc.CreateNode(XmlNodeType.Element,
                                                        "ErrorMessage",
                                                        webServiceNamespace);
            errorMessageNode.InnerText = errorMessage;
            //Create and set the value for the ErrorSource node
            XmlNode errorSourceNode =
              xmlDoc.CreateNode(XmlNodeType.Element, "ErrorSource",
                                webServiceNamespace);
            errorSourceNode.InnerText = errorSource;
            //Append the Error child element nodes to the root detail node.
            errorNode.AppendChild(errorNumberNode);
            errorNode.AppendChild(errorMessageNode);
            errorNode.AppendChild(errorSourceNode);
            //Append the Detail node to the root node
            rootNode.AppendChild(errorNode);
            //Construct the exception            
            SoapException soapEx = new SoapException(errorMessage,
                                                     faultCodeLocation, uri,
                                                     rootNode);
            //Raise the exception  back to the caller
            //response.StatusCode = Int32.Parse(errorNumber);  
            return soapEx;
        }

        public String md5(String sMessage)
        {
        //     Dim x
        //Dim k
        //Dim AA
        //Dim BB
        //Dim CC
        //Dim DD
        //Dim a
        //Dim b
        //Dim c
        //Dim d
        
        //Const S11 = 7
        //Const S12 = 12
        //Const S13 = 17
        //Const S14 = 22
        //Const S21 = 5
        //Const S22 = 9
        //Const S23 = 14
        //Const S24 = 20
        //Const S31 = 4
        //Const S32 = 11
        //Const S33 = 16
        //Const S34 = 23
        //Const S41 = 6
        //Const S42 = 10
        //Const S43 = 15
        //Const S44 = 21

        //x = ConvertToWordArray(sMessage)
        
        //a = &H67452301
        //b = &HEFCDAB89
        //c = &H98BADCFE
        //d = &H10325476

        //For k = 0 To UBound(x) Step 16
        //    AA = a
        //    BB = b
        //    CC = c
        //    DD = d
        
        //    FF a, b, c, d, x(k + 0), S11, &HD76AA478
        //    FF d, a, b, c, x(k + 1), S12, &HE8C7B756
        //    FF c, d, a, b, x(k + 2), S13, &H242070DB
        //    FF b, c, d, a, x(k + 3), S14, &HC1BDCEEE
        //    FF a, b, c, d, x(k + 4), S11, &HF57C0FAF
        //    FF d, a, b, c, x(k + 5), S12, &H4787C62A
        //    FF c, d, a, b, x(k + 6), S13, &HA8304613
        //    FF b, c, d, a, x(k + 7), S14, &HFD469501
        //    FF a, b, c, d, x(k + 8), S11, &H698098D8
        //    FF d, a, b, c, x(k + 9), S12, &H8B44F7AF
        //    FF c, d, a, b, x(k + 10), S13, &HFFFF5BB1
        //    FF b, c, d, a, x(k + 11), S14, &H895CD7BE
        //    FF a, b, c, d, x(k + 12), S11, &H6B901122
        //    FF d, a, b, c, x(k + 13), S12, &HFD987193
        //    FF c, d, a, b, x(k + 14), S13, &HA679438E
        //    FF b, c, d, a, x(k + 15), S14, &H49B40821
        
        //    GG a, b, c, d, x(k + 1), S21, &HF61E2562
        //    GG d, a, b, c, x(k + 6), S22, &HC040B340
        //    GG c, d, a, b, x(k + 11), S23, &H265E5A51
        //    GG b, c, d, a, x(k + 0), S24, &HE9B6C7AA
        //    GG a, b, c, d, x(k + 5), S21, &HD62F105D
        //    GG d, a, b, c, x(k + 10), S22, &H2441453
        //    GG c, d, a, b, x(k + 15), S23, &HD8A1E681
        //    GG b, c, d, a, x(k + 4), S24, &HE7D3FBC8
        //    GG a, b, c, d, x(k + 9), S21, &H21E1CDE6
        //    GG d, a, b, c, x(k + 14), S22, &HC33707D6
        //    GG c, d, a, b, x(k + 3), S23, &HF4D50D87
        //    GG b, c, d, a, x(k + 8), S24, &H455A14ED
        //    GG a, b, c, d, x(k + 13), S21, &HA9E3E905
        //    GG d, a, b, c, x(k + 2), S22, &HFCEFA3F8
        //    GG c, d, a, b, x(k + 7), S23, &H676F02D9
        //    GG b, c, d, a, x(k + 12), S24, &H8D2A4C8A
                
        //    HH a, b, c, d, x(k + 5), S31, &HFFFA3942
        //    HH d, a, b, c, x(k + 8), S32, &H8771F681
        //    HH c, d, a, b, x(k + 11), S33, &H6D9D6122
        //    HH b, c, d, a, x(k + 14), S34, &HFDE5380C
        //    HH a, b, c, d, x(k + 1), S31, &HA4BEEA44
        //    HH d, a, b, c, x(k + 4), S32, &H4BDECFA9
        //    HH c, d, a, b, x(k + 7), S33, &HF6BB4B60
        //    HH b, c, d, a, x(k + 10), S34, &HBEBFBC70
        //    HH a, b, c, d, x(k + 13), S31, &H289B7EC6
        //    HH d, a, b, c, x(k + 0), S32, &HEAA127FA
        //    HH c, d, a, b, x(k + 3), S33, &HD4EF3085
        //    HH b, c, d, a, x(k + 6), S34, &H4881D05
        //    HH a, b, c, d, x(k + 9), S31, &HD9D4D039
        //    HH d, a, b, c, x(k + 12), S32, &HE6DB99E5
        //    HH c, d, a, b, x(k + 15), S33, &H1FA27CF8
        //    HH b, c, d, a, x(k + 2), S34, &HC4AC5665
        
        //    II a, b, c, d, x(k + 0), S41, &HF4292244
        //    II d, a, b, c, x(k + 7), S42, &H432AFF97
        //    II c, d, a, b, x(k + 14), S43, &HAB9423A7
        //    II b, c, d, a, x(k + 5), S44, &HFC93A039
        //    II a, b, c, d, x(k + 12), S41, &H655B59C3
        //    II d, a, b, c, x(k + 3), S42, &H8F0CCC92
        //    II c, d, a, b, x(k + 10), S43, &HFFEFF47D
        //    II b, c, d, a, x(k + 1), S44, &H85845DD1
        //    II a, b, c, d, x(k + 8), S41, &H6FA87E4F
        //    II d, a, b, c, x(k + 15), S42, &HFE2CE6E0
        //    II c, d, a, b, x(k + 6), S43, &HA3014314
        //    II b, c, d, a, x(k + 13), S44, &H4E0811A1
        //    II a, b, c, d, x(k + 4), S41, &HF7537E82
        //    II d, a, b, c, x(k + 11), S42, &HBD3AF235
        //    II c, d, a, b, x(k + 2), S43, &H2AD7D2BB
        //    II b, c, d, a, x(k + 9), S44, &HEB86D391
        
        //    a = AddUnsigned(a, AA)
        //    b = AddUnsigned(b, BB)
        //    c = AddUnsigned(c, CC)
        //    d = AddUnsigned(d, DD)
        //Next
        
        //MD5 = LCase(WordToHex(a) & WordToHex(b) & WordToHex(c) & WordToHex(d))
    

            return "";
        }

        public static String getGeoNamesAPI()
        {
            //HttpWebRequest myReq = (HttpWebRequest)WebRequest.Create("http://www.contoso.com/");
         
          /*  XmlDocument myXMLDocument = new XmlDocument();
            myXMLDocument.Load("http://api.geonames.org/findNearbyStreetsOSM?lat=32.089351&lng=34.770974&username=demo");
            myXMLDocument.ReadNode
            */


            String URLString = "http://api.geonames.org/findNearbyStreetsOSM?lat=32.089351&lng=34.770974&username=cityparkgeo";
            XmlTextReader reader = new XmlTextReader (URLString);

            String xml = "";
            while (reader.Read()) 
            {
                switch (reader.NodeType) 
                {
                    case XmlNodeType.Element: // The node is an element.
                        xml+=("<" + reader.Name);

                        while (reader.MoveToNextAttribute()) // Read the attributes.
                            xml += ("MoveToNextAttribute: " + reader.Name + "='" + reader.Value + "'");
                        xml += (">");
                        xml += (">");
                        break;
                    case XmlNodeType.Text: //Display the text in each element.
                        xml += ("text value:"+reader.Value);
                        break;
                    case XmlNodeType. EndElement: //Display the end of the element.
                        xml += ("</" + reader.Name);
                        xml += (">");
                        break;
                }
            }
        

            return xml;
        }

        public static String getParkingParams(String payment, String nolimit, String withlock, String tatkarkait, String roof, String toshav, String criple) 
        {
            String paramsSql = "";
            if (!"".Equals(payment))
            {
                paramsSql = " and payment=" + payment;
            }
            if (!"".Equals(nolimit))
            {
                paramsSql += " and nolimit=" + nolimit;
            }
            if (!"".Equals(withlock))
            {
                paramsSql += " and withlock=" + withlock;
            }
            if (!"".Equals(tatkarkait))
            {
                paramsSql += " and tatkarkait=" + tatkarkait;
            }
            if (!"".Equals(roof))
            {
                paramsSql += " and roof=" + roof;
            }
            if (!"".Equals(toshav))
            {
                paramsSql += " and toshav=" + toshav;
            }
            if (!"".Equals(criple))
            {
                paramsSql += " and criple=" + criple;
            }
            return paramsSql;

        }
        

    }
}
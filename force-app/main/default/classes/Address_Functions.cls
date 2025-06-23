public class Address_Functions {

  public static Boolean isNull(String s) {
  	return (s == null || s.trim().length() == 0);
  }
  
  public static List<String> convert1LineAddressto4(string addressIn) {
    List<String> addressLines = new List<String>();
    if (addressIn != null)
      {addressLines = addressIn.split('\n',4);}
           
    return addressLines;
  }

  public static String convert4LineAddressto1(List<String> addressLinesIn) {
    String address = '';
    if(addresslinesIn.size() >= 1) {if (!isNull(addressLinesIn.get(0))) address += addressLinesIn.get(0) + '\n';}
    if(addresslinesIn.size() >= 2) {if (!isNull(addressLinesIn.get(1))) address += addressLinesIn.get(1) + '\n';}
    if(addresslinesIn.size() >= 3) {if (!isNull(addressLinesIn.get(2))) address += addressLinesIn.get(2) + '\n';}
    if(addresslinesIn.size() >= 4) {if (!isNull(addressLinesIn.get(3))) address += addressLinesIn.get(3) + '\n';}

    return address;
  } 


  public static String FormatAddressforWebDisplay(List <String> addressLines, 
                                                  String city,
                                                  String state,
                                                  String zipCode,
                                                  String country) {
    return FormatAddressforWebDisplay(convert4LineAddressto1(addressLines),city,state,zipCode,country);
  }

  public static String FormatAddressforWebDisplay(String addressLines, 
                                                  String city,
                                                  String state,
                                                  String zipCode,
                                                  String country) {
  
    String addressOut = '';
    
    if (addressLines != null) {
      addressOut += String_Functions.convertCRtoBR(addressLines);
    }

    if (!isNull(addressOut)) {addressOut += '<BR>';}

    String CityStateZip = '';
    
    if (!isNull(city)) {CityStateZip += city;}
    
    if (!isNull(city) && !isNull(state)) {CityStateZip += ', ';}
    
    if (!isNull(state)) {CityStateZip += state;}
    
    if (!isNull(state) && !isNull(zipCode)) {CityStateZip += ' ';}

    if (!isNull(city) && isNull(state) && !isNull(zipCode)) {CityStateZip += ' ';}
    
    if (!isNull(zipCode)) {CityStateZip += zipCode;}
    
    if (!isNull(CityStateZip)) {CityStateZip += '<BR>';}

    addressOut += CityStateZip;

    if (!isNull(country)) {addressOut += country;}

    return addressOut;
                                                    
  }

  public static String FormatAddressforTextArea(List <String> addressLines, 
                                                String city,
                                                String state,
                                                String zipCode,
                                                String country) {
    return FormatAddressforTextArea(convert4LineAddressto1(addressLines),city,state,zipCode,country);
  }

  public static String FormatAddressforTextArea(String addressLines, 
                                                String city,
                                                String state,
                                                String zipCode,
                                                String country) {
  
    String addressOut = '';
    
    if (addressLines != null) {
      addressOut += addressLines + '\n';
    }

    String CityStateZip = '';
    
    if (!isNull(city)) {CityStateZip += city;}
    
    if (!isNull(city) && !isNull(state)) {CityStateZip += ', ';}
    
    if (!isNull(state)) {CityStateZip += state;}
    
    if (!isNull(state) && !isNull(zipCode)) {CityStateZip += ' ';}

    if (!isNull(city) && isNull(state) && !isNull(zipCode)) {CityStateZip += ' ';}
    
    if (!isNull(zipCode)) {CityStateZip += zipCode;}
    
    if (!isNull(CityStateZip)) {CityStateZip += '\n';}

    addressOut += CityStateZip;

    if (!isNull(country)) {addressOut += country;}

    return addressOut;
                                                    
  }

  public static String FormatCustomerLocation(String state, String city, String country)  {
  
    String customerLocation = '';
    if (!isNull(state)) {customerLocation = state + ', ';}              
    if (!isNull(city)) {customerLocation += city + ', ';}
    if (!isNull(country)) {customerLocation += country;}
    if (customerLocation.endsWith(', ')) {
      customerLocation = customerLocation.subString(0, customerLocation.length()-2);
    }

    return customerLocation;   
  
  }


//******************
//Test Method 
//******************

  @isTest public static void TestMe() {

  List <String> addressLines_List = convert1LineAddressto4('Line1\nLine2\nLine3\nLine4');
  List <String> addressLines_List2 = convert1LineAddressto4('');
  List <String> addressLines_List3 = convert1LineAddressto4(null);
  String addressLines_String = convert4LineAddressto1(addressLines_List);
  String location1 = FormatCustomerLocation('State', 'City', 'Country');
  String location2 = FormatCustomerLocation('State', 'City', '');  

  System.debug(FormatAddressforWebDisplay(addressLines_List,'city','state','zipcode','country'));
  System.debug(FormatAddressforWebDisplay(addressLines_String,'city','state','zipcode','country'));
  System.debug(FormatAddressforWebDisplay(addressLines_String,'city',null,'zipcode','country'));  

  System.debug(FormatAddressforTextArea(addressLines_List,'city','state','zipcode','country'));
  System.debug(FormatAddressforTextArea(addressLines_String,'city','state','zipcode','country'));
  System.debug(FormatAddressforTextArea(addressLines_String,'city',null,'zipcode','country'));
  System.debug(FormatCustomerLocation('State', 'City', 'Country'));
  System.debug(FormatCustomerLocation('State', 'City', ''));  
  
  // Customer Acocunts
  List<Account> insertAccounts = new List<Account>();
  Integer loopCount = 66;
  boolean odd = true;
  for (Integer i = 10; i < loopCount; i++)  {
     if (odd)  {
        insertAccounts.add(new Account(name='Account Test ' + i,SAP_Sales_Org__c = '1000', SAP_Street__c = 'Blazer Parkway', SAP_StreetSuppl1__c = null, SAP_StreetSuppl2__c = null, SAP_StreetSuppl3__c = null, SAP_City__c = 'Dublin', SAP_State__c = 'OH',SAP_Zip_Code__c = '90210', SAP_Country__c = 'US', type = 'Customer', SAP_DistChannel__c = '40', SAP_DivisionCode__c = '40', SAP_Dist_Channel_Desc__c = 'Valvoline', SAP_Division_Desc__c = 'Valvoline', inactive_account__c = false, SAP_Customer_Number__c = '0012345' + i, SAP_Partner_Functions__c = 'Bill To'));
        odd = false;
     }          
     else  {
        insertAccounts.add(new Account(name='Account Test ' + i,SAP_Sales_Org__c = '0312', SAP_Street__c = 'Pesetastraat 5', SAP_StreetSuppl1__c = null, SAP_StreetSuppl2__c = null, SAP_StreetSuppl3__c = null, SAP_City__c = 'Barendrecht', SAP_State__c = null,SAP_Zip_Code__c = '2991XT', SAP_Country__c = 'NL', type = 'Customer', SAP_DistChannel__c = '10', SAP_DivisionCode__c = '11', SAP_Dist_Channel_Desc__c = 'Water', SAP_Division_Desc__c = 'Drew Industrial', inactive_account__c = true, SAP_Customer_Number__c = '0012345' + i, SAP_Partner_Functions__c = 'Ship To'));
        odd = true;
     }
  }
    
  // Prospect Accounts
  List<Account> prosAcc = new List<Account>();
  for (Integer i = 10; i < loopCount; i++)  {
     if (odd)  {
        insertAccounts.add(new Account(name='Prospect Account Test ' + i,SAP_Sales_Org__c = null, SAP_Street__c = 'Blazer Parkway', SAP_StreetSuppl1__c = null, SAP_StreetSuppl2__c = null, SAP_StreetSuppl3__c = null, SAP_City__c = 'Dublin', SAP_State__c = 'OH',SAP_Zip_Code__c = '90210', SAP_Country__c = 'US', type = 'Prospect', SAP_DistChannel__c = '40', SAP_DivisionCode__c = '40', SAP_Dist_Channel_Desc__c = 'Valvoline', SAP_Division_Desc__c = 'Valvoline', inactive_account__c = false, SAP_Customer_Number__c = null, SAP_Partner_Functions__c = null, cis_prospect_status__c = 'Active'));
        odd = false;
     }          
     else  {
        insertAccounts.add(new Account(name='Prospect Account Test ' + i,SAP_Sales_Org__c = null, SAP_Street__c = 'Pesetastraat 5', SAP_StreetSuppl1__c = null, SAP_StreetSuppl2__c = null, SAP_StreetSuppl3__c = null, SAP_City__c = 'Barendrecht', SAP_State__c = null,SAP_Zip_Code__c = '2991XT', SAP_Country__c = 'NL', type = 'Prospect', SAP_DistChannel__c = '10', SAP_DivisionCode__c = '11', SAP_Dist_Channel_Desc__c = 'Water', SAP_Division_Desc__c = 'Drew Industrial', inactive_account__c = false, SAP_Customer_Number__c = null, SAP_Partner_Functions__c = null, cis_prospect_status__c = 'Inactive'));
        odd = true;
     }
  }
   
  // Marked for Deletion Acocunts. Just upload 2. To make sure that Bulk Processing works.
  List<Account> mfdAcc = new List<Account>();
  for (Integer i = 10; i < 12; i++)  {
     if (odd)  {
        insertAccounts.add(new Account(name='Account Test ' + i,SAP_Sales_Org__c = '1000', SAP_Street__c = 'Blazer Parkway', SAP_StreetSuppl1__c = null, SAP_StreetSuppl2__c = null, SAP_StreetSuppl3__c = null, SAP_City__c = 'Dublin', SAP_State__c = 'OH',SAP_Zip_Code__c = '90210', SAP_Country__c = 'US', type = 'Marked for deletion', SAP_DistChannel__c = '40', SAP_DivisionCode__c = '40', SAP_Dist_Channel_Desc__c = 'Valvoline', SAP_Division_Desc__c = 'Valvoline', inactive_account__c = false, SAP_Customer_Number__c = '0012345' + i, SAP_Partner_Functions__c = 'Bill To'));
        odd = false;
     }          
     else  {
        insertAccounts.add(new Account(name='Account Test ' + i,SAP_Sales_Org__c = '0312', SAP_Street__c = 'Pesetastraat 5', SAP_StreetSuppl1__c = null, SAP_StreetSuppl2__c = null, SAP_StreetSuppl3__c = null, SAP_City__c = 'Barendrecht', SAP_State__c = null,SAP_Zip_Code__c = '2991XT', SAP_Country__c = 'NL', type = 'MArked for Deletion', SAP_DistChannel__c = '10', SAP_DivisionCode__c = '11', SAP_Dist_Channel_Desc__c = 'Water', SAP_Division_Desc__c = 'Drew Industrial', inactive_account__c = true, SAP_Customer_Number__c = '0012345' + i, SAP_Partner_Functions__c = 'Ship To'));
        odd = true;
     }
  }
  insert(insertAccounts);     
  
  SAP_Sales_Org_Lookup_Functions.populateSAP_Sales_Orgs();
  System.debug(SAP_Sales_Org_Lookup_Functions.lookup_Region_from_Sales_Org('0441'));
  List<String> salesOrgs = new List<String>();
  salesOrgs.add('0441');
  System.debug(SAP_Sales_Org_Lookup_Functions.lookup_Region_from_Sales_Org(salesOrgs));
  System.debug(String_Functions.convertBRtoCR('This is a <BR>TEST'));
  System.debug(String_Functions.removeLeadingZeros('0000test'));
  System.debug(String_Functions.trimAllStringsinListString(salesOrgs));
  List<String> test = new List<String>();
  test.add('Line 1 ');
  test.add('Line 2 ');  
  System.debug(String_Functions.Format_ListString_into_HTML_List(test, 'prefix:', ':suffix'));
  System.debug(String_Functions.Format_ListString_into_HTML_List('test', 'prefix:', ':suffix'));  
  
  
  }

//The End
}
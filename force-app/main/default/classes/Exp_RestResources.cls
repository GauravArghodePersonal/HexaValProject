/*

Author:Aakash Wankhede

Created Date: 5th June 2023

Last Modified On: 14th June 2023

Description: Rest Resource to validate user details (like account number) collected from azure b2c
Azure will call this API during user registration to validate account number (Sold To/Ship To)
*/
@RestResource(urlMapping='/validateAzureUserRegDetails')
global with sharing class Exp_RestResources {
    @HttpPost
    global static ResponseWrapper validateAzureUserDetails(String extension_SalesForceAccountNumber) {
        ResponseWrapper response = new ResponseWrapper();
        List<Account> accountList = [Select Id,Name, AccountNumber,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,SAP_Zip_Code__c From Account Where AccountNumber = :extension_SalesForceAccountNumber and type='Customer' and (SAP_Partner_Functions__c like '%Sold to%' OR SAP_Partner_Functions__c like '%Ship to%') ];
        if(accountList.isEmpty()){
            response.accountStatus='Invalid';
        }
        else{
            response.accountStatus= 'Valid';
        }
        return response;
    }
    global class ResponseWrapper{
        public String accountStatus;
    }
}
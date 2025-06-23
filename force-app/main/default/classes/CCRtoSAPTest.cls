@isTest
private class CCRtoSAPTest {
    
    @isTest static void CCRtoSAPTest01(){
        
        User user= TestDataFactory.createUser(false, 'solenis@test.com', 'empId');
        user.SAP_Cust_Num__c = '000020880222288';
        insert user;
        user.SAP_Cust_Num__c = '000020880222288';
        update user;
        Account Acc= TestDataFactory.createAccount(False);
        acc.ParentId = null;
        acc.Sap_partner_functions__c = 'Sold To,Ship To';
        Insert Acc;
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(false, Acc.Id);
        ccr.CCR_Sales_Organization__c = 'Solenis LLC(1020)';
       // ccr.Currency__c  = 'USD';
       // ccr.CCR_Sales_District__c = 'RSD IWT NA (IWNA1)';
        ccr.Account_Owner__c= user.Id;
      //  ccr.CCR_Sales_Office__c = 'IWT NA CENTRAL (IW35)';
      //  ccr.Sales_Group__c = 'IWT NA SUPERIOR (33I)';
        ccr.CCR_DIst_Channel__c = 'AHWT (10)';
        ccr.CCR_Division__c = 'AHWT (11)';
    //    ccr.CCR_Customer_Group__c = 'DIRECT SALE (501)';
      //  ccr.CCR_Customer_Group2__c = 'IWT PRINTING&WRITING (176)';
       // ccr.CCR_Customer_Group1__c = 'AM CALGARY (116)';
      //  ccr.Customer_Group_3__c = 'MUNI-OPERATING CO (134)';
        ccr.Country__c = 'United States (US)';
        ccr.Currency__c = 'USD';
        ccr.State_Region__c = 'SA-South Australia';
        ccr.Incoterms__c = 'CFR - Cost and Freight';
        ccr.Street_Number__c = '24A KIDRICEVA';
        ccr.City__c = 'CELJE';
        ccr.Postal_Code__c = '3000';
        ccr.Change_Request__c = TRUE;
        ccr.CurrencyIsoCode = 'USD';
        ccr.Account_Owner__c= user.Id;
        insert ccr;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseCCRtoSAP());
        Test.stopTest();
        //CCRtoSAP.CalloutToDellBoomi(ccr.Id);
        String response = '';
        try{
            system.debug('ccr='+ccr);
            String responce=CCRtoSAP.CalloutToDellBoomi(ccr.Id);
        }
        catch(Exception e) {
            System.debug('ERROR: '+ e.getMessage());
            response = e.getMessage();  
        }
        
        //HttpResponse res = CCRtoSAP.CalloutToDellBoomi(ccr.Id);
 
    }

}
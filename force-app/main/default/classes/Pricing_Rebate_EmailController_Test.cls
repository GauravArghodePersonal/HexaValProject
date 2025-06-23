@isTest
private class Pricing_Rebate_EmailController_Test{
    @isTest static void Pricing_Rebate_EmailControllermethod (){
        List<Pricing_Rebate__c> pr = new List<Pricing_Rebate__c>();
        Pricing_Rebate__c price = new Pricing_Rebate__c();
        price.Condition_Type__c = 'Z021 - Cust/MatlReb%/Val';
        price.Dist_Channel__c = '10';
        price.Dist_Channel_Description__c = 'AHWT';
        price.Division__c = '11';
        price.Division_Description__c ='AHWT';
        price.Internal_Comments__c = 'none';
        price.Rebate_Agreement_Type__c = 'Z020 - Cust/Matl Rebate';
        price.Rebate_End_Date__c = Date.newInstance(2017, 12, 9);
        price.Rebate_Recipient_account_number__c = '0000475883';
        price.Rebate_Start_Date__c = Date.newInstance(2016, 12, 9);
        price.Sales_Org__c = '0490';
        price.Sales_Org_Description__c = 'Solenis Germany GmbH';
        price.SAP_Rebate_Agreement_Number__c = '23555';
        price.Status__c = 'Approved';
        pr.add(price);
        insert pr;
        String pricing_Rebate_Id = price.id;
        Pricing_Rebate_Detail__c  price1 = new Pricing_Rebate_Detail__c();
        price1.Accrual__c = 5.00;
        price1.Amount__c = 5.00;
        price1.Approved_Rebate__c = true;
        price1.Change_Tracker__c = 'New';
        price1.MFD__c = true;
        price1.Per__c = 1;
        price1.Table__c = 'Test';
        price1.Unit__c = 'Test';
        price1.UoM__c  = 'Test';
        insert price1;
        Pricing_Rebate_EmailController controller = new Pricing_Rebate_EmailController(); 
        controller.getDetail();
        controller.getHeader();
    }
}
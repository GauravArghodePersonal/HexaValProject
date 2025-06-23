public class AccountDeliveryCitiesExtension {

public Account Acct;
public list<Delivery_Cities__c> DC{get; set;}
public integer dcsize{get;set;}

    public AccountDeliveryCitiesExtension(ApexPages.StandardController controller) {
       Acct = (Account)Controller.getRecord();
       DC = new list<Delivery_Cities__c>();
       Acct = [select id, SAP_City__c,  SAP_State__c, SAP_Zip_Code__c, SAP_ShippingPlant__c from Account where id = :Acct.id limit 1];
       DC = [select id, state__c, Account__c, Account__r.id, Account__r.name, Account__r.site, name, default_plant__c, ship__c, mon__c, tues__c, wed__c, thur__c, fri__c from Delivery_Cities__c where (zip__c = :Acct.SAP_Zip_Code__c) or (state__c = :Acct.SAP_State__c and name = :Acct.SAP_City__c)];   
       dcsize=dc.size();
    }

}
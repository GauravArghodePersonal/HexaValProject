public class UpdateTankReq
{
    private final Tank_Requirement__c tankReq;
    
    public Tank_Requirement__c tr;
       
    public UpdateTankReq(ApexPages.StandardController stdController) 
    {
        this.tankReq = (Tank_Requirement__c) stdController.getRecord();
        
        tr = [Select Id, Name, Contact__c, Contact_Phone__c, Customer_Prospect__c, Address_Line_1__c, Address_Line_2__c, Address_Line_3__c, Address_Line_4__c, City__c, State__c, Postal_Zip_Code__c, Country__c, Customer_Prospect_Number__c from Tank_Requirement__c where Id =: tankReq.Id];

    }
    
    public PageReference updateAccCon()
    {
        
        String accNumber;
                        
        tr.Contact_Phone__c = [Select Id, Name, Phone from Contact where Id =: tr.Contact__c].Phone;
        
        Account acc = [Select Id, Name, RecordTypeId, RecordType.Name, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_StreetSuppl3__c, SAP_City__c, SAP_State__c, SAP_Zip_Code__c, SAP_Country__c, SAP_Customer_Number__c, CIS_Prospect_Number__c, Type from Account where Id =: tr.Customer_Prospect__c];
        tr.Address_Line_1__c = acc.SAP_Street__c;
        tr.Address_Line_2__c = acc.SAP_StreetSuppl1__c;
        tr.Address_Line_3__c = acc.SAP_StreetSuppl2__c;
        tr.Address_Line_4__c = acc.SAP_StreetSuppl3__c;
        tr.City__c = acc.SAP_City__c;
        tr.State__c = acc.SAP_State__c;
        tr.Postal_Zip_Code__c = acc.SAP_Zip_Code__c;
        tr.Country__c = acc.SAP_Country__c;
        
        if(acc.RecordType.Name.indexOf('Customer')>-1)
        accNumber = acc.SAP_Customer_Number__c;
        else if(acc.RecordType.Name.indexOf('Prospect')>-1)
        accNumber = acc.CIS_Prospect_Number__c;
        else accNumber = acc.SAP_Customer_Number__c;
        
        tr.Customer_Prospect_Number__c = accNumber;
        update tr;
        return null;
    }
}
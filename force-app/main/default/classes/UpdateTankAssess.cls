public class UpdateTankAssess
{
    private final Tank_Inspection__c tankAssess;
    
    public Tank_Inspection__c ta;
       
    public UpdateTankAssess(ApexPages.StandardController stdController) 
    {
        this.tankAssess = (Tank_Inspection__c) stdController.getRecord();
        
        ta = [Select Id, Name, Customer_Prospect__c, Address_Line_1__c, Address_Line_2__c, Address_Line_3__c, Address_Line_4__c, City__c, State__c, Postal_Zip_Code__c, Country__c from Tank_Inspection__c where Id =: tankAssess.Id];

    }
    
    public PageReference updateAccInfo()
    {
        
        String accNumber;
                        
        Account acc = [Select Id, Name, RecordTypeId, RecordType.Name, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_StreetSuppl3__c, SAP_City__c, SAP_State__c, SAP_Zip_Code__c, SAP_Country__c, SAP_Customer_Number__c, CIS_Prospect_Number__c, Type from Account where Id =: ta.Customer_Prospect__c];
        ta.Address_Line_1__c = acc.SAP_Street__c;
        ta.Address_Line_2__c = acc.SAP_StreetSuppl1__c;
        ta.Address_Line_3__c = acc.SAP_StreetSuppl2__c;
        ta.Address_Line_4__c = acc.SAP_StreetSuppl3__c;
        ta.City__c = acc.SAP_City__c;
        ta.State__c = acc.SAP_State__c;
        ta.Postal_Zip_Code__c = acc.SAP_Zip_Code__c;
        ta.Country__c = acc.SAP_Country__c;
        
        update ta;
        return null;
    }
}
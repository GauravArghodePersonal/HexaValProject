/**
 * *********************** Revision History ***************************
 * @description setup method to arrange data using contruct code
 * [SL-10]:Lookup Sections: Lookup to Objects and populate values based on those objects
 * Flow: CQ_SL_Complaint_Set_Sales_Orders_AL_Flow
 * *********************** Revision History ***************************
 */
@isTest
public without sharing class CQ_SL_Test_Open_Orders_Factory implements CQ_SL_Test_SObject_Factory{
    //Commit values
    public static final Boolean NO_COMMIT_DB=TRUE,
                                COMMIT_DB=FALSE;
    /**
     * @description Method to Construct Data
     * @param dataCode
     * @return Map
     */
    public Map<String, SObject> constructData(String dataCode){
        switch on dataCode{
            when 'createOpenOrder'{ createOpenOrder(COMMIT_DB); }
        }
        return new  Map<String,SObject>();
    }
    
     
    /**
     * @description Method to Construct Data
     * @param noCommitToDb
     * @return assignment  Record
     */
    public static Open_Orders__c createOpenOrder(Boolean noCommitToDb){
        User stdUser1 = [SELECT Id FROM User WHERE FirstName =: 'Standard User 1' LIMIT 1];
        
        //Account Creation
        Account rec=new Account(); 
        rec.Name = 'Test Account 2';
        rec.recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('DrewCustomer').getRecordTypeId();
        rec.SAP_Zip_Code__c = '43081';
        rec.Account_Sales_Potential_Amount_Year__c = 52;
        rec.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        rec.Prospect_Dist_Channel__c = 'AHWT (10)';
        rec.Prospect_Division__c = 'AWT (11)';
        rec.Prospect_Sales_District__c = 'RSD IWT NA (IWNA1)';
        rec.Prospect_Sales_Office__c = 'DM  IWT NA CENTRAL (IW35)';
        rec.Prospect_Sales_Group__c = 'IWT NA ARKLATEX (27I)';
        rec.Prospect_Customer_Group__c = 'POWER (1J)';
        rec.Prospect_Customer_Group1__c = 'THIRD PARTY PRODUCER (510)';
        rec.Prospect_Customer_Group2__c = 'PWR-Coal (191)';
        rec.Related_to_Corporate__c = 'No';
        rec.SAP_Account_Name_2__c = rec.Name;
        rec.AccountNumber = '123';
        rec.SAP_Customer_Group_2_Desc__c = 'ADD-ADHESIVES';
        rec.SAP_Customer_Group_Desc__c = 'ADDITIVES';
        rec.SAP_DistChannel__c = '10';
        rec.SAP_Dist_Channel_Desc__c = 'AHWT';
        rec.SAP_DivisionCode__c = '11';
        rec.SAP_Division_Desc__c = 'AHWT';
        rec.SAP_Sales_Org__c = '1020';
        rec.SAP_Sales_Org_Desc__c = 'Solenis';
        rec.Account_Number__c = rec.Name + rec.SAP_Sales_Org__c + rec.SAP_DistChannel__c + rec.SAP_DivisionCode__c;
        Account rec2 = rec.clone(false, false, false, false);
        rec2.Hours_of_Access__c='9 to 17';
        rec2.PPE_Requirements__c='Ear Plugs';
        rec2.Site_Access__c='BackGround Check';
        List<Account>acLst = new List<Account>();
        acLst.add(rec);
        acLst.add(rec2);
        insert acLst;
        acLst.clear();
        rec.Hours_of_Access__c='9 to 17';
        rec.PPE_Requirements__c='Ear Plugs';
        rec.Site_Access__c='BackGround Check';
        acLst.add(rec);
        update acLst;
        
       //Arrange Open Orders 
        Open_Orders__c open = new Open_Orders__c();
        open.Sales_Order_Number__c ='TestOpenOrder';
        open.ShipTo__c=rec.Id;
        open.Line_Item_Number__c='test1';
        open.Key__c ='test';
        
        if(!noCommitToDb){
            insert open;
        }        
        return open; 
    }
}
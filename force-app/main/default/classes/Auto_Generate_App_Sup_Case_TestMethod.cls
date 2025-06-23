@isTest
private class Auto_Generate_App_Sup_Case_TestMethod
{
    static testMethod void testWaterOpportunity()
    {
        //Getting RecordTypeId for Water Prospect Account
        String accRecordTypeId = RecordType_Functions.LookupRecordTypeId('Water Prospect', 'Account');

        //Getting RecordTypeId for Performance Materials & Water Contact
        //String conRecordTypeId1 = RecordType_Functions.LookupRecordTypeId('Performance Materials', 'Contact');
        String conRecordTypeId2 = RecordType_Functions.LookupRecordTypeId('Water Contact', 'Contact');

        //Getting RecordTypeId for Water Opportunity
        //String oppRecordTypeId = RecordType_Functions.LookupRecordTypeId('Water Opportunity', 'Opportunity');
        String oppRecordTypeId = RecordType_Functions.LookupRecordTypeId('Water Opportunity non G3', 'Opportunity');
        //Setting the date/datetime values for use
        Date today = Date.Today();
        DateTime now = DateTime.Now();
        DateTime yest = now.addDays(-1);

        //Getting the UserId of 'acfriend' for Application Support Engineer
        Id appSuppEngg = User_Functions.LookupActiveUserbyFullName('acfriend');

        //Inserting a test Water Prospect Account
        Account acct1 = new Account();
        acct1.RecordTypeId = accRecordTypeId;
        acct1.Name = 'Test1 Account';
        acct1.SAP_Division_Desc__c = 'Water Technology';
        acct1.SAP_Sales_District_Desc__c = 'AMERICAS';
        acct1.SAP_Sales_Office_Desc__c = 'RBT CENTRAL US';
        acct1.SAP_Sales_Group_Desc__c = 'LCT GREAT LAKES';
        acct1.SAP_Customer_Group_Desc__c = 'CHEMICALS';
        acct1.SAP_Customer_Group_1_Desc__c = 'DIRECT SALE';
        acct1.SAP_Customer_Group_2_Desc__c = 'CHEM-ALL OTHER';
        insert acct1;

        //List to hold all the Contacts
        List<Contact> cons = new List<Contact>();

        //Creating a test Performance Materials Contact
        /*Contact con1 = new Contact();
        con1.RecordTypeId = conRecordTypeId1;
        con1.Salutation = 'Mr.';
        con1.FirstName = 'Test';
        con1.LastName = 'Test1 Contact';
        con1.AccountId = acct1.Id;
        con1.T_Role__c = 'Executive';
        con1.Phone = '6473828354';
        con1.Email = 'abc@mail.com';
        con1.MobilePhone = '8376456457';
        //
        cons.add(con1);*/

        //Creating a test Performance Materials Contact
        Contact con2 = new Contact();
        con2.RecordTypeId = conRecordTypeId2;
        con2.Salutation = 'Mr.';
        con2.FirstName = 'Test';
        con2.LastName = 'Test2 Contact';
        con2.AccountId = acct1.Id;
        con2.W_Decision_Maker_Type__c = 'Decision Maker';
        con2.Phone = '7854515654';
        con2.Email = 'pqr@mail.com';
        con2.MobilePhone = '2454126214';
        //
        cons.add(con2);

        //Inserting the list of test contacts
        insert cons;

        //Inserting a test Competitor
        Competitor__c comp = new Competitor__c();
        comp.Name = 'Test Competitor';
        insert comp;

        //List to hold all the Opportunities
        List<Opportunity> opptys = new List<Opportunity>();

        //Inserting a test Water Opportunity with Application Support Engineer with value
        Opportunity opp1 = new Opportunity();
        opp1.RecordTypeId = oppRecordTypeId;
        opp1.Name = 'Test1 Opportunity';
        opp1.AccountId = acct1.Id;
        opp1.Annualized_Gross_Profit_GP__c = 20000;
        opp1.CloseDate = today;
        opp1.StageName = 'Discovering/Value Proposition';
        opp1.Application_Support_Manager__c = 'EMEA IWT & P&P Equipment Engineering projects - Clive Jenkins';
        opp1.Application_Support_Engineer__c = '00550000006zvQM';
        opp1.Primary_Competitor__c = comp.Id;
        opp1.Opportunity_Type__c = 'Price';
        opp1.ASR_Pending__c=false;
        opp1.ASR_Approval__c =false;
        opp1.Application_Support_Requested__c=true;
        opptys.add(opp1);
        
        Opportunity opp2 = new Opportunity();
        opp2.RecordTypeId = oppRecordTypeId;
        opp2.Name = 'Test1 Opportunity';
        opp2.AccountId = acct1.Id;
        opp2.Annualized_Gross_Profit_GP__c = 20000;
        opp2.CloseDate = today;
        opp2.StageName = 'Discovering/Value Proposition';
        opp2.Application_Support_Manager__c = 'EMEA IWT & P&P Equipment Engineering projects - Clive Jenkins';
        opp2.Application_Support_Engineer__c = '00550000006zvQM';
        opp2.Primary_Competitor__c = comp.Id;
        opp2.Opportunity_Type__c = 'Price';
        opp2.ASR_Pending__c=false;
        opp2.ASR_Approval__c = false;
        opp2.Application_Support_Requested__c =false;
        opptys.add(opp2);
        insert opptys;
        unlockOpportunity.invocableUnlock(opptys);
        opptys.clear();
        Test.startTest();
        try{
            //opp1.Opportunity_Status__c = 'Application Support Request Approved';
            opp1.Opportunity_Type__c = 'Price';
            opp2.ASR_Pending__c=true;
            opptys.add(opp1);
            opp2.Application_Support_Requested__c =true;
            opp2.Opportunity_Status__c = 'Application Support Request Approved';
            opptys.add(opp2);
            update opptys;
            unlockOpportunity.invocableUnlock(opptys);
        }
        catch(Exception e){
            System.debug('Exception'+e);
        }
        
        Test.stopTest();
    }

}
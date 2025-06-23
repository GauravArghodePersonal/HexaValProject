@isTest
private class OpportunityExtension_Test
{
    static Opportunity opp;
    static Account acct;
    static Competitor__c com;
    static Contact con;
    static User user;
    static List<Opportunity_Material__c> oms;

    static String sorg = '1021';
    static String dchan = '50';
    static String mnum1 = 'MatNum1';
    static String mnum2 = 'MatNum2';
    static Material_Sales_Data2__c mat1;
    static List<Material_Sales_Data2__c> msd2s;
    static List<OpportunityExtensionV3.MaterialSearchWrapper> mswlist;
    static OpportunityExtensionV3 c;
    
    static void debug(String s) {System.debug(LoggingLevel.INFO, s);}

    static void CreateData() {
        RecordType pmRecType = [Select Id From RecordType WHERE SobjectType = 'Account' AND (Name LIKE '%Performance%') AND isActive = true LIMIT 1];
        acct = TestObjects.newAccount(new Map<String,String>{'RecordTypeId'=>pmRecType.Id,'SAP_Division_Desc__c'=>'Castings Solutions'});
        //acct = TestObjects.newAccount(true);
        con = TestObjects.newContact(true);
        user = TestObjects.newUser(true);
        com = TestObjects.newCompetitor(true);
        
        Date date1 = Date.today().addDays(30);
        Date date2 = Date.today().addDays(60);
        
        opp = TestObjects.newOpportunity(getOppFieldValues());
        opp.Actual_Decision_Date__c = date1;
        opp.CloseDate = date1;
        opp.Expected_Revenue_Date__c = date2;
        opp.Coach_Champion_Contact__c = con.Id;
        opp.Evaluator_Formulator_Contact__c = con.Id;
        opp.Value_Descision_Maker_Economic_Buyer_Con__c = con.Id;
        opp.Current_Year_Revenue_in_Plan__c = 1000;
        opp.Current_Year_Revenue_Above__c = 1000;
        opp.Type__c = 'OppType1';
        update opp;
        debug('opp = ' + opp);
        
        List<String> mnums = new List<String>{mnum1, mnum2};
        msd2s = Material_Sales_Data_Functions_Test.getTestMsd2s(sorg, dchan, mnums);
        mat1 = msd2s[0]; debug('mat1 = ' + mat1);
    }
    
    static void setup2() {
        CreateData(); 
        
        Opportunity_Material__c om;
        oms = new List<Opportunity_Material__c>();
        for (Material_Sales_Data2__c msd2 : msd2s) {
            om = new Opportunity_Material__c();
            om.Opportunity__c = opp.Id; om.Material__c = msd2.Id;
            om.Material__r = msd2;
            om.Quantity__c = 2; om.Sales_Price__c = 5;
            om.CurrencyIsoCode = opp.CurrencyIsoCode;
            //om.Unit_of_Measure__c = 'LB'; 
            oms.add(om);
        }
        //debug('msd2s = ' + msd2s);
        //debug('oms = ' + oms);
        insert oms;
        
        
        //ApexPages.StandardController sc = new ApexPages.StandardController(opp); 
        ApexPages.StandardController sc ;
        ApexPages.currentPage().getParameters().put('debug', 'true');
        c = new OpportunityExtensionV3(sc);   
        c.initAction1(); c.materialNumber = mnum1;
    }
    
    static Map<String, String> getOppFieldValues() {
        Id currencyId;
        string currencyCode;
            
        for (CurrencyType curType:[Select c.Id, c.IsoCode 
                                     From CurrencyType c Where IsoCode = 'USD' Limit 1] ) {
            currencyId = curType.Id; currencyCode = curType.IsoCode;
        }        
        
        Schema.DescribeSObjectResult oppSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> OppRecordTypeInfo = oppSchema .getRecordTypeInfosByName(); 
        Id OppRecordTypeId = OppRecordTypeInfo.get('Water Opportunity').getRecordTypeId()    ;          
              
        Map<String, String> OppFieldValues = new Map<String, String> {
                'Name' => 'TestOpp2',
                'AccountId' => acct.Id,
                'Contact__c' => con.Id,
                'Region__c' => 'NA',
                'CurrencyIsoCode' => currencyCode,
                'Business_Segment__c' => 'Hair Care',
                'OwnerId' => user.Id,
                'SBU__c' => 'CMC',
                'PAC_Description__c' => 'PAC',
                'Result_Reason__c' => 'Reason',
                'Primary_Competitor__c' => com.id,
                'Contact__c' => con.id,
                'StageName' => 'Stage 1',
                'Opportunity_Status__c' => 'Open',
                'RecordTypeId' => OppRecordTypeId};
            
        return OppFieldValues;      
    }     

//*
    static testMethod void test01() {
        setup2(); Test.startTest();
        c.opp.CloseDate = null;
        c.opp.Expected_Revenue_Date__c = null;
        c.opp.Current_Year_Revenue_in_Plan__c = null;
        c.opp.Current_Year_Revenue_Above__c = null;
        c.opp.Name = null;
        c.opp.StageName = null;
        c.opp.AccountId = null;
        c.opp.CurrencyIsoCode = null;
        c.opp.Opportunity_Status__c = null;
        c.opp.PAC_Description__c = null;
        c.opp.SBU__c = null;
        c.opp.Primary_Competitor__c = null;
        c.opp.Contact__c = null;
        c.opp.Result_Reason__c = null;
        c.opp.Actual_Decision_Date__c = null;
        c.save();
    }
    
    static testMethod void test02() {
        setup2(); c.save();
    }
    
    static testMethod void test03() {
        CreateData(); Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(opp); 
        c = new OpportunityExtensionV3(sc);   
        
        c.initAction1();
        
        c.SAPSalesOrg = sorg;
        c.SAPDistChannel = dchan;
        c.materialNumber = 'MatNum';
        c.defaultSearchForMaterialSelector();
        c.searchMaterials();
        mswlist = c.getMaterialList();
        for (OpportunityExtensionV3.MaterialSearchWrapper msw : mswlist) {msw.addToOpp = true;}
        c.addMaterialsToOpp();
        c.deleteMaterials();
        c.addMaterialsToOpp();
    }
//*/

    static testMethod void test04() {
        setup2(); Test.startTest();
        c.CalculateWeightedAbovePlanRevenueThisYear(); c.CalculateAQRevenueLocal();
        c.prodHierarchy5 = 'abc-123'; c.prodHierarchy6 = 'def-456'; c.defaultSearchForMaterialSelector(); 
        c.prodHierarchy5 = null; c.prodHierarchy6 = null; c.searchMaterials();
        c.getMaterialList(); c.cancelMaterialSelector(); c.clearMaterialSelector(); c.searchMaterial();
        c.setPacIndustry(); c.updateOppStageOnOverride(); c.OverrideStageOnChange();
        c.getVCPRatingField(); c.updateVCPRating(); c.getRecordTypeId(); c.getRecordTypeName();
        c.redirect(); c.cancel(); c.customSave();
        c.ContactOnChangeEvent(); c.CoachOnChangeEvent(); c.EvaluatorOnChangeEvent();
        c.EconBuyerOnChangeEvent(); c.CompetitorOnChangeEvent(); c.CompLostWonOnChangeEvent();
        c.AcctEndCUOnChange();
        c.opp.Type__c = 'Test'; c.ShowHideStages(); 
        c.opp.Type__c = 'Price Increase'; c.ShowHideStages(); 
        c.opp.Opportunity_Status__c = 'Won'; c.OpportunityStatusChange();
        c.opp.Opportunity_Status__c = 'Lost'; c.OpportunityStatusChange();
    }

//*
    static testMethod void test05() {
        setup2(); Test.startTest();
        c.searchContacts(); c.cancelSearchContacts(); c.getContacts();
        c.searchCoaches(); c.cancelSearchCoaches(); c.getCoaches();
        c.searchEvaluators(); c.cancelSearchEvaluators(); c.getEvaluators();
        c.searchEconBuyers(); c.cancelSearchEconBuyers(); c.getEconBuyers();
        c.searchCompetitors(); c.cancelSearchCompetitors(); c.getCompetitors();
        c.searchCompsLostWon(); c.cancelSearchCompsLostWon(); c.getCompsLostWon();
    }
        
    static testMethod void test06() {
        setup2(); Test.startTest();
        c.GetNumOfMonthsRange(1); c.GetNumOfMonthsRange(5); c.GetNumOfMonthsRange(7);
        c.GetNumOfMonthsRange(15); c.GetNumOfMonthsRange(20); c.GetNumOfMonthsRange(25);
        c.GetProjectSenseOfUrgencyNoScoreRecalc();
        c.GetProjectSenseOfUrgency();
        
        c.opp.ISP_Resources_Required__c = 'Not Required'; 
        c.OnAshlandResReqChangeNoScoreReCalc();
        
        c.opp.ISP_Resources_Required__c = 'PIDA (confidentiality agreement) Only'; 
        c.OnAshlandResReqChangeNoScoreReCalc();
        
        c.opp.ISP_Resources_Required__c = 'TSR'; 
        c.OnAshlandResReqChangeNoScoreReCalc();
        
        c.opp.ISP_Resources_Required__c = 'INNOVA Project'; 
        c.OnAshlandResReqChangeNoScoreReCalc();
        
        c.opp.ISP_Resources_Required__c = 'Test'; 
        c.OnAshlandResReqChangeNoScoreReCalc();
        
        //c.GetSalesPotentialRangeFor(100, opp.Customer_Group__c, opp.CurrencyIsoCode );
    }
//*/
        
}
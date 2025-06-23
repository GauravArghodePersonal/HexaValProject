@isTest
private class Opportunity_Functions_Test {
    
    static Map<String, String> OPP_RT_MAP = RecordType_Functions.RetrieveRecordTypeNameMap('Opportunity');

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
    static List<Material_Sales_Data2__c> msd2s;
    static Material_Sales_Data2__c mat1;

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Opportunity_Functions_Test : ' + s);
    }

    static testMethod void test01() {
        Test.startTest();
        Opportunity op = createOppMaterial();
        op.Amount = op.Amount + 10.0;
        op.RecordTypeId = OPP_RT_MAP.get('Water Opportunity');
        op.Project_Type__c = 'Growth Project';
        op.StageName = 'Stage2';
        update op;
        op.StageName = 'Stage3';
        update op;
        Test.stopTest();
    }
    
    static testMethod void test02() {
        Opportunity_Functions.getOpportunityStageMap();
    }
    
    static testMethod void test03()
    {
        system.debug(Opportunity_Functions.GetOppRatingToReachStage2());
        system.debug(Opportunity_Functions.GetOppRatingToReachStage3());
        Opportunity_Functions.GetOppRatingToReachStage4();

    }
    
    static testMethod void CalculateRatings()
    {
        List<string> Stage1Fields = new List<string> 
            {'Client_has_Need_Interest_for_Prod_Sol__c', 'Lead_Source__c', 'VCP_Rating__c', 'Project_Sense_of_Urgency__c'}  ;
                    
        CreateData();
        opp.Customer_Group__c = '58';
        opp.Sales_Office__c = '5101';
        Opportunity_Functions.CalculateRatings(opp);
        Opportunity_Functions.SetWeightedOpportunityRevenueValue(opp);
        Opportunity_Functions.GetOppRatingConfigScoreFor(opp, 'VCP_Rating__c', 'A');
        Opportunity_Functions.FindStageFieldsTotalRatings(Stage1Fields, opp);
        Opportunity_Functions.CalculateRatingsFromUI(opp);

    }
    
    static Opportunity createOppMaterial() {
        Map <String, ID>RTMap = RecordType_Functions.RetrieveRecordTypeNameMap('Opportunity_Material__c');
        Id omrt = RTMap.get('AQ Opportunity Material');
        Id oprt = OPP_RT_MAP.get('Water Opportunity');
        Date cdate = Date.today().addDays(30);
        Opportunity op = new Opportunity(Name='TestOp',StageName='Open',Amount=10.0,
                                         RecordTypeID=oprt,CloseDate=cdate);
        op.Project_Type__c = 'Target';
        insert op;

        oms = new List<Opportunity_Material__c>();
        oms.add(getOpportunityMaterial(op, omrt, 'KG'));
        oms.add(getOpportunityMaterial(op, omrt, 'LB'));
        insert oms;
        return op;
    }
    
    static Opportunity_Material__c getOpportunityMaterial(Opportunity op,
                                                          Id rectype, 
                                                          String uom) {
        Opportunity_Material__c om = new Opportunity_Material__c();
        om.Opportunity__c = op.Id;
        om.Sales_Price__c = 100.0;
        om.Quantity__c = 10.0;
        om.RecordTypeID = rectype;
        om.Unit_of_Measure__c = uom;
        return om;
    }
    
    static void CreateData() {

        Date date1 = Date.today().addDays(30);
        Date date2 = Date.today().addDays(60);
                
        RecordType pmRecType = [Select Id From RecordType WHERE SobjectType = 'Account' AND (Name LIKE '%Performance%') AND isActive = true LIMIT 1];
        acct = TestObjects.newAccount(new Map<String,String>{'RecordTypeId'=>pmRecType.Id,'SAP_Division_Desc__c'=>'Castings Solutions'});
        con = TestObjects.newContact(true);
        user = TestObjects.newUser(true);
        com = TestObjects.newCompetitor(true);

        opp = TestObjects.newOpportunity(getOppFieldValues());
        opp.Current_Year_Revenue_in_Plan__c = 1000;
        opp.Current_Year_Revenue_Above__c = 1000;  
        opp.Actual_Decision_Date__c = date1;
        opp.CloseDate = date1;
        opp.Expected_Revenue_Date__c = date2;       

        upsert opp;
        List<String> mnums = new List<String>{mnum1, mnum2};
        msd2s = Material_Sales_Data_Functions_Test.getTestMsd2s(sorg, dchan, mnums);
        mat1 = msd2s[0]; debug('mat1 = ' + mat1);
        
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
        insert oms;    
        
        system.debug('msd2s = ' + msd2s);
        system.debug('oms = ' + oms);  
        system.debug('opp = ' + opp);       
        
        /*
        ApexPages.StandardController sc ;
        ApexPages.currentPage().getParameters().put('debug', 'true');
        c = new OpportunityExtensionV3(sc);   
        c.initAction1(); c.materialNumber = mnum1;
        */
                    
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
                'Coach_Champion_Contact__c' => con.Id,
                'Evaluator_Formulator_Contact__c' => con.Id,
                'Value_Descision_Maker_Economic_Buyer_Con__c' => con.Id,
                'Type__c' => 'OppType1',
                'Lead_Source__c' => 'SALES CALL',
                'Client_has_Need_Interest_for_Prod_Sol__c' => 'Known',
                'ISP_Resources_Required__c' => 'Not Required',
                'Credit_Risk__c' => 'Moderate',
                'Customer_s_Project_Plan__c' => 'Documented',
                'Willingness_to_share__c' => 'Limited',
                'RecordTypeId' => OppRecordTypeId};
                             
            
        return OppFieldValues;      
    }    
       
}
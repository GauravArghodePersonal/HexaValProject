@isTest
private class OppToConsConvert_Test {

    static Map<String, String> OPP_RT_MAP = RecordType_Functions.RetrieveRecordTypeNameMap('Opportunity');

static testMethod void myUnitTest() {
        Test.startTest();
        RecordType oppRTId = [select Id from RecordType where RecordType.Name = :'Water Opportunity' limit 1];

        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Material_Sales_Data2__c mat = new Material_Sales_Data2__c();
        mat.Material_Number__c = '0000001';
        mat.Name = 'Material-1';
        mat.Dist_Channel_Code__c = '30';
        mat.Record_Key__c = mat.Name;
        mat.Sales_Org_Code__c = '1000';
        insert mat;
        
        Opportunity Opp = new Opportunity();
        //opp.RecordTypeId = OPP_RT_MAP.get('Water Opportunity');
        opp.RecordTypeId = oppRTId.Id;
        opp.accountid = acc.id;
        opp.SAP_Material__c = mat.id;
        opp.product_of_interest_other__c = '12345'; 
        opp.price_unit_of_measure__c = 'KG';
       
        //opp.details__c = 'These are my details';
        //Opp.product_group__c = 'ABS';
        opp.stagename = 'in';
        Opp.Name = 'Opportunity';
        opp.closedate = system.today();
        insert opp;
      

        
        ApexPages.currentpage().getparameters().put('oid', opp.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp); 
        OppToConsConvert c = new OpptoConsConvert(sc);
        c.doconvert();
        c.closePopup(); 
        c.processcancel();
        c.showPopup();
       
}


}
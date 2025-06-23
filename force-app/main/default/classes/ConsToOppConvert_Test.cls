@isTest
private class ConsToOppConvert_Test {

    static Map<String, String> CON_RT_MAP = RecordType_Functions.RetrieveRecordTypeNameMap('Consumption__c');

static testMethod void myUnitTest() {
        Test.startTest();
        Map<String, Id> AcctRecTypes = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
        Account acc = new Account(Name='AD_Chemicals',
                                  RecordTypeId=AcctRecTypes.get('Aqualon Customer'),
                                  SAP_Division_Desc__c = 'Chemicals');
        insert acc;

        Material_Sales_Data2__c mat = new Material_Sales_Data2__c();
        mat.Material_Number__c = '0000001';
        mat.Name = 'Material-1';
        mat.Dist_Channel_Code__c = '30';
        mat.Record_Key__c = mat.Name;
        mat.Sales_Org_Code__c = '1000';
        insert mat;
        
        Nexeo_Competitor__c nc = new Nexeo_Competitor__c(Name='Nexeo Comp');
        insert nc;
        
        Consumption__c con = new Consumption__c();
        con.RecordTypeId = CON_RT_MAP.get('PM China');
        con.Account_Name__c = acc.id;
        con.SAP_Material__c = mat.id;
        con.Nexeo_Competitor__c = nc.id;
        con.Distribution_Volume__c = 1000; 
        con.Direct_Volume__c = 1000;
        con.description__c = 'This is my description';    
        con.Unit_of_Measure__c = 'KG';
        con.RTKKey__c = '12345';
        insert con;
        RTK_Transfer__c t = new RTK_Transfer__c(Consumption__c = con.id);
        t.Hidden_EPA_ID_Source_Facility__c = '123';
        t.Reporting_year__c = '4';
        t.page_number__c = '5';
        insert t;
        epa_code__c e = new epa_code__c(Consumption__c = con.id);
        rtk_code__c r = new RTK_Code__c(Name = 'test', Description__c='Desc');
        insert r;
        e.EPA_ID__c = '123';
        e.Reporting_year__c = '4';
        e.page_number__c = '5';
        e.epa_code__c = r.id;
        insert e;
        
        

        
        ApexPages.currentpage().getparameters().put('cid', con.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(con); 
        ConsToOppConvert c = new ConsToOppConvert(sc);
        c.doconvert(); c.closePopup(); c.processcancel();
        c.showPopup();

}


}
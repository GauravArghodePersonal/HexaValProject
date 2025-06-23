@isTest 
private class RCRTest {
    static testMethod void insertTestData() {
        Account a = TestDataFactory.createAccount3(true);
        Material_Sales_Data2__c  m = TestDataFactory.create_Material_Sales_Data2(true);
        System.debug('Material>>'+m);
        List<RCR_email_list__c> emailList = new List<RCR_email_list__c>();
        RCR_email_list__c emailAdd = new RCR_email_list__c();
        emailAdd.Name = 'TBD';
        emailAdd.mailAddress__c = 'test@solenistest.cocm';
        emailList.add(emailAdd);
        
        RCR_email_list__c emailAdd2 = new RCR_email_list__c();
        emailAdd2.Name = 'UNDEFINED';
        emailAdd2.mailAddress__c = 'test@solenistest.cocm';
        emailList.add(emailAdd2);
        insert emailList;
        List<Regulatory_Customer_Request__c> listRCR = new List<Regulatory_Customer_Request__c>();
        Regulatory_Customer_Request__c o = new Regulatory_Customer_Request__c();
        o.Type_of_Requests__c = 'Questionnaires';
        o.Request_Date__c = system.today();
        o.Priority__c = '3-Normal';
        o.Customer__c = a.id;
        o.Regulatory_Material__c = m.id;
        o.Attributed_To__c= UserInfo.getUserId();
        o.Bulk_Creation__c = true;
        o.Bulk_Request_Number__c = '123';
        listRCR.add(o);
        Test.startTest();
        List<Material_Sales_Data2__c> mat = new List<Material_Sales_Data2__c>();
        mat = RCR.getMaterials('', 0,10,a.id);
        List<Material_Sales_Data2__c>  prevMat = new List<Material_Sales_Data2__c>();
        List<String> st = new List<String>();
        st.add(m.id);
        prevMat = RCR.getPreviewData(st);
        string result = insertObject.insertCon(listRCR);
        System.debug('From Test Class>>'+result);
        Test.stopTest();      
    }
}
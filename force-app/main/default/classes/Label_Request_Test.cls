@isTest(SeeAllData=true)
private class Label_Request_Test {

    static testMethod void myUnitTest() {
    	/*
        User u = [select Id from User where id = '00550000000scHU'];
        System.runAs(u) {
            Account acc = [select Id from Account where id = '0015000000cmvry'];
            Contact con = [select Id from Contact where id = '0035000001Al0fp'];
            Material_Sales_Data2__c mat = [select Id from Material_Sales_Data2__c where id = 'a3d50000000TTmM'];
            Label_Request__c lr = new Label_Request__c();
            lr.Customer_Prospect__c = acc.Id;
            lr.Contact__c = con.Id;
            lr.SAP_Material__c = mat.Id;
            try {insert lr;} catch(Exception e) {System.debug(e);}
        }
        */
    }
}
@isTest
private class Aquarius_Request_Test {

    static Map<String, Id> accRecordTypeMap = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
    static Map<String, Id> cseRecordTypeMap = RecordType_Functions.RetrieveRecordTypeNameMap('Case');
    static Map<String, Id> oppRecordTypeMap = RecordType_Functions.RetrieveRecordTypeNameMap('Opportunity');

    static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>> ' + s);
    }
    
    static testMethod void test01() {

        Account TestAccount1a  = new Account(Name='Test1a',AccountNumber='Prospect',
                                     SAP_Sales_Org__c='0315',
                                     RecordTypeId=accRecordTypeMap.get('Aqualon Prospect'));
                                     
        insert TestAccount1a;
        
        Id oprt = oppRecordTypeMap.get('Water Opportunity');
        Date cdate = Date.today().addDays(30);
        Opportunity op = new Opportunity(Name='TestOp',StageName='Open',Amount=10.0,
                                         RecordTypeID=oprt,CloseDate=cdate);
        insert op;
        
        Case testCase1 = new Case(RecordTypeId=cseRecordTypeMap.get('AAFI-TSR'));
        testCase1.Related_Opportunity__c = op.Id;
        insert testCase1;

        Sample_Request_Aquarius t = new Sample_Request_Aquarius();
        Sample_Request_Aquarius__c sra = t.getAquariusRequest(testCase1);
        sra.Other_Documentation__c = true;
        sra.Other_Market__c = true;
        sra.Custom_Color__c = true;
        sra.Other_Target__c = true;
        sra.Label_Match__c = true;
        sra.Exact_Formulation_Match__c = true;
        insert sra;
        debug('sra = ' + sra);

        Sample_Request__c TestSample1a  = new Sample_Request__c(Account__c= TestAccount1a.Id, 
                                                                Aquarius_Sample__c = true);
        TestSample1a.Case__c = testCase1.Id;
        insert TestSample1a;
    
        sra = t.getAquariusRequest(TestSample1a);
        debug('sra = ' + sra);
        
        Sample_Request_Aquarius.validateRequiredFields(sra);
        t.init(); t.isValid(); t.setPageMsgs(); t.getErrorMessages();
        t.getInstance(); t.onAquariusClose();
        
        Aquarius_Request_Controller c = new Aquarius_Request_Controller();
        c.setAttr1(t); c.cancel(); c.getAttr1(); 
        c.getIsCoatDscReadOnly(); c.getIsCoatObjReadOnly();
        c.getIsReadOnly(); c.getStyleClass_othClrDtl(); c.getStyleClass_othDocDtl();
        c.getStyleClass_othMktDtl(); c.getStyleClass_othTgtDtl();
        c.getStyleClass_prodMatch(); c.getStyleClass_qntfMatch();
        c.validate();
    }
}
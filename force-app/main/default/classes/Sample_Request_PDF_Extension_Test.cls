@isTest 

private class Sample_Request_PDF_Extension_Test {

    static testmethod void TestMe() {

        Map<String, Id> AccountRecordTypeMap = RecordType_Functions.RetrieveRecordTypeNameMap('Account');

        Account TestAccount1a  = new Account(Name='Test1a',AccountNumber='Prospect',
                                     SAP_Sales_Org__c='0315',
                                     RecordTypeId=AccountRecordTypeMap.get('Aqualon Prospect'));

                                     
        insert TestAccount1a;

        Sample_Request__c TestSample1a  = new Sample_Request__c(Account__c= TestAccount1a.Id);
        insert TestSample1a;
    
        Sample_Material__c TestMaterial1a  = new Sample_Material__c(Sample_Request__c= TestSample1a.Id,
                                                 AD_Compound__c=false,Tectyl_Product__c=false);
        insert TestMaterial1a;

        Sample_Request__c sr = null;
        try {
            sr = [SELECT Id FROM Sample_Request__c LIMIT 1];
        } catch(Exception e) {}
        if (sr == null) {return;}

        ApexPages.StandardController sc = new ApexPages.StandardController(sr);
        Sample_Request_PDF_Extension cls = new Sample_Request_PDF_Extension(sc);

        Sample_Request__c sr_test = cls.getsampleRequest();
    
        Sample_Request__c sr_test2 = cls.getsampleRequest_AdditionalFields();
        
        List<Sample_Material__c> materials = cls.getSampleMaterials();
        
        Integer notessize = cls.getSampleNotesSize();
        
        String header = cls.getHeaderDetailLine();
        
        String address = cls.getSampleRequestAddress();
        
    }
    }
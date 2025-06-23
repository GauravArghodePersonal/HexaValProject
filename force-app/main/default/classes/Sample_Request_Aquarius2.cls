public with sharing class Sample_Request_Aquarius2 {

    public Sample_Request_Aquarius__c getSra(String srid) {
        Sample_Request_Aquarius__c sra;
    
        List<Sample_Request_Aquarius__c> alist = [select Id, Sample_Request__c,
                                                         Active_Ingredient__c,
                                                         Color_Desired__c,
                                                         Colorants_Preferred__c,
                                                         Colorants_that_cannot_be_used__c,
                                                         Countries_SoldTo__c,
                                                         Current_System_Performance__c,
                                                         Current_System__c,
                                                         Film_Improvements_Needed__c,
                                                         Market_End_Use__c,
                                                         Plasticizer_Preference__c,
                                                         Reference_Tablet__c,
                                                         Aquarius_DOE_Material__c
                                                    from Sample_Request_Aquarius__c
                                                   where Sample_Request__c = :srid 
                                                 ];
        if (alist.isEmpty()) {
            sra = new Sample_Request_Aquarius__c();
            sra.Sample_Request__c = srid;
        } else {
            sra = alist[0];
        }
        return sra;
    }
    
    public static String validateRequiredFields(Sample_Request_Aquarius__c sra) {
        List<String> alist = new List<String>();
        if (isNull(sra.Market_End_Use__c)) {
            alist.add('Select a Market End Use value');
        }
        if (isNull(sra.End_Use_Customer__c)) {
            alist.add('Enter End Use Customer Name');
        }
        if (isNull(sra.Aquarius_DOE_Material__c)) {
            alist.add('Select Aquarius DOE Material');
        }
        if (isNull(sra.Color_Desired__c)) {
            alist.add('Enter Color Desired');
        }
        if (isNull(sra.Countries_SoldTo__c)) {
            alist.add('Enter Countries Sold to');
        }
        if (isNull(sra.Plasticizer_Preference__c)) {
            alist.add('Choose Plasticizer Preference');
        }
        if (isNull(sra.Reference_Tablet__c)) {
            alist.add('Enter Reference Tablet');
        }
        String s;
        if (alist.isEmpty()) {
            s = '';
        } else {
            s = String_Functions.Format_ListString_into_HTML_List(alist,'Error: Aquarius Samples : ','');
        }
        return s;
    }
    
    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    @isTest static void test01() {
        Map<String, Id> AccountRecordTypeMap = RecordType_Functions.RetrieveRecordTypeNameMap('Account');

        Account TestAccount1a  = new Account(Name='Test1a',AccountNumber='Prospect',
                                     SAP_Sales_Org__c='0315',
                                     RecordTypeId=AccountRecordTypeMap.get('Aqualon Prospect'));

                                     
        insert TestAccount1a;

        Sample_Request__c TestSample1a  = new Sample_Request__c(Account__c= TestAccount1a.Id, 
                                                                Aquarius_Sample__c = true);
        insert TestSample1a;
    
        Sample_Material__c TestMaterial1a  = new Sample_Material__c(Sample_Request__c= TestSample1a.Id);
        insert TestMaterial1a;

        String srId = TestSample1a.Id;
        List<Sample_Request__c> srs = [select Id, Aquarius_Sample__c
                                         from Sample_Request__c
                                        where Id = :srId 
                                      ];
        Sample_Request_Aquarius2 t = new Sample_Request_Aquarius2();
        Sample_Request_Aquarius__c sra = t.getSra(srId);
        validateRequiredFields(sra);
    }
}
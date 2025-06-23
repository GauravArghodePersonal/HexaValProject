public with sharing class PriceBookSalesOrgExtendFunctions {

    private static final String userEmail = User_Functions.getLoggedInUserEmail();
    
    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>> ' + s);
    }

    @future
    public static void createPriceBookEntries(String pbId, String fromSorg, List<String> toSorgs) {
        List<Price_Book__c> pbs = PriceBookFunctions.getPriceBooks(pbId);
        Price_Book__c pb = pbs[0];
    	for (String toSorg : toSorgs) {
    		createPriceBookEntries(pb, fromSorg, toSorg);
    	}
        sendEmail('PriceBook ' + pb.Name + ' extended to Sales Orgs : '+ toSorgs);
    }
    
    private static void createPriceBookEntries(Price_Book__c pb, String fromSorg, String toSorg) {
        String pbId = pb.Id;
        String dchanCode = pb.Dist_Channel_Code__c;
        Set<String> sorgCodes = new Set<String>{fromSorg, toSorg};
        Set<String> matKeys1 = new Set<String>();
        Set<String> matKeys2 = new Set<String>(); 
        Set<String> matKeys3 = new Set<String>();
        Map<String, Price_Book_Entry__c> matPBEntryMap = new Map<String, Price_Book_Entry__c>();
        List<Price_Book_Entry__c> pbes = PriceBookEntryFunctions.getPriceBookEntries(pbId, sorgCodes);
        if (pbes == null || pbes.isEmpty()) {return;} 
        for (Price_Book_Entry__c pbe : pbes) {
            matKeys1.add(pbe.Material_Sales_Data2__r.Material_Number__c + 
                         pbe.Material_Sales_Data2__r.Sales_Org_Code__c + 
                         pbe.Material_Sales_Data2__r.Dist_Channel_Code__c);
            matKeys2.add(pbe.Material_Sales_Data2__r.Material_Number__c + 
                         toSorg + dchanCode);
            matPBEntryMap.put(pbe.Material_Sales_Data2__r.Material_Number__c, pbe);
        }
        for (String s : matKeys2) {if (!matKeys1.contains(s)) {matKeys3.add(s);}}
        Map<String, Id> matReckeyIdMap = new Map<String, Id>();
        if (!matKeys3.isEmpty()) {
            PriceBookFunctions.processBeforeUpdate = false;
            insertPriceBookEntries(pbId, toSorg, matKeys3, matPBEntryMap);
            PriceBookFunctions.processBeforeUpdate = true;
        }
    }
    
    private static void insertPriceBookEntries(String pbId, String sorgCode, Set<String> keys,
                                               Map<String, Price_Book_Entry__c> matPBEntryMap) {
        Price_Book_Entry__c pbe1, pbe2;
        List<Price_Book_Entry__c> pbes = new List<Price_Book_Entry__c>(); 
        for (Material_Sales_Data2__c m : [
            select Id, Material_Number__c 
              from Material_Sales_Data2__c
             where Record_Key__c in :keys]) {
            pbe1 = matPBEntryMap.get(m.Material_Number__c);
            pbe2 = pbe1.clone(false, true);
            pbe2.Material_Sales_Data2__c = m.Id;
            pbes.add(pbe2);
        }
        Map<String, Id> pbeMatIdMap = new Map<String, Id>();
        //Savepoint sp = Database.setSavepoint();
        try {
            insertPriceBookSalesOrg(pbId, sorgCode);
            insert pbes;
            for (Price_Book_Entry__c pbe : pbes) {
                pbeMatIdMap.put(pbe.Material_Sales_Data2__r.Material_Number__c, pbe.Id);
            }
            insertPriceBookEntryScales(pbeMatIdMap, matPBEntryMap);
        } catch (Exception e) {
            //Database.rollback(sp);
            sendEmail(e.getMessage());
        }
    }
    
    private static void insertPriceBookSalesOrg(String pbId, String sorgCode) {
        List<SAP_Sales_Org__c> sorgs = [select Id 
                                          from SAP_Sales_Org__c 
                                         where Sales_Org_Code__c = :sorgCode];
        if (sorgs == null || sorgs.isEmpty()) {return;}
        Id sorgId = sorgs[0].Id;
        List<Price_Book_Sales_Org__c> pbsorgs = [select Id
                                                   from Price_Book_Sales_Org__c
                                                  where Price_Book__c = :pbId
                                                    and SAP_Sales_Org__c = :sorgId];
        if (pbsorgs == null || pbsorgs.isEmpty()) {
            Price_Book_Sales_Org__c pbsorg = new Price_Book_Sales_Org__c();
            pbsorg.Price_Book__c = pbId;
            pbsorg.SAP_Sales_Org__c = sorgId;
            insert pbsorg;
        }
    }
    
    private static void insertPriceBookEntryScales(Map<String, Id> pbeMatIdMap, 
                                                   Map<String, Price_Book_Entry__c> matPBEntryMap) {
        Id pbeId;
        Price_Book_Entry__c pbe1;
        List<Price_Book_Entry_Scaled_Pricing__c> pbesps1, 
                                                 pbesps3 = new List<Price_Book_Entry_Scaled_Pricing__c>();
        for (String matNum : pbeMatIdMap.keySet()) {
            pbeId = pbeMatIdMap.get(matNum);
            pbe1 = matPBEntryMap.get(matNum);
            pbesps1 = pbe1.Price_Book_Entries_Scaled_Pricing__r;
            if (pbesps1 != null && !pbesps1.isEmpty()) {
                List<Price_Book_Entry_Scaled_Pricing__c> pbesps2 = pbesps1.deepClone(false);
                for (Price_Book_Entry_Scaled_Pricing__c pbesp : pbesps2) {
                    pbesp.Price_Book_Entry__c = pbeId;
                }
                pbesps3.addAll(pbesps2);
            }
        }
        try {insert pbesps3;} catch (Exception e) {sendEmail(e.getMessage());}
    }
    
    private static void sendEmail(String s) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {userEmail});
        mail.setReplyTo(userEmail);
        mail.setSenderDisplayName('SysAdmin');
        mail.setSubject('PriceBook extension to other SalesOrgs');
        mail.setPlainTextBody(s);
        MessagingMethods.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

/*    
    @isTest static void test01() {
    	List<String> sorgCodes = new List<String>{'0390'};
    	Test.startTest();
        createPriceBookEntries('a42500000008RXN', '0490', sorgCodes);
        Test.stopTest();
    }
*/
    
}
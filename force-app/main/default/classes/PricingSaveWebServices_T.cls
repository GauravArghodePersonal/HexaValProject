@isTest
private class PricingSaveWebServices_T {

    static Competitor__c                             competitor;
    static Price_Book__c                             priceBook;
    static Price_Book_Entry__c                       priceBookEntry;
    static Price_Book_Service__c                     priceBookService;
    static Pricing_Condition__c                      pricingCondition; 

    static List<Price_Book_Customer_Group__c>        priceBookCustGroups, priceBookCustGroups2;
    static List<Price_Book_Entry__c>                 priceBookEntries;
    static List<Price_Book_Family__c>                priceBookFamilies, priceBookFamilies2;
    static List<Price_Book_Product_Line__c>          priceBookProdLines, priceBookProdLines2;
    static List<Price_Book_Region__c>                priceBookRegions, priceBookRegions2;
    static List<Price_Book_Sales_Org__c>             priceBookSalesOrgs, priceBookSalesOrgs2;
    static List<Price_Book_Entry_Scaled_Pricing__c>  priceBookEntryScales, priceBookEntryScales2;
    static List<Pricing_Condition_Scaled_Pricing__c> pricingConditionScales, pricingConditionScales2;
    static List<Pricing_to_Competitor__c>            pricingCompetitors;

    static Price_Book_Entry                          pbEntry;
    static List<Price_Book_Entry>                    pbEntries;

    static PricingSaveWebServices.ReturnClass rc;

    static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>> ' + s);
    }
     
    static void createTestData() {

        try {
        	competitor = TestObjects.newCompetitor();

			/*        	
            competitor = [
               select Name 
                 from Competitor__c
                order by Name desc 
                limit 1];
			*/            
            debug(''+competitor);
        } catch(Exception e) {}
    
        try {
        	pricebook = TestObjects.newPrice_Book();
        	/*
            priceBook = [
               select Name 
                 from Price_Book__c
                order by Name desc 
                limit 1];
            */
            debug(''+priceBook);
        } catch(Exception e) {}
    
        try {
        	priceBookEntry = TestObjects.newPrice_Book_Entry(new Map<String,String>{'Price_Book__c'=>pricebook.Id});
        	/*
            priceBookEntry = [
               select Name, Price_Book__c
                 from Price_Book_Entry__c
                where Price_Book__c = :priceBook.Id
                limit 1];
            */
            debug(''+priceBookEntry);
            pbEntry = new Price_Book_Entry();
            pbEntry.priceBookEntry = priceBookEntry;
        } catch(Exception e) {}
    
        try {
            Price_Book_Entry_Scaled_Pricing__c priceBookEntryScale1 = TestObjects.newPrice_Book_Entry_Scaled_Pricing(new Map<String,String>{'Price_Book_Entry__c'=>priceBookEntry.Id});
            Price_Book_Entry_Scaled_Pricing__c priceBookEntryScale2 = TestObjects.newPrice_Book_Entry_Scaled_Pricing(new Map<String,String>{'Price_Book_Entry__c'=>priceBookEntry.Id});
            
            priceBookEntryScales = new List<Price_Book_Entry_Scaled_Pricing__c>();
            priceBookEntryScales.add(priceBookEntryScale1);
            priceBookEntryScales.add(priceBookEntryScale2);
            /*
            priceBookEntryScales = [
               select Name, Price_Book_Entry__c
                 from Price_Book_Entry_Scaled_Pricing__c
                where Price_Book_Entry__c = :priceBookEntry.Id
                limit 2];
            */
            priceBookEntryScales2 = priceBookEntryScales.deepClone(false);
            debug(''+priceBookEntryScales2);
            pbEntry.pbEntryScales = priceBookEntryScales;
        } catch(Exception e) {}

        pbEntries = new List<Price_Book_Entry>{pbEntry}; 

        try {
            priceBookService = new Price_Book_Service__c(Price_Book__c = priceBook.Id);
        } catch(Exception e) {}

        try {
        	Price_Book_Customer_Group__c priceBookCustGroup1 = TestObjects.newPrice_Book_Customer_Group(new Map<String,String>{'Price_Book__c'=>pricebook.Id,'SAP_Customer_Group__c'=>'001'});
        	Price_Book_Customer_Group__c priceBookCustGroup2 = TestObjects.newPrice_Book_Customer_Group(new Map<String,String>{'Price_Book__c'=>pricebook.Id,'SAP_Customer_Group__c'=>'002'});

            priceBookCustGroups = new List<Price_Book_Customer_Group__c>();
            priceBookCustGroups.add(priceBookCustGroup1);
            priceBookCustGroups.add(priceBookCustGroup2);
        	/*
            priceBookCustGroups = [
               select Name, Price_Book__c, SAP_Customer_Group__c
                 from Price_Book_Customer_Group__c
                where Price_Book__c = :priceBook.Id
                limit 2];
            */
            priceBookCustGroups2 = priceBookCustGroups.deepClone(false);
            debug(''+priceBookCustGroups2);
        } catch(Exception e) {}
    
        try {
        	Price_Book_Family__c priceBookFamily1 = TestObjects.newPrice_Book_Family(new Map<String,String>{'Price_Book__c'=>pricebook.Id});
        	Price_Book_Family__c priceBookFamily2 = TestObjects.newPrice_Book_Family(new Map<String,String>{'Price_Book__c'=>pricebook.Id});

            priceBookFamilies = new List<Price_Book_Family__c>();
            priceBookFamilies.add(priceBookFamily1);
            priceBookFamilies.add(priceBookFamily2);
            /*
            priceBookFamilies = [
               select Name, Price_Book__c, Family_Code__c
                 from Price_Book_Family__c
                where Price_Book__c = :priceBook.Id
                limit 2];
            */                
            priceBookFamilies2 = priceBookFamilies.deepClone(false);
            debug(''+priceBookFamilies2);
        } catch(Exception e) {}
    
        try {
        	Price_Book_Product_Line__c priceBookProdLine1 = TestObjects.newPrice_Book_Product_Line(new Map<String,String>{'Price_Book__c'=>pricebook.Id});
        	Price_Book_Product_Line__c priceBookProdLine2 = TestObjects.newPrice_Book_Product_Line(new Map<String,String>{'Price_Book__c'=>pricebook.Id});

            priceBookProdLines = new List<Price_Book_Product_Line__c>();
            priceBookProdLines.add(priceBookProdLine1);
            priceBookProdLines.add(priceBookProdLine2);

			/*
            priceBookProdLines = [
               select Name, Price_Book__c, Product_Line_Code__c, Product_Line_Desc__c
                 from Price_Book_Product_Line__c
                where Price_Book__c = :priceBook.Id
                limit 2];
            */
            priceBookProdLines2 = priceBookProdLines.deepClone(false);
            debug(''+priceBookProdLines2);
        } catch(Exception e) {}
    
        try {
        	Price_Book_Region__c priceBookRegion1 = TestObjects.newPrice_Book_Region(new Map<String,String>{'Price_Book__c'=>pricebook.Id,'SAP_Region__c'=>'001'});
        	Price_Book_Region__c priceBookRegion2 = TestObjects.newPrice_Book_Region(new Map<String,String>{'Price_Book__c'=>pricebook.Id,'SAP_Region__c'=>'001'});

            priceBookRegions = new List<Price_Book_Region__c>();
            priceBookRegions.add(priceBookRegion1);
            priceBookRegions.add(priceBookRegion2);
			
			/*
            priceBookRegions = [
               select Name, Price_Book__c, SAP_Region__c
                 from Price_Book_Region__c
                where Price_Book__c = :priceBook.Id
                limit 2];
            */
            priceBookRegions2 = priceBookRegions.deepClone(false);
            debug(''+priceBookRegions2);
        } catch(Exception e) {}
    
        try {
        	Price_Book_Sales_Org__c priceBookSalesOrg1 = TestObjects.newPrice_Book_Sales_Org(new Map<String,String>{'Price_Book__c'=>pricebook.Id,'SAP_Sales_Org__c'=>'001'});
        	Price_Book_Sales_Org__c priceBookSalesOrg2 = TestObjects.newPrice_Book_Sales_Org(new Map<String,String>{'Price_Book__c'=>pricebook.Id,'SAP_Sales_Org__c'=>'001'});

            priceBookSalesOrgs = new List<Price_Book_Sales_Org__c>();
            priceBookSalesOrgs.add(priceBookSalesOrg1);
            priceBookSalesOrgs.add(priceBookSalesOrg2);
			
			/*
            priceBookSalesOrgs = [
               select Name, Price_Book__c, SAP_Sales_Org__c
                 from Price_Book_Sales_Org__c
                where Price_Book__c = :priceBook.Id
                limit 2];
			*/                
            priceBookSalesOrgs2 = priceBookSalesOrgs.deepClone(false);
            debug(''+priceBookSalesOrgs2);
        } catch(Exception e) {}

        try {
        	pricingCondition = TestObjects.newPricing_Condition();
        	/*
            pricingCondition = [
               select Name 
                 from Pricing_Condition__c
                order by Name desc 
                limit 1];
            */                
            debug(''+pricingCondition);
        } catch(Exception e) {}
    
        try {
        	Pricing_Condition_Scaled_Pricing__c pricingConditionScale1 = new Pricing_Condition_Scaled_Pricing__c();
        	pricingConditionScale1.Pricing_Condition__c = pricingCondition.Id;
        	insert pricingConditionScale1;
        	
        	Pricing_Condition_Scaled_Pricing__c pricingConditionScale2 = new Pricing_Condition_Scaled_Pricing__c();
        	pricingConditionScale2.Pricing_Condition__c = pricingCondition.Id;
        	insert pricingConditionScale2;
        	
            pricingConditionScales = new List<Pricing_Condition_Scaled_Pricing__c>();
            pricingConditionScales.add(pricingConditionScale1);
            pricingConditionScales.add(pricingConditionScale2);
            
        	/*
            pricingConditionScales = [
               select Name, Selling_Price__c, Selling_Price_with_Upcharges__c
                 from Pricing_Condition_Scaled_Pricing__c
                where Pricing_Condition__c = :pricingCondition.Id
                limit 2];
            */
            pricingConditionScales2 = pricingConditionScales.deepClone(false);
            debug(''+pricingConditionScales2);
        } catch(Exception e) {}
        
        pricingCompetitors = new List<Pricing_to_Competitor__c>();
        Pricing_to_Competitor__c pricingCompetitor = new Pricing_to_Competitor__c();
        try {
            pricingCompetitor.Pricing_Condition__c = pricingCondition.Id;
            pricingCompetitor.Competitor__c = competitor.Id;
            pricingCompetitors.add(pricingCompetitor);
        } catch(Exception e) {}
    }

    private static Boolean notEmpty(List<SObject> objs) {
        Boolean b = (objs != null && !objs.isEmpty());
        if (b && objs.size() == 1) {
            String s = (String)objs[0].get('Name');
            b = !(s != null && s.equalsIgnorecase('Dummy'));
        } 
        return b;
    }

//*    
    static testMethod void test01() {
        createTestData();
        Test.startTest();
        rc = PricingSaveWebServices.upsertPriceBook(
           priceBook,
           priceBookCustGroups2,
           priceBookFamilies2,
           priceBookProdLines2,
           priceBookRegions2,
           priceBookSalesOrgs2,
           priceBookCustGroups,
           priceBookFamilies,
           priceBookProdLines,
           priceBookRegions,
           priceBookSalesOrgs
        );
        debug(''+rc);
        rc = PricingSaveWebServices.upsertPriceBookEntry(
           priceBookEntry,
           priceBookEntryScales2
        );
        debug(''+rc);
        rc = PricingSaveWebServices.upsertPriceBookService(
           priceBookService
        );
        debug(''+rc);
        rc = PricingSaveWebServices.upsertPricingCondition(
           pricingCondition,
           pricingConditionScales2,
           pricingCompetitors
        );
        debug(''+rc);
    }
    
    static testMethod void test02() {
        createTestData();
        Test.startTest();
        rc = PricingSaveWebServices.upsertPriceBook(
           priceBook,
           priceBookCustGroups,
           priceBookFamilies,
           priceBookProdLines,
           priceBookRegions,
           priceBookSalesOrgs,
           null, null, null, null, null
        );
        debug(''+rc);
        rc = PricingSaveWebServices.upsertPriceBookEntry(
           priceBookEntry,
           priceBookEntryScales
        );
        debug(''+rc);
        rc = PricingSaveWebServices.upsertPriceBookService(
           null
        );
        debug(''+rc);
        rc = PricingSaveWebServices.upsertPricingCondition(
           pricingCondition,
           pricingConditionScales,
           null
        );
        debug(''+rc);
    }
    
    static testMethod void test03() {
        createTestData();
        Test.startTest();
        List<String> ids;
        if (priceBookEntry != null) {
            ids = new List<String>{priceBookEntry.Id};
            rc = PricingSaveWebServices.deleteRecords(
                'Price_Book_Entry__c', ids
            );
            debug(''+rc);
        }
        if (pricingCondition != null) {
            ids = new List<String>{pricingCondition.Id};
            rc = PricingSaveWebServices.deleteRecords(
                'Pricing_Condition__c', ids
            );
            debug(''+rc);
        } 
        
        //Test a bad scenario
        PricingSaveWebServices.deleteRecords('Bad', ids);
    }

    static testMethod void test04() {
        List<SObject> objs = new List<SObject>();
        SObject obj = new Account(name='dummy');
        objs.add(obj);
        debug(''+notEmpty(objs));
    }
//*/
    static testMethod void test05() {
        createTestData();
        Test.startTest();
        rc = PricingSaveWebServices.upsertPriceBookEntries_OLD(pbEntries);
        rc = PricingSaveWebServices.upsertPriceBookEntries(pbEntries);
        debug(''+rc);
        
        List<String> idsToDelete = new List<String>();
        Account acct = TestObjects.newAccount();
        idsToDelete.add(acct.Id);
        PricingSaveWebServices.deleteRecords('Account',idsToDelete);
        
    }
}
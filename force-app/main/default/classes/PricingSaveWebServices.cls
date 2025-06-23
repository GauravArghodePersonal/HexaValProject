global class PricingSaveWebServices {
    
    private static final Integer MAX_RECS = 10000;
    
    global class ReturnClass {
    
        webservice Price_Book__c                             priceBook;
        webservice Price_Book_Entry__c                       priceBookEntry;
        webservice Price_Book_Service__c                     priceBookService;
        webservice Pricing_Condition__c                      pricingCondition; 

        webservice List<Price_Book_Customer_Group__c>        priceBookCustGroups;
        webservice List<Price_Book_Family__c>                priceBookFamilies;
        webservice List<Price_Book_Product_Line__c>          priceBookProdLines;
        webservice List<Price_Book_Region__c>                priceBookRegions;
        webservice List<Price_Book_Sales_Org__c>             priceBookSalesOrgs;
        webservice List<Price_Book_Entry__c>                 priceBookEntries;
        webservice List<Price_Book_Entry_Scaled_Pricing__c>  priceBookEntryScales;
        webservice List<Pricing_Condition_Scaled_Pricing__c> pricingConditionScales;
        webservice List<Pricing_to_Competitor__c>            pricingCompetitors;

        webservice List<Price_Book_Entry>                    pbEntries;

        webservice String                                    returnMessage = '';
        webservice Boolean                                   saveFailed = false;
        
    }

/*
    webservice static ReturnClass test1() {
        Price_Book__c pbc = [select Id, Name from Price_Book__c limit 1];
        ReturnClass rc = new ReturnClass();
        rc.priceBook = pbc;
        rc.returnMessage = 'errMsg';
        return rc;
    }
    
    webservice static ReturnClass test2(List<Price_Book_Customer_Group__c> sos) {
        debug(''+sos);
        ReturnClass rc = new ReturnClass();
        rc.returnMessage = ''+sos;
        return rc;
    }
*/    

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>> ' + s);
    }
    
    webservice static ReturnClass deleteRecords(
        String objectApiName, 
        List<String> recordIds) {
        
        ReturnClass rc = new ReturnClass();
        
        String q = 'select Id from ' + objectApiName +
                   ' where Id in :recordIds ' +
                   ' limit :MAX_RECS';
        try {
            for (List<SObject> sos : Database.query(q)) {
                delete sos;
                addMessage('deleteRecords', objectApiName + 
                           ' : Number of records deleted : ' + 
                           sos.size(), rc);
            }
        } catch(Exception e) {
            addMessage('deleteRecords', e, rc);
        }
        
        return rc;
    }

    webservice static ReturnClass upsertPriceBook(
        Price_Book__c priceBook, 
        List<Price_Book_Customer_Group__c> custGroups_to_Upsert,
        List<Price_Book_Family__c> families_to_Upsert,
        List<Price_Book_Product_Line__c> prodLines_to_Upsert,
        List<Price_Book_Region__c> regions_to_Upsert,
        List<Price_Book_Sales_Org__c> salesOrgs_to_Upsert,
        List<Price_Book_Customer_Group__c> custGroups_to_Delete,
        List<Price_Book_Family__c> families_to_Delete,
        List<Price_Book_Product_Line__c> prodLines_to_Delete,
        List<Price_Book_Region__c> regions_to_Delete,
        List<Price_Book_Sales_Org__c> salesOrgs_to_Delete) {

        ReturnClass rc = new ReturnClass();
        
        savepoint sp = Database.setSavepoint();
        
        try {

            if (notEmpty(custGroups_to_Delete)) {delete(custGroups_to_Delete);}
            if (notEmpty(families_to_Delete))   {delete(families_to_Delete);}
            if (notEmpty(prodLines_to_Delete))  {delete(prodLines_to_Delete);}
            if (notEmpty(regions_to_Delete))    {delete(regions_to_Delete);}
            if (notEmpty(salesOrgs_to_Delete))  {delete(salesOrgs_to_Delete);}
            
            upsert priceBook;
            rc.priceBook = priceBook;
            
            System.debug('custGroups_to_Upsert = ' + custGroups_to_Upsert); 
            if (notEmpty(custGroups_to_Upsert)) {
                for (Price_Book_Customer_Group__c i : custGroups_to_Upsert) {
                    if (i.Price_Book__c == null) {i.Price_Book__c = priceBook.Id;}
                }
                try {
                    upsert custGroups_to_Upsert;
                    rc.priceBookCustGroups = custGroups_to_Upsert;
                } catch(Exception e) {addMessage('upsertPBCustGroups', e, rc);}
            }

            if (notEmpty(families_to_Upsert)) {
                for (Price_Book_Family__c i : families_to_Upsert) {
                    if (i.Price_Book__c == null) {i.Price_Book__c = priceBook.Id;}
                }
                try {
                    upsert families_to_Upsert;
                    rc.priceBookFamilies = families_to_Upsert;
                } catch(Exception e) {addMessage('upsertPBFamilies', e, rc);}
            }

            if (notEmpty(prodLines_to_Upsert)) {
                for (Price_Book_Product_Line__c i : prodLines_to_Upsert) {
                    if (i.Price_Book__c == null) {i.Price_Book__c = priceBook.Id;}
                }
                try {
                    upsert prodLines_to_Upsert;
                    rc.priceBookProdLines = prodLines_to_Upsert;
                } catch(Exception e) {addMessage('upsertPBProductLines', e, rc);}
            }

            if (notEmpty(regions_to_Upsert)) {
                for (Price_Book_Region__c i : regions_to_Upsert) {
                      if (i.Price_Book__c == null) {i.Price_Book__c = priceBook.Id;}
                }
                try {
                    upsert regions_to_Upsert;
                    rc.priceBookRegions = regions_to_Upsert;
                } catch(Exception e) {addMessage('upsertPBRegions', e, rc);}
            }

            if (notEmpty(salesOrgs_to_Upsert)) {
                for (Price_Book_Sales_Org__c i : salesOrgs_to_Upsert) {
                    if (i.Price_Book__c == null) {i.Price_Book__c = priceBook.Id;}
                }
                try {
                    upsert salesOrgs_to_Upsert;
                    rc.priceBookSalesOrgs = salesOrgs_to_Upsert;
                } catch(Exception e) {addMessage('upsertPBSalesOrgs', e, rc);}
            }
            
        } catch (Exception e) {
            addMessage('upsertPriceBook', e, rc);
            System.debug('upsertPriceBook error: ' + e);
            rc.saveFailed = true;
            Database.rollback(sp);  
        }
        
        return rc;
    }
    
    private static void addMessage(String ctx, Exception e, ReturnClass rc) {
        addMessage(ctx, e.getMessage(), rc);
    }
    
    private static void addMessage(String ctx, String msg, ReturnClass rc) {
        rc.returnMessage += ctx + ' : ' + msg + '\n';
        debug(msg);
    }
    
    private static Boolean notEmpty(List<SObject> objs) {
        Boolean b = (objs != null && !objs.isEmpty());
        if (b && objs.size() == 1) {
            String s = (String)objs[0].get('Name');
            b = !(s != null && s.equalsIgnorecase('Dummy'));
        } 
        return b;
    }

    webservice static ReturnClass upsertPriceBookEntry(
        Price_Book_Entry__c pbEntry, 
        List<Price_Book_Entry_Scaled_Pricing__c> pbEntryScales) {
            
        ReturnClass rc = new ReturnClass();
        
        savepoint sp = Database.setSavepoint();
        
        try {
            upsert pbEntry;
            rc.priceBookEntry = pbEntry;
            
            for (Price_Book_Entry_Scaled_Pricing__c i : pbEntryScales) {
                if (i.Price_Book_Entry__c == null) {i.Price_Book_Entry__c = pbEntry.Id;}
            }

            upsert pbEntryScales;
            rc.priceBookEntryScales = pbEntryScales;
        } 
        catch (Exception e) {
            addMessage('upsertPriceBookEntry', e, rc);
            rc.saveFailed = true;
            Database.rollback(sp);  
        }
        
        return rc;
    }


  webservice static ReturnClass upsertPriceBookEntries_OLD(
        List<Price_Book_Entry> pbEntries) {
       
        ReturnClass rc = new ReturnClass();
       
        savepoint sp = Database.setSavepoint();
       
        List<Price_Book_Entry__c> pbes = new List<Price_Book_Entry__c>();
        List<Price_Book_Entry_Scaled_Pricing__c> pbescales1 = new List<Price_Book_Entry_Scaled_Pricing__c>();
        List<Price_Book_Entry_Scaled_Pricing__c> pbescales2;
        Map<String, List<Price_Book_Entry_Scaled_Pricing__c>> pmap = new Map<String, List<Price_Book_Entry_Scaled_Pricing__c>>();
        Price_Book_Entry__c pbe;
        Price_Book_Entry pbEntry;
        String pbeid;
        try {
            for (Price_Book_Entry pbe1 : pbEntries) {
                pbes.add(pbe1.priceBookEntry);
            }
            upsert pbes;
            //rc.priceBookEntries = pbes;
            for (Integer n = 0; n < pbEntries.size(); n++) {
                pbEntry = pbEntries.get(n);
                pbe = pbes.get(n);
                pbescales2 = new List<Price_Book_Entry_Scaled_Pricing__c >();
                pbescales2.addAll(pbEntry.pbEntryScales);
                for (Price_Book_Entry_Scaled_Pricing__c pbes2 : pbescales2) {
                    if (pbes2.Price_Book_Entry__c == null) {pbes2.Price_Book_Entry__c = pbe.Id;}
                }
                pbescales1.addAll(pbescales2);
            }
            upsert pbescales1;
            //rc.priceBookEntryScales = pbescales1;
            pbescales2 = new List<Price_Book_Entry_Scaled_Pricing__c >();
            for (Price_Book_Entry_Scaled_Pricing__c pbes1 : pbescales1) {
                pbeid = pbes1.Price_Book_Entry__c;
                if (pmap.containsKey(pbeid)) {
                    pbescales2 = pmap.get(pbeid);
                } else {
                    pbescales2 = new List<Price_Book_Entry_Scaled_Pricing__c>();
                }
                pbescales2.add(pbes1);
                pmap.put(pbeid, pbescales2);
            }
            pbEntries = new List<Price_Book_Entry>();
            for (Price_Book_Entry__c pbe2 : pbes) {
                pbeid = pbe2.Id;
                if (pmap.containsKey(pbeid)) {
                    pbescales2 = pmap.get(pbeid);
                    pbEntry = new Price_Book_Entry();
                    pbEntry.priceBookEntry = pbe2;
                    pbEntry.pbEntryScales = pbescales2;
                    pbEntries.add(pbEntry);
                }
            }
            rc.pbEntries = pbEntries;
        }
        catch (Exception e) {
            addMessage( 'upsertPriceBookEntries', e, rc);
            rc.saveFailed = true;
            Database.rollback(sp); 
        }
       
        return rc;
    }
 
  /* Fixes the DELETE PROBLEM */
  webservice static ReturnClass upsertPriceBookEntries(
        List<Price_Book_Entry> pbEntries) {
        
        ReturnClass rc = new ReturnClass();
        
        savepoint sp = Database.setSavepoint();
        
        List<Price_Book_Entry__c> pbes = new List<Price_Book_Entry__c>();
        List<Price_Book_Entry_Scaled_Pricing__c> pbescales1 = new List<Price_Book_Entry_Scaled_Pricing__c>(); 
        List<Price_Book_Entry_Scaled_Pricing__c> pbescales2;
        List<Price_Book_Entry_Scaled_Pricing__c> scalesToDelete = new List<Price_Book_Entry_Scaled_Pricing__c>();
        
        Map<String, List<Price_Book_Entry_Scaled_Pricing__c>> pmap = new Map<String, List<Price_Book_Entry_Scaled_Pricing__c>>();
        Price_Book_Entry__c pbe;
        Price_Book_Entry pbEntry;
        String pbeid;
        try {
            for (Price_Book_Entry pbe1 : pbEntries) {
                pbes.add(pbe1.priceBookEntry);
            }
            upsert pbes; 
            //rc.priceBookEntries = pbes;
            for (Integer n = 0; n < pbEntries.size(); n++) {
                pbEntry = pbEntries.get(n);
                pbe = pbes.get(n);
                pbescales2 = new List<Price_Book_Entry_Scaled_Pricing__c>();
                pbescales2.addAll(pbEntry.pbEntryScales);
                for (Price_Book_Entry_Scaled_Pricing__c pbes2 : pbescales2) {
                    if (pbes2.Price_Book_Entry__c == null) {pbes2.Price_Book_Entry__c = pbe.Id;}
                }
                pbescales1.addAll(pbescales2); 
                
        		scalesToDelete.addAll(pbEntry.pbEntryScalesToDelete);
            }
            upsert pbescales1; 
            //rc.priceBookEntryScales = pbescales1;
            pbescales2 = new List<Price_Book_Entry_Scaled_Pricing__c>();
            for (Price_Book_Entry_Scaled_Pricing__c pbes1 : pbescales1) {
                pbeid = pbes1.Price_Book_Entry__c;
                if (pmap.containsKey(pbeid)) {
                    pbescales2 = pmap.get(pbeid);
                } else {
                    pbescales2 = new List<Price_Book_Entry_Scaled_Pricing__c>();
                }
                pbescales2.add(pbes1);
                pmap.put(pbeid, pbescales2);
            }
            pbEntries = new List<Price_Book_Entry>();
            for (Price_Book_Entry__c pbe2 : pbes) {
                pbeid = pbe2.Id;
                if (pmap.containsKey(pbeid)) {
                    pbescales2 = pmap.get(pbeid);
                    pbEntry = new Price_Book_Entry();
                    pbEntry.priceBookEntry = pbe2;
                    pbEntry.pbEntryScales = pbescales2;
                    pbEntries.add(pbEntry);
                }
            }
            rc.pbEntries = pbEntries;
            
	        List<Price_Book_Entry_Scaled_Pricing__c> itemsToDelete = new List<Price_Book_Entry_Scaled_Pricing__c>();
	            
	        for (Integer i=0;i<scalesToDelete.size();i++) {
	        	Price_Book_Entry_Scaled_Pricing__c scaleToDelete = scalesToDelete[i];
				System.debug('*** scaleToDelete = ' + scaleToDelete);
	        	if (scaleToDelete.Id != null) {
					System.debug('*** Skipping blank scale...');
					itemsToDelete.add(scaleToDelete);
	        	}
	        }

	        System.debug('*** itemsToDelete.size() = ' + itemsToDelete.size());
	        System.debug('*** itemsToDelete.isEmpty() = ' + itemsToDelete.isEmpty());
	        
	        if (!itemsToDelete.isEmpty()) {
				System.debug('*** trying to delete items');
		        System.debug('*** itemsToDelete = ' + itemsToDelete);
	        	delete itemsToDelete;
				System.debug('*** items deleted');
	        }
        } 
        catch (Exception e) {
            addMessage('upsertPriceBookEntries', e, rc);
            rc.saveFailed = true;
            Database.rollback(sp);  
        }
        
        return rc;
    }
    
    webservice static ReturnClass upsertPriceBookService(
        Price_Book_Service__c pbService) {
            
        ReturnClass rc = new ReturnClass();
        
        savepoint sp = Database.setSavepoint();
        
        try {
            upsert pbService;
            rc.priceBookService = pbService;
        } 
        catch (Exception e) {
            addMessage('upsertPriceBookService', e, rc);
            rc.saveFailed = true;
            Database.rollback(sp);  
        }
        
        return rc;
    }

    webservice static ReturnClass upsertPricingCondition(
        Pricing_Condition__c pricingCondition, 
        List<Pricing_Condition_Scaled_Pricing__c> scaledPricing,
        List<Pricing_to_Competitor__c> pricingtoCompetitors) {
            
        ReturnClass rc = new ReturnClass();
        
        savepoint sp = Database.setSavepoint();
        
        try {
            upsert pricingCondition;
            rc.pricingCondition = pricingCondition;
            
            if (notEmpty(scaledPricing)) {
                for (Pricing_Condition_Scaled_Pricing__c i : scaledPricing)
                    {i.Pricing_Condition__c = pricingCondition.Id;}
                try {
                    upsert scaledPricing;
                    rc.pricingConditionScales = scaledPricing;
                } catch(Exception e) {addMessage('upsertPCScales', e, rc);}
            }

            if (notEmpty(pricingtoCompetitors)) {
                for (Pricing_to_Competitor__c i : pricingtoCompetitors)
                    {i.Pricing_Condition__c = pricingCondition.Id;}
                try {
                    upsert pricingtoCompetitors;
                    rc.pricingCompetitors = pricingtoCompetitors;
                } catch(Exception e) {addMessage('upsertPCCompetitors', e, rc);}
            }

        } catch (Exception e) {
            addMessage('upsertPricingCondition', e, rc);
            rc.saveFailed = true;
            Database.rollback(sp);  
        }
        
       return rc;
    }

}
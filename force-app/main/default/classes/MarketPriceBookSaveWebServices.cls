global class MarketPriceBookSaveWebServices {

    private static final Integer MAX_RECS = 10000;
    
    global class ReturnClass {
    
        webservice Market_Price_Book__c                             marketPriceBook;
        webservice Market_Price_Book_Entry__c                       marketPriceBookEntry;

        webservice List<Market_Price_Book_Country__c>               marketPriceBookCountries;
        webservice List<Market_Price_Book_Customer_Group_1__c>      marketPriceBookCustGroup1s;
        webservice List<Market_Price_Book_Dist_Channel__c>          marketPriceBookDistChannels;
        webservice List<Market_Price_Book_Division__c>              marketPriceBookDivisions;
        webservice List<Market_Price_Book_Family__c>                marketPriceBookFamilies;
        webservice List<Market_Price_Book_IncoTerm__c>              marketPriceBookIncoTerms;
        webservice List<Market_Price_Book_PAC_Industry_Segment__c>  marketPriceBookPACIndustrySegments;
        webservice List<Market_Price_Book_Product_Line__c>          marketPriceBookProductLines;
        webservice List<Market_Price_Book_Sales_Org__c>             marketPriceBookSalesOrgs;
        webservice List<Market_Price_Book_Segment__c>               marketPriceBookSegments;
        webservice List<Market_Price_Book_Sub_Segment__c>           marketPriceBookSubSegments;
        webservice List<Market_Price_Book_VCP_Rating__c>            marketPriceBookVCPRatings;
        webservice List<Market_Price_Book_Default_Scale__c>         marketPriceBookDefaultScales;
        webservice List<Market_Price_Book_Work_When_Approved__c>    marketPriceBookWorkWhenApproved;
        webservice List<Market_Price_Book_Entry__c>                 marketPriceBookEntries;
        webservice List<Market_Price_Book_Scaled_Pricing_Entry__c>  marketPriceBookEntryScales;
        webservice List<Market_Price_Book_Entry>                    mpbEntries;

        webservice String                                    returnMessage = '';
        webservice Boolean                                   saveFailed = false;
        
    }

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

    webservice static ReturnClass upsertMarketPriceBook(
        Market_Price_Book__c marketpriceBook, 
        List<Market_Price_Book_Country__c>               countries_to_Upsert,          
        List<Market_Price_Book_Customer_Group_1__c>      custGroup1s_to_Upsert,        
        List<Market_Price_Book_Dist_Channel__c>          distChannels_to_Upsert,       
        List<Market_Price_Book_Division__c>              divisions_to_Upsert,       
        List<Market_Price_Book_Family__c>                families_to_Upsert,          
        List<Market_Price_Book_IncoTerm__c>              incoTerms_to_Upsert,          
        List<Market_Price_Book_PAC_Industry_Segment__c>  PACIndustrySegments_to_Upsert,
        List<Market_Price_Book_Product_Line__c>          productLines_to_Upsert,
        List<Market_Price_Book_Sales_Org__c>             salesOrgs_to_Upsert,       
        List<Market_Price_Book_Segment__c>               segments_to_Upsert,          
        List<Market_Price_Book_Sub_Segment__c>           subSegments_to_Upsert,   
        List<Market_Price_Book_VCP_Rating__c>            vcpRatings_to_Upsert,   
        List<Market_Price_Book_Default_Scale__c>         defaultScales_to_Upsert,   
             
        List<Market_Price_Book_Country__c>               countries_to_Delete,          
        List<Market_Price_Book_Customer_Group_1__c>      custGroup1s_to_Delete,        
        List<Market_Price_Book_Dist_Channel__c>          distChannels_to_Delete,       
        List<Market_Price_Book_Division__c>              divisions_to_Delete,       
        List<Market_Price_Book_Family__c>                families_to_Delete,          
        List<Market_Price_Book_IncoTerm__c>              incoTerms_to_Delete,          
        List<Market_Price_Book_PAC_Industry_Segment__c>  PACIndustrySegments_to_Delete,
        List<Market_Price_Book_Product_Line__c>          productLines_to_Delete,
        List<Market_Price_Book_Sales_Org__c>             salesOrgs_to_Delete,       
        List<Market_Price_Book_Segment__c>               segments_to_Delete,          
        List<Market_Price_Book_Sub_Segment__c>           subSegments_to_Delete,        
        List<Market_Price_Book_VCP_Rating__c>            vcpRatings_to_Delete,        
        List<Market_Price_Book_Default_Scale__c>         defaultScales_to_Delete        
        ) 
        {
        	return MarketPriceBookSaveWebServices.upsertMarketPriceBookV2(
	            marketpriceBook,           
	            countries_to_Upsert,           
				custGroup1s_to_Upsert,         
				distChannels_to_Upsert,        
				divisions_to_Upsert,           
				families_to_Upsert,            
				incoTerms_to_Upsert,           
				PACIndustrySegments_to_Upsert, 
				productLines_to_Upsert,        
				salesOrgs_to_Upsert,           
				segments_to_Upsert,            
				subSegments_to_Upsert,         
				vcpRatings_to_Upsert,          
				defaultScales_to_Upsert,       
				new List<Market_Price_Book_Work_When_Approved__c>(),       
				countries_to_Delete,           
				custGroup1s_to_Delete,         
				distChannels_to_Delete,        
				divisions_to_Delete,           
				families_to_Delete,            
				incoTerms_to_Delete,           
				PACIndustrySegments_to_Delete, 
				productLines_to_Delete,        
				salesOrgs_to_Delete,           
				segments_to_Delete,            
				subSegments_to_Delete,         
				vcpRatings_to_Delete,          
				defaultScales_to_Delete,        
				new List<Market_Price_Book_Work_When_Approved__c>()        
        	);
        }

    webservice static ReturnClass upsertMarketPriceBookV2(
        Market_Price_Book__c marketpriceBook, 
        List<Market_Price_Book_Country__c>               countries_to_Upsert,          
        List<Market_Price_Book_Customer_Group_1__c>      custGroup1s_to_Upsert,        
        List<Market_Price_Book_Dist_Channel__c>          distChannels_to_Upsert,       
        List<Market_Price_Book_Division__c>              divisions_to_Upsert,       
        List<Market_Price_Book_Family__c>                families_to_Upsert,          
        List<Market_Price_Book_IncoTerm__c>              incoTerms_to_Upsert,          
        List<Market_Price_Book_PAC_Industry_Segment__c>  PACIndustrySegments_to_Upsert,
        List<Market_Price_Book_Product_Line__c>          productLines_to_Upsert,
        List<Market_Price_Book_Sales_Org__c>             salesOrgs_to_Upsert,       
        List<Market_Price_Book_Segment__c>               segments_to_Upsert,          
        List<Market_Price_Book_Sub_Segment__c>           subSegments_to_Upsert,   
        List<Market_Price_Book_VCP_Rating__c>            vcpRatings_to_Upsert,   
        List<Market_Price_Book_Default_Scale__c>         defaultScales_to_Upsert,   
        List<Market_Price_Book_Work_When_Approved__c>    workWhenApproved_to_Upsert,   
        List<Market_Price_Book_Country__c>               countries_to_Delete,          
        List<Market_Price_Book_Customer_Group_1__c>      custGroup1s_to_Delete,        
        List<Market_Price_Book_Dist_Channel__c>          distChannels_to_Delete,       
        List<Market_Price_Book_Division__c>              divisions_to_Delete,       
        List<Market_Price_Book_Family__c>                families_to_Delete,          
        List<Market_Price_Book_IncoTerm__c>              incoTerms_to_Delete,          
        List<Market_Price_Book_PAC_Industry_Segment__c>  PACIndustrySegments_to_Delete,
        List<Market_Price_Book_Product_Line__c>          productLines_to_Delete,
        List<Market_Price_Book_Sales_Org__c>             salesOrgs_to_Delete,       
        List<Market_Price_Book_Segment__c>               segments_to_Delete,          
        List<Market_Price_Book_Sub_Segment__c>           subSegments_to_Delete,        
        List<Market_Price_Book_VCP_Rating__c>            vcpRatings_to_Delete,        
        List<Market_Price_Book_Default_Scale__c>         defaultScales_to_Delete,        
        List<Market_Price_Book_Work_When_Approved__c>    workWhenApproved_to_Delete        
        ) 
        {
        ReturnClass rc = new ReturnClass();
        
        savepoint sp = Database.setSavepoint();
        
        try {

            if (notEmpty(countries_to_Delete)) {delete(countries_to_Delete);}
            if (notEmpty(custGroup1s_to_Delete))   {delete(custGroup1s_to_Delete);}
            if (notEmpty(distChannels_to_Delete))  {delete(distChannels_to_Delete);}
            if (notEmpty(divisions_to_Delete))    {delete(divisions_to_Delete);}
            if (notEmpty(families_to_Delete))  {delete(families_to_Delete);}
            if (notEmpty(incoTerms_to_Delete))  {delete(incoTerms_to_Delete);}
            if (notEmpty(PACIndustrySegments_to_Delete))  {delete(PACIndustrySegments_to_Delete);}
            if (notEmpty(productLines_to_Delete))  {delete(productLines_to_Delete);}
            if (notEmpty(salesOrgs_to_Delete))  {delete(salesOrgs_to_Delete);}
            if (notEmpty(segments_to_Delete))  {delete(segments_to_Delete);}
            if (notEmpty(subSegments_to_Delete))  {delete(subSegments_to_Delete);}
            if (notEmpty(vcpRatings_to_Delete))  {delete(vcpRatings_to_Delete);}
            if (notEmpty(defaultScales_to_Delete))  {delete(defaultScales_to_Delete);}
            if (notEmpty(workWhenApproved_to_Delete))  {delete(workWhenApproved_to_Delete);}
            
            upsert marketpriceBook;
            rc.marketpriceBook = marketpriceBook;
            
            if (notEmpty(countries_to_Upsert)) {
                for (Market_Price_Book_Country__c i : countries_to_Upsert) {
                    if (i.Market_Price_Book__c == null) {i.Market_Price_Book__c = marketPriceBook.Id;}
                }
                try {
                	System.debug('*** upserting Countries... ' + countries_to_Upsert.size());
                    upsert countries_to_Upsert;
                    rc.marketPriceBookCountries = countries_to_Upsert;
                } catch(Exception e) {addMessage('upsert_marketPriceBookCountries', e, rc);System.debug('*** An Error occurred - ' + e);}
            }

            if (notEmpty(custGroup1s_to_Upsert)) {
            	System.debug('*** custGroup1s_to_Upsert Details = ' + custGroup1s_to_Upsert);
                for (Market_Price_Book_Customer_Group_1__c i : custGroup1s_to_Upsert) {
                    if (i.Market_Price_Book__c == null) {i.Market_Price_Book__c = marketPriceBook.Id;}
                }
                try {
                    upsert custGroup1s_to_Upsert;
                    rc.marketPriceBookCustGroup1s = custGroup1s_to_Upsert;
                } catch(Exception e) {addMessage('upsert_marketPriceBookCustGroup1s', e, rc);}
            }

            if (notEmpty(distChannels_to_Upsert)) {
                for (Market_Price_Book_Dist_Channel__c i : distChannels_to_Upsert) {
                    if (i.Market_Price_Book__c == null) {i.Market_Price_Book__c = marketPriceBook.Id;}
                }
                try {
                    upsert distChannels_to_Upsert;
                    rc.marketPriceBookDistChannels = distChannels_to_Upsert;
                } catch(Exception e) {addMessage('upsert_marketPriceBookDistChannels', e, rc);}
            }

            if (notEmpty(divisions_to_Upsert)) {
                for (Market_Price_Book_Division__c i : divisions_to_Upsert) {
                    if (i.Market_Price_Book__c == null) {i.Market_Price_Book__c = marketPriceBook.Id;}
                }
                try {
                    upsert divisions_to_Upsert;
                    rc.marketPriceBookDivisions = divisions_to_Upsert;
                } catch(Exception e) {addMessage('upsert_marketPriceBookDivisions', e, rc);}
            }

            if (notEmpty(families_to_Upsert)) {
                for (Market_Price_Book_Family__c i : families_to_Upsert) {
                    if (i.Market_Price_Book__c == null) {i.Market_Price_Book__c = marketPriceBook.Id;}
                }
                try {
                    upsert families_to_Upsert;
                    rc.marketPriceBookFamilies = families_to_Upsert;
                } catch(Exception e) {addMessage('upsert_marketPriceBookFamilies', e, rc);}
            }

            if (notEmpty(incoTerms_to_Upsert)) {
                for (Market_Price_Book_IncoTerm__c i : incoTerms_to_Upsert) {
                    if (i.Market_Price_Book__c == null) {i.Market_Price_Book__c = marketPriceBook.Id;}
                }
                try {
                    upsert incoTerms_to_Upsert;
                    rc.marketPriceBookIncoTerms = incoTerms_to_Upsert;
                } catch(Exception e) {addMessage('upsert_marketPriceBookIncoTerms', e, rc);}
            }

            if (notEmpty(PACIndustrySegments_to_Upsert)) {
                for (Market_Price_Book_PAC_Industry_Segment__c i : PACIndustrySegments_to_Upsert) {
                    if (i.Market_Price_Book__c == null) {i.Market_Price_Book__c = marketPriceBook.Id;}
                }
                try {
                    upsert PACIndustrySegments_to_Upsert;
                    rc.marketPriceBookPACIndustrySegments = PACIndustrySegments_to_Upsert;
                } catch(Exception e) {addMessage('upsert_marketPriceBookPACIndustrySegments', e, rc);}
            }

            if (notEmpty(productLines_to_Upsert)) {
                for (Market_Price_Book_Product_Line__c i : productLines_to_Upsert) {
                    if (i.Market_Price_Book__c == null) {i.Market_Price_Book__c = marketPriceBook.Id;}
                }
                try {
                    upsert productLines_to_Upsert;
                    rc.marketPriceBookProductLines = productLines_to_Upsert;
                } catch(Exception e) {addMessage('upsert_marketPriceBookProductLines', e, rc);}
            }

           if (notEmpty(salesOrgs_to_Upsert)) {
                for (Market_Price_Book_Sales_Org__c i : salesOrgs_to_Upsert) {
                    if (i.Market_Price_Book__c == null) {i.Market_Price_Book__c = marketPriceBook.Id;}
                }
                try {
                    upsert salesOrgs_to_Upsert;
                    rc.marketPriceBookSalesOrgs = salesOrgs_to_Upsert;
                } catch(Exception e) {addMessage('upsert_marketPriceBookSalesOrgs', e, rc);}
            }

           if (notEmpty(segments_to_Upsert)) {
                for (Market_Price_Book_Segment__c i : segments_to_Upsert) {
                    if (i.Market_Price_Book__c == null) {i.Market_Price_Book__c = marketPriceBook.Id;}
                }
                try {
                    upsert segments_to_Upsert;
                    rc.marketPriceBookSegments = segments_to_Upsert;
                } catch(Exception e) {addMessage('upsert_marketPriceBookSegments', e, rc);}
            }

            if (notEmpty(subSegments_to_Upsert)) {
                for (Market_Price_Book_Sub_Segment__c i : subSegments_to_Upsert) {
                    if (i.Market_Price_Book__c == null) {i.Market_Price_Book__c = marketPriceBook.Id;}
                }
                try {
                    upsert subSegments_to_Upsert;
                    rc.marketPriceBookSubSegments = subSegments_to_Upsert;
                } catch(Exception e) {addMessage('upsert_marketPriceBookSubSegments', e, rc);}
            }

            if (notEmpty(vcpRatings_to_Upsert)) {
                for (Market_Price_Book_VCP_Rating__c i : vcpRatings_to_Upsert) {
                    if (i.Market_Price_Book__c == null) {i.Market_Price_Book__c = marketPriceBook.Id;}
                }
                try {
                    upsert vcpRatings_to_Upsert;
                    rc.marketPriceBookVCPRatings = vcpRatings_to_Upsert;
                } catch(Exception e) {addMessage('upsert_marketPriceBookVCPRatings', e, rc);}
            }

            if (notEmpty(defaultScales_to_Upsert)) {
            	System.debug('*** upserting defaultScales_to_Upsert... ' + defaultScales_to_Upsert.size());
            	System.debug('*** defaultScales_to_Upsert Details = ' + defaultScales_to_Upsert);
                for (Market_Price_Book_Default_Scale__c i : defaultScales_to_Upsert) {
	            	System.debug('*** i.Market_Price_Book__c = ' + i.Market_Price_Book__c);
	            	System.debug('*** i = ' + i);
                    if (i.Market_Price_Book__c == null) {i.Market_Price_Book__c = marketPriceBook.Id;}
                }
                try {
	            	System.debug('*** defaultScales_to_Upsert Details = ' + defaultScales_to_Upsert);
                    upsert defaultScales_to_Upsert;
                    rc.marketPriceBookDefaultScales = defaultScales_to_Upsert;
                } catch(Exception e) {addMessage('upsert_marketPriceBookDefaultScales', e, rc);System.debug('*** error - ' + e);}
            }

            if (notEmpty(workWhenApproved_to_Upsert)) {
                for (Market_Price_Book_Work_When_Approved__c i : workWhenApproved_to_Upsert) {
                    if (i.Market_Price_Book__c == null) {i.Market_Price_Book__c = marketPriceBook.Id;}
                }
                try {
                    upsert workWhenApproved_to_Upsert;
                    rc.marketPriceBookWorkWhenApproved = workWhenApproved_to_Upsert;
                } catch(Exception e) {addMessage('upsert_marketPriceBookWorkWhenApproved', e, rc);}
            }

        } catch (Exception e) {
            addMessage('upsertMarketPriceBook', e, rc);
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

    webservice static ReturnClass upsertMarketPriceBookEntry(
        Market_Price_Book_Entry__c mpbEntry, 
        List<Market_Price_Book_Scaled_Pricing_Entry__c> mpbEntryScales) {
            
        ReturnClass rc = new ReturnClass();
        
        savepoint sp = Database.setSavepoint();
        
        try {
            upsert mpbEntry;
            rc.marketPriceBookEntry = mpbEntry;
            
            for (Market_Price_Book_Scaled_Pricing_Entry__c i : mpbEntryScales) {
                if (i.Market_Price_Book_Entry__c == null) {i.Market_Price_Book_Entry__c = mpbEntry.Id;}
            }

            upsert mpbEntryScales;
            rc.marketPriceBookEntryScales = mpbEntryScales;
        } 
        catch (Exception e) {
            addMessage('upsertMarketPriceBookEntry', e, rc);
            rc.saveFailed = true;
            Database.rollback(sp);  
        }
        
        return rc;
    }


  webservice static ReturnClass upsertMarketPriceBookEntries(
        List<Market_Price_Book_Entry> mpbEntries) {
        
        ReturnClass rc = new ReturnClass();
        
        savepoint sp = Database.setSavepoint();
        
        List<Market_Price_Book_Entry__c> mpbes = new List<Market_Price_Book_Entry__c>();
        List<Market_Price_Book_Scaled_Pricing_Entry__c> mpbescales1 = new List<Market_Price_Book_Scaled_Pricing_Entry__c>(); 
        List<Market_Price_Book_Scaled_Pricing_Entry__c> mpbescales2;
        List<Market_Price_Book_Scaled_Pricing_Entry__c> scalesToDelete = new List<Market_Price_Book_Scaled_Pricing_Entry__c>();
        Map<String, List<Market_Price_Book_Scaled_Pricing_Entry__c>> pmap = new Map<String, List<Market_Price_Book_Scaled_Pricing_Entry__c>>();
        Market_Price_Book_Entry__c mpbe;
        Market_Price_Book_Entry mpbEntry;
        String mpbeid;
        try {
            for (Market_Price_Book_Entry mpbe1 : mpbEntries) {
                mpbes.add(mpbe1.marketPriceBookEntry);
            }
            upsert mpbes; 
            //rc.priceBookEntries = pbes;
            for (Integer n = 0; n < mpbEntries.size(); n++) {
                mpbEntry = mpbEntries.get(n);
                mpbe = mpbes.get(n);
                mpbescales2 = new List<Market_Price_Book_Scaled_Pricing_Entry__c>();
                mpbescales2.addAll(mpbEntry.mpbEntryScales);
                for (Market_Price_Book_Scaled_Pricing_Entry__c mpbes2 : mpbescales2) {
	               	System.debug('*** mpbe = ' + mpbe);
	               	System.debug('*** Scale Record - mpbes2.Market_Price_Book_Entry__c = ' + mpbes2.Market_Price_Book_Entry__c);
                    if (mpbes2.Market_Price_Book_Entry__c == null) {mpbes2.Market_Price_Book_Entry__c = mpbe.Id;}
                }
                mpbescales1.addAll(mpbescales2);
                
        		scalesToDelete.addAll(mpbEntry.mpbEntryScalesToDelete);
            }
            upsert mpbescales1; 

            mpbescales2 = new List<Market_Price_Book_Scaled_Pricing_Entry__c>();
            for (Market_Price_Book_Scaled_Pricing_Entry__c mpbes1 : mpbescales1) {
                mpbeid = mpbes1.Market_Price_Book_Entry__c;
                if (pmap.containsKey(mpbeid)) {
                    mpbescales2 = pmap.get(mpbeid);
                } else {
                    mpbescales2 = new List<Market_Price_Book_Scaled_Pricing_Entry__c>();
                }
                mpbescales2.add(mpbes1);
                pmap.put(mpbeid, mpbescales2);
            }
            mpbEntries = new List<Market_Price_Book_Entry>();
            for (Market_Price_Book_Entry__c mpbe2 : mpbes) {
                mpbeid = mpbe2.Id;
                if (pmap.containsKey(mpbeid)) {
                    mpbescales2 = pmap.get(mpbeid);
                    mpbEntry = new Market_Price_Book_Entry();
                    mpbEntry.marketPriceBookEntry = mpbe2;
                    mpbEntry.mpbEntryScales = mpbescales2;
                    mpbEntries.add(mpbEntry);
                }
            }
            rc.mpbEntries = mpbEntries;

	        List<Market_Price_Book_Scaled_Pricing_Entry__c> itemsToDelete = new List<Market_Price_Book_Scaled_Pricing_Entry__c>();
	            
	        for (Integer i=0;i<scalesToDelete.size();i++) {
	        	Market_Price_Book_Scaled_Pricing_Entry__c scaleToDelete = scalesToDelete[i];
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
            addMessage('upsertMarketPriceBookEntries', e, rc);
            rc.saveFailed = true;
            Database.rollback(sp);  
        }
        
        return rc;
    }

}
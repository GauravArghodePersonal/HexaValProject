@isTest
private class Price_Book_Entry_Test {
         static testMethod void Price_Book_EntryMethod() {
           Price_Book_Entry_Scaled_Pricing__c scaledPricing = new Price_Book_Entry_Scaled_Pricing__c();
           String materialNumber = 'number';
           String pricingScales = 'price';
           Integer recordNumber = 1;
           
           Price_Book_Entry__c priceBookEntry = new  Price_Book_Entry__c();
           String pbEntryId = 'pbid';
           String pbEntryScaleId = 'pbscaleid';
           Double floorPrice = 0.00;
           Double marketPrice = 0.00;
           Double targetGPPct = 0.00;
           List<Price_Book_Entry_Scaled_Pricing__c> pbEntryScales = new List<Price_Book_Entry_Scaled_Pricing__c>();
           List<Price_Book_Entry_Scaled_Pricing__c> pbEntryScalesToDelete = new List<Price_Book_Entry_Scaled_Pricing__c>();
           Double annualVolume = 1;
           List<Price_Book_Entry_Scaled_Pricing__c> splist = new  List<Price_Book_Entry_Scaled_Pricing__c>();
           splist.add(scaledPricing);
           String v = 'test';
           List<Price_Book_Entry_Scaled_Pricing__c> spa = new List<Price_Book_Entry_Scaled_Pricing__c>();
           Price_Book_Entry_Scaled_Pricing__c scaledPricing1 = new Price_Book_Entry_Scaled_Pricing__c();
           spa.add(scaledPricing1);
           
           Price_Book_Entry pr = new Price_Book_Entry();
           Price_Book_Entry pr1 = new Price_Book_Entry(priceBookEntry);
           Price_Book_Entry pr2 = new Price_Book_Entry(priceBookEntry,annualVolume);
           
           System.assertEquals(materialNumber,'number');
           System.assertEquals(pricingScales,'price');
           System.assertEquals(recordNumber,1);
           System.assertEquals(pbEntryId,'pbid');
           System.assertEquals(pbEntryScaleId,'pbscaleid');
           System.assertEquals(floorPrice,0.00);
           System.assertEquals(marketPrice,0.00);
           System.assertEquals(targetGPPct,0.00);
         }  
    }
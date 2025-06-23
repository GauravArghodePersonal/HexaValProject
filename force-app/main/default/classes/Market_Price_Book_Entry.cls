global with sharing class Market_Price_Book_Entry {

    public Market_Price_Book_Scaled_Pricing_Entry__c scaledPricing {get; set;}
    public String materialNumber {get; set;}
    public String pricingScales {get; set;}
    
    webservice Market_Price_Book_Entry__c marketPriceBookEntry {get; set;}
    webservice String mpbEntryId {get; set;}
    webservice String mpbEntryScaleId {get; set;}
    webservice Double floorPrice {get; set;}
    webservice Double marketPrice {get; set;}
    webservice Double targetGPPct {get; set;}
    webservice Double quantitySurcharge {get; set;}
    webservice List<Market_Price_Book_Scaled_Pricing_Entry__c> mpbEntryScales {get; set;}
    webservice List<Market_Price_Book_Scaled_Pricing_Entry__c> mpbEntryScalesToDelete {get; set;}


    public Market_Price_Book_Entry() {}

    public Market_Price_Book_Entry(Market_Price_Book_Entry__c p) {
        marketPriceBookEntry = p;
        mpbEntryId = p.Id;
        //targetGPPct = p.GPPct__c;
        //materialNumber = String_Functions.removeLeadingZeros(p.Material_Number__c);
        if (p.Market_Price_Book_Scaled_Pricing_Entries__r == null || 
            p.Market_Price_Book_Scaled_Pricing_Entries__r.isEmpty()) {
            scaledPricing = null;
            mpbEntryScales = null;
        } else {
          mpbEntryScales = p.Market_Price_Book_Scaled_Pricing_Entries__r;
            scaledPricing = p.Market_Price_Book_Scaled_Pricing_Entries__r[0];
            setPricingScales(p.Market_Price_Book_Scaled_Pricing_Entries__r);
        }
    }
    
    public Market_Price_Book_Entry(Market_Price_Book_Entry__c p,
                            Double annualVolume) {
      this(p);
      setScaledPricing(annualVolume);
    }
    
    private void setScaledPricing(Double annualVolume) {
        List<Market_Price_Book_Scaled_Pricing_Entry__c> splist = marketPriceBookEntry.Market_Price_Book_Scaled_Pricing_Entries__r;
        if (splist != null && !splist.isEmpty()) {
            scaledPricing = splist[0];
            Double minVolume, maxVolume;
            for (Market_Price_Book_Scaled_Pricing_Entry__c sp : splist) {
                minVolume = sp.Minimum_Volume__c;
                if (annualVolume >= minVolume) {
                    scaledPricing = sp;
                }
            }
        }
        if (scaledPricing != null) {
          mpbEntryScaleId = scaledPricing.Id;
          floorPrice = scaledPricing.Floor_Price__c;
          marketPrice = scaledPricing.Selling_Price__c;
          quantitySurcharge = scaledPricing.Quantity_Surcharge__c;
        }
    }
    
    private void setPricingScales(List<Market_Price_Book_Scaled_Pricing_Entry__c> spa) {
        String s = '';
        if (spa.size() > 1) {
            s += '<table class="pscales">';
            String maxVol;
            for (Market_Price_Book_Scaled_Pricing_Entry__c sp : spa) {
                maxVol = '-';
                if (sp.Maximum_Volume__c > 0) {
                    maxVol = ''+sp.Maximum_Volume__c;
                }
                s += '<tr>';
                s += getPricingScaleCell(''+sp.Minimum_Volume__c);
                s += getPricingScaleCell(maxVol);
                s += getPricingScaleCell(''+sp.Floor_Price__c);
                s += getPricingScaleCell(''+sp.Selling_Price__c);
                s += '</tr>';
            }
            s += '</table>';
        }
        pricingScales = s;
    }
    
    private String getPricingScaleCell(String v) {
        return '<td>' + v + '</td>';
    }

    /********************************
     * Market Pricing Batch Routines
     ********************************/
     
    public static void processMarketPriceBookEntryChanges(List<Id> marketPriceBookEntryIds) {
        List<Market_Price_Book_Entry__c> marketPriceBookEntries;
        
        try {
            marketPriceBookEntries = [SELECT Id,
                                             Selling_UOM__c,
                                             Volume_UOM__c,
                                        (SELECT Id,
                                                Minimum_Volume__c,
                                                Maximum_Volume__c,
                                                Floor_Price__c,
                                                Selling_Price__c,
                                                Quantity_Surcharge__c,
                                                Surcharge__c
                                           FROM Market_Price_Book_Scaled_Pricing_Entries__r
                                         ORDER BY Minimum_Volume__c)
                                   FROM Market_Price_Book_Entry__c 
                                  WHERE Id IN :marketPriceBookEntryIds];
        }   
        catch (Exception e) {
            marketPriceBookEntries = new List<Market_Price_Book_Entry__c>();
        }   
        
        if (!marketPriceBookEntries.isEmpty()) {
            for (Market_Price_Book_Entry__c rec : marketPriceBookEntries) {
                Market_Price_Book_Entry entry = new Market_Price_Book_Entry(rec);
                entry.updateRelatedPricingConditions();
            }
        }
     }
 
     public String updateRelatedPricingConditions() {
        List<Pricing_Condition__c> pricingConditionsToUpdate;
        
        pricingConditionsToUpdate = [SELECT Id, 
                                            Selling_UOM__c, 
                                            Volume_UOM__c, 
                                            Market_Pricing_Type__c,
                                            Market_Pricing_Adjustment_Type__c,
                                            Market_Pricing_Adjustment_Value__c,
                                            Record_Status__c,
                                            Comments__c,
                                            Account_Sales_Office__c,
                                            Account_Sales_Group__c,
                                            Valid_From_Date__c,
                                            Valid_To_Date__c,
                                            Account__c,
                                            Account__r.AccountNumber,
                                            Material2__c,
                                            Material2__r.Material_Number__c,
                                            SAP_Pricing_Table__c,
                                            Dist_Channel_Code__c,
                                            Product_Hierarchy__r.Product_Hierarchy5__r.Product_Hierarchy_Description__c,
                                            Product_Hierarchy__r.Product_Hierarchy6__r.Product_Hierarchy_Description__c,
                                            Product_Hierarchy__r.Product_Hierarchy7__r.Product_Hierarchy_Description__c,
                                            (SELECT Id,
                                                    Pricing_Condition__c,
                                                    Volume_UOM__c,
                                                    Selling_UOM__c,
                                                    Scaled_Selling_Price__c,
                                                    Invoice_Price__c,
                                                    Minimum_Volume__c,
                                                    Maximum_Volume__c,
                                                    Selling_Price__c,
                                                    Quantity_Surcharge__c,
                                                    Surcharge__c 
                                              FROM Pricing_Condition_Scaled_Pricing__r ORDER BY Minimum_Volume__c)
                                       FROM Pricing_Condition__c
                                      WHERE Market_Price_Book_Entry__c = :marketPriceBookEntry.Id];
                                      
        if (!pricingConditionsToUpdate.isEmpty()) {
            for (Pricing_Condition__c rec : pricingConditionsToUpdate) {
                Pricing_Condition pc = new Pricing_Condition(rec); 
                pc.updatePricingwithMarketPriceBookEntry(this);
            }
        }                            
         
        return '';
     }

}
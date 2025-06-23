global with sharing class Price_Book_Entry {

    public Price_Book_Entry_Scaled_Pricing__c scaledPricing {get; set;}
    public String materialNumber {get; set;}
    public String pricingScales {get; set;}
    public Integer recordNumber {get; set;}
    
    webservice Price_Book_Entry__c priceBookEntry {get; set;}
    webservice String pbEntryId {get; set;}
    webservice String pbEntryScaleId {get; set;}
    webservice Double floorPrice {get; set;}
    webservice Double marketPrice {get; set;}
    webservice Double targetGPPct {get; set;}
    webservice List<Price_Book_Entry_Scaled_Pricing__c> pbEntryScales {get; set;}
    webservice List<Price_Book_Entry_Scaled_Pricing__c> pbEntryScalesToDelete {get; set;}

    public Price_Book_Entry() {}

    public Price_Book_Entry(Price_Book_Entry__c p) {this(p, 1);}
    
    public Price_Book_Entry(Price_Book_Entry__c p, Integer recNum) {
        priceBookEntry = p; recordNumber = recNum;
        pbEntryId = p.Id;
        targetGPPct = p.GPPct__c;
        materialNumber = String_Functions.removeLeadingZeros(p.Material_Number__c);
        if (p.Price_Book_Entries_Scaled_Pricing__r == null || 
            p.Price_Book_Entries_Scaled_Pricing__r.isEmpty()) {
            scaledPricing = null;
            pbEntryScales = null;
        } else {
        	pbEntryScales = p.Price_Book_Entries_Scaled_Pricing__r;
            scaledPricing = p.Price_Book_Entries_Scaled_Pricing__r[0];
            setPricingScales(p.Price_Book_Entries_Scaled_Pricing__r);
        }
    }
    
    public Price_Book_Entry(Price_Book_Entry__c p,
                            Double annualVolume) {
    	this(p);
    	setScaledPricing(annualVolume);
    }
    
    private void setScaledPricing(Double annualVolume) {
        List<Price_Book_Entry_Scaled_Pricing__c> splist = priceBookEntry.Price_Book_Entries_Scaled_Pricing__r;
        if (splist != null && !splist.isEmpty()) {
            scaledPricing = splist[0];
            Double minVolume, maxVolume;
            for (Price_Book_Entry_Scaled_Pricing__c sp : splist) {
                minVolume = sp.Minimum_Volume__c;
                if (annualVolume >= minVolume) {
                    scaledPricing = sp;
                }
            }
        }
        if (scaledPricing != null) {
        	pbEntryScaleId = scaledPricing.Id;
        	floorPrice = scaledPricing.Floor_Price__c;
        	marketPrice = scaledPricing.Selling_Price__c;
        }
    }
    
    private void setPricingScales(List<Price_Book_Entry_Scaled_Pricing__c> spa) {
        String s = '';
        if (spa.size() > 1) {
            s += '<table class="pscales">';
            String maxVol;
            for (Price_Book_Entry_Scaled_Pricing__c sp : spa) {
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

}
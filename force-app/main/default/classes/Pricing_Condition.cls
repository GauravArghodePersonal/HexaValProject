public with sharing class Pricing_Condition {

    private static final String ACTIVE    = 'Active';
    private static final String APPROVED  = 'Approved,Not Yet Active';
    private static final String CANCELLED = 'Cancelled';
    private static final String DRAFT     = 'Draft';
    private static final String EXPIRED   = 'Expired';
    private static final String REJECTED  = 'Rejected';
    private static final String SUBMITTED = 'In Approval Process';
    private static final String OTCREJECTED = 'Rejected by OTC';

    private static final String DELIM = '-';
    
    private static final String DIST_CHAN_AHWT = '10';
    private static final String DIST_CHAN_AAFI = '50';

    public Boolean isEditable                    {get; set;}
    public Boolean isExtendable                  {get; set;}
    public Boolean isInvoicePriceChanged         {get; set;}
    public Boolean isSelectable                  {get; set;}
    public Boolean selected                      {get; set;}

    public Date validToDate                      {get; set;}
    public Datetime submittedDateTime            {get; set;}

    public Double basePrice                      {get; set;}
    public Double freightCost                    {get; set;}
    public Double freightMarkup                  {get; set;}
    public Double invoicePrice                   {get; set;}

    public Integer attachmentsCount              {get; set;}
    public Integer recordNumber                  {get; set;}

    public List<Attachment> attachments          {get; set;}
    public List<SelectOption> selOpts1           {get; set;}
    public Pricing_Condition__c activePC         {get; set;}
    public Pricing_Condition__c pricingCondition {get; set;}
    public Set<String> approverEmails            {get; set;}

    public String accountNumber                  {get; set;}
    public String approvers                      {get; set;}
    public String attachmentsExist               {get; set;}
    public String comments                       {get; set;}
    public String commentsExist                  {get; set;}
    public String marketPricingType              {get; set;}
    public String marketPricingTitle             {get; set;}
    public String materialNumber                 {get; set;}
    public String ph5                            {get; set;}
    public String ph6                            {get; set;}
    public String ph7                            {get; set;}
    public String plantId                        {get; set;}
    public String pricingScales                  {get; set;}
    public String salesGroup                     {get; set;}
    public String salesOffice                    {get; set;}
    public String sellerName                     {get; set;}
    public String submittedTime                  {get; set;}
    public String validFromStr                   {get; set;}
    public String validToStr                     {get; set;}

    public Pricing_Condition(Pricing_Condition__c p) {this(p, 1);}
    
    public Pricing_Condition(Pricing_Condition__c p, Integer recNum) {
        debug('p.Material2__r : ' + p.Material2__r);
        pricingCondition = p;
        selected = false; 
        accountNumber = String_Functions.removeLeadingZeros(p.Account__r.AccountNumber);
        materialNumber = String_Functions.removeLeadingZeros(p.Material2__r.Material_Number__c);
        recordNumber = recNum;
        commentsExist = 'No'; 
        attachmentsExist = 'No';
        isEditable = (p.Record_Status__c == ACTIVE ||
                      p.Record_Status__c == APPROVED ||
                      p.Record_Status__c == DRAFT ||
                      p.Record_Status__c == EXPIRED ||
                      p.Record_Status__c == REJECTED ||
                      p.Record_Status__c == OTCREJECTED 
                     );
        isSelectable = (isEditable); isExtendable = true;
        if (p.Comments__c != null && p.Comments__c.trim().length() > 0) {
            commentsExist = 'Yes';
        }
        setPricingScales(p); setMarketPricingType();
        salesOffice = getString(p.Account_Sales_Office__c);
        salesgroup = getString(p.Account_Sales_Group__c);
        ph5 = getString(p.Product_Hierarchy__r.Product_Hierarchy5__r.Product_Hierarchy_Description__c);
        ph6 = getString(p.Product_Hierarchy__r.Product_Hierarchy6__r.Product_Hierarchy_Description__c);
        ph7 = getString(p.Product_Hierarchy__r.Product_Hierarchy7__r.Product_Hierarchy_Description__c);
        validFromStr = getString(p.Valid_From_Date__c);
        validToStr = getString(p.Valid_To_Date__c);
        validToDate = p.Valid_To_Date__c; sellerName = '';
        try {
            sellerName = getString(p.Account__r.Owner.Name);
           // if (p.LISD_Seller__c != null) {sellerName = p.LISD_Seller__r.Name;}
        } catch (Exception e) {}
    }

    private void debug(String s) {System.debug(LoggingLevel.INFO, 'Pricing_Condition : ' + s);}

    private String getString(String s) {
        return (s != null ? s : '');
    }
    
    private String getString(Boolean b) {
        if (b == null) {return '';}
        return (b ? 'Yes' : 'No');
    }
    
    private String getString(Date d) {
        return (d != null ? d.format() : '');
    }
    
    private String getString(Datetime d) {
        return (d != null ? d.format() : '');
    }
    
    private String getString(Decimal d) {
        return (d != null ? d.toPlainString() : '');
    }
    
    private Boolean isAAFI(Pricing_Condition__c p) {
        return (p.Dist_Channel_Code__c == DIST_CHAN_AAFI);
    }
    
    private void setPricingScales(Pricing_Condition__c p) {
        String s = '';
        List<Pricing_Condition_Scaled_Pricing__c> spa = p.Pricing_Condition_Scaled_Pricing__r;
        if (spa != null && !spa.isEmpty()) {
            s += '<table style="border-collapse: collapse; empty-cells: show; width: 100%">';
            String maxVol;
            for (Pricing_Condition_Scaled_Pricing__c sp : spa) {
                s += '<tr>';
                s += getPricingScaleCell(getString(sp.Minimum_Volume__c));
                if (isAAFI(p)) {
                    maxVol = '-';
                    if (sp.Maximum_Volume__c > 0) {
                        maxVol = getString(sp.Maximum_Volume__c);
                    }
                    s += getPricingScaleCell(maxVol);
                }
                s += getPricingScaleCell(sp.Volume_UOM__c);
                s += getPricingScaleCell(getString(sp.Selling_Price__c));
                s += getPricingScaleCell(sp.Selling_UOM__c);
                if (isAAFI(p)) {
                    s += getPricingScaleCell(getString(sp.Surcharge__c));
                    s += getPricingScaleCell(getString(sp.Scaled_Selling_Price__c));
                } else {
                    s += getPricingScaleCell(getString(sp.Invoice_Price__c));
                }
                s += '</tr>';
            }
            s += '</table>';
        }
        pricingScales = s;
    }
    
    private String getPricingScaleCell(String v) {
        return '<td style="border:solid silver 1px; padding:5px; text-align:right; width: 50px;">' + v + '</td>';
    }

    public void setApprovers(Map<Id, Set<String>> amap) {
        String sb = '';
        String k = pricingCondition.Id;
        if (amap != null && amap.containsKey(k)) {
            Set<String> sa = amap.get(k);
            sb += '<table class="approvers">';
            for (String s : sa) {
                sb += '<tr><td>' + s + '</td></tr>';
            }
            sb += '</table>';
        }
        approvers = sb;
    }
    
    public static String getPricingConditionKey(Pricing_Condition__c pc) {
        String k = pc.Account__c + DELIM +
                   pc.Material2__c + DELIM +
                   pc.SAP_Pricing_Table__c;
        if (pc.Dist_Channel_Code__c == DIST_CHAN_AAFI) {
            k = k + DELIM + pc.INCO_Term_Code__c;
        }
        return k;
    }
    
    public void setActivePricingCondition(Map<String, Pricing_Condition__c> pmap) {
        String k = getPricingConditionKey(pricingCondition);
        if (pmap != null && pmap.containsKey(k)) {
            activePC = pmap.get(k);
        }
    }
    
    private void setMarketPricingType() {
        Pricing_Condition__c p = pricingCondition;
        marketPricingType = null; marketPricingTitle = null; 
        String s1 = '', s2 = 'Market Price Book : <br/>';
        if (p.Market_Pricing_Type__c != null && p.Market_Pricing_Type__c.length() > 0) {
            s1 = p.Market_Pricing_Type__c.substring(0,1).toUppercase();
            if ('A'.equals(s1)) {marketPricingType = s1; marketPricingTitle = s2 + 'Associated';} else
            if ('H'.equals(s1)) {marketPricingType = s1; marketPricingTitle = s2 + 'HardWired';} else
            if ('S'.equals(s1)) {marketPricingType = s1; marketPricingTitle = s2 + 'SoftWired';} 
        }
        debug('setMarketPricingType : ' + marketPricingType + ' : ' + marketPricingTitle);
    }
 
    /********************************
     * Market Pricing Batch Routines
     ********************************/ 
    public void updatePricingwithMarketPriceBookEntry(Market_Price_Book_Entry mpbe) {
        
        List<Pricing_Condition_Scaled_Pricing__c> scaledPricingtoDelete = new List<Pricing_Condition_Scaled_Pricing__c>();
        List<Pricing_Condition_Scaled_Pricing__c> scaledPricingtoInsert = new List<Pricing_Condition_Scaled_Pricing__c>();
        
        if ((pricingCondition.Market_Pricing_Type__c == 'hardWired') || (pricingCondition.Market_Pricing_Type__c == 'softWired')) {
            
            // Apply Changes to Pricing Condition
            pricingCondition.Selling_UOM__c = mpbe.marketPriceBookEntry.Selling_UOM__c;
            pricingCondition.Volume_UOM__c = mpbe.marketPriceBookEntry.Volume_UOM__c;
            
            // Apply Changes to Pricing Condition Scaled Pricing
            
            /* process existing records */
            for (Pricing_Condition_Scaled_Pricing__c sp : pricingCondition.Pricing_Condition_Scaled_Pricing__r) {
                scaledPricingtoDelete.add(sp);
            }
            
            /* create new records */
            for (Market_Price_Book_Scaled_Pricing_Entry__c mpbesp : mpbe.mpbEntryScales) {
                Pricing_Condition_Scaled_Pricing__c newScaledPricingRec = new Pricing_Condition_Scaled_Pricing__c();
                newScaledPricingRec.Pricing_Condition__c = pricingCondition.Id;
                newScaledPricingRec.Minimum_Volume__c = mpbesp.Minimum_Volume__c;
                newScaledPricingRec.Maximum_Volume__c = mpbesp.Minimum_Volume__c;
                newScaledPricingRec.Selling_Price__c = mpbesp.Selling_Price__c;
                newScaledPricingRec.Surcharge__c = mpbesp.Surcharge__c;
                
                scaledPricingtoInsert.add(newScaledPricingRec);
            }

            // Perform Currency Conversion if Needed

            // Apply Adjustments if soft wired          
            if (pricingCondition.Market_Pricing_Type__c == 'softWired') {
                for (Pricing_Condition_Scaled_Pricing__c pricingDetail : scaledPricingtoInsert) {
                    if (pricingCondition.Market_Pricing_Adjustment_Type__c == 'Amount') {
                        pricingDetail.Selling_Price__c += pricingCondition.Market_Pricing_Adjustment_Value__c;
                    }
                    
                    if (pricingCondition.Market_Pricing_Adjustment_Type__c == 'Percent') {
                        Decimal adjustmentMultiplier = pricingCondition.Market_Pricing_Adjustment_Value__c / 100;
                        adjustmentMultiplier = adjustmentMultiplier.setScale(4);
                        Decimal adjustmentAmount = pricingDetail.Selling_Price__c * adjustmentMultiplier;
                        adjustmentAmount = adjustmentAmount.setScale(4);
                        pricingDetail.Selling_Price__c += adjustmentAmount;
                    }
                }
            }
        
            // Apply Changes to Salesforce
            delete scaledPricingtoDelete;
            insert scaledPricingtoInsert;
        }
    }   
}
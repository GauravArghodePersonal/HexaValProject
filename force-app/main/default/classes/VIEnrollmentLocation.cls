public class VIEnrollmentLocation {

    public static final String DELIM = '|';

    public Account acc                       {get; private set;}
    public VIAccount viacc                   {get; private set;}
    public VIPromotion vipromo               {get; private set;}
    public VI_Promotion__c promo             {get; private set;}
    public VI_Enrollment__c enrol            {get; private set;}
    public VI_Enrollment_Location__c  enloc  {get; private set;}

    public List<VIEnrollmentLocationMaterial> vielms {get; private set;}
    public List<VI_Enrollment_Location_Material__c> materials {get; set;}
    public Map<String, VI_Enrollment_Location_Material__c> matMap {get; set;}

    public Boolean selected         {get; set;}
    public Boolean isEnrolled       {get; set;}

    public Integer recordNumber     {get; set;}

    public Double totalCost         {get; set;}
    public Double totalQuantity     {get; set;}

    public String enlocId           {get; set;}
    
    public String accountId         {get; private set;}
    public String promotionId       {get; private set;}

    public VIEnrollmentLocation() {init();}
    
    private void init() {
        selected = false; enloc = new VI_Enrollment_Location__c();
        materials = new List<VI_Enrollment_Location_Material__c>();
    }
    
    public VIEnrollmentLocation(VIPromotion p, VIAccount a) {
        viacc = a; vipromo = p; init(); 
    }
    
    public VIEnrollmentLocation(VI_Promotion__c p, Account a) {
        //acc = a;
        viacc = new VIAccount(a);
        vipromo = new VIPromotion(p);
        promo = p; init(); 
    }
    
    public VIEnrollmentLocation(VI_Enrollment__c e) {
        enrol = e; init(); 
    }
    
    public VIEnrollmentLocation(VI_Enrollment__c e, Account a) {
        acc = a; enrol = e; init(); 
    }
    
    public VIEnrollmentLocation(VI_Enrollment_Location__c el) {
        setEnrollmentLocation(el);
        viacc = new VIAccount(el.Location__r);
        materials = el.Enrollment_Location_Materials__r;
        //System.debug(LoggingLevel.INFO, el.Name + ' : ' + materials);
        if (materials == null) {
            materials = new List<VI_Enrollment_Location_Material__c>();
        }
        setMaterialTotals();
    }
    
    public VIEnrollmentLocation(String promoId, String accId) {
    	accountId = accId; promotionId = promoId;
    }
    
    public void setEnrollment(VI_Enrollment__c e) {enrol = e;}

    public VI_Enrollment_Location__c getEnrollmentLocation(String enlocId) {
    	this.enlocId = enlocId; return getEnrollmentLocation();
    }
        
    public VI_Enrollment_Location__c getEnrollmentLocation() {
    	if (enlocId == null) {return enloc;}
		enloc = [select Id, Name, Approval_Date__c,
		                Location__r.Name, Location__r.Owner.Name,
		                Location__r.Promotion_Text_Code__c,
		                Promotion__r.Name, Promotion__r.Program_Code__c, 
		                Shipping_Street__c, Shipping_City__c, 
		                Shipping_State__c, Shipping_Postal_Code__c 
		           from VI_Enrollment_Location__c where Id = :enlocId];
    	return enloc;
    }
    
    public void setEnrollmentLocation(VI_Enrollment_Location__c el) {
    	enloc = el; enlocId = el.Id;
    }
    
    public void setMaterialTotals() {
        totalCost = 0; totalQuantity = 0; String k;
        matMap = new Map<String, VI_Enrollment_Location_Material__c>();
        for (VI_Enrollment_Location_Material__c m : materials) {
            //k = m.Material__c + DELIM + m.Material_SKU__c;
            k = m.Promotion_Material__c;
            matMap.put(k, m);
            Double quantity = m.Quantity__c;
            if ((quantity != null) && (quantity > 0)) {
                totalQuantity += quantity;
                Double cost = m.Cost__c;
                if ((cost != null) && (cost > 0)) {
                    totalCost += (quantity * cost);
                }
            }
        }
    }
    
    public void setEnrollmentMaterials(List<VIEnrollmentLocationMaterial> alist) {
        vielms = alist; materials = new List<VI_Enrollment_Location_Material__c>();
        for (VIEnrollmentLocationMaterial v : vielms) {materials.add(v.elm);}
        setMaterialTotals();
    }

    public List<VI_Enrollment_Material_Order__c> getMaterialsOrdered() {
        return getMaterialsOrdered(enlocId);
    }
    
    public List<VI_Enrollment_Material_Order__c> getMaterialsOrdered(String elocId) {
        List<VI_Enrollment_Material_Order__c> alist = new List<VI_Enrollment_Material_Order__c>(); 
        if (elocId == null) {return alist;}
        alist = [
           select Id, Name, Material__c, Material_SKU__c, Quantity__c
             from VI_Enrollment_Material_Order__c
            where Enrollment_Location_Material__r.Enrollment_Location__c = :elocId
              and Quantity__c > 0
              and Shipped_Date__c = null
         order by Material__c limit 1000];
        return alist;
    }
        
}
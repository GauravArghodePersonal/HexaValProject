public class UOM_Conversion_Functions {

    public static final SelectOption OPTION_NONE = new SelectOption('', '--None--');

    public static final String QTY1 = 'QTY1'; 
    public static final String QTY2 = 'QTY2'; 
    public static final String QTY3 = 'QTY3'; 
    
    public static List<UOM_Conversion__c> UOMConversions;

    private static void debug(String s) {
    	System.debug(LoggingLevel.INFO, 'UOM_Conversion_Functions : ' + s);
    }
    
    public static void populateUOMConversions() {
        if (UOMConversions == null) {
            UOMConversions = [SELECT UOM__c, Qty_Greater_Than_or_Equal_to_5_Gallons__c 
                                FROM UOM_Conversion__c];
        }                                                
    }

    public static Boolean UOMQty_Greater_Than_5_Gallons(String UOM, Double quantity) {
  
        Double UOMQuantity = 0;
    
        populateUOMConversions();
    
        for (UOM_Conversion__c UOMConversion : UOMConversions) {
            if(UOMConversion.UOM__c == UOM) {
            	UOMQuantity = UOMConversion.Qty_Greater_Than_or_Equal_to_5_Gallons__c;
            }
        }
    
        return (quantity > UOMQuantity);
    }

    public static List<SelectOption> getUomSelectOptions(String accountRecordType) {
    	List<SelectOption> slist = new List<SelectOption>();
        //slist.add(OPTION_NONE);
    	for (UOM_Account_Record_Type__c u : [
            select UOM__c from UOM_Account_Record_Type__c
    	     where Account_Record_Type__c = :accountRecordType order by UOM__c]) {
    		slist.add(new SelectOption(u.UOM__c, u.UOM__c));
    	}
    	return slist;
    }
    
    public static Map<String, Map<String, Double>> getSampleQuantities(String accountRecordType) {
    	Map<String, Map<String, Double>> amap = new Map<String, Map<String, Double>>();
		List<UOM_Account_Record_Type__c> ulist = [
            select Sample_Quantity_1__c, Sample_Quantity_2__c, Sample_Quantity_3__c, UOM__c
              from UOM_Account_Record_Type__c 
             where Account_Record_Type__c = :accountRecordType];
        if (ulist == null || ulist.isEmpty()) {return amap;}
        for (UOM_Account_Record_Type__c u : ulist) {
            Map<String, Double> bmap = new Map<String, Double> {
                QTY1 => u.Sample_Quantity_1__c,
                QTY2 => u.Sample_Quantity_2__c,
                QTY3 => u.Sample_Quantity_3__c
            };
            amap.put(u.UOM__c, bmap);
        }
        return amap;
    }

    public static void setRouteForApprovalFlags(Sample_Request__c sampleRequest,
                                                Map<String, Double> qmap, Double msq) {
        if (sampleRequest.Route_for_Approval_1__c == false) {
            sampleRequest.Route_for_Approval_1__c = getApprovalFlag(msq, qmap,  QTY1);
        }
        if (sampleRequest.Route_for_Approval_2__c == false) {
            sampleRequest.Route_for_Approval_2__c = getApprovalFlag(msq, qmap,  QTY2);
        }
        if (sampleRequest.Route_for_Approval_3__c == false) {
            sampleRequest.Route_for_Approval_3__c = getApprovalFlag(msq, qmap,  QTY3);
        }
    }

    private static Boolean getApprovalFlag(Double msq, Map<String, Double> qmap, String k) {
        if (qmap.containsKey(k)) {
            Double usq = qmap.get(k);
            debug(k + ' : msq = ' + msq + ' : usq = ' + usq); 
            return (usq != null && msq > usq);
        }
        return false;
    } 
    
/*
*******************************************************
Test Methods are in UOM_Conversion_Functions_Test class 
*******************************************************
*/

}
public class Custom_Config_Functions {

    public static final Map<String, Schema.SObjectField> CCS_FMAP = 
        Schema.SObjectType.Custom_Config_Set__c.fields.getMap();
    
    public static Set<String> getCCSet(String fname) {
        Schema.DescribeFieldResult dfr = getDFR(fname);
        return Schema_Functions.getPicklistValueSet(dfr);
    }
    
    public static List<String> getCCList(String fname) {
        Schema.DescribeFieldResult dfr = getDFR(fname);
        return Schema_Functions.getPicklistValues(dfr);
    }
    
    private static Schema.DescribeFieldResult getDFR(String fname) {
        Schema.SObjectField sof = CCS_FMAP.get(fname);
        Schema.DescribeFieldResult dfr = sof.getDescribe();
        return dfr;
    }
    
}
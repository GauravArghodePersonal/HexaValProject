/**
 * @description LWR Utilties
 * @author      Lavakusareddy Poluru
 * @date        Created: 20-Jun-2022
 */
public class LWRUtilities {
	
    public static List<String> getProfileNames(List<LWR_Setting__mdt> lwrSettings){
        List<String> profiles = (!lwrSettings.isEmpty() && String.isNotBlank(lwrSettings[0].Profile_Names__c))?
            								lwrSettings[0].Profile_Names__c.split(','):new List<String>();
        return profiles;
    }
    
    public static String getUnqiueUserName(){
        String orgId = UserInfo.getOrganizationId();  
        String dateString =   
        String.valueof(Datetime.now()).replace(' ' ,'').replace(':','').replace('-','');  
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
        String uniqueName = orgId + dateString + randomInt;  
        return uniqueName;
    }
    
    public static Map<String,List<SObject>> groupSObjectsByFieldName(String fieldName, List<SObject> sobjs){
        Map<String,List<SObject>> sobjsByFieldNameMap = new Map<String,List<SObject>>();
        if(String.isNotBlank(fieldName)){
            for(SObject sobj : sobjs){
                String fieldValue = String.valueOf(sobj.get(fieldName));
                List<SObject> records = sobjsByFieldNameMap.get(fieldValue);
                records = (records == null)?new List<SObject>():records;
                records.add(sobj);
                sobjsByFieldNameMap.put(fieldValue, records);
            }            
        }
        
        return sobjsByFieldNameMap;
    }
}
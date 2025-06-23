public class RecordType_Functions {
    
    public static final String OBJECT_TYPE_ACCOUNT = 'Account';

    public static final String AAFI = 'AAFI'; 
    public static final String AHWT = 'AHWT'; 
    public static final String DISTRIBUTION = 'Distribution'; 
    public static final String FLINT_GROUP = 'Flint Group'; 
    public static final String PERFORMANCE_MATERIALS = 'Performance Materials'; 
    public static final String VALVOLINE = 'Valvoline'; 
    
    public static final Map<String, String> ACCOUNT_BUSINESS_MAP = new Map<String, String> {
        'Aqualon Customer' => AAFI, 
        'Aqualon Prospect' => AAFI, 

        'Drew Customer' => AHWT, 
        'Water Prospect' => AHWT,
            

        'Distribution Customer' => DISTRIBUTION, 
        'Distribution Other Account' => DISTRIBUTION, 
        'Distribution Prospect' => DISTRIBUTION, 
        'Distribution Prospect-Plastics' => DISTRIBUTION,
        
        'Flint Other Account' => FLINT_GROUP,

        'Performance Materials Customer' => PERFORMANCE_MATERIALS, 
        'Performance Materials Other Account' => PERFORMANCE_MATERIALS, 
        'Performance Materials Prospect - CAST' => PERFORMANCE_MATERIALS, 
        'Performance Materials Prospect - CP' => PERFORMANCE_MATERIALS, 
        'Performance Materials Prospect - SPA' => PERFORMANCE_MATERIALS,

        'Valolvine Customer' => VALVOLINE, 
        'Valvoline DIFM EMEA Prospect' => VALVOLINE, 
        'Valvoline DIFM Prospect' => VALVOLINE, 
        'Valvoline DIY Prospect' => VALVOLINE, 
        'Valvoline Other DIFM Account' => VALVOLINE, 
        'Valvoline Other DIY Account' => VALVOLINE
    };
    
    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'RecordType_Functions : ' + s);
    }
    
    public static String getBusinessNameForAccountType(Id accountRecordTypeId) {
        String businessName = '';
        Map<Id,String> amap = RetrieveRecordTypeIdMap(OBJECT_TYPE_ACCOUNT);
        debug('RecordTypeIdNameMap : ' + amap);
        String accountRecordType = '';
        if (amap.containsKey(accountRecordTypeId)) {
            accountRecordType = amap.get(accountRecordTypeId);
            if (ACCOUNT_BUSINESS_MAP.containsKey(accountRecordType)) {
                businessName = ACCOUNT_BUSINESS_MAP.get(accountRecordType);
            }
        }
        return businessName;
    }
    
  public static String LookupRecordTypeName(Id RecordTypeId) {

    RecordType recType;
    String RecordTypeName = '';

    if (RecordTypeId != null)
      {
        try {
              recType = [select Id, 
                                Name
                           from RecordType where Id = :RecordTypeId];
            }  
        catch (Exception e) 
            {
            //Most likely, no record was returned
            }
      }
    if (recType != null) {RecordTypeName = recType.Name;}
    return RecordTypeName;
  }

  public static Map<String, Id> RetrieveRecordTypeNameMap(String ObjectType) {
    
    return Schema_Functions.getRecordTypeNameMap(ObjectType);
  }

  public static Map<String, Id> RetrieveRecordTypeNameMap() {

    Map<String,Id> results = new Map<String,Id>();

    List<RecordType> recTypes;

    try {
          recTypes = [select Id, 
                            Name,
                            sObjectType
                       from RecordType];
        } 
    catch (Exception e) 
        {
        //Most likely, no record was returned
        }

    if (recTypes != null)
      {
        for(RecordType r:recTypes)
          {
            results.put(r.Name + '-' + r.sObjectType,r.Id);
          }
      }

    return results;
  }

  public static Map<Id,String> RetrieveRecordTypeIdMap(String ObjectType) {

    return Schema_Functions.getRecordTypeIdMap(ObjectType);
  }

  public static String LookupRecordTypeId(String RecordTypeName,String sObjectType) {

    String RecordTypeId = '';
    if ((RecordTypeName != null) && (sObjectType != null)) {
        Map<String, Id> rtnmap = RetrieveRecordTypeNameMap(sObjectType);
        if (rtnmap.containsKey(RecordTypeName)) {
            RecordTypeId = rtnmap.get(RecordTypeName);
        }
    }
    return RecordTypeId;
  }
  
  public static Map<Id, String> RetrieveAccRecordTypeMap() 
  {
      //Map to hold Account Record Type Ids and their values Customer/Vendor and Prospect/Other
      Map<Id, String> results = new Map<Id, String>();
      //List to hold all Account Record Types
      List<RecordType> accRecTypes = new List<RecordType>();
//*      
      Map<String, Id> rtmap = RetrieveRecordTypeNameMap('Account');
      for (String s : rtmap.keySet()) {
        if (s == 'KNA1' || s == 'Material Holder Account' || s == 'Partner Account') {
            continue;
        }
        accRecTypes.add(new RecordType(Id = rtmap.get(s), Name = s));
      }
//*/
      //Added Filter Record type not equals customer care
      //logic to classify Record Types as Customer/Vendor or Prospect/Other
      if(accRecTypes != null)
      {
          for (Integer i=0;i<accRecTypes.size();i++) 
          {
              if (
                  (accRecTypes[i].Name.contains('Customer') || 
                   accRecTypes[i].Name.contains('Vendor')) &&
                 accRecTypes[i].Name != 'Customer Care' && accRecTypes[i].Name != 'RSA Customer Care') 
              {
                  if (!(accRecTypes[i].Name.contains('Prospect') || 
                        accRecTypes[i].Name.contains('Other') ||
                        accRecTypes[i].Name.contains('VIOC Fleet Account'))) 
                  {
                      results.put(accRecTypes[i].Id, 'Customer/Vendor');
                  }
              }
              else if (accRecTypes[i].Name.contains('Prospect') || 
                       accRecTypes[i].Name.contains('Other') ||
                       accRecTypes[i].Name.contains('VIOC Fleet Account')) 
              {
                  results.put(accRecTypes[i].Id, 'Prospect/Other');
              }    
          }
      }
      
      return results;
  }
  
    public static Map<String, Map<String, Id>> getRecordTypeNameMap(List<String> objectNames) {
        return Schema_Functions.getRecordTypeNameMap(objectNames);
    }
    
    public static Map<String, Map<Id, String>> getRecordTypeIdMap(List<String> objectNames) {
        return Schema_Functions.getRecordTypeIdMap(objectNames);
    }

    public static String getDefaultRecordTypeId(String objectName) {
        return Schema_Functions.getDefaultRecordTypeId(objectName);
    }
    
//The End
}
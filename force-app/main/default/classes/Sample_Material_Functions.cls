public class Sample_Material_Functions { 

    private static Boolean doAfterInsert = true; 
    private static Boolean doAfterUpdate = true; 

    public static final String STAT_APPROVED  = 'Approved';
    public static final String STAT_CANCELLED = 'Cancelled';
    public static final String STAT_SHIPPED   = 'Shipped';

    public static final String STAT_CMC_ACKND = 'CMC - Acknowledged';  
    public static final String STAT_CMC_BKORD = 'CMC Backordered';  
    public static final String STAT_CMC_SHIPD = 'CMC Shipped';  
    
    public static final Set<String> SAMPLE_CENTERS_CMC = 
        Sample_Request_Config.getCMCSampleCenters();
    
    public static final Set<String> SAMPLE_CENTERS_LAB = 
        Sample_Request_Config.getLabSampleCenters();
    
    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Sample_Material_Functions : ' + s);
    }
    
    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    public static void doBeforeUpsert(List<Sample_Material__c> alist) {
        Set<Id> mset = new Set<Id>(), cset = new Set<Id>();
        for (Sample_Material__c a : alist) {
            addToSet(mset, a.SAP_Material_MSD2__c);
            addToSet(cset, a.Sample_Material_Catalog__c);
        }
        Map<Id, Material_Sales_Data2__c> mmap = getMSDmap(mset); 
        Map<Id, Sample_Material_Catalog__c> cmap = getSMCmap(cset);
        Material_Sales_Data2__c m; Sample_Material_Catalog__c c; 
        for (Sample_Material__c a : alist) {
            if (!isNull(a.SAP_Material_MSD2__c) && mmap.containsKey(a.SAP_Material_MSD2__c)) {
                m = mmap.get(a.SAP_Material_MSD2__c); setFields(a, m); continue;
            }
            if (!isNull(a.Sample_Material_Catalog__c) && cmap.containsKey(a.Sample_Material_Catalog__c)) {
                c = cmap.get(a.Sample_Material_Catalog__c); setFields(a, c); continue;
            }
            a.Material_Name__c = a.Name;
        }
    }
    
    public static void doAfterInsert(List<Sample_Material__c> alist) {
        if (!doAfterInsert) {return;}
        doAfterInsert = false;
        createCMCMaterials(alist);
    }
    
    public static void doAfterUpdate(Map<Id, Sample_Material__c> amap) {
        if (!doAfterUpdate || amap == null) {return;}
        doAfterUpdate = false;
        updateCMCMaterials(amap); updateSampleRequest(amap.values());
    }
    
    public static void doAfterUpdate(List<Sample_Material_CMC__c> alist) {
        if (!doAfterUpdate) {return;}
        doAfterUpdate = false;
        updateMaterials(alist);
    }
    
    private static void addToSet(Set<Id> aset, Id a) {
        if (!isNull(a)) {aset.add(a);}
    }
    
    private static Map<Id, Material_Sales_Data2__c> getMSDmap(Set<Id> ids) {
        Map<Id, Material_Sales_Data2__c> amap = new Map<Id, Material_Sales_Data2__c>();
        if (ids == null || ids.isEmpty()) {return amap;}
        amap = new Map<Id, Material_Sales_Data2__c>([
            select Id, Name, Material_Desc__c, Material_Number__c 
              from Material_Sales_Data2__c where Id in :ids]);
        return amap;
    }
    
    private static Map<Id, Sample_Material_Catalog__c> getSMCmap(Set<Id> ids) {
        Map<Id, Sample_Material_Catalog__c> amap = new Map<Id, Sample_Material_Catalog__c>();
        if (ids == null || ids.isEmpty()) {return amap;}
        amap = new Map<Id, Sample_Material_Catalog__c>([
            select Id, Name, Product_Code__c, Product_Name__c 
              from Sample_Material_Catalog__c where Id in :ids]);
        return amap;
    }
    
    private static void setFields(Sample_Material__c a, Material_Sales_Data2__c m) {
        a.Material_Name__c = m.Material_Desc__c;
        a.Material_Number__c = String_Functions.removeLeadingZeros(m.Material_Number__c);
    }
    
    private static void setFields(Sample_Material__c a, Sample_Material_Catalog__c c) {
        a.Material_Name__c = c.Product_Name__c;
        a.Material_Number__c = String_Functions.removeLeadingZeros(c.Product_Code__c);
        a.Name = a.Material_Name__c + ' - ' + a.Material_Number__c;
    }
    
    public static Boolean isCMCSampleCenter(String s) {
        return (!isNull(s) && SAMPLE_CENTERS_CMC.contains(s));
    }
    
    public static Boolean isLabSampleCenter(String s) {
        return (!isNull(s) && SAMPLE_CENTERS_LAB.contains(s));
    }
    
    // called from Sample_Material_Batchable
    public static void updateMaterials1(List<Sample_Material__c> alist) {
    	if (alist == null || alist.isEmpty()) {return;}
    	for (Sample_Material__c a : alist) {
    		a.Record_Status__c = a.Sample_Request__r.Status__c;
    	}
    	try {update alist;} catch (Exception e) {debug(e.getMessage());}
    }
    
    private static void createCMCMaterials(List<Sample_Material__c> alist) {
        if (alist == null || alist.isEmpty()) {return;}
        List<Sample_Material_CMC__c> blist = new List<Sample_Material_CMC__c>();
        Sample_Material_CMC__c b;
        for (Sample_Material__c a : alist) {
            if (!isCMCSampleCenter(a.Sample_Center__c)) {continue;}
            b = new Sample_Material_CMC__c(); 
            b.Sample_Request__c = a.Sample_Request__c; b.Sample_Material__c = a.Id;
            b.Record_Status__c = a.Record_Status__c;
            b.Carrier_Name__c = a.Carrier_Name__c;
            b.Lot_Number__c = a.Lot_Numbers__c;
            blist.add(b);
        }
        if (!blist.isEmpty()) {insert blist;}
    }
    
    private static void updateCMCMaterials(Map<Id, Sample_Material__c> amap) {
    	debug('updateCMCMaterials');
        if (amap == null || amap.isEmpty()) {return;}
        List<Sample_Material_CMC__c> blist = [
            select Id, Actual_Ship_Date__c, Carrier_Name__c, 
                   Lot_Number__c, Record_Status__c, 
                   Sample_Material__c, Tracking_Number__c
              from Sample_Material_CMC__c 
             where Sample_Material__c in :amap.keySet()];
        if (blist == null || blist.isEmpty()) {return;}
        List<Sample_Material_CMC__c> clist = new List<Sample_Material_CMC__c>();
        Sample_Material__c a;
        for (Sample_Material_CMC__c b : blist) {
            if (!amap.containsKey(b.Sample_Material__c)) {continue;}
            a = amap.get(b.Sample_Material__c);
            if (!changed(a, b)) {continue;}
            b.Record_Status__c = a.Record_Status__c;
            clist.add(b);
        }
        if (!clist.isEmpty()) {update clist;}
    }
    
    private static Boolean changed(Date a, Date b) {
        return (a == null && b != null) ||
               (a != null && b == null) || (a != b);
    }
    
    private static Boolean changed(String a, String b) {
        return (a == null && b != null) ||
               (a != null && b == null) || (a != b);
    }

    private static Boolean validCMCStatus(String a, String b) {
    	Boolean b1 = true, b2 = true;
    	b1 = (a != null && b != null && a == STAT_CANCELLED && 
    	     (b == STAT_CMC_ACKND || b == STAT_CMC_BKORD));
    	if (b1) {b2 = false;}
    	return b2;
    }
        
    private static Boolean changed(Sample_Material__c a, Sample_Material_CMC__c b) {
        Boolean b1 = false, b2 = false, b3 = false, b4 = false, b5 = false;
        b1 = changed(a.Actual_Ship_Date__c, b.Actual_Ship_Date__c);
        b2 = changed(a.Carrier_Name__c, b.Carrier_Name__c);
        b3 = changed(a.Lot_Numbers__c, b.Lot_Number__c);
        b4 = changed(a.Record_Status__c, b.Record_Status__c);
        if (b4) {b4 = validCMCStatus(a.Record_Status__c, b.Record_Status__c);} 
        b5 = changed(a.Tracking_Air_Bill__c, b.Tracking_Number__c);
        return (b1 || b2 || b3 || b4 || b5);
    }
    
    private static void updateMaterials(List<Sample_Material_CMC__c> blist) {
        debug('updateMaterials');
        if (blist == null || blist.isEmpty()) {return;}
        Set<Id> aset = new Set<Id>();
        for (Sample_Material_CMC__c b : blist) {addToSet(aset, b.Sample_Material__c);}
        if (aset.isEmpty()) {return;}
        Map<Id, Sample_Material__c> amap = new Map<Id, Sample_Material__c>([
            select Id, Actual_Ship_Date__c, Carrier_Name__c, Lot_Numbers__c,
                   Record_Status__c, Sample_Request__c, Tracking_Air_Bill__c
              from Sample_Material__c where Id in :aset]);
        if (amap == null || amap.isEmpty()) {return;}
        List<Sample_Material__c> alist = new List<Sample_Material__c>();
        Sample_Material__c a;
        for (Sample_Material_CMC__c b : blist) {
            if (!amap.containsKey(b.Sample_Material__c)) {continue;}
            a = amap.get(b.Sample_Material__c);
            if (!changed(a, b)) {continue;}
            a.Actual_Ship_Date__c  = b.Actual_Ship_Date__c;
            a.Carrier_Name__c      = b.Carrier_Name__c;
            a.Lot_Numbers__c       = b.Lot_Number__c;
            a.Record_Status__c     = b.Record_Status__c;
            a.Tracking_Air_Bill__c = b.Tracking_Number__c;
            alist.add(a);
        }
        if (!alist.isEmpty()) {update alist; updateSampleRequest(alist);}
    }
    
    private static void updateSampleRequest(List<Sample_Material__c> mlist) {
        debug('updateSampleRequest');
        if (mlist == null || mlist.isEmpty()) {return;}
        String reqComp = 'Request Completed', mstat; Integer n;
        String reqCompRecTypeId = RecordType_Functions.LookupRecordTypeId(reqComp,'Sample_Request__c');
        Set<Id> rset = new Set<Id>(); Set<String> mset = new Set<String>();
        Set<String> sset = new Set<String>{STAT_APPROVED, STAT_CANCELLED, STAT_CMC_ACKND, STAT_CMC_BKORD};
        Set<String> shpd = new Set<String>{STAT_SHIPPED, STAT_CMC_SHIPD};
        for (Sample_Material__c m : mlist) {rset.add(m.Sample_Request__c);}
        List<Sample_Request__c> rlist = new List<Sample_Request__c>();
        for (Sample_Request__c r : [select Id, Name, RecordTypeId, Status__c,
                (select Record_Status__c from Sample_Materials__r) 
            from Sample_Request__c where Id in :rset]) {
            if (!sset.contains(r.Status__c)) {continue;}
            mset = new Set<String>(); mstat = '';
            for (Sample_Material__c m : r.Sample_Materials__r) {
            	mstat = m.Record_Status__c; mset.add(mstat);
            }
            n = mset.size();
            if (mset.contains(STAT_CMC_BKORD)) {mstat = STAT_CMC_BKORD;} else
            if (n == 2 && mset.contains(STAT_CANCELLED) && 
               (mset.contains(STAT_SHIPPED) || mset.contains(STAT_CMC_SHIPD))) {
                mstat = STAT_SHIPPED;} else
            if (n == 3 && mset.contains(STAT_CANCELLED) && 
                mset.contains(STAT_SHIPPED) && mset.contains(STAT_CMC_SHIPD)) {
                mstat = STAT_SHIPPED;} else if (n != 1) {continue;}
            debug('updateSampleRequest : mstat = ' + mstat);
            if (mstat == '' || (r.Status__c != null && r.Status__c == mstat) ||
                !validCMCStatus(r.Status__c, mstat)) {continue;}
            r.Status__c = mstat; if (shpd.contains(mstat)) {r.RecordTypeId = reqCompRecTypeId;}
            rlist.add(r); debug('r : ' + r);
        }
        if (!rlist.isEmpty()) {
            try {update rlist;} catch(Exception e) {}
        }
    }

  public static Boolean List_Contains_Material_Greater_Then_5_Gallons(List<Sample_Material__c> materials) {
    Boolean result = false;
    
    for(Sample_Material__c material:materials)
      {
      if (UOM_Conversion_Functions.UOMQty_Greater_Than_5_Gallons(material.Sample_UOM__c, material.Sample_Quantity__c) == true)
        {
        result = true;
        }
      }
      
    return result;      
  }

    public static List<Sample_Material__c> Populate_SAP_Material_Number_from_Materials_Table(List<Sample_Material__c> materials) {
        List<Sample_Material__c> results = new List<Sample_Material__c>(); List<Id> msd2Ids = new List<Id>();
        if (materials == null || materials.isEmpty()) {return results;}
      
        for(Sample_Material__c material : materials) {
            if(material.SAP_Material_MSD2__c != null){msd2Ids.add(material.SAP_Material_MSD2__c);}
        }
  
        Map<Id, Material_Sales_Data2__c> msd2Map = new Map<Id, Material_Sales_Data2__c>();
        
        if (!msd2Ids.isEmpty()) {
            msd2Map = new Map<Id, Material_Sales_Data2__c>([select id, Material_Number__c from Material_Sales_Data2__c where Id in :msd2Ids]);
        }
      
        Sample_Material__c newMaterial;
        for(Sample_Material__c material : materials) {
            newMaterial = material; newMaterial.SAP_Material_Number__c = null;
            if (newmaterial.SAP_Material_MSD2__c != null && msd2Map.containsKey(newmaterial.SAP_Material_MSD2__c)){
                newMaterial.SAP_Material_Number__c = String_Functions.removeLeadingZeros(msd2Map.get(newMaterial.SAP_Material_MSD2__c).Material_Number__c); 
            }        
            results.add(newMaterial);
        }
        return results;
    }

//********************************************
//Remove Blank Rows from Material List
//********************************************

  public static List<Sample_Material__c> Remove_Blank_Rows_From_Material_List(List<Sample_Material__c> sampleMaterials) {

      List<Sample_Material__c> sampleMaterials_hold = new List<Sample_Material__c>();

      //Move the good records to the hold
      for (Sample_Material__c sampleMaterial : sampleMaterials)
        if (((sampleMaterial.name != '') && (sampleMaterial.name != null)) ||
            ((sampleMaterial.material__c != '') && (sampleMaterial.material__c != null))) {
            sampleMaterials_hold.add(sampleMaterial);
          }
    return sampleMaterials_hold;
    
  }

//********************************************
//Delete Materials no longer related to Sample
//********************************************
  public static void Delete_Sample_Materials_Not_In_List(Sample_Request__c sampleRequest,List<Sample_Material__c> sampleMaterials) {
  
    List<Sample_Material__c> existingMaterials;
    Boolean materialsStillExists = false;
    
    try {
          existingMaterials = [SELECT id
                                 FROM Sample_Material__c
                                WHERE Sample_Request__c = :sampleRequest.Id];
        } 
    catch (Exception e) 
        {
        //Most likely, no record was returned
        }
                             
    if (existingMaterials != null)
      {
        //Loop through materials that are in Salesforce
        for(Sample_Material__c existingMaterial:existingMaterials)
          {
            materialsStillExists = false;

            //Loop over materials that need to be on Sample based on current save
            for(Sample_Material__c sampleMaterial:sampleMaterials)
              {
                if (existingMaterial.Id == sampleMaterial.Id) {materialsStillExists = true;}
              }

            //If the material should no longer exist, remove it
            if (materialsStillExists == false) {delete existingMaterial;}
          }
      }                           
    
    
  }
  


//********************************************
//Material Field Availability based on Account
//********************************************

  /*static Account CurrentAccount;
  
  public static void populateCurrentAccount(Id accountId) {
    
    Boolean reloadAccount = false;
    
    
    if (CurrentAccount == null) {reloadAccount = true;}
    else 
        {
        if (acc.id != accountId) {reloadAccount = true;}
        }
    
    if (reloadAccount == true)
        {
        CurrentAccount = [SELECT id, RecordTypeId, RecordType.Name, SAP_SALES_ORG__C, SAP_Sales_District_Desc__c, SAP_Sales_Group_Desc__c, SAP_Division_Desc__c, SalesOffice__c FROM Account WHERE Id = :accountId];  
        }

    system.Debug('reloadAccount = ' + reloadAccount);
    system.Debug('accountId = ' + accountId);
    system.Debug('acc.id = ' + acc.id);

  }
*/

  public static Boolean SupportsTectylProducts(Account acc) {

    Boolean result = false;
    
    //populateCurrentAccount(accountId);
    
    string business = '';
    business = RecordType_Relationship_Functions.GetBusinessType_Based_on_AccountRecordTypeId(acc.RecordTypeId);

    string region = '';
    region = SAP_Sales_Org_Lookup_Functions.lookup_Region_from_Sales_Org(acc.SAP_SALES_ORG__C);

    //Tectyl Products are only available in Valvoline EMEA
    if ((business == 'Valvoline') && ((region == 'EMEA')))
      {
      result = true;
      }

    return result;
  }


  public static Boolean SupportsProductLine(Account acc) {

    Boolean result = false;
    
    //populateCurrentAccount(accountId);
    string business = '';
    business = RecordType_Relationship_Functions.GetBusinessType_Based_on_AccountRecordTypeId(acc.RecordTypeId);

    string region = '';
    region = SAP_Sales_Org_Lookup_Functions.lookup_Region_from_Sales_Org(acc.SAP_SALES_ORG__C);

    //Product Lines are only available in Valvoline Americas
        if ((business == 'Valvoline') && ((region == 'USA') || (region == 'CANADA') || (region == 'MEXICO') || (region == 'SOUTH AMERICA')))
      {
      result = true;
      }

    return result;

  }

  public static Boolean SupportsPMCastingsProductLine(Account acc) {

    Boolean result = false;
    
    //populateCurrentAccount(accountId);
    
    string business = '';
    business = RecordType_Relationship_Functions.GetBusinessType_Based_on_AccountRecordTypeId(acc.RecordTypeId);

    string accountType = '';
    accountType = RecordType_Relationship_Functions.GetAccountType_Based_on_AccountRecordTypeId(acc.RecordTypeId);

    //Show Product Lines When the following is true
    if (
        (business == 'Performance Materials') && (
          ((accountType == 'Customer') && (acc.SAP_Division_Desc__c == 'Casting Solutions' || 
                                           acc.SAP_Division_Desc__c == 'ASK Chemicals')) || 
          ((accountType == 'Prospect') && (acc.RecordType.Name == 'Performance Materials Prospect - CAST' || 
                                           acc.RecordType.Name == 'ASK Prospect'))         
          )
       ) {result = true;}

    return result;

  }


    public static Boolean SupportsAHWTProductLine(Account acc) {

    Boolean result = false;
    
    //populateCurrentAccount(accountId);
    
    string business = '';
    business = RecordType_Relationship_Functions.GetBusinessType_Based_on_AccountRecordTypeId(acc.RecordTypeId);

    //Show Product Lines When the following is true
    if (
        (business == 'Water')   
       )
      {
      result = true;
      }

    
    return result;
  }
  
  public static Boolean SupportsADCompoundProducts(Account acc) {

    Boolean result = false;
    
    //populateCurrentAccount(accountId);
    
    string business = '';
    business = RecordType_Relationship_Functions.GetBusinessType_Based_on_AccountRecordTypeId(acc.RecordTypeId);

    string region = '';
    region = SAP_Sales_Org_Lookup_Functions.lookup_Region_from_Sales_Org(acc.SAP_SALES_ORG__C);

    //Product Lines are only available in Valvoline Americas
        if ((business == 'Distribution') && (region == 'EMEA'))
      {
      result = true;
      }

    return result;

  }

  public static Boolean SupportsProductDevelopment(Account acc) {

    Boolean result = false;
    
    //populateCurrentAccount(accountId);
    
    String recordTypeName = RecordType_Functions.LookupRecordTypeName(acc.RecordTypeId);

    String business = '';
    business = RecordType_Relationship_Functions.GetBusinessType_Based_on_AccountRecordTypeId(acc.RecordTypeId);

    String region = '';
    region = SAP_Sales_Org_Lookup_Functions.lookup_Region_from_Sales_Org(acc.SAP_SALES_ORG__C);
    
    String prospectRegion = '';
    if ((acc.SalesOffice__c == '2150-> CM NORTH') || 
        (acc.SalesOffice__c == '2160-> CM SOUTH') || 
        (acc.SalesOffice__c == '2170 ->CM SPECIALTY')) 
       {prospectRegion = 'EMEA';}

    if ((recordTypeName == 'Valvoline DIFM EMEA Prospect') &&
        (
         (acc.SAP_Sales_Group_Desc__c == 'CENTRAL CHINA') || 
         (acc.SAP_Sales_Group_Desc__c == 'EAST CHINA') || 
         (acc.SAP_Sales_Group_Desc__c == 'SOUTHEAST CHINA') || 
         (acc.SAP_Sales_Group_Desc__c == 'SOUTHWEST CHINA') || 
         (acc.SAP_Sales_Group_Desc__c == 'WEST CHINA') || 
         (acc.SAP_Sales_Group_Desc__c == 'NORTH CHINA') 
        )
       ) 
       {prospectRegion = 'CHINA';}
       
    if (
        ((business == 'Valvoline') && (prospectRegion != 'CHINA') && (Region != 'CHINA')) ||
        ((recordTypeName == 'Performance Materials Prospect - CP') && (prospectRegion == 'EMEA')) ||
        ((recordTypeName == 'Performance Materials Customer') && (Region == 'EMEA'))
       )
      {
      result = true;
      }

    return result;
  }
  
  public static Boolean SupportsASTSamples() {
    Boolean result = false;
    //Id currentUserId;
    //currentUserId = UserInfo.getUserId();
    //User currentUser = [SELECT Id, AST_Sample_User__c FROM User WHERE Id = :currentUserId];
    //result = currentUser.AST_Sample_User__c;
    
    result = true;
    return result;
  }

  public static Boolean SupportsOakCreek(Account acc) {

    Boolean result = false;
    //populateCurrentAccount(accountId);
    
    String recordTypeName = RecordType_Functions.LookupRecordTypeName(acc.RecordTypeId);

    String business = '';
    business = RecordType_Relationship_Functions.GetBusinessType_Based_on_AccountRecordTypeId(acc.RecordTypeId);

    Boolean SPA_Division = false;
    if (acc.SAP_Division_Desc__c == 'Specialty Poly & Adh')
      {SPA_Division = true;}

    if (recordTypeName == 'Performance Materials Prospect - SPA')
      {SPA_Division = true;}

    String region = '';
    region = SAP_Sales_Org_Lookup_Functions.lookup_Region_from_Sales_Org(acc.SAP_SALES_ORG__C);
    
    String prospectRegion = '';
    if ((acc.SAP_Sales_District_Desc__c == 'ASIA REGION')) 
       {prospectRegion = 'CHINA';}
       
    if ((business == 'Performance Materials') && (SPA_Division == true) && (region != 'CHINA') && (prospectRegion != 'CHINA'))
      {result = true;}

    return result;
  }


//**********************************
//Material Field Validation Routines
//**********************************

  public static String Validate_Ship_From_Location(String dataIn, Boolean required) {
    String result = '';

    if ((required == true) && ((dataIn == '') || (dataIn == null)))
      {result = '<u>Ship From Location</u> is required on material';}
    
    return result;
  }
  
  public static String Validate_Nanjing(boolean isNanjing, string NanjingMaterial){
     string result = '';
     if(isNanjing == true && (NanjingMaterial == null || NanjingMaterial == '')){
        result = '<u>Nanjing Material Number</u> is required';}
     if(isNanjing == false && NanjingMaterial != null && NanjingMaterial != ''){
        result = '<u>Nanjing Material</u> must equal true when Nanjing Material Number equals ' + NanjingMaterial;}
     return result; 
  }
  
  public static String Validate_Name(String dataIn, Boolean required) {
    String result = '';

    if ((required == true) && ((dataIn == '') || (dataIn == null)))
    {     result = '<u>Material Name</u> is required on material';}

    return result;
  }

  public static String Validate_Estimated_Ship_Date(Date dataIn, Boolean required) {
    String result = '';

    if ((required == true) && (dataIn == null)) 
      {result = '<u>Estimated Ship Date</u> is required on material';}

    return result;
  }

  public static String Validate_Estimated_Arrival_Date(Date dataIn, Boolean required) {
    String result = '';

    if ((required == true) && (dataIn == null)) 
      {result = '<u>Estimated Arrival Date</u> is required on material';}

    return result;
  }

  public static String Validate_Actual_Ship_Date(Date dataIn, Boolean required) {
    String result = '';

    if ((required == true) && (dataIn == null)) 
      {result = '<u>Shipping Plant</u> is required on material';}

    return result;
  }

  public static String Validate_Material_Must_Ship_From_Location(Boolean dataIn, String Ship_From_Location, Boolean required) {
    String result = '';

    if ((required == true) && (dataIn == true))  
        {
        if ((Ship_From_Location == '') || (Ship_From_Location == null))
                {
                 result = '<u>Ship From Location</u> is required when "Material Must Ship From Location" is selected on material';
                }
        }
    return result;
  }

  public static String Validate_Shipping_Carrier(String dataIn, Boolean required) {
    String result = '';

    if ((required == true) && ((dataIn == '') || (dataIn == null)))
      {result = '<u>Shipping Carrier</u> is required on material';}

    return result;
  }

  public static String Validate_Product_Line(String dataIn, Account acc, Boolean required) {
    String result = '';

    if ((required == true) && SupportsProductLine(acc) && ((dataIn == '') || (dataIn == null)))
      {result = '<u>Product Line</u> is required on material';}

    return result;
  }

  public static String Validate_PM_Castings_Product_Line(String dataIn, Account acc, Boolean required) {
    String result = '';

    if ((required == true) && SupportsPMCastingsProductLine(acc) && ((dataIn == '') || (dataIn == null)))
      {result = '<u>Product Line</u> is required on material';}

    return result;
  }

  public static String Validate_Special_Size(Decimal dataIn, Boolean required) {
    String result = '';

    if ((required == true) && (dataIn == null))
      {result = '<u>Special Size</u> is required on material';}

    return result;
  }

  public static String Validate_Sample_UOM(String dataIn, Boolean required) {
    String result = '';

    if ((required == true) && ((dataIn == '') || (dataIn == null)))
      {result = '<u>Sample UOM</u> is required on material';}

    return result;
  }

  public static String Validate_Date_Required_By(Date dataIn, Boolean required) {
    String result = ''; Date currentDate = System.today();
    if ((required == true)) {
    	if (dataIn == null) {
        	result = '<u>Date Required By</u> is required on material';
    	} else 
    	if (dataIn < currentDate) {
    		result = '<u>Date Required By</u> cannot be past date';
    	}
    }

    return result;
  }

  public static String Validate_Sample_Quantity(Decimal dataIn, Boolean required) {
    String result = '';

    if ((required == true) && (dataIn == null)) 
      {result = '<u>Sample Quantity</u> is required on material';}

    return result;
  }

  public static String Validate_Estimated_Sample_Value(Decimal dataIn, Boolean required) {
    String result = '';

    if ((required == true) && (dataIn == null)) 
      {result = '<u>Estimated Sample Value</u> is required on material';}

    return result;
  }

  public static String Validate_Potential_Annual_Value(Decimal dataIn, Boolean required) {
    String result = '';

    if ((required == true) && (dataIn == null)) 
      {result = '<u>Potential Annual Value</u> is required on material';}

    return result;
  }

  public static String Validate_Material_Plant(String FirstPlant, String CurrentPlant) {
    String result = '';

    if (FirstPlant != '' && FirstPlant != CurrentPlant) 
      {result = '<u>All Material Plants</u> must be the same' ;}

    return result;
  }
  
  public static String Validate_Material_Picklist(String Plant, String Material) {
    String result = '';

    if((plant != '' && plant != null) && (Material == '' || Material == null)){
      result = '<u>Material</u> Required When Material Plant equals ' + Plant;}

    return result;
  }
  
  public static String Validate_PAC(String PAC, String Business) {
    String result = '';

    if((PAC == null || PAC == '' ) && Business == 'Aqualon'){
      result = '<u>PAC Industry Segment</u> is Required';}

    return result;
  }

  public static String Validate_Same_Pac(String FirstPAC, String CurrentPAC) {
    String result = '';

    if (FirstPAC != '' && FirstPAC != CurrentPAC) 
      {result = '<u>All PAC Industry Segments</u> must be the same' ;}

    return result;
  }

  //*********************
  //Material Validators
  //*********************

  public static List<String> Validate_Materials(List<Sample_Material__c> materials, Account acc, String validationProcess, Boolean AddNameasSuffix, String Business) {
    
    String ErrorSuffix, FirstPlant = '', FirstPAC = '';
    
    for (Sample_Material__c material:materials) {
      if((material.material_Plant__c != null && material.material_plant__c != '')&&
         (FirstPlant == null || FirstPlant == '')) {FirstPlant = material.material_Plant__c;}
         
      if((material.PAC_Industry_Segment__c != null && material.PAC_Industry_Segment__c != '')&&
         (FirstPAC == null || FirstPAC == '')){FirstPAC = material.PAC_Industry_Segment__c;}   
    }
    
    List<String> allErrors = new List<String>(), errors; Integer i = 0;  
    for (Sample_Material__c material:materials) {
        i++;
        if (AddNameasSuffix == true) {ErrorSuffix = material.Name;} else {ErrorSuffix = '';}
      
        errors = Validate_Material(FirstPlant, FirstPAC, material, acc, 
                                   validationProcess, ErrorSuffix, business);
        if (errors.size() > 0) {
            allErrors.add('Material #' + i + ' errors :'); 
            for (String err:errors) {allErrors.add(err);} allErrors.add('');
        }
    }

    return allErrors;      
  }
  

  public static List<String> Validate_Material(String FirstPlant, String FirstPAC, 
                                               Sample_Material__c material, Account acc, 
                                               String validationProcess, String business) {
    return Validate_Material(FirstPlant, FirstPAC, material, acc, validationProcess,'', business);
  }

  public static List<String> Validate_Material(String FirstPlant, String FirstPAC, 
                                               Sample_Material__c material, Account acc, 
                                               String validationProcess, String ErrorSuffix, 
                                               String Business) {
    List<String> results = new List<String>();
    String errorMessage = '', suffix = '';
    Boolean isASI = Sample_Request_Functions.isASI(acc);
    //Set up the suffix if necessary
    if (ErrorSuffix != '') {suffix = ' : ' + ErrorSuffix;}
    
    if (validationProcess == 'InitialEntry') {
        errorMessage = Validate_Material_Picklist(material.material_plant__c, material.material__c);
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
      
        errorMessage = Validate_Nanjing(material.nanjing_material__c, material.nanjing_material_number__c);
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
       
        if(material.material__c != '' && material.material__c != null && (material.name == null || material.name == '')){
         material.name = material.material__c;}
         
        errorMessage = Validate_Name(material.Name, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}

        if (material.Special_Size__c != null && material.Special_Size__c) {
            errorMessage = Validate_Special_Size(material.Sample_Size__c, true); 
            if(errorMessage != '') {results.add(ErrorMessage + suffix);}
        }

        errorMessage = Validate_Sample_UOM(material.Sample_UOM__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}

        errorMessage = Validate_Sample_Quantity(material.Sample_Quantity__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}

        errorMessage = Validate_Date_Required_By(material.Date_Required_By__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}

        if (!isASI) {/*
            errorMessage = Validate_Same_PAC(FirstPAC, material.PAC_Industry_Segment__c);
            if(errorMessage != '') {results.add(ErrorMessage + suffix);}
          
            errorMessage = Validate_PAC(material.PAC_Industry_Segment__c, business);
            if(errorMessage != '') {results.add(ErrorMessage + suffix);}
          
            errorMessage = Validate_Material_Plant(FirstPlant, material.material_plant__c);
            if(errorMessage != '') {results.add(ErrorMessage + suffix);}
      
            errorMessage = Validate_Product_Line(material.Product_Line__c, acc, true); 
            if(errorMessage != '') {results.add(ErrorMessage + suffix);}

            errorMessage = Validate_PM_Castings_Product_Line(material.PM_Castings_Product_Line__c, acc, true); 
            if(errorMessage != '') {results.add(ErrorMessage + suffix);}

            errorMessage = Validate_Estimated_Sample_Value(material.Estimated_Sample_Value__c, true); 
            if(errorMessage != '') {results.add(ErrorMessage + suffix);}
    
            errorMessage = Validate_Potential_Annual_Value(material.Potential_Annual_Value__c, true); 
            if(errorMessage != '') {results.add(ErrorMessage + suffix);}
        */}
      }

    if (validationProcess == 'AssignOrderEntrytoCSR') {
        errorMessage = Validate_Name(material.Name, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
        
        errorMessage = Validate_Material_Must_Ship_From_Location(material.Material_Must_Ship_From_Location__c, material.Ship_From_Location__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
    }
      
    if (validationProcess == 'OrderEntry-CSR') {
        errorMessage = Validate_Name(material.Name, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
          
        errorMessage = Validate_Ship_From_Location(material.Ship_From_Location__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
          
        errorMessage = Validate_Estimated_Ship_Date(material.Estimated_Ship_Date__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
        
        errorMessage = Validate_Estimated_Arrival_Date(material.Estimated_Arrival_Date__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
        
        errorMessage = Validate_Material_Must_Ship_From_Location(material.Material_Must_Ship_From_Location__c, material.Ship_From_Location__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
      }
      
    if (validationProcess == 'OrderEntry-Coordinator') {
        errorMessage = Validate_Name(material.Name, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
          
        errorMessage = Validate_Ship_From_Location(material.Ship_From_Location__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
          
        errorMessage = Validate_Estimated_Ship_Date(material.Estimated_Ship_Date__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
        
        errorMessage = Validate_Estimated_Arrival_Date(material.Estimated_Arrival_Date__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
        
        errorMessage = Validate_Material_Must_Ship_From_Location(material.Material_Must_Ship_From_Location__c, material.Ship_From_Location__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
      }

    if (validationProcess == 'OrderShipped') {
        errorMessage = Validate_Actual_Ship_Date(material.Actual_Ship_Date__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}

        errorMessage = Validate_Ship_From_Location(material.Ship_From_Location__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}

        errorMessage = Validate_Shipping_Carrier(material.Shipping_Carrier__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
    }
    
    return results;
  }


  public static Map<String, Map<Id,String>> SummarizeMaterialsonSampleRequests(List<Id> sampleRequestIds) {
    
    Map<Id,String> materialresults = new Map<Id,String>();
    Map<Id,String> productlineresults = new Map<Id,String>();
    Map<ID,String> shippingresults = new Map<Id, String>();
    Map<ID,String> PACresults = new Map<Id, String>();
     
    Map<String, MAP<ID, String>> returnmap = new map<string, map<id, string>>();
    String result = '';
    String plresult = '';
    String sresult = '';
    String pacresult = '';
    
    List<Sample_Material__c> sampleMaterials = Select_All_Fields_Based_on_Sample_Request_Ids(sampleRequestIds);
    
    for(Id sampleRequestId:sampleRequestIds)
        {
        result = '';
        plresult = '';
        sresult = '';
        pacresult = '';
        for(Sample_Material__c sampleMaterial:sampleMaterials)
            {
            if (sampleMaterial.Sample_Request__c == sampleRequestId)
                {
                result += 'Material: ' + sampleMaterial.Name;
                if (sampleMaterial.SAP_Material_Number__c!=null) {result += ' (' + sampleMaterial.SAP_Material_Number__c +')';}
                result += ' : ' + sampleMaterial.Sample_Quantity__c + ' ';
                if (sampleMaterial.Special_Size__c != null && sampleMaterial.Special_Size__c) {result += '- ' + sampleMaterial.Sample_Size__c;}
                result += sampleMaterial.Sample_UOM__c + '\n';
                if (sampleMaterial.AHWT_Product_Line__c != null){
                plresult += sampleMaterial.AHWT_Product_Line__c + ';'; }
                if (sampleMaterial.PAC_Industry_Segment__c != null && !pacresult.contains(sampleMaterial.PAC_Industry_Segment__c)){
                pacresult += sampleMaterial.PAC_Industry_Segment__c + ';'; }
                sresult += 'Material: ' + sampleMaterial.name + '\n' + 'Tracking / Air Bill #: ';
                if(samplematerial.Tracking_Air_Bill__c != null){sresult += samplematerial.Tracking_Air_Bill__c;}
                sresult += '\n' + 'Carrier: ';
                if(samplematerial.shipping_carrier__c != null){sresult += samplematerial.shipping_carrier__c;}
                sresult += '\n' + 'Estimated Ship Date: ';
                if(samplematerial.estimated_ship_date__c != null){ sresult += samplematerial.estimated_ship_date__c.format();}
                sresult += '\n' + 'Actual Ship Date: ';
                if(samplematerial.actual_ship_date__c != null){ sresult += samplematerial.actual_ship_date__c.format();}
                sresult += '\n' + 'Estimated Arrival Date: ';
                if(samplematerial.estimated_arrival_date__c != null){ sresult += samplematerial.estimated_arrival_date__c.format(); }
                sresult += '\n' + 'Date Required: ';
                if(samplematerial.date_required_by__c != null){ sresult += samplematerial.date_required_by__c.format();}
                sresult += '\n\n';
                

                }
            }
        materialresults.put(sampleRequestId,result);
        productlineresults.put(sampleRequestID, plresult);
        shippingresults.put(sampleRequestID, sresult);
        pacresults.put(sampleRequestID, pacresult);
        } 



    returnmap.put('Material', materialresults);
    returnmap.put('Product Line', productlineresults);
    returnmap.put('Shipping Info', shippingresults);
    returnmap.put('PAC Info', pacresults);
    return returnmap;
  }




  public static List<Sample_Material__c> Select_All_Fields_Based_on_Sample_Request_Ids(Id sampleRequestId) {
    List<Id> sampleRequestIds = new List<Id>();
    sampleRequestIds.add(sampleRequestId);
    return Select_All_Fields_Based_on_Sample_Request_Ids(sampleRequestIds);
  }

  public static List<Sample_Material__c> Select_All_Fields_Based_on_Sample_Request_Ids(List<Id> sampleRequestIds) {
    List<Sample_Material__c> sampleMaterials = [SELECT 
            Id, Name, CreatedById, CreatedDate, CurrencyIsoCode, LastModifiedDate, LastModifiedById, 
            RecordTypeId, SystemModstamp, Actual_Ship_Date__c, AD_Compound__c, Additional_Admin_Cost__c,
            AHWT_Product_Line__c, Customer_Expectations_Met_on_Delivery__c, Date_Required_By__c, 
            Estimated_Arrival_Date__c, Estimated_Sample_Value__c, Estimated_Ship_Date__c, 
            Existing_Material_in_SAP__c, Lot_Numbers__c, Material__c, Material_Must_Ship_From_Location__c,
            Material_Plant__c, Nanjing_Material__c, Notes__c, PAC_Industry_Segment__c,
            PM_Castings_Product_Line__c, Potential_Annual_Value__c, Product_Line__c,
            Record_Status__c, Requested_Supplier__c, Sample_Quantity__c, Sample_Request__c, 
            Sample_Size__c, Sample_UOM__c, SAP_Material__c, SAP_Material_MSD2__c, SAP_Material_Number__c,
            Ship_From_Location__c, Shipping_Carrier__c, Shipping_Result__c, Special_Size__c, 
            Tectyl_Product__c, Track_Shipment__c, Tracking_Air_Bill__c
            FROM Sample_Material__c WHERE Sample_Request__c IN :sampleRequestIds];
    return sampleMaterials;                                                        
  }

//The End
}
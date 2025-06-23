public class SAP_Queries_Functions {

    public static final String LANG_CODE_E = 'E';

    public static final String DIST_CHAN_AAFI = '50';
    public static final String DIST_CHAN_AHWT = '10';

    public static final String DVSN_CODE_SLNK = '13';
    
    public static final Set<String> CUST_GROUPS = getCCSet('Customer_Groups__c');

    public static final Set<String> SALES_ORGS_AP = getCCSet('Sales_Orgs_AP__c');
    public static final Set<String> SALES_ORGS_EU = getCCSet('Sales_Orgs_EMEA__c');
    public static final Set<String> SALES_ORGS_NA = getCCSet('Sales_Orgs_NA__c');
    //Code added on 29-5-2020 for Lead time LA addition
    public static final Set<String> SALES_ORGS_LA = getCCSet('Sales_Orgs_LA__c');
  
    public static final Set<String> THIRD_PARTY_PLANTS_AP = getCCSet('Third_Party_Plants_AP__c');
    public static final Set<String> THIRD_PARTY_PLANTS_EU = getCCSet('Third_Party_Plants_EMEA__c');
    public static final Set<String> THIRD_PARTY_PLANTS_NA = getCCSet('Third_Party_Plants_NA__c');
      //Code added on 29-5-2020 for Lead time LA addition
    public static final Set<String> THIRD_PARTY_PLANTS_LA = getCCSet('Third_Party_Plants_LA__c');

    
    public static final Map<String, Set<String>> CUST_GROUP_CODES = new Map<String, Set<String>>{
        DIST_CHAN_AAFI => getCCSet('Customer_Groups_50__c'),
        DIST_CHAN_AHWT => getCCSet('Customer_Groups_10__c')
    };

    public static final Map<String, Set<String>> PRODUCT_LINE_CODES = new Map<String, Set<String>>{
        DIST_CHAN_AAFI => getCCSet('Product_Lines_50__c'),
        DIST_CHAN_AHWT => getCCSet('Product_Lines_10__c')
    };

    public static final Map<String, Set<String>> PRODUCT_FAMILY_CODES = new Map<String, Set<String>>{
        DIST_CHAN_AAFI => getCCSet('Product_Families_50__c'),
        DIST_CHAN_AHWT => getCCSet('Product_Families_10__c')
    };

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'SAP_Queries_Functions : ' + s);
    }
    
    public static Boolean isAHWT_AP(Account acc) {
        return (isAPSalesOrg(acc) && isAHWT(acc));
    }
    
    public static Boolean isAHWT_EMEA(Account acc) {
        return (isEUSalesOrg(acc) && isAHWT(acc));
    }
    
    public static Boolean isAHWT_NA(Account acc) {
        return (isNASalesOrg(acc) && isAHWT(acc));
    }
    
    public static Boolean isAHWT(Account acc) {
        String distChanCode = acc.SAP_DistChannel__c;
        return DIST_CHAN_AHWT.equals(distChanCode);
    }
    
    public static Boolean isAAFI(Account acc) {
        String distChanCode = acc.SAP_DistChannel__c;
        return DIST_CHAN_AAFI.equals(distChanCode);
    }
    
    public static Boolean isAAFI_NA(Account acc) {
        return (isNASalesOrg(acc) && isAAFI(acc));
    }
    
    public static Boolean isAPSalesOrg(Account acc) {
        return isAccInSalesOrgSet(acc, SALES_ORGS_AP);
    }
    
    public static Boolean isEUSalesOrg(Account acc) {
        return isAccInSalesOrgSet(acc, SALES_ORGS_EU);
    }
    
    public static Boolean isNASalesOrg(Account acc) {
        return isAccInSalesOrgSet(acc, SALES_ORGS_NA);
    }
    
    public static Boolean isStreamLink(Account acc) {
        String divisionCode = acc.SAP_DivisionCode__c;
        return DVSN_CODE_SLNK.equals(divisionCode);
    }
    
    public static Boolean isThirdPartyPlant(String sorgCode, String plantCode) {
    	return (SALES_ORGS_AP.contains(sorgCode) && THIRD_PARTY_PLANTS_AP.contains(plantCode)) ||
               (SALES_ORGS_EU.contains(sorgCode) && THIRD_PARTY_PLANTS_EU.contains(plantCode)) ||
            (SALES_ORGS_LA.contains(sorgCode) && THIRD_PARTY_PLANTS_LA.contains(plantCode)) ||
               (SALES_ORGS_NA.contains(sorgCode) && THIRD_PARTY_PLANTS_NA.contains(plantCode));
    }
    
    public static Set<String> getCCSet(String fname) {
    	return Custom_Config_Functions.getCCSet(fname);
    }
    
    public static void processBeforeUpsert(List<SAP_Sales_Org__c> slist) {
    	for (SAP_Sales_Org__c s : slist) {
    		s.Name = s.Sales_Org_Description__c + ' - ' + s.Sales_Org_Code__c;
    	}
    }
    
    private static Boolean isAccInSalesOrgSet(Account acc, Set<String> socodes) {
        if (acc == null) {return false;}
        String salesOrgCode = acc.SAP_Sales_Org__c;
        return socodes.contains(salesOrgCode);
    }
    
    public static User getLoggedInUser() {
        String userId = UserInfo.getUserId();
        List<User> results;
        results = [SELECT Id, UserName, email
                     FROM User WHERE id = :userId];
        if (!results.isEmpty()) {return results[0];}
        return null;                                                        
    }

    public static List<Account> getAccountsOwnedByLoggedInUser() {
        Id userId = UserInfo.getUserId();
        return getAccountsOwnedByUser(userId);
    }

    public static List<Account> getAccountsOwnedByUser(Id userId) {
        List<Account> results;
        results = [Select 
                      RecordType.Name
                    , AccountNumber
                    , SAP_Sales_Org__c
                    , SAP_DistChannel__c
                    , SAP_DivisionCode__c
                    , SAP_SalesDistrict__c
                    , SAP_Sales_Office__c
                    , SAP_SalesGroup__c
                    , SAP_Customer_Group__c
                    , SAP_Customer_Group_1__c
                    , SAP_Region__c
               From Account 
               where owner.id = :userId];
        if (!results.isEmpty()) {return results;}
        return null;                                                        
    }
    
    public static List<SAP_Sales_Org__c> getAllSalesOrgs() {
        List<SAP_Sales_Org__c> results;
        results = [SELECT Id,
                      Name, 
                      Sales_Org_Code__c, 
                      Sales_Org_Description__c 
                 FROM SAP_Sales_Org__c 
                WHERE Deleted__c = false
             ORDER BY Sales_Org_Description__c];
        return results;                                                        
    }

    public static Set<String> getSalesOrgSet() {
        Set<String> s = new Set<String>();
        s.addAll(SALES_ORGS_AP);
        s.addAll(SALES_ORGS_EU);
        s.addAll(SALES_ORGS_NA);
        return s;
    }

    private static Set<String> getSalesOrgSet(List<Account> alist) {
        if (alist == null || alist.isEmpty()) {return null;}
        Set<String> s = new Set<String>();
        for (Account a : alist) {
            if (a.SAP_Sales_Org__c != null) {s.add(a.SAP_Sales_Org__c);}
        }
        return s;
    }

    private static List<SAP_Sales_Org__c> getSalesOrgList(Set<String> s) {
        if (s == null || s.isEmpty()) {return null;}
        List<SAP_Sales_Org__c> results;
        results = [SELECT Id,
                      Name, 
                      Sales_Org_Code__c, 
                      Sales_Org_Description__c 
                 FROM SAP_Sales_Org__c
                WHERE Deleted__c = false
                  AND Sales_Org_Code__c in :s]; 
        if (!results.isEmpty()) {return results;}
        return null;                                                        
    }

    public static List<SAP_Sales_Org__c> getSalesOrgsOfLoggedInUser() {
        List<Account> alist = getAccountsOwnedByLoggedInUser();
        Set<String> s = getSalesOrgSet(alist);
        return getSalesOrgList(s);
    }
    
    public static List<User_Sales_Area__c> getSalesAreasOfLoggedInUser() {
        Id userId = UserInfo.getUserId();
        return getUserSalesAreas(userId);
    }
    
    public static List<SelectOption> getSalesOrgOpts() {
    	List<SelectOption> slist = new List<SelectOption>();
    	slist.add(new SelectOption('', 'All'));
    	Set<String> aset = getSalesOrgSet();
	    List<SAP_Sales_Org__c> alist = [
            select Sales_Org_Code__c, Sales_Org_Description__c 
              from SAP_Sales_Org__c where Deleted__c = false
               and Sales_Org_Code__c in :aset
	      order by Sales_Org_Description__c];
	    if (alist == null || alist.isEmpty()) {return slist;}
	    String val, lbl;
	    for (SAP_Sales_Org__c a : alist) {
            val = a.Sales_Org_Code__c;
            lbl = a.Sales_Org_Description__c + ' - ' + val;
            slist.add(new SelectOption(val, lbl));
	    }
	    return slist;
    }

    public static List<User_Sales_Area__c> getUserSalesAreas(Id userId) {
        return UserSalesAreaFunctions.getUserSalesAreas(userId);                                                        
    }
    
    public static List<User_Product_Segment__c> getProductLinesOfLoggedInUser() {
        Id userId = UserInfo.getUserId();
        return getUserProductLines(userId);
    }

    public static List<User_Product_Segment__c> getUserProductLines(Id userId) {
        return UserProductSegmentFunctions.getUserProductSegments(userId);                                                        
    }
    
    public static List<Customer_Group__c> getCustomerGroups(Id distChanId) {
        return CustomerGroupFunctions.getCustomerGroups(distChanId);
    }
    
    public static List<SAP_INCO_Term__c> getSapIncoTerms() {
        List<SAP_INCO_Term__c> alist = new List<SAP_INCO_Term__c>();
        Set<String> aset = new Set<String>{'ZD2', 'ZD3', 'ZO1', 'ZO4', 'ZF1', 'ZF3', 
                                       'FH', 'NA', 'UN', 'DAF', 'DDU', 'DEQ', 'DES'};
        for (SAP_INCO_Term__c a : [select Id, INCO_Term_Code__c, INCO_Term_Name__c
                                     from SAP_INCO_Term__c where Deleted__c = false]) {
            if (aset.contains(a.INCO_Term_Code__c)) {continue;}
            //debug(a.INCO_Term_Name__c);
            alist.add(a);
        }
        return alist;
    }
    
    public static Map<String, String> getSapIncoTermMap() {
        Map<String, String> amap = new Map<String, String>();
        List<SAP_INCO_Term__c> alist = getSapIncoTerms();
        if (alist != null && !alist.isEmpty()) {
            for (SAP_INCO_Term__c a : alist) {
                amap.put(a.INCO_Term_Code__c, a.INCO_Term_Name__c);
            }
        }
        return amap;
    }
    
    public Static List<SAP_INCO_Term__c> getSapIncoTerms(Id accountId) {
        List<SAP_INCO_Term__c> plist = getSapIncoTerms();
        List<SAP_INCO_Term__c> rlist = new List<SAP_INCO_Term__c>();
        if (plist == null || plist.isEmpty()) {return rlist;}
        Set<String> aset = new Set<String>{'CFR', 'CIF', 'DAP', 'DAT', 'EXW', 'FAS'};
        Set<String> bset = new Set<String>{'ZF2'};
        Boolean isNA = false, isAAFI_NA = false, isAHWT_NA = false;
        if (accountId != null) {
            Account acc = getAccount(accountId);
            if (acc == null) {return plist;}
            isNA = isNASalesOrg(acc); 
            isAAFI_NA = isAAFI_NA(acc); isAHWT_NA = isAHWT_NA(acc);
        }
        for (SAP_INCO_Term__c p : plist) {
            // for EMEA and AP - no Z* codes 
            if (!isNA && p.INCO_Term_Code__c.startsWith('Z')) {
                continue;
            }
            // for AHWT NA - only Z* codes
            if (isAHWT_NA && !p.INCO_Term_Code__c.startsWith('Z') && 
               !aset.contains(p.INCO_Term_Code__c)) {
                continue;
            }
            if (isAAFI_NA && bset.contains(p.INCO_Term_Code__c)) {
                continue;
            }
            //System.debug(accountId + ':' + p);
            rlist.add(p);
        }
        return rlist;
    }

    public static List<SAP_Plant__c> getSapPlants() {
        List<SAP_Plant__c> alist = [select Plant_Code__c,
                                       Plant_Name__c,
                                       Street_Address__c,
                                       City_Name__c,
                                       Region__c,
                                       Postal_Code__c
                                  from SAP_Plant__c
                                 where Deleted__c = false];
        return alist;
    }
    
    public static Map<String, SAP_Plant__c> getSapPlantMap() {
        Map<String, SAP_Plant__c> amap = new Map<String, SAP_Plant__c>();
        List<SAP_Plant__c> alist = getSapPlants();
        if (alist != null && !alist.isEmpty()) {
            for (SAP_Plant__c a : alist) {amap.put(a.Plant_Code__c, a);}
        }
        return amap;
    }
    
    public static Map<String, SAP_Sales_Org__c> getSapSalesOrgMap() {
        Map<String, SAP_Sales_Org__c> amap = new Map<String, SAP_Sales_Org__c>();
        for (SAP_Sales_Org__c sd : [SELECT Id, Name,
                                       Sales_Org_Code__c,
                                       Sales_Org_Description__c
                                  FROM SAP_Sales_Org__c
                                 WHERE Deleted__c = false
                                 ORDER BY Sales_Org_Description__c]) {
            amap.put(sd.Sales_Org_Code__c, sd);
        }
        return amap;
    }
    
    public static Map<String, SAP_Distribution_Channel__c> getSapDistChanMap() {
        Map<String, SAP_Distribution_Channel__c> amap = new Map<String, SAP_Distribution_Channel__c>();
        for (SAP_Distribution_Channel__c sd : [SELECT Id, Name,
                                                  Distribution_Channel_Code__c,
                                                  Distribution_Channel_Description__c
                                             FROM SAP_Distribution_Channel__c
                                            WHERE Deleted__c = false
                                            ORDER BY Distribution_Channel_Description__c]) {
            amap.put(sd.Distribution_Channel_Code__c, sd);
        }
        return amap;
    }
    
    public static Map<String, SAP_Sales_Division__c> getSapSalesDivisionMap() {
        Map<String, SAP_Sales_Division__c> amap = new Map<String, SAP_Sales_Division__c>();
        for (SAP_Sales_Division__c sd : [SELECT Id, Name,
                                            Sales_Division_Code__c,
                                            Sales_Division_Description__c
                                       FROM SAP_Sales_Division__c
                                      WHERE Deleted__c = false
                                      ORDER BY Sales_Division_Description__c]) {
            amap.put(sd.Sales_Division_Code__c, sd);
        }
        return amap;
    }
    
    private static List<SAP_UOM_Code__c> getSapUomCodes(String uomType) {
        List<SAP_UOM_Code__c> uoms = [select UOM_Code__c
                                        from SAP_UOM_Code__c
                                       where Deleted__c = false
                                         and Dimension_Key__c = :uomType];
        return uoms;
    }
    
    public static Set<String> getMassUoms() {
        List<SAP_UOM_Code__c> massUoms = getSapUomCodes('MASS');
        Set<String> uset = new Set<String>();
        if (massUoms != null && !massUoms.isEmpty()) {
            for (SAP_UOM_Code__c u : massUoms) {uset.add(u.UOM_Code__c);} 
        }
        return uset;
    }
    
    public static SAP_UOM_Description__c getSapUomDesc(String uomCode) {
    	SAP_UOM_Description__c uomDesc = null;
        List<SAP_UOM_Description__c> ulist = [select Id, Name,
                                                     UOM_Code__c,
                                                     UOM_Description__c
                                                from SAP_UOM_Description__c
                                               where Deleted__c = false
                                                 and Language_Code__c = 'E'
                                                 and UOM_Code__c = :uomCode];
        if (ulist != null && !ulist.isEmpty()) {uomDesc = ulist[0];}
        return uomDesc;
    }
    
    public static Map<String, SAP_UOM_Description__c> getSapUomDescMap() {
        Map<String, SAP_UOM_Description__c> umap = new Map<String, SAP_UOM_Description__c>();
        for (SAP_UOM_Description__c u : [select Id, Name,
                                                UOM_Code__c,
                                                UOM_Description__c
                                           from SAP_UOM_Description__c
                                          where Deleted__c = false
                                            and Language_Code__c = 'E'
                                        ]) {umap.put(u.UOM_Code__c, u);}
        return umap;
    }
    
    public static List<SAP_UOM_Description__c> getSapUomDescs(Set<String> uomCodes) {
      if (uomCodes == null || uomCodes.isEmpty()) {return null;}
      Map<String, SAP_UOM_Description__c> uomDescMap = getSapUomDescMap();
      return getSapUomDescs(uomDescMap, uomCodes);
    }
    
    public static List<SAP_UOM_Description__c> getSapUomDescs(Map<String, SAP_UOM_Description__c> uomDescMap, 
                                                              Set<String> uomCodes) {
      if (uomCodes == null || uomCodes.isEmpty()) {return null;}
      List<SAP_UOM_Description__c> uoms = new List<SAP_UOM_Description__c>();
      for (String c : uomCodes) {
        if (uomDescMap.containsKey(c)) {uoms.add(uomDescMap.get(c));}
      }
      return uoms;
    }
    
    public static List<SelectOption> getSapUomOpts(Set<String> uomCodes) {
    	List<SelectOption> alist = new List<SelectOption>();
    	List<SAP_UOM_Description__c> blist = getSapUomDescs(uomCodes);
    	if (blist == null) {return alist;} String val, lbl;
    	for (SAP_UOM_Description__c b : blist) {
    		val = b.UOM_Code__c; lbl = val + ' - ' + b.UOM_Description__c;
    		alist.add(new SelectOption(val, lbl));
    	}
    	return alist;
    }
    
    public static Map<String, String> getIndustryNames(Set<String> codes) {
        Map<String, String> amap = new Map<String, String>();
        if (codes != null && !codes.isEmpty()) {
            for (SAP_Industry_Name__c a : [select Industry_Code__c,
                                                  Industry_Name__c
                                             from SAP_Industry_Name__c
                                            where Deleted__c = false
                                              and Industry_Code__c in :codes
                                          ]) {
                amap.put(a.Industry_Code__c, a.Industry_Name__c);
            }
        }
        return amap;
    }
    
    public static Map<String, String> getPaymentTermDescs(Set<String> codes) {
        Map<String, String> amap = new Map<String, String>();
        if (codes != null && !codes.isEmpty()) {
            for (SAP_Payment_Term_Explanation__c a : [select Payment_Term_Code__c,
                                                             Payment_Term_Explanation__c
                                                        from SAP_Payment_Term_Explanation__c
                                                       where Deleted__c = false
                                                         and Payment_Term_Code__c in :codes
                                          ]) {
                amap.put(a.Payment_Term_Code__c, a.Payment_Term_Explanation__c);
            }
        }
        return amap;
    }
    
    private static Account getAccount(Id accountId) {
        List<Account> accs = [select Id, SAP_DistChannel__c,
                                     SAP_Sales_Org__c
                                from Account
                               where Id = :accountId
                             ];
        if (accs == null || accs.isEmpty()) {
            return null;
        }
        return accs[0];
    }
    
    public static List<SAP_Payment_Term_Explanation__c> getPaymentTermExplanations() {
        List<SAP_Payment_Term_Explanation__c> plist = [select Payment_Term_Code__c,
                                                              Payment_Term_Explanation__c 
                                                         from SAP_Payment_Term_Explanation__c
                                                        where Deleted__c = false
                                                      ];
        return plist;
    }

    public static List<SAP_Payment_Term_Explanation__c> getPaymentTermExplanations(Id accountId, 
                                                                                   List<SAP_Payment_Term_Explanation__c> plist) {
        List<SAP_Payment_Term_Explanation__c> rlist = new List<SAP_Payment_Term_Explanation__c>();
        if (plist == null || plist.isEmpty()) {return rlist;}
        Boolean isAAFI = false;
        if (accountId != null) {
            Account acc = getAccount(accountId);
            if (acc == null) {return plist;}
            isAAFI = (acc.SAP_DistChannel__c == DIST_CHAN_AAFI);
        }
        for (SAP_Payment_Term_Explanation__c p : plist) {
            if (isAAFI && !p.Payment_Term_Code__c.startsWith('Z')) {continue;}
            rlist.add(p);
        }
        return rlist;
    }

    public static List<SAP_Payment_Term_Explanation__c> getPaymentTermExplanations(Id accountId) {
        List<SAP_Payment_Term_Explanation__c> plist = getPaymentTermExplanations();
        return getPaymentTermExplanations(accountId, plist);
    }
    
    public static List<SelectOption> getCountrySelectList() {
    	List<SelectOption> alist = new List<SelectOption>();
    	Set<String> aset = new Set<String>{'US'};
    	alist.add(new SelectOption('US', 'USA - US'));
        for (SAP_Country_Name__c a : [
            select Country_Code__c, Country_Name__c 
              from SAP_Country_Name__c
             where Language_Code__c = :LANG_CODE_E
               and Deleted__c = false
             order by Country_Name__c]) {
            if (aset.contains(a.Country_Code__c)) {continue;}
          	alist.add(new SelectOption(a.Country_Code__c, 
                a.Country_Name__c + ' - ' + a.Country_Code__c));
        }
        return alist;
    }
    
/*
 **********************************************************
 Test Methods
 ********************************************************** 
 */    

//*
    @isTest public static void test01() {

      //  Id userId = '00550000000rdVPAAY'; // Carey Chapman
      //  Id distChanId = 'a2n500000004CED'; // AHWT 
           Id userId = '00550000000rdVPAAY'; // Carey Chapman
        Id distChanId = '00550000003XAo1'; // AHWT 
        Test.startTest();
        List<Account> alist = getAccountsOwnedByUser(userId);
        if (alist != null) {
            System.debug('List size : '+ alist.size());
            Set<String> s = getSalesOrgSet(alist);
            System.debug('Set size : '+s.size());
            List<SAP_Sales_Org__c> blist = getSalesOrgList(s);
            if (blist != null) {debug('List size : '+ blist.size());}
        }
        getLoggedInUser();
        //getAccountsOwnedByLoggedInUser();
        getAllSalesOrgs();
        getUserSalesAreas(userId);
        getSalesAreasOfLoggedInUser();
        getSalesOrgsOfLoggedInUser();
        getProductLinesOfLoggedInUser();
        getUserProductLines(userId);
        getCustomerGroups(distChanId);
        getSapIncoTerms();
        getSapIncoTermMap();
        getSapSalesOrgMap();
        getSapDistChanMap();
        getSapSalesDivisionMap();
        //Test
        getSalesOrgSet();
        isThirdPartyPlant('1111','1100');
        Test.stopTest();
        
    }
    
    @isTest public static void test02() {
        Test.startTest();
        getSapPlants();
        getSapPlantMap();
        getCountrySelectList();
        Test.stopTest();
    }    
    
    @isTest public static void test03() {
        Test.startTest();
        String uomCode = '!@';
        Set<String> uomCodes = new Set<String>{uomCode};
        SAP_UOM_Description__c uomDesc = new SAP_UOM_Description__c();
        uomDesc.Language_Code__c = 'E';
        uomDesc.UOM_Code__c = uomCode;
        uomDesc.UOM_Description__c = 'Test UOM';
        insert uomDesc;
        getMassUoms();
        getSapUomDescs(null);
        getSapUomDescs(uomCodes);
        
        //test
        getSapUomOpts(uomCodes);
        getSalesOrgOpts();
        getPaymentTermExplanations();
        Test.stopTest();
        debug('str');
    }
    
    @isTest public static void test04() {
        Test.startTest();
        Map<String, String> amap;      
        Set<String> codes = new Set<String>{'Z030'};      
        amap = getIndustryNames(codes);      
        System.debug(amap);
        amap = getPaymentTermDescs(codes);      
        System.debug(amap);
        Test.stopTest();
    }
    
    @isTest public static void test05() {
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'Test Water Account';
        acc.SAP_DistChannel__c = DIST_CHAN_AAFI;
        insert acc;
        isAHWT_EMEA(acc);
        isAHWT_NA(acc);
        isStreamLink(acc);
        Id accountId = acc.Id;
        List<SAP_Payment_Term_Explanation__c> plist = new 
        List<SAP_Payment_Term_Explanation__c>(), rlist;
        SAP_Payment_Term_Explanation__c p;
        p = new SAP_Payment_Term_Explanation__c(
                   Day_Limit__c='01',
                   Language_Code__c='E',
                   Record_Key__c='A001',
                   Payment_Term_Code__c='A001', 
                   Payment_Term_Explanation__c = 'E001');
        plist.add(p);
        p = new SAP_Payment_Term_Explanation__c(
                   Day_Limit__c='01',
                   Language_Code__c='E',
                   Record_Key__c='Z001',
                   Payment_Term_Code__c='Z001', 
                   Payment_Term_Explanation__c = 'E002');
        plist.add(p);
        try {insert plist;} catch(Exception e){}
        rlist = getPaymentTermExplanations(accountId, plist);
        System.debug(rlist);
        rlist = getPaymentTermExplanations(null, plist);
        System.debug(rlist);
        getPaymentTermDescs(new Set<String>{'A001', 'Z001'});
        //test
        isAPSalesOrg(acc);
isAAFI_NA(acc);
isAAFI(acc);
isAHWT(acc);
isAHWT_AP(acc);
        getSapUomDesc('str');
        getSapIncoTerms(acc.Id);

        Test.stopTest();
    }
//*/
   /* @isTest public static void test06() {
        Test.startTest();
        Account ac1 = new Account();
        ac1.Name = 'Test Water Account1';
        ac1.SAP_DistChannel__c = DIST_CHAN_AHWT;
        ac1.SAP_Sales_Org__c = '1000';
        Account ac2 = new Account();
        ac2.Name = 'Test Water Account2';
        ac2.SAP_DistChannel__c = DIST_CHAN_AHWT;
        ac2.SAP_Sales_Org__c = '0070';
        List<Account> accs = new List<Account>{ac1, ac2};
        insert accs;
        getSalesOrgSet(accs);
        getSalesOrgList(new Set<String>{'1000'});
        Id acId1 = ac1.Id, acId2 = ac2.Id;
        List<SAP_INCO_Term__c> rlist;
        //acId1 = '0015000000GXsHTAA1'; 
        //acId2 = '0015000000L3HSHAA3';
        rlist = getSapIncoTerms(acId1);
        System.debug(rlist.size()+' : '+rlist);
        rlist = getSapIncoTerms(acId2);
        System.debug(rlist.size()+' : '+rlist);
        rlist = getSapIncoTerms(null);
        System.debug(rlist.size()+' : '+rlist);
        Test.stopTest();
    }*/

}
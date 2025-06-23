public class PriceBookFunctions {

    public static final String CLASS_NAME = 'PriceBookFunctions';
    public static final String OBJECT_NAME = 'Price_Book__c';
    public static final String NL = '\n';
    public static final String COLON = ':';
    public static final String ACTIVE = 'Active';
    public static final String APPROVED = 'Approved but not Active yet';
    public static final String CANCELLED = 'Cancelled';
    public static final String DRAFT = 'Draft';
    public static final String EXPIRED = 'Expired';
    public static final Set<String> APPROVED_RECS = new Set<String>{APPROVED};
    public static final Set<String> ACTIVE_RECS = new Set<String>{ACTIVE};
    public static final Set<String> ACTIVE_APPROVED = new Set<String>{ACTIVE, APPROVED};
    
    private static final String QRY_STRING1 = 'select Id, Name, Owner.Name, Active__c,' +
        ' Approver_Comments__c, Description__c, Dist_Channel__c, Dist_Channel_Code__c,' +
        ' Dist_Channel_Description__c, Division__c, Division_Code__c, Division_Description__c,' +
        ' Effective_Date__c, Number_of_Materials_on_Price_Book__c, Number_of_Services__c,' +
        ' Record_Status__c, VCP_Grade__c';

    private static final String QRY_STRING2 = ' from Price_Book__c '; 

    public static final String SELECT_QRY_1 = QRY_STRING1 + ',' +

        '(select Id, Customer_Group_Code__c, Customer_Group_Desc__c, SAP_Customer_Group__c' +  
        '   from Price_Book_Customer_Groups__r), ' + 

        '(select Id, Family_Code__c, Family_Desc__c' +  
        '   from Price_Book_Families__r), ' +

        '(select Id, Product_Line_Code__c, Product_Line_Desc__c' + 
        '   from Price_Book_Product_Lines__r), ' +

        '(select Id, Region_Code__c, Region_Desc__c, SAP_Region__c' +  
        '   from Price_Book_Regions__r), ' + 

        '(select Id, Sales_Org_Code__c, Sales_Org_Desc__c, SAP_Sales_Org__c' +  
        '   from Price_Book_Sales_Orgs__r)' + 

        QRY_STRING2;
    
    public static final String SELECT_QRY_2 = QRY_STRING1 + QRY_STRING2;

    // static flag to avoid recursion
    public static Boolean processBeforeUpdate = true;
    
    public static void processBeforeUpdate(List<Price_Book__c> pbs) {
        if (processBeforeUpdate) {
            processBeforeUpdate = false;
            setPriceBookFields(pbs);
            //activatePriceBooks(pbs);
        }
    }
    
    private static void debug(String s) {
        /*
        Integer n1 = Limits.getQueries();
        Integer n2 = Limits.getLimitQueries();
        Integer n3 = Limits.getScriptStatements();
        Integer n4 = Limits.getLimitScriptStatements();
        Integer n5 = Limits.getHeapSize();
        Integer n6 = Limits.getLimitHeapSize();
        System.debug('>>>>>>> Queries : ' + s + ' : ' + n1 + ' / ' + n2);
        System.debug('>>>>>>> Statements : ' + s + ' : ' + n3 + ' / ' + n4);
        System.debug('>>>>>>> HeapSize : ' + s + ' : ' + n5 + ' / ' + n6);
        */
        System.debug(LoggingLevel.INFO, '>>>>>>> '+s);
    }
    
    private static void debug(String s, List<Price_Book__c> pbs) {
        if (pbs == null || pbs.isEmpty()) {
            DebugLog_Functions.logMessage(s, CLASS_NAME); return;
        }
        String msg; 
        for (Price_Book__c pb : pbs) {
            msg = s + ' : Name = ' + pb.Name + ' : Id = ' + pb.Id + 
                      ' : Expired By = ' + pb.Expired_By__c;
            DebugLog_Functions.logMessage(msg, CLASS_NAME);
        }
    }
    
    public static String getPriceBookTabUrl() {
        String objPrefix = ObjectPrefixFunctions.getObjectKeyPrefix(OBJECT_NAME);
        return '/' + objPrefix + '/o';
    }
    
    public static List<Price_Book__c> getActivePriceBooks() {
        List<Price_Book__c> alist = new List<Price_Book__c>();
        String q = SELECT_QRY_1 + ' where Record_Status__c in :ACTIVE_RECS';
        for (Price_Book__c pb : Database.query(q)) {
            alist.add(pb);
        }
        return (alist == null || alist.isEmpty()) ? null : alist;
    }
    
    public static List<Price_Book__c> getApprovedPriceBooks() {
        List<Price_Book__c> alist = new List<Price_Book__c>();
        String q = SELECT_QRY_1 + ' where Record_Status__c in :APPROVED_RECS';
        for (Price_Book__c pb : Database.query(q)) {
            alist.add(pb);
        }
        return (alist == null || alist.isEmpty()) ? null : alist;
    }
    
    public static List<Price_Book__c> getApprovedPriceBooks(Set<String> pbIds) {
        List<Price_Book__c> alist = new List<Price_Book__c>();
        String q = SELECT_QRY_1 + ' where Id in :pbIds and Record_Status__c in :APPROVED_RECS';
        for (Price_Book__c pb : Database.query(q)) {
            alist.add(pb);
        }
        return (alist == null || alist.isEmpty()) ? null : alist;
    }
    
    public static Boolean isActive(Price_Book__c pb) {
        return (pb.Active__c || pb.Record_Status__c == ACTIVE);
    }
    
    public static Boolean isApproved(Price_Book__c pb) {
        return (pb.Record_Status__c == APPROVED);
    }
    
    public static void setPriceBookFields(List<Price_Book__c> pbs) {
        Set<String> pbids = getPriceBookIds(pbs);
        Map<String, List<Price_Book_Customer_Group__c>> pbCustomerGroupMap = PriceBookCustGroupFunctions.getPriceBookCustomerGroupMap(pbids);
        Map<String, List<Price_Book_Family__c>> pbFamilyMap = PriceBookFamilyFunctions.getPriceBookFamilyMap(pbids);
        Map<String, List<Price_Book_Product_Line__c>> pbProductLineMap = PriceBookProductLineFunctions.getPriceBookProductLineMap(pbids);
        Map<String, List<Price_Book_Region__c>> pbRegionMap = PriceBookRegionFunctions.getPriceBookRegionMap(pbids);
        Map<String, List<Price_Book_Sales_Org__c>> pbSalesOrgMap = PriceBookSalesOrgFunctions.getPriceBookSalesOrgMap(pbids);
        for (Price_Book__c pb : pbs) {
            PriceBookCustGroupFunctions.setCustomerGroupsDesc(pb, pbCustomerGroupMap);
            PriceBookFamilyFunctions.setProductFamiliesDesc(pb, pbFamilyMap);
            PriceBookProductLineFunctions.setProductLinesDesc(pb, pbProductLineMap);
            PriceBookRegionFunctions.setRegionsDesc(pb, pbRegionMap);
            PriceBookSalesOrgFunctions.setSalesOrgsDesc(pb, pbSalesOrgMap);
             }
    }
    
    public static List<Price_Book__c> activatePriceBooks(List<Price_Book__c> pbs) {
        Date tdate = System.today();
        List<Price_Book__c> alist = new List<Price_Book__c>();
        for (Price_Book__c pb : pbs) {
            Date edate = pb.Effective_Date__c;
            Integer n = edate.daysBetween(tdate); 
            if (n >= 0 && isApproved(pb)) {
                //debug(''+pb);
                pb.Active__c = true;
                pb.Current_State__c = ACTIVE;
                pb.Record_Status__c = ACTIVE;
                alist.add(pb);
            } 
        }
        if (!alist.isEmpty()) {
            Savepoint sp = Database.setSavepoint();
            try {
                debug('PBs to be activated', alist);
                List<Price_Book__c> blist = getActivePriceBooks(alist);
                debug('PBs to be expired  ', blist);
                deactivatePriceBooks(blist);
                
                return alist;
            } catch(Exception e) {
                Database.rollback(sp);
                System.debug(e.getMessage());
            }
        }
        return null;
    }
    
    public static void deactivatePriceBooks(List<Price_Book__c> pbs) {
        if (pbs == null || pbs.isEmpty()) {
            return;
        }
        Date tdate = System.today();
        List<Price_Book__c> alist = new List<Price_Book__c>();
        for (Price_Book__c pb : pbs) {
            Date edate = pb.Effective_Date__c;
            Integer n = tdate.daysBetween(edate); 
            if (isActive(pb) && n <= 0) {
                pb.Active__c = false;
                pb.Current_State__c = EXPIRED;
                pb.Record_Status__c = EXPIRED;
                pb.Price_Book_Group__c = null;
                alist.add(pb);
            } 
        }
        if (!alist.isEmpty()) {
            try {
                //debug(''+alist);
                update alist;
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
        }
    }
    
    public static List<Price_Book__c> getActivePriceBooks(List<Price_Book__c> pblist) {
        Set<String> pbIds = getPriceBookIds(pblist);
        Set<String> distChanCodes = new Set<String>();
        Set<String> divisionCodes = new Set<String>();
        Set<String> vcpGrades = new Set<String>();
        //getFieldValueSets(pblist, distChanCodes, divisionCodes);
        getFieldValueSets(pblist, distChanCodes, divisionCodes, vcpGrades);
        Map<String, Price_Book__c> pbMap = getActivePriceBooks(distChanCodes, divisionCodes, vcpGrades);
        List<Price_Book__c> pbs = pbMap.values();
        if (pbs == null || pbs.isEmpty()) {
            return null;
        }
        //List<Price_Book__c> pbs2 = getActivePriceBooks(pbIds, pblist, pbs);
        List<Price_Book__c> pbs2 = getActivePriceBooks(pbIds, vcpGrades, pblist, pbs);
        return pbs2;
    }
    
    private static List<Price_Book__c> getActivePriceBooks(Set<String> pbIds,
                                                           List<Price_Book__c> pblist, 
                                                           List<Price_Book__c> pbs) {
        List<Price_Book__c> pbs2 = new List<Price_Book__c>();
        Set<String> pbIds2 = new Set<String>(); 
        String recStatus;
        for (Price_Book__c pb : pbs) {
            recStatus = pb.Record_Status__c;
            if (ACTIVE_RECS.contains(recStatus) && !pbIds.contains(pb.Id)) {
                pbs2.add(pb);
                pbIds2.add(pb.Id);
            }
        }
        if (pbs2.isEmpty()) {return null;} pbs = null;
        List<Price_Book__c> pbs3 = getMatchingPriceBooks(pbIds, pblist, pbIds2, pbs2);
        return pbs3;
    }
    
    private static List<Price_Book__c> getActivePriceBooks(Set<String> pbIds,
                                                           Set<String> vcpGrade,
                                                           List<Price_Book__c> pblist, 
                                                           List<Price_Book__c> pbs) {
        List<Price_Book__c> pbs2 = new List<Price_Book__c>();
        Set<String> pbIds2 = new Set<String>(); 
        String recStatus;
                                                               
        for (Price_Book__c pb : pbs) {
            
            recStatus = pb.Record_Status__c;
            if (ACTIVE_RECS.contains(recStatus) && !pbIds.contains(pb.Id) && vcpGrade.contains(pb.VCP_Grade__c)) {
                pbs2.add(pb);
                pbIds2.add(pb.Id);                            
            }
        }
        if (pbs2.isEmpty()) {return null;} pbs = null;
        List<Price_Book__c> pbs3 = getMatchingPriceBooks(pbIds, pblist, pbIds2, pbs2);
        return pbs3;
    }
    
    private static List<Price_Book__c> getMatchingPriceBooks(Set<String> pbIds1,
                                                             List<Price_Book__c> pbs1,
                                                             Set<String> pbIds2, 
                                                             List<Price_Book__c> pbs2) {
        //debug(''+pbIds1); debug(''+pbs1); debug(''+pbIds2); debug(''+pbs2);
        List<Price_Book__c> pbs3 = new List<Price_Book__c>();
        Set<String> pbIds3 = new Set<String>(); Boolean b;
        pbIds3.addAll(pbIds1); pbIds3.addAll(pbIds2); 

        Map<String, Set<String>> amap;
        
        pbs3 = new List<Price_Book__c>(); pbIds3 = new Set<String>(); pbIds3.addAll(pbIds1); 
        for (Price_Book__c pb1 : pbs1) {
            for (Price_Book__c pb2 : pbs2) {
                //if (pb1.Dist_Channel__c == pb2.Dist_Channel__c && pb1.Division__c == pb2.Division__c) {
                if (pb1.Dist_Channel__c == pb2.Dist_Channel__c) {
                    pbs3.add(pb2); pbIds3.add(pb2.Id);
                }
            }
        }
        if (pbs3.isEmpty()) {return null;} else {pbs2 = pbs3.deepClone(true);} 

        amap = PriceBookSalesOrgFunctions.getPriceBookSalesOrgIdMap(pbIds3);
        pbs3 = new List<Price_Book__c>(); pbIds3 = new Set<String>(); pbIds3.addAll(pbIds1);
        getMatchingPriceBooks(pbs1, pbs2, pbs3, pbIds3, amap);
        if (pbs3.isEmpty()) {return null;} else {pbs2 = pbs3.deepClone(true);} 

        amap = PriceBookProductLineFunctions.getPriceBookProductLineCodeMap(pbIds3);
        pbs3 = new List<Price_Book__c>(); pbIds3 = new Set<String>(); pbIds3.addAll(pbIds1);
        getMatchingPriceBooks(pbs1, pbs2, pbs3, pbIds3, amap);
        if (pbs3.isEmpty()) {return null;} else {pbs2 = pbs3.deepClone(true);} 

        amap = PriceBookFamilyFunctions.getPriceBookFamilyCodeMap(pbIds3);
        pbs3 = new List<Price_Book__c>(); pbIds3 = new Set<String>(); pbIds3.addAll(pbIds1);
        getMatchingPriceBooks(pbs1, pbs2, pbs3, pbIds3, amap);
        if (pbs3.isEmpty()) {return null;} else {pbs2 = pbs3.deepClone(true);} 

        amap = PriceBookRegionFunctions.getPriceBookRegionIdMap(pbIds3);
        pbs3 = new List<Price_Book__c>(); pbIds3 = new Set<String>(); pbIds3.addAll(pbIds1);
        getMatchingPriceBooks(pbs1, pbs2, pbs3, pbIds3, amap);
        if (pbs3.isEmpty()) {return null;} else {pbs2 = pbs3.deepClone(true);} 

        amap = PriceBookCustGroupFunctions.getPriceBookCustomerGroupIdMap(pbIds3);
        pbs3 = new List<Price_Book__c>(); pbIds3 = new Set<String>(); pbIds3.addAll(pbIds1);
        //debug('cg.amap = ' + amap);
        getMatchingPriceBooks(pbs1, pbs2, pbs3, pbIds3, amap);
        
        if (pbs3.isEmpty()) {return null;} else {return pbs3;} 
    }
    
    private static void getMatchingPriceBooks(List<Price_Book__c> pbs1, List<Price_Book__c> pbs2,
                                              List<Price_Book__c> pbs3, Set<String> pbIds3,
                                              Map<String, Set<String>> amap) {
        Boolean b;
        for (Price_Book__c pb1 : pbs1) {
            for (Price_Book__c pb2 : pbs2) {
                b = comparePriceBooksKeys(pb1, pb2, amap); 
                if (b && !pbIds3.contains(pb2.Id)) {
                    pb2.Expired_By__c = pb1.Id;
                    pbs3.add(pb2); pbIds3.add(pb2.Id);
                }
            }
        }
        //debug('pbs3.size = ' + pbs3.size());
    }
    
    private static Boolean comparePriceBooksKeys(Price_Book__c pb1,
                                                 Price_Book__c pb2,
                                                 Map<String, Set<String>> pmap) {
        String id1 = pb1.Id;
        String id2 = pb2.Id;
        //debug(id1 + ':' + pmap.containsKey(id1));
        //debug(id2 + ':' + pmap.containsKey(id2));
        if (pmap != null && pmap.containsKey(id1) && 
                            pmap.containsKey(id2)) {
            Set<String> set1 = pmap.get(id1);
            Set<String> set2 = pmap.get(id2);
            return compareIdSets(set1, set2);
        }
        return false;
    }
    
    public static List<Price_Book__c> getPriceBooks(String pbid) {
        return getPriceBooks(new Set<Id>{pbid});
    }
    
    public static List<Price_Book__c> getPriceBooks(Set<String> pbids) {
        Set<Id> ids = new Set<Id>();
        for (String s : pbids) {
            ids.add(s);
        }
        return getPriceBooks(ids);
    }
    
    public static List<Price_Book__c> getPriceBooks(Set<Id> pbids) {
        String q = SELECT_QRY_1 + ' where id in :pbids';
        List<Price_Book__c> alist = Database.query(q);
        if (alist == null || alist.isEmpty()) {return null;}
        return alist;
    }
    
    public static List<Price_Book__c> getActivePriceBooks(Set<String> pbids) {
        String q = SELECT_QRY_2 + ' where Id in :pbids and Record_Status__c in :ACTIVE_RECS';
        List<Price_Book__c> alist = Database.query(q);
        if (alist == null || alist.isEmpty()) {return null;}
        return alist;
    }

    public static Map<String, Price_Book__c> getActivePriceBooks(Set<String> distChanCodes,
                                                                 Set<String> divisionCodes) {
        String q = SELECT_QRY_2 + ' where Record_Status__c in :ACTIVE_RECS' +
                   ' and Dist_Channel_Code__c in :distChanCodes ';
        if (divisionCodes != null && !divisionCodes.isEmpty()) {
             q += ' and Division_Code__c in :divisionCodes';
        }
        Map<String, Price_Book__c> pmap = new Map<String, Price_Book__c>();
        try {
            for (Price_Book__c p : Database.query(q)) {
                pmap.put(p.Id, p);
            }
        } catch(Exception e) {return null;}
        return pmap;
        
    }
    
     public static Map<String, Price_Book__c> getActivePriceBooks(Set<String> distChanCodes,
                                                                 Set<String> divisionCodes,
                                                                  Set<String> vcpGrade) {
                                                                      system.debug('distChanCodes**'+distChanCodes);
                                                                      system.debug('divisionCodes**'+divisionCodes);
                                                                      system.debug('vcpGrade*'+vcpGrade);
                                                                      system.debug('enter the dragon.....');
        String q = SELECT_QRY_2 + ' where Record_Status__c in :ACTIVE_RECS' +
                   ' and Dist_Channel_Code__c in :distChanCodes ';
         if (divisionCodes != null && !divisionCodes.isEmpty()) {
             q += ' and Division_Code__c in :divisionCodes';
        }
       if(vcpGrade != Null && !vcpGrade.isEmpty()){
            q += ' and VCP_Grade__c in :vcpGrade';
          }
          // String q = SELECT_QRY_2 + ' where Record_Status__c in :ACTIVE_RECS' ;
                                                               system.debug('q query1'+q); 
        Map<String, Price_Book__c> pmap = new Map<String, Price_Book__c>();
        try {
            for (Price_Book__c p : Database.query(q)) {
                pmap.put(p.Id, p);
                system.debug('p line394'+p);
                system.debug('pmap'+pmap);
            }
        } catch(Exception e) {return null;}
        return pmap;
                                                                      
    }
     public static Map<String, Price_Book__c> getActivePriceBooks(Set<String> distChanCodes,
                                                                 Set<String> divisionCodes,
                                                                 String vcpGrade) {
                                                                     system.debug('enter the dragon2.....');
        String q = SELECT_QRY_2 + ' where Record_Status__c in :ACTIVE_RECS' +
                   ' and Dist_Channel_Code__c in :distChanCodes ';
        if (divisionCodes != null && !divisionCodes.isEmpty()) {
             q += ' and Division_Code__c in :divisionCodes';
        }
        if(vcpGrade != Null && !String.IsBlank(vcpGrade)){
            q += ' and VCP_Grade__c =:vcpGrade';
        }
        system.debug('q query'+q); 
        Map<String, Price_Book__c> pmap = new Map<String, Price_Book__c>();
        try {
            for (Price_Book__c p : Database.query(q)) {
                pmap.put(p.Id, p);
            }
        } catch(Exception e) {return null;}
        return pmap;
    }

    public static List<Price_Book__c> getActivePriceBooks(Set<String> salesOrgCodes,
                                                          Set<String> distChanCodes,
                                                          Set<String> divisionCodes,
                                                          Set<String> prodLineCodes,
                                                          Set<String> familyCodes,
                                                          Set<String> regionCodes,
                                                          Set<String> custGroupCodes) {
        Set<String> pbIds;
        Map<String, Price_Book__c> pmap = getActivePriceBooks(distChanCodes, divisionCodes);
        if (pmap == null || pmap.isEmpty()) {
            return null;
        }
        pbIds = pmap.keySet();

        Map<String, Set<String>> cmap = PriceBookCustGroupFunctions.getPriceBookCustomerGroupCodeMap(pbIds);
        if (cmap == null || cmap.isEmpty()) {
            return null;
        }
        pbIds = cmap.keySet();

        Map<String, Set<String>> fmap = PriceBookFamilyFunctions.getPriceBookFamilyCodeMap(pbIds);
        if (fmap == null || fmap.isEmpty()) {
            return null;
        }
        pbIds = fmap.keySet();

        Map<String, Set<String>> lmap = PriceBookProductLineFunctions.getPriceBookProductLineCodeMap(pbIds);
        if (lmap == null || lmap.isEmpty()) {
            return null;
        }
        pbIds = lmap.keySet();

        Map<String, Set<String>> rmap = PriceBookRegionFunctions.getPriceBookRegionCodeMap(pbIds);
        if (rmap == null || rmap.isEmpty()) {
            return null;
        }
        pbIds = rmap.keySet();

        Map<String, Set<String>> smap = PriceBookSalesOrgFunctions.getPriceBookSalesOrgCodeMap(pbIds);
        if (smap == null || smap.isEmpty()) {
            return null;
        }
        pbIds = smap.keySet();

        List<Price_Book__c> pblist = new List<Price_Book__c>();
        for (String s : pbIds) {
            if (pmap.containsKey(s)) {
                pblist.add(pmap.get(s));
            }
        }
        if (pblist.isEmpty()) {
            return null;
        }
        return pblist;
    }
    
    private static void getFieldValueSets(List<Price_Book__c> pbs,
                                          Set<String> distChanCodes,
                                          Set<String> divisionCodes) {
        for (Price_Book__c pb : pbs) {
            distChanCodes.add(pb.Dist_Channel_Code__c);
            divisionCodes.add(pb.Division_Code__c);
        }
    }
    
    private static void getFieldValueSets(List<Price_Book__c> pbs,
                                          Set<String> distChanCodes,
                                          Set<String> divisionCodes,
                                          Set<String> vcpGrades) {
        for (Price_Book__c pb : pbs) {
            distChanCodes.add(pb.Dist_Channel_Code__c);
            divisionCodes.add(pb.Division_Code__c);
            vcpGrades.add(pb.VCP_Grade__c);
        }
    }
    
    public static List<Price_Book__c> getPriceBooks(String sorgIds, String dchanId, String divsnId,
                                                    String prodLineCode, String familyCodes, String regionIds,
                                                    String custGroupIds, String vcpGrade) {
       return getPriceBooks(sorgIds, dchanId, divsnId, prodLineCode, familyCodes, regionIds, custGroupIds, vcpGrade, false);
    }
    
    public static List<Price_Book__c> getPriceBooks(String sorgIds, String dchanId, String divsnId,
                                                    String prodLineCode, String familyCodes, String regionIds,
                                                    String custGroupIds, String vcpGrade, Boolean exactMatch) {
                                                    system.debug('exactMatch---'+exactMatch);
                                                    system.debug('2222'+vcpGrade);
        return getPriceBooks(COLON, sorgIds, dchanId, divsnId, prodLineCode, familyCodes, regionIds, custGroupIds, vcpGrade, exactMatch);
    }
    
    public static List<Price_Book__c> getPriceBooks(String delim, String sorgIds, String dchanId, String divsnId,
                                                    String prodLineCodes, String familyCodes, String regionIds,
                                                    String custGroupIds, String vcpGrade, Boolean exactMatch) {
                                                    system.debug('3333'+vcpGrade);
        List<Id> sorgIdList = sorgIds.split(delim);
        
        List<String> familyCodeList = familyCodes.split(delim);
        Set<String> familyCodeSet = new Set<String>();
        familyCodeSet.addAll(familyCodeList);
        
        List<String> prodLineCodeList = prodLineCodes.split(delim);
        Set<String> prodLineCodeSet = new Set<String>();
        prodLineCodeSet.addAll(prodLineCodeList);
        
        List<Id> regionIdList = regionIds.split(delim);
        List<Id> custGroupIdList = custGroupIds.split(delim);
        return getPriceBooks(sorgIdList, dchanId, divsnId, prodLineCodeSet, familyCodeSet,
                             regionIdList, custGroupIdList, vcpGrade,  exactMatch);
    }
    
    public static List<Price_Book__c> getPriceBooks(List<Id> sorgIdList, Id dchanId, Id divsnId,
                                                    Set<String> prodLineCodeSet, Set<String> familyCodeSet,
                                                    List<Id> regionIdList, List<Id> custGroupIdList, String vcpGrade,
                                                    Boolean exactMatch) {
                                                    system.debug('4444'+vcpGrade);
        List<Price_Book__c> pblist = getPriceBooks(sorgIdList, dchanId, divsnId, prodLineCodeSet, familyCodeSet,
                                                   regionIdList, custGroupIdList, vcpGrade);
                                                   system.debug('pblist@@'+pblist);
       
        if (pblist == null) {
            return null;
        }
        List<Price_Book__c> emlist = new List<Price_Book__c>(); // exact Match list
        List<Price_Book__c> pmlist = new List<Price_Book__c>(); // partial Match list
        getPriceBooks(pblist, emlist, pmlist, sorgIdList, prodLineCodeSet, familyCodeSet, regionIdList, custGroupIdList,vcpGrade);
        system.debug('5555'+vcpGrade);
        system.debug('emlist+++'+emlist);
        if (emlist.isEmpty()) {
            emlist = null;
        }
        if (pmlist.isEmpty()) {
            pmlist = null;
        }
        if (exactMatch) {
            return emlist;
        } else {
            return pmlist;
        }
    }
    
    public static List<Price_Book__c> getPriceBooks(List<Id> sorgIdList, Id dchanId, Id divsnId,
                                                    Set<String> prodLineCodeSet, Set<String> familyCodeSet,
                                                    List<Id> regionIdList, List<Id> custGroupIdList, String vcpGrade) {
                                                    system.debug('66666'+vcpGrade);
        Set<Id> dchanIdSet = new Set<Id>{dchanId}; Set<Id> divsnIdSet = new Set<Id>{divsnId};
        return getPriceBooks(sorgIdList, dchanIdSet, divsnIdSet, prodLineCodeSet, 
                             familyCodeSet, regionIdList, custGroupIdList, vcpGrade);
    }
    
    public static List<Price_Book__c> getPriceBooks(Set<String> sorgIdSet, Id dchanId, Id divsnId,
                                                    Set<String> prodLineCodeSet, Set<String> familyCodeSet,
                                                    Set<String> regionIdSet, Set<String> custGroupIdSet, String vcpGrade) {
                                                    system.debug('7777'+vcpGrade);
        List<Id> sorgIdList = stringSetToIdList(sorgIdSet);
        List<Id> regionIdList = stringSetToIdList(regionIdSet);
        List<Id> custGroupIdList = stringSetToIdList(custGroupIdSet);
        return getPriceBooks(sorgIdList, dchanId, divsnId, prodLineCodeSet, familyCodeSet, regionIdList, custGroupIdList, vcpGrade);
    }
    
    public static List<Price_Book__c> getPriceBooks(List<Id> salesOrgIds,
                                                    Set<Id> distChanIds,
                                                    Set<Id> divisionIds,
                                                    Set<String> prodLineCodes,
                                                    Set<String> familyCodes,
                                                    List<Id> regionIds,
                                                    List<Id> custGroupIds, String vcpGrade) {
                                                    system.debug('88888'+vcpGrade);
        
        Set<Id> pbIds;
        pbIds = PriceBookRegionFunctions.getPriceBookIdsForRegions(regionIds, ACTIVE_APPROVED);
        if (pbIds == null || pbIds.isEmpty()) {
            return null;
        }
        pbIds = PriceBookProductLineFunctions.getPriceBookIdsForProductLines(pbIds, prodLineCodes);
        if (pbIds == null || pbIds.isEmpty()) {
            return null;
        }
        pbIds = PriceBookFamilyFunctions.getPriceBookIdsForFamilies(pbIds, familyCodes);
        if (pbIds == null || pbIds.isEmpty()) {
            return null;
        }
        pbIds = PriceBookSalesOrgFunctions.getPriceBookIdsForSalesOrgs(pbIds, salesOrgIds);
        if (pbIds == null || pbIds.isEmpty()) {
            return null;
        }
        pbIds = PriceBookCustGroupFunctions.getPriceBookIdsForCustGroups(pbIds, custGroupIds);
        if (pbIds == null || pbIds.isEmpty()) {
            return null;
        }
        system.debug('pbIds111'+pbIds);

        List<Price_Book__c> pblist = getActivePriceBooks(pbIds, distChanIds, divisionIds, vcpGrade);
        system.debug('vcpGrade'+vcpGrade);
        if (pblist == null || pblist.isEmpty()) {return null;}
        return pblist;
        
    }
    
    private static List<Price_Book__c> getActivePriceBooks(Set<Id> pbIds, Set<Id> distChanIds, Set<Id> divisionIds, String vcpGrade) {
        Set<Id> aset = new Set<Id>();
        system.debug('pbIds pbIds : '+pbIds);
        list<Price_Book__c> pb1 = [select Id, Dist_Channel__c, Division__c, Record_Status__c, VCP_Grade__c 
                                   from Price_Book__c where Id in :pbIds];
              /* list<Price_Book__c> pb1 = [select Id, Dist_Channel__c, Division__c, Record_Status__c, VCP_Grade__c 
                                   from Price_Book__c where Id in :pbIds AND VCP_Grade__c = :'vcpGrade'];*/
                                           system.debug('pb1 '+pb1 );
        system.debug('99999'+vcpGrade);
        for (Price_Book__c pb : [select Id, Dist_Channel__c, Division__c, Record_Status__c, VCP_Grade__c 
                                   from Price_Book__c where Id in :pbIds]) {
            /* for (Price_Book__c pb : [select Id, Dist_Channel__c, Division__c, Record_Status__c, VCP_Grade__c 
                                   from Price_Book__c where Id in :pbIds AND VCP_Grade__c = :'vcpGrade']) {*/
            system.debug('pb'+pb);
            String rs = pb.Record_Status__c;
            if (rs == CANCELLED || rs == DRAFT || rs == EXPIRED) {
                continue;
            }
            system.debug('PricebookVcP'+pb.VCP_Grade__c);
            system.debug('vcpGrade set'+vcpGrade);
            if(pb.VCP_Grade__c == null)
                pb.VCP_Grade__c = 'None';
                
                system.debug('vcpGrade null'+pb.VCP_Grade__c);
          //if (distChanIds.contains(pb.Dist_Channel__c) && divisionIds.contains(pb.Division__c) && vcpGrade.contains(pb.VCP_Grade__c)) {
           if (distChanIds.contains(pb.Dist_Channel__c) && divisionIds.contains(pb.Division__c) && (pb.VCP_Grade__c != null && vcpGrade.contains(pb.VCP_Grade__c))) {
          //if (distChanIds.contains(pb.Dist_Channel__c)) { // commented to fix PB Overlap Issue
                if(pb.VCP_Grade__c == 'None')
                    pb.VCP_Grade__c = '';

                aset.add(pb.Id);
                system.debug('aset$$'+aset);
            }
        }
        if (aset.isEmpty()) {return null;}
        
        List<Price_Book__c> pbs = getPriceBooks(aset);
        
        system.debug('pbs--'+pbs);
        return pbs;
    }
    
    private static void getPriceBooks(List<Price_Book__c> pblist,
                                      List<Price_Book__c> emlist,
                                      List<Price_Book__c> pmlist,
                                      List<Id> salesOrgIds,
                                      Set<String> lset,
                                      Set<String> fset,
                                      List<Id> regionIds,
                                      List<Id> custGroupIds, String vcpGrade) {
                                      system.debug('pblist::'+pblist);
        Set<String> pbIds = getPriceBookIds(pblist);
        
        Set<String> sset = idListToStringSet(salesOrgIds);
        Set<String> rset = idListToStringSet(regionIds);
        Set<String> cset = idListToStringSet(custGroupIds);
        
        Map<String, Set<String>> smap = PriceBookSalesOrgFunctions.getPriceBookSalesOrgIdMap(pbIds);
        Map<String, Set<String>> lmap = PriceBookProductLineFunctions.getPriceBookProductLineCodeMap(pbIds);
        Map<String, Set<String>> fmap = PriceBookFamilyFunctions.getPriceBookFamilyCodeMap(pbIds);
        Map<String, Set<String>> rmap = PriceBookRegionFunctions.getPriceBookRegionIdMap(pbIds);
        Map<String, Set<String>> cmap = PriceBookCustGroupFunctions.getPriceBookCustomerGroupIdMap(pbIds);
        
        for (Price_Book__c pb : pblist) {
            Boolean sb = compareIdSets(pb.Id, smap, sset);
            Boolean lb = compareIdSets(pb.Id, lmap, lset);
            Boolean fb = compareIdSets(pb.Id, fmap, fset);
            Boolean rb = compareIdSets(pb.Id, rmap, rset);
            Boolean cb = compareIdSets(pb.Id, cmap, cset);
            Boolean pbv; 
            if(pb.VCP_Grade__c ==vcpGrade) {pbv=true;}else pbv =false;
            if (sb && fb && rb && cb && pbv) {
                emlist.add(pb);
                system.debug('emlist+add'+emlist);
            } else {
                pmlist.add(pb);
            }
        } 
    }
    
    public static Set<String> getPriceBookIds(List<Price_Book__c> pblist) {
        Set<String> pbIds = new Set<String>();
        if (pblist != null && !pblist.isEmpty()) {
            for (Price_Book__c pb : pblist) {pbIds.add(pb.Id);}
        }
        return pbIds;
    }
    
    private static Set<String> idListToStringSet(List<Id> alist) {
        Set<String> aset = new Set<String>();
        for (Id s : alist) {
            aset.add(s);
        }
        return aset;
    }
    
    private static List<Id> stringSetToIdList(Set<String> aset) {
        List<Id> alist = new List<Id>();
        for (String s : aset) {
            alist.add(s);
        }
        return alist;
    }
    
    private static Boolean compareIdSets(String pbId,
                                         Map<String, Set<String>> pmap,
                                         Set<String> aset) {
        if (pmap != null && pmap.containsKey(pbId)) {
            Set<String> bset = pmap.get(pbId);
            return compareIdSets(aset, bset);
        }
        return false;
    }
    
    private static Boolean compareIdSets(Set<String> aset, 
                                         Set<String> bset) {
        if (aset != null && bset != null && aset.size() >= bset.size()) {
            for (String s : bset) {
                if (!aset.contains(s)) {return false;}
            }
            debug('compareIdSets:'+aset+'\n'+bset);
            return true;
        }
        return false;
    }

    public static Integer getRelatedRecordsCount(Set<String> pbIds) {
        List<Price_Book__c> pblist = getPriceBooks(pbIds);
        return getRelatedRecordsCount(pblist);
    }
    
    

    public static Integer getRelatedRecordsCount(List<Price_Book__c> pblist) {
        Integer n = 1; List<Price_Book_Entry__c> elist; Set<Id> matIds = new Set<Id>();
        List<Price_Book_Entry_Scaled_Pricing__c> slist;
        String q1 = PriceBookEntryFunctions.SELECT_QRY_1 + ' where Price_Book__c = :pid', pid;
        for (Price_Book__c p : pblist) {
            if (p.Price_Book_Sales_Orgs__r      != null) {n += p.Price_Book_Sales_Orgs__r.size();}
            if (p.Price_Book_Product_Lines__r   != null) {n += p.Price_Book_Product_Lines__r.size();}
            if (p.Price_Book_Families__r        != null) {n += p.Price_Book_Families__r.size();}
            if (p.Price_Book_Regions__r         != null) {n += p.Price_Book_Regions__r.size();}
            if (p.Price_Book_Customer_Groups__r != null) {n += p.Price_Book_Customer_Groups__r.size();}
            pid = p.Id; elist =  Database.query(q1);
            if (elist == null || elist.isEmpty()) {continue;}
            for (Price_Book_Entry__c e : elist) {
                if (matIds.contains(e.Material_Sales_Data2__c)) {continue;}
                matIds.add(e.Material_Sales_Data2__c); n += 1;
                if (e.Price_Book_Entries_Scaled_Pricing__r != null) {
                    n += e.Price_Book_Entries_Scaled_Pricing__r.size();
                } 
            }
        }
        return n;
    }
    
}
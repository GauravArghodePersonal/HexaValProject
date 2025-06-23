global class PriceBookEntryFunctions {

    private static final Integer MAX_COUNT = 1000;
    
    public static final String DELIM = ':';
    public static final String ACTIVE = 'Active';
    public static final Set<String> ACTIVE_RECS = new Set<String>{ACTIVE};

    private static final String CUST_GRP_CODE   = 'CUST_GRP_CODE'; 
    private static final String DIST_CHAN_CODE  = 'DIST_CHAN_CODE'; 
    private static final String DIVISION_CODE   = 'DIVISION_CODE'; 
    private static final String PH5_FAMILY_CODE = 'PH5_FAMILY_CODE'; 
    private static final String PH6_SEGMNT_CODE = 'PH6_SEGMNT_CODE'; 
    private static final String REGION_CODE     = 'REGION_CODE'; 
    private static final String SALES_ORG_CODE  = 'SALES_ORG_CODE';
    
    public static final String SELECT_QRY_1 = 'select'
        + ' Id, Active__c, CurrencyIsoCode, Bulk_Minimum_Order_Quantity__c,'
        + ' General_Notes__c, GPPct__c, Material_Name__c, Material_Number__c,'
        + ' Material_Sales_Data2__c, Material_Sales_Data2__r.Dist_Channel_Code__c,'
        + ' Material_Sales_Data2__r.Material_Number__c, Material_Sales_Data2__r.Sales_Org_Code__c,'
        + ' Name, Plant_Notes__c, Price_Book__r.Id,Price_Book__r.VCP_Grade__c, Sales_Org_Desc__c, Selling_UOM__c,'
        + ' Uses_Scaled_Pricing__c, Volume_UOM__c,'
        + ' (select id, CurrencyIsoCode, Floor_Price__c, Maximum_Volume__c, Minimum_Volume__c,'
        + '  Name, Price_Book_Entry__c, Price_Book__c, Pricing_UOM__c, Selling_Price__c,'
        + '  Surcharge__c, Volume_UOM__c' 
        + '  from Price_Book_Entries_Scaled_Pricing__r order by Minimum_Volume__c)'
        + ' from Price_Book_Entry__c ';

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
        //System.debug(LoggingLevel.INFO, '>>>>>>>> ' + s);
    }
    
    public static List<Price_Book_Entry__c> getPriceBookEntries(String pbid) {
        return getPriceBookEntries(new Set<String>{pbid}); 
    }

    public static List<Price_Book_Entry__c> getPriceBookEntries(Set<String> pbids) {
        String q = SELECT_QRY_1 + 'where Price_Book__c in :pbids limit :MAX_COUNT';
        List<Price_Book_Entry__c> alist =  Database.query(q);
        if (alist == null || alist.isEmpty()) {return null;}
        return alist;
    }
    
    public static List<Price_Book_Entry__c> getPriceBookEntries(String pbId, Set<String> sorgCodes) {
        String q = SELECT_QRY_1 + 'where Price_Book__c = :pbId and ' + 
                   'Material_Sales_Data2__r.Sales_Org_Code__c in :sorgCodes';
        List<Price_Book_Entry__c> alist =  Database.query(q);
        if (alist == null || alist.isEmpty()) {return null;}
        return alist;
    }
    
    public static Map<String, Price_Book_Entry__c> getPriceBookEntries(Map<String, Pricing_Condition__c> pcMap,
                                                                       Map<Id, Material_Sales_Data2__c> matMap,
                                                                       Set<String> pbeIds) {
        String q = SELECT_QRY_1 + 'where Id in :pbeIds';
        List<Price_Book_Entry__c> pbes =  Database.query(q);
        if (pbes == null || pbes.isEmpty()) {return null;}
        Map<String, Price_Book_Entry__c> pbeMap = new Map<String, Price_Book_Entry__c>();
        for (Price_Book_Entry__c pbe : pbes) {pbeMap.put(pbe.Material_Sales_Data2__c, pbe);}
        return getPriceBookEntries(pcMap, matMap, pbeMap);
    }
                                                                        
    private static Map<String, Price_Book_Entry__c> getPriceBookEntries(Map<String, Pricing_Condition__c> pcMap,
                                                                        Map<Id, Material_Sales_Data2__c> matMap,
                                                                        Map<String, Price_Book_Entry__c> pbeMap) {
        if (pbeMap == null || pbeMap.isEmpty()) {return null;}
        //debug('pbeMap : ' + pbeMap);
        //debug('pcMap --: ' + pcMap);
        //debug('MatMap-- : ' + matMap);
        Map<String, Price_Book_Entry__c> pmap = new Map<String, Price_Book_Entry__c>();
        Pricing_Condition__c pc; Price_Book_Entry__c pbe; String key;
                                                                            system.debug('84pcMap :: '+pcMap);
        for (String k : pcMap.keySet()) {
            pc = pcMap.get(k); key = pc.Material2__c;
            //debug('key : ' + key);
            if (pbeMap.containsKey(key)) {
                pbe = pbeMap.get(key); pmap.put(k, pbe);
                //debug('pbe : ' + pbe);
            }
        }
        return pmap;
    }
    
    // Map<msd2id, Price_Book_Entry__c>
    private static Map<String, Price_Book_Entry__c> getPriceBookEntries(Set<Id> msd2ids,
                                                                        Set<String> pbids) {
        Map<String, Price_Book_Entry__c> pemap = new Map<String, Price_Book_Entry__c>();
        Id msd2id, pbid;
        String q = SELECT_QRY_1 + 'where Material_Sales_Data2__r.Id in :msd2ids and ' + 
                   'Price_Book__r.Id in :pbids';
        //debug('pbids : ' + pbids); debug('msd2ids : ' + msd2ids);
        try {
            for (Price_Book_Entry__c pe : Database.query(q)) {
                msd2id = pe.Material_Sales_Data2__r.Id;
                pbid = pe.Price_Book__r.Id;
                system.debug('pbid ---'+pbid );
                pemap.put(msd2id, pe);
                //debug('pemap : ' + msd2id + ' : ' + pe.Id);
            } 
        } catch(Exception e) {return null;}
        return pemap;
    }
    
    
    private static Map<String, Map<String, String>> getPricingConditionFields(Map<String, Pricing_Condition__c> pcMap,
                                                                              Map<Id, Account> accMap,
                                                                              Map<Id, Material_Sales_Data2__c> matMap) {
        //debug(''+pcMap+accMap+matMap);
        Map<String, Map<String, String>> pmap = new Map<String, Map<String, String>>();
        Id acid, mtid;
        Account acc;
        Material_Sales_Data2__c mat;
        Pricing_Condition__c pc;
        Map<String, String> fmap;
        for (String k : pcMap.keySet()) {
            pc = pcMap.get(k);
            acid = pc.Account__c;
            mtid = pc.Material2__c;
            fmap = new Map<String, String>();
            if (accMap.containsKey(acid)) {
                acc = accMap.get(acid);
                fmap.put(CUST_GRP_CODE,   acc.SAP_Customer_Group__c); 
                fmap.put(DIST_CHAN_CODE,  acc.SAP_DistChannel__c); 
                fmap.put(DIVISION_CODE,   acc.SAP_DivisionCode__c); 
                fmap.put(REGION_CODE,     acc.SAP_Country__c); 
                fmap.put(SALES_ORG_CODE,  acc.SAP_Sales_Org__c);
            }
            if (matMap.containsKey(mtid)) {
                mat = matMap.get(mtid);
                //fmap.put(PH5_FAMILY_CODE, mat.Product_Hierarchy__r.PH5__c); 
                //fmap.put(PH6_SEGMNT_CODE, mat.Product_Hierarchy__r.PH6__c);
                fmap.put(PH5_FAMILY_CODE, mat.Product_Hierarchy__r.PH1__c); 
                fmap.put(PH6_SEGMNT_CODE, mat.Product_Hierarchy__r.PH2__c);
            }
            if (!fmap.isEmpty()) { 
                pmap.put(k, fmap); 
            }
        }
        return pmap;
    }
    
    private static void getAccountFieldSets(Map<Id, Account> amap,
                                            Set<String> salesOrgCodes,
                                            Set<String> distChanCodes,
                                            Set<String> divisionCodes,
                                            Set<String> regionCodes,
                                            Set<String> custGroupCodes) {
        for (Account a : amap.values()) {
            salesOrgCodes.add(a.SAP_Sales_Org__c);
            distChanCodes.add(a.SAP_DistChannel__c);
            divisionCodes.add(a.SAP_DivisionCode__c);
            regionCodes.add(a.SAP_Country__c);
            custGroupCodes.add(a.SAP_Customer_Group__c);
         }
    }
      private static void getAccountFieldSets(Map<Id, Account> amap,
                                            Set<Id> accIds,
                                            Set<String> salesOrgCodes,
                                            Set<String> distChanCodes,
                                            Set<String> divisionCodes,
                                            Set<String> regionCodes,
                                            Set<String> custGroupCodes,
                                            Set<String> vcpGrade) {
        for (Account a : amap.values()) {
            salesOrgCodes.add(a.SAP_Sales_Org__c);
            distChanCodes.add(a.SAP_DistChannel__c);
            divisionCodes.add(a.SAP_DivisionCode__c);
            regionCodes.add(a.SAP_Country__c);
            custGroupCodes.add(a.SAP_Customer_Group__c);
            //vcpGrade=a.SAP_Customer_Price_Group_Desc__c;
            //if(a.SAP_Customer_Price_Group_Desc__c !=NULL && !string.Isblank(a.SAP_Customer_Price_Group_Desc__c))
            if(accIds.contains(a.Id)){
                vcpGrade.add(a.SAP_Customer_Price_Group_Desc__c);
            }
            //vcpGrade.add(a.SAP_Customer_Price_Group_Desc__c);
            
          }
    }
    
    private static void getMaterialFieldSets(Map<Id, Material_Sales_Data2__c> amap,
                                             Set<String> familyCodes,
                                             Set<String> prodLineCodes) {
        for (Material_Sales_Data2__c m : amap.values()) {
            //familyCodes.add(m.Product_Hierarchy__r.PH5__c);
            //prodLineCodes.add(m.Product_Hierarchy__r.PH6__c);
            familyCodes.add(m.Product_Hierarchy__r.PH1__c);
            prodLineCodes.add(m.Product_Hierarchy__r.PH2__c);
        }
    }
    
    public static void setPriceBookEntryFields(Pricing_Condition__c pc,
                                               Map<String, Price_Book_Entry__c> pbemap,
                                               Map<String, Double> ccrmap,
                                               String key) {
        //debug('setPriceBookEntryFields : 1 : ' + pc);
        Double currConvFac = 1.0;
                                                  
        if (pbemap != null && pbemap.containsKey(key)) {
            Double annualVolume = pc.Forecasted_Annual_Volume__c;
            Price_Book_Entry__c pbec = pbemap.get(key);
            if (!pbec.CurrencyIsoCode.equals(pc.CurrencyIsoCode)) {
                currConvFac = CurrencyConverter.getCurrencyConversionFactor(
                                  ccrmap, pbec.CurrencyIsoCode, pc.CurrencyIsoCode);
            }
            
            Price_Book_Entry pbe = new Price_Book_Entry(pbec, annualVolume);
            
            pc.Price_Book_Entry__c = pbe.pbEntryId;
            pc.Price_Book_Entry_Scaled_Pricing__c = pbe.pbEntryScaleId;
            pc.Floor_Price__c = pbe.floorPrice * currConvFac;
            pc.Market_Price__c = pbe.marketPrice * currConvFac;
            pc.Target_Gross_Profit_Percent__c = pbe.targetGPPct;
        }
    }

    // Map<PricingConditionKey, PriceBookEntry>
    public static Map<String, Price_Book_Entry__c> getPriceBookEntries(Map<String, Pricing_Condition__c> pcMap,
                                                                       Map<Id, Account> accMap,
                                                                       Map<Id, Material_Sales_Data2__c> matMap, Set<id> accIds) {
        //debug('getPriceBookEntries begins');
        Set<String> salesOrgCodes = new Set<String>();
        Set<String> distChanCodes = new Set<String>();
        Set<String> divisionCodes = new Set<String>();
        Set<String> prodLineCodes = new Set<String>();
        Set<String> familyCodes = new Set<String>();
        Set<String> regionCodes = new Set<String>();
        Set<String> custGroupCodes = new Set<String>();
        Set<String> vcpGrade= new Set<String>();
        //String vcpGrade;
        getAccountFieldSets(accMap, accIds, salesOrgCodes, distChanCodes, divisionCodes, regionCodes, custGroupCodes, vcpGrade);
        getMaterialFieldSets(matMap, familyCodes, prodLineCodes);
                                                                           
        Set<String> pbIds;
        //debug('before getActivePriceBooks');
        //debug(''+accMap+distChanCodes+divisionCodes+prodLineCodes);

        Map<String, Map<String, String>> pcfmap = getPricingConditionFields(pcMap, accMap, matMap);
		divisionCodes = new Set<String>();
		
        //Map<String, Price_Book__c> pmap = PriceBookFunctions.getActivePriceBooks(distChanCodes, 
          //                                                                       divisionCodes);
        
        Map<String, Price_Book__c> pmap=new  Map<String, Price_Book__c>();
        pmap = PriceBookFunctions.getActivePriceBooks(distChanCodes, divisionCodes,vcpGrade);
        
        if (pmap == null || pmap.isEmpty()) {return null;}
        pbids = pmap.keySet();

        List<Price_Book__c> pbs = pmap.values(); 
         //pbs = pmap.values(); 
        //debug('pbs.size = '+pbs.size());
        if (pbs.isEmpty()) {return null;}
        Map<String, Set<String>> amap;
        
        //debug('before getPriceBookSalesOrgCodeMap');
        amap = PriceBookSalesOrgFunctions.getPriceBookSalesOrgCodeMap(pbids);
        if (amap == null || amap.isEmpty()) {return null;}
                                                                           
        pbids = new Set<String>();
        pbs = getMatchingPriceBooks(SALES_ORG_CODE, amap, pcfmap, pbs, pbids);
                                                                           
        if (pbids.isEmpty()) {return null;}
        
        //debug('before getPriceBookProductLineCodeMap');
        amap = PriceBookProductLineFunctions.getPriceBookProductLineCodeMap(pbids);
                                                                           
        if (amap == null || amap.isEmpty()) {return null;}
        pbids = new Set<String>();
        pbs = getMatchingPriceBooks(PH6_SEGMNT_CODE, amap, pcfmap, pbs, pbids);
       
        if (pbids.isEmpty()) {return null;}

        //debug('before getPriceBookFamilyCodeMap');
        amap = PriceBookFamilyFunctions.getPriceBookFamilyCodeMap(pbids);
        if (amap == null || amap.isEmpty()) {return null;}
        pbids = new Set<String>();
        pbs = getMatchingPriceBooks(PH5_FAMILY_CODE, amap, pcfmap, pbs, pbids);
       
        if (pbids.isEmpty()) {return null;}

        //debug('before getPriceBookRegionCodeMap');
        amap = PriceBookRegionFunctions.getPriceBookRegionCodeMap(pbids);
        if (amap == null || amap.isEmpty()) {return null;}
        pbids = new Set<String>();
        pbs = getMatchingPriceBooks(REGION_CODE, amap, pcfmap, pbs, pbids);
       
        if (pbids.isEmpty()) {return null;}

        //debug('before getPriceBookCustomerGroupCodeMap');
        amap = PriceBookCustGroupFunctions.getPriceBookCustomerGroupCodeMap(pbids);
        if (amap == null || amap.isEmpty()) {return null;}
        pbids = new Set<String>();
        pbs = getMatchingPriceBooks(CUST_GRP_CODE, amap, pcfmap, pbs, pbids);
                                                                           
		
        if (pbids.isEmpty()) {return null;}
		
        Set<Id> msd2ids = matMap.keySet();
        Map<String, Price_Book_Entry__c> pbeMap = getPriceBookEntries(msd2ids, pbids);
        return getPriceBookEntries(pcMap, matMap, pbeMap);
    }
    
    private static List<Price_Book__c> getMatchingPriceBooks(String aname,
                                       Map<String, Set<String>> amap, 
                                       Map<String, Map<String, String>> pcfmap,
                                       List<Price_Book__c> pbs, Set<String> pbids) {
            
        Map<String, String> pcfs; String acode;
        //debug(aname + ' : pcfmap.size = '+pcfmap.size()+' : pbs.size = '+pbs.size());
       
        List<Price_Book__c> pbs2 = new List<Price_Book__c>();
        for (String k : pcfmap.keySet()) {
            pcfs = pcfmap.get(k);
            if (!pcfs.containsKey(aname)) {continue;}
            acode = pcfs.get(aname);
            //debug('acode = ' + acode);
           
            for (Price_Book__c pb : pbs) {
                if (isPriceBookMatched(pb, amap, acode)) {
                    //debug('Matched PB : '+pb);
                    
                    if (!pbids.contains(pb.Id)) {
                        pbids.add(pb.Id); pbs2.add(pb);
                      
                    }
                }
            }
        }
                                           
        return pbs2;
    }
    
    private static Boolean isPriceBookMatched(Price_Book__c pb,
                                              Map<String, Set<String>> amap,
                                              String acode) {
        //debug(''+pb+':'+amap+':'+acode);
        String pbid = pb.Id; Set<String> aset;
        if (amap.containsKey(pbid)) {
            aset = amap.get(pbid);
            //debug('aset = ' + aset);
            return aset.contains(acode);
        }
        return false;
    }
    
    private static Boolean isPriceBookMatched(Price_Book__c pb,
                                              Map<String, Set<String>> cmap,
                                              Map<String, Set<String>> lmap,
                                              Map<String, Set<String>> fmap,
                                              Map<String, Set<String>> rmap,
                                              Map<String, Set<String>> smap,
                                              Map<String, String> pcfields) {
        //debug(''+pb+cmap+fmap+rmap+smap+pcfields);
        String pbid = pb.Id;
        if (cmap.containsKey(pbid) &&
            lmap.containsKey(pbid) &&
            fmap.containsKey(pbid) &&
            rmap.containsKey(pbid) &&
            smap.containsKey(pbid)) {
            Set<String> cset = cmap.get(pbid);
            Set<String> lset = lmap.get(pbid);
            Set<String> fset = fmap.get(pbid);
            Set<String> rset = rmap.get(pbid);
            Set<String> sset = smap.get(pbid);
            String cgcode = pcfields.get(CUST_GRP_CODE); 
            String dccode = pcfields.get(DIST_CHAN_CODE); 
            String dvcode = pcfields.get(DIVISION_CODE); 
            String pfcode = pcfields.get(PH5_FAMILY_CODE); 
            String pscode = pcfields.get(PH6_SEGMNT_CODE); 
            String rgcode = pcfields.get(REGION_CODE); 
            String socode = pcfields.get(SALES_ORG_CODE);
            return (
                dccode == pb.Dist_Channel_Code__c &&  
                //dvcode == pb.Division_Code__c &&  
                cset.contains(cgcode) &&
                lset.contains(pscode) &&
                fset.contains(pfcode) &&
                rset.contains(rgcode) &&
                sset.contains(socode)
            );
        }
        return false;
    }
    
/*
 **************************************************
 webservice methods
 ************************************************** 
 */    

    webservice static Price_Book_Entry getPriceBookEntry(String accountId,
                                                         String materialId,
                                                         Double annualVolume) {
        Set<id> accIds = new Set<id>{accountId};
        Set<id> msd2ids = new Set<id>{materialId};

        Map<Id, Map<String, List<Id>>> partnerIds = Account_Partner_Functions.getPartnerIds(accIds);
        Map<Id, Account> accMap = Account_Partner_Functions.getAccountsMap(partnerIds);
        debug('partnerIds = ' + partnerIds);
        debug('accMap = ' + accMap);
        List<Material_Sales_Data2__c> msd2s = Material_Sales_Data_Functions.getMaterialSalesData2s(msd2ids);
        Map<Id, Material_Sales_Data2__c> msd2map = Material_Sales_Data_Functions.getMaterialSalesData2Map(msd2s);
        Pricing_Condition__c pc = new Pricing_Condition__c();
        pc.Account__c = accountId;
        system.debug('pc.Account__c++++'+pc.Account__c);
        pc.Material2__c = materialId;
        pc.Forecasted_Annual_Volume__c = annualVolume;
        String pcKey = 'pcKey';
        Map<String, Pricing_Condition__c> pcMap = new Map<String, Pricing_Condition__c>{pcKey => pc};
        
        debug('pcMap = ' + pcMap);
        debug('accMap = ' + accMap);
        debug('msd2map = ' + msd2map);
       
        
        Map<String, Price_Book_Entry__c> pbemap = getPriceBookEntries(pcMap, accMap, msd2map, accIds);
        system.debug('pbemappbemap : '+pbemap);
        Price_Book_Entry pbe = null;
        if (pbemap != null && pbemap.containsKey(pcKey)) {
            Price_Book_Entry__c pbec = pbemap.get(pcKey);
            pbe = new Price_Book_Entry(pbec, annualVolume);
        }
        return pbe; 
    }

/*
 **************************************************
 Test Methods are in PriceBookFunctions_Test class
 ************************************************** 
 */    

}
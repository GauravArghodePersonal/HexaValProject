public with sharing class CPI_Functions {

    private static final String DELIM = ':';
    private static final String SHIPTO = Account_Partner_Functions.ACC_TYPE_SHIPTO;
    private static final String SOLDTO = Account_Partner_Functions.ACC_TYPE_SOLDTO;
    private static final String CHERKY = Account_Partner_Functions.ACC_TYPE_CHERKY;

    private static final String CPI_REC_TYPE_SHIPTO = '1';
    private static final String CPI_REC_TYPE_SOLDTO = '2';
    private static final String CPI_REC_TYPE_CHERKY = '3';

    public class Parameter {
        public String cpiMapKey {get; set;}
        public Id accId {get; set;}
        public Id matId {get; set;}
        public String accType {get; set;}
    }

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>> ' + s);
    }

    public static void doBeforeUpsert(List<Customer_Product_Info__c> cpis) {
        for (Customer_Product_Info__c cpi : cpis) {
            cpi.Record_Key2__c = cpi.Sales_Org_Code__c + DELIM +
                                 cpi.Distribution_Channel_Code__c + DELIM +
                                 cpi.Customer_Number__c + DELIM +
                                 cpi.Material_Number__c;
            debug('cpi.Record_Key2__c = ' + cpi.Record_Key2__c);
        }
    }

    public static void doAfterUpsert(List<Customer_Product_Info__c> cpis) {
        Set<String> accNumbrs = new Set<String>(),
                    accKeyset = new Set<String>(),
                    cpiKeyset = new Set<String>(),
                    distChans = new Set<String>(),
                    matKeyset = new Set<String>(),
                    salesOrgs = new Set<String>();
        for (Customer_Product_Info__c cpi : cpis) {
            accNumbrs.add(cpi.Customer_Number__c);
            if (String.isNotBlank(cpi.ShipTo_Number__c)) {
                accNumbrs.add(cpi.ShipTo_Number__c);
            }
            distChans.add(cpi.Distribution_Channel_Code__c);
            matKeyset.add(cpi.Material_Number__c+cpi.Sales_Org_Code__c+cpi.Distribution_Channel_Code__c);
            salesOrgs.add(cpi.Sales_Org_Code__c);
        }
        Map<String, Set<String>> kmap = new Map<String, Set<String>>();
        Map<String, Account> amap = new Map<String, Account>();
        getAccountMaps(accNumbrs, salesOrgs, distChans, kmap, amap);
        Map<String, Id> mmap = getMaterialIds(matKeyset);
        List<Customer_Product_Info2__c> alist = new List<Customer_Product_Info2__c>();
        String akey, mkey, accId, matId; Account acc, shp;
        Customer_Product_Info2__c cpi2;
        for (Customer_Product_Info__c cpi : cpis) {
            akey = cpi.Customer_Number__c + DELIM + cpi.Sales_Org_Code__c + DELIM +
                   cpi.Distribution_Channel_Code__c;
            mkey = cpi.Material_Number__c + cpi.Sales_Org_Code__c +
                   cpi.Distribution_Channel_Code__c;
            if (!kmap.containsKey(akey)) {continue;}
            accKeyset = kmap.get(akey); matId = null;
            if (mmap.containsKey(mkey)) {matId = mmap.get(mkey);}
            for (String s : accKeyset) {
                if (!amap.containsKey(s)) {continue;}
                acc = amap.get(s); accId = acc.Id;
                cpi2 = new Customer_Product_Info2__c();
                cpi2.Key__c = cpi.Id + DELIM + accId;
                cpi2.CPI__c = cpi.Id;
                cpi2.Customer__c = accId;
                cpi2.Material__c = matId;
                if (String.isNotBlank(cpi.ShipTo_Number__c)) {
                    if (cpi.ShipTo_Number__c == cpi.Customer_Number__c) {
                        cpi2.ShipTo__c = accId;
                    } else {
                        akey = cpi.ShipTo_Number__c + acc.SAP_Sales_Org__c +
                            acc.SAP_DistChannel__c + acc.SAP_DivisionCode__c;
                        if (amap.containsKey(akey)) {
                            shp = amap.get(akey); cpi2.ShipTo__c = shp.Id;
                        }
                    }
                }
                alist.add(cpi2);
            }
        }
        if (alist.isEmpty()) {return;}
        try {upsert alist Key__c;} catch(Exception e) {}
    }

    private static Map<String, Id> getMaterialIds(Set<String> matKeyset) {
        Map<String, Id> amap = new Map<String, Id>();
        List<Material_Sales_Data2__c> alist = [select Id, Record_Key__c
                                                from Material_Sales_Data2__c
                                                where Record_Key__c in :matKeyset];
        if (alist == null || alist.isEmpty()) {return amap;}
        for (Material_Sales_Data2__c a : alist) {amap.put(a.Record_Key__c, a.Id);}
        return amap;
    }

    private static void getAccountMaps(Set<String> accNumbrs,
                                       Set<String> salesOrgs,
                                       Set<String> distChans,
                                       Map<String, Set<String>> kmap,
                                       Map<String, Account> amap) {
        List<Account> alist = [select Id, AccountNumber, Account_Number__c,
                                    SAP_Sales_Org__c, SAP_DistChannel__c,
                                    SAP_DivisionCode__c
                                from Account
                                where AccountNumber in :accNumbrs
                                  and SAP_Sales_Org__c in :salesOrgs
                                and SAP_DistChannel__c in :distChans
                                and Inactive_Account__c = false];
        if (alist == null || alist.isEmpty()) {return;}
        String k; Set<String> kset;
        for (Account a : alist) {
            k = a.AccountNumber + DELIM + a.SAP_Sales_Org__c + DELIM + a.SAP_DistChannel__c;
            if (kmap.containsKey(k)) {kset = kmap.get(k);} else {kset = new Set<String>();}
            kset.add(a.Account_Number__c); kmap.put(k, kset); amap.put(a.Account_Number__c, a);
        }
    }

    public static Map<String, Customer_Product_Info__c> getCPIMap(List<Parameter> plist,
                                                                  Map<Id, Map<String, List<Id>>> partnerMap,
                                                                  Map<Id, Account> accs,
                                                                  Map<Id, Material_Sales_Data2__c> mats) {
        Map<String, Customer_Product_Info__c> cpimap = new Map<String, Customer_Product_Info__c>();
        Map<String, List<Customer_Product_Info__c>> cpiListMap = getCPIListMap(plist, partnerMap, accs, mats);
        List<Customer_Product_Info__c> cpilist;
        Customer_Product_Info__c cpi;
        Id accid, matid, soldtoId, cherkyId;
        String acctype, matnum;
        Material_Sales_Data2__c msd2;
        for (Parameter p : plist) {
            //debug('Parameter : ' + p);
            cpi = null; cpilist = new List<Customer_Product_Info__c>();
            accid = p.accId;
            matid = p.matId;
            msd2 = mats.get(matid);
            matnum = msd2.Material_Number__c;
            acctype = p.accType;
            if (partnerMap.containsKey(accid)) {
                soldtoId = Account_Partner_Functions.getPartnerId(partnerMap, accid, SOLDTO);
                cherkyId = Account_Partner_Functions.getPartnerId(partnerMap, accid, CHERKY);
                if (acctype != null && acctype == SHIPTO) {
                    cpilist = getCPIList(matnum, accs, cpiListMap, CPI_REC_TYPE_SHIPTO, soldtoId, accid);
                }
                if (cpilist.isEmpty()) {
                    cpilist = getCPIList(matnum, accs, cpiListMap, CPI_REC_TYPE_SOLDTO, soldtoId, null);
                    if (cpilist.isEmpty()) {
                        cpilist = getCPIList(matnum, accs, cpiListMap, CPI_REC_TYPE_SHIPTO, soldtoId, null);
                        if (cpilist.isEmpty()) {
                            cpilist = getCPIList(matnum, accs, cpiListMap, CPI_REC_TYPE_CHERKY, cherkyId, null);
                        }
                    }
                }
                if (cpilist.size() > 1) {
                    for (Customer_Product_Info__c c : cpilist) {
                        if (c.Primary_Indicator__c == 'X') {cpi = c;}
                    }
                }
                if (cpi == null && !cpilist.isEmpty()) {cpi = cpilist[0];}
                if (cpi != null) {cpimap.put(p.cpiMapKey, cpi);}
            }
        }
        //debug('cpimap : ' + cpimap);
        return cpimap;
    }

    private static List<Customer_Product_Info__c> getCPIList(String matnum, Map<Id, Account> accs,
                                                             Map<String, List<Customer_Product_Info__c>> cpimap,
                                                             String cpitype, Id accId, Id shiptoId) {
        //debug('matnum : ' + matnum); debug('cpitype : ' + cpitype); debug('accId : ' + accId);
        List<Customer_Product_Info__c> cpilist = new List<Customer_Product_Info__c>();
        String custNum = '', salesorg = '', distchan = '', shiptoNum = '';
        Account acc;
        if (accId != null && accs.containsKey(accId)) {
            acc = accs.get(accId);
            custNum = acc.SAP_Customer_Number__c;
            salesorg = acc.SAP_Sales_Org__c;
            distchan = acc.SAP_DistChannel__c;
        }
        if (shiptoId != null && accs.containsKey(shiptoId)) {
            acc = accs.get(shiptoId);
            salesorg = acc.SAP_Sales_Org__c;
            distchan = acc.SAP_DistChannel__c;
            shiptoNum = acc.SAP_Customer_Number__c;
        }
        String cpikey = salesorg + DELIM + distchan + DELIM + custNum + DELIM + matnum + DELIM + cpitype;
        debug('cpikey : ' + cpikey);
        if (cpimap.containsKey(cpikey)) {
            List<Customer_Product_Info__c> tmplist = cpimap.get(cpikey);
            if (shiptoId != null) {
                for (Customer_Product_Info__c c : tmplist) {
                    if (shiptoNum == c.ShipTo_Number__c) {cpilist.add(c);}
                }
            } else {cpilist.addAll(tmplist);}
        }
        return cpilist;
    }

    private static Map<String, List<Customer_Product_Info__c>> getCPIListMap(List<Parameter> plist,
                                                                             Map<Id, Map<String, List<Id>>> partnerMap,
                                                                             Map<Id, Account> accs,
                                                                             Map<Id, Material_Sales_Data2__c> mats) {
        Map<String, List<Customer_Product_Info__c>> cpimap = new Map<String, List<Customer_Product_Info__c>>();
        Set<String> recordKey2s = getRecordKey2s(plist, partnerMap, accs, mats);
        List<Customer_Product_Info__c> cpilist; String key;
        for (Customer_Product_Info__c cpi : [Select Id, Name,
                                                    CPI_Record_Type__c,
                                                    Customer_Material_Number__c,
                                                    Customer_Number__c,
                                                    Distribution_Channel_Code__c,
                                                    INCO_Terms1__c, Item_Usage__c,
                                                    Material_Number__c,
                                                    Plant_Code__c, Primary_Indicator__c,
                                                    Sales_Org_Code__c,
                                                    ShipTo_Number__c
                                               from Customer_Product_Info__c
                                              where Deletion_Indicator__c != 'X'
                                                and Record_Key2__c in :recordKey2s
                                            ]) {
            key = cpi.Sales_Org_Code__c + DELIM +
                  cpi.Distribution_Channel_Code__c + DELIM +
                  cpi.Customer_Number__c + DELIM +
                  cpi.Material_Number__c + DELIM +
                  cpi.CPI_Record_Type__c;
            if (cpimap.containsKey(key)) {
                cpilist = cpimap.get(key);
            } else {
                cpilist = new List<Customer_Product_Info__c>();
            }
            cpilist.add(cpi);
            cpimap.put(key, cpilist);
        }
        //debug('cpimap : ' + cpimap);
        return cpimap;
    }

    private static Set<String> getRecordKey2s(List<Parameter> plist,
                                              Map<Id, Map<String, List<Id>>> partnerMap,
                                              Map<Id, Account> accs,
                                              Map<Id, Material_Sales_Data2__c> mats) {
        Account acc;
        Id accid, matid;
        String matnum;
        Material_Sales_Data2__c msd2;
        Set<Id> partnerIds;
        Set<String> recordKey2s = new Set<String>();
        for (Parameter p : plist) {
            accid = p.accId;
            matid = p.matId;
            msd2 = mats.get(matid);
            matnum = msd2.Material_Number__c;
            partnerIds = getPartnerIds(partnerMap, accid);
            setRecordKey2s(partnerIds, accs, matnum, recordKey2s);
        }
        debug('<<<<<<< '+recordKey2s);
        return recordKey2s;
    }

    private static Set<Id> getPartnerIds(Map<Id, Map<String, List<Id>>> partnerMap, Id accid) {
        Set<Id> pset = new Set<Id>();
        if (partnerMap.containsKey(accid)) {
            Map<String, List<Id>> pmap = partnerMap.get(accid);
            for (List<Id> plist : pmap.values()) {
                pset.addAll(plist);
            }
        }
        return pset;
    }

    private static void setRecordKey2s(Set<Id> partnerIds, Map<Id, Account> accs,
                                       String matnum, Set<String> recordKey2s) {
        Account acc;
        String custNum, salesorg, distchan;
        for (Id accid : partnerIds) {
            if (accs.containsKey(accid)) {
                acc = accs.get(accid);
                custNum = acc.SAP_Customer_Number__c;
                salesorg = acc.SAP_Sales_Org__c;
                distchan = acc.SAP_DistChannel__c;
                recordKey2s.add(salesorg + DELIM + distchan + DELIM + custNum + DELIM + matnum);
            }
        }
    }

}
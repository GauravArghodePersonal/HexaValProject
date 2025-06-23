public class Sales_Plan_Functions {
    
    public static final Integer PAGE_SIZE = 200;
    public static final String ACTIVE = 'Active';
    public static final String CLOSED = 'Closed';
    public static final String DRAFT = 'Draft';
    public static final String DELIM = '-';

    public static final String FISCAL_PERIOD = Rolling_Product_Sales_Info.START_FP;

    public static final String PRODUCT_PLAN_QRY1 = ''
        + 'select Id, Name, Account__c, Cloned_From__c, FiscalPeriod__c, Material__c,'
        + '       Material__r.Name, Material__r.Material_Number__c,'
        + '       Material_General_Data2__c, Material_General_Data2__r.Material_Number__c,' 
        + '       Record_Status__c, RecordType__c, Sales_Volume__c, Sales_Volume_UOM__c'
        + '  from Product_Sales_Plan__c';

    public static final String PRODUCT_PLAN_OB1 = ' order by '
        + 'Material__r.Name, Material__r.Material_Number__c';
    
    public static void debug(String s) {
        DebugLog_Functions.info('Sales_Plan_Functions : ' + s);
    }
    
    public static void doBeforeUpsert(List<Account_Sales_Plan__c> alist) {
        Set<String> aset = new Set<String>();
        for (Account_Sales_Plan__c a : alist) {
            a.Name = a.Key__c;
            if (!String.isBlank(a.Account_Number__c)) {
                aset.add(getAccKey(a.Account_Number__c, a));
            }
            if (!String.isBlank(a.SoldTo_Number__c)) {
                aset.add(getAccKey(a.SoldTo_Number__c, a));
            }
        }
        Map<String, Account> amap = getAccountMap(aset);
        String k; Account acc;
        for (Account_Sales_Plan__c a : alist) {
            if (!String.isBlank(a.Account_Number__c)) {
                k = getAccKey(a.Account_Number__c, a);
                if (amap.containsKey(k)) {  
                    acc = amap.get(k); a.Account__c = acc.Id;
                }
            }
            if (!String.isBlank(a.SoldTo_Number__c)) {
                k = getAccKey(a.SoldTo_Number__c, a);
                if (amap.containsKey(k)) {  
                    acc = amap.get(k); a.SoldTo__c = acc.Id;
                }
            }
        }
    }
    
    public static void doBeforeUpsert(List<Product_Sales_Plan__c> alist) {
        Set<String> aset = new Set<String>(), mset = new Set<String>(),
                    nset = new Set<String>();
        for (Product_Sales_Plan__c a : alist) {
            a.Name = a.Key__c;
            if (!String.isBlank(a.Material_Number__c)) {
                mset.add(getMatKey(a)); nset.add(a.Material_Number__c);
            }
            if (!String.isBlank(a.Account_Number__c)) {
                aset.add(getAccKey(a.Account_Number__c, a));
            }
            if (!String.isBlank(a.SoldTo_Number__c)) {
                aset.add(getAccKey(a.SoldTo_Number__c, a));
            }
        }
        Map<String, Account> amap = getAccountMap(aset);
        Map<String, Material_Sales_Data2__c> mmap = getMaterialMap(mset);
        Map<String, Material_General_Data2__c> nmap = getMGD2Map(nset);
        String k; Account acc; Material_Sales_Data2__c mat;
        Material_General_Data2__c mgd2;
        for (Product_Sales_Plan__c a : alist) {
            if (!String.isBlank(a.Account_Number__c)) {
                k = getAccKey(a.Account_Number__c, a);
                if (amap.containsKey(k)) {  
                    acc = amap.get(k); a.Account__c = acc.Id;
                }
            }
            if (!String.isBlank(a.SoldTo_Number__c)) {
                k = getAccKey(a.SoldTo_Number__c, a);
                if (amap.containsKey(k)) {  
                    acc = amap.get(k); a.SoldTo__c = acc.Id;
                }
            }
            if (!String.isBlank(a.Material_Number__c)) {
                k = getMatKey(a);
                if (mmap.containsKey(k)) {  
                    mat = mmap.get(k); a.Material__c = mat.Id;
                }
                if (nmap.containsKey(a.Material_Number__c)) {
                    mgd2 = nmap.get(a.Material_Number__c);
                    a.Material_General_Data2__c = mgd2.Id;
                }
            }
        }
    }
    
    private static String getString(String s) {
        return s != null ? s : '';
    }
    
    private static String getAccKey(String accNum, Account_Sales_Plan__c a) {
        String s = accNum;
        s += getString(a.SalesOrg_Code__c);
        s += getString(a.DistChan_Code__c);
        s += getString(a.Division_Code__c);
        return s;
    }

    private static String getAccKey(String accNum, Product_Sales_Plan__c a) {
        String s = accNum;
        s += getString(a.SalesOrg_Code__c);
        s += getString(a.DistChan_Code__c);
        s += getString(a.Division_Code__c);
        return s;
    }

    private static String getMatKey(Product_Sales_Plan__c a) {
        String s = '';
        s += getString(a.Material_Number__c);
        s += getString(a.SalesOrg_Code__c);
        s += getString(a.DistChan_Code__c);
        return s;
    }
    
    private static Map<String, Account> getAccountMap(Set<String> aset) {
        Map<String, Account> amap = new Map<String, Account>();
        if (aset.isEmpty()) {return amap;}
        List<Account> alist = [
            select Id, Account_Number__c from Account 
             where Account_Number__c in :aset];
        if (alist == null || alist.isEmpty()) {return amap;}
        for (Account a : alist) {amap.put(a.Account_Number__c, a);} 
        return amap;
    }

    private static Map<String, Material_Sales_Data2__c> getMaterialMap(Set<String> aset) {
        Map<String, Material_Sales_Data2__c> amap = new Map<String, Material_Sales_Data2__c>();
        if (aset.isEmpty()) {return amap;}
        List<Material_Sales_Data2__c> alist = [
            select Id, Record_Key__c from Material_Sales_Data2__c 
             where Record_Key__c in :aset];
        if (alist == null || alist.isEmpty()) {return amap;}
        for (Material_Sales_Data2__c a : alist) {amap.put(a.Record_Key__c, a);} 
        return amap;
    }

    private static Map<String, Material_General_Data2__c> getMGD2Map(Set<String> aset) {
        Map<String, Material_General_Data2__c> amap = new 
        Map<String, Material_General_Data2__c>();
        if (aset.isEmpty()) {return amap;}
        List<Material_General_Data2__c> alist = [
            select Id, Material_Number__c from Material_General_Data2__c 
             where Material_Number__c in :aset];
        if (alist == null || alist.isEmpty()) {return amap;}
        for (Material_General_Data2__c a : alist) {amap.put(a.Material_Number__c, a);} 
        return amap;
    }
    
    private static String getAccountType(String accountId) {
    	String s = '';
    	Rolling_Product_Sales_Info__c rpsi = Rolling_Product_Sales_Info.getRPSI(accountId);
    	if (rpsi != null && rpsi.Account_Type__c != null) {s = rpsi.Account_Type__c;}
    	return s;
    }

    public static PaginationController getProductPlansPC(String accountId) {
        return getProductPlansPC(accountId, null, PAGE_SIZE);
    }
    
    public static PaginationController getProductPlansPC(String accountId, String matName) {
        return getProductPlansPC(accountId, matName, PAGE_SIZE);
    }
    
    public static PaginationController getProductPlansPC(String accountId, String matName, 
                                                         Integer pageSize) {
        return getProductPlansPC(accountId, matName, pageSize, ACTIVE);
    }
    
    public static PaginationController getProductPlansPC(String accountId, String matName, 
                                                         Integer pageSize, String recStatus) {
        return getProductPlansPC(accountId, matName, pageSize, recStatus, PRODUCT_PLAN_OB1);
    }

    public static PaginationController getProductPlansPC(String accountId, String matName, 
                                                         Integer pageSize, String recStatus, 
                                                         String orderBy) {
        String accountType = getAccountType(accountId);
        String qry = PRODUCT_PLAN_QRY1;
        //qry += ' where Record_Status__c = \'' + recStatus + '\''; 
        qry += ' where RecordType__c = \'FYF\''; 
        qry += '   and FiscalPeriod__c = \'' + FISCAL_PERIOD + '\'';
        qry += '   and Account__c = \'' + accountId + '\'';
        if (String.isNotBlank(accountType)) {
            qry += ' and CustomerType__c = \'' + accountType + '\'';
        }
        if (String.isNotBlank(matName)) {
            qry += ' and Material__r.Name like \'%' + matName + '%\'';
        }
        qry += orderBy; 
        debug('getProductPlansPC : qry = ' + qry);
        Database.Querylocator ql; PaginationController pc = null;
        try {
            ql = Database.getQueryLocator(qry);
            pc = new PaginationController(ql, pageSize);
        } catch(Exception e) {debug('getProductPlansPC : ' + e.getMessage());}
        return pc;
    }

    public static Boolean isActive(Product_Sales_Plan__c a) {
        return (a.Record_Status__c != null && a.Record_Status__c == ACTIVE);
    }
    
    public static Boolean isClosed(Product_Sales_Plan__c a) {
        return (a.Record_Status__c != null && a.Record_Status__c == CLOSED);
    }
    
    public static Boolean isDraft(Product_Sales_Plan__c a) {
        return (a.Record_Status__c != null && a.Record_Status__c == DRAFT);
    }
    
    public static void activateNextYearProdPlans(List<Product_Sales_Plan__c> tlist) {
        List<Product_Sales_Plan__c> clist = new List<Product_Sales_Plan__c>(); Boolean b;
        for (Product_Sales_Plan__c t : tlist) {
            if (isClosed(t)) {continue;} b = false;
            if (isActive(t)){t.FiscalPeriod__c = 'PFYTD'; t.Record_Status__c = CLOSED; b = true;}
            if (isDraft(t)) {t.FiscalPeriod__c = 'FYTD';  t.Record_Status__c = ACTIVE; b = true;}
            if (b) {clist.add(t);}
        }
        debug('activateNextYearProdPlans : clist = ' + clist);
        //if (!clist.isEmpty()) {update clist;}
    }
    
    public static List<Product_Sales_Plan__c> createNextYearProdPlans(List<Product_Sales_Plan__c> tlist) {
        List<Product_Sales_Plan__c> dlist = new List<Product_Sales_Plan__c>();
        /*
        List<Product_Sales_Plan__c> clist = getProdPlansToClose(tlist);
        if (clist.isEmpty()) {return dlist;}
        dlist = getClonedProdPlans(clist);
        for (Product_Sales_Plan__c t : dlist) {
            t.Sales_Volume_CY__c = 0; t.Sales_Volume_UOM_CY__c = null;
            if (t.Sales_Volume_NY__c != null) {t.Sales_Volume_CY__c = t.Sales_Volume_NY__c;}
            if (t.Sales_Volume_UOM_NY__c != null) {t.Sales_Volume_UOM_CY__c = t.Sales_Volume_UOM_NY__c;}
            t.Sales_Volume_NY__c = 0; t.Sales_Volume_UOM_NY__c = null; t.Record_Status__c = DRAFT;
            t.FiscalPeriod__c = 'NYTD';
        }
        insert dlist; debug('createNextYearProdPlans : dlist = ' + dlist);
        */
        return dlist;
    }
    
    private static List<Product_Sales_Plan__c> getClonedProdPlans(List<Product_Sales_Plan__c> tlist) {
        List<Product_Sales_Plan__c> clist = tlist.deepClone(true);
        for (Product_Sales_Plan__c c : clist) {c.Cloned_From__c = c.Id;}
        clist = clist.deepClone(false);
        return clist;
    }

    private static List<Product_Sales_Plan__c> getProdPlansToClose(List<Product_Sales_Plan__c> tlist) {
        List<Product_Sales_Plan__c> clist = new List<Product_Sales_Plan__c>(), rlist;
        debug('getProdPlansToClose : tlist = ' + tlist);
        for (Product_Sales_Plan__c t : tlist) {
            if (isActive(t)) {clist.add(t);}
        }
        debug('getProdPlansToClose : clist = ' + clist);
        return clist;
    } 
        
}
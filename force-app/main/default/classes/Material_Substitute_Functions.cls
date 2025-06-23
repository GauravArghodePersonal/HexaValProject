public class Material_Substitute_Functions {

    private static void debug(String s) {System.debug(LoggingLevel.INFO, s);}

    private static void getMatSubsts(Set<String> keys, List<Material_Substitution__c> mlist, Set<String> mset) {
        for (Material_Substitution__c a : [
            select Condition_Record_Number__c, Deleted__c, Substitute_Material__c
              from Material_Substitution__c
             where Condition_Record_Number__c in :keys]) {
            if (a.Deleted__c) {continue;}
            mlist.add(a); mset.add(a.Substitute_Material__c);
        }
    }

    private static Map<String, Material_General_Data2__c> getMatMap(Set<String> matNums) {
        Map<String, Material_General_Data2__c> amap = new Map<String, Material_General_Data2__c>();
        for (Material_General_Data2__c a : [
            select Material_Number__c, Material_Description__c
            from Material_General_Data2__c
            where Material_Number__c in :matNums]) {amap.put(a.Material_Number__c, a);}
        return amap;
    }

    private static Map<String, Material_General_Data2__c> getMatSubstMap(Map<String, String> cmap) {
        Map<String, Material_General_Data2__c> amap = new Map<String, Material_General_Data2__c>();
        if (cmap.isEmpty()) {return amap;}
        List<Material_Substitution__c> mlist = new List<Material_Substitution__c>(); Set<String> mset = new Set<String>();
        getMatSubsts(cmap.keySet(), mlist, mset);
        if (mset.isEmpty()) {return amap;}
        Map<String, Material_General_Data2__c> mmap = getMatMap(mset);
        for (Material_Substitution__c m : mlist) {
            if (cmap.containsKey(m.Condition_Record_Number__c) && mmap.containsKey(m.Substitute_Material__c)) {
                amap.put(cmap.get(m.Condition_Record_Number__c), mmap.get(m.Substitute_Material__c));
            }
        }
        return amap;
    }

    private static Map<String, Material_General_Data2__c> getMatSubstShipMap(Set<String> matNums, String shipToNum) {
        Map<String, Material_General_Data2__c> amap = new Map<String, Material_General_Data2__c>();
        if (matNums == null || matNums.isEmpty() || String.isBlank(shipToNum)) {return amap;}
        Map<String, String> cmap = new Map<String, String>(); Date tdate = Date.today();
        for (Material_Determination_ShipTo__c a : [
            select Condition_Record_Number__c, Material_Number__c, Shipto_Party__c
            from Material_Determination_ShipTo__c
            where Material_Number__c in :matNums and Shipto_Party__c = :shipToNum
              and Deleted__c = false and Validity_End_Date__c >= :tdate]) {
            cmap.put(a.Condition_Record_Number__c, a.Material_Number__c);
        }
        return getMatSubstMap(cmap);
    }

    private static Map<String, Material_General_Data2__c> getMatSubstSoldMap(Set<String> matNums, String soldToNum) {
        Map<String, Material_General_Data2__c> amap = new Map<String, Material_General_Data2__c>();
        if (matNums == null || matNums.isEmpty() || String.isBlank(soldToNum)) {return amap;}
        Map<String, String> cmap = new Map<String, String>(); Date tdate = Date.today();
        for (Material_Determination_SoldTo__c a : [
            select Condition_Record_Number__c, Material_Number__c, Soldto_Party__c
              from Material_Determination_SoldTo__c
             where Material_Number__c in :matNums and Soldto_Party__c = :soldToNum
               and Deleted__c = false and Validity_End_Date__c >= :tdate]) {
            cmap.put(a.Condition_Record_Number__c, a.Material_Number__c);
        }
        return getMatSubstMap(cmap);
    }

    private static Map<String, Material_General_Data2__c> getMatSubstPlntMap(Set<String> matNums, Set<String> plntCodes) {
        Map<String, Material_General_Data2__c> amap = new Map<String, Material_General_Data2__c>();
        if (matNums == null || matNums.isEmpty() || plntCodes == null || plntCodes.isEmpty()) {return amap;}
        Map<String, String> cmap = new Map<String, String>(); Date tdate = Date.today();
        for (Material_Determination_Plant__c a : [
            select Condition_Record_Number__c, Material_Number__c, Plant_Code__c
              from Material_Determination_Plant__c
             where Material_Number__c in :matNums and Plant_Code__c in :plntCodes
               and Deleted__c = false and Validity_End_Date__c >= :tdate]) {
            cmap.put(a.Condition_Record_Number__c, a.Material_Number__c);
        }
        return getMatSubstMap(cmap);
    }

    public static Map<String, Material_General_Data2__c> getMatSubsts(String shipToNum, String soldToNum,
                                                                      Set<String> matNums, Set<String> plntCodes) {
        Map<String, Material_General_Data2__c> amap = getMatSubstShipMap(matNums, shipToNum); debug('amap : ' + amap);
        if (String.isBlank(soldToNum)) {return amap;}
        Map<String, Material_General_Data2__c> bmap = getMatSubstSoldMap(matNums, soldToNum); debug('bmap : ' + bmap);
        Map<String, Material_General_Data2__c> cmap = getMatSubstPlntMap(matNums, plntCodes); debug('cmap : ' + cmap);
        Map<String, Material_General_Data2__c> dmap = new Map<String, Material_General_Data2__c>();
        for (String s : matNums) {
            if (amap.containsKey(s)) {dmap.put(s, amap.get(s));} else
            if (bmap.containsKey(s)) {dmap.put(s, bmap.get(s));} else
            if (cmap.containsKey(s)) {dmap.put(s, cmap.get(s));}
        }
        debug('dmap : ' + dmap);
        return dmap;
    }

}
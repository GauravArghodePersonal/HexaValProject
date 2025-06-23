public with sharing class Material_Plant_Functions {
    
    private static String className = 'Material_Plant_Functions';
    
    private static String KEY_MNUM = 'KEY_MNUM';
    private static String KEY_SORG = 'KEY_SORG';
    private static String KEY_PLNT = 'KEY_PLNT';
    
    private static Map<String, List<String>> sapgids = null;
    
    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>>>>>>> ' + s);
    }
    
    public static void upsert_Material_Plant2(Material_Plant__c[] mpa) {
        List<Material_Plant2__c> alist = getMaterial_Plant2(mpa);
        if (alist.isEmpty()) {
            return;
        }
        upsert_Material_Plant2(alist);
    }
    
    public static void upsert_Material_Plant2(List<Material_Plant2__c> alist) {
        List<Database.Upsertresult> ur =  new List<Database.Upsertresult>();
        try {
            setCOGS(alist);
            ur = Database.upsert(alist, Material_Plant2__c.Record_Key__c, false);
        } catch(DmlException de) {
            System.debug(de.getMessage());
        } finally {
            //DebugLog_Functions.logUpsertErrors(className, 'upsert_Material_Plant2', ur);
        }
    }
    
    private static List<Material_Plant2__c> getMaterial_Plant2(Material_Plant__c[] mpa) {
        Map<String, Set<String>> fieldValues = getFieldValues(mpa);
        Set<String> plants = fieldValues.get(KEY_PLNT);
        Map<String, String> plantSalesOrgs = getPlantSalesOrgMap(plants);
        List<Material_Plant2__c> alist = new List<Material_Plant2__c>();
        for(Material_Plant__c mp : mpa) {
            Material_Plant2__c mp2 = getMaterial_Plant2(mp, plantSalesOrgs);
            if (mp2 != null) {
                alist.add(mp2);
            }
        }
        return alist;
    }
    
    public static Material_Plant2__c getMaterial_Plant2(Material_Plant__c mp,
                                                        Map<String, String> plantSalesOrgs) {
                                                            if (!plantSalesOrgs.containsKey(mp.Plant_Code__c)) {
                                                                return null;
                                                            }
                                                            Material_Plant2__c mp2 = new Material_Plant2__c();
                                                            String soc = plantSalesOrgs.get(mp.Plant_Code__c);
                                                            mp2.Material_Number__c = mp.Material_Number__c;
                                                            mp2.Material_Origin_Country__c = mp.Material_Origin_Country__c;
                                                            mp2.Plant_Code__c = mp.Plant_Code__c;
                                                            mp2.SalesOrg_Code__c = soc;
                                                            mp2.Record_Key__c = mp.Material_Number__c + mp.Plant_Code__c + soc;
                                                            mp2.Deletion_Flag__c = mp.Deletion_Flag__c;
                                                            
                                                            //Code change on 16/2/2021 to add MRP Type
                                                            mp2.MRP_Type__c=mp.MRP_Type__c;
                                                            //Code change on19/4/2021 to add Procurement Type
                                                            mp2.Procurement_Type__c=mp.Procurement_Type__c;
                                                            
                                                            //07/18/2018 This Was commented for Loading data from MAterial PLant to Material Plant2 Objects. We will be data loading as per USer request. 
                                                            //26/05/2020 Uncommmented for Lead time display project
                                                            mp2.Delivery_Time_in_Days__c = mp.Delivery_Time_in_Days__c;
                                                            mp2.Lead_Time_in_Days__c = mp.Lead_Time_in_Days__c;
                                                            
                                                            Material_General_Data2__c mgd = new Material_General_Data2__c();
                                                            mgd.Material_Number__c = mp.Material_Number__c;
                                                            mp2.Material_General_Data__r = mgd;
                                                            
                                                            SAP_Plant__c sp = new SAP_Plant__c();
                                                            sp.Plant_Code__c = mp.Plant_Code__c;
                                                            mp2.SAP_Plant__r = sp;
                                                            
                                                            SAP_Sales_Org__c so = new SAP_Sales_Org__c();
                                                            so.Sales_Org_Code__c = soc;
                                                            mp2.SAP_Sales_Org__r = so;
                                                            
                                                            return mp2;
                                                        }
    
    private static Map<String, Set<String>> getFieldValues(Material_Plant__c[] mpa) {
        Map<String, Set<String>> amap = new Map<String, Set<String>>();
        Set<String> plants = new Set<String>();
        for(Material_Plant__c mp : mpa) {
            plants.add(mp.Plant_Code__c);
        }
        amap.put(KEY_PLNT, plants);
        return amap;
    }
    
    public static Map<String, String> getPlantSalesOrgMap(Set<String> vas) {
        Map<String, String> plantSalesOrgs = new Map<String, String>();
        for (List<SAP_Valuation_Area__c> psList : [select Company_Code__c,
                                                   Valuation_Area__c
                                                   from SAP_Valuation_Area__c
                                                   where Valuation_Area__c in :vas]) {
                                                       for(SAP_Valuation_Area__c ps : psList) {
                                                           String sorg = ps.Company_Code__c;
                                                           String pnum = ps.Valuation_Area__c;
                                                           if (sorg != null && sorg.trim().length() > 0) {
                                                               plantSalesOrgs.put(pnum, sorg);
                                                           }
                                                       }
                                                   }
        return plantSalesOrgs;
    }
    
    public static void createSharingRecords(Material_Plant2__c[] mp2a) {
        String accessLevel = 'Read';
        String rowCause = Schema.Material_Plant2__share.RowCause.SalesAreaGroup__c;
        List<Material_Plant2__share> mp2Shares = new List<Material_Plant2__share>();
        List<String> mp2ids = new List<String>();
        if (sapgids == null) {
            sapgids = Public_Group_Functions.getSalesAreaPublicGroupIds();
        }
        for(Material_Plant2__c mp2 : mp2a) {
            mp2ids.add(mp2.id);
            String so = mp2.SalesOrg_Code__c;
            List<String> groupids = sapgids.get(so);
            if (groupids == null) {
                continue;
            }
            for(String gid : groupids) {
                Material_Plant2__share share = getMp2share(mp2.id, gid,
                                                           accessLevel, rowCause);
                mp2Shares.add(share);
            }
        }
        deleteSharingRecords(mp2ids, accessLevel, rowCause);
        List<Database.Saveresult> sr = new List<Database.Saveresult>();
        try {
            sr = Database.insert(mp2Shares, false);
        } catch(DmlException de) {
            System.debug(de.getMessage());
        } finally {
            //DebugLog_Functions.logInsertErrors(className, 'createSharingRecords', sr);
        }
    }
    
    public static Material_Plant2__share getMp2share(String parentId,
                                                     String groupId,
                                                     String accessLevel,
                                                     String rowCause) {
                                                         Material_Plant2__share share = new Material_Plant2__share();
                                                         share.AccessLevel = accessLevel;
                                                         share.ParentId = parentId;
                                                         share.RowCause = rowCause;
                                                         share.UserOrGroupId = groupId;
                                                         return share;
                                                     }
    
    private static void deleteSharingRecords(List<String> parentIds,
                                             String accessLevel,
                                             String rowCause) {
                                                 List<Database.DeleteResult> dr = new List<Database.DeleteResult>();
                                                 String rowc = Schema.Material_Plant2__share.RowCause.SalesAreaGroup__c;
                                                 for(List<Material_Plant2__share> alist : [select id
                                                                                           from Material_Plant2__share
                                                                                           where ParentId in :parentIds
                                                                                           and AccessLevel = :accessLevel
                                                                                           and RowCause = :rowCause
                                                                                          ]){
                                                                                              try {
                                                                                                  dr = Database.delete(alist);
                                                                                              } catch(DmlException de) {
                                                                                                  System.debug(de.getMessage());
                                                                                              }
                                                                                          }
                                             }
    
    public static Map<String, Material_Plant2__c> getPlantsMap(List<String> matnums) {
        Set<Id> mgd2Ids  = Material_General_Data_Functions.getMaterialGeneralData2Ids(matnums);
        if (mgd2Ids == null || mgd2Ids.isEmpty()) {
            return null;
        }
        List<Material_Plant2__c> mp2a = getPlants(mgd2Ids);
        return getPlantsMap(mp2a);
    }
    
    private static Map<String, Material_Plant2__c> getPlantsMap(List<Material_Plant2__c> mp2a) {
        Map<String, Material_Plant2__c> amap = new Map<String, Material_Plant2__c>();
        if (mp2a == null || mp2a.isEmpty()) {
            return amap;
        }
        String recKey;
        for (Material_Plant2__c mp2 : mp2a) {
            recKey = mp2.Material_Number__c + mp2.Plant_Code__c;
            amap.put(recKey, mp2);
        }
        return amap;
    }
    
    public static Map<String, Material_Plant2__c> getPlantsMap(Id mgd2Id) {
        return getPlantsMap(new Set<Id>{mgd2Id}, null);
    }
    
    public static Map<String, Material_Plant2__c> getPlantsMap(Set<Id> mgd2Ids) {
        return getPlantsMap(mgd2Ids, null);
    }
    
    public static Map<String, Material_Plant2__c> getPlantsMap(Set<Id> mgd2Ids,
                                                               Set<id> plantIds) {
                                                                   List<Material_Plant2__c> mp2a = getPlants(mgd2Ids, plantIds);
                                                                   return getPlantsMap(mp2a);
                                                               }
    
    //Map<Material_Sales_Data2Id, List<Material_Plant2__c>>
    public static Map<Id, List<Material_Plant2__c>> getPlantsMap(List<Material_Sales_Data2__c> msd2a,
                                                                 Set<Id> mgd2Ids) {
                                                                     if (msd2a == null || msd2a.isEmpty() ||
                                                                         mgd2Ids == null || mgd2Ids.isEmpty()) {
                                                                             return null;
                                                                         }
                                                                     List<Material_Plant2__c> mp2a = getPlants(mgd2Ids);
                                                                     Map<Id, List<Material_Plant2__c>> gmap = getMaterialPlantMap(mp2a);
                                                                     Map<Id, List<Material_Plant2__c>> smap = new Map<Id, List<Material_Plant2__c>>();
                                                                     for (Material_Sales_Data2__c msd2 : msd2a) {
                                                                         Id msd2Id = msd2.Id;
                                                                         Id mgd2Id = msd2.Material_General_Data__c;
                                                                         if (gmap.containsKey(mgd2Id)) {
                                                                             List<Material_Plant2__c> glist = gmap.get(mgd2Id);
                                                                             List<Material_Plant2__c> slist = getPlants(msd2, glist);
                                                                             if (slist != null && !slist.isEmpty()) {
                                                                                 smap.put(msd2Id, slist);
                                                                             }
                                                                         }
                                                                     }
                                                                     return smap;
                                                                 }
    
    //Map<Material_General_Data2Id, List<Material_Plant2__c>>
    private static Map<Id, List<Material_Plant2__c>> getMaterialPlantMap(List<Material_Plant2__c> mp2a) {
        Map<Id, List<Material_Plant2__c>> amap = new Map<Id, List<Material_Plant2__c>>();
        Id mgd2Id;
        List<Material_Plant2__c> alist;
        for (Material_Plant2__c mp2 : mp2a) {
            mgd2Id = mp2.Material_General_Data__c;
            if (!amap.containsKey(mgd2Id)) {
                amap.put(mgd2Id, new List<Material_Plant2__c>());
            }
            alist = amap.get(mgd2Id);
            alist.add(mp2);
        }
        return amap;
    }
    
    public static List<Material_Plant2__c> getPlants(Material_Sales_Data2__c msd) {
        if (msd == null) {return null;}
         system.debug('00IIID'+msd.Material_General_Data__c);
        Id mgd2Id = msd.Material_General_Data__c;
        system.debug('Final test0'+mgd2Id);
          system.debug('Final test0'+msd);
        system.debug('Final test0'+msd.Id);
        List<Material_Plant2__c> mp2a = getPlants(mgd2Id);
        system.debug('Final test');
           system.debug('Final test'+msd);
        system.debug('Final test'+mp2a);
        return getPlants(msd, mp2a);
    }
    
    private static List<Material_Plant2__c> getPlants(Material_Sales_Data2__c msd,
                                                      List<Material_Plant2__c> mp2a) {
                                                          if (mp2a == null || mp2a.isEmpty()) {
                                                              return null;
                                                          }
                                                          List<Material_Plant2__c> plants = new List<Material_Plant2__c>();
                                                          Id mgd2Id = msd.Material_General_Data__c;
                                                          String salesOrg = msd.Sales_Org_Code__c;
                                                          for (Material_Plant2__c mp2 : mp2a) {
                                                              if (mp2.Material_General_Data__c == mgd2Id) {
                                                                  plants.add(mp2);
                                                              }
                                                          }
                                                          return plants;
                                                      }
    
    private static List<Material_Plant2__c> getPlants(Id mgd2Id) {
        if (mgd2Id == null) {
            return null;
        }
        return getPlants(new Set<Id>{mgd2Id});
    }
    
    private static List<Material_Plant2__c> getPlants(Set<Id> mgd2Ids) {
        if (mgd2Ids == null || mgd2Ids.isEmpty()) {
            return null;
        }
        List<Material_Plant2__c> plants = null;
        try {
            plants = [select Material_Number__c,
                      Material_Origin_Country__c,
                      Plant_Code__c,
                      SalesOrg_Code__c,
                      Record_Key__c,
                      Plant_Name__c,
                      Plant_Address__c,
                      SalesOrg_Desc__c,
                      Deletion_Flag__c,
                      COGS__c,
                      COGS_Currency__c,
                      COGS_String__c,
                      Delivery_Time_in_Days__c,
                      Lead_Time_in_Days__c,
                      Material_General_Data__c,
                      Required_Lead_Time__c,
                      SAP_Plant__c,
                      SAP_Sales_Org__c,
                      Third_Party_Plant__c,
                      MRP_Type__c
                      from Material_Plant2__c
                      where Material_General_Data__c in :mgd2Ids
                      order by SalesOrg_Desc__c, Plant_Name__c];
            System.debug('BB1TEST-->'+mgd2Ids);
            System.debug('BB1TEST Plants-->'+plants);
            setCOGS(plants);
            
        } catch(Exception e) {}
        return plants;
    }
    
    private static List<Material_Plant2__c> getPlants(Set<Id> mgd2Ids, Set<Id> plantIds) {
        debug('mgd2Ids : ' + mgd2Ids); debug('plantIds : ' + plantIds);
        if (mgd2Ids == null || mgd2Ids.isEmpty()) {return null;}
        if (plantIds == null || plantIds.isEmpty()) {return getPlants(mgd2Ids);}
        List<Material_Plant2__c> plants = null;
        try {
            //code change on 16/2/2021 to add MRP Type
            plants = [select Material_Number__c,
                      Material_Origin_Country__c,
                      Plant_Code__c,
                      SalesOrg_Code__c,
                      Record_Key__c,
                      Plant_Name__c,
                      Plant_Address__c,
                      SalesOrg_Desc__c,
                      Deletion_Flag__c,
                      COGS__c,
                      COGS_Currency__c,
                      COGS_String__c,
                      Delivery_Time_in_Days__c,
                      Lead_Time_in_Days__c,
                      Material_General_Data__c,
                      Required_Lead_Time__c,
                      SAP_Plant__c,
                      SAP_Sales_Org__c,
                      Third_Party_Plant__c,
                      MRP_Type__c
                      from Material_Plant2__c
                      where Material_General_Data__c in :mgd2Ids
                      and SAP_Plant__c in :plantIds
                      order by SalesOrg_Desc__c, Plant_Name__c]; 
            
            setCOGS(plants);
            
        } catch(Exception e) {}
        return plants;
    }
    //07/18/2018 This Was commented for Loading data from MAterial PLant to Material Plant2 Objects. We will be data loading as per USer request. 
    //26/05/2020 Uncommmented for Lead time display project New logic added
    private static void setRequiredLeadTime(Material_Plant2__c p) {
        Boolean b = SAP_Queries_Functions.isThirdPartyPlant(p.SalesOrg_Code__c, p.Plant_Code__c);
        system.debug('TETETET'+b);
        system.debug(p.Lead_Time_in_Days__c);
        system.debug(p.Delivery_Time_in_Days__c);
        p.Third_Party_Plant__c = b; p.Required_Lead_Time__c = null;
        /*  
if (b) {

if (p.Delivery_Time_in_Days__c != null &&
p.Delivery_Time_in_Days__c > 0){
//p.Required_Lead_Time__c = p.Delivery_Time_in_Days__c;
}
}
else {if (p.Lead_Time_in_Days__c != null &&
p.Lead_Time_in_Days__c > 0){p.Required_Lead_Time__c = p.Lead_Time_in_Days__c;}
}*/
        //26/05/2020 Lead time display project New logic added
        if (b) {
            if (p.Lead_Time_in_Days__c != null &&
                p.Lead_Time_in_Days__c > 0){
                    p.Required_Lead_Time__c = p.Lead_Time_in_Days__c;
                }
        }
        debug('Required_Lead_Time__c : ' + p.Required_Lead_Time__c + ' (' + p.Plant_Code__c + ')');
    }
    
    private static void setCOGS(List<Material_Plant2__c> plants) {
        List<String> recKeys = new List<String>();
        Map<String, Material_Plant2__c> amap = new Map<String, Material_Plant2__c>();
        for (Material_Plant2__c p : plants) {
            System.debug('Inside--> '+p.Plant_Name__c+p.Third_Party_Plant__c);
            // 07/18/2018 This Was commented for Loading data from MAterial PLant to Material Plant2 Objects. We will be data loading as per USer request.
            //26/05/2020 Uncommmented for Lead time display project
            setRequiredLeadTime(p);
            String recKey = p.Material_Number__c + p.Plant_Code__c;
            recKeys.add(recKey);
            amap.put(recKey, p);
        }
        if (recKeys.isEmpty()) {
            return;
        }
        List<Material_Valuation__c> mva = getMaterialValuations(recKeys);
        setCOGS(amap, mva);
    }
    
    private static void setCOGS(Map<String, Material_Plant2__c> amap,
                                List<Material_Valuation__c> mva) {
                                    if (mva == null || mva.isEmpty()) {
                                        return;
                                    }
                                    for (Material_Valuation__c mv : mva) {
                                        String recKey = mv.Material_Number__c + mv.Valuation_Area__c;
                                        if (amap.containsKey(recKey)) {
                                            Material_Plant2__c p = amap.get(recKey);
                                            p.COGS__c = getCOGS(mv);
                                            p.COGS_Currency__c = mv.Currency_Key__c;
                                            p.COGS_String__c = getCogsString(p.COGS__c) + ' ' + mv.Currency_Key__c;
                                        }
                                    }
                                }
    
    private static List<Material_Valuation__c> getMaterialValuations(List<String> recKeys) {
        List<Material_Valuation__c> mva = [select Currency_Key__c,
                                           Material_Number__c,
                                           Price_Control_Indicator__c,
                                           Price_Unit__c,
                                           Standard_Price__c,
                                           Valuation_Area__c
                                           from Material_Valuation__c
                                           where Record_Key__c in :recKeys
                                          ];
        return mva;
    }
    
    private static Double getCOGS(Material_Valuation__c mv) {
        Double cogs = 0.0;
        if ('S'.equals(mv.Price_Control_Indicator__c) && mv.Price_Unit__c != 0) {
            cogs = mv.Standard_Price__c / mv.Price_Unit__c;
        }
        return cogs;
    }
    
    private static String getCogsString(Double d) {
        Decimal t = (d * 10000).round();
        Decimal r = t.divide(10000, 4);
        return r.toPlainString();
    }
    
    /*
**********************************************************
Test Methods are in Material_Plant_Functions_Test class
**********************************************************
*/
}
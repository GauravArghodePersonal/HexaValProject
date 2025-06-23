public with sharing class Product_Hierarchy_Functions {

/*static Map<String, String> DCHAN_PH1_MAP = new Map<String, String>{'10'=>'P',
                                                                       '20'=>'T',
                                                                       '30'=>'D',
                                                                       '40'=>'V',
                                                                       '50'=>'F',
                                                                       '99'=>'!'};*/

static Map<String, list<String>> DCHAN_PH1_MAP = new Map<String, list<String>>{'10'=>new list<string>{'P', 'W', 'I'},
                                                                       '20'=>new list<string>{'T'},
                                                                       '30'=>new list<string>{'D'},
                                                                       '40'=>new list<string>{'V'},
                                                                       '50'=>new list<string>{'F'},
                                                                       '99'=>new list<string>{'!'}};
                                                                     

    public static void upsert_Product_Hierarchy2(Set<String> pha) {
        if (pha == null || pha.isEmpty()) {
            return;
        }
        List<Product_Hierarchy2__c> alist = new List<Product_Hierarchy2__c>();
        Product_Hierarchy2__c obj;
        Product_Hierarchy__c ph1, ph2, ph3, ph4, ph5, ph6, ph7;
        for (String ph : pha) {
            obj = new Product_Hierarchy2__c();
            obj.Product_Hierarchy__c = ph;
            
            if (ph.length() > 0) {
                ph1 = new Product_Hierarchy__c();
                ph1.Product_Hierarchy_Code__c = ph.substring(0,1);
                obj.Product_Hierarchy1__r = ph1;
            }
        
            if (ph.length() > 2) {
                ph2 = new Product_Hierarchy__c();
                ph2.Product_Hierarchy_Code__c = ph.substring(0,3);
                obj.Product_Hierarchy2__r = ph2;
            }
        
            if (ph.length() > 5) {
                ph3 = new Product_Hierarchy__c();
                ph3.Product_Hierarchy_Code__c = ph.substring(0,6);
                obj.Product_Hierarchy3__r = ph3;
            }
        
            if (ph.length() > 8) {
                ph4 = new Product_Hierarchy__c();
                ph4.Product_Hierarchy_Code__c = ph.substring(0,9);
                obj.Product_Hierarchy4__r = ph4;
            }
        
            if (ph.length() > 11) {
                ph5 = new Product_Hierarchy__c();
                ph5.Product_Hierarchy_Code__c = ph.substring(0,12);
                obj.Product_Hierarchy5__r = ph5;
            }
        
            if (ph.length() > 14) {
                ph6 = new Product_Hierarchy__c();
                ph6.Product_Hierarchy_Code__c = ph.substring(0,15);
                obj.Product_Hierarchy6__r = ph6;
            }
        
            if (ph.length() > 17) {
                ph7 = new Product_Hierarchy__c();
                ph7.Product_Hierarchy_Code__c = ph;
                obj.Product_Hierarchy7__r = ph7;
            }
            
            alist.add(obj);
        }
        
        List<Database.Upsertresult> ur =  new List<Database.Upsertresult>();
        try {
            ur = Database.upsert(alist, Product_Hierarchy2__c.Product_Hierarchy__c, false);
        } catch(DmlException de) {
            System.debug(de.getMessage());
        } finally {
            //DebugLog_Functions.logUpsertErrors(className, 'upsert_Product_Hierarchy2', ur);
        }
    }
    
    public static Map<String, Product_Hierarchy2__c> getProdHerkyMap(Set<String> aset) {
        Map<String, Product_Hierarchy2__c> amap = new Map<String, Product_Hierarchy2__c>();
        for (List<Product_Hierarchy2__c> alist : [select Id,
                                                         PH1__c, PH1_Division__c,
                                                         PH2__c, PH2_Line__c,
                                                         PH3__c, PH3_Group__c,
                                                         PH4__c, PH4_Supplier__c,
                                                         PH5__c, PH5_Family__c,
                                                         PH6__c, PH6_Segment__c,
                                                         PH7__c, PH7_SubSegment__c, 
                                                         Product_Hierarchy__c
                                                    from Product_Hierarchy2__c
                                                   where Product_Hierarchy__c in :aset     
                                                 ]) {
            for (Product_Hierarchy2__c obj : alist) {
                amap.put(obj.Product_Hierarchy__c, obj);  
            }                                    
        }
        return amap;
    }
    
    public static Map<String, String> getProductSegmentMap(Set<String> ph6s) {
        Map<String, String> amap = new Map<String, String>();
        for (List<Product_Hierarchy2__c> alist : [select PH6__c, PH6_Segment__c
                                                    from Product_Hierarchy2__c
                                                   where PH6__c in :ph6s
                                                   order by PH6__c
                                                 ]) {
            for (Product_Hierarchy2__c obj : alist) {
                if (!amap.containsKey(obj.PH6__c)) {
                    amap.put(obj.PH6__c, obj.PH6_Segment__c);
                }  
            }                                    
        }
        if (amap.isEmpty()) {
            return null;
        }
        return amap;
    }
    
    /* public static Map<String, String> phbusiness (Set<String> ph1s) {
        Map<String, String> amap = new Map<String, String>();
        for (List<Product_Hierarchy2__c> alist : [select PH1__c, PH1_Division__c
                                                    from Product_Hierarchy2__c
                                                   where PH1__c in :ph1s
                                                   order by PH1__c
                                                 ]) {
            for (Product_Hierarchy2__c obj : alist) {
                if (!amap.containsKey(obj.PH1__c)) {
                    amap.put(obj.PH1__c, obj.PH1_Division__c);
                }  
            }                                    
        }
        if (amap.isEmpty()) {
            return null;
        }
        return amap;
    }*/
    
    public static Map<String, String> getProductFamilyMap(Set<String> ph5s) {
        Map<String, String> amap = new Map<String, String>();
        for (List<Product_Hierarchy2__c> alist : [select PH5__c, PH5_Family__c
                                                    from Product_Hierarchy2__c
                                                   where PH5__c in :ph5s
                                                   order by PH5__c
                                                 ]) {
            for (Product_Hierarchy2__c obj : alist) {
                if (!amap.containsKey(obj.PH5__c)) {
                    amap.put(obj.PH5__c, obj.PH5_Family__c);
                }  
            }                                    
        }
        if (amap.isEmpty()) {
            return null;
        }
        return amap;
    }
    
    /*public static String getPH1(String distChan) {
        String ph1 = null;
        if (DCHAN_PH1_MAP.containsKey(distChan)) {ph1 = DCHAN_PH1_MAP.get(distChan);}
        return ph1;
    }*/
    
    public static list<String> getPH1(String distChan) {
        list<String> ph1 = null;
        if (DCHAN_PH1_MAP.containsKey(distChan)) {ph1 = DCHAN_PH1_MAP.get(distChan);}
        return ph1;
    }
    
    private static List<Product_Hierarchy__c> getProductHierarchies(Map<String, String> amap) {
        List<Product_Hierarchy__c> plist = new List<Product_Hierarchy__c>();
        List<String> ks = new List<String>(); ks.addAll(amap.keySet()); ks.sort();
        for (String k : ks) {
            Product_Hierarchy__c ph = new Product_Hierarchy__c();
            ph.Product_Hierarchy_Code__c = k;
            ph.Product_Hierarchy_Description__c = amap.get(k);
            plist.add(ph);
        }
        return plist;
    }
    
    /* public static List<Product_Hierarchy__c> getBusiness(String distChan) {
        String ph1 = getPH1(distChan); if (ph1 == null) {return null;}
        Set<String> ph5s = SAP_Queries_Functions.PRODUCT_FAMILY_CODES.get(distChan); if (ph5s == null) {return null;}
        Map<String, String> amap = new Map<String, String>();
        for (List<Product_Hierarchy2__c> alist : [select PH2__c, PH2_Line__c
                                                    from Product_Hierarchy2__c
                                                   where PH1__c = :ph1
                                                     and PH5__c in :ph5s     
                                                 ]) {
            for (Product_Hierarchy2__c obj : alist) {
                amap.put(obj.PH2__c, obj.PH2_Line__c);  
            }                                    
        }
        if (amap.isEmpty()) {return null;}
        return getProductHierarchies(amap);
    }*/
    
    public static List<Product_Hierarchy__c> getProductFamilies(String distChan) {
        list<String> ph1 = getPH1(distChan); if (ph1 == null) {return null;}
        Set<String> ph5s = SAP_Queries_Functions.PRODUCT_FAMILY_CODES.get(distChan); if (ph5s == null) {return null;}
        Map<String, String> amap = new Map<String, String>();
        for (List<Product_Hierarchy2__c> alist : [select PH1__c, PH1_Division__c
                                                    from Product_Hierarchy2__c
                                                   where PH1__c in :ph5s     
                                                 ]) {
            for (Product_Hierarchy2__c obj : alist) {
                amap.put(obj.PH1__c, obj.PH1_Division__c);  
            }                                    
        }
        if (amap.isEmpty()) {return null;}
        return getProductHierarchies(amap);
    }
    
    /*public static List<Product_Hierarchy__c> getProductFamilies(String distChan) {
        String ph1 = getPH1(distChan); if (ph1 == null) {return null;}
        Set<String> ph5s = SAP_Queries_Functions.PRODUCT_FAMILY_CODES.get(distChan); if (ph5s == null) {return null;}
        Map<String, String> amap = new Map<String, String>();
        for (List<Product_Hierarchy2__c> alist : [select PH5__c, PH5_Family__c
                                                    from Product_Hierarchy2__c
                                                   where PH1__c = :ph1
                                                     and PH5__c in :ph5s     
                                                 ]) {
            for (Product_Hierarchy2__c obj : alist) {
                amap.put(obj.PH5__c, obj.PH5_Family__c);  
            }                                    
        }
        if (amap.isEmpty()) {return null;}
        return getProductHierarchies(amap);
    }*/
    
    public static List<Product_Hierarchy__c> getProductFamilies(String distChan,
                                                                String prodSegment) {
        return getProductFamilies(distChan, new List<String>{prodSegment});
    }
    
   /* public static List<Product_Hierarchy__c> getProductFamilies(String distChan,
                                                                List<String> prodSegments) {
        String ph1 = getPH1(distChan); if (ph1 == null) {return null;}
        Set<String> ph5s = SAP_Queries_Functions.PRODUCT_FAMILY_CODES.get(distChan); if (ph5s == null) {return null;}
        Map<String, String> amap = new Map<String, String>();
        for (List<Product_Hierarchy2__c> alist : [select PH5__c, PH5_Family__c,
                                                         PH6__c, PH6_Segment__c
                                                    from Product_Hierarchy2__c
                                                   where PH1__c = :ph1
                                                     and PH6__c in :prodSegments
                                                     and PH5__c in :ph5s     
                                                 ]) {
            for (Product_Hierarchy2__c obj : alist) {
                amap.put(obj.PH5__c, obj.PH5_Family__c);  
            }                                    
        }
        if (amap.isEmpty()) {return null;}
        return getProductHierarchies(amap);
    }*/
     public static List<Product_Hierarchy__c> getProductFamilies(String distChan,
                                                                List<String> prodSegments) {
        list<String> ph1 = getPH1(distChan); if (ph1 == null) {return null;}
        Set<String> ph5s = SAP_Queries_Functions.PRODUCT_FAMILY_CODES.get(distChan); if (ph5s == null) {return null;}
        Map<String, String> amap = new Map<String, String>();
        system.debug('prodSegments0000'+prodSegments+'  ::: '+ph1+'  ::: '+ph5s);
        for (List<Product_Hierarchy2__c> alist : [select PH1__c, PH1_Division__c,
                                                         PH2__c, PH2_Line__c
                                                    from Product_Hierarchy2__c
                                                   where PH1__c in :ph1 
                                                     and PH2__c in :prodSegments
                                                     and PH1__c in :ph5s     
                                                 ]) {
                                                  system.debug('alist+-+'+alist);
            for (Product_Hierarchy2__c obj : alist) {
                amap.put(obj.PH1__c, obj.PH1_Division__c);  
                system.debug('amap+-+'+amap);     
            }                                    
        }
        if (amap.isEmpty()) {return null;}
        return getProductHierarchies(amap);
    }
    
    
    public static List<Product_Hierarchy__c> getProductSegments(String distChan) {
        list<String> ph1 = getPH1(distChan); if (ph1 == null) {return null;}
        system.debug('ph1'+ph1);
        Set<String> ph6s = SAP_Queries_Functions.PRODUCT_LINE_CODES.get(distChan); 
        system.debug('ph6s'+ph6s);
        if (ph6s == null) {return null;}
        Map<String, String> amap = new Map<String, String>();
        for (List<Product_Hierarchy2__c> alist : [select PH2__c, PH2_Line__c
                                                    from Product_Hierarchy2__c
                                                   where PH1__c in :ph1
                                                     and PH2__c in :ph6s limit 100   
                                                 ]) {system.debug('alist for loop'+alist);
                                                     
            for (Product_Hierarchy2__c obj : alist) {
                amap.put(obj.PH2__c, obj.PH2_Line__c);  
            }    
            
         }
        if (amap.isEmpty()) {return null;}
        return getProductHierarchies(amap);
    }
    
    /*public static List<Product_Hierarchy__c> getProductSegments(String distChan) {
        String ph1 = getPH1(distChan); if (ph1 == null) {return null;}
        Set<String> ph6s = SAP_Queries_Functions.PRODUCT_LINE_CODES.get(distChan); if (ph6s == null) {return null;}
        Map<String, String> amap = new Map<String, String>();
        for (List<Product_Hierarchy2__c> alist : [select PH2__c, PH6_Segment__c
                                                    from Product_Hierarchy2__c
                                                   where PH1__c = :ph1
                                                     and PH6__c in :ph6s     
                                                 ]) {
            for (Product_Hierarchy2__c obj : alist) {
                amap.put(obj.PH6__c, obj.PH6_Segment__c);  
            }                                    
        }
        if (amap.isEmpty()) {return null;}
        return getProductHierarchies(amap);
    }*/
    
    public static List<Product_Hierarchy__c> getProductSegments(String distChan,
                                                                String prodFamily) {
        return getProductSegments(distChan, new List<String>{prodFamily});
    }
    
    public static List<Product_Hierarchy__c> getProductSegments(String distChan,
                                                                List<String> prodFamilies) {
        list<String> ph1 = getPH1(distChan); if (ph1 == null) {return null;}
        system.debug('ph1111'+ph1);
        Set<String> ph6s = SAP_Queries_Functions.PRODUCT_LINE_CODES.get(distChan); if (ph6s == null) {return null;}
        system.debug('ph666'+ph6s);
        Map<String, String> amap = new Map<String, String>();
        for (List<Product_Hierarchy2__c> alist : [select PH1__c, PH1_Division__c,
                                                         PH2__c, PH2_Line__c
                                                    from Product_Hierarchy2__c
                                                   where PH1__c in :ph1
                                                     and PH1__c in :prodFamilies     
                                                     and PH2__c in :ph6s
                                                 ]) {
                                                 system.debug('alist0000'+alist);
            for (Product_Hierarchy2__c obj : alist) {amap.put(obj.PH2__c, obj.PH2_Line__c);}  
        }
        if (amap.isEmpty()) {return null;}
        return getProductHierarchies(amap);
    }
    
    /*public static List<Product_Hierarchy__c> getProductSegments(String distChan,
                                                                List<String> prodFamilies) {
        String ph1 = getPH1(distChan); if (ph1 == null) {return null;}
        Set<String> ph6s = SAP_Queries_Functions.PRODUCT_LINE_CODES.get(distChan); if (ph6s == null) {return null;}
        Map<String, String> amap = new Map<String, String>();
        for (List<Product_Hierarchy2__c> alist : [select PH5__c, PH5_Family__c,
                                                         PH6__c, PH6_Segment__c
                                                    from Product_Hierarchy2__c
                                                   where PH1__c = :ph1
                                                     and PH5__c in :prodFamilies     
                                                     and PH6__c in :ph6s
                                                 ]) {
            for (Product_Hierarchy2__c obj : alist) {amap.put(obj.PH6__c, obj.PH6_Segment__c);}                                    
        }
        if (amap.isEmpty()) {return null;}
        return getProductHierarchies(amap);
    }*/
    
    public static List<Product_Hierarchy__c> getProductSubSegments(String distChan,
                                                                   List<String> prodFamilies,
                                                                   List<String> prodSegments) {
        if (prodFamilies == null || prodFamilies.isEmpty() ||
            prodSegments == null || prodSegments.isEmpty()) {return null;}
        list<String> ph1 = getPH1(distChan); if (ph1 == null) {return null;}
        Map<String, String> amap = new Map<String, String>();
        for (List<Product_Hierarchy2__c> alist : [select PH1__c, PH1_Division__c,
                                                         PH2__c, PH2_Line__c,
                                                         PH7__c, PH7_SubSegment__c
                                                    from Product_Hierarchy2__c
                                                   where PH1__c in :ph1 and
                                                   PH1__c in :prodFamilies     
                                                     and PH2__c in :prodSegments
                                                 ]) {
            for (Product_Hierarchy2__c obj : alist) {amap.put(obj.PH7__c, obj.PH7_SubSegment__c);}                                    
        }
        if (amap.isEmpty()) {return null;}
        return getProductHierarchies(amap);
    }
    
    /*public static List<Product_Hierarchy__c> getProductSubSegments(String distChan,
                                                                   List<String> 
                                                                   ,
                                                                   List<String> prodSegments) {
        if (prodFamilies == null || prodFamilies.isEmpty() ||
            prodSegments == null || prodSegments.isEmpty()) {return null;}
        String ph1 = getPH1(distChan); if (ph1 == null) {return null;}
        Map<String, String> amap = new Map<String, String>();
        for (List<Product_Hierarchy2__c> alist : [select PH5__c, PH5_Family__c,
                                                         PH6__c, PH6_Segment__c,
                                                         PH7__c, PH7_SubSegment__c
                                                    from Product_Hierarchy2__c
                                                   where PH1__c = :ph1
                                                     and PH5__c in :prodFamilies     
                                                     and PH6__c in :prodSegments
                                                 ]) {
            for (Product_Hierarchy2__c obj : alist) {amap.put(obj.PH7__c, obj.PH7_SubSegment__c);}                                    
        }
        if (amap.isEmpty()) {return null;}
        return getProductHierarchies(amap);
    }*/
    
    
/*
 **********************************************************
 Test Methods are in Product_Hierarchy_Functions_Test class
 ********************************************************** 
 */    

}
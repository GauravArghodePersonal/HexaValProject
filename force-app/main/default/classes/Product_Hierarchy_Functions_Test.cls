@isTest
public class Product_Hierarchy_Functions_Test {

    static String ph = '!abcdefghijklmnopq';
    static String lc = 'E';
    static String lang     = 'E';
    static List<String> ph1code  =new list<string>{'!'};
    static String ph2code  = '!23';
    static String ph3code  = '!23456';
    static String ph4code  = '!23456789';
    static String ph5code  = '!23456789123';
    static String ph6code  = '!23456789123456';
    static String ph7code  = '!23456789123456789';
    
    private static void debug(String s) {System.debug(LoggingLevel.INFO, s);}
    
    private static void init1(String dchan) {
       ph1code = Product_Hierarchy_Functions.getPH1(dchan);
        ph2code = ph1code + '23';
        ph3code = ph2code + '456';
        ph4code = ph3code + '789';
        ph5code = ph4code + '123';
        ph6code = ph5code + '456';
        ph7code = ph6code + '789';
    }

    public static Product_Hierarchy2__c getTestProdHerky2() {
        return getTestProdHerky2('99');
    }
    
    public static Product_Hierarchy2__c getTestProdHerky2(String dchan) {
        init1(dchan);
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Language_Code__c = lang;
        ph1.Product_Hierarchy_Code__c = 'ph1code';
        ph1.Product_Hierarchy_Description__c = 'ph1desc';
        insert ph1;

        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        ph2.Language_Code__c = lang;
        ph2.Product_Hierarchy_Code__c = ph2code;
        ph2.Product_Hierarchy_Description__c = 'ph2desc';
        insert ph2;

        Product_Hierarchy__c ph3 = new Product_Hierarchy__c();
        ph3.Language_Code__c = lang;
        ph3.Product_Hierarchy_Code__c = ph3code;
        ph3.Product_Hierarchy_Description__c = 'ph3desc';
        insert ph3;

        Product_Hierarchy__c ph4 = new Product_Hierarchy__c();
        ph4.Language_Code__c = lang;
        ph4.Product_Hierarchy_Code__c = ph4code;
        ph4.Product_Hierarchy_Description__c = 'ph4desc';
        insert ph4;

        Product_Hierarchy__c ph5 = new Product_Hierarchy__c();
        ph5.Language_Code__c = lang;
        ph5.Product_Hierarchy_Code__c = ph5code;
        ph5.Product_Hierarchy_Description__c = 'ph5desc';
        insert ph5;

        Product_Hierarchy__c ph6 = new Product_Hierarchy__c();
        ph6.Language_Code__c = lang;
        ph6.Product_Hierarchy_Code__c = ph6code;
        ph6.Product_Hierarchy_Description__c = 'ph6desc';
        insert ph6;

        Product_Hierarchy__c ph7 = new Product_Hierarchy__c();
        ph7.Language_Code__c = lang;
        ph7.Product_Hierarchy_Code__c = ph7code;
        ph7.Product_Hierarchy_Description__c = 'ph7desc';
        insert ph7;

        Product_Hierarchy2__c pherky2 = new Product_Hierarchy2__c();
        pherky2.Product_Hierarchy__c = ph7.Product_Hierarchy_Code__c;
        pherky2.Product_Hierarchy1__c = ph1.Id;
        pherky2.Product_Hierarchy2__c = ph2.Id;
        pherky2.Product_Hierarchy3__c = ph3.Id;
        pherky2.Product_Hierarchy4__c = ph4.Id;
        pherky2.Product_Hierarchy5__c = ph5.Id;
        pherky2.Product_Hierarchy6__c = ph6.Id;
        pherky2.Product_Hierarchy7__c = ph7.Id;
        insert pherky2;
        pherky2 = [select PH1__c, 
            PH1_Division__c,
            PH1_Division_Code__c, 
            PH2__c, 
            PH2_Line__c,
            PH3__c, 
            PH3_Group__c,
            PH4__c,
            PH4_Supplier__c,
            PH5__c, 
            PH5_Family__c, 
            PH6__c, 
            PH6_Segment__c,
            PH6_Segment_Code__c, 
            PH7__c, 
            PH7_SubSegment__c,
            Product_Hierarchy__c,
            Product_Hierarchy1__c,
            Product_Hierarchy2__c,
            Product_Hierarchy3__c,
            Product_Hierarchy4__c,
            Product_Hierarchy5__c,
            Product_Hierarchy6__c,
            Product_Hierarchy7__c         
        from Product_Hierarchy2__c where Id = :pherky2.Id];
        return pherky2;
    }

    static testMethod void test01() {
        Test.startTest();
        Product_Hierarchy__c ph1, ph2, ph3, ph4, ph5, ph6, ph7;
        ph1 = new Product_Hierarchy__c();
        ph1.Product_Hierarchy_Code__c = ph.substring(0,1);
        ph1.Language_Code__c = lc;
        ph2 = new Product_Hierarchy__c();
        ph2.Product_Hierarchy_Code__c = ph.substring(0,3);
        ph2.Language_Code__c = lc;
        ph3 = new Product_Hierarchy__c();
        ph3.Product_Hierarchy_Code__c = ph.substring(0,6);
        ph3.Language_Code__c = lc;
        ph4 = new Product_Hierarchy__c();
        ph4.Product_Hierarchy_Code__c = ph.substring(0,9);
        ph4.Language_Code__c = lc;
        ph5 = new Product_Hierarchy__c();
        ph5.Product_Hierarchy_Code__c = ph.substring(0,12);
        ph5.Language_Code__c = lc;
        ph6 = new Product_Hierarchy__c();
        ph6.Product_Hierarchy_Code__c = ph.substring(0,15);
        ph6.Language_Code__c = lc;
        ph7 = new Product_Hierarchy__c();
        ph7.Product_Hierarchy_Code__c = ph;
        ph7.Language_Code__c = lc;
        insert ph1;
        insert ph2;
        insert ph3;
        insert ph4;
        insert ph5;
        insert ph6;
        insert ph7;
        Set<String> aset = new Set<String> {ph};
        Product_Hierarchy_Functions.upsert_Product_Hierarchy2(aset);
        Product_Hierarchy_Functions.getProdHerkyMap(aset);
        List<Product_Hierarchy__c> plist;
        plist = Product_Hierarchy_Functions.getProductSegments('99');
        System.debug(plist);
        Set<String> ph5s = new Set<String> {ph.substring(0,12)};
        Map<String, String> ph5map = Product_Hierarchy_Functions.getProductFamilyMap(ph5s);
        Set<String> ph6s = new Set<String> {ph.substring(0,15)};
        Map<String, String> ph6map = Product_Hierarchy_Functions.getProductSegmentMap(ph6s);
        Test.stopTest();
    }
    
    static testMethod void test02() {
        Test.startTest();
        Product_Hierarchy_Functions.getProductFamilies('10', '000');
        Test.stopTest();
    }
   
    static testMethod void test03() {
        Test.startTest();
        Product_Hierarchy2__c pherky2 = getTestProdHerky2();
        debug(''+pherky2);
        String distChan = '99';
        List<String> prodFamilies = new List<String>{'123'};
        List<String> prodSegments = new List<String>{'456'};
        List<Product_Hierarchy__c> phs = SAP_Material_Queries.getProductSubSegments(distChan,
                                                              prodFamilies, prodSegments);
        debug(''+phs);
        Test.stopTest();
    }

}
@isTest
private class Price_Book_Functions_Test {
    
    static final String langCode = '0'; 

    static final String sorgCode = '0000'; 
    static final String sorgDesc = 'test Sales Org'; 

    static final String distChan = '00'; 
    static final String distChanDesc = 'test Dist Chan'; 

    static final String divCode = '00'; 
    static final String divDesc = 'test Division'; 

    static final String countryCode = '00'; 
    static final String countryDesc = 'test Country'; 

    static final String custGroupCode = '00'; 
    static final String custGroupDesc = 'test CustGroup'; 

    static final String prodLineCode = '000'; 
    static final String prodLineDesc = 'test ProdLine'; 
    static final String familyCode = '000'; 

    static final String accName = 'test Account'; 
    static final String parentAccName = 'test Parent Account'; 

    static final SAP_Sales_Org__c sorg = getSalesOrg();
    static final SAP_Distribution_Channel__c dchan = getDistChan();
    static final SAP_Sales_Division__c divsn = getDivision();
    static final SAP_Country_Name__c regn = getRegion();
    static final SAP_Customer_Group__c cgrp = getCustGroup();

    static testMethod void myUnitTest() {
        Test.startTest();
        test01();
        test02();
        test03();
        //Test.stopTest();
    }
    
    static void test01() {
        //system.debug('empty String = ' + doesPriceBookExist(''));
        //system.debug('1001-99-42-AF-17-125 = ' + doesPriceBookExist('1001-99-42-AF-17-125'));
        //system.debug('Should not exist = ' + doesPriceBookExist('BadKey'));
    }

    static void test02() {
        List<Id> sorgIds = new List <Id>{sorg.Id};
        Set<String> familyCodes = new Set<String>{familyCode};
        List<Id> regnIds = new List <Id>{regn.Id};
        List<Id> cgrpIds = new List <Id>{cgrp.Id};
        string vcpGrade;
        vcpGrade='A';
        
        Account parentAccount = getAccount(parentAccName, null);
        Account acc = getAccount(accName, parentAccount.Id);
        System.assertEquals(acc.Name, accName);
        Price_Book__c pb = getPriceBook();
        Id pbId = pb.Id;
        System.debug(pbId);
        getPriceBookCustomerGroup(pbId);
        getPriceBookFamily(pbId);
        getPriceBookProdLine(pbId);
        getPriceBookRegion(pbId);
        getPriceBookSalesOrg(pbId);
        List<Id> pbIds;
        pbIds = Price_Book_Functions.getPriceBooksIdsForCustomer(acc.Id);
        System.debug(pbIds);
        Price_Book_Functions.getPriceBooksForCustomer(parentAccount.Id, true);
        Price_Book_Functions.getPACIndustrySegments();
        Price_Book_Functions.getEndUseCustomers(acc.Id);
        Price_Book_Functions.getPriceBooks(sorg.Id, dchan.Id, divsn.Id, prodLineCode, familyCode, regn.Id, cgrp.Id,vcpGrade, false);
        try {
            Price_Book_Functions.submitPriceBookforApproval(pbId);
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
    }
    
    static void test03() {
        Price_Book_Functions.getPaymentTermExplanations();
    }
    
    static Account getAccount(String accountName,
                              Id parentId) {
        Account a = new Account();
        a.Name = accountName;
        a.SAP_Sales_Org__c = sorg.Sales_Org_Code__c;
        a.SAP_DistChannel__c = dchan.Distribution_Channel_Code__c;
        a.SAP_DivisionCode__c = divsn.Sales_Division_Code__c;
        a.SAP_Region__c = regn.Country_Code__c;
        a.SAP_Customer_Group__c = cgrp.Customer_Group_Code__c;
        if (parentId != null) {
            a.ParentId = parentId;
        }
        insert a;
        return a;
    }
    
    static SAP_Sales_Org__c getSalesOrg() {
        SAP_Sales_Org__c so = new SAP_Sales_Org__c();
        so.Language_Code__c = langCode;
        so.Sales_Org_Code__c = sorgCode;
        so.Sales_Org_Description__c = sorgDesc;
        insert so;
        return so;
    }
    
    static SAP_Distribution_Channel__c getDistChan() {
        SAP_Distribution_Channel__c dc = new SAP_Distribution_Channel__c();
        dc.Distribution_Channel_Code__c = distChan;
        dc.Language_Code__c = langCode;
        dc.Distribution_Channel_Description__c = distChanDesc;
        insert dc;
        return dc;
    }
    
    static SAP_Sales_Division__c getDivision() {
        SAP_Sales_Division__c sd = new SAP_Sales_Division__c();
        sd.Language_Code__c = langCode;
        sd.Sales_Division_Code__c = divCode;
        sd.Sales_Division_Description__c = divDesc;
        insert sd;
        return sd;
    }
    
    static SAP_Country_Name__c getRegion() {
        SAP_Country_Name__c r = new SAP_Country_Name__c();
        r.Country_Code__c = countryCode;
        r.Country_Name__c = countryDesc;
        r.Language_Code__c = langCode;
        insert r;
        return r;
    }
    
    static SAP_Customer_Group__c getCustGroup() {
        SAP_Customer_Group__c cg = new SAP_Customer_Group__c();
        cg.Language_Code__c = langCode;
        cg.Customer_Group_Code__c = custGroupCode;
        cg.Customer_Group_Name__c = custGroupDesc;
        insert cg;
        return cg;
    }
    
    static Price_Book__c getPriceBook() {
        Price_Book__c pb = new Price_Book__c();
        pb.Dist_Channel__c = dchan.Id;
        pb.Division__c = divsn.Id;
        insert pb;
        return pb; 
    }
    
    static Price_Book_Customer_Group__c getPriceBookCustomerGroup(Id pbId) {
        Price_Book_Customer_Group__c p = new Price_Book_Customer_Group__c();
        p.Price_Book__c = pbId;
        p.SAP_Customer_Group__c = cgrp.Id;
        insert p;
        return p;
    }
    
    static Price_Book_Family__c getPriceBookFamily(Id pbId) {
        Price_Book_Family__c p = new Price_Book_Family__c();
        p.Price_Book__c = pbId;
        p.Family_Code__c = familyCode;
        insert p;
        return p;
    }
    
    static Price_Book_Product_Line__c getPriceBookProdLine(Id pbId) {
        Price_Book_Product_Line__c p = new Price_Book_Product_Line__c();
        p.Price_Book__c = pbId;
        p.Product_Line_Code__c = prodLineCode;
        p.Product_Line_Desc__c = prodLineDesc;
        insert p;
        return p;
    }
    
    static Price_Book_Region__c getPriceBookRegion(Id pbId) {
        Price_Book_Region__c p = new Price_Book_Region__c();
        p.Price_Book__c = pbId;
        p.SAP_Region__c = regn.Id;
        insert p;
        return p;
    }
    
    static Price_Book_Sales_Org__c getPriceBookSalesOrg(Id pbId) {
        Price_Book_Sales_Org__c p = new Price_Book_Sales_Org__c();
        p.Price_Book__c = pbId;
        p.SAP_Sales_Org__c = sorg.Id;
        insert p;
        return p;
    }
    
}
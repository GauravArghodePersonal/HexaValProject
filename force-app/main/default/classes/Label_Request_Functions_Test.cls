@isTest
private class Label_Request_Functions_Test {

    static Account acc;
    static Contact con;
    static Label_Request__c lr;
    static Label_Vendor__c lv;
    static SAP_Distribution_Channel__c dc;
    static SAP_Sales_Org__c so;
    static String responseText;
    static String distChanCode = '10';
    static String salesOrgCode = '1020';
    static String lang = 'E';
    
    static testMethod void myUnitTest() {
        Test.startTest();
        createTestData();
        test01();
        Test.stopTest();
    }
    
    static void createTestData() {
         
        dc = getDistChan(distChanCode);
        
        so = getSalesOrg(salesOrgCode);
        // Added by Vinu
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        insert p;
        system.debug('11'+p);
        //acc = new Account(Name = 'Test Account');
        acc = new Account(Name = 'Test Account');
        acc.Account_Number__c = 'TestAccount';
        acc.SAP_DistChannel__c = distChanCode;
        acc.SAP_Sales_Org__c = salesOrgCode;
        insert acc;
         system.debug('22'+acc);
        //insert acc;
        con = new Contact();
        con.LastName = 'LastName';
        con.Email = 'emailid1@ashland.com';
        insert con;
         system.debug('33'+con);
        lv = new Label_Vendor__c();
        lv.Contact__c = con.Id;
        lv.SAP_Distribution_Channel__c = dc.Id;
        lv.SAP_Sales_Org__c = so.Id;
        lv.Additional_Emails__c = 'emailid2@ashland.com';
        insert lv;
          system.debug('44'+lv);
        lr = new Label_Request__c();
        lr.Contact__c = con.Id;
        lr.Customer_Prospect__c = acc.Id;
        lr.Status__c = 'Submitted';
       
        insert lr;
          system.debug('55'+lr);
        responseText = '\n';
        responseText += 'Almatek Replies:\n';
        responseText += 'Date Shipped (MM/DD/YYYY) : 01/01/2010\n';
        responseText += 'Quantity Shipped : 1234\n';
        responseText += 'Tracking Number : ABCDEFGHIJKL\n';
        responseText += 'Label Request Reference # : ';
        responseText += lr.Id;
        responseText += '\n';
    }
    
    static SAP_Sales_Org__c getSalesOrg(String sorg) {
        so = null;
        try {
            so = [select Sales_Org_Code__c 
                    from SAP_Sales_Org__c
                   where Sales_Org_Code__c = :sorg
                   limit 1];
        } catch(Exception e) {}
        if (so == null) {
            so = new SAP_Sales_Org__c();
            so.Sales_Org_Code__c = sorg;
            so.Language_Code__c = lang;
            insert so;
        }
        return so;
    }
    
    static SAP_Distribution_Channel__c getDistChan(String dchan) {
        dc = null;
        try {
            dc = [select Distribution_Channel_Code__c 
                    from SAP_Distribution_Channel__c
                   where Distribution_Channel_Code__c = :dchan
                   limit 1];
        } catch(Exception e) {}
        if (dc == null) {
            dc = new SAP_Distribution_Channel__c();
            dc.Distribution_Channel_Code__c = dchan;
            dc.Language_Code__c = lang;
            insert dc;
        }
        return dc;
    }
    
    static void test01() {
        List<Label_Request__c> lrs = new List<Label_Request__c>{lr};
        System.debug(lr);
        Label_Request_Functions.updateLabelRequestResponse(responseText);
        PageReference myVfPage = Page.displaylabels;
Test.setCurrentPage(myVfPage);

// Put Id into the current page Parameters
ApexPages.currentPage().getParameters().put('aid',acc.Id);
ApexPages.currentPage().getParameters().put('id',lr.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(lr);
        Label_Request_Display_Extension e = new Label_Request_Display_Extension(sc);
        e.getpic1big();
        e.getpic2big();
        e.getpic3big();
        e.getpic4big();
        e.getpic1small();
        e.getpic5big();
e.getpic6big();
e.getpic7big();    
e.getpic8big();
e.getpic9big();
e.getpic10big();
e.getpic11big();
e.getpic12big();
e.getpic13big();
e.getpic14big();
e.getpic15big();
e.getpic16big();
e.getpic17big();
e.getpic18big();
e.getpic19big();
e.getpic2small();
e.getpic3small();
e.getpic4small();
e.getpic5small();
e.getpic6small();
e.getpic7small();
e.getpic8small();
e.getpic9small();
e.getpic10small();
e.getpic11small();
e.getpic12small();
e.getpic13small();
e.getpic14small();
e.getpic15small();
e.getpic16small();
e.getpic17small();
e.getpic18small();
e.getpic19small();
e.hidecontactpopup();
e.opencontactpanel();
e.getContactStyle();
e.showcontactpopup();
e.createreqsubmit();
e.createreq();

        System.debug(lr);
    }
    
}
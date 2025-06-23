@isTest
private class PricingConditionApprovalCriteria_Test {

    static Account acc;
    static Pricing_Condition__c pc;
    static SAP_INCO_Term__c sitc;
    static User usr;
    static Double flrPrice, minPrice, mktPrice;
    static String sorg;
    static String dchan;
    static String dvsn;
    static String apterm;
    static String ppterm;
    static String pcinco;
    static String cpinco;
    static String accId, pcId, sitcId, usrId;
    
    static void debug(String s) {
    	System.debug(LoggingLevel.INFO, '>>>>>>> PCApprovalCriteria_Test : ' + s);
    }
    
    static void setAccount() {
    	acc = null;	if (accId == null) {return;}
        try {
            acc = [select Name, SAP_Payment_Terms__c, SAP_Sales_Org__c,
                          SAP_DistChannel__c, SAP_DivisionCode__c
                     from Account where Id = :accId];
        } catch(Exception e){}
    }
    
    static void setSapIncoTerm() {
    	sitc = null; if (sitcId == null) {return;}
        try {
        	sitc = [select INCO_Term_Code__c 
        	          from SAP_INCO_Term__c where Id = :sitcId];
        } catch(Exception e){}
    }
    
    static void setPricingCondition() {
    	pc = null; if (pcId == null) {return;}
        try {
	        pc = [select Account_Payment_Terms__c,
	                     CPI_INCO_Term_Code__c,
	                     Discount_Percent__c,
	                     Floor_Price__c, 
	                     Freight_Up_Charge__c,
	                     INCO_Term_Code__c,
	                     Market_Price__c, 
	                     Payment_Terms__c
	                from Pricing_Condition__c
	               where Id = :pcId];
        } catch(Exception e){}
    }
    
    static void setUser() {
        usr = null; if (usrId == null) {return;}
        try {
            usr = [select Name from User where Id = :usrId];
        } catch(Exception e) {}
    }

    static void createTestData() {
    	setAccount();
    	if (acc == null) {
	    	acc = new Account();
	    	acc.Name = 'TestAccount';
	    	acc.SAP_Payment_Terms__c = apterm;
	    	acc.SAP_Sales_Org__c = sorg;
	    	acc.SAP_DistChannel__c = dchan;
	    	acc.SAP_DivisionCode__c = dvsn;
	    	insert acc; accId = acc.Id;
    	}
        setAccount();
    	
    	setSapIncoTerm();
    	if (sitc == null) {
	    	sitc = new SAP_INCO_Term__c();
	    	sitc.INCO_Term_Code__c = pcinco;
	    	sitc.Language_Code__c = 'E';
	    	insert sitc; sitcId = sitc.Id;
    	}
        setSapIncoTerm();

        setPricingCondition();
    	if (pc == null) {
	    	pc = new Pricing_Condition__c();
	    	pc.Account__c = accId;
	        pc.CPI_INCO_Term_Code__c = cpinco;
	        pc.Floor_Price__c = flrPrice;
	        pc.Market_Price__c = mktPrice;
	        pc.Payment_Terms__c = ppterm;
	        pc.SAP_INCO_Term__c = sitcId;
	        insert pc; pcId = pc.Id;
    	}
        setPricingCondition();
    	
    }

    static void setRouteForApprovalFields() {
        createTestData();
        PricingConditionApprovalCriteria.setRouteForApprovalFields(pc, acc, minPrice);
        debug(''+pc);
    }

    static testMethod void test01() {
    	Test.startTest();
    	sorg = '0865'; dchan = '10'; dvsn = '13';
    	apterm = 'APTC'; ppterm = 'PPTC';
    	cpinco = 'CPI'; pcinco = 'PCI';
        flrPrice = 0.8; minPrice = 1.1; mktPrice = 1.2;
        setRouteForApprovalFields();
    }
    
/*        
    static testMethod void test02() {
    	usrId = '00550000000sypU'; 
    	accId = '0015000000NDvdN';
    	pcId = 'a44P000000001qn';
    	sitcId = 'a2o500000004C9O';
    	
    	setUser();
    	if (usr == null) {return;}
        Test.startTest();
        minPrice = 1.1;
    	System.runAs(usr) {
            setRouteForApprovalFields();
    	}
    }
//*/
    
}
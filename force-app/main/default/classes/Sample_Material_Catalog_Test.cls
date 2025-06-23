@isTest
private class Sample_Material_Catalog_Test {

    static String sampleCenter = 'Test-SC';
    static String page1 = '/apex/Sample_Material_Catalog';
    static Sample_Material_Catalog__c smc;
    static List<Sample_Material_Catalog__c> smclist;
    static Sample_Material_Catalog c;

    static void addSMC(String ssize) {
        smc = new Sample_Material_Catalog__c();
        smc.Product_Code__c = 'Test1234';
        smc.Product_Name__c = 'TestProduct';
        smc.Sample_Center__c = sampleCenter;
        smc.Sample_Size__c = ssize;
        smclist.add(smc);
    }
        
    static void createTestData() {
    	smclist = new List<Sample_Material_Catalog__c>();
    	addSMC('TestSize1'); addSMC('TestSize2'); addSMC('TestSize3');
    	insert smclist;
    	User usr = User_Functions.getLoggedInUser();
    	usr.Sample_Center__c = sampleCenter;
    	try {update usr;} catch(Exception e){}
        PageReference pr = new PageReference(page1);
        Test.setCurrentPageReference(pr);
        c = new Sample_Material_Catalog();
    }
    
    static testMethod void test01() {
    	createTestData();
        c.pc1Frst(); c.pc1Next(); c.pc1Last(); c.pc1Prev(); c.pc1Size(); 
        selectAll(); c.editRecs(); 
        selectAll(); c.undoRecs(); 
        selectAll(); c.saveRecs(); 

        c.recNum = 3; c.blankRec(); 
        c.recNum = 3; c.cloneRec(); 
        c.recNum = 3; c.editRec(); 
        c.recNum = 3; c.saveRec(); 
        c.recNum = 3; c.deleteRec();

    	c.recNum = 1; c.blankRec(); 
    	c.recNum = 1; c.cloneRec(); 
    	c.recNum = 1; c.editRec(); 
    	c.recNum = 1; c.saveRec(); 
    	c.recNum = 1; c.deleteRec();

    	selectAll(); c.reviewRecs();
    	c.deleteRecs(); c.addErrorMessage('test error');
    }
    
    static void selectAll() {
    	for (Sample_Material_Catalog.Rec r : c.reclist) {
    		r.selected = true;
    	}
    }
    
    static testMethod void test02() {
        createTestData();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(smc);
        c = new Sample_Material_Catalog(sc);
        c.smc.Product_Code__c = smc.Product_Code__c;
        c.smc.Product_Name__c = smc.Product_Name__c;
        c.smc.Sample_Size__c = smc.Sample_Size__c; 
        c.setRecPC();
    }
}
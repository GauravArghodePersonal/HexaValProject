@isTest
private class AssetManagementFunctions_Test {

    static Account plant1, plant2, acc1;
    static Asset asset1;
    static List<Asset> assets;
    static Product2 equip1;
    static Material_Sales_Data2__c mat1;
    static List<AssetManagementController.AssetClass> aclist; 
    
    static testMethod void test01() {
    	createTestData();
    	ApexPages.currentPage().getParameters().put('pid', plant1.Id);
        AssetManagementController c = new AssetManagementController();
        c.newAsset = new AssetManagementController.AssetClass(asset1);
        c.newAsset.assignedAccName = 'Test Asset Account1'; 
        c.newAsset.equipmentName = 'Test Asset Equipment1';
        c.newAsset.plantName = 'Test Asset Plant1'; 
        c.getStatSelOps(); c.setAccounts(); c.setEquipments(); c.setPlants();
        c.newAsset.quantity = 2; c.newAsset.plantId = plant1.Id; c.newAsset.equipmentId = equip1.Id;
        c.createAssets(); c.initAssetList(); c.searchAssets(); 
        aclist = c.getAssetList(); aclist[0].selected = true;
        c.getAssetsToAssign(); 
        c.getAssetsToDelete(); 
        c.getAssetsToRetire();
        c.getAssetsToReturn();
        c.getAssetsToTransfer();
    }
    
    static void createTestData() {
        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        
        
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        pfxCustomList.add(p);
        
        
        
        PriceFx__c p1 = new PriceFx__c();
        p1.allowed_recordtype_id__c = '01250000000HmZV';
        p1.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p1.Name='callMaterialSalesData2';
        p1.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p1.password__c='Testuser@123';
        p1.username__c='sfdctestuser';
        pfxCustomList.add(p1);
        
        PriceFx__c p2 = new PriceFx__c();
        p2.allowed_recordtype_id__c = '01250000000HmZV';
        p2.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p2.Name='callCustomerProductInfo2';
        p2.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p2.password__c='Testuser@123';
        p2.username__c='sfdctestuser';
        pfxCustomList.add(p2);
        
        PriceFx__c p3 = new PriceFx__c();
        p3.allowed_recordtype_id__c = '01250000000HmZV';
        p3.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p3.Name='callMaterialPlant2';
        p3.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p3.password__c='Testuser@123';
        p3.username__c='sfdctestuser';
        pfxCustomList.add(p3);
        
        insert pfxCustomList;
        
    	plant1 = new Account(Name='Test Asset Plant1');
        plant2 = new Account(Name='Test Asset Plant2');
        acc1   = new Account(Name='Test Asset Account1');
        List<Account> accs = new List<Account>{acc1, plant1, plant2};
        insert accs;  
        
        List<ProductCatalog> prdtCtlgList = new List<ProductCatalog>();
        ProductCatalog prdtCtlg_A =  new ProductCatalog(Name = 'abc');
        ProductCatalog prdtCtlg_B =  new ProductCatalog(Name = 'efg');
        prdtCtlgList.add(prdtCtlg_A);
        prdtCtlgList.add(prdtCtlg_B);
        insert prdtCtlgList;
        
        List<ProductCategory> prdtCtgyList = new List<ProductCategory>();
      	ProductCategory prdtCtgy_A = new ProductCategory(Name = 'abc', Brand_Code__c='abc',Brand_Name_As_Account__c ='abc',CatalogId =prdtCtlg_A.id);
      	ProductCategory prdtCtgy_B = new ProductCategory(Name = 'efg', Brand_Code__c='efg',Brand_Name_As_Account__c ='efg',CatalogId =prdtCtlg_B.id);
        prdtCtgyList.add(prdtCtgy_A);
        prdtCtgyList.add(prdtCtgy_B);
      	insert prdtCtgyList;        
        
        List<CommerceEntitlementPolicy> cmreEtmntPlcyList = new List<CommerceEntitlementPolicy>();
        CommerceEntitlementPolicy cmreEtmntPlcy_A = new CommerceEntitlementPolicy(Name='abc');
        CommerceEntitlementPolicy cmreEtmntPlcy_B = new CommerceEntitlementPolicy(Name='efg');
        cmreEtmntPlcyList.add(cmreEtmntPlcy_A);
        cmreEtmntPlcyList.add(cmreEtmntPlcy_B);
        insert cmreEtmntPlcyList;
        
        mat1 = Material_Sales_Data_Functions_Test.getTestMsd2();
        mat1.Material_Group4_Code__c = 'efg';
        update mat1;
        
        List<Product2> prdtList = new List<Product2>();
        equip1 = new Product2(Name='Test Asset Equipment1', RecordKey__c='Test', MSD2__c = mat1.Id );
        prdtList.add(equip1);        
        insert prdtList;
        
        List<ProductCategoryProduct> prdtCtgyPrdtList = new List<ProductCategoryProduct>();
       	ProductCategoryProduct prdtCtgyPrdt_A = new ProductCategoryProduct(ProductCategoryId = prdtCtgy_A.id, ProductId = equip1.id);
        prdtCtgyPrdtList.add(prdtCtgyPrdt_A);      
        Insert prdtCtgyPrdtList;
        
        asset1 = new Asset(Name='Test Asset 1', AccountId=plant1.Id, Product2Id=equip1.Id);
        insert asset1;
        
        assets = new List<Asset>();
        for (Integer i = 0; i < 100; i++) {
        	asset1 = new Asset(Name='Asset '+i, AccountId=plant1.Id, Product2Id=equip1.Id);
        	assets.add(asset1);
        }
        //insert assets;
    }

/*    
    static  List<AssetClass> getTestAssets() {
        List<AssetClass> alist = new List<AssetClass>();
        Product2 eqp = [select Id, Name from Product2
                         where Name = 'Valv Equipment 1' 
                         limit 1];
        for (Integer i = 0; i < 10; i++) {
            Asset a = new Asset();
            a.Product2 = eqp;
            a.Name = 'Asset Name ' + i;
            a.Quantity = i;
            alist.add(new AssetClass(a));
        }
        return alist;
    }
*/    

}
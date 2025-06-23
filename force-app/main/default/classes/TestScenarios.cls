@isTest
public class TestScenarios {
    private static Integer uniqueIdx = 0;
    private static Integer newUniqueIdx() {return uniqueIdx++;}

    /***********************************************************
     * Generate an Account with Contact, Case Opportunity, Call Report and a Task
     *
     * Implementation Code:
    
        private static Account account;
        private static Contact contact;
        private static Case newCase;
        private static Opportunity opportunity;
        private static Task accountTask;
        private static Task contactTask;
        private static Call_Report__c callReport;
    
        Map<String,SObject> testData = TestScenarios.createAccountwithContactOppandTask();
        account = (Account)testData.get('account');
        contact = (Contact)testData.get('contact');
        newCase = (Case)testData.get('case');
        opportunity = (Opportunity)testData.get('opportunity');
        accountTask = (Task)testData.get('accountTask');
        contactTask = (Task)testData.get('contactTask');
        callReport = (Call_Report__c)testData.get('callReport');
    
     ************************************************************/
    public static Map<String,SObject> createAccountwithContactOppandTask() {
        Map<String,SObject> results = new Map<String,SObject>();

        Account account;
        Contact contact;
        Case newCase;
        Opportunity opportunity;
        Task accountTask, contactTask;
        Call_Report__c callReport;
        
        account = TestObjects.newAccount('',true);
        contact = TestObjects.newContact('',new Map<String,String>{'AccountId'=>account.Id},true);
        newCase = TestObjects.newCase('',new Map<String,String>{'AccountId'=>account.Id},true);
        opportunity = TestObjects.newOpportunity('',new Map<String,String>{'AccountId'=>account.Id}, true);
        accountTask = TestObjects.newTask('',new Map<String,String>{'WhatId'=>account.Id}, true);
        contactTask = TestObjects.newTask('',new Map<String,String>{'WhatId'=>account.Id,'WhoId'=>contact.Id}, true);
        callReport = TestObjects.newCall_Report('',new Map<String,String>{'Account__c'=>account.Id,'Title__c'=>'Test Call Report'}, true);

        results.put('account', account);
        results.put('contact', contact);
        results.put('case', newCase);
        results.put('opportunity', opportunity);
        results.put('accountTask', accountTask);
        results.put('contactTask', contactTask);
        results.put('callReport', callReport);
        return results;
    }
    
    /**************************************************************************
     * Generate Accounts with Relationships, Pricing Conditions, and Materials
     * 
     * Two method types: createAccountsWithRelationshipMaterialandPCObjects() and
     *                   createAccountsWithRelationshipMaterialandPCObjects(String salesArea, String matnum, String salesOrg, String distChan)
     *  
     * Implementation Code for :
    
        Map<String,SObject> testData = createAccountsWithRelationshipMaterialandPCObjects();
        // OR
        Map<String,SObject> testData = createAccountsWithRelationshipMaterialandPCObjects('00000000','010000000123456789','1234','12');
        Account cHerky = testData.get('cHerky');
        Account soldTo = testData.get('soldTo');
        Account soldTo2 = testData.get('soldTo2');
        Account shipTo = testData.get('shipTo');
        invalidAcc = testData.get('invalidAcc');
        CISRelationships__c CR1 = testData.get('CR1');
        CISRelationships__c CR2 = testData.get('CR2');
        CISRelationships__c CR3 = testData.get('CR3');
        CISRelationships__c CR4 = testData.get('CR4');
        Material_Sales_Data2__c msd2 = testData.get('msd2');
        Pricing_Condition__c priceCond1 = testData.get('priceCond1');
        Pricing_Condition__c priceCond2 = testData.get('priceCond2');
        Pricing_Condition__c priceCond3 = testData.get('priceCond3');
        
     ***************************************************************************/
    public static Map<String,SObject> createAccountsWithRelationshipMaterialandPCObjects() {
        String salesArea = '00000000';
        String matnum = '010000000123456789';
        String salesOrg = '1234';
        String distChan = '12';
        return createAccountsWithRelationshipMaterialandPCObjects(salesArea, matnum, salesOrg, distChan);
    }
    
    public static Map<String,SObject> createAccountsWithRelationshipMaterialandPCObjects(String salesArea, String matnum, String salesOrg, String distChan) {
        Map<String,SObject> results = new Map<String,SObject>();
        Map<String,SObject> results1 = createAccountsWithRelationshipObjects(salesArea);
        Map<String,SObject> results2 = createPricingConditionsandMaterial((Account)results1.get('cHerky'), 
                                                                          (Account)results1.get('soldTo'), 
                                                                          (Account)results1.get('shipTo'), 
                                                                          matnum, salesOrg, distChan);

        results.putAll(results1);
        results.putAll(results2);
        return results;                                                                    
    }
    
    /**************************************************************************
     * Generate Accounts with Relationships
     * 
     * Two method types: createAccountsWithRelationshipObjects() and
     *                   createAccountsWithRelationshipObjects(String salesArea)
     *  
     * Implementation Code for :
    
        Map<String,SObject> testData = createAccountsWithRelationshipObjects();
        // OR
        Map<String,SObject> testData = createAccountsWithRelationshipObjects('00000000');
        Account cHerky = testData.get('cHerky');
        Account soldTo = testData.get('soldTo');
        Account soldTo2 = testData.get('soldTo2');
        Account shipTo = testData.get('shipTo');
        invalidAcc = testData.get('invalidAcc');
        CISRelationships__c CR1 = testData.get('CR1');
        CISRelationships__c CR2 = testData.get('CR2');
        CISRelationships__c CR3 = testData.get('CR3');
        CISRelationships__c CR4 = testData.get('CR4');
        
     ***************************************************************************/
    public static Map<String,SObject> createAccountsWithRelationshipObjects() {
        String salesArea = '00000000';
        return createAccountsWithRelationshipObjects(salesArea);
    }
    
    public static Map<String,SObject> createAccountsWithRelationshipObjects(String salesArea) {
        Map<String,SObject> results = new Map<String,SObject>();
        Account shipTo, soldTo, soldTo2, cHerky, invalidAcc;
        CISRelationships__c CR1, CR2, CR3, CR4;
        
        cHerky = TestObjects.newAccount('',true);
        
        soldTo = TestObjects.newAccount('',new Map<String,String>{'ParentId'=>cHerky.Id,
                                                                  'SAP_Partner_Functions__c'=>CISRelationships_Functions.SOLDTO
                                                                 },true);
    
        soldTo2 = TestObjects.newAccount('',new Map<String,String>{'ParentId'=>cHerky.Id,
                                                                   'SAP_Partner_Functions__c'=>CISRelationships_Functions.SOLDTO
                                                                  },true);
     
        shipTo = TestObjects.newAccount('',new Map<String,String>{'ParentId'=>cHerky.Id,
                                                                  'SAP_Partner_Functions__c'=>CISRelationships_Functions.SHIPTO
                                                                 },true);
        invalidAcc = TestObjects.newAccount('',true);

        CR1 = TestObjects.newCISRelationships('ShipTo',new Map<String,String>{'Source_Customer__c'=>shipTo.Id,
                                                                        'Target_Customer__c'=>shipTo.Id,
                                                                        'Customer_Number__c'=>shipTo.AccountNumber,
                                                                        'Ext_Unique_ID_c__c'=>(shipTo.Id + shipTo.AccountNumber + salesArea + CISRelationships_Functions.SHIPTO)
                                                                       },true);


        CR2 = TestObjects.newCISRelationships('SoldTo',new Map<String,String>{'Source_Customer__c'=>shipTo.Id,
                                                                        'Target_Customer__c'=>soldTo.Id,
                                                                        'Customer_Number__c'=>shipTo.AccountNumber,
                                                                        'Ext_Unique_ID_c__c'=>(shipTo.Id + shipTo.AccountNumber + salesArea + CISRelationships_Functions.SOLDTO)
                                                                       },true);

        CR3 = TestObjects.newCISRelationships('SoldTo',new Map<String,String>{'Source_Customer__c'=>soldTo.Id,
                                                                        'Customer_Number__c'=>soldTo.AccountNumber,
                                                                        'Ext_Unique_ID_c__c'=>(soldTo.Id + soldTo.AccountNumber + salesArea + CISRelationships_Functions.SOLDTO)
                                                                       },true);

        CR4 = TestObjects.newCISRelationships('',new Map<String,String>{'Source_Customer__c'=>invalidAcc.Id,
                                                                  'Customer_Number__c'=>invalidAcc.AccountNumber,
                                                                  'Customer_Type__c'=>'invalidAcc',
                                                                  'Ext_Unique_ID_c__c'=>(invalidAcc.Id + invalidAcc.AccountNumber + salesArea + 'invalidAcc')
                                                                 },true);
        
        results.put('cHerky', cHerky);
        results.put('soldTo', soldTo);
        results.put('soldTo2', soldTo2);
        results.put('shipTo', shipTo);
        results.put('invalidAcc', invalidAcc);
        results.put('CR1', CR1);
        results.put('CR2', CR2);
        results.put('CR3', CR3);
        results.put('CR4', CR4);
        return results;
    }

    /**************************************************************************
     * Generate Pricing Conditions and Materials
     * 
     * Two method types: createPricingConditionsandMaterial(Account cHerky, Account soldTo, Account shipTo) and
     *                   createPricingConditionsandMaterial(Account cHerky, Account soldTo, Account shipTo, String matnum, String salesOrg, String distChan)
     *  
     * Implementation Code for :
    
        Map<String,SObject> testData = createPricingConditionsandMaterial(cHerky,soldTo,shipTo);
        // OR
        Map<String,SObject> testData = createPricingConditionsandMaterial(cHerky,soldTo,shipTo,'010000000123456789','1234','12');
        Material_Sales_Data2__c msd2 = testData.get('msd2');
        Pricing_Condition__c priceCond1 = testData.get('priceCond1');
        Pricing_Condition__c priceCond2 = testData.get('priceCond2');
        Pricing_Condition__c priceCond3 = testData.get('priceCond3');
        
     ***************************************************************************/
    public static Map<String,SObject> createPricingConditionsandMaterial(Account cHerky, Account soldTo, Account shipTo) {
        String matnum = '010000000123456789';
        String salesOrg = '1234';
        String distChan = '12';
        return createPricingConditionsandMaterial(cHerky, soldTo, shipTo, matnum, salesOrg, distChan);      
    }
    
    public static Map<String,SObject> createPricingConditionsandMaterial(Account cHerky, Account soldTo, Account shipTo, String matnum, String salesOrg, String distChan) {
        Map<String,SObject> results = new Map<String,SObject>();
        Material_Sales_Data2__c msd2;
        Pricing_Condition__c priceCond1, priceCond2, priceCond3;

        msd2 = new Material_Sales_Data2__c();
        msd2.Material_Number__c = matnum;
        msd2.Sales_Org_Code__c = salesOrg;
        msd2.Dist_Channel_Code__c = distChan;
        msd2.Record_Key__c = matnum + salesOrg + distChan;
        insert msd2;

        Date fdate1 = System.today();
        Date tdate1 = fdate1.addDays(30);
        priceCond1 = new Pricing_Condition__c();
        priceCond1.Account__c = shipTo.Id;
        priceCond1.Material2__c = msd2.Id;
        priceCond1.Valid_From_Date__c = fdate1;
        priceCond1.Valid_To_Date__c = tdate1;
        priceCond1.Selling_Price__c = 10.0;
        insert priceCond1;

        priceCond2 = new Pricing_Condition__c();
        priceCond2.Account__c = soldTo.Id;
        priceCond2.Material2__c = msd2.Id;
        priceCond2.Valid_From_Date__c = fdate1;
        priceCond2.Valid_To_Date__c = tdate1;
        priceCond2.Selling_Price__c = 10.0;
        insert priceCond2;

        priceCond3 = new Pricing_Condition__c();
        priceCond3.Account__c = cHerky.Id;
        priceCond3.Material2__c = msd2.Id;
        priceCond3.Valid_From_Date__c = fdate1;
        priceCond3.Valid_To_Date__c = tdate1;
        priceCond3.Selling_Price__c = 10.0;
        insert priceCond3;

        
        results.put('msd2', msd2);
        results.put('priceCond1', priceCond1);
        results.put('priceCond2', priceCond2);
        results.put('priceCond3', priceCond3);

        return results;     
    }
    
    /**************************************************************************
     * Generate Account, Plants, and Assets
     * 
     * Two method types: createAccountandPlantswithAssets()
     *  
     * Implementation Code for :
    
        private static Account plant1, plant2, acc1;
        private static Asset asset1;
        private static List<Asset> assets;
        private static Product2 equip1;

        Map<String,SObject> testData = TestScenarios.createAccountandPlantswithAssets();
        plant1 = (Account)testData.get('plant1');
        plant2 = (Account)testData.get('plant2');
        acc1 = (Account)testData.get('acc1');
        equip1 = (Product2)testData.get('equip1');
        asset1 = (Asset)testData.get('asset1');

     ***************************************************************************/
    public static Map<String,SObject> createAccountandPlantswithAssets() {
        Map<String,SObject> results = new Map<String,SObject>();

        Account plant1 = TestObjects.newAccount('',new Map<String,String>{'Name'=>'Test Asset Plant1'},false);
        Account plant2 = TestObjects.newAccount('',new Map<String,String>{'Name'=>'Test Asset Plant2'},false);
        Account acc1   = TestObjects.newAccount('',new Map<String,String>{'Name'=>'Test Asset Account1'},false);
        List<Account> accs = new List<Account>{acc1, plant1, plant2};
        insert accs;
        
        Product2 equip1 = TestObjects.newProduct2('',new Map<String,String>{'Name'=>'Test Asset Equipment1'},true);
        
        Asset asset1 = TestObjects.newAsset('',new Map<String,String>{'Name'=>'Test Asset 1',
                                                                      'AccountId'=>plant1.Id,
                                                                      'Product2Id'=>equip1.Id},true);
        
        List<Asset> assets = new List<Asset>();
        for (Integer i = 0; i < 100; i++) {
            Asset newAsset = TestObjects.newAsset('',new Map<String,String>{'Name'=>'Asset ' + i,
                                                                            'AccountId'=>plant1.Id,
                                                                            'Product2Id'=>equip1.Id},false);
            assets.add(newAsset);
        }
        insert assets;
        
        results.put('plant1', plant1);
        results.put('plant2', plant2);
        results.put('acc1', acc1);
        results.put('equip1', equip1);
        results.put('asset1', asset1);

        return results;     
    }
    
    /**************************************************************************
     * Generate Account, Case, AttachmentFolders and Attachments
     * 
     * Two method types: createAccountCaseandAttachmentFoldersandAttachments()
     *  
     * Implementation Code for :
    
        private static Account account;
        private static Case testCase;
        private static Attachment_Folder__c attachmentFolder1,attachmentFolder2,attachmentFolder3;
        private static Attachment attachment1,attachment2,attachment3;

        Map<String,SObject> testData = TestScenarios.createAccountCaseandAttachmentFoldersandAttachments();
        account = (Account)testData.get('account');
        testCase = (Case)testData.get('case');
        attachmentFolder1 = (Attachment_Folder__c)testData.get('attachmentFolder1');
        attachmentFolder2 = (Attachment_Folder__c)testData.get('attachmentFolder2');
        attachmentFolder3 = (Attachment_Folder__c)testData.get('attachmentFolder3');
        attachment1 = (Attachment)testData.get('attachment1');
        attachment2 = (Attachment)testData.get('attachment2');
        attachment3 = (Attachment)testData.get('attachment3');

     ***************************************************************************/
    public static Map<String,SObject> createAccountCaseandAttachmentFoldersandAttachments() {
        Map<String,SObject> results = new Map<String,SObject>();
        
        Account acc = TestObjects.newAccount('',new Map<String,String>{'Name'=>'TestAccount'},true);
        Case c = TestObjects.newCase('',new Map<String,String>{'Accountid'=>acc.Id},true);
        
        Attachment_Folder__c AF = TestObjects.newAttachment_Folder('',new Map<String,String>{'Account__c'=>acc.Id},true);
        Attachment_Folder__c AF2 = TestObjects.newAttachment_Folder('',new Map<String,String>{'Parent_Folder__c'=>AF.Id},true);
        Attachment_Folder__c AF3 = TestObjects.newAttachment_Folder('',new Map<String,String>{'Parent_Folder__c'=>AF2.Id},true);
        
        Blob b = Blob.valueOf('Test');
        Attachment a = TestObjects.newAttachment('',new Map<String,String>{'Name'=>'Test',
                                                                           'parentId'=>c.Id},false);
        a.body = b;
        insert a;                                                                          
        
        Attachment a1 = a.clone(false);
        a1.parentid = AF.id;
        insert a1;
        
        Attachment a2 = a.clone(false);
        a2.parentid = AF2.id;
        insert a2;
 
        Attachment a3 = a.clone(false);
        a3.parentid = AF3.id;
        insert a3;
        
        results.put('account', acc);
        results.put('case', c);
        results.put('attachmentFolder1', AF);
        results.put('attachmentFolder2', AF2);
        results.put('attachmentFolder3', AF3);
        results.put('attachment1', a1);
        results.put('attachment2', a2);
        results.put('attachment3', a3);

        return results;     
    }
    
    public static Map<String,SObject> createAccountswithDifferentRecordTypes() {
        Map<String,SObject> results = new Map<String,SObject>();
        
        results.put('AD_Chemicals',TestObjects.newAccount('',new Map<String,String>{'Name'=>'AD_Chemicals',
                                                                                    'RecordTypeId'=>RecordType_Functions.LookupRecordTypeId('Distribution Customer', 'Account'),
                                                                                    'SAP_Division_Desc__c'=>'Chemicals'
                                                                                   },true)
                                        );
               
        results.put('AD_Composites',TestObjects.newAccount('',new Map<String,String>{'Name'=>'AD_Composites',
                                                                                     'RecordTypeId'=>RecordType_Functions.LookupRecordTypeId('Aqualon Customer', 'Account'),
                                                                                     'SAP_Division_Desc__c'=>'Composites'
                                                                                    },true)
                                        );
               
        results.put('AD_Plastics',TestObjects.newAccount('',new Map<String,String>{'Name'=>'AD_Plastics',
                                                                                   'RecordTypeId'=>RecordType_Functions.LookupRecordTypeId('Aqualon Customer', 'Account'),
                                                                                   'SAP_Division_Desc__c'=>'Plastics'
                                                                                  },true)
                                        );
               
        results.put('AD_ES',TestObjects.newAccount('',new Map<String,String>{'Name'=>'AD_ES',
                                                                             'RecordTypeId'=>RecordType_Functions.LookupRecordTypeId('Aqualon Customer', 'Account'),
                                                                             'SAP_Division_Desc__c'=>'Environmental Svcs'
                                                                            },true)
                                        );
               
        results.put('PM_CAST',TestObjects.newAccount('',new Map<String,String>{'Name'=>'PM_CAST',
                                                                               'RecordTypeId'=>RecordType_Functions.LookupRecordTypeId('Aqualon Customer', 'Account'),
                                                                               'SAP_Division_Desc__c'=>'Castings Solutions'
                                                                              },true)
                                        );
               
        results.put('PM_COMP',TestObjects.newAccount('',new Map<String,String>{'Name'=>'PM_COMP',
                                                                               'RecordTypeId'=>RecordType_Functions.LookupRecordTypeId('Aqualon Customer', 'Account'),
                                                                               'SAP_Division_Desc__c'=>'Composite Polymers'
                                                                              },true)
                                        );
               
        results.put('PM_SPA',TestObjects.newAccount('',new Map<String,String>{'Name'=>'PM_SPA',
                                                                              'RecordTypeId'=>RecordType_Functions.LookupRecordTypeId('Aqualon Customer', 'Account'),
                                                                              'SAP_Division_Desc__c'=>'Specialty Poly & Adh'
                                                                             },true)
                                        );
               
        results.put('Valvoline_DIFM',TestObjects.newAccount('',new Map<String,String>{'Name'=>'Valvoline_DIFM',
                                                                                      'RecordTypeId'=>RecordType_Functions.LookupRecordTypeId('Aqualon Customer', 'Account'),
                                                                                      'SAP_Division_Desc__c'=>'DIFM'
                                                                                     },true)
                                        );
               
        results.put('Valvoline_DIY',TestObjects.newAccount('',new Map<String,String>{'Name'=>'Valvoline_DIY',
                                                                                     'RecordTypeId'=>RecordType_Functions.LookupRecordTypeId('Aqualon Customer', 'Account'),
                                                                                     'SAP_Division_Desc__c'=>'DIY'
                                                                                    },true)
                                        );
               
        results.put('Valvoline_DIY2',TestObjects.newAccount('',new Map<String,String>{'Name'=>'Valvoline_DIY2',
                                                                                      'RecordTypeId'=>RecordType_Functions.LookupRecordTypeId('Aqualon Customer', 'Account'),
                                                                                      'SAP_Division_Desc__c'=>'DIY'
                                                                                     },true)
                                        );
               
        results.put('Valvoline_Specialty',TestObjects.newAccount('',new Map<String,String>{'Name'=>'Valvoline_Specialty',
                                                                                           'RecordTypeId'=>RecordType_Functions.LookupRecordTypeId('Aqualon Customer', 'Account'),
                                                                                           'SAP_Division_Desc__c'=>'SPECIALTY'
                                                                                          },true)
                                        );
               
        results.put('Water',TestObjects.newAccount('',new Map<String,String>{'Name'=>'Water',
                                                                             'RecordTypeId'=>RecordType_Functions.LookupRecordTypeId('Water Prospect', 'Account')
                                                                            },true)
                                        );
               
        results.put('Water_Drew',TestObjects.newAccount('',new Map<String,String>{'Name'=>'Water_Drew',
                                                                                  'RecordTypeId'=>RecordType_Functions.LookupRecordTypeId('Drew Customer', 'Account')
                                                                                 },true)
                                        );
               
        return results;     
    }
 
    public static Map<String,SObject> createDistChannelandCustGroups() {
        Map<String,SObject> results = new Map<String,SObject>();
 
        SAP_Distribution_Channel__c distchan = TestObjects.newSAP_Distribution_Channel();
        SAP_Customer_Group__c custgrp = TestObjects.newSAP_Customer_Group();
        SAP_Customer_Group1__c custgrp1 = TestObjects.newSAP_Customer_Group1();
        Customer_Group__c customerGroup =  TestObjects.newCustomer_Group(new Map<String,String>{'SAP_Customer_Group__c'=>custgrp.Id,
                                                                                                'SAP_Distribution_Channel__c'=>distchan.Id});
        
        results.put('distchan', distchan);
        results.put('custgrp', custgrp);
        results.put('custgrp1', custgrp1);
        results.put('customerGroup', customerGroup);
 
        return results;
    }
    
    /*
    private static Material_Sales_Data2__c msd2;   
    private static SAP_Sales_Org__c so;
    private static SAP_Distribution_Channel__c dc;
    private static Material_Description__c md;
    private static Material_General_Data2__c mgd2;
    private static Product_Hierarchy__c ph_1, ph_2, ph_3, ph_4, ph_5, ph_6, ph_7;
    private static Product_Hierarchy2__c ph2;
    private static Material_Pricing_Group1__c mg1;
    private static Material_Pricing_Group2__c mg2;
    private static SAP_Valuation_Area__c va;
    private static SAP_Plant__c sp;
    private static Material_Plant2__c mp2;
    private static Material_Valuation__c mv;
    private static Material_General_Data__c mgd;
    private static Material_Sales_Data__c msd;
    private static Group g;
    private static List<Material_UOM2__c> mu2s = new List<Material_UOM2__c>();
    private static List<Material_General_Data__c> mgda = new List<Material_General_Data__c>();
    private static List<Material_Sales_Data__c> msda = new List<Material_Sales_Data__c>();
    
        Map<String,SObject> testData = TestScenarios.createMaterialSalesDataEnv();
        msd2 = (Material_Sales_Data2__c)testData.get('materialSalesData2');
        so = (SAP_Sales_Org__c)testData.get('sapSalesOrg');
        dc = (SAP_Distribution_Channel__c)testData.get('sapDistributionChannel');
        md = (Material_Description__c)testData.get('materialDescription');
        mgd2 = (Material_General_Data2__c)testData.get('materialGeneralData2');
        ph_1 = (Product_Hierarchy__c)testData.get('productHierarchy_1');
        ph_2 = (Product_Hierarchy__c)testData.get('productHierarchy_2');
        ph_3 = (Product_Hierarchy__c)testData.get('productHierarchy_3');
        ph_4 = (Product_Hierarchy__c)testData.get('productHierarchy_4');
        ph_5 = (Product_Hierarchy__c)testData.get('productHierarchy_5');
        ph_6 = (Product_Hierarchy__c)testData.get('productHierarchy_6');
        ph_7 = (Product_Hierarchy__c)testData.get('productHierarchy_7');
        ph2 = (Product_Hierarchy2__c)testData.get('productHierarchy2');
        mg1 = (Material_Pricing_Group1__c)testData.get('materialPricingGroup1');
        mg2 = (Material_Pricing_Group2__c)testData.get('materialPricingGroup2');
        va = (SAP_Valuation_Area__c)testData.get('sapValuationArea');
        sp = (SAP_Plant__c)testData.get('sapPlant');
        mp2 = (Material_Plant2__c)testData.get('materialPlant2');
        mv = (Material_Valuation__c)testData.get('materialValuation');
        mgd = (Material_General_Data__c)testData.get('materialGeneralData');
        msd = (Material_Sales_Data__c)testData.get('materialSalesData');
        g = (Group)testData.get('group');
        
        mgda.add(mgd);
        msda.add(msd);
    
    */
    public static Map<String,SObject> createMaterialSalesDataEnv() {
        Map<String,SObject> results = new Map<String,SObject>();
        
        Account acc1;
        Material_Sales_Data2__c msd2;   
        SAP_Sales_Org__c so;
        SAP_Distribution_Channel__c dc;
        Material_Description__c md;
        Material_General_Data2__c mgd2;
        Product_Hierarchy__c ph_1, ph_2, ph_3, ph_4, ph_5, ph_6, ph_7;
        Product_Hierarchy2__c ph2;
        Material_Pricing_Group1__c mg1;
        Material_Pricing_Group2__c mg2;
        SAP_Valuation_Area__c va;
        SAP_Plant__c sp;
        Material_Plant2__c mp2;
        Material_Valuation__c mv;
        Group g;
        Material_General_Data__c mgd;
        Material_Sales_Data__c msd;
        Sample_Request__c sr1;
        Sample_Material__c sm1;
        Open_Orders__c oo1;
        Sales_Order_Deliveries__c od1;
        List<Material_UOM2__c> mu2s = new List<Material_UOM2__c>();
        List<Material_General_Data__c> mgda = new List<Material_General_Data__c>();
        List<Material_Sales_Data__c> msda = new List<Material_Sales_Data__c>();
        
        String lang     = 'E';
        String matnumbr = '010000000123456789';
        String plant    = '1234';
        String salesOrg = '1234';
        String distChan = '10';
        String matgrp1  = 'MG1';
        String matgrp2  = 'MG2';
        String salesUom = 'UM1';
        List<String> matUoms = new List<String>{'UM1', 'UM2'};
        
        acc1 = TestObjects.newAccount();
        
        so = TestObjects.newSAP_Sales_Org(new Map<String,String>{'Sales_Org_Code__c'=>salesOrg,
                                                                 'Language_Code__c'=>lang});
                                                                 
        dc = TestObjects.newSAP_Distribution_Channel(new Map<String,String>{'Distribution_Channel_Code__c'=>distChan,
                                                                            'Language_Code__c'=>lang});
                                                                            
        md = TestObjects.newMaterial_Description(new Map<String,String>{'Language_Code__c'=>lang,
                                                                        'Material_Number__c'=>matnumbr,
                                                                        'Material_Description__c'=>'TestMaterial'});
                                                                        
        mgd2 = TestObjects.newMaterial_General_Data2(new Map<String,String>{'Material_Number__c'=>matnumbr});

        Map<String,SObject> phData = createProductHierarchy();
        ph_1 = (Product_Hierarchy__c)phData.get('productHierarchy_1');
        ph_2 = (Product_Hierarchy__c)phData.get('productHierarchy_2');
        ph_3 = (Product_Hierarchy__c)phData.get('productHierarchy_3');
        ph_4 = (Product_Hierarchy__c)phData.get('productHierarchy_4');
        ph_5 = (Product_Hierarchy__c)phData.get('productHierarchy_5');
        ph_6 = (Product_Hierarchy__c)phData.get('productHierarchy_6');
        ph_7 = (Product_Hierarchy__c)phData.get('productHierarchy_7');
        ph2 = (Product_Hierarchy2__c)phData.get('productHierarchy2');
        
        
        /*
        ph_1 = TestObjects.newProduct_Hierarchy(new Map<String,String>{'Language_Code__c'=>lang,'Product_Hierarchy_Code__c'=>ph1code});
        ph_2 = TestObjects.newProduct_Hierarchy(new Map<String,String>{'Language_Code__c'=>lang,'Product_Hierarchy_Code__c'=>ph2code});
        ph_3 = TestObjects.newProduct_Hierarchy(new Map<String,String>{'Language_Code__c'=>lang,'Product_Hierarchy_Code__c'=>ph3code});
        ph_4 = TestObjects.newProduct_Hierarchy(new Map<String,String>{'Language_Code__c'=>lang,'Product_Hierarchy_Code__c'=>ph4code});
        ph_5 = TestObjects.newProduct_Hierarchy(new Map<String,String>{'Language_Code__c'=>lang,'Product_Hierarchy_Code__c'=>ph5code});
        ph_6 = TestObjects.newProduct_Hierarchy(new Map<String,String>{'Language_Code__c'=>lang,'Product_Hierarchy_Code__c'=>ph6code});
        ph_7 = TestObjects.newProduct_Hierarchy(new Map<String,String>{'Language_Code__c'=>lang,'Product_Hierarchy_Code__c'=>ph7code});

        ph2 = TestObjects.newProduct_Hierarchy2(new Map<String,String>{'Product_Hierarchy__c'=>ph_7.Product_Hierarchy_Code__c,
                                                                       'Product_Hierarchy1__c'=>ph_1.Id,
                                                                       'Product_Hierarchy2__c'=>ph_2.Id,
                                                                       'Product_Hierarchy3__c'=>ph_3.Id,
                                                                       'Product_Hierarchy4__c'=>ph_4.Id,
                                                                       'Product_Hierarchy5__c'=>ph_5.Id,
                                                                       'Product_Hierarchy6__c'=>ph_6.Id,
                                                                       'Product_Hierarchy7__c'=>ph_7.Id});
        */                                                                       
        
        for (String s : matuoms) {
            Material_UOM2__c mu2 = TestObjects.newMaterial_UOM2(new Map<String,String>{'Alternative_UOM__c'=>s,
                                                                                       'Material_Number__c'=>matnumbr,
                                                                                       'Record_Key__c'=>matnumbr + s},false);
            mu2s.add(mu2);
        }
        insert mu2s;
        
        mg1 = TestObjects.newMaterial_Pricing_Group1(new Map<String,String>{'Language_Code__c'=>lang,
                                                                            'Material_Pricing_Group1_Code__c'=>matgrp1,
                                                                            'Material_Pricing_Group1_Description__c'=>'Test Material Group1'});
                                                                            
        mg2 = TestObjects.newMaterial_Pricing_Group2(new Map<String,String>{'Language_Code__c'=>lang,
                                                                            'Material_Pricing_Group2_Code__c'=>matgrp2,
                                                                            'Material_Pricing_Group2_Description__c'=>'Test Material Group2'});
                                                                            
        va = TestObjects.newSAP_Valuation_Area(new Map<String,String>{'Company_Code__c'=>salesOrg,
                                                                      'Valuation_Area__c'=>plant});
                                                                      
        sp = TestObjects.newSAP_Plant(new Map<String,String>{'Plant_Code__c'=>plant});
        
        mp2 = TestObjects.newMaterial_Plant2(new Map<String,String>{'Material_Number__c'=>mgd2.Material_Number__c,
                                                                    'Plant_Code__c'=>sp.Plant_Code__c,
                                                                    'SalesOrg_Code__c'=>so.Sales_Org_Code__c,
                                                                    'Record_Key__c'=>mgd2.Material_Number__c + sp.Plant_Code__c + so.Sales_Org_Code__c,
                                                                    'Material_General_Data__c'=>mgd2.Id,
                                                                    'SAP_Plant__c'=>sp.Id,
                                                                    'SAP_Sales_Org__c'=>so.Id});
                                                                    
        mv = TestObjects.newMaterial_Valuation(new Map<String,String>{'Material_Number__c'=>matnumbr,                       
                                                                      'Price_Control_Indicator__c'=>'S',
                                                                      'Record_Key__c'=>matnumbr + plant,
                                                                      'Valuation_Area__c'=>plant},false);
        mv.Price_Unit__c = 100.0;
        mv.Standard_Price__c = 1234.56;
        insert mv;
        
        msd2 = TestObjects.newMaterial_Sales_Data2(new Map<String,String>{'Material_Number__c'=>matnumbr,
                                                                          'Sales_Org_Code__c'=>salesOrg,
                                                                          'Dist_Channel_Code__c'=>distChan,
                                                                          'Material_Group1_Code__c'=>matgrp1,
                                                                          'Material_Group2_Code__c'=>matgrp2,
                                                                          'Record_Key__c'=>matnumbr + salesOrg + distChan,
                                                                          'SalesOrg_Code__c'=>so.Id,
                                                                          'DistChannel_Code__c'=>dc.Id,
                                                                          'Material_General_Data__c'=>mgd2.Id,
                                                                          'Product_Hierarchy__c'=>ph2.Id,
                                                                          'Sales_UOM__c'=>mu2s[0].Id});
        
        mgd = TestObjects.newMaterial_General_Data(new Map<String,String>{'Material_Number__c'=>matnumbr},false);

        msd = TestObjects.newMaterial_Sales_Data(new Map<String,String>{'Material_Number__c'=>matnumbr,
                                                                        'Sales_Org__c'=>salesOrg,
                                                                        'Distribution_Channel__c'=>distChan,
                                                                        'Material_Group1__c'=>'MG1',
                                                                        'Material_Group2__c'=>'MG2',
                                                                        'Record_Key__c'=>matnumbr + salesOrg + distChan,
                                                                        'Sales_Unit__c'=>'UM1',
                                                                        'Product_Hierarchy__c'=>ph_7.Product_Hierarchy_Code__c},false);

        g = TestObjects.newGroup(new Map<String,String>{'Name'=>'Test Group'});
        
        sr1 = TestObjects.newSample_Request(new Map<String,String>{'Account__c'=>acc1.Id});
        
        sm1 = TestObjects.newSample_Material(new Map<String,String>{'Sample_Request__c'=>sr1.Id,
                                                                    'SAP_Material_MSD2__c'=>msd2.Id});

        oo1 = TestObjects.newOpen_Orders(new Map<String,String>{'Key__c'=>'RecordKey1',
                                                                'SFDC_Sample_Request_Number__c'=>sr1.Name,
                                                                'ShipTo__c'=>sr1.Account__c,
                                                                'Line_Item_Number__c'=>'0001',
                                                                'Sales_Order_Number__c'=>'0001'});
                                                                
        od1 = TestObjects.newSales_Order_Deliveries(new Map<String,String>{'Actual_Goods_Issue_Date_Text__c'=>'2012-12-12',
                                                                           'ShipTo__c'=>sr1.Account__c,
                                                                           'Material__c'=>sm1.SAP_Material_MSD2__c,
                                                                           'Open_Orders__c'=>oo1.Id,
                                                                           'Record_Key__c'=>'RecordKey1'});                                                             
                                                                                  
        results.put('account', acc1);
        results.put('materialSalesData2', msd2);
        results.put('sapSalesOrg', so);
        results.put('sapDistributionChannel', dc);
        results.put('materialDescription', md);
        results.put('materialGeneralData2', mgd2);
        results.put('productHierarchy_1', ph_1);
        results.put('productHierarchy_2', ph_2);
        results.put('productHierarchy_3', ph_3);
        results.put('productHierarchy_4', ph_4);
        results.put('productHierarchy_5', ph_5);
        results.put('productHierarchy_6', ph_6);
        results.put('productHierarchy_7', ph_7);
        results.put('productHierarchy2', ph2);
        results.put('materialPricingGroup1', mg1);
        results.put('materialPricingGroup2', mg2);
        results.put('sapValuationArea', va);
        results.put('sapPlant', sp);
        results.put('materialPlant2', mp2);
        results.put('materialValuation', mv);
        results.put('materialGeneralData', mgd);
        results.put('materialSalesData', msd);
        results.put('group', g);
        results.put('sampleRequest', sr1);
        results.put('sampleMaterial', sm1);
        results.put('openOrders', oo1);
        results.put('salesOrderDeliveries', od1);

        return results;     
    }
    
    public static Map<String,SObject> createProductHierarchy() {
        Integer idx = newUniqueIdx();

        String lang     = 'E';
        String ph1code  = '!' + idx;
        String ph2code  = '!23' + idx;
        String ph3code  = '!23456' + idx;
        String ph4code  = '!23456789' + idx;
        String ph5code  = '!23456789123' + idx;
        String ph6code  = '!23456789123456' + idx;
        String ph7code  = '!23456789123456789' + idx;
        
        return createProductHierarchy(lang, ph1code, ph2code, ph3code, ph4code, ph5code, ph6code, ph7code);
    }
    
    public static Map<String,SObject> createProductHierarchy(String lang, String ph1code, String ph2code, String ph3code, String ph4code, String ph5code, String ph6code, String ph7code) {
        Map<String,SObject> results = new Map<String,SObject>();
        
        Product_Hierarchy__c ph_1, ph_2, ph_3, ph_4, ph_5, ph_6, ph_7;
        Product_Hierarchy2__c ph2;
        
        ph_1 = TestObjects.newProduct_Hierarchy(new Map<String,String>{'Language_Code__c'=>lang,'Product_Hierarchy_Code__c'=>ph1code});
        ph_2 = TestObjects.newProduct_Hierarchy(new Map<String,String>{'Language_Code__c'=>lang,'Product_Hierarchy_Code__c'=>ph2code});
        ph_3 = TestObjects.newProduct_Hierarchy(new Map<String,String>{'Language_Code__c'=>lang,'Product_Hierarchy_Code__c'=>ph3code});
        ph_4 = TestObjects.newProduct_Hierarchy(new Map<String,String>{'Language_Code__c'=>lang,'Product_Hierarchy_Code__c'=>ph4code});
        ph_5 = TestObjects.newProduct_Hierarchy(new Map<String,String>{'Language_Code__c'=>lang,'Product_Hierarchy_Code__c'=>ph5code});
        ph_6 = TestObjects.newProduct_Hierarchy(new Map<String,String>{'Language_Code__c'=>lang,'Product_Hierarchy_Code__c'=>ph6code});
        ph_7 = TestObjects.newProduct_Hierarchy(new Map<String,String>{'Language_Code__c'=>lang,'Product_Hierarchy_Code__c'=>ph7code});

        ph2 = TestObjects.newProduct_Hierarchy2(new Map<String,String>{'Product_Hierarchy__c'=>ph_7.Product_Hierarchy_Code__c,
                                                                       'Product_Hierarchy1__c'=>ph_1.Id,
                                                                       'Product_Hierarchy2__c'=>ph_2.Id,
                                                                       'Product_Hierarchy3__c'=>ph_3.Id,
                                                                       'Product_Hierarchy4__c'=>ph_4.Id,
                                                                       'Product_Hierarchy5__c'=>ph_5.Id,
                                                                       'Product_Hierarchy6__c'=>ph_6.Id,
                                                                       'Product_Hierarchy7__c'=>ph_7.Id});
        
    
        results.put('productHierarchy_1', ph_1);
        results.put('productHierarchy_2', ph_2);
        results.put('productHierarchy_3', ph_3);
        results.put('productHierarchy_4', ph_4);
        results.put('productHierarchy_5', ph_5);
        results.put('productHierarchy_6', ph_6);
        results.put('productHierarchy_7', ph_7);
        results.put('productHierarchy2', ph2);
    
        return results;     
    }
    
    public static Map<String,SObject> createTwoPriceBooks() {
        Map<String,SObject> results = new Map<String,SObject>();

        SAP_Distribution_Channel__c distChan = TestObjects.newSAP_Distribution_Channel(new Map<String,String>{'Distribution_Channel_Code__c'=>'10'});
        SAP_Sales_Division__c div = TestObjects.newSAP_Sales_Division(new Map<String,String>{'Sales_Division_Code__c'=>'11'});
        SAP_Country_Name__c region1 = TestObjects.newSAP_Country_Name(new Map<String,String>{'Country_Code__c'=>'R1'});
        SAP_Country_Name__c region2 = TestObjects.newSAP_Country_Name(new Map<String,String>{'Country_Code__c'=>'R2'});
        SAP_Sales_Org__c salesOrg1 = TestObjects.newSAP_Sales_Org(new Map<String,String>{'Sales_Org_Code__c'=>'0000'});
        SAP_Sales_Org__c salesOrg2 = TestObjects.newSAP_Sales_Org(new Map<String,String>{'Sales_Org_Code__c'=>'0002'});
        SAP_Customer_Group__c customerGroup1 = TestObjects.newSAP_Customer_Group(new Map<String,String>{'Customer_Group_Code__c'=>'00'});
        SAP_Customer_Group__c customerGroup2 = TestObjects.newSAP_Customer_Group(new Map<String,String>{'Customer_Group_Code__c'=>'02'});

        Product_Hierarchy__c ph_1, ph_2, ph_3, ph_4, ph_5, ph_6, ph_7;
        Product_Hierarchy2__c ph2;

        Map<String,SObject> phData = createProductHierarchy();
        ph_1 = (Product_Hierarchy__c)phData.get('productHierarchy_1');
        ph_2 = (Product_Hierarchy__c)phData.get('productHierarchy_2');
        ph_3 = (Product_Hierarchy__c)phData.get('productHierarchy_3');
        ph_4 = (Product_Hierarchy__c)phData.get('productHierarchy_4');
        ph_5 = (Product_Hierarchy__c)phData.get('productHierarchy_5');
        ph_6 = (Product_Hierarchy__c)phData.get('productHierarchy_6');
        ph_7 = (Product_Hierarchy__c)phData.get('productHierarchy_7');
        ph2 = (Product_Hierarchy2__c)phData.get('productHierarchy2');

        Material_Sales_Data2__c material1 = TestObjects.newMaterial_Sales_Data2(new Map<String,String>{'Product_Hierarchy__c'=>ph2.Id});
//          Material_Sales_Data2__c material2 = TestObjects.newMaterial_Sales_Data2(new Map<String,String>{'Product_Hierarchy__c'=>ph2.Id});

        Map<String,SObject> pb1Data = createPriceBookwithEntries(true,'pb desc 1',distChan,div,region1,'000','PL1',salesOrg1,customerGroup1,material1,System.today().addDays(-30),'Active');
        Map<String,SObject> pb2Data = createPriceBookwithEntries(false,'pb desc 2',distChan,div,region2,'002','PL2',salesOrg2,customerGroup2,material1,System.today().addDays(-30),'Approved but not Active yet');

        results.put('distChan', distChan);
        results.put('div', div);
        results.put('region1', region1);
        results.put('region2', region2);
        results.put('salesOrg1', salesOrg1);
        results.put('salesOrg2', salesOrg2);
        results.put('customerGroup1', customerGroup1);
        results.put('customerGroup2', customerGroup2);

        results.put('pb1', pb1Data.get('priceBook'));
        results.put('pb1ParentAccount', pb1Data.get('parentAccount'));
        results.put('pb1ChildAccount', pb1Data.get('childAccount'));
        results.put('pb1Region1', pb1Data.get('pbRegion1'));
        results.put('pb1Region2', pb1Data.get('pbRegion2'));
        results.put('pb1Family1', pb1Data.get('pbFamily1'));
        results.put('pb1Family2', pb1Data.get('pbFamily2'));
        results.put('pb1ProductLine1', pb1Data.get('pbProductLine1'));
        results.put('pb1ProductLine2', pb1Data.get('pbProductLine2'));
        results.put('pb1SalesOrg1', pb1Data.get('pbSalesOrg1'));
        results.put('pb1SalesOrg2', pb1Data.get('pbSalesOrg2'));
        results.put('pb1CustomerGroup1', pb1Data.get('pbCustomerGroup1'));
        results.put('pb1CustomerGroup2', pb1Data.get('pbCustomerGroup2'));

        results.put('pb2', pb2Data.get('priceBook'));
        results.put('pb2ParentAccount', pb2Data.get('parentAccount'));
        results.put('pb2ChildAccount', pb2Data.get('childAccount'));
        results.put('pb2Region1', pb1Data.get('pbRegion1'));
        results.put('pb2Region2', pb1Data.get('pbRegion2'));
        results.put('pb2Family1', pb1Data.get('pbFamily1'));
        results.put('pb2Family2', pb1Data.get('pbFamily2'));
        results.put('pb2ProductLine1', pb1Data.get('pbProductLine1'));
        results.put('pb2ProductLine2', pb1Data.get('pbProductLine2'));
        results.put('pb2SalesOrg1', pb1Data.get('pbSalesOrg1'));
        results.put('pb2SalesOrg2', pb1Data.get('pbSalesOrg2'));
        results.put('pb2CustomerGroup1', pb1Data.get('pbCustomerGroup1'));
        results.put('pb2CustomerGroup2', pb1Data.get('pbCustomerGroup2'));

        results.put('material', material1);

        return results;     
    }
    
    public static Map<String,SObject> createPriceBookwithEntries(Boolean active, 
                                                                 String description, 
                                                                 SAP_Distribution_Channel__c distChan, 
                                                                 SAP_Sales_Division__c div, 
                                                                 SAP_Country_Name__c region, 
                                                                 String familyCode, 
                                                                 String prodLineCode, 
                                                                 SAP_Sales_Org__c salesOrg, 
                                                                 SAP_Customer_Group__c customerGroup,
                                                                 Material_Sales_Data2__c material, 
                                                                 Date effectiveDate, 
                                                                 String recordStatus) {
        Map<String,SObject> results = new Map<String,SObject>();

        
        /*
        SAP_Distribution_Channel__c distChan = TestObjects.newSAP_Distribution_Channel(new Map<String,String>{'Distribution_Channel_Code__c'=>distChanCode});
        SAP_Sales_Division__c div = TestObjects.newSAP_Sales_Division(new Map<String,String>{'Sales_Division_Code__c'=>divisionCode});
        SAP_Country_Name__c region = TestObjects.newSAP_Country_Name(new Map<String,String>{'Country_Code__c'=>regionCode});
        SAP_Sales_Org__c salesOrg = TestObjects.newSAP_Sales_Org(new Map<String,String>{'Sales_Org_Code__c'=>salesOrgCode});
        SAP_Customer_Group__c customerGroup = TestObjects.newSAP_Customer_Group(new Map<String,String>{'Customer_Group_Code__c'=>customerGroupCode});
        Material_Sales_Data2__c material = TestObjects.newMaterial_Sales_Data2(new Map<String,String>{'Product_Hierarchy__c'=>ph2.Id});
        */
        
        Price_Book__c priceBook = TestObjects.newPrice_Book(false);
        priceBook.Active__c = active;
        priceBook.Description__c = description;
        priceBook.Dist_Channel__c = distChan.Id;
        priceBook.Division__c = div.Id;
        priceBook.Effective_Date__c = effectiveDate;
        priceBook.Record_Status__c = recordStatus;
        insert priceBook;
        
        Price_Book_Region__c pbRegion1 = TestObjects.newPrice_Book_Region(new Map<String,String>{'Price_Book__c'=>priceBook.Id,
                                                                                                 'SAP_Region__c'=>region.Id});

        Price_Book_Region__c pbRegion2 = TestObjects.newPrice_Book_Region(new Map<String,String>{'Price_Book__c'=>priceBook.Id,
                                                                                                 'SAP_Region__c'=>region.Id});

        Price_Book_Family__c pbFamily1 = TestObjects.newPrice_Book_Family(new Map<String,String>{'Price_Book__c'=>priceBook.Id,
                                                                                                 'Family_Code__c'=>familyCode});

        Price_Book_Family__c pbFamily2 = TestObjects.newPrice_Book_Family(new Map<String,String>{'Price_Book__c'=>priceBook.Id,
                                                                                                 'Family_Code__c'=>familyCode});

        Price_Book_Product_Line__c pbProductLine1 = TestObjects.newPrice_Book_Product_Line(new Map<String,String>{'Price_Book__c'=>priceBook.Id,
                                                                                                                  'Product_Line_Code__c'=>prodLineCode});

        Price_Book_Product_Line__c pbProductLine2 = TestObjects.newPrice_Book_Product_Line(new Map<String,String>{'Price_Book__c'=>priceBook.Id,
                                                                                                                  'Product_Line_Code__c'=>prodLineCode});

        Price_Book_Sales_Org__c pbSalesOrg1 = TestObjects.newPrice_Book_Sales_Org(new Map<String,String>{'Price_Book__c'=>priceBook.Id,
                                                                                                         'SAP_Sales_Org__c'=>salesOrg.Id});

        Price_Book_Sales_Org__c pbSalesOrg2 = TestObjects.newPrice_Book_Sales_Org(new Map<String,String>{'Price_Book__c'=>priceBook.Id,
                                                                                                         'SAP_Sales_Org__c'=>salesOrg.Id});

        Price_Book_Customer_Group__c pbCustomerGroup1 = TestObjects.newPrice_Book_Customer_Group(new Map<String,String>{'Price_Book__c'=>priceBook.Id,
                                                                                                                        'SAP_Customer_Group__c'=>customerGroup.Id});

        Price_Book_Customer_Group__c pbCustomerGroup2 = TestObjects.newPrice_Book_Customer_Group(new Map<String,String>{'Price_Book__c'=>priceBook.Id,
                                                                                                                        'SAP_Customer_Group__c'=>customerGroup.Id});

        Price_Book_Entry__c pbEntry = TestObjects.newPrice_Book_Entry(new Map<String,String>{'Material_Sales_Data2__c'=>material.Id,
                                                                                             'Price_Book__c'=>priceBook.Id});

        Price_Book_Entry_Scaled_Pricing__c pbEntryScaledPricing = TestObjects.newPrice_Book_Entry_Scaled_Pricing(new Map<String,String>{'Price_Book_Entry__c'=>pbEntry.Id});

        Price_Book_Service__c pbService = TestObjects.newPrice_Book_Service(new Map<String,String>{'Price_Book__c'=>priceBook.Id});

        Account parentAccount = TestObjects.newAccount(new Map<String,String>{'SAP_Sales_Org__c'=>salesOrg.Sales_Org_Code__c,
                                                                              'SAP_DistChannel__c'=>distChan.Distribution_Channel_Code__c,
                                                                              'SAP_DivisionCode__c'=>div.Sales_Division_Code__c,
                                                                              'SAP_Region__c'=>region.Country_Code__c,
                                                                              'SAP_Customer_Group__c'=>customerGroup.Customer_Group_Code__c});

        Account childAccount = TestObjects.newAccount(new Map<String,String>{'SAP_Sales_Org__c'=>salesOrg.Sales_Org_Code__c,
                                                                             'SAP_DistChannel__c'=>distChan.Distribution_Channel_Code__c,
                                                                             'SAP_DivisionCode__c'=>div.Sales_Division_Code__c,
                                                                             'SAP_Region__c'=>region.Country_Code__c,
                                                                             'SAP_Customer_Group__c'=>customerGroup.Customer_Group_Code__c,
                                                                             'parentId'=>parentAccount.Id});

        CISRelationships__c CR = TestObjects.newCISRelationships('SoldTo',new Map<String,String>{'Source_Customer__c'=>childAccount.Id,
                                                                 'Target_Customer__c'=>parentAccount.Id,
                                                                 'Customer_Number__c'=>childAccount.AccountNumber,
                                                                 'Ext_Unique_ID_c__c'=>(childAccount.Id + childAccount.AccountNumber + '000' + CISRelationships_Functions.SOLDTO)},true);

        
/*  
        results.put('productHierarchy_1', ph_1);
        results.put('productHierarchy_2', ph_2);
        results.put('productHierarchy_3', ph_3);
        results.put('productHierarchy_4', ph_4);
        results.put('productHierarchy_5', ph_5);
        results.put('productHierarchy_6', ph_6);
        results.put('productHierarchy_7', ph_7);
        results.put('productHierarchy2', ph2);
        results.put('material', material);
        results.put('distChan', distChan);
        results.put('div', div);
        results.put('region', region);
        results.put('salesOrg', salesOrg);
        results.put('customerGroup', customerGroup);
*/      
        results.put('parentAccount', parentAccount);
        results.put('childAccount', childAccount);
        results.put('priceBook', priceBook);
        results.put('pbRegion1', pbRegion1);
        results.put('pbRegion2', pbRegion2);
        results.put('pbFamily1', pbFamily1);
        results.put('pbFamily2', pbFamily2);
        results.put('pbProductLine1', pbProductLine1);
        results.put('pbProductLine2', pbProductLine2);
        results.put('pbSalesOrg1', pbSalesOrg1);
        results.put('pbSalesOrg2', pbSalesOrg2);
        results.put('pbCustomerGroup1', pbCustomerGroup1);
        results.put('pbCustomerGroup2', pbCustomerGroup2);
        results.put('pbEntry', pbEntry);
        results.put('pbEntryScaledPricing', pbEntryScaledPricing);
        results.put('pbService', pbService);

        return results;     
        
    }
}
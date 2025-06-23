@IsTest
public with sharing class Chemical_Inventory_Trigger_Util_Test {
    
    @TestSetup
    private static void setupData() {
        System.debug('----> Start testUp');
        PriceFx__c priceFx = new PriceFx__c(
                Name = 'callAccount',
                EndpointURL__c = 'test.com',
                password__c = 'abc123',
                username__c = 'Joe',
                Allowed_Sales_Org__c = '1,2',
                Allowed_recordType_Id__c = 'a,b'
        );
        insert priceFx;

        PriceFx__c priceFx2 = new PriceFx__c(
                Name = 'callMaterialSalesData2',
                EndpointURL__c = 'test.com',
                password__c = 'abc123',
                username__c = 'Joe',
                Allowed_Sales_Org__c = '1,2',
                Allowed_recordType_Id__c = 'a,b'
        );
        insert priceFx2;
        
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Material_Sales_Data2__c material = new Material_Sales_Data2__c(Name = 'SWE-Z68 DRUM 200KG C - 874315',
                                                                       Dist_Channel_Code__c = 'MA',
                                                                       Material_Number__c = '123',
                                                                       Record_Key__c = 'test record key',
                                                                       Sales_Org_Code__c = '1020');
        insert material;
        
        Chemical_Container__c container = new Chemical_Container__c(Account__c = acc.Id,
                                                                    Sales_Org_Region__c = '1020',
                                                                    Material__c = material.Id,
                                                                    Billing_Type__c = 'Ship and Bill',
                                                                    Container_Type__c = 'Tank Vertical Steel',
                                                                    Inventory_Type__c = 'Actual Tank',
                                                                    Tank_Capacity__c = 200,
                                                                    Tank_Heel__c = 5);
        System.debug('Test insert Container: ' + 1);
        insert container;


        Chemical_Container__c containerWithInventories = new Chemical_Container__c(Account__c = acc.Id,
                                                                                   Sales_Org_Region__c = '1020',
                                                                                   Material__c = material.Id,
                                                                                   Billing_Type__c = 'Ship and Bill',
                                                                                   Container_Type__c = 'Tank Vertical Steel',
                                                                                   Inventory_Type__c = 'Actual Tank',
                                                                                   Tank_Capacity__c = 500,
                                                                                   Tank_Heel__c = 20);
        System.debug('Test insert Container: ' + 2);
        insert containerWithInventories;

        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        Chemical_Inventory__c consumpInventory1 = new Chemical_Inventory__c(Chemical_Container__c = containerWithInventories.Id,
                                                                             Total_Inventory__c = 80,
                                                                             Inventory_Date__c = date.newInstance(2020, 11, 15),
                                                                             Deliveries__c = 170,
                                                                             Delivered_Date__c = date.newInstance(2020, 11, 10)
                                                                            );
        System.debug('Test insert Inv: ' +1);
        insert consumpInventory1;

     	Chemical_Inventory__c consumpInventory2 = new Chemical_Inventory__c(Chemical_Container__c = containerWithInventories.Id,
                                                                             Total_Inventory__c = 60,
                                                                             Inventory_Date__c = date.newInstance(2020, 11, 06),
                                                                             Deliveries__c = 200,
                                                                             Delivered_Date__c = date.newInstance(2020, 11, 02)
                                                                            );
        System.debug('Test insert Inv: ' + 2);
        insert consumpInventory2;

        Chemical_Inventory__c consumpInventory3 = new Chemical_Inventory__c(Chemical_Container__c = containerWithInventories.Id,
                                                                             Total_Inventory__c = 210,
                                                                             Inventory_Date__c = date.newInstance(2020, 10, 01),
                                                                             Deliveries__c = 300,
                                                                             Delivered_Date__c = date.newInstance(2020, 09, 12)
                                                                            );
        System.debug('Test insert Inv: ' +3);
        insert consumpInventory3;

        System.debug('----> End testUp');

        System.debug('---> getQueries: 0 ' + Limits.getQueries());
    }
    
	@IsTest
    public static void inventoryWithTheSameDate() {
        System.debug('---> getQueries: 1 ' + Limits.getQueries());
        System.debug('---> start test method');
        Chemical_Container__c testContainer = [
                SELECT Id
                FROM Chemical_Container__c
                WHERE Tank_Capacity__c = 200
                LIMIT 1
        ];

        Chemical_Inventory__c testInventory1 = new Chemical_Inventory__c(
                Chemical_Container__c = testContainer.Id,
                Total_Inventory__c = 60,
                Inventory_Date__c = date.newInstance(2020, 11, 06),
                Deliveries__c = 200,
                Delivered_Date__c = date.newInstance(2020, 11, 02)
        );

        insert testInventory1;
        System.debug('---> getQueries: 1.5 ' + Limits.getQueries());
        
        Test.startTest();
        System.debug('---> getQueries: 2 ' + Limits.getQueries());
        System.debug('---> start test context');

            Chemical_Inventory__c testInventory2 = new Chemical_Inventory__c(
                    Chemical_Container__c = testContainer.Id,
                    Total_Inventory__c = 100,
                    Inventory_Date__c = date.newInstance(2020, 11, 06)
            );
            try{
                insert testInventory2;
            }catch (System.DmlException e) {
                System.assertEquals('There can´t be two inventories with the same Inventory Date', e.getDmlMessage(0));
            }

        System.debug('---> getQueries: 3 ' + Limits.getQueries());
        Test.stopTest();

        System.debug('---> getQueries: 4 ' + Limits.getQueries());
    }    
    
    @IsTest
    public static void singleCalculation() {
        Chemical_Container__c parentContainer = [
                SELECT Id
                FROM Chemical_Container__c
                WHERE Tank_Capacity__c = 200
                LIMIT 1
        ];
        
        Test.startTest();
        	
        	Chemical_Inventory__c inventory1 = new Chemical_Inventory__c(
                    Chemical_Container__c = parentContainer.Id,
                    Total_Inventory__c = 60,
                    Inventory_Date__c = date.newInstance(2020, 11, 06),
                    Deliveries__c = 200,
                    Delivered_Date__c = date.newInstance(2020, 11, 02)
            );
        	insert inventory1;
        
        Test.stopTest();
        
        Chemical_Container__c testContainer = [
                SELECT Id, Total_Inventory__c, Duration_Days__c, Total_Usage_Including_Deliveries__c,  Usage_Rate__c, Estimated_Runout_Days__c, Runout_Date__c
                FROM Chemical_Container__c
                LIMIT 1
        ];
        
        System.assertEquals(60, testContainer.Total_Inventory__c);
        System.assertEquals(0, testContainer.Duration_Days__c);
        System.assertEquals(0, testContainer.Total_Usage_Including_Deliveries__c);
        System.assertEquals(0, testContainer.Usage_Rate__c);
        System.assertEquals(0, testContainer.Estimated_Runout_Days__c);
        System.assertEquals(date.today(), testContainer.Runout_Date__c);
    }
    
    @IsTest
    public static void bulkCalculation() {

        Chemical_Container__c parentBulkContainer = [
                SELECT Id
                FROM Chemical_Container__c
                WHERE Tank_Capacity__c = 200
                LIMIT 1
        ];
        
        List<Chemical_Inventory__c> inventoriesList = new List<Chemical_Inventory__c>();
        
        Chemical_Inventory__c bulkInventory1 = new Chemical_Inventory__c(Chemical_Container__c = parentBulkContainer.Id,
                                                                         Total_Inventory__c = 60,
                                                                         Inventory_Date__c = date.newInstance(2020, 11, 06),
                                                                         Deliveries__c = 200,
                                                                         Delivered_Date__c = date.newInstance(2020, 11, 02) 
                                                                        );
        inventoriesList.add(bulkInventory1);
        
        Chemical_Inventory__c bulkInventory2 = new Chemical_Inventory__c(Chemical_Container__c = parentBulkContainer.Id,
                                                                         Total_Inventory__c = 80,
                                                                         Inventory_Date__c = date.newInstance(2020, 10, 25),
                                                                         Deliveries__c = 150,
                                                                         Delivered_Date__c = date.newInstance(2020, 10, 12) 
                                                                        );
        inventoriesList.add(bulkInventory2);
        
        Chemical_Inventory__c bulkInventory3 = new Chemical_Inventory__c(Chemical_Container__c = parentBulkContainer.Id,
                                                                         Total_Inventory__c = 210,
                                                                         Inventory_Date__c = date.newInstance(2020, 10, 01),
                                                                         Deliveries__c = 300,
                                                                         Delivered_Date__c = date.newInstance(2020, 09, 12) 
                                                                        );
        inventoriesList.add(bulkInventory3);
        
        Chemical_Inventory__c bulkInventory4 = new Chemical_Inventory__c(Chemical_Container__c = parentBulkContainer.Id,
                                                                         Total_Inventory__c = 150,
                                                                         Inventory_Date__c = date.newInstance(2020, 09, 01) 
                                                                        );
        inventoriesList.add(bulkInventory4);
        
        Test.startTest();

        	insert inventoriesList;
        
        Test.stopTest();
        
        Chemical_Container__c testBulkContainer = [
            SELECT Id, Total_Inventory__c, Duration_Days__c, Total_Usage_Including_Deliveries__c, Usage_Rate__c,
                    Estimated_Runout_Days__c, Runout_Date__c, (
                    SELECT Id, Consumption__c
                    FROM Chemical_Inventories__r
                    ORDER BY Inventory_Date__c DESC
            )
            FROM Chemical_Container__c
            LIMIT 1
        ];

        System.assertEquals(60, testBulkContainer.Total_Inventory__c);
        System.assertEquals(36, testBulkContainer.Duration_Days__c);
        System.assertEquals(500, testBulkContainer.Total_Usage_Including_Deliveries__c);
        System.assertEquals(13.88888888888889, testBulkContainer.Usage_Rate__c);
        System.assertEquals(3.9599999999999995, testBulkContainer.Estimated_Runout_Days__c);
        System.assertEquals(date.newInstance(2020, 11, 09), testBulkContainer.Runout_Date__c);


        List<Chemical_Inventory__c> inventories = testBulkContainer.Chemical_Inventories__r;
        System.assertNotEquals(null, inventories);
        System.assertEquals(4, inventories.size());

        for (Integer i = 0; i < inventories.size(); i++) {
            if(i == 0) {
                System.assertEquals(220, inventories[i].Consumption__c);
            } else if(i == 1) {
                System.assertEquals(280, inventories[i].Consumption__c);
            } else if(i == 2) {
                System.assertEquals(240, inventories[i].Consumption__c);
            } else if(i == 3) {
                System.assertEquals(0, inventories[i].Consumption__c);
            }
        }
    }
    
    @IsTest
    public static void calculateConsumption() {
        Chemical_Container__c consumptionContainer = [SELECT Id 
                                                     FROM Chemical_Container__c
                                                     WHERE Tank_Capacity__c = 500
                                                     LIMIT 1];

        Chemical_Inventory__c consumpInventory4 = new Chemical_Inventory__c(Chemical_Container__c = consumptionContainer.Id,
                                                                             Total_Inventory__c = 80,
                                                                             Inventory_Date__c = Date.newInstance(2020, 10, 25),
                                                                             Deliveries__c = 150,
                                                                             Delivered_Date__c = Date.newInstance(2020, 10, 12)
                                                                            );
        
        Test.startTest();
        
        	insert consumpInventory4;
        
        Test.stopTest();
        
        Chemical_Container__c consumpTestContainer = [SELECT Id, (SELECT Id, Consumption__c, Inventory_Date__c
                                                                  FROM Chemical_Inventories__r
                                                                  ORDER BY Inventory_Date__c
                                                                  DESC)
                                                     FROM Chemical_Container__c
                                                     WHERE Tank_Capacity__c = 500
                                                     LIMIT 1];
        List<Chemical_Inventory__c> testInven = consumpTestContainer.Chemical_Inventories__r;
        
        System.assertEquals(150, testInven[0].Consumption__c);
        System.assertEquals(220, testInven[1].Consumption__c);
        System.assertEquals(280, testInven[2].Consumption__c);
        System.assertEquals(null, testInven[3].Consumption__c);
    }

    @IsTest
    public static void calculateConsumptionWithoutDeliveries() {
        Chemical_Container__c consumpContainer = [SELECT Id
                                                     FROM Chemical_Container__c
                                                     WHERE Tank_Capacity__c = 500
                                                     LIMIT 1];

        List<Chemical_Inventory__c> consumpList = new List<Chemical_Inventory__c>();

        Chemical_Inventory__c consumpInvent4 = new Chemical_Inventory__c(Chemical_Container__c = consumpContainer.Id,
                                                                             Total_Inventory__c = 40,
                                                                             Inventory_Date__c = Date.newInstance(2020, 10, 20)
                                                                            );

        consumpList.add(consumpInvent4);

        Chemical_Inventory__c consumpInvent5 = new Chemical_Inventory__c(Chemical_Container__c = consumpContainer.Id,
                                                                             Total_Inventory__c = 80,
                                                                             Inventory_Date__c = Date.newInstance(2020, 10, 10)
                                                                            );

        consumpList.add(consumpInvent5);

        Test.startTest();

        	insert consumpList;

        Test.stopTest();

        Chemical_Container__c consumpTestContainerWithoutDel = [SELECT Id, (SELECT Id, Consumption__c, Inventory_Date__c
                                                                  FROM Chemical_Inventories__r
                                                                  ORDER BY Inventory_Date__c
                                                                  DESC)
                                                     FROM Chemical_Container__c
                                                     WHERE Tank_Capacity__c = 500
                                                     LIMIT 1];
        List<Chemical_Inventory__c> testInvenWithoutDel = consumpTestContainerWithoutDel.Chemical_Inventories__r;

        System.assertEquals(150, testInvenWithoutDel[0].Consumption__c);
        System.assertEquals(180, testInvenWithoutDel[1].Consumption__c);
        System.assertEquals(40, testInvenWithoutDel[2].Consumption__c);
        System.assertEquals(130, testInvenWithoutDel[3].Consumption__c);
        System.assertEquals(null, testInvenWithoutDel[4].Consumption__c);
    }

    @IsTest
    public static void deleteInventory() {
        Chemical_Container__c deleteContainer = [SELECT Id, (SELECT Id, Consumption__c
                                                                  FROM Chemical_Inventories__r
                                                                  ORDER BY Inventory_Date__c
                                                                  DESC)
                                                     FROM Chemical_Container__c
                                                     WHERE Tank_Capacity__c = 500
                                                     LIMIT 1];

        List<Chemical_Inventory__c> childInven = deleteContainer.Chemical_Inventories__r;

        Test.startTest();

        	delete childInven[1];

        Test.stopTest();

        Chemical_Container__c testDelContainer = [SELECT Id, (SELECT Id, Consumption__c
                                                                  FROM Chemical_Inventories__r
                                                                  ORDER BY Inventory_Date__c
                                                                  DESC)
                                                     FROM Chemical_Container__c
                                                     WHERE Tank_Capacity__c = 500
                                                     LIMIT 1];

        List<Chemical_Inventory__c> testChildInven = testDelContainer.Chemical_Inventories__r;

        System.assertEquals(300, testChildInven[0].Consumption__c);
    }

    @IsTest
    public static void bulkInsertion_Positive() {

        List<Chemical_Inventory__c> inventoriesBatch_1 = createInventories(200, Date.today());
        Integer lastIndex = inventoriesBatch_1.size() - 1;
        Date lastDateOfTheFirstBatch = inventoriesBatch_1[lastIndex].Inventory_Date__c;
        List<Chemical_Inventory__c> inventoriesBatch_2 = createInventories(200, lastDateOfTheFirstBatch.addDays(-1));

        Test.startTest();

        insert inventoriesBatch_1;
        insert inventoriesBatch_2;

        Test.stopTest();

        Chemical_Container__c parentContainer = [SELECT Id FROM Chemical_Container__c WHERE Tank_Capacity__c = 200 AND Tank_Heel__c = 5];

        List<Chemical_Inventory__c> inventories = [
                SELECT Id, Consumption__c
                FROM Chemical_Inventory__c
                WHERE Chemical_Container__c = :parentContainer.Id
                AND Total_Inventory__c = 120
                ORDER BY Inventory_Date__c DESC
        ];

        System.assertEquals(400, inventories.size());

        Integer insertedLastIndex = inventories.size() - 1;

        for (Integer i = 0; i < inventories.size(); i++) {

            if(i == insertedLastIndex) {
                System.assertEquals(null, inventories[i].Consumption__c);
            } else {
                System.assertNotEquals(null, inventories[i].Consumption__c);
                System.debug('Index ' + i + ': consumption: ' + inventories[i].Consumption__c);
            }
        }
    }

    private static List<Chemical_Inventory__c> createInventories(Integer batchSize, Date startDate) {
        List<Chemical_Inventory__c> inventories = new List<Chemical_Inventory__c>();

        Chemical_Container__c container = [SELECT Id FROM Chemical_Container__c WHERE Tank_Capacity__c = 200 AND Tank_Heel__c = 5];

        for (Integer i = 0; i < batchSize; i++) {

            Chemical_Inventory__c inventory = new Chemical_Inventory__c(
                    Chemical_Container__c = container.Id,
                    Total_Inventory__c = 120,
                    Inventory_Date__c = startDate.addDays(i * -1)
            );

            inventories.add(inventory);
        }

        return inventories;
    }

}
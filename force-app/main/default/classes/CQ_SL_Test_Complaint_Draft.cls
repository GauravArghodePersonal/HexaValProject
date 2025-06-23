/**
 * *********************** Revision History ***************************
 * @description Test class for the flow
 * 1. [SL-30] : Field Mgt - Complaint Create and Details Screen
 * Flow: CQ_SL_Complaint_Before_Create_Update_RT_Flow
 * @description Test class for the flow
 * 2. [SL-10]:Lookup Sections: Lookup to Objects and populate values based on those objects
 * Flow: CQ_SL_Complaint_Set_Sales_Orders_AL_Flow
 * 3. [SL-44]: Mapping fields from SF to CQ objects
 * Flow: CQ_SL_Complaint_Set_Sales_Orders_AL_Flow
 * 4. [SL-49]: Supplier and Carrier contact names
 * Flow: CQ_SL_Complaint_Set_Sales_Orders_AL_Flow
 * 5. [SL-47]: Assignment new field
 * Flow: CQ_SL_Complaint_Before_Create_Update_RT_Flow
 * 6. [SL-62]: Mappings to facilitate when no sales order deliveries for an open order
 * Flow : CQ SL Complaint After Update RT Flow , CQ SL Complaint Before Create Update RT Flow , CQ SL Complaint Set Sales Orders AL Flow
 * -----------------------------------------------------------------
 * [SL-73]: Sales order deliveries
 * Flow: CQ_SL_Complaint_After_Update_RT_Flow
 * TestMethod: givenComplaintRecord_WhenOriginalOpenOrderUdpated_ThenMapSalesOrderDeliveries()
 * *********************** Revision History ***************************
 */
/**
 * @description setup method to arrange data using contruct code
 */
@isTest
public class CQ_SL_Test_Complaint_Draft {
    /**
     * @description setup method to arrange data using contruct code
     */
    @testSetup
    static void setupData(){
        Map<String,SObject> usersMap = new CQ_CCC_Test_Data_Factory(User.SObjectType).constructData('users-adminandstandard');
        User stdUser = (User)usersMap.get('Standard User 1'); 
        User adminUser = (User)usersMap.get('Admin User 1');
        System.runAs(stdUser){
            new CQ_CCC_Test_Data_Factory(CQ_SL_SQX_Assignment__c.SObjectType).constructData('createAssign-Commit');
            new CQ_CCC_Test_Data_Factory(CQ_SL_SQX_Assignment_Evaluator__c.SObjectType).constructData('createEvaluator');
            new CQ_CCC_Test_Data_Factory(Sales_Order_Deliveries__c.SObjectType).constructData('createSalesOrderDeliveries');
            new CQ_CCC_Test_Data_Factory(Open_Orders__c.SObjectType).constructData('createOpenOrder');
            //new CQ_CCC_Test_Data_Factory(compliancequest__SQX_Complaint__c.SObjectType).constructData('createCom-and-SOD');
            new CQ_CCC_Test_Data_Factory(compliancequest__SQX_Complaint__c.SObjectType).constructData('createCom-OF-CA-Commit');
            new CQ_CCC_Test_Data_Factory(compliancequest__SQX_Complaint__c.SObjectType).constructData('BulkInsert');
         }
    }
    
    /**
     * @description This method is used to verify owner updation
     * GIVEN: Complaint Record
     * WHEN: When Sales Original Order Selected
     * THEN: Populate Sales Order Deliveries 
     * 
     * @Story: [SL-10] [SL-44] [SL-49] [SL-62]
     * Flow: CQ_SL_Complaint_Set_Sales_Orders_AL_Flow
     */
    /*@isTest
    public static void givenComplaint_WhenOpenOrderSelected_ThenSalesOrderDeliveriesPopulated(){
        User stdUser = [SELECT Id FROM User WHERE FirstName =: 'Standard User 1' LIMIT 1];   
        
        System.runAs(stdUser){
            Open_Orders__c opd = [SELECT Id,ShipTo__r.SAP_Country__c FROM Open_Orders__c LIMIT 1];
                
            Sales_Order_Deliveries__c sod = [SELECT Id, Open_Orders__c,
                                             Carrier_Contact_Name__c, Supplier_Contact_Name__c
                                             FROM Sales_Order_Deliveries__c LIMIT 1];
            sod.Open_Orders__c = opd.Id;
            sod.Carrier_Contact_Name__c = 'Carrier1';
            sod.Supplier_Contact_Name__c = 'Supplier1';
            update sod;
                       
            compliancequest__SQX_Complaint__c comp = [SELECT Id,CQ_SL_Responsible_Department__c,OwnerId,CQ_SL_PlantCode__c,
                                                      compliancequest__Country_of_Origin__c,
                                                      CQ_SL_Carrier_Contact_Name__c, CQ_SL_Supplier_Contact_Name__c
                                                      FROM compliancequest__SQX_Complaint__c LIMIT 1];
            comp.CQ_SL_SQX_Original_Sales_Order__c = opd.Id;
            comp.CQ_SL_SQX_Sales_Order_Deliveries__c = sod.Id;
            
            //ACT: create Root Cause record
            Map<String, Object> inputs = new Map<String, Object> {'InRecord' => comp};
            Flow.Interview flw = new Flow.Interview.CQ_SL_Complaint_Set_Sales_Orders_AL_Flow(inputs);
            Test.startTest();
            flw.start();
            Test.stopTest();
            compliancequest__SQX_Complaint__c comOut = (compliancequest__SQX_Complaint__c)flw.getVariableValue('OutRecord');
            //ASSERT: Record Type matching
            System.assertEquals(comOut.CQ_SL_SQX_Sales_Order_Deliveries__c, sod.Id, 'Not updated.');
            
            //Assert: Country of origin should be updated
            System.assertEquals(comOut.compliancequest__Country_of_Origin__c, opd.ShipTo__r.SAP_Country__c, 'Country of origin should be updated.');
            
            //Assert: Carrier Contact Name should be updated
            System.assertEquals(comOut.CQ_SL_Carrier_Contact_Name__c, sod.Carrier_Contact_Name__c, 'Carrier Contact Name should be updated.');
        }       
    }*/
    
    /**
     * @description : This method is used to check the Customer Id is equal or not with Sales Order Deliveries ShipTo
     * GIVEN: Complaint Record
     * WHEN: When Sales Order Deliveries Selected
     * THEN: Update the Customer field
     * 
     * @Story: [SL-30] [SL-62]
     * Flow: CQ_SL_Complaint_Before_Create_Update_RT_Flow
     */
    @isTest
    public static void givenComplaint_WhenSalesOrderDeliveriesSelected_ThenUpdateTheCustomerField(){
        User stdUser = [SELECT Id FROM User WHERE FirstName = 'Standard User 1' LIMIT 1];
        
        System.runAs(stdUser){
            
          /*  //Arrange : Get the Complaint With Sales Order Deliveries
            compliancequest__SQX_Complaint__c complaint = [SELECT Id,
                                                           compliancequest__SQX_Account__c, CQ_SL_SQX_Original_Sales_Order__c
                                                           FROM compliancequest__SQX_Complaint__c 
                                                           WHERE compliancequest__Complaint_Title__c = 'SL-30' LIMIT 1];
            
            //Arrange: Get the Sales Order Deliveries
            Sales_Order_Deliveries__c salesOrderDeliveries = [SELECT Id, CSR__c, ShipTo__c 
                                                              FROM Sales_Order_Deliveries__c 
                                                              WHERE Id = :complaint.CQ_SL_SQX_Sales_Order_Deliveries__c]; 
            
            //Assert: Check the Complaint Account Id and Sales Order Ship To Id are equal to each other.
            system.assertEquals(complaint.compliancequest__SQX_Account__c, salesOrderDeliveries.ShipTo__c , 'Complaint Customer Id and Sales Order Deliveries Ship To Id should be common but not common'); */
              
            //Arrange : Get Open Orders Record
            Open_Orders__c opd = [SELECT Id, ShipTo__c FROM Open_Orders__c LIMIT 1];
            
            //Act : Insert Complaint record
            compliancequest__SQX_Complaint__c comp = CQ_SL_Test_Complaint_Factory.createComplaint(true); 
            comp.CQ_SL_SQX_Original_Sales_Order__c = opd.Id;
            insert comp;
            
            //Arrange : Get complaint record
            comp = [SELECT Id, compliancequest__SQX_Account__c
                    FROM compliancequest__SQX_Complaint__c
                    WHERE Id =: comp.Id];
            
            //Assert: Check the Complaint Account Id and Open Order Ship To Id are equal to each other.
            system.assertEquals(comp.compliancequest__SQX_Account__c, opd.ShipTo__c , 'Complaint Customer Id and Open Order Ship To Id should be common but not common');
        }
    }
    /**
     * @description : This method is to check the Region populated from Assignment to Complaint
     * GIVEN: Complaint Record
     * WHEN: When Manufacturing Code Selected
     * THEN: Update the region field based on plant Code
     * @Story: [SL-47]
     * Flow: CQ_SL_Complaint_Before_Create_Update_RT_Flow
     */
     @isTest
     public static void givenComplaint_WhenPlantCodeIsSelected_ThenUpdateTheRegionFieldFromAssignment(){
         User stdUser = [SELECT Id FROM User WHERE FirstName =: 'Standard User 1' LIMIT 1];   
        
         System.runAs(stdUser){
            //Arrange: Get Assignment Record
            CQ_SL_SQX_Assignment__c assignment = [SELECT Id,CQ_SL_SQX_CA_User__c,CQ_SL_SQX_Manufacturing_User__c,CQ_SL_Plant_Code__c,CQ_SL_Region__c FROM CQ_SL_SQX_Assignment__c LIMIT 1];
            
            //Arrange: Create Complaint record
            compliancequest__SQX_Complaint__c comRecord = [SELECT Id,CQ_SL_Responsible_Department__c,OwnerId,CQ_SL_PlantCode__c,CQ_SL_Region__c FROM compliancequest__SQX_Complaint__c WHERE CQ_SL_Responsible_Department__c = 'CA' LIMIT 1];
            
            //Assert: Check the Complaint Account Id and Sales Order Ship To Id are equal to each other.
            system.assertEquals(comRecord.CQ_SL_Region__c, assignment.CQ_SL_Region__c , 'Complaint Region and Assignment Region should be same but not same');
        }
    }
    
    /**
    * @description This method is used to verify the material sales data value depends on open order's material value.
    * GIVEN : Complaint Record
    * WHEN  : Sales order deliveries is null
    * THEN  : Assign Open order's material to material sales data
    * 
    * @Story: [SL-62] Mappings to facilitate when no sales order deliveries for an open order
    * Flow: CQ_SL_Complaint_Set_Sales_Orders_AL_Flow
    */
    @isTest
    public static void givenComplaint_WhenSalesOrderDeliveriesIsNull_ThenAssignOpenOrderMaterialToMaterialSalesData(){
        User stdUser = [SELECT Id FROM User WHERE FirstName =: 'Standard User 1' LIMIT 1];   
        
        System.runAs(stdUser){

            //Arrange : Get Open Orders Record
            Open_Orders__c opd = [SELECT Id , Material__c , Material_Desc__c FROM Open_Orders__c LIMIT 1];
            
            //Arrange : Insert Complaint record
            compliancequest__SQX_Complaint__c comp = CQ_SL_Test_Complaint_Factory.createComplaint(true); 
            comp.CQ_SL_SQX_Original_Sales_Order__c = opd.Id;
            insert comp;
            
            //Act : Call CQ_SL_Complaint_Set_Sales_Orders_AL_Flow Flow
            Map<String, Object> inputs = new Map<String, Object> {'InRecord' => comp};
            Flow.Interview flw = new Flow.Interview.CQ_SL_Complaint_Set_Sales_Orders_AL_Flow(inputs);
            Test.startTest();
            flw.start();
            Test.stopTest();
            compliancequest__SQX_Complaint__c comOut = (compliancequest__SQX_Complaint__c)flw.getVariableValue('OutRecord');    
            
            //Arrange : Get Complaint record
            comp = [SELECT Id, CQ_SL_SQX_Material_Sales_Data2__c , CQ_SL_Part_Name_Text__c
                    FROM compliancequest__SQX_Complaint__c
                    WHERE Id =: comp.Id 
                    AND CQ_SL_SQX_Sales_Order_Deliveries__c = null]; 

            //Assert : Check material sales date is coming from open order material
            System.assertEquals(opd.Material__c,comOut.CQ_SL_SQX_Material_Sales_Data2__c , 'Material sales data was expected to come from open order material but failed to assign.');   
        }
    }
    
   /**
    * @description This method is used to verify whether or not the part name is updated once the original open order is changed.
    * GIVEN : Complaint Record
    * WHEN  : Original Open Order is changed
    * THEN  : Update Part Name 
    * 
    * @Story: [SL-62] Mappings to facilitate when no sales order deliveries for an open order
    * Flow: CQ SL Complaint After Update RT Flow
    */
    
    @isTest
    public static void givenComplaintRecord_WhenOriginalOpenOrderChanged_ThenUpdatePartName(){
        User stdUser = [SELECT Id FROM User WHERE FirstName =: 'Standard User 1' LIMIT 1];   
        
        System.runAs(stdUser){
            
            //Arrange : Get Open Orders Record
            Open_Orders__c opd = [SELECT Id , Material__c, Material_Desc__c FROM Open_Orders__c LIMIT 1];
            
            //Arrange: Get Complaint record
            compliancequest__SQX_Complaint__c comRecord = [SELECT Id,CQ_SL_Responsible_Department__c,OwnerId,CQ_SL_PlantCode__c
                                                           FROM compliancequest__SQX_Complaint__c LIMIT 1];
            comRecord.CQ_SL_SQX_Original_Sales_Order__c = opd.Id;
            update comRecord;
            
            //Arrange: Create Evaluator record
            CQ_SL_SQX_Evaluator__c comEvaluator = new CQ_SL_SQX_Evaluator__c();
            comEvaluator.CQ_SL_SQX_Complaint__c = comRecord.Id;
            comEvaluator.CQ_SL_SQX_User__c= stdUser.Id;
            insert comEvaluator;
      
            //Arrange : Get Open Orders Record
            //Open_Orders__c opd1 = [SELECT Id , Material_Desc__c FROM Open_Orders__c LIMIT 1];
            
            //Act : Update Complaint Record
            //comRecord.CQ_SL_SQX_Original_Sales_Order__c = opd1.Id;
            //update comRecord;
            
            //Arrange : Get update complaint record
            compliancequest__SQX_Complaint__c comp = [SELECT Id , CQ_SL_Part_Name_Text__c 
                                                      FROM compliancequest__SQX_Complaint__c
                                                      WHERE Id =: comRecord.Id 
                                                      AND CQ_SL_SQX_Original_Sales_Order__c =: opd.Id];
            
            //Assert : Check if part name field is updated or not
            System.assertEquals(comp.CQ_SL_Part_Name_Text__c , opd.Material_Desc__c , 'Partname was expected to updated but failed.');
        }
    }

    /**
     * @description Test Method to Check the Sales Order Deliveries when Open Order Updated 
     * 
     * GIVEN: Complaint record
     * WHEN: Original Open Order Updated
     * THEN: Map Sales Order Deliveries
     * 
     * @Story: [SL-73]
     * Flow: CQ_SL_Complaint_After_Update_RT_Flow 
     */ 
    @isTest	
    public static void givenComplaintRecord_WhenOriginalOpenOrderUdpated_ThenMapSalesOrderDeliveries(){
        User stdUser = [SELECT Id FROM User WHERE FirstName = 'Standard User 1' LIMIT 1];
        
        System.runAs(stdUser){
            
            //Arrange: Get the Open Order.
            Open_Orders__c openOrder = [SELECT Id FROM Open_Orders__c LIMIT 1];
                
            //Arrange: Get the Sales Order Deliveries.
            Sales_Order_Deliveries__c salesOrderDeliveries = [SELECT Id, 
                                                              Open_Orders__c
                                                              FROM Sales_Order_Deliveries__c 
                                                              LIMIT 1];
            
            //Arrange: Update the Sales Order Deliveries with Open Order Id.
            salesOrderDeliveries.Open_Orders__c = openOrder.Id;
            update salesOrderDeliveries;
                       
            //Arrange: Get the Complaint Record.
            compliancequest__SQX_Complaint__c complaint = [SELECT Id,
                                                           CQ_SL_SQX_Original_Sales_Order__c
                                                           FROM compliancequest__SQX_Complaint__c LIMIT 1];
            
            //Act: update the complaint Open Order Id.
            complaint.CQ_SL_SQX_Original_Sales_Order__c = openOrder.Id;
            update complaint;
            
            //Arrange: Get the Complaint record
            compliancequest__SQX_Complaint__c comRecord = [SELECT Id,
                                                           CQ_SL_SQX_Sales_Order_Deliveries__c
                                                           FROM compliancequest__SQX_Complaint__c 
                                                           WHERE Id =: complaint.Id];
            
            //Assert : check the Sales order deliveries Id is mapped when open order is changed in complaint
            System.assertEquals(comRecord.CQ_SL_SQX_Sales_Order_Deliveries__c , salesOrderDeliveries.Id , 'Sales Order Deliveries is mapped when Open Order is updated in complaint but not updated');
        }
    }
}
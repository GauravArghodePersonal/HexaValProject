@isTest
public class SolenisB2BgetOrdersTest {
  public static testMethod void testOrderStatusMethod1(){
     	User user= TestDataFactory.createUser(false, 'solenis@test.com', 'empId');
        user.SAP_Cust_Num__c = '0000208802222';
        insert user;

        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
        
        Account regularAccount = TestDataFactory.createAccount(false);
        regularAccount.Name = 'Account123';
        regularAccount.ownerId = user.id;
        regularAccount.RecordTypeId = accountRecordTypeId;
        regularAccount.AccountNumber = '19876';
        regularAccount.SAP_Sales_Org__c = '1020';
        regularAccount.Enable_As_Buyer_Account__c = true;
        regularAccount.SAP_Attribute1_Desc__c ='abc';
        regularAccount.SAP_DivisionCode__c = '10';
        regularAccount.SAP_DistChannel__c = '10';
        regularAccount.SAP_Customer_Number__c = '35462379';
        regularAccount.ParentId = null;

        Insert regularAccount;
        Id pricebookId = Test.getStandardPricebookId(); 
      	PriceFx__c setting1 = new PriceFx__c();
      	setting1.Name = 'callMaterialSalesData2';
        setting1.Allowed_Sales_Org__c = '0100';
        setting1.Allowed_recordType_Id__c = 'shdhb';
        setting1.username__c = 'test';
        setting1.password__c = 'solenis-32DPHR:afff1e3f-5bd8-4d49-91a1-73efcde405ee';
        setting1.EndpointURL__c = 'https://b2bdbqa.solenis.com:9093/ws/simple/upsertCustomerUpdate';
        insert setting1;
      
      ProductCatalog pcata =  new ProductCatalog(Name = 'abc');
      insert pcata;
      ProductCategory pc = new ProductCategory(Name = 'abc', Brand_Code__c='abc',Brand_Name_As_Account__c ='abc',CatalogId =pcata.id);
      insert pc;
      CommerceEntitlementPolicy cep = new CommerceEntitlementPolicy(Name='abc');
      insert cep;
      Material_General_Data2__c general1 = new Material_General_Data2__c(Material_Number__c='abc1234561ab',Old_Material_Number__c='abc1234561ab');
      insert general1;
            
      Material_Sales_Data2__c material1 = new Material_Sales_Data2__c(Dist_Channel_Code__c='ac', Material_Number__c='abc1234561ab', Record_Key__c='abc1234561ab',Material_General_Data__c=general1.id, Sales_Org_Code__c='0100', Material_Group4_Code__c='abc',Sales_Unit__c='CSv');
      insert material1; 
      /*Product2 pp = new Product2(MSD2__c=material1.Id,isActive=True,Name='abc', Sales_org__c='1020', RecordKey__c='abc1234561ab');
      
      insert pp;

	PricebookEntry standardPrice = new PricebookEntry();
    standardPrice.Pricebook2Id = pricebookId;
    standardPrice.Product2Id = pp.Id;
    standardPrice.UnitPrice = 1;
    standardPrice.IsActive = true;
    standardPrice.UseStandardPrice = false;
    insert standardPrice ;*/
      Order order = new Order(SAP_Order_Number__c = '19876', ShipTo_SAP_Customer_Number__c = '19876', 
                              BillTo_SAP_Customer_Number__c ='19876',AccountId = regularAccount.Id,
                              Status='Draft',EffectiveDate = system.today(),EndDate = system.today() + 4);
      insert order;

	Datetime yesterday = Datetime.now().addDays(-1);
      Test.setCreatedDate(order.Id, yesterday); 
                
      Material_General_Data2__c general = new Material_General_Data2__c(Material_Number__c='abc123456test',Old_Material_Number__c='abc123456test');
      insert general;
      
      Material_Sales_Data2__c material = new Material_Sales_Data2__c(Dist_Channel_Code__c='ab', Material_Number__c='abc123456test', Record_Key__c='abc123456test',Material_General_Data__c=general.id, Sales_Org_Code__c='0100', Material_Group4_Code__c='abc',Sales_Unit__c='CSv');
      insert material;    
         
     /*Product2 p2 = new Product2(MSD2__c=material.Id,isActive=True,Name='abc123456test', RecordKey__c='abc123456test');
            insert p2;*/
          //Product2 p2 = [Select Id from Product2 where Name = 'abc'];

             
         /*ProductCategoryProduct pcp = new ProductCategoryProduct(ProductCategoryId = pc.id, ProductId = p2.id);
            insert pcp;*/

      Product2 p2 = [Select Id from Product2 where MSD2__c=:material.id];
          OrderItem old = new OrderItem(ProductKey__c='abc123456test',Orderid=order.Id,ListPrice=12,UnitPrice=12, TotalLineAmount=12,quantity=1);
          insert old;
              // order.StatusCode = 'A';
      order.Status = 'Activated';
      update order;
        PriceFx__c setting = new PriceFx__c();
        setting.Name = 'B2BOrderUpdate';
        setting.username__c = 'test';
        setting.password__c = 'solenis-32DPHR:afff1e3f-5bd8-4d49-91a1-73efcde405ee';
        setting.EndpointURL__c = 'https://b2bdbqa.solenis.com:9093/ws/simple/upsertCustomerUpdate';
        insert setting;
          Test.startTest();
        Test.setMock(HttpCalloutMock.class, new B2BMockTestOrdresponse());
       Test.stopTest();
        //CCRtoSAP.CalloutToDellBoomi(ccr.Id);
        String response = '';
        String response1 = '';
        try{
            // callWebServiceB2bOrderHeader(String recordId,String strSAPOrderNumber,
                                                     // String sapChannel,String sapCustomerNumber,
                                                     // String sapDivision,String sapOrg)
                 
             SolenisB2BgetOrders.getOrder('12', 'SAP_Order_Number__c', 'desc');
            SolenisB2BgetOrders.getOrders(regularAccount.id, '', 'OrderNumber','','');
            SolenisB2BgetOrders.getOrders(regularAccount.id, '', 'OrderedDate','','');
            SolenisB2BgetOrders.getOrders(regularAccount.id, '', '','','');
            SolenisB2BgetOrders.getOrders(regularAccount.id, '', 'OrderNumber',DateTime.now().addDays(-1).format('yyyy-MM-dd'),Datetime.now().addDays(1).format('yyyy-MM-dd'));
            String Orderid=order.Id;
            SolenisB2BgetOrders.getOrderDetails(Orderid);
                //SolenisB2BgetOrders.getOrderDetails(order.Id);
            
                SolenisB2BgetOrders.getOrderlineItem('');
                SolenisB2BgetOrders.gettracking('1212');
            SolenisB2BgetOrders.callWebServiceB2bOrderHeader('','1212','10','1212','11','0100');
            SolenisB2BgetOrders.callWebServiceB2bOrderline('','1212','10','1212','11','0100');
            SolenisB2BgetOrders.callWebServiceB2bOrderHeaderStoreStatus('','19876','10','1212','11','0100');

         B2BOrderWrapper bb= new B2BOrderWrapper('order',null,'123','12','12','12','12','12',order,null);
                
            
            
        }
        catch(Exception e) {
            System.debug('ERROR: '+ e.getMessage());
            response = e.getMessage();  
        }
        
        
    }
}
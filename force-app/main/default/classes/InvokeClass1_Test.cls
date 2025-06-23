@isTest
private class InvokeClass1_Test 
{
		@isTest static void DeleteOrderProductItems() 
    	{
            /*
            List<ID> ids = new List<ID>();
            ids.add('801Z0000000USJHIA4');
            InvokeClass1.updateOrder(ids);
			*/
            
             User user= TestDataFactory.createUser(false, 'solenis@test.com', 'empId');
        user.SAP_Cust_Num__c = '0000208802222';
        insert user;
        List<ID> Ids = new List<ID>();
        
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
        Ids.Add(regularAccount.Id);
            
            Order newOrder = new Order();
            newOrder.SAP_Order_Number__c='11101';
            newOrder.AccountId=regularAccount.Id;
            newOrder.EffectiveDate=System.today();
            newOrder.Status='Draft';
            newOrder.Status1__c='Draft';
            newOrder.ShipTo_Account_ID__c=regularAccount.Id;            
            newOrder.SAP_BillTo_Account__c=regularAccount.Id;                       
            insert newOrder;
            //List<Id> ids = new List<Id>();
            ids.add(newOrder.Id);
            InvokeClass1.updateOrder(Ids);                       
        }
}
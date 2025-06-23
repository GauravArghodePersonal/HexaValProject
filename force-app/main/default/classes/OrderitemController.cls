public class OrderitemController {
    public static void Orderlistupdate(List<OrderItem> orderItems)
    {
List<String> productKey=new List<String>();
List<Id> orderIds = new List<Id>();
List<Id>oiproductIds=new List<Id>();
        
        //get the productkey before insert
        for(orderItem it:orderItems)
        {
            system.debug('Actual Order ID Key TTTTT---->'+it.OrderId);
              system.debug('Actual product Key---->'+it.ProductKey__c);
                        //setting Dummy Product key id.... This field will be set by Dellboomi. 
           // it.ProductKey__c='000000000000206202010010';
            //default listprice
       //   it.ListPrice=0.0;
       if(it.ProductKey__c!=null)
            productKey.add(it.ProductKey__c);
           // it.Product2Id='01tZ0000004vkWgIAI';
           // it.PricebookEntryId='01s50000000VZ05AAG';
           orderIds.add(it.OrderId);
            if(it.Product2Id!=null)
            oiproductIds.add(it.Product2Id);
        }
        system.debug('productKey-->'+productKey);
        //Query the product and store the map products with key and id as the map
        Map<String,Id> mapProducts=new Map<String,Id>();
        List<Id> productIds = new List<Id>();
        Map<Id,Id> productToPriceBookEntry = new map<Id,Id>();
        //to store the currency value
        Map<Id,Decimal> productToPriceBookEntryCost=new Map<Id,Decimal>();
      //  List<PriceBook2> standardPBList = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];
         List<Footer_Links__mdt> standardPBList= [SELECT Id, Label,Type__c, Value__c FROM Footer_Links__mdt where Label='b2bDefaultPricebook'];
       for (Product2 lstProduct : [select id,RecordKey__c from Product2 where RecordKey__c IN :productKey])
       {
           if(lstProduct.RecordKey__c!=null)
           {
            mapProducts.put(lstProduct.RecordKey__c,lstProduct.Id);
               productIds.add(lstProduct.Id);
           }
       }
       //if(!test.isrunningTest()){
         //  for(PricebookEntry pbe : [SELECT Id,IsActive,Pricebook2Id,Product2Id,UnitPrice FROM PricebookEntry where (Product2Id in: productIds or Product2Id in:oiproductIds) and Pricebook2Id =: standardPBList[0].Id and IsActive = true]){
             for(PricebookEntry pbe : [SELECT Id,IsActive,Pricebook2Id,Product2Id,UnitPrice FROM PricebookEntry where (Product2Id in: productIds or Product2Id in:oiproductIds) and Pricebook2Id =: standardPBList[0].Value__c and IsActive = true]){
               productToPriceBookEntry.put(pbe.Product2Id, pbe.Id);
               productToPriceBookEntryCost.put(pbe.Product2Id, pbe.UnitPrice);
           }
       //}
       
       system.debug('productToPriceBookEntry++++++ ' + productToPriceBookEntry);
       
       List<Id> ordersWithPriceBook = new List<Id>();
       for(Order od : [Select id from order where id in:orderIds and Pricebook2Id!=null]){
           ordersWithPriceBook.add(od.Id);
       }
       System.debug('ordersWithPriceBook++ ' + ordersWithPriceBook);
       
       
       for(orderItem it:orderItems)
       {
            system.debug('IT---->'+it.Account_Id__c);
            productKey.add(it.ProductKey__c);

            if(!String.isBlank(it.ProductKey__c))
            {
                
                Id product2ID= mapProducts.get(it.ProductKey__c);
                system.debug('product2ID'+product2ID);
                if(!String.isBlank(product2ID))
                {
                    system.debug('product2ID'+product2ID);
                    //add product lookup
                    it.Product2Id=product2ID;
                    //add pricebook entry
                    if(!test.isrunningTest()){
                        if(ordersWithPriceBook != null && ordersWithPriceBook.contains(it.OrderId)){
                            system.debug('ordersWithPriceBook123++++++++ ' + ordersWithPriceBook);
                           it.PricebookEntryId = productToPriceBookEntry.get(product2ID);
                            it.ListPrice=productToPriceBookEntryCost.get(product2ID);
                        }
                    }
                    
                }
                else
                {
                    
                  
                    it.addError('Valid Product Not available in SFDC');
                }
                
                
            }
            else
            {
                //for Order creation also set the PricelistID
                  it.PricebookEntryId = productToPriceBookEntry.get(it.product2ID);
                  it.ListPrice=productToPriceBookEntryCost.get(it.product2ID);
                system.debug('This part only for B2B order creation');
            }
           
        }
        
    }

}
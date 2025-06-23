public class reprocessPriceFx {

 

    public Static string reProcess()
    { 
        set<string>  Pfx = new  set<string>();
        set<string> callAccount = new  set<string>();
        set<string> callMaterialSalesData2 = new  set<string>();
        set<string> callMaterialPlant2 = new  set<string>();
        set<string> callCustomerProductInfo2 = new  set<string>();
        List<Account> process_Account_Customer = new  List<Account> ();
        List<Material_Plant2__c> process_Material_Plant2 = new List<Material_Plant2__c>();
        List<Material_Sales_Data2__c> process_Material_Sales_Data2 = new List<Material_Sales_Data2__c>();
        List<Customer_Product_Info2__c> process_Customer_Product_Info2 = new List<Customer_Product_Info2__c>();
        
        /*// Test
        set<string>  Pfx1 = new  set<string>();
        set<string> callAccount1 = new  set<string>();
        set<string> callMaterialSalesData21 = new  set<string>();
        set<string> callMaterialPlant21 = new  set<string>();
        set<string> callCustomerProductInfo21 = new  set<string>();
        List<Account> process_Account_Customer11 = new  List<Account> ();
        List<Material_Plant2__c> process_Material_Plant21 = new List<Material_Plant2__c>();
        List<Material_Sales_Data2__c> process_Material_Sales_Data211 = new List<Material_Sales_Data2__c>();
        List<Customer_Product_Info2__c> process_Customer_Product_Info21 = new List<Customer_Product_Info2__c>();*/
        
        
        List <PriceFx_Webservice_Logs__c> pfxList = new  List <PriceFx_Webservice_Logs__c>();
        String isSuccess = 'failed';
        String result = 'Failed';
        // do something with the selected records
        //List<PriceFx_Webservice_Logs__c> pfxLogsList = [select id,CreatedDate,Status_of_the_Process__c,Name from PriceFx_Webservice_Logs__c WHERE Status_of_the_Process__c != 'Success' and Re_Processed__c !=True ORDER BY CreatedDate limit 200];
        List<PriceFx_Webservice_Logs__c> pfxLogsList = [select id,CreatedDate,Status_of_the_Process__c,Name from PriceFx_Webservice_Logs__c WHERE CreatedDate =LAST_N_DAYS:3 and Status_of_the_Process__c != 'Success' and Re_Processed__c !=True Order by CreatedDate limit 1000];
        List <PriceFx_Webservice_Logs__c> updateReprocessed = new List <PriceFx_Webservice_Logs__c>();
        for (PriceFx_Webservice_Logs__c acc : pfxLogsList){
                Pfx.add(acc.Name);
                acc.Re_Processed__c = True;
                updateReprocessed.add(acc);
        }
        System.debug('PriceFx_Webservice_Logs__c name = ' + Pfx);
        if (!pfx.isEmpty()){
                    for (string p :Pfx){
                            //callAccount
                                Id id = p;
                                if(id.getSObjectType().getDescribe().getName() == 'Account'){
                                    callAccount.add(p);
                                }
                                //callMaterialPlant2
                                if(id.getSObjectType().getDescribe().getName() == 'Material_Plant2__c'){
                                    callMaterialPlant2.add(p);
                                }
                                //callMaterialSalesData2
                                if(id.getSObjectType().getDescribe().getName() == 'Material_Sales_Data2__c'){
                                    callMaterialSalesData2.add(p);
                                }
                                //callCustomerProductInfo2
                                if(id.getSObjectType().getDescribe().getName() == 'Customer_Product_Info2__c'){
                                    callCustomerProductInfo2.add(p);
                                }
                            
                    }
        isSuccess = 'seggregated';        
        }
        else {
            isSuccess = 'failed'; 
        }
               
        System.debug('callAccount'+callAccount);
        System.debug('callMaterialPlant2'+callMaterialPlant2);
        System.debug('callMaterialSalesData2'+callMaterialSalesData2);
        System.debug('callCustomerProductInfo2'+callCustomerProductInfo2);
        
        if(!Test.isRunningTest()){
            try{
                if(!callAccount.isEmpty()){
                    PriceFxOutboundInterfaceWebservice.callAccount(callAccount);    
                }
                if(!callMaterialPlant2.isEmpty()){
                    PriceFxOutboundInterfaceWebservice.callMaterialPlant2(callMaterialPlant2);   
                }
                if(!callMaterialSalesData2.isEmpty()){
                    PriceFxOutboundInterfaceWebservice.callMaterialSalesData2(callMaterialSalesData2);
                    
                }
                if(!callCustomerProductInfo2.isEmpty()){
                    PriceFxOutboundInterfaceWebservice.callCustomerProductInfo2(callCustomerProductInfo2);
                }
                isSuccess = 'Passed';
            }
            Catch(Exception e){
                isSuccess = 'failed';    
            }
        }
        if(isSuccess != 'failed' && !updateReprocessed.isEmpty() && updateReprocessed!=NULL){
            result = 'Success';
            update updateReprocessed;
            return result;
        }
        else{
            return result;
        }
        
        
    }
}
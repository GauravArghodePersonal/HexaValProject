public class quickReprocessController {
ApexPages.StandardSetController setCon;
set<string>  Pfx = new  set<string>();
set<string> callAccount = new  set<string>();
set<string> callMaterialSalesData2 = new  set<string>();
set<string> callMaterialPlant2 = new  set<string>();
set<string> callCustomerProductInfo2 = new  set<string>();
List<Account> process_Account_Customer = new  List<Account> ();
List<Material_Plant2__c> process_Material_Plant2 = new List<Material_Plant2__c>();
List<Material_Sales_Data2__c> process_Material_Sales_Data2 = new List<Material_Sales_Data2__c>();
List<Customer_Product_Info2__c> process_Customer_Product_Info2 = new List<Customer_Product_Info2__c>();
List <PriceFx_Webservice_Logs__c> pfxList = new  List <PriceFx_Webservice_Logs__c>();
Boolean isSuccess;
    
    public quickReprocessController(ApexPages.StandardSetController controller)
    {
        setCon = controller;
    }

    public pageReference doSomething()
    {     
        // do something with the selected records
        for (PriceFx_Webservice_Logs__c acc : (PriceFx_Webservice_Logs__c[])setCon.getSelected()){
                Pfx.add(acc.Name);
        }
        System.debug('PriceFx_Webservice_Logs__c name = ' + Pfx);
        if (!pfx.isEmpty()){
        System.debug('It is empty');
                //pfxList = [select Name,Interface_Name__c,Status_of_the_Process__c from PriceFx_Webservice_Logs__c where Name IN : Pfx];
                    //System.debug('pfxList'+pfxList );
                    for (string p :Pfx){
                        //System.debug('p.Status_of_the_Process__c'+p.Status_of_the_Process__c);
                            //callAccount
                                Id id = p;
                                System.debug('id'+id);
                                System.debug('id.getSObjectType().getDescribe().getName()'+id.getSObjectType().getDescribe().getName());
                                if(id.getSObjectType().getDescribe().getName() == 'Account'){
                                   // System.debug('Pfx'+Pfx);
                                   // system.debug('p.Interface_Name__c   '+p.Interface_Name__c+'---'+p.Name);
                                    callAccount.add(p);
                                }
                                //callMaterialPlant2
                                if(id.getSObjectType().getDescribe().getName() == 'Material_Plant2__c'){
                                   // System.debug('Pfx'+Pfx);
                                    //system.debug('p.Interface_Name__c   '+p.Interface_Name__c+'---'+p.Name);
                                    callMaterialPlant2.add(p);
                                }
                                //callMaterialSalesData2
                                if(id.getSObjectType().getDescribe().getName() == 'Material_Sales_Data2__c'){
                                    //System.debug('Pfx'+Pfx);
                                    //system.debug('p.Interface_Name__c   '+p.Interface_Name__c+'---'+p.Name);
                                    callMaterialSalesData2.add(p);
                                }
                                //callCustomerProductInfo2
                                if(id.getSObjectType().getDescribe().getName() == 'Customer_Product_Info2__c'){
                                    //System.debug('Pfx'+Pfx);
                                    //system.debug('p.Interface_Name__c   '+p.Interface_Name__c+'---'+p.Name);
                                    callCustomerProductInfo2.add(p);
                                }
                            
                    }
        isSuccess = true;        
        }
        else {
            isSuccess = false; 
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please select any value <a href="/a83/o">Click Here to Select</a>'));
        }
               
        System.debug('callAccount'+callAccount);
        System.debug('callMaterialPlant2'+callMaterialPlant2);
        System.debug('callMaterialSalesData2'+callMaterialSalesData2);
        System.debug('callCustomerProductInfo2'+callCustomerProductInfo2);
        
        if(!callAccount.isEmpty()){
            process_Account_Customer = [Select Id,SAP_Sales_Office__c,SAP_Sales_Org__c,recordtypeID from Account where Id In : callAccount];
            TriggerHelperFunction_Webservice.process_Account_Customer(process_Account_Customer);
            //PriceFxOutboundInterfaceWebservice.callAccount(callAccount);
        }
        if(!callMaterialPlant2.isEmpty()){
            process_Material_Plant2 = [Select Id,SalesOrg_Code__c from Material_Plant2__c where Id IN : callMaterialPlant2];
            TriggerHelperFunction_Webservice.process_Material_Plant2(process_Material_Plant2);
            //PriceFxOutboundInterfaceWebservice.callMaterialPlant2(callMaterialPlant2);
        }
        if(!callMaterialSalesData2.isEmpty()){
            process_Material_Sales_Data2 = [Select Id,Sales_Org_Code__c,recordtypeId from Material_Sales_Data2__c  where Id IN : callMaterialSalesData2];
            TriggerHelperFunction_Webservice.process_Material_Sales_Data2(process_Material_Sales_Data2);
            //PriceFxOutboundInterfaceWebservice.callMaterialSalesData2(callMaterialSalesData2);
        }
        if(!callCustomerProductInfo2.isEmpty()){
            process_Customer_Product_Info2 = [Select Id, Sales_Org_Code__c from Customer_Product_Info2__c where Id IN :callCustomerProductInfo2];
            TriggerHelperFunction_Webservice.process_Customer_Product_Info2 (process_Customer_Product_Info2 );
            //PriceFxOutboundInterfaceWebservice.callCustomerProductInfo2(callCustomerProductInfo2);
        }
        if(isSuccess){
            PageReference pageRef = new PageReference('/a83/o');
            return pageRef;
        }
        else{
            return null;
        }
        
        
    }
}
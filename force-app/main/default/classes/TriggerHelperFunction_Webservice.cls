public class TriggerHelperFunction_Webservice {
     public static void process_Material_Sales_Data2(List<Material_Sales_Data2__c> alist){
         set<string> materialids=new set<string>();
        //Inserting coding for Price f(x) outbound Message 
        PriceFx__c px = new PriceFx__c();
        px = PriceFx__c.getInstance('callMaterialSalesData2');
        List<PriceFx__c> pxList = new List<PriceFx__c>();
        pxList.add(px);
        String[] temp = new List<String>();
        String[] temp2 = new List<String>();
        for (PriceFx__c p : pxList){
            temp = p.Allowed_Sales_Org__c.split(',');
            temp2 = p.Allowed_recordType_Id__c.split(',');
        }
        set<string> allowedSalesOrg = new set<string>();
        set<string> allowedRecordTypes = new set<string>();
        allowedSalesOrg.addAll(temp);
        allowedRecordTypes.addAll(temp2);
        System.debug('Allowed Sales Org'+allowedSalesOrg);
        System.debug('Allowed record types'+allowedRecordTypes);
        for(Material_Sales_Data2__c a : alist) {
                system.debug('&&& Material_Sales_Data SalesOrg_Code__c' + a.Sales_Org_Code__c+'record--'+a.recordtypeID);
                 //if((a.Sales_Org_Code__c=='1020' || a.Sales_Org_Code__c=='1700' || a.Sales_Org_Code__c=='1031') && (a.recordtypeId=='01250000000HmbT')){ 
                  if((allowedSalesOrg.contains(a.Sales_Org_Code__c)) && (allowedRecordTypes.contains(a.recordtypeID))){
                    system.debug('Value of a---'+a.id);
                    materialids.add(a.id);
                }
            }    
        if (materialids.size() != 0) {
            system.debug('Before calling service - checking the materialId size'+ materialids);
            PriceFxOutboundInterfaceWebservice.callMaterialSalesData2(materialids);
        } 
    }
    public static void process_Material_Plant2(List<Material_Plant2__c> alist){
        set<string> materialids=new set<string>();
        //Inserting coding for Price f(x) outbound Message 
        PriceFx__c px = new PriceFx__c();
        px = PriceFx__c.getInstance('callMaterialPlant2');
        List<PriceFx__c> pxList = new List<PriceFx__c>();
        pxList.add(px);
        String[] temp = new List<String>();
        for (PriceFx__c p : pxList){
            temp = p.Allowed_Sales_Org__c.split(',');
        }
        set<string> allowedSalesOrg = new set<string>();
        set<string> allowedRecordTypes = new set<string>();
        allowedSalesOrg.addAll(temp);
        System.debug('Allowed Sales Org'+allowedSalesOrg);
        for(Material_Plant2__c a : alist) {
             system.debug('&&& Material_Plant2 SalesOrg_Code__c' + a.SalesOrg_Code__c);
           if((allowedSalesOrg.contains(a.SalesOrg_Code__c))){
           //if(a.SalesOrg_Code__c=='1020' || a.SalesOrg_Code__c=='1700' || a.SalesOrg_Code__c=='1031'){
               materialids.add(a.id);
                system.debug(' &&& materialids' + a.id);
            }    
        }
        system.debug(' &&& materialids Size' + materialids.size());
        if (materialids.size() != 0) {
            System.debug('Before passing the data to webservice this is the value'+materialids);
            PriceFxOutboundInterfaceWebservice.callMaterialPlant2(materialids);
        }
    }
    
    public static void process_Customer_Product_Info2(List<Customer_Product_Info2__c> alist){
        set<string> materialids=new set<string>();
        PriceFx__c px = new PriceFx__c();
        px = PriceFx__c.getInstance('callCustomerProductInfo2');
        List<PriceFx__c> pxList = new List<PriceFx__c>();
        pxList.add(px);
        String[] temp = new List<String>();
        for (PriceFx__c p : pxList){
            temp = p.Allowed_Sales_Org__c.split(',');
        }
        set<string> allowedSalesOrg = new set<string>();
        set<string> allowedRecordTypes = new set<string>();
        allowedSalesOrg.addAll(temp);
        System.debug('Allowed Sales Org'+allowedSalesOrg);
        for(Customer_Product_Info2__c a : alist)  {
            system.debug('&&& Customer_Product_Info2 Sales_Org_Code__c' + a.Sales_Org_Code__c);
           if((allowedSalesOrg.contains(a.Sales_Org_Code__c))){
            //if(a.Sales_Org_Code__c=='1020' || a.Sales_Org_Code__c=='1700' || a.Sales_Org_Code__c=='1031'){
                materialids.add(a.id);
                }
        }
        if (materialids.size() != 0) {     
            PriceFxOutboundInterfaceWebservice.callCustomerProductInfo2(materialids);
        }
    }
    
    
    public static void process_Account_Customer(List<Account> alist){
        set<string> materialids=new set<string>();
        set<string> Customeracctids=new set<string>();
        set<string> Prospectacctids=new set<string>();
        PriceFx__c px = new PriceFx__c();
        px = PriceFx__c.getInstance('callAccount');
        system.debug('px '+px);
        if(px != null){
        List<PriceFx__c> pxList = new List<PriceFx__c>();
        pxList.add(px);
        String[] temp = new List<String>();
        String[] temp2 = new List<String>();
        for (PriceFx__c p : pxList){
            temp = p.Allowed_Sales_Org__c.split(',');
            system.debug('temp '+temp);
            temp2 = p.Allowed_recordType_Id__c.split(',');
        }
        set<string> allowedSalesOrg = new set<string>();
        set<string> allowedRecordTypes = new set<string>();
        allowedSalesOrg.addAll(temp);
        allowedRecordTypes.addAll(temp2);
        System.debug('Allowed Sales Orgi'+allowedSalesOrg);
        System.debug('Allowed record types'+allowedRecordTypes);
        
        for(Account a : alist)  {
            //system.debug('&&& Account SAP_Sales_Office__c' + a.SAP_Sales_Office__c);
                   //if((a.SAP_Sales_Org__c=='1020' || a.SAP_Sales_Org__c=='1700' || a.SAP_Sales_Org__c=='1031') && ((a.recordtypeID=='01250000000HmZ3AAK')||  (a.recordtypeId=='01250000000HmZV'))){
                   if((allowedSalesOrg.contains(a.SAP_Sales_Org__c)) && (allowedRecordTypes.contains(a.recordtypeID))){
                        Customeracctids.add(a.ID);
                        System.debug('Sales'+a.SAP_Sales_Org__c);
                        System.debug('It is the correct one'+Customeracctids);
                         /*   if(a.recordtypeid == '01250000000HmZ3AAK'  )
                            {
                                if(a.SAP_Sales_Office__c== 'PP31' )
                                {
                                    Customeracctids.add(a.ID);
                                }
                            }
                            else if(a.recordtypeid == '01250000000HmZVAA0')
                            {
                                if(a.SAP_Sales_Office__c== 'PP31' )
                                {
                                    Prospectacctids.add(a.id); 
                                }
                            } */
                    }
        }
             
        //Inserting coding for Price f(x) outbound Message - Ends
        system.debug('&&& Calling AccountOutboundInterfaceWebservice Customeracctids.size()' + Customeracctids.size());
        if (Customeracctids.size() != 0){
            system.debug('&&& Calling AccountOutboundInterfaceWebservice');
            PriceFxOutboundInterfaceWebservice.callAccount(Customeracctids);
        }
        system.debug('&&& Calling AccountOutboundInterfaceWebservice Prospectacctids.size()' + Prospectacctids.size());
        
        //The Below line of code is commented by Vinu - As we are not processing the Prospect Account Id's now
        /*if (Prospectacctids.size() != 0){
            system.debug('&&& Calling AccountOutboundInterfaceWebservice');
            PriceFxOutboundInterfaceWebservice.callProspect(Prospectacctids);
        }*/
    }
    }
}
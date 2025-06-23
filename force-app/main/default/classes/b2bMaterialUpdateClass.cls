public class b2bMaterialUpdateClass {

    public static void handleChangeSolenis(List<Material_Sales_Data2__c> processMaterials) {
        
        List<Product2> insertProductList =  new List<Product2>();
        //Map<Id,Id> insertedProductList =  new Map<id,Id>();
        List<Footer_Links__mdt> uoms= [SELECT Id, Label,Type__c, Value__c FROM Footer_Links__mdt where Label='UOMConversion'];
        Map<String,String> uomsMap = new Map<String,String>();
        if(uoms != null){
            List<String> lstString = uoms[0].Value__c.split(',');
            for(String uom : lstString){
                List<String> uomSplit = uom.split(':');
                uomsMap.put(uomSplit[0],uomSplit[1]);
            }
        }
        
        system.debug('uomsMap++++++++ '+ uomsMap);
        for(Material_Sales_Data2__c material: processMaterials){
            system.debug('material activa dtate++++++++ '+ material.Active_Material__c);
            //boolean checkZD = false;
            Product2 product = new Product2();
            
            product.RecordKey__c = material.Record_Key__c;
            product.MSD2__c = material.Id;
            if(material.Material_Desc__c != null){
                product.Name = material.Material_Desc__c;
            }
            else{
                product.Name = material.Name;
            }
            product.Material_Name_SAP__c = material.Name;
            product.ProductCode = material.Material_Number__c;
            product.Sales_org__c = material.Sales_Org_Code__c;
            product.Dist_channel__c = material.Dist_Channel_Code__c;
            product.Is_Material_Updated__c = true;
            
            if(material.Sales_Unit__c!=null && uomsMap.get(material.Sales_Unit__c)!=null){
                product.Sales_Unit_Of_Mesure__c = uomsMap.get(material.Sales_Unit__c);
            }
            else{
                product.Sales_Unit_Of_Mesure__c = material.Sales_Unit__c;
            }
            
            product.Old_Material_Number__c = material.Old_Material_Number__c;
            
            /*if(material.DistChan_MatStat_Code__c == 'ZD'){
                checkZD = true;
            }*/
            //product.IsActive = material.Active_Material__c == 'Y' && checkZD == false ? true : false;
            
            product.IsActive = material.Active_Material__c == 'Y' ? true : false;
            
            
            insertProductList.add(product);
        }
        System.debug('insertProductList+++++' + insertProductList);
        if(insertProductList.size() > 0) {
            //Upserting Product
            Schema.SObjectField ftoken = Product2.Fields.RecordKey__c;
            database.UpsertResult[] myResult=database.upsert(insertProductList,ftoken,false);
            System.debug('myResult success==='+myResult);
            for(Integer i=0; i < myResult.size(); i++) {
                if(myResult.get(i).isSuccess()){
                    System.debug('success==='+myResult.get(i));
                    if(myResult.get(i).isCreated()){
                        System.debug('created success==='+myResult.get(i));
                        //insertedProductList.put(myResult.get(i).Id,insertProductList[i].MSD2__c);
                    }
                }
            }
            //System.debug('inserted products list++ ' + insertedProductList);
        }
        
        
    }

    public static void handleChange(List<Material_Sales_Data2__c> processMaterials) {
        
        List<Product2> insertProductList =  new List<Product2>();
        //Map<Id,Id> insertedProductList =  new Map<id,Id>();
        List<Footer_Links__mdt> uoms= [SELECT Id, Label,Type__c, Value__c FROM Footer_Links__mdt where Label='UOMConversion'];
        Map<String,String> uomsMap = new Map<String,String>();
        if(uoms != null){
            List<String> lstString = uoms[0].Value__c.split(',');
            for(String uom : lstString){
                List<String> uomSplit = uom.split(':');
                uomsMap.put(uomSplit[0],uomSplit[1]);
            }
        }
        
        system.debug('uomsMap++++++++ '+ uomsMap);
        for(Material_Sales_Data2__c material: processMaterials){
            system.debug('material activa dtate++++++++ '+ material.Active_Material__c);
            boolean checkZD = false;
            Product2 product = new Product2();
            
            product.RecordKey__c = material.Record_Key__c;
            product.MSD2__c = material.Id;
            if(material.Material_Desc__c != null){
                product.Name = material.Material_Desc__c;
            }
            else{
                product.Name = material.Name;
            }
            product.Material_Name_SAP__c = material.Name;
            product.ProductCode = material.Material_Number__c;
            product.Sales_org__c = material.Sales_Org_Code__c;
            product.Dist_channel__c = material.Dist_Channel_Code__c;
            product.Is_Material_Updated__c = true;
            
            if(uomsMap.get(material.Sales_Unit__c)!=null){
                product.Sales_Unit_Of_Mesure__c = uomsMap.get(material.Sales_Unit__c);
            }
            else{
                product.Sales_Unit_Of_Mesure__c = material.Sales_Unit__c;
            }
            
            product.Old_Material_Number__c = material.Old_Material_Number__c;
            
            if(material.DistChan_MatStat_Code__c == 'ZD'){
                checkZD = true;
            }
            product.IsActive = material.Active_Material__c == 'Y' && checkZD == false ? true : false;
            
            
            insertProductList.add(product);
        }
        System.debug('insertProductList+++++' + insertProductList);
        if(insertProductList.size() > 0) {
            //Upserting Product
            Schema.SObjectField ftoken = Product2.Fields.RecordKey__c;
            database.UpsertResult[] myResult=database.upsert(insertProductList,ftoken,false);
            System.debug('myResult success==='+myResult);
            for(Integer i=0; i < myResult.size(); i++) {
                if(myResult.get(i).isSuccess()){
                    System.debug('success==='+myResult.get(i));
                    if(myResult.get(i).isCreated()){
                        System.debug('created success==='+myResult.get(i));
                        //insertedProductList.put(myResult.get(i).Id,insertProductList[i].MSD2__c);
                    }
                }
            }
            //System.debug('inserted products list++ ' + insertedProductList);
        }
        
        
    }
}
public class b2bPartUpdateClass {
    public static void handleChangeSolenis(List<Material_Sales_Data2__c> processMaterials) {
        
        List<compliancequest__SQX_Part__c> ProductList =  new List<compliancequest__SQX_Part__c>();
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
        for(Material_Sales_Data2__c material: [SELECT Id, Active_Material__c, Material_General_Data__r.Name, Material_General_Data__r.Material_Number__c, Record_Key__c, 
                                               Material_Desc__c, Name, Material_Number__c, Sales_Org_Code__c, Sales_Unit__c, Old_Material_Number__c FROM Material_Sales_Data2__c WHERE Id IN:processMaterials]) {
            //boolean checkZD = false;
            compliancequest__SQX_Part__c part = new compliancequest__SQX_Part__c();
            createPartFamily(material, part);                         
            part.MSD2__c = material.Id;
            if(material.Material_Desc__c != null){
                part.Name = material.Material_Desc__c;
            }
            else{
                part.Name = material.Name;
            }
            //part.Material_Name_SAP__c = material.Name;
            part.compliancequest__Part_Number__c = material.Material_Number__c;
            part.Sales_org__c = material.Sales_Org_Code__c;
            //part.Dist_channel__c = material.Dist_Channel_Code__c;
            part.Is_Material_Updated__c = true;
            if(material.Sales_Unit__c!=null && uomsMap.get(material.Sales_Unit__c)!=null){
                part.Sales_Unit_of_Measure__c = uomsMap.get(material.Sales_Unit__c);
            }
            else{
                part.Sales_Unit_of_Measure__c = material.Sales_Unit__c;
            }
            
            part.Old_Material_Number__c = material.Old_Material_Number__c;
            part.compliancequest__Part_Description__c = material.Material_Desc__c;
            /*if(material.DistChan_MatStat_Code__c == 'ZD'){
			checkZD = true;
			}*/
            //product.IsActive = material.Active_Material__c == 'Y' && checkZD == false ? true : false;
            
            part.compliancequest__Active__c = material.Active_Material__c == 'Y' ? true : false;
            ProductList.add(part);
        }
       
        if(ProductList.size() > 0) {
            //Upserting Product
            Schema.SObjectField ftoken = compliancequest__SQX_Part__c.Fields.compliancequest__Part_Number__c;
            database.UpsertResult[] myResult=database.upsert(ProductList,ftoken,false);
            System.debug('myResult success==='+myResult);
            for(Integer i=0; i < myResult.size(); i++) {
                if(myResult.get(i).isSuccess()){
                    System.debug('success==='+myResult.get(i));
                    if(myResult.get(i).isCreated()){
                        System.debug('created success==='+myResult.get(i));
                        //insertedProductList.put(myResult.get(i).Id,ProductList[i].MSD2__c);
                    }
                }
            }
        }
    }
    private static void createPartFamily(Material_Sales_Data2__c material, compliancequest__SQX_Part__c part) {
        Map<String, Id> materialDataIdToPartFamilyId = new Map<String, Id>();
        for (compliancequest__SQX_Part_Family__c partFamily : [SELECT Id, Name,Material_Number__c FROM compliancequest__SQX_Part_Family__c]) {
            materialDataIdToPartFamilyId.put(partFamily.Name, partFamily.Id);
        }
            if (!materialDataIdToPartFamilyId.containsKey(material.Material_General_Data__r.Name) && material.Material_General_Data__r.Name != null) {
                // If Part Family doesn't exist, create it based on Material General Data
                compliancequest__SQX_Part_Family__c partFamily = new compliancequest__SQX_Part_Family__c();
                partFamily.Material_Number__c = material.Material_General_Data__r.Material_Number__c;
                partFamily.Name = material.Material_General_Data__r.Name;
                insert partFamily; // Insert the Part Family
                part.compliancequest__Part_Family__c = partFamily.Id;
            } else {
                // If Part Family exists, get its ID
                part.compliancequest__Part_Family__c = materialDataIdToPartFamilyId.get(material.Material_General_Data__r.Name);
            }
        }
    public static void handleChange(List<Material_Sales_Data2__c> processMaterials) {
        
        List<compliancequest__SQX_Part__c> ProductList =  new List<compliancequest__SQX_Part__c>();
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
        for(Material_Sales_Data2__c material: [SELECT Id, Active_Material__c, Material_General_Data__r.Name, Material_General_Data__r.Material_Number__c, Record_Key__c, 
                                               Material_Desc__c, DistChan_MatStat_Code__c,Name, Material_Number__c, Sales_Org_Code__c, Sales_Unit__c, Old_Material_Number__c FROM Material_Sales_Data2__c WHERE Id IN:processMaterials]) {
    	system.debug('material activa dtate++++++++ '+ material.Active_Material__c);
            boolean checkZD = false;
            compliancequest__SQX_Part__c part = new compliancequest__SQX_Part__c();
			createPartFamily(material, part);    
            part.MSD2__c = material.Id;
            if(material.Material_Desc__c != null){
                part.Name = material.Material_Desc__c;
            }
            else{
                part.Name = material.Name;
            }
            //part.Material_Name_SAP__c = material.Name;
            part.compliancequest__Part_Number__c = material.Material_Number__c;
            part.Sales_org__c = material.Sales_Org_Code__c;
            //part.Dist_channel__c = material.Dist_Channel_Code__c;
            part.Is_Material_Updated__c = true;
            
            if(uomsMap.get(material.Sales_Unit__c)!=null){
                part.Sales_Unit_of_Measure__c = uomsMap.get(material.Sales_Unit__c);
            }
            else{
                part.Sales_Unit_of_Measure__c = material.Sales_Unit__c;
            }
            
            part.Old_Material_Number__c = material.Old_Material_Number__c;
            
            if(material.DistChan_MatStat_Code__c == 'ZD'){
                checkZD = true;
            }
            part.compliancequest__Active__c = material.Active_Material__c == 'Y' && checkZD == false ? true : false;
            
            
            ProductList.add(part);
        }
        System.debug('ProductList+++++' + ProductList);
        if(ProductList.size() > 0) {
            //Upserting Product
            Schema.SObjectField ftoken = compliancequest__SQX_Part__c.Fields.compliancequest__Part_Number__c;
            database.UpsertResult[] myResult=database.upsert(ProductList,ftoken,false);
            System.debug('myResult success==='+myResult);
            for(Integer i=0; i < myResult.size(); i++) {
                if(myResult.get(i).isSuccess()){
                    System.debug('success==='+myResult.get(i));
                    if(myResult.get(i).isCreated()){
                        System.debug('created success==='+myResult.get(i));
                        //insertedProductList.put(myResult.get(i).Id,ProductList[i].MSD2__c);
                    }
                }
            }
        }
    }
}
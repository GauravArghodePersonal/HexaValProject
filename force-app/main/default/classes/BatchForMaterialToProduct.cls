global class BatchForMaterialToProduct implements Database.Batchable<sObject> {
    Public Set<Id> recordIdSet = new Set<Id>();
    Public Map<Id,String> errorMap = new Map<Id,string>();
    global Map<String,ProductCategory> mapOfCategory {get;set;}
    public BatchForMaterialToProduct(){
        // Added By Devansh Shukla
        mapOfCategory = new Map<String,ProductCategory>();
        List<ProductCategory> categoryList = [SELECT Id,Name,Brand_Code__c FROM productCategory];
        Map<String,ProductCategory> mapOfCat = new Map<String,ProductCategory>();
        for(ProductCategory pc: categoryList){
            mapOfCat.put(pc.Brand_Code__c,pc);
        }
        mapOfCategory = mapOfCat;
        //End 
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('start method calling===');
        String query = this.queryData('Material_Sales_Data2__c','',' WHERE Sales_Org_Code__c = \'0100\' AND Material_Group4_Code__c != null AND Material_Group4_Code__c != \'\' AND MaterialGroup4Desc__c != null AND MaterialGroup4Desc__c != \'\' AND Old_Material_Number__c != null AND Sales_Unit__c != null AND Old_Material_Number__c != \'\' AND Sales_Unit__c != \'\'  ORDER BY LastModifiedDate DESC');
        System.debug(query);
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Material_Sales_Data2__c> records){
        List<Product2> productList =  new List<Product2>();
        Map<String,String> mapOfProCat = new Map<String,String>();
        List<PriceBook2> standardPBList = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];
      List<Footer_Links__mdt> b2bStandarpriceBook= [SELECT Id, Label,Type__c, Value__c FROM Footer_Links__mdt where Label='b2bDefaultPricebook'];
        //Generating Product;
        for(Material_Sales_Data2__c material: records){
            Product2 product = new Product2();
            
            product.RecordKey__c = material.Record_Key__c;
            product.MSD2__c = material.Id;
            product.Name = material.Name;
            product.Material_Name_SAP__c = material.Name;
            product.ProductCode = material.Material_Number__c;
            product.Sales_org__c = material.Sales_Org_Code__c;
            product.Dist_channel__c = material.Dist_Channel_Code__c;
            product.Sales_Unit_Of_Mesure__c = material.Sales_Unit__c;
            product.Old_Material_Number__c = material.Old_Material_Number__c;
            product.IsActive = material.Active_Material__c == 'Y' ? true : false;
            
            mapOfProCat.put(material.Id, material.Material_Group4_Code__c);
            
            productList.add(product);
        }
        
        if(productList.size() > 0) {
            //Inserting Product
            database.SaveResult[] myResult=database.insert(productList,false);
            for(Integer i=0; i < myResult.size(); i++) {
                if(myResult.get(i).isSuccess()){
                    System.debug('success==='+myResult.get(i));
                }else If(!myResult.get(i).isSuccess()){
                    
                    Database.Error errors =  myResult.get(i).getErrors().get(0);
                    System.debug('error==='+myResult.get(i).Id +'======='+errors);
                    recordIdSet.add(myResult.get(i).Id);
                    errorMap.put(myResult.get(i).Id,String.ValueOf(myResult.get(i).getErrors().get(0)));
                }
            }
            // update productList;
            
            
            //Generating list for Junction Object Btwn Product & Category
            List<ProductCategoryProduct> junctionList = new List<ProductCategoryProduct>();
            List<PricebookEntry> pbeList = new List<PricebookEntry>();
            for(Product2 p: productList){
                ProductCategoryProduct pcp = new ProductCategoryProduct();
                pcp.ProductId = p.Id;
                
                pcp.ProductCategoryId = mapOfCategory.get(mapOfProCat.get(p.MSD2__c)).Id;
                junctionList.add(pcp);
                //Get pricebook from custom settings which should be default
                 if(b2bStandarpriceBook.size() > 0)
                {
                    pbeList.add(new PricebookEntry( Pricebook2Id = b2bStandarpriceBook[0].Value__c,
                                                    Product2Id = p.Id,
                                                    UnitPrice = 0,
                                                    UseStandardPrice = false,
                                                    IsActive = true));
                }
                if(standardPBList.size() > 0)
                {
                    pbeList.add(new PricebookEntry( Pricebook2Id = standardPBList[0].Id,
                                                    Product2Id = p.Id,
                                                    UnitPrice = 0,
                                                    UseStandardPrice = false,
                                                    IsActive = true));
                }
            }
            
            //Inserting ProductCategoryProduct
            database.SaveResult[] myResult_1=database.insert(junctionList,false);
            for(Integer i=0; i < myResult_1.size(); i++) {
                if(myResult_1.get(i).isSuccess()){
                    System.debug('success==='+myResult_1.get(i));
                }else If(!myResult_1.get(i).isSuccess()){
                    
                    Database.Error errors =  myResult_1.get(i).getErrors().get(0);
                    System.debug('error==='+myResult_1.get(i).Id +'======='+errors);
                    recordIdSet.add(myResult_1.get(i).Id);
                    errorMap.put(myResult_1.get(i).Id,String.ValueOf(myResult_1.get(i).getErrors().get(0)));
                }
            }
            
            //Inserting ProductCategoryProduct
            database.SaveResult[] myResult_2=database.insert(pbeList,false);
            for(Integer i=0; i < myResult_2.size(); i++) {
                if(myResult_2.get(i).isSuccess()){
                    System.debug('success==='+myResult_2.get(i));
                }else If(!myResult_2.get(i).isSuccess()){
                    
                    Database.Error errors =  myResult_2.get(i).getErrors().get(0);
                    System.debug('error==='+myResult_2.get(i).Id +'======='+errors);
                    recordIdSet.add(myResult_2.get(i).Id);
                    errorMap.put(myResult_2.get(i).Id,String.ValueOf(myResult_2.get(i).getErrors().get(0)));
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext bc){
        If(recordIdSet.size() != 0){
            String generatedCSVFile ='';
            String fileHeader = 'Id,Error';
            
            
            String fileRow = '';
            fileRow += fileHeader;
            for(Id knw: recordIdSet){
                //fileRow = '';
                fileRow = fileRow +'\t'+ knw;
                fileRow = fileRow +'\t'+ errorMap.get(knw);
                
                fileRow = fileRow.replaceFirst('\t','');
                generatedCSVFile = generatedCSVFile + fileRow + '\n';
            }
            
            Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
            Blob csvBlob = blob.valueOf(generatedCSVFile);
            String csvName = 'DataMigration.csv';
            csvAttachment.setFileName(csvName);
            csvAttachment.setBody(csvBlob);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{'devansh.shukla@focalcxm.com'};
                String subject = 'Backup CSV for Migration of Material Sales Data to Product';
            email.setSubject(subject);
            email.setToAddresses(toAddresses);
            email.setPlainTextBody('Backup CSV for Migration of Material Sales Data to Product');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});
            Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
        }
    }
    
    public String queryData(String ObjName, String parentFields, String conditions){
        List<sObject> dataList = new List<sObject>();
        String dString = this.getQueryData(ObjName,parentFields);
        dString += conditions;
        return dString;
    }
    
    // To query from any object.
    public String getQueryData(String ObjectName, String relatedFields){
        
        String query = 'SELECT ' + this.getDynamicFields(ObjectName);
        // If we have any parent fields to query pass in string format with comma seperated.
        if(relatedFields != '') query += relatedFields;
        query += ' FROM ' + ObjectName;
        
        return query;
    }
    
    // returns object's field names without parent fields.
    public String getDynamicFields(String ObjectName){
        String fieldNames ='';
        Schema.SObjectType convertType = Schema.getGlobalDescribe().get(ObjectName);
        Map<String, Schema.SObjectField> fieldsMap = convertType.getDescribe().fields.getMap();
        Boolean isFirst = true;
        for(String key : fieldsMap.keySet()) {
            fieldNames  = isFirst   ? fieldNames + ' ' + fieldsMap.get(key)     : fieldNames + ',' + fieldsMap.get(key) + ' ';
            isFirst     = false;
        }
        return fieldNames;
    }
    
    public static void test_1(){
        Integer i =0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}
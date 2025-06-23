global class b2bBatchToUpdateMaterialToProduct implements Database.Batchable<sObject> {
    Public Set<Id> recordIdSet = new Set<Id>();
    Public Map<Id,String> errorMap = new Map<Id,string>();
    global Map<String,ProductCategory> mapOfCategory {get;set;}
    global map<Id,list<id>> brandToAccountListMap = new map<Id,list<id>>();
    global map<string,id> brandNameToIdMap = new map<string,id>();
    global map<string,id> policyNameToIdMap = new map<string,id>();

    public b2bBatchToUpdateMaterialToProduct(){
        // Added By Devansh Shukla
        mapOfCategory = new Map<String,ProductCategory>();
        brandNameToIdMap = new map<string,id>();
        policyNameToIdMap = new map<string,id>();
        List<ProductCategory> categoryList = [SELECT Id,Name,Brand_Code__c,Brand_Name_As_Account__c FROM productCategory];
        Map<String,ProductCategory> mapOfCat = new Map<String,ProductCategory>();
        for(ProductCategory pc: categoryList){
            mapOfCat.put(pc.Brand_Code__c,pc);
            brandNameToIdMap.put(pc.Brand_Name_As_Account__c,pc.Id);
        }
        mapOfCategory = mapOfCat;
        //End 
        
        brandToAccountListMap = new map<Id,list<id>>();
        for(Account acc : [SELECT Id,SAP_Sales_Org__c,SAP_Attribute1_Desc__c,SAP_Attribute2_Desc__c,SAP_Attribute3_Desc__c,SAP_Attribute4_Desc__c,SAP_Attribute5_Desc__c,SAP_Attribute6_Desc__c,SAP_Attribute7_Desc__c,SAP_Attribute8_Desc__c,SAP_Attribute9_Desc__c,SAP_Attribute10_Desc__c FROM Account where isBuyer = True]){
            List<id> tempAccountList = new List<Id>();
            if(acc.SAP_Attribute1_Desc__c != null){
                if(brandToAccountListMap.get(brandNameToIdMap.get(acc.SAP_Attribute1_Desc__c) ) != null){
                    tempAccountList.addAll(brandToAccountListMap.get(brandNameToIdMap.get(acc.SAP_Attribute1_Desc__c)));
                }
                tempAccountList.add(acc.Id);
                brandToAccountListMap.put(brandNameToIdMap.get(acc.SAP_Attribute1_Desc__c) ,tempAccountList);
            }
            
            if(acc.SAP_Attribute2_Desc__c != null){
                tempAccountList = new List<Id>();
                if(brandToAccountListMap.get(brandNameToIdMap.get(acc.SAP_Attribute2_Desc__c) ) != null){
                    tempAccountList.addAll(brandToAccountListMap.get(brandNameToIdMap.get(acc.SAP_Attribute2_Desc__c)));
                }
                tempAccountList.add(acc.Id);
                brandToAccountListMap.put(brandNameToIdMap.get(acc.SAP_Attribute2_Desc__c) ,tempAccountList);
            }

            if(acc.SAP_Attribute3_Desc__c != null){
                tempAccountList = new List<Id>();
                if(brandToAccountListMap.get(brandNameToIdMap.get(acc.SAP_Attribute3_Desc__c) ) != null){
                    tempAccountList.addAll(brandToAccountListMap.get(brandNameToIdMap.get(acc.SAP_Attribute3_Desc__c )));
                }
                tempAccountList.add(acc.Id);
                brandToAccountListMap.put(brandNameToIdMap.get(acc.SAP_Attribute3_Desc__c) ,tempAccountList);
            }

            if(acc.SAP_Attribute4_Desc__c != null){
                tempAccountList = new List<Id>();
                if(brandToAccountListMap.get(brandNameToIdMap.get(acc.SAP_Attribute4_Desc__c )) != null){
                    tempAccountList.addAll(brandToAccountListMap.get(brandNameToIdMap.get(acc.SAP_Attribute4_Desc__c) ));
                }
                tempAccountList.add(acc.Id);
                brandToAccountListMap.put(brandNameToIdMap.get(acc.SAP_Attribute4_Desc__c) ,tempAccountList);
            }
            
            if(acc.SAP_Attribute5_Desc__c != null){
                tempAccountList = new List<Id>();
                if(brandToAccountListMap.get(brandNameToIdMap.get(acc.SAP_Attribute5_Desc__c) ) != null){
                    tempAccountList.addAll(brandToAccountListMap.get(brandNameToIdMap.get(acc.SAP_Attribute5_Desc__c) ));
                }
                tempAccountList.add(acc.Id);
                brandToAccountListMap.put(brandNameToIdMap.get(acc.SAP_Attribute5_Desc__c),tempAccountList);
            }

            if(acc.SAP_Attribute6_Desc__c != null){
                tempAccountList = new List<Id>();
                if(brandToAccountListMap.get(brandNameToIdMap.get(acc.SAP_Attribute6_Desc__c) ) != null){
                    tempAccountList.addAll(brandToAccountListMap.get(brandNameToIdMap.get(acc.SAP_Attribute6_Desc__c) ));
                }
                tempAccountList.add(acc.Id);
                brandToAccountListMap.put(brandNameToIdMap.get(acc.SAP_Attribute6_Desc__c) ,tempAccountList);
            }

            if(acc.SAP_Attribute7_Desc__c != null){
                tempAccountList = new List<Id>();
                if(brandToAccountListMap.get(brandNameToIdMap.get(acc.SAP_Attribute7_Desc__c) ) != null){
                    tempAccountList.addAll(brandToAccountListMap.get(brandNameToIdMap.get(acc.SAP_Attribute7_Desc__c)));
                }
                tempAccountList.add(acc.Id);
                brandToAccountListMap.put(brandNameToIdMap.get(acc.SAP_Attribute7_Desc__c),tempAccountList);
            }

            if(acc.SAP_Attribute8_Desc__c != null){
                tempAccountList = new List<Id>();
                if(brandToAccountListMap.get(brandNameToIdMap.get(acc.SAP_Attribute8_Desc__c) ) != null){
                    tempAccountList.addAll(brandToAccountListMap.get(brandNameToIdMap.get(acc.SAP_Attribute8_Desc__c) ));
                }
                tempAccountList.add(acc.Id);
                brandToAccountListMap.put(brandNameToIdMap.get(acc.SAP_Attribute8_Desc__c) ,tempAccountList);
            }

            if(acc.SAP_Attribute9_Desc__c != null){
                tempAccountList = new List<Id>();
                if(brandToAccountListMap.get(brandNameToIdMap.get(acc.SAP_Attribute9_Desc__c) ) != null){
                    tempAccountList.addAll(brandToAccountListMap.get(brandNameToIdMap.get(acc.SAP_Attribute9_Desc__c) ));
                }
                tempAccountList.add(acc.Id);
                brandToAccountListMap.put(brandNameToIdMap.get(acc.SAP_Attribute9_Desc__c) ,tempAccountList);
            }

            if(acc.SAP_Attribute10_Desc__c != null){
                tempAccountList = new List<Id>();
                if(brandToAccountListMap.get(brandNameToIdMap.get(acc.SAP_Attribute10_Desc__c) ) != null){
                    tempAccountList.addAll(brandToAccountListMap.get(brandNameToIdMap.get(acc.SAP_Attribute10_Desc__c )));
                }
                tempAccountList.add(acc.Id);
                brandToAccountListMap.put(brandNameToIdMap.get(acc.SAP_Attribute10_Desc__c) ,tempAccountList);
            }
            
            tempAccountList = new List<Id>();
            if(brandToAccountListMap.get(brandNameToIdMap.get('ALGAESHIELD®' )) != null){
                tempAccountList.addAll(brandToAccountListMap.get(brandNameToIdMap.get('ALGAESHIELD®')));
            }
            tempAccountList.add(acc.Id);
            brandToAccountListMap.put(brandNameToIdMap.get('ALGAESHIELD®') ,tempAccountList);

            tempAccountList = new List<Id>();
            if(brandToAccountListMap.get(brandNameToIdMap.get('PRISTINEBLUE®')) != null){
                tempAccountList.addAll(brandToAccountListMap.get(brandNameToIdMap.get('PRISTINEBLUE®') ));
            }
            tempAccountList.add(acc.Id);
            brandToAccountListMap.put(brandNameToIdMap.get('PRISTINEBLUE®'),tempAccountList);

            tempAccountList = new List<Id>();
            if(brandToAccountListMap.get(brandNameToIdMap.get('CCH, Ultima, Water Testing, Misc')) != null){
                tempAccountList.addAll(brandToAccountListMap.get(brandNameToIdMap.get('CCH, Ultima, Water Testing, Misc') ));
            }
            tempAccountList.add(acc.Id);
            brandToAccountListMap.put(brandNameToIdMap.get('CCH, Ultima, Water Testing, Misc'),tempAccountList);
        }

        System.debug('brandToAccountListMap+++++ ' + brandToAccountListMap);

        for(CommerceEntitlementPolicy policy : [Select Id,Name from CommerceEntitlementPolicy]){
            policyNameToIdMap.put(policy.Name, policy.Id);
        }
        System.debug('policyNameToIdMap+++++ ' + policyNameToIdMap);
    
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('start method calling===');
        String query = this.queryData('Material_Sales_Data2__c','',' WHERE Sales_Org_Code__c = \'0100\' AND Material_Group4_Code__c != null AND Material_Group4_Code__c != \'\' AND MaterialGroup4Desc__c != null AND MaterialGroup4Desc__c != \'\' AND Old_Material_Number__c != null AND Sales_Unit__c != null AND Old_Material_Number__c != \'\' AND Sales_Unit__c != \'\' AND LastModifiedDate = TODAY');
        System.debug(query);
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Material_Sales_Data2__c> records){
        List<Product2> productList =  new List<Product2>();
        Map<String,String> mapOfProCat = new Map<String,String>();
        Map<Id,Id> insertedProductList =  new Map<id,Id>();
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
            //Upserting Product
            Schema.SObjectField ftoken = Product2.Fields.RecordKey__c;
            database.UpsertResult[] myResult=database.upsert(productList,ftoken,false);
            System.debug('myResult success==='+myResult);
            for(Integer i=0; i < myResult.size(); i++) {
                if(myResult.get(i).isSuccess()){
                    System.debug('success==='+myResult.get(i));
                    if(myResult.get(i).isCreated()){
                        System.debug('created success==='+myResult.get(i));
                        insertedProductList.put(myResult.get(i).Id,productList[i].MSD2__c);
                    }
                }
                else If(!myResult.get(i).isSuccess()){
                    
                    Database.Error errors =  myResult.get(i).getErrors().get(0);
                    System.debug('error==='+myResult.get(i).Id +'======='+errors);
                    recordIdSet.add(myResult.get(i).Id);
                    errorMap.put(myResult.get(i).Id,String.ValueOf(myResult.get(i).getErrors().get(0)));
                }
            }
            System.debug('inserted products list++ ' + insertedProductList);
            // update productList;
            
            
            //Generating list for Junction Object Btwn Product & Category
            List<ProductCategoryProduct> junctionList = new List<ProductCategoryProduct>();
            List<PricebookEntry> pbeList = new List<PricebookEntry>();
            for(Id p: insertedProductList.keySet()){
                System.debug('inserted product+++' + p);
                ProductCategoryProduct pcp = new ProductCategoryProduct();
                pcp.ProductId = p;
                
                pcp.ProductCategoryId = mapOfCategory.get(mapOfProCat.get(insertedProductList.get(p))).Id;
                junctionList.add(pcp);
                //Get pricebook from custom settings which should be default
                System.debug('b2bStandarpriceBook+++' + b2bStandarpriceBook);
                if(standardPBList.size() > 0)
                {
                    System.debug('Inside standard price book assignment+++');
                    pbeList.add(new PricebookEntry( Pricebook2Id = standardPBList[0].Id,
                                                    Product2Id = p,
                                                    UnitPrice = 0,
                                                    UseStandardPrice = false,
                                                    IsActive = true));
                }
                 if(b2bStandarpriceBook.size() > 0)
                {
                    System.debug('Inside price book assignment+++');
                    pbeList.add(new PricebookEntry( Pricebook2Id = b2bStandarpriceBook[0].Value__c,
                                                    Product2Id = p,
                                                    UnitPrice = 0,
                                                    UseStandardPrice = false,
                                                    IsActive = true));
                }
            }
            System.debug('junctionList++++++++ ' + junctionList);
            System.debug('pbeList++++++++ ' + pbeList);
            Map<Id,list<Id>> insertedBrandToProductsMap = new Map<Id,list<Id>>();

            //Inserting ProductCategoryProduct
            database.SaveResult[] myResult_1=database.insert(junctionList,false);
            for(Integer i=0; i < myResult_1.size(); i++) {
                if(myResult_1.get(i).isSuccess()){
                    System.debug('success==='+myResult_1.get(i));
                    List<id> tempproductList = new List<Id>();
                    if(insertedBrandToProductsMap.get(junctionList.get(i).ProductCategoryId) != null){
                        tempproductList = insertedBrandToProductsMap.get(junctionList.get(i).ProductCategoryId);
                    }
                    tempproductList.add(junctionList.get(i).ProductId);
                    insertedBrandToProductsMap.put(junctionList.get(i).ProductCategoryId,tempproductList);

                }
                else If(!myResult_1.get(i).isSuccess()){
                    
                    Database.Error errors =  myResult_1.get(i).getErrors().get(0);
                    System.debug('error==='+myResult_1.get(i).Id +'======='+errors);
                    recordIdSet.add(myResult_1.get(i).Id);
                    errorMap.put(myResult_1.get(i).Id,String.ValueOf(myResult_1.get(i).getErrors().get(0)));
                }
            }
            System.debug('insertedBrandToProductsMap++++++++ ' + insertedBrandToProductsMap);

            
            //Inserting pricebook
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

            //insert into entitlement policies for new product and run search index
            List<CommerceEntitlementProduct> entitlesProductList = new List<CommerceEntitlementProduct>();
            for(Id brandId : insertedBrandToProductsMap.keySet()){
                for(Id productId : insertedBrandToProductsMap.get(brandId)){ //brandToAccountListMap
                    for(Id accountId : brandToAccountListMap.get(brandId)){
                        CommerceEntitlementProduct cep = new CommerceEntitlementProduct(PolicyId = policyNameToIdMap.get(String.valueOf(accountId)),
                                                                                        ProductId = productId);
                        entitlesProductList.add(cep);

                    }
                }
            }
            System.debug('entitlesProductList++++++ ' + entitlesProductList);
            database.SaveResult[] myResult_3=database.insert(entitlesProductList,false);

            //if product is getting inactive, remove from entitlement -- how check if flag was changed but not the other field.
            
            //if product is getting active, add in entitlement -- how check if flag was changed but not the other field.

            //can category or salesorg change for material? -- it will have multiple implications
        }
    }
    
    global void finish(Database.BatchableContext bc){
        If(recordIdSet.size() != 0){
           /* String generatedCSVFile ='';
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
            Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});*/
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

    /*public static void test_1(){
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
    }*/
    
}
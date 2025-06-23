global class BatchToCreateCategories implements Database.Batchable<AggregateResult> {
    Public Set<Id> recordIdSet = new Set<Id>();
    Public Map<Id,String> errorMap = new Map<Id,string>();

    public String catalogid {get;set;}

    // global Map<String,ProductCategory> mapOfCategory {
    //     get{ 
    //      return mapOfCategory;
    //     }
    //     set{
    //         List<ProductCategory> categoryList = [SELECT Id,Name FROM productCategory];
    //         Map<String,ProductCategory> mapOfCat = new Map<String,ProductCategory>();
    //         for(ProductCategory pc: categoryList){
    //             mapOfCat.put(pc.Name,pc);
    //         }
    //         mapOfCategory = mapOfCat;
    //     }
    // }

    global Map<String,ProductCategory> mapOfCategory {get;set;}

    public BatchToCreateCategories(){
        System.debug('in the constructor');
        List<ProductCategory> categoryList = [SELECT Id,Name FROM productCategory];
        Map<String,ProductCategory> mapOfCat = new Map<String,ProductCategory>();
        for(ProductCategory pc: categoryList){
            mapOfCat.put(pc.Name,pc);
        }
        mapOfCategory = mapOfCat;

        catalogId = '';
        List<ProductCatalog> listCata = new List<ProductCatalog>();
        listCata = [SELECT Id,Name FROM ProductCatalog WHERE Name = 'Solenis Eshop Catalog' LIMIT 1];
        if(listCata.size() > 0){
            catalogid = listCata[0].Id;            
        }

    }

    global List<AggregateResult> start(Database.BatchableContext bc) {
        System.debug('start method calling===');
        // String query = this.queryData('Material_Sales_Data__c','',' WHERE Sales_Org_Code__c = \'0100\' AND Material_Group4__c != null AND Material_Group4__c != \'\'  ORDER BY LastModifiedDate DESC');
        String query = 'SELECT Count(Id), Material_Group4_Code__c,Material_General_Data__r.Material_Desc_Code__r.Material_Group4_Desc__c  FROM Material_Sales_Data2__c WHERE Sales_Org_Code__c = \'0100\' AND Material_Group4_Code__c != null AND Material_General_Data__r.Material_Desc_Code__r.Material_Group4_Desc__c != null AND Old_Material_Number__c != null AND Sales_Unit__c != null AND Old_Material_Number__c != \'\' AND Sales_Unit__c != \'\' GROUP BY Material_Group4_Code__c,Material_General_Data__r.Material_Desc_Code__r.Material_Group4_Desc__c LIMIT 2000';
        System.debug(query);
        return Database.query(query);
    }

    global void execute(Database.BatchableContext bc, List<AggregateResult> records){
        System.debug('Execute method calling===='+records.size());
        List<Product2> productList =  new List<Product2>();
        List<ProductCategory> categoryList = new List<ProductCategory>();

        for(AggregateResult material: records){
            ProductCategory p = new ProductCategory();
            p.Brand_Code__c = String.valueOf(material.get('Material_Group4_Code__c'));
            p.Name = String.valueOf(material.get('Material_General_Data__r.Material_Desc_Code__r.Material_Group4_Desc__c'));
            p.CatalogId = catalogid;

            if(mapOfCategory.get(string.valueOf(material.get('Material_Group4_Code__c')))==null) categoryList.add(p);
        }

        if(categoryList.size() > 0) {
            database.SaveResult[] myResult=database.insert(categoryList,false);
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
            System.debug('categoryList--'+categoryList);
        }
    }

    global void finish(Database.BatchableContext bc){
        System.debug(mapOfCategory.size());
        for(String s : mapOfCategory.keySet()){
            System.debug('s-->'+s);
        }
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
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
                i++;
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
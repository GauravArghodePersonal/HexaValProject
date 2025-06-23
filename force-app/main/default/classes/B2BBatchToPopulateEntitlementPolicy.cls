/*****************************************************************
* Class Name     : B2BBatchToPopulateEntitlementPolicy                            *
* Author         : Jyoti                                    *
* Description    : This creates entitlement policies for Sold To accounts for B2B Platform. To be used for intial go-live.*
*****************************************************************/

global class B2BBatchToPopulateEntitlementPolicy implements Database.Batchable<sObject>,Database.Stateful{
    
    global map<String,List<Id>> brandToProductListMap = new Map<String,List<Id>>();
    global map<String,id> brandNameToIdMap = new Map<String,id>();
    
    global Database.QueryLocator start(Database.BatchableContext bc){
    
        //ProductCategory  Product2   ProductCategoryProduct
        //get Brand name to Id --
        /*for(ProductCategory pc: [Select id,Name,(Select id,ProductId from ProductCategoryProducts) from ProductCategory]){
            brandNameToIdMap.put(pc.name,pc.id);
            List<Id> tempProductList = new List<Id>();
            for(ProductCategoryProduct pcp : pc.ProductCategoryProducts){
                tempProductList.add(pcp.ProductId);
            }
            brandToProductListMap.put(pc.Name,tempProductList);
        }*/
        for (ProductCategoryProduct pcp : [SELECT ProductCategoryId,ProductCategory.Name,ProductCategory.Brand_Code__c,ProductCategory.Brand_Name_As_Account__c,ProductId,Product.Sales_org__c,ProductToCategory FROM ProductCategoryProduct])
        {
            List<Id> tempProductList = new List<Id>();
            if(brandToProductListMap.get(pcp.ProductCategory.Brand_Name_As_Account__c +'_' +pcp.Product.Sales_org__c) != null){
                tempProductList.addAll(brandToProductListMap.get(pcp.ProductCategory.Brand_Name_As_Account__c +'_' +pcp.Product.Sales_org__c));
            }
            tempProductList.add(pcp.ProductId);
            brandToProductListMap.put(pcp.ProductCategory.Brand_Name_As_Account__c +'_' +pcp.Product.Sales_org__c,tempProductList);
        
        }
        
        System.debug('brandNameToIdMap data++++' + brandNameToIdMap);
        System.debug('brandToProductListMap data++++' + brandToProductListMap);
        
        String soqlQuery = 'SELECT id,Name,SAP_Sales_Org__c,SAP_Attribute1_Desc__c,SAP_Attribute2_Desc__c,SAP_Attribute3_Desc__c,SAP_Attribute4_Desc__c,SAP_Attribute5_Desc__c,SAP_Attribute6_Desc__c,SAP_Attribute7_Desc__c,SAP_Attribute8_Desc__c,SAP_Attribute9_Desc__c,SAP_Attribute10_Desc__c From Account where Enable_As_Buyer_Account__c = true and isBuyer = False';
        return Database.getQueryLocator(soqlQuery);
    }
     
    global void execute(Database.BatchableContext bc, List<Account> scope){
        List<BuyerAccount> enableAccountAsBuyer = new List<BuyerAccount>();
        List<BuyerGroup> createBuyerGroup = new List<BuyerGroup>();
        List<BuyerGroupMember> assignBuyerGroupMember = new List<BuyerGroupMember>();
        List<WebStoreBuyerGroup> assignBuyerGroupToStore = new List<WebStoreBuyerGroup>();
        List<CommerceEntitlementPolicy> entitlementPolicyList = new List<CommerceEntitlementPolicy>();
        List<CommerceEntitlementBuyerGroup> entitlementPolicyGroupList = new List<CommerceEntitlementBuyerGroup>();
        List<CommerceEntitlementProduct> entitlementProductsList = new List<CommerceEntitlementProduct>();
        Map<String,id> mapBuyerGroupNametoIdMap =  new Map<String,id>();
        Map<String,id> mapEntitlePolicyNametoId =  new Map<String,id>();
        Map<id,Set<String>> accountToBrandListMap = new Map<id,Set<String>>();
        
        WebStore store = [select id,Name from WebStore where Name = 'Solenis Eshop'];
        
        System.debug('scope data++++' + scope);
        
        if(scope.size()>0){
             for (Account acc : scope){
                 //Convert Account to Buyer Account
                 BuyerAccount buyer = new BuyerAccount(BuyerId = acc.id,CommerceType = 'Buyer',
                                                         IsActive = true, Name = acc.Name);
                                                         
                 enableAccountAsBuyer.add(buyer);
                 
                 //Create Buyer group for each account -- Name has to be unique
                 BuyerGroup buyerGroup = new BuyerGroup(Name = acc.id);
                 createBuyerGroup.add(buyerGroup);
                 
                 //Create Entitlementpolicy for each account -- Name has to be unique
                 CommerceEntitlementPolicy entitlementPolicy = new CommerceEntitlementPolicy(IsActive = True,
                                                                                             Name = acc.id ,
                                                                                             CanViewPrice = True,
                                                                                             CanViewProduct = True);
                 entitlementPolicyList.add(entitlementPolicy);       
                 
                 //account to brands list map
                 Set<String> tempBrandList = new Set<String>();
                 if(acc.SAP_Attribute1_Desc__c != null)    
                     tempBrandList.add(acc.SAP_Attribute1_Desc__c+'_'+acc.SAP_Sales_Org__c);    
                 if(acc.SAP_Attribute2_Desc__c != null)    
                     tempBrandList.add(acc.SAP_Attribute2_Desc__c+'_'+acc.SAP_Sales_Org__c);  
                 if(acc.SAP_Attribute3_Desc__c != null)    
                     tempBrandList.add(acc.SAP_Attribute3_Desc__c+'_'+acc.SAP_Sales_Org__c);  
                 if(acc.SAP_Attribute4_Desc__c != null)    
                     tempBrandList.add(acc.SAP_Attribute4_Desc__c+'_'+acc.SAP_Sales_Org__c);  
                 if(acc.SAP_Attribute5_Desc__c != null)    
                     tempBrandList.add(acc.SAP_Attribute5_Desc__c+'_'+acc.SAP_Sales_Org__c);  
                 if(acc.SAP_Attribute6_Desc__c != null)    
                     tempBrandList.add(acc.SAP_Attribute6_Desc__c+'_'+acc.SAP_Sales_Org__c);  
                 if(acc.SAP_Attribute7_Desc__c != null)    
                     tempBrandList.add(acc.SAP_Attribute7_Desc__c+'_'+acc.SAP_Sales_Org__c);  
                 if(acc.SAP_Attribute8_Desc__c != null)    
                     tempBrandList.add(acc.SAP_Attribute8_Desc__c+'_'+acc.SAP_Sales_Org__c);  
                 if(acc.SAP_Attribute9_Desc__c != null)    
                     tempBrandList.add(acc.SAP_Attribute9_Desc__c+'_'+acc.SAP_Sales_Org__c);  
                 if(acc.SAP_Attribute10_Desc__c != null)    
                     tempBrandList.add(acc.SAP_Attribute10_Desc__c+'_'+acc.SAP_Sales_Org__c); 
                    
                     tempBrandList.add('ALGAESHIELD®'+'_'+acc.SAP_Sales_Org__c); 
                     
                     tempBrandList.add('PRISTINEBLUE®'+'_'+acc.SAP_Sales_Org__c); 
                 
                     tempBrandList.add('CCH, Ultima, Water Testing, Misc'+'_'+acc.SAP_Sales_Org__c); 
                     
                 accountToBrandListMap.put(acc.id,tempBrandList);                                                            
             }
             System.debug('accountToBrandListMap data++++' + accountToBrandListMap);
             
             insert enableAccountAsBuyer;
             insert createBuyerGroup;
             insert entitlementPolicyList;
             System.debug('enableAccountAsBuyer data++++' + enableAccountAsBuyer);
             System.debug('createBuyerGroup data++++' + createBuyerGroup);
             System.debug('entitlementPolicyList data++++' + entitlementPolicyList);
             
             
             //Assign Buyer Group to same store and get map of buyer groups - Name being unique key
             for(BuyerGroup bg : createBuyerGroup){
                 mapBuyerGroupNametoIdMap.put(bg.Name,bg.Id);
                 WebStoreBuyerGroup storeBuyerGroup = new WebStoreBuyerGroup(WebStoreId = store.id, 
                                                                             BuyerGroupId = bg.id);
                 assignBuyerGroupToStore.add(storeBuyerGroup);                                                           
             }
             insert assignBuyerGroupToStore;
             System.debug('assignBuyerGroupToStore data++++' + assignBuyerGroupToStore);
             
             //Get map of Entitlement Policies -- Name being unique key
             for(CommerceEntitlementPolicy cep : entitlementPolicyList){
                 mapEntitlePolicyNametoId.put(cep.Name,cep.Id);                                                          
             }
             
             for(Account acc : scope){
                 //Assign Buyer Account to its unique buyer group using map -- Name being unique key
                 BuyerGroupMember buyerGroupMember = new BuyerGroupMember(BuyerId = acc.id, 
                                                                          BuyerGroupId = mapBuyerGroupNametoIdMap.get(acc.id) );
                 assignBuyerGroupMember.add(buyerGroupMember);
                 
                 //Assign Entitlement Policy to its unique buyer group using map -- Name being unique key
                 CommerceEntitlementBuyerGroup entitlePolicyGroup = new CommerceEntitlementBuyerGroup(
                                                                         BuyerGroupId = mapBuyerGroupNametoIdMap.get(acc.id),
                                                                         PolicyId = mapEntitlePolicyNametoId.get(acc.id));
                 entitlementPolicyGroupList.add(entitlePolicyGroup);
                 
                 //Assign products to each entitlement policy --CommerceEntitlementProduct
                 List<id> tempProductList= new List<id>();
                 Id policy = mapEntitlePolicyNametoId.get(acc.id);
                 
                 for(String brand : accountToBrandListMap.get(acc.id)){
                     if(brandToProductListMap.get(brand) != null){
                         tempProductList.addAll(brandToProductListMap.get(brand));
                     }
                     
                 }
                 
                 for(Id product : tempProductList){
                     CommerceEntitlementProduct entitlementProduct = new CommerceEntitlementProduct(
                                                                     PolicyId = policy,
                                                                     ProductId = product );
                     entitlementProductsList.add(entitlementProduct);
                 }                
             }
             
             insert assignBuyerGroupMember;
             System.debug('assignBuyerGroupMember data++++' + assignBuyerGroupMember);
             
             insert entitlementPolicyGroupList;
             System.debug('entitlementPolicyGroupList data++++' + entitlementPolicyGroupList);
             
             insert entitlementProductsList;
             System.debug('entitlementProductsList data++++' + entitlementProductsList);
             
            
        }
    }
     
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email, ExtendedStatus
                            from AsyncApexJob where Id = :BC.getJobId()];
        
        // Email the Batch Job's submitter that the Job is finished.
        
        
        
    }
}
/*****************************************************************
* Class Name     : B2BBatchToPopulateEntitlementPolicyV2                            *
* Author         : Jyoti                                    *
* Description    : This creates entitlement policies for Sold To accounts for B2B Platform. To be used for intial go-live. Unique key is Brand name.*
*****************************************************************/

global class B2BBatchToPopulateEntitlementPolicyV2 implements Database.Batchable<sObject>,Database.Stateful{
    
    global map<String,List<Id>> brandToProductListMap = new Map<String,List<Id>>();
    global map<String,id> brandNameToIdMap = new Map<String,id>();
    global map<Id,List<Account>> soldToShipTosMap = new Map<Id,List<Account>>();
    global map<String,id> buyergroupNameToIdMap = new Map<String,id>();
    
    global Database.QueryLocator start(Database.BatchableContext bc){
    
        
        for (Account acc : [Select Id, Name, SAP_Partner_Functions__c, ParentId ,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet from Account where SAP_Partner_Functions__c like '%Ship To%' and ParentId!=null and parent.Enable_As_Buyer_Account__c = true and parent.isBuyer = false and SAP_Sales_Org__c = '0100']){
            List<Account> tempShipToList = new List<Account>();
            if(soldToShipTosMap.get(acc.ParentId) != null){
                tempShipToList.addAll(soldToShipTosMap.get(acc.ParentId));
            }
            tempShipToList.add(acc);
            soldToShipTosMap.put(acc.ParentId,tempShipToList);
            
        }
        System.debug('soldToShipTosMap data++++' + soldToShipTosMap);
        
        for(BuyerGroup pc: [Select id,Name from BuyerGroup]){
            buyergroupNameToIdMap.put(pc.Name,pc.Id);
        }
        System.debug('buyergroupNameToIdMap data++++' + buyergroupNameToIdMap);
        
        String soqlQuery = 'SELECT id,Name,SAP_Partner_Functions__c,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet,SAP_Sales_Org__c,SAP_Attribute1_Desc__c,SAP_Attribute2_Desc__c,SAP_Attribute3_Desc__c,SAP_Attribute4_Desc__c,SAP_Attribute5_Desc__c,SAP_Attribute6_Desc__c,SAP_Attribute7_Desc__c,SAP_Attribute8_Desc__c,SAP_Attribute9_Desc__c,SAP_Attribute10_Desc__c From Account where Enable_As_Buyer_Account__c = true and isBuyer = False'; //and SAP_Sales_Org__c = \'0100\'
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
        List<ContactPointAddress> accountAddressList = new List<ContactPointAddress>();
        
        WebStore store = [select id,Name from WebStore where Name = 'Solenis Eshop'];
        System.debug('soldToShipTosMap data execute++++' + soldToShipTosMap);
        System.debug('scope data++++' + scope);
        
        if(scope.size()>0){
             for (Account acc : scope){
                 //Convert Sold to Account to Buyer Account
                 BuyerAccount buyer = new BuyerAccount(BuyerId = acc.id,CommerceType = 'Buyer',
                                                         IsActive = true, Name = acc.Id);
                 enableAccountAsBuyer.add(buyer);                                        
                 //Convert Related Ship to Accounts to Buyer Account  
                 if(soldToShipTosMap.get(acc.id) != null){
                     for(Account shipToAccId : soldToShipTosMap.get(acc.id)){
                         BuyerAccount buyer1 = new BuyerAccount(BuyerId = shipToAccId.Id,CommerceType = 'Buyer',
                                                             IsActive = true, Name = acc.Id);
                         enableAccountAsBuyer.add(buyer1);                                   
                     }
                 }
                 
                 system.debug('acc.SAP_Partner_Functions__c+++++++' +acc.SAP_Partner_Functions__c );
                 if(acc.SAP_Partner_Functions__c.contains('Ship To')){
                     system.debug('Ship to Partner function+++++++' );
                     ContactPointAddress cpa = new ContactPointAddress(AddressType = 'Shipping', City= acc.ShippingCity, Country=acc.ShippingCountry ,IsDefault=True, IsPrimary = True, Name=acc.Name ,ParentId =acc.id , PostalCode=acc.ShippingPostalCode, State=acc.ShippingState , Street=acc.ShippingStreet );
                     accountAddressList.add(cpa);
                 }  
                 if(soldToShipTosMap.get(acc.id)!=null){
                     for(Account shipToAccId : soldToShipTosMap.get(acc.id)){
                             ContactPointAddress cpa = new ContactPointAddress(AddressType = 'Shipping', City= shipToAccId.ShippingCity, Country=shipToAccId.ShippingCountry ,IsDefault=True, IsPrimary = True, Name=shipToAccId.Name ,ParentId =shipToAccId.id , PostalCode=shipToAccId.ShippingPostalCode, State=shipToAccId.ShippingState , Street=shipToAccId.ShippingStreet );
                             accountAddressList.add(cpa);
                                                            
                     }
                 }                              
                 
                 //Create Buyer group for each account -- Name will be given for Sold To Account Id
                 /*BuyerGroup buyerGroup = new BuyerGroup(Name = acc.id);
                 createBuyerGroup.add(buyerGroup);*/
                 
                 //account to brands list map
                 Set<String> tempBrandList = new Set<String>();
                 if(acc.SAP_Attribute1_Desc__c != null)    
                     tempBrandList.add(acc.SAP_Attribute1_Desc__c);    
                 if(acc.SAP_Attribute2_Desc__c != null)    
                     tempBrandList.add(acc.SAP_Attribute2_Desc__c);  
                 if(acc.SAP_Attribute3_Desc__c != null)    
                     tempBrandList.add(acc.SAP_Attribute3_Desc__c);  
                 if(acc.SAP_Attribute4_Desc__c != null)    
                     tempBrandList.add(acc.SAP_Attribute4_Desc__c);  
                 if(acc.SAP_Attribute5_Desc__c != null)    
                     tempBrandList.add(acc.SAP_Attribute5_Desc__c);  
                 if(acc.SAP_Attribute6_Desc__c != null)    
                     tempBrandList.add(acc.SAP_Attribute6_Desc__c);  
                 if(acc.SAP_Attribute7_Desc__c != null)    
                     tempBrandList.add(acc.SAP_Attribute7_Desc__c);  
                 if(acc.SAP_Attribute8_Desc__c != null)    
                     tempBrandList.add(acc.SAP_Attribute8_Desc__c);  
                 if(acc.SAP_Attribute9_Desc__c != null)    
                     tempBrandList.add(acc.SAP_Attribute9_Desc__c);  
                 if(acc.SAP_Attribute10_Desc__c != null)    
                     tempBrandList.add(acc.SAP_Attribute10_Desc__c); 
                    
                     /*tempBrandList.add('ALGAESHIELD®'); 
                     
                     tempBrandList.add('PRISTINEBLUE®'); 
                 
                     tempBrandList.add('CCH, Ultima, Water Testing, Misc'); */
                     Footer_Links__mdt[] defaultBrands = [Select MasterLabel, Value__c from Footer_Links__mdt where MasterLabel='Default_Brands'];
                     tempBrandList.addAll(defaultBrands[0].Value__c.split(';'));
                     
                 accountToBrandListMap.put(acc.id,tempBrandList);                                                      
             }
             System.debug('accountToBrandListMap data++++' + accountToBrandListMap);
             System.debug('enableAccountAsBuyer data++++' + enableAccountAsBuyer);
             //System.debug('createBuyerGroup data++++' + createBuyerGroup);
             System.debug('accountAddressList data++++' + accountAddressList);
             
             insert enableAccountAsBuyer;
             //insert createBuyerGroup;
             insert accountAddressList;
                          
             
             //Assign Buyer Group to same store and get map of buyer groups - Name being unique key
             /*for(BuyerGroup bg : createBuyerGroup){
                 mapBuyerGroupNametoIdMap.put(bg.Name,bg.Id);
                 WebStoreBuyerGroup storeBuyerGroup = new WebStoreBuyerGroup(WebStoreId = store.id, 
                                                                             BuyerGroupId = bg.id);
                 assignBuyerGroupToStore.add(storeBuyerGroup);                                                           
             }
             insert assignBuyerGroupToStore;
             System.debug('assignBuyerGroupToStore data++++' + assignBuyerGroupToStore);*/
             
             //Get map of Entitlement Policies -- Name is the name of Brand coming from account attribite
             for(CommerceEntitlementPolicy cep : [Select Id, Name from CommerceEntitlementPolicy]){
                 system.debug('cep.Name++++' + cep.Name);
                 mapEntitlePolicyNametoId.put(cep.Name,cep.Id);                                                          
             }
             
             for(Account acc : scope){
                 //Assign Buyer Account to its unique buyer group using map -- Name being Sold to account id unique key
                 for(String brand: accountToBrandListMap.get(acc.id)){
                     
                     if(buyergroupNameToIdMap.get(brand) != null){
                         BuyerGroupMember buyerGroupMember = new BuyerGroupMember(BuyerId = acc.id, 
                                                                          BuyerGroupId = buyergroupNameToIdMap.get(brand) );
                         assignBuyerGroupMember.add(buyerGroupMember);
                     }
                     
                 }
                 if(soldToShipTosMap.get(acc.id) != null){
                     for(Account shipToId : soldToShipTosMap.get(acc.id)){
                         for(String brand: accountToBrandListMap.get(acc.id)){
                             if(buyergroupNameToIdMap.get(brand) != null){
                                 BuyerGroupMember buyerGroupMember1 = new BuyerGroupMember(BuyerId = shipToId.id, 
                                                                                  BuyerGroupId = buyergroupNameToIdMap.get(brand) );
                                 assignBuyerGroupMember.add(buyerGroupMember1);
                             
                             }
                             
                         }
                     }
                 }
                 
                 
                 //Assign Ship to account to same buyer group as their sold to account
                 /*if(soldToShipTosMap.get(acc.id) != null){
                     for(Account shipToId : soldToShipTosMap.get(acc.id)){
                         BuyerGroupMember buyerGroupMember1 = new BuyerGroupMember(BuyerId = shipToId.Id, 
                                                                              BuyerGroupId = mapBuyerGroupNametoIdMap.get(acc.id) );
                         assignBuyerGroupMember.add(buyerGroupMember1);
                     }
                 }*/
                 
                 system.debug('mapEntitlePolicyNametoId+++++++' + mapEntitlePolicyNametoId);
                 //Add buyer group to all those policies where brands are in attributes.
                 /*for(String brand: accountToBrandListMap.get(acc.id)){
                     system.debug('brand+++++' + brand);
                     system.debug('mapEntitlePolicyNametoId.get(brand)+++++++' + mapEntitlePolicyNametoId.get(brand));
                     if(mapEntitlePolicyNametoId.get(brand) != null){
                         CommerceEntitlementBuyerGroup entitlePolicyGroup = new CommerceEntitlementBuyerGroup(
                                                                         BuyerGroupId = mapBuyerGroupNametoIdMap.get(acc.id),
                                                                         PolicyId = mapEntitlePolicyNametoId.get(brand));
                         entitlementPolicyGroupList.add(entitlePolicyGroup);
                     }
                     
                 
                 }*/
                       
             }
             
             System.debug('assignBuyerGroupMember data++++' + assignBuyerGroupMember);
             insert assignBuyerGroupMember;
        
             //System.debug('entitlementPolicyGroupList data++++' + entitlementPolicyGroupList);
             //insert entitlementPolicyGroupList;
        }
    }
     
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email, ExtendedStatus
                            from AsyncApexJob where Id = :BC.getJobId()];
        
        // Email the Batch Job's submitter that the Job is finished.
        
        
        
    }
}
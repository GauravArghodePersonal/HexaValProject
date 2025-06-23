/*****************************************************************
* Class Name     : ExpConvertAccountToBuyer                            *
* Author         : Aakash Wankhede                                   *
* Description    : It will convert account to buyer when request raised for non-buyer account.*
*****************************************************************/

public class ExpConvertAccountToBuyer {

    /**
    * @description invocable method called in flow to send request to SAP to create new contact when request is approved in SFDC
    */
    
      @InvocableMethod(Label='Account Conversion To Buyer Account' Description='Once Request is Approved Non-Buyer Account Will be Converted to Buyer') 
      public static void processB2BSendContactRequestCreationToSAP(List<New_Contact_Request__c> ids) {
      
        Account accountToConvert = [SELECT id,Name,SAP_Partner_Functions__c,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet,SAP_Sales_Org__c,SAP_Attribute1_Desc__c,SAP_Attribute2_Desc__c,SAP_Attribute3_Desc__c,SAP_Attribute4_Desc__c,SAP_Attribute5_Desc__c,SAP_Attribute6_Desc__c,SAP_Attribute7_Desc__c,SAP_Attribute8_Desc__c,SAP_Attribute9_Desc__c,SAP_Attribute10_Desc__c,isBuyer From Account where Id =:ids[0].B2B_Account_Lookup__c];
        
        system.debug('In Invocable method' + ids);
        map<Id,List<Account>> soldToShipTosMap = new Map<Id,List<Account>>();
        map<String,id> buyergroupNameToIdMap = new Map<String,id>();
        List<BuyerAccount> enableAccountAsBuyer = new List<BuyerAccount>();
        Map<id,Set<String>> accountToBrandListMap = new Map<id,Set<String>>();
        List<ContactPointAddress> accountAddressList = new List<ContactPointAddress>();
        List<BuyerGroupMember> assignBuyerGroupMember = new List<BuyerGroupMember>();
        
        Set<String> tempBrandList = new Set<String>();
             
                 
        Id accountId = accountToConvert.Id;
        for (Account acc : [Select Id, Name, SAP_Partner_Functions__c, ParentId ,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet,isBuyer from Account where SAP_Partner_Functions__c like '%Ship To%' and ParentId!=null and parentId=:accountId and isBuyer=false]){
                List<Account> tempShipToList = new List<Account>();
                if(soldToShipTosMap.get(acc.ParentId) != null){
                    tempShipToList.addAll(soldToShipTosMap.get(acc.ParentId));
                }
                tempShipToList.add(acc);
                soldToShipTosMap.put(acc.ParentId,tempShipToList);
                
        }
        System.debug('soldToShipTosMap data++++' + soldToShipTosMap);
        
          //Do the below logic only if any account is not buyer
          if(accountToConvert.isBuyer==false || soldToShipTosMap.containsKey(accountToConvert.id)){
                 Footer_Links__mdt[] defaultBrands = [Select MasterLabel, Value__c from Footer_Links__mdt where MasterLabel='Default_Brands_Solenis'];
                 tempBrandList.addAll(defaultBrands[0].Value__c.split(';'));
                 accountToBrandListMap.put(accountToConvert.id,tempBrandList);                                                      
         
         		System.debug('accountToBrandListMap data++++' + accountToBrandListMap);
              
              
              
               for(BuyerGroup pc: [Select id,Name from BuyerGroup]){
                    buyergroupNameToIdMap.put(pc.Name,pc.Id);
                }
                System.debug('buyergroupNameToIdMap data++++' + buyergroupNameToIdMap);
                
                  if(accountToConvert.isBuyer==false){
                      BuyerAccount buyer = new BuyerAccount(BuyerId = accountId,CommerceType = 'Buyer',
                                                                     IsActive = true, Name = accountId);
                      enableAccountAsBuyer.add(buyer);  
                  }
                                                      
                 //Convert Related Ship to Accounts to Buyer Account  
                 if(soldToShipTosMap.get(accountToConvert.id) != null){
                     for(Account shipToAccId : soldToShipTosMap.get(accountToConvert.id)){
                         BuyerAccount buyer1 = new BuyerAccount(BuyerId = shipToAccId.Id,CommerceType = 'Buyer',
                                                             IsActive = true, Name = shipToAccId.Id);
                         enableAccountAsBuyer.add(buyer1);                                   
                     }
                 }
                 
                 system.debug('acc.SAP_Partner_Functions__c+++++++' +accountToConvert.SAP_Partner_Functions__c );
                 if(accountToConvert.SAP_Partner_Functions__c.contains('Ship To') && accountToConvert.isBuyer==false){
                     system.debug('Ship to Partner function+++++++' );
                     ContactPointAddress cpa = new ContactPointAddress(AddressType = 'Shipping', City=accountToConvert.ShippingCity, Country=accountToConvert.ShippingCountry ,IsDefault=True, IsPrimary = True, Name=accountToConvert.Name ,ParentId =accountToConvert.id , PostalCode=accountToConvert.ShippingPostalCode, State=accountToConvert.ShippingState , Street=accountToConvert.ShippingStreet );
                     accountAddressList.add(cpa);
                 }  
                 if(soldToShipTosMap.get(accountToConvert.id)!=null){
                     for(Account shipToAccId : soldToShipTosMap.get(accountToConvert.id)){
                             ContactPointAddress cpa = new ContactPointAddress(AddressType = 'Shipping', City= shipToAccId.ShippingCity, Country=shipToAccId.ShippingCountry ,IsDefault=True, IsPrimary = True, Name=shipToAccId.Name ,ParentId =shipToAccId.id , PostalCode=shipToAccId.ShippingPostalCode, State=shipToAccId.ShippingState , Street=shipToAccId.ShippingStreet );
                             accountAddressList.add(cpa);
                                                            
                     }
                 }
                 
                 System.debug('accountToBrandListMap data++++' + accountToBrandListMap);
                 System.debug('enableAccountAsBuyer data++++' + enableAccountAsBuyer);
                 System.debug('accountAddressList data++++' + accountAddressList);
                 
                  if(enableAccountAsBuyer.size()>0){
                      insert enableAccountAsBuyer;
                  }
                 if(accountAddressList.size()>0){
                     insert accountAddressList;
                 }
                 
                 
                 
                 
                 //Assign Buyer Account to its unique buyer group using map -- Name being Sold to account id unique key
                  if(accountToConvert.isBuyer==false){
                      for(String brand: accountToBrandListMap.get(accountToConvert.id)){
                     
                         if(buyergroupNameToIdMap.get(brand) != null){
                             BuyerGroupMember buyerGroupMember = new BuyerGroupMember(BuyerId = accountToConvert.id, 
                                                                              BuyerGroupId = buyergroupNameToIdMap.get(brand) );
                             assignBuyerGroupMember.add(buyerGroupMember);
                         }
                         
                     }
                  }
                 if(soldToShipTosMap.get(accountToConvert.id) != null){
                     for(Account shipToId : soldToShipTosMap.get(accountToConvert.id)){
                         for(String brand: accountToBrandListMap.get(accountToConvert.id)){
                             if(buyergroupNameToIdMap.get(brand) != null){
                                 BuyerGroupMember buyerGroupMember1 = new BuyerGroupMember(BuyerId = shipToId.id, 
                                                                                  BuyerGroupId = buyergroupNameToIdMap.get(brand) );
                                 assignBuyerGroupMember.add(buyerGroupMember1);
                             
                             }
                             
                         }
                     }
                 }
                 
                 System.debug('assignBuyerGroupMember data++++' + assignBuyerGroupMember);
                  if(assignBuyerGroupMember.size()>0){
                      insert assignBuyerGroupMember;
                  }
                 
              }
          }
          
       
      
      
      
    }
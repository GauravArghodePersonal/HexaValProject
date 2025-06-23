/*****************************************************************
* Class Name     : ExpConvertAccountToBuyer                            *
* Author         : Aakash Wankhede                                   *
* Description    : It will convert account to buyer when request raised for non-buyer account.*
*****************************************************************/
public class ExpConvertNewlyAddedShipToAccountToBuyer {
     /**
    * @description invocable method called in flow to send request to SAP to create new contact when request is approved in SFDC
    */
    
      @InvocableMethod(Label='Newly Added Ship To Account Conversion To Buyer Account' Description='Once Request is Approved Non-Buyer Account Will be Converted to Buyer') 
      public static void processExpNewlyAddedShipTo(List<Account> accountIds) {
          map<String,id> buyergroupNameToIdMap = new Map<String,id>();
          List<BuyerAccount> enableAccountAsBuyer = new List<BuyerAccount>();
          Map<id,Set<String>> accountToBrandListMap = new Map<id,Set<String>>();
          List<ContactPointAddress> accountAddressList = new List<ContactPointAddress>();
          List<BuyerGroupMember> assignBuyerGroupMember = new List<BuyerGroupMember>();
          Set<String> tempBrandList = new Set<String>();
          List<AccountContactRelation> relatedContactsToBeInserted = new List<AccountContactRelation>();
          Account shipToBeConvereted = accountIds[0];
          Footer_Links__mdt[] defaultBrands = [Select MasterLabel, Value__c from Footer_Links__mdt where MasterLabel='Default_Brands_Solenis'];
          tempBrandList.addAll(defaultBrands[0].Value__c.split(';'));
          accountToBrandListMap.put(shipToBeConvereted.Id,tempBrandList);                                                      
          for(BuyerGroup pc: [Select id,Name from BuyerGroup]){
              buyergroupNameToIdMap.put(pc.Name,pc.Id);
          }          
          //Enabling the new Ship To as Buyer Account
          BuyerAccount buyer = new BuyerAccount(BuyerId = shipToBeConvereted.Id,CommerceType = 'Buyer',
                                                IsActive = true, Name = shipToBeConvereted.Id);
          enableAccountAsBuyer.add(buyer);  
          
		  //Creating contact point address for new Ship To
          ContactPointAddress cpa = new ContactPointAddress(AddressType = 'Shipping', City=shipToBeConvereted.ShippingCity, Country=shipToBeConvereted.ShippingCountry ,IsDefault=True, IsPrimary = True, Name=shipToBeConvereted.Name ,ParentId =shipToBeConvereted.id , PostalCode=shipToBeConvereted.ShippingPostalCode, State=shipToBeConvereted.ShippingState , Street=shipToBeConvereted.ShippingStreet );
          accountAddressList.add(cpa);
          if(enableAccountAsBuyer.size()>0){
              insert enableAccountAsBuyer;
          }
          if(accountAddressList.size()>0){
              insert accountAddressList;
          }
          
          for(String brand: accountToBrandListMap.get(shipToBeConvereted.id)){
              
              if(buyergroupNameToIdMap.get(brand) != null){
                  BuyerGroupMember buyerGroupMember = new BuyerGroupMember(BuyerId = shipToBeConvereted.id, 
                                                                           BuyerGroupId = buyergroupNameToIdMap.get(brand) );
                  assignBuyerGroupMember.add(buyerGroupMember);
              }
              
          }

          if(assignBuyerGroupMember.size()>0){
              insert assignBuyerGroupMember;
          }
              
          //Iterate Sold to related contacts
          for(AccountContactRelation soldToRelatedContact : [SELECT Id, ContactId, AccountId FROM AccountContactRelation WHERE IsActive = true AND AccountId =:shipToBeConvereted.ParentId AND Contact.RecordType.Name='SAP Contact']){
              AccountContactRelation relatedCon = new AccountContactRelation();
              relatedCon.ContactId = soldToRelatedContact.ContactId;
              relatedCon.AccountId = shipToBeConvereted.Id;
              relatedCon.IsActive = true;
              relatedCon.Unique_Key__c = shipToBeConvereted.Id+''+soldToRelatedContact.ContactId;
              relatedCon.Upgrade_to_External_Account__c = Datetime.now();
              relatedContactsToBeInserted.add(relatedCon);
          }
          
          if(relatedContactsToBeInserted.size()>0){
              insert relatedContactsToBeInserted;
          }
      }
}
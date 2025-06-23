public class b2bAccountsUpdateClass {

    public static Set<String> getBrandList(Account acc){
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
            
             Footer_Links__mdt[] defaultBrands = [Select MasterLabel, Value__c from Footer_Links__mdt where MasterLabel='Default_Brands'];
             tempBrandList.addAll(defaultBrands[0].Value__c.split(';'));
             return tempBrandList;
    }

    
    public static void handleShipToRegisteration(List<Account> shipToAccIdList, map<Id,Account> soldToIdtoAccountMap) {
         Set<Id> soldToIds = soldToIdtoAccountMap.keySet();
        Set<Id> upgradedSoldToIds = new Set<Id>();
        Map<Id,Set<Id>> soldToConatctsMap = new Map<Id,Set<Id>>();
         for(AccountContactRelation acr : [Select id, Account.parentid, AccountId, ContactId, Upgraded_to_External_Account_B2B__c from AccountContactRelation where Upgraded_to_External_Account_B2B__c = true and (Account.parentid in :soldToIds or AccountId in :soldToIds)])
        {
            if(acr.Account.parentid !=null){
                upgradedSoldToIds.add(acr.Account.parentid);
                
                Set<Id> tempContactsList = new Set<Id>();
                if(soldToConatctsMap.get(acr.Account.parentid) != null){
                    tempContactsList.addAll(soldToConatctsMap.get(acr.Account.parentid));
                }
                tempContactsList.add(acr.ContactId);
                soldToConatctsMap.put(acr.Account.parentid,tempContactsList);
                    
            }
            else{
                upgradedSoldToIds.add(acr.AccountId);
                
                Set<Id> tempContactsList = new Set<Id>();
                if(soldToConatctsMap.get(acr.AccountId) != null){
                    tempContactsList.addAll(soldToConatctsMap.get(acr.AccountId));
                }
                tempContactsList.add(acr.ContactId);
                soldToConatctsMap.put(acr.AccountId,tempContactsList);
            }
        }
         List<AccountContactRelation> registerShipTos = new List<AccountContactRelation>();
        
        for(Account acc : shipToAccIdList){
            if(upgradedSoldToIds.contains(acc.ParentId)){
                for(Id contact : soldToConatctsMap.get(acc.ParentId)){
                    AccountContactRelation acr = new AccountContactRelation(AccountId = acc.id, ContactId = contact, IsActive = True, Upgraded_to_External_Account_B2B__c = True, Unique_Key__c = String.Valueof(acc.id)+String.Valueof(contact) );
                    registerShipTos.add(acr);
                }
                
            }
        
        }
        if(!Test.isRunningTest ()){
            if(registerShipTos.size()>0){
                insert registerShipTos;
            }
        }
        
        
    
    }
    
    public static void handleShipToInsert(List<Account> shipToAccIdList, map<Id,Account> soldToIdtoAccountMap) {
        Map<Id,Set<string>> accountToBrandListMap = new Map<Id,Set<string>>();
        List<BuyerAccount> enableAccountAsBuyer = new List<BuyerAccount>();
        List<ContactPointAddress> accountAddressList = new List<ContactPointAddress>();
        map<String,id> buyergroupNameToIdMap = new Map<String,id>();
        List<BuyerGroupMember> assignBuyerGroupMember = new List<BuyerGroupMember>();
        
       for(BuyerGroup pc: [Select id,Name from BuyerGroup]){
            buyergroupNameToIdMap.put(pc.Name,pc.Id);
        }
        
        for(Account acc : shipToAccIdList){
            accountToBrandListMap.put(acc.id, b2bAccountsUpdateClass.getBrandList(soldToIdtoAccountMap.get(acc.ParentId)));
            //enable accounts as buyer
            BuyerAccount buyer = new BuyerAccount(BuyerId = acc.id,CommerceType = 'Buyer',
                                                         IsActive = true, Name = acc.Id);
            enableAccountAsBuyer.add(buyer); 
            
            //contact addresses
            ContactPointAddress cpa = new ContactPointAddress(AddressType = 'Shipping', City= acc.ShippingCity, Country=acc.ShippingCountry ,IsDefault=True, IsPrimary = True, Name=acc.Name ,ParentId =acc.id , PostalCode=acc.ShippingPostalCode, State=acc.ShippingState , Street=acc.ShippingStreet );
            accountAddressList.add(cpa);
            
            //buyergroup member assignments
            for(String brand: accountToBrandListMap.get(acc.id)){
                     
                 if(buyergroupNameToIdMap.get(brand) != null){
                     BuyerGroupMember buyerGroupMember = new BuyerGroupMember(BuyerId = acc.id, 
                                                                      BuyerGroupId = buyergroupNameToIdMap.get(brand) );
                     assignBuyerGroupMember.add(buyerGroupMember);
                 }
                 
             }
        }
         if(enableAccountAsBuyer.size()>0){
            insert enableAccountAsBuyer;
        }
        if(accountAddressList.size()>0){
            insert accountAddressList;
        }
        if(assignBuyerGroupMember.size()>0){
            insert assignBuyerGroupMember;
        }
        b2bAccountsUpdateClass.handleShipToRegisteration(shipToAccIdList, soldToIdtoAccountMap);
        
    }
    
       
    public static void handleUpdate(List<Account> newAcclist, Map<Id,Account> oldAccMap) {
        
        System.debug('newAcclist data++++' + newAcclist);
        System.debug('oldAccMap data++++' + oldAccMap);
        
        map<Id,List<Account>> soldToShipTosMap = new Map<Id,List<Account>>();
        map<String,id> buyergroupNameToIdMap = new Map<String,id>();
        List<id> newAccIds = new List<id>();
        List<id> consolidatedAccIds = new List<id>();
        List<BuyerGroupMember> newBuyerGroupMember = new List<BuyerGroupMember>();
        List<BuyerGroupMember> deleteBuyerGroupMember = new List<BuyerGroupMember>();
        map<String,BuyerGroupMember> keyToBuyerGroupMemberMap = new Map<String,BuyerGroupMember>();
        map<String,String> BuyerIdwithacc = new map<String,string>();
        
        for(Account acc : newAcclist){
            newAccIds.add(acc.Id);
            consolidatedAccIds.add(acc.Id);
        }
         System.debug('consolidatedAccIds+' + consolidatedAccIds);
        for (Account acc : [Select Id, Name, SAP_Partner_Functions__c, ParentId ,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet from Account where SAP_Partner_Functions__c like '%Ship To%' and ParentId in :newAccIds and isBuyer = true]){
            List<Account> tempShipToList = new List<Account>();
            if(soldToShipTosMap.get(acc.ParentId) != null){
                tempShipToList.addAll(soldToShipTosMap.get(acc.ParentId));
            }
            tempShipToList.add(acc);
            consolidatedAccIds.add(acc.Id);
            soldToShipTosMap.put(acc.ParentId,tempShipToList);
            
        }
        System.debug('soldToShipTosMap data++++' + soldToShipTosMap);
        System.debug('consolidatedAccIds data++++' + consolidatedAccIds);
        
        for(BuyerGroup pc: [Select id,Name from BuyerGroup]){
            buyergroupNameToIdMap.put(pc.Name,pc.Id);
        }
        System.debug('buyergroupNameToIdMap data++++' + buyergroupNameToIdMap);
        System.debug('consolidatedAccIds' + consolidatedAccIds);
        set<Id> BuygroupIds = new set<Id>();
        map<String,BuyerGroupMember> AccidwithBuyid = new map<String,BuyerGroupMember>();
        Map<string,List<BuyerGroupMember>> BuyerGroupIdwithbgm = new Map<String,List<BuyerGroupMember>>();
      //  List<BuyerGroupMember> buyergroupList = new List<BuyerGroupMember>();
        for(BuyerGroupMember bgm : [Select id,BuyerId,BuyerGroupId,BuyerGroup.name from BuyerGroupMember where BuyerId in:consolidatedAccIds]){
            keyToBuyerGroupMemberMap.put(bgm.BuyerId+'_'+bgm.BuyerGroupId , bgm);
            BuygroupIds.add(bgm.id);
            AccidwithBuyid.put(bgm.BuyerGroupId,bgm);
            if(BuyerGroupIdwithbgm.containskey(bgm.BuyerGroupId)){
            List<BuyerGroupMember>  buyerList = BuyerGroupIdwithbgm.get(bgm.BuyerGroupId);
                buyerList.add(bgm);
                BuyerGroupIdwithbgm.put(bgm.BuyerGroupId,buyerList);
            }else{
               //wrap =  buyergroupList.add(bgm);
                BuyerGroupIdwithbgm.put(bgm.BuyerGroupId,new List<BuyerGroupMember>{bgm});
            }
            
        }
        for(Account acc : newAcclist){
            if(acc.SAP_Attribute1_Desc__c != oldAccMap.get(acc.Id).SAP_Attribute1_Desc__c){
                if(acc.SAP_Attribute1_Desc__c != null){
                    system.debug('acc.SAP_Attribute1_Desc__c ' +acc.SAP_Attribute1_Desc__c );
                    if(buyergroupNameToIdMap.get(acc.SAP_Attribute1_Desc__c) != null){
                         BuyerGroupMember buyerGroupMember = new BuyerGroupMember(BuyerId = acc.id, 
                                                                          BuyerGroupId = buyergroupNameToIdMap.get(acc.SAP_Attribute1_Desc__c) );
                         newBuyerGroupMember.add(buyerGroupMember);
                        if(oldAccMap.get(acc.Id).SAP_Attribute1_Desc__c != null){
                      Id oldBuyerGroupId =  buyergroupNameToIdMap.get(oldAccMap.get(acc.Id).SAP_Attribute1_Desc__c);
                      List<BuyerGroupMember> OldbuyerGroupMemberDelete =BuyerGroupIdwithbgm.get(oldBuyerGroupId); 
                         Delete OldbuyerGroupMemberDelete;
                        }
                         	
                    }
                     if(soldToShipTosMap.get(acc.id) != null){
                         for(Account shipToId : soldToShipTosMap.get(acc.id)){
                             
                                 if(buyergroupNameToIdMap.get(acc.SAP_Attribute1_Desc__c) != null){
                                     BuyerGroupMember buyerGroupMember1 = new BuyerGroupMember(BuyerId = shipToId.id, 
                                                                                      BuyerGroupId = buyergroupNameToIdMap.get(acc.SAP_Attribute1_Desc__c) );
                                     newBuyerGroupMember.add(buyerGroupMember1);
                                 
                                 }
                           } 
                      }
                }
                else if(acc.SAP_Attribute1_Desc__c == null){
                    String oldBrand = oldAccMap.get(acc.Id).SAP_Attribute1_Desc__c;
                    if(buyergroupNameToIdMap.get(oldBrand) != null && keyToBuyerGroupMemberMap.get(acc.id+'_'+buyergroupNameToIdMap.get(oldBrand))!=null){
                        deleteBuyerGroupMember.add(keyToBuyerGroupMemberMap.get(acc.id+'_'+buyergroupNameToIdMap.get(oldBrand)));
                    }
                    if(soldToShipTosMap.get(acc.id) != null){
                         for(Account shipToId : soldToShipTosMap.get(acc.id)){
                                 if(buyergroupNameToIdMap.get(oldBrand) != null &&keyToBuyerGroupMemberMap.get(shipToId.id+'_'+buyergroupNameToIdMap.get(oldBrand))!=null){
                                    deleteBuyerGroupMember.add(keyToBuyerGroupMemberMap.get(shipToId.id+'_'+buyergroupNameToIdMap.get(oldBrand)));
                                }
                                 
                           } 
                      }
                }
                
            }
            if(acc.SAP_Attribute2_Desc__c != oldAccMap.get(acc.Id).SAP_Attribute2_Desc__c){
                system.debug('acc.SAP_Attribute1_Desc__c ' +acc.SAP_Attribute2_Desc__c );
                if(acc.SAP_Attribute2_Desc__c != null){
                    system.debug('acc.SAP_Attribute1_Desc__c ' +acc.SAP_Attribute2_Desc__c );
                    system.debug('acc.SAP_Attribute1_Desc__c ' +buyergroupNameToIdMap.get(acc.SAP_Attribute2_Desc__c) );
                    if(buyergroupNameToIdMap.get(acc.SAP_Attribute2_Desc__c) != null){
                        system.debug('acc.SAP_Attribute1_Desc__c ' +acc.SAP_Attribute2_Desc__c );
                         BuyerGroupMember buyerGroupMember = new BuyerGroupMember(BuyerId = acc.id, 
                                                                          BuyerGroupId = buyergroupNameToIdMap.get(acc.SAP_Attribute2_Desc__c) );
                        
                         newBuyerGroupMember.add(buyerGroupMember);
                        system.debug('acc.SAP_Attribute1_Desc__c ' +buyerGroupMember);
                         System.debug('BuygroupIds' + acc.SAP_Attribute2_Desc__c);
                        System.debug('BuygroupIds' + oldAccMap.get(acc.Id).SAP_Attribute2_Desc__c);
                          if(oldAccMap.get(acc.Id).SAP_Attribute2_Desc__c != null){
                      				Id oldBuyerGroupId =  buyergroupNameToIdMap.get(oldAccMap.get(acc.Id).SAP_Attribute2_Desc__c);
                      				List<BuyerGroupMember> OldbuyerGroupMemberDelete =BuyerGroupIdwithbgm.get(oldBuyerGroupId); 
                      				 Delete OldbuyerGroupMemberDelete;
                        }
                     }
                    system.debug('acc.SAP_Attribute1_Desc__c ' +soldToShipTosMap.get(acc.id));
                     if(soldToShipTosMap.get(acc.id) != null){
                         for(Account shipToId : soldToShipTosMap.get(acc.id)){
                             system.debug('acc.SAP_Attribute1_Desc__c ' +soldToShipTosMap.get(acc.id));
                                 if(buyergroupNameToIdMap.get(acc.SAP_Attribute2_Desc__c) != null){
                                     BuyerGroupMember buyerGroupMember1 = new BuyerGroupMember(BuyerId = shipToId.id, 
                                                                                      BuyerGroupId = buyergroupNameToIdMap.get(acc.SAP_Attribute2_Desc__c) );
                                     newBuyerGroupMember.add(buyerGroupMember1);
                                 system.debug('acc.SAP_Attribute1_Desc__c ' +buyerGroupMember1);
                                 }
                           } 
                      }
                 
                }
                else if(acc.SAP_Attribute2_Desc__c == null){
                    String oldBrand = oldAccMap.get(acc.Id).SAP_Attribute2_Desc__c;
                    if(buyergroupNameToIdMap.get(oldBrand) != null &&keyToBuyerGroupMemberMap.get(acc.id+'_'+buyergroupNameToIdMap.get(oldBrand))!=null){
                        deleteBuyerGroupMember.add(keyToBuyerGroupMemberMap.get(acc.id+'_'+buyergroupNameToIdMap.get(oldBrand)));
                    }
                    if(soldToShipTosMap.get(acc.id) != null){
                         for(Account shipToId : soldToShipTosMap.get(acc.id)){
                                 if(buyergroupNameToIdMap.get(oldBrand) != null&&keyToBuyerGroupMemberMap.get(shipToId.id+'_'+buyergroupNameToIdMap.get(oldBrand))!=null){
                                    deleteBuyerGroupMember.add(keyToBuyerGroupMemberMap.get(shipToId.id+'_'+buyergroupNameToIdMap.get(oldBrand)));
                                }
                                 
                           } 
                      }
                }
            }
            if(acc.SAP_Attribute3_Desc__c != oldAccMap.get(acc.Id).SAP_Attribute3_Desc__c){
                if(acc.SAP_Attribute3_Desc__c != null){
                    if(buyergroupNameToIdMap.get(acc.SAP_Attribute3_Desc__c) != null){
                         BuyerGroupMember buyerGroupMember = new BuyerGroupMember(BuyerId = acc.id, 
                                                                          BuyerGroupId = buyergroupNameToIdMap.get(acc.SAP_Attribute3_Desc__c) );
                         newBuyerGroupMember.add(buyerGroupMember);
                         if(oldAccMap.get(acc.Id).SAP_Attribute3_Desc__c != null){
                      Id oldBuyerGroupId =  buyergroupNameToIdMap.get(oldAccMap.get(acc.Id).SAP_Attribute3_Desc__c);
                      List<BuyerGroupMember> OldbuyerGroupMemberDelete =BuyerGroupIdwithbgm.get(oldBuyerGroupId); 
                       Delete OldbuyerGroupMemberDelete;
                        }
                     }
                     if(soldToShipTosMap.get(acc.id) != null){
                         for(Account shipToId : soldToShipTosMap.get(acc.id)){
                             
                                 if(buyergroupNameToIdMap.get(acc.SAP_Attribute3_Desc__c) != null){
                                     BuyerGroupMember buyerGroupMember1 = new BuyerGroupMember(BuyerId = shipToId.id, 
                                                                                      BuyerGroupId = buyergroupNameToIdMap.get(acc.SAP_Attribute3_Desc__c) );
                                     newBuyerGroupMember.add(buyerGroupMember1);
                                 
                                 }
                           } 
                      }
                 
                }
                else if(acc.SAP_Attribute3_Desc__c == null){
                    String oldBrand = oldAccMap.get(acc.Id).SAP_Attribute3_Desc__c;
                    if(buyergroupNameToIdMap.get(oldBrand) != null&&keyToBuyerGroupMemberMap.get(acc.id+'_'+buyergroupNameToIdMap.get(oldBrand))!=null){
                        deleteBuyerGroupMember.add(keyToBuyerGroupMemberMap.get(acc.id+'_'+buyergroupNameToIdMap.get(oldBrand)));
                    }
                    if(soldToShipTosMap.get(acc.id) != null){
                         for(Account shipToId : soldToShipTosMap.get(acc.id)){
                                 if(buyergroupNameToIdMap.get(oldBrand) != null&&keyToBuyerGroupMemberMap.get(shipToId.id+'_'+buyergroupNameToIdMap.get(oldBrand))!=null){
                                    deleteBuyerGroupMember.add(keyToBuyerGroupMemberMap.get(shipToId.id+'_'+buyergroupNameToIdMap.get(oldBrand)));
                                }
                                 
                           } 
                      }
                }
            }
            if(acc.SAP_Attribute4_Desc__c != oldAccMap.get(acc.Id).SAP_Attribute4_Desc__c){
                if(acc.SAP_Attribute4_Desc__c != null){
                    if(buyergroupNameToIdMap.get(acc.SAP_Attribute4_Desc__c) != null){
                         BuyerGroupMember buyerGroupMember = new BuyerGroupMember(BuyerId = acc.id, 
                                                                          BuyerGroupId = buyergroupNameToIdMap.get(acc.SAP_Attribute4_Desc__c) );
                         newBuyerGroupMember.add(buyerGroupMember);
                         System.debug('BuygroupIds' + acc.SAP_Attribute4_Desc__c);
                        System.debug('BuygroupIds' + oldAccMap.get(acc.Id).SAP_Attribute4_Desc__c);
                          if(oldAccMap.get(acc.Id).SAP_Attribute4_Desc__c != null){
                      Id oldBuyerGroupId =  buyergroupNameToIdMap.get(oldAccMap.get(acc.Id).SAP_Attribute4_Desc__c);
                      List<BuyerGroupMember> OldbuyerGroupMemberDelete =BuyerGroupIdwithbgm.get(oldBuyerGroupId); 
                       Delete OldbuyerGroupMemberDelete;
                        }
                     }
                     if(soldToShipTosMap.get(acc.id) != null){
                         for(Account shipToId : soldToShipTosMap.get(acc.id)){
                             
                                 if(buyergroupNameToIdMap.get(acc.SAP_Attribute4_Desc__c) != null){
                                     BuyerGroupMember buyerGroupMember1 = new BuyerGroupMember(BuyerId = shipToId.id, 
                                                                                      BuyerGroupId = buyergroupNameToIdMap.get(acc.SAP_Attribute4_Desc__c) );
                                     newBuyerGroupMember.add(buyerGroupMember1);
                                 	
                                 
                                 }
                                 }
                           } 
                      }
                 
                
                else if(acc.SAP_Attribute4_Desc__c == null){
                    String oldBrand = oldAccMap.get(acc.Id).SAP_Attribute4_Desc__c;
                    if(buyergroupNameToIdMap.get(oldBrand) != null&&keyToBuyerGroupMemberMap.get(acc.id+'_'+buyergroupNameToIdMap.get(oldBrand))!=null){
                        deleteBuyerGroupMember.add(keyToBuyerGroupMemberMap.get(acc.id+'_'+buyergroupNameToIdMap.get(oldBrand)));
                    }
                    if(soldToShipTosMap.get(acc.id) != null){
                         for(Account shipToId : soldToShipTosMap.get(acc.id)){
                                 if(buyergroupNameToIdMap.get(oldBrand) != null &&keyToBuyerGroupMemberMap.get(shipToId.id+'_'+buyergroupNameToIdMap.get(oldBrand))!=null){
                                    deleteBuyerGroupMember.add(keyToBuyerGroupMemberMap.get(shipToId.id+'_'+buyergroupNameToIdMap.get(oldBrand)));
                                }
                                 
                           } 
                      }
                }
            }
            
            if(acc.SAP_Attribute5_Desc__c != oldAccMap.get(acc.Id).SAP_Attribute5_Desc__c){
                if(acc.SAP_Attribute5_Desc__c != null){
                    if(buyergroupNameToIdMap.get(acc.SAP_Attribute5_Desc__c) != null){
                         BuyerGroupMember buyerGroupMember = new BuyerGroupMember(BuyerId = acc.id, 
                                                                          BuyerGroupId = buyergroupNameToIdMap.get(acc.SAP_Attribute5_Desc__c) );
                         newBuyerGroupMember.add(buyerGroupMember);
                         if(oldAccMap.get(acc.Id).SAP_Attribute5_Desc__c != null){
                      Id oldBuyerGroupId =  buyergroupNameToIdMap.get(oldAccMap.get(acc.Id).SAP_Attribute5_Desc__c);
                      List<BuyerGroupMember> OldbuyerGroupMemberDelete =BuyerGroupIdwithbgm.get(oldBuyerGroupId); 
                       Delete OldbuyerGroupMemberDelete;
                        }
                     }
                     if(soldToShipTosMap.get(acc.id) != null){
                         for(Account shipToId : soldToShipTosMap.get(acc.id)){
                             
                                 if(buyergroupNameToIdMap.get(acc.SAP_Attribute5_Desc__c) != null){
                                     BuyerGroupMember buyerGroupMember1 = new BuyerGroupMember(BuyerId = shipToId.id, 
                                                                                      BuyerGroupId = buyergroupNameToIdMap.get(acc.SAP_Attribute5_Desc__c) );
                                     newBuyerGroupMember.add(buyerGroupMember1);
                                 		
                                     
                                 }
                           } 
                      }
                 
                }
                else if(acc.SAP_Attribute5_Desc__c == null){
                    String oldBrand = oldAccMap.get(acc.Id).SAP_Attribute5_Desc__c;
                    if(buyergroupNameToIdMap.get(oldBrand) != null&&keyToBuyerGroupMemberMap.get(acc.id+'_'+buyergroupNameToIdMap.get(oldBrand))!=null){
                        deleteBuyerGroupMember.add(keyToBuyerGroupMemberMap.get(acc.id+'_'+buyergroupNameToIdMap.get(oldBrand)));
                    }
                    if(soldToShipTosMap.get(acc.id) != null){
                         for(Account shipToId : soldToShipTosMap.get(acc.id)){
                                 if(buyergroupNameToIdMap.get(oldBrand) != null&&keyToBuyerGroupMemberMap.get(shipToId.id+'_'+buyergroupNameToIdMap.get(oldBrand))!=null){
                                    deleteBuyerGroupMember.add(keyToBuyerGroupMemberMap.get(shipToId.id+'_'+buyergroupNameToIdMap.get(oldBrand)));
                                }
                                 
                           } 
                      }
                }
            }
            if(acc.SAP_Attribute6_Desc__c != oldAccMap.get(acc.Id).SAP_Attribute6_Desc__c){
                if(acc.SAP_Attribute6_Desc__c != null){
                    if(buyergroupNameToIdMap.get(acc.SAP_Attribute6_Desc__c) != null){
                         BuyerGroupMember buyerGroupMember = new BuyerGroupMember(BuyerId = acc.id, 
                                                                          BuyerGroupId = buyergroupNameToIdMap.get(acc.SAP_Attribute6_Desc__c) );
                         newBuyerGroupMember.add(buyerGroupMember);
                     }
                     if(soldToShipTosMap.get(acc.id) != null){
                         for(Account shipToId : soldToShipTosMap.get(acc.id)){
                             
                                 if(buyergroupNameToIdMap.get(acc.SAP_Attribute6_Desc__c) != null){
                                     BuyerGroupMember buyerGroupMember1 = new BuyerGroupMember(BuyerId = shipToId.id, 
                                                                                      BuyerGroupId = buyergroupNameToIdMap.get(acc.SAP_Attribute6_Desc__c) );
                                     newBuyerGroupMember.add(buyerGroupMember1);
                                 	
                                     	 if(oldAccMap.get(acc.Id).SAP_Attribute6_Desc__c != null){
                      Id oldBuyerGroupId =  buyergroupNameToIdMap.get(oldAccMap.get(acc.Id).SAP_Attribute6_Desc__c);
                      List<BuyerGroupMember> OldbuyerGroupMemberDelete =BuyerGroupIdwithbgm.get(oldBuyerGroupId); 
                       Delete OldbuyerGroupMemberDelete;
                        }
                                 }
                           } 
                      }
                 
                }
                else if(acc.SAP_Attribute6_Desc__c == null){
                    String oldBrand = oldAccMap.get(acc.Id).SAP_Attribute6_Desc__c;
                    if(buyergroupNameToIdMap.get(oldBrand) != null&&keyToBuyerGroupMemberMap.get(acc.id+'_'+buyergroupNameToIdMap.get(oldBrand))!=null){
                        deleteBuyerGroupMember.add(keyToBuyerGroupMemberMap.get(acc.id+'_'+buyergroupNameToIdMap.get(oldBrand)));
                    }
                    if(soldToShipTosMap.get(acc.id) != null){
                         for(Account shipToId : soldToShipTosMap.get(acc.id)){
                                 if(buyergroupNameToIdMap.get(oldBrand) != null&&keyToBuyerGroupMemberMap.get(shipToId.id+'_'+buyergroupNameToIdMap.get(oldBrand))!=null){
                                    deleteBuyerGroupMember.add(keyToBuyerGroupMemberMap.get(shipToId.id+'_'+buyergroupNameToIdMap.get(oldBrand)));
                                }
                                 
                           } 
                      }
                }
            }
            if(acc.SAP_Attribute7_Desc__c != oldAccMap.get(acc.Id).SAP_Attribute7_Desc__c){
                if(acc.SAP_Attribute7_Desc__c != null){
                    if(buyergroupNameToIdMap.get(acc.SAP_Attribute7_Desc__c) != null){
                         BuyerGroupMember buyerGroupMember = new BuyerGroupMember(BuyerId = acc.id, 
                                                                          BuyerGroupId = buyergroupNameToIdMap.get(acc.SAP_Attribute7_Desc__c) );
                         newBuyerGroupMember.add(buyerGroupMember);
                         if(oldAccMap.get(acc.Id).SAP_Attribute7_Desc__c != null){
                      Id oldBuyerGroupId =  buyergroupNameToIdMap.get(oldAccMap.get(acc.Id).SAP_Attribute7_Desc__c);
                      List<BuyerGroupMember> OldbuyerGroupMemberDelete =BuyerGroupIdwithbgm.get(oldBuyerGroupId); 
                       Delete OldbuyerGroupMemberDelete;
                        }
                        
                     }
                     if(soldToShipTosMap.get(acc.id) != null){
                         for(Account shipToId : soldToShipTosMap.get(acc.id)){
                             
                                 if(buyergroupNameToIdMap.get(acc.SAP_Attribute7_Desc__c) != null){
                                     BuyerGroupMember buyerGroupMember1 = new BuyerGroupMember(BuyerId = shipToId.id, 
                                                                                      BuyerGroupId = buyergroupNameToIdMap.get(acc.SAP_Attribute7_Desc__c) );
                                     newBuyerGroupMember.add(buyerGroupMember1);
                                 	
                                     	
                                 }
                           } 
                      }
                 
                }
                else if(acc.SAP_Attribute7_Desc__c == null){
                    String oldBrand = oldAccMap.get(acc.Id).SAP_Attribute7_Desc__c;
                    if(buyergroupNameToIdMap.get(oldBrand) != null&&keyToBuyerGroupMemberMap.get(acc.id+'_'+buyergroupNameToIdMap.get(oldBrand))!=null){
                        deleteBuyerGroupMember.add(keyToBuyerGroupMemberMap.get(acc.id+'_'+buyergroupNameToIdMap.get(oldBrand)));
                    }
                    if(soldToShipTosMap.get(acc.id) != null){
                         for(Account shipToId : soldToShipTosMap.get(acc.id)){
                                 if(buyergroupNameToIdMap.get(oldBrand) != null&&keyToBuyerGroupMemberMap.get(shipToId.id+'_'+buyergroupNameToIdMap.get(oldBrand))!=null){
                                    deleteBuyerGroupMember.add(keyToBuyerGroupMemberMap.get(shipToId.id+'_'+buyergroupNameToIdMap.get(oldBrand)));
                                }
                                 
                           } 
                      }
                }
            }
            if(acc.SAP_Attribute8_Desc__c != oldAccMap.get(acc.Id).SAP_Attribute8_Desc__c){
                if(acc.SAP_Attribute8_Desc__c != null){
                    if(buyergroupNameToIdMap.get(acc.SAP_Attribute8_Desc__c) != null){
                         BuyerGroupMember buyerGroupMember = new BuyerGroupMember(BuyerId = acc.id, 
                                                                          BuyerGroupId = buyergroupNameToIdMap.get(acc.SAP_Attribute8_Desc__c) );
                         newBuyerGroupMember.add(buyerGroupMember);
                        
                        if(oldAccMap.get(acc.Id).SAP_Attribute8_Desc__c != null){
                      Id oldBuyerGroupId =  buyergroupNameToIdMap.get(oldAccMap.get(acc.Id).SAP_Attribute8_Desc__c);
                      List<BuyerGroupMember> OldbuyerGroupMemberDelete =BuyerGroupIdwithbgm.get(oldBuyerGroupId); 
                       Delete OldbuyerGroupMemberDelete;
                        }
                     }
                     if(soldToShipTosMap.get(acc.id) != null){
                         for(Account shipToId : soldToShipTosMap.get(acc.id)){
                             
                                 if(buyergroupNameToIdMap.get(acc.SAP_Attribute8_Desc__c) != null){
                                     BuyerGroupMember buyerGroupMember1 = new BuyerGroupMember(BuyerId = shipToId.id, 
                                                                                      BuyerGroupId = buyergroupNameToIdMap.get(acc.SAP_Attribute8_Desc__c) );
                                     newBuyerGroupMember.add(buyerGroupMember1);
                                 	
                                     	 
                                 }
                           } 
                      }
                 
                }
                else if(acc.SAP_Attribute8_Desc__c == null){
                    String oldBrand = oldAccMap.get(acc.Id).SAP_Attribute8_Desc__c;
                    if(buyergroupNameToIdMap.get(oldBrand) != null&&keyToBuyerGroupMemberMap.get(acc.id+'_'+buyergroupNameToIdMap.get(oldBrand))!=null){
                        deleteBuyerGroupMember.add(keyToBuyerGroupMemberMap.get(acc.id+'_'+buyergroupNameToIdMap.get(oldBrand)));
                    }
                    if(soldToShipTosMap.get(acc.id) != null){
                         for(Account shipToId : soldToShipTosMap.get(acc.id)){
                                 if(buyergroupNameToIdMap.get(oldBrand) != null&&keyToBuyerGroupMemberMap.get(shipToId.id+'_'+buyergroupNameToIdMap.get(oldBrand))!=null){
                                    deleteBuyerGroupMember.add(keyToBuyerGroupMemberMap.get(shipToId.id+'_'+buyergroupNameToIdMap.get(oldBrand)));
                                }
                                 
                           } 
                      }
                }
            }
            if(acc.SAP_Attribute9_Desc__c != oldAccMap.get(acc.Id).SAP_Attribute9_Desc__c){
                if(acc.SAP_Attribute9_Desc__c != null){
                    if(buyergroupNameToIdMap.get(acc.SAP_Attribute9_Desc__c) != null){
                         BuyerGroupMember buyerGroupMember = new BuyerGroupMember(BuyerId = acc.id, 
                                                                          BuyerGroupId = buyergroupNameToIdMap.get(acc.SAP_Attribute9_Desc__c) );
                         newBuyerGroupMember.add(buyerGroupMember);
                         if(oldAccMap.get(acc.Id).SAP_Attribute9_Desc__c != null){
                      Id oldBuyerGroupId =  buyergroupNameToIdMap.get(oldAccMap.get(acc.Id).SAP_Attribute9_Desc__c);
                      List<BuyerGroupMember> OldbuyerGroupMemberDelete =BuyerGroupIdwithbgm.get(oldBuyerGroupId); 
                       Delete OldbuyerGroupMemberDelete;
                        }
                     }
                     if(soldToShipTosMap.get(acc.id) != null){
                         for(Account shipToId : soldToShipTosMap.get(acc.id)){
                             
                                 if(buyergroupNameToIdMap.get(acc.SAP_Attribute9_Desc__c) != null){
                                     BuyerGroupMember buyerGroupMember1 = new BuyerGroupMember(BuyerId = shipToId.id, 
                                                                                      BuyerGroupId = buyergroupNameToIdMap.get(acc.SAP_Attribute9_Desc__c) );
                                     newBuyerGroupMember.add(buyerGroupMember1);
                                 	
                                     	
                                 }
                           } 
                      }
                 
                }
                else if(acc.SAP_Attribute9_Desc__c == null){
                    String oldBrand = oldAccMap.get(acc.Id).SAP_Attribute9_Desc__c;
                    if(buyergroupNameToIdMap.get(oldBrand) != null&&keyToBuyerGroupMemberMap.get(acc.id+'_'+buyergroupNameToIdMap.get(oldBrand))!=null){
                        deleteBuyerGroupMember.add(keyToBuyerGroupMemberMap.get(acc.id+'_'+buyergroupNameToIdMap.get(oldBrand)));
                    }
                    if(soldToShipTosMap.get(acc.id) != null){
                         for(Account shipToId : soldToShipTosMap.get(acc.id)){
                                 if(buyergroupNameToIdMap.get(oldBrand) != null&&keyToBuyerGroupMemberMap.get(shipToId.id+'_'+buyergroupNameToIdMap.get(oldBrand))!=null){
                                    deleteBuyerGroupMember.add(keyToBuyerGroupMemberMap.get(shipToId.id+'_'+buyergroupNameToIdMap.get(oldBrand)));
                                }
                                 
                           } 
                      }
                }
            }
            if(acc.SAP_Attribute10_Desc__c != oldAccMap.get(acc.Id).SAP_Attribute10_Desc__c){
                if(acc.SAP_Attribute10_Desc__c != null){
                    if(buyergroupNameToIdMap.get(acc.SAP_Attribute10_Desc__c) != null){
                         BuyerGroupMember buyerGroupMember = new BuyerGroupMember(BuyerId = acc.id, 
                                                                          BuyerGroupId = buyergroupNameToIdMap.get(acc.SAP_Attribute10_Desc__c) );
                         newBuyerGroupMember.add(buyerGroupMember);
                         if(oldAccMap.get(acc.Id).SAP_Attribute10_Desc__c != null){
                      Id oldBuyerGroupId =  buyergroupNameToIdMap.get(oldAccMap.get(acc.Id).SAP_Attribute10_Desc__c);
                      List<BuyerGroupMember> OldbuyerGroupMemberDelete =BuyerGroupIdwithbgm.get(oldBuyerGroupId); 
                       Delete OldbuyerGroupMemberDelete;
                        }
                     }
                     if(soldToShipTosMap.get(acc.id) != null){
                         for(Account shipToId : soldToShipTosMap.get(acc.id)){
                             
                                 if(buyergroupNameToIdMap.get(acc.SAP_Attribute10_Desc__c) != null){
                                     BuyerGroupMember buyerGroupMember1 = new BuyerGroupMember(BuyerId = shipToId.id, 
                                                                                      BuyerGroupId = buyergroupNameToIdMap.get(acc.SAP_Attribute10_Desc__c) );
                                     newBuyerGroupMember.add(buyerGroupMember1);
                                 
                                     	
                                 }
                           } 
                      }
                 
                }
                else if(acc.SAP_Attribute10_Desc__c == null){
                    String oldBrand = oldAccMap.get(acc.Id).SAP_Attribute10_Desc__c;
                    if(buyergroupNameToIdMap.get(oldBrand) != null&&keyToBuyerGroupMemberMap.get(acc.id+'_'+buyergroupNameToIdMap.get(oldBrand))!=null){
                        deleteBuyerGroupMember.add(keyToBuyerGroupMemberMap.get(acc.id+'_'+buyergroupNameToIdMap.get(oldBrand)));
                    }
                    if(soldToShipTosMap.get(acc.id) != null){
                         for(Account shipToId : soldToShipTosMap.get(acc.id)){
                                 if(buyergroupNameToIdMap.get(oldBrand) != null&&keyToBuyerGroupMemberMap.get(shipToId.id+'_'+buyergroupNameToIdMap.get(oldBrand))!=null){
                                    deleteBuyerGroupMember.add(keyToBuyerGroupMemberMap.get(shipToId.id+'_'+buyergroupNameToIdMap.get(oldBrand)));
                                }
                                 
                           } 
                      }
                }
            }
        
        }
        System.debug('newBuyerGroupMember++++++++' + newBuyerGroupMember);
        if(!test.isRunningTest()){
            if(newBuyerGroupMember.size()>0){
                Insert newBuyerGroupMember;
            }
        }
        
        
        
        System.debug('deleteBuyerGroupMember++++++++' + deleteBuyerGroupMember);
        if(!test.isRunningTest()){
            if(deleteBuyerGroupMember.size()>0){
                delete deleteBuyerGroupMember;
            }
        }
        
        
    }
}
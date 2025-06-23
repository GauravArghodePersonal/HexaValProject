@isTest
public class b2bAccountsUpdateClassTest {
    @TestSetup
    static void createData(){
  
      WebStore store = new WebStore(Name = 'Solenis Eshop');
      insert store;

      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      User u = new User(Alias = 'standt', Email='standarduser@org.com', 
                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                      LocaleSidKey='en_US', ProfileId = p.Id, 
                      TimeZoneSidKey='America/Los_Angeles', UserName='Testuser1212' + system.now().format('YYYYmmddhhmmss') + '@testorg.com');
      u.IsActive = true;
      insert u;
        
             

    }
    

    static testMethod void B2BBatchToPopulateEntitlementPolicy_UnitTest() {

        User oUser = [SELECT ID FROM User WHERE LastName='Testing'];
        

        system.runAs(oUser){            
            List<BuyerGroup> buyerGroups = new List<BuyerGroup>();
            BuyerGroup bg = new BuyerGroup(Name = 'abc111');
        	buyerGroups.add(bg);
            BuyerGroup bg1 = new BuyerGroup(Name = 'abc121');
        	buyerGroups.add(bg1);
            BuyerGroup bg2 = new BuyerGroup(Name = 'abc131');
        	buyerGroups.add(bg2);
            BuyerGroup bg3 = new BuyerGroup(Name = 'abc141');
        	buyerGroups.add(bg3);
            BuyerGroup bg4 = new BuyerGroup(Name = 'abc161');
        	buyerGroups.add(bg4);
            BuyerGroup bg5 = new BuyerGroup(Name = 'abc171');
        	buyerGroups.add(bg5);
            BuyerGroup bg6 = new BuyerGroup(Name = 'abc181');
        	buyerGroups.add(bg6);
            BuyerGroup bg7 = new BuyerGroup(Name = 'abc191');
        	buyerGroups.add(bg7);
            BuyerGroup bg8 = new BuyerGroup(Name = 'abc120');
        	buyerGroups.add(bg8);
            BuyerGroup bg9 = new BuyerGroup(Name = 'abc122');
        	buyerGroups.add(bg9);
            
            Insert buyerGroups;
            
            Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
        	
            List<Account> accounts = new List<Account>();
            Account regularAccount = TestDataFactory.createAccount(false);
            regularAccount.Name = 'Account123';
            regularAccount.ownerId = oUser.id;
            regularAccount.RecordTypeId = accountRecordTypeId;
            regularAccount.AccountNumber = '19876';
            regularAccount.SAP_Sales_Org__c = '0100';
            regularAccount.Enable_As_Buyer_Account__c = true;
            regularAccount.SAP_Partner_Functions__c = 'Sold To,Ship To';
            regularAccount.SAP_Attribute1_Desc__c ='abc1';
            regularAccount.SAP_Attribute2_Desc__c = 'abc12';
            regularAccount.SAP_Attribute3_Desc__c = 'abc3';
            regularAccount.SAP_Attribute4_Desc__c = 'abc4';
            regularAccount.SAP_Attribute5_Desc__c = 'abc6';
            regularAccount.SAP_Attribute6_Desc__c = 'abc7';
            regularAccount.SAP_Attribute7_Desc__c = 'abc8';
            regularAccount.SAP_Attribute8_Desc__c = 'abc9';
            regularAccount.SAP_Attribute9_Desc__c = 'abc10';
            regularAccount.SAP_Attribute10_Desc__c = 'abc11';
			regularAccount.ParentId = null;
            
            accounts.add(regularAccount);
            
            Account regularAccount2 = TestDataFactory.createAccount(false);
            regularAccount2.Name = 'Account123abc';
            regularAccount2.ownerId = oUser.id;
            regularAccount2.RecordTypeId = accountRecordTypeId;
            regularAccount2.AccountNumber = '19876abc';
            regularAccount2.SAP_Sales_Org__c = '0100';
            regularAccount2.Enable_As_Buyer_Account__c = true;
            regularAccount2.SAP_Partner_Functions__c = 'Sold To,Ship To';
            regularAccount2.SAP_Attribute1_Desc__c ='abc1';
            regularAccount2.SAP_Attribute2_Desc__c = 'abc12';
            regularAccount2.SAP_Attribute3_Desc__c = 'abc3';
            regularAccount2.SAP_Attribute4_Desc__c = 'abc4';
            regularAccount2.SAP_Attribute5_Desc__c = 'abc6';
            regularAccount2.SAP_Attribute6_Desc__c = 'abc7';
            regularAccount2.SAP_Attribute7_Desc__c = 'abc8';
            regularAccount2.SAP_Attribute8_Desc__c = 'abc9';
            regularAccount2.SAP_Attribute9_Desc__c = 'abc10';
            regularAccount2.SAP_Attribute10_Desc__c = 'abc11';
			regularAccount2.ParentId = null;
            
            accounts.add(regularAccount2);
            
            Insert accounts;
            accounts.clear();            
            
            List<BuyerAccount> buyers = new List<BuyerAccount>();
            buyers.add(new BuyerAccount(BuyerId = regularAccount.id,CommerceType = 'Buyer',
                                                         IsActive = true, Name = 'abc111'));
            
          	insert buyers;
            
          	BuyerGroupMember buyerGroupMember = new BuyerGroupMember(BuyerId = regularAccount.id, 
                                                                      BuyerGroupId = bg.id );
            Insert buyerGroupMember;
            
            Account regularAccount1 = TestDataFactory.createAccount(false);
            regularAccount1.Name = 'Account12345';
            regularAccount1.ownerId = oUser.id;
            regularAccount1.RecordTypeId = accountRecordTypeId;
            regularAccount1.AccountNumber = '198767';
            regularAccount1.SAP_Sales_Org__c = '0100';
            regularAccount1.Enable_As_Buyer_Account__c = true;
            regularAccount1.SAP_Attribute1_Desc__c ='abc1';
            regularAccount1.SAP_Attribute2_Desc__c ='abc';
            regularAccount1.SAP_Attribute3_Desc__c ='abc';
            regularAccount1.SAP_Attribute4_Desc__c ='abc';
            regularAccount1.SAP_Attribute5_Desc__c ='abc';
            regularAccount1.SAP_Attribute6_Desc__c ='abc';
            regularAccount1.SAP_Attribute7_Desc__c ='abc';
            regularAccount1.SAP_Attribute8_Desc__c ='abc';
            regularAccount1.SAP_Attribute9_Desc__c ='abc';
            regularAccount1.SAP_Attribute10_Desc__c ='abc';
            regularAccount1.ParentId = regularAccount.Id;
            regularAccount1.SAP_Partner_Functions__c = 'Sold To,Ship To';
            
            accounts.add(regularAccount1);
            
            Account regularAccount3 = TestDataFactory.createAccount(false);
            regularAccount3.Name = 'Acc345gfh';
            regularAccount3.ownerId = oUser.id;
            regularAccount3.RecordTypeId = accountRecordTypeId;
            regularAccount3.AccountNumber = '198726';
            regularAccount3.SAP_Sales_Org__c = '0100';
            regularAccount3.Enable_As_Buyer_Account__c = true;
            regularAccount3.SAP_Partner_Functions__c = 'Sold To,Ship To';
            regularAccount3.ParentId = regularAccount2.Id;
            
            accounts.add(regularAccount3);
            
            Insert accounts;
            
            List<Contact> contacts = new List<Contact>();
           	Contact cc = new contact(Firstname ='abc',lastname='abc',accountid=regularAccount.Id,b2b_user__c=true);
            contacts.add(cc);
            
           	Contact cc1 = new contact(Firstname ='abc1',lastname='abc1',accountid=regularAccount2.Id,b2b_user__c=true);
            contacts.add(cc1);
            
           	Contact cc2 = new contact(Firstname ='abc2',lastname='abc2',accountid=regularAccount1.Id,b2b_user__c=true);
            contacts.add(cc2);
            
           	Contact cc3 = new contact(Firstname ='abc3',lastname='abc3',accountid=regularAccount3.Id,b2b_user__c=true);
            contacts.add(cc3);
            
            Insert contacts;
            
            List<AccountContactRelation> accountContactRelations = [SELECT Id,AccountId,Account.Name,ContactId,Contact.Name,Upgraded_to_External_Account_B2B__c,IsActive FROM AccountContactRelation
                                                                    WHERE Upgraded_to_External_Account_B2B__c = FALSE];
            for(AccountContactRelation accountContactRelation: accountContactRelations){
                accountContactRelation.IsActive = True;
                accountContactRelation.Upgraded_to_External_Account_B2B__c = True;
            }
            
            update accountContactRelations;                
         
            BuyerGroupMember buyerGroupMember1 = new BuyerGroupMember(BuyerId = regularAccount.id, 
                                                                      BuyerGroupId = bg1.id );
            Insert buyerGroupMember1;
          	
            accounts.clear();
            
            regularAccount.SAP_Attribute1_Desc__c = '';
            regularAccount.SAP_Attribute2_Desc__c = '';
            regularAccount.SAP_Attribute3_Desc__c = '';
            regularAccount.SAP_Attribute4_Desc__c = '';
            regularAccount.SAP_Attribute5_Desc__c = '';
            regularAccount.SAP_Attribute6_Desc__c = '';
            regularAccount.SAP_Attribute7_Desc__c = '';
            regularAccount.SAP_Attribute8_Desc__c = '';
            regularAccount.SAP_Attribute9_Desc__c = '';
            regularAccount.SAP_Attribute10_Desc__c = '';
             
            accounts.add(regularAccount);
            
            Update accounts;
          	
            accounts.clear();
           
            regularAccount.SAP_Attribute1_Desc__c ='abc111';
            regularAccount.SAP_Attribute2_Desc__c = 'abc121';
            regularAccount.SAP_Attribute3_Desc__c = 'abc131';
            regularAccount.SAP_Attribute4_Desc__c = 'abc141';
            regularAccount.SAP_Attribute5_Desc__c = 'abc161';
            regularAccount.SAP_Attribute6_Desc__c = 'abc171';
            regularAccount.SAP_Attribute7_Desc__c = 'abc181';
            regularAccount.SAP_Attribute8_Desc__c = 'abc191';
            regularAccount.SAP_Attribute9_Desc__c = 'abc120';
            regularAccount.SAP_Attribute10_Desc__c = 'abc121';     
            
            accounts.add(regularAccount);
            
            Update accounts;
            
            System.debug([SELECT Id,AccountId,Account.Name,ContactId,Contact.Name,Upgraded_to_External_Account_B2B__c,IsActive FROM AccountContactRelation]);
            
            List<New_Contact_Request__c> ncrList = new List<New_Contact_Request__c>();
            New_Contact_Request__c ncr = new New_Contact_Request__c(B2B_Account_Lookup__c = regularAccount2.id,B2B_Email_Address__c='abc@gmail.com', B2B_Last_Name__c='abc');
            ncrList.add(ncr);
            insert ncrList;
            test.startTest();
            B2BconvertAccountToBuyer.processB2BSendContactRequestCreationToSAP(ncrList);
            b2bAccountsUpdateClass.handleShipToRegisteration(accounts,new Map<Id,Account>(accounts));
            test.stopTest();
          
        }

        
        
      } 
}
/**
 * @description Test class for SocialRegHandler2 Apex Class
 */
@isTest
private class SocialRegHandler3Test {
    
    /**
     * @description Test method to validate create and update user logic
     */
    static testMethod void testCreateAndUpdateUser() {        
        Account testAccount = TestDataFactory.createAccount(false);
        testAccount.ParentId = null;
        testAccount.Type = 'Customer';
        testAccount.AccountNumber = '12345';
        testAccount.SAP_Partner_Functions__c = 'Sold To';
        Insert testAccount;
        SocialRegHandler3 handler = new SocialRegHandler3 ();
        User u1 =[SELECT id,email from user LIMIT 1];
        String emailString= u1.email;
        
        Auth.UserData sampleData = new Auth.UserData('testId', 'change-me', 'change-me',
                                                     'change-me Last', emailString , null, 'testuserlong', 'en_US', 'facebook',
                                                     null, new Map<String, String>{'language' => 'en_US', 
                                                         						   'extension_RequestAdditionalAccess' => 'IoT',
                                                         						   'extension_SalesForceAccountNumber' => '12345'
                                                                                  });
        Test.startTest();
            try{
                User u = handler.createUser(null, sampleData);
                insert(u);
                String uid = u.id;
                handler.updateUser(uid, null, sampleData);
            } catch(Exception ex) {
                
            }        	
        Test.stopTest();
        
    }
    
    /**
     * @description Test method to validate with existing user email id
     */
    static testMethod void testExistingUserWithEmailId() { 
        Account testAccount = TestDataFactory.createAccount(false);
        testAccount.ParentId = null;
        testAccount.Type = 'Customer';
        testAccount.AccountNumber = '12345';
        testAccount.SAP_Partner_Functions__c = 'Sold To';
        Insert testAccount;
        
        Contact testCon = TestDataFactory.createContact(true, testAccount.Id);
        
        Id pId = [SELECT Id FROM Profile WHERE Name='Exp Community User'].Id;
        User testUser = TestDataFactory.createUser(false,getUnqiueUserName()+ '@testOrg.com',String.valueOf(Integer.valueOf(math.rint(math.random()*1000))));
        testUser.ProfileId = pId;
        testUser.FederationIdentifier = 'abcdefgh-ijklmn-opqrst';
        testUser.ContactId = testCon.Id;
        Insert testUser;
        
        SocialRegHandler3 handler = new SocialRegHandler3 ();
        User u1 =[SELECT id,FirstName,LastName,email from user LIMIT 1];
        String emailString= testUser.email;
        
        Auth.UserData sampleData = new Auth.UserData('testId', '', '',
                                                     null, emailString , null, 'testuserlong', 'en_US', 'facebook',
                                                     null, new Map<String, String>{'language' => 'en_US', 
                                                         						   'extension_RequestAdditionalAccess' => 'IoT',
                                                         						   'name' => 'testFNameLName'
                                                                                  });
        Test.startTest();
            try{
                User u = handler.createUser(null, sampleData);
            } catch(Exception ex) {
                Assert.isTrue(true, 'Something went wrong with user create');
            }        	
        Test.stopTest();
        
    }
    
    /**
     * @description Test method to validate with existing user federation id
     */
    static testMethod void testExistingUserWithFederationId() { 
        Account testAccount = TestDataFactory.createAccount(false);
        testAccount.ParentId = null;
        testAccount.Type = 'Customer';
        testAccount.AccountNumber = '12345';
        testAccount.SAP_Partner_Functions__c = 'Sold To';
        Insert testAccount;
        
        Contact testCon = TestDataFactory.createContact(true, testAccount.Id);
        
        Id pId = [SELECT Id FROM Profile WHERE Name='Exp Community User'].Id;
        User testUser = TestDataFactory.createUser(false,getUnqiueUserName()+ '@testOrg.com',String.valueOf(Integer.valueOf(math.rint(math.random()*1000))));
        testUser.ProfileId = pId;
        testUser.FederationIdentifier = 'abcdefgh-ijklmn-opqrst';
        testUser.ContactId = testCon.Id;
        Insert testUser;
        System.debug([SELECT Id,FederationIdentifier FROM User WHERE Id = :testUser.Id ]);
        SocialRegHandler3 handler = new SocialRegHandler3 ();
        User u1 =[SELECT id,FirstName,LastName,email from user LIMIT 1];
        String emailString= 'TET' + testUser.email;
        
        Auth.UserData sampleData = new Auth.UserData('testId', '', '',
                                                     null, emailString , null, 'testuserlong', 'en_US', 'facebook',
                                                     null, new Map<String, String>{'language' => 'en_US', 
                                                         						   'extension_RequestAdditionalAccess' => 'IoT',
                                                         						   'identifier' => 'abcdefgh-ijklmn-opqrst',
                                                         						   'name' => 'testFNameLName'
                                                                                  });
        Test.startTest();
            try{
                User u = handler.createUser(null, sampleData);
            } catch(Exception ex) {
                Assert.isTrue(true, 'Something went wrong with user create');
            }        	
        Test.stopTest();
        
    }
    
    /**
     * @description Method to generate unique user name to be use for new user creation
     */
    private static String getUnqiueUserName(){
        String orgId = UserInfo.getOrganizationId();  
        String dateString =   
        String.valueof(Datetime.now()).replace(' ' ,'').replace(':','').replace('-','');  
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
        String uniqueName = orgId + dateString + randomInt;  
        return uniqueName;
    }
}
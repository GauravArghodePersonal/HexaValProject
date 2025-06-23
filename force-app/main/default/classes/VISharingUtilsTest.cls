/**
 * Contains test methods for the VISharingUtils class.
 */
@IsTest
private class VISharingUtilsTest {
	/**
	 * Add a new child account to an existing customer portal enabled account.
	 */
	static testmethod void addChildAccountToExistingCustomerPortalAccount() {
		/*List<Account> customerPortalAccounts = [SELECT Id
				FROM Account
				
				LIMIT 1];
		System.assert(!customerPortalAccounts.isEmpty(),
				'test requires at least one customer portal enabled account');
		
		List<UserRole> userRoles = [SELECT Id
				FROM UserRole
				WHERE PortalAccountId = :customerPortalAccounts.get(0).Id
				AND PortalType = 'CustomerPortal'
				AND PortalRole = 'Executive'
				LIMIT 1];
		System.assert(!userRoles.isEmpty(), 'executive role not found');
		
		List<Group> groups = [SELECT Id
				FROM Group
				WHERE RelatedId = :userRoles.get(0).Id
				AND Type = 'RoleAndSubordinates'
				LIMIT 1];
		System.assert(!groups.isEmpty(), 'group not found');
		
		Test.startTest();
		
		Account childAccount = new Account();
		childAccount.ParentId = customerPortalAccounts.get(0).Id;
		childAccount.Name = 'Test Account 1';
		insert childAccount;
		
		Test.stopTest();
		
		List<AccountShare> accountShares = [SELECT Id, AccountAccessLevel,
				OpportunityAccessLevel, CaseAccessLevel
				FROM AccountShare
				WHERE AccountId = :childAccount.Id
				AND UserOrGroupId = :groups.get(0).Id];
		System.assert(!accountShares.isEmpty(), 'share not created');
		System.assertEquals('Edit', accountShares.get(0).AccountAccessLevel);
		System.assertEquals('None', accountShares.get(0).OpportunityAccessLevel);
		System.assertEquals('None', accountShares.get(0).CaseAccessLevel);*/
	}
	
	/**
	 * Change the parent account of an existing account.
	 */
	 
	static testmethod void changeParentToCustomerPortalAccount() {
		
		Account acct1 = TestObjects.newAccount();
		Account acct2 = TestObjects.newAccount();
		
		List<Account> customerPortalAccounts = [SELECT Id
				FROM Account
				
				LIMIT 2];
				
		//System.assertEquals(2, customerPortalAccounts.size(), 'test requires 2 customer portal enabled accounts');
		
		Test.startTest();
		
		if (customerPortalAccounts.size() == 2) {
			
			Account childAccount = new Account();
			childAccount.ParentId = customerPortalAccounts.get(0).Id;
			childAccount.Name = 'Test Account 1';
			insert childAccount;
			
			childAccount.ParentId = customerPortalAccounts.get(1).Id;
			update childAccount;
		}
		
		Test.stopTest();
	}	 
}
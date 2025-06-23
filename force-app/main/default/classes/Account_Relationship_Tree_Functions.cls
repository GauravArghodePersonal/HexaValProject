global without sharing class Account_Relationship_Tree_Functions {

	global class AccountTreeData {
		webservice Id topLevelId;
		webservice Id HQAccountId;
		webservice List<Account> accountDetails;
		
		private AccountTreeData() {
			accountDetails = new List<Account>();
		}
	}

    webservice static AccountTreeData getRelatedAccountsV2(Id accountId) {
		AccountTreeData results = new AccountTreeData();
		Set<Id> accountIdsToRetrieve = new Set<Id>(); 

		Id HQAccountId;
		Boolean usingHQAccount = false;

		accountIdsToRetrieve.add(accountId);

        Account acc = [SELECT ParentId, 
                              Parent.ParentId, 
                              Parent.Parent.ParentId, 
                              Parent.Parent.Parent.ParentId, 
                              Parent.Parent.Parent.Parent.ParentId, 
                              Parent.Parent.Parent.Parent.Parent.ParentId, 
                              Sales_Ultimate_Parent__c, HQ_Account__c FROM Account WHERE Id = :accountId];

//		// Determine if an HQ Account is involved
//        HQAccountId = acc.HQ_Account__c;
//		if (HQAccountId != null) {usingHQAccount = true;}

		//HQ Processing
		if (acc.HQ_Account__c != null) {
			/* This account has an HQ Account Related to it */
	        HQAccountId = acc.HQ_Account__c;
	        usingHQAccount = true;
		}
		else {
			//Check if the account passed in is an HQ_Account to other Accounts
			List<Account> HQAccount_ChildAccounts = [SELECT Id, HQ_Account__c FROM Account WHERE HQ_Account__c = :accountId];

			if (HQAccount_ChildAccounts.size() > 0) {
				/* This account is an HQ Account */
				HQAccountId = accountId;
				usingHQAccount = true;
			}
			else {
				HQAccountId = null;
				usingHQAccount = false;
			}
		}


		//Check if the account passed in is an HQ_Account to other Accounts
//		List<Account> HQAccount_ChildAccounts = [SELECT Id, HQ_Account__c FROM Account WHERE HQ_Account__c = :accountId];
//		
//		if (HQAccount_ChildAccounts.size() > 0) {
//			HQAccountId = accountId;
//			usingHQAccount = true;
//		}
		
		//for (Account HQAccount_ChildAccount : HQAccount_ChildAccounts) {accountIdsToRetrieve.add(HQAccount_ChildAccount.Id);}

		Id topLevelParentId;
		Id salesUltimateParentId;

		// Determine Top Level Parent Id 
		topLevelParentId = acc.Id;
		if (acc.ParentId != null) {topLevelParentId = acc.ParentId;}
		if (acc.Parent.ParentId != null) {topLevelParentId = acc.Parent.ParentId;}
		if (acc.Parent.Parent.ParentId != null) {topLevelParentId = acc.Parent.Parent.ParentId;}
		if (acc.Parent.Parent.Parent.ParentId != null) {topLevelParentId = acc.Parent.Parent.Parent.ParentId;}
		if (acc.Parent.Parent.Parent.Parent.ParentId != null) {topLevelParentId = acc.Parent.Parent.Parent.Parent.ParentId;}
		if (acc.Parent.Parent.Parent.Parent.Parent.ParentId != null) {topLevelParentId = acc.Parent.Parent.Parent.Parent.Parent.ParentId;}

		// Determine if Sales Ultimate Parent Exists
		if (acc.Sales_Ultimate_Parent__c != null) {
			salesUltimateParentId = acc.Sales_Ultimate_Parent__c;
			accountIdsToRetrieve.add(salesUltimateParentId);
		}

		// Find the appropriate Top Level parent and retrieve Children
		Id startingId;
		
		if (salesUltimateParentId != null) {
			startingId = salesUltimateParentId;
		}
		else {
			startingId = topLevelParentId;
		}
		
		//if (acc.Sales_Ultimate_Parent__c != null) {
		//	startingId = acc.Sales_Ultimate_Parent__c;
		//}
		//else {
		//	startingId = acc.Id;
		//	if (acc.ParentId != null) {startingId = acc.ParentId;}
		//	if (acc.Parent.ParentId != null) {startingId = acc.Parent.ParentId;}
		//	if (acc.Parent.Parent.ParentId != null) {startingId = acc.Parent.Parent.ParentId;}
		//	if (acc.Parent.Parent.Parent.ParentId != null) {startingId = acc.Parent.Parent.Parent.ParentId;}
		//	if (acc.Parent.Parent.Parent.Parent.ParentId != null) {startingId = acc.Parent.Parent.Parent.Parent.ParentId;}
		//	if (acc.Parent.Parent.Parent.Parent.Parent.ParentId != null) {startingId = acc.Parent.Parent.Parent.Parent.Parent.ParentId;}
		//}
		
		List<Id> idsToRetrieveRelationships = new List<Id>();
		
		if (topLevelParentId != null) {idsToRetrieveRelationships.add(topLevelParentId);}
		if (salesUltimateParentId != null) {idsToRetrieveRelationships.add(salesUltimateParentId);}
		
		if (!idsToRetrieveRelationships.isEmpty()) {
			List<Account_Relationship__c> accountRelationships = [SELECT Parent_Account__c, Child_Account__c FROM Account_Relationship__c WHERE Parent_Account__c IN :idsToRetrieveRelationships];
			for (Account_Relationship__c accountRelationship : accountRelationships) {
				accountIdsToRetrieve.add(accountRelationship.Child_Account__c);
				accountIdsToRetrieve.add(accountRelationship.Parent_Account__c);
			}
		}

		//Retrieve The Accounts
        List<Account> accountDetails;

		if (usingHQAccount) {
	        accountDetails = [SELECT Id, Name, NameLocal, Type, RecordTypeId, RecordType.Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, AccountNumber, OwnerId, 
	                                 Owner.Name, Owner_Name__c, SAP_Account_Name_2__c, SAP_Accounting_Group__c, SAP_Partner_Functions__c, SAP_Customer_Group__c, SAP_Customer_Group_Desc__c, 
	                                 SAP_Customer_Group_1__c, SAP_Customer_Group_1_Desc__c, SAP_Sales_Org__c, SAP_Sales_Org_Desc__c, SAP_DistChannel__c, SAP_Dist_Channel_Desc__c, SAP_DivisionCode__c, 
	                                 SAP_Division_Desc__c, SAP_Exempt_Quantity_Surcharge__c, SAP_Sales_Office__c, SAP_Sales_Office_Desc__c, SAP_SalesGroup__c, SAP_Sales_Group_Desc__c, 
	                                 SAP_SalesDistrict__c, SAP_Sales_District_Desc__c, SAP_Currency__c, SAP_Customer_Number__c, SAP_Customer_Type__c, SAP_PartnerFunctionCodeText__c, 
	                                 SAP_National_Account__c, SAP_PartnerFunctionText__c, SAP_Region__c, SAP_Seller__c, SAP_Seller_Name__c, SAP_ShippingPlant__c, SAP_State__c, SAP_Street__c, 
	                                 SAP_Zip_Code__c, Active_Account__c, Street_Address__c, State_City_Country__c, sales_area__c, Full_Address__c, Account_Number_and_Status__c, Inside_Seller_Number__c, 
	                                 Inside_Seller_Name__c, Sales_Ultimate_Parent__c, HQ_Account__c, ParentId, Parent.Type, Parent.RecordType.Name, Parent.SAP_Partner_Functions__c, Parent.Sales_Ultimate_Parent__c, Parent.HQ_Account__c
	                            FROM Account
	                           WHERE HQ_Account__c = :HQAccountId
	                              OR Id = :HQAccountId
	                              OR Id in :accountIdsToRetrieve
	                         ];
		}
		else {
	        accountDetails = [SELECT Id, Name, NameLocal, Type, RecordTypeId, RecordType.Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, AccountNumber, OwnerId, 
	                                 Owner.Name, Owner_Name__c, SAP_Account_Name_2__c, SAP_Accounting_Group__c, SAP_Partner_Functions__c, SAP_Customer_Group__c, SAP_Customer_Group_Desc__c, 
	                                 SAP_Customer_Group_1__c, SAP_Customer_Group_1_Desc__c, SAP_Sales_Org__c, SAP_Sales_Org_Desc__c, SAP_DistChannel__c, SAP_Dist_Channel_Desc__c, SAP_DivisionCode__c, 
	                                 SAP_Division_Desc__c, SAP_Exempt_Quantity_Surcharge__c, SAP_Sales_Office__c, SAP_Sales_Office_Desc__c, SAP_SalesGroup__c, SAP_Sales_Group_Desc__c, 
	                                 SAP_SalesDistrict__c, SAP_Sales_District_Desc__c, SAP_Currency__c, SAP_Customer_Number__c, SAP_Customer_Type__c, SAP_PartnerFunctionCodeText__c, 
	                                 SAP_National_Account__c, SAP_PartnerFunctionText__c, SAP_Region__c, SAP_Seller__c, SAP_Seller_Name__c, SAP_ShippingPlant__c, SAP_State__c, SAP_Street__c, 
	                                 SAP_Zip_Code__c, Active_Account__c, Street_Address__c, State_City_Country__c, sales_area__c, Full_Address__c, Account_Number_and_Status__c, Inside_Seller_Number__c, 
	                                 Inside_Seller_Name__c, Sales_Ultimate_Parent__c, HQ_Account__c, ParentId, Parent.Type, Parent.RecordType.Name, Parent.SAP_Partner_Functions__c, Parent.Sales_Ultimate_Parent__c, Parent.HQ_Account__c
	                            FROM Account
	                           WHERE Id in :accountIdsToRetrieve 
	                         ];
		}		
		
		results.topLevelId = startingId; 
		if (usingHQAccount) {results.HQAccountId = HQAccountId;}
		results.accountDetails = accountDetails;
		
		return results;	
    }
	
	
    webservice static List<Account> getRelatedAccounts(Id accountId) {
        List<Account> results = new List<Account>();
        
        List<Id> relatedAccountIds = new List<Id>();
        Boolean runWithParentIds = true;

        //Add the current account to the list
        relatedAccountIds.add(accountId);
        
        Account acc = [SELECT parentId, HQ_Account__c FROM Account WHERE Id = :accountId];
        
        Id parentId = acc.parentId;
        Id HQAccountId = acc.HQ_Account__c;
        
        try {
            //Test query the parent record to confirm we have access
            Account testQuery = [SELECT id FROM Account WHERE Id = :parentId];
        } 
        catch (Exception e) {
            //Since we don't have access, ignore the parent Id
            runWithParentIds = false;
        }
       
        
        
        if (parentId != null)
        {
            relatedAccountIds.add(parentId);
            
            List<Account> otherAcctswithSameParent = [SELECT Id FROM Account WHERE parentId = :parentId AND Id != :accountId];
            
            for (Account a:otherAcctswithSameParent)
            {
                relatedAccountIds.add(a.Id);
            }
        }
        
        //if (HQAccountId != null) {relatedAccountIds.add(HQAccountId);}
        
        //Add any records that are children of this account
        List<Account> childAccounts = [SELECT Id FROM Account WHERE parentId = :accountId];
            
        for (Account a:childAccounts)
        {
            relatedAccountIds.add(a.Id);
        }
  
        if (runWithParentIds == true)
        {
            results = [SELECT Id, Name, NameLocal, Type, RecordTypeId, RecordType.Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, AccountNumber, OwnerId, 
                              Owner.Name, SAP_Account_Name_2__c, SAP_Accounting_Group__c, SAP_Partner_Functions__c, SAP_Customer_Group__c, SAP_Customer_Group_Desc__c, 
                              SAP_Customer_Group_1__c, SAP_Customer_Group_1_Desc__c, SAP_Sales_Org__c, SAP_Sales_Org_Desc__c, SAP_DistChannel__c, SAP_Dist_Channel_Desc__c, SAP_DivisionCode__c, 
                              SAP_Division_Desc__c, SAP_Exempt_Quantity_Surcharge__c, SAP_Sales_Office__c, SAP_Sales_Office_Desc__c, SAP_SalesGroup__c, SAP_Sales_Group_Desc__c, 
                              SAP_SalesDistrict__c, SAP_Sales_District_Desc__c, SAP_Currency__c, SAP_Customer_Number__c, SAP_Customer_Type__c, SAP_PartnerFunctionCodeText__c, 
                              SAP_National_Account__c, SAP_PartnerFunctionText__c, SAP_Region__c, SAP_Seller__c, SAP_Seller_Name__c, SAP_ShippingPlant__c, SAP_State__c, SAP_Street__c, 
                              SAP_Zip_Code__c, Active_Account__c, Street_Address__c, State_City_Country__c, sales_area__c, Full_Address__c, Account_Number_and_Status__c, Inside_Seller_Number__c, 
                              Inside_Seller_Name__c, ParentId, 
                                (SELECT Id, Customer_Number__c, Customer_Type__c, Source_Customer__c, Source_Customer_AccountNumber__c, Source_Customer_Active_Account__c, 
                                        Source_Customer_Name__c, Source_Customer_Name_Local__c, Source_Customer_SAP_Account_Name_2__c, Source_Customer_SAP_Customer_Type__c, 
                                        Source_Customer_Type__c, Source_Customer_SAP_Partner_Functions__c, Source_Customer_Billing_City__c, Source_Customer_Billing_State_Province__c, 
                                        Source_Customer_Billing_Country__c, Source_Customer_Owner_Name__c, Source_Customer_SAP_Sales_Org__c, Source_Customer_SAP_Division_Code__c, 
                                        Source_Customer_SAP_Dist_Channel__c, Source_Customer_SAP_Customer_Group_Desc__c, Source_Customer_SAP_Customer_Group_1_Des__c, 
                                        Source_Customer_SAP_Sales_Office_Desc__c, Source_Customer_SAP_Sales_Group_Desc__c, Source_Customer_SAP_Sales_District_Desc__c,
                                        Source_Customer_Full_Address__c, Source_Customer_Sales_Area__c, Source_Customer_ParentId__c, Target_Customer__c, Target_Customer_AccountNumber__c, 
                                        Target_Customer_Active_Account__c, Target_Customer_Name__c, Target_Customer_Name_Local__c, Target_Customer_SAP_Account_Name_2__c, 
                                        Target_Customer_SAP_Customer_Type__c, Target_Customer_Type__c, Target_Customer_SAP_Partner_Functions__c, Target_Customer_Billing_City__c,
                                        Target_Customer_Billing_State_Province__c, Target_Customer_Billing_Country__c, Target_Customer_Owner_Name__c, Target_Customer_SAP_Sales_Org__c,
                                        Target_Customer_SAP_Division_Code__c, Target_Customer_SAP_Dist_Channel__c, Target_Customer_SAP_Customer_Group_Desc__c, 
                                        Target_Customer_SAP_Sales_Office_Desc__c, Target_Customer_SAP_Sales_Group_Desc__c, Target_Customer_SAP_Sales_District_Desc__c,
                                        Target_Customer_SAP_Customer_Group_1_Des__c, Target_Customer_Full_Address__c, Target_Customer_Sales_Area__c, Target_Customer_ParentId__c  
                                   FROM CISRelationships__r ORDER BY Target_Customer_AccountNumber__c),  
                                (SELECT Id, Customer_Number__c, Customer_Type__c, Source_Customer__c, Source_Customer_AccountNumber__c, Source_Customer_Active_Account__c, 
                                        Source_Customer_Name__c, Source_Customer_Name_Local__c, Source_Customer_SAP_Account_Name_2__c, Source_Customer_SAP_Customer_Type__c, Source_Customer_Type__c, 
                                        Source_Customer_SAP_Partner_Functions__c, Source_Customer_Billing_City__c, Source_Customer_Billing_State_Province__c, Source_Customer_Billing_Country__c,  
                                        Source_Customer_Owner_Name__c, Source_Customer_SAP_Sales_Org__c, Source_Customer_SAP_Division_Code__c, Source_Customer_SAP_Dist_Channel__c, 
                                        Source_Customer_SAP_Sales_Office_Desc__c, Source_Customer_SAP_Sales_Group_Desc__c, Source_Customer_SAP_Sales_District_Desc__c,
                                        Source_Customer_SAP_Customer_Group_Desc__c, Source_Customer_SAP_Customer_Group_1_Des__c,  Source_Customer_Full_Address__c, Source_Customer_Sales_Area__c, 
                                        Source_Customer_ParentId__c, Target_Customer__c, Target_Customer_AccountNumber__c, Target_Customer_Active_Account__c, Target_Customer_Name__c, 
                                        Target_Customer_Name_Local__c, Target_Customer_SAP_Account_Name_2__c, Target_Customer_SAP_Customer_Type__c, Target_Customer_Type__c, 
                                        Target_Customer_SAP_Partner_Functions__c, Target_Customer_Billing_City__c, Target_Customer_Billing_State_Province__c, Target_Customer_Billing_Country__c,  
                                        Target_Customer_Owner_Name__c, Target_Customer_SAP_Sales_Org__c, Target_Customer_SAP_Division_Code__c, Target_Customer_SAP_Dist_Channel__c, 
                                        Target_Customer_SAP_Sales_Office_Desc__c, Target_Customer_SAP_Sales_Group_Desc__c, Target_Customer_SAP_Sales_District_Desc__c,
                                        Target_Customer_SAP_Customer_Group_Desc__c, Target_Customer_SAP_Customer_Group_1_Des__c, Target_Customer_Full_Address__c, Target_Customer_Sales_Area__c, 
                                        Target_Customer_ParentId__c  
                                   FROM CIS_Relationships__r ORDER BY Source_Customer_AccountNumber__c)  
                     FROM Account   
                     WHERE id IN :relatedAccountIds 
                     ORDER BY AccountNumber
                    ];
         }
         else
         {
            results = [SELECT Id, Name, NameLocal, Type, RecordTypeId, RecordType.Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, AccountNumber, OwnerId, 
                              Owner.Name, SAP_Account_Name_2__c, SAP_Accounting_Group__c, SAP_Partner_Functions__c, SAP_Customer_Group__c, SAP_Customer_Group_Desc__c, 
                              SAP_Customer_Group_1__c, SAP_Customer_Group_1_Desc__c, SAP_Sales_Org__c, SAP_Sales_Org_Desc__c, SAP_DistChannel__c, SAP_Dist_Channel_Desc__c, SAP_DivisionCode__c, 
                              SAP_Division_Desc__c, SAP_Exempt_Quantity_Surcharge__c, SAP_Sales_Office__c, SAP_Sales_Office_Desc__c, SAP_SalesGroup__c, SAP_Sales_Group_Desc__c, 
                              SAP_SalesDistrict__c, SAP_Sales_District_Desc__c, SAP_Currency__c, SAP_Customer_Number__c, SAP_Customer_Type__c, SAP_PartnerFunctionCodeText__c, 
                              SAP_National_Account__c, SAP_PartnerFunctionText__c, SAP_Region__c, SAP_Seller__c, SAP_Seller_Name__c, SAP_ShippingPlant__c, SAP_State__c, SAP_Street__c, 
                              SAP_Zip_Code__c, Active_Account__c, Street_Address__c, State_City_Country__c, sales_area__c, Full_Address__c, Account_Number_and_Status__c, Inside_Seller_Number__c, 
                              Inside_Seller_Name__c, 
                                (SELECT Id, Customer_Number__c, Customer_Type__c, Source_Customer__c, Source_Customer_AccountNumber__c, Source_Customer_Active_Account__c, 
                                        Source_Customer_Name__c, Source_Customer_Name_Local__c, Source_Customer_SAP_Account_Name_2__c, Source_Customer_SAP_Customer_Type__c, 
                                        Source_Customer_Type__c, Source_Customer_SAP_Partner_Functions__c, Source_Customer_Billing_City__c, Source_Customer_Billing_State_Province__c, 
                                        Source_Customer_Billing_Country__c, Source_Customer_Owner_Name__c, Source_Customer_SAP_Sales_Org__c, Source_Customer_SAP_Division_Code__c, 
                                        Source_Customer_SAP_Dist_Channel__c, Source_Customer_SAP_Customer_Group_Desc__c, Source_Customer_SAP_Customer_Group_1_Des__c, 
                                        Source_Customer_SAP_Sales_Office_Desc__c, Source_Customer_SAP_Sales_Group_Desc__c, Source_Customer_SAP_Sales_District_Desc__c,
                                        Source_Customer_Full_Address__c, Source_Customer_Sales_Area__c, Target_Customer__c, Target_Customer_AccountNumber__c, 
                                        Target_Customer_Active_Account__c, Target_Customer_Name__c, Target_Customer_Name_Local__c, Target_Customer_SAP_Account_Name_2__c, 
                                        Target_Customer_SAP_Customer_Type__c, Target_Customer_Type__c, Target_Customer_SAP_Partner_Functions__c, Target_Customer_Billing_City__c,
                                        Target_Customer_Billing_State_Province__c, Target_Customer_Billing_Country__c, Target_Customer_Owner_Name__c, Target_Customer_SAP_Sales_Org__c,
                                        Target_Customer_SAP_Division_Code__c, Target_Customer_SAP_Dist_Channel__c, Target_Customer_SAP_Customer_Group_Desc__c, 
                                        Target_Customer_SAP_Sales_Office_Desc__c, Target_Customer_SAP_Sales_Group_Desc__c, Target_Customer_SAP_Sales_District_Desc__c,
                                        Target_Customer_SAP_Customer_Group_1_Des__c, Target_Customer_Full_Address__c, Target_Customer_Sales_Area__c
                                   FROM CISRelationships__r ORDER BY Target_Customer_AccountNumber__c),  
                                (SELECT Id, Customer_Number__c, Customer_Type__c, Source_Customer__c, Source_Customer_AccountNumber__c, Source_Customer_Active_Account__c, 
                                        Source_Customer_Name__c, Source_Customer_Name_Local__c, Source_Customer_SAP_Account_Name_2__c, Source_Customer_SAP_Customer_Type__c, Source_Customer_Type__c, 
                                        Source_Customer_SAP_Partner_Functions__c, Source_Customer_Billing_City__c, Source_Customer_Billing_State_Province__c, Source_Customer_Billing_Country__c,  
                                        Source_Customer_Owner_Name__c, Source_Customer_SAP_Sales_Org__c, Source_Customer_SAP_Division_Code__c, Source_Customer_SAP_Dist_Channel__c, 
                                        Source_Customer_SAP_Sales_Office_Desc__c, Source_Customer_SAP_Sales_Group_Desc__c, Source_Customer_SAP_Sales_District_Desc__c,
                                        Source_Customer_SAP_Customer_Group_Desc__c, Source_Customer_SAP_Customer_Group_1_Des__c,  Source_Customer_Full_Address__c, Source_Customer_Sales_Area__c, 
                                        Target_Customer__c, Target_Customer_AccountNumber__c, Target_Customer_Active_Account__c, Target_Customer_Name__c, 
                                        Target_Customer_Name_Local__c, Target_Customer_SAP_Account_Name_2__c, Target_Customer_SAP_Customer_Type__c, Target_Customer_Type__c, 
                                        Target_Customer_SAP_Partner_Functions__c, Target_Customer_Billing_City__c, Target_Customer_Billing_State_Province__c, Target_Customer_Billing_Country__c,  
                                        Target_Customer_Owner_Name__c, Target_Customer_SAP_Sales_Org__c, Target_Customer_SAP_Division_Code__c, Target_Customer_SAP_Dist_Channel__c, 
                                        Target_Customer_SAP_Sales_Office_Desc__c, Target_Customer_SAP_Sales_Group_Desc__c, Target_Customer_SAP_Sales_District_Desc__c,
                                        Target_Customer_SAP_Customer_Group_Desc__c, Target_Customer_SAP_Customer_Group_1_Des__c, Target_Customer_Full_Address__c, Target_Customer_Sales_Area__c 
                                   FROM CIS_Relationships__r ORDER BY Source_Customer_AccountNumber__c)  
                     FROM Account   
                     WHERE id IN :relatedAccountIds 
                     ORDER BY AccountNumber
                     ];
         }
            
        return results;
    }
}
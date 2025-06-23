public without sharing class Account_Relationship {

    /* Developer Console Test Code
    List<Account> accounts = new List<Account>();
    accounts = [SELECT Id, ParentId, Parent_Chain__c FROM Account WHERE ParentId != '' LIMIT 1];
    Account_Relationship.createAccountRelationshipRecords(accounts);
    */ 

    public static createAccountRelationshipRecordsResult createAccountRelationshipRecords(Id accountId) {
        return createAccountRelationshipRecords(ListMethods.newWithData(accountId),true);
    }
    
    public static createAccountRelationshipRecordsResult createAccountRelationshipRecords(List<Id> accountIds) {
        return createAccountRelationshipRecords(accountIds,true);
    }
    
    public static createAccountRelationshipRecordsResult createAccountRelationshipRecords(List<Account> accounts) {
        return createAccountRelationshipRecords(accounts,true);
    }
    
    public static createAccountRelationshipRecordsResult createAccountRelationshipRecords(List<Id> accountIds, Boolean processChildren) {
        List<Account> accounts = [SELECT Id, ParentId, Parent_Chain__c, Prev_Parent_Chain__c FROM Account WHERE Id in :accountIds];
        return createAccountRelationshipRecords(accounts, processChildren);
    }
    
    
    public class CreateAccountRelationshipRecordsResult {
        public integer postponed = 0;
        public List<String> errors = new List<String>();
    }
    
    public static createAccountRelationshipRecordsResult createAccountRelationshipRecords(List<Account> accounts, Boolean processChildren) {
        //----------
        // Var Init
        //----------
        CreateAccountRelationshipRecordsResult result = new createAccountRelationshipRecordsResult(); 
        
        Integer postponed = 0;
        List<Id> accountIds = new List<Id>();
        List<Account_Relationship__c> newAccountRelationships = new List<Account_Relationship__c>();
        Map<Id,Account> accountUpdatesMap = new Map<Id,Account>(); // Hold Account Updates for the Prev_Parent_Chain__c field

        //-----------------------------------------------------
        // Delete up any existing Account Relationship Records      
        //-----------------------------------------------------
        removeAccountRelationshipRecords(accounts);

        //--------------------------------
        // Loop over accounts and process
        //--------------------------------
        for(Account account:accounts) {
            accountIds.add(account.Id);
            
            String parentChain = account.Parent_Chain__c;
            if (parentChain != null && parentChain != '') {
                List<String> parentChainIds = parentChain.split(':');
                
                Integer separation = 1;
                for (String parentChainId : parentChainIds) {

                    // Create the new record                    
                    Account_Relationship__c newRec = new Account_Relationship__c();
                    newRec.Child_Account__c = account.Id;
                    newRec.Parent_Account__c = parentChainId;
                    newRec.Recalc_Needed__c = true;
                    newRec.Separation__c = separation;
                    
                    // Add to the list
                    newAccountRelationships.add(newRec);
                    
                    //Increment Separation for next item
                    separation++;
                }

            }
            else {
                //Create a rec that does not point to a parent
                Account_Relationship__c newRec = new Account_Relationship__c();
                newRec.Child_Account__c = account.Id;
                newRec.Recalc_Needed__c = true;
                
                // Add to the list
                newAccountRelationships.add(newRec);
            }
            
            
            // Add accounts to the list to update their Prev_Parent_Chain__c field
            if (account.Parent_Chain__c != account.Prev_Parent_Chain__c) {
                account.Prev_Parent_Chain__c = account.Parent_Chain__c;
                accountUpdatesMap.put(account.Id,account);
            }
        }

        //--------------------------------------
        // Insert the new Account Relationships
        //--------------------------------------
        
        Boolean errorsOccurred = false;
        
        if (newAccountRelationships.size() > 0) {
            //insert newAccountRelationships;
            List<Database.SaveResult> newAccountRelationshipsInsertResults = database.insert(newAccountRelationships,false);
            
            Integer newAccountRelationshipsIndex = 0;
            for (Database.SaveResult newAccountRelationshipsInsertResult : newAccountRelationshipsInsertResults) {
                
                Id Error_parentAccountId = newAccountRelationships[newAccountRelationshipsIndex].Parent_Account__c;
                Id Error_childAccountId = newAccountRelationships[newAccountRelationshipsIndex].Child_Account__c;
                
                for(Database.Error err: newAccountRelationshipsInsertResult.getErrors()) {
                    result.errors.add('Error Inserting Account Relationship - Parent Account Id = ' + isNull(Error_parentAccountId) + ' - Child Account Id = ' + isNull(Error_childAccountId) + ' - ' + isNull(err.getMessage()));
                    errorsOccurred = true;  
                }
                
                newAccountRelationshipsIndex++;
            }
        }

        //-----------------------------------------------------
        // Update Account Relationships Need Reprocessed flags
        //-----------------------------------------------------
        if (accountUpdatesMap.size() > 0 && !errorsOccurred) {
            List<Account> accountUpdates = accountUpdatesMap.values();
            //update accountUpdates;
            List<Database.SaveResult> accountUpdatesUpdateResults = database.update(accountUpdates,false);
            
            Integer accountUpdatesIndex = 0;
            for (Database.SaveResult accountUpdatesUpdateResult : accountUpdatesUpdateResults) {
                Id errorAccountId = accountUpdatesUpdateResult.getId();
                //Id errorAccountId = accountUpdates[accountUpdatesIndex].Id;
                
                for(Database.Error err: accountUpdatesUpdateResult.getErrors()) {
                    result.errors.add('Error Updating Account: ' + isNull(errorAccountId) + ' - ' + isNull(err.getMessage()));  
                }
                
                accountUpdatesIndex++;
            }
        }
        
        //---------------------------------
        // Perform Child Record Processing
        //---------------------------------
        if (processChildren) {
            
            // Check for any Child Accounts that need rebuilt
            List<Id> childAccountIds = new List<Id>();
            List<Account> childAccounts = [Select Id FROM Account WHERE ParentId in :accountIds LIMIT 5000];
            childAccountIds = new List<Id>(new Map<Id,Account>(childAccounts).keySet());
            
            if (childAccountIds.size() > 0) {
                Integer threshholdForFutureCalls = 50;
                Integer threshholdForBatchProcessing = 1000;
                
                Boolean processNow = false;
                Boolean processAsFuture = false;
                Boolean processAsBatch = false;
                Boolean futureCallPossible = false;
    
                // Check the current environment for possible processing options
                if (!System.isFuture() && !System.isBatch()) {
                    if (Limits.getLimitFutureCalls() > 0) {futureCallPossible = true;}
                }
    
                // Set the flags based on the data
    
                if (childAccountIds.size() <= threshholdForFutureCalls) {
                    processNow = true;
                }
                else {
                    if (childAccountIds.size() > threshholdForFutureCalls && childAccountIds.size() < threshholdForBatchProcessing) {
                        if (!System.isFuture() && futureCallPossible) {
                            processAsFuture = true;
                        } 
                        else {
                            postponed += childAccountIds.size();
                            processAsBatch = true;
                        }
                    }
                    else {
                        if (childAccountIds.size() > threshholdForBatchProcessing) {
                            if (!System.isBatch()) {
                                postponed += childAccountIds.size();
                                processAsBatch = true;
                            }
                            else {
                                postponed += childAccountIds.size();
                                processAsBatch = true;
                            }
                        }
                    }
                }
                
                System.debug('*** System.isFuture() = ' + System.isFuture());
                System.debug('*** System.isBatch() = ' + System.isBatch());
                System.debug('*** Limits.getFutureCalls() = ' + Limits.getFutureCalls());
                System.debug('*** Limits.getLimitFutureCalls() = ' + Limits.getLimitFutureCalls());
                System.debug('*** childAccountIds.size() = ' + childAccountIds.size());
                System.debug('*** futureCallPossible = ' + futureCallPossible);
                System.debug('*** processNow = ' + processNow);
                System.debug('*** processAsFuture = ' + processAsFuture);
                System.debug('*** processAsBatch = ' + processAsBatch);
                
                if (processNow) {
                    CreateAccountRelationshipRecordsResult newResults = createAccountRelationshipRecords(childAccountIds);
                    postponed += newResults.postponed;
                    for (String err:newResults.errors) {
                    	if (isNull(err) != '') {
                    		result.errors.add(isNull(err));
                    	}
                    }
                }
    
                if (processAsFuture) {
                    futureCreateAccountRelationshipRecords(childAccountIds);
                }
                
                if (processAsBatch) {
                    // Do Nothing, these will be processed in a future batch
                }
            }
        }

        result.postponed = postponed;

		if (result.errors.size() > 0) {
        	System.debug('result.errors = ' + result.errors);
	        AppLogV2.write('JHKInAccount_Relationship', 'JHK', 'JHK', '', 'Error', 'Debug', 'Error', '', String.valueOf(result.errors), '', '', '');
		}

        return result;
    }
   
    @Future
    public static void futureCreateAccountRelationshipRecords(List<Id> accountIds) {
        CreateAccountRelationshipRecordsResult results = createAccountRelationshipRecords(accountIds);
        
        if (results.errors.size() > 0) {
            AppLog.write('AccountRelationshipsFunctions','','futureCreateAccountRelationshipRecords:','Error','','Errors Occurred = ' + String.join(results.errors,'\n'));  
        }
    }   
   
    public static void removeAccountRelationshipRecords(List<Account> accounts) {
        List<Id> accountIds = new List<Id>();
        for(Account account:accounts) {accountIds.add(account.Id);}
        List<Account_Relationship__c> recsToDelete = [SELECT Id, Child_Account__c FROM Account_Relationship__c WHERE Child_Account__c IN :accountIds];
        try {
        	delete recsToDelete;
        }
        catch (Exception e) {}
    }



    public static void setRecalcNeededBasedOnParentAccount(Account account, Boolean recalcNeeded) {
        List<Account> accounts = new List<Account>();
        accounts.add(account);
        setRecalcNeededBasedOnParentAccount(accounts,recalcNeeded);
    }   

    public static void setRecalcNeededBasedOnChildAccount(Account account, Boolean recalcNeeded) {
        List<Account> accounts = new List<Account>();
        accounts.add(account);
        setRecalcNeededBasedOnChildAccount(accounts,recalcNeeded);
    }   

    public static void setRecalcNeededBasedOnParentAccount(List<Account> accounts, Boolean recalcNeeded) {
        List<Id> accountIds = new List<Id>();
        for(Account account:accounts) {accountIds.add(account.Id);}
        setRecalcNeededBasedOnParentAccount(accountIds,recalcNeeded);
    }   

    public static void setRecalcNeededBasedOnChildAccount(List<Account> accounts, Boolean recalcNeeded) {
        List<Id> accountIds = new List<Id>();
        for(Account account:accounts) {accountIds.add(account.Id);}
        setRecalcNeededBasedOnChildAccount(accountIds,recalcNeeded);
    }   

    public static void setRecalcNeededBasedOnParentAccount(Id accountId, Boolean recalcNeeded) {
        List<Id> accountIds = new List<Id>();
        accountIds.add(accountId);
        setRecalcNeededBasedOnParentAccount(accountIds,recalcNeeded);
    }   

    public static void setRecalcNeededBasedOnChildAccount(Id accountId, Boolean recalcNeeded) {
        List<Id> accountIds = new List<Id>();
        accountIds.add(accountId);
        setRecalcNeededBasedOnChildAccount(accountIds,recalcNeeded);
    }   

    public static void setRecalcNeededBasedOnParentAccount(List<Id> accountIds, Boolean recalcNeeded) {
        List<Account_Relationship__c> accountRelationships = [SELECT Id, Child_Account__c, Recalc_Needed__c FROM Account_Relationship__c WHERE Parent_Account__c IN :accountIds];
        setRecalcNeeded(accountRelationships,recalcNeeded);
    }   

    public static void setRecalcNeededBasedOnChildAccount(List<Id> accountIds, Boolean recalcNeeded) {
        List<Account_Relationship__c> accountRelationships = [SELECT Id, Child_Account__c, Recalc_Needed__c FROM Account_Relationship__c WHERE Child_Account__c IN :accountIds];
        setRecalcNeeded(accountRelationships,recalcNeeded);
    }   

    public static void setRecalcNeeded(Account_Relationship__c accountRelationship, Boolean recalcNeeded) {
        List<Account_Relationship__c> accountRelationships = new List<Account_Relationship__c>();
        accountRelationships.add(accountRelationship);
        setRecalcNeeded(accountRelationships,recalcNeeded);
    }
    
    public static void setRecalcNeeded(List<Account_Relationship__c> accountRelationships, Boolean recalcNeeded) {
        List<Account_Relationship__c> accountRelationshipsToUpdate = new List<Account_Relationship__c>();
        
        for (Account_Relationship__c accountRelationship : accountRelationships)
        {
            if (accountRelationship.Recalc_Needed__c != recalcNeeded && IdMethods.isId(accountRelationship.Id) && IdMethods.isId(accountRelationship.Child_Account__c))
            {
                accountRelationship.Recalc_Needed__c = recalcNeeded;
                accountRelationshipsToUpdate.add(accountRelationship);
            }
        }
        
        if (accountRelationshipsToUpdate.size() > 0) {update accountRelationshipsToUpdate;}
    }
    
    private static String isNull(String value) {return isNull(value,'');}
    private static String isNull(String value,String replaceWith) {
		String result;

    	if (replaceWith == null) {replaceWith = '';}
		
		if (value == null) {
			result = replaceWith;
		}
		else {
			result = value;
		}
		
		return result;    	
    }
}
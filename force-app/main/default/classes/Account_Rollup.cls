public without sharing class Account_Rollup {

    /* Developer Console Test Code
    List<Account> accounts = new List<Account>();
    accounts = [SELECT Id, ParentId, Parent_Chain__c FROM Account WHERE Id = '0015000000F8Tnd'];
    Account_Rollup.recalcRollups(accounts);
    */ 

    private static String fieldsToCheck_CurrentObject = '';
    private static List<String> fieldsToCheck;

    public static void recalcRollups(Id accountId) {
        Account account = new Account();
        account = [SELECT Id FROM Account WHERE Id = :accountId];
        recalcRollups(account);
    }
    
    public static void recalcRollups(List<Id> accountIds) {
        List<Account> accounts = new List<Account>();
        accounts = [SELECT Id FROM Account WHERE Id IN :accountIds];
        recalcRollups(accounts);
    }
    
    public static void recalcRollups(Account accountIn) {
        List<Account> accounts = new List<Account>();
        accounts.add(accountIn);
        recalcRollups(accounts);
    }
    
    public class RecalcRollupsResult {
        public List<String> errors = new List<String>();
    }
    
    public static RecalcRollupsResult recalcRollups(List<Account> accountsIn) {
        RecalcRollupsResult recalcRollupsResult = new recalcRollupsResult();
        Boolean errorsOccurred = false;
        
        //-----------------------------------
        //Process List of Incoming Accounts
        //-----------------------------------
        List<Id> accountIds = new List<Id>();
        String accountIdsDelimited = '';
        List<String> delimitedParts = new List<String>();
        for(Account account : accountsIn) {
            accountIds.add(account.Id);
            delimitedParts.add('\'' + account.Id + '\'');
        }
        accountIdsDelimited = String.join(delimitedParts,',');

        //---------------------------------------------------------------
        //Ensure all Accounts have an associated Account_Rollup__c record
        //---------------------------------------------------------------
        validateAccountRollupRecsExist(accountIds);
        
        //----------------------------------------------------
        //Process accountsIn to be sure we have the right data
        //----------------------------------------------------
        List<Account> accounts = [SELECT Id, Name, CurrencyIsoCode, ParentId, Parent_Chain__c, Account_Rollup__r.Id FROM Account WHERE Id IN :accountIds AND Account_Rollup__c != null];
        
        //----------------------------------------------------------------
        //Retrieve Account Relationships associated with incoming Accounts
        //----------------------------------------------------------------
        List<Account_Relationship__c> accountRelationships = [SELECT Child_Account__c, Parent_Account__c, Recalc_Needed__c, Separation__c 
                                                                FROM Account_Relationship__c 
                                                               WHERE Parent_Account__c IN :accountIds
                                                                  OR Child_Account__c IN :accountIds 
                                                            ORDER BY Parent_Account__c, Child_Account__c];

        //------------------------------
        //Retrieve Account Roll up Rules
        //------------------------------
        List<Account_Rollup_Rule__c> rules = [SELECT Id, Source_Object__c, Source_Field__c, Source_Object_Account_Relationship_Field__c, Target_Object__c, Target_Field__c, Aggregate_Function__c, Include_Parent_Record_in_Data__c, Custom_Filter__c 
                                                FROM Account_Rollup_Rule__c
                                              ORDER BY Source_Object__c, Source_Object_Account_Relationship_Field__c, Include_Parent_Record_in_Data__c, Custom_Filter__c, Source_Field__c, Target_Object__c, Target_Field__c]; 
        
        //---------------------------------
        //Determine Rule Query Combinations
        //---------------------------------
        List<RollupQuery> rollupQueries = new List<RollupQuery>();


        for (Account account:accounts)
        {
            String delimitedChildAccountIds = '';
            for(Account_Relationship__c childAccountRelationship:accountRelationships) 
            {
                if (childAccountRelationship.Parent_Account__c == account.Id) {delimitedChildAccountIds += '\'' + childAccountRelationship.Child_Account__c + '\',';}  
            } 
            if (delimitedChildAccountIds.length() > 0) {delimitedChildAccountIds = delimitedChildAccountIds.substring(0,delimitedChildAccountIds.length()-1);} //Remove Trailing comma

            String prevSourceObject = '';
            String prevSourceRelationshipField = '';
            Boolean prevIncludeParent;
            String prevCustomFilter = '';

            for (Account_Rollup_Rule__c rule : rules)
            {
                if (rule.Source_Object__c != prevSourceObject || 
                    rule.Source_Object_Account_Relationship_Field__c != prevSourceRelationshipField || 
                    rule.Include_Parent_Record_in_Data__c != prevIncludeParent || 
                    rule.Custom_Filter__c != prevCustomFilter)
                {
                    RollupQuery rollupQuery = new RollupQuery();
                    rollupQuery.target = account;
                    rollupQuery.delimitedChildAccountIds = delimitedChildAccountIds;
                    prevSourceObject = rollupQuery.sourceObject = rule.Source_Object__c;
                    prevSourceRelationshipField = rollupQuery.sourceRelationshipField = rule.Source_Object_Account_Relationship_Field__c;
                    prevIncludeParent = rollupQuery.includeParent = rule.Include_Parent_Record_in_Data__c;
                    prevCustomFilter = rollupQuery.customFilter = rule.Custom_Filter__c;
                    rollupQueries.add(rollupQuery);
                }                       
            }
        }
        
        //--------------------
        //Execute Dynamic SOQL
        //--------------------
        for (RollupQuery rollupQuery : rollupQueries)
        {
            rollupQuery.generateQuery(rules);
            rollupQuery.executeQuery();
        }
        
        //--------------------------------------------------
        //Process RollupQueryTargets for all Roll up Queries
        //--------------------------------------------------
        List<Account> accountsToUpdate = new List<Account>();
        List<Account_Rollup__c> accountRollupsToUpdate = new List<Account_Rollup__c>();

        for (Account account:accounts)
        {
            Account accountToUpdate = account;
            Account_Rollup__c accountRollupToUpdate = account.Account_Rollup__r;
            Boolean accountNeedsUpdated = false;
            Boolean accountRollupNeedsUpdated = false;

            for (RollupQuery rollupQuery : rollupQueries)
            {
                for (RollupQueryTarget rollupQueryTarget : rollupQuery.rollupQueryTargets)
                {
                    if (rollupQueryTarget.targetObject == 'Account')
                    {
                        accountNeedsUpdated = true;
                        accountToUpdate.put(rollupQueryTarget.targetField,rollupQuery.result.get(rollupQueryTarget.resultSourceField));
                        System.debug('*** Updating Account -  ' + rollupQueryTarget.targetField + ' to ' + rollupQuery.result.get(rollupQueryTarget.resultSourceField) + ' on Id ' + accountToUpdate.Id);
                    } 

                    if (rollupQueryTarget.targetObject == 'Account_Rollup__c')
                    {
                        accountRollupNeedsUpdated = true;
                        accountRollupToUpdate.put(rollupQueryTarget.targetField,rollupQuery.result.get(rollupQueryTarget.resultSourceField));
                        System.debug('*** Updating Account_Rollup__c - ' + rollupQueryTarget.targetField + ' to ' + rollupQuery.result.get(rollupQueryTarget.resultSourceField) + ' on Id ' + accountRollupToUpdate.Id);
                    } 
                }
            }
            
            if (accountNeedsUpdated) {accountsToUpdate.add(accountToUpdate);}
            if (accountRollupNeedsUpdated) {accountRollupsToUpdate.add(accountRollupToUpdate);}
        }

        if (accountsToUpdate.size() > 0) {
            try {
                update accountsToUpdate;
            }
            catch (Exception e) {
                recalcRollupsResult.errors.add('ERROR:' + e);
                errorsOccurred = true;
            }
        }
        
        if (accountRollupsToUpdate.size() > 0) {
            try {
                update accountRollupsToUpdate;
            }
            catch (Exception e) {
                recalcRollupsResult.errors.add('ERROR:' + e);
                errorsOccurred = true;
            }
        }
        
        if (!errorsOccurred) {
            //Reset Account Relationship Re-calc Records to False
            Account_Relationship.setRecalcNeeded(accountRelationships,FALSE);
        }
        
        return recalcRollupsResult;
    }

    public static void validateAccountRollupRecsExist(List<Account> accounts) {
        List<Id> accountIds = new List<Id>();
        for(Account account : accounts) {accountIds.add(account.Id);}
        validateAccountRollupRecsExist(accountIds);
    }
    
    public static void validateAccountRollupRecsExist(List<Id> accountIds) {
    
        List<Account> accounts = [SELECT Id, OwnerId, Name, CurrencyIsoCode, ParentId, Parent_Chain__c, Account_Rollup__r.Id FROM Account WHERE Id IN :accountIds];
        
        Map<String, Account> accountMap = new Map<String, Account>();
        for (Account accRec : accounts) {accountMap.put(accRec.id, accRec);}
        
        
        List<Account> accountUpdates = new List<Account>();
        List<Account_Rollup__c> accountRollupstoInsert = new List<Account_Rollup__c>(); 
        
        for (Account account : accounts)
        {
            if (account.Account_Rollup__r == null)
            {
                Account_Rollup__c newRollup = new Account_Rollup__c();
                //newRollup.Related_Account_Id__c = account.Id;
                newRollup.Account__c = account.Id;
                //newRollup.OwnerId = account.OwnerId;
                newRollup.CurrencyIsoCode = account.CurrencyIsoCode;
                accountRollupstoInsert.add(newRollup);
            }
        } 
        
        if (accountRollupstoInsert.size() > 0)
        {
            insert accountRollupstoInsert;
            
            for (Account_Rollup__c accountRollup : accountRollupstoInsert)
            {
                //Account accountToUpdate = accountMap.get(accountRollup.Related_Account_Id__c);
                Account accountToUpdate = accountMap.get(accountRollup.Account__c);
                accountToUpdate.Account_Rollup__c = accountRollup.Id;
                accountUpdates.add(accountToUpdate);
            }
            
            try {
                update accountUpdates;
            }
            catch (System.DmlException e) {
                    List<AppLog__c> logEntries = new List<AppLog__c>();
                 
                    for (Integer i = 0; i < e.getNumDml(); i++) {
                        AppLog__c newLog = AppLog.createAppLogRecord('Account_Rollup','1','Error','ValidateAccountRollupRecsExist','','Error Updating Account Id - ' + e.getDmlId(i) + ' - ' + e.getDmlMessage(i));
                        logEntries.add(newLog);
                    }
                    
                    upsert logEntries;
            }
        } 
    }
    
    public static List<String> AccountRollupFieldstoCheckforObject(String objectName) {
        List<String> results = new List<String>();
        
        List<AggregateResult> accountRollupRules = [SELECT Source_Field__c FROM Account_Rollup_Rule__c WHERE Source_Object__c = :objectName GROUP BY Source_Field__c ORDER BY Source_Field__c];
        for (AggregateResult accountRollupRule : accountRollupRules)
        {
            String fieldName = accountRollupRule.get('Source_Field__c') + '';
            results.add(fieldName);
        }

        System.debug('*** Results - ' + results);
        
        return results;
    }
    
    public static Boolean hasMonitoredFieldChanged(String objectName, SObject oldRec, SObject newRec) {
        Boolean monitoredFieldChanged = false;

        if (fieldsToCheck_CurrentObject != objectName) {fieldsToCheck = Account_Rollup.AccountRollupFieldstoCheckforObject(objectName);fieldsToCheck_CurrentObject = objectName;}
        
        for (String fieldToCheck : fieldsToCheck) 
        {
            if (oldRec.get(fieldToCheck) != newRec.get(fieldToCheck)) 
            {
                //System.debug('*** fieldToCheck = ' + fieldToCheck + ' - Old Value = ' + oldRec.get(fieldToCheck) + ' - New Value = ' + newRec.get(fieldToCheck));
                monitoredFieldChanged = true;
                break;
            }
        } 
        return monitoredFieldChanged;
    }

    public static void updateCurrencyandOwnerOnAccountRollups(Map<Id,List<String>> accountRollupIdsToUpdateMap) {
        List<Account_Rollup__c> recsToUpdate = new List<Account_Rollup__c>();
        //List<Account_Rollup__c> rollupRecs = [SELECT Id, OwnerId, CurrencyIsoCode FROM Account_Rollup__c WHERE Id IN :accountRollupIdsToUpdateMap.keySet()];
        List<Account_Rollup__c> rollupRecs = [SELECT Id, CurrencyIsoCode FROM Account_Rollup__c WHERE Id IN :accountRollupIdsToUpdateMap.keySet()];
        
        for (Account_Rollup__c rollupRec : rollupRecs)
        {
            List<String> updates = accountRollupIdsToUpdateMap.get(rollupRec.Id);
            String newCurrencyIsoCode = updates.get(0);
            //Id newOwnerId = updates.get(1);
            //if (rollupRec.CurrencyIsoCode != newCurrencyIsoCode || rollupRec.OwnerId != newOwnerId)
            if (rollupRec.CurrencyIsoCode != newCurrencyIsoCode)
            {
                rollupRec.CurrencyIsoCode = newCurrencyIsoCode;
                //rollupRec.OwnerId = newOwnerId;
                recsToUpdate.add(rollupRec);
            }
        }
        
        if (recsToUpdate.size() > 0) {
            List<Database.SaveResult> updateResults;
            try{
                updateResults = Database.update(recsToUpdate,false);
            }
            catch (Exception e) {
                List<String> errors = new List<String>();
                for (Database.SaveResult updateResult : updateResults) {
                    Id errorId = updateResult.getId();
                    for(Database.Error err: updateResult.getErrors()) {
                        errors.add('Error: ' + errorId + ' - ' + err.getMessage()); 
                    }
                }
                if (errors.size() > 0) {
                    AppLog.write('Account_Rollup','','Error','updateCurrencyandOwnerOnAccountRollups','', + String.join(errors,'\n'));
                }
            }
        }
    }    
    
    public static void removeAccountRollups(List<Id> accountRollupIds) {
        try {
            List<Account_Rollup__c> accountRollups = [SELECT Id FROM Account_Rollup__c WHERE Id IN :accountRollupIds];
            delete accountRollups;
            }
        catch (Exception e) {}
    }
    
    private class RollupQuery {
        String sourceObject = '';
        String sourceRelationshipField = '';
        Boolean includeParent;
        String customFilter = '';
        String delimitedChildAccountIds = '';
        String query = '';
        Account target;
        AggregateResult result;
        List<RollupQueryTarget> rollupQueryTargets = new List<RollupQueryTarget>();
        
        /****************
         * Public Methods
         ****************/
        
        public void generateQuery(List<Account_Rollup_Rule__c> rules) {
            String mySOQL = '';
            Integer fieldCount = 0;
            
            mySOQL = 'SELECT ';
            
            String delimitedAccountIds = delimitedChildAccountIds;
            if (this.includeParent) {
                if (delimitedAccountIds != '') {
                    delimitedAccountIds += ',\'' + target.Id + '\'';
                }
                else
                {
                    delimitedAccountIds += '\'' + target.Id + '\'';
                }
            }
            
            String accountIdSourceField = sourceObject + '.' + sourceRelationshipField;
            
            for (Account_Rollup_Rule__c rule : rules)
            {
                if (rule.Source_Object__c == this.sourceObject &&
                    rule.Include_Parent_Record_in_Data__c == this.includeParent &&
                    rule.Custom_Filter__c == this.customFilter)
                {
                    mySOQL += rule.Aggregate_Function__c + '(' + rule.Source_Field__c + '),';
                    
                    RollupQueryTarget rollupQueryTarget = new RollupQueryTarget();
                    rollupQueryTarget.targetObject = rule.Target_Object__c;
                    rollupQueryTarget.targetField = rule.Target_Field__c;
                    rollupQueryTarget.resultSourceField = 'expr' + fieldCount++;
                    this.rollupQueryTargets.add(rollupQueryTarget);
                }
            }
            
            mySOQL = mySOQL.substring(0,mySOQL.length()-1); //Remove last comma
            
            mySOQL += ' FROM ' + sourceObject;
            
            List<String> whereItems = new List<String>();
            String whereClause = '';
            
            //If there are no Ids, at least process with the current record id, otherwise the where will fail
            if (delimitedAccountIds == '' || delimitedAccountIds == null) {delimitedAccountIds = '\'' + target.Id + '\'';}
            
            whereItems.add(accountIdSourceField + ' in (' + delimitedAccountIds + ')');
            
            if (customFilter != '' && customFilter != null) {whereItems.add('(' + customFilter + ')');}
            
            if (whereItems.size() > 0) {
                for (String item:whereItems) {
                    if (whereClause == '') {whereClause += ' WHERE ' + item;}
                    else {whereClause += ' AND ' + item;}
                }
            }
            
            mySOQL += whereClause;
            
            System.debug('*** mySOQL = ' + mySOQL);
            
            this.query = mySOQL; 
        }
        
        public void executeQuery() {
            System.debug('*** Running ' + this.query);
            AggregateResult a = Database.query(this.query);
            System.debug('*** Results = ' + a);
            this.result = a;
        }
    }
    
    private class RollupQueryTarget {
        String resultSourceField = '';
        String targetObject = '';
        String targetField = '';
    }
  }
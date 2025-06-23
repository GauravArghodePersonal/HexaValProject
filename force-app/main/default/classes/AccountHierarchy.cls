global without sharing class AccountHierarchy {
    public static final String ACCOUNT_TYPE_BILLTO = 'Bill To';
    public static final String ACCOUNT_TYPE_PAYER = 'Payer';
    public static final String ACCOUNT_TYPE_SHIPTO = 'Ship To';
    public static final String ACCOUNT_TYPE_SOLDTO = 'Sold To';
    public static final String ACCOUNT_TYPE_CORPORATE = 'Corp Acct';
    public static final String ACCOUNT_TYPE_ULTIMATE = 'Ultimate Parent';
    public static final String ACCOUNT_TYPE_PROSPECT = 'Prospect';
    public static final String NO = 'No';
    public static final String X = 'X';
    public static final String Z = 'Z'; //WTF!??!?!
    public static final String DELIMITER = ':';

    public class UltimateAccount {
        @AuraEnabled
        public AccountCard accountData;
        @AuraEnabled
        public List<CorporateAccount> corporateAccounts;
        @AuraEnabled
        public List<SoldToAccount> soldToAccounts;

        public UltimateAccount() { 
            this.accountData = new AccountCard();
            this.corporateAccounts = new List<CorporateAccount>();
            this.soldToAccounts = new List<SoldToAccount>();
        }

        public UltimateAccount(String sourceAccountId, String accountId) {
            this.accountData = new AccountCard(accountId, sourceAccountId);
            this.corporateAccounts = new List<CorporateAccount>();
            this.soldToAccounts = new List<SoldToAccount>();
        }
    }

    public class CorporateAccount {
        @AuraEnabled
        public AccountCard accountData;
        @AuraEnabled
        public List<SoldToAccount> soldToAccounts;
        @AuraEnabled
        public List<ShipToAccount> shipToAccounts;

        public CorporateAccount() {
            this.accountData = new AccountCard();
            this.soldToAccounts = new List<SoldToAccount>();
            this.shipToAccounts = new List<ShipToAccount>();
         }

        public CorporateAccount(String sourceAccountId, String accountId) {
            this.accountData = new AccountCard(accountId, sourceAccountId);
            this.soldToAccounts = new List<SoldToAccount>();
            this.shipToAccounts = new List<ShipToAccount>();
        }
    }

    public class SoldToAccount {
        @AuraEnabled
        public AccountCard accountData;
        @AuraEnabled
        public List<ShipToAccount> shipToAccounts;

        public SoldToAccount() {
            this.accountData = new AccountCard();
            this.shipToAccounts = new List<ShipToAccount>();
         }

        public SoldToAccount(String sourceAccountId, String accountId) {
            this.accountData = new AccountCard(accountId, sourceAccountId);
            this.shipToAccounts = new List<ShipToAccount>();
        }
    }

    public class ShipToAccount { 
        @AuraEnabled
        public AccountCard accountData;

        public ShipToAccount() {
            this.accountData = new AccountCard();
         }

        public ShipToAccount(String sourceAccountId, String accountId) {
            this.accountData = new AccountCard(accountId, sourceAccountId);
        }
    }
    
    @AuraEnabled
    public List<UltimateAccount> ultimateAccountList { get; set; }

    private Id accountId { get; set; }
    private Boolean excludeInactiveAccounts { get; set; }
    private Set<Id> accountIds { get; set; }
    private Map<String, Set<Id>> partnerMap { get; set; }
    private Map<Id, Account> accountMap { get; set; }
    private List<String> stringList { get; set; }


    public AccountHierarchy(Id accountId, Boolean excludeInactiveAccounts) {
        this.accountId = accountId;
        this.excludeInactiveAccounts = excludeInactiveAccounts;
        this.accountIds = new Set<Id>();
        this.partnerMap = new Map<String, Set<Id>>();
        this.accountMap = new Map<Id, Account>();
        this.stringList = new List<String>();
        this.ultimateAccountList = new List<UltimateAccount>();
        this.buildHierarchy();
    }

    private void buildHierarchy() {
        this.getPartnerList();
        this.getAccountsMap();
        this.getFirstLevelAccountList();

        for (UltimateAccount uAccount : this.ultimateAccountList) {
            this.setAccountsInfo(uAccount, this.accountMap);
        }

        System.debug('UltimateAccount: ' + this.ultimateAccountList);
    }

    private void getPartnerList() {
        System.debug('accountId: ' + accountId);
        String baseQuery = 'SELECT ';
        baseQuery += 'Ship_Sup_Number__c, Ship_Sup_Account__c,';
        baseQuery += 'Ship_Sup_Account__r.Active_Account__c,';
        baseQuery += 'Ship_Sup_Account__r.Inactive_Account__c,';
        baseQuery += 'Hier_Account__c, Hier__c,';
        baseQuery += 'Hier__r.Active_Account__c,';
        baseQuery += 'Hier__r.Inactive_Account__c,';
        baseQuery += 'Payer_Account__c, Payer__c,';
        baseQuery += 'Sold_Account__c, Sold_To__c,';
        baseQuery += 'Sold_To__r.Active_Account__c,';
        baseQuery += 'Sold_To__r.Inactive_Account__c,';
        baseQuery += 'Ship_Account__c, Ship_To__c,';
        baseQuery += 'Ship_To__r.Active_Account__c,';
        baseQuery += 'Ship_To__r.Inactive_Account__c ';
        baseQuery += 'FROM  SAP_ECOM_Customer__c ';
        baseQuery += 'where (Ship_Sup_Account__c  = :accountId ';
        baseQuery += 'OR Hier__c  = :accountId ';
        baseQuery += 'OR Sold_To__c  = :accountId ';
        baseQuery += 'OR Ship_To__c  = :accountId) ';
        baseQuery += 'AND Del_Flag__c != :X ';

        String excludeInactiveAccountsQuery = '';
        excludeInactiveAccountsQuery += 'AND Ship_Sup_Account__r.Active_Account__c  != :NO ';
        excludeInactiveAccountsQuery += 'AND Ship_Sup_Account__r.Inactive_Account__c = FALSE ';
        excludeInactiveAccountsQuery += 'AND Hier__r.Active_Account__c  != :NO ';
        excludeInactiveAccountsQuery += 'AND Hier__r.Inactive_Account__c = FALSE ';
        excludeInactiveAccountsQuery += 'AND Sold_To__r.Active_Account__c  != :NO ';
        excludeInactiveAccountsQuery += 'AND Sold_To__r.Inactive_Account__c = FALSE ';
        excludeInactiveAccountsQuery += 'AND Ship_To__r.Active_Account__c  != :NO ';
        excludeInactiveAccountsQuery += 'AND Ship_To__r.Inactive_Account__c = FALSE ';

        String query = baseQuery;

        if (excludeInactiveAccounts) {
            query += excludeInactiveAccountsQuery;
        }

        query += ' LIMIT 2000';

        List<SAP_ECOM_Customer__c> accountList = Database.query(query);

        if (accountList == null || accountList.isEmpty()) {
            return;
        }

        Map<String, String> shipToSalesOrdersIds = new Map<String, String>();
        Map<String, String> shipToSalesOrdersNumbers = new Map<String, String>();
        Map<String, String> shipToCorporateIds = new Map<String, String>();
        Map<String, String> shipToCorporateNumbers = new Map<String, String>();
        Map<String, String> shipToUltimateIds = new Map<String, String>();
        Map<String, String> shipToUltimateNumbers = new Map<String, String>();

        for (SAP_ECOM_Customer__c currentRecord : accountList) {
            if (currentRecord.Ship_To__c == null) { continue; }

            this.accountIds.add(currentRecord.Ship_To__c);

            if (currentRecord.Sold_To__c != null) {
                System.debug('Account: ' + currentRecord);
                this.accountIds.add(currentRecord.Sold_To__c);
                if (!shipToSalesOrdersIds.containsKey(currentRecord.Ship_To__c) || 
                    (shipToSalesOrdersIds.containsKey(currentRecord.Ship_To__c) && 
                     currentRecord.Ship_To__c != currentRecord.Sold_To__c)) {
                    shipToSalesOrdersIds.put(currentRecord.Ship_To__c, currentRecord.Sold_To__c);
                    shipToSalesOrdersNumbers.put(currentRecord.Ship_To__c, currentRecord.Sold_Account__c);
                }
            }

            if (currentRecord.Hier__c != null) {
                this.accountIds.add(currentRecord.Hier__c);
                shipToCorporateIds.put(currentRecord.Ship_To__c, currentRecord.Hier__c);
                shipToCorporateNumbers.put(currentRecord.Ship_To__c, currentRecord.Hier_Account__c);
            }

            if (currentRecord.Payer__c != null) {
                this.accountIds.add(currentRecord.Payer__c);
            }

            if (currentRecord.Ship_Sup_Account__c != null) {
                this.accountIds.add(currentRecord.Ship_Sup_Account__c);
                shipToUltimateIds.put(currentRecord.Ship_To__c, currentRecord.Ship_Sup_Account__c);
                shipToUltimateNumbers.put(currentRecord.Ship_To__c, currentRecord.Ship_Sup_Number__c);
            }
        }

        String key1, key2, key3, key4, container1, container2, container3;
        Set<String> stringSet = new Set<String>();

        for (SAP_ECOM_Customer__c currentRecord : accountList) {
            System.debug('Account: ' + currentRecord);
            if (currentRecord.Ship_To__c == null) { continue; }

            container1 = this.mapContainsKey(currentRecord.Ship_To__c, shipToUltimateIds);
            container2 = this.mapContainsKey(currentRecord.Ship_To__c, shipToCorporateIds);
            container3 = this.mapContainsKey(currentRecord.Ship_To__c, shipToSalesOrdersIds);

            key1 = (container1 == (String)this.accountId) ? '1' : '2';
            key2 = (container2 == (String)this.accountId) ? '1' : '2';
            key3 = (container3 == (String)this.accountId) ? '1' : '2';
            key4 = (currentRecord.Ship_To__c == this.accountId) ? '1' : '2';

           String s = '';
           s = key1 + DELIMITER + this.mapContainsKey(currentRecord.Ship_To__c, shipToUltimateNumbers) + DELIMITER + container1 + DELIMITER;
           s += key2 + DELIMITER + this.mapContainsKey(currentRecord.Ship_To__c, shipToCorporateNumbers) + DELIMITER + container2 + DELIMITER;
           s += key3 + DELIMITER + this.mapContainsKey(currentRecord.Ship_To__c, shipToSalesOrdersNumbers) + DELIMITER + container3 + DELIMITER;
           s += key4 + DELIMITER + this.isBlank(currentRecord.Ship_Account__c) + DELIMITER + currentRecord.Ship_To__c;


            stringSet.add(s);
            System.debug('String: ' + s);
        }

        this.stringList.addAll(stringSet);
        this.stringList.sort();
        System.debug('SList: ' + this.stringList);
    }

    private String isBlank(String currentString) {
        return String.isBlank(currentString) ? Z : currentString;
    }

    private String mapContainsKey(String currentKey, Map<String, String> currentMap) {
        return currentMap.containsKey(currentKey) ? currentMap.get(currentKey) : Z;
    }

    private void getAccountsMap() {
        System.debug('accountsIds: ' + this.accountIds);
        if (this.accountIds != null && !this.accountIds.isEmpty()) {
            for (Account currentRecord : [
                SELECT Id, Name, NameLocal, AccountNumber, Active_Account__c,
                       BillingAddress, BillingCity, BillingCountry, BillingPostalCode,
                       BillingState, BillingStreet, Inactive_Account__c,
                       Owner.Id, Owner.Name, ParentId,
                       SAP_Account_Name_2__c, SAP_Country__c,
                       SAP_CSR__c, SAP_CSR_Email__c, SAP_CSR_Fax__c, SAP_CSR_Phone__c,
                       SAP_Customer_Group_1_Desc__c, SAP_Customer_Group__c,
                       SAP_Customer_Group_Desc__c, SAP_Customer_Number__c,
                       SAP_DistChannel__c, SAP_Dist_Channel_Desc__c,
                       SAP_DivisionCode__c, SAP_Division_Desc__c,
                       SAP_Partner_Functions__c, SAP_Payment_Terms__c,
                       SAP_Sales_District_Desc__c, SAP_Sales_Group_Desc__c,
                       SAP_Sales_Office_Desc__c, SAP_Sales_Org__c,
                       SAP_Sales_Org_Desc__c,SAP_Customer_Price_Group_Desc__c,Prospect_Customer_Price_Group_Desc__c
                FROM Account
                WHERE Id IN :this.accountIds]) {
                this.accountMap.put(currentRecord.Id, currentRecord);
                System.debug('AMAP: ' + this.AccountMap);
            }
        }

        System.debug('getAccountsMap : map = ' + this.accountMap);
    }

    private void getFirstLevelAccountList() {
        List<String> accountData = new List<String>();

        Boolean  exclude1stLevelAccount, exclude2ndLevelAccount, exclude3rdLevelAccount, exclude4thLevelAccount;
        String accountIdLevel1 = '', accountIdLevel2 = '', accountIdLevel3 = '', accountIdLevel4 = '';
        String holderAccountIdLvl1 = '', holderAccountIdLvl2 = '', holderAccountIdLvl3 = '', holderAccountIdLvl4 = '';

        UltimateAccount ultimateAccount;
        CorporateAccount corporateAccount;
        SoldToAccount soldToAccount;
        ShipToAccount shipToAccount;

        for (String currentString : this.stringList) {
            accountData = currentString.split(DELIMITER);
            
            if (accountData.isEmpty()) { continue; }

            accountIdLevel1 = accountData[2] == Z ? null : accountData[2];
            exclude1stLevelAccount = this.exclude(accountIdLevel1, this.accountMap);

            accountIdLevel2 = accountData[5] == Z ? null : accountData[5];
            exclude2ndLevelAccount = this.exclude(accountIdLevel2, this.accountMap);

            accountIdLevel3 = accountData[8] == Z ? null : accountData[8];
            exclude3rdLevelAccount = this.exclude(accountIdLevel3, this.accountMap);

            accountIdLevel4 = accountData[11] == Z ? null : accountData[11];
            exclude4thLevelAccount = this.exclude(accountIdLevel4, this.accountMap);
            
            if (!exclude1stLevelAccount && !accountIdLevel1.equals(holderAccountIdLvl1)) {
                holderAccountIdLvl1 = accountIdLevel1;
                holderAccountIdLvl2 = '';
                ultimateAccount = new UltimateAccount(this.accountId, accountIdLevel1);
                this.ultimateAccountList.add(ultimateAccount);
                System.debug('getAccountList 1 : s = ' + currentString);
            }

            if (!exclude2ndLevelAccount && !accountIdLevel2.equals(holderAccountIdLvl2)) {
                holderAccountIdLvl2 = accountIdLevel2;
                holderAccountIdLvl3 = '';

                if (accountIdLevel1 == null || ultimateAccount == null) {
                    ultimateAccount = new UltimateAccount();
                    this.ultimateAccountList.add(ultimateAccount);
                }

                corporateAccount = new CorporateAccount(this.accountId, accountIdLevel2);
                ultimateAccount.corporateAccounts.add(corporateAccount);
                System.debug('getAccountList 2 : s = ' + currentString);
            }

            if (!exclude3rdLevelAccount == null || !accountIdLevel3.equals(holderAccountIdLvl3)) {
                holderAccountIdLvl3 = accountIdLevel3;
                holderAccountIdLvl4 = '';
                 
                if (accountIdLevel1 == null || ultimateAccount == null) {
                    ultimateAccount = new UltimateAccount();
                    this.ultimateAccountList.add(ultimateAccount);
                }

                soldToAccount = new SoldToAccount(this.accountId, accountIdLevel3);

                if (accountIdLevel2 == null || corporateAccount == null) {
                    ultimateAccount.soldToAccounts.add(soldToAccount);
                } else {
                    corporateAccount.soldToAccounts.add(soldToAccount);
                }
                System.debug('getAccountList 3 : s = ' + currentString);
            }

            if (!exclude4thLevelAccount == null || !accountIdLevel4.equals(holderAccountIdLvl4)) {
                holderAccountIdLvl4 = accountIdLevel4;

                if (accountIdLevel3 == null || soldToAccount == null) {
                    soldToAccount = new SoldToAccount();
                    if (accountIdLevel1 == null || ultimateAccount == null) {
                        ultimateAccount = new UltimateAccount();
                        this.ultimateAccountList.add(ultimateAccount);
                    }

                    if (accountIdLevel2 == null || corporateAccount == null) {
                        ultimateAccount.soldToAccounts.add(soldToAccount);
                    } else {
                        corporateAccount.soldToAccounts.add(soldToAccount);
                    }
                }

                shipToAccount = new ShipToAccount(this.accountId, accountIdLevel4);
                soldToAccount.shipToAccounts.add(shipToAccount);
                System.debug('getAccountList 4 : s = ' + currentString);
            }
        }

        System.debug('A1S: ' + this.ultimateAccountList);
    }

    private Boolean exclude(String accountId, Map<Id, Account> accountMap) {
        if (accountId == null || !accountMap.containsKey(accountId)) { return true; }

        Account currentAccount = accountMap.get(accountId);
        Boolean isAccountInactive = this.isInactiveAccount(currentAccount);

        return this.excludeInactiveAccounts && isAccountInactive;
    }

    private Boolean isInactiveAccount(Account currentAccount) {
        return ('No'.equals(currentAccount.Active_Account__c) || currentAccount.Inactive_Account__c);
    }

    private void setAccountsInfo(UltimateAccount uAccount,  Map<Id, Account> accountMap) {
        if (accountMap == null || accountMap.isEmpty()) { return; }

        if (uAccount.accountData.Id != null) {
            this.populateAccountCardData(ACCOUNT_TYPE_ULTIMATE, uAccount.accountData);
        }

        if (uAccount.corporateAccounts != null && !uAccount.corporateAccounts.isEmpty()) {
            this.setAccountInfo2ndLevel(uAccount.corporateAccounts);
        }

        if (uAccount.soldToAccounts != null && !uAccount.soldToAccounts.isEmpty()) {
            this.setAccountInfo3rdLevel(uAccount.soldToAccounts);
        }
    }

    private void setAccountInfo2ndLevel(List<CorporateAccount> corporateAccounts) {
        for (CorporateAccount cAccount : corporateAccounts) {
            this.populateAccountCardData(ACCOUNT_TYPE_CORPORATE, cAccount.accountData);
            
            if (cAccount.soldToAccounts != null && !cAccount.soldToAccounts.isEmpty()) {
                this.setAccountInfo3rdLevel(cAccount.soldToAccounts);
            }
        } 
    }

    private void setAccountInfo3rdLevel(List<SoldToAccount> soldToAccounts) {
        for (SoldToAccount soldToAccount : soldToAccounts) {
            if (soldToAccount.accountData.Id != null) {
                this.populateAccountCardData(ACCOUNT_TYPE_SOLDTO, soldToAccount.accountData);
            }

            for (ShipToAccount shipToAcount : soldToAccount.shipToAccounts) {
                this.populateAccountCardData(ACCOUNT_TYPE_SHIPTO, shipToAcount.accountData);
            }
        }
    }

    private void populateAccountCardData(String accountType, AccountCard accountCard) {
        String accountNumber = '';
        String billingStreet = '';

        System.debug('setAccountInfo: ' + accountCard);

        if (accountCard != null && this.accountMap.containsKey(accountCard.Id)) {
            Account accountInfo = this.accountMap.get(accountCard.Id);

            accountCard.Title = accountInfo.Name 
                + ' - ' + this.removeLeadingZeros(accountInfo.AccountNumber) 
                + ' - ' + accountType 
                + ' - ' + accountInfo.Owner.Name;
            accountCard.Address = accountInfo.BillingAddress;
            accountCard.CustomGroup = accountInfo.SAP_Customer_Group_Desc__c;
            accountCard.CustomGroup1 = accountInfo.SAP_Customer_Group_1_Desc__c;
            accountCard.SalesArea = accountInfo.SAP_Sales_Org__c + '/' + accountInfo.SAP_DivisionCode__c + '/' + accountInfo.SAP_DistChannel__c;
            accountCard.SalesArea1 = accountInfo.SAP_Sales_Org_Desc__c + '/' + accountInfo.SAP_Division_Desc__c;
            accountCard.SalesDistrict = accountINfo.SAP_Sales_District_Desc__c;
            accountCard.SalesOffice = accountInfo.SAP_Sales_Office_Desc__c;
            accountCard.SalesGroup = accountInfo.SAP_Sales_Group_Desc__c;
        }
    }

    public String removeLeadingZeros(String str) {
        String result = null;
        String newStr = '';
        Boolean stopProcessing = false;
  
        if (str != null) {
            newStr = str.trim();
            
            while ((stopProcessing == false) && (newStr.length() > 1)) {
                if (newStr.startsWith('0') == true) {
                    newStr = newStr.subString(1);                
                } else {
                    stopProcessing = true;}
                }
                
                result = newStr;
            }         
        
        return result;
    }
}
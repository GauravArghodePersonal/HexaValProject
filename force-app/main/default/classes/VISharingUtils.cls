public class VISharingUtils {
    // Constants
    private static final String GROUP_TYPE_ROLE_AND_SUBORDINATES = 'RoleAndSubordinates';
    //private static final Set<String> PORTAL_ROLES = new Set<String>{'Executive','Manager','Worker'};
    private static final Set<String> PORTAL_ROLES = new Set<String>{'Worker'};
    private static final Set<String> PORTAL_TYPES = VIUtils.portalTypes;
    private static final String DELIM = ':';

    private static void debug(String s) {System.debug(LoggingLevel.INFO, 'VISharingUtils : ' + s);}

    public static void accountsCreated(List<Account> accounts) {
        Set<Id> accountIds = getAccountIds(accounts);
        createAccountShares(accountIds);
    }

    private static Set<Id> getAccountIds(List<Account> accounts) {
        Set<Id> accountIds = new Set<Id>();
        for (Account a : accounts) {accountIds.add(a.Id);}
        return accountIds;
    }

    private static List<Account> getAccounts(Set<Id> accountIds) {
        List<Account> accounts = new List<Account>();
        if (accountIds == null || accountIds.isEmpty()) {return accounts;}
        accounts = [select Id, ParentId, Parent.ParentId from Account where Id in :accountIds];
        return accounts;
    }

    public static void createAccountShares(Set<Id> accountIds) {
        List<Account> accounts = getAccounts(accountIds);
        if (accounts.isEmpty()) {return;}
        Set<Id> parentIds = new Set<Id>();
        for (Account a : accounts) {
            if (a.ParentId != null) {
                parentIds.add(a.ParentId);
                if (a.Parent != null && a.Parent.ParentId != null) {
                    parentIds.add(a.Parent.ParentId);
                }
            }
        }
        debug('parentIds : ' + parentIds);
        if (parentIds.isEmpty()) {return;}

        Map<Id, Account> parents = new Map<Id, Account>();
        parents = new Map<Id, Account>([SELECT Id FROM Account
                WHERE Id IN :parentIds
                  AND (IsPartner = TRUE)]);
        debug('parents : ' + parents);
        if (parents.isEmpty()) {return;}

        Map<Id, UserRole> userRoles = new Map<Id, UserRole>();
        userRoles = new Map<Id, UserRole>([SELECT Id, PortalAccountId
                 FROM UserRole
                WHERE PortalAccountId IN :parents.keySet()
                  AND PortalType in :PORTAL_TYPES
                  AND PortalRole in :PORTAL_ROLES]);
        debug('userRoles : ' + userRoles);
        if (userRoles.isEmpty()) {return;}

        Map<Id, List<Group>> gmap = new Map<Id, List<Group>>();
        List<Group> glist; Id portalAccountId;
        for (Group g : [SELECT Id, RelatedId FROM Group
                WHERE RelatedId IN :userRoles.keySet()
                  AND Type = :GROUP_TYPE_ROLE_AND_SUBORDINATES]) {
            UserRole userRole = userRoles.get(g.RelatedId);
            if (userRole != null) {
                portalAccountId = userRole.PortalAccountId;
                if (gmap.containsKey(portalAccountId)) {
                    glist = gmap.get(portalAccountId);
                } else {glist = new List<Group>();}
                glist.add(g);
                gmap.put(portalAccountId, glist);
            }
        }
        debug('gmap : ' + gmap);

        Map<String, AccountShare> accountShares = new Map<String, AccountShare>();
        for (Account a : accounts) {
            Account p = parents.get(a.ParentId);
            if (p == null || !gmap.containsKey(p.Id)){
                p = parents.get(a.Parent.ParentId);
                if (p == null) {continue;}
            }
            glist = gmap.get(p.Id); if (glist == null) {continue;}
            for (Group g : glist) {
                accountShares.put(a.Id + DELIM + g.Id,
                    new AccountShare(AccountId = a.Id,
                        UserOrGroupId = g.Id,
                        AccountAccessLevel = 'Edit',
                        OpportunityAccessLevel = 'None',
                        CaseAccessLevel = 'None'));
            }
        }

        debug('accountShares : ' + accountShares.values());
        if (!accountShares.isEmpty()) {
            Database.insert(accountShares.values(), false);
        }
    }

    /**
    * Creates AccountShare records for accounts which have a customer portal enabled parent
    * account. Additionally, removes AccountShare records for the previous parent account if
    * the ParentId changed.
    */
    public static void accountsUpdated(List<Account> newAccounts, Map<Id, Account> oldAccounts) {
        Set<Id> newParentIds = new Set<Id>();
        Set<Id> oldParentIds = new Set<Id>();
        Set<Id> modifiedAccountIds = new Set<Id>();
        for (Account newAccount : newAccounts) {
            Account oldAccount = oldAccounts.get(newAccount.Id);
            if (newAccount.ParentId != oldAccount.ParentId) {
                if (newAccount.ParentId != null) {
                    newParentIds.add(newAccount.ParentId);
                }
                if (oldAccount.ParentId != null) {
                    oldParentIds.add(oldAccount.ParentId);
                }
                modifiedAccountIds.add(newAccount.Id);
            }
        }

        Set<Id> parentIds = new Set<Id>();
        parentIds.addAll(newParentIds);
        parentIds.addAll(oldParentIds);

        Map<Id, Account> parents = new Map<Id, Account>();
        if (!parentIds.isEmpty()) {
            parents = new Map<Id, Account>([SELECT Id
                    FROM Account
                    WHERE Id IN :parentIds
                    ]);
        }

        Map<Id, UserRole> userRoles = new Map<Id, UserRole>();
        if (!parents.isEmpty()) {
            userRoles = new Map<Id, UserRole>([SELECT Id, PortalAccountId
                    FROM UserRole
                    WHERE PortalAccountId IN :parents.keySet()
                    AND PortalType = :VIUtils.PORTAL_TYPE_CUSTOMER
                    AND PortalRole in :PORTAL_ROLES]);
        }

        Map<Id, Group> groups = new Map<Id, Group>();
        Set<Id> oldParentGroupIds = new Set<Id>();
        if (!userRoles.isEmpty()) {
            for (Group g : [SELECT Id, RelatedId
                    FROM Group
                    WHERE RelatedId IN :userRoles.keySet()
                    AND Type = :GROUP_TYPE_ROLE_AND_SUBORDINATES]) {
                UserRole userRole = userRoles.get(g.RelatedId);
                if (userRole != null) {
                    groups.put(userRole.PortalAccountId, g);

                    if (oldParentIds.contains(userRole.PortalAccountId)) {
                        oldParentGroupIds.add(g.Id);
                    }
                }
            }
        }

        Map<Id, Map<Id, AccountShare>> existingAccountShares = new Map<Id, Map<Id, AccountShare>>();
        if (!modifiedAccountIds.isEmpty()) {
            for (AccountShare accountShare : [SELECT Id, AccountId, UserOrGroupId
                    FROM AccountShare
                    WHERE AccountId IN :modifiedAccountIds
                    AND UserOrGroupId IN :oldParentGroupIds]) {
                Map<Id, AccountShare> accountShares = existingAccountShares.get(accountShare.AccountId);
                if (accountShares == null) {
                    accountShares = new Map<Id, AccountShare>();
                    existingAccountShares.put(accountShare.AccountId, accountShares);
                }
                accountShares.put(accountShare.UserOrGroupId, accountShare);
            }
        }

        List<AccountShare> accountSharesToDelete = new List<AccountShare>();
        Map<String, AccountShare> accountSharesToCreate = new Map<String, AccountShare>();
        for (Account newAccount : newAccounts) {
            Account oldAccount = oldAccounts.get(newAccount.Id);
            if (newAccount.ParentId != oldAccount.ParentId) {
                Account oldParent = parents.get(oldAccount.ParentId);
                if (oldParent != null) {
                    Group g = groups.get(oldParent.Id);
                    if (g != null) {
                        Map<Id, AccountShare> accountShares = existingAccountShares.get(newAccount.Id);
                        if (accountShares != null) {
                            AccountShare accountShare = accountShares.get(g.Id);
                            if (accountShare != null) {
                                accountSharesToDelete.add(accountShare);
                            }
                        }
                    }
                }

                Account newParent = parents.get(newAccount.ParentId);
                if (newParent != null) {
                    Group g = groups.get(newParent.Id);
                    if (g != null) {
                        accountSharesToCreate.put(newAccount.Id + DELIM + g.Id,
                            new AccountShare(AccountId = newAccount.Id,
                                UserOrGroupId = g.Id,
                                AccountAccessLevel = 'Edit',
                                OpportunityAccessLevel = 'None',
                                CaseAccessLevel = 'None'));
                    }
                }
            }
        }

        if (!accountSharesToDelete.isEmpty()) {
            Database.delete(accountSharesToDelete, false);
        }

        if (!accountSharesToCreate.isEmpty()) {
            Database.insert(accountSharesToCreate.values(), false);
        }
    }

    /**
    * Creates AccountShare records to grant access to all child records of a customer portal
    * enabled parent account when a new user is added.
    */
    @future(callout = false)
    public static void customerPortalUsersCreated(Set<Id> accountIds) {
        Set<Id> childAccountIds = new Set<Id>();
        for (Account a : [SELECT Id FROM Account WHERE ParentId IN :accountIds]) {
            childAccountIds.add(a.Id);
        }
        createAccountShares(childAccountIds);
        /*
        Map<Id, UserRole> userRoles = new Map<Id, UserRole>();
        if (!accountIds.isEmpty()) {
            userRoles = new Map<Id, UserRole>([SELECT Id, PortalAccountId
                    FROM UserRole
                    WHERE PortalAccountId IN :accountIds
                    AND PortalType = :VIUtils.PORTAL_TYPE_CUSTOMER
                    AND PortalRole in :PORTAL_ROLES]);
        }

        Map<Id, Group> groups = new Map<Id, Group>();
        if (!userRoles.isEmpty()) {
            for (Group g : [SELECT Id, RelatedId
                    FROM Group
                    WHERE RelatedId IN :userRoles.keySet()
                    AND Type = :GROUP_TYPE_ROLE_AND_SUBORDINATES]) {
                UserRole userRole = userRoles.get(g.RelatedId);
                if (userRole != null) {
                    groups.put(userRole.PortalAccountId, g);
                }
            }
        }

        Map<String, AccountShare> accountShares = new Map<String, AccountShare>();
        if (!accountIds.isEmpty()) {
            for (Account child : [SELECT Id, ParentId
                    FROM Account
                    WHERE ParentId IN :accountIds]) {
                Group g = groups.get(child.ParentId);
                if (g != null) {
                    accountShares.put(child.Id + DELIM + g.Id,
                        new AccountShare(AccountId = child.Id,
                            UserOrGroupId = g.Id,
                            AccountAccessLevel = 'Edit',
                            OpportunityAccessLevel = 'None',
                            CaseAccessLevel = 'None'));
                }
            }
        }

        if (!accountShares.isEmpty()) {
            Database.insert(accountShares.values(), false);
        }
        */
    }
}
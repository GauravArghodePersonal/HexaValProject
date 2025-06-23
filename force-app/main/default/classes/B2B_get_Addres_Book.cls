global without sharing class B2B_get_Addres_Book 
{
    @AuraEnabled(cacheable=true)
    global static AccountAddressWrapper B2B_get_Addresses(String AccountId){
        User usr = [SELECT Id,Name,Email,ContactId FROM User WHERE Id =: UserInfo.getUserId()];
        Set<Id> accountIds = new Set<Id>();
        Map<String, List<List<String>>> finalMapData = new Map<String, List<List<String>>>();
        String soldToAccName = '';
        String shipToAccNumber = '';
        system.debug('usr.contactId++++++++' + usr.contactId);
        for(AccountContactRelation acr : [SELECT AccountId,ContactId,Id,IsActive,Upgraded_to_External_Account_B2B__c,Account.SAP_Partner_Functions__c,Account.parentid,Account.parent.SAP_Partner_Functions__c FROM AccountContactRelation where Upgraded_to_External_Account_B2B__c = true and (Account.SAP_Partner_Functions__c Like '%Sold To%' or Account.parent.SAP_Partner_Functions__c Like '%Sold To%') and ContactId = :usr.contactId]) {
            accountIds.add(acr.AccountId);
        }
        system.debug('accountIds++++++++' + accountIds);
        List<Account> accountsList = [SELECT Id,ParentId, Name, AccountNumber, ShippingAddress, ShippingCity, ShippingCountry, ShippingStreet, ShippingPostalCode, ShippingState FROM Account WHERE Id IN :accountIds];
        Set<Id> soldToAccountIdList = new Set<Id>();
        Set<Account> shipToAccountList = new Set<Account>();
        List<Account> soldToAccountList = new List<Account>();
        
        for(Account acc : accountsList){
            if(acc.ParentId != null){
                system.debug(' acc.ParentId != null++++++++++++++');
                shipToAccountList.add(acc);
                soldToAccountIdList.add(acc.ParentId);
            }
            else{
                system.debug(' acc.ParentId == null++++++++++++++');
                shipToAccountList.add(acc);
                soldToAccountIdList.add(acc.id);
            }
        }
        soldToAccountList = [SELECT Id,ParentId, Name, AccountNumber, ShippingAddress, ShippingCity, ShippingCountry, ShippingStreet, ShippingPostalCode, ShippingState, SAP_Partner_Functions__c FROM Account WHERE Id IN :soldToAccountIdList];
        
        system.debug('soldToAccountList++++++++' + soldToAccountList);
        system.debug('shipToAccountList++++++++' + shipToAccountList);
        for(Account soldacc : soldToAccountList) {
            if(!finalMapData.containsKey(soldacc.Name)) {
                finalMapData.put(soldacc.Name, new List<List<String>>());
            }
            for(Account shipacc : shipToAccountList) {
                if(soldacc.Id == shipacc.ParentId) {
                    String address = '';
                    if(!String.isBlank(String.valueOf(shipacc.ShippingStreet))){
                        address = String.valueOf(shipacc.ShippingStreet) +', ';
                    }

                    if(!String.isBlank(String.valueOf(shipacc.ShippingCity))){
                        address += String.valueOf(shipacc.ShippingCity)+', ';
                    }
                    if(!String.isBlank(String.valueOf(shipacc.ShippingState))){
                        address += +String.valueOf(shipacc.ShippingState)+', ';
                    }
                    if(!String.isBlank(String.valueOf(shipacc.ShippingCountry))){
                        address += String.valueOf(shipacc.ShippingCountry)+', ';
                    }
                    if(!String.isBlank(String.valueOf(shipacc.ShippingPostalCode))){
                        address += String.valueOf(shipacc.ShippingPostalCode)+', ';
                    }
                    address = address.removeEnd(', ');
                    System.debug('address -- '+address);
                    
                    List<String> mapData = new List<String>();
                    if(!String.isBlank(shipacc.AccountNumber)) {
                        mapData.add(shipacc.AccountNumber);
                    }
                    if(!String.isBlank(shipacc.Name)) {
                        mapData.add(shipacc.Name);
                    }
                    if(!String.isBlank(address)) {
                        mapData.add(address);
                    }
                    if(mapData != null) {
                        finalMapData.get(soldacc.Name).add(mapData);
                    }
                    if(shipacc.Id == AccountId) {
                        soldToAccName = soldacc.Name;
                        shipToAccNumber = shipacc.AccountNumber;
                    }
                }
            }
            
            if(!finalMapData.containsKey(soldacc.Name) || soldacc.SAP_Partner_Functions__c.contains('Ship To')) {
                String address = '';
                if(!String.isBlank(String.valueOf(soldacc.ShippingStreet))){
                    address = String.valueOf(soldacc.ShippingStreet) +', ';
                }
                if(!String.isBlank(String.valueOf(soldacc.ShippingCity))){
                    address += String.valueOf(soldacc.ShippingCity)+', ';
                }
                if(!String.isBlank(String.valueOf(soldacc.ShippingState))){
                    address += +String.valueOf(soldacc.ShippingState)+', ';
                }
                if(!String.isBlank(String.valueOf(soldacc.ShippingCountry))){
                    address += String.valueOf(soldacc.ShippingCountry)+', ';
                }
                if(!String.isBlank(String.valueOf(soldacc.ShippingPostalCode))){
                    address += String.valueOf(soldacc.ShippingPostalCode)+', ';
                }
                address = address.removeEnd(', ');
                System.debug('address -- '+address);
                
                List<String> mapData = new List<String>();
                if(!String.isBlank(soldacc.AccountNumber)) {
                    mapData.add(soldacc.AccountNumber);
                }
                if(!String.isBlank(soldacc.Name)) {
                    mapData.add(soldacc.Name);
                }
                if(!String.isBlank(address)) {
                    mapData.add(address);
                }
                if(mapData != null){
                    finalMapData.get(soldacc.Name).add(mapData);
                }

                if(soldacc.Id == AccountId) {
                    soldToAccName = soldacc.Name;
                    shipToAccNumber = soldacc.AccountNumber;
                }
            }
        }

        AccountAddressWrapper accWrapper = new AccountAddressWrapper();
        accWrapper.finalMapData = finalMapData;
        accWrapper.soldToAccName = soldToAccName;
        accWrapper.shipToAccNumber = shipToAccNumber;
        System.debug('accWrapper ---> '+accWrapper);
        return accWrapper;
    }
    
    global class AccountAddressWrapper{
        @AuraEnabled
        public Map<String, List<List<String>>> finalMapData{get;set;}
        @AuraEnabled
        public String soldToAccName{get;set;}
        @AuraEnabled
        public String shipToAccNumber{get;set;}
    }
}
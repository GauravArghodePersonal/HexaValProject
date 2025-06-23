global without sharing class b2bAddressComponentController {
    @AuraEnabled(cacheable=true)
    global static AccountAddressWrapper B2B_get_Addresses(String AccountId){

        System.debug('get address called==');
        // List<String> AccountAdds = new List<String>();
        String ParentAdds = null;
        // Map<Id,String> addressMap = new Map<Id,String>();
        
        
        // for(Account a: [SELECT Id,Name,ShippingAddress,ShippingCity,ShippingCountry,ShippingStreet,ShippingPostalCode,ShippingState FROM Account WHERE parentId=: AccountId ]){
        //     String address = null;
        //     if(String.valueOf(a.ShippingStreet) != null || String.valueOf(a.ShippingStreet) != ''){
        //         address = String.valueOf(a.ShippingStreet) +', ';
        //     }
        //     if(String.valueOf(a.ShippingCity) != null || String.valueOf(a.ShippingCity) != '' ){
        //         address += String.valueOf(a.ShippingCity)+', ';
        //     }
        //     if(String.valueOf(a.ShippingState) != null || String.valueOf(a.ShippingState) != '' ){
        //         address += +String.valueOf(a.ShippingState)+', ';
        //     }
        //     if(String.valueOf(a.ShippingCountry) != null || String.valueOf(a.ShippingCountry) != '' ){
        //         address += String.valueOf(a.ShippingCountry)+', ';
        //     }
        //     if(String.valueOf(a.ShippingPostalCode) != null || String.valueOf(a.ShippingPostalCode) != '' ){
        //         address += String.valueOf(a.ShippingPostalCode)+', ';
        //     }
        //     address = address.removeEnd(',');
        //     address += ':::'+a.Id;
        //     // String s = String.valueOf(a.ShippingCountry)+String.valueOf(a.ShippingPostalCode)+String.valueOf(a.ShippingState)+String.valueOf(a.BillingCity)+String.valueOf(a.BillingStreet);
        //     If(address != null || address != ''){
        //         // addressMap.put(a.Id, address);
        //         AccountAdds.add(address);
        //     }
        // }

        Account parentAccount = [SELECT Id,AccountNumber,Name,ShippingAddress,ShippingCity,ShippingCountry,ShippingStreet,ShippingPostalCode,ShippingState FROM Account WHERE Id=: AccountId LIMIT 1];
        if(String.valueOf(parentAccount.ShippingStreet) != null || String.valueOf(parentAccount.ShippingStreet) != ''){
            ParentAdds = String.valueOf(parentAccount.ShippingStreet) +', ';
        }
        if(String.valueOf(parentAccount.ShippingCity) != null || String.valueOf(parentAccount.ShippingCity) != '' ){
            ParentAdds += String.valueOf(parentAccount.ShippingCity)+', ';
        }
        if(String.valueOf(parentAccount.ShippingState) != null || String.valueOf(parentAccount.ShippingState) != '' ){
            ParentAdds += +String.valueOf(parentAccount.ShippingState)+', ';
        }
        if(String.valueOf(parentAccount.ShippingCountry) != null || String.valueOf(parentAccount.ShippingCountry) != '' ){
            ParentAdds += String.valueOf(parentAccount.ShippingCountry)+', ';
        }
        if(String.valueOf(parentAccount.ShippingPostalCode) != null || String.valueOf(parentAccount.ShippingPostalCode) != '' ){
            ParentAdds += String.valueOf(parentAccount.ShippingPostalCode)+', ';
        }
        ParentAdds = ParentAdds.removeEnd(',');
        // ParentAdds += ':::'+parentAccount.Id;
        // String s = String.valueOf(a.ShippingCountry)+String.valueOf(a.ShippingPostalCode)+String.valueOf(a.ShippingState)+String.valueOf(a.BillingCity)+String.valueOf(a.BillingStreet);
       
        // System.debug('AccountAdds=='+AccountAdds);
        AccountAddressWrapper accWrapper = new AccountAddressWrapper();
        // accWrapper.AccountAddressList = AccountAdds;
        accWrapper.ParentAccountName = parentAccount.Name;
        accWrapper.ParentAccountNumber = parentAccount.AccountNumber;

        If(ParentAdds != null || ParentAdds != ''){
            // addressMap.put(a.Id, address);
            accWrapper.ParentAccountAddress = ParentAdds;
        }

        System.debug('accWrapper.ParentAccountName=='+accWrapper.ParentAccountName);
        System.debug('accWrapper.ParentAccountNumber==='+accWrapper.ParentAccountNumber);
        System.debug('accWrapper.ParentAccountAddress=='+accWrapper.ParentAccountAddress);
        // System.debug('accWrapper.AccountAddressList=='+accWrapper.AccountAddressList);
        System.debug(accWrapper);
        return accWrapper;
        // return accWrapper;
    }


    global class AccountAddressWrapper{
        // @Auraenabled
        // public List<String> AccountAddressList{get;set;}
        @Auraenabled
        public String ParentAccountAddress{get;set;}
        @Auraenabled
        public String ParentAccountName{get;set;}
        @Auraenabled
        public String ParentAccountNumber{get;set;}
    }
}
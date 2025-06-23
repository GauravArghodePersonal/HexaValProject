/*****************************************************************
* Class Name     : B2BBrandsLogo                            *
* Author         : Jyoti                                    *
* Description    : Used in b2bBrands LWC component. It is used to get entitled brands and its banner image.*
*****************************************************************/

public without sharing class B2BBrandsLogo {

    /**
* @description get entitled brands list based on selected account
*/  
   
    @AuraEnabled(cacheable=true)
    public static List<ProductCategory> getBrandDetails(String accountId) {
        System.debug('accountId==='+accountId);
        Account acc = [Select Id, Name,parentId,SAP_Attribute1_Desc__c, SAP_Attribute2_Desc__c, SAP_Attribute3_Desc__c, SAP_Attribute4_Desc__c, SAP_Attribute5_Desc__c, SAP_Attribute6_Desc__c, SAP_Attribute7_Desc__c , SAP_Attribute8_Desc__c, SAP_Attribute9_Desc__c,SAP_Attribute10_Desc__c from Account where Id =:accountId ];
        set<string> BrandNameSet = new set<string>();

        if(String.isBlank(acc.parentId) ){
            System.debug('In If=====');
            if(acc.SAP_Attribute1_Desc__c != null) BrandNameSet.add(acc.SAP_Attribute1_Desc__c);
            if(acc.SAP_Attribute2_Desc__c != null) BrandNameSet.add(acc.SAP_Attribute2_Desc__c);
            if(acc.SAP_Attribute3_Desc__c != null) BrandNameSet.add(acc.SAP_Attribute3_Desc__c);
            if(acc.SAP_Attribute4_Desc__c != null) BrandNameSet.add(acc.SAP_Attribute4_Desc__c);
            if(acc.SAP_Attribute5_Desc__c != null) BrandNameSet.add(acc.SAP_Attribute5_Desc__c);
            if(acc.SAP_Attribute6_Desc__c != null) BrandNameSet.add(acc.SAP_Attribute6_Desc__c);
            if(acc.SAP_Attribute7_Desc__c != null) BrandNameSet.add(acc.SAP_Attribute7_Desc__c);
            if(acc.SAP_Attribute8_Desc__c != null) BrandNameSet.add(acc.SAP_Attribute8_Desc__c);
            if(acc.SAP_Attribute9_Desc__c != null) BrandNameSet.add(acc.SAP_Attribute9_Desc__c);
            if(acc.SAP_Attribute10_Desc__c != null) BrandNameSet.add(acc.SAP_Attribute10_Desc__c);
        }else{
            System.debug('In Else=====');
            Account ParentAcc = [Select Id, Name,parentId, SAP_Attribute1_Desc__c, SAP_Attribute2_Desc__c, SAP_Attribute3_Desc__c, SAP_Attribute4_Desc__c, SAP_Attribute5_Desc__c, SAP_Attribute6_Desc__c, SAP_Attribute7_Desc__c , SAP_Attribute8_Desc__c, SAP_Attribute9_Desc__c,SAP_Attribute10_Desc__c from Account where Id =:acc.ParentId ];
            if(ParentAcc.SAP_Attribute1_Desc__c != null) BrandNameSet.add(ParentAcc.SAP_Attribute1_Desc__c);
            if(ParentAcc.SAP_Attribute2_Desc__c != null) BrandNameSet.add(ParentAcc.SAP_Attribute2_Desc__c);
            if(ParentAcc.SAP_Attribute3_Desc__c != null) BrandNameSet.add(ParentAcc.SAP_Attribute3_Desc__c);
            if(ParentAcc.SAP_Attribute4_Desc__c != null) BrandNameSet.add(ParentAcc.SAP_Attribute4_Desc__c);
            if(ParentAcc.SAP_Attribute5_Desc__c != null) BrandNameSet.add(ParentAcc.SAP_Attribute5_Desc__c);
            if(ParentAcc.SAP_Attribute6_Desc__c != null) BrandNameSet.add(ParentAcc.SAP_Attribute6_Desc__c);
            if(ParentAcc.SAP_Attribute7_Desc__c != null) BrandNameSet.add(ParentAcc.SAP_Attribute7_Desc__c);
            if(ParentAcc.SAP_Attribute8_Desc__c != null) BrandNameSet.add(ParentAcc.SAP_Attribute8_Desc__c);
            if(ParentAcc.SAP_Attribute9_Desc__c != null) BrandNameSet.add(ParentAcc.SAP_Attribute9_Desc__c);
            if(ParentAcc.SAP_Attribute10_Desc__c != null) BrandNameSet.add(ParentAcc.SAP_Attribute10_Desc__c);  
        }

        /*BrandNameSet.add('ALGAESHIELD®');
        BrandNameSet.add('PRISTINEBLUE®');
        BrandNameSet.add('CCH, Ultima, Water Testing, Misc');*/
        Footer_Links__mdt[] defaultBrands = [Select MasterLabel, Value__c from Footer_Links__mdt where MasterLabel='Default_Brands'];
        BrandNameSet.addAll(defaultBrands[0].Value__c.split(';'));
        String query  = 'Select Id,Name from ProductCategory where Brand_name_As_Account__c in :'+BrandNameSet + ' order by SortOrder asc';
        System.debug('query--'+query);

        List<ProductCategory>  entitledBrandsReturn = [Select Id,Name from ProductCategory where Brand_name_As_Account__c in : BrandNameSet order by SortOrder asc];
        System.debug('entitledBrandsReturn++++++ ' + entitledBrandsReturn);
        return entitledBrandsReturn;
    }


    // @AuraEnabled(cacheable=true)
    // public static List<ProductCategory> getBrandDetails(String accountId) {
    //     Account acc = [Select Id, Name from Account where Id =:accountId ];
    //     String key = acc.id;
    //     System.debug('key++++++ ' + key);
    //     CommerceEntitlementPolicy policy = [Select Id from CommerceEntitlementPolicy where name =: key ];
    //     System.debug('policy++++++ ' + policy);
    //     List<CommerceEntitlementProduct> entitlementProducts = [Select Id,ProductId from CommerceEntitlementProduct where PolicyId =: policy.Id];
    //     System.debug('entitlementProducts++++++ ' + entitlementProducts);
    //     List<Id> productIds = new List <Id>();
    //     For(CommerceEntitlementProduct  ep: entitlementProducts){
    //         productIds.add(ep.ProductId);
    //     }
    //     System.debug('productIds++++++ ' + productIds);
    //     List<ProductCategoryProduct> productCategoryProducts = [Select Id,ProductCategoryId from ProductCategoryProduct where ProductId in :productIds];
    //     System.debug('productCategoryProducts++++++ ' + productCategoryProducts);
    //     Set<Id> entitledBrands = new Set<Id>();
    //     //List<Id> entitledBrandsReturn = new List<Id>();
    //     for(ProductCategoryProduct pcp : productCategoryProducts){
    //         entitledBrands.add(pcp.ProductCategoryId);
    //     }
    //     System.debug('entitledBrands++++++ ' + entitledBrands);
    //     List<ProductCategory>  entitledBrandsReturn = [Select Id,Name from ProductCategory where id in : entitledBrands ];
    //     //entitledBrandsReturn.addAll(entitledBrands);
    //     System.debug('entitledBrandsReturn++++++ ' + entitledBrandsReturn);
    //     return entitledBrandsReturn;
    //     //return null;
    // }

/**
* @description Uses connect Api to get banner image of brands.
*/  

    @AuraEnabled(cacheable=true)
    public static ConnectApi.ProductCategoryDetail getBrand(String communityId,
                                                      String productCategoryId,
                                                      String effectiveAccountId
                                                     ) 
    {
        // Lookup the webstore ID associated with the community
        System.debug('communityId :::::' + communityId);
        String webstoreId = '';
        if(!Test.isRunningTest()){
            webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);
        }
        else{
            WebStore wb = [SELECT Id FROM WebStore WHERE Name = 'Solenis Eshop'];
            webstoreId = wb.Id;
        }
        
        System.debug('effectiveAccountID :::::' + effectiveAccountId);
        System.debug('productCategoryId :::::' + productCategoryId);
        System.debug('webstoreId :::::' + webstoreId);

        if(!Test.isRunningTest()){
        return ConnectApi.CommerceCatalog.getProductCategory(webstoreId,productCategoryId,effectiveAccountID,null,false,null,false);
        }
        else{
            return null;
        }
    }

}
global class B2BsearchIndexRefreshSchedule implements Schedulable {
     

    global void execute(SchedulableContext sc)
    
    {
        String communityId;
        System.debug('#####' + ConnectApi.Communities.getCommunities().communities);
        for(ConnectApi.Community cm : ConnectApi.Communities.getCommunities().communities){
            if(cm.Name == 'Solenis EShop'){
                System.debug('=========' + cm.Name);
                System.debug('=========' + cm.Id);
                communityId = cm.Id;
            }
        
        }
        String webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(communityId);

         ConnectApi.CommerceSearchIndex abc = ConnectApi.CommerceSearchSettings.createCommerceSearchIndex(webstoreId);
    }
}
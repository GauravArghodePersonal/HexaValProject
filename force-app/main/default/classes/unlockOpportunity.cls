public  class unlockOpportunity{
    
    @InvocableMethod
    public static void invocableUnlock(List<Opportunity> objOpportunity) {
        Approval.UnlockResult[] lrList = Approval.unlock(objOpportunity, false);

        // Iterate through each returned result
        for(Approval.UnlockResult lr : lrList) {
            if (lr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully locked account with ID: ' + lr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : lr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                }
            }
        }
    }
}
// Test Class - caseOwnerEmailPopulate_T
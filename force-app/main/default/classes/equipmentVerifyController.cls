public class equipmentVerifyController{

    /* public Asset myAccount{get;set;}
 
public equipmentVerifyController(ApexPages.StandardController controller) {
       
  }
 
  Public Pagereference go(){
       myAccount = [SELECT Id, Name,Last_Verification_Date__c,Last_verification_By__c 
                   FROM Asset
                   WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
                   
                   myAccount.Last_verification_By__c = UserInfo.getFirstName()+ ' ' +UserInfo.getLastName();
                   myAccount.Last_Verification_Date__c= System.today();
                       
               Update myAccount;   
                PageReference pageRef = new PageReference('/lightning/r/Asset/'+myAccount.id);
                pageRef.setRedirect(true);
                //System.Aura.redirect(pageRef);
    return pageRef;
   }*/
    
    @AuraEnabled
    public static Asset verifyAsset(Id AssetId){
        try{
            asset asst = [SELECT Id, Name,Last_Verification_Date__c,Last_verification_By__c 
                   FROM Asset
                   WHERE Id=:AssetId];   
            
                   asst.Last_verification_By__c = UserInfo.getFirstName()+ ' ' +UserInfo.getLastName();
                   asst.Last_Verification_Date__c= System.today();                       
               Update asst;   
            return asst;
        }
        catch (Exception e){
            throw new AuraHandledException(e.getMessage()); 
        }
    }
}
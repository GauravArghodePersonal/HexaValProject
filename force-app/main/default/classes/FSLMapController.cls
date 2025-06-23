public class FSLMapController {
    public Id Current_Acc_Id;
    public string address {get;set;}
    public FSLMapController(ApexPages.StandardController controller) {
         Asset c = (Asset)controller.getRecord();
         Current_Acc_Id = c.id;
         Asset ass = [select Account_Address__c from Asset where Id =:Current_Acc_Id limit 1 ];
         address = ass.Account_Address__c;
         System.debug('address>>'+address);
    }
}
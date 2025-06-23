public class MapController {
    public Id Current_Acc_Id;
    public string address {get;set;}
    public MapController(ApexPages.StandardController controller) {
         Case c = (Case)controller.getRecord();
         Current_Acc_Id = c.id;
         Case cases = [select addressFormap__c from Case where Id =:Current_Acc_Id limit 1 ];
         address = cases.addressFormap__c;
         System.debug('address>>'+address);
    }
}
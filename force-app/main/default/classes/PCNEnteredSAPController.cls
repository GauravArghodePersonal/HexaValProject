public class PCNEnteredSAPController {

public static string id;
public static pricing_condition__c pcn;
    public PCNEnteredSAPController(ApexPages.StandardController controller) {
      id = apexpages.currentpage().getparameters().get('id');
      pcn = [select id, entered_in_SAP__c from pricing_condition__c where id = :id limit 1];
      
    }
    
    public pagereference toggleEnteredSAP(){
    if(pcn.entered_in_SAP__c == true){
    pcn.entered_in_SAP__c = false;}
    else{
    pcn.entered_in_SAP__c = true;}
    update pcn;
    return new pagereference ('/' + id);
    }

}
public class rejectpricingextension {

public pricing__c p{get; set;}

public rejectpricingextension(ApexPages.StandardController controller){
string id = '';
id = apexpages.currentpage().getparameters().get('id');
p = new pricing__c();
p=[select id, Status__c, rejection_comments__c from pricing__c where id = :id limit 1];
p.Status__c = 'Auto Reject';

}

public pagereference updatepricing(){

update p;
Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();  
req1.setComments('Submitting request for approval'); 
req1.setObjectId(p.Id); 

Approval.ProcessResult result = Approval.process(req1);

return new pagereference('/' + p.id);}

}
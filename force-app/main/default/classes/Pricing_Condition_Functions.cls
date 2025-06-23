global with sharing class Pricing_Condition_Functions {

  webservice static Boolean submitPricingConditionforApproval(String pcId) 
  {
  		
	//Create an approval request for the price book
   	Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
   	req.setComments('Submitting Pricing Condition for Approval.');
   	req.setObjectId(pcId);
   	
  	//Submit the approval request for the price book
  	Approval.ProcessResult result = Approval.process(req);	
    
    return result.isSuccess();                                                        
  }
  

}
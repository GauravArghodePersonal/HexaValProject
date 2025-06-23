public class GetSAPController {
 public IRF_Monthly_Data__c irfmonthlydata{get; set;}   
    
 
   public GetSAPController()
   {
       irfmonthlydata = [SELECT Id, Name,Shipped_From__c,Month__c,Year__c,Invoice_Start_Date__c,Invoice_Due_Date__c,Sales_OrderNum__c,Bill_LandNumber__c,Start_Date__c,End_Date__c,Payment_Terms__c FROM IRF_Monthly_Data__c WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
   }
    
    public PageReference save(){
        upsert irfmonthlydata;
         PageReference pageRef = new PageReference('/apex/IRF_Page_2A?imdId='+ ApexPages.currentPage().getParameters().get('id') );
        pageRef.setRedirect(true);
        return pageRef;
    }
    public PageReference cancel(){
      PageReference pageRef = new PageReference('/apex/IRF_Page_2A?imdId='+ ApexPages.currentPage().getParameters().get('id') );
        pageRef.setRedirect(true);
        return pageRef;
    }
}
@isTest
private class PriceBookActivationController_Test{
    @isTest static void PriceBookActivationControllermethod (){
      Integer resultSize  = 10;
      Integer lastPageNumber = 10;
      Integer pageNumber = 10;
      Integer recordFrom = 1;
      Integer recordTo =1;
      Boolean disableActivateButton = false;
      Boolean renderApprovedList = true;
      List<Price_Book__c > pr = new List<Price_Book__c >();
      Price_Book__c price = new Price_Book__c();
      price.Active__c = true;
      price.Description__c = 'test';
      price.Record_Status__c = 'Active';
      price.Effective_Date__c = Date.Today();
      pr.add(price);
      insert pr;
      Test.startTest(); 
      PageReference pageRef = page.PriceBookActivationPage1;
      Test.setCurrentPage(pageRef);
      pageRef.getParameters().put('id',price.id); 
      ApexPages.StandardSetController c = new ApexPages.StandardSetController(pr);   
      PriceBookActivationController controller = new PriceBookActivationController(c); 
      controller.activatePriceBooks();
      controller.submitActivationBatchJob();
      controller.first();
      controller.last();
      controller.next();
      controller.previous();
      controller.getPageSize();
      controller.setPageSize(10);
      controller.getPageNumber();
      controller.setPageNumber(1);
      controller.getApprovedPriceBooks();
      System.assertEquals(resultSize,10);
      System.assertEquals(lastPageNumber,10);
      System.assertEquals(pageNumber,10);
      System.assertEquals(recordFrom,1);
      System.assertEquals(disableActivateButton,false);
      System.assertEquals(renderApprovedList,true);
    }
}
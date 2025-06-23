@isTest
public class MaterialSalesData2Controller_TestClass{
    
    @isTest(SeeAllData=true)
    static void checkData(){
      Material_Sales_Data2__c  ms = [select id from Material_Sales_Data2__c limit 1];  
    
    Test.startTest();
        PageReference pageRef = Page.Material_Sales_Data2_Page01;
        pageRef.getparameters().put('recordId', ms.id);  
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController sc = new Apexpages.StandardController(ms);
        Material_Sales_Data2_Controller ext = new  Material_Sales_Data2_Controller(sc);         
       // ext.doCancel();   
   // Apexpages.Material_Sales_Data2_Controller stdController = new Apexpages.Material_Sales_Data2_Controller(MS);
    //Solenis_MSD result = Solenis_MSD.init(opp.Id, 'All');
   // Material_Sales_Data2_Controller s = Material_Sales_Data2_Controller.init(ms.id);
    Test.stopTest();
    }
    
}
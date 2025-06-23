@isTest
private class equipmentVerifyControllerTest{
      @isTest 
    Private static void equipmentVerifyControllerTests(){
        Account Acc= TestDataFactory.createAccount(True); 
        Asset ast =  TestDataFactory.createAsset(True,Acc.id);  
        
        equipmentVerifyController.verifyAsset(ast.id);    
    }
     
 }
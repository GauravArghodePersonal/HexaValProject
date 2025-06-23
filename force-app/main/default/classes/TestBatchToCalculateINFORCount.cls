/**

  * ────────────────────────────────────────────────────────────────────────────────────────────────

  * Test class for Apex class: BatchToCalculateINFORCount

  * ────────────────────────────────────────────────────────────────────────────────────────────────

  */



  @isTest

  public class TestBatchToCalculateINFORCount {
  
     
  
      @TestSetup static void createData(){
  
          //Create an INFOR Record
  
        INFOR_Forecast__c infor = new INFOR_Forecast__c(Material_Description__c = 'abc');
        insert infor;
        

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@org.com', 
                        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                        LocaleSidKey='en_US', ProfileId = p.Id, 
                        TimeZoneSidKey='America/Los_Angeles', UserName='Testuser1212' + system.now().format('YYYYmmddhhmmss') + '@testorg.com');
        u.IsActive = true;
        insert u;

        User u1 = new User(Alias = 'standt', Email='standarduser@org.com', 
                        EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                        LocaleSidKey='en_US', ProfileId = p.Id, 
                        TimeZoneSidKey='America/Los_Angeles', UserName='Testuser121245' + system.now().format('YYYYmmddhhmmss') + '@testorg.com');
        u1.IsActive = true;
        insert u1;
  
      }
      
  
      static testMethod void BatchToCalculateINFORCount_UnitTest() {
  
          User oUser = [SELECT ID FROM User WHERE LastName='Testing'];
  
          User oUser1 = [SELECT ID FROM User WHERE LastName='Testing1'];
          system.assert(oUser.Id!=null);
  
          test.startTest();
  
          system.runAs(oUser){
                BatchToCalculateINFORCount bc = new BatchToCalculateINFORCount();
                database.executeBatch(bc);

          }
  
          test.stopTest();
          system.runAs(oUser1){
            
            INFOR_Forecast__c infor1 = new INFOR_Forecast__c(Material_Number__c = 'ZZZZZZZZZZZZZZZZZZ');
            insert infor1;

            BatchToCalculateINFORCount bc1 = new BatchToCalculateINFORCount();
            database.executeBatch(bc1);
      }
        }  
  
  }
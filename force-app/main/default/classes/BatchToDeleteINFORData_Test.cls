@isTest
public class BatchToDeleteINFORData_Test {
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
    }
    

    static testMethod void BatchToDeleteINFORData_UnitTest() {

        User oUser = [SELECT ID FROM User WHERE LastName='Testing'];

        test.startTest();

        system.runAs(oUser){
            BatchToDeleteINFORData bc = new BatchToDeleteINFORData();
              database.executeBatch(bc);

              BatchToDeleteINFORData testobj = new BatchToDeleteINFORData();

              String cronexpression = '0 0 0 ? * * *';
              system.schedule('test', cronexpression, testobj);

        }

        test.stopTest();
        
      } 
}
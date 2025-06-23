@isTest
public class ForcastProReusableLookupControllerTest {
    
     @isTest
   public static void testFetchRecordsReusable() {
       
       Contact contact = new Contact();
       contact.LastName = 'Test';
       insert contact;
       ForcastProReusableLookupController.ResultWrapper expectedResult = new ForcastProReusableLookupController.ResultWrapper();
       expectedResult.mainField = 'Test Value';
       expectedResult.subField = 'Sub Value';
       expectedResult.id = contact.Id;
 
       ForcastProReusableLookupController.SearchWrapper inputWrapper = new ForcastProReusableLookupController.SearchWrapper();
       inputWrapper.objectApiName = 'Contact';
       inputWrapper.fieldApiName = 'Name';
       inputWrapper.otherFieldApiName = 'Description'; // Use any other field here
       inputWrapper.searchString = 'Test';
       inputWrapper.selectedRecordId = '';
       inputWrapper.parentRecordId = '';
       inputWrapper.parentFieldApiName = '';
       ForcastProReusableLookupController.ResultWrapper inputWrapper1 = new ForcastProReusableLookupController.ResultWrapper();
       inputWrapper1.mainField = 'Contact';
       inputWrapper1.subField = 'Name';
       inputWrapper1.id = contact.id; // Use any other field here
     
       Test.startTest();
       List<ForcastProReusableLookupController.ResultWrapper> actualResult = ForcastProReusableLookupController.fetchRecords(inputWrapper);
       Test.stopTest();
       System.assertEquals(1, actualResult.size());
       System.assertEquals(expectedResult.mainField, 'Test Value');
       System.assertEquals(expectedResult.subField, 'Sub Value');
       System.assertEquals(expectedResult.id, contact.id);
      
      
   }

}
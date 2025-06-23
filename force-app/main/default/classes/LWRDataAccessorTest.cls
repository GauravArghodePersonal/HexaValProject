@isTest
private class LWRDataAccessorTest {
	
    /**
     * @description Test Method for getLWRSetting
     * @author      Lavakusareddy
     * @date		CreatedDate: 20-Jun-2022
     */
    @isTest static void getLWRSettingTest(){
        Test.startTest();
        List<LWR_Setting__mdt> results = LWRDataAccessor.getLWRSetting('');
        Test.stopTest();
        
        System.assertEquals(0, results.size());
    }
    
    /**
     * @description Test Method for getLoggedInUserDetails
     * @author      Lavakusareddy
     * @date		CreatedDate: 20-Jun-2022
     */
    @isTest static void getLoggedInUserDetailsTest(){
        Test.startTest();
        User testUsr = LWRDataAccessor.getLoggedInUserDetails();
        Test.stopTest();
        
        System.assert(testUsr != null);
    }
    
    /**
     * @description Test Method for getLabs
     * @author      Lavakusareddy
     * @date		CreatedDate: 20-Jun-2022
     */
    @isTest static void getLabsTest(){
        List<Lab__c> labs = new List<Lab__c>();
        labs.add(new Lab__c(Lab_Name__c = 'Lab_One'));
        labs.add(new Lab__c(Lab_Name__c = 'Lab_Two'));
        Insert labs;
        
        Test.startTest();
        List<Lab__c> results = LWRDataAccessor.getLabs();
        Test.stopTest();
        
        System.assertEquals(2, results.size());
    }
}
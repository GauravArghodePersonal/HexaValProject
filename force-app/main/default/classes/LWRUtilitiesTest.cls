@isTest
private class LWRUtilitiesTest {
	
    /**
     * @description Test Method for getProfileNames
     * @author      Lavakusareddy
     * @date		CreatedDate: 20-Jun-2022
     */
    @isTest static void getProfileNamesTest(){
        Test.startTest();
        List<String> result = LWRUtilities.getProfileNames(new List<LWR_Setting__mdt>());
        Test.stopTest();
        
        System.assertEquals(0, result.size());
    }
    
    /**
     * @description Test Method for getUnqiueUserName
     * @author      Lavakusareddy
     * @date		CreatedDate: 20-Jun-2022
     */
    @isTest static void getUnqiueUserNameTest(){
        Test.startTest();
        String result = LWRUtilities.getUnqiueUserName();
        Test.stopTest();
        
        System.assert(result.contains(UserInfo.getOrganizationId()));
    }
    
    /**
     * @description Test Method for groupSObjectsByFieldName
     * @author      Lavakusareddy
     * @date		CreatedDate: 20-Jun-2022
     */
    @isTest static void groupSObjectsByFieldNameTest(){
        List<User> users = [SELECT Id, Email FROM User LIMIT 1];
        Test.startTest();
        Map<String,List<SObject>> results = LWRUtilities.groupSObjectsByFieldName('Email', users);
        Test.stopTest();
        
        System.assertEquals(1, results.size());
    }
}
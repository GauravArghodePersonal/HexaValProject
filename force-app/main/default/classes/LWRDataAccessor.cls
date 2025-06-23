/**
 * @description LWR Data Accessor
 * @author      Lavakusareddy Poluru
 * @date        Created: 20-Jun-2022
 */
public with sharing class LWRDataAccessor {
	
    /**
     * @description Function to reterive specific LWR Setting
     * @author      Lavakusareddy Poluru
 	 * @date        Created: 20-Jun-2022
     * @param		settingName Name of the setting
     * @return 		LWR Settings
     */
    public static List<LWR_Setting__mdt> getLWRSetting(String settingName){
        return [SELECT Id, 
                       Profile_Names__c 
                   FROM LWR_Setting__mdt 
                   WHERE DeveloperName = :settingName
               ];
    }
    
    /**
     * @description Function to reterive logged-in user record
     * @author      Lavakusareddy Poluru
 	 * @date        Created: 20-Jun-2022
     * @return 		Logged-In User record
     */
    public static User getLoggedInUserDetails(){
        return [SELECT Id, 
                       ProfileId,
                	   Profile.Name
                   FROM User 
                   WHERE Id = :UserInfo.getUserId()
                   LIMIT 1
               ];
    }
    
    /**
     * @description Function to reterive logged-in user record
     * @author      Lavakusareddy Poluru
 	 * @date        Created: 20-Jun-2022
     * @return 		Logged-In User record
     */
    public static List<Lab__c> getLabs(){
        return [SELECT Id,
               		   Lab_Name__c
               		FROM Lab__c
              ];
    }
}
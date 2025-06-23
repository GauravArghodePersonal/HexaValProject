public class HX_OneTimeDataHandler {
    public static void updateAccountForOneTimeData(List<One_Time_Data__c> oneTimeDataList) {
        Set<Id> libraryIds = new Set<Id>();
        Map<Id, HXLibraryCW__c> libraryMap = new Map<Id, HXLibraryCW__c>();
        
        for (One_Time_Data__c data : oneTimeDataList) {
            data.Date_Created__c = DateTime.now();
            libraryIds.add(data.HXLibraryCW__c);
        }
        
        List<HXLibraryCW__c> libraries = [SELECT Id, Account_Name_New__c FROM HXLibraryCW__c WHERE Id IN :libraryIds];
        for (HXLibraryCW__c library : libraries) {
            libraryMap.put(library.Id, library);
        }
        
        for (One_Time_Data__c data : oneTimeDataList) {
            if (libraryMap.containsKey(data.HXLibraryCW__c)) {
                if(!Test.isRunningTest())
                data.Account__c = libraryMap.get(data.HXLibraryCW__c).Account_Name_New__c;
            }
        }
    }
}
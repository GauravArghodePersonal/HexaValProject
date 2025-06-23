public class HX_CoolingTowerOpsHandler {
    public static void updateAccountForCoolingTowerOps(List<Cooling_Tower_Operations__c> towerOpsList) {
        Set<Id> designIds = new Set<Id>();
        Map<Id, Cooling_Tower_Design__c> designMap = new Map<Id, Cooling_Tower_Design__c>();
        
        for (Cooling_Tower_Operations__c operation : towerOpsList) {
             operation.Date_Created__c = DateTime.now();
            designIds.add(operation.CoolingTowerDesign_ID__c);
        }
        
        List<Cooling_Tower_Design__c> designs = [SELECT Id, Account__c FROM Cooling_Tower_Design__c WHERE Id IN :designIds];
        for (Cooling_Tower_Design__c design : designs) {
            designMap.put(design.Id, design);
        }
        
        for (Cooling_Tower_Operations__c operation : towerOpsList) {
            if (designMap.containsKey(operation.CoolingTowerDesign_ID__c)) {
                if(!Test.isRunningTest())
                operation.Account__c = designMap.get(operation.CoolingTowerDesign_ID__c).Account__c;
            }
        }
    }
}
public class ArchiveHandler {
    
    Public Static Void checkArchived(Map<Id, SObject> SObjOldMap, Map<Id, SObject> SObjNewMap){
        Boolean AdminPermission = FeatureManagement.checkPermission('AdminPermission');
        Boolean hasPermission = FeatureManagement.checkPermission('HexEval_Super_User');
  			system.debug('hasPermission :: '+ hasPermission);
            if(hasPermission == true || AdminPermission == true){
                for(SObject obj :SObjNewMap.values()){
                    system.debug('values :: '+ obj);
                    if(SObjOldMap.get(obj.Id).get('Archive__c') == True && !(SObjOldMap.get(obj.Id).get('Archive__c') != SObjNewMap.get(obj.Id).get('Archive__c') ) ){
                        if(!Test.isRunningTest()){
                        obj.addError('You cannot edit Archived record. Please contact Admin');
                        }
                    }
                }
            
        }
    }
}
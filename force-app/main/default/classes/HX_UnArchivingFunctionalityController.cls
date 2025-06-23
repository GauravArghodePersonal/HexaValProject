public class HX_UnArchivingFunctionalityController {
    @AuraEnabled
    Public Static String unArchiveRecords(Id recordId){
        String sObjName = recordId.getSObjectType().getDescribe().getName();
        System.debug(sObjName);
        System.debug(recordId);
        try{
        if(sObjName == 'Cooling_Tower_Design__c'){
            archiveCTDAndRelated(recordId);
        }
        if(sObjName == 'Cooling_Tower_Operations__c'){
            List<Cooling_Tower_Operations__c> CTOList = [Select Id, Archive__c from Cooling_Tower_Operations__c where Id =:recordId AND Archive__c != False];
            archiveCTO(CTOList);
        }
        if(sObjName == 'HXLibraryCW__c'){
            List<HXLibraryCW__c> HXList = [Select Id, Archive__c from HXLibraryCW__c where Id =:recordId AND Archive__c != False];
            archiveHXL(HXList);
        }
        if(sObjName == 'HXEvent__c'){
            List<HXEvent__c> HXEList = [Select Id, Archive__c from HXEvent__c where Id =:recordId AND Archive__c != False];
            archiveHXE(HXEList);
        }
        if(sObjName == 'FlowStudyCW__c'){
            List<FlowStudyCW__c> FSList = [Select Id, Archive__c from FlowStudyCW__c where Id =:recordId AND Archive__c != False];
            archiveFS(FSList);
        }
        if(sObjName == 'One_Time_Data__c'){
            List<One_Time_Data__c> OTDList = [Select Id, Archive__c from One_Time_Data__c where Id =:recordId AND Archive__c != False];
            archiveOTD(OTDList);
        }
        return 'Success';
        }catch(exception ex){
            return 'Error';
        }
    }

    Public Static void archiveCTDAndRelated(Id recordId){
        Cooling_Tower_Design__c  ctdRec = new Cooling_Tower_Design__c();
        ctdRec.Id = recordId;
        ctdRec.Archive__c = False;
        Update ctdRec;
        List<Cooling_Tower_Operations__c> CTOList = [Select Id, Archive__c from Cooling_Tower_Operations__c where CoolingTowerDesign_ID__c =:recordId AND Archive__c != False];
        if(!CTOList.isEmpty()){
            archiveCTO(CTOList);
        }
        List<HXLibraryCW__c> HXList = [Select Id, Archive__c from HXLibraryCW__c where Cooling_Tower_ID__c =:recordId AND Archive__c != False];
        if(!HXList.isEmpty()){
            archiveHXL(HXList);
        }
        List<HXEvent__c> HXEList = [Select Id, Archive__c from HXEvent__c where HXLibrary__c =:recordId AND Archive__c != False];
        if(!HXEList.isEmpty()){
            archiveHXE(HXEList);
        }
        List<FlowStudyCW__c> FSList = [Select Id, Archive__c from FlowStudyCW__c where Heat_Exchanger_Id__c =:recordId AND Archive__c != False];
        if(!FSList.isEmpty()){
            archiveFS(FSList);
        }
        List<One_Time_Data__c> OTDList = [Select Id, Archive__c from One_Time_Data__c where HXLibraryCW__c =:recordId AND Archive__c != False];
        if(!OTDList.isEmpty()){
            archiveOTD(OTDList);
        }
    }

    Public Static void archiveCTO(List<Cooling_Tower_Operations__c> CTOList){
        for(Cooling_Tower_Operations__c ctoRec:CTOList){
            ctoRec.Id = ctoRec.Id;
            ctoRec.Archive__c = False;
        }
        update CTOList;
    }
    
    Public Static void archiveHXL(List<HXLibraryCW__c> HXList){
        for(HXLibraryCW__c HXLRec:HXList){
            HXLRec.Id = HXLRec.Id;
            HXLRec.Archive__c = False;
        }
        update HXList;
        List<HXEvent__c> HXEList = [Select Id, Archive__c from HXEvent__c where HXLibrary__c IN: HXList AND Archive__c != False];
        if(!HXEList.isEmpty()){
            archiveHXE(HXEList);
        }
        List<FlowStudyCW__c> FSList = [Select Id, Archive__c from FlowStudyCW__c where Heat_Exchanger_Id__c IN: HXList AND Archive__c != False];
        if(!FSList.isEmpty()){
            archiveFS(FSList);
        }
        List<One_Time_Data__c> OTDList = [Select Id, Archive__c from One_Time_Data__c where HXLibraryCW__c IN: HXList AND Archive__c != False];
        if(!OTDList.isEmpty()){
            archiveOTD(OTDList);
        }
    }
    Public Static void archiveHXE(List<HXEvent__c> HXEList){
        for(HXEvent__c HXERec:HXEList){
            HXERec.Id = HXERec.Id;
            HXERec.Archive__c = False;
        }
        update HXEList;
    }
    Public Static void archiveFS(List<FlowStudyCW__c> FSList){
        for(FlowStudyCW__c FSRec:FSList){
            FSRec.Id = FSRec.Id;
            FSRec.Archive__c = False;
        }
        update FSList;
    }
    Public Static void archiveOTD(List<One_Time_Data__c> OTDList){
        for(One_Time_Data__c OTDRec:OTDList){
            OTDRec.Id = OTDRec.Id;
            OTDRec.Archive__c = False;
        }
        update OTDList;
    }
}
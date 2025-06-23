public class SubLWRTriggerHandler {
    
    //Target date auto populated from sub LWR
    public static void getMaximumTargetDate(List<Sub_LWR__c> subList){
        List<Sub_LWR__c> subLWRlist = new List<Sub_LWR__c>();
        Set<string> LWRsetid = new Set<string>();
        List<LWR__c> LWRList = new List<LWR__c>();

        for(Sub_LWR__c  sublwr: subList){
            LWRsetid.add(sublwr.LWR__c);
            system.debug('======='+LWRsetid);
        }
        if(LWRsetid.size() > 0){
            system.debug('======='+LWRsetid.size());
            for(LWR__c LWR:[select id,name,Target_date__c,(select id,Name,LWR__c, Target_date__c from Sub_LWR__r where LWR__c=:LWRsetid order by Target_date__c Desc limit 1) from LWR__c where id=:LWRsetid  ]){
                system.debug('======='+LWR);
                system.debug('======='+LWR);
                for(Sub_LWR__c sublwr:LWR.Sub_LWR__r){
                    system.debug('======='+sublwr);
                    LWR.Target_Date__c=sublwr.Target_date__c;
                    LWRList.add(LWR);
                    }
                }
            }
        if(LWRList.size() > 0){
            system.debug('======='+LWRList.size());
            upsert LWRList;
            }
	}

}
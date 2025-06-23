/*

Author:Aakash Wankhede

Last Modified On: 

Description: this class is created for fetching latest event to be shown/dispalyed on event banner component which is placed on experience site home page, test class name : Exp_LatestEventsTest.cls

*/
public class Exp_LatestEvents {
    @AuraEnabled(cacheable=true)
    public static ResultWrapper getLatestEvents(){
        ResultWrapper result=new ResultWrapper();
        List<EventWrapper> events = new List<EventWrapper>();
        for(Exp_Events__c event:[ SELECT Id, Heading__c, Sub_Heading__c, Content__c, Button_Label__c, Button_URL__c FROM Exp_Events__c WHERE Is_Active__c=TRUE ORDER BY CreatedDate DESC LIMIT 1]){
            events.add(new EventWrapper(event.Id,event.Heading__c,event.Sub_Heading__c, event.Content__c, event.Button_Label__c, event.Button_URL__c));
        }
        result.events = events;
        return result;
    }
    public class ResultWrapper{
        @AuraEnabled
        public Boolean isSuccess;
        @AuraEnabled
        public String message;
        @AuraEnabled
        public List<EventWrapper> events;
    }
    public class EventWrapper{
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String heading;
        @AuraEnabled
        public String subHeading;
        @AuraEnabled
        public String content;
        @AuraEnabled
        public String buttonLabel;
        @AuraEnabled
        public String buttonUrl;
        public EventWrapper(Id recordId, String heading, String subHeading, String content, String buttonLabel, String buttonUrl){
            this.id = recordId;
            this.heading = heading;
            this.subHeading = subHeading;
            this.content= content;
            this.buttonLabel = buttonLabel;
            this.buttonUrl = buttonUrl;
        }
    }
}
({
    onInitHandler : function(component, event, helper){
        helper.getOppById(component, event, helper);
    },
    init : function(component, event, helper, opportunity){
        let currentUrl = decodeURIComponent(window.location.search.substring(1));
        var createRecordEvent = $A.get("e.force:createRecord");

        createRecordEvent.setParams({  
            "entityApiName": "Task",
            "recordTypeId": "01250000000NBiv",
            /*"navigationLocation":"LOOKUP",*/
            "defaultFieldValues": {
                'WhatId': component.get('v.recordId'),
                'ActivityDate': $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"),
                'Subject': 'Opportunity Update',
                'Status': 'Completed', 
                'Stage_on_Opportunity__c': opportunity.StageName
            },
            "panelOnDestroyCallback":function(event) {
                // window.location.href = windowRedirect;
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get("v.recordId"),
                    "isredirect":true
                });
                // navigate back to account only if Task create was cancelled
                decodeURIComponent(window.location.search.substring(1)) == currentUrl ? 
                                    navEvt.fire() : console.log('nav to Account');
            } 
        });
        createRecordEvent.fire(); 
    },
    getOppById: function(component, event, helper){
        var action = component.get("c.getOpportunityById");
        action.setParams({ opportunityId : component.get("v.recordId") });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var opportunity = response.getReturnValue();
                console.log('>>>>>>>>>>>>>',opportunity);
                helper.init(component, event, helper, opportunity);
            }
        });
	 	$A.enqueueAction(action);
	}
})
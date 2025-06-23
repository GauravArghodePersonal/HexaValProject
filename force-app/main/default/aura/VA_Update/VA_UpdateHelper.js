({
    onInitHandler : function(component, event, helper){
        helper.getOppById(component, event, helper);
        //helper.recordTypeHelper(component, event, helper);
    },
    init : function(component, event, helper, ValueAdvantage__c){
        let currentUrl = decodeURIComponent(window.location.search.substring(1));
        var createRecordEvent = $A.get("e.force:createRecord");

        createRecordEvent.setParams({  
            "entityApiName": "Task",
            "recordTypeId" : "0122J000000JCb8",
            
            /*"navigationLocation":"LOOKUP",*/
            "defaultFieldValues": {
                'WhatId': component.get('v.recordId'),
                
                'ActivityDate': $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"),
                'Subject': 'VA Update',
                'Status': 'Completed', 
                'Project_Status__c': ValueAdvantage__c.Project_Status__c
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
        var action = component.get("c.getValueAdvantageById");
        action.setParams({ ValuerecId : component.get("v.recordId") });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var ValueAdvantage__c = response.getReturnValue();
                console.log('>>>>>>>>>>>>>',ValueAdvantage__c);
                helper.init(component, event, helper, ValueAdvantage__c);
            }
        });
	 	$A.enqueueAction(action);
	},
    recordTypeHelper : function(component, event, helper) {
		var action = component.get('c.getrectypeId');
        action.setParams({"recName": 'VA_Update'});
        
        action.setCallback(this, function(response){
            var state = response.getState();      
            //alert('state ' + state);
            if(state == "SUCCESS"){
                var result = response.getReturnValue();
                alert('result ' + JSON.stringify(result));
                component.set('v.recordTypeId',result);
            }
        });
        $A.enqueueAction(action);
	}
})
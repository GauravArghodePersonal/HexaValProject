({
    onInitHandler : function(component, event, helper){
        let currentUrl = decodeURIComponent(window.location.search.substring(1));
        var createRecordEvent = $A.get("e.force:createRecord");

        createRecordEvent.setParams({ 
            "entityApiName": "Task",
            "recordTypeId": "01250000000NBiq",
            /*"navigationLocation":"LOOKUP",*/
            "defaultFieldValues": {
                'WhatId': component.get('v.recordId'),
                'ActivityDate': $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"),
                'Subject': 'Account Management Document',
                'Status': 'Completed'
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
    }
})
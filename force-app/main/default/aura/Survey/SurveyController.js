({
    doInit : function(component, event, helper){
        var myAction = component.get("c.isSurveyUser");
        myAction.setCallback(this, function(response) { 
            if(response.getState() === "SUCCESS") {
                if(response.getReturnValue()){
                    component.set("v.isSurveyUser", response.getReturnValue()); 
                }
                else{
                    $A.get("e.force:closeQuickAction").fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Sorry',
                        message: $A.get("$Label.c.Survey_Access_Message"),
                        messageTemplate: 'Record {0} created! See it {1}!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'info',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }
            }
            
        });
        $A.enqueueAction(myAction); 
    },
    
    closeEvt : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})
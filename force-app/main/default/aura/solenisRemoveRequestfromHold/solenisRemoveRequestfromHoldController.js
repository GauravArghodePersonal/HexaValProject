({
	doInit : function(component, event, helper) {
        component.set("v.Spinner", true);
        
        var action = component.get("c.RemoveRequestfromHoldLTD");
        action.setParams({
            SampleRequestId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();      
            if (state === "SUCCESS") {
                component.set("v.Spinner", false);
                $A.get("e.force:closeQuickAction").fire();
				 $A.get('e.force:refreshView').fire();  
                
            }
         });
        $A.enqueueAction(action);
    }     
})
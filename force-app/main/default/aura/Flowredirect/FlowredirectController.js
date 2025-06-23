({
	myAction : function(component, event, helper) {
		
	},
    init : function(component,event,helper)
    {
        console.log('Inside Init');
        var navEvt= $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId":component.get("v.recId"),
            "slideDevName":"related"
        
        } );
        console.log('Before Fire');
        navEvt.fire();
        console.log('After Init');
        
    }
})
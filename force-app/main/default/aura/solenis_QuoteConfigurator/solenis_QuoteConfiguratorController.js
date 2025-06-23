({
	doInit : function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
   		dismissActionPanel.fire();
        helper.openSubtab(component, event, helper);
	}
})
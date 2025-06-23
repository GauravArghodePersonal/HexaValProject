({
   /* doInit: function(component, event, helper) {
        var nagigateLightning = component.find('navigate');
        var pageReference = {    
            "type": "standard__component",
            "attributes": {
                componentName: "c__Solenis_Comercial_CallReport"    
            },    
            "state": {
                c__recordId : component.get("v.recordId")    
            }
        }
        nagigateLightning.navigate(pageReference);
    } */
    
        closeQA : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})
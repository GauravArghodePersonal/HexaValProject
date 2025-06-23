/**
 * Created by ricardo on 12/3/20.
 */

({
    init : function(component, event, helper) {

        const recordId = component.get("v.recordId");
        window.open("/apex/printqrcode?id=" + recordId);
        $A.get("e.force:closeQuickAction").fire();
    }
});
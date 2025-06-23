({
	openSubtab: function(component, event, helper) {
        var workspaceAPI = component.find("Workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {     
            workspaceAPI.openSubtab({
                parentTabId: response.tabId,
                url: '/apex/Quote_Configurator_For_Console?aId='+response.recordId,
                focus: true
            }).then(function(subtabId) {
                console.log("The new subtab ID is:" + subtabId);
            }).catch(function(error) {
                console.log("error",error);
            });
        });
    }
})
({
    doInit: function(component, event, helper) {
        if(component.get("v.recordId") != null) {
            component.set("v.modalTitle", "Edit Forecast Pro");
        }
        //component.set("v.numberOfRows", 1);
    },
    
    addNewRow: function(component, event, helper) {
        const arrayNumberofRows = component.get("v.numberOfRows");
        arrayNumberofRows.push(component.get("v.numberOfRows").length + 1);
        component.set("v.numberOfRows", arrayNumberofRows);
    },
    
   closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   },
    
    closeFocusedTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.isConsoleNavigation().then(function(isConsoleApp) {
            if(isConsoleApp) {
                workspaceAPI.getFocusedTabInfo().then(function(focusedTabInfo) {
                    var focusedTabId = focusedTabInfo.tabId;
                    workspaceAPI.closeTab({tabId: focusedTabId});
                })
                .catch(function(error) {
                    console.log(error);
                });
            } else {
                
            }
        })
        .catch(function(error) {
            console.log(error);
        });
        
    }
})
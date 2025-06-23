public class PendingApprovalsController {

    //public static final String OBJ_NAME_PARAM = 'type';
    
    List<SelectOption> optionList;
    
    public PendingApprovalsController() {
    	getObjectSelectionList();
    }
    
    public String objectName {get; set;}
    
    public PageReference getPendingApprovals() {
        String nextPage = Custom_Approval_Functions.getObjectPageUrl(objectName);
        if (nextPage == null) {return null;}
        PageReference pr = new PageReference(nextPage);
        //pr.getParameters().put(OBJ_NAME_PARAM, objectName);
        pr.setRedirect(true);
        return pr;
    }
    
    public Boolean renderObjectSelectionList {
    	get {
    		getObjectSelectionList();
            return (optionList != null && !optionList.isEmpty());
    	}
    }

    public List<SelectOption> getObjectSelectionList() {
    	if (optionList == null) {
            optionList = Custom_Approval_Functions.getObjectSelectionList();
    	}
        return optionList;
    }

    public PageReference pageAction() {
    	PageReference pr = null;
    	getObjectSelectionList();
    	if (optionList != null && optionList.size() == 1) {
    		objectName = optionList[0].getValue();
    		pr = getPendingApprovals();
    	}
        return pr;
    }

/*
 **********************************************************
 Test Methods are in Custom_Approval_Functions_Test class
 ********************************************************** 
 */    
    
}
/**
 * @description factory class to set permisison set according to persona
 */
@isTest
public class CQ_SL_Test_Persona_Factory {
    public static final String PROFILE_TYPE_CUSTOMER_ADMIN = 'CQ_System_Administrator';
    public static final String PROFILE_TYPE_CUSTOMER = 'CQ_Standard_User';
    public static final String PROFILE_TYPE_CHANGE_ORDER_OWNER = 'CQ_Change_Order_Owner';
    public static final String PROFILE_TYPE_CHANGE_ORDER_SUBMITTER = 'CQ_Change_Order_Submitter';
    public static final String PROFILE_TYPE_CHANGE_ORDER_APPROVER = 'CQ_Change_Order_Approver';
    public static final String PROFILE_TYPE_CHANGE_ORDER_ADMIN = 'CQ_Change_Admin';
    
    public static final String PERMISSION_SET_DOCUMENT_ADMIN = 'CQ_Document_Admin_PS';
    public static final String PERMISSION_SET_SS_CHANGE_ORDER = 'CQ_SS_Change_Order_Permission';

    /**
     * @description This method returns the permission set based on the name of the permission set
     * @param permissionSetName name of the permission set
     * @return returns permission set.
     */
    public static List<PermissionSet> getPermissionSet(String permissionSetName){
        return [SELECT Id FROM PermissionSet WHERE Name =: permissionSetName];
    }
    
    /**
     * @description This method adds the given custom permission to permission set
     * @param permissionSetName api name of the permission set
     * @param customPermissionDeveloperName api name of the custom permission
     */
    public static void addPermissionToPermissionSet(String permissionSetName, String customPermissionDeveloperName){
        
        //get the Id of the permission set with the name as supplied in method argument
        List<PermissionSet> ps = getPermissionSet(permissionSetName);
        if(ps.size() > 0){
            
            //Create the Setup Entity Access
            SetupEntityAccess sea = new SetupEntityAccess();
            sea.ParentId = ps[0].Id;
            sea.SetupEntityId = getCustomPermissionByDeveloperName(new List<String>{customPermissionDeveloperName})[0].Id;
            insert sea;
        }
    }
    
    /**
     * @description this method is to remove custom permission from permissionset
     * @param permissionSetName permission set where custom permission is to be added
     * @param customPermissionDeveloperName name of custom permission
     */
    public static void removePermissionFromPermissionSet(String permissionSetName, String customPermissionDeveloperName){
        List<PermissionSet> ps = getPermissionSet(permissionSetName);
        SetupEntityAccess sea = [SELECT Id FROM SetupEntityAccess WHERE ParentId =: ps[0].Id AND SetupEntityId =:getCustomPermissionByDeveloperName(new List<String>{customPermissionDeveloperName})[0].Id];
        delete sea;
    }

    /**
    * @description This method returns the list of custom permission based on the developer names
    * @param customPermissionDeveloperName list of names of custom permission api name
    * @return returns list of custom permission.
    */
    public static List<CustomPermission> getCustomPermissionByDeveloperName(List<String> customPermissionDeveloperName){
        return [SELECT Id FROM CustomPermission WHERE DeveloperName IN: customPermissionDeveloperName];
    }
    
    /**
     * @description This method creates new permission set with unique name for unit tests and assigns provided custom permission
     * @param customPermissionDeveloperName is the developer name of the custom permission to assign to the new permission set
     * @return new permission set record created for unit tests purpose with provided custom permission
     */
    public static PermissionSet createPermissionSetWithCustomPermission(String customPermissionDeveloperName) {
        // create new permission set for unit tests to assign provided custom permission
        integer randomNumber = (Integer) (Math.random() * 1000000);
        String uniquePermSetName = 'SQXTestPermSet' + System.now().getTime() + randomNumber;
        PermissionSet ps = new PermissionSet(
            Name = uniquePermSetName,
            Label = uniquePermSetName
        );
        insert ps;
        
        //Create the Setup Entity Access
        SetupEntityAccess sea = new SetupEntityAccess();
        sea.ParentId = ps.Id;
        sea.SetupEntityId = getCustomPermissionByDeveloperName(new List<String>{customPermissionDeveloperName})[0].Id;
        insert sea;
        
        return ps;
    }
    
    /**
     * @description This method assigns provided custom permission to provided user through new permission set for unit tests
     * @param user is the User to assign provided custom permission
     * @param customPermissionDeveloperName is the developer name of the custom permission to assign to the provided user
     * @return new permission set record created for unit tests purpose with provided custom permission
     */
    public static PermissionSet createAndAssignPermissionSetWithCustomPermission(User user, String customPermissionDeveloperName) {
        // create new permission set for unit tests with provided custom permission
        PermissionSet ps = createPermissionSetWithCustomPermission(customPermissionDeveloperName);
        
        // assign new permission set that has provided custom permission to the test user
        assignPermissionSet(user, ps);
        
        return ps;
    }

    /**
     * @description This method assigns given permission set to user
     * @param usr will have the permSetName permission set assigned
     * @param permSetName is the name of the permission set
     */
    public static void assignPermissionSet(User usr, String permSetName){
        PermissionSet permSet = [SELECT Id,Name from PermissionSet Where Name = :permSetName];
        assignPermissionSet(usr, permSet);
    }
    
    /**
     * @description This method assigns given permission set to user
     * @param user is the User to assign provided permission set
     * @param permSet is provided permission set to assign
     */
    public static void assignPermissionSet(User user, PermissionSet permSet){
        PermissionSetAssignment permSetAssignment = new PermissionSetAssignment(AssigneeId = user.Id, PermissionSetId = permSet.Id);
        insert permSetAssignment;
    }
}
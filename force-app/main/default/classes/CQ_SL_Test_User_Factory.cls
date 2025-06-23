/**
 * @description test factory class to create users
 */
@isTest
public class CQ_SL_Test_User_Factory implements CQ_SL_Test_SObject_Factory {
    
    /**
     * @description method with data code to create the record
     * @param dataCode code to define which type of record to create
     * @return map of data code to type of user
     */
    public Map<String, SObject> constructData(String dataCode){
        switch on dataCode{
            when 'users-adminandstandard' { return createUserWithProfileStandardAndAdmin(); }
            when 'co-standard-actionAssignee' { return createUserWithProfileTypeStandardAndPermissionForCO(); }
            when else { System.assert(false, 'Record not found in data library for key ' + dataCode); }
        }
        return new Map<String, SObject>();
    }
    
    /**
     * @description method to create user with standard and admin profile
     * Data Tree:
     * ----------
     * User 1 (Admin)
     * 		Contact (null)
     * 		Permission set name (PROFILE_TYPE_CUSTOMER_ADMIN -> CQ_System_Administrator)
     * 
     * User 2 (Standard)
     * 		Contact (null)
     * 		Permission set name (PROFILE_TYPE_CUSTOMER -> CQ_Standard_User)
     * 
     * User 3 (Standard)
     * 		Contact (null)
     * 		Permission set name (PROFILE_TYPE_CUSTOMER -> CQ_Standard_User)
     * 
     * User 4 (Standard)
     * 		Contact (null)
     * 		Permission set name (PROFILE_TYPE_CUSTOMER -> CQ_Standard_User)
     * @return map of users
     */
    public Map<String, SObject> createUserWithProfileStandardAndAdmin(){
        integer adminIdentifier = (Integer)(Math.random() * 1000000);
        String [] permissionSetNames = new List<String>{
            CQ_SL_Test_Persona_Factory.PROFILE_TYPE_CUSTOMER_ADMIN,
            CQ_SL_Test_Persona_Factory.PROFILE_TYPE_CUSTOMER
        };
        Map<String, Id> profileIdsByName = new Map<String, Id>();
        
        UserRole role = new UserRole (Name = 'CEO' + 'USR-000001');
        insert role;
        
        for(Profile prof : [SELECT Id, Name FROM Profile WHERE Name =: 'System Administrator' OR Name =: 'Standard User']){
            profileIdsByName.put(prof.Name, prof.Id);
        }
        
        User adminUser = new User();
        adminUser.Username = 'a' + adminIdentifier + '@test' + adminIdentifier +'.com';
        adminUser.Email = 'a' + adminIdentifier + '@test' + adminIdentifier + '.com';
        adminUser.FirstName = 'Admin User 1';
        adminUser.LastName = 'a' + adminIdentifier;
        adminUser.CommunityNickname = 's' + adminIdentifier;
        adminUser.ProfileId = profileIdsByName.get('System Administrator');
        
        adminUser.Alias =  '' + adminIdentifier;
        adminUser.EmailEncodingKey = 'UTF-8';
        adminUser.LanguageLocaleKey = 'en_US';
        adminUser.LocaleSidKey = 'en_US';
        adminUser.TimeZoneSidKey = 'America/Los_Angeles';
        adminUser.AboutMe = 'CQ_System_Administrator:'+'Admin user 1';
        adminUser.UserRoleId = role.Id;
        
        List<User> userList = new List<User>();
        userList.add(adminUser);
        for(integer i=0; i<3; i++) {
            User standardUser = new User();
            Integer standardIdentifier = (Integer)( Math.random() * 1000000 );
            standardUser.Username =  'a' + standardIdentifier + '@test' + standardIdentifier + '.com';
            standardUser.Email = 'a'+ standardIdentifier + '@test' + standardIdentifier + '.com';
            standardUser.FirstName = 'Standard User '+ (i+1);
            standardUser.LastName = 'a' + standardIdentifier;
            standardUser.CommunityNickname = 's' + standardIdentifier;
            standardUser.ProfileId = profileIdsByName.get('Standard User');
            standardUser.Alias =  '' + standardIdentifier;
            standardUser.EmailEncodingKey = 'UTF-8';
            standardUser.LanguageLocaleKey = 'en_US';
            standardUser.LocaleSidKey = 'en_US';
            standardUser.TimeZoneSidKey = 'America/Los_Angeles';
            standardUser.AboutMe = 'CQ_Standard_User:'+'Admin user 1';
            standardUser.UserRoleId = role.Id;
            userList.add(standardUser);
        }

        insert userList;
        
        Map<String, Id> permissionSetsByName  = new Map<String, Id>();
        for(PermissionSet permissionSet : [SELECT ID, Name FROM PermissionSet WHERE Name IN : permissionSetNames ]){
            permissionSetsByName.put(permissionSet.Name, permissionSet.Id);
        }

        PermissionSetAssignment[] assignments = new List<PermissionSetAssignment>();

        if(permissionSetsByName.containsKey(CQ_SL_Test_Persona_Factory.PROFILE_TYPE_CUSTOMER_ADMIN)) {
            PermissionSetAssignment  assignPermissionSet =  new PermissionSetAssignment(AssigneeId=adminUser.Id, PermissionSetId = permissionSetsByName.get(CQ_SL_Test_Persona_Factory.PROFILE_TYPE_CUSTOMER_ADMIN));
            assignments.add(assignPermissionSet);
        }


        if(permissionSetsByName.containsKey(CQ_SL_Test_Persona_Factory.PROFILE_TYPE_CUSTOMER)) {
            assignments.add(new PermissionSetAssignment(AssigneeId = userList[1].Id, PermissionSetId = permissionSetsByName.get(CQ_SL_Test_Persona_Factory.PROFILE_TYPE_CUSTOMER)));
            assignments.add(new PermissionSetAssignment(AssigneeId = userList[2].Id, PermissionSetId = permissionSetsByName.get(CQ_SL_Test_Persona_Factory.PROFILE_TYPE_CUSTOMER)));
            assignments.add(new PermissionSetAssignment(AssigneeId = userList[3].Id, PermissionSetId = permissionSetsByName.get(CQ_SL_Test_Persona_Factory.PROFILE_TYPE_CUSTOMER)));

        }

        
        if(assignments.size() > 0){
            insert assignments;
    
        }
        
        return new Map<String, SObject> {
            'Admin User 1' => userList[0],
            'Standard User 1' => userList[1],
            'Standard User 2' => userList[2],
            'Standard User 3' => userList[3]
        };
    }
    
    /**
     * @description method to create user with standard profile and assign permission sets
     * Data Tree:
     * --------
     * User 1 (Standard User)
     *    Contact (null)
     *   
     * @return map of users
     */
    public Map<String,SObject> createUserWithProfileTypeStandardAndPermissionForCO(){
        
        Integer standardIdentifier = (Integer)( Math.random() * 1000000 );
        String [] permissionSetNames = new List<String> {
            CQ_SL_Test_Persona_Factory.PROFILE_TYPE_CUSTOMER,
            CQ_SL_Test_Persona_Factory.PROFILE_TYPE_CHANGE_ORDER_OWNER,'CQ_Document_Owner_PS','CQ_Document_Admin_PS','CQ_System_Administrator','CQ_Document_Approver_PS','CQ_Document_Binder_Editor_PS',
                'CQ_Document_Binder_Viewer_PS','CQ_Document_Viewer_PS'
        };
        Map<String, Id> profileIdsByName = new Map<String, Id>();

        UserRole role  = new UserRole(Name = 'CEO' +'USR-000003');
        insert role;
        
        for(Profile prof : [SELECT ID, Name FROM Profile WHERE Name = : 'Standard User']) {
            profileIdsByName.put(prof.Name, prof.Id);
        }

        User standardUser = new User();
        standardUser.Username =  'a' + standardIdentifier + '@test' + standardIdentifier + '.com';
        standardUser.Email = 'a' + standardIdentifier + '@test' + standardIdentifier + '.com';
        standardUser.FirstName = 'Standard User 1';
        standardUser.LastName = 'a' + standardIdentifier;
        standardUser.CommunityNickname = 's' + standardIdentifier;
        standardUser.ProfileId = profileIdsByName.get('Standard User');
        
        standardUser.Alias =  '' + standardIdentifier;
        standardUser.EmailEncodingKey = 'UTF-8';
        standardUser.LanguageLocaleKey = 'en_US';
        standardUser.LocaleSidKey = 'en_US';
        standardUser.TimeZoneSidKey = 'America/Los_Angeles';
        standardUser.AboutMe = 'CQ_Standard_User:'+'Standard User 1';
        standardUser.UserRoleId = role.Id;

        insert standardUser;

        Map<String, Id> permissionSetsByName  = new Map<String, Id>();
        for(PermissionSet permissionSet : [SELECT ID, Name FROM PermissionSet WHERE Name IN : permissionSetNames ]){
            permissionSetsByName.put(permissionSet.Name, permissionSet.Id);
        }

        List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>();
        List<PermissionSet> permissionSets = [SELECT Id FROM PermissionSet WHERE Name IN: permissionSetNames];

        for(PermissionSet ps  : permissionSets){
            PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId=standardUser.Id, PermissionSetId=ps.Id);
            assignments.add(psa);
        }

        if(assignments.size() > 0){
            insert assignments;
    
        }
        
        return new Map<String, SObject> {
            'Complaint Std Assignee' => standardUser
        };
    }
}
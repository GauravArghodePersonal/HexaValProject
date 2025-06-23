/**
 * Created by ricardo on 11/18/20.
 */

public with sharing class Chemical_Container_Trigger_Util {

    private static Set<Id> recursiveIds;

    static {
        recursiveIds = new Set<Id>();
    }

    static Boolean executedSetProductNameWOPackage = false;
    static Boolean executedSetDefaultSiteEngineer = false;
    static Boolean executedPreventNonAdminsToUpdate = false;


    public static void preventNonAdminUserInsertion(List<Chemical_Container__c> newContainers) {
        if(!isUserContainerAdmin()) {
            for (Chemical_Container__c container : newContainers) {
                container.addError('You have to be Chemical Container Admin in order to create these type of records');
            }
        }
    }

    public static void setProductNameWOPackage(List<Chemical_Container__c> newContainers) {
        if(Trigger.isUpdate && (executedSetProductNameWOPackage || Chemical_Inventory_Trigger_Util.executedFromInventoryTrigger)) {
            return;
        }
        logContext(1);

        Map<Id, Material_Sales_Data2__c> materialsById = getMaterialsById(newContainers);
        updateProductName(newContainers, materialsById);
        executedSetProductNameWOPackage = true;
    }

    public static void setDefaultSiteEngineer(List<Chemical_Container__c> newContainers) {
        if(Trigger.isUpdate && (executedSetDefaultSiteEngineer || Chemical_Inventory_Trigger_Util.executedFromInventoryTrigger)) {
            return;
        }
        logContext(2);

        List<Chemical_Container__c> containersWithOutEngineer = new List<Chemical_Container__c>();
        for (Chemical_Container__c container : newContainers) {
            if(container.Site_Engineer__c == null) {
                containersWithOutEngineer.add(container);
            }
        }

        if(!containersWithOutEngineer.isEmpty()) {
            Map<Id, Account> accountsById = getAccountsById(containersWithOutEngineer);

            for(Chemical_Container__c container : containersWithOutEngineer){
                if(!accountsById.isEmpty() && accountsById.containsKey(container.Account__c)) {
                    container.Site_Engineer__c = accountsById.get(container.Account__c).OwnerId;
                }
            }
        }

        executedSetDefaultSiteEngineer = true;
    }

    public static void preventNonAdminsToUpdate(List<Chemical_Container__c> newList, Map<Id, Chemical_Container__c> oldMap) {
        if(Trigger.isUpdate && (executedPreventNonAdminsToUpdate || Chemical_Inventory_Trigger_Util.executedFromInventoryTrigger)) {
            return;
        }
        logContext(3);

        if(!isUserContainerAdmin()) {

            for (Chemical_Container__c newContainer : newList) {
                Chemical_Container__c oldContainer = oldMap.get(newContainer.Id);
                List<String> fieldsChanged = new List<String>();

                for (String fieldName : getFieldNameList()) {

                    Object newValue = newContainer.get(fieldName);
                    Object oldValue = oldContainer.get(fieldName);
                    Boolean valueChanged = false;

                    if(newValue == null && oldValue == null) {
                        valueChanged = false;
                    } else if(newValue != null && oldValue == null)  {
                        valueChanged = true;
                    } else if(newValue == null && oldValue != null)  {
                        valueChanged = true;
                    } else if(!newValue.equals(oldValue))  {
                        valueChanged = true;
                    }

                    if (valueChanged) {
                        fieldsChanged.add(fieldName);
                    }
                }

                if (!fieldsChanged.isEmpty()) {
                    String fieldsAsString = getCSVFromList(fieldsChanged);
                    newContainer.addError('You have to be a Chemical Container Admin in order to change these fields: ' + fieldsAsString);
                }
            }
        }

        executedPreventNonAdminsToUpdate = true;
    }

    public static void preventNonAdminsToDelete(List<Chemical_Container__c> containers) {
        if(!isUserContainerAdmin()) {
            for (Chemical_Container__c container : containers) {
                container.addError('You have to be Chemical Container Admin in order to Delete these type of records');
            }
        }
    }

    private static Boolean isUserContainerAdmin() {
        User currentUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
        String userProfile = currentUser.Profile.Name;

        if(userProfile == 'System Administrator' || userProfile == 'System Administrator - SSO Enabled') {
            return true;
        }

        Set<Id> usersIdAdminPS = userIdsInPermissionSet();

        return usersIdAdminPS.contains(currentUser.Id);
    }

    private static Set<Id> userIdsInPermissionSet() {
        Set<Id> userIds = new Set<Id>();

        List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>([
                SELECT Id, PermissionSetId, PermissionSet.Name, PermissionSet.ProfileId,
                        PermissionSet.Profile.Name, AssigneeId, Assignee.Name
                FROM PermissionSetAssignment
                WHERE PermissionSet.Name = 'Chemical_Container_Admin_Permission'
        ]);

        for (PermissionSetAssignment assignment : assignments) {
            userIds.add(assignment.AssigneeId);
        }

        return userIds;
    }
    
    private static String getCSVFromList(List<String> strings) {
        String fields = '';

        for (String field : strings) {
            fields += field + ', ';
        }

        fields = fields.removeEnd(', ');

        return fields;
    }

    private static List<String> getFieldNameList() {
        List<String> fieldNames = new List<String>();

        List<Schema.FieldSetMember> fieldSetMembers = SObjectType.Chemical_Container__c.FieldSets.Container_Not_Editable_Fields.getFields();

        for (FieldSetMember setMember : fieldSetMembers) {
            fieldNames.add(setMember.getFieldPath());
        }

        return fieldNames;
    }

    private static Map<Id, Material_Sales_Data2__c> getMaterialsById(List<Chemical_Container__c> containers) {
        Set<Id> materialIds = new Set<Id>();

        for (Chemical_Container__c container : containers) {
            if(container.Material__c == null) {
                continue;
            }

            materialIds.add(container.Material__c );
        }


        Map<Id, Material_Sales_Data2__c> materialsById = new Map<Id, Material_Sales_Data2__c>();

        if(!materialIds.isEmpty()) {
            materialsById = new Map<Id, Material_Sales_Data2__c>([
                    SELECT Id, Name
                    FROM Material_Sales_Data2__c
                    WHERE Id IN :materialIds
            ]);
        }

        return materialsById;
    }

    private static void updateProductName(List<Chemical_Container__c> newContainers, Map<Id, Material_Sales_Data2__c> materialsById) {

        for (Chemical_Container__c container : newContainers) {
            if(container.Material__c == null) {
                container.Product_Name_wo_Package__c = null;
                continue;
            }

            if(!materialsById.isEmpty() && container.Material__c != null && materialsById.containsKey(container.Material__c)) {
                String materialFullName = materialsById.get(container.Material__c).Name;
                container.Product_Name_wo_Package__c = parseName(materialFullName);
            }
        }
    }

    public static String parseName(String materialFullName) {

        String result = materialFullName;
        List<String> packageKeywords = new List<String> {' IBC', ' DRUM' , ' BULK', ' BAG', ' PAIL', ' SSK', ' BOTTLE', ' FLEXITANK', ' DR400', ' BOX'};

        for (String keyword : packageKeywords) {
            if(materialFullName.contains(keyword)) {
                result = materialFullName.split(keyword)[0];
                break;
            }
        }

        return result;
    }

    private static Map<Id, Account> getAccountsById(List<Chemical_Container__c> containers) {
        Set<Id> accountsIds = new Set<Id>();

        for (Chemical_Container__c container : containers) {
            if(container.Account__c == null) {
                continue;
            }

            accountsIds.add(container.Account__c);
        }

        return new Map<Id, Account>([
                SELECT Id, OwnerId
                FROM Account
                WHERE Id IN :accountsIds
        ]);
    }

    private static void logContext(Integer order) {
        String context = (Trigger.isBefore ? 'BEFORE' : 'AFTER') + ' ' +  (Trigger.isInsert ? 'INSERT' : 'UPDATE');
        System.debug('---> Container: ' + order +' : ' + context);
    }
}
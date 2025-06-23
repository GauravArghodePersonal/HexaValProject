public with sharing class ProfileMethods {

    public static Profile retrieveWithId(Id id) {
        Profile result = null;
        try {
            result = [
                      SELECT Id, Name, Description, UserLicenseId, UserType, 
                             (SELECT Id, Name, ProfileId, Profile.Name, UserRoleId, UserRole.Name, isActive FROM Users)
                        FROM Profile 
                       WHERE Id = :id
                     ];
        }
        catch (Exception e) {}
        return result;
    }
    
    public static Profile retrieveWithName(String name) {
        Profile result = null;
        try {
            result = [
                      SELECT Id, Name, Description, UserLicenseId, UserType, 
                             (SELECT Id, Name, ProfileId, Profile.Name, UserRoleId, UserRole.Name, isActive FROM Users)
                        FROM Profile 
                       WHERE Name = :name
                     ];
        }
        catch (Exception e) {}
        return result;
    }
}
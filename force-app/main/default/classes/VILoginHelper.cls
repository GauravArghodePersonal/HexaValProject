global class VILoginHelper {
    webservice static String getPortalType(String username) {
        String portalType = 'None';

        List<User> users = [
            SELECT Id, UserRole.PortalType
            FROM User
            WHERE Username = :username
            AND UserRoleId != NULL
            AND IsActive = TRUE];

        if (!users.isEmpty()) {
            portalType = users.get(0).UserRole.PortalType;
        }

        return portalType;
    }
}
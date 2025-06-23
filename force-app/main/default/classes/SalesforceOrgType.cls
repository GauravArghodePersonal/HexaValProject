public with sharing class SalesforceOrgType {
    public static final String ORGTYPE_PROD = 'PROD';
    public static final String ORGTYPE_SANDBOX = 'SANDBOX';
    public static final String ORGLOCATION_NORTHAMERICA = 'NORTH AMERICA';
    public static final String ORGLOCATION_APAC = 'APAC';
    public static final String ORGLOCATION_EMEA = 'EMEA';
    public static final String ORGLOCATION_SANDBOX = 'SANDBOX';

    public static String instanceServerOverride = '';

    public static String determineOrgInstance() {
        String result = 'UNKNOWN'; User user;

        if (isProd(retrieveInstanceServer())) {
            result = 'PROD';
        }
        else {
            try {
                user = [SELECT UserName FROM User WHERE UserName LIKE '%.com.%' ORDER BY CreatedDate LIMIT 1];
            } catch(Exception e) {return result;}

            List<String> nameParts = user.UserName.split('[.]');
            if (nameParts.size() > 0) {
                String orgName = nameParts[nameParts.size() - 1];
                result = orgName.toUpperCase();
            }
        }

        return result;
    }

    public static String retrieveInstanceServer() {
        String result = 'UNKNOWN';

        if (String.isEmpty(instanceServerOverride)) {
            String host = URL.getSalesforceBaseUrl().getHost();
            List<String> hostParts = host.split('[.]');
            if (hostParts.size() > 0) {
                result = hostParts[0];
            }
        }
        else {
            result = instanceServerOverride;
        }
        return result;
    }

    public static Boolean isProd(String instanceServer) {
        return (determineOrgType(instanceServer) == ORGTYPE_PROD);
    }

    public static Boolean isSandbox(String instanceServer) {
        return (determineOrgType(instanceServer) == ORGTYPE_SANDBOX);
    }

    public static String determineOrgType(String instanceServer) {
        String result = 'UNKNOWN';
        if (
            instanceServer.left(2).toUpperCase() == 'NA' ||
            instanceServer.left(2).toUpperCase() == 'AP' ||
            instanceServer.left(2).toUpperCase() == 'EU'
           ) {
            result = ORGTYPE_PROD;
        }

        if (instanceServer.left(2).toUpperCase() == 'CS') {
            result = ORGTYPE_SANDBOX;
        }

        return result;
    }

    public static String determineOrgLocation(String instanceServer) {
        String result = 'UNKNOWN';
        if (instanceServer.left(2).toUpperCase() == 'NA') {
            result = ORGLOCATION_NORTHAMERICA;
        }
        if (instanceServer.left(2).toUpperCase() == 'AP') {
            result = ORGLOCATION_APAC;
        }
        if (instanceServer.left(2).toUpperCase() == 'EU') {
            result = ORGLOCATION_EMEA;
        }
        if (instanceServer.left(2).toUpperCase() == 'CS') {
            result = ORGLOCATION_SANDBOX;
        }

        return result;
    }
}
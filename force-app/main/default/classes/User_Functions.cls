public class User_Functions {

  private static final String SYSADMIN = 'System Admin';

  private static final String CA_T3_SUPPORT = 'CA Team - Tier 3 Support';

  private static final String SYSADM_USERNAME = 'solenissfdcsupport@solenis.com';

  private static final Set<String> INTRANET_IP_SET;

  static {
    INTRANET_IP_SET = new Set<String>();
    OrgSettings__c orgs = OrgSettings__c.getInstance();
    String CRNL = '\r\n', ips = '162.128.69.140';
    if (orgs != null) {ips = orgs.Internet_Facing_IP_Set__c;}
    List<String> iplist = ips.split(CRNL);
    INTRANET_IP_SET.addAll(iplist); debug('INTRANET_IP_SET : ' + INTRANET_IP_SET);
  }

  private static String loggedInUserProfileName = null;

  private static void debug(String s) {
    System.debug(LoggingLevel.INFO, '>>>>>>>>> ' + s);
  }

  public static String RetrieveUserName(String id) {
    String result = '';

    try {
        User user = [SELECT Name FROM User WHERE Id = :id];
        result = user.Name;
        } catch (Exception e) {}
    return result;
  }

  public static String RetrieveUserName(Id id) {
    String result = '';

    try {
        User user = [SELECT Name FROM User WHERE Id = :id];
        result = user.Name;
        } catch (Exception e) {}
    return result;
  }

  public static String LookupProfileId(String profileName) {
    String profileId = '';
    if (profileName != null)
    {
        profileId = [SELECT Id FROM profile WHERE name=:profileName].Id;
    }

    return profileId;
  }

  public static Id LookupActiveUserbyFullName(String fullName) {
    Id result = null;

    try {result = [SELECT Id FROM User WHERE Name = :fullName AND IsActive = true LIMIT 1].Id;}
    catch (Exception e) {//Not Found
                        }

    return result;
  }

  public static Map<String,Id> LookupActiveUsersbyFullName(List<String> fullNames) {
    Map<String,Id> results = new Map<String,Id>();
    List<User> usersFound;

    if (fullNames != null)
      {
        try {
            usersFound = [SELECT Id, Name FROM User WHERE Name in :fullNames AND IsActive = true];
            for(User userFound:usersFound)
                {
                results.put(userFound.Name,userFound.Id);
                }
            }
        catch (Exception e) {//Not Found
                            }
      }

    return results;
  }


  public static Id LookupInactiveUserbyFullName(String fullName) {
    Id result = null;

    try {result = [SELECT Id FROM User WHERE Name = :fullName AND IsActive = false LIMIT 1].Id;}
    catch (Exception e) {//Not Found
                        }

    return result;
  }

  public static Id LookupUserbyFullName(String fullName) {
    Id result = null;

    try {result = [SELECT Id FROM User WHERE Name = :fullName LIMIT 1].Id;}
    catch (Exception e) {//Not Found
                        }

    return result;
  }

  public static String getLoggedInUserEmail() {
    String result = getUserEmail(UserInfo.getUserId());
    return result;
  }

  public static String getUserEmail(String id) {
    String result = '';
    try {
        User user = [SELECT Email FROM User WHERE Id = :id];
        result = user.Email;
    } catch (Exception e) {
        System.debug(e.getMessage());
    }
    return result;
  }

    public static String getUserProfile(String usrId) {
        User u; Profile p; String s = '';
        try {
            u = [select Id, ProfileId from User where Id = :usrId];
            p = [select Name from Profile where Id = :u.ProfileId];
            s = p.Name;
        } catch(Exception e) {}
        return s;
    }

    public static User getLoggedInUser() {
        String userId = UserInfo.getUserId();
        User usr = [select Id, Email, FirstName, LastName, Name,
                        Sample_Center__c
                    from User where Id = :userId];
        return usr;
    }

    public static String getLoggedInUserProfileName() {
        if (loggedInUserProfileName == null) {
            String pid = UserInfo.getProfileId();
            if (pid != null) {
                List<profile> pl = [select name from profile where id = :pid];
                if (pl != null && pl.size() > 0) {
                    loggedInUserProfileName = pl[0].Name;
                }
            }
        }
        //System.debug('User Profile Name : '+loggedInUserProfileName);
        return loggedInUserProfileName;
    }

    public static String getSysAdminEmail() {
        String s = null;
        List<User> ulist = [Select Id, Name, Email from User
                             where Username = :SYSADM_USERNAME];
        if (!ulist.isEmpty()) {s = ulist[0].Email;}
        return s;
    }

    public static boolean isSysAdmin() {
        loggedInUserProfileName = getLoggedInUserProfileName();
        if (loggedInUserProfileName != null) {
            return loggedInUserProfileName.startsWith(SYSADMIN);
        }
        return false;
    }

    public static boolean isSupport() {
        loggedInUserProfileName = getLoggedInUserProfileName();
        if (loggedInUserProfileName != null) {
            return loggedInUserProfileName.equalsIgnoreCase(CA_T3_SUPPORT);
        }
        return false;
    }

    public static String getUserIPAddress() {
        Map<String, String> hmap = new Map<String, String>();
        PageReference currentPage = ApexPages.currentPage();
        if (currentPage != null) {hmap = currentPage.getHeaders();}
        debug('headerInfo : ' + hmap);
        return hmap.get('X-Salesforce-SIP');
    }

    public static Boolean isIntranetIP() {
        String userIP = getUserIPAddress();
        return isIntranetIP(userIP);
    }

    public static Boolean isIntranetIP(String userIP) {
        debug('userIP = ' + userIP);
        return (userIP != null && INTRANET_IP_SET.contains(userIP));
    }
//The End
}
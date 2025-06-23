public without sharing class VIUtils {
    public static final String NONE = '--None--';

    public static final String PARAM_NAME_DEBUG = 'debug';
    public static final String PARAM_FACILITY_ID = 'facilityId';
    public static final String PARAM_ID = 'id';

    public static final String URL_HOME       = '/home/home.jsp';
    public static final String URL_LOGOUT     = '/secur/logout.jsp';

    public static final String URL_VIHOME     = '/apex/VIPortalHomePage';
    public static final String URL_FACILITIES = '/apex/VIFacilityList2?id=';
    public static final String URL_LOCATIONS  = '/apex/VILocationList2?facilityId=';
    public static final String URL_PROMOTIONS = '/apex/VIAvailablePromotions2?id=';

    public static final String PORTAL_TYPE_PARTNER = 'Partner';
    public static final String PORTAL_TYPE_CUSTOMER = 'CustomerPortal';

    public static final String PARTNER_PORTAL_NAME = 'VI - Partner Portal';
    public static final String CUSTOMER_PORTAL_NAME = 'VI - Customer Portal';

    public static final String VI_DISTCHAN_CODE = '40';

    public static final String ACCOUNT_RECORD_TYPE_PROSPECT = 'Valvoline DIFM Prospect';

    public static final String ACCOUNT_TYPE_DISTRIBUTOR = 'Distributor';
    public static final String ACCOUNT_TYPE_FACILITY = 'Facility';
    public static final String ACCOUNT_TYPE_LOCATION = 'Location';

    public static final String ENROLLMENT_STATUS_SUBMITTED = 'Submitted';
    public static final String ENROLLMENT_STATUS_APPROVED = 'Approved';
    public static final String ENROLLMENT_STATUS_APPROVED_WITH_EXCEPTIONS = 'Approved with Exceptions';
    public static final String ENROLLMENT_STATUS_REJECTED = 'Rejected';

    public static final String AVI_STATUS_SUBMITTED = 'Submitted';
    public static final String AVI_STATUS_APPROVED = 'Approved';
    public static final String AVI_STATUS_REJECTED = 'Rejected';

    public static final String CHANNEL_ASC = 'ASC';
    public static final String CHANNEL_CAR_DEALER = 'Car Dealer';
    public static final String CHANNEL_QUICKLUBE = 'Quick Lube';
    public static final String CHANNEL_QUICKLUBE_EXPRESSCARE = 'Quick Lube - Express Care';

    public static final String SAP_CUST_GROUP_5_EXPRESSCARE = 'EXPRESS CARE';

    public static final String VPERKS_EARNER = 'Vperks Earner';

    public static final String[] STORE_HOURS = new String[] { NONE,
        '12:30 AM', '1:00 AM', '1:30 AM', '2:00 AM', '2:30 AM', '3:00 AM', '3:30 AM', '4:00 AM','4:30 AM','5:00 AM',
         '5:30 AM', '6:00 AM', '6:30 AM', '7:00 AM', '7:30 AM', '8:00 AM', '8:30 AM', '9:00 AM','9:30 AM',
        '10:00 AM','10:30 AM','11:00 AM','11:30 AM','12:00 PM','12:30 PM', '1:00 PM', '1:30 PM','2:00 PM','2:30 PM',
         '3:00 PM', '3:30 PM', '4:00 PM', '4:30 PM', '5:00 PM', '5:30 PM', '6:00 PM', '6:30 PM','7:00 PM','7:30 PM',
         '8:00 PM', '8:30 PM', '9:00 PM', '9:30 PM','10:00 PM','10:30 PM','11:00 PM','11:30 PM','Midnight'
    };

    public static final List<SelectOption> STORE_HOUR_SELECT_OPTIONS = new List<SelectOption>();

    public static final List<String> MATERIAL_VENDORS;
    public static final List<String> SALESORG_CODES;
    public static final String DEFAULT_SALESORG = '1000';

    public static final String ACCOUNT_QRY1 = ''
        + 'SELECT Id, ParentId, Name, Phone, Fax, Website, '
        + '               AccountNumber, BillingStreet, BillingCity, '
        + '               BillingState, BillingPostalCode, '
        + '               AVI_Certified__c, AVI_Locator_Name__c, '
        + '               Inactive_Account__c, '
        + '               SAP_Customer_Group_5_Desc__c, '
        + '               SAP_Customer_Number__c, SAP_Sales_Org__c, '
        + '               VI_Account_Type__c, VI_Channel__c '
        + '  FROM Account WHERE Inactive_Account__c = false ';

    public static final Set<String> portalTypes = new Set<String>{
        PORTAL_TYPE_CUSTOMER, PORTAL_TYPE_PARTNER
    };

    public static final Set<String> portalProfiles = new Set<String>{
        CUSTOMER_PORTAL_NAME, PARTNER_PORTAL_NAME
    };

    public static final Set<String> adminProfiles = new Set<String>{
        'CA Team - Tier 3 Support',
        'System Administrator',
        'System Administrator - SSO Enabled'
    };

    public static final Set<String> homeProfiles = new Set<String>{
        'VI - PFC Portal'
    };

    public static final Boolean PORTAL_USER_VIEW;
    public static final Boolean PROD_REFRESH_ENABLED;
    public static final Boolean SHOW_DEBUG_MSGS;

    public static final Set<Integer> AES_SET = new Set<Integer>{128, 192, 256};
    public static final String AES_128 = 'AES128'; // key must be 16 bytes and initVector must be 16 bytes
    public static final String AES_256 = 'AES256'; // key must be 32 bytes and initVector must be 16 bytes
    public static final String MD5 = 'MD5';
    public static final String SHA1 = 'SHA1';
    public static final String UTF_8 = 'UTF-8';
    public static final String LEARNSHARE_KEY;
    public static final String LEARNSHARE_URL;
    public static final String PFC_KEY;
    public static final String PFC_URL;
    public static final String QUICKSQUARE_KEY;
    public static final String QUICKSQUARE_URL;
    public static final String BIW_CRYPTO_KEY;
    public static final String BIW_INIT_VECTOR;
    public static final String BIW_SECRET_KEY;
    public static final String BIW_URL;
    public static final String BRANDMUSCLE_KEY = 'oflv0ut9e0019f35f5df2eg045c0c3ad66b1a4b9aa62e300c96ab25518bcf08406985a1e4d3e4dafaa93c7b1d1a5d0ed55962348aa0fagg79498a921c6d9rjsf122bbfc8104d5a62b5f0a9c81d5dlg9rc5908d8766918bff039b7820af58024f06663f116d92d8d60e187152fe6bd31ff325d823f6aa70c1db6a4cb0d8cd4suz';
    public static final String BRANDMUSCLE_URL;

    private static UserRole userRole;
    private static Boolean userRoleLoaded = false;

    static {
        for (String s : STORE_HOURS) {
            STORE_HOUR_SELECT_OPTIONS.add(new SelectOption(NONE.equals(s) ? '' : s, s));
        }
        VI_Portal_Settings__c vips = VI_Portal_Settings__c.getInstance();
        String CRNL = '\r\n', sos, mvs;
        if (vips != null) {
            sos = vips.SalesOrg_Codes__c; mvs = vips.Material_Vendors__c;
            LEARNSHARE_KEY = vips.Learnshare_CryptoKey__c;
            LEARNSHARE_URL = vips.Learnshare_URL__c;
            PFC_KEY = vips.PFC_CryptoKey__c; PFC_URL = vips.PFC_URL__c;
            BIW_CRYPTO_KEY = vips.BIW_CryptoKey__c; BIW_INIT_VECTOR = vips.BIW_InitVector__c;
            BIW_SECRET_KEY = vips.BIW_SecretKey__c; BIW_URL = vips.BIW_URL__c;
            BRANDMUSCLE_URL = vips.BrandMuscle_URL__c;
            QUICKSQUARE_KEY = vips.QuickSquare_Key__c; QUICKSQUARE_URL = vips.QuickSquare_URL__c;
            MATERIAL_VENDORS = mvs != null ? mvs.split(CRNL) : new List<String>();
            SALESORG_CODES = sos != null ? sos.split(CRNL) : new List<String>();
            PORTAL_USER_VIEW = vips.Portal_User_View__c;
            PROD_REFRESH_ENABLED = vips.Products_Refresh_Enabled__c;
            SHOW_DEBUG_MSGS = vips.Show_Debug_Msgs__c;
        } else {
            LEARNSHARE_KEY = ''; LEARNSHARE_URL = ''; PFC_KEY = ''; PFC_URL = '';
            BIW_CRYPTO_KEY = ''; BIW_INIT_VECTOR = ''; BIW_SECRET_KEY = ''; BIW_URL = '';
            BRANDMUSCLE_URL = ''; QUICKSQUARE_KEY = ''; QUICKSQUARE_URL = '';
            SALESORG_CODES = new List<String>{DEFAULT_SALESORG}; PORTAL_USER_VIEW = false;
            PROD_REFRESH_ENABLED = false; SHOW_DEBUG_MSGS = false;
        }
    }

    private static void debug(String s) {System.debug(LoggingLevel.INFO, 'VIUtils : ' + s);}

    private static Boolean isNull(String s) {return (s == null || s.trim().length() == 0);}

    private static UserRole getUserRole() {
        if (!userRoleLoaded) {
            List<UserRole> userRoles = [SELECT PortalAccountId, PortalType
                    FROM UserRole
                    WHERE Id = :UserInfo.getUserRoleId()];
            if (!userRoles.isEmpty()) {
                userRole = userRoles.get(0);
            }

            userRoleLoaded = true;
        }
        return userRole;
    }

    public static Boolean showDebugMsgs(Map<String, String> params) {
        return SHOW_DEBUG_MSGS && params != null && params.containsKey(PARAM_NAME_DEBUG);
    }

    public static Boolean isPortalUser() {
        return PORTAL_USER_VIEW || isPartnerPortalUser() || isCustomerPortalUser();
    }

    public static Boolean isPartnerPortalUser() {
        return PORTAL_TYPE_PARTNER.equalsIgnoreCase(getPortalType());
    }

    public static Boolean isCustomerPortalUser() {
        return PORTAL_TYPE_CUSTOMER.equalsIgnoreCase(getPortalType());
    }

    public static String getPortalType() {
        String portalType = 'None';

        UserRole r = getUserRole();
        if (r != null) {
            portalType = r.PortalType;
        }

        return portalType;
    }

    public static Id getPortalAccountId() {
        Id accountId = null;

        UserRole r = getUserRole();
        if (r != null) {
            accountId = r.PortalAccountId;
        }

        return accountId;
    }

    public static String getPortalAccountType() {
        String accountType = null;

        Id accountId = getPortalAccountId();
        if (accountId != null) {
            List<Account> accounts = [SELECT VI_Account_Type__c
                    FROM Account
                    WHERE Id = :accountId];

            if (!accounts.isEmpty()) {
                accountType = accounts.get(0).VI_Account_Type__c;
            }
        }

        return accountType;
    }

    public static Boolean isDistributor(Id accountId) {
        Account acc = getAccount(accountId);
        String s = acc != null ? acc.VI_Account_Type__c : '';
        return ACCOUNT_TYPE_DISTRIBUTOR.equalsIgnoreCase(s);
    }

    public static String getHomePageUrl() {return getHomePageUrl(null);}

    public static String getHomePageUrl(String accountId) {
        String userProfile = User_Functions.getLoggedInUserProfileName();
        String portalAccId = getPortalAccountId();
        String s = null, portalHome = URL_VIHOME + '?id=';
        if (homeProfiles.contains(userProfile)) {s = URL_HOME;} else
        if (portalAccId != null) {s = portalHome + portalAccId;} else
        if (!isNull(accountId)) {s = '/' + accountId;}
        debug('getHomePageUrl : ' + accountId + ' : ' + s); return s;
    }

    public static PageReference getHomePageRef() {return getHomePageRef(null);}

    public static PageReference getHomePageRef(String accountId) {
        String s = getHomePageUrl(accountId);
        return s != null ? new PageReference(s) : null;
    }

    public static String getLocationsUrl(Id accountId) {
        Id accId = getPortalAccountId(); String t = URL_LOCATIONS;
        if (accId == null) {accId = accountId;}
        if (isDistributor(accId)) {t = URL_FACILITIES;}
        return (t + accId);
    }

    public static String getPromotionsUrl(Id accountId) {
        return (URL_PROMOTIONS + accountId);
    }

    public static String getChannel(Id accountId) {
        String s = ''; Account acc = null;
        acc = getAccount(accountId); if (acc == null) {return s;}
        s = getChannel(acc); debug('channel 1 = ' + s);
        if (!String.isBlank(s)) {return s;}
        acc = getAccount(acc.ParentId); if (acc == null) {return s;}
        s = getChannel(acc); debug('channel 2 = ' + s);
        return s;
    }

    private static String getChannel(Account acc) {
        if (isExpressCare(acc)) {return SAP_CUST_GROUP_5_EXPRESSCARE;}
        return getChannel(acc.VI_Channel__c, acc.SAP_Customer_Group_5_Desc__c);
    }

    public static String getChannel(String channel, String sapCustGroup5Desc) {
        if (CHANNEL_QUICKLUBE.equals(channel) &&
            SAP_CUST_GROUP_5_EXPRESSCARE.equalsIgnoreCase(sapCustGroup5Desc)) {
            channel = CHANNEL_QUICKLUBE_EXPRESSCARE;
        }
        return channel;
    }

    public static Boolean isExpressCare(Account acc) {
        String s = acc != null ? acc.SAP_Customer_Group_5_Desc__c : '';
        return SAP_CUST_GROUP_5_EXPRESSCARE.equalsIgnoreCase(s);
    }

    public static Boolean isVperksUser() {
        User usr = getUser(UserInfo.getUserName());
        return usr.Contact != null && usr.Contact.Role__c != null &&
               usr.Contact.Role__c.contains(VPERKS_EARNER);
    }

    public static Datetime dateToDatetime(Date d) {
        Datetime dt = null;
        if (d != null) {
            dt = Datetime.newInstance(d.year(), d.month(), d.day());
        }
        return dt;
    }

    public static String formatDate(Date d, String formatString) {
        String formattedDate = '';

        Datetime dt = dateToDatetime(d);
        if (dt != null) {
            if ((formatString != null) && (formatString.length() > 0)) {
                formattedDate = dt.format(formatString);
            }
            else {
                formattedDate = dt.format();
            }
        }

        return formattedDate;
    }

    public static Integer getFiscalYear(Date d, Integer fiscalYearStartMonth) {
        Date fiscalYearStart = Date.newInstance(d.year(), fiscalYearStartMonth, 1);
        if (fiscalYearStartMonth > 6) {
            fiscalYearStart = fiscalYearStart.addMonths(-12);
        }

        Date fiscalYearEnd = fiscalYearStart.addMonths(12).addDays(-1);

        Integer fiscalYear;
        if (d < fiscalYearStart) {
            fiscalYear = d.year() - 1;
        }
        else if (d > fiscalYearEnd) {
            fiscalYear = d.year() + 1;
        }
        else {
            fiscalYear = d.year();
        }
        return fiscalYear;
    }

    public static Account getAccount(String accountId) {
        Account acc = null; if (isNull(accountId)) {return null;}
        List<Account> alist = [SELECT AccountNumber, AVI_Certified__c, AVI_Locator_Name__c,
            BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet,
            Fax, Id, Inactive_Account__c, Name, Owner.Email, Owner.Name, Owner.Phone, OwnerId,
            Parent.BillingCity, Parent.BillingPostalCode, Parent.BillingState, Parent.BillingStreet,
            ParentId, Phone, SAP_Customer_Group_5_Desc__c, SAP_Customer_Number__c, SAP_Sales_Org__c,
            VI_Account_Type__c, VI_Channel__c, VI_Ineligible_for_Promotions__c, VI_Promotional_Group__c, Website
            FROM Account WHERE Id = :accountId];
        if (!alist.isEmpty()) {acc = alist.get(0);}
        return acc;
    }

    public static Account getFacility(Map<String, String> params) {
        String facilityId, portalAccountType = getPortalAccountType();
        if (ACCOUNT_TYPE_FACILITY.equalsIgnoreCase(portalAccountType)) {
            facilityId = getPortalAccountId();
        } else
        if (ACCOUNT_TYPE_LOCATION.equalsIgnoreCase(portalAccountType)) {
            Account location = getLocation(getPortalAccountId());
            if (location != null) {facilityId = location.ParentId;}
        } else {
            facilityId = params.get(PARAM_FACILITY_ID);
            if (facilityId == null) {facilityId = params.get(PARAM_ID);}
        }
        return getFacility(facilityId);
    }

    public static Account getFacility(String facilityId) {
        Account facility = null; if (isNull(facilityId)) {return null;}
        List<Account> facilities = [SELECT AccountNumber, AVI_Certified__c, AVI_Locator_Name__c,
            BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet,
            Fax, Id, Inactive_Account__c, Name, Owner.Email, Owner.Name, Owner.Phone, OwnerId,
            Parent.BillingCity, Parent.BillingPostalCode, Parent.BillingState, Parent.BillingStreet,
            ParentId, Phone, SAP_Customer_Group_5_Desc__c, SAP_Customer_Number__c, SAP_Sales_Org__c,
            VI_Account_Type__c, VI_Channel__c, VI_Ineligible_for_Promotions__c, VI_Promotional_Group__c, Website
            FROM Account WHERE Id = :facilityId AND VI_Account_Type__c = :ACCOUNT_TYPE_FACILITY];

        if (!facilities.isEmpty()) {facility = facilities.get(0);}
        return facility;
    }

    public static Account getLocation(String locationId) {
        List<Account> locations = [SELECT Id, ParentId, OwnerId, Name, AccountNumber,
                VI_Account_Type__c, VI_Channel__c, VI_Ineligible_for_Promotions__c, VI_Promotional_Group__c,
                SAP_Customer_Number__c, SAP_Customer_Group_5_Desc__c, SAP_Sales_Org__c,
                BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,
                Phone, Fax, Website, AVI_Certified__c, Inactive_Account__c, AVI_Locator_Name__c
                FROM Account
                WHERE Id = :locationId
                AND VI_Account_Type__c = :ACCOUNT_TYPE_LOCATION];

        Account location = null;
        if (!locations.isEmpty()) {
            location = locations.get(0);
        }
        return location;
    }

    public static List<Account> getLocations(Account facility) {

        List<Account> locations = new List<Account>();
        if (facility == null || facility.Id == null) {
            return null;
        }

        locations = [SELECT Id, Name,  AccountNumber, ParentId,
                            AVI_Locator_Name__c, Inactive_Account__c,
                            BillingStreet, BillingCity, BillingState,
                            BillingPostalCode, BillingCountry, Phone,
                            SAP_Customer_Number__c, VI_Account_Type__c
                       FROM Account
                      WHERE ParentId = :facility.Id
                        AND VI_Account_Type__c = :ACCOUNT_TYPE_LOCATION
                      ORDER BY Name];
        return locations;
    }

    public static User getUser(String usrName) {
        List<User> ulist = [select Id, ContactId, Contact.Role__c,
                                   FirstName, LastName, UserName
                              from User where UserName = :usrName];
        if (ulist == null || ulist.isEmpty()) {return null;}
        else {return ulist[0];}
    }

    private static VIAccount getVIAccount(String accountId,
                                          String accountType) {
        Account acc;
        if (ACCOUNT_TYPE_FACILITY.equalsIgnoreCase(accountType)) {
            acc = getFacility(accountId);
        }
        return new VIAccount(acc);
    }

    public static VIAccount getVIFacility(String facilityId) {
        return getVIAccount(facilityId, ACCOUNT_TYPE_FACILITY);
    }

    private static Map<Id, VIAccount> getVIAccountMap(List<VIAccount> accs) {
        Map<Id, VIAccount> amap = new Map<Id, VIAccount>();
        for (VIAccount a : accs) {
            amap.put(a.acc.Id, a);
        }
        return amap;
    }

    public static List<VIAccount> getSortedVIAccounts(List<VIAccount> accs) {
        return getSortedVIAccounts(accs, false);
    }

    public static List<VIAccount> getSortedVIAccounts(List<VIAccount> accs, Boolean sortOnEnrolled) {
        updateParentInfo(accs);
        List<VIAccount> slist = new List<VIAccount>();
        List<String> keys = new List<String>();
        String key, d = '|';
        Map<String, VIAccount> amap = new Map<String, VIAccount>();
        for (VIAccount a : accs) {
            key = d;
            if (sortOnEnrolled) {key += a.isEnrolled;}
            if (a.dst != null) {key += d + '1' + d + a.dst.Name + d + a.dst.Id;} key += d;
            if (a.fac != null) {key += d + '2' + d + a.fac.Name + d + a.fac.Id;} key += d;
            if (a.loc != null) {key += d + '3' + d + a.loc.Name + d + a.loc.Id;} key += d;
            amap.put(key, a);
            keys.add(key);
        }
        keys.sort();
        Integer n = 0;
        for (String k : keys) {
            //System.debug('>>>>>>>>>>> Key = '+k);
            VIAccount acc = amap.get(k);
            //System.debug('>>>>>>>>>>> acc = '+acc.acc.Id);
            acc.recordNumber = (++n);
            slist.add(acc);
        }
        return slist;
    }

    private static void updateParentInfo(List<VIAccount> accs) {
        Map<Id, VIAccount> amap = getVIAccountMap(accs);
        Account acc;
        VIAccount p;
        Id pid;
        for (VIAccount a : accs) {
            acc = a.acc;
            pid = acc.ParentId;
            if (pid != null && amap.containsKey(pid)) {
                p = amap.get(pid);
                if (a.isLocation()) {
                    a.fac = p.acc;
                    pid = p.acc.ParentId;
                    if (pid != null && amap.containsKey(pid)) {
                        p = amap.get(pid);
                        a.dst = p.acc;
                    }
                } else if (a.isFacility()) {
                    a.dst = p.acc;
                }
            }
            a.setVIAccountType();
        }
    }

    public static List<VIAccount> getVIAccountsByCustGroup5(String custGroup5,
                                                            Boolean aviCertified,
                                                            Integer limitCount) {
        if (limitCount == null) {limitCount = 1000;}
        List<VIAccount> accs = new List<VIAccount>();
        VIAccount acc;
        for (Account a : [SELECT Id, ParentId, Name,  AccountNumber, Phone, Fax, Website,
                                 AVI_Locator_Name__c, BillingStreet, BillingCity,
                                 BillingState, BillingPostalCode,
                                 AVI_Certified__c, Inactive_Account__c,
                                 SAP_Customer_Group_5_Desc__c,
                                 SAP_Customer_Number__c, SAP_Sales_Org__c,
                                 VI_Account_Type__c, VI_Channel__c
                            FROM Account
                           WHERE SAP_DistChannel__c = :VI_DISTCHAN_CODE
                             AND Inactive_Account__c = false
                             AND AVI_Certified__c = :aviCertified
                             AND SAP_Customer_Group_5_Desc__c = :custGroup5
                             AND VI_Account_Type__c in (
                                :ACCOUNT_TYPE_DISTRIBUTOR,
                                :ACCOUNT_TYPE_FACILITY,
                                :ACCOUNT_TYPE_LOCATION)
                           ORDER BY VI_Account_Type__c, Name, BillingStreet
                           LIMIT :limitCount
                         ]) {
            acc = new VIAccount(a);
            accs.add(acc);
        }
        accs = getSortedVIAccounts(accs);
        return accs;
    }

    public static String getAccountQryForPromo(VIPromotion p) {
        String s = ACCOUNT_QRY1;
        if (p != null && p.isPromoForAVIOnly()) {
            s += ' AND AVI_Certified__c = true ';
        } else if (p != null && p.isPromoForNonAVI()) {
            s += ' AND AVI_Certified__c = false ';
        }
        return s;
    }

    public static List<Account> getFacilitiesByCustGroup5(String custGroup5,
                                                          VIPromotion promo,
                                                          Integer maxLimit) {
        String q = getAccountQryForPromo(promo);
        q += ' AND SAP_DistChannel__c = :VI_DISTCHAN_CODE';
        q += ' AND SAP_Customer_Group_5_Desc__c = :custGroup5';
        q += ' AND VI_Account_Type__c = :ACCOUNT_TYPE_FACILITY';
        q += ' LIMIT :maxLimit';
        debug('getFacilitiesByCustGroup5 : ' + q);
        return Database.query(q);
    }

    public static List<String> getCustGroup5List() {
        List<String> cg5list = new List<String>();
        for (AggregateResult ar : [select SAP_Customer_Group_5_Desc__c custgrp5
                                         from Account
                                        where SAP_DistChannel__c = :VI_DISTCHAN_CODE
                                          and Inactive_Account__c = false
                                          and VI_Account_Type__c in (
                                             :ACCOUNT_TYPE_DISTRIBUTOR,
                                             :ACCOUNT_TYPE_FACILITY,
                                             :ACCOUNT_TYPE_LOCATION)
                                          and SAP_Customer_Group_5_Desc__c != null
                                        group by SAP_Customer_Group_5_Desc__c
                                  ]) {
            cg5list.add((String)ar.get('custgrp5'));
        }
        return cg5list;
    }

    public static List<SelectOption> getSalesOrgOptionList() {
        List<SelectOption> sos = new List<SelectOption>();
        List<SAP_Sales_Org__c> slist = SAP_Queries.get_SAP_Sales_Orgs(SALESORG_CODES);
        for (SAP_Sales_Org__c s : slist) {
            // Value, Label
            sos.add(new SelectOption(s.Sales_Org_Code__c , s.Name));
        }
        return sos;
    }

    public static List<SelectOption> getSelectOptionList(Schema.DescribeFieldResult dfr) {
        List<SelectOption> solist = new List<SelectOption>();
        try {
            List<Schema.PicklistEntry> pelist = dfr.getPicklistValues();
            solist = getSelectOptions(pelist);
        } catch(exception e) {
            System.debug(e.getMessage());
        }
        return solist;
    }

    private static List<SelectOption> getSelectOptions(List<Schema.PicklistEntry> pelist) {
        List<SelectOption> solist = new List<SelectOption>();
        List<String> pvlist = getPicklistValues(pelist);
        if (pvlist != null && !pvlist.isEmpty()) {
            for (String s : pvlist) {
                // Value, Label
                solist.add(new SelectOption(s, s));
            }
        }
        return solist;
    }

    private static List<String> getPicklistValues(List<Schema.PicklistEntry> pelist) {
        List<String> slist = new List<String>();
        if (pelist != null && !pelist.isEmpty()) {
            for (Schema.PicklistEntry pe : pelist) {
                if (pe.isActive()) {
                    slist.add(pe.getValue());
                }
            }
            slist.sort();
        }
        return slist;
    }

    public static Boolean isPicklistContains(String pv, String s) {
        List<String> pvlist = pv.split(';');
        Set<String> pvset = new Set<String>();
        for (String p : pvlist) {
            pvset.add(p.toLowerCase());
        }
        return pvset.contains(s.toLowerCase());
    }

    public static Boolean isAdmin() {
        Boolean b = false;
        String p = [select name from profile
                     where id = :UserInfo.getProfileId()
                     limit 1][0].name;
        b = adminProfiles.contains(p);
        return b;
    }

    public static String getAesKey128() {
        String k = EncodingUtil.base64Encode(Crypto.generateAesKey(128));
        debug('k : ' + k); return k;
    }

    public static String getAesKey256() {
        String k = EncodingUtil.base64Encode(Crypto.generateAesKey(256));
        debug('k : ' + k); return k;
    }

    public static String getAesKey(Integer n) {
        if (!AES_SET.contains(n)) {return null;}
        String k = EncodingUtil.base64Encode(Crypto.generateAesKey(n)).subString(0, n/8);
        debug('k : ' + k); return k;
    }

    public static String getEncryptedString(String algorithm, String keyString, String initVectr, String plainString) {
        debug('plainString : ' + plainString);
        Blob cryptoKey = Blob.valueOf(keyString);
        Blob iniVector = Blob.valueOf(initVectr);
        Blob data = Blob.valueOf(plainString);
        String dataEncoded = EncodingUtil.base64Encode(data);
        //debug('dataEncoded : ' + dataEncoded);

        Blob encryptedData = Crypto.encrypt(algorithm, cryptoKey, iniVector, data);
        String encryptedDataString = EncodingUtil.base64Encode(encryptedData);
        debug('encryptedDataString : ' + encryptedDataString);

        return encryptedDataString;
    }

    public static String getEncrypted256(String keyString, String initVectr, String plainString) {
        debug('plainString : ' + plainString);
        Blob cryptoKey = EncodingUtil.base64Decode(keyString);
        Blob iniVector = EncodingUtil.base64Decode(initVectr);
        Blob plainData = Blob.valueOf(plainString);

        Blob encryptedData = Crypto.encrypt(AES_256, cryptoKey, iniVector, plainData);
        String encryptedDataString = EncodingUtil.base64Encode(encryptedData);
        debug('encryptedDataString : ' + encryptedDataString);

        return encryptedDataString;
    }

    public static String getEncoded256(String keyString, String initVectr, String plainString) {
        String e = getEncryptedString(AES_256, keyString, initVectr, plainString);
        e = EncodingUtil.urlEncode(e, UTF_8); debug('e : ' + e); return e;
    }

    public static String getDecryptedAES256(String keyString, String cryptString) {
        Blob k = Blob.valueOf(keyString);
        Blob v = Blob.valueOf(keyString.substring(0,16));
        Blob c = EncodingUtil.base64Decode(EncodingUtil.urlDecode(cryptString, UTF_8));
        return Crypto.decrypt(AES_256, k, v, c).toString();
    }

    public static String getDigestMD5(String s) {
        String t = '{' + MD5 + '}';
        Blob d = Crypto.generateDigest(MD5, Blob.valueOf(s));
        return t + EncodingUtil.convertToHex(d).toUpperCase();
    }

    public static PageReference getLearnsharePageRef() {
        String un = UserInfo.getUsername();
        Long t = DateTime.now().getTime() * 10000 + 621355968000000000L;
        String p = 'user='+un+'&act=4&T='+t;
        String e = getEncryptedString(AES_128, LEARNSHARE_KEY, LEARNSHARE_KEY, p);
        String u = LEARNSHARE_URL + e;
        debug('URL : ' + u);
        return new PageReference(u);
    }

    public static PageReference getPfcPageRef(String accNum) {
        String un = UserInfo.getUsername();
        DateTime dt = DateTime.now();
        Integer t = dt.hourGmt()*3600 + dt.minuteGmt()*60 + dt.secondGmt();
        String p = 'user='+un+'&account='+accNum+'&time='+t;
        String e = getEncryptedString(AES_128, PFC_KEY, PFC_KEY, p);
        e = EncodingUtil.urlEncode(e, UTF_8);
        String u = PFC_URL + e;
        debug('URL : ' + u);
        return new PageReference(u);
    }

    public static PageReference getQuickSquarePageRef(String accNum) {
        String k = 'toi4dPoEewm7iIdz7yWb9YBPqEGWPJZz9Bl3SzlX0iY=';
        String v = 'Jzwnbb8xWcOw8eYB7gfjOg==';
        String s = 'This is so cool when you get it working.';
        getEncrypted256(k, v, s);
        /*
        String un = UserInfo.getUsername(); DateTime dt = DateTime.now();
        String t = DateTime.now().formatGmt('yyyyMMddHHmm');
        String s = accNum + t + QUICKSQUARE_KEY;
        String d = EncodingUtil.base64Encode(Crypto.generateDigest(SHA1, Blob.valueOf(s)));
        String e = 'a='+accNum+'&t='+t;
        String u = QUICKSQUARE_URL + e;
        debug('URL : ' + u);
        return new PageReference(u);
        */
        return null;
    }

/*
    public static PageReference getBiwPageRef() {
        String u = BIW_URL, k = BIW_CRYPTO_KEY, v, s, e;
        //k =  getAesKey(256); // for testing only
        v = k.substring(0,16);
        s = UserInfo.getUsername();
        e = getEncoded256(k, v, s);
        u += ('?UniqueID=' + e);
        DateTime dt = DateTime.now();
        s = dt.formatGmt('yyyy-MM-dd HH:mm:ss');
        e = getEncoded256(k, v, s);
        u += ('&TimeStamp=' + e);
        debug('URL : ' + u);
        return new PageReference(u);
    }
*/

    public static PageReference getBrandMusclePageRef(String accNum) {
        /*
        //accNum = 'ssoTestUser';
        String t = DateTime.now().formatGmt('yyyyMMddHHmm');
        String s = accNum + t + BRANDMUSCLE_KEY;
        String d = EncodingUtil.base64Encode(Crypto.generateDigest(SHA1, Blob.valueOf(s)));
        String a = '<AUTHENTICATOR><LOGINID>' + accNum + '</LOGINID><DATE>' + t +
                   '</DATE><USERTOKEN><![CDATA[' + d + ']]></USERTOKEN></AUTHENTICATOR>';
        String u = BRANDMUSCLE_URL + a;
        */
        String u = BRANDMUSCLE_URL;
        debug('URL : ' + u);
        return new PageReference(u);
    }

/*
    @isTest static void test01() {
        Test.startTest();
        System.debug(getCustGroup5List());
        Schema.DescribeFieldResult dfr = Account.SAP_Customer_Group_5_Desc__c.getDescribe();
        System.debug(getSelectOptionList(dfr));
    }
*/
}
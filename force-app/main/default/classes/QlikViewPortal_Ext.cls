public with sharing class QlikViewPortal_Ext {

    public String URL { get; set; }

    public void Init() {
        URL = generateURL();
    }

    public QlikViewPortal_Ext(QlikViewPortal_Controller c) {

    }

    /* URL Generator Code */
    public String generateURL() {
        String url = 'http://qlikview.ashland.com';
        return url;
    }


    public Boolean getInsideIntranet() {
        if (getUserName() == 'solenissfdcsupport@solenis.com') {return true;}
        if (getUserName() == 'ghill@ashland.com') {return true;}

        if (User_Functions.isIntranetIP()) {return true;}

        return false;
    }

    public Boolean getOutsideIntranet() {
        if (getUserName() == 'solenissfdcsupport@solenis.com') {return true;}
        if (getUserName() == 'ghill@ashland.com') {return true;}

        if (User_Functions.isIntranetIP()) {return false;}

        return true;
    }

    public String getUserIPAddress() {
        Map<String,String> headerInfo = ApexPages.currentPage().getHeaders();
        String userIP = headerInfo.get('X-Salesforce-SIP');
        return userIP;
    }

    public String getUserName() {
        String userName = UserInfo.getUserName();
        return userName;
    }



}
public without sharing class solenisPortnerPortalController{

    @AuraEnabled
    public static List<user> getcontactList(String UserId){
        List<User> ConList = New List<User>();
        //map<string,user> usr = new map<string,user>([select email,id from user where isPortalEnabled=True]);
        String AccId =[select id,contact.Accountid from user where id=:UserId].contact.Accountid;
        
        ConList=[select id,Name,contact.account.Name,contact.Name,Email,contact.MobilePhone from user where contact.Accountid=:AccId];
        
        
    
    return ConList;
    }
    @AuraEnabled
    public static String getAccountId(String UserId){
        List<User> ConList = New List<User>();
        //map<string,user> usr = new map<string,user>([select email,id from user where isPortalEnabled=True]);
        String AccId =[select id,contact.Accountid from user where id=:UserId].contact.Accountid;
           
    return AccId;
    }


}
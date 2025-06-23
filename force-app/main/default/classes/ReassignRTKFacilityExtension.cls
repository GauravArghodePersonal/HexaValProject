public class ReassignRTKFacilityExtension {

public List<RTK_Facility__c> RTKList{get; set;}
public Account acct{get; set;}
public integer RTKListsize{get; set;}
public List<Account> AccountList{get; set;}
public boolean displaypopup{get; set;}

    public ReassignRTKFacilityExtension(ApexPages.StandardSetController controller) {
        List<RTK_Facility__c> RTK = controller.getselected();
        RTKList = new List<RTK_Facility__c>();
        RTKListSize = 0;
        displaypopup = false;
        acct = new Account();
  
        Set<ID>RTKSet = new Set<ID>();    
        
        for(RTK_Facility__c r:RTK){
           RTKSet.add(r.id);  }  
        
        RTKList = [select id, Account__c, Account__r.id from RTK_Facility__c where id in :RTKSet order by Account__c];
        RTKlistsize=RTKList.size();  
    }


public pagereference cancel(){
string p = ObjectPrefixFunctions.getObjectKeyPrefix('RTK_Facility__c');
return new pagereference('/' + p + '/o');
}

public void next(){
AccountList = new List<Account>();
List<Opportunity> OppList = new List<Opportunity>();
List<Contact> ContactList = new List<Contact>();

Set<ID> AccountSet = new set<ID>();

 for(RTK_Facility__c r:RTKList) {
           AccountList.add(r.Account__r);
           AccountSet.add(r.Account__r.id);
        }

OppList = [select id from Opportunity where Accountid in :Accountset];
ContactList = [select id from Contact where Accountid in:Accountset];

for(Account a:AccountList){
  a.ownerid = acct.ownerid;
}

for(Opportunity O:OppList) {
  O.ownerid = acct.ownerid;
}

for(Contact c:ContactList) {
  C.Ownerid = acct.ownerid;
}

Update OppList;
update AccountList;
displaypopup = true;
}

public pagereference closepopup(){
string p = ObjectPrefixFunctions.getObjectKeyPrefix('RTK_Facility__c');
return new pagereference('/' + p + '/o');
}

}
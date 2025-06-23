public with sharing class leadconversionprocessclass {

    public id leadid;
    public string opp {get;set;}
    public string descrip {get;set;}
    public string app {get;set;}
    public string convalue {get;set;}
    public string statusvalue {get;set;}
    public task t {get;set;}
    public boolean check {get;set;}
    public boolean check1 {get;set;}
    public boolean sendemail {get;set;}
    public boolean show {get;set;}
    public boolean createtask {get;set;}
    public boolean lsource {get;set;}
    public list<account> lstacc;
    public lead custom {get;set;}
    public List<SelectOption> adding {get;set;}
    public list<SelectOption> convalues {get;set;}
    string s='';string k='';string v='';string r='';Id accid;
  
    
Public leadconversionprocessclass () {
   leadId = ApexPages.currentPage().getParameters().get('id');
      t = new task(); show=false;  
    custom= new lead ();
   
  custom= [select id,lastname ,company, DoNotCall,ownerid,IsConverted  from lead where id=:leadid];
  system.debug('========================'+custom.company);
   
  string some= 'select id,name,phone from account where name like\''+custom.company+'%\'Limit 999';
  lstacc = database.query(some);
  system.debug('============================'+lstacc.size());
  system.debug('============================'+lstacc);
  
        
  adding = new list<selectoption>();
      k='CREATE NEW ACCOUNT FOR:'+custom.Company;
      adding.add(new selectoption('',k));
      for(account a:lstacc){
      s = 'Add to exicting account: '+ a.name;
      adding.add(new SelectOption(a.id, s));
        }

  
    }
    

 public pagereference ConvertToAccount(){
     
   system.debug ('===================method called=====================');
   system.debug ('=============================accountid=============='+app);
       
      Database.LeadConvert lc = new database.LeadConvert();
      lc.setLeadId(leadId);
      LeadStatus convertStatus = [Select Id,MasterLabel from LeadStatus where IsConverted=true limit 1];
      lc.setConvertedStatus('Qualified/Converted'); 
      lc.setownerid(Custom.ownerid);
      if(app!=null) {                       
      account an =[select id,name from account where id =:app];
      system.debug('=========AccountID============'+an.id);
      lc.setAccountId(an.id);
      if(Convalue!=null){
      contact con =[select Id,name from contact where Id=:convalue];
      lc.setContactId(con.Id); }}
      
        if(custom.DoNotCall==true) {
     lc.setDoNotCreateOpportunity(true);   }
             else {
     lc.opportunityName=opp;  }
        if(sendemail==true) {
     lc.setSendNotificationEmail(true);   }
             else {
     lc.setSendNotificationEmail(false);  }
       if(lsource==true){
     lc.setOverwriteLeadSource(true);}
    
      try {     
   Database.LeadConvertResult lcr = Database.convertLead(lc);
     system.debug('================'+lc);
     System.assert(lcr.isSuccess()); 
     accid= lcr.getAccountId();
       
   if(createtask==true) {
      gettask(accId);
   } }
   catch(DMLException e){
      ApexPages.addMessages(e);
      
      Return Null;      }
  PageReference page = new PageReference('/apex/leadProcessExtn?id='+accid); 
   Page.SetRedirect(true); 
   Return Page; 
    } 
    private void gettask(Id accId){
      t.whatid=accid;
      t.Description=descrip;
      t.Isreminderset=true; 
      insert t;  
    }
   public void getcontact() {
     
               show = false;
                System.debug('--selectedAccount------->'+app);
                convalues = new List<SelectOption>();
                if(app!=null){
                List<Contact> lstcon = [Select id, name from Contact where accountid =:app limit 999];
                system.debug('=========contact list====='+lstcon.size());
                if(lstcon.size()>0){
                        show= true;
                        v='Create New Contact For:'+custom.Company;
                        convalues.add(new Selectoption('',v));
                        for(Contact c: lstcon){
                        r = 'Attach to existing Contact: '+ c.name;
                           convalues.add(new SelectOption(c.Id, r));
                      system.debug('=========contact list id====='+c.id);  
                        }
                } }
                
                
        }
    
   Public PageReference BackToLead () {
    PageReference Page = New Apexpages.StandardController(custom).View();
    system.debug('&&&&&&&&&&&&&&***************'+page);
    Page.SetRedirect(true);
    Return Page; }       
  }
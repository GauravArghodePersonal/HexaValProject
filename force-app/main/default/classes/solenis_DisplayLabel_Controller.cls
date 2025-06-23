public class solenis_DisplayLabel_Controller{
    @AuraEnabled
    public map<string, string> imgmap{get; set;}
    @AuraEnabled
    public string folderid;
    @AuraEnabled
    public list<document> docs{get; set;}
    private static final String NEWCONTACT = 'createNewContact';
  

    @AuraEnabled    
    public static Label_Request__c AccountDetail(Id accid) {
        try{
            Label_Request__c LR = New Label_Request__c();
             Map<String, Schema.RecordTypeInfo> RTMap = Label_Request__c.sObjectType.getDescribe().getRecordTypeInfosByName();
            LR.recordtypeid = RTMAP.get('Draft').getrecordtypeid(); 
            system.debug('recordtypeid: ' + LR.recordtypeid);
            LR.recordtype = [select id, name from recordtype where id = :RTMAP.get('Draft').getrecordtypeid() limit 1];
            LR.Customer_Prospect__c = accid;
            Account acc = [select id, name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c
                             FROM Account 
                             WHERE Id =: accId];
                             
            LR.Full_Address__c = acc.name;
            IF(acc.SAP_Street__c != null){LR.Full_Address__c += '\n' + acc.SAP_Street__c;}
            IF(acc.SAP_StreetSuppl1__c != null){LR.Full_Address__c += '\n' + acc.SAP_StreetSuppl1__c;}
            IF(acc.SAP_StreetSuppl2__c != null){LR.Full_Address__c += '\n' + acc.SAP_StreetSuppl2__c;}
            LR.Full_Address__c += '\n' + acc.SAP_City__c + ', ' +  acc.SAP_state__c + ' ' + acc.SAP_ZIP_Code__c;
            LR.Full_Address__c += '\n' + acc.SAP_Country__c;
            //LR.Customer_Prospect__r.name=acc.name;
            System.debug('<<<>>>>'+LR);
           return LR;
        }
        catch (Exception e){
            throw new AuraHandledException(e.getMessage()); 
        }
    }
    
    public solenis_DisplayLabel_Controller() {   
         folder f = [select id from folder where name = 'AHWT Label Pictures' limit 1];
         folderid = f.id;
         docs = new list<document>();
         docs = [select name, id from document where folderid  = :folderid];
         imgmap = new map<string, string>();
         for(document d:docs){
            imgmap.put(d.name, '/servlet/servlet.FileDownload?file=' + d.id);
            }   
    
    } 
    @AuraEnabled(cacheable=true)
    public static solenis_DisplayLabel_Controller init(String accountId){
        solenis_DisplayLabel_Controller objLRDExtension = new solenis_DisplayLabel_Controller();
        return objLRDExtension;
    }
    @AuraEnabled
    public string getpic1big(){
        return imgmap.get('Picture 1 Big');}
        
    @AuraEnabled
    public string getpic2big(){
        return imgmap.get('Picture 2 Big');} 
             
    @AuraEnabled
    public string getpic3big(){
        return imgmap.get('Picture 3 Big');}
        
    @AuraEnabled    
    public string getpic4big(){
        return imgmap.get('Picture 4 Big');}
        
    @AuraEnabled
    public string getpic5big(){
        return imgmap.get('Picture 5 Big');}
        
    @AuraEnabled
    public string getpic6big(){
        return imgmap.get('Picture 6 Big');}
        
    @AuraEnabled
    public string getpic7big(){
        return imgmap.get('Picture 7 Big');}
    
    @AuraEnabled
    public string getpic8big(){
        return imgmap.get('Picture 8 Big');}       
    
    @AuraEnabled
    public string getpic9big(){
        return imgmap.get('Picture 9 Big');}
    
    @AuraEnabled
    public string getpic10big(){
        return imgmap.get('Picture 10 Big');}
        
    @AuraEnabled
    public string getpic11big(){
        return imgmap.get('Picture 11 Big');}
        
    @AuraEnabled
    public string getpic12big(){
        return imgmap.get('Picture 12 Big');}
        
    @AuraEnabled
    public string getpic13big(){
        return imgmap.get('Picture 13 Big');}
        
    @AuraEnabled
    public string getpic14big(){
        return imgmap.get('Picture 14 Big');}
        
    @AuraEnabled
    public string getpic15big(){
        return imgmap.get('Picture 15 Big');}
        
    @AuraEnabled
    public string getpic16big(){
        return imgmap.get('Picture 16 Big');}
        
    @AuraEnabled
    public string getpic17big(){
        return imgmap.get('Picture 17 Big');}
        
    @AuraEnabled
    public string getpic18big(){
        return imgmap.get('Picture 18 Big');}
        
    @AuraEnabled
    public string getpic19big(){
        return imgmap.get('Picture 19 Big');}
        
    @AuraEnabled
    public string getpic20big(){
        return imgmap.get('Picture 20 Big');}
    
    @AuraEnabled
    public string getpic1small(){
        return imgmap.get('Picture 1 Small');}
        
    @AuraEnabled
    public string getpic2small(){
        return imgmap.get('Picture 2 Small');} 
             
    @AuraEnabled
    public string getpic3small(){
        return imgmap.get('Picture 3 Small');}
        
    @AuraEnabled
    public string getpic4small(){
        return imgmap.get('Picture 4 Small');}
        
    @AuraEnabled
    public string getpic5small(){
        return imgmap.get('Picture 5 Small');}
        
    @AuraEnabled
    public string getpic6small(){
        return imgmap.get('Picture 6 Small');}
        
    @AuraEnabled
    public string getpic7small(){
        return imgmap.get('Picture 7 Small');}
        
    @AuraEnabled
    public string getpic8small(){
        return imgmap.get('Picture 8 Small');} 
              
    @AuraEnabled
    public string getpic9small(){
        return imgmap.get('Picture 9 Small');}
        
    @AuraEnabled
    public string getpic10small(){
        return imgmap.get('Picture 10 Small');}
        
    @AuraEnabled
    public string getpic11small(){
        return imgmap.get('Picture 11 Small');}
        
    @AuraEnabled
    public string getpic12small(){
        return imgmap.get('Picture 12 Small');}
        
    @AuraEnabled
    public string getpic13small(){
        return imgmap.get('Picture 13 Small');}
        
    @AuraEnabled
    public string getpic14small(){
        return imgmap.get('Picture 14 Small');}
    
    @AuraEnabled
    public string getpic15small(){
        return imgmap.get('Picture 15 Small');}
    
    @AuraEnabled
    public string getpic16small(){
        return imgmap.get('Picture 16 Small');}
    
    @AuraEnabled
    public string getpic17small(){
        return imgmap.get('Picture 17 Small');}
        
    @AuraEnabled
    public string getpic18small(){
        return imgmap.get('Picture 18 Small');}
        
    @AuraEnabled        
    public string getpic19small(){
        return imgmap.get('Picture 19 Small');}
        
    @AuraEnabled    
    public string getpic20small(){
        return imgmap.get('Picture 20 Small');}
        
    @AuraEnabled
   public static List<cSelectOption>  ContactList(Id accountId){
       System.debug('<<<accountId>>>'+accountId);
        List<cSelectOption> allContacts = new list<cSelectOption>();
          //contact.accountid = accountId;
        List<Contact> contactlist = [select id, firstname, lastname, phone, email from Contact where accountid = :accountid order by lastname];           
        allContacts.add(new cSelectOption('', '--None--'));
        allContacts.add(new cSelectOption(NEWCONTACT, '--Create New Contact--' ));
        
        for(Contact c:contactlist){
           
            //phonemap.put(c.id, c.phone);
            allContacts.add(new cSelectOption(c.id, c.lastname + ', ' + c.firstname ));
        
    }
    return allContacts;

    }
    public class cSelectOption{
        @AuraEnabled
        public String label{get;set;}
        @AuraEnabled
        public String value{get;set;}
        @AuraEnabled
        public Boolean selected{get;set;}
        public cSelectOption(String value, String label){
            this.label = label;
            this.value = value;
           // this.selected = selected;
        }
        
}
@AuraEnabled
    public static string createcontactLWC(String contactStr){
        system.debug('<<<contactStr>>>>'+contactStr);
        Contact contact = (Contact)JSON.deserialize(contactStr, Contact.class);
        if (contact.Salutation == null) {contact.Salutation = '.';}
        insert contact;
        return contact.id;
    }
     @AuraEnabled
    public static String createreqsubmitLWC(String accountId, String LRS, String contactId){
        solenis_DisplayLabel_Controller objLRDExtension = new solenis_DisplayLabel_Controller();
        Label_Request__c LR = New Label_Request__c();        
        LR = (Label_Request__c)JSON.deserialize(LRS, Label_Request__c.class);
        return objLRDExtension.upsertAndSubmitReqLWC(true,LR ); 
       
    }
    
     private String upsertAndSubmitReqLWC(Boolean submt,Label_Request__c LR){
         System.debug('<<<LR1>>>'+LR);
                if(LR.id == null) {
                  LR.Delivery_Method__c = 'Standard Delivery';
                    if (lr.Contact__c == null) {return 'Contact Required';} 
                    try{
                        insert LR;
                    }
                    catch (Exception ex)
                    {
                        return ex.getMessage();
                    }
                } 
                else {update LR;}  
                
                if (submt) {
                    Id labelReqRecordTypeId = RecordType_Functions.LookupRecordTypeId('Submitted', 'Label_Request__c');
                    LR.Status__c = 'Submitted'; LR.RecordTypeId = labelReqRecordTypeId;
                    update LR;
                }
                return '/' + LR.id;   
    
    } 
    
    @AuraEnabled
    public static String createreqLWC(String accountId, String LRS, String contactId){
         System.debug('<<<LRS>>>'+LRS);
        solenis_DisplayLabel_Controller objLRDExtension = new solenis_DisplayLabel_Controller();
        Label_Request__c LR = New Label_Request__c();        
        LR = (Label_Request__c)JSON.deserialize(LRS, Label_Request__c.class);
        return objLRDExtension.upsertAndSubmitReqLWC(false,LR ); 
    } 
}
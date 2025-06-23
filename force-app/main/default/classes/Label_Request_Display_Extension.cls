// Author: AWT Sys Admin
// Purpose : To Display Label Request Custom Page from Account Create Label Request Button. To Display Images.
// Created Date : 4/22/2014 5:47 PM
// Last Modified By :  Srinivasan Muthu (TechMahindra)
// Last Modified Date: 19/02/2015

public with sharing class Label_Request_Display_Extension {
    
    private static final String NEWCONTACT = 'createNewContact';
    
    public string folderid;
    public string accountid;
    public string id;
    public Label_Request__c LR{get; set;}
    public list<document> docs{get; set;}
    public map<string, string> imgmap{get; set;}
    public boolean displaycontactpopup{get; set;}
    public string selectedcontact{get; set;}
    public list<selectoption> contacts{get; set;}
    public Contact contact{get; set;}
    public map<id, string> phonemap;
    
    public Label_Request_Display_Extension(ApexPages.StandardController controller) {
        
        Account a = new Account();
        displaycontactpopup = false;
        Contact = new contact();
        phonemap = new map<id, string>();
        
        LR = new Label_Request__c();
        Map<String, Schema.RecordTypeInfo> RTMap = Label_Request__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        LR.recordtypeid = RTMAP.get('Draft').getrecordtypeid(); 
        system.debug('recordtypeid: ' + LR.recordtypeid);
        LR.recordtype = [select id, name from recordtype where id = :RTMAP.get('Draft').getrecordtypeid() limit 1];
        
        LR.Status__c = 'Draft';
        string req = apexpages.currentpage().getparameters().get('req');
        if(req != null && req != ''){
           // LR.Tank_Requirement__c = req;
            LR.Case__c = req;}
        
        contacts = new list<selectoption>();
        selectedcontact = '';
        accountid = apexpages.currentpage().getparameters().get('aid');
        id = apexpages.currentpage().getparameters().get('id');
        
        folder f = [select id from folder where name = 'AHWT Label Pictures' limit 1];
        folderid = f.id;
        
        // Changed For : Ticket 711057 - SFDC Label Request Changes for the incident #711057  Line No: 73,74
        
        if(id != null){ 
            LR = [select id, 
                  name,
                  Customer_Prospect__r.name,
                  status__c,
                  Delivery_Method__c,
                  tank_requirement__c,
                  SAP_Material__c,
                  asset_number__C,
                  model__c,
                  RecordType.Name,
                  label_request_comments__c,
                  capacity__c,
                  contact__c,
                  contact_phone__c,
                  program_type__c,
                  shipping_Instruction_product__c,
                  Stick_on_Packaged_Goods_Label__c,
                  Laminated_Lable__c,
                  Stick_On_Label_Quantity__c,
                  Fill_Line_Sign_Quantity__c,
                  Solenis_Label_Cover__c,
                  Hot_Line_Sticker__c,
                  Line_Tag__c,
                  Ultra_Serv_Inv_Mgmt_Sign_w_Label_Qty__c,
                  Large_Metal_w_Lam_Label_Fill_Line_Qty__c,
                  Tank_Placard_Quantity__c,
                  Customer_Prospect__c,
                  Full_Address__c,GHS_Cover_label__c,Case__c 
                  from Label_Request__c where id = :id limit 1];
            Accountid = LR.Customer_Prospect__r.id;     
        }
        else{
            
            LR.Customer_Prospect__c = accountid;
            a = [select id, name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account where id = :accountid limit 1];
            
            LR.Full_Address__c = a.name;
            IF(a.SAP_Street__c != null){LR.Full_Address__c += '\n' + a.SAP_Street__c;}
            IF(a.SAP_StreetSuppl1__c != null){LR.Full_Address__c += '\n' + a.SAP_StreetSuppl1__c;}
            IF(a.SAP_StreetSuppl2__c != null){LR.Full_Address__c += '\n' + a.SAP_StreetSuppl2__c;}
            LR.Full_Address__c += '\n' + a.SAP_City__c + ', ' +  a.SAP_state__c + ' ' + a.SAP_ZIP_Code__c;
            LR.Full_Address__c += '\n' + a.SAP_Country__c;
        }
        
        contact.accountid = accountid;
        docs = new list<document>();
        docs = [select name, id from document where folderid  = :folderid];
        imgmap = new map<string, string>();
        for(document d:docs){
            imgmap.put(d.name, '/servlet/servlet.FileDownload?file=' + d.id);} 
        List<Contact> contactlist = [select id, firstname, lastname, phone, email from Contact where accountid = :accountid order by lastname];
        
        contacts.add(new selectoption('', '--None--'));
        contacts.add(new selectoption(NEWCONTACT, '--Create New Contact--' ));
        for(Contact c:contactlist){
            contacts.add(new selectoption(c.id, c.lastname + ', ' + c.firstname ));
            phonemap.put(c.id, c.phone);
        }
    }
    
    private void debug(String s) {System.debug(LoggingLevel.INFO, '>>>>>>>>>>>>> ' + s);}
    
    private Boolean isNull(String s) {return s == null || s.trim().length() == 0;}
    
    public string getpic1big(){
        return imgmap.get('Picture 1 Big');}
    
    public string getpic2big(){
        return imgmap.get('Picture 2 Big');}      
    
    public string getpic3big(){
        return imgmap.get('Picture 3 Big');}
    
    
    public string getpic4big(){
        return imgmap.get('Picture 4 Big');}
    
    public string getpic5big(){
        return imgmap.get('Picture 5 Big');}
    
    public string getpic6big(){
        return imgmap.get('Picture 6 Big');}
    
    public string getpic7big(){
        return imgmap.get('Picture 7 Big');}
    
    public string getpic8big(){
        return imgmap.get('Picture 8 Big');}       
    
    public string getpic9big(){
        return imgmap.get('Picture 9 Big');}
    
    public string getpic10big(){
        return imgmap.get('Picture 10 Big');}
    
    public string getpic11big(){
        return imgmap.get('Picture 11 Big');}
    
    public string getpic12big(){
        return imgmap.get('Picture 12 Big');}
    
    public string getpic13big(){
        return imgmap.get('Picture 13 Big');}
    
    public string getpic14big(){
        return imgmap.get('Picture 14 Big');}
    
    public string getpic15big(){
        return imgmap.get('Picture 15 Big');}
    
    public string getpic16big(){
        return imgmap.get('Picture 16 Big');}
    
    public string getpic17big(){
        return imgmap.get('Picture 17 Big');}
    
    public string getpic18big(){
        return imgmap.get('Picture 18 Big');}
    
    public string getpic19big(){
        return imgmap.get('Picture 19 Big');}
        
     public string getpic20big(){
        return imgmap.get('Picture 20 Big');}
    
    
    
    public string getpic1small(){
        return imgmap.get('Picture 1 Small');}
    
    public string getpic2small(){
        return imgmap.get('Picture 2 Small');}      
    
    public string getpic3small(){
        return imgmap.get('Picture 3 Small');}
    
    public string getpic4small(){
        return imgmap.get('Picture 4 Small');}
    
    public string getpic5small(){
        return imgmap.get('Picture 5 Small');}
    
    public string getpic6small(){
        return imgmap.get('Picture 6 Small');}
    
    public string getpic7small(){
        return imgmap.get('Picture 7 Small');}
    
    public string getpic8small(){
        return imgmap.get('Picture 8 Small');}       
    
    public string getpic9small(){
        return imgmap.get('Picture 9 Small');}
    
    public string getpic10small(){
        return imgmap.get('Picture 10 Small');}
    
    public string getpic11small(){
        return imgmap.get('Picture 11 Small');}
    
    public string getpic12small(){
        return imgmap.get('Picture 12 Small');}
    
    public string getpic13small(){
        return imgmap.get('Picture 13 Small');}
    
    public string getpic14small(){
        return imgmap.get('Picture 14 Small');}
    
    public string getpic15small(){
        return imgmap.get('Picture 15 Small');}
    
    public string getpic16small(){
        return imgmap.get('Picture 16 Small');}
    
    public string getpic17small(){
        return imgmap.get('Picture 17 Small');}
    
    public string getpic18small(){
        return imgmap.get('Picture 18 Small');}
    
    public string getpic19small(){
        return imgmap.get('Picture 19 Small');}
        
    public string getpic20small(){
        return imgmap.get('Picture 20 Small');}
    
    
    public void showcontactpopup(){displaycontactpopup = true;}
    
    public pagereference hidecontactpopup(){
        displaycontactpopup = false; selectedcontact = ''; return null;
    }
    
    public String getContactStyle() {
        if (isNull(selectedcontact)) {return 'reqd';}
        return '';
    } 
    
    public void opencontactpanel(){
        LR.Contact__c = null; LR.Contact_Phone__c = null;
        debug('opencontactpanel : ' + selectedcontact);
        if(selectedcontact == NEWCONTACT){
            displaycontactpopup = true;
        } else {
            setContactInfo();
            displaycontactpopup = false;
        }
        debug('opencontactpanel : ' + lr);
    }
    
    public pagereference createcontact(){
        if (contact.Salutation == null) {contact.Salutation = '.';}
        insert contact;
        displaycontactpopup = false;
        LR.Contact__c = contact.id;
        Contacts.add(New selectoption(contact.id, Contact.LastName + ', ' + contact.Firstname));
        selectedcontact = contact.id;
        LR.Contact_Phone__c = Contact.Phone;
        phonemap.put(contact.id, contact.phone);
        return null;
    }
    
    private void addContactErrorMsg() {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Contact Required'));
    }
    
    private void setContactInfo() {
        if(!isNull(selectedcontact)) {
            LR.Contact__c = selectedcontact;
            LR.Contact_Phone__c = phonemap.get(selectedcontact);
        }
    }
    
    // Changed For : Ticket 711057 - SFDC Label Request Changes for the incident #711057-2 Line No: 249,257
    
    private pagereference upsertAndSubmitReq(Boolean submt){
        debug('upsertAndSubmitReq : ' + lr);
        debug('upsertAndSubmitReq : ' + selectedcontact);
        if(isNull(selectedcontact)) {addContactErrorMsg(); return null;} 
        else {
            if(selectedcontact == NEWCONTACT) {displaycontactpopup = true; return null;} 
            else {      
                if(LR.id == null) {
                    setContactInfo(); LR.Delivery_Method__c = 'Standard Delivery';
                    if (lr.Contact__c == null) {addContactErrorMsg(); return null;} 
                    try{
                        insert LR;
                    }
                    catch (Exception ex)
                    {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
                        ApexPages.addMessage(myMsg);
                        return null;
                    }
                } 
                else {update LR;}  
                
                if (submt) {
                    Id labelReqRecordTypeId = RecordType_Functions.LookupRecordTypeId('Submitted', 'Label_Request__c');
                    LR.Status__c = 'Submitted'; LR.RecordTypeId = labelReqRecordTypeId;
                    update LR;
                }
                return new pagereference('/' + LR.id );   
            }
        }     
    }
    
    public pagereference createreqsubmit(){
        return upsertAndSubmitReq(true);
    }
    
    public pagereference createreq(){
        return upsertAndSubmitReq(false);
    } 
}
/*****************************************************************
* Class Name     : Exp_NewContactRequestController                            *
* Author         : Aakash Wankhede                                  *
* Created Date   : 28-Sep-2023                                   *
* Modified Date  :                                    *
* Description    : Controller class used for the additional request for sold to
registration process*
*****************************************************************/
public without sharing class Exp_NewContactRequestController {

    /**
* @description create request in SAP
*/
    @AuraEnabled
    public static String createRequest(String accountNumber, String email){
        try {
            String firstname, lastName, accountId;
            
            List<Account> accountList = [Select Id,Name,ParentId,SAP_Partner_Functions__c,AccountNumber,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,SAP_Zip_Code__c From Account Where AccountNumber = :accountNumber and type='Customer' and Inactive_Account__c=FALSE and SAP_Partner_Functions__c like '%Sold to%'];
			if(accountList.isEmpty()){
                return 'Failed~~Entered Sold To Account number is Invalid';
            }
            else{
                accountId = accountList[0].Id;
            }
            //Do validation check if Contact already exist in 
            //Do validation if request already exist.
            New_Contact_Request__c[] conReq=[select id from New_Contact_Request__c where status__c in ('Pending for Approval') and B2B_Email_Address__c=:email and B2B_Account_Lookup__c=:accountid];
            Contact[] cc=[select id, FirstName, LastName, B2B_User__c from contact where email=:email and recordtype.name='SAP Contact'];                                                                                                 
            if(cc.size()>0){
                firstname = cc[0].FirstName;
                lastName = cc[0].LastName;
            }
            if(conReq.size() > 0)
            {
                return 'Failed~~Request already created for the Account, Under approval';
            }
            else
            {
                //Contact Already exist need to enable the user.                         
                AccountContactRelation[] notb2bEnabledSoldTos;
                List<AccountContactRelation> b2bEnabledSoldTos = new List<AccountContactRelation>();
                if(cc!=null&&cc.size()>0)
                {
                    b2bEnabledSoldTos =[SELECT AccountId,Account.ParentId,ContactId,Id,IsActive,SAP_Contact_Number__c,Sold_To_Account__c,Unique_Key__c,Upgraded_to_External_Account_B2B__c,Upgrade_to_External_Account__c FROM AccountContactRelation where ContactId = :cc[0].id and ( AccountId =:accountid  or Account.ParentId=: accountid ) and IsActive = true and Upgraded_to_External_Account_B2B__c = True and Account.SAP_Partner_Functions__c like '%Ship To%'];
                    
                    List<Id> b2bEnabledSOldToIds = new List<Id>();
                    for (AccountContactRelation acr : b2bEnabledSoldTos ){
                        b2bEnabledSOldToIds.add(acr.AccountId);
                    
                    }
                    //***assuming we will not get ship to contacts from SAP.
                    notb2bEnabledSoldTos=[select AccountId,id,Upgrade_to_External_Account__c,Upgraded_to_External_Account_B2B__c from AccountContactRelation where ContactId=:cc[0].id and  AccountId =:accountid  and AccountId NOT IN:b2bEnabledSOldToIds and account.isbuyer=true and Upgraded_to_External_Account_B2B__c = False ];              
                }

                //This condition is added if contact is already registered for that sold to or its ship tos.
                if(b2bEnabledSoldTos !=null && b2bEnabledSoldTos.size()>0){
                    return 'Failed~~You already have access to entered Sold To';
                }
                
                else if(notb2bEnabledSoldTos!=null && cc!=null && notb2bEnabledSoldTos.size()>0 && cc.size()>0)
                {   
                    //This coniditon is added to enable the user for this sold to or its ships without approval process
                    if(cc[0].B2B_User__c==true){
                        //delete exsiting relationship -- Contact will not be deleted as its already b2b enabled. only exisitng sold to relationship will be deleted and auto-approved request will be create so that flows can create sold to and ship to relationships as needed.
                        delete notb2bEnabledSoldTos[0];
                    
                    }
                    New_Contact_Request__c cr=new New_Contact_Request__c();
                    cr.B2B_Account_Lookup__c=accountid;
                    cr.B2B_First_name__c=firstname;
                    cr.B2B_Last_Name__c=lastName;
                    cr.B2B_Email_Address__c=email;
                    cr.Request_type__c='New';
                    cr.Is_Created_from_Exp_Site__c = true;
                    cr.Is_Additional_Sold_To_Request_from_Exp__c = true;
                    //Get Account Owner
                    if(accountid!=null)
                    {
                        Account ac=[select ownerid,Accountnumber from account where id=:accountid];
                        cr.status__C='Success in SAP';
                        cr.B2B_Customer_Number__c=ac.Accountnumber;
                    }
                    insert cr;
                    return 'Create~~Request is created successfully. You will receive an email with access details upon approval';
                }
                else {
                    New_Contact_Request__c cr=new New_Contact_Request__c();
                    cr.B2B_Account_Lookup__c=accountid;
                    cr.B2B_First_name__c=firstname;
                    cr.B2B_Last_Name__c=lastName;
                    cr.B2B_Email_Address__c=email;
                    cr.Request_type__c='New';
                    cr.Is_Created_from_Exp_Site__c = true;
                    cr.Is_Additional_Sold_To_Request_from_Exp__c = true;
                    //Get Account Owner
                    if(accountid!=null)
                    {
                        Account ac=[select ownerid,Accountnumber from account where id=:accountid];
                        //Code change to check user Activated 
                        User ur=[select id,IsActive from user where id=:ac.ownerid];
                        if(ur.IsActive!=null&&ur.IsActive==true)
                        {
                        cr.Approver__c=ac.ownerid;
                        }
                        cr.status__C='Submitted';
                        cr.B2B_Customer_Number__c=ac.Accountnumber;
                    }
                    insert cr;
                    return 'Create~~Request is created successfully. You will receive an email with access details upon approval';
                }
                
                
            }
        } catch (Exception e) {
            return 'Failed~~Error contact Solenis support~~'+e.getMessage();
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<PIMRequestDetails> getExistingPIMRequests(){
        List <PIMRequestDetails> result = new List<PIMRequestDetails>();
        for(New_Contact_Request__c req : [select id, Name, CreatedDate, Status__c from New_Contact_Request__c where B2B_Email_Address__c=:UserInfo.getUserEmail() ORDER BY CreatedDate desc]){
            result.add(new PIMRequestDetails(req.Name, req.CreatedDate, req.Status__c));
        }
        return result;
    }      

    //Result Wrapper to hold results
    public class PIMRequestDetails{
        @AuraEnabled
        public String requestId;
        @AuraEnabled
        public String requestDate;
        @AuraEnabled
        public Boolean isSubmitted=false;
        @AuraEnabled
        public Boolean isPending=false;
        @AuraEnabled
        public Boolean isApproved=false;
        @AuraEnabled
        public Boolean isRejected=false;
        @AuraEnabled
        public Boolean isError=false;
        public PIMRequestDetails(String requestId, DateTime requestDate, String status){
            this.requestId = requestId;
            this.requestDate = requestDate.format('hh:mm, MMM d, yyyy');
            switch on status {
                when 'Submitted' {
                    this.isSubmitted = true;
                }	
                when 'Pending for Approval', 'Approved' {
                    this.isPending = true;
                }
                when 'Success in SAP'{
                    this.isApproved = true;
                }
                when 'Rejected' {
                    this.isRejected = true;
                }
                when else {
                    this.isError=true;
                }
            }
        }
    }
}
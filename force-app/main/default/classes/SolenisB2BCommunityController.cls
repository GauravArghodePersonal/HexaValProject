/*****************************************************************
* Class Name     : SolenisB2BCommunityController                            *
* Author         : Donald JP                                    *
* Created Date   : 27-Mar-2022                                   *
* Modified Date  : 21-Apr-2021                                   *
* Description    : Controller class used for the
registration process*
*****************************************************************/

public without sharing class SolenisB2BCommunityController {
    
    /**
* @description constructor
*/
    public SolenisB2BCommunityController()
    {
        
    }
    
    /**
* @description getAccount Address
*/
    @AuraEnabled
    public static List<Account> getAccountAddress(String accountNumber, String salesOrg){
        try {
            
            List<Account> acccountList = new List<Account>();
            acccountList = [Select Id,Name, AccountNumber,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,SAP_Zip_Code__c From Account Where AccountNumber = :accountNumber and SAP_Sales_Org__c=:salesOrg and type='Customer' and SAP_Partner_Functions__c like '%Sold to%' ];
            
            if(acccountList.size()>=1)
            {
                system.debug('Account Found'+acccountList);
                return acccountList;
            }
            else {
                system.debug('Account Not Found');
                acccountList=null;
                return acccountList; 
            }
            
            // return !userList.isEmpty();
            
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
            
            // return null;
        }
    }
    /**
* @description create request in SAP
*/
    @AuraEnabled
    public static String createRequest(String accountid, String title,String firstname,String lastName, String phone, String email){
        try {
            //Do validation check if Contact already exist in 
            system.debug('Inside Test01');
            system.debug('Inside 1'+email);
            system.debug('Inside 2'+accountid);
            
            //Do validation if request already exist.
            New_Contact_Request__c[] conReq=[select id from New_Contact_Request__c where status__c in ('Pending for Approval') and B2B_Email_Address__c=:email and B2B_Account_Lookup__c=:accountid];
            Contact[] cc=[select id,B2B_User__c from contact where email=:email and recordtype.name='SAP Contact'];                                                                                                 
            system.debug('Old Request Size'+conReq.size());
            if(conReq.size() > 0)
            {
                system.debug('Inside request already in place Test');
                system.debug(conReq[0].id);
                //  throw new AuraHandledException('Contact already created');
                return 'Failed~~Request already created for the Account, Under approval';
            }
            else
            {
                system.debug('Request not in place');
                system.debug('Request not in place1');
                system.debug('Request not in place1'+cc.size());
                //Contact Already exist need to enable the user.                         
                AccountContactRelation[] notb2bEnabledSoldTos;
                List<AccountContactRelation> b2bEnabledSoldTos = new List<AccountContactRelation>();
                if(cc!=null&&cc.size()>0)
                {
                    system.debug('inside Account relation'+cc[0].id );
                    system.debug('inside Account relation'+accountid);
         
                    b2bEnabledSoldTos =[SELECT AccountId,Account.ParentId,ContactId,Id,IsActive,SAP_Contact_Number__c,Sold_To_Account__c,Unique_Key__c,Upgraded_to_External_Account_B2B__c,Upgrade_to_External_Account__c FROM AccountContactRelation where ContactId = :cc[0].id and ( AccountId =:accountid  or Account.ParentId=: accountid ) and IsActive = true and Upgraded_to_External_Account_B2B__c = True and Account.SAP_Partner_Functions__c like '%Ship To%'];
                    
                    List<Id> b2bEnabledSOldToIds = new List<Id>();
                    for (AccountContactRelation acr : b2bEnabledSoldTos ){
                        b2bEnabledSOldToIds.add(acr.AccountId);
                    
                    }
                    //***assuming we will not get ship to contacts from SAP.
                    notb2bEnabledSoldTos=[select AccountId,id,Upgrade_to_External_Account__c,Upgraded_to_External_Account_B2B__c from AccountContactRelation where ContactId=:cc[0].id and  AccountId =:accountid  and AccountId NOT IN:b2bEnabledSOldToIds  and Upgraded_to_External_Account_B2B__c = False ];              
                }   
                // system.debug('Account Relationship Size'+req.size());
                system.debug('notb2bEnabledSoldTos++++++++++'+notb2bEnabledSoldTos);
                //system.debug('notb2bEnabledSoldTos size++++++++++'+notb2bEnabledSoldTos.size());
                system.debug('b2bEnabledSoldTos++++++++++'+b2bEnabledSoldTos);
                //system.debug('b2bEnabledSoldTos size++++++++++'+b2bEnabledSoldTos.size());

                //This condition is added if contact is already registered for that sold to or its ship tos.
                if(b2bEnabledSoldTos !=null && b2bEnabledSoldTos.size()>0){
                    system.debug('Contact already created with b2bEnabledSoldTos');
                    //throw new AuraHandledException('Contact already created');
                    return 'Failed~~Contact already created for the same Email Id';
                }
                
                else if(notb2bEnabledSoldTos!=null && cc!=null && notb2bEnabledSoldTos.size()>0 && cc.size()>0)
                {   
                    //This coniditon is added to enable the user for this sold to or its ships without approval process
                    if(cc[0].B2B_User__c==true){
                        //delete exsiting relationship -- Conatct will not be deleted as its already b2b enabled. only exisitng sold to relationship will be deleted and auto-approved request will be create so that flows can create sold to and ship to relationships as needed.
                        delete notb2bEnabledSoldTos[0];
                    
                    }
                    system.debug('Inside auto-approved request creation +++++++');
                    New_Contact_Request__c cr=new New_Contact_Request__c();
                    cr.B2B_Account_Lookup__c=accountid;
                    cr.B2B_Title__c=title;
                    cr.B2B_First_name__c=firstname;
                    cr.B2B_Last_Name__c=lastName;
                    cr.B2B_Phone__c=phone;
                    cr.B2B_Email_Address__c=email;
                    cr.Request_type__c='New';
                    //Get Account Owner
                    if(accountid!=null)
                    {
                        Account ac=[select ownerid,Accountnumber from account where id=:accountid];
                        cr.status__C='Success in SAP';
                        cr.B2B_Customer_Number__c=ac.Accountnumber;
                    }
                    insert cr;
                    
                    system.debug('Created Successfully'+cr.ID);
                    return 'Create~~Request is created successfully. You will receive an email with access details upon approval';
                }
                else {
                    system.debug('Inside request creation for approval++++++');
                    New_Contact_Request__c cr=new New_Contact_Request__c();
                    cr.B2B_Account_Lookup__c=accountid;
                    cr.B2B_Title__c=title;
                    cr.B2B_First_name__c=firstname;
                    cr.B2B_Last_Name__c=lastName;
                    cr.B2B_Phone__c=phone;
                    cr.B2B_Email_Address__c=email;
                    cr.Request_type__c='New';
                    //Get Account Owner
                    if(accountid!=null)
                    {
                        Account ac=[select ownerid,Accountnumber from account where id=:accountid];
                        system.debug('TEST123'+ac.ownerid);
                        //Code change to check user Activated 
                        User ur=[select id,IsActive from user where id=:ac.ownerid];
                            if(ur.IsActive!=null&&ur.IsActive==true)
                        {
                        cr.Approver__c=ac.ownerid;
                        }
                        cr.status__C='Submitted';
                        cr.B2B_Customer_Number__c=ac.Accountnumber;
                    }
                    system.debug('Created Successfully'+cr.Approver__c);
                    insert cr;
                    
                    system.debug('Created Successfully'+cr.ID);
                    // return cr.ID;
                    return 'Create~~Request is created successfully. You will receive an email with access details upon approval';
                }
                
                
                //Contact information 
                
                
                // return !userList.isEmpty();
                
                
            }
        } catch (Exception e) {
            return 'Failed~~Error contact Solenis support~~'+e.getMessage();
            // throw new AuraHandledException(e.getMessage());
            
            // return null;
        }
    }
}
public with sharing class SolenisCChReadController {
  @AuraEnabled
    public static sObject getAccContact(Id ccrId) {
        system.debug('=====AcctList====='+ccrId);
        Id accId;
        List<Customer_Creation_Request__C> ccr=new List<Customer_Creation_Request__C>();
        ccr=[select SAP_Contact__c from Customer_Creation_Request__C where id=:ccrId];
        if(ccr!=null)
        {
          accId=ccr.get(0).SAP_Contact__c;  
        }
        String ObjName = accId.getSObjectType().getDescribe().getName();
        List<sobject> RecordInstance = new List<sobject>();
        if(objName == 'SAP_Contact__c'){
            List<SAP_Contact__c> accList=[select SAP_Phone__c,Account_Name__c,SAP_Customer_Number__c,SAP_Department_Code__c,id,First_Name__c,Last_Name__c,SAP_Department_Desc__c,SAP_Contact_Number__c,SAP_Title__c,SAP_Email__c,SAP_Fax__c from SAP_Contact__c where id =:accId];
            if(!accList.isEmpty()){
                RecordInstance = accList;
                system.debug('CCR instance '+RecordInstance);
            }
        }
        if(!RecordInstance.isEmpty()){
            system.debug('RecordInstance'+RecordInstance[0]);
            return RecordInstance[0]; 
        }
        else
            return null;
    }
    @AuraEnabled
    public static sObject getAcc(Id ccrId) {
        system.debug('=====AcctList====='+ccrId);
        Id accId;
        List<Customer_Creation_Request__C> ccr=new List<Customer_Creation_Request__C>();
        ccr=[select Account__c from Customer_Creation_Request__C where id=:ccrId];
        if(ccr!=null)
        {
          accId=ccr.get(0).Account__c;  
        }
        String ObjName = accId.getSObjectType().getDescribe().getName();
        List<sobject> RecordInstance = new List<sobject>();
        if(objName == 'Account'){
            List<Account> accList=[select id,NameLocal,SAP_CustomerGroup_Desc3__c,SAP_INCO_Terms1_Desc__c,SAP_Sales_Org_Region_value__c,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,Country_Code__c,HQ_Account__r.Name,
                                   Name,OwnerId, Owner.Name,Owner.Ashland_Employee_Number__c, Owner.SAP_Cust_Num__c,Parent.Name,Parent.SAP_Customer_Number__c,
                                   SAP_Account_Name_2__c,SAP_Currency__c,SAP_Customer_Group_1__c,SAP_Customer_Group_2__c,SAP_Customer_Group_3__c, SAP_StreetSuppl1__c,SAP_StreetSuppl2__c,SAP_StreetSuppl3__c,SAP_House_Number__c,SAP_House_Number_2__c,V_PO_Box__c,
                                   SAP_Zip_Code__c,SAP_Customer_Group__c,SAP_INCO_Terms1__c,SAP_INCO_Terms2__c,SAP_SalesDistrict__c,SAP_SalesGroup__c,SAP_Sales_Office__c, SAP_DistChannel__c,SAP_DistChannel_Desc__c,SAP_DivisionCode__c,SAP_DivisionCode_Desc__c,
                                   SAP_Sales_Org__c, DivisionNodeNo__c, SAP_SalesOrg_Desc__c, SAP_Sales_District_Desc__c, SAP_SalesDistrict_Desc__c, SAP_SalesOffice_Desc__c,SAP_ShippingPlant__c,SAP_Partner_Functions__c,StreetFormulaFields__c,
                                   SAP_SalesGroup_Desc__c,SAP_CustomerGroup_Desc__c,SAP_CustomerGroup_Desc1__c,SAP_CustomerGroup_Desc2__c,ToLabel(CurrencyIsoCode) countryDesc from Account where id =:accId];
            if(!accList.isEmpty()){
                if((accList.get(0).SAP_Sales_Org__c.contains('0070'))||(accList.get(0).SAP_Sales_Org__c.contains('0869')))
                {
                  
                } 
                else
                {
                   accList.get(0).NameLocal =accList.get(0).Name; 
                }
                RecordInstance = accList;
                system.debug('CCR instance '+RecordInstance);
            }
        }
        if(!RecordInstance.isEmpty()){
            system.debug('RecordInstance'+RecordInstance[0]);
            return RecordInstance[0]; 
        }
        else
            return null;
    }
    
    @AuraEnabled
    public static Customer_Creation_Request__c getCCR(String ccrId) {
        system.debug('=====ccrList====='+ccrId);
        List<Customer_Creation_Request__c> ccrList = new List<Customer_Creation_Request__c>();
        ccrList=[select id, Account__c, Region__c, CCR_Sales_Organization__c, CCR_Sales_District__c, CCR_Sales_Office__c, Sales_Group__c, Customer_Group__c,CCR_Customer_Group1__c,
                 CCR_Customer_Group2__c,Customer_Group_3__c,Incoterms__c,Incoterms_2__c,Name_3__c,Parent_Account__c,SAP_Contact__c,CCR_DIst_Channel__c,CCR_Division__c,
                 Postal_Code__c,Country__c, Currency__c, SAP_CustomerNumber__c,SAP_Contact_Number__c,BillingStreet__c,Street_2__c,Street_3__c,
                 House_Number1__c,House_Number2__c,PO_Box__c from Customer_Creation_Request__c where id =:ccrId];
        return ccrList[0];
    }
    
     @AuraEnabled
    public static Customer_Creation_Request__c getDuplicate(String ccrId) {
        system.debug('=====ccrList====='+ccrId);
        List<Customer_Creation_Request__c> ccrList = new List<Customer_Creation_Request__c>();
        ccrList=[select id,Duplicate_Request_CreatedBy__c,Duplicate_Request_Number__c,Change_Request_Count__c,Change_Request_Status__c from Customer_Creation_Request__c where id =:ccrId];
        return ccrList[0];
    }
    
        @AuraEnabled
    public static Customer_Creation_Request__c getDuplicateCon(String ccrId) {
        system.debug('=====ccrList====='+ccrId);
        List<Customer_Creation_Request__c> ccrList = new List<Customer_Creation_Request__c>();
        ccrList=[select id,Duplicate_Contact_CreatedBy__c,Duplicate_Contact_Number__c,Change_Contact_Count__c,Change_Contact_Status__c from Customer_Creation_Request__c where id =:ccrId];
        return ccrList[0];
    }
    
}
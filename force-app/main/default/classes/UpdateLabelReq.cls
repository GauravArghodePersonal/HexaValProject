public class UpdateLabelReq
{
    private final Label_Request__c labelReq;
    
    public boolean statusUpdateFlag {get; set;}
    
    public Label_Request__c lb;
       
    public UpdateLabelReq(ApexPages.StandardController stdController) 
    {
        this.labelReq = (Label_Request__c) stdController.getRecord();
        
        lb = [Select Id, Name, Contact__c, Contact_Phone__c, Customer_Prospect__c, Street_Address_1__c, Street_Address_2__c, Street_Address_3__c, Street_Address_4__c, City__c, State__c, Zip_Postal_Code__c, Country__c, Status__c from Label_Request__c where Id =: labelReq.Id];

    }
    
    public PageReference updateAccCon()
    {
        String accNumber;
        
        lb.Contact_Phone__c = [Select Id, Name, Phone from Contact where Id =: lb.Contact__c].Phone;
        
        Account acc = [Select Id, Name, RecordTypeId, RecordType.Name, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_StreetSuppl3__c, SAP_City__c, SAP_State__c, SAP_Zip_Code__c, SAP_Country__c, SAP_Customer_Number__c, CIS_Prospect_Number__c, Type from Account where Id =: lb.Customer_Prospect__c];
        lb.Street_Address_1__c = acc.SAP_Street__c;
        lb.Street_Address_2__c = acc.SAP_StreetSuppl1__c;
        lb.Street_Address_3__c = acc.SAP_StreetSuppl2__c;
        lb.Street_Address_4__c = acc.SAP_StreetSuppl3__c;
        lb.City__c = acc.SAP_City__c;
        lb.State__c = acc.SAP_State__c;
        lb.Zip_Postal_Code__c = acc.SAP_Zip_Code__c;
        lb.Country__c = acc.SAP_Country__c;
        
        if(acc.RecordType.Name.indexOf('Customer')>-1)
        accNumber = acc.SAP_Customer_Number__c;
        else if(acc.RecordType.Name.indexOf('Prospect')>-1)
        accNumber = acc.CIS_Prospect_Number__c;
        else accNumber = acc.SAP_Customer_Number__c;
        
        lb.Customer_Prospect_Number__c = accNumber;
        
        update lb;
        return null;
    }
    
    public PageReference updateStatus()
    {
        //Map<String, Schema.RecordTypeInfo> rtMapByNameLabelReq = Label_Request__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        //Id labelReqRecordTypeId = rtMapByNameLabelReq.get('Submitted').getRecordTypeId();
        Id labelReqRecordTypeId = RecordType_Functions.LookupRecordTypeId('Submitted', 'Label_Request__c');
        
        lb.Status__c = 'Submitted';
        lb.RecordTypeId = labelReqRecordTypeId;
        
        update lb;
        return null;
    }
    
    @AuraEnabled 
    public static String updateStatusHandler(String labelRequestId) {
        Label_Request__c lb = [Select Id, Name, Contact__c, Contact_Phone__c, 
                Customer_Prospect__c, Street_Address_1__c, Street_Address_2__c, Street_Address_3__c, 
                Street_Address_4__c, City__c, State__c, Zip_Postal_Code__c, Country__c, Status__c 
                FROM Label_Request__c where Id =: labelRequestId];
        if(lb.Status__c != 'Draft'){
            return 'Label Request is not in a draft status, so it can not be submitted.';
        }else{
            Id labelReqRecordTypeId = RecordType_Functions.LookupRecordTypeId('Submitted', 'Label_Request__c');
            lb.Status__c = 'Submitted';
            lb.RecordTypeId = labelReqRecordTypeId;        
            update lb;
            return lb.Id;
        }
    }                 
}
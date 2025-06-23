public class Pricing_Rebate_EmailController {

    public String pricing_Rebate_Id{get;set;}
    
    public Pricing_Rebate__c getHeader() {
    	Pricing_Rebate__c hdr = new Pricing_Rebate__c();
        If(pricing_Rebate_Id != null) {
        	hdr = [select Id, Name, Condition_Type__c, CreatedBy.Full_Name__c,
            Dist_Channel__c, Dist_Channel_Description__c, Division__c,
            Division_Description__c, Internal_Comments__c, LastModifiedBy.Full_Name__c,
            Rebate_Agreement_Type__c, Rebate_End_Date__c, Rebate_Recipient__r.Name,
            Rebate_Recipient__r.Owner.Name, Rebate_Recipient__r.SAP_Currency__c,
            Rebate_Recipient_account_number__c, Rebate_Start_Date__c, Sales_Org__c,
            Sales_Org_Description__c, SAP_Rebate_Agreement_Number__c, Status__c
        	from Pricing_Rebate__c where Id = :pricing_Rebate_Id];
        }
        return hdr;        
    } 
        
    public List<Pricing_Rebate_Detail__c> getDetail() {
        List<Pricing_Rebate_Detail__c> alist = new List<Pricing_Rebate_Detail__c>();

        If(pricing_Rebate_Id != null) {
        
            for(Pricing_Rebate_Detail__c a : [SELECT Id, Name,
                         Account__r.AccountNumber, Account__r.Name,
                         Accrual__c, Amount__c, Approved_Rebate__c,
                         Change_Tracker__c, Customer_Name_and_Number__c, 
                         Material_Sales_Data2__c, 
                         Material_Sales_Data2__r.Material_Number__c, 
                         Material_Sales_Data2__r.Material_Desc__c, 
                         MFD__c, MFD_Text__c, Per__c, Pricing_Rebate__c, 
                         Table__c, Unit__c, UoM__c 
                    FROM Pricing_Rebate_Detail__c  
                   WHERE Pricing_Rebate__c = :pricing_Rebate_Id
                ORDER BY Account__r.Account_Number__c, Material_Sales_Data2__r.Material_Number__c]) {
            
                a.Account__r.AccountNumber = String_Functions.removeLeadingZeros(a.Account__r.AccountNumber);
                if (a.Material_Sales_Data2__r.Material_Number__c != null) {
                    a.Material_Sales_Data2__r.Material_Number__c = String_Functions.removeLeadingZeros(a.Material_Sales_Data2__r.Material_Number__c);
                }

                if (a.Change_Tracker__c == null) {
                    if (a.Approved_Rebate__c) { a.Change_Tracker__c = 'No Change'; }
                    else { a.Change_Tracker__c = 'New'; }
                }

                alist.add(a);
            }
        }
        return alist;
    }

}
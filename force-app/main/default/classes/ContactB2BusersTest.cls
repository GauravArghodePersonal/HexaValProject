@IsTest
public class ContactB2BusersTest {
    
    @IsTest static void createContacts(){
        
         Account acc = new Account();
        acc.Name = 'Test 5';
        acc.ParentId = '0015000000tvxEv';
        acc.Type = 'Prospect';
        acc.AccountNumber = 'P704122';
        acc.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        acc.country_picklist__c = 'Afghanistan (AF)';
        acc.Prospect_Division__c = 'AAFI (50)';
        acc.Prospect_Sales_District__c = 'ADDITIVES (11100)';
        acc.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
        acc.Prospect_Sales_Group__c = 'AM ARG/URU';
        acc.Prospect_Dist_Channel__c = 'AAFI (50)';
        acc.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
        acc.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Group__c = 'ADDITIVES (11)';
        acc.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Price_Group_Desc__c = 'A';
        acc.SAP_Country__c = 'US';
        acc.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
        acc.SAP_Customer_Number__c = '12345';
        acc.Ship_To_Customer_Number__c = '12345';
        acc.SAP_Sales_Office__c='IW31';
        acc.SAP_SalesGroup__c='18I';        
        acc.SAP_SalesDistrict__c='IWNA1';
        acc.RecordTypeId = '01250000000HmZ3AAK';
        insert acc;
      
        Id recordTypeIds = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SAP Contact').getRecordTypeId();
        for(Integer i = 0; i <=5; i++){
            Contact c = new Contact();
            c.RecordTypeId = recordTypeIds;
            c.LastName = 'Test ' + i;
            c.FirstName = 'Name';
            c.Email = 'test'+ i + '@solenistest.com';
            c.Phone = '9876543210';
            c.Title = 'test '+ i;
            c.B2B_User__c = true;
            c.AccountId=acc.Id;
            INSERT C;
            
        }
       List<Contact> conList =  ContactB2Busers.getconList();
        List<Id> conId = new List<Id>();
        for(Contact c : [select Id from Contact LIMIT 5]){
            conId.add(c.Id);
        }
        ContactB2Busers.sendEmail(conId,'vbattula@contractor.solenis.com');
        
    }

}
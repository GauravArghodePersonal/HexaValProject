@isTest
public class TestObjects {

/********************************************
 * Test Account Generation
 *********************************************/
    public static Account newAccount() {return newAccount('');}
    public static Account newAccount(Boolean insertRec) {return newAccount('',insertRec);}
    public static Account newAccount(Map<String,String> fieldValues) {return newAccount('',fieldValues, true);}
    public static Account newAccount(Map<String,String> fieldValues, Boolean insertRec) {return newAccount('',fieldValues, insertRec);}
    public static Account newAccount(String templateType) {return newAccount(templateType,true);}
    public static Account newAccount(String templateType, Boolean insertRec) {return newAccount(templateType,new Map<String,String>(),insertRec);}
    public static Account newAccount(String templateType, Map<String,String> fieldValues, Boolean insertRec) {
        createPriceFx();
        return (Account)newSObject('Account', templateType, fieldValues, insertRec);
    }


/********************************************
 * Test AccountTeamMember Generation
 *********************************************/
    public static AccountTeamMember newAccountTeamMember() {return newAccountTeamMember('');}
    public static AccountTeamMember newAccountTeamMember(Boolean insertRec) {return newAccountTeamMember('',insertRec);}
    public static AccountTeamMember newAccountTeamMember(Map<String,String> fieldValues) {return newAccountTeamMember('',fieldValues, true);}
    public static AccountTeamMember newAccountTeamMember(Map<String,String> fieldValues, Boolean insertRec) {return newAccountTeamMember('',fieldValues, insertRec);}
    public static AccountTeamMember newAccountTeamMember(String templateType) {return newAccountTeamMember(templateType,true);}
    public static AccountTeamMember newAccountTeamMember(String templateType, Boolean insertRec) {return newAccountTeamMember(templateType,new Map<String,String>(),insertRec);}
    public static AccountTeamMember newAccountTeamMember(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (AccountTeamMember)newSObject('AccountTeamMember', templateType, fieldValues, insertRec);}


/********************************************
 * Test Account_Relationship__c Generation
 *********************************************/
    public static Account_Relationship__c newAccount_Relationship() {return newAccount_Relationship('');}
    public static Account_Relationship__c newAccount_Relationship(Boolean insertRec) {return newAccount_Relationship('',insertRec);}
    public static Account_Relationship__c newAccount_Relationship(Map<String,String> fieldValues) {return newAccount_Relationship('',fieldValues, true);}
    public static Account_Relationship__c newAccount_Relationship(Map<String,String> fieldValues, Boolean insertRec) {return newAccount_Relationship('',fieldValues, insertRec);}
    public static Account_Relationship__c newAccount_Relationship(String templateType) {return newAccount_Relationship(templateType,true);}
    public static Account_Relationship__c newAccount_Relationship(String templateType, Boolean insertRec) {return newAccount_Relationship(templateType,new Map<String,String>(),insertRec);}
    public static Account_Relationship__c newAccount_Relationship(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Account_Relationship__c)newSObject('Account_Relationship__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Account_Sales_Figure__c Generation
 *********************************************/
    public static Account_Sales_Figure__c newAccount_Sales_Figure() {return newAccount_Sales_Figure('');}
    public static Account_Sales_Figure__c newAccount_Sales_Figure(Boolean insertRec) {return newAccount_Sales_Figure('',insertRec);}
    public static Account_Sales_Figure__c newAccount_Sales_Figure(Map<String,String> fieldValues) {return newAccount_Sales_Figure('',fieldValues, true);}
    public static Account_Sales_Figure__c newAccount_Sales_Figure(Map<String,String> fieldValues, Boolean insertRec) {return newAccount_Sales_Figure('',fieldValues, insertRec);}
    public static Account_Sales_Figure__c newAccount_Sales_Figure(String templateType) {return newAccount_Sales_Figure(templateType,true);}
    public static Account_Sales_Figure__c newAccount_Sales_Figure(String templateType, Boolean insertRec) {return newAccount_Sales_Figure(templateType,new Map<String,String>(),insertRec);}
    public static Account_Sales_Figure__c newAccount_Sales_Figure(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Account_Sales_Figure__c)newSObject('Account_Sales_Figure__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Action_Plan__c Generation
 *********************************************/
    public static Action_Plan__c newAction_Plan() {return newAction_Plan('');}
    public static Action_Plan__c newAction_Plan(Boolean insertRec) {return newAction_Plan('',insertRec);}
    public static Action_Plan__c newAction_Plan(Map<String,String> fieldValues) {return newAction_Plan('',fieldValues, true);}
    public static Action_Plan__c newAction_Plan(Map<String,String> fieldValues, Boolean insertRec) {return newAction_Plan('',fieldValues, insertRec);}
    public static Action_Plan__c newAction_Plan(String templateType) {return newAction_Plan(templateType,true);}
    public static Action_Plan__c newAction_Plan(String templateType, Boolean insertRec) {return newAction_Plan(templateType,new Map<String,String>(),insertRec);}
    public static Action_Plan__c newAction_Plan(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Action_Plan__c)newSObject('Action_Plan__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Activity_User_Group__c Generation
 *********************************************/
    public static Activity_User_Group__c newActivity_User_Group() {return newActivity_User_Group('');}
    public static Activity_User_Group__c newActivity_User_Group(Boolean insertRec) {return newActivity_User_Group('',insertRec);}
    public static Activity_User_Group__c newActivity_User_Group(Map<String,String> fieldValues) {return newActivity_User_Group('',fieldValues, true);}
    public static Activity_User_Group__c newActivity_User_Group(Map<String,String> fieldValues, Boolean insertRec) {return newActivity_User_Group('',fieldValues, insertRec);}
    public static Activity_User_Group__c newActivity_User_Group(String templateType) {return newActivity_User_Group(templateType,true);}
    public static Activity_User_Group__c newActivity_User_Group(String templateType, Boolean insertRec) {return newActivity_User_Group(templateType,new Map<String,String>(),insertRec);}
    public static Activity_User_Group__c newActivity_User_Group(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Activity_User_Group__c)newSObject('Activity_User_Group__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test ART_Project__c Generation
 *********************************************/
    public static ART_Project__c newART_Project() {return newART_Project('');}
    public static ART_Project__c newART_Project(Boolean insertRec) {return newART_Project('',insertRec);}
    public static ART_Project__c newART_Project(Map<String,String> fieldValues) {return newART_Project('',fieldValues, true);}
    public static ART_Project__c newART_Project(Map<String,String> fieldValues, Boolean insertRec) {return newART_Project('',fieldValues, insertRec);}
    public static ART_Project__c newART_Project(String templateType) {return newART_Project(templateType,true);}
    public static ART_Project__c newART_Project(String templateType, Boolean insertRec) {return newART_Project(templateType,new Map<String,String>(),insertRec);}
    public static ART_Project__c newART_Project(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (ART_Project__c)newSObject('ART_Project__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test ART_Request__c Generation
 *********************************************/
    public static ART_Request__c newART_Request() {return newART_Request('');}
    public static ART_Request__c newART_Request(Boolean insertRec) {return newART_Request('',insertRec);}
    public static ART_Request__c newART_Request(Map<String,String> fieldValues) {return newART_Request('',fieldValues, true);}
    public static ART_Request__c newART_Request(Map<String,String> fieldValues, Boolean insertRec) {return newART_Request('',fieldValues, insertRec);}
    public static ART_Request__c newART_Request(String templateType) {return newART_Request(templateType,true);}
    public static ART_Request__c newART_Request(String templateType, Boolean insertRec) {return newART_Request(templateType,new Map<String,String>(),insertRec);}
    public static ART_Request__c newART_Request(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (ART_Request__c)newSObject('ART_Request__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test ART_Release__c Generation
 *********************************************/
    public static ART_Release__c newART_Release() {return newART_Release('');}
    public static ART_Release__c newART_Release(Boolean insertRec) {return newART_Release('',insertRec);}
    public static ART_Release__c newART_Release(Map<String,String> fieldValues) {return newART_Release('',fieldValues, true);}
    public static ART_Release__c newART_Release(Map<String,String> fieldValues, Boolean insertRec) {return newART_Release('',fieldValues, insertRec);}
    public static ART_Release__c newART_Release(String templateType) {return newART_Release(templateType,true);}
    public static ART_Release__c newART_Release(String templateType, Boolean insertRec) {return newART_Release(templateType,new Map<String,String>(),insertRec);}
    public static ART_Release__c newART_Release(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (ART_Release__c)newSObject('ART_Release__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Asset Generation
 *********************************************/
    public static Asset newAsset() {return newAsset('');}
    public static Asset newAsset(Boolean insertRec) {return newAsset('',insertRec);}
    public static Asset newAsset(Map<String,String> fieldValues) {return newAsset('',fieldValues, true);}
    public static Asset newAsset(Map<String,String> fieldValues, Boolean insertRec) {return newAsset('',fieldValues, insertRec);}
    public static Asset newAsset(String templateType) {return newAsset(templateType,true);}
    public static Asset newAsset(String templateType, Boolean insertRec) {return newAsset(templateType,new Map<String,String>(),insertRec);}
    public static Asset newAsset(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Asset)newSObject('Asset', templateType, fieldValues, insertRec);}


/********************************************
 * Test Attachment Generation
 *********************************************/
    public static Attachment newAttachment() {return newAttachment('');}
    public static Attachment newAttachment(Boolean insertRec) {return newAttachment('',insertRec);}
    public static Attachment newAttachment(Map<String,String> fieldValues) {return newAttachment('',fieldValues, true);}
    public static Attachment newAttachment(Map<String,String> fieldValues, Boolean insertRec) {return newAttachment('',fieldValues, insertRec);}
    public static Attachment newAttachment(String templateType) {return newAttachment(templateType,true);}
    public static Attachment newAttachment(String templateType, Boolean insertRec) {return newAttachment(templateType,new Map<String,String>(),insertRec);}
    public static Attachment newAttachment(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Attachment)newSObject('Attachment', templateType, fieldValues, insertRec);}


/********************************************
 * Test Attachment_Folder__c Generation
 *********************************************/
    public static Attachment_Folder__c newAttachment_Folder() {return newAttachment_Folder('');}
    public static Attachment_Folder__c newAttachment_Folder(Boolean insertRec) {return newAttachment_Folder('',insertRec);}
    public static Attachment_Folder__c newAttachment_Folder(Map<String,String> fieldValues) {return newAttachment_Folder('',fieldValues, true);}
    public static Attachment_Folder__c newAttachment_Folder(Map<String,String> fieldValues, Boolean insertRec) {return newAttachment_Folder('',fieldValues, insertRec);}
    public static Attachment_Folder__c newAttachment_Folder(String templateType) {return newAttachment_Folder(templateType,true);}
    public static Attachment_Folder__c newAttachment_Folder(String templateType, Boolean insertRec) {return newAttachment_Folder(templateType,new Map<String,String>(),insertRec);}
    public static Attachment_Folder__c newAttachment_Folder(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Attachment_Folder__c)newSObject('Attachment_Folder__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Business_Contract__c Generation
 *********************************************/
    public static Business_Contract__c newBusiness_Contract() {return newBusiness_Contract('');}
    public static Business_Contract__c newBusiness_Contract(Boolean insertRec) {return newBusiness_Contract('',insertRec);}
    public static Business_Contract__c newBusiness_Contract(Map<String,String> fieldValues) {return newBusiness_Contract('',fieldValues, true);}
    public static Business_Contract__c newBusiness_Contract(Map<String,String> fieldValues, Boolean insertRec) {return newBusiness_Contract('',fieldValues, insertRec);}
    public static Business_Contract__c newBusiness_Contract(String templateType) {return newBusiness_Contract(templateType,true);}
    public static Business_Contract__c newBusiness_Contract(String templateType, Boolean insertRec) {return newBusiness_Contract(templateType,new Map<String,String>(),insertRec);}
    public static Business_Contract__c newBusiness_Contract(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Business_Contract__c)newSObject('Business_Contract__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Call_Report__c Generation
 *********************************************/
    public static Call_Report__c newCall_Report() {return newCall_Report('');}
    public static Call_Report__c newCall_Report(Boolean insertRec) {return newCall_Report('',insertRec);}
    public static Call_Report__c newCall_Report(Map<String,String> fieldValues) {return newCall_Report('',fieldValues, true);}
    public static Call_Report__c newCall_Report(Map<String,String> fieldValues, Boolean insertRec) {return newCall_Report('',fieldValues, insertRec);}
    public static Call_Report__c newCall_Report(String templateType) {return newCall_Report(templateType,true);}
    public static Call_Report__c newCall_Report(String templateType, Boolean insertRec) {return newCall_Report(templateType,new Map<String,String>(),insertRec);}
    public static Call_Report__c newCall_Report(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Call_Report__c)newSObject('Call_Report__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Case Generation
 *********************************************/
    public static Case newCase() {return newCase('');}
    public static Case newCase(Boolean insertRec) {return newCase('',insertRec);}
    public static Case newCase(Map<String,String> fieldValues) {return newCase('',fieldValues, true);}
    public static Case newCase(Map<String,String> fieldValues, Boolean insertRec) {return newCase('',fieldValues, insertRec);}
    public static Case newCase(String templateType) {return newCase(templateType,true);}
    public static Case newCase(String templateType, Boolean insertRec) {return newCase(templateType,new Map<String,String>(),insertRec);}
    public static Case newCase(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Case)newSObject('Case', templateType, fieldValues, insertRec);}


/********************************************
 * Test Chemical_Competitive__c Generation
 *********************************************/
    public static Chemical_Competitive__c newChemical_Competitive() {return newChemical_Competitive('');}
    public static Chemical_Competitive__c newChemical_Competitive(Boolean insertRec) {return newChemical_Competitive('',insertRec);}
    public static Chemical_Competitive__c newChemical_Competitive(Map<String,String> fieldValues) {return newChemical_Competitive('',fieldValues, true);}
    public static Chemical_Competitive__c newChemical_Competitive(Map<String,String> fieldValues, Boolean insertRec) {return newChemical_Competitive('',fieldValues, insertRec);}
    public static Chemical_Competitive__c newChemical_Competitive(String templateType) {return newChemical_Competitive(templateType,true);}
    public static Chemical_Competitive__c newChemical_Competitive(String templateType, Boolean insertRec) {return newChemical_Competitive(templateType,new Map<String,String>(),insertRec);}
    public static Chemical_Competitive__c newChemical_Competitive(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Chemical_Competitive__c)newSObject('Chemical_Competitive__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test CISRelationships__c Generation
 *********************************************/
    public static CISRelationships__c newCISRelationships() {return newCISRelationships('');}
    public static CISRelationships__c newCISRelationships(Boolean insertRec) {return newCISRelationships('',insertRec);}
    public static CISRelationships__c newCISRelationships(Map<String,String> fieldValues) {return newCISRelationships('',fieldValues, true);}
    public static CISRelationships__c newCISRelationships(Map<String,String> fieldValues, Boolean insertRec) {return newCISRelationships('',fieldValues, insertRec);}
    public static CISRelationships__c newCISRelationships(String templateType) {return newCISRelationships(templateType,true);}
    public static CISRelationships__c newCISRelationships(String templateType, Boolean insertRec) {return newCISRelationships(templateType,new Map<String,String>(),insertRec);}
    public static CISRelationships__c newCISRelationships(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (CISRelationships__c)newSObject('CISRelationships__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Competitor__c Generation
 *********************************************/
    public static Competitor__c newCompetitor() {return newCompetitor('');}
    public static Competitor__c newCompetitor(Boolean insertRec) {return newCompetitor('',insertRec);}
    public static Competitor__c newCompetitor(Map<String,String> fieldValues) {return newCompetitor('',fieldValues, true);}
    public static Competitor__c newCompetitor(Map<String,String> fieldValues, Boolean insertRec) {return newCompetitor('',fieldValues, insertRec);}
    public static Competitor__c newCompetitor(String templateType) {return newCompetitor(templateType,true);}
    public static Competitor__c newCompetitor(String templateType, Boolean insertRec) {return newCompetitor(templateType,new Map<String,String>(),insertRec);}
    public static Competitor__c newCompetitor(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Competitor__c)newSObject('Competitor__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Competitor_to_Account__c Generation
 *********************************************/
    public static Competitor_to_Account__c newCompetitor_to_Account() {return newCompetitor_to_Account('');}
    public static Competitor_to_Account__c newCompetitor_to_Account(Boolean insertRec) {return newCompetitor_to_Account('',insertRec);}
    public static Competitor_to_Account__c newCompetitor_to_Account(Map<String,String> fieldValues) {return newCompetitor_to_Account('',fieldValues, true);}
    public static Competitor_to_Account__c newCompetitor_to_Account(Map<String,String> fieldValues, Boolean insertRec) {return newCompetitor_to_Account('',fieldValues, insertRec);}
    public static Competitor_to_Account__c newCompetitor_to_Account(String templateType) {return newCompetitor_to_Account(templateType,true);}
    public static Competitor_to_Account__c newCompetitor_to_Account(String templateType, Boolean insertRec) {return newCompetitor_to_Account(templateType,new Map<String,String>(),insertRec);}
    public static Competitor_to_Account__c newCompetitor_to_Account(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Competitor_to_Account__c)newSObject('Competitor_to_Account__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Competitor_to_Opportunity__c Generation
 *********************************************/
    public static Competitor_to_Opportunity__c newCompetitor_to_Opportunity() {return newCompetitor_to_Opportunity('');}
    public static Competitor_to_Opportunity__c newCompetitor_to_Opportunity(Boolean insertRec) {return newCompetitor_to_Opportunity('',insertRec);}
    public static Competitor_to_Opportunity__c newCompetitor_to_Opportunity(Map<String,String> fieldValues) {return newCompetitor_to_Opportunity('',fieldValues, true);}
    public static Competitor_to_Opportunity__c newCompetitor_to_Opportunity(Map<String,String> fieldValues, Boolean insertRec) {return newCompetitor_to_Opportunity('',fieldValues, insertRec);}
    public static Competitor_to_Opportunity__c newCompetitor_to_Opportunity(String templateType) {return newCompetitor_to_Opportunity(templateType,true);}
    public static Competitor_to_Opportunity__c newCompetitor_to_Opportunity(String templateType, Boolean insertRec) {return newCompetitor_to_Opportunity(templateType,new Map<String,String>(),insertRec);}
    public static Competitor_to_Opportunity__c newCompetitor_to_Opportunity(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Competitor_to_Opportunity__c)newSObject('Competitor_to_Opportunity__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Consumption__c Generation
 *********************************************/
    public static Consumption__c newConsumption() {return newConsumption('');}
    public static Consumption__c newConsumption(Boolean insertRec) {return newConsumption('',insertRec);}
    public static Consumption__c newConsumption(Map<String,String> fieldValues) {return newConsumption('',fieldValues, true);}
    public static Consumption__c newConsumption(Map<String,String> fieldValues, Boolean insertRec) {return newConsumption('',fieldValues, insertRec);}
    public static Consumption__c newConsumption(String templateType) {return newConsumption(templateType,true);}
    public static Consumption__c newConsumption(String templateType, Boolean insertRec) {return newConsumption(templateType,new Map<String,String>(),insertRec);}
    public static Consumption__c newConsumption(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Consumption__c)newSObject('Consumption__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Consumption_Competitive_Product__c Generation
 *********************************************/
    public static Consumption_Competitive_Product__c newConsumption_Competitive_Product() {return newConsumption_Competitive_Product('');}
    public static Consumption_Competitive_Product__c newConsumption_Competitive_Product(Boolean insertRec) {return newConsumption_Competitive_Product('',insertRec);}
    public static Consumption_Competitive_Product__c newConsumption_Competitive_Product(Map<String,String> fieldValues) {return newConsumption_Competitive_Product('',fieldValues, true);}
    public static Consumption_Competitive_Product__c newConsumption_Competitive_Product(Map<String,String> fieldValues, Boolean insertRec) {return newConsumption_Competitive_Product('',fieldValues, insertRec);}
    public static Consumption_Competitive_Product__c newConsumption_Competitive_Product(String templateType) {return newConsumption_Competitive_Product(templateType,true);}
    public static Consumption_Competitive_Product__c newConsumption_Competitive_Product(String templateType, Boolean insertRec) {return newConsumption_Competitive_Product(templateType,new Map<String,String>(),insertRec);}
    public static Consumption_Competitive_Product__c newConsumption_Competitive_Product(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Consumption_Competitive_Product__c)newSObject('Consumption_Competitive_Product__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Contact Generation
 *********************************************/
    public static Contact newContact() {return newContact('');}
    public static Contact newContact(Boolean insertRec) {return newContact('',insertRec);}
    public static Contact newContact(Map<String,String> fieldValues) {return newContact('',fieldValues, true);}
    public static Contact newContact(Map<String,String> fieldValues, Boolean insertRec) {return newContact('',fieldValues, insertRec);}
    public static Contact newContact(String templateType) {return newContact(templateType,true);}
    public static Contact newContact(String templateType, Boolean insertRec) {return newContact(templateType,new Map<String,String>(),insertRec);}
    public static Contact newContact(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Contact)newSObject('Contact', templateType, fieldValues, insertRec);}


/********************************************
 * Test Customer_Group__c Generation
 *********************************************/
    public static Customer_Group__c newCustomer_Group() {return newCustomer_Group('');}
    public static Customer_Group__c newCustomer_Group(Boolean insertRec) {return newCustomer_Group('',insertRec);}
    public static Customer_Group__c newCustomer_Group(Map<String,String> fieldValues) {return newCustomer_Group('',fieldValues, true);}
    public static Customer_Group__c newCustomer_Group(Map<String,String> fieldValues, Boolean insertRec) {return newCustomer_Group('',fieldValues, insertRec);}
    public static Customer_Group__c newCustomer_Group(String templateType) {return newCustomer_Group(templateType,true);}
    public static Customer_Group__c newCustomer_Group(String templateType, Boolean insertRec) {return newCustomer_Group(templateType,new Map<String,String>(),insertRec);}
    public static Customer_Group__c newCustomer_Group(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Customer_Group__c)newSObject('Customer_Group__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Customer_Product_Info__c Generation
 *********************************************/
    public static Customer_Product_Info__c newCustomer_Product_Info() {return newCustomer_Product_Info('');}
    public static Customer_Product_Info__c newCustomer_Product_Info(Boolean insertRec) {return newCustomer_Product_Info('',insertRec);}
    public static Customer_Product_Info__c newCustomer_Product_Info(Map<String,String> fieldValues) {return newCustomer_Product_Info('',fieldValues, true);}
    public static Customer_Product_Info__c newCustomer_Product_Info(Map<String,String> fieldValues, Boolean insertRec) {return newCustomer_Product_Info('',fieldValues, insertRec);}
    public static Customer_Product_Info__c newCustomer_Product_Info(String templateType) {return newCustomer_Product_Info(templateType,true);}
    public static Customer_Product_Info__c newCustomer_Product_Info(String templateType, Boolean insertRec) {return newCustomer_Product_Info(templateType,new Map<String,String>(),insertRec);}
    public static Customer_Product_Info__c newCustomer_Product_Info(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Customer_Product_Info__c)newSObject('Customer_Product_Info__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test EmailTemplate Generation
 *********************************************/
    public static EmailTemplate newEmailTemplate() {return newEmailTemplate('');}
    public static EmailTemplate newEmailTemplate(Boolean insertRec) {return newEmailTemplate('',insertRec);}
    public static EmailTemplate newEmailTemplate(Map<String,String> fieldValues) {return newEmailTemplate('',fieldValues, true);}
    public static EmailTemplate newEmailTemplate(Map<String,String> fieldValues, Boolean insertRec) {return newEmailTemplate('',fieldValues, insertRec);}
    public static EmailTemplate newEmailTemplate(String templateType) {return newEmailTemplate(templateType,true);}
    public static EmailTemplate newEmailTemplate(String templateType, Boolean insertRec) {return newEmailTemplate(templateType,new Map<String,String>(),insertRec);}
    public static EmailTemplate newEmailTemplate(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (EmailTemplate)newSObject('EmailTemplate', templateType, fieldValues, insertRec);}


/********************************************
 * Test EPA_Code__c Generation
 *********************************************/
    public static EPA_Code__c newEPA_Code() {return newEPA_Code('');}
    public static EPA_Code__c newEPA_Code(Boolean insertRec) {return newEPA_Code('',insertRec);}
    public static EPA_Code__c newEPA_Code(Map<String,String> fieldValues) {return newEPA_Code('',fieldValues, true);}
    public static EPA_Code__c newEPA_Code(Map<String,String> fieldValues, Boolean insertRec) {return newEPA_Code('',fieldValues, insertRec);}
    public static EPA_Code__c newEPA_Code(String templateType) {return newEPA_Code(templateType,true);}
    public static EPA_Code__c newEPA_Code(String templateType, Boolean insertRec) {return newEPA_Code(templateType,new Map<String,String>(),insertRec);}
    public static EPA_Code__c newEPA_Code(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (EPA_Code__c)newSObject('EPA_Code__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Equipment__c Generation
 *********************************************/
/* 
    public static Equipment__c newEquipment() {return newEquipment('');}
    public static Equipment__c newEquipment(Boolean insertRec) {return newEquipment('',insertRec);}
    public static Equipment__c newEquipment(Map<String,String> fieldValues) {return newEquipment('',fieldValues, true);}
    public static Equipment__c newEquipment(Map<String,String> fieldValues, Boolean insertRec) {return newEquipment('',fieldValues, insertRec);}
    public static Equipment__c newEquipment(String templateType) {return newEquipment(templateType,true);}
    public static Equipment__c newEquipment(String templateType, Boolean insertRec) {return newEquipment(templateType,new Map<String,String>(),insertRec);}
    public static Equipment__c newEquipment(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Equipment__c)newSObject('Equipment__c', templateType, fieldValues, insertRec);}
*/

/********************************************
 * Test Event Generation
 *********************************************/
    public static Event newEvent() {return newEvent('');}
    public static Event newEvent(Boolean insertRec) {return newEvent('',insertRec);}
    public static Event newEvent(Map<String,String> fieldValues) {return newEvent('',fieldValues, true);}
    public static Event newEvent(Map<String,String> fieldValues, Boolean insertRec) {return newEvent('',fieldValues, insertRec);}
    public static Event newEvent(String templateType) {return newEvent(templateType,true);}
    public static Event newEvent(String templateType, Boolean insertRec) {return newEvent(templateType,new Map<String,String>(),insertRec);}
    public static Event newEvent(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Event)newSObject('Event', templateType, fieldValues, insertRec);}


/********************************************
 * Test ES_Profile__c Generation
 *********************************************/
    public static ES_Profile__c newES_Profile() {return newES_Profile('');}
    public static ES_Profile__c newES_Profile(Boolean insertRec) {return newES_Profile('',insertRec);}
    public static ES_Profile__c newES_Profile(Map<String,String> fieldValues) {return newES_Profile('',fieldValues, true);}
    public static ES_Profile__c newES_Profile(Map<String,String> fieldValues, Boolean insertRec) {return newES_Profile('',fieldValues, insertRec);}
    public static ES_Profile__c newES_Profile(String templateType) {return newES_Profile(templateType,true);}
    public static ES_Profile__c newES_Profile(String templateType, Boolean insertRec) {return newES_Profile(templateType,new Map<String,String>(),insertRec);}
    public static ES_Profile__c newES_Profile(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (ES_Profile__c)newSObject('ES_Profile__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Goal__c Generation
 *********************************************/
    public static Goal__c newGoal() {return newGoal('');}
    public static Goal__c newGoal(Boolean insertRec) {return newGoal('',insertRec);}
    public static Goal__c newGoal(Map<String,String> fieldValues) {return newGoal('',fieldValues, true);}
    public static Goal__c newGoal(Map<String,String> fieldValues, Boolean insertRec) {return newGoal('',fieldValues, insertRec);}
    public static Goal__c newGoal(String templateType) {return newGoal(templateType,true);}
    public static Goal__c newGoal(String templateType, Boolean insertRec) {return newGoal(templateType,new Map<String,String>(),insertRec);}
    public static Goal__c newGoal(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Goal__c)newSObject('Goal__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Group Generation
 *********************************************/
    public static Group newGroup() {return newGroup('');}
    public static Group newGroup(Boolean insertRec) {return newGroup('',insertRec);}
    public static Group newGroup(Map<String,String> fieldValues) {return newGroup('',fieldValues, true);}
    public static Group newGroup(Map<String,String> fieldValues, Boolean insertRec) {return newGroup('',fieldValues, insertRec);}
    public static Group newGroup(String templateType) {return newGroup(templateType,true);}
    public static Group newGroup(String templateType, Boolean insertRec) {return newGroup(templateType,new Map<String,String>(),insertRec);}
    public static Group newGroup(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Group)newSObject('Group', templateType, fieldValues, insertRec);}


/********************************************
 * Test Label_Request__c Generation
 *********************************************/
    public static Label_Request__c newLabel_Request() {return newLabel_Request('');}
    public static Label_Request__c newLabel_Request(Boolean insertRec) {return newLabel_Request('',insertRec);}
    public static Label_Request__c newLabel_Request(Map<String,String> fieldValues) {return newLabel_Request('',fieldValues, true);}
    public static Label_Request__c newLabel_Request(Map<String,String> fieldValues, Boolean insertRec) {return newLabel_Request('',fieldValues, insertRec);}
    public static Label_Request__c newLabel_Request(String templateType) {return newLabel_Request(templateType,true);}
    public static Label_Request__c newLabel_Request(String templateType, Boolean insertRec) {return newLabel_Request(templateType,new Map<String,String>(),insertRec);}
    public static Label_Request__c newLabel_Request(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Label_Request__c)newSObject('Label_Request__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Label_Vendor__c Generation
 *********************************************/
    public static Label_Vendor__c newLabel_Vendor() {return newLabel_Vendor('');}
    public static Label_Vendor__c newLabel_Vendor(Boolean insertRec) {return newLabel_Vendor('',insertRec);}
    public static Label_Vendor__c newLabel_Vendor(Map<String,String> fieldValues) {return newLabel_Vendor('',fieldValues, true);}
    public static Label_Vendor__c newLabel_Vendor(Map<String,String> fieldValues, Boolean insertRec) {return newLabel_Vendor('',fieldValues, insertRec);}
    public static Label_Vendor__c newLabel_Vendor(String templateType) {return newLabel_Vendor(templateType,true);}
    public static Label_Vendor__c newLabel_Vendor(String templateType, Boolean insertRec) {return newLabel_Vendor(templateType,new Map<String,String>(),insertRec);}
    public static Label_Vendor__c newLabel_Vendor(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Label_Vendor__c)newSObject('Label_Vendor__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Lead Generation
 *********************************************/
    public static Lead newLead() {return newLead('');}
    public static Lead newLead(Boolean insertRec) {return newLead('',insertRec);}
    public static Lead newLead(Map<String,String> fieldValues) {return newLead('',fieldValues, true);}
    public static Lead newLead(Map<String,String> fieldValues, Boolean insertRec) {return newLead('',fieldValues, insertRec);}
    public static Lead newLead(String templateType) {return newLead(templateType,true);}
    public static Lead newLead(String templateType, Boolean insertRec) {return newLead(templateType,new Map<String,String>(),insertRec);}
    public static Lead newLead(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Lead)newSObject('Lead', templateType, fieldValues, insertRec);}


/********************************************
 * Test Material_Base_Code__c Generation
 *********************************************/
    public static Material_Base_Code__c newMaterial_Base_Code() {return newMaterial_Base_Code('');}
    public static Material_Base_Code__c newMaterial_Base_Code(Boolean insertRec) {return newMaterial_Base_Code('',insertRec);}
    public static Material_Base_Code__c newMaterial_Base_Code(Map<String,String> fieldValues) {return newMaterial_Base_Code('',fieldValues, true);}
    public static Material_Base_Code__c newMaterial_Base_Code(Map<String,String> fieldValues, Boolean insertRec) {return newMaterial_Base_Code('',fieldValues, insertRec);}
    public static Material_Base_Code__c newMaterial_Base_Code(String templateType) {return newMaterial_Base_Code(templateType,true);}
    public static Material_Base_Code__c newMaterial_Base_Code(String templateType, Boolean insertRec) {return newMaterial_Base_Code(templateType,new Map<String,String>(),insertRec);}
    public static Material_Base_Code__c newMaterial_Base_Code(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Material_Base_Code__c)newSObject('Material_Base_Code__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Material_Container_Code__c Generation
 *********************************************/
    public static Material_Container_Code__c newMaterial_Container_Code() {return newMaterial_Container_Code('');}
    public static Material_Container_Code__c newMaterial_Container_Code(Boolean insertRec) {return newMaterial_Container_Code('',insertRec);}
    public static Material_Container_Code__c newMaterial_Container_Code(Map<String,String> fieldValues) {return newMaterial_Container_Code('',fieldValues, true);}
    public static Material_Container_Code__c newMaterial_Container_Code(Map<String,String> fieldValues, Boolean insertRec) {return newMaterial_Container_Code('',fieldValues, insertRec);}
    public static Material_Container_Code__c newMaterial_Container_Code(String templateType) {return newMaterial_Container_Code(templateType,true);}
    public static Material_Container_Code__c newMaterial_Container_Code(String templateType, Boolean insertRec) {return newMaterial_Container_Code(templateType,new Map<String,String>(),insertRec);}
    public static Material_Container_Code__c newMaterial_Container_Code(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Material_Container_Code__c)newSObject('Material_Container_Code__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Material_Description__c Generation
 *********************************************/
    public static Material_Description__c newMaterial_Description() {return newMaterial_Description('');}
    public static Material_Description__c newMaterial_Description(Boolean insertRec) {return newMaterial_Description('',insertRec);}
    public static Material_Description__c newMaterial_Description(Map<String,String> fieldValues) {return newMaterial_Description('',fieldValues, true);}
    public static Material_Description__c newMaterial_Description(Map<String,String> fieldValues, Boolean insertRec) {return newMaterial_Description('',fieldValues, insertRec);}
    public static Material_Description__c newMaterial_Description(String templateType) {return newMaterial_Description(templateType,true);}
    public static Material_Description__c newMaterial_Description(String templateType, Boolean insertRec) {return newMaterial_Description(templateType,new Map<String,String>(),insertRec);}
    public static Material_Description__c newMaterial_Description(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Material_Description__c)newSObject('Material_Description__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Material_General_Data__c Generation
 *********************************************/
    public static Material_General_Data__c newMaterial_General_Data() {return newMaterial_General_Data('');}
    public static Material_General_Data__c newMaterial_General_Data(Boolean insertRec) {return newMaterial_General_Data('',insertRec);}
    public static Material_General_Data__c newMaterial_General_Data(Map<String,String> fieldValues) {return newMaterial_General_Data('',fieldValues, true);}
    public static Material_General_Data__c newMaterial_General_Data(Map<String,String> fieldValues, Boolean insertRec) {return newMaterial_General_Data('',fieldValues, insertRec);}
    public static Material_General_Data__c newMaterial_General_Data(String templateType) {return newMaterial_General_Data(templateType,true);}
    public static Material_General_Data__c newMaterial_General_Data(String templateType, Boolean insertRec) {return newMaterial_General_Data(templateType,new Map<String,String>(),insertRec);}
    public static Material_General_Data__c newMaterial_General_Data(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Material_General_Data__c)newSObject('Material_General_Data__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Material_General_Data2__c Generation
 *********************************************/
    public static Material_General_Data2__c newMaterial_General_Data2() {return newMaterial_General_Data2('');}
    public static Material_General_Data2__c newMaterial_General_Data2(Boolean insertRec) {return newMaterial_General_Data2('',insertRec);}
    public static Material_General_Data2__c newMaterial_General_Data2(Map<String,String> fieldValues) {return newMaterial_General_Data2('',fieldValues, true);}
    public static Material_General_Data2__c newMaterial_General_Data2(Map<String,String> fieldValues, Boolean insertRec) {return newMaterial_General_Data2('',fieldValues, insertRec);}
    public static Material_General_Data2__c newMaterial_General_Data2(String templateType) {return newMaterial_General_Data2(templateType,true);}
    public static Material_General_Data2__c newMaterial_General_Data2(String templateType, Boolean insertRec) {return newMaterial_General_Data2(templateType,new Map<String,String>(),insertRec);}
    public static Material_General_Data2__c newMaterial_General_Data2(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Material_General_Data2__c)newSObject('Material_General_Data2__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Material_Group__c Generation
 *********************************************/
    public static Material_Group__c newMaterial_Group() {return newMaterial_Group('');}
    public static Material_Group__c newMaterial_Group(Boolean insertRec) {return newMaterial_Group('',insertRec);}
    public static Material_Group__c newMaterial_Group(Map<String,String> fieldValues) {return newMaterial_Group('',fieldValues, true);}
    public static Material_Group__c newMaterial_Group(Map<String,String> fieldValues, Boolean insertRec) {return newMaterial_Group('',fieldValues, insertRec);}
    public static Material_Group__c newMaterial_Group(String templateType) {return newMaterial_Group(templateType,true);}
    public static Material_Group__c newMaterial_Group(String templateType, Boolean insertRec) {return newMaterial_Group(templateType,new Map<String,String>(),insertRec);}
    public static Material_Group__c newMaterial_Group(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Material_Group__c)newSObject('Material_Group__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Material_Plant__c Generation
 *********************************************/
    public static Material_Plant__c newMaterial_Plant() {return newMaterial_Plant('');}
    public static Material_Plant__c newMaterial_Plant(Boolean insertRec) {return newMaterial_Plant('',insertRec);}
    public static Material_Plant__c newMaterial_Plant(Map<String,String> fieldValues) {return newMaterial_Plant('',fieldValues, true);}
    public static Material_Plant__c newMaterial_Plant(Map<String,String> fieldValues, Boolean insertRec) {return newMaterial_Plant('',fieldValues, insertRec);}
    public static Material_Plant__c newMaterial_Plant(String templateType) {return newMaterial_Plant(templateType,true);}
    public static Material_Plant__c newMaterial_Plant(String templateType, Boolean insertRec) {return newMaterial_Plant(templateType,new Map<String,String>(),insertRec);}
    public static Material_Plant__c newMaterial_Plant(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Material_Plant__c)newSObject('Material_Plant__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Material_Plant2__c Generation
 *********************************************/
    public static Material_Plant2__c newMaterial_Plant2() {return newMaterial_Plant2('');}
    public static Material_Plant2__c newMaterial_Plant2(Boolean insertRec) {return newMaterial_Plant2('',insertRec);}
    public static Material_Plant2__c newMaterial_Plant2(Map<String,String> fieldValues) {return newMaterial_Plant2('',fieldValues, true);}
    public static Material_Plant2__c newMaterial_Plant2(Map<String,String> fieldValues, Boolean insertRec) {return newMaterial_Plant2('',fieldValues, insertRec);}
    public static Material_Plant2__c newMaterial_Plant2(String templateType) {return newMaterial_Plant2(templateType,true);}
    public static Material_Plant2__c newMaterial_Plant2(String templateType, Boolean insertRec) {return newMaterial_Plant2(templateType,new Map<String,String>(),insertRec);}
    public static Material_Plant2__c newMaterial_Plant2(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Material_Plant2__c)newSObject('Material_Plant2__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Material_Pricing_Group1__c Generation
 *********************************************/
    public static Material_Pricing_Group1__c newMaterial_Pricing_Group1() {return newMaterial_Pricing_Group1('');}
    public static Material_Pricing_Group1__c newMaterial_Pricing_Group1(Boolean insertRec) {return newMaterial_Pricing_Group1('',insertRec);}
    public static Material_Pricing_Group1__c newMaterial_Pricing_Group1(Map<String,String> fieldValues) {return newMaterial_Pricing_Group1('',fieldValues, true);}
    public static Material_Pricing_Group1__c newMaterial_Pricing_Group1(Map<String,String> fieldValues, Boolean insertRec) {return newMaterial_Pricing_Group1('',fieldValues, insertRec);}
    public static Material_Pricing_Group1__c newMaterial_Pricing_Group1(String templateType) {return newMaterial_Pricing_Group1(templateType,true);}
    public static Material_Pricing_Group1__c newMaterial_Pricing_Group1(String templateType, Boolean insertRec) {return newMaterial_Pricing_Group1(templateType,new Map<String,String>(),insertRec);}
    public static Material_Pricing_Group1__c newMaterial_Pricing_Group1(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Material_Pricing_Group1__c)newSObject('Material_Pricing_Group1__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Material_Pricing_Group2__c Generation
 *********************************************/
    public static Material_Pricing_Group2__c newMaterial_Pricing_Group2() {return newMaterial_Pricing_Group2('');}
    public static Material_Pricing_Group2__c newMaterial_Pricing_Group2(Boolean insertRec) {return newMaterial_Pricing_Group2('',insertRec);}
    public static Material_Pricing_Group2__c newMaterial_Pricing_Group2(Map<String,String> fieldValues) {return newMaterial_Pricing_Group2('',fieldValues, true);}
    public static Material_Pricing_Group2__c newMaterial_Pricing_Group2(Map<String,String> fieldValues, Boolean insertRec) {return newMaterial_Pricing_Group2('',fieldValues, insertRec);}
    public static Material_Pricing_Group2__c newMaterial_Pricing_Group2(String templateType) {return newMaterial_Pricing_Group2(templateType,true);}
    public static Material_Pricing_Group2__c newMaterial_Pricing_Group2(String templateType, Boolean insertRec) {return newMaterial_Pricing_Group2(templateType,new Map<String,String>(),insertRec);}
    public static Material_Pricing_Group2__c newMaterial_Pricing_Group2(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Material_Pricing_Group2__c)newSObject('Material_Pricing_Group2__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Material_Sales_Data__c Generation
 *********************************************/
    public static Material_Sales_Data__c newMaterial_Sales_Data() {return newMaterial_Sales_Data('');}
    public static Material_Sales_Data__c newMaterial_Sales_Data(Boolean insertRec) {return newMaterial_Sales_Data('',insertRec);}
    public static Material_Sales_Data__c newMaterial_Sales_Data(Map<String,String> fieldValues) {return newMaterial_Sales_Data('',fieldValues, true);}
    public static Material_Sales_Data__c newMaterial_Sales_Data(Map<String,String> fieldValues, Boolean insertRec) {return newMaterial_Sales_Data('',fieldValues, insertRec);}
    public static Material_Sales_Data__c newMaterial_Sales_Data(String templateType) {return newMaterial_Sales_Data(templateType,true);}
    public static Material_Sales_Data__c newMaterial_Sales_Data(String templateType, Boolean insertRec) {return newMaterial_Sales_Data(templateType,new Map<String,String>(),insertRec);}
    public static Material_Sales_Data__c newMaterial_Sales_Data(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Material_Sales_Data__c)newSObject('Material_Sales_Data__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Material_Sales_Data2__c Generation
 *********************************************/
    public static Material_Sales_Data2__c newMaterial_Sales_Data2() {return newMaterial_Sales_Data2('');}
    public static Material_Sales_Data2__c newMaterial_Sales_Data2(Boolean insertRec) {return newMaterial_Sales_Data2('',insertRec);}
    public static Material_Sales_Data2__c newMaterial_Sales_Data2(Map<String,String> fieldValues) {return newMaterial_Sales_Data2('',fieldValues, true);}
    public static Material_Sales_Data2__c newMaterial_Sales_Data2(Map<String,String> fieldValues, Boolean insertRec) {return newMaterial_Sales_Data2('',fieldValues, insertRec);}
    public static Material_Sales_Data2__c newMaterial_Sales_Data2(String templateType) {return newMaterial_Sales_Data2(templateType,true);}
    public static Material_Sales_Data2__c newMaterial_Sales_Data2(String templateType, Boolean insertRec) {return newMaterial_Sales_Data2(templateType,new Map<String,String>(),insertRec);}
    public static Material_Sales_Data2__c newMaterial_Sales_Data2(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Material_Sales_Data2__c)newSObject('Material_Sales_Data2__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Material_Type__c Generation
 *********************************************/
    public static Material_Type__c newMaterial_Type() {return newMaterial_Type('');}
    public static Material_Type__c newMaterial_Type(Boolean insertRec) {return newMaterial_Type('',insertRec);}
    public static Material_Type__c newMaterial_Type(Map<String,String> fieldValues) {return newMaterial_Type('',fieldValues, true);}
    public static Material_Type__c newMaterial_Type(Map<String,String> fieldValues, Boolean insertRec) {return newMaterial_Type('',fieldValues, insertRec);}
    public static Material_Type__c newMaterial_Type(String templateType) {return newMaterial_Type(templateType,true);}
    public static Material_Type__c newMaterial_Type(String templateType, Boolean insertRec) {return newMaterial_Type(templateType,new Map<String,String>(),insertRec);}
    public static Material_Type__c newMaterial_Type(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Material_Type__c)newSObject('Material_Type__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Material_UOM__c Generation
 *********************************************/
    public static Material_UOM__c newMaterial_UOM() {return newMaterial_UOM('');}
    public static Material_UOM__c newMaterial_UOM(Boolean insertRec) {return newMaterial_UOM('',insertRec);}
    public static Material_UOM__c newMaterial_UOM(Map<String,String> fieldValues) {return newMaterial_UOM('',fieldValues, true);}
    public static Material_UOM__c newMaterial_UOM(Map<String,String> fieldValues, Boolean insertRec) {return newMaterial_UOM('',fieldValues, insertRec);}
    public static Material_UOM__c newMaterial_UOM(String templateType) {return newMaterial_UOM(templateType,true);}
    public static Material_UOM__c newMaterial_UOM(String templateType, Boolean insertRec) {return newMaterial_UOM(templateType,new Map<String,String>(),insertRec);}
    public static Material_UOM__c newMaterial_UOM(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Material_UOM__c)newSObject('Material_UOM__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Material_UOM2__c Generation
 *********************************************/
    public static Material_UOM2__c newMaterial_UOM2() {return newMaterial_UOM2('');}
    public static Material_UOM2__c newMaterial_UOM2(Boolean insertRec) {return newMaterial_UOM2('',insertRec);}
    public static Material_UOM2__c newMaterial_UOM2(Map<String,String> fieldValues) {return newMaterial_UOM2('',fieldValues, true);}
    public static Material_UOM2__c newMaterial_UOM2(Map<String,String> fieldValues, Boolean insertRec) {return newMaterial_UOM2('',fieldValues, insertRec);}
    public static Material_UOM2__c newMaterial_UOM2(String templateType) {return newMaterial_UOM2(templateType,true);}
    public static Material_UOM2__c newMaterial_UOM2(String templateType, Boolean insertRec) {return newMaterial_UOM2(templateType,new Map<String,String>(),insertRec);}
    public static Material_UOM2__c newMaterial_UOM2(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Material_UOM2__c)newSObject('Material_UOM2__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Material_Valuation__c Generation
 *********************************************/
    public static Material_Valuation__c newMaterial_Valuation() {return newMaterial_Valuation('');}
    public static Material_Valuation__c newMaterial_Valuation(Boolean insertRec) {return newMaterial_Valuation('',insertRec);}
    public static Material_Valuation__c newMaterial_Valuation(Map<String,String> fieldValues) {return newMaterial_Valuation('',fieldValues, true);}
    public static Material_Valuation__c newMaterial_Valuation(Map<String,String> fieldValues, Boolean insertRec) {return newMaterial_Valuation('',fieldValues, insertRec);}
    public static Material_Valuation__c newMaterial_Valuation(String templateType) {return newMaterial_Valuation(templateType,true);}
    public static Material_Valuation__c newMaterial_Valuation(String templateType, Boolean insertRec) {return newMaterial_Valuation(templateType,new Map<String,String>(),insertRec);}
    public static Material_Valuation__c newMaterial_Valuation(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Material_Valuation__c)newSObject('Material_Valuation__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Merging_Record_Type__c Generation
 *********************************************/
    public static Merging_Record_Type__c newMerging_Record_Type() {return newMerging_Record_Type('');}
    public static Merging_Record_Type__c newMerging_Record_Type(Boolean insertRec) {return newMerging_Record_Type('',insertRec);}
    public static Merging_Record_Type__c newMerging_Record_Type(Map<String,String> fieldValues) {return newMerging_Record_Type('',fieldValues, true);}
    public static Merging_Record_Type__c newMerging_Record_Type(Map<String,String> fieldValues, Boolean insertRec) {return newMerging_Record_Type('',fieldValues, insertRec);}
    public static Merging_Record_Type__c newMerging_Record_Type(String templateType) {return newMerging_Record_Type(templateType,true);}
    public static Merging_Record_Type__c newMerging_Record_Type(String templateType, Boolean insertRec) {return newMerging_Record_Type(templateType,new Map<String,String>(),insertRec);}
    public static Merging_Record_Type__c newMerging_Record_Type(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Merging_Record_Type__c)newSObject('Merging_Record_Type__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Nexeo_Competitor__c Generation
 *********************************************/
    public static Nexeo_Competitor__c newNexeo_Competitor() {return newNexeo_Competitor('');}
    public static Nexeo_Competitor__c newNexeo_Competitor(Boolean insertRec) {return newNexeo_Competitor('',insertRec);}
    public static Nexeo_Competitor__c newNexeo_Competitor(Map<String,String> fieldValues) {return newNexeo_Competitor('',fieldValues, true);}
    public static Nexeo_Competitor__c newNexeo_Competitor(Map<String,String> fieldValues, Boolean insertRec) {return newNexeo_Competitor('',fieldValues, insertRec);}
    public static Nexeo_Competitor__c newNexeo_Competitor(String templateType) {return newNexeo_Competitor(templateType,true);}
    public static Nexeo_Competitor__c newNexeo_Competitor(String templateType, Boolean insertRec) {return newNexeo_Competitor(templateType,new Map<String,String>(),insertRec);}
    public static Nexeo_Competitor__c newNexeo_Competitor(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Nexeo_Competitor__c)newSObject('Nexeo_Competitor__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Open_Orders__c Generation
 *********************************************/
    public static Open_Orders__c newOpen_Orders() {return newOpen_Orders('');}
    public static Open_Orders__c newOpen_Orders(Boolean insertRec) {return newOpen_Orders('',insertRec);}
    public static Open_Orders__c newOpen_Orders(Map<String,String> fieldValues) {return newOpen_Orders('',fieldValues, true);}
    public static Open_Orders__c newOpen_Orders(Map<String,String> fieldValues, Boolean insertRec) {return newOpen_Orders('',fieldValues, insertRec);}
    public static Open_Orders__c newOpen_Orders(String templateType) {return newOpen_Orders(templateType,true);}
    public static Open_Orders__c newOpen_Orders(String templateType, Boolean insertRec) {return newOpen_Orders(templateType,new Map<String,String>(),insertRec);}
    public static Open_Orders__c newOpen_Orders(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Open_Orders__c)newSObject('Open_Orders__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Opportunity Generation
 *********************************************/
    public static Opportunity newOpportunity() {return newOpportunity('');}
    public static Opportunity newOpportunity(Boolean insertRec) {return newOpportunity('',insertRec);}
    public static Opportunity newOpportunity(Map<String,String> fieldValues) {return newOpportunity('',fieldValues, true);}
    public static Opportunity newOpportunity(Map<String,String> fieldValues, Boolean insertRec) {return newOpportunity('',fieldValues, insertRec);}
    public static Opportunity newOpportunity(String templateType) {return newOpportunity(templateType,true);}
    public static Opportunity newOpportunity(String templateType, Boolean insertRec) {return newOpportunity(templateType,new Map<String,String>(),insertRec);}
    public static Opportunity newOpportunity(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Opportunity)newSObject('Opportunity', templateType, fieldValues, insertRec);}


/********************************************
 * Test Opportunity_Material__c Generation
 *********************************************/
    public static Opportunity_Material__c newOpportunity_Material() {return newOpportunity_Material('');}
    public static Opportunity_Material__c newOpportunity_Material(Boolean insertRec) {return newOpportunity_Material('',insertRec);}
    public static Opportunity_Material__c newOpportunity_Material(Map<String,String> fieldValues) {return newOpportunity_Material('',fieldValues, true);}
    public static Opportunity_Material__c newOpportunity_Material(Map<String,String> fieldValues, Boolean insertRec) {return newOpportunity_Material('',fieldValues, insertRec);}
    public static Opportunity_Material__c newOpportunity_Material(String templateType) {return newOpportunity_Material(templateType,true);}
    public static Opportunity_Material__c newOpportunity_Material(String templateType, Boolean insertRec) {return newOpportunity_Material(templateType,new Map<String,String>(),insertRec);}
    public static Opportunity_Material__c newOpportunity_Material(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Opportunity_Material__c)newSObject('Opportunity_Material__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Plastics_Lost_Order__c Generation
 *********************************************/
    public static Plastics_Lost_Order__c newPlastics_Lost_Order() {return newPlastics_Lost_Order('');}
    public static Plastics_Lost_Order__c newPlastics_Lost_Order(Boolean insertRec) {return newPlastics_Lost_Order('',insertRec);}
    public static Plastics_Lost_Order__c newPlastics_Lost_Order(Map<String,String> fieldValues) {return newPlastics_Lost_Order('',fieldValues, true);}
    public static Plastics_Lost_Order__c newPlastics_Lost_Order(Map<String,String> fieldValues, Boolean insertRec) {return newPlastics_Lost_Order('',fieldValues, insertRec);}
    public static Plastics_Lost_Order__c newPlastics_Lost_Order(String templateType) {return newPlastics_Lost_Order(templateType,true);}
    public static Plastics_Lost_Order__c newPlastics_Lost_Order(String templateType, Boolean insertRec) {return newPlastics_Lost_Order(templateType,new Map<String,String>(),insertRec);}
    public static Plastics_Lost_Order__c newPlastics_Lost_Order(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Plastics_Lost_Order__c)newSObject('Plastics_Lost_Order__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Price_Book__c Generation
 *********************************************/
    public static Price_Book__c newPrice_Book() {return newPrice_Book('');}
    public static Price_Book__c newPrice_Book(Boolean insertRec) {return newPrice_Book('',insertRec);}
    public static Price_Book__c newPrice_Book(Map<String,String> fieldValues) {return newPrice_Book('',fieldValues, true);}
    public static Price_Book__c newPrice_Book(Map<String,String> fieldValues, Boolean insertRec) {return newPrice_Book('',fieldValues, insertRec);}
    public static Price_Book__c newPrice_Book(String templateType) {return newPrice_Book(templateType,true);}
    public static Price_Book__c newPrice_Book(String templateType, Boolean insertRec) {return newPrice_Book(templateType,new Map<String,String>(),insertRec);}
    public static Price_Book__c newPrice_Book(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Price_Book__c)newSObject('Price_Book__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Price_Book_Customer_Group__c Generation
 *********************************************/
    public static Price_Book_Customer_Group__c newPrice_Book_Customer_Group() {return newPrice_Book_Customer_Group('');}
    public static Price_Book_Customer_Group__c newPrice_Book_Customer_Group(Boolean insertRec) {return newPrice_Book_Customer_Group('',insertRec);}
    public static Price_Book_Customer_Group__c newPrice_Book_Customer_Group(Map<String,String> fieldValues) {return newPrice_Book_Customer_Group('',fieldValues, true);}
    public static Price_Book_Customer_Group__c newPrice_Book_Customer_Group(Map<String,String> fieldValues, Boolean insertRec) {return newPrice_Book_Customer_Group('',fieldValues, insertRec);}
    public static Price_Book_Customer_Group__c newPrice_Book_Customer_Group(String templateType) {return newPrice_Book_Customer_Group(templateType,true);}
    public static Price_Book_Customer_Group__c newPrice_Book_Customer_Group(String templateType, Boolean insertRec) {return newPrice_Book_Customer_Group(templateType,new Map<String,String>(),insertRec);}
    public static Price_Book_Customer_Group__c newPrice_Book_Customer_Group(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Price_Book_Customer_Group__c)newSObject('Price_Book_Customer_Group__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Price_Book_Entry__c Generation
 *********************************************/
    public static Price_Book_Entry__c newPrice_Book_Entry() {return newPrice_Book_Entry('');}
    public static Price_Book_Entry__c newPrice_Book_Entry(Boolean insertRec) {return newPrice_Book_Entry('',insertRec);}
    public static Price_Book_Entry__c newPrice_Book_Entry(Map<String,String> fieldValues) {return newPrice_Book_Entry('',fieldValues, true);}
    public static Price_Book_Entry__c newPrice_Book_Entry(Map<String,String> fieldValues, Boolean insertRec) {return newPrice_Book_Entry('',fieldValues, insertRec);}
    public static Price_Book_Entry__c newPrice_Book_Entry(String templateType) {return newPrice_Book_Entry(templateType,true);}
    public static Price_Book_Entry__c newPrice_Book_Entry(String templateType, Boolean insertRec) {return newPrice_Book_Entry(templateType,new Map<String,String>(),insertRec);}
    public static Price_Book_Entry__c newPrice_Book_Entry(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Price_Book_Entry__c)newSObject('Price_Book_Entry__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Price_Book_Entry_Scaled_Pricing__c Generation
 *********************************************/
    public static Price_Book_Entry_Scaled_Pricing__c newPrice_Book_Entry_Scaled_Pricing() {return newPrice_Book_Entry_Scaled_Pricing('');}
    public static Price_Book_Entry_Scaled_Pricing__c newPrice_Book_Entry_Scaled_Pricing(Boolean insertRec) {return newPrice_Book_Entry_Scaled_Pricing('',insertRec);}
    public static Price_Book_Entry_Scaled_Pricing__c newPrice_Book_Entry_Scaled_Pricing(Map<String,String> fieldValues) {return newPrice_Book_Entry_Scaled_Pricing('',fieldValues, true);}
    public static Price_Book_Entry_Scaled_Pricing__c newPrice_Book_Entry_Scaled_Pricing(Map<String,String> fieldValues, Boolean insertRec) {return newPrice_Book_Entry_Scaled_Pricing('',fieldValues, insertRec);}
    public static Price_Book_Entry_Scaled_Pricing__c newPrice_Book_Entry_Scaled_Pricing(String templateType) {return newPrice_Book_Entry_Scaled_Pricing(templateType,true);}
    public static Price_Book_Entry_Scaled_Pricing__c newPrice_Book_Entry_Scaled_Pricing(String templateType, Boolean insertRec) {return newPrice_Book_Entry_Scaled_Pricing(templateType,new Map<String,String>(),insertRec);}
    public static Price_Book_Entry_Scaled_Pricing__c newPrice_Book_Entry_Scaled_Pricing(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Price_Book_Entry_Scaled_Pricing__c)newSObject('Price_Book_Entry_Scaled_Pricing__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Price_Book_Family__c Generation
 *********************************************/
    public static Price_Book_Family__c newPrice_Book_Family() {return newPrice_Book_Family('');}
    public static Price_Book_Family__c newPrice_Book_Family(Boolean insertRec) {return newPrice_Book_Family('',insertRec);}
    public static Price_Book_Family__c newPrice_Book_Family(Map<String,String> fieldValues) {return newPrice_Book_Family('',fieldValues, true);}
    public static Price_Book_Family__c newPrice_Book_Family(Map<String,String> fieldValues, Boolean insertRec) {return newPrice_Book_Family('',fieldValues, insertRec);}
    public static Price_Book_Family__c newPrice_Book_Family(String templateType) {return newPrice_Book_Family(templateType,true);}
    public static Price_Book_Family__c newPrice_Book_Family(String templateType, Boolean insertRec) {return newPrice_Book_Family(templateType,new Map<String,String>(),insertRec);}
    public static Price_Book_Family__c newPrice_Book_Family(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Price_Book_Family__c)newSObject('Price_Book_Family__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Price_Book_Product_Line__c Generation
 *********************************************/
    public static Price_Book_Product_Line__c newPrice_Book_Product_Line() {return newPrice_Book_Product_Line('');}
    public static Price_Book_Product_Line__c newPrice_Book_Product_Line(Boolean insertRec) {return newPrice_Book_Product_Line('',insertRec);}
    public static Price_Book_Product_Line__c newPrice_Book_Product_Line(Map<String,String> fieldValues) {return newPrice_Book_Product_Line('',fieldValues, true);}
    public static Price_Book_Product_Line__c newPrice_Book_Product_Line(Map<String,String> fieldValues, Boolean insertRec) {return newPrice_Book_Product_Line('',fieldValues, insertRec);}
    public static Price_Book_Product_Line__c newPrice_Book_Product_Line(String templateType) {return newPrice_Book_Product_Line(templateType,true);}
    public static Price_Book_Product_Line__c newPrice_Book_Product_Line(String templateType, Boolean insertRec) {return newPrice_Book_Product_Line(templateType,new Map<String,String>(),insertRec);}
    public static Price_Book_Product_Line__c newPrice_Book_Product_Line(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Price_Book_Product_Line__c)newSObject('Price_Book_Product_Line__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Price_Book_Region__c Generation
 *********************************************/
    public static Price_Book_Region__c newPrice_Book_Region() {return newPrice_Book_Region('');}
    public static Price_Book_Region__c newPrice_Book_Region(Boolean insertRec) {return newPrice_Book_Region('',insertRec);}
    public static Price_Book_Region__c newPrice_Book_Region(Map<String,String> fieldValues) {return newPrice_Book_Region('',fieldValues, true);}
    public static Price_Book_Region__c newPrice_Book_Region(Map<String,String> fieldValues, Boolean insertRec) {return newPrice_Book_Region('',fieldValues, insertRec);}
    public static Price_Book_Region__c newPrice_Book_Region(String templateType) {return newPrice_Book_Region(templateType,true);}
    public static Price_Book_Region__c newPrice_Book_Region(String templateType, Boolean insertRec) {return newPrice_Book_Region(templateType,new Map<String,String>(),insertRec);}
    public static Price_Book_Region__c newPrice_Book_Region(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Price_Book_Region__c)newSObject('Price_Book_Region__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Price_Book_Sales_Org__c Generation
 *********************************************/
    public static Price_Book_Sales_Org__c newPrice_Book_Sales_Org() {return newPrice_Book_Sales_Org('');}
    public static Price_Book_Sales_Org__c newPrice_Book_Sales_Org(Boolean insertRec) {return newPrice_Book_Sales_Org('',insertRec);}
    public static Price_Book_Sales_Org__c newPrice_Book_Sales_Org(Map<String,String> fieldValues) {return newPrice_Book_Sales_Org('',fieldValues, true);}
    public static Price_Book_Sales_Org__c newPrice_Book_Sales_Org(Map<String,String> fieldValues, Boolean insertRec) {return newPrice_Book_Sales_Org('',fieldValues, insertRec);}
    public static Price_Book_Sales_Org__c newPrice_Book_Sales_Org(String templateType) {return newPrice_Book_Sales_Org(templateType,true);}
    public static Price_Book_Sales_Org__c newPrice_Book_Sales_Org(String templateType, Boolean insertRec) {return newPrice_Book_Sales_Org(templateType,new Map<String,String>(),insertRec);}
    public static Price_Book_Sales_Org__c newPrice_Book_Sales_Org(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Price_Book_Sales_Org__c)newSObject('Price_Book_Sales_Org__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Price_Book_Service__c Generation
 *********************************************/
    public static Price_Book_Service__c newPrice_Book_Service() {return newPrice_Book_Service('');}
    public static Price_Book_Service__c newPrice_Book_Service(Boolean insertRec) {return newPrice_Book_Service('',insertRec);}
    public static Price_Book_Service__c newPrice_Book_Service(Map<String,String> fieldValues) {return newPrice_Book_Service('',fieldValues, true);}
    public static Price_Book_Service__c newPrice_Book_Service(Map<String,String> fieldValues, Boolean insertRec) {return newPrice_Book_Service('',fieldValues, insertRec);}
    public static Price_Book_Service__c newPrice_Book_Service(String templateType) {return newPrice_Book_Service(templateType,true);}
    public static Price_Book_Service__c newPrice_Book_Service(String templateType, Boolean insertRec) {return newPrice_Book_Service(templateType,new Map<String,String>(),insertRec);}
    public static Price_Book_Service__c newPrice_Book_Service(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Price_Book_Service__c)newSObject('Price_Book_Service__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Pricebook2 Generation
 *********************************************/
    public static Pricebook2 newPricebook2() {return newPricebook2('');}
    public static Pricebook2 newPricebook2(Boolean insertRec) {return newPricebook2('',insertRec);}
    public static Pricebook2 newPricebook2(Map<String,String> fieldValues) {return newPricebook2('',fieldValues, true);}
    public static Pricebook2 newPricebook2(Map<String,String> fieldValues, Boolean insertRec) {return newPricebook2('',fieldValues, insertRec);}
    public static Pricebook2 newPricebook2(String templateType) {return newPricebook2(templateType,true);}
    public static Pricebook2 newPricebook2(String templateType, Boolean insertRec) {return newPricebook2(templateType,new Map<String,String>(),insertRec);}
    public static Pricebook2 newPricebook2(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Pricebook2)newSObject('Pricebook2', templateType, fieldValues, insertRec);}


/********************************************
 * Test Pricing__c Generation
 *********************************************/
    public static Pricing__c newPricing() {return newPricing('');}
    public static Pricing__c newPricing(Boolean insertRec) {return newPricing('',insertRec);}
    public static Pricing__c newPricing(Map<String,String> fieldValues) {return newPricing('',fieldValues, true);}
    public static Pricing__c newPricing(Map<String,String> fieldValues, Boolean insertRec) {return newPricing('',fieldValues, insertRec);}
    public static Pricing__c newPricing(String templateType) {return newPricing(templateType,true);}
    public static Pricing__c newPricing(String templateType, Boolean insertRec) {return newPricing(templateType,new Map<String,String>(),insertRec);}
    public static Pricing__c newPricing(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Pricing__c)newSObject('Pricing__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Pricing_Condition__c Generation
 *********************************************/
    public static Pricing_Condition__c newPricing_Condition() {return newPricing_Condition('');}
    public static Pricing_Condition__c newPricing_Condition(Boolean insertRec) {return newPricing_Condition('',insertRec);}
    public static Pricing_Condition__c newPricing_Condition(Map<String,String> fieldValues) {return newPricing_Condition('',fieldValues, true);}
    public static Pricing_Condition__c newPricing_Condition(Map<String,String> fieldValues, Boolean insertRec) {return newPricing_Condition('',fieldValues, insertRec);}
    public static Pricing_Condition__c newPricing_Condition(String templateType) {return newPricing_Condition(templateType,true);}
    public static Pricing_Condition__c newPricing_Condition(String templateType, Boolean insertRec) {return newPricing_Condition(templateType,new Map<String,String>(),insertRec);}
    public static Pricing_Condition__c newPricing_Condition(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Pricing_Condition__c)newSObject('Pricing_Condition__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Pricing_Rebate__c Generation
 *********************************************/
    public static Pricing_Rebate__c newPricing_Rebate() {return newPricing_Rebate('');}
    public static Pricing_Rebate__c newPricing_Rebate(Boolean insertRec) {return newPricing_Rebate('',insertRec);}
    public static Pricing_Rebate__c newPricing_Rebate(Map<String,String> fieldValues) {return newPricing_Rebate('',fieldValues, true);}
    public static Pricing_Rebate__c newPricing_Rebate(Map<String,String> fieldValues, Boolean insertRec) {return newPricing_Rebate('',fieldValues, insertRec);}
    public static Pricing_Rebate__c newPricing_Rebate(String templateType) {return newPricing_Rebate(templateType,true);}
    public static Pricing_Rebate__c newPricing_Rebate(String templateType, Boolean insertRec) {return newPricing_Rebate(templateType,new Map<String,String>(),insertRec);}
    public static Pricing_Rebate__c newPricing_Rebate(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Pricing_Rebate__c)newSObject('Pricing_Rebate__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Pricing_Rebate_Detail__c Generation
 *********************************************/
    public static Pricing_Rebate_Detail__c newPricing_Rebate_Detail() {return newPricing_Rebate_Detail('');}
    public static Pricing_Rebate_Detail__c newPricing_Rebate_Detail(Boolean insertRec) {return newPricing_Rebate_Detail('',insertRec);}
    public static Pricing_Rebate_Detail__c newPricing_Rebate_Detail(Map<String,String> fieldValues) {return newPricing_Rebate_Detail('',fieldValues, true);}
    public static Pricing_Rebate_Detail__c newPricing_Rebate_Detail(Map<String,String> fieldValues, Boolean insertRec) {return newPricing_Rebate_Detail('',fieldValues, insertRec);}
    public static Pricing_Rebate_Detail__c newPricing_Rebate_Detail(String templateType) {return newPricing_Rebate_Detail(templateType,true);}
    public static Pricing_Rebate_Detail__c newPricing_Rebate_Detail(String templateType, Boolean insertRec) {return newPricing_Rebate_Detail(templateType,new Map<String,String>(),insertRec);}
    public static Pricing_Rebate_Detail__c newPricing_Rebate_Detail(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Pricing_Rebate_Detail__c)newSObject('Pricing_Rebate_Detail__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Pricing_Rebate_Configuration__c Generation
 *********************************************/
    public static Pricing_Rebate_Configuration__c newPricing_Rebate_Configuration() {return newPricing_Rebate_Configuration('');}
    public static Pricing_Rebate_Configuration__c newPricing_Rebate_Configuration(Boolean insertRec) {return newPricing_Rebate_Configuration('',insertRec);}
    public static Pricing_Rebate_Configuration__c newPricing_Rebate_Configuration(Map<String,String> fieldValues) {return newPricing_Rebate_Configuration('',fieldValues, true);}
    public static Pricing_Rebate_Configuration__c newPricing_Rebate_Configuration(Map<String,String> fieldValues, Boolean insertRec) {return newPricing_Rebate_Configuration('',fieldValues, insertRec);}
    public static Pricing_Rebate_Configuration__c newPricing_Rebate_Configuration(String templateType) {return newPricing_Rebate_Configuration(templateType,true);}
    public static Pricing_Rebate_Configuration__c newPricing_Rebate_Configuration(String templateType, Boolean insertRec) {return newPricing_Rebate_Configuration(templateType,new Map<String,String>(),insertRec);}
    public static Pricing_Rebate_Configuration__c newPricing_Rebate_Configuration(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Pricing_Rebate_Configuration__c)newSObject('Pricing_Rebate_Configuration__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Product_Hierarchy__c Generation
 *********************************************/
    public static Product_Hierarchy__c newProduct_Hierarchy() {return newProduct_Hierarchy('');}
    public static Product_Hierarchy__c newProduct_Hierarchy(Boolean insertRec) {return newProduct_Hierarchy('',insertRec);}
    public static Product_Hierarchy__c newProduct_Hierarchy(Map<String,String> fieldValues) {return newProduct_Hierarchy('',fieldValues, true);}
    public static Product_Hierarchy__c newProduct_Hierarchy(Map<String,String> fieldValues, Boolean insertRec) {return newProduct_Hierarchy('',fieldValues, insertRec);}
    public static Product_Hierarchy__c newProduct_Hierarchy(String templateType) {return newProduct_Hierarchy(templateType,true);}
    public static Product_Hierarchy__c newProduct_Hierarchy(String templateType, Boolean insertRec) {return newProduct_Hierarchy(templateType,new Map<String,String>(),insertRec);}
    public static Product_Hierarchy__c newProduct_Hierarchy(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Product_Hierarchy__c)newSObject('Product_Hierarchy__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Product_Hierarchy2__c Generation
 *********************************************/
    public static Product_Hierarchy2__c newProduct_Hierarchy2() {return newProduct_Hierarchy2('');}
    public static Product_Hierarchy2__c newProduct_Hierarchy2(Boolean insertRec) {return newProduct_Hierarchy2('',insertRec);}
    public static Product_Hierarchy2__c newProduct_Hierarchy2(Map<String,String> fieldValues) {return newProduct_Hierarchy2('',fieldValues, true);}
    public static Product_Hierarchy2__c newProduct_Hierarchy2(Map<String,String> fieldValues, Boolean insertRec) {return newProduct_Hierarchy2('',fieldValues, insertRec);}
    public static Product_Hierarchy2__c newProduct_Hierarchy2(String templateType) {return newProduct_Hierarchy2(templateType,true);}
    public static Product_Hierarchy2__c newProduct_Hierarchy2(String templateType, Boolean insertRec) {return newProduct_Hierarchy2(templateType,new Map<String,String>(),insertRec);}
    public static Product_Hierarchy2__c newProduct_Hierarchy2(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Product_Hierarchy2__c)newSObject('Product_Hierarchy2__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Product_Sales_Figure__c Generation
 *********************************************/
    public static Product_Sales_Figure__c newProduct_Sales_Figure() {return newProduct_Sales_Figure('');}
    public static Product_Sales_Figure__c newProduct_Sales_Figure(Boolean insertRec) {return newProduct_Sales_Figure('',insertRec);}
    public static Product_Sales_Figure__c newProduct_Sales_Figure(Map<String,String> fieldValues) {return newProduct_Sales_Figure('',fieldValues, true);}
    public static Product_Sales_Figure__c newProduct_Sales_Figure(Map<String,String> fieldValues, Boolean insertRec) {return newProduct_Sales_Figure('',fieldValues, insertRec);}
    public static Product_Sales_Figure__c newProduct_Sales_Figure(String templateType) {return newProduct_Sales_Figure(templateType,true);}
    public static Product_Sales_Figure__c newProduct_Sales_Figure(String templateType, Boolean insertRec) {return newProduct_Sales_Figure(templateType,new Map<String,String>(),insertRec);}
    public static Product_Sales_Figure__c newProduct_Sales_Figure(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Product_Sales_Figure__c)newSObject('Product_Sales_Figure__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Product2 Generation
 *********************************************/
    public static Product2 newProduct2() {return newProduct2('');}
    public static Product2 newProduct2(Boolean insertRec) {return newProduct2('',insertRec);}
    public static Product2 newProduct2(Map<String,String> fieldValues) {return newProduct2('',fieldValues, true);}
    public static Product2 newProduct2(Map<String,String> fieldValues, Boolean insertRec) {return newProduct2('',fieldValues, insertRec);}
    public static Product2 newProduct2(String templateType) {return newProduct2(templateType,true);}
    public static Product2 newProduct2(String templateType, Boolean insertRec) {return newProduct2(templateType,new Map<String,String>(),insertRec);}
    public static Product2 newProduct2(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Product2)newSObject('Product2', templateType, fieldValues, insertRec);}


/********************************************
 * Test RTK_Code__c Generation
 *********************************************/
    public static RTK_Code__c newRTK_Code() {return newRTK_Code('');}
    public static RTK_Code__c newRTK_Code(Boolean insertRec) {return newRTK_Code('',insertRec);}
    public static RTK_Code__c newRTK_Code(Map<String,String> fieldValues) {return newRTK_Code('',fieldValues, true);}
    public static RTK_Code__c newRTK_Code(Map<String,String> fieldValues, Boolean insertRec) {return newRTK_Code('',fieldValues, insertRec);}
    public static RTK_Code__c newRTK_Code(String templateType) {return newRTK_Code(templateType,true);}
    public static RTK_Code__c newRTK_Code(String templateType, Boolean insertRec) {return newRTK_Code(templateType,new Map<String,String>(),insertRec);}
    public static RTK_Code__c newRTK_Code(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (RTK_Code__c)newSObject('RTK_Code__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Reorder__c Generation
 *********************************************/
    public static Reorder__c newReorder() {return newReorder('');}
    public static Reorder__c newReorder(Boolean insertRec) {return newReorder('',insertRec);}
    public static Reorder__c newReorder(Map<String,String> fieldValues) {return newReorder('',fieldValues, true);}
    public static Reorder__c newReorder(Map<String,String> fieldValues, Boolean insertRec) {return newReorder('',fieldValues, insertRec);}
    public static Reorder__c newReorder(String templateType) {return newReorder(templateType,true);}
    public static Reorder__c newReorder(String templateType, Boolean insertRec) {return newReorder(templateType,new Map<String,String>(),insertRec);}
    public static Reorder__c newReorder(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Reorder__c)newSObject('Reorder__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test RTK_Transfer__c Generation
 *********************************************/
    public static RTK_Transfer__c newRTK_Transfer() {return newRTK_Transfer('');}
    public static RTK_Transfer__c newRTK_Transfer(Boolean insertRec) {return newRTK_Transfer('',insertRec);}
    public static RTK_Transfer__c newRTK_Transfer(Map<String,String> fieldValues) {return newRTK_Transfer('',fieldValues, true);}
    public static RTK_Transfer__c newRTK_Transfer(Map<String,String> fieldValues, Boolean insertRec) {return newRTK_Transfer('',fieldValues, insertRec);}
    public static RTK_Transfer__c newRTK_Transfer(String templateType) {return newRTK_Transfer(templateType,true);}
    public static RTK_Transfer__c newRTK_Transfer(String templateType, Boolean insertRec) {return newRTK_Transfer(templateType,new Map<String,String>(),insertRec);}
    public static RTK_Transfer__c newRTK_Transfer(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (RTK_Transfer__c)newSObject('RTK_Transfer__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Sales_Order_Deliveries__c Generation
 *********************************************/
    public static Sales_Order_Deliveries__c newSales_Order_Deliveries() {return newSales_Order_Deliveries('');}
    public static Sales_Order_Deliveries__c newSales_Order_Deliveries(Boolean insertRec) {return newSales_Order_Deliveries('',insertRec);}
    public static Sales_Order_Deliveries__c newSales_Order_Deliveries(Map<String,String> fieldValues) {return newSales_Order_Deliveries('',fieldValues, true);}
    public static Sales_Order_Deliveries__c newSales_Order_Deliveries(Map<String,String> fieldValues, Boolean insertRec) {return newSales_Order_Deliveries('',fieldValues, insertRec);}
    public static Sales_Order_Deliveries__c newSales_Order_Deliveries(String templateType) {return newSales_Order_Deliveries(templateType,true);}
    public static Sales_Order_Deliveries__c newSales_Order_Deliveries(String templateType, Boolean insertRec) {return newSales_Order_Deliveries(templateType,new Map<String,String>(),insertRec);}
    public static Sales_Order_Deliveries__c newSales_Order_Deliveries(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Sales_Order_Deliveries__c)newSObject('Sales_Order_Deliveries__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Sample_Material__c Generation
 *********************************************/
    public static Sample_Material__c newSample_Material() {return newSample_Material('');}
    public static Sample_Material__c newSample_Material(Boolean insertRec) {return newSample_Material('',insertRec);}
    public static Sample_Material__c newSample_Material(Map<String,String> fieldValues) {return newSample_Material('',fieldValues, true);}
    public static Sample_Material__c newSample_Material(Map<String,String> fieldValues, Boolean insertRec) {return newSample_Material('',fieldValues, insertRec);}
    public static Sample_Material__c newSample_Material(String templateType) {return newSample_Material(templateType,true);}
    public static Sample_Material__c newSample_Material(String templateType, Boolean insertRec) {return newSample_Material(templateType,new Map<String,String>(),insertRec);}
    public static Sample_Material__c newSample_Material(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Sample_Material__c)newSObject('Sample_Material__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Sample_Request__c Generation
 *********************************************/
    public static Sample_Request__c newSample_Request() {return newSample_Request('');}
    public static Sample_Request__c newSample_Request(Boolean insertRec) {return newSample_Request('',insertRec);}
    public static Sample_Request__c newSample_Request(Map<String,String> fieldValues) {return newSample_Request('',fieldValues, true);}
    public static Sample_Request__c newSample_Request(Map<String,String> fieldValues, Boolean insertRec) {return newSample_Request('',fieldValues, insertRec);}
    public static Sample_Request__c newSample_Request(String templateType) {return newSample_Request(templateType,true);}
    public static Sample_Request__c newSample_Request(String templateType, Boolean insertRec) {return newSample_Request(templateType,new Map<String,String>(),insertRec);}
    public static Sample_Request__c newSample_Request(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Sample_Request__c)newSObject('Sample_Request__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Sample_Request_Approval_Process__c Generation
 *********************************************/
    public static Sample_Request_Approval_Process__c newSample_Request_Approval_Process() {return newSample_Request_Approval_Process('');}
    public static Sample_Request_Approval_Process__c newSample_Request_Approval_Process(Boolean insertRec) {return newSample_Request_Approval_Process('',insertRec);}
    public static Sample_Request_Approval_Process__c newSample_Request_Approval_Process(Map<String,String> fieldValues) {return newSample_Request_Approval_Process('',fieldValues, true);}
    public static Sample_Request_Approval_Process__c newSample_Request_Approval_Process(Map<String,String> fieldValues, Boolean insertRec) {return newSample_Request_Approval_Process('',fieldValues, insertRec);}
    public static Sample_Request_Approval_Process__c newSample_Request_Approval_Process(String templateType) {return newSample_Request_Approval_Process(templateType,true);}
    public static Sample_Request_Approval_Process__c newSample_Request_Approval_Process(String templateType, Boolean insertRec) {return newSample_Request_Approval_Process(templateType,new Map<String,String>(),insertRec);}
    public static Sample_Request_Approval_Process__c newSample_Request_Approval_Process(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Sample_Request_Approval_Process__c)newSObject('Sample_Request_Approval_Process__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test SAP_Country_Name__c Generation
 *********************************************/
    public static SAP_Country_Name__c newSAP_Country_Name() {return newSAP_Country_Name('');}
    public static SAP_Country_Name__c newSAP_Country_Name(Boolean insertRec) {return newSAP_Country_Name('',insertRec);}
    public static SAP_Country_Name__c newSAP_Country_Name(Map<String,String> fieldValues) {return newSAP_Country_Name('',fieldValues, true);}
    public static SAP_Country_Name__c newSAP_Country_Name(Map<String,String> fieldValues, Boolean insertRec) {return newSAP_Country_Name('',fieldValues, insertRec);}
    public static SAP_Country_Name__c newSAP_Country_Name(String templateType) {return newSAP_Country_Name(templateType,true);}
    public static SAP_Country_Name__c newSAP_Country_Name(String templateType, Boolean insertRec) {return newSAP_Country_Name(templateType,new Map<String,String>(),insertRec);}
    public static SAP_Country_Name__c newSAP_Country_Name(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (SAP_Country_Name__c)newSObject('SAP_Country_Name__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test SAP_Customer_Group__c Generation
 *********************************************/
    public static SAP_Customer_Group__c newSAP_Customer_Group() {return newSAP_Customer_Group('');}
    public static SAP_Customer_Group__c newSAP_Customer_Group(Boolean insertRec) {return newSAP_Customer_Group('',insertRec);}
    public static SAP_Customer_Group__c newSAP_Customer_Group(Map<String,String> fieldValues) {return newSAP_Customer_Group('',fieldValues, true);}
    public static SAP_Customer_Group__c newSAP_Customer_Group(Map<String,String> fieldValues, Boolean insertRec) {return newSAP_Customer_Group('',fieldValues, insertRec);}
    public static SAP_Customer_Group__c newSAP_Customer_Group(String templateType) {return newSAP_Customer_Group(templateType,true);}
    public static SAP_Customer_Group__c newSAP_Customer_Group(String templateType, Boolean insertRec) {return newSAP_Customer_Group(templateType,new Map<String,String>(),insertRec);}
    public static SAP_Customer_Group__c newSAP_Customer_Group(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (SAP_Customer_Group__c)newSObject('SAP_Customer_Group__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test SAP_Customer_Group1__c Generation
 *********************************************/
    public static SAP_Customer_Group1__c newSAP_Customer_Group1() {return newSAP_Customer_Group1('');}
    public static SAP_Customer_Group1__c newSAP_Customer_Group1(Boolean insertRec) {return newSAP_Customer_Group1('',insertRec);}
    public static SAP_Customer_Group1__c newSAP_Customer_Group1(Map<String,String> fieldValues) {return newSAP_Customer_Group1('',fieldValues, true);}
    public static SAP_Customer_Group1__c newSAP_Customer_Group1(Map<String,String> fieldValues, Boolean insertRec) {return newSAP_Customer_Group1('',fieldValues, insertRec);}
    public static SAP_Customer_Group1__c newSAP_Customer_Group1(String templateType) {return newSAP_Customer_Group1(templateType,true);}
    public static SAP_Customer_Group1__c newSAP_Customer_Group1(String templateType, Boolean insertRec) {return newSAP_Customer_Group1(templateType,new Map<String,String>(),insertRec);}
    public static SAP_Customer_Group1__c newSAP_Customer_Group1(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (SAP_Customer_Group1__c)newSObject('SAP_Customer_Group1__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test SAP_Distribution_Channel__c Generation
 *********************************************/
    public static SAP_Distribution_Channel__c newSAP_Distribution_Channel() {return newSAP_Distribution_Channel('');}
    public static SAP_Distribution_Channel__c newSAP_Distribution_Channel(Boolean insertRec) {return newSAP_Distribution_Channel('',insertRec);}
    public static SAP_Distribution_Channel__c newSAP_Distribution_Channel(Map<String,String> fieldValues) {return newSAP_Distribution_Channel('',fieldValues, true);}
    public static SAP_Distribution_Channel__c newSAP_Distribution_Channel(Map<String,String> fieldValues, Boolean insertRec) {return newSAP_Distribution_Channel('',fieldValues, insertRec);}
    public static SAP_Distribution_Channel__c newSAP_Distribution_Channel(String templateType) {return newSAP_Distribution_Channel(templateType,true);}
    public static SAP_Distribution_Channel__c newSAP_Distribution_Channel(String templateType, Boolean insertRec) {return newSAP_Distribution_Channel(templateType,new Map<String,String>(),insertRec);}
    public static SAP_Distribution_Channel__c newSAP_Distribution_Channel(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (SAP_Distribution_Channel__c)newSObject('SAP_Distribution_Channel__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test SAP_Plant__c Generation
 *********************************************/
    public static SAP_Plant__c newSAP_Plant() {return newSAP_Plant('');}
    public static SAP_Plant__c newSAP_Plant(Boolean insertRec) {return newSAP_Plant('',insertRec);}
    public static SAP_Plant__c newSAP_Plant(Map<String,String> fieldValues) {return newSAP_Plant('',fieldValues, true);}
    public static SAP_Plant__c newSAP_Plant(Map<String,String> fieldValues, Boolean insertRec) {return newSAP_Plant('',fieldValues, insertRec);}
    public static SAP_Plant__c newSAP_Plant(String templateType) {return newSAP_Plant(templateType,true);}
    public static SAP_Plant__c newSAP_Plant(String templateType, Boolean insertRec) {return newSAP_Plant(templateType,new Map<String,String>(),insertRec);}
    public static SAP_Plant__c newSAP_Plant(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (SAP_Plant__c)newSObject('SAP_Plant__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test SAP_Sales_Division__c Generation
 *********************************************/
    public static SAP_Sales_Division__c newSAP_Sales_Division() {return newSAP_Sales_Division('');}
    public static SAP_Sales_Division__c newSAP_Sales_Division(Boolean insertRec) {return newSAP_Sales_Division('',insertRec);}
    public static SAP_Sales_Division__c newSAP_Sales_Division(Map<String,String> fieldValues) {return newSAP_Sales_Division('',fieldValues, true);}
    public static SAP_Sales_Division__c newSAP_Sales_Division(Map<String,String> fieldValues, Boolean insertRec) {return newSAP_Sales_Division('',fieldValues, insertRec);}
    public static SAP_Sales_Division__c newSAP_Sales_Division(String templateType) {return newSAP_Sales_Division(templateType,true);}
    public static SAP_Sales_Division__c newSAP_Sales_Division(String templateType, Boolean insertRec) {return newSAP_Sales_Division(templateType,new Map<String,String>(),insertRec);}
    public static SAP_Sales_Division__c newSAP_Sales_Division(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (SAP_Sales_Division__c)newSObject('SAP_Sales_Division__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test SAP_Sales_Org__c Generation
 *********************************************/
    public static SAP_Sales_Org__c newSAP_Sales_Org() {return newSAP_Sales_Org('');}
    public static SAP_Sales_Org__c newSAP_Sales_Org(Boolean insertRec) {return newSAP_Sales_Org('',insertRec);}
    public static SAP_Sales_Org__c newSAP_Sales_Org(Map<String,String> fieldValues) {return newSAP_Sales_Org('',fieldValues, true);}
    public static SAP_Sales_Org__c newSAP_Sales_Org(Map<String,String> fieldValues, Boolean insertRec) {return newSAP_Sales_Org('',fieldValues, insertRec);}
    public static SAP_Sales_Org__c newSAP_Sales_Org(String templateType) {return newSAP_Sales_Org(templateType,true);}
    public static SAP_Sales_Org__c newSAP_Sales_Org(String templateType, Boolean insertRec) {return newSAP_Sales_Org(templateType,new Map<String,String>(),insertRec);}
    public static SAP_Sales_Org__c newSAP_Sales_Org(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (SAP_Sales_Org__c)newSObject('SAP_Sales_Org__c', templateType, fieldValues, insertRec);}

/********************************************
 * Test SAP_Ultimate_Parent__c Generation
 *********************************************/
    public static SAP_Ultimate_Parent__c newSAP_Ultimate_Parent() {return newSAP_Ultimate_Parent('');}
    public static SAP_Ultimate_Parent__c newSAP_Ultimate_Parent(Boolean insertRec) {return newSAP_Ultimate_Parent('',insertRec);}
    public static SAP_Ultimate_Parent__c newSAP_Ultimate_Parent(Map<String,String> fieldValues) {return newSAP_Ultimate_Parent('',fieldValues, true);}
    public static SAP_Ultimate_Parent__c newSAP_Ultimate_Parent(Map<String,String> fieldValues, Boolean insertRec) {return newSAP_Ultimate_Parent('',fieldValues, insertRec);}
    public static SAP_Ultimate_Parent__c newSAP_Ultimate_Parent(String templateType) {return newSAP_Ultimate_Parent(templateType,true);}
    public static SAP_Ultimate_Parent__c newSAP_Ultimate_Parent(String templateType, Boolean insertRec) {return newSAP_Ultimate_Parent(templateType,new Map<String,String>(),insertRec);}
    public static SAP_Ultimate_Parent__c newSAP_Ultimate_Parent(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (SAP_Ultimate_Parent__c)newSObject('SAP_Ultimate_Parent__c', templateType, fieldValues, insertRec);}

/********************************************
 * Test SAP_UOM_Code__c Generation
 *********************************************/
    public static SAP_UOM_Code__c newSAP_UOM_Code() {return newSAP_UOM_Code('');}
    public static SAP_UOM_Code__c newSAP_UOM_Code(Boolean insertRec) {return newSAP_UOM_Code('',insertRec);}
    public static SAP_UOM_Code__c newSAP_UOM_Code(Map<String,String> fieldValues) {return newSAP_UOM_Code('',fieldValues, true);}
    public static SAP_UOM_Code__c newSAP_UOM_Code(Map<String,String> fieldValues, Boolean insertRec) {return newSAP_UOM_Code('',fieldValues, insertRec);}
    public static SAP_UOM_Code__c newSAP_UOM_Code(String templateType) {return newSAP_UOM_Code(templateType,true);}
    public static SAP_UOM_Code__c newSAP_UOM_Code(String templateType, Boolean insertRec) {return newSAP_UOM_Code(templateType,new Map<String,String>(),insertRec);}
    public static SAP_UOM_Code__c newSAP_UOM_Code(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (SAP_UOM_Code__c)newSObject('SAP_UOM_Code__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test SAP_UOM_Description__c Generation
 *********************************************/
    public static SAP_UOM_Description__c newSAP_UOM_Description() {return newSAP_UOM_Description('');}
    public static SAP_UOM_Description__c newSAP_UOM_Description(Boolean insertRec) {return newSAP_UOM_Description('',insertRec);}
    public static SAP_UOM_Description__c newSAP_UOM_Description(Map<String,String> fieldValues) {return newSAP_UOM_Description('',fieldValues, true);}
    public static SAP_UOM_Description__c newSAP_UOM_Description(Map<String,String> fieldValues, Boolean insertRec) {return newSAP_UOM_Description('',fieldValues, insertRec);}
    public static SAP_UOM_Description__c newSAP_UOM_Description(String templateType) {return newSAP_UOM_Description(templateType,true);}
    public static SAP_UOM_Description__c newSAP_UOM_Description(String templateType, Boolean insertRec) {return newSAP_UOM_Description(templateType,new Map<String,String>(),insertRec);}
    public static SAP_UOM_Description__c newSAP_UOM_Description(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (SAP_UOM_Description__c)newSObject('SAP_UOM_Description__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test SAP_Valuation_Area__c Generation
 *********************************************/
    public static SAP_Valuation_Area__c newSAP_Valuation_Area() {return newSAP_Valuation_Area('');}
    public static SAP_Valuation_Area__c newSAP_Valuation_Area(Boolean insertRec) {return newSAP_Valuation_Area('',insertRec);}
    public static SAP_Valuation_Area__c newSAP_Valuation_Area(Map<String,String> fieldValues) {return newSAP_Valuation_Area('',fieldValues, true);}
    public static SAP_Valuation_Area__c newSAP_Valuation_Area(Map<String,String> fieldValues, Boolean insertRec) {return newSAP_Valuation_Area('',fieldValues, insertRec);}
    public static SAP_Valuation_Area__c newSAP_Valuation_Area(String templateType) {return newSAP_Valuation_Area(templateType,true);}
    public static SAP_Valuation_Area__c newSAP_Valuation_Area(String templateType, Boolean insertRec) {return newSAP_Valuation_Area(templateType,new Map<String,String>(),insertRec);}
    public static SAP_Valuation_Area__c newSAP_Valuation_Area(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (SAP_Valuation_Area__c)newSObject('SAP_Valuation_Area__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Strategic_Plan__c Generation
 *********************************************/
    public static Strategic_Plan__c newStrategic_Plan() {return newStrategic_Plan('');}
    public static Strategic_Plan__c newStrategic_Plan(Boolean insertRec) {return newStrategic_Plan('',insertRec);}
    public static Strategic_Plan__c newStrategic_Plan(Map<String,String> fieldValues) {return newStrategic_Plan('',fieldValues, true);}
    public static Strategic_Plan__c newStrategic_Plan(Map<String,String> fieldValues, Boolean insertRec) {return newStrategic_Plan('',fieldValues, insertRec);}
    public static Strategic_Plan__c newStrategic_Plan(String templateType) {return newStrategic_Plan(templateType,true);}
    public static Strategic_Plan__c newStrategic_Plan(String templateType, Boolean insertRec) {return newStrategic_Plan(templateType,new Map<String,String>(),insertRec);}
    public static Strategic_Plan__c newStrategic_Plan(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Strategic_Plan__c)newSObject('Strategic_Plan__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Strategy__c Generation
 *********************************************/
    public static Strategy__c newStrategy() {return newStrategy('');}
    public static Strategy__c newStrategy(Boolean insertRec) {return newStrategy('',insertRec);}
    public static Strategy__c newStrategy(Map<String,String> fieldValues) {return newStrategy('',fieldValues, true);}
    public static Strategy__c newStrategy(Map<String,String> fieldValues, Boolean insertRec) {return newStrategy('',fieldValues, insertRec);}
    public static Strategy__c newStrategy(String templateType) {return newStrategy(templateType,true);}
    public static Strategy__c newStrategy(String templateType, Boolean insertRec) {return newStrategy(templateType,new Map<String,String>(),insertRec);}
    public static Strategy__c newStrategy(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Strategy__c)newSObject('Strategy__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Strength_and_Weaknesses__c Generation
 *********************************************/
    public static Strength_and_Weaknesses__c newStrength_and_Weaknesses() {return newStrength_and_Weaknesses('');}
    public static Strength_and_Weaknesses__c newStrength_and_Weaknesses(Boolean insertRec) {return newStrength_and_Weaknesses('',insertRec);}
    public static Strength_and_Weaknesses__c newStrength_and_Weaknesses(Map<String,String> fieldValues) {return newStrength_and_Weaknesses('',fieldValues, true);}
    public static Strength_and_Weaknesses__c newStrength_and_Weaknesses(Map<String,String> fieldValues, Boolean insertRec) {return newStrength_and_Weaknesses('',fieldValues, insertRec);}
    public static Strength_and_Weaknesses__c newStrength_and_Weaknesses(String templateType) {return newStrength_and_Weaknesses(templateType,true);}
    public static Strength_and_Weaknesses__c newStrength_and_Weaknesses(String templateType, Boolean insertRec) {return newStrength_and_Weaknesses(templateType,new Map<String,String>(),insertRec);}
    public static Strength_and_Weaknesses__c newStrength_and_Weaknesses(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Strength_and_Weaknesses__c)newSObject('Strength_and_Weaknesses__c', templateType, fieldValues, insertRec);}


/********************************************
 * Test Task Generation
 *********************************************/
    public static Task newTask() {return newTask('');}
    public static Task newTask(Boolean insertRec) {return newTask('',insertRec);}
    public static Task newTask(Map<String,String> fieldValues) {return newTask('',fieldValues, true);}
    public static Task newTask(Map<String,String> fieldValues, Boolean insertRec) {return newTask('',fieldValues, insertRec);}
    public static Task newTask(String templateType) {return newTask(templateType,true);}
    public static Task newTask(String templateType, Boolean insertRec) {return newTask(templateType,new Map<String,String>(),insertRec);}
    public static Task newTask(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (Task)newSObject('Task', templateType, fieldValues, insertRec);}


/********************************************
 * Test User Generation
 *********************************************/
    public static User newUser() {return newUser('');}
    public static User newUser(Boolean insertRec) {return newUser('',insertRec);}
    public static User newUser(Map<String,String> fieldValues) {return newUser('',fieldValues, true);}
    public static User newUser(Map<String,String> fieldValues, Boolean insertRec) {return newUser('',fieldValues, insertRec);}
    public static User newUser(String templateType) {return newUser(templateType,true);}
    public static User newUser(String templateType, Boolean insertRec) {return newUser(templateType,new Map<String,String>(),insertRec);}
    public static User newUser(String templateType, Map<String,String> fieldValues, Boolean insertRec) {return (User)newSObject('User', templateType, fieldValues, insertRec);}

    /********************************** 
    * Create and Submit ApprovalProcess
    ***********************************/
    public static Approval.ProcessResult createandSubmitApprovalProcess(sObject sobj) {return createandSubmitApprovalProcess(sobj, 'Comments', new List<Id>());}
    public static Approval.ProcessResult createandSubmitApprovalProcess(sObject sobj, String comments) {return createandSubmitApprovalProcess(sobj, comments, new List<Id>());}
    public static Approval.ProcessResult createandSubmitApprovalProcess(sObject sobj, String comments, List<Id> nextApproverIds) {
        Approval.ProcessSubmitRequest req = newApprovalProcess(sobj, comments, nextApproverIds);
        Approval.ProcessResult result = submitApprovalProcess(req);
        return result;
    }

    /********************************** 
    * Create an Approval Process Submit Request
    ***********************************/
    public static Approval.ProcessSubmitRequest newApprovalProcess(sObject sobj) {return newApprovalProcess(sobj, 'Comments', new List<Id>());}
    public static Approval.ProcessSubmitRequest newApprovalProcess(sObject sobj, String comments) {return newApprovalProcess(sobj, comments, new List<Id>());}
    public static Approval.ProcessSubmitRequest newApprovalProcess(sObject sobj, String comments, List<Id> nextApproverIds) {
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments(comments);
        req1.setObjectId(sobj.Id);
        if (nextApproverIds.size() > 0) {req1.setNextApproverIds(nextApproverIds);}

        return req1;        
    }

    /********************************** 
    * Create an Submit ApprovalProcess
    ***********************************/
    public static Approval.ProcessResult submitApprovalProcess(Approval.ProcessSubmitRequest request) {
        Approval.ProcessResult result = Approval.process(request);
        return result;
    }

    /********************************** 
    * General Private Methods
    ***********************************/
    private static SObject newSObject(String sObjectType, String templateType, Map<String,String> fieldValues, Boolean insertRec) {
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sObjectType);
        SObject rec = targetType.newSObject();

        //First: Initialize Data based on TestObjectData values
        TestObjectData.populateSObject(sObjectType, templateType, rec);

        //Second: Apply any passed in field values
        if (fieldValues.size() > 0)
        {
            for (String fieldName:fieldValues.keySet()) 
            {
                System.debug('*** - Updating field on ' + sObjectType + ' - ' + fieldName + ' --> ' + fieldValues.get(fieldName));
                rec.put(fieldName, fieldValues.get(fieldName));
            }
        }
        
        //Third: Insert the record when requested
        if (insertRec) {insert rec;}
        
        return rec;
    }
    
    public static void createPriceFx(){
        //Creating PriceFx test data
        
        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        
        
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        pfxCustomList.add(p);
        
        
        
        PriceFx__c p1 = new PriceFx__c();
        p1.allowed_recordtype_id__c = '01250000000HmZV';
        p1.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p1.Name='callMaterialSalesData2';
        p1.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p1.password__c='Testuser@123';
        p1.username__c='sfdctestuser';
        pfxCustomList.add(p1);
        
        PriceFx__c p2 = new PriceFx__c();
        p2.allowed_recordtype_id__c = '01250000000HmZV';
        p2.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p2.Name='callCustomerProductInfo2';
        p2.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p2.password__c='Testuser@123';
        p2.username__c='sfdctestuser';
        pfxCustomList.add(p2);
        
        PriceFx__c p3 = new PriceFx__c();
        p3.allowed_recordtype_id__c = '01250000000HmZV';
        p3.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p3.Name='callMaterialPlant2';
        p3.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p3.password__c='Testuser@123';
        p3.username__c='sfdctestuser';
        pfxCustomList.add(p3);
        
        insert pfxCustomList;
    }
    
}
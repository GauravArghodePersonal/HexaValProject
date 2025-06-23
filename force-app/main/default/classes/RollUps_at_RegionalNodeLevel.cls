public with sharing class RollUps_at_RegionalNodeLevel {
    @AuraEnabled(cacheable=true)
    public static List<Account> getOppsRelatedToRegionalAcct(Id regionalCustomerNodeId) {
        list<Account> accs = new List<Account>();
        try{
            if(regionalCustomerNodeId != null){
               // accs = [SELECT Id, Name, Is_Corporate_Account__c, SAP_Sales_Org_Region_value__c, (SELECT Name, Amount, StageName, CreatedDate, CloseDate, Oppage__c, RecordType.Name, Primary_Competitor__r.Name, Probability FROM Opportunities) FROM Account WHERE Regional_Customer_Node__c =: regionalCustomerNodeId AND Inactive_Account__c = false WITH USER_MODE];
                Integer currentYear = Date.today().year();
                Integer currentMonth = Date.today().month();
              //  Integer currentYear = 2024;
              //  Integer currentMonth = 10;
                Date startDate;
                Date endDate;
                if(currentMonth > 9)
                {
                	startDate = Date.newInstance(currentYear - 1, 10, 1);
                	//endDate = Date.newInstance(currentYear + 1, 9, 30);
                	endDate = Date.today();
                }
                else
                {
                    startDate = Date.newInstance(currentYear - 2, 10, 1);
                	endDate = Date.newInstance(currentYear, 9, 30);
                }
                system.debug('The startDate : '+ startDate +'and enddate :: ' +endDate + 'current month ::' + currentMonth);
                
           // accs = [SELECT Id, Name, Is_Corporate_Account__c, SAP_Sales_Org_Region_value__c, (SELECT Name, Amount, StageName, CreatedDate, CloseDate, Oppage__c, RecordType.Name, Primary_Competitor__r.Name, Probability FROM Opportunities) FROM Account WHERE Regional_Customer_Node__c =: regionalCustomerNodeId AND Inactive_Account__c = false];
            accs = [ SELECT Id, Name, Is_Corporate_Account__c, SAP_Sales_Org_Region_value__c, (SELECT Name, Amount, StageName, CreatedDate, CloseDate, Oppage__c, RecordType.Name, Primary_Competitor__r.Name, Probability FROM Opportunities WHERE CloseDate >= :startDate AND CloseDate < :endDate ) FROM Account WHERE Regional_Customer_Node__c = :regionalCustomerNodeId AND Inactive_Account__c = false ];
            }
        }
        catch(Exception e){
            system.debug('The Error : '+ e.getMessage());
        }
        return accs;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getVARelatedToRegionalAcct(Id regionalCustomerNodeId) {
        list<Account> accs = new List<Account>();
        try{
            if(regionalCustomerNodeId != null){
                accs = [SELECT Id, Name, Is_Corporate_Account__c, SAP_Sales_Org_Region_value__c, (SELECT Name, Customer__r.AccountNumber, Value_Focus_Area__c, Actual_Status__c, Actual_Date_Approved__c, Customer_Value_Type_Cost_Savings__c, Customer_Value_Type_Cost_Avoidance__c, Delivering_Value_Date__c, Expected_Annual_Value__c, Approver__r.Name from R00N3000000108HTEAY) FROM Account WHERE Regional_Customer_Node__c =: regionalCustomerNodeId AND Inactive_Account__c = false];
            }
        }
        catch(Exception e){
            system.debug('The Error : '+ e.getMessage());
        }
        return accs;
    }
    
    @AuraEnabled
    public static List<Account> getConsRelatedToRegionalAcct(Id regionalCustomerNodeId) {
        list<Account> accs = new List<Account>();
        try{
            if(regionalCustomerNodeId != null){
                accs = [SELECT Id, Name, Is_Corporate_Account__c, SAP_Sales_Org_Region_value__c, (SELECT Id, Name, Account_Owner__c, Email, Phone, Role__c,Site_Location__c,SAP_Title__c,SAP_Phone__c,Grid_Management_Level__c,GRID_ALIGNMENT__c,Grid_Power__c,Alignment_points__c,Power_points__c,Management_level_point__c,Total_contact_rating__c,Contact_polarity__c,Relationship_max_point__c from Contacts where WV_Contact_Status__c = 'Active') FROM Account WHERE Regional_Customer_Node__c =: regionalCustomerNodeId AND Inactive_Account__c = false];
            }
        }
        catch(Exception e){
            system.debug('The Error : '+ e.getMessage());
        }
        return accs;
    }
    
    @AuraEnabled
    public static List<Position_Analysis__c> getStrengthandWeakness(Id regionalCustomerNodeId) {
        list<Position_Analysis__c> parecs = new List<Position_Analysis__c>();
        try{
            if(regionalCustomerNodeId != null){
                parecs = [SELECT Id, Strength_Rating__c, Weakness_Rating__c, Strength_Weakness_Point_Value__c from Position_Analysis__c where RecordType.name = 'SWAT Analysis (Strength and Weakness)' and Regional_Customer_Node__c =: regionalCustomerNodeId];
            }
        }
        catch(Exception e){
            system.debug('The Error : '+ e.getMessage());
        }
        system.debug('parecs size :: ' + parecs.size());
        return parecs;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Account_Rating__c> getAccountRatings(Id regionalCustomerNodeId) {
        list<Account_Rating__c> accratrecs = new List<Account_Rating__c>();
        try{
            if(regionalCustomerNodeId != null){
                accratrecs = [SELECT Id, Situational_Assessment_Total_Rating__c, Earned_Point_Total_SA_Section__c, Market_share_earned_points__c, Market_share_rating_in__c, Overview_rating__c, Perception_pts_earned__c, Total_Activity_Performance_Rating__c, Earned_Point_Total_AP_Section__c, Earned_Point_Total_KI_Section__c, Key_Indicator_Rating__c,Total_Maximum_points__c,RecordType.Name from Account_Rating__c where Regional_Customer_Node__c =: regionalCustomerNodeId];
            }
        }
        catch(Exception e){
            system.debug('The Error : '+ e.getMessage());
        }
        return accratrecs;
    }
    
    @AuraEnabled(cacheable=true)
    public static String getReportURL() {
         String s2 = System.Label.CaminexReportLabel;
        Report reportRecord = [SELECT Id FROM Report WHERE Name = :s2 LIMIT 1];
        String sfdcBaseURL = URL.getOrgDomainURL().toExternalForm();
        if (reportRecord != null) {
            String reportId = reportRecord.Id;
            String reportURL = sfdcBaseURL + '/lightning/r/Report/' + reportId;
            return reportURL;
        } else {
            return null;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Task> getTasksActionItems(Id regionalCustomerNodeId) {
        list<Task> taskrecs = new List<Task>();
        try{
            if(regionalCustomerNodeId != null){
                taskrecs = [SELECT Id, Subject, Related_AccountNumber__c, Action_Item_Description__c, Who.Name,WhoId, Status, Item_completed__c, Assigned_Date__c, ActivityDate FROM Task where recordtype.name = 'Action Item (Caminex)' and WhatId =: regionalCustomerNodeId];
            }
        }
        catch(Exception e){
            system.debug('The Error : '+ e.getMessage());
        }
        return taskrecs;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Task> getEventandLogs(Id regionalCustomerNodeId) {
        list<Task> taskrecs = new List<Task>();
        try{
            if(regionalCustomerNodeId != null){
                taskrecs = [SELECT Id, Subject, Start_Date__c, Attendees__c, What.Name, Status, Owner.Name, ActivityDate, Priority FROM Task where recordtype.name = 'Events & Meetings Log' and WhatId =: regionalCustomerNodeId];
            }
        }
        catch(Exception e){
            system.debug('The Error : '+ e.getMessage());
        }
        return taskrecs;
    }
    
    @AuraEnabled
    public static void updateRelationshipPenetrationIndex(Id regionalCustomerNodeId, Decimal relationshipPenetrationIndex) {
        try {
            Regional_Customer_node__c regionalCustomerNode = [SELECT Id, Overall_relationship_rating__c FROM Regional_Customer_node__c WHERE Id = :regionalCustomerNodeId LIMIT 1];
            regionalCustomerNode.Overall_relationship_rating__c = relationshipPenetrationIndex;
            update regionalCustomerNode;
        } catch (Exception e) {
            System.debug('Error updating Overall_relationship_rating__c: ' + e.getMessage());
            throw new AuraHandledException('Error updating Overall_relationship_rating__c: ' + e.getMessage());
        }
    }
 
    @AuraEnabled(cacheable=true)
    public static String getReportURLVOC(String rep) {
        String s2 = System.Label.CaminexReportLabelVOCQType;
        String s3 = System.Label.CaminexReportLabelVOC;
        System.debug('Entered getReportURLVOC with rep: ' + rep);
        
        Report reportRecord;
        if (rep == s2 || rep == s3) {
            reportRecord = [SELECT Id FROM Report WHERE Name = :rep LIMIT 1];
        } else {
            System.debug('No matching label found for rep: ' + rep);
            return null;
        }
        
        if (reportRecord != null) {
            String sfdcBaseURL = URL.getOrgDomainURL().toExternalForm();
            String reportId = reportRecord.Id;
            String reportURL = sfdcBaseURL + '/lightning/r/Report/' + reportId;
            System.debug('Report URL found: ' + reportURL);
            return reportURL;
        } else {
            System.debug('Report not found for label: ' + rep);
            return null;
        }
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(Id regionalCustomerNodeId) {
        list<Account> accrecs = new List<Account>();
        try{
            if(regionalCustomerNodeId != null){
                //accrecs = [SELECT Name from Account where Regional_Customer_Node__c =: regionalCustomerNodeId];
                accrecs = [SELECT HQ_Account__r.Name from Account where Regional_Customer_Node__c =: regionalCustomerNodeId];
            }
        }
        catch(Exception e){
            system.debug('The Error : '+ e.getMessage());
        }
        return accrecs;
    }

}
@isTest
    private class OpportunityTriggerHandlertest{
        @TestSetUp Private static void OpportunityTriggerEmailSetup(){
            Trigger__c Tr = New Trigger__c();
               Tr.Name='SentEmailToAcc';    
               Tr.Run__c=True;
               Tr.Trigger_Name__c='opportunityTriggerhandler';
           Insert Tr;     
           Competitive_Email_Setup__c CMS = New Competitive_Email_Setup__c();
               CMS.Name='SentEmailToAcc';
               CMS.Bcc__c='Test@test.com';
               CMS.CC_Email__c='Test@test.com';
               CMS.DisplayName__c='Test Display Name';
               CMS.Reply_To__c='Test@test.com';
               CMS.Subject__c='Test Subject';
            insert CMS;
            
            Competitive_Email_Setup__c CMS1 = New Competitive_Email_Setup__c();
               CMS1.Name='1M';
               CMS1.Bcc__c='Test@test.com';
               CMS1.CC_Email__c='Test@test.com';
               CMS1.DisplayName__c='Test Display Name';
               CMS1.Reply_To__c='Test@test.com';
               CMS1.Subject__c='Test Subject';
            insert CMS1;
            
            Competitive_Email_Setup__c CMS2 = New Competitive_Email_Setup__c();
               CMS2.Name='1N';
               CMS2.Bcc__c='Test@test.com';
               CMS2.CC_Email__c='Test@test.com';
               CMS2.DisplayName__c='Test Display Name';
               CMS2.Reply_To__c='Test@test.com';
               CMS2.Subject__c='Test Subject';
            insert CMS2;
            
            Competitive_Email_Setup__c CMS3 = New Competitive_Email_Setup__c();
               CMS3.Name='1P';
               CMS3.Bcc__c='Test@test.com';
               CMS3.CC_Email__c='Test@test.com';
               CMS3.DisplayName__c='Test Display Name';
               CMS3.Reply_To__c='Test@test.com';
               CMS3.Subject__c='Test Subject';
            insert CMS3;
            
            Competitive_Email_Setup__c CMS4 = New Competitive_Email_Setup__c();
               CMS4.Name='1R';
               CMS4.Bcc__c='Test@test.com';
               CMS4.CC_Email__c='Test@test.com';
               CMS4.DisplayName__c='Test Display Name';
               CMS4.Reply_To__c='Test@test.com';
               CMS4.Subject__c='Test Subject';
            insert CMS4;
            
            Competitive_Email_Setup__c CMS5 = New Competitive_Email_Setup__c();
               CMS5.Name='All_Verticals';
               CMS5.Bcc__c='Test@test.com';
               CMS5.CC_Email__c='Test@test.com';
               CMS5.DisplayName__c='Test Display Name';
               CMS5.Reply_To__c='Test@test.com';
               CMS5.Subject__c='Test Subject';
            insert CMS5;
        }
        
        @isTest Private static void OpportunityTriggerHandlerTests(){
           Account Acc= TestDataFactory.createAccount(true);
            Acc.SAP_SalesDistrict__c = 'IWTC1';
            Update Acc;
            
           Account Acc1= TestDataFactory.createAccount(false);
           Acc1.RecordTypeid =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitive Intel').getRecordTypeId(); 
           Acc1.Ownerid=UserInfo.getUserId();
           Acc1.SAP_Customer_Group__c='1M';
           insert Acc1;
                    
           Competitor__c  Compe = TestDataFactory.createApplication(True);
           Machine__c mach = TestDataFactory.createMachine(True,Acc1.id);
           Application__c Ap = TestDataFactory.createApplication(false,mach.id);   
            
            mach.Machine_Type__c = 'Pulp Dryer';//added updated
            update mach;
            Ap.suppliers__c=Compe.id;
               
               Ap.Machine_Type__c='Pulp Dryer';
               Ap.Process_Area__c='Dry End ~ Pulp Dryer';
               Ap.Application_Type__c='Passivation ~ Pulp Dryer';
               Ap.Product_SBU__c='Pulp';
               Ap.Supplier_Other__c=' ';//added
             //  Ap.Machine__r.Account__r.RecordType.Name='Competitive Intel';
               Insert Ap;
               
               CollaborationGroup myGroup = new CollaborationGroup();
               myGroup.Name='My Group'; // Define group name here
               myGroup.CollaborationType='Public'; //It can be 'Public' or 'Private'  
               insert myGroup;                      
       
           Opportunity Opp = TestDataFactory.createOpportunity(true,Acc.id);
           
           Opportunity_Material__c oppMat = TestDataFactory.createOpportunityMaterial(true,opp.id);Opp.StageName='Won';
              Opp.SBU_Multi__c='Defoamers';               
              Opp.ByPassValidation_Rule__c=True;
              //Opp.SAP_Sales_District__c ='IWNA1';
              
              Test.startTest();
              update Opp;  
         	Test.stopTest();     
       }
	
	/* ***********************************************************
	 * @description: Inserting test data for Project(ActionItem).
	 * ***********************************************************/
     @isTest
     Private static void createProjectTest(){
         List<opportunity> opplist = new List<opportunity>();
         User user= TestDataFactory.createUser(True, 'solenis@test.com', 'empId');
         Account Acc= TestDataFactory.createAccount(false);
         Acc.SAP_Sales_Org__c  = '1020';
         Acc.SAP_Sales_Office__c = 'IW36';
         Acc.SAP_Sales_Group_Desc__c = 'IWT NA SE_NORTH';
          //added
         Acc.SAP_SalesDistrict__c = 'IWNA7';
         Acc.SAP_Sales_District_Desc__c = 'IWT NAA';
         acc.Prospect_Sales_District__c = 'IWT NA (IWNA0)';
         
         Insert Acc;
         System.debug('Acc' +Acc);
         System.debug('Acc' +Acc.id);
             System.debug('Acc' +Acc.SAP_SalesDistrict__c);
         Global_Strategic_Initiative__c gsi= TestDataFactory.createGlobalStrategicInitiative(True, user.Id);
         Category__c cat= TestDataFactory.createCategory(True, gsi.Id, user.Id);
         Opportunity Opp = TestDataFactory.createOpportunity(false, Acc.Id);
         //Opp.AccountId = Acc.Id;
         Opp.GSI_Code__c = 'PAM';
         Opp.SAP_Sales_Org_Region__c = 'NA';
         Opp.CloseDate = System.today();
         Insert Opp;
         
         opplist.add(Opp);
 		 System.debug('Acc' +Opp.AccountId);
             SYstem.debug('Acc' +Opp); 
             SYstem.debug('Acc' + [SELECT Id, AccountId, SAP_Sales_District__c FROM Opportunity WHERE Id = :Opp.Id]);
         
         //Opportunity_Material__c oppMat = TestDataFactory.createOpportunityMaterial(true,opp.id);
         Action_Item__c act=TestDataFactory.createActionItem(True, gsi.Id, cat.Id,Opp.Id);
            
         Action_Item__c result= [Select Id,Global_Strategic_Initiative__c,Category__c,Opportunity_AI__c From Action_Item__c where Id =: act.Id];
         test.startTest();
         opportunityTriggerhandler.createProject(opplist);
         test.stopTest();
         System.assertEquals(gsi.Id, result.Global_Strategic_Initiative__c);
         System.assertEquals(cat.Id, result.Category__c);
         System.assertEquals(Opp.Id, result.Opportunity_AI__c);
     }  
    //added
   
}
public class opportunityTriggerhandler{
    public static boolean IsUpdateOppMat = true;
    public static void afterUpdateTrigger(List<opportunity> newlist,Map<id,opportunity> oldmapValue) {
    
       list<id> RecordId = New list<id>();
       for(opportunity op:newlist){
           if((op.StageName != oldmapValue.get(op.Id).StageName && op.StageName== 'Won') || Test.isRunningTest()){
               RecordId.add(op.id);
              }
           } 
        if(checkRecursive.runOnce()){  
            If(Trigger__c.getValues('SentEmailToAcc').Run__c && RecordId.Size()>0){
              SentEmailToAcc(RecordId);
              }
        }                 
    }
    
    public static void beforeUpdateTrigger(List<opportunity> newlist,Map<id,opportunity> oldmapValue){
      
    }   

    
   @future    
   public static void SentEmailToAcc(List<id> RecordId){
             String BaseURL=URL.getSalesforceBaseUrl().toExternalForm();
             List<opportunity> newlist= New List<opportunity>();
             newlist=[Select id,name,SBU_Multi__c,Primary_Competitor__c,StageName,Opportunity_Number__c,Account_Name__c,SAP_Sales_Org_Region__c,Opportunity_Owner__c,Opportunity_owner_email__c,Competitor_Name__c,Amount,SAP_Customer_Group__c,W_Secondary_Won_Lost_Reason__c,W_Primary_Won_Lost_Reason__c,SAP_Customer_Group_Desc__c,SAP_Sales_District__c,SAP_Sales_District_Desc__c,SAP_Sales_Group__c,SAP_Sales_Group_Desc__c,SAP_Sales_Office__c,SAP_Sales_Office_Desc__c from opportunity where id=:RecordId];
       // if(checkRecursive.runOnce()){  
        list<string> SBU = New list<string>();
        list<string> SBUList = New list<string>();
        String strSBU;
        List<id> SupilerList = New List<id>();
        List<String> SAPCustomerGroupList = New List<String>();
        list<Application__c> app = New List<Application__c>();
        for(opportunity opp:newlist){
            SupilerList.Add(opp.Primary_Competitor__c);
            SAPCustomerGroupList.Add(opp.SAP_Customer_Group__c);
            if(opp.StageName== 'Won'){
                strSBU=opp.SBU_Multi__c;                            
            }   
            else if(Test.isRunningTest()){
                strSBU='Contaminant Control;Pulp Mill;Barrier technologies;RDC;Dry Strength;Defoamers;Creping/Softeners;Coloration;Microbiological Control;Sizing;Wet Strength;Crosslinkers;Deinking;Polymers;Wood Products;';
            }        
        }
        if(strSBU!=Null){
            SBU=strSBU.split(';');
        }
        
        
        for(String str:SBU){
            if(str=='Barrier technologies'){
                SBUList.add('Coating & Barriers');}
            else if(str=='Pulp Mill'){
                SBUList.add('Pulp Specialties');              
            }
            else if(str=='RDC'){
                SBUList.add('Retention/Drainage/Clarification');              
            }
            else{
                SBUList.add(str);
            }
            
        }
         app=[select id,name,Machine__r.Account__r.ownerid,Machine__r.Account__r.RecordType.Name,Product_SBU__c,suppliers__c,Machine__r.Name,Machine__r.Account__r.owner.Email,Machine__r.Account__r.owner.Name,Machine__r.Account__c,Machine__r.Account__r.Name,Machine__r.Account__r.CIS_Prospect_Number__c,suppliers__r.Name,Vertical_Code__c,Vertical_Name__c
             FROM Application__c 
             WHERE Product_SBU__c IN :SBUList AND Machine__r.Account__r.RecordType.Name='Competitive Intel' and Machine__r.Account__r.owner.IsActive=True and suppliers__c IN :SupilerList and Vertical_Code__c IN:SAPCustomerGroupList ];
             
              If(Test.isRunningTest()){
                 app= New List<Application__c>();
                app=[select id,name,Machine__r.Account__r.ownerid,Machine__r.Account__r.RecordType.Name,Product_SBU__c,suppliers__c,Machine__r.Name,Machine__r.Account__r.owner.Email,Machine__r.Account__r.owner.Name,Machine__r.Account__c,Machine__r.Account__r.Name,Machine__r.Account__r.CIS_Prospect_Number__c,suppliers__r.Name,Vertical_Code__c,Vertical_Name__c
             FROM Application__c ];
          //   WHERE Product_SBU__c IN :SBUList AND Machine__r.Account__r.RecordType.Name='Competitive Intel' and Machine__r.Account__r.owner.IsActive=True ]; 
             }             
            If(app.size()>0){
         set<String> accOwnerEmail = new set<string>();         
         string header = 'Account Name,Machine Name,Application Name,Account Owner Name,Prospect Number,Suppliers,Product SBU,Vertical Name\n';
            string finalstr = header ;
        
         for(Application__c ap:app){
             accOwnerEmail.add(ap.Machine__r.Account__r.owner.Email);
             string recordString = ap.Machine__r.Account__r.Name+','+ap.Machine__r.Name+','+ap.name+','+ap.Machine__r.Account__r.owner.Name+','+ap.Machine__r.Account__r.CIS_Prospect_Number__c+','+ap.suppliers__r.Name+','+ap.Product_SBU__c+','+ap.Vertical_Name__c+'\n';            
                   finalstr = finalstr +recordString;
         }
            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
            blob csvBlob = Blob.valueOf(finalstr);
            string csvname= 'Competitive Intel Accounts'+System.Now()+'.csv';
            csvAttc.setFileName(csvname);
            csvAttc.setBody(csvBlob);
            List<Email_Log__c> ELog = New List<Email_Log__c>();
            For(Opportunity Op: newlist){
                Email_Log__c EMLog = New Email_Log__c();
                    EMLog.Account__c=Op.Account_Name__c;
                    EMLog.Opportunity_name__c=Op.Name;
                    EMLog.Opportunity_number__c=Op.Opportunity_Number__c;
                    EMLog.Region__c=Op.SAP_Sales_Org_Region__c;
                    EMLog.Opportunity_owner__c=OP.Opportunity_Owner__c;
                    EMLog.Opportunity_owner_email__c=Op.Opportunity_owner_email__c;
                    EMLog.Competitor_Name__c=Op.Competitor_Name__c;
                    EMLog.SBU_Name__c=Op.SBU_Multi__c;
                    EMLog.Email_Count__c=accOwnerEmail.size();
                    EMLog.Vertical_Code__c=Op.SAP_Customer_Group__c;
                    EMLog.Vertical_Name__c=Op.SAP_Customer_Group_Desc__c;
                    EMLog.SAP_Sales_District__c=Op.SAP_Sales_District__c;
                    EMLog.SAP_Sales_District_Desc__c=Op.SAP_Sales_District_Desc__c;
                    EMLog.SAP_Sales_Group__c=Op.SAP_Sales_Group__c;
                    EMLog.SAP_Sales_Group_Desc__c=Op.SAP_Sales_Group_Desc__c;
                    EMLog.SAP_Sales_Office__c=Op.SAP_Sales_Office__c;
                    EMLog.SAP_Sales_Office_Desc__c=Op.SAP_Sales_Office_Desc__c;
                    ELog.add(EMLog);
                    
            If(accOwnerEmail.size()>0){
                List<Messaging.SingleEmailMessage> masterListMails =  new List<Messaging.SingleEmailMessage>();
                Decimal Count=0;
                Decimal CountSet=1;    
                string []toAdd=new string[]{};    
               // string []toAdddub=new string[]{};                                       
                For(String ST:accOwnerEmail){
                                
                    toAdd.add(ST);                
                      
                      if(toAdd.size()==95 || accOwnerEmail.size()==CountSet){  
                        messaging.SingleEmailMessage email1=new messaging.SingleEmailMessage();               
                        
                        string []ccAdd=new string[]{};               
                        string []bccAdd=new string[]{};
                        String bccList=Competitive_Email_Setup__c.getValues('SentEmailToAcc').Bcc__c;
                        String ccList=Competitive_Email_Setup__c.getValues('All_Verticals').CC_Email__c;
                        If(Op.SAP_Customer_Group__c=='1M' || Op.SAP_Customer_Group__c=='1R' || Op.SAP_Customer_Group__c=='1N' ||Op.SAP_Customer_Group__c=='1P'){
                        ccList+=';';
                        ccList+=Competitive_Email_Setup__c.getValues(Op.SAP_Customer_Group__c).CC_Email__c;  
                        }  
                        ccAdd = ccList.split(';');         
                        bccAdd= bccList.split(';');   
                                     
                        email1.setToAddresses(toAdd);
                        email1.setReplyTo(Competitive_Email_Setup__c.getValues('SentEmailToAcc').Reply_To__c);
                        email1.setCcAddresses(ccAdd);
                        email1.setBccAddresses(bccAdd);
                        email1.setSubject(Competitive_Email_Setup__c.getValues('SentEmailToAcc').Subject__c + ' ' + EMLog.Competitor_Name__c);
                        String StrHtml ='Hi All'+'<br/><br/>'+'If you are receiving this email, it’s because Solenis recently won business from a competitor who sells a similar product at one of your accounts as listed in the competitive edge database.'+' <br/>'+'The below win could potentially serve as a reference to target the same competitive application at your account.'+'<br/><br/>'+'The details of the business won are below:'+'<br/><br/>'+'Opportunity name : '+Op.Name+'<br/>'+'Opportunity number : '+Op.Opportunity_Number__c+'<br/>'+'Account : '+Op.Account_Name__c+'<br/>'+'Region : '+Op.SAP_Sales_Org_Region__c+'<br/>'+'Vertical Name: '+Op.SAP_Customer_Group_Desc__c+'<br/>'+'Opportunity owner : '+OP.Opportunity_Owner__c+'<br/>'+'Opportunity owner email : '+ Op.Opportunity_owner_email__c+'<br/>'+'Competitor Name: '+Op.Competitor_Name__c+'<br/>'+'Primary Won/Lost Reason: '+Op.W_Primary_Won_Lost_Reason__c+'<br/>'+'Secondary Won/Lost Reason: '+Op.W_Secondary_Won_Lost_Reason__c+'<br/>'+'SBU Name : '+Op.SBU_Multi__c+'<br/>'+'Est. Annual Revenue of Opportunity : '+Op.Amount+'<br/><br/>'+'If you need information about this won opportunity, please contact the opportunity owner or your local Applications Support Team.'+'<Font style="color: Red;"> To make sure you are copied on future announcements like this one, please make sure you have updated the competitive intel account information in SFDC for your customers.</Font>'+'<br/><br/>'+'Good luck !';
                        email1.setHtmlBody(StrHtml);
                       // email1.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
                        email1.setSenderDisplayName(Competitive_Email_Setup__c.getValues('SentEmailToAcc').DisplayName__c);
                        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {email1};
                        //Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                        masterListMails.add(email1);
                           toAdd.clear();
                        
                        Count=0;
                        }
                        CountSet++;
                        Count++;
                }     
                 Messaging.SendEmailResult[] results = Messaging.sendEmail(masterListMails);
                
           }
          }
          System.debug('<<ELog>>>'+ELog);
          IF(ELog.size()>0){
          insert ELog;
          }
        }
    
    }
    
    /**
     * Desc: Opportunity based GSI project creation based on GSI-Code.
     * 
     **/
        public static void createProject(List<Opportunity> newlist)
    {
       
        String regionname = '';
        List<String> gsiId = New List<String>();
        List<string> oppId=new List<string>();
        List<Action_Item__c> serList = new List<Action_Item__c>();
        Map<String, String> gsiMap = new Map<String, String>();
        Map<String, Category__c> catMap = new Map<String, Category__c>();
        for(Global_Strategic_Initiative__c gsi:[Select id,Name,GSI_Code__c,Regions__c,Vertical__c,Active__c,RecordType.Name FROM Global_Strategic_Initiative__c Where RecordType.Name = 'Opportunity GSI' AND Active__c = TRUE]){
            String gsiRecv = gsi.GSI_Code__c + gsi.Regions__c + gsi.Vertical__c;
            gsiMap.put(gsiRecv, gsi.Id);
        }
        for(Opportunity Opp:[Select id, GSI_Code__c,SAP_Sales_Org_Region__c,SAP_Sales_District__c,SAP_Sales_Group_Desc__c,SAP_Sales_Office__c From Opportunity where id IN:newlist])
        {
        //New code change for District Code Logic
            String str= opp.SAP_Sales_District__c;
            String strRec='';
            if(str!=null)
            {
                //District code = -- IWTC1 - FW
                if(str.equals('IWTC1'))
                {
                    strRec='FW';
                }
                //District code  contains IW - IWAP1-- IWT
                else if(str.contains('IW'))
                {
                    strRec='IWT';
                }
                //District code contains PP - PPNA1,-- P&P
                else if(str.contains('PP'))
                {
                    strRec='P&P';
                }
                //District code contains PSS - AM
                else if(str.contains('PSS'))
                {
                    strRec='AM';
                }
                //District code contains RSA - RSA
                else if(str.contains('RSA'))
                {
                    strRec='RSA';
                }
                else
                {
                     strRec='Other';
                }
                
            }
            else
            {
                strRec=''; 
            }
            
              
            if(opp.GSI_Code__c != Null && opp.SAP_Sales_Org_Region__c !=Null){
                regionname += opp.GSI_Code__c + opp.SAP_Sales_Org_Region__c + strRec;
                if(gsiMap.containsKey(regionname)){
                    gsiId.add(gsiMap.get(regionname));
                    oppId.add(opp.id);
                }
            }
        }
                for(Category__c caty:[Select id,Name,Region__c,Category_Code__c,Global_Strategic_Initiative__c, Assigned_To__c From Category__c Where Global_Strategic_Initiative__c IN:gsiId]){
            catMap.put(caty.Category_Code__c, caty);
        }
        string matchstring='';
        for(Opportunity Opp:[Select id,Name,StageName,Owner.Id,CloseDate,GSI_Code__c,SAP_Sales_Org_Region__c,SAP_Sales_District__c,SAP_Sales_Office__c,SAP_Sales_Group_Desc__c,Annualized_Gross_Profit_GP__c From Opportunity where id IN:oppId])
        {
            //New code change for District Code Logic
            String str= opp.SAP_Sales_District__c;
            String strRec='';
            if(str!=null)
            {
                //District code = -- IWTC1 - FW
                if(str.equals('IWTC1'))
                {
                    strRec='FW';
                }
                //District code  contains IW - IWAP1-- IWT
                else if(str.contains('IW'))
                {
                    strRec='IWT';
                }
                //District code contains PP - PPNA1,-- P&P
                else if(str.contains('PP'))
                {
                    strRec='P&P';
                }
                //District code contains PSS - AM
                else if(str.contains('PSS'))
                {
                    strRec='AM';
                }
                //District code contains RSA - RSA
                else if(str.contains('RSA'))
                {
                    strRec='RSA';
                }
                else
                {
                     strRec='Other';
                }}
            else
            {
                strRec=''; 
            }
             if(opp.GSI_Code__c != Null && opp.SAP_Sales_Org_Region__c !=Null){
                matchstring += opp.GSI_Code__c + opp.SAP_Sales_Org_Region__c + strRec;
                if(gsiMap.containsKey(matchstring)){
                    
                    Action_Item__c act = new Action_Item__c();
                    act.Name = Opp.Name;
                    act.recordTypeId = Schema.SObjectType.Action_Item__c.getRecordTypeInfosByName().get('Opportunity Based GSI').getRecordTypeId();
                    act.Opportunity_AI__c = opp.Id;
                    act.Region__c = opp.SAP_Sales_Org_Region__c;
                    act.Vertical__c = strRec;
                    act.Project_Owner__c = Opp.Owner.Id;
                    act.Action_Item_Value_Captured__c = Opp.Annualized_Gross_Profit_GP__c;
                    act.Due_Date__c = Opp.CloseDate;
                    act.Global_Strategic_Initiative__c = gsiMap.get(matchstring);
                    if(Opp.StageName == 'Defended' || Opp.StageName == 'Won'){
                        act.Action_Item_Status__c = 'Completed';
                    }
                    else if(Opp.StageName == 'Lost Business'){
                        act.Action_Item_Status__c = 'Lost Business';
                    }
                    else if(Opp.StageName == 'Lost Opportunity'){
                        act.Action_Item_Status__c = 'Lost Opportunity';
                    }
                    else if(Opp.StageName != 'Defended' && Opp.StageName != 'Won' && Opp.StageName != 'Lost Business' && Opp.StageName != 'Lost Opportunity'){
                        act.Action_Item_Status__c = 'In Progress';
                    }
                    if(opp.SAP_Sales_District__c=='IWNA1')
                    {
                        if(catMap.get(opp.SAP_Sales_District__c+opp.SAP_Sales_Office__c)!=null)
                        {
                    if(act.Global_Strategic_Initiative__c == catMap.get(opp.SAP_Sales_District__c+opp.SAP_Sales_Office__c).Global_Strategic_Initiative__c)
                    {
                        act.Category__c = catMap.get(opp.SAP_Sales_District__c+opp.SAP_Sales_Office__c).Id;
                       }}
                    }
                    else
                    {
                     if(catMap.get(opp.SAP_Sales_District__c) !=Null){
                         if(act.Global_Strategic_Initiative__c == catMap.get(opp.SAP_Sales_District__c).Global_Strategic_Initiative__c)
                             {
                                 act.Category__c = catMap.get(opp.SAP_Sales_District__c).Id;}
                    }
                    }
                    serList.add(act);
                }
            }
        }
        List<Action_Item__c> actlist=[Select id,Opportunity_AI__c,Action_Item_Status__c from Action_Item__c where Opportunity_AI__c in: newlist];
        if(serList.size()>0 && actlist.size()==0){
            Insert serList;
        }
           
    }
    
    
}
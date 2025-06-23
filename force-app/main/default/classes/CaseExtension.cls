public class CaseExtension
{
    private static final Integer MAX_COUNT_1 = 200;

    public Case m_Case { get; private set; }
    public boolean displayCasePageBlock{get;set;}
    public String m_vfPageMessageSummary { get; set; }
    public String strErrMsg {get; private set;}
    public Boolean InternalExternalFieldEditable {get; set;}
    public Boolean AccountIdFieldEditable {get; set; }
    public Boolean ContactIdFieldEditable {get; set; }
    private List<SelectOption> caseReasonsOptionsList = new List<SelectOption>();
    private List<SelectOption> caseOriginsOptionsList = new List<SelectOption>();
    private List<SelectOption> technicalLabGroupOptionsList = new List<SelectOption>();
    public List<SelectOption> CaseReasons {get {return this.caseReasonsOptionsList;}}
    public List<SelectOption> CaseOrigins {get {return this.caseOriginsOptionsList;}}
    public List<SelectOption> TechnicalLabGroups {get {return this.technicalLabGroupOptionsList;}}
    
    public String CaseReason {get {return m_Case.Reason;} set {m_Case.Reason = value;}}
    public String CaseOrigin {get {return m_Case.Origin;} set {m_Case.Origin = value;}}
    public String TechnicalLabGroup {get {return m_Case.Technical_Lab_Group__c;} set {m_Case.Technical_Lab_Group__c = value;}}
    
    public Decimal TotalOpportunityRevenueAnnual {get; set;}
    public Decimal CYAmountAtRisk {get; set;}
    
    public String userLocale {get; set;} 
    public String OppCurrency {get;set;}
    public String RiskCurrency {get;set;}
    
    public String FocusField {get; set; }
    
    public Sample_Request_Aquarius__c aquarius {get; set;}
    public Sample_Request_Aquarius aquariusRequest {get; set;}
    public boolean renderAquariusForm {get; private set;}
    public boolean renderTSRForm {get; private set;}
    public boolean renderRiskForm {get; private set;}
    public boolean renderContactForm {get; private set;}  
    public boolean renderOwnerForm {get; private set;} 
    public boolean renderCustFeedbackByForm {get; private set;} 
    public boolean renderCustContFeedbackForm {get; private set;}
    
    
    public boolean disableAquariusBtn {get; private set;} 
    public boolean renderSaveAndSubmitButton {get; private set;}
    
    public boolean renderTechServInfoSection {get; private set;}
    public boolean renderCaseTimeSection {get {return false;} private set;} // hide section
    public boolean renderLabResultsSection {get; private set;}
    public boolean renderCustomerFeedbackSection {get; private set;}
    public boolean renderLabWorkApprovedPBSItem {get; private set;}
    
    //public String TotalOpportunityRevenueAnnualCurrency {get; set; }
    //public Boolean ErrorPageBlockRendered {get {return String.isNotBlank(strErrMsg);} set;}
    
    //ApexPages.StandardController stdCtrl;
    
    private string strRecordTypeParam, strRetURLParam, strCancelURLParam, strAccidParam, strOppIdParam, strConIdParam ;
    private String RecordTypeId, RecordTypeName; 
    
    private Account acc;
    private Opportunity opp;
    private Contact cont;
    private Risk__c risk;
    private Boolean isCaseCreated {get;set {isCaseCreated = false;}}
    
    // Fields used in opp search form
    public String oppName         {get; set;}
    public String oppIdFromOppSearch {get; set;}
    public boolean renderOppsForm   {get; private set;} 
    public boolean renderOppsList {get; private set;}     
    public boolean renderMaxMsg1 {get; private set;}
    private List<Opportunity> opportunities;
    public Integer maxCount1 {get; private set;}
    
    // Risk search form
    public String riskName         {get; set;}
    public boolean renderRisksList {get; private set;}
    private List<Risk__c> risks;
    
    // Contact search form
    public String contactName         {get; set;}
    public boolean renderContactsList {get; private set;}
    private List<Contact> contacts; 

    // Owner search form
    public String ownerName         {get; set;}
    public boolean renderOwnersList {get; private set;}
    private List<User> owners;  
    
    // Customer_Feedback_By__c search form
    public String custFeedbackByName         {get; set;}
    public boolean rendercustFeedbackByList {get; private set;}
    private List<User> custFeedbackByList; 
    
    // Customer_Contact_for_Feedback__c search form
    public String custContFeedbackName         {get; set;}
    public boolean renderCustContFeedbackList {get; private set;}
    private List<Contact> custContFeedbackList;    
        
    public Boolean disableSave {get;set;}
    
    // Properties used in setting field required style
    public String SubjectRequireStyle {get; private set;}
    public String InternalExternalRequireStyle {get; private set;}    
    public String AccountIdRequireStyle {get; private set;}
    public String BusinessSegmentRequireStyle {get; private set;}
    public String CaseReasonRequireStyle {get; private set;}
    public String BusinessUnitRequireStyle {get; private set;}
    public String StatusRequireStyle {get; private set;}
    public String SBURequireStyle {get; private set;}
    public String RequestedCompletionDateRequireStyle {get; private set;}
    public String TechnicalLabGroupRequireStyle {get; private set;}
    public String BackgroundRequireStyle {get; private set;}
    public String DescribeWorkNeededRequireStyle {get; private set;}
    public String ContactIdRequireStyle {get; private set;}
    public String OwnerIdRequireStyle {get; private set;}
    public String ObjectiveRequireStyle {get; private set;}
    
    public String tsrStatusOnRecordLoad {get; private set;}
    public Boolean isLabWorkApprover {get; set;}
    public Boolean isLabTech {get; set;}
    
    //CPI
    public SAP_LISD lisd  {get; set;}    
    public Boolean renderPage2           {get; private set;}
    public boolean activeAccount {get; set;}
    public Boolean renderGoto2           {get; private set;}
    public Boolean renderLisd            {get; private set;}
    public Boolean renderGoto1           {get; private set;}
    private String lisdCustomerGroup {get;set;}
    
    //Sales DOG
    public String helpText_cg            {get; private set;}
    public String helpText_sd            {get; private set;}
    public String helpText_so            {get; private set;}
    public String helpText_sg            {get; private set;}    
    
    //Debugging related
    public String debugTextValue {get; set;}
    public Boolean renderDebugPanel {get; set;}     
    
    private List<String> FormRequiredFieldNamesList = new List<String>
        {
            'Subject', 'Internal_External__c', 'AccountId',  'Status', 
            'Reason',  'OwnerId', 'ContactId', 'Technical_Lab_Group__c',
            'T_RequestedCompletionDate__c', 'SBU__c', 'Background__c', 
            'Describe_Work_Needed__c'
            
            
        };
        
    private List<String> FormRequiredFieldLabelsList = new List<String>
        {
            'Title / Subject', 'Internal / External', 'Customer / Prospect Account Name',
             'Status', 'Case Reason', 'Owner', 'Contact', 'Technical Lab Group',
            'Requested Completion Date', 'SBU', 'Background', 'Describe Work Needed'
            
        };     
    
    public CaseExtension(ApexPages.StandardController controller) 
    {
        userLocale = UserInfo.getLocale();
        debugTextValue = '';
        if (controller!= null) {
            this.m_Case = (Case)controller.getRecord();
            
            //stdCtrl = controller;
        }
        else
        {
            this.m_Case = new Case();
        }       
        GetQueryStringParams();
        SetRecordTypeIdAndName(); 
            
        if (RecordTypeName == 'AAFI-TSR' || RecordTypeName == 'AAFI-TSSR') 
        {               
            displayCasePageBlock = true; 

            if (this.m_Case.id != null)
                GetCaseInfo(this.m_Case.Id);
            
        }   
        
        renderLisd = true;
        renderPage2 = false;  
        renderGoto2 = false; 
        renderGoto1 = false;         
        renderConfirmDialogComp = false;        
    }

    public PageReference redirect() 
    {
        String param = getParameters() ;
        system.Debug('---redirect Parm---'+param);
        if (RecordTypeName != 'AAFI-TSR' && RecordTypeName != 'AAFI-TSSR') 
        {
            String prefix = Case.SObjectType.getDescribe().getKeyPrefix();
            //String param = getParameters() ;
            system.Debug('---redirect Parm1---'+'/'+prefix+'/e?nooverride=1&'+param);
            return new PageReference('/'+prefix+'/e?nooverride=1&'+param); 
            
        } 
        else 
        {

            PageReference CasePage = new PageReference('/apex/CaseCPI?'+param); 
            CasePage.setRedirect(true);
            return CasePage; 
        }

    }

    public void OnFormLoaded()    
    {
        LogDebugMsg('Entered: OnFormLoaded');
        renderContactForm = false;
        isLabWorkApprover = false;
        isLabTech = false;
        ShowForm('renderTSRForm');
        LogDebugMsg('hasMessages: ' + ApexPages.hasMessages());
        try
        {
            if (RecordTypeName == 'AAFI-TSR' || RecordTypeName == 'AAFI-TSSR') 
            {
                disableSave = false;
                maxCount1 = MAX_COUNT_1;
                  
                enableDisableItemsBasedOnTsrStatus();           
                
                // set contact
                if (strConIdParam != null && m_Case.ContactId == null)
                {
                    GetContactInfo(strConIdParam);
                }
                else if (m_Case.ContactId != null)
                {
                    GetContactInfo(m_Case.ContactId);
                }
                    
                // Set Opportunity                  
                if (strOppIdParam != null && m_Case.Related_Opportunity__c == null)
                {
                    GetOpportunityInfo(strOppIdParam);
                    oppName = opp.Name;                 
                }
                else if (m_Case.Related_Opportunity__c != null)
                {
                    GetOpportunityInfo(m_Case.Related_Opportunity__c);
                    oppName = opp.Name;
                
                }
                // Set Risk Related Info
                if (m_Case.Risk_To_Plan__c != null)
                {
                    GetCYAmountAtRisk();
                    riskName = risk.Name;
                
                }   
                
                // Set Owner Info
                if (m_Case.OwnerId != null)
                {
                    GetOwnerInfo(m_Case.OwnerId);
                }   
                
                // Set Customer_Feedback_By__c Info
                if (m_Case.Customer_Feedback_By__c != null)
                {
                    GetCustFeedbackByInfo(m_Case.Customer_Feedback_By__c);
                }                        

                // Set Customer_Contact_for_Feedback__c Info
                if (m_Case.Customer_Contact_for_Feedback__c != null)
                {
                    GetCustContFeedbackInfo(m_Case.Customer_Contact_for_Feedback__c);
                }
                
                if (this.m_Case.id == null) // new Case
                {
                    m_Case.Status = 'New';
                    
                    // doing this as a workaround... when creating a new record, the field (in setup) should 
                    // be defaulted to External but the value here is coming here as null
                    m_Case.Internal_External__c = 'External'; 
                    getCaseReasons(m_Case.Internal_External__c);
                    getCaseOrigins(m_Case.Internal_External__c);                    

                    InternalExternalFieldEditable = true;
                    
                    if (this.m_Case.ContactId == null)
                        ContactIdFieldEditable = true;       
                
                } 
                else
                {
                    getCaseReasons(m_Case.Internal_External__c);
                    getCaseOrigins(m_Case.Internal_External__c);                    

                    InternalExternalFieldEditable = false;
                    ContactIdFieldEditable = false;
    
                    if (this.m_Case.ContactId == null || m_Case.Status == null || m_Case.Status == 'New')
                    {
                        ContactIdFieldEditable = true;
                    }               
                    
                    // Set controller fields
                    CaseReason = m_Case.Reason;
                    CaseOrigin = m_Case.Origin;     
                    TechnicalLabGroup = m_Case.Technical_Lab_Group__c;
                    
                    isLabWorkApprover = CaseCustomSettings__c.getInstance().Lab_Work_Approver__c;
                    isLabTech = CaseCustomSettings__c.getInstance().Lab_Tech__c;
                         
                    if (m_Case.Lab_Work_Completed__c && isLabWorkApprover)
                        renderLabWorkApprovedPBSItem = true;            

                } 
                

                                    
                LogDebugMsg('m_Case.Customer_Group__c: ' + m_Case.Customer_Group__c);
                lisdCustomerGroup = m_Case.Customer_Group__c;
                getTechLabGroups(lisdCustomerGroup);
                                
            }
            
        }
        
        catch (Exception ex)
        {
            LogException('OnFormLoaded', ex);
            System.debug('*** OnFormLoaded Error: ' + ex); 
        }
        
        LogDebugMsg('Exiting: OnFormLoaded'); 
    }  
        
    public PageReference save()
    {
        //System.debug('*** Entered Save Method ***');
        
        PageReference returnValue = null;
                
        try
        {

            Savepoint sp = Database.setSavepoint();
            
            if (!customSave())
            {
                Database.rollback(sp);
            }
            else
            {
                // if a new Case is created go to that Case
                if (isCaseCreated)
                {
                    returnValue = new PageReference('/' + this.m_Case.id);
                }
                else
                {
                    // otherwise go back to where came from
                    returnValue = cancel();
                }
            }           
                        
        }
        catch (Exception ex)
        { 
            LogException('save', ex); 
        }
        
        System.debug('returnValue: ' + returnValue);
        
        //System.debug('*** Exiting Save Method ***');
        
        return returnValue;

        
    } 
    
    public PageReference saveAndNew()
    {
        PageReference returnValue = null;
        
        try
        {

            Savepoint sp = Database.setSavepoint();
            
            if (!customSave())
            {
                Database.rollback(sp);
            }
            else
            {
                returnValue = new PageReference('/setup/ui/recordtypeselect.jsp?ent=Case&retURL=/500/o&save_new_url=/500/e?retURL=/500/o');
                //LogException('saveAndNew', 'Method not implemented yet');
                //System.Debug('saveAndNew - returnValue: ' + returnValue);
            }           
                        
        }
        catch (Exception ex)
        { 
            LogException('saveAndNew', ex); 
        }
        
        return returnValue;

    }   
    
    
    public PageReference saveAndSubmit()
    {
        try
        {

            Savepoint sp = Database.setSavepoint();
            
            if (!customSave())
            {
                Database.rollback(sp);
                return null;
            }
            else
            {
                Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();        
                psr.setComments('Submitting TSR for Approval.');        
                psr.setObjectId(this.m_Case.id);        
                Approval.ProcessResult pr = Approval.process(psr); 
         
                if (!pr.isSuccess()) 
                {
                    LogException('saveAndSubmit', 'TSR Submit Failed');
                }                   
                else
                {
                    // if a new Case is created go to that Case
                    if (isCaseCreated)
                    {
                        return new PageReference('/' + this.m_Case.id);
                    }
                    else // Submit for approval and  go back to where came from
                    {
                    
                        return cancel();
                    }
                }
            }           
                        
        }
        catch (Exception ex)
        { 
            LogException('saveAndSubmit', ex); 
        }
        return null;        
    }
    

    public PageReference cancel()
    { 
        try 
        {
            PageReference caseHome;
            //PageReference oppHome = new PageReference('/006/o'); 
            if (strRetURLParam == null)
                caseHome = new PageReference(strCancelURLParam); 
            else
                caseHome = new PageReference(strRetURLParam); 
                
            caseHome.setRedirect(true); 
            return caseHome; 
        } 
        catch (Exception ex)
        {
            LogException('cancel', ex);
        } 
        return null;
    
    } 
    
    public PageReference GetAccountRelatedInfo()
    {
        try
        {
            //System.Debug('m_Case.AccountId: ' + m_Case.AccountId);
            if (m_Case.AccountId != null)
            {
                
                GetAccountInfo(m_Case.AccountId);
                                
                //System.Debug('m_Case.Account.OwnerId: ' + m_Case.Account.OwnerId);
                if (m_Case.OwnerId == null)
                    GetOwnerInfo(m_Case.Account.OwnerId);
                if (m_Case.Customer_Feedback_By__c == null)
                {
                    //
                    if (lisd.seller != null)
                        GetCustFeedbackByInfo(lisd.seller.id);
                    else
                        GetCustFeedbackByInfo(m_Case.Account.OwnerId);   
                } 
                //System.Debug('m_Case.OwnerId: ' + m_Case.OwnerId);

                
            }
        }
        catch (Exception ex)
        {
            LogException('GetAccountRelatedInfo', ex);
        } 
        return null;    
    }
    
    public PageReference GetTotalOppRevAnnual()
    {
        LogDebugMsg('Entered: GetTotalOppRevAnnual');
        
        try
        {
            
            LogDebugMsg('m_Case.Related_Opportunity__c: ' + m_Case.Related_Opportunity__c);
            LogDebugMsg('oppName: ' + oppName);         

            if (oppName != null && oppName != '' && m_Case.Related_Opportunity__c != null)
            {
                List<Opportunity> oppList = [select Id, Name, AccountId, Annual_Revenue__c, Amount, Aqualon_Amount__c, CurrencyIsoCode
                        from Opportunity
                        where Id = :m_Case.Related_Opportunity__c
                        LIMIT 1];     

                if (oppList.Size() > 0)
                {
                    for (Opportunity op : oppList)
                    {
                        opp = op;
                        TotalOpportunityRevenueAnnual = opp.Aqualon_Amount__c;
                        OppCurrency = opp.CurrencyIsoCode ;
                        
                    }
                }                       
                                                        
            }
            else
            {
                TotalOpportunityRevenueAnnual = null;
                m_Case.Related_Opportunity__c = null;
            }
            
            LogDebugMsg('TotalOpportunityRevenueAnnual: ' + TotalOpportunityRevenueAnnual);
            LogDebugMsg('m_Case.Related_Opportunity__c: ' + m_Case.Related_Opportunity__c);
            LogDebugMsg('oppName: ' + oppName);            


                
        }
        catch (Exception ex)
        {
            LogException('GetTotalOppRevAnnual', ex);
        } 
        
        LogDebugMsg('Exiting: GetTotalOppRevAnnual');
        
        return null;        
    }
    
    public PageReference OppNameOnChange()
    {
        LogDebugMsg('Entered: OppNameOnChange');
        
        try
        {

            LogDebugMsg('m_Case.Related_Opportunity__c: ' + m_Case.Related_Opportunity__c);
            LogDebugMsg('oppName: ' + oppName); 

            if (isNull(oppName))
            {
                TotalOpportunityRevenueAnnual = null;
                m_Case.Related_Opportunity__c = null;
                oppName = null;             
                                                      
            }
            else
            {
                GetTotalOppRevAnnual(); 
            }
            
            LogDebugMsg('m_Case.Related_Opportunity__c: ' + m_Case.Related_Opportunity__c);
            LogDebugMsg('oppName: ' + oppName); 

                
        }
        catch (Exception ex)
        {
            LogException('OppNameOnChange', ex);
        } 
        
        LogDebugMsg('Exiting: OppNameOnChange');
        
        return null;        
    }    
    
    public PageReference GetCYAmountAtRisk()
    {
        LogDebugMsg('Entered: GetCYAmountAtRisk');
        
        try
        {

            CYAmountAtRisk = 0 ;
            
            LogDebugMsg('GetCYAmountAtRisk m_Case.Risk_To_Plan__c: ' + m_Case.Risk_To_Plan__c);
            LogDebugMsg('riskName: ' + riskName);
            
            if (m_Case.Risk_To_Plan__c != null )
            {
                List<Risk__c> riskList = [select Id, Name, Account__c, Amount_at_Risk_CY__c, CurrencyIsoCode
                        from Risk__c
                        where Id = :m_Case.Risk_To_Plan__c
                        LIMIT 1];    
                        
                if (riskList.size() > 0)
                {   
                    for (Risk__c r : riskList)
                    {
                        risk = r;  
                        //m_Case.Current_Year_Budget_At_Risk__c = risk.Amount_at_Risk_CY__c;
                        CYAmountAtRisk = risk.Amount_at_Risk_CY__c;
                        RiskCurrency = risk.CurrencyIsoCode;
                    }
    
                }                           
                                                        
            }
            else
            {
                CYAmountAtRisk = null;
                m_Case.Risk_To_Plan__c = null;
                riskName = null;
            }
            
            LogDebugMsg('CYAmountAtRisk: ' + CYAmountAtRisk);
            LogDebugMsg('m_Case.Risk_To_Plan__c: ' + m_Case.Risk_To_Plan__c);
            LogDebugMsg('riskName: ' + riskName);

                
        }
        catch (Exception ex)
        {
            LogException('GetCYAmountAtRisk', ex);
        } 
        
        LogDebugMsg('Exiting: GetCYAmountAtRisk');
        
        return null;        
    }   
    
    public PageReference RickNameOnChange()
    {
        LogDebugMsg('Entered: RickNameOnChange');
        
        try
        {

            LogDebugMsg('m_Case.Risk_To_Plan__c: ' + m_Case.Risk_To_Plan__c);
            LogDebugMsg('riskName: ' + riskName);

            if (isNull(riskName))
            {
                CYAmountAtRisk = null;
                m_Case.Risk_To_Plan__c = null;
                riskName = null;                
                                                      
            }
            else
            {
                GetCYAmountAtRisk(); 
            }
            
            LogDebugMsg('m_Case.Risk_To_Plan__c: ' + m_Case.Risk_To_Plan__c);
            LogDebugMsg('riskName: ' + riskName);

                
        }
        catch (Exception ex)
        {
            LogException('RickNameOnChange', ex);
        } 
        
        LogDebugMsg('Exiting: RickNameOnChange');
        
        return null;        
    }      
    
    public PageReference ContactOnChangeEvent()
    {
        try
        {
/*
            m_Case.Customer_Contact_for_Feedback__c = m_Case.ContactId ;
                        
            System.Debug('m_Case.ContactId in ContactOnChangeEvent is ' + m_Case.ContactId);
            strErrMsg = '</br>' + 'm_Case.ContactId in ContactOnChangeEvent is ' + m_Case.ContactId;
                                        
            System.Debug('m_Case.Customer_Contact_for_Feedback__c in ContactOnChangeEvent is ' + m_Case.Customer_Contact_for_Feedback__c);
            strErrMsg = '</br>' + 'm_Case.Customer_Contact_for_Feedback__c in ContactOnChangeEvent is ' + m_Case.Customer_Contact_for_Feedback__c ;
*/
            if (contactName != null && contactName!= '')
            {

                if (this.m_Case.id == null) // new Case
                {
                    m_Case.Customer_Contact_for_Feedback__c = m_Case.ContactId ;
                }
                else
                {
    
                    if (m_Case.Customer_Contact_for_Feedback__c == null)
                    {
                        m_Case.Customer_Contact_for_Feedback__c = m_Case.ContactId ;                    
                    }
    
                }
            }
            else
            {
                m_Case.ContactId = null;
                if (this.m_Case.id == null) // new Case
                {
                    m_Case.Customer_Contact_for_Feedback__c = null ;
                }               
            }
    
        }
        catch (Exception ex)
        {
            LogException('ContactOnChangeEvent', ex);
        } 
        return null;        
    }   
    
    public PageReference InternalExternalField_OnChange()
    {
        try
        {
            //System.Debug('m_Case.Internal_External__c in InternalExternalField_OnChange is ' + m_Case.Internal_External__c);
            getCaseReasons(m_Case.Internal_External__c);
            getCaseOrigins(m_Case.Internal_External__c);            
        }
        catch (Exception ex)
        {
            LogException('InternalExternalField_OnChange', ex);
        } 
        return null;

    }
    
    public PageReference FeedbackCompletedOnChange()
    {
        try
        {
            
            if (m_Case.Feedback_Completed__c == true)
            {
                m_Case.Feedback_Completed_By__c = UserInfo.getUserId() ;
                if (m_Case.Feedback_Completed_Date__c == null)
                    m_Case.Feedback_Completed_Date__c = Date.today();
                    
                m_Case.Status = 'Customer Feedback Completed';
            }
            else
            {
                m_Case.Feedback_Completed_By__c = null;
                m_Case.Feedback_Completed_Date__c = null;
                if (m_Case.Lab_Work_Approved__c == true)
                {
                    m_Case.Status = 'Lab Work Approved';
                }
                else
                {
                    m_Case.Status = 'Lab Work Completed';
                }                
            }
        }
        catch (Exception ex)
        {
            LogException('FeedbackCompletedOnChange', ex);
        } 
        finally
        {
            
        }
        return null;        
        
    }
    
    public PageReference LabWorkApprovedOnChange()
    {
        
        LogDebugMsg('Entered LabWorkApprovedOnChange');
        if (m_Case.Lab_Work_Approved__c == true)
        {
            m_Case.Status = 'Lab Work Approved';
            m_Case.Customer_Feedback_Due_Date__c = date.today().addDays(40);
            if (lisd.seller.id == null)
            {
                LogDebugMsg('lisd.seller.id is null, using Customer Feedback By');
                GetOwnerInfo(m_Case.Customer_Feedback_By__c);
            }
            else
            {
                GetOwnerInfo(lisd.seller.id);
                
            }
            LogDebugMsg('m_Case.OwnerId: ' + m_Case.OwnerId);
            LogDebugMsg('Owner Name: ' + ownerName);            
        }
        else
        {
            m_Case.Status = 'Lab Work Completed';
            m_Case.Customer_Feedback_Due_Date__c = null;
        }
        LogDebugMsg('Leaving LabWorkApprovedOnChange');    
        
        
        return null;        
    }
    
    public PageReference LabWorkCompletedOnChange()
    {
        try
        {
            
            LogDebugMsg('Entered LabWorkCompletedOnChange');
            if (m_Case.Lab_Work_Completed__c == true)
            {
                m_Case.Lab_Work_Completed_By__c = UserInfo.getUserId() ;
                if (m_Case.Lab_Work_Completed_Date__c == null)
                    m_Case.Lab_Work_Completed_Date__c = Date.today();
                    
                m_Case.Status = 'Lab Work Completed';
                LogDebugMsg('m_Case.Technical_Lab_Group_Manager__c: ' + m_Case.Technical_Lab_Group_Manager__c);
                GetOwnerInfo(m_Case.Technical_Lab_Group_Manager__c);
                LogDebugMsg('m_Case.OwnerId: ' + m_Case.OwnerId);
                LogDebugMsg('Owner Name: ' + ownerName);
            }
            else
            {
                m_Case.Status = 'Approved - New TSR';
                m_Case.Lab_Work_Completed_By__c = null;
                m_Case.Lab_Work_Completed_Date__c = null;
                
            }
        }
        catch (Exception ex)
        {
            LogException('LabWorkCompletedOnChange', ex);
        }
        finally
        {
            
        } 
        
        LogDebugMsg('Leaving LabWorkCompletedOnChange');
        return null;        
        
    } 
    
    public PageReference CustFeedbackByOnChange()
    {
        try
        {
            System.Debug('CustFeedbackByOnChange - ' + custFeedbackByName);
            if (custFeedbackByName == null || custFeedbackByName == '')
            {
                m_Case.Customer_Feedback_By__c = null;
                    
            }

        }
        catch (Exception ex)
        {
            LogException('CustFeedbackByOnChange', ex);
        } 
        return null;        
        
    }     
      
    public PageReference CustContFeedbackOnChange()
    {
        try
        {
            System.Debug('CustContFeedbackOnChange - ' + custContFeedbackName);
            if (custContFeedbackName == null || custContFeedbackName == '')
            {
                m_Case.Customer_Contact_for_Feedback__c = null;
                    
            }

        }
        catch (Exception ex)
        {
            LogException('CustContFeedbackOnChange', ex);
        } 
        return null;        
        
    } 
    
    public void onAquariusClose() 
    {      
        //renderAquariusForm = !aquariusRequest.errorMessages.isEmpty();  
        if (aquariusRequest.errorMessages.isEmpty())
        {
            if (aquarius != null)
            {
                m_Case.Aquarius__c = aquariusRequest.isValid();
            }
            
            ShowForm('renderTSRForm');
            
        }
        else
        {
            ShowForm('renderAquariusForm');
            
        }
    }   
    
    public PageReference initAquarius() 
    {        

        if (isNull(m_Case.Objective__c) || isNull(m_Case.Describe_Work_Needed__c))
        {
            LogException('initAquarius', 'Please fill in the Objective and Describe Work Needed fields');
            
        }
        else
        {
            if (aquarius == null) 
            {            
                aquariusRequest = new Sample_Request_Aquarius();            
                aquarius = aquariusRequest.getAquariusRequest(m_Case);   
        
            }
            else
            {
                if (m_Case.Status == 'New')
                {
                    if (aquarius.Coating_Objective__c.trim() != m_Case.Objective__c.trim())
                        aquarius.Coating_Objective__c = m_Case.Objective__c.trim();
                    if (aquarius.Coating_Description__c.trim() != m_Case.Describe_Work_Needed__c.trim())    
                        aquarius.Coating_Description__c = m_Case.Describe_Work_Needed__c.trim();
                }               
            }        
    
            ShowForm('renderAquariusForm');
        }
         
        return null;    
        
    }   
    

    
    public void enableDisableItemsBasedOnTsrStatus()
    {
        // hide tech ser info section as of 2/21
        renderTechServInfoSection = false;
        
        if (m_Case.Status != null 
            && (m_Case.Status.contains('Approved') ||
                m_Case.Status == 'Lab Work Completed' ||
                m_Case.Status == 'Lab Work Approved' ||
                m_Case.Status == 'Customer Feedback Completed')
            )
        {
            renderLabResultsSection = true;
            renderCustomerFeedbackSection = true;  
            renderSaveAndSubmitButton = false;
            
        }
        else
        {
            renderLabResultsSection = false;
            renderCustomerFeedbackSection = false; 
            renderSaveAndSubmitButton = true;         

        }
        
    }
    
    public boolean FeedbackTaskCreated()
    {
        boolean returnValue = false;
        
        if (m_Case.Id != null)
        {
            List<Task> caseTasks = [select Id
                            from Task 
                            where WhatId =:m_Case.Id
                            limit 1];
                            
            if (!caseTasks.isEmpty())
                returnValue = true;
                        
        }
        
        return returnValue;
    }

// *** Start: Used by the Opp search form ***   
    public PageReference searchOpps() {

        ShowForm('renderOppsForm'); 
        renderMaxMsg1 = false;
        opportunities = new List<Opportunity>();
                    
        try {       
            System.Debug('searchOpps: m_Case.AccountId = ' + m_Case.AccountId);
            if (m_Case.AccountId == null) 
            {
                String errMsg = 'Missing Account information. Please contact system Administrator';
                CustomException.throwException(errMsg); 
                return null;        
            }
            String accId = m_Case.AccountId;

            String q = 'SELECT id, Name, RecordType.Name, Description, StageName, CloseDate ';
            q += 'FROM Opportunity WHERE AccountId = :accId AND IsClosed = false ';
            if (!isNull(oppName)) {q += ' and Name like \'%' + oppName + '%\'';}
            q += ' order by Name';
            q += ' limit ' + String.valueOf(maxCount1 + 1); 

            System.Debug('searchOpps: q = ' + q) ;
            opportunities = Database.query(q);
            renderOppsList = (opportunities != null && !opportunities.isEmpty());
            renderMaxMsg1 = renderOppsList && opportunities.size() > maxCount1;
            
            
        }
        catch(Exception ex)
        {
            LogException('searchOpps', ex);
        }       
        return null;
    }
    
    public PageReference cancelSearchOpps() {  
        LogDebugMsg('Entered: cancelSearchOpps');
        LogDebugMsg('m_Case.Related_Opportunity__c: ' + m_Case.Related_Opportunity__c);
        LogDebugMsg('oppIdFromOppSearch: ' + oppIdFromOppSearch);
        GetTotalOppRevAnnual();
        ShowForm('renderTSRForm');
        LogDebugMsg('Exiting: cancelSearchOpps');
        return null;
    }       

    public List<Opportunity> getOpportunities() {
        if ( opportunities == null ) {
          try {
          opportunities = [SELECT id,
                                  Name,
                                  RecordType.Name,
                                  Description,
                                  StageName,
                                  CloseDate
                             FROM Opportunity 
            WHERE AccountId = : m_Case.AccountId ]; }
           catch (Exception e) {}
              
          }
        return opportunities;
    }   
    
// *** End: Used by the Opp search form *** 
    
    
// *** Start: Used by the Risk search form ***  
    public PageReference searchRisks() {

        ShowForm('renderRiskForm'); 
        renderMaxMsg1 = false;
        risks = new List<Risk__c>();
                    
        try {       
            LogDebugMsg('searchRisks: m_Case.AccountId = ' + m_Case.AccountId);
            if (m_Case.AccountId == null) 
            {
                String errMsg = 'Missing Account information. Please contact system Administrator';
                CustomException.throwException(errMsg); 
                return null;        
            }
            String accId = m_Case.AccountId;

            String q = 'SELECT id, Name, Revenue_At_Risk__c, Reason__c, Stage__c, CurrencyIsoCode, ' + 
                    'Amount_at_Risk_CY__c, Weighted_Amount_at_Risk_CY__c, ' + 
                    'Probability_of_Risk_CY__c, Weighted_Amount_at_Risk_NY__c, Probability_of_Risk_NY__c ';
            q += 'FROM Risk__c WHERE Account__c = :accId ';
            if (!isNull(riskName)) {q += ' and Name like \'%' + riskName + '%\'';}
            q += ' order by Name';
            q += ' limit ' + String.valueOf(maxCount1 + 1); 

            LogDebugMsg('searchRisks: q = ' + q) ;
            risks = Database.query(q);
            renderRisksList = (risks != null && !risks.isEmpty());
            renderMaxMsg1 = renderRisksList && risks.size() > maxCount1;
            
            
        }
        catch(Exception ex)
        {
            LogException('searchRisks', ex);
        }
               
        return null;
    }
    
    public PageReference cancelSearchRisks() {  
        GetCYAmountAtRisk();
        ShowForm('renderTSRForm');
        return null;
    }       

      
    public List<Risk__c> getRisks() {
        if ( risks == null ) {
          try {
          risks = [SELECT id, Name, Revenue_At_Risk__c, Reason__c, Stage__c, CurrencyIsoCode,
                    Amount_at_Risk_CY__c, Amount_at_Risk_NY__c, Weighted_Amount_at_Risk_CY__c,
                    Probability_of_Risk_CY__c, Weighted_Amount_at_Risk_NY__c, Probability_of_Risk_NY__c
                    FROM Risk__c 
            WHERE Account__c = : m_Case.AccountId]; }
           catch (Exception e) {}
              
          }
        return risks;
    }   
          
    
// *** End: Used by the Risk search form ***        
    
    
// *** Start: Used by the Contact search form ***   
    public PageReference searchContacts() {

        ShowForm('renderContactForm'); 
        renderMaxMsg1 = false;
        contacts = new List<Contact>();
                    
        try {       
            System.Debug('searchContacts: m_Case.AccountId = ' + m_Case.AccountId);
            if (m_Case.AccountId == null) 
            {
                String errMsg = 'Missing Account information. Please contact system Administrator';
                CustomException.throwException(errMsg); 
                return null;        
            }
            String accId = m_Case.AccountId;

            String q = 'SELECT id, Name, Email, Phone, MailingCity, MailingCountry, RecordType.Name ';
            q += 'FROM Contact WHERE WV_Contact_Status__c = \'Active\' and AccountId  = :accId ';
            if (!isNull(contactName)) {q += ' and Name like \'%' + contactName + '%\'';}
            q += ' order by Name';
            q += ' limit ' + String.valueOf(maxCount1 + 1); 

            System.Debug('searchContacts: q = ' + q) ;
            contacts = Database.query(q);
            renderContactsList = (contacts != null && !contacts.isEmpty());
            renderMaxMsg1 = rendercontactsList && contacts.size() > maxCount1;
            
            
        }
        catch(Exception ex)
        {
            LogException('searchContacts', ex);
        }       
        return null;
    }
    
    public PageReference cancelSearchContacts() {  
        ShowForm('renderTSRForm');
        return null;
    }       

    public List<Contact> getContacts() {
        if (renderContactForm != null && renderContactForm)
        {
            if ( contacts == null ) {
              try {
              contacts = [SELECT id, Name, Email, Phone, MailingCity, MailingCountry, RecordType.Name
                            FROM Contact 
                            WHERE WV_Contact_Status__c = 'Active' and AccountId = : m_Case.AccountId]; }
               catch (Exception e) {}
                  
              }
    
            return contacts;
        }
        else
            return new List<Contact>();

    }   
    
// *** End: Used by the Contact search form *** 

// *** Start: Used by the Owner search form *** 
    public PageReference searchOwners() {

        ShowForm('renderOwnerForm');
        renderMaxMsg1 = false;
        owners = new List<User>();
                    
        try { 
            
            /*      
            System.Debug('searchOwners: m_Case.AccountId = ' + m_Case.AccountId);
            if (m_Case.AccountId == null) 
            {
                String errMsg = 'Missing Account information. Please contact system Administrator';
                CustomException.throwException(errMsg); 
                return null;        
            }
            String accId = m_Case.AccountId;
            */
            
            String q = 'Select Title, Phone, IsActive, Full_Name__c, Email, Department, Country, City, Ashland_Employee_Number__c ';
            q += 'From User ';
            q += 'Where isActive = true';
            if (!isNull(ownerName)) {q += ' and Full_Name__c like \'%' + ownerName + '%\'';}
            q += ' order by Full_Name__c';
            q += ' limit ' + String.valueOf(maxCount1 + 1); 

            System.Debug('searchOwners: q = ' + q) ;
            owners = Database.query(q);
            renderOwnersList = (owners != null && !owners.isEmpty());
            renderMaxMsg1 = renderownersList && owners.size() > maxCount1;
            
            
        }
        catch(Exception ex)
        {
            LogException('searchOwners', ex);
        }       
        return null;
    }
    
    public PageReference cancelSearchOwners() {
        if (m_Case.OwnerId != null)
        {
            // NOTE: the following line on the page was dropping everything after a comma so do this as a work around
            // for. e.g. Martin, Edward as showing up as Martin
            // <apex:param assignTo="{!ownerName}" name="p1" value="{!o.Full_Name__c}"/>
            //System.Debug('cancelSearchOwners: m_Case.OwnerId = ' + m_Case.OwnerId);
            //System.Debug('cancelSearchOwners: ownerName = ' + ownerName);
            GetOwnerInfo(m_Case.OwnerId);
            //System.Debug('cancelSearchOwners: ownerName = ' + ownerName);
        }  
        ShowForm('renderTSRForm');
        return null;
    }       

    public List<User> getOwners() {
        if (renderOwnerForm != null && renderOwnerForm)
        {
            if ( owners == null ) {
              try {
              owners = [Select Title, Phone, IsActive, Full_Name__c, Email, Department, Country, City, Ashland_Employee_Number__c  
                        From User
                        Where isActive = true and id = : m_Case.OwnerId]; }
               catch (Exception e) {}
                  
              }
            return owners;
        }
        else
            return new List<User>();
        
    }
    
    public String getUserById(String userId) {
        string returnValue = ''; List<User> users = new List<User>();
        if (!isnull(userId))
        {
            try {
                users = [Select Title, Phone, IsActive, Full_Name__c, Email, Department, Country, City, Ashland_Employee_Number__c  
                    From User
                    Where isActive = true and id = : userId LIMIT 1]; 
                    
                if (users.size() > 0)
                {
                    for (User u : users)
                    {
                        returnValue = u.Full_Name__c;
                        break;
                    }
                }    
                    
            }
            catch (Exception e) {}
            
        }
        
        return returnValue;
    }
           
    
// *** End: Used by the Owner search form ***


// *** Start: Used by the Customer_Feedback_By__c search form *** 
    public PageReference searchCustFeedbackBy() {

        ShowForm('renderCustFeedbackByForm'); 
        renderMaxMsg1 = false;
        custFeedbackByList = new List<User>();
                    
        try { 
            
            String q = 'Select Title, Phone, IsActive, Full_Name__c, Email, Department, Country, City, Ashland_Employee_Number__c ';
            q += 'From User ';
            q += 'Where isActive = true';
            if (!isNull(ownerName)) {q += ' and Full_Name__c like \'%' + ownerName + '%\'';}
            q += ' order by Full_Name__c';
            q += ' limit ' + String.valueOf(maxCount1 + 1); 

            System.Debug('searchCustFeedbackBy: q = ' + q) ;
            custFeedbackByList = Database.query(q);
            rendercustFeedbackByList = (custFeedbackByList != null && !custFeedbackByList.isEmpty());
            renderMaxMsg1 = rendercustFeedbackByList && custFeedbackByList.size() > maxCount1;
            
            
        }
        catch(Exception ex)
        {
            LogException('searchCustFeedbackBy', ex);
        }       
        return null;
    }
    
    public PageReference cancelSearchCustFeedbackBy() {
        FocusField = 'CustomerFeedbackByFieldId';
        if (m_Case.Customer_Feedback_By__c != null)
        {
            // NOTE: the following line on the page was dropping everything after a comma so do this as a work around
            // for. e.g. Martin, Edward as showing up as Martin
            // <apex:param assignTo="{!ownerName}" name="p1" value="{!o.Full_Name__c}"/>
            //System.Debug('cancelSearchOwners: m_Case.OwnerId = ' + m_Case.OwnerId);
            //System.Debug('cancelSearchOwners: ownerName = ' + ownerName);
            GetCustFeedbackByInfo(m_Case.Customer_Feedback_By__c);
            //System.Debug('cancelSearchOwners: ownerName = ' + ownerName);
        } 
        ShowForm('renderTSRForm');
        return null;
    }       

    public List<User> getCustFeedbackBy() {
        
        if (renderCustFeedbackByForm != null && renderCustFeedbackByForm)
        {

            if ( custFeedbackByList == null ) {
              try {
              custFeedbackByList = [Select Title, Phone, IsActive, Full_Name__c, Email, Department, Country, City, Ashland_Employee_Number__c  
                        From User
                        Where isActive = true and id = : m_Case.Customer_Feedback_By__c]; }
               catch (Exception e) {}
                  
              }
    
            return custFeedbackByList;
        }
        else
            return new List<User>();

    }   
    
// *** End: Used by the Customer_Feedback_By__c search form ***

// *** Start: Used by the Customer_Contact_for_Feedback__c search form ***   
    public PageReference searchCustContFeedback() {

        ShowForm('renderCustContFeedbackForm'); 
        renderMaxMsg1 = false;
        custContFeedbackList = new List<Contact>();
                    
        try {       
            System.Debug('searchCustContFeedback: m_Case.AccountId = ' + m_Case.AccountId);
            if (m_Case.AccountId == null) 
            {
                String errMsg = 'Missing Account information. Please contact system Administrator';
                CustomException.throwException(errMsg); 
                return null;        
            }
            String accId = m_Case.AccountId;

            String q = 'SELECT id, Name, Email, Phone, MailingCity, MailingCountry, RecordType.Name ';
            q += 'FROM Contact WHERE WV_Contact_Status__c = \'Active\' and AccountId  = :accId ';
            if (!isNull(custContFeedbackName)) {q += ' and Name like \'%' + custContFeedbackName + '%\'';}
            q += ' order by Name';
            q += ' limit ' + String.valueOf(maxCount1 + 1); 

            System.Debug('searchCustContFeedback: q = ' + q) ;
            custContFeedbackList = Database.query(q);
            renderCustContFeedbackList = (custContFeedbackList != null && !custContFeedbackList.isEmpty());
            renderMaxMsg1 = renderCustContFeedbackList && custContFeedbackList.size() > maxCount1;
            
            
        }
        catch(Exception ex)
        {
            LogException('searchCustContFeedback', ex);
        }       
        return null;
    }
    
    public PageReference cancelSearchCustContFeedback() {
        FocusField = 'CustContactForFeedbackFieldId';
        if (m_Case.Customer_Contact_for_Feedback__c != null)
        {
            GetCustContFeedbackInfo(m_Case.Customer_Contact_for_Feedback__c);
        }       
        ShowForm('renderTSRForm');
        return null;
    }       

    public List<Contact> getCustContFeedback() {
        
        if (renderCustContFeedbackForm != null && renderCustContFeedbackForm)
        {
            if ( custContFeedbackList == null ) {
              try {
              custContFeedbackList = [SELECT id, Name, Email, Phone, MailingCity, MailingCountry, RecordType.Name
                            FROM Contact 
                            WHERE WV_Contact_Status__c = 'Active' and AccountId = : m_Case.AccountId]; }
               catch (Exception e) {}
                  
              }
            
              
            return custContFeedbackList;
        }
        else
            return new List<Contact>();

    }   
    
// *** End: Used by the Contact search form *** 

    public void initAction1() {
        LogDebugMsg('Entered: initAction1');
        
        try
        {
            LogDebugMsg('strAccidParam = ' + strAccidParam);
            LogDebugMsg('m_Case.AccountId = ' + m_Case.AccountId);
            
            if (isNull(strAccidParam) && m_Case.AccountId != null)
                strAccidParam = m_Case.AccountId;
        
            if (lisd == null) {
                lisd = new SAP_LISD();
                if (!isNull(strAccidParam)) {lisd.setIndustries(strAccidParam);}
                else {lisd.readOnlyAC = false;}
            }
            
            LogDebugMsg('lisd = ' + lisd);
            LogDebugMsg('m_Case.id = ' + m_Case.id);
                        
            if (m_Case.id == null) 
            {
                if (!isNull(strAccidParam))
                {
                    GetAccountInfo(strAccidParam);
                    if(!activeAccount)
                    {
                        ShowForm('renderConfirmDialogComp');
                        return; 
                    }
                
                }           
                
                onLisdComplete();
            } 
            else if (m_Case.id != null && m_Case.Seller__c == null)
            {
                if (!isNull(strAccidParam)) 
                {
                    lisd.setIndustries(strAccidParam);
                    onLisdComplete();
                }
            }         
            else {
                renderPage2 = true;
                renderLisd = false;
                if (m_Case.AccountId != null)       // this is to handle the old data that will not have an account
                    lisd.copyDataFrom(m_Case);
                ShowForm('renderTSRForm');
                OnFormLoaded();
                    
            }           
                        
            LogDebugMsg('Exiting: initAction1');
        
            
        }
        catch(Exception ex)
        {
            LogException('initAction1', ex);
        }  
                
    } 
    
    public void onLisdComplete() 
    {
        LogDebugMsg('Entered: onLisdComplete');
        LogDebugMsg('m_Case.AccountId: ' + m_Case.AccountId);

        renderGoto2 = (lisd != null && !lisd.readOnlyInputs && 
                       lisd.seller != null && lisd.seller.Id != null);      

        LogDebugMsg('renderPage2: ' + renderPage2);

        if (lisd != null && lisd.readOnlyInputs) {gotoPage2();}

        LogDebugMsg('Exiting: onLisdComplete');
    }    
    
    public void gotoPage2() {
        LogDebugMsg('Entered: gotoPage2');
        
        renderGoto2 = false; renderLisd = false;
        renderPage2 = true; 
        renderGoto1 = ( lisd != null && !lisd.readOnlyInputs);

        if (renderPage2)
        { 
            //GetAccountInfo(lisd.acc.Id);
            
            lisd.copyDataTo(m_Case);
            
            //if (activeAccount)
            //{                     
                ShowForm('renderTSRForm');
                OnFormLoaded();
                GetOwnerInfo(lisd.seller.Id);
            //}
            //else
            //{
                //ShowForm('renderConfirmDialogComp');
            //}         
        }
        LogDebugMsg('Exiting: gotoPage2');
    }   

    public void SetTechLabGrpMgr()
    {
        
        try
        {
            LogDebugMsg('Entered: SetTechLabGrpMgr');

            List<TechLabGroup_Configuration__c> techLabGrpConfigList = [
                SELECT id, Technical_Lab_Group__c, Lab_Group_Manager__c, Customer_Group__c
                FROM TechLabGroup_Configuration__c 
                WHERE Customer_Group__c =:m_Case.Customer_Group__c
                    AND Technical_Lab_Group__c =:TechnicalLabGroup];
            
            LogDebugMsg('techLabGrpConfigList: ' + techLabGrpConfigList.size());
            
            if (techLabGrpConfigList.size() > 0)
            {    
                for (TechLabGroup_Configuration__c techLabGrpConfig : techLabGrpConfigList )
                {
                    m_Case.Technical_Lab_Group_Manager__c = techLabGrpConfig.Lab_Group_Manager__c;
                    m_Case.DevEx_Project_Manager__c = getUserById(techLabGrpConfig.Lab_Group_Manager__c);
                    break;      
                }  
            }
  
        }   
        catch (Exception ex)
        {
            LogException('SetTechLabGrpMgr', ex);
        }  
            
        LogDebugMsg('Exiting: SetTechLabGrpMgr');      
        
    }     
   
    private Boolean customSave()
    {
        Boolean returnValue = False;
        
        LogDebugMsg('*** Entered customSave ***');
        
        try
        {
            if (RequiredFieldCheckOnSave() == true) 
            {           
            
                LogDebugMsg('customSave: About to call GetTotalOppRevAnnual');
                GetTotalOppRevAnnual();
                
                LogDebugMsg('customSave: About to call GetCYAmountAtRisk');
                GetCYAmountAtRisk();
                
                if (m_Case.Status == 'New')
                {
                    LogDebugMsg('customSave: About to call SetTechLabMgr');
                    SetTechLabGrpMgr();    
                }            

                if (m_Case.Lab_Work_Approved__c && m_Case.Customer_Feedback_Due_Date__c == null )
                {
                    m_Case.Customer_Feedback_Due_Date__c = date.today().addDays(40);
                }
                
                    
                //NOTE: using Database.upsert to customized the errors displayed
                
                LogDebugMsg('customSave: Customer_Feedback_By__c: ' + m_Case.Customer_Feedback_By__c);
                
                LogDebugMsg('customSave: About to call Database.upsert(this.m_Case)');
                Database.UpsertResult result = Database.upsert(this.m_Case);
                
                LogDebugMsg('customSave: Database Upsert Result: ' + result);
                if (result != null)
                {
                    LogDebugMsg('customSave: result.isSuccess(): ' + result.isSuccess());
                    if (result.isSuccess())
                    {
                        LogDebugMsg('customSave: result.isCreated(): ' + result.isCreated());
                        isCaseCreated = result.isCreated();
                        
                        LogDebugMsg('customSave: m_Case.Aquarius__c: ' + m_Case.Aquarius__c);
                        LogDebugMsg('customSave: aquarius: ' + aquarius);
                        
                        if (aquarius != null && m_Case.Aquarius__c) 
                        {   
                            LogDebugMsg('customSave: aquarius.Case__c: ' + aquarius.Case__c);
                            LogDebugMsg('customSave: m_Case.Id: ' + m_Case.Id);    
                                                
                            if (aquarius.Case__c == null)     
                                aquarius.Case__c = m_Case.Id;  
                                
                            // C2 - when TSR is editable (new status), make sure the Objective and 
                            // Describe work needed stays in sync with Aquarius fields
                            LogDebugMsg('customSave: m_Case.Status: ' + m_Case.Status);
                            if (m_Case.Status == 'New')
                            {
                                if (aquarius.Coating_Objective__c.trim() != m_Case.Objective__c.trim())
                                    aquarius.Coating_Objective__c = m_Case.Objective__c.trim();
                                if (aquarius.Coating_Description__c.trim() != m_Case.Describe_Work_Needed__c.trim())    
                                    aquarius.Coating_Description__c = m_Case.Describe_Work_Needed__c.trim();
                            }
                            
                            LogDebugMsg('About to upsert aquarius...');
                            Database.UpsertResult aquariusUpsertResult = Database.upsert(aquarius); 
                            
                            LogDebugMsg('customSave: aquariusUpsertResult: ' + aquariusUpsertResult);
                            if (aquariusUpsertResult != null)
                            {
                                if (!aquariusUpsertResult.isSuccess())
                                {
                                    if (aquariusUpsertResult.getErrors() != null)
                                    {
                                        String strErrString = '';
                                        List<Database.Error> errList = aquariusUpsertResult.getErrors();
                                        for (Database.Error err:errList)
                                        {
                                            strErrString = 
                                            'Status Code: ' + err.getStatusCode() + '</BR>' +
                                            'Message: ' + err.getMessage() + '</BR>' ;
                                        }
                                        if (strErrString != '')
                                        {
                                            LogException('customSave', 'Error in method customSave, saving Aquarius TSR: </BR>' +
                                            strErrString + '</BR>'); 
                                            System.debug('Error in method customSave, saving Aquarius TSR: ' + strErrString);
                                        }                                   
                                    }
                                    else
                                    {
                                        LogDebugMsg('Error in method customSave, saving TSR: Aquarius Upsert Result getErrors() is null');
                                        LogException('customSave', 'Error in method customSave, saving TSR: </BR>' +
                                            'Aquarius Upsert Result getErrors() is null' + '</BR>'); 
                                    }                               
                                                                    
                                }
                                else
                                    returnValue = True;                         
                                
                            } 
                            else
                            {
                                LogDebugMsg('Error in method customSave, saving TSR: Aquarius Upsert Result is null');
                                LogException('customSave', 'Error in method customSave, saving TSR: </BR>' +
                                    'Aquarius Upsert Result is null' + '</BR>');    
                            }                     
                        }
                        else
                            returnValue = True;                     
                    }
                    else
                    {
                        if (result.getErrors() != null)
                        {
                            String strErrString = '';
                            List<Database.Error> errList = result.getErrors();
                            for (Database.Error err:errList)
                            {
                                strErrString = 
                                'Status Code: ' + err.getStatusCode() + '</BR>' +
                                'Message: ' + err.getMessage() + '</BR>' ;
                            }
                            if (strErrString != '')
                            {
                                LogDebugMsg('Error in method customSave, saving TSR: ' + strErrString);
                                LogException('customSave', 'Error in method customSave, saving TSR: </BR>' +
                                strErrString + '</BR>'); 
                                
                            } 
    
                        } 
                        else
                        {
                            LogDebugMsg('Error in method customSave, saving TSR: Upsert Result getErrors() is null');
                            LogException('customSave', 'Error in method customSave, saving TSR: </BR>' +
                                'Upsert Result getErrors() is null' + '</BR>'); 
                            
                            
                        }
                    }
                } 
                else
                {
                    LogDebugMsg('Error in method customSave, saving TSR: Upsert Result is null');
                    LogException('customSave', 'Error in method customSave, saving TSR: </BR>' +
                        'Upsert Result is null' + '</BR>'); 
                                
                }
            }
            else
                return false;

            
        }
        catch(System.DmlException dex)
        {
            LogDebugMsg('Error in method customSave, System.DmlException: ' + dex.getDmlMessage(0));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, dex.getDmlMessage(0)));
        }
        catch (Exception ex)
        {
            LogDebugMsg('Error in method customSave, Exception: ' + ex.getMessage());
            if (ex.getTypeName() == 'CustomException')
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            }                   
            else            
                LogException('customSave', ex);             
        }        
        
        LogDebugMsg('customSave returnValue: ' + returnValue);
        
        LogDebugMsg('*** Exiting customSave ***');
        
        return returnValue;
    
    }   
    
    
    
    
    
    private void GetQueryStringParams()
    {
        strRecordTypeParam = ApexPages.currentPage().getParameters().get('RecordType');
        strRetURLParam = ApexPages.currentPage().getParameters().get('retURL');
        strCancelURLParam = ApexPages.currentPage().getParameters().get('cancelURL');
        if (strCancelURLParam == null)
            strCancelURLParam = '/006/o';
        strAccidParam = ApexPages.currentPage().getParameters().get('def_account_id');
        strOppIdParam = ApexPages.currentPage().getParameters().get('def_opportunity_id');
        strConIdParam = ApexPages.currentPage().getParameters().get('def_contact_id');
        if (ApexPages.currentPage().getParameters().get('debug') != null)
            renderDebugPanel = true;        
   
    }

    public void GetOpportunityInfo(string strOppIdParam)
    {
        try
        {
            //System.Debug('Inside GetOpportunityInfo param strOppIdParam = ' + strOppIdParam);
            opp = [select Id, Name, AccountId, Annual_Revenue__c, Amount, Aqualon_Amount__c, CurrencyIsoCode
                    from Opportunity
                    where Id = :strOppIdParam];
                    
            if (opp != null)
            {
                m_Case.Related_Opportunity__c = opp.id;
                TotalOpportunityRevenueAnnual = opp.Aqualon_Amount__c;
                OppCurrency = opp.CurrencyIsoCode ;
            }
                    
        }
        catch (Exception ex)
        {
            LogException('GetOpportunityInfo', ex);
        
        }       
        
    }

    public void setPacIndustry() {
      lisd.setPacIndustry(m_Case.PAC_Industry_Code__c);
      m_Case.PAC_Description__c = lisd.getPacIndustryLabel();
    }


    private void GetCaseInfo(string strCaseId)
    {
        
        try
        {
            this.m_Case = [select Id, Internal_External__c, AccountId, CaseNumber, Region__c,
                Subject, ContactId, Business_Segment__c, Reason, Is_Request_Confidential__c, 
                Business_Unit__c, Origin, OwnerId, PAC_Description__c, Status, Problem_Cause__c,
                SBU__c, Related_Opportunity__c, Risk_To_Plan__c, T_RequestedCompletionDate__c,
                // Current_Year_Budget_At_Risk__c, 
                Requested_Completion_Date_Explanation__c, Material__c, Priority, 
                Required_Technical_Output__c, Sample_Submitted__c, T_Date_Sample_Shipped__c, 
                Background__c, Describe_Work_Needed__c, Competitive_Products__c, Issues__c,
                Description, What_type_of_sample_being_sent__c, Project_Duration__c, Estimated_Start_Date__c,
                T_Estimated_Complete_Date__c, T_Date_Sample_Received__c, Lab_Work_Completed__c, 
                Lab_Work_Completed_By__c, Lab_Work_Completed_Date__c, Technical_Achievement__c,
                Technical_Risk_Assessment__c, Technical_Approval_Priority__c, Technical_Lab_Group__c,
                Lab_Tech_Assigned__c, DevEx_Project_Manager__c, Objective__c, W_Results__c, 
                Case_Time_In_Progress__c, Case_Time_Pending__c, Total_Case_Time__c, Total_Task_Hours__c,
                Total_Case_Hours__c, Customer_Feedback_Due_Date__c, Customer_Contact_for_Feedback__c,
                Feedback_Completed__c, Feedback_Completed_Date__c, Customer_Feedback_By__c, Feedback_Completed_By__c,
                Customer_Conclusion_of_Results__c, Customer_Feedback__c, Lab_Work_Approved__c,
                Feedback_Results_and_Recommendations__c, Aquarius__c, Feedback_Task_Created__c,
                DevEx_Transfer_Status__c, Customer_Group__c, Customer_Group_Desc__c, Sales_District__c,
                Sales_District_Desc__c, Sales_Office__c, Sales_Office_Desc__c, Sales_Group__c,
                Sales_Group_Desc__c, EndUse_Customer__c, EndUse_Customer_Desc__c,
                Industry__c, Technical_Lab_Group_Manager__c, Seller__c
                from Case
                where Id = :strCaseId];

        
        }
        catch (Exception ex)
        {
            LogException('GetCaseInfo', ex);
        
        }
    }
            
    private void GetAccountInfo(string strAccountId)
    {
        try
        {
            //System.Debug('Inside GetAccountInfo param strAccountId = ' + strAccountId);
            acc = [select Id, Name, Customer_Classification_ABC__c, SAP_Sales_Office__c, 
                SAP_DistChannel__c, SAP_Sales_Org__c, OwnerId, Inactive_Account__c
                from Account
                where Id = :strAccountId];
                
            if (acc != null && acc.Inactive_Account__c != null && acc.Inactive_Account__c) {
                activeAccount = false;
                this.m_Case.AccountId = acc.Id;
                this.m_Case.Account = acc;              
                initConfirmDialog();
            }
            else
            {                
                activeAccount = true;
                this.m_Case.AccountId = acc.Id;
                this.m_Case.Account = acc;
                
                if (this.m_Case.OwnerId == null)
                    GetOwnerInfo(acc.OwnerId);
    
                if (m_Case.Customer_Feedback_By__c == null && m_Case.Id == null)
                    GetCustFeedbackByInfo(acc.OwnerId);
                    
                // with CPI, account link should be read-only,
                // if incorrect account is selected, user will need to start over
                AccountIdFieldEditable = false;                 
                
            }
                
            //GetAccountRelatedInfo();
        
        }
        catch (Exception ex)
        {
            if (strAccountId == '' || strAccountId == '000000000000000' && 
                ex.getMessage() == 'List has no rows for assignment to SObject')
            {
                disableSave = true;
                LogException('GetAccountInfo', 'Contact does not have an Account associated. Please contact system administrator');
            }
            else
                LogException('GetAccountInfo', ex);
        
        }
    }
    
    public ConfirmDialogParam cdp {get; private set;}

    public Boolean renderConfirmDialogComp {get; private set;}

    public void onConfirmComplete() {
        renderConfirmDialogComp = cdp.renderComp;
        LogDebugMsg('onConfirmComplete: renderConfirmDialogComp = ' + renderConfirmDialogComp);
        if (!renderConfirmDialogComp)
        {
            onLisdComplete();
            //ShowForm('renderTSRForm');
            //OnFormLoaded();
        }        
    }
    
    private void initConfirmDialog() {
        cdp = new ConfirmDialogParam();
        cdp.cancelUrl = strRetURLParam;
        cdp.warnMsg1 = 'Account is marked for deletion. Continue creating TSR?';
        renderConfirmDialogComp = cdp.renderComp;
    }    
    
    private void GetContactInfo(string strContactId)
    {
        String errMsg = '';
        try
        {
            List<Contact> conts = [select Id, AccountId, Name
            from Contact
            where Id = :strContactId 
            LIMIT 1];

            if (conts.Size() > 0)
            {
                for(Contact c : conts)
                {
                    this.cont = c;
                    m_Case.ContactId = c.Id;
                    contactName = c.Name;
                }
                
                if (cont.AccountId == null)
                {
                    disableSave = true;
                    AccountIdFieldEditable = false;
                    errMsg = 'The selected contact is missing Account information. Please contact system Administrator';
                    CustomException.throwException(errMsg);             
                }
                
                if (acc == null)
                    GetAccountInfo(cont.AccountId);
            }
        
        }
        catch (Exception ex)
        {
            if (ex.getTypeName() == 'CustomException')
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            }
            else
                LogException('GetContactInfo', ex);
        
        }
    }
    
    private void GetOwnerInfo(string strOwnerId)
    {
        try
        {
            //System.Debug('Inside GetOwnerInfo param strOwnerId = ' + strOwnerId);
          List<User> owners = [Select Title, Phone, IsActive, Full_Name__c, Email, Department, Country, City, Ashland_Employee_Number__c  
                    From User
                    Where isActive = true and
                    Id =:strOwnerId
                    Limit 1];
                    
            for(User owner : owners)
            {
                m_Case.OwnerId = owner.Id;
                ownerName = owner.Full_Name__c;
            }
                    
        }
        catch (Exception ex)
        {
            LogException('GetOwnerInfo', ex);
        
        }       
        
    }    
    
    private void GetCustFeedbackByInfo(string strOwnerId)
    {
        try
        {
            //System.Debug('Inside GetCustFeedbackByInfo param strOwnerId = ' + strOwnerId);
          List<User> custFeedbackByList = [Select Title, Phone, IsActive, Full_Name__c, Email, Department, Country, City, Ashland_Employee_Number__c  
                    From User
                    Where isActive = true and
                    Id =:strOwnerId
                    Limit 1];
                    
            for (User custFeedbackBy : custFeedbackByList)
            {
                m_Case.Customer_Feedback_By__c = custFeedbackBy.id;
                custFeedbackByName = custFeedbackBy.Full_Name__c;
            }
                    
        }
        catch (Exception ex)
        {
            LogException('GetCustFeedbackByInfo', ex);
        
        }       
        
    }
    
    private void GetCustContFeedbackInfo(string strContactId)
    {
        try
        {
            //System.Debug('Inside GetCustContFeedbackInfo param strContactId = ' + strContactId);
          List<Contact> custContFeedbackList = [SELECT id, Name, Email, Phone, MailingCity, MailingCountry, RecordType.Name
                        FROM Contact 
                        WHERE id =:strContactId];
                    
            for (Contact custContFeedback : custContFeedbackList )
            {
                m_Case.Customer_Contact_for_Feedback__c = custContFeedback.id;
                custContFeedbackName = custContFeedback.Name;
            }
                    
        }
        catch (Exception ex)
        {
            LogException('GetCustContFeedbackInfo', ex);
        
        }       
        
    }         
    
    private void LogException(string methodName, Exception ex)
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
        'Error in method ' + methodName + ': ' + ex.getMessage() + '</br>' +
        'Error Line: ' + ex.getLineNumber() + '</br>' +
        'Error Type: ' + ex.getTypeName()
        )); 
        
        System.debug(methodName + ex);
        LogDebugMsg(methodName + ex); 
    }
    
    private void LogException(string methodName, string strErrMsg)
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strErrMsg)); 
        
        System.debug(methodName + strErrMsg); 
    } 
        
    private void SetRecordTypeIdAndName() {
        RecordTypeName = ''; 
        RecordTypeId = this.m_Case.RecordTypeId;
        
        
        // if record type value is passed in use that
        if (strRecordTypeParam != null)
        {
            for (RecordType rt: [select id,name from recordtype where id = :strRecordTypeParam]) {
                RecordTypeId = rt.id;
                RecordTypeName = rt.name;
            
                this.m_Case.RecordTypeId = RecordTypeId;
            } 
        
        }
        else //otherwise 
        {
            // If the controller didn't have this value get the Opp default
            if (RecordTypeId == null) {
                RecordTypeId = RecordType_Functions.getDefaultRecordTypeId('Case');
            
            
            }
            for (RecordType rt: [select id,name from recordtype where id = :recordtypeid]) {
                RecordTypeName = rt.name;
            } 
        }
    
    }

    // Inherit previous parameters, more imporatntly, RecordType parameter!
    private String getParameters(){
        string param = '';
        Map<String, String> strMap = ApexPages.currentPage().getParameters();
        String[] keys = new String[]{'RecordType', 'retURL', 'cancelURL', 'accid', 'id', 'def_account_id', 'save_new_url', 'def_contact_id', 'def_opportunity_id','00N50000002AXw2','CF00N50000001ywPq','CF00N50000001ywPq_lkid','00N50000001ywSt'};
        for(String s : keys){
            if(strMap.containsKey(S)) param += s + '=' + strMap.get(s) + '&';
        }
        param = param.replace(';','&00N50000001ywSt=');
        if(param.length() > 0) param = param.substring(0, param.length()-1);
        return param;
    } 

    private void getCaseReasons(String strInternalOrExternal)
    {
        caseReasonsOptionsList.clear();
        
        //System.Debug('strInternalOrExternal in getCaseReasons is ' + strInternalOrExternal);
        
        //caseReasonsOptionsList.add(new SelectOption('','- None -'));
        
        if (strInternalOrExternal == 'External' || strInternalOrExternal == 'Internal')
        {           
            Schema.DescribeFieldResult F = Case.Reason.getDescribe();
            List<Schema.PicklistEntry> P = F.getPicklistValues();
            for (Schema.PicklistEntry entry: P)
            {
                if (strInternalOrExternal == 'External')
                {
                    if (entry.getValue().contains('EXT-'))
                        caseReasonsOptionsList.add(new SelectOption(entry.getLabel(),entry.getValue()));
                }
                else if (strInternalOrExternal == 'Internal')
                {
                    if (entry.getValue().contains('INT-'))
                        caseReasonsOptionsList.add(new SelectOption(entry.getLabel(),entry.getValue()));
                }
                //system.debug('entry.getLabel--'+entry.getLabel() + ' entry.getValue--'+entry.getValue());     
            }
        }           
        
    }

    private void getCaseOrigins(String strInternalOrExternal)
    {
        caseOriginsOptionsList.clear();
        
        //System.Debug('strInternalOrExternal in getCaseOrigins is ' + strInternalOrExternal);
        
        //caseOriginsOptionsList.add(new SelectOption('','- None -'));
         
        if (strInternalOrExternal == 'External' || strInternalOrExternal == 'Internal')
        {
            Schema.DescribeFieldResult F = Case.Origin.getDescribe();
            List<Schema.PicklistEntry> P = F.getPicklistValues();
            for (Schema.PicklistEntry entry: P)
            {
                if (strInternalOrExternal == 'External')
                {
                    if (entry.getValue().contains('EXT-'))
                        caseOriginsOptionsList.add(new SelectOption(entry.getLabel(),entry.getValue()));
                }
                else if (strInternalOrExternal == 'Internal')
                {
                    if (entry.getValue().contains('INT-'))
                        caseOriginsOptionsList.add(new SelectOption(entry.getLabel(),entry.getValue()));
                }           
                //system.debug('entry.getLabel--'+entry.getLabel() + ' entry.getValue--'+entry.getValue());     
            }   
        }       
        
    }
    
    private void getTechLabGroups(String strCustomerGroup)
    {
        
        try
        {
            LogDebugMsg('Entered: getTechLabGroups');
            
            LogDebugMsg('strCustomerGroup: ' + strCustomerGroup);
            
            technicalLabGroupOptionsList.clear();
    
            List<TechLabGroup_Configuration__c> techLabGrpConfigList = [
                SELECT id, Technical_Lab_Group__c, Lab_Group_Manager__c, Customer_Group__c
                FROM TechLabGroup_Configuration__c 
                WHERE Customer_Group__c =:strCustomerGroup];
            
            LogDebugMsg('techLabGrpConfigList: ' + techLabGrpConfigList.size());
            
            if (techLabGrpConfigList.size() > 0)
            {   
                technicalLabGroupOptionsList.add(new SelectOption('','--None--')); 
                for (TechLabGroup_Configuration__c techLabGrpConfig : techLabGrpConfigList )
                {
                    technicalLabGroupOptionsList.add(new SelectOption(techLabGrpConfig.Technical_Lab_Group__c,techLabGrpConfig.Technical_Lab_Group__c));
        
                }  
            }
            else    
            {
                /*
                // if there is no data for the customer group, get picklist values as defined on the field
                Schema.DescribeFieldResult F = TechLabGroup_Configuration__c.Technical_Lab_Group__c.getDescribe();
                List<Schema.PicklistEntry> P = F.getPicklistValues();
                for (Schema.PicklistEntry entry: P)
                {
                    technicalLabGroupOptionsList.add(new SelectOption(entry.getLabel(),entry.getValue()));
                } 
                */
                // if there is no data for the customer group, display error
                String noLabTechErrMsg = 'No Technical Lab Group found for customer group ' + strCustomerGroup + ' . Please contact system Administrator';
                CustomException.throwException(noLabTechErrMsg);              
                        
            }   
        }
        catch (CustomException custEx)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, custEx.getMessage()));
        }       
        catch (Exception ex)
        {
            LogException('getTechLabGroups', ex);
        }  
            
        LogDebugMsg('Exiting: getTechLabGroups');      
        
    }    

/*
    private boolean CreateFeedbackTask()
    {
        boolean returnValue = false;
        String returnValueFromFucntion = '';
        
        try
        {
            
            if (m_Case.AccountId != null && m_Case.Account.OwnerId == null)
            {
                GetAccountInfo(m_Case.AccountId);
            }           

            System.Debug('CreateFeedbackTask m_Case.Account.OwnerId: ' + m_Case.Account.OwnerId);
            
            if (m_Case.Account.OwnerId == null)
            {
                LogException('CreateFeedbackTask', 'Account OwnerId is null');
                
            }
            else
            {

                returnValueFromFucntion = Task_Functions.createTaskWithDueDateRecordTypeAndSendEmails(
                    acc.OwnerId, m_Case.Id, 
                    'Customer Feedback Required for TSR - ' + m_case.CaseNumber , 
                    '', m_Case.Account, date.today().addDays(30),
                    [select id,name from recordtype where name = 'Aqualon Task' limit 1].Id) ;
                    
                //System.Debug('CreateFeedbackTask after creating task: ' + returnValueFromFucntion);
                            
                if (returnValueFromFucntion != '')
                {
                    LogException('CreateFeedbackTask', returnValueFromFucntion);
                    
                }
                else
                    returnValue = true;
                
            }               
        
        }
        catch (Exception ex)
        {
            LogException('CreateFeedbackTask', ex);
        
        }   
        
        return returnValue; 
    }
    
*/

    private Boolean isNull(String s) {return (s == null || s.trim().length() == 0);}
    
    private void ShowForm(String formToshow)
    {
        if (formToshow == 'renderTSRForm')
        {
            renderTSRForm = true;
            renderOppsForm = false;
            renderAquariusForm = false;
            renderRiskForm = false;
            renderContactForm = false;
            renderOwnerForm = false;
            renderCustFeedbackByForm = false;
            renderCustContFeedbackForm = false;
            renderConfirmDialogComp = false;
        }   
        else if (formToshow == 'renderOppsForm')
        {
            renderTSRForm = false;
            renderOppsForm = true;
            renderAquariusForm = false;
            renderRiskForm = false;
            renderContactForm = false;
            renderOwnerForm = false;
            renderCustFeedbackByForm = false;
            renderCustContFeedbackForm = false;
            renderConfirmDialogComp = false;
        }
        else if (formToshow == 'renderAquariusForm')
        {
            renderTSRForm = false;
            renderOppsForm = false;
            renderAquariusForm = true;
            renderRiskForm = false;
            renderContactForm = false;
            renderOwnerForm = false;
            renderCustFeedbackByForm = false;
            renderCustContFeedbackForm = false;
            renderConfirmDialogComp = false;
        }   
        else if (formToshow == 'renderRiskForm')
        {
            renderTSRForm = false;
            renderOppsForm = false;
            renderAquariusForm = false;
            renderRiskForm = true;
            renderContactForm = false;
            renderOwnerForm = false;
            renderCustFeedbackByForm = false;
            renderCustContFeedbackForm = false;
            renderConfirmDialogComp = false;
        }   
        else if (formToshow == 'renderContactForm')
        {
            renderTSRForm = false;
            renderOppsForm = false;
            renderAquariusForm = false;
            renderRiskForm = false;
            renderContactForm = true;
            renderOwnerForm = false;
            renderCustFeedbackByForm = false;
            renderCustContFeedbackForm = false;
            renderConfirmDialogComp = false;
        }       
        else if (formToshow == 'renderOwnerForm')
        {
            renderTSRForm = false;
            renderOppsForm = false;
            renderAquariusForm = false;
            renderRiskForm = false;
            renderContactForm = false;
            renderOwnerForm = true;
            renderCustFeedbackByForm = false;
            renderCustContFeedbackForm = false;
            renderConfirmDialogComp = false;
        }       
        else if (formToshow == 'renderCustFeedbackByForm')
        {
            renderTSRForm = false;
            renderOppsForm = false;
            renderAquariusForm = false;
            renderRiskForm = false;
            renderContactForm = false;
            renderOwnerForm = false;
            renderCustFeedbackByForm = true;
            renderCustContFeedbackForm = false;
            renderConfirmDialogComp = false;
        } 
        else if (formToshow == 'renderCustContFeedbackForm')
        {
            renderTSRForm = false;
            renderOppsForm = false;
            renderAquariusForm = false;
            renderRiskForm = false;
            renderContactForm = false;
            renderOwnerForm = false;
            renderCustFeedbackByForm = false;
            renderCustContFeedbackForm = true;
            renderConfirmDialogComp = false;
        }  
        else if (formToShow == 'renderConfirmDialogComp')
        {
            renderConfirmDialogComp = true;
            renderTSRForm = false;
            renderOppsForm = false;
            renderAquariusForm = false;
            renderRiskForm = false;
            renderContactForm = false;
            renderOwnerForm = false;
            renderCustFeedbackByForm = false;
            renderCustContFeedbackForm = false; 
        
        }                       
                    
    }

    public Boolean RequiredFieldCheckOnSave()
    {
        try
        {
            // primary fields
            
            for (integer i=0; i < FormRequiredFieldNamesList.size(); i++)
            {
                if ( m_Case.get(FormRequiredFieldNamesList[i]) == null)
                {
                    SetFieldRequired(FormRequiredFieldNamesList[i]);
                    LogException('RequiredFieldCheckOnSave', FormRequiredFieldLabelsList[i] + ' is required ');
                    return false;
                }               
            }                  
        }
        catch (Exception ex)
        {
            LogException('RequiredFieldCheckOnSave', ex);
            return false;          
        }

        
        return true;
    }

    private void SetFieldRequired(String field)
    {
        try
        {
            if (field == 'Subject')
                SubjectRequireStyle = 'error' ;
            else
                SubjectRequireStyle = null;
                
            if (field == 'Internal_External__c')
                InternalExternalRequireStyle = 'error' ;
            else
                InternalExternalRequireStyle = null;

            if (field == 'AccountId')
                AccountIdRequireStyle = 'error' ;
            else
                AccountIdRequireStyle = null;
                
            if (field == 'ContactId')
                ContactIdRequireStyle = 'error' ;
            else
                ContactIdRequireStyle = null;

            if (field == 'Reason')
                CaseReasonRequireStyle = 'error' ;
            else
                CaseReasonRequireStyle = null;                                                                                                

            if (field == 'Status')
                StatusRequireStyle = 'error' ;
            else
                StatusRequireStyle = null;                                                

            if (field == 'OwnerId')
                OwnerIdRequireStyle = 'error' ;
            else
                OwnerIdRequireStyle = null;                                                

            if (field == 'T_RequestedCompletionDate__c')
                RequestedCompletionDateRequireStyle = 'error' ;
            else
                RequestedCompletionDateRequireStyle = null; 
                
            if (field == 'SBU__c')
                SBURequireStyle = 'error' ;
            else
                SBURequireStyle = null;  
                
            if (field == 'Technical_Lab_Group__c')
                TechnicalLabGroupRequireStyle = 'error' ;
            else
                TechnicalLabGroupRequireStyle = null;                                                
                                                              
            if (field == 'Background__c')
                BackgroundRequireStyle = 'error' ;
            else
                BackgroundRequireStyle = null;
                
            if (field == 'Objective__c')
                ObjectiveRequireStyle = 'error' ;
            else
                ObjectiveRequireStyle = null;
                                                  
            if (field == 'Describe_Work_Needed__c')
                DescribeWorkNeededRequireStyle = 'error' ;
            else
                DescribeWorkNeededRequireStyle = null;          

        }
        catch (Exception ex)
        {
            LogException('SetFieldRequired', ex);
        }
    }

    private void LogDebugMsg(String strErrMsg)
    {
        System.Debug('LogDebugMsg >>> ' +strErrMsg);
        try
        {
            if (renderDebugPanel)
            {
                strErrMsg = datetime.now() + ' ' + strErrMsg;
                if (debugTextValue.length() > 50000) debugTextValue = '';
                if (debugTextValue == '') debugTextValue = strErrMsg;
                else debugTextValue += '\r\n' + strErrMsg; 
            }
        }
        catch (Exception ex){}
    }

}
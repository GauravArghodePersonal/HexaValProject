public class SCPR {

    public static final Integer LIMIT_30 = 30;
    public static final Integer LIMIT_50 = 50;
    
    public static final Set<String> LOG_A_CALL_TASK_TYPES = new Set<String> {
        'Email',
        'Entertainment',
        'Fax',
        'Follow Up',
        'Inquiry',
        'Mailing',
        'Meeting',
        'Other',
        'Phone Call',
        'Physical',
        'Project',
        'Sales Call',
        'Technical Service Call',
        'Trial'
    };
    //Start Account Summary Info
    public Account_Summary_Information accountSummaryInformation = new Account_Summary_Information();
    public List<Account_Sales_Figure__c> acctSalesFigures;
    public string fid;
    public list<document> docs{get; set;}
    public boolean renderdocs{get; set;}
    
    public Account_Summary_Information getAccountSummaryInformation() {
      return accountSummaryInformation;
    }
        public Boolean getFYTDvsPFYTD_Volume_in_LB_Up() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_LB_Up;}
    public Boolean getFYTDvsPFYTD_Volume_in_LB_Down() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_LB_Down;}
    public Boolean getFYTDvsPFYTD_Volume_in_KG_Up() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_LB_Up;}
    public Boolean getFYTDvsPFYTD_Volume_in_KG_Down() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_LB_Down;}
    public Boolean getFYTDvsPFYTD_Amount_Up() {return accountSummaryInformation.FYTDvsPFYTD_Amount_Up;}
    public Boolean getFYTDvsPFYTD_Amount_Down() {return accountSummaryInformation.FYTDvsPFYTD_Amount_Down;}
    public Boolean getFYTDvsPFYTD_GM_Up() {return accountSummaryInformation.FYTDvsPFYTD_GM_Up;}
    public Boolean getFYTDvsPFYTD_GM_Down() {return accountSummaryInformation.FYTDvsPFYTD_GM_Down;}
    public Boolean getFYTDvsPFYTD_GMpct_Up() {return accountSummaryInformation.FYTDvsPFYTD_GMpct_Up;}
    public Boolean getFYTDvsPFYTD_GMpct_Down() {return accountSummaryInformation.FYTDvsPFYTD_GMpct_Down;}
    //End Account Summary Info
    /* Property value that controls the truncation of comments */
    public boolean Contacts_ShowInactive { get; private set; }
    public boolean OpenActivities_FullComments { get; private set; }
    public String  OpenActivities_NextXDays { get; set; }
    public boolean CallReports_FullComments { get; private set; }
    public String  CallReports_LastXDays { get; set; }
    public boolean CallReports_LimittoOwner { get; set; }
    public String  Call_Reports_LastXDays { get; set; }
    public boolean Call_Reports_LimittoOwner { get; set; }
    public String  Opportunities_Stage { get; set; }
    public List<Contract> conList {get;set;} 
    public List<ID> conListIds = new List<ID>();
    public Integer countName {get;set;}
    public Integer countStatus {get;set;}
    public Boolean isSortByStatus {get;set;}
    public Boolean isSortByName {get;set;}
    public String selectedStatus {get;set;}
    public String businessName {get;set;}
    public Boolean isDistribution {get;set;}
    public Boolean isFlintGroup {get;set;}
    public Boolean isPerformanceMaterials {get;set;}
    public Boolean isValvoline {get;set;}
    public Boolean isWater {get;set;}
    public Boolean isAqualon {get;set;}
    public boolean isNorthAmerica {get; set;}
    public boolean isES{get; set;}
    public String  OpenOrders_NextXDays { get; set; }
    public String  Contacts_Type { get; set; }
    public String  ContactsActStat { get; set; }
    public String  BusinessContracts { get; set; }
    public String  SampleRequest_LastXDays { get; set; }
    public String  OrderHistory{ get; set; }

    public Boolean renderSR{get;set;}
    public Boolean renderOA{get;set;}
    public Boolean renderCL{get;set;}
    public Boolean renderCR{get;set;}
    public Boolean renderOPP{get;set;}
    public Boolean renderOO{get;set;}
    public Boolean renderCon{get;set;}
    public Boolean renderBusCon{get;set;}
    public Boolean renderOH{get;set;}
   
    public boolean ClosedActivities_FullComments { get; private set; }
    public String  ClosedActivities_NextXDays { get; set; }
    public Boolean renderCA{get;set;}
    public String  contentType{get;set;}

        
    private final Account acct;
    
    // The extension constructor initializes the private member
    // variable \by using the getRecord method from the standard
    // controller.
    public SCPR(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord();
        docs = new list<document>();
        fid = apexpages.currentpage().getparameters().get('fid');
        if(fid == null){fid = '';}
        docs = [select url, name from document where folderid = :fid];
        renderdocs = (fid.length() > 0);
        

        //start Account Summary Information
                        acctSalesFigures = [SELECT 
                         Id, 
                         Name, 
                         CurrencyIsoCode, 
                         CreatedDate, 
                         CreatedById, 
                         LastModifiedDate, 
                         LastModifiedById, 
                         SystemModstamp, 
                         Account__c, 
                         Date_Range_Label__c, 
                         Start_Date__c, 
                         End_Date__c, 
                         Sales_Volume_in_LBs__c, 
                         Sales_Vol_in_KGs__c,
                         Sales_Volume_in_UNs__c, 
                         Sales_Volume_in_GALs__c, 
                         Sales_Volume_in_PTs__c, 
                         Sales_Amount__c, 
                         GM__c, 
                         GMpct__c
                  FROM Account_Sales_Figure__c
                  WHERE Account__c = :Acct.Id
                  ];
        
                
        for(Account_Sales_Figure__c f:acctSalesFigures)
          {
          	if (f.Start_Date__c == null) {continue;}
          accountSummaryInformation.addData(f.Date_Range_Label__c,
                                    f.Start_Date__c,
                                    f.End_Date__c,
                                    f.Sales_Volume_in_LBs__c,
                                    f.Sales_Vol_in_KGs__c,
                                    f.Sales_Volume_in_UNs__c,
                                    f.Sales_Volume_in_GALs__c,
                                    f.Sales_Volume_in_PTs__c,
                                    f.Sales_Amount__c,
                                    f.GM__c,
                                    f.GMpct__c,
                                    f.CurrencyIsoCode
                            );
          }
        
        
        //end Account Summary Information
        Contacts_ShowInactive        = false;
        OpenActivities_FullComments  = false;
        OpenActivities_NextXDays     = '30';
        CallReports_FullComments     = false;
        CallReports_LastXDays        = '90';
        CallReports_LimittoOwner     = false;
        Call_Reports_LastXDays       = '90';
        Call_Reports_LimittoOwner    = false;
        truncatedCommentLength       = 100;
        Opportunities_Stage          = 'All';
        OpenOrders_NextXDays         = 'All Open';
        Contacts_Type               = 'All';
        SampleRequest_LastXDays      = '60';
        contentType = '';
        ClosedActivities_FullComments  = false;
        ClosedActivities_NextXDays     = '30';
        ContactsActStat                = 'All';
        BusinessContracts              = 'All';
//      OrderHistory                   = 'All';
        OrderHistory                   = '30';        
        renderSR = true;
        renderOA = true;
        renderCL = true;
        renderCR = true;
        renderOPP = true;
        renderOO = true;
        renderCA = true;
        renderCon = True;
        renderBusCon = true;
        renderOH = true;
        


        if(ApexPages.currentPage().getparameters().get('c_si') != null) 
            {if (ApexPages.currentPage().getparameters().get('c_si') == 'true') {Contacts_ShowInactive=true;} else {Contacts_ShowInactive=false;}}

        if(ApexPages.currentPage().getparameters().get('oa_fc') != null) 
            {if (ApexPages.currentPage().getparameters().get('oa_fc') == 'true') {OpenActivities_FullComments=true;} else {OpenActivities_FullComments=false;}}
            
        if(ApexPages.currentPage().getparameters().get('oa_nxd') != null) 
            {OpenActivities_NextXDays = ApexPages.currentPage().getparameters().get('oa_nxd');}

        if(ApexPages.currentPage().getparameters().get('cr_fc') != null) 
            {if (ApexPages.currentPage().getparameters().get('cr_fc') == 'true') {CallReports_FullComments=true;} else {CallReports_FullComments=false;}}

        if(ApexPages.currentPage().getparameters().get('cr_lxd') != null) 
            {CallReports_LastXDays = ApexPages.currentPage().getparameters().get('cr_lxd');}
            
       if(ApexPages.currentPage().getparameters().get('opp_stage') != null) 
            {Opportunities_Stage = ApexPages.currentPage().getparameters().get('opp_stage');}

        if(ApexPages.currentPage().getparameters().get('cr_lto') != null) 
            {if (ApexPages.currentPage().getparameters().get('cr_lto') == 'true') {CallReports_LimittoOwner=true;} else {CallReports_LimittoOwner=false;}}
        
        if(ApexPages.currentPage().getparameters().get('c_r_lto') != null) 
            {if (ApexPages.currentPage().getparameters().get('c_r_lto') == 'true') {Call_Reports_LimittoOwner=true;} else {Call_Reports_LimittoOwner=false;}}
            
         if(ApexPages.currentPage().getparameters().get('Op_Order_NXdays') != null) 
            {
                OpenOrders_NextXDays = ApexPages.currentPage().getparameters().get('Op_Order_NXdays');
            }
            
         //
         
         
         
         
        if(ApexPages.currentPage().getparameters().get('Order_His_NXdays') != null) 
            {
                OrderHistory = ApexPages.currentPage().getparameters().get('Order_His_NXdays');
            }

        
        if(ApexPages.currentPage().getparameters().get('Cs_type') != null) 
            {
                Contacts_Type = ApexPages.currentPage().getparameters().get('Cs_type');
            }

        
            
        if(ApexPages.currentPage().getparameters().get('Sa_req__LXdays') != null) 
            {
                SampleRequest_LastXDays = ApexPages.currentPage().getparameters().get('Sa_req__LXdays');
            }
        if(ApexPages.currentPage().getparameters().get('ca_fc') != null) 
            {if (ApexPages.currentPage().getparameters().get('ca_fc') == 'true') {ClosedActivities_FullComments=true;} else {ClosedActivities_FullComments=false;}}        
        if(ApexPages.currentPage().getparameters().get('rn_sr') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_sr') == 'true') {renderSR=true;} else {renderSR=false;}}
        if(ApexPages.currentPage().getparameters().get('rn_OA') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_OA') == 'true') {renderOA=true;} else {renderOA=false;}}
        if(ApexPages.currentPage().getparameters().get('rn_CL') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_CL') == 'true') {renderCL=true;} else {renderCL=false;}}
        if(ApexPages.currentPage().getparameters().get('rn_CR') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_CR') == 'true') {renderCR=true;} else {renderCR=false;}}
        if(ApexPages.currentPage().getparameters().get('rn_OPP') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_OPP') == 'true') {renderOPP=true;} else {renderOPP=false;}}
        if(ApexPages.currentPage().getparameters().get('rn_OO') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_OO') == 'true') {renderOO=true;} else {renderOO=false;}}
        if(ApexPages.currentPage().getparameters().get('rn_con') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_con') == 'true') {rendercon=true;} else {rendercon=false;}}
        if(ApexPages.currentPage().getparameters().get('rn_buscon') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_buscon') == 'true') {renderbuscon=true;} else {renderbuscon=false;}}

        if(ApexPages.currentPage().getparameters().get('rn_OH') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_OH') == 'true') {renderOH=true;} else {renderOH=false;}}
        if(ApexPages.currentPage().getparameters().get('dwnld_exl') != null) 
            {if (ApexPages.currentPage().getparameters().get('dwnld_exl') == 'true') {contentType ='application/vnd.ms-excel#test.xls';} else {contentType = '';}}
        if(ApexPages.currentPage().getparameters().get('rn_CA') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_CA') == 'true') {renderCA=true;} else {renderCA=false;}}
        conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract WHERE RecordTypeId = '012300000000a6U' and AccountId = :acct.Id ORDER BY EndDate DESC];
        for(Integer i=0;i<conList.size();i++)
            conListIds.add(conList[i].Id);
        countName = 0;
        countStatus = 0;
        selectedStatus = 'All';
    }

    private Boolean isLogCallType(String t) {
        return (t == null || t == '' || LOG_A_CALL_TASK_TYPES.contains(t));
    }

    /* Returns string value with respect to Active and Inactive contects*/
    public String getContacts_Desc() {
        String result = '';
        
        if (Contacts_ShowInactive == true)
            {result = '(Includes Active and Inactive Contacts)';}
        
        return result;
    }    
    
    /* Returns string value which contains date range. */
    public String getOpenActivities_Desc()
    {
        String result = '';
        String startDate = '';
        String endDate = '';
        
        startDate = String.ValueOf(System.today());
        endDate = String.ValueOf(System.today().addDays((Integer.valueOf(OpenActivities_NextXDays) * 1)));
        
        result = '(Date Range = ' + startDate + ' - ' + endDate + ')';
        
        return result;
        
    }

    /* Returns string value which contains date range. */
        public String Activities_Desc()
    {
        String result = '';
        String startDate = '';
        String endDate = '';
        
        startDate = String.ValueOf(System.today());
        endDate = String.ValueOf(System.today().addDays((Integer.valueOf(closedActivities_NextXDays) * 1)));
        
        result = '(Date Range = ' + startDate + ' - ' + endDate + ')';
        
        return result;
        
    }
    
    /* Returns string value which contains date on basis of current date and the selected value of dropdown for Call Reports
       and Call report limit.*/
    public String getCallReports_Desc() {
        String result = '';
        String startDate = '';
        String endDate = '';
        
        startDate = String.ValueOf(System.today().addDays((Integer.valueOf(CallReports_LastXDays) * -1)));
        endDate = String.ValueOf(System.today());
        
        result = '(Date Range = ' + startDate + ' - ' + endDate;

        if (CallReports_LimittoOwner == true)
            {result += ' - Limited to Call Reports Created by Account Owner)';}
        else 
            {result += ')';}

        
        return result;
    }
    
    public String getOppStage_Desc()
    {
        String result = '';
        result = '(Stage = ' + Opportunities_Stage + ')';
        return result;
    }
    
    public String getCDFStatus_Desc()
    {
        String result = '';
        result = '(Status = ' + selectedStatus + ')';
        return result;
    }
       
    public String getOpenOrder_Desc() {
        String result = '';
        String startDate = '';
        String endDate = '';
        
        if (OpenOrders_NextXDays == 'All Open') {
                result = '(Status = All)';
            } else {
                endDate = String.ValueOf(System.today().addDays((Integer.valueOf(OpenOrders_NextXDays) * (1))));
                startDate = String.ValueOf(System.today());
                result = '(Date Range = ' + startDate + ' - ' + endDate + ')';
            }
            return result;
    }
    
    
    public String getOrderHistory_Desc() {
    String result = '';
        String startDate = '';
        String endDate = '';
        
        if (OrderHistory == 'All') {
                result = '(Status = All)';
            } else {
                endDate = String.ValueOf(System.today().addDays((Integer.valueOf(OrderHistory) * (-1))));
                startDate = String.ValueOf(System.today());
                result = '(Date Range = ' + endDate + ' - ' + startDate + ')';
            }
            return result;
    }
    
    public String getSampleRequest_Desc() {
        String result = '';
        String startDate = '';
        String endDate = '';
        endDate = String.ValueOf(System.today().addDays((Integer.valueOf(SampleRequest_lastXdays) * (-1))));
        startDate = String.ValueOf(System.today());
        result = '(Date Range = ' + endDate + ' - ' + startDate + ')';
        
        return result;
    }
    
    public String getCnct_Desc() {
        String result = '';

        If (ContactsActStat=='All') {
            result = '(Status = All)';
        } else if (ContactsActStat=='Active') {
            result = '(Status = Active)';
        } else if (ContactsActStat=='Active') {
            result = '(Status = Active)';
        } else {
            result = '(Status = '+ ContactsActStat + ')';
        }        
        return result;
    }   
    
    public String getClosedActivities_Desc()
    {
        String result = '';
        String startDate = '';
        String endDate = '';
        
        startDate = String.ValueOf(System.today());
        endDate = String.ValueOf(System.today().addDays((Integer.valueOf(closedActivities_NextXDays) * 1)));
        
        result = '(Date Range = ' + startDate + ' - ' + endDate + ')';
        
        return result;
        
    }
 

    /* Action method for toggling the fullComments property */
    public void toggleContacts_ShowInactive() { Contacts_ShowInactive = !Contacts_ShowInactive; }
    public void toggleOpenActivities_FullComments() { OpenActivities_FullComments = !OpenActivities_FullComments; }
    public void toggleCallReports_FullComments() { CallReports_FullComments = !CallReports_FullComments; }
    public void toggleCallReports_LimittoOwner() { CallReports_LimittoOwner = !CallReports_LimittoOwner; }
    public void toggleCall_Reports_LimittoOwner() { Call_Reports_LimittoOwner = !Call_Reports_LimittoOwner; }
    public void toggleClosedActivities_FullComments() { ClosedActivities_FullComments = !ClosedActivities_FullComments; }

    /* Action method for navigating the user back to the case page. */
    public PageReference backToAccount() {
        return new ApexPages.StandardController(a).view();
    }

    public PageReference Printable_View() {
        PageReference result = null;    
        PageReference PrintableView = Page.Sales_Call_Prep_Report_Print;
        PrintableView.getparameters().put('accountId',accountId);
        PrintableView.getparameters().put('c_si',String.valueOf(Contacts_ShowInactive));
        PrintableView.getparameters().put('oa_fc',String.valueOf(OpenActivities_FullComments));
        PrintableView.getParameters().put('oa_nxd',OpenActivities_NextXDays);
        PrintableView.getparameters().put('cr_fc',String.valueOf(CallReports_FullComments));
        PrintableView.getparameters().put('cr_lxd',CallReports_LastXDays);
        PrintableView.getParameters().put('opp_stage', Opportunities_Stage);
        PrintableView.getparameters().put('cr_lto',String.valueOf(CallReports_LimittoOwner));
        PrintableView.getparameters().put('c_r_lto',String.valueOf(Call_Reports_LimittoOwner));
        PrintableView.getparameters().put('Op_Order_NXdays',String.valueOf(OpenOrders_NextXDays));  
        PrintableView.getparameters().put('Sa_req__LXdays',String.valueOf(SampleRequest_LastXDays));  
        PrintableView.getparameters().put('Cs_type',String.valueOf(Contacts_Type)); 
        PrintableView.getparameters().put('Order_His_NXdays',String.valueOf(OrderHistory));                
        
        PrintableView.getparameters().put('rn_sr',String.valueOf(renderSR));
        PrintableView.getParameters().put('rn_OA', String.valueOf(renderOA));
        PrintableView.getparameters().put('rn_CL',String.valueOf(renderCL));
        PrintableView.getparameters().put('rn_CR',String.valueOf(renderCR));
        PrintableView.getparameters().put('rn_OPP',String.valueOf(renderOPP));  
        PrintableView.getparameters().put('rn_OO',String.valueOf(renderOO)); 
        PrintableView.getParameters().put('rn_CA', String.valueOf(renderCA));
        PrintableView.getParameters().put('rn_con', String.valueOf(rendercon));
        PrintableView.getParameters().put('rn_buscon', String.valueOf(renderbuscon));
        PrintableView.getParameters().put('rn_OH', String.valueOf(renderOH));

        result = PrintableView;
        return page.Sales_Call_Prep_Report_Print;
    
    }
    /*
    public PageReference Download_excel() {
        PageReference downloadView = Page.Contact_Report_excel;
        downloadView.getparameters().put('scontrolCaching','1');
        downloadView.getparameters().put('id',a.id);
        downloadView.getparameters().put('dwnld_exl','true');
        return downloadView;
    }*/
    
    public PageReference  reRenderSR(){
        renderSR = !(renderSR);
        return null;
    }
    
    public PageReference  reRendercon(){
        rendercon = !(rendercon);
        return null;
    }
    
    public PageReference  reRenderbuscon(){
        renderbuscon = !(renderbuscon);
        return null;
    }

    
    public PageReference  reRenderOA(){
        renderOA = !(renderOA);
        return null;
    }

    public PageReference  reRenderCA(){
        renderCA = !(renderCA);
        return null;
    }
    
    public PageReference  reRenderCL(){
        renderCL = !(renderCL);
        return null;
    }
    
    public PageReference  reRenderCR(){
        renderCR = !(renderCR);
        return null;
    }
    
    public PageReference  reRenderOpp(){
        renderOPP = !(renderOPP);
        return null;
    }
    
    public PageReference  reRenderOO(){
        renderOO = !(renderOO);
        return null;
    }
    
    public PageReference  reRenderOH(){
        renderOH = !(renderOh);
        return null;
    }
        
    public List<SelectOption> getOpenOrders_NextXDays_items()
    {
        List<SelectOption> openActivitiesOptions = new List<SelectOption>();
        openActivitiesOptions.add(new SelectOption('All Open', 'All Open'));
        openActivitiesOptions.add(new SelectOption('30', 'Next 30 Days'));
        openActivitiesOptions.add(new SelectOption('60', 'Next 60 Days'));
        openActivitiesOptions.add(new SelectOption('90', 'Next 90 Days'));
        openActivitiesOptions.add(new SelectOption('120', 'Next 120 Days'));
        openActivitiesOptions.add(new SelectOption('180', 'Next 180 Days'));
        return openActivitiesOptions;
    }
    
    public List<SelectOption> getSampleRequest_LastXDays_items()
    {
        List<SelectOption> openActivitiesOptions = new List<SelectOption>();
        openActivitiesOptions.add(new SelectOption('30', 'Last 30 Days'));
        openActivitiesOptions.add(new SelectOption('60', 'Last 60 Days'));
        openActivitiesOptions.add(new SelectOption('90', 'Last 90 Days'));
        openActivitiesOptions.add(new SelectOption('120', 'Last 120 Days'));
        openActivitiesOptions.add(new SelectOption('180', 'Last 180 Days'));
        return openActivitiesOptions;
    }
    
    public List<SelectOption> getContactsActStat_items()
    {
        List<SelectOption> openActivitiesOptions = new List<SelectOption>();
        openActivitiesOptions.add(new SelectOption('All', 'All'));
        openActivitiesOptions.add(new SelectOption('Active', 'Active'));
        openActivitiesOptions.add(new SelectOption('Inactive', 'Inactive'));        
        openActivitiesOptions.add(new SelectOption('10', 'Last 10'));
        openActivitiesOptions.add(new SelectOption('20', 'Last 20'));
        openActivitiesOptions.add(new SelectOption('50', 'Last 50'));
        openActivitiesOptions.add(new SelectOption('100', 'Last 100'));

        return openActivitiesOptions;
    }
    
    public List<SelectOption> getOpenActivities_NextXDays_items()
    {
        List<SelectOption> openActivitiesOptions = new List<SelectOption>();
        openActivitiesOptions.add(new SelectOption('30', 'Next 30 Days'));
        openActivitiesOptions.add(new SelectOption('90', 'Next 90 Days'));
        openActivitiesOptions.add(new SelectOption('183', 'Next 6 Months'));
        openActivitiesOptions.add(new SelectOption('365', 'Next 12 Months'));
        return openActivitiesOptions;
    }
    
    public List<SelectOption> getClosedActivities_NextXDays_items()
    {
        List<SelectOption> closedActivitiesOptions = new List<SelectOption>();
        closedActivitiesOptions.add(new SelectOption('30', 'Last 30 Days'));
        closedActivitiesOptions.add(new SelectOption('90', 'Last 90 Days'));
        closedActivitiesOptions.add(new SelectOption('183', 'Last 6 Months'));
        closedActivitiesOptions.add(new SelectOption('365', 'Last 12 Months'));
        return closedActivitiesOptions;
    }

    public List<SelectOption> getCallReports_LastXDays_items() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('30','Last 30 Days'));
        options.add(new SelectOption('60','Last 60 Days'));
        options.add(new SelectOption('90','Last 90 Days'));
        options.add(new SelectOption('183','Last 6 Months'));
        options.add(new SelectOption('365','Last Year'));
        return options;
    }
    
    public List<SelectOption> getCall_Reports_LastXDays_items() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('30','Last 30 Days'));
        options.add(new SelectOption('60','Last 60 Days'));
        options.add(new SelectOption('90','Last 90 Days'));
        options.add(new SelectOption('183','Last 6 Months'));
        options.add(new SelectOption('365','Last Year'));
        return options;
    }
    
    public List<SelectOption> getOpportunities_Stage_items()
    {
        List<SelectOption> stageOptions = new List<SelectOption>();
        stageOptions.add(new SelectOption('All', 'All'));
        stageOptions.add(new SelectOption('Open', 'Open'));
        stageOptions.add(new SelectOption('Closed', 'Closed'));
        stageOptions.add(new SelectOption('None', '-None-'));
        return stageOptions;
    }
    
    public List<SelectOption> getBusinessContracts_items()
    {
        List<SelectOption> stageOptions = new List<SelectOption>();
        stageOptions.add(new SelectOption('All', 'All'));
        stageOptions.add(new SelectOption('Active', 'Active'));
        stageOptions.add(new SelectOption('Inactive', 'Inactive'));
        return stageOptions;
    }

    public List<SelectOption> getOrderHistory_items()
    {
        List<SelectOption> stageOptions = new List<SelectOption>();
        stageOptions.add(new SelectOption('All', 'All'));
        stageOptions.add(new SelectOption('30', 'Last 30 days'));
        stageOptions.add(new SelectOption('60', 'Last 60 days'));
        stageOptions.add(new SelectOption('90', 'Last 90 days'));
        stageOptions.add(new SelectOption('120', 'Last 120 days'));
        stageOptions.add(new SelectOption('180', 'Last 180 days'));
        return stageOptions;
    }


    Integer contacts_Count;
    Integer opportunties_Count;
    Integer contracts_Count;
    Integer inactive_Contacts_Count;
    Integer Sample_Requests_Count;
    Integer Consumption_Count;
    Integer callReports_Count;
    Integer call_Reports_Count;

    Account currentAccount;
    List<Task> indirectTasks;
    List<Event> indirectEvents;

    /* Accessor for retrieving the case object and its related items. If the cid property is null this
       method will return a new, empty case object. The functionality in this method could have been placed
       in the get property accessor for the private property named 'c' below but for simplicity of the page
       author in referencing the current case object this method was created because it is not possible to
       create a variable named 'case' since it is a reserved term in Apex.*/
    public Account getAccount() { 
        
        Account result;
        
        System.debug('accountId = ' + accountId);
        
        //if(accountId == null) return new Account();
        if (currentAccount == null)
        {
            
        //We need to get a list of contact Ids because some Tasks/Events may be indirectly related to the Account via the contact record.
            
        result = [SELECT Id, Name,SAP_Industry_Key_Desc__c, SAP_Customer_Number__c, CIS_Prospect_Number__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_StreetSuppl3__c, 
                       SAP_City__c, SAP_State__c, SAP_Zip_Code__c, SAP_Country__c, OwnerID, Owner.Name, RecordTypeId, RecordType.Name, Type, SAP_Sales_Org__c, SAP_DivisionCode__c,
                        
                       (SELECT Id, Salutation, FirstName, LastName, WV_Contact_Status__c, Title, Phone, Fax, Email, OwnerId, Owner.Name, CreatedDate 
                               FROM Contacts ORDER BY LastName ASC, FirstName ASC, CreatedDate DESC limit :LIMIT_30),
                               
                       (SELECT Id, Subject, ActivityDate, Description, Status, Type, OwnerId, Owner.Name, CreatedById, CreatedBy.Name 
                               FROM Tasks ORDER BY ActivityDate DESC limit :LIMIT_30),
                               
                       (SELECT Id, StartDateTime, EndDateTime, ActivityDateTime, Subject, Description, Type, OwnerId, Owner.Name, CreatedById, CreatedBy.Name 
                               FROM Events WHERE IsChild = false ORDER BY StartDateTime DESC limit :LIMIT_30),
                               
                       (SELECT Id, Name, Amount, Probability, Competition__c, Target_Price__c, CloseDate, StageName, CurrencyIsoCode, OwnerId, Owner.Name, CreatedById, CreatedBy.Name 
                               FROM Opportunities ORDER BY CloseDate DESC limit :LIMIT_30),
                               
                       (SELECT Id, Subject, OwnerId, Owner.Name, ActivityDate, Status, WhoId, Who.Name, WhatId, What.Name, Description 
                               FROM OpenActivities limit :LIMIT_30),
                               
                       (SELECT Id, Subject, OwnerId, Owner.Name, ActivityDate, Status, WhoId, Who.Name, WhatId, What.Name, Description 
                               FROM ActivityHistories limit :LIMIT_30),
                               
                       (SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name 
                               FROM Contracts WHERE RecordTypeId = '012300000000a6U' ORDER BY EndDate DESC limit :LIMIT_30),
                               
                       (SELECT Id, Name, Material_Summary__c , Material__r.Name, Status__c, CreatedDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name 
                               FROM SampleRequest_to_Account__r WHERE Sample_State__c = 'Active' limit :LIMIT_30),
                               
                       (SELECT Id, Name, secondary_volume__c, description__c, product_group__c, SAP_Material__c, distribution_volume__c, comments__c, competitor_volume__c, container__c, 
                               current_supplier_producer_other__c, family__c, family_other__c,  offsite_waste_management__c, onsite_waste_Management__c, price__c, product_tradename__c, 
                               product_Type__c, Related_Account_Name__c, segment_Class__c, Source_Code__c, Source_description__c, sum_all_Volumes__c, technology_activity__c, Tons_Generated__c, 
                               Tons_Managed_Onsite__c, tons_managed_Offsite__c, type__c, waste_form_code__c, Waste_form_Description__c,  application__c, direct_volume__c, Material__c, 
                               Status__c, CreatedDate, Annual_Usage_Volume__c, Product_Group_FAMILY__c, Market__c, Technology__c, Annual_Usage_T_Y__c,  
                               distributor__c, Annual_Volume__c, Unit_of_Measure__c, Current_Supplier_Producer__c, channel_To_Market__c, base_code_Other__c, product_description__c, 
                               MFI__c, CreatedById, Distribution__c, of_Filler_Content_or_Comonomer__c, agent_area__c, CreatedBy.Name 
                               FROM Consumptions__r WHERE Status__c = 'Active' ORDER BY SAP_Material__r.name limit :LIMIT_30),
                               
                       (SELECT Id, Name, CreatedById, CreatedBy.Name, Title__c, Reason_for_Visit__c, Date__c, Date_of_Call__c, Start_Date__c, End_Date__c, Discussion__C, purpose__c 
                               FROM CallReports__r limit :LIMIT_30),
                               
                       (Select id, ShipTo_Desc__c, Material__c, Ordered_Qty__c, Goods_Issue_Date2__c, Reason_Rejected_Code__c, Reason_Rejected_Desc__c, Requested_Delivery_Date2__c, 
                               Expected_Ship_Date2__c, Created_Date2__c, Customer_PO_Number__c, Sales_Order_Number__c, Ordered_Qty_in_LB__c, Unit_Price_per_LB__c, Plant_Desc__c 
                               FROM Open_Orders_ShipTo__r ORDER BY Expected_Ship_Date2__c DESC limit :LIMIT_50),
                               
                       (select id, Name, Customer_Name__r.name, Contract_Type__c, Effective_Date__c, Expiration_Date__c, Comments__c, Status__c 
                               FROM Business_Contracts__r limit :LIMIT_30)
                               
                    FROM Account  
                   WHERE id = :accountId]; 
        System.debug('>>>>>>>>>>>>>>>> ' + result.Open_Orders_ShipTo__r.size());
        currentAccount = result;
        
        businessName = RecordType_Functions.getBusinessNameForAccountType(currentAccount.RecordTypeId);
        
        isNorthAmerica = (result.SAP_Sales_Org__c == '1000' || result.SAP_Sales_Org__c == '1800' || result.SAP_Sales_Org__c == '1700'); 
        isDistribution = (businessName == RecordType_Functions.DISTRIBUTION);
        isFlintGroup = (businessName == RecordType_Functions.FLINT_GROUP);
        isPerformanceMaterials = (businessName == RecordType_Functions.PERFORMANCE_MATERIALS);
        isValvoline = (businessName == RecordType_Functions.VALVOLINE);
        isWater = (businessName == RecordType_Functions.AHWT);
        isAqualon = (businessName == RecordType_Functions.AAFI);
        isES = (currentAccount.SAP_DivisionCode__c == '34');
        
        indirectTasks = [SELECT Id, Subject, ActivityDate, Description, Status, Type, OwnerId, Owner.Name, CreatedById, CreatedBy.Name 
                           FROM Task
                          WHERE AccountId = :accountId AND WhatId = null
                          ORDER BY ActivityDate DESC];

        indirectEvents = [SELECT Id, StartDateTime, EndDateTime, ActivityDateTime, Subject, Description, Type, OwnerId, Owner.Name, CreatedById, CreatedBy.Name 
                            FROM Event
                           WHERE IsChild = false AND AccountId = :accountId AND WhatId = null
                           ORDER BY StartDateTime DESC];
                
        contacts_Count = result.Contacts.size();
        opportunties_Count = result.Opportunities.size();
        contracts_Count = result.Contracts.size();
        Sample_Requests_Count = result.SampleRequest_to_Account__r.size();
        Consumption_Count = result.Consumptions__r.size();
        callReports_Count = result.CallReports__r.size();
        
        inactive_Contacts_Count = 0;
        for (Contact c:result.Contacts)
            {
            if (c.WV_Contact_Status__c != 'Active') {inactive_Contacts_Count++;}
            }   
        }
        else {result = currentAccount;}
        
                
        return result; 
    }
    
    
    
    
    public Integer getContacts_Count() {return contacts_Count;}
    public Integer getOpportunities_Count() {return opportunties_Count;}
    public Integer getContracts_Count() {return contracts_Count;}
    public Integer getInactiveContacts_Count() {return inactive_Contacts_Count;}
    public Integer getSample_Requests_Count() {return Sample_Requests_Count;}
    public Integer getConsumption_Count() {return Consumption_Count;}
    public Integer getCallReports_Count() {return callReports_Count;}
    public Integer getCall_Reports_Count() {return call_Reports_Count;}

/*
    public Integer getOpenActivities_Count() {return openActivities.size();}
    public Integer getCallReports_Count() {return callReports.size();}
*/    
    public List<Opportunity> getOpportunities()
    {
        List<Opportunity> opp = new List<Opportunity>();
        for (Opportunity o:a.Opportunities)
        {
            if(Opportunities_Stage == 'All')
            opp.add(o);
            else if((Opportunities_Stage == 'Open') && (!o.StageName.contains('Closed')))
            opp.add(o);
            else if((Opportunities_Stage == 'Closed') && (o.StageName.contains('Closed')))
            opp.add(o);
            else if((Opportunities_Stage == 'None'))
            {
            }
        }
        return opp;

    }
    
    public Contact[] getContactstoDisplay() {
    System.debug('Entering into method' +ContactsActStat);
        List<Contact> contacts = new List<Contact>();
        if(ContactsActStat == 'All')
            return a.Contacts;
        else if(ContactsActStat == 'Active')
        {
            for (Contact c:a.Contacts) {
                //if ((Contacts_ShowInactive) || (c.WV_Contact_Status__c == 'Active'))
                //    {contacts.add(c);}
                if(c.WV_Contact_Status__c == 'Active') {
                    contacts.add(c);
                }
            }
        }
        else if (ContactsActStat == 'Inactive') 
        {
            for (Contact c:a.Contacts) {
            if(c.WV_Contact_Status__c != 'Active') {
                contacts.add(c);
            }
            }
        }    
        else {
            Integer i =  Integer.valueOf(ContactsActStat);
            i = ( i < a.contacts.size())? i : a.contacts.size() ;
            for(integer j=0;j<i;j++)    
                contacts.add(a.contacts[j]);
        }
        System.debug('&****' + ContactsActStat  + '****' +contacts);  
        return contacts;
    }
    
    public Business_Contract__c[] getBusContactstoDisplay() {
        System.debug('Entering into method getBusContactstoDisplay' +BusinessContracts);
        List<Business_Contract__c> contract = new List<Business_Contract__c>();
        if(BusinessContracts == 'All')
            return a.Business_Contracts__r;
        else if(BusinessContracts == 'Active')
        {
            for (Business_Contract__c c:a.Business_Contracts__r) {
                if(c.Status__c == 'Activated') {
                    contract.add(c);
                }
            }
        }
        else
        {
            System.debug('Entering into else'+BusinessContracts);
            for (Business_Contract__c c:a.Business_Contracts__r) {
            if(c.Status__c != 'Activated') {
                contract.add(c);
            }
        }
        } 
        return contract;
    }

    
    
    /* This accessor provides the page with the ordered collection of history (apex) objects for display in the page. 
       it also processes the truncation of case comments as specified by the fullComments property value.*/
    public SCPR_Call_Report[] getCallReports() {
        SCPR_Call_Report[] callReports = new SCPR_Call_Report[]{};
        
        Date BeginDate = System.today().addDays((Integer.valueOf(CallReports_LastXDays) * -1));

        for (Task t:a.tasks) { 
            if (isLogCallType(t.Type)
                && (t.ActivityDate >= BeginDate)
                && (t.ActivityDate <= System.today())
                && (t.Description != null)
                && ((CallReports_LimittoOwner == false) || (a.OwnerId == t.CreatedById)) 
               ) {
                datetime dt = DateTime.newInstance(t.ActivityDate.year(),t.ActivityDate.month(),t.ActivityDate.day(), 0, 0, 0);
                addCallReport(callReports, new SCPR_Call_Report(t.Id, t.CreatedById, t.CreatedBy.Name, dt, t.Subject, truncateValue(t.Description,'CallReports'))); 
            }
        }

        for (Event e:a.events)
             if (e.ActivityDateTime != null)
                { 
                 date ActivityDate = Date.newInstance(e.ActivityDateTime.year(),e.ActivityDateTime.month(),e.ActivityDateTime.day());
                 if (
                       (ActivityDate >= BeginDate)
                    && (ActivityDate <= System.today())
                    && (e.Description != null)
                    && ((CallReports_LimittoOwner == false) || (a.OwnerId == e.CreatedById)) 
                    )
                        { 
                        addCallReport(callReports, new SCPR_Call_Report(e.Id, e.CreatedById, e.CreatedBy.Name, e.ActivityDateTime, e.Subject, truncateValue(e.Description,'CallReports'))); 
                        }
                }

        for (Task t:indirectTasks) { 
            if (isLogCallType(t.Type)
                && (t.ActivityDate >= BeginDate)
                && (t.ActivityDate <= System.today())
                && (t.Description != null)
                && ((CallReports_LimittoOwner == false) || (a.OwnerId == t.CreatedById)) 
               ) {
                datetime dt = DateTime.newInstance(t.ActivityDate.year(),t.ActivityDate.month(),t.ActivityDate.day(), 0, 0, 0);
                addCallReport(callReports, new SCPR_Call_Report(t.Id, t.CreatedById, t.CreatedBy.Name, dt, t.Subject, truncateValue(t.Description,'CallReports'))); 
            }
        }

        for (Event e:indirectEvents)
             if (e.ActivityDateTime != null)
                { 
                 date ActivityDate = Date.newInstance(e.ActivityDateTime.year(),e.ActivityDateTime.month(),e.ActivityDateTime.day());
                 if (
                       (ActivityDate >= BeginDate)
                    && (ActivityDate <= System.today())
                    && (e.Description != null)
                    && ((CallReports_LimittoOwner == false) || (a.OwnerId == e.CreatedById)) 
                    )
                        { 
                        addCallReport(callReports, new SCPR_Call_Report(e.Id, e.CreatedById, e.CreatedBy.Name, e.ActivityDateTime, e.Subject, truncateValue(e.Description,'CallReports'))); 
                        }
                }

        
        return callReports;
    }
    
    /* This method adds the newHistory object to the given histories collection in the appropriate order. 
       The order provided here places the oldest records at the front of the list, i.e. by date ascending. */
    private void addCallReport(SCPR_Call_Report[] callReports, SCPR_Call_Report newCallReport) {
        Integer position = callReports.size();
        for (Integer i = 0; i < callReports.size(); i++) {
            if (newCallReport.CallReportDate > callReports[i].CallReportDate) {
                position = i;
                break;
            }
        }
        
        if (position == callReports.size()) {
            callReports.add(newCallReport);
        } else {
            callReports.add(position, newCallReport);
        }
    }

    public SCPR_Call_Report[] getCall_Reports() {
        SCPR_Call_Report[] call_Reports = new SCPR_Call_Report[]{};
        SCPR_Call_Report scr;
        
        Date beginDate = System.today().addDays((Integer.valueOf(Call_Reports_LastXDays) * -1));
        Date d; 
        String p;
        for (Call_Report__c cr : a.CallReports__r) {
            d = getCallReportDate(cr);
            if (d == null) {d = beginDate;}
            p = getCallPurpose(cr);
            DateTime dt = DateTime.newInstance(d.year(), d.month(), d.day());
            if (d <= System.today() &&
                d >= beginDate &&
               (Call_Reports_LimittoOwner == false || 
                a.OwnerId == cr.CreatedById)
               ) {
                scr = new SCPR_Call_Report(cr.Id, cr.CreatedById, 
                                           cr.CreatedBy.Name, 
                                           dt, cr.Title__c, p,cr.discussion__c);
                addCallReport(call_Reports, scr);
            }
        }

        return call_Reports;
    }
    
    private Date getCallReportDate(Call_Report__c cr) {
        Date d = null;
        if (isDistribution ||
            isPerformanceMaterials ||
            isValvoline) {
            d = cr.Start_Date__c;
        } else if (isWater) {
            d = cr.Date_of_Call__c;
        } else if (isAqualon) {
            d = cr.Date__c;
        }
        return d;
    }
    
    private String getCallPurpose(Call_Report__c cr) {
        String p = cr.Reason_for_Visit__c;
        if (isDistribution) {
            p = cr.Purpose__c; 
        }
        return p;
    }
    
    /* This accessor provides the page with the ordered collection of history (apex) objects for display in the page. 
       it also processes the truncation of case comments as specified by the fullComments property value.*/
   /* public SCPR_Open_Activity[] getOpenActivities() {
        SCPR_Open_Activity[] openActivities = new SCPR_Open_Activity[]{};

        for (Task t:a.tasks) 
            { 
            if (t.Status != 'Completed')
                {
                addOpenActivity(openActivities, new SCPR_Open_Activity(t.Id, t.ActivityDate, t.OwnerId, t.Owner.Name, t.Subject, truncateValue(t.Description,'OpenActivities')));
                }
            }

        for (Task t:indirectTasks) 
            { 
            if (t.Status != 'Completed')
                {
                addOpenActivity(openActivities, new SCPR_Open_Activity(t.Id, t.ActivityDate, t.OwnerId, t.Owner.Name, t.Subject, truncateValue(t.Description,'OpenActivities')));
                }
            }

        return openActivities;
    }*/
    
    public SCPR_Open_Activity[] getOpenActivities() {
        SCPR_Open_Activity[] openActivities = new SCPR_Open_Activity[]{};
        
        Date EndDate = System.today().addDays((Integer.valueOf(OpenActivities_NextXDays) * 1));
        for (OpenActivity opActy:a.OpenActivities) 
            { 
                if(opActy.ActivityDate >= System.today() && opActy.ActivityDate <= EndDate)
                {
                    Date dt = Date.newInstance(opActy.ActivityDate.year(),opActy.ActivityDate.month(),opActy.ActivityDate.day());
                    addOpenActivity(openActivities, new SCPR_Open_Activity(opActy.Id, dt, opActy.OwnerId, opActy.Owner.Name, opActy.Subject, truncateValue(opActy.Description,'OpenActivities'), opActy.WhoId, opActy.Who.Name, opActy.WhatId, opActy.What.Name,opActy.Status));
                    system.debug('OA: ' + opActy);
                }               
            }

        return openActivities;
    }
    
     public list<activityHistory> getcloseActivities() {     
       
        /*list<activityHistory> closeActivities = new list<activityHistory>();    
        List<activityHistory> returncloseactivities = new list<activityHistory>();
        Date EndDate = System.today().addDays((Integer.valueOf(ClosedActivities_NextXDays) * (-1)));
        for (ActivityHistory clActy:closeActivities) 
            { 
                if(clActy.ActivityDate >= System.today() && clActy.ActivityDate <= EndDate)
                {
                   //Date dt = Date.newInstance(clActy.ActivityDate.year(),clActy.ActivityDate.month(),clActy.ActivityDate.day());
                   //addOpenActivity(closedActivities, new SCPR_Open_Activity(clActy.Id, dt, clActy.OwnerId, clActy.Owner.Name, clActy.Subject, truncateValue(clActy.Description,'OpenActivities'), clActy.WhoId, clActy.Who.Name, clActy.WhatId, clActy.What.Name,clActy.Status));
                   returncloseactivities.add(clActy);
                }               
            }
        return a.activityHistories;*/
            
        //list<activityHistory> closeActivities = new list<activityHistory> ();
        List<activityHistory> returncloseactivities = new list<activityHistory>();
       
        Date EndDate = System.today().addDays((Integer.valueOf(ClosedActivities_NextXDays) * (-1)));

        for (ActivityHistory clActy:a.activityHistories ) 
            { 
                if(clActy.ActivityDate <= System.today() && clActy.ActivityDate >= EndDate)
                {
                    returncloseactivities.add(clActy);                   
                }               
            }

                        System.Debug('Render val--->'+renderCA);
            return returncloseactivities;

    }
    
       public list<Open_Orders__c> getOpenOrders() {
            System.debug(LoggingLevel.INFO, 'Open Orders Count : ' + a.Open_Orders_ShipTo__r.size());
            list<Open_Orders__c> open_orders = new list<Open_Orders__c>();
            if (OpenOrders_NextXDays == 'All Open') {
                for(Open_Orders__c tempOpenOrder : a.Open_Orders_ShipTo__r)
                {
                     if(tempOpenOrder.Goods_Issue_Date2__c ==null && tempOpenOrder.Reason_Rejected_Code__c == null  && tempOpenOrder.Reason_Rejected_Desc__c == null)
                        open_orders.add(tempOpenOrder);
                }
            } else {
                Date EndDate = System.today().addDays((Integer.valueOf(OpenOrders_NextXDays) * (1)));
                Date CurrentDate = System.today();
                for(Open_Orders__c tempOpenOrder : a.Open_Orders_ShipTo__r)
                {
                     if(tempOpenOrder.Requested_Delivery_Date2__c > System.Today() && tempOpenOrder.Requested_Delivery_Date2__c < Enddate && tempOpenOrder .Goods_Issue_Date2__c ==null && tempOpenOrder.Reason_Rejected_Code__c == null  && tempOpenOrder.Reason_Rejected_Desc__c == null)
                        open_orders.add(tempOpenOrder);
                }
            }
            return open_orders ;
       }
       
       public list<Open_Orders__c> getOrderHistorytoDisplay() {
            list<Open_Orders__c> OrderHistoryList = new list<Open_Orders__c>();
            if (OrderHistory == 'All') {
                for(Open_Orders__c tempOpenOrder : a.Open_Orders_ShipTo__r)
                {
                    if(tempOpenOrder .Goods_Issue_Date2__c !=null || tempOpenOrder.Reason_Rejected_Code__c != null  || tempOpenOrder.Reason_Rejected_Desc__c != null)
                    OrderHistoryList.add(tempOpenOrder);
                }
            } else {
                Date EndDate =  System.today().addDays((Integer.valueOf(OrderHistory) * (-1)));
                Date CurrentDate = System.today();
                for(Open_Orders__c tempOpenOrder : a.Open_Orders_ShipTo__r)
                {
                    if(tempOpenOrder.Requested_Delivery_Date2__c < System.Today() && tempOpenOrder.Requested_Delivery_Date2__c > Enddate && (tempOpenOrder .Goods_Issue_Date2__c !=null || tempOpenOrder.Reason_Rejected_Code__c != null  || tempOpenOrder.Reason_Rejected_Desc__c != null))                        
                    OrderHistoryList.add(tempOpenOrder);
                }
            }
            return OrderHistoryList;
       } 
        
        public list<Sample_Request__c> getSampleRequest() {
            list<Sample_Request__c> sample_request = new list<Sample_Request__c>();
            Date EndDate = System.today().addDays((Integer.valueOf(SampleRequest_lastXdays) * (-1)));
            Date CurrentDate = System.today();
            for(Sample_Request__c tempsamplerequest : a.SampleRequest_to_Account__r)
            {
                date createddate = Date.newInstance(tempsamplerequest.CreatedDAte.year(),tempsamplerequest.CreatedDAte.month(),tempsamplerequest.CreatedDAte.day());
                if(createddate  < System.Today() && createddate > Enddate)
                    sample_request.add(tempsamplerequest );
            }
                       // open_orders = [Select id,ShipTo_Desc__c,Material__c,Ordered_Qty__c,Requested_Delivery_Date2__c,Expected_Ship_Date2__c,Created_Date2__c,Customer_PO_Number__c from Open_Orders__c where shipto__c =: a.id and Requested_Delivery_Date2__c < :Enddate and Requested_Delivery_Date2__c >:CurrentDate];
            return sample_request;
        }
        
    
    private void addOpenActivity(SCPR_Open_Activity[] openActivities, SCPR_Open_Activity newOpenActivity) {
        Integer position = openActivities.size();
        for (Integer i = 0; i < openActivities.size(); i++) {
            if (newOpenActivity.ActivityDate > openActivities[i].ActivityDate) {
                position = i;
                break;
            }
        }
        
        if (position == openActivities.size()) {
            openActivities.add(newOpenActivity);
        } else {
            openActivities.add(position, newOpenActivity);
        }
    }

        
    /* Returns the truncated string value if that is specified in the current state (!fullComments)
       and the current length is greater than the value of the private truncatedCommentLength property. */
    private String truncateValue(String s, String valueType) {
        
        Boolean fullComments = false;
        
        if (valueType == 'OpenActivities') {fullComments = OpenActivities_FullComments;}
        if (valueType == 'CallReports') {fullComments = CallReports_FullComments;}
        
        if (s != null)
            {
            if (!fullComments && s.length() > truncatedCommentLength) 
                {
                s = s.substring(0,truncatedCommentLength) + '...';
                }
            }
        
        return s;
    }
    
    /* The ID value of the case that will be used by the getCase() method to query for the related
       objects used to generate the ordered history collection. The value will be based on the request 
       parameter, if available. */
    private Id accountId { 
        get {
            
            system.debug('acct.Id = ' + acct.id);
            system.debug('getparameters accountId = ' + ApexPages.currentPage().getparameters().get('accountId'));
            
            if (acct.Id==null)
                {
                if(ApexPages.currentPage().getparameters().get('accountId') != null) 
                    {
                    return ApexPages.currentPage().getparameters().get('accountId');
                    }
                else {return null;}
                }
            else
                {
                return acct.Id;
                }
        }
        set; 
//        { 
//            if(value != null) accountId = value;
//        }
    }
    
    /* The case object set by the getCase method and used by the getHistories method to acquire
       the related records.  */
    private Account a { 
        get { return getAccount(); }
//        get { return acct; }
        set; 
    }
    
    /* The length of "Short Comments" which is used by the truncateValue method in this class to
       truncate case comments when specified by the user. */
    private Integer truncatedCommentLength { get; set; }
    
    
    Boolean isCustomer = null;
    Boolean isProspect = null;

    public void determineAccountType() {
        String AccountType = '';
        isCustomer = false;
        isProspect = false;
        
        AccountType = RecordType_Relationship_Functions.GetAccountType_Based_on_AccountRecordTypeId(a.recordTypeId);
        
        if (AccountType == 'Customer') isCustomer = true;
        if (AccountType == 'Prospect') isProspect = true;
    }

    public Boolean getisCustomer() {
        if(isCustomer==null) {determineAccountType();}
        return isCustomer;
    }

    public Boolean getisProspect() {
        if(isProspect==null) {determineAccountType();}
        return isProspect;
    }

/*
    public void determineBusinessType() {
        String BusinessType = '';

        isDistribution = false;
        isPerformanceMaterials = false;
        isValvoline = false;
        isWater = false;

        BusinessType = RecordType_Relationship_Functions.GetBusinessType_Based_on_AccountRecordTypeId(a.recordTypeId);
        if (BusinessType == 'Distribution') isDistribution = true;
        if (BusinessType == 'Performance Materials') isPerformanceMaterials = true;
        if (BusinessType == 'Valvoline') isValvoline = true;
        if (BusinessType == 'Water') isWater = true;
    }

    public Boolean getisDistribution() {
        if (isDistribution == null) {determineBusinessType();}
        return isDistribution;
    }

    public Boolean getisPerformanceMaterials() {
        if (isPerformanceMaterials == null) {determineBusinessType();}
        return isPerformanceMaterials;
    }

    public Boolean getisValvoline() {
        if (isValvoline == null) {determineBusinessType();}
        return isValvoline;
    }

    public Boolean getisWater() {
        if (isWater == null) {determineBusinessType();}
        return isWater;
    }
    
*/
    public String getAccountAddress() {

        String AccountAddress = '';     

        List <String> addressLines = new List <String>();
        addressLines.add(a.SAP_Street__c);
        addressLines.add(a.SAP_StreetSuppl1__c);
        addressLines.add(a.SAP_StreetSuppl2__c);
        addressLines.add(a.SAP_StreetSuppl3__c);
          
        AccountAddress = Address_Functions.FormatAddressforWebDisplay(addressLines,
                                                                      a.SAP_City__c,
                                                                      a.SAP_State__c,
                                                                      a.SAP_Zip_Code__c,
                                                                      a.SAP_Country__c);
                                                                      
        return AccountAddress;
                                                                            
    }



    public String getAccountDetailSection_Header() {
        String result = '';
        
        result = 'for ';
        
        if (a.Type == 'Customer')
            {result += a.SAP_Customer_Number__c;}
        else
            {result += a.CIS_Prospect_Number__c;}
        
        result += ' - ' + a.Name;
            
        return result;  
    }
    
    public List<SelectOption> getStatus(){
        List<SelectOption> status = new List<SelectOption>();
        status.add(new SelectOption('All','All'));
        status.add(new SelectOption('Expired','Expired'));
        status.add(new SelectOption('Not Expired','Not Expired'));
        return status;
    }
    
    public PageReference sortByName(){
        isSortByName = true;
        isSortByStatus  = false;
        countStatus = 0;
        if(math.mod(countName,2)==0)
            if(selectedStatus=='All')
                conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds ORDER BY Name];
            else if(selectedStatus=='Expired')
                conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status = 'Expired' ORDER BY Name];
            else if(selectedStatus=='Not Expired')
                conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and status <> 'Expired' ORDER BY Name];
            
        if(math.mod(countName,2)==1)
            if(selectedStatus=='All')
                conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds ORDER BY Name desc];
            else if(selectedStatus=='Expired')
                conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status = 'Expired' ORDER BY Name desc];
            else if(selectedStatus=='Not Expired')
                conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status <> 'Expired' ORDER BY Name desc];
        
        countName++;
        return null;
    }
    
    public PageReference sortByStatus(){
        isSortByStatus = true;
        isSortByName = false;
        countName = 0;
        if(math.mod(countStatus,2)==0)
            if(selectedStatus=='All')
                conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds ORDER BY Status];
            else if(selectedStatus=='Expired')
                conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status = 'Expired' ORDER BY Status];
            else if(selectedStatus=='Not Expired')
                conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status <> 'Expired' ORDER BY Status];
        
        if(math.mod(countStatus,2)==1)
            if(selectedStatus=='All')
                conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds ORDER BY Status desc];
            else if(selectedStatus=='Expired')
                conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status = 'Expired' ORDER BY Status desc];
            else if(selectedStatus=='Not Expired')
                conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status <> 'Expired' ORDER BY Status desc];
        countStatus++;
        return null;
    }
    
    public PageReference filterByStatus(){
        countName = 0;
        countStatus = 0;
        isSortByStatus = false;
        isSortByName = false;
        if(selectedStatus=='All')
            conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds ORDER BY EndDate desc];
        else if(selectedStatus=='Expired')
            conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status='Expired' ORDER BY EndDate desc];
        else if(selectedStatus=='Not Expired')
            conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status <> 'Expired' ORDER BY EndDate desc];
        return null;
    }


//******************
//Test Method 
//******************

    @isTest static void TestMe() {
        Account testAcct = new Account(Name='TestAccount');
        insert testAcct;
    
        Id contractRecordTypeId = RecordType_Functions.LookupRecordTypeId('CDF','Contract');
        
        try {
            testAcct = [SELECT Id, Name,SAP_Industry_Key_Desc__c, SAP_Customer_Number__c, CIS_Prospect_Number__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_StreetSuppl3__c, 
                       SAP_City__c, SAP_State__c, SAP_Zip_Code__c, SAP_Country__c, OwnerID, Owner.Name, RecordTypeId, RecordType.Name, Type, SAP_Sales_Org__c,
                       (SELECT Id, Salutation, FirstName, LastName, WV_Contact_Status__c, Title, Phone, Fax, Email, OwnerId, Owner.Name, CreatedDate FROM Contacts ORDER BY LastName ASC, FirstName ASC, CreatedDate DESC),
                       (SELECT Id, Subject, ActivityDate, Description, Status, Type, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Tasks ORDER BY ActivityDate DESC limit :LIMIT_30),
                       (SELECT Id, StartDateTime, EndDateTime, ActivityDateTime, Subject, Description, Type, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Events WHERE IsChild = false ORDER BY StartDateTime DESC),
                       (SELECT Id, Name, Amount, Probability, Competition__c, Target_Price__c, CloseDate, StageName, CurrencyIsoCode, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Opportunities ORDER BY CloseDate DESC),
                       (SELECT Id, Subject, OwnerId, Owner.Name, ActivityDate, Status, WhoId, Who.Name, WhatId, What.Name, Description from OpenActivities),
                       (SELECT Id, Subject, OwnerId, Owner.Name, ActivityDate, Status, WhoId, Who.Name, WhatId, What.Name, Description from ActivityHistories limit :LIMIT_30),
                       (SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contracts WHERE RecordTypeId = :contractRecordTypeId ORDER BY EndDate DESC),
                       (SELECT Id, Name, Material_Summary__c , Material__r.Name, Status__c, CreatedDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM SampleRequest_to_Account__r WHERE Sample_State__c = 'Active'),
                       (SELECT Id, Name, SAP_Material__c, distribution_volume__c, direct_volume__c, Material__c, Status__c, CreatedDate, Annual_Usage_Volume__c, Product_Group_FAMILY__c, Market__c, Technology__c, Annual_Usage_T_Y__c, Annual_Volume__c, Unit_of_Measure__c, Current_Supplier_Producer__c, CreatedById, CreatedBy.Name FROM Consumptions__r WHERE Status__c = 'Active' ORDER BY Material__c DESC),
                       (SELECT Id, Name, CreatedById, CreatedBy.Name, Title__c, Reason_for_Visit__c, Date__c, Date_of_Call__c, Start_Date__c, End_Date__c, Discussion__C from CallReports__r),
                       (Select id, ShipTo_Desc__c, Material__c, Ordered_Qty__c, Goods_Issue_Date2__c, Reason_Rejected_Code__c, Reason_Rejected_Desc__c, Requested_Delivery_Date2__c, Expected_Ship_Date2__c, Created_Date2__c, Customer_PO_Number__c, Sales_Order_Number__c from Open_Orders_ShipTo__r ORDER BY Material__c DESC),
                       (select id, Name, Customer_Name__r.name, Contract_Type__c, Effective_Date__c, Expiration_Date__c, Comments__c, Status__c from Business_Contracts__r)
                    FROM Account  limit 1];
        } catch(Exception e) {}
        
        if (testAcct == null) {return;} 
        
        //apexpages.currentpage().getparameters().put('fid', '00lP0000000QrJC');
        Contact testContact = new Contact();
        testContact.Lastname = 'Test';
        testContact.WV_Contact_Status__c = 'Active';
        testContact.AccountId = testAcct.id;
        insert testContact;
        
        Contact testContact2 = new Contact();
        testContact2.Lastname = 'Test 2';
        testContact2.WV_Contact_Status__c = 'Inactive';
        testContact2.AccountId = testAcct.id;
        insert testContact2;

        Task testTask = new Task();
        testTask.Whatid = testAcct.Id;
        testTask.Type = 'Email';
        testTask.Description = 'Test';
        testTask.ActivityDate = System.today();
        insert testTask;

        Date Yesterday = System.today().addDays(-1);

        Task testTask2 = new Task();
        testTask2.Whatid = testAcct.Id;
        testTask2.Type = 'Email';
        testTask2.Description = 'Test';
        testTask2.ActivityDate = Yesterday;
        insert testTask2;

        Date Tomorrow = System.today().addDays(-1);

        Task testTask3 = new Task();
        testTask3.Whatid = testAcct.Id;
        testTask3.Type = 'Email';
        testTask3.Description = 'Test';
        testTask3.ActivityDate = Tomorrow;
        insert testTask3;

        Event testEvent = new Event();
        testEvent.Whatid = testAcct.Id;
        testEvent.Type = 'Email';
        testEvent.Total_Hours__c = 1;
        testEvent.DurationInMinutes = 59;
        testEvent.ActivityDateTime = DateTime.newInstance(System.today().year(),System.today().month(),System.today().day(), 0, 0, 0);
        testEvent.StartDateTime = DateTime.newInstance(System.today().year(),System.today().month(),System.today().day(), 0, 0, 0);
        testEvent.EndDateTime = DateTime.newInstance(System.today().year(),System.today().month(),System.today().day(), 0, 59, 0);
        testEvent.Description = 'Test';
        insert testEvent;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testAcct);
        SCPR cls = new SCPR(sc);
//      SCPR cls = new SCPR();
        
        String testString = '';
        
        cls.Contacts_ShowInactive = false; 
        testString = cls.getContacts_Desc();        

        cls.Contacts_ShowInactive = true; 
        testString = cls.getContacts_Desc();    
        
        testString = cls.getOpenActivities_Desc();
        
        testString = cls.getCallReports_Desc();
        
        testString = cls.getOppStage_Desc();
        
        testString = cls.getCDFStatus_Desc();

        cls.toggleContacts_ShowInactive();
        cls.toggleOpenActivities_FullComments();
        cls.toggleCallReports_FullComments();
        cls.toggleCallReports_LimittoOwner();

        testString = cls.getCallReports_Desc(); 
        
        PageReference testPageReference1 = cls.backToAccount();
        PageReference testPageReference2 = cls.Printable_View();
        PageReference testPageReference3 = cls.sortByName();
        PageReference testPageReference4 = cls.sortByStatus();
        PageReference testPageReference5 = cls.filterByStatus();
 

        cls.toggleCallReports_LimittoOwner();
        
        List<SelectOption> testSelectOption1 = cls.getCallReports_LastXDays_items();
        
        List<SelectOption> testSelectOption2 = cls.getOpportunities_Stage_items();
        
        List<SelectOption> testSelectOption3 = cls.getOpenActivities_NextXDays_items();
        
        List<SelectOption> testSelectOption4 = cls.getStatus();
        
        Account testAcct2 = cls.getAccount();
        
        Integer testInt;
        testInt = cls.getContacts_Count();
        testInt = cls.getOpportunities_Count();
        testInt = cls.getContracts_Count();
        testInt = cls.getInactiveContacts_Count();
        testInt = cls.getSample_Requests_Count();
        testInt = cls.getConsumption_Count();

        cls.CallReports_LimittoOwner = false;
        
        List<Opportunity> testOpp = cls.getOpportunities();
        
        Contact[] testContacts = cls.getContactstoDisplay();
        SCPR_Call_Report[] testCallReports = cls.getCallReports();
        SCPR_Open_Activity[] testOpenActivities = cls.getOpenActivities();
  
        Boolean testBoolean = cls.getisCustomer();
        testBoolean = cls.getisProspect();
        
        testString = cls.getAccountAddress();
        testString = cls.getAccountDetailSection_Header();

        cls.getcloseActivities();
        cls.getOpenOrders();
        cls.getBusContactstoDisplay();
        cls.getAccountSummaryInformation();
        cls.getFYTDvsPFYTD_Amount_Down();
        cls.getFYTDvsPFYTD_Amount_Up();
        cls.getFYTDvsPFYTD_GM_Down();
        cls.getFYTDvsPFYTD_GM_Up();
        cls.getFYTDvsPFYTD_GMpct_Down();
        cls.getFYTDvsPFYTD_GMpct_Up();
        cls.getFYTDvsPFYTD_Volume_in_KG_Down();
        cls.getFYTDvsPFYTD_Volume_in_KG_Up();
        cls.getFYTDvsPFYTD_Volume_in_LB_Down();
        cls.getFYTDvsPFYTD_Volume_in_LB_Up();
        cls.printable_view();

        cls.Activities_Desc();
        cls.getOpenOrder_Desc();
        cls.getOrderHistory_desc();
        cls.getSampleRequest_Desc();
        cls.getCnct_desc();
        cls.getClosedActivities_Desc();
        cls.rerenderSR();
        cls.rerendercon();
        cls.rerenderbuscon();
        cls.rerenderOA();
        cls.rerenderCA();
        cls.rerenderCL();
        cls.rerenderOpp();
        cls.rerenderCR();
        cls.rerenderOO();
        cls.rerenderOH();
        cls.getOpenOrders_NextXDays_items();
        
        cls.getSampleRequest();
        cls.getBusinessContracts_Items();
        cls.getorderhistory_items();
        cls.getCallReports_count();
        cls.getCall_reports_Count();
        cls.getCall_Reports();
        cls.getClosedActivities_NextXDays_Items();
        cls.getCall_Reports_LastXDays_items();
        cls.getOrderHistory_Items();
        cls.getSampleRequest_LastXDays_Items();
        cls.getContactsActStat_Items();
        
    }

}
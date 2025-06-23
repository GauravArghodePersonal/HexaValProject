public with sharing class VI_Run_VEM_Report_Form_Extension {

    /*******************************
     * Public Vars
     *******************************/

    /* Object Holders */
    public VI_Enrollment_Location__c enrollmentLocation;
    public Account primaryAccount;

    /* Properties for Input Form */

    //Parameters used to generate URL
    public String ReportType { get; set; }
    public String PromotionCode { get; set; }
    public String InstallerStore { get; set; }
    public String AcctNo { get; set; }
    public String ParentAcctNo { get; set; }
    public String CustGrp5 { get; set; }
    public String FullSynOCPrice { get; set; }
    public String SemiSynOCPrice { get; set; }
    public String ConvOCPrice { get; set; }
    public String IssuanceRate { get; set; }
    public String PremiumMix { get; set; }
    public String UpsoldPct { get; set; }
    public String LoyaltyRate { get; set; }
    public String PayTicket { get; set; }
    public String GPperTicket { get; set; }
    public String LubricantVol { get; set; }
    public String ConvMix { get; set; }
    public String SemiSynMix { get; set; }
    public String SynMix { get; set; }
    public String ConvCost { get; set; }
    public String SemiSynCost { get; set; }
    public String SynCost { get; set; }


    //Display Values for Header of Form
    public String promotionId { get; set; }
    public String promotionDesc { get; set; }

    public String installerStoreId { get; set; }
    public String installerStoreDesc { get; set; }

    public String SAPAccountId { get; set; }
    public String SAPAccountDesc { get; set; }

    public String InstallerDataId { get; set; }
    public String serviceProviderProfileId{ get; set; }

    public String parentAccountId { get; set; }
    public String parentAccountDesc { get; set; }

    //Interface Properties
    public Boolean showProspectInput { get; set; }
    public Boolean reportViewerVisible { get; set; }
    String tabInFocus = System.currentPageReference().getParameters().get('tab');
    public String reportViewerURL { get; set; }
    public Boolean reportTypeAccountNumberEnabled { get; set; }
    public Boolean reportTypeParentAccountEnabled { get; set; }
    public Boolean reportTypeSAPCustomerGroup5DescEnabled { get; set; }
    //Custom Getters and Setters

    private void debug(String s) {System.debug(LoggingLevel.INFO, s);}

    //Radio Button Values
    public List<SelectOption> getReportTypes() {
        List<SelectOption> options = new List<SelectOption>();
        if (reportTypeAccountNumberEnabled == true) {options.add(new SelectOption('AcctNo','Account Number'));}
        if (reportTypeParentAccountEnabled == true) {options.add(new SelectOption('ParentAcctNo','Parent Account'));}
        if (reportTypeSAPCustomerGroup5DescEnabled == true) {options.add(new SelectOption('CustGrp5','SAP Customer Group 5 Desc'));}
        return options;
    }

    public Boolean getPromotionExists() {
        return (PromotionCode != '' && PromotionCode != null);
    }

    public Boolean getInstallerStoreExists() {
        return (InstallerStore != '' && InstallerStore != null);
    }

    public Boolean getSAPAccountExists() {
        return (AcctNo != '' && AcctNo != null);
    }

    public Boolean getParentAccountExists() {
        return (ParentAcctNo != '' && ParentAcctNo != null);
    }

    public Boolean getSAPCustomerGroup5DescExists() {
        return (CustGrp5 != '' && CustGrp5 != null);
    }

    public Boolean getInsideIntranet() {
        if (getUserName() == 'jhkeener@ashland.com.prod.qa') {return true;}
        if (getUserName() == 'ghill@ashland.com') {return true;}

        if (User_Functions.isIntranetIP()) {return true;}

        return false;
    }

    public Boolean getOutsideIntranet() {
        if (getUserName() == 'solenissfdcsupport@solenis.com') {return true;}
        if (getUserName() == 'ghill@ashland.com') {return true;}

        if (User_Functions.isIntranetIP()) {return false;}

        return true;
    }

    public String getUserIPAddress() {
        Map<String,String> headerInfo = ApexPages.currentPage().getHeaders();
        String userIP = headerInfo.get('X-Salesforce-SIP');
        return userIP;
    }

    public String getUserName() {
        String userName = UserInfo.getUserName();
        return userName;
    }

    public String getTabInFocus() {
        return tabInFocus;
    }

    public void setTabInFocus( String s ) {
        this.tabInFocus = s;
    }

    /*******************************
     * Class Controller
     *******************************/

    public VI_Run_VEM_Report_Form_Extension(ApexPages.StandardSetController controller) {
    }

    public VI_Run_VEM_Report_Form_Extension(ApexPages.StandardController controller) {
        //Retrieve Current Record
        enrollmentLocation = (VI_Enrollment_Location__c)Controller.getRecord();
    }

    /*******************************
     * Initialize Functions
     *******************************/

    public void InitializeForm() {
        clearFormFields();
        queryRelevantData();
        populateFormFields();
        processInstallerDataData();
        initializeFormParameters();
    }

    private void clearFormFields() {
        //Initialize Input Fields
        ReportType = '';
        PromotionCode = '';
        InstallerStore = '';
        AcctNo = '';
        ParentAcctNo = '';
        CustGrp5 = '';
        FullSynOCPrice = '';
        SemiSynOCPrice = '';
        ConvOCPrice = '';
        IssuanceRate = '';
        PremiumMix = '';
        UpsoldPct = '';
        LoyaltyRate = '';
        PayTicket = '';
        GPperTicket = '';
        LubricantVol = '';
        ConvMix = '';
        SemiSynMix = '';
        SynMix = '';
        ConvCost = '';
        SemiSynCost = '';
        SynCost = '';

        reportViewerURL = '';
        parentAccountId = '';
    }

    private void queryRelevantData() {
        //Query Data
        enrollmentLocation = [SELECT id,
                                     Program_Code__c,
                                     Facility__c,
                                     Facility__r.AccountNumber,
                                     Facility__r.Name,
                                     Location__c,
                                     Location__r.AccountNumber,
                                     Location__r.Name,
                                     Promotion__c,
                                     Promotion__r.Id,
                                     Promotion__r.Program_Code__c,
                                     Promotion__r.Name,
                                     Promotion__r.Start_Date__c,
                                     Promotion__r.End_Date__c
                                FROM VI_Enrollment_Location__c
                               WHERE id = :enrollmentLocation.id
                               LIMIT 1];

        primaryAccount = [SELECT id,
                                 Name,
                                 ParentId,
                                 Parent.AccountNumber,
                                 Parent.Name,
                                 SAP_Customer_Group_5_Desc__c
                            FROM Account
                           WHERE Id = :enrollmentLocation.Facility__c];
    }

    private void initializeFormParameters() {
        //Initialize Form Parameters
        tabInFocus = 'reportParameterEntry';
        reportViewerVisible = false;
        updateShowProspectInput();

        if (CustGrp5 != '') {reportTypeSAPCustomerGroup5DescEnabled = true;ReportType = 'CustGrp5';}
        if (ParentAcctNo != '') {reportTypeParentAccountEnabled = true;ReportType = 'ParentAcctNo';}
        if (AcctNo != '') {reportTypeAccountNumberEnabled = true;ReportType = 'AcctNo';}
    }

    private void populateFormFields() {
        //Populate Form Fields
        if (enrollmentLocation.Location__c != null)
        {
            installerStoreId = enrollmentLocation.Location__c;
            installerStoreId = installerStoreId.substring(0,15);
            InstallerStore = enrollmentLocation.Location__r.AccountNumber;
            installerStoreDesc = enrollmentLocation.Location__r.Name + ' (' + enrollmentLocation.Location__r.AccountNumber + ')';
        }

        if (enrollmentLocation.Location__c != null)
        {
            SAPAccountId = enrollmentLocation.Facility__c;
            SAPAccountId = SAPAccountId.substring(0,15);
            AcctNo = enrollmentLocation.Facility__r.AccountNumber;
            SAPAccountDesc = enrollmentLocation.Facility__r.Name + ' (' + enrollmentLocation.Facility__r.AccountNumber + ')';
        }

        if (enrollmentLocation.Promotion__c != null)
        {
            promotionId = enrollmentLocation.Promotion__c;
            promotionId = promotionId.substring(0,15);
            PromotionCode = enrollmentLocation.Program_Code__c;
            promotionDesc = enrollmentLocation.Promotion__r.Name + ' (' + enrollmentLocation.Promotion__r.Program_Code__c + ')';
        }

        if (primaryAccount != null)
        {
            ParentAcctNo = primaryAccount.Parent.AccountNumber;
            parentAccountId = primaryAccount.ParentId;
            parentAccountDesc = primaryAccount.Parent.Name + ' (' + primaryAccount.Parent.AccountNumber + ')';
            CustGrp5 = primaryAccount.SAP_Customer_Group_5_Desc__c;
        }
    }

    private void processInstallerDataData() {
        //Attempt to Query InstallerData Data
        List<String> InstallerDataAccounts = new List<String>();
        InstallerDataAccounts.add(SAPAccountId);

        List<String> questionNames = new List<String>();
        questionNames.add('FullSyntheticOilChange');
        questionNames.add('SyntheticBlendOilChange');
        questionNames.add('ConventionalOilChange');
        date InstallerDataDate = enrollmentLocation.Promotion__r.Start_Date__c;

        List<Service_Profile__c> InstallerDataAnswers = new List<Service_Profile__c>();

        try {
            InstallerDataAnswers = [SELECT Id, Installer_Data_Id__c, Service_Provider_Profile__r.Id, QuestionName__c, Retail_Price__c, Effective_Date__c,  Expiry_Date__c
                                  FROM Service_Profile__c
                                 WHERE Related_Account_Id__c IN :InstallerDataAccounts
                                   AND QuestionName__c IN :questionNames
                                   AND Effective_Date__c <= :InstallerDataDate
                                   AND Expiry_Date__c >= :InstallerDataDate
                               ];
        } catch (Exception e) {}

        if (InstallerDataAnswers != null)
        {
            for (Service_Profile__c InstallerDataAnswer : InstallerDataAnswers)
            {
                if (InstallerDataAnswer.QuestionName__c == 'FullSyntheticOilChange') {FullSynOCPrice = InstallerDataAnswer.Retail_Price__c.toPlainString();}
                if (InstallerDataAnswer.QuestionName__c == 'SyntheticBlendOilChange') {SemiSynOCPrice  = InstallerDataAnswer.Retail_Price__c.toPlainString();}
                if (InstallerDataAnswer.QuestionName__c == 'ConventionalOilChange') {ConvOCPrice = InstallerDataAnswer.Retail_Price__c.toPlainString();}
                InstallerDataId = InstallerDataAnswer.Installer_Data_Id__c;
                serviceProviderProfileId = InstallerDataAnswer.Service_Provider_Profile__r.Id;
            }
        }
    }

    /*******************************
     * Public Action Functions
     *******************************/

    public void runVIPromotionInstallerDataReport() {
        reportViewerURL = generatePromotionInstallerDataURL();
        this.tabInFocus = 'reportViewer';
        reportViewerVisible = true;

        debug(' *****Current Selected tab is :' + TabInFocus);
    }

    public void updateShowProspectInput() {
        if (AcctNo.startsWith('P'))
        {
            showProspectInput = true;
        }
        else
        {
            showProspectInput = false;
        }
    }

    /* URL Generator Code */
    public String generatePromotionInstallerDataURL() {
        String url = '';

        CognosConfig__c cognosConfig = CognosConfig__c.getInstance('config');
        String urlStart = cognosConfig.Cognos_URL_Prefix__c;

        //String urlStart = 'http://reportnet-qa.asco.ashland.com/c84/cgi-bin/cognosisapi.dll';
        String param_CAMNamespace = 'CAMNamespace=';
        String param_b_action = 'b_action=';
        String param_ui_action = 'ui.action=';
        String param_ui_object = 'ui.object=';
        String param_ui_name = 'ui.name=';
        String param_run_outputFormat = 'run.outputFormat=';
        String param_run_prompt = 'run.prompt=';

        String param_ReportType = 'p_ReportType=';
        String param_PromotionCode = 'p_PromotionCode=';
        String param_InstallerStore = 'p_InstallerStore=';
        String param_AcctNo = 'p_AcctNo=';
        String param_ParentAcctNo = 'p_ParentAcctNo=';
        String param_CustGrp5 = 'p_CustGrp5=';
        String param_FullSynOCPrice = 'p_FullSynOCPrice=';
        String param_SemiSynOCPrice = 'p_SemiSynOCPrice=';
        String param_ConvOCPrice = 'p_ConvOCPrice=';
        String param_IssuanceRate = 'p_IssuanceRate=';
        String param_PremiumMix = 'p_PremiumMix=';
        String param_UpsoldPct = 'p_UpsoldPct=';
        String param_LoyaltyRate = 'p_LoyaltyRate=';
        String param_PayTicket = 'p_PayTicket=';
        String param_GPperTicket = 'p_GPperTicket=';
        String param_LubricantVol = 'p_LubricantVol=';
        String param_ConvMix = 'p_ConvMix=';
        String param_SemiSynMix = 'p_SemiSynMix=';
        String param_SynMix = 'p_SynMix=';
        String param_ConvCost = 'p_ConvCost=';
        String param_SemiSynCost = 'p_SemiSynCost=';
        String param_SynCost = 'p_SynCost=';

        url = urlStart;
        url += '?';
        url += param_CAMNamespace + 'Ashland' + '&';
        url += param_b_action + 'cognosViewer' + '&';
        url += param_ui_action + 'run' + '&';
        url += param_ui_object + '%2fcontent%2fpackage%5b%40name%3d%27VEM%20Installer%20Promotions%27%5d%2freport%5b%40name%3d%27Promotion%20Scorecard%27%5d' + '&';
        url += param_ui_name + 'Promotion%20Scorecard' + '&';
        url += param_run_outputFormat + 'PDF' + '&';
        url += param_run_prompt + 'false';

        if (ReportType != '' && ReportType != null) {url += '&' + param_ReportType + EncodingUtil.urlEncode(ReportType,'UTF-8');}
        if (PromotionCode != '' && PromotionCode != null) {url += '&' + param_PromotionCode + EncodingUtil.urlEncode(PromotionCode,'UTF-8');}
        if (InstallerStore != '' && InstallerStore != null) {url += '&' + param_InstallerStore + EncodingUtil.urlEncode(InstallerStore,'UTF-8');}
        if (AcctNo != '' && AcctNo != null) {url += '&' + param_AcctNo + EncodingUtil.urlEncode(AcctNo,'UTF-8');}
        if (ParentAcctNo != '' && ParentAcctNo != null) {url += '&' + param_ParentAcctNo + EncodingUtil.urlEncode(ParentAcctNo,'UTF-8');}
        if (CustGrp5 != '' && CustGrp5 != null) {url += '&' + param_CustGrp5 + EncodingUtil.urlEncode(CustGrp5,'UTF-8');}
        if (FullSynOCPrice != '' && FullSynOCPrice != null) {url += '&' + param_FullSynOCPrice + EncodingUtil.urlEncode(FullSynOCPrice,'UTF-8');}
        if (SemiSynOCPrice != '' && SemiSynOCPrice != null) {url += '&' + param_SemiSynOCPrice + EncodingUtil.urlEncode(SemiSynOCPrice,'UTF-8');}
        if (ConvOCPrice != '' && ConvOCPrice != null) {url += '&' + param_ConvOCPrice + EncodingUtil.urlEncode(ConvOCPrice,'UTF-8');}
        if (IssuanceRate != '' && IssuanceRate != null) {url += '&' + param_IssuanceRate + EncodingUtil.urlEncode(IssuanceRate,'UTF-8');}
        if (PremiumMix != '' && PremiumMix != null) {url += '&' + param_PremiumMix + EncodingUtil.urlEncode(PremiumMix,'UTF-8');}
        if (UpsoldPct != '' && UpsoldPct != null) {url += '&' + param_UpsoldPct + EncodingUtil.urlEncode(UpsoldPct,'UTF-8');}
        if (LoyaltyRate != '' && LoyaltyRate != null) {url += '&' + param_LoyaltyRate + EncodingUtil.urlEncode(LoyaltyRate,'UTF-8');}
        if (PayTicket != '' && PayTicket != null) {url += '&' + param_PayTicket + EncodingUtil.urlEncode(PayTicket,'UTF-8');}
        if (GPperTicket != '' && GPperTicket != null) {url += '&' + param_GPperTicket + EncodingUtil.urlEncode(GPperTicket,'UTF-8');}
        if (LubricantVol != '' && LubricantVol != null) {url += '&' + param_LubricantVol + EncodingUtil.urlEncode(LubricantVol,'UTF-8');}
        if (ConvMix != '' && ConvMix != null) {url += '&' + param_ConvMix + EncodingUtil.urlEncode(ConvMix,'UTF-8');}
        if (SemiSynMix != '' && SemiSynMix != null) {url += '&' + param_SemiSynMix + EncodingUtil.urlEncode(SemiSynMix,'UTF-8');}
        if (SynMix != '' && SynMix != null) {url += '&' + param_SynMix + EncodingUtil.urlEncode(SynMix,'UTF-8');}
        if (ConvCost != '' && ConvCost != null) {url += '&' + param_ConvCost + EncodingUtil.urlEncode(ConvCost,'UTF-8');}
        if (SemiSynCost != '' && SemiSynCost != null) {url += '&' + param_SemiSynCost + EncodingUtil.urlEncode(SemiSynCost,'UTF-8');}
        if (SynCost != '' && SynCost != null) {url += '&' + param_SynCost + EncodingUtil.urlEncode(SynCost,'UTF-8');}

        debug('GENERATED COGNOS URL:' + url);

        return url;
    }
}
public with sharing class VI_VEM_Report_Controller {

    public String forecastRedem            {get; set;}
    public String loyaltyRate              {get; set;}
    public String avgTicket                {get; set;}
    public String grossProfit              {get; set;}
    
    public String ReportType               {get; set;}
    public String promoCode                {get; set;}
    public String location                 {get; set;}
    public String AcctNo                   {get; set;}
    public String distributor              {get; set;}
    public String CustGrp5                 {get; set;}

    public String productCatgry            {get; set;}
    public String promotionId              {get; set;}
    public String promotionDesc            {get; set;}
    
    public String locationId               {get; set;}
    public String locationDesc             {get; set;}
    
    public String SAPAccountId             {get; set;}
    public String SAPAccountDesc           {get; set;}
    
    public String InstallerDataId          {get; set;}
    public String serviceProviderProfileId {get; set;}

    public String distributorId            {get; set;}
    public String distributorDesc          {get; set;}
    
    public Boolean showProspectInput       {get; set;}
    public Boolean reportViewerVisible     {get; set;}
    public String  reportViewerURL         {get; set;}
    
    public List<VI_Reward_Card_Value__c> rewardCards {get; private set;}

    VI_Enrollment_Location__c enrollmentLocation;
    VI_Promotion__c promotion;
    Account facility;

    Boolean reportTypeAccountNumEnabled;
    Boolean reportTypeDistributorEnabled;
    Boolean reportTypeCustGrp5Enabled;

    String enrollmentLocationId;
    
    //String tabInFocus = System.currentPageReference().getParameters().get('tab');
    String tabInFocus = '';

    public VI_VEM_Report_Controller(ApexPages.StandardSetController controller) {}

    public VI_VEM_Report_Controller(ApexPages.StandardController controller) {
        PageReference pr = ApexPages.currentPage();
        Map<String, String> pmap = new Map<String, String>();
        if(pr != null) {pmap = pr.getParameters();}
        enrollmentLocation = (VI_Enrollment_Location__c)Controller.getRecord();
        enrollmentLocationId = enrollmentLocation.Id;
        if (isNull(enrollmentLocationId) && pmap != null) {
        	enrollmentLocationId = pmap.get('id');
        }
    }
    
    private void debug(String s) {System.debug(LoggingLevel.INFO, '>>>>>>>>> ' + s);}

    public List<SelectOption> getReportTypes() {
        List<SelectOption> options = new List<SelectOption>(); 
        if (reportTypeAccountNumEnabled == true) {options.add(new SelectOption('AcctNo','Account Number'));} 
        if (reportTypedistributorEnabled == true) {options.add(new SelectOption('distributor','Parent Account'));}
        if (reportTypeCustGrp5Enabled == true) {options.add(new SelectOption('CustGrp5','Customer Group5'));} 
        return options; 
    }
    
    private Boolean isNull(String s) {return (s == null || s.trim().length() == 0);}
 
    public Boolean getPromotionExists() {return !isNull(promoCode);}

    public Boolean getLocationExists() {return !isNull(location);}

    public Boolean getSAPAccountExists() {return !isNull(AcctNo);}

    public Boolean getDistributorExists() {return !isNull(distributor);}

    public Boolean getSAPCustomerGroup5DescExists() {return !isNull(CustGrp5);}

    public Boolean getInsideIntranet() {
    	return User_Functions.isIntranetIP();
    }

    public String getUserIPAddress() {
        return User_Functions.getUserIPAddress();
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

    public void initAction() {
        clearFormFields();
        queryRelevantData();
        populateFormFields();
        getServiceProfileData();
        initializeFormParameters();
    }

    private void clearFormFields() {
    	forecastRedem = '45'; loyaltyRate = '50'; avgTicket = '75'; grossProfit = '30';
    	
        ReportType = ''; promoCode = ''; location = ''; AcctNo = '';
        distributor = ''; CustGrp5 = ''; reportViewerURL = ''; distributorId = '';
    }

    private void queryRelevantData() {
    	if (isNull(enrollmentLocationId)) {return;}
        try {        
            enrollmentLocation = [SELECT id, Name,
                Facility__c, Facility__r.AccountNumber, Facility__r.Name,
                Location__c, Location__r.AccountNumber, Location__r.Name,
                Promotion__c 
                FROM VI_Enrollment_Location__c WHERE id = :enrollmentLocationId];
                               
            facility = [SELECT id, Name, AccountNumber, ParentId, 
                Parent.AccountNumber, Parent.Name, SAP_Customer_Group_5_Desc__c 
                FROM Account WHERE Id = :enrollmentLocation.Facility__c];
                
            promotion = [select Id, Name, End_Date__c, Product_Category__c,
                                Program_Code__c, Start_Date__c,
                               (select Primary_Product__c, Reward_Card_Value__c
                                  from VI_Reward_Card_Values__r)
                from VI_Promotion__c where Id = :enrollmentLocation.Promotion__c];
        } catch(Exception e) {}
    }

    private void initializeFormParameters() {
        tabInFocus = 'reportParameterEntry';
        reportViewerVisible = false;
        updateShowProspectInput();
        
        if (!isNull(CustGrp5)) {reportTypeCustGrp5Enabled = true;ReportType = 'CustGrp5';}
        if (!isNull(distributor)) {reportTypedistributorEnabled = true;ReportType = 'distributor';}
        if (!isNull(AcctNo)) {reportTypeAccountNumEnabled = true;ReportType = 'AcctNo';}
    }

    private void populateFormFields() {
        rewardCards = new List<VI_Reward_Card_Value__c>();
        if (enrollmentLocation.Location__c != null) {
            locationId = enrollmentLocation.Location__c;
            locationId = locationId.substring(0,15);
            location = enrollmentLocation.Location__r.AccountNumber;
            locationDesc = enrollmentLocation.Location__r.Name + ' (' + enrollmentLocation.Location__r.AccountNumber + ')';
        }

        if (facility != null) {
            SAPAccountId = facility.Id;
            SAPAccountId = SAPAccountId.substring(0,15);
            AcctNo = facility.AccountNumber;
            SAPAccountDesc = facility.Name + ' (' + AcctNo + ')';
            distributor = facility.Parent.AccountNumber;
            distributorId = facility.ParentId;
            distributorDesc = facility.Parent.Name + ' (' + facility.Parent.AccountNumber + ')';
            CustGrp5 = facility.SAP_Customer_Group_5_Desc__c;
        }

        if (promotion != null) {
        	productCatgry = promotion.Product_Category__c;
            promotionId = promotion.Id;
            promotionId = promotionId.substring(0,15);
            promoCode = promotion.Program_Code__c;
            promotionDesc = promotion.Name + ' (' + promoCode + ')';
            if (promotion.VI_Reward_Card_Values__r != null) {
	            for (VI_Reward_Card_Value__c rc : promotion.VI_Reward_Card_Values__r) {
	            	rewardCards.add(rc);
	            }
            }
        }
        debug('rewardCards : ' + rewardCards);    
    }

    private void getServiceProfileData() {
        if (SAPAccountId == null || promotion == null) {return;}
        List<String> InstallerDataAccounts = new List<String>();
        InstallerDataAccounts.add(SAPAccountId);
        
        List<String> questionNames = new List<String>();
        questionNames.add('FullSyntheticOilChange');
        questionNames.add('SyntheticBlendOilChange');
        questionNames.add('ConventionalOilChange');
        date InstallerDataDate = promotion.Start_Date__c;

        List<Service_Profile__c> InstallerDataAnswers = new List<Service_Profile__c>();

        debug('enrollmentLocation : ' + enrollmentLocation);
        debug('InstallerDataAccounts : ' + InstallerDataAccounts);
        debug('questionNames : ' + questionNames);
        debug('InstallerDataDate : ' + InstallerDataDate);
        try {
            InstallerDataAnswers = [SELECT Id, Installer_Data_Id__c, 
                       Service_Provider_Profile__r.Id, QuestionName__c, 
                       Retail_Price__c, Effective_Date__c, Expiry_Date__c 
                  FROM Service_Profile__c 
                 WHERE Related_Account_Id__c IN :InstallerDataAccounts 
                   AND QuestionName__c IN :questionNames 
                   AND Effective_Date__c <= :InstallerDataDate
                   AND Expiry_Date__c >= :InstallerDataDate
                               ];
        } catch (Exception e) {}
        
        if (InstallerDataAnswers != null) {
            for (Service_Profile__c InstallerDataAnswer : InstallerDataAnswers) {
                debug('InstallerDataAnswer : ' + InstallerDataAnswer);
                //if (InstallerDataAnswer.QuestionName__c == 'FullSyntheticOilChange') {FullSynOCPrice = InstallerDataAnswer.Retail_Price__c.toPlainString();}            
                //if (InstallerDataAnswer.QuestionName__c == 'SyntheticBlendOilChange') {SemiSynOCPrice  = InstallerDataAnswer.Retail_Price__c.toPlainString();}            
                //if (InstallerDataAnswer.QuestionName__c == 'ConventionalOilChange') {ConvOCPrice = InstallerDataAnswer.Retail_Price__c.toPlainString();}          
                InstallerDataId = InstallerDataAnswer.Installer_Data_Id__c;  
                serviceProviderProfileId = InstallerDataAnswer.Service_Provider_Profile__r.Id;
            }
        }
    }

    public void runVIPromotionInstallerDataReport() {
        reportViewerURL = generatePromotionInstallerDataURL();
        this.tabInFocus = 'reportViewer';
        reportViewerVisible = true;
        
        debug(' *****Current Selected tab is :' + TabInFocus);
    }

    public void updateShowProspectInput() {showProspectInput = AcctNo.startsWith('P');}
    
    private String urlenc(String s) {return EncodingUtil.urlEncode(s, 'UTF-8');}

    public String generatePromotionInstallerDataURL() {
        CognosConfig__c cc = CognosConfig__c.getInstance('config');
        String url = cc.Cognos_URL_Prefix__c;

        url += '?CAMNamespace=Ashland&b_action=cognosViewer&ui.action=run';
        url += '&ui.object=' + urlenc('/content/package[@name=\'VEM Installer Promotions\']/report[@name=\'Promotion Scorecard\']');
        url += '&ui.name='   + urlenc('Promotion Scorecard');
        url += '&run.outputFormat=PDF&run.prompt=false';

        url += getParam(reportType,    '&p_RptTyp='); 
        url += getParam(promoCode,     '&p_PromoCd='); 
        url += getParam(location,      '&p_InstStore='); 
        url += getParam(acctNo,        '&p_AcctNo='); 
        url += getParam(distributor,   '&p_ParntAcctNo='); 
        url += getParam(custGrp5,      '&p_CustGrp5='); 
        url += getParam(productCatgry, '&p_ProdCat='); 
        url += getParam(grossProfit,   '&p_GPPerTick='); 
        url += getParam(forecastRedem, '&p_FrcastRdmptns='); 
        url += getParam(loyaltyRate,   '&p_InstLoyaltyRt='); 
        url += getParam(avgTicket,     '&p_AvgTickPerRetCust='); 

        VI_Reward_Card_Value__c rc; String t; Decimal v;
        for (Integer i = 0; i < rewardCards.size(); i++) {
        	rc = rewardCards[i]; t = (i+1) + '='; v = rc.Reward_Card_Value__c;
        	url += '&p_PrimProd' + t + urlenc(rc.Primary_Product__c);
            url += '&p_CardVal'  + t + v.toPlainString();
        } 
        debug('URL : ' + url);

        return url;
    }
    
    private String getParam(String v, String p) {
    	debug('p = ' + p + ' : v = ' + v);
    	if (!isNull(v)) {return p + urlenc(v);} return '';
    }
}
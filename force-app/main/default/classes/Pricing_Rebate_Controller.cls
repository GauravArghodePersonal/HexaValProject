//Last Modified by Mukul Singh TechM for INC000000616833
//Last Modified by Srinivasan Muthu-TechMfor CR-Request-0629 on 02/04/2015

public class Pricing_Rebate_Controller {

    public static final String COMMA = ',';
    public static final String SOLDTO = Account_Partner_Functions.ACC_TYPE_SOLDTO;
    public static final String SHIPTO = Account_Partner_Functions.ACC_TYPE_SHIPTO;
    public static final String LIMIT1 = ' limit 1000';
    public static final String ERR_01 = 'This sales org has not been setup for rebate '
                                      + 'functionality.  Please log a ticket.';
    public static final String ERR_02 = 'Please select Rebate Recipient.';
    public static final String ERR_03 = 'Please select Agreement Type.';
    public static final String ERR_04 = 'Please select Condition Type.';
    public static final String ERR_05 = 'Please select Table.';
    public static final String ERR_06 = 'End Date should be greater than or equal to '
                                      + 'the Start date and should not be greater than '
                                      + '3 years after the Start date';
    public static final String ERR_07 = 'Please select at least one customer.';
    public static final String ERR_08 = 'Please select at least one customer and one material.';
    public static final String ERR_09 = 'Please select at least one material.';

    public Pricing_Rebate__c rebate {get; set;}
    public Account rebateRecipient {get; set;}
    //Line No:24 Last Modified by Srinivasan Muthu-TechM for CR-Request-0629
    public Boolean rebatenotify {get; set;}

    public boolean displayCustomerSelector{get;set;}
    public boolean displayMaterialSelector{get;set;}
    public boolean displayRebatePage{get;set;}
    public List<Pricing_RebateCustomerInfo> customersAdded{get;set;}
    public List<Pricing_RebateMaterialInfo> materialsAdded{get;set;}
    public List<Pricing_RebateAccountWrapper> selectedCustomers = new List<Pricing_RebateAccountWrapper>();
    public List<Pricing_RebateMaterialWrapper> selectedMaterials = new List<Pricing_RebateMaterialWrapper>();
    public List<SelectOption> rebateAgreementTypeOptions{get;set;}
    public String rebateAgreementType{get;set;}
    public List<SelectOption> conditionTypeOptions{get;set;}
    public String conditionType{get;set;}
    public List<SelectOption> tablesOptions{get;set;}
    public String tables{get; set;}
    public String tablesOutput{get; private set;}
    public List<String> tableList {get;set;}
    public Boolean readonlyTables {get; private set;}
    public Pricing_RebateCustomerSelectorSearch custSearch{get;set;}
    public Boolean allAcc1{get;set;}
    public Boolean allAcc2{get;set;}
    public Boolean allMat1{get;set;}
    public Boolean allMat2{get;set;}
    public boolean isReadOnly{get;set;}
    public List<Pricing_RebateAccountWrapper> accountList;
    public ApexPages.Standardsetcontroller stdSetCtr;
    public boolean displayNext{get;set;}
    public boolean displayPrevious{get;set;}
    public Pricing_RebateMaterialSelectorSearch materialSearch{get;set;}
    public List<Pricing_RebateMaterialWrapper> materialList;
    public Map<Id,Pricing_Rebate_Detail__c> rebateDetailMap = new Map<Id,Pricing_Rebate_Detail__c>();
    public Boolean displayCustomerAndMaterial{get;set;}
    public String currencyCode, accountId;
    public Boolean displayonlyAmountAndAccrual{get;set;}
    public Boolean rebateChangeable{get; private set;}
    public Boolean rebateOptionsSet{get; private set;}
    public Boolean rebateFromAccount{get;set;}
    public List<SelectOption> radioOptions{get;set;}
    public List<SelectOption> currencyCodes {get; private set;}
    public List<SelectOption> uomCodes {get; private set;}
    public PaginationController apc {get; set;}
    public PaginationController mpc {get; set;}

    public Boolean allowedToCreate {get; private set;}
    public Boolean renderCancelBtn {get; private set;}
    public Boolean renderDeleteBtn {get; private set;}
    public Boolean renderExpireBtn {get; private set;}
    public Boolean renderShiptoLvlMsg {get; set;}

    public Pricing_Rebate_Approvers__c rebateApprovers {get; set;}

    public String amountHelpText {get; set;}
    public String amountLabel {get; set;}
    public String accrualHelpText {get; set;}
    public String accrualLabel {get; set;}

    public String accountNumber {get; private set;}

    public SAP_LISD lisd       {get; set;}
    public Boolean renderGoto1 {get; private set;}
    public Boolean renderGoto2 {get; private set;}
    public Boolean renderLisd  {get; private set;}
    public Boolean renderPage2 {get; private set;}

    PageReference accountPageRef;

    Pricing_Rebate_Detail__c rebateDetail;

    private String conditionTypeCode, conditionTypeDesc, rebateAgmTypeCode, rebateAgmTypeDesc, salesOrg, distChan;

    private void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Pricing_Rebate_Controller : ' + s);
    }

    private Boolean isNull(String s) {return (s == null || s.trim().length() == 0);}

    public Pricing_Rebate_Controller(ApexPages.StandardController stdCtrl){
        debug('Constructor');
        //Line No:102 Last Modified by Srinivasan Muthu-TechM for CR-Request-0629
        rebatenotify=true;
        accountId = ApexPages.currentPage().getParameters().get('accountId');
        init(stdCtrl.getRecord());
    }

    private List<Pricing_Rebate_Configuration__c> getRebateConfigs() {
        debug('getRebateConfigs : distChan = ' + distChan);
        debug('getRebateConfigs : salesOrg = ' + salesOrg);
        debug('getRebateConfigs : rtypCode = ' + rebateAgmTypeCode);
        debug('getRebateConfigs : rtypDesc = ' + rebateAgmTypeDesc);
        debug('getRebateConfigs : condCode = ' + conditionTypeCode);
        debug('getRebateConfigs : condDesc = ' + conditionTypeDesc);
        String s = ''
        + 'select Id, Name, CurrencyIsoCode,'
        + '       Condition_Type__c, Condition_Type_Desc__c, Dist_Channel__c,'
        + '       Rebate_Agreement_Default_Flag__c, Rebate_Agreement_Description__c,'
        + '       Rebate_Agreement_Edit_Flag__c, Rebate_Agreement_Type__c,'
        + '       Sales_Org__c, Table__c, Table_Description__c'
        + '  from Pricing_Rebate_Configuration__c where Name != null';
        if (!isNull(distChan))          {s += ' and Dist_Channel__c                 = :distChan';}
        if (!isNull(salesOrg))          {s += ' and Sales_Org__c                    = :salesOrg';}
        if (!isNull(rebateAgmTypeCode)) {s += ' and Rebate_Agreement_Type__c        = :rebateAgmTypeCode';}
        if (!isNull(conditionTypeCode)) {s += ' and Condition_Type__c               = :conditionTypeCode';}
        s += ' order by '; if (isNull(conditionTypeCode))  {s += 'Condition_Type__c';} else {s += 'Table__c';}
        s += LIMIT1; debug('getRebateConfigs : confgQry = ' + s);
        return Database.query(s);
    }

    private void setRebateAgmTypeFlds() {
        displayCustomerAndMaterial = true; rebateAgmTypeCode = '';
        if(isNull(rebateAgreementType)){return;}
        String[] sa = rebateAgreementType.split('-');
        if(sa != null && sa.size() > 1){
            rebateAgmTypeDesc = sa.get(1).trim();
            rebateAgmTypeCode = sa.get(0).trim();
        } else if(sa != null && sa.size() == 1){
            rebateAgmTypeCode = sa.get(0).trim();
        }
        if(Pricing_RebateProperties.CustomerMaterialRebateType.equalsIgnoreCase(rebateAgmTypeCode)) {
            displayCustomerAndMaterial = false;
        }
    }

    private void setConditionTypeFlds() {
        displayonlyAmountAndAccrual = false; conditionTypeCode = '';
        if(isNull(conditionType)){return;}
         String[] sa = conditionType.split('-');
        if(sa != null && sa.size() > 1){
            conditionTypedesc = sa.get(1).trim();
            conditionTypeCode = sa.get(0).trim();
        } else if(sa != null && sa.size() == 1){
            conditionTypeCode = sa.get(0).trim();
        }
        if(Pricing_RebateProperties.conditionTypeCode1.equalsIgnoreCase(conditionTypeCode) ||
           Pricing_RebateProperties.conditionTypeCode2.equalsIgnoreCase(conditionTypeCode) ||
           Pricing_RebateProperties.conditionTypeCode3.equalsIgnoreCase(conditionTypeCode)) {
            displayonlyAmountAndAccrual = true;
        }
    }

    public void onRebateTypeChange() {
        conditionType = ''; getRebateTables();
    }

    public PageReference getRebateTables() {
        debug('getRebateTables');
        List<String> ctypeList = new List<String>(), tableList = new List<String>();
        Set<String> ctypeSet = new Set<String>(), tableSet = new Set<String>();
        setRebateAgmTypeFlds(); setConditionTypeFlds();
        distChan = rebate.Dist_Channel__c; salesOrg = rebate.Sales_Org__c;
        for (Pricing_Rebate_Configuration__c c : getRebateConfigs()){
            debug('Config 1 : ' + c);
            ctypeSet.add(c.Condition_Type__c + ' - ' + c.Condition_Type_Desc__c);
            tableSet.add(c.Table__c + ' - ' + c.Table_Description__c);
        }
        ctypeList.addAll(ctypeSet); ctypeList.sort();

        if (!ctypeList.isEmpty()) {
            conditionTypeOptions = Pricing_RebatePickListUtils.addPickListValuesFromList(ctypeList, false);
            if (isNull(conditionType)) {conditionType = ctypeList.get(0);}
            setConditionTypeFlds(); tableSet = new Set<String>();
            for (Pricing_Rebate_Configuration__c c : getRebateConfigs()){
                debug('Config 2 : ' + c);
                tableSet.add(c.Table__c + ' - ' + c.Table_Description__c);
            }
        }

        tableList.addAll(tableSet); tableList.sort();

        debug('conditionType = ' + conditionType + ' : code = ' + conditionTypeCode);
        /*
        if(Pricing_RebateProperties.conditionTypeCode1.equalsIgnoreCase(conditionTypeCode) ||
           Pricing_RebateProperties.conditionTypeCode2.equalsIgnoreCase(conditionTypeCode) ||
           Pricing_RebateProperties.conditionTypeCode3.equalsIgnoreCase(conditionTypeCode)) {
            displayonlyAmountAndAccrual = true;
        } else {
            displayonlyAmountAndAccrual = false;
        }
        */
        tablesOptions = Pricing_RebatePickListUtils.addPickListValuesFromList(tableList, false);

        initTableList();

        return null;
    }

    private void initTableList() {
        readonlyTables = false; tables = '';
        if (!isNull(rebate.Tables__c)) {tables = rebate.Tables__c;}
        debug('initTableList : tables = ' + tables);
        if (!isNull(tables)) {
            for (String s : tables.split(COMMA)) {tableList.add(s.trim());} return;
        }
        if (tablesOptions == null || tablesOptions.isEmpty()) {return;}
        tables = tablesOptions[0].getValue(); tableList.add(tables);
    }

    public PageReference cancel() {
        PageReference pr = new PageReference('/' + accountId);
        String retURL = ApexPages.currentPage().getParameters().get('retURL');
        if (retURL != null) {pr = new PageReference(retURL);}
        return pr.setRedirect(true);
    }

    private void init(SObject sobj) {
        debug('init');
        rebate = new Pricing_Rebate__c();
        if (sobj != null) {
            if (sobj.getSObjectType() == Pricing_Rebate__c.sObjectType) {
                rebate = (Pricing_Rebate__c) sobj; setRebate(rebate.Id);
            } else
            if (sobj.getSObjectType() == Pricing_Rebate_Detail__c.sObjectType) {
                rebateDetail = (Pricing_Rebate_Detail__c) sobj;
                setRebateDetail(rebateDetail.Id);
            }
        }
        Schema.DescribeFieldResult dfr = Pricing_Rebate_Detail__c.Amount__c.getDescribe();
        amountLabel = dfr.getLabel(); amountHelpText = dfr.getInlineHelpText();
        dfr = Pricing_Rebate_Detail__c.Accrual__c.getDescribe();
        accrualLabel = dfr.getLabel(); accrualHelpText = dfr.getInlineHelpText();
    }

    public void initAction1() {
        debug('initAction1: rebate.Seller__c = ' + rebate.Seller__c);
        if (lisd == null) {
            lisd = new SAP_LISD();

            if (!isNull(accountId)) {
                lisd.setIndustries(accountId);
                if (rebate.Id != null && isNull(rebate.Seller__c)){onLisdComplete();return;}
                else if (rebate.Id != null && lisd.isMultiIndustyAcc){initLisdDialog();return;}
            }
            else {lisd.readOnlyAC = false;}
        }
        if (rebate.Id == null) {
            if (!validateSoldTo()) {return;}
            if (lisd.isInactiveAcc) {initConfirmDialog(); return;}
            onLisdComplete();
        } else {
            renderPage2 = true; renderLisd = false;
            lisd.copyDataFrom(rebate); init1();
        }
    }

    public void onLisdComplete() {
        debug('onLisdComplete : lisd = ' + lisd);
        renderPage2 = (lisd != null && !lisd.isMultiIndustyAcc);
        if (renderPage2) {gotoPage2(); return;}
        renderGoto2 = (lisd != null && lisd.isMultiIndustyAcc &&
                       lisd.seller != null && lisd.seller.Id != null);
    }


    public ConfirmDialogParam cdp {get; private set;}

    public Boolean renderConfirmDialogComp {get; private set;}

    public void onConfirmComplete() {
        debug('onConfirmComplete:cdp = ' + cdp);
        renderConfirmDialogComp = cdp.renderComp;
        if (cdp.clickedNo)  {gotoPage2();} else
        if (!renderConfirmDialogComp) {onLisdComplete();}
    }

    private void initConfirmDialog() {
        if (cdp == null) {cdp = new ConfirmDialogParam();}
        cdp.cancelUrl = '/' + getString(accountId);
        cdp.warnMsg1 = 'Account is marked for deletion. Continue or Cancel?';
        renderConfirmDialogComp = isNull(rebate.Id) && cdp.renderComp;
    }

    private void initLisdDialog() {
        cdp = new ConfirmDialogParam(ConfirmDialogParam.DialogButtons.YesNoCancel);
        cdp.cancelUrl = '/' + getString(rebate.Id);
        cdp.warnMsg1 = 'Do you want to edit LISD information as well?';
        renderConfirmDialogComp = cdp.renderComp;
    }

    private String getString(String s) {if (isNone(s)) {return '';} return s;}
    private Boolean isNone(String s) {return isNull(s) || s.equals(SAP_LISD_Functions.NONE);}

    public void gotoPage1() {
        if (lisd == null) {return;}
        debug('gotoPage1');
        renderPage2 = lisd.isMultiIndustyAcc;
        if (renderPage2) {return;}
        lisd.setDataLists(rebate); renderLisd = true;
        renderGoto2 = (!lisd.isMultiIndustyAcc &&
                       lisd.seller != null && lisd.seller.Id != null);
    }

    public void gotoPage2() {
        debug('gotoPage2');
        renderPage2 = true; renderGoto2 = false; renderLisd = false;
        accountId = lisd.acc.Id; rebate.Rebate_Recipient__c = accountId;
        if (!validateSoldTo()) {return;}
        lisd.copyDataTo(rebate); init1();
    }

    private void init1(){
        debug('init1');
        allowedToCreate = Schema_Services.isObjectCreatable('Pricing_Rebate__c');
        renderDeleteBtn = false; renderExpireBtn = false; renderCancelBtn = false;
        displayCustomerSelector = false; displayMaterialSelector = false;
        displayRebatePage = true; isReadOnly = false; renderLisd = false;
        accountPageRef = null; tableList = new List<String>();
        customersAdded = new List<Pricing_RebateCustomerInfo>();
        materialsAdded = new List<Pricing_RebateMaterialInfo>();
        custSearch = new Pricing_RebateCustomerSelectorSearch();
        materialSearch = new Pricing_RebateMaterialSelectorSearch();
        if (rebate != null && rebate.Id != null){
            tables = rebate.Tables__c; initTableList();
            rebateFromAccount = true;
            renderDeleteBtn = Pricing_Rebate_Functions.isDraft(rebate);
            renderExpireBtn = allowedToCreate && Pricing_Rebate_Functions.isApproved(rebate);
        } else {
            Integer year = Date.today().year();
            rebate.Status__c = Pricing_RebateProperties.DraftStatus;
            rebate.Rebate_Start_Date__c = Date.newInstance(year, 01, 01);
            rebate.Rebate_End_Date__c = Date.newInstance(year, 12, 31);
            if (accountId != null) {rebate.Rebate_Recipient__c = accountId;}
        }
        if(rebate.Rebate_Recipient__c != null) {
            rebateFromAccount = true;
            rebateRecipient = Pricing_Rebate_Functions.getAccount(accountId);
            accountNumber = String_Functions.removeLeadingZeros(rebateRecipient.AccountNumber);
        } else {rebateFromAccount = false;}
        setRebateAgmTypeFlds(); setConditionTypeFlds();
        conditionType = rebate.Condition_Type__c;
        debug('conditionType = ' + conditionType);
        rebateAgreementType = rebate.Rebate_Agreement_Type__c;
        init3(); init4();
        if (rebateFromAccount && (rebateAgreementTypeOptions == null ||
                                  rebateAgreementTypeOptions.isEmpty())) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_01));
            displayRebatePage = false; renderCancelBtn = true; renderPage2 = true; return;
        }
        currencyCodes = CurrencyFunctions.getCurrencyCodes(); uomCodes = getUomCodes();
        custSearch.distChanCodes = Pricing_Rebate_Functions.getDistChanCodes();
        custSearch.salesOrgCodes = Pricing_Rebate_Functions.getSalesOrgCodes();
        String s = ApexPages.currentPage().getParameters().get('invokedFromAddCustomer');
        isReadOnly = (s == 'true');
        if (rebate.Id == null && rebateFromAccount &&
            conditionTypeOptions != null && conditionTypeOptions.isEmpty()) {
            conditionType = conditionTypeOptions[0].getValue();
            debug('conditionType = ' + conditionType);
        }
        initTableList();
        renderGoto1 = (!isReadOnly && lisd != null && !lisd.isMultiIndustyAcc);
        renderConfirmDialogComp = false;
    }

    private void init3(){
        debug('init3');
        Account a = rebateRecipient; if (a == null) {return;}
        currencyCode = (a.SAP_Currency__c != null) ? a.SAP_Currency__c : 'USD';

        rebateApprovers = Pricing_Rebate_Functions.getRebateApprovers(a, lisd);

        rebate.Sales_Org__c = a.SAP_Sales_Org__c;
        rebate.Sales_Org_Description__c = a.SAP_Sales_Org_Desc__c;
        rebate.Dist_Channel__c = a.SAP_DistChannel__c;
        rebate.Dist_Channel_Description__c = a.SAP_Dist_Channel_Desc__c;
        rebate.Division__c = a.SAP_DivisionCode__c;
        rebate.Division_Description__c = a.SAP_Division_Desc__c;
        rebate.Rebate_Recipient_account_number__c = a.AccountNumber;

        custSearch.salesOrg = a.SAP_Sales_Org__c + ' - ' + a.SAP_Sales_Org_Desc__c;
        custSearch.distChannel = a.SAP_DistChannel__c + ' - ' + a.SAP_Dist_Channel_Desc__c;
        custSearch.division = a.SAP_DivisionCode__c + ' - ' + a.SAP_Division_Desc__c;

        custSearch.salesOrgOptions = Pricing_RebatePickListUtils.addPickListValues(
                                     new Set<String>{custSearch.salesOrg}, false);
        custSearch.distChannelOptions = Pricing_RebatePickListUtils.addPickListValues(
                                        new Set<String>{custSearch.distChannel}, false);
        custSearch.divisionOptions = Pricing_RebatePickListUtils.addPickListValues(
                                     new Set<String>{custSearch.division}, false);
    }

    private void init4() {
        if(rebate == null || rebate.Rebate_Recipient__c == null){return;}
        debug('init4');
        Set<String> rebateAgreementTypeSet = new Set<String>();
        Set<String> conditionTypeSet = new Set<String>();
        List<String> defaultRebates = new List<String>();
        rebateChangeable = false; rebateOptionsSet = false; rebateAgreementType = '';
        distChan = rebate.Dist_Channel__c; salesOrg = rebate.Sales_Org__c;
        for(Pricing_Rebate_Configuration__c c : getRebateConfigs()){
            if (c.Rebate_Agreement_Default_Flag__c == true ||
                c.Rebate_Agreement_Edit_Flag__c == true) {rebateOptionsSet = true;}
            rebateAgreementTypeSet.add(c.Rebate_Agreement_Type__c + ' - ' +
                                       c.Rebate_Agreement_Description__c);
            conditionTypeSet.add(c.Condition_Type__c + ' - ' +
                                 c.Condition_Type_Desc__c);
            currencyCode = c.CurrencyIsoCode;
            if(c.Rebate_Agreement_Default_Flag__c) {
                defaultRebates.add(c.Rebate_Agreement_Type__c + ' - ' +
                                   c.Rebate_Agreement_Description__c);
            }
            if(!rebateChangeable && c.Rebate_Agreement_Edit_Flag__c) {rebateChangeable = true;}
        }
        List<String> rebateAgreements = new List<String>();
        rebateAgreements.addAll(rebateAgreementTypeSet); rebateAgreements.sort();
        List<String> conditionTypes = new List<String>();
        conditionTypes.addAll(conditionTypeSet); conditionTypes.sort();
        rebateAgreementTypeOptions = Pricing_RebatePickListUtils.addPickListValuesFromList(
                                     rebateAgreements, false);
        conditionTypeOptions = Pricing_RebatePickListUtils.addPickListValuesFromList(
                               conditionTypes, false);
        if(!defaultRebates.isEmpty())   {rebateAgreementType = defaultRebates.get(0);} else
        if(!rebateAgreements.isEmpty()) {rebateAgreementType = rebateAgreements.get(0);}

        if (!isNull(rebate.Rebate_Agreement_Type__c)) {rebateAgreementType = rebate.Rebate_Agreement_Type__c;}
        getRebateTables(); //populateCustAndMaterialInfo();

        Set<Id> createdAccIds = new Set<Id>();
        customersAdded = new List<Pricing_RebateCustomerInfo>();
        materialsAdded = new List<Pricing_RebateMaterialInfo>();
        rebateDetailMap = new Map<Id,Pricing_Rebate_Detail__c>();
        conditionType = rebate.Condition_Type__c; tables = rebate.Tables__c;
        debug('conditionType = ' + conditionType);
        if(rebate.Id == null){return;}

        rebateDetailMap = new Map<Id,Pricing_Rebate_Detail__c>([
            select UoM__c, Unit__c, Table__c, Pricing_Rebate__c, Per__c, Name,
                   Material_Sales_Data2__c, MFD__c, Id, Amount__c,
                   Accrual__c, Account__c, Approved_Rebate__c,
                   Account__r.AccountNumber, Account__r.Name,
                   Account__r.SAP_Sales_Org__c, Account__r.SAP_Sales_Org_Desc__c,
                   Account__r.SAP_DistChannel__c, Account__r.SAP_Dist_Channel_Desc__c,
                   Account__r.SAP_DivisionCode__c, Account__r.SAP_Division_Desc__c,
                   Account__r.SAP_Partner_Functions__c,
                   Material_Sales_Data2__r.Material_Number__c,Material_Sales_Data2__r.Name
              from Pricing_Rebate_Detail__c Where Pricing_Rebate__c = :rebate.Id
          order by Approved_Rebate__c desc]);
        for (Pricing_Rebate_Detail__c d : rebateDetailMap.values()){
            if (d.Material_Sales_Data2__c == null){
                displayCustomerAndMaterial = false; break;
            }
        }
        Set<Id> approvedRebateAccounts = new Set<Id>();
        for (Pricing_Rebate_Detail__c d : rebateDetailMap.values()){
            if (d.Approved_Rebate__c) {approvedRebateAccounts.add(d.Account__c);}
        }
        for(Pricing_Rebate_Detail__c d : rebateDetailMap.values()){
            if(!createdAccIds.contains(d.Account__c)){
                Account acc = new Account(Id=d.Account__c);
                acc.Name = d.Account__r.Name;
                acc.AccountNumber= d.Account__r.AccountNumber;
                acc.SAP_Sales_Org__c = d.Account__r.SAP_Sales_Org__c;
                acc.SAP_Sales_Org_Desc__c = d.Account__r.SAP_Sales_Org_Desc__c;
                acc.SAP_DistChannel__c = d.Account__r.SAP_DistChannel__c;
                acc.SAP_Dist_Channel_Desc__c = d.Account__r.SAP_Dist_Channel_Desc__c;
                acc.SAP_DivisionCode__c = d.Account__r.SAP_DivisionCode__c;
                acc.SAP_Division_Desc__c = d.Account__r.SAP_Division_Desc__c;
                acc.SAP_Partner_Functions__c = d.Account__r.SAP_Partner_Functions__c;
                Pricing_RebateCustomerInfo custInfo = new
                Pricing_RebateCustomerInfo(acc, tables, d.table__c);
                custInfo.deleteCustomer = false; custInfo.rebateDetail = d;
                if (Pricing_RebateProperties.ApprovedStatus.equalsIgnoreCase(rebate.Status__c) ||
                    Pricing_RebateProperties.ProcessStatus.equalsIgnoreCase(rebate.Status__c) ||
                    approvedRebateAccounts.contains(d.Account__c)) {
                    custInfo.displayDeleteCheckBox = false;
                    custInfo.accountLevelReadonly = true;
                } else {
                    custInfo.displayDeleteCheckBox = true;
                }
                customersAdded.add(custInfo); createdAccIds.add(d.Account__c);
            }
        }

        if (displayCustomerAndMaterial && !customersAdded.isEmpty()){
            Set<Id> approvedMaterialIDs = new Set<Id>();
            for (Pricing_Rebate_Detail__c d : rebateDetailMap.values()) {
                if(d.Approved_Rebate__c) {approvedMaterialIDs.add(d.Material_Sales_Data2__c);}
            }
            Id accountId = customersAdded.get(0).acc.Id;
            for (Pricing_Rebate_Detail__c d : rebateDetailMap.values()){
                if (d.Account__c != accountId){continue;}
                Pricing_RebateMaterialInfo matInfo = new Pricing_RebateMaterialInfo();
                matInfo.rebateDetail = d; matInfo.deleteMaterial = false;
                matInfo.materialNumber = String_Functions.removeLeadingZeros(
                                         d.Material_Sales_Data2__r.Material_Number__c);
                Material_Sales_Data2__c matObj = new
                Material_Sales_Data2__c(Id=d.Material_Sales_Data2__c);
                matObj.Name = d.Material_Sales_Data2__r.Name;
                matObj.Material_Number__c = d.Material_Sales_Data2__r.Material_Number__c;
                matInfo.material = matObj;
                if (Pricing_RebateProperties.ApprovedStatus.equalsIgnoreCase(rebate.Status__c) ||
                    Pricing_RebateProperties.ProcessStatus.equalsIgnoreCase(rebate.Status__c) ||
                    approvedMaterialIDs.contains(d.Material_Sales_Data2__c))
                    matInfo.displayDeleteCheckBox = false;
                else
                    matInfo.displayDeleteCheckBox = true;
                materialsAdded.add(matInfo);
            }
        }

        getMFDCheckbox();
        selectedCustomers = new List<Pricing_RebateAccountWrapper>();
        selectedMaterials = new List<Pricing_RebateMaterialWrapper>();

        renderShiptoLvlMsg = false;
        for(Pricing_RebateCustomerInfo custInfo : customersAdded){
            Pricing_RebateAccountWrapper c = new
            Pricing_RebateAccountWrapper(custInfo.acc);
            c.addToRebate = false;
            c.displayDeleteCheckBox = custInfo.displayDeleteCheckBox;
            c.rebateDetail = custInfo.rebateDetail;
            selectedCustomers.add(c);
        }
        for(Pricing_RebateMaterialInfo matInfo : materialsAdded){
            Pricing_RebateMaterialWrapper m = new Pricing_RebateMaterialWrapper();
            m.material = matInfo.material;
            m.materialNumber = String_Functions.removeLeadingZeros(
                               matInfo.material.Material_Number__c);
            m.addToRebate = false;
            m.displayDeleteCheckBox = matInfo.displayDeleteCheckBox;
            m.rebateDetail = matInfo.rebateDetail;
            selectedMaterials.add(m);
        }
    }

    private void setBoolMap(Map<Id, Boolean> bmap, Boolean bval, Id bkey) {
        if (bkey == null) {return;}
        Boolean b = (bval == null ? false : bval);
        if (bmap.containsKey(bkey)) {b = b && bmap.get(bkey);}
        bmap.put(bkey, b);
    }

    private Map<Id, Boolean> getMFDMap() {
        Map<Id, Boolean> bmap = new Map<Id, Boolean>();
        if(rebateDetailMap == null) {return bmap;}
        for(Pricing_Rebate_Detail__c d : rebateDetailMap.values()) {
            setBoolMap(bmap, d.MFD__c, d.Account__c);
            setBoolMap(bmap, d.MFD__c, d.Material_Sales_Data2__c);
        }
        return bmap;
    }

    private void getMFDCheckbox() {
        debug('getMFDCheckbox');
        Map<Id, Boolean> bmap = getMFDMap();
        for(Pricing_RebateCustomerInfo c : customersAdded) {
            if(bmap.containsKey(c.rebateDetail.Account__c)) {
                c.mfd = bmap.get(c.rebateDetail.Account__c);
            }
        }
        for(Pricing_RebateMaterialInfo m : materialsAdded) {
            if(bmap.containsKey(m.rebateDetail.Material_Sales_Data2__c)) {
                m.mfd = bmap.get(m.rebateDetail.Material_Sales_Data2__c);
            }
        }
    }
/*
    private void getMFDCheckbox() {
        debug('getMFDCheckbox');
        if (displayCustomerAndMaterial) {
            if(rebateDetailMap != null && customersAdded != null && materialsAdded != null) {
                for(Pricing_RebateCustomerInfo customer : customersAdded) {
                    Integer matMFDCounter = 0;
                    for(Pricing_Rebate_Detail__c d : rebateDetailMap.values()) {
                        if(d.Account__c == customer.rebateDetail.Account__c && d.MFD__c) {
                            matMFDCounter++;
                        }
                    }
                    if(matMFDCounter == materialsAdded.size()) {customer.mfd = true;}
                }
                for(Pricing_RebateMaterialInfo m : materialsAdded) {
                    Integer custMFDCounter = 0;
                    for(Pricing_Rebate_Detail__c d : rebateDetailMap.values()) {
                        if(d.Material_Sales_Data2__c == m.rebateDetail.Material_Sales_Data2__c &&
                           d.MFD__c) {custMFDCounter++;}
                    }
                    if(custMFDCounter == customersAdded.size()) {m.mfd = true;}
                }
            }
        } else if (customersAdded != null) {
            for(Pricing_RebateCustomerInfo c : customersAdded) {c.mfd = c.rebateDetail.MFD__c;}
        }
    }
*/
    private void setTables() {
        debug('setTables');
        tables = ''; if (tableList == null || tableList.isEmpty()) {return;}
        String s = String.valueOf(tableList);
        if (s.length() > 1) {tables = s.substring(1, s.length()-1);}
        debug('tables : ' + tables);
        custSearch.isSoldTo = tables.contains(SOLDTO);
        custSearch.isShipTo = tables.contains(SHIPTO);
    }

    private void setRebate(String rebateId) {
        if (isNull(rebateId)) {return;}
        debug('setRebate');
        rebate = [Select Id, Name, OwnerId,
            Cloned_from_Pricing_Rebate__c, Condition_Type__c,
            Customer_Group__c, Customer_Group_Desc__c,
            Dist_Channel__c, Dist_Channel_Description__c,
            Division__c, Division_Description__c,
            EndUse_Customer__c, EndUse_Customer_Desc__c,
            Industry__c, Industry_Desc__c, Internal_Comments__c,
            Rebate_Agreement_Type__c, Rebate_End_Date__c,
            Rebate_Recipient__c,
            Rebate_Recipient__r.OwnerId,
            Rebate_Recipient__r.SAP_Customer_Group__c,
            Rebate_Recipient__r.SAP_Customer_Group_Desc__c,
            Rebate_Recipient__r.SAP_SalesDistrict__c,
            Rebate_Recipient__r.SAP_Sales_District_Desc__c,
            Rebate_Recipient__r.SAP_SalesGroup__c,
            Rebate_Recipient__r.SAP_Sales_Group_Desc__c,
            Rebate_Recipient__r.SAP_Sales_Office__c,
            Rebate_Recipient__r.SAP_Sales_Office_Desc__c,
            Rebate_Start_Date__c,
            Rebate_Recipient_account_number__c,
            Sales_Org__c, Sales_Org_Description__c,
            Sales_District__c, Sales_District_Desc__c,
            Sales_Group__c, Sales_Group_Desc__c,
            Sales_Office__c, Sales_Office_Desc__c,
            SAP_Rebate_Agreement_Number__c, Seller__c, Status__c, Tables__c
        From Pricing_Rebate__c Where Id = :rebateId];
        initLisdFields(); accountId = rebate.Rebate_Recipient__c;
    }

    private void initLisdFields() {
        if (rebate == null || rebate.Rebate_Recipient__r == null) {return;}
        debug('initLisdFields');
        Account a = rebate.Rebate_Recipient__r; String d = ' - ';
        if (String.isBlank(rebate.Customer_Group__c))      {rebate.Customer_Group__c      = a.SAP_Customer_Group__c;}
        if (String.isBlank(rebate.Customer_Group_Desc__c)) {rebate.Customer_Group_Desc__c = a.SAP_Customer_Group_Desc__c + d +
                                                                                            a.SAP_Customer_Group__c;}

        if (String.isBlank(rebate.Sales_District__c))      {rebate.Sales_District__c      = a.SAP_SalesDistrict__c;}
        if (String.isBlank(rebate.Sales_District_Desc__c)) {rebate.Sales_District_Desc__c = a.SAP_Sales_District_Desc__c + d +
                                                                                            a.SAP_SalesDistrict__c;}

        if (String.isBlank(rebate.Sales_Group__c))         {rebate.Sales_Group__c         = a.SAP_SalesGroup__c;}
        if (String.isBlank(rebate.Sales_Group_Desc__c))    {rebate.Sales_Group_Desc__c    = a.SAP_Sales_Group_Desc__c + d +
                                                                                            a.SAP_SalesGroup__c;}

        if (String.isBlank(rebate.Sales_Office__c))        {rebate.Sales_Office__c        = a.SAP_Sales_Office__c;}
        if (String.isBlank(rebate.Sales_Office_Desc__c))   {rebate.Sales_Office_Desc__c   = a.SAP_Sales_Office_Desc__c + d +
                                                                                            a.SAP_Sales_Office__c;}

        //if (String.isBlank(rebate.Seller__c))              {rebate.Seller__c              = a.OwnerId;}
    }

    private void setRebateDetail(String rebateDetailId) {
        if (isNull(rebateDetailId)) {return;}
        debug('setRebateDetail');
        Pricing_Rebate_Detail__c d = [select Id, Pricing_Rebate__c
                                        from Pricing_Rebate_Detail__c
                                       where Id = :rebateDetailId];
        setRebate(d.Pricing_Rebate__c);
    }

    private Boolean validateSoldTo() {
        debug('validateSoldTo');
        displayRebatePage = Account_Partner_Functions.isSoldTo(accountId, false);
        if (!displayRebatePage) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Rebate Recipient is not a Sold-To Account'));
            renderCancelBtn = true; renderPage2 = true;
        }
        return displayRebatePage;
    }

    public Boolean condTypeDisabled {
        get {
        Boolean b1 = customersAdded != null && !customersAdded.isEmpty();
        Boolean b2 = materialsAdded != null && !materialsAdded.isEmpty();
        return (b1 || b2);
        } private set;
    }

    //Line No: 701 Last Modified by Srinivasan Muthu-TechM for CR-Request-0629
    public PageReference expireRebate() {
        if (allowedToCreate && rebate != null && rebate.Id != null) {
            debug('expireRebate');
            Pricing_Rebate_Functions.expirePricingRebate(rebate,rebatenotify);
        }
        return new PageReference('/'+rebate.Id);
    }

    private List<SelectOption> getUomCodes() {
        debug('getUomCodes');
        List<SelectOption> alist = new List<SelectOption>();
        alist.add(new SelectOption('KG', 'KG'));
        alist.add(new SelectOption('LB', 'LB'));
        return alist;
    }

    public PageReference gotoPricingRebatePage(){
        PageReference pr = null;
        if (rebateDetail != null && rebateDetail.Id != null) {
            debug('gotoPricingRebatePage');
            rebateDetail = [select Pricing_Rebate__c from Pricing_Rebate_Detail__c
                             where Id = :rebateDetail.Id];
            pr = new PageReference('/apex/Pricing_Rebate_Page1?id='+rebateDetail.Pricing_Rebate__c);
        }
        return pr;
    }

    public PageReference addCustomer(){
        debug('addCustomer : custSearch : ' + custSearch);
        allAcc1 = false; allAcc2 = false; apc = null;
        String invokedFromAddCustomer = ApexPages.currentPage().getParameters().get('invokedFromAddCustomer');
        String invokedFromSelectRecipient = ApexPages.currentPage().getParameters().get('invokedFromSelectRecipient');
        if('true' == invokedFromAddCustomer){isReadOnly = true;} else
        if('true' == invokedFromSelectRecipient){isReadOnly = false;}
        if(!Pricing_RebateStringUtils.isNullOrBlank(invokedFromAddCustomer) && invokedFromAddCustomer == 'true' &&
            rebate != null && rebate.Rebate_Recipient__c == null){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Rebate Recipient.'));
            return null;
        }
        displayCustomerSelector = true; displayMaterialSelector = false; displayRebatePage = false;
        setTables();
        return null;
    }

    private void setReadOnlyTables() {
        debug('setReadOnlyTables');
        readonlyTables = (customersAdded != null && !customersAdded.isEmpty()) ||
                         (materialsAdded != null && !materialsAdded.isEmpty());
        tablesOutput = ''; for (String s : tableList) {tablesOutput += s + '<br/>';}
    }

    public PageReference searchCustomer(){
        debug('searchCustomer');
        addCustomer(); populateSalesOrg();
        selectedCustomers = new Pricing_RebateAccountWrapper[]{};
        apc = Pricing_Rebate_Functions.getAccountsPC(custSearch);
        return null;
    }

    public PageReference searchMaterial(){
        allMat1 = false; allMat2 = false; mpc = null;
        if(rebate.Rebate_Recipient__c == null){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_02));
            return null;
        }
        debug('searchMaterial');
        String s = ApexPages.currentPage().getParameters().get('invokedFromAddMaterial');
        if(s == 'true') {defaultSearchForMaterialSelector();}
        selectedMaterials = new Pricing_RebateMaterialWrapper[]{};
        mpc = Pricing_Rebate_Functions.getMaterialsPC(materialSearch);
        displayCustomerSelector = false; displayMaterialSelector = true;
        displayRebatePage = false;
        return null;
    }

    private void defaultSearchForMaterialSelector(){
        displayMaterialSelector = true;
        String s = ApexPages.currentPage().getParameters().get('invokedFromAddMaterial');
        if('true' != s){return;}
        debug('defaultSearchForMaterialSelector');
        isReadOnly = true;
        materialSearch = new Pricing_RebateMaterialSelectorSearch();
        materialSearch.salesOrgOptions = Pricing_RebatePickListUtils.addPickListValues(
                                         new Set<String>{rebate.Sales_Org__c}, false);
        materialSearch.salesOrg = rebate.Sales_Org__c;
        materialSearch.distChannelOptions = Pricing_RebatePickListUtils.addPickListValues(
                                         new Set<String>{rebate.Dist_Channel__c}, false);
        materialSearch.distChannel = rebate.Dist_Channel__c;
        populateProductHierarchy5(); populateProductHierarchy6();
    }

    public void populateSalesOrg(){
        debug('populateSalesOrg');
        List<String> salesOrgSortedList = new List<String>(); String s;
        List<Pricing_Rebate_Configuration__c> salesOrgList = getRebateConfigs();
        Set<String> salesOrgs = new Set<String>();
        for(Pricing_Rebate_Configuration__c c : salesOrgList){salesOrgs.add(c.Sales_Org__c);}
        List<SAP_Sales_Org__c> salesOrgObjList = [
            select Id, Sales_Org_Description__c, Sales_Org_Code__c
              from SAP_Sales_Org__c where Sales_Org_Code__c in :salesOrgs];
        for (SAP_Sales_Org__c obj : salesOrgObjList){
            for (String str : salesOrgs){
                if (str.equalsIgnoreCase(obj.Sales_Org_Code__c)) {
                    s = obj.Sales_Org_Code__c + ' - ' + obj.Sales_Org_Description__c;
                    salesOrgSortedList.add(s);
                }
            }
        }
        salesOrgSortedList.sort();
        if (custSearch != null) {
            custSearch.salesOrgOptions = Pricing_RebatePickListUtils.addPickListValuesFromList(
                                         salesOrgSortedList, true);
            if (salesOrgSortedList.size() == 1) {
                custSearch.salesOrg = s; populateDistChannel();
            }
        }
    }

    public PageReference populateDistChannel(){
        debug('populateDistChannel');
        String s;
        if(!isNull(custSearch.salesOrg)){
            String[] codeAndDesc = custSearch.salesOrg.split('-');
            if(codeAndDesc != null && codeAndDesc.size() >= 1){
                salesOrg = codeAndDesc.get(0).trim();
            }
        }
        List<Pricing_Rebate_Configuration__c> clist = getRebateConfigs();
        Set<String> distChannelSet = new Set<String>();
        List<String> distChannelList = new List<String>();
        for(Pricing_Rebate_Configuration__c c : clist){distChannelSet.add(c.Dist_Channel__c);}
        List<SAP_Distribution_Channel__c> distChannelObjList = [
            select Id, Distribution_Channel_Description__c, Distribution_Channel_Code__c
              from SAP_Distribution_Channel__c
             where Distribution_Channel_Code__c in :distChannelSet];
        for(SAP_Distribution_Channel__c obj : distChannelObjList){
            for(String str : distChannelSet){
                if (str.equalsIgnoreCase(obj.Distribution_Channel_Code__c)) {
                    s = obj.Distribution_Channel_Code__c + ' - ' +
                        obj.Distribution_Channel_Description__c;
                    distChannelList.add(s);
                }
            }
        }
        distChannelList.sort();
        custSearch.distChannelOptions = Pricing_RebatePickListUtils.addPickListValuesFromList(
                                        distChannelList, true);
        if (distChannelList.size() == 1) {
            custSearch.distChannel = s; populateDivision();
        }

        return null;
    }

    public PageReference populateDivision(){
        debug('populateDivision');
        String dchcode, orgcode, s;
        if(!isNull(custSearch.distChannel)){
            String[] codeAndDesc = custSearch.distChannel.split('-');
            if(codeAndDesc != null && codeAndDesc.size() >= 1){
                dchcode = codeAndDesc.get(0).trim();
            }
        }
        if(!isNull(custSearch.salesOrg)){
            String[] codeAndDesc = custSearch.salesOrg.split('-');
            if(codeAndDesc != null && codeAndDesc.size() >= 1){
                orgcode = codeAndDesc.get(0).trim();
            }
        }

        List<SAP_Sales_Area__c> divisions = [
            select Id, Sales_Org_Code__c, Sales_Division_Code__c, Distribution_Channel_Code__c
              from SAP_Sales_Area__c where Sales_Org_Code__c = :orgcode
               and Distribution_Channel_Code__c = :dchcode];
        Set<String> divisionSet = new Set<String>();
        List<String> divisionList = new List<String>();
        for (SAP_Sales_Area__c a : divisions){divisionSet.add(a.Sales_Division_Code__c);}
        List<SAP_Sales_Division__c> salesDivList = [
            select Id, Sales_Division_Description__c, Sales_Division_Code__c
              from SAP_Sales_Division__c where Sales_Division_Code__c in :divisionSet];
        for (SAP_Sales_Division__c obj : salesDivList){
            for (String str : divisionSet){
                if (str.equalsIgnoreCase(obj.Sales_Division_Code__c)) {
                    s = obj.Sales_Division_Code__c + ' - ' + obj.Sales_Division_Description__c;
                    divisionList.add(s);
                }
            }
        }
        divisionList.sort();
        custSearch.divisionOptions = Pricing_RebatePickListUtils.addPickListValuesFromList(
                                     divisionList, true);
        if (divisionList.size() == 1) {custSearch.division = s;}

        return null;
    }

    private void populateProductHierarchy5(){
        debug('populateProductHierarchy5');
        List<Product_Hierarchy__c> phList =
        SAP_Material_Queries.getProductFamiliesForDistChan(rebate.Dist_Channel__c);
        List<String> ph5List = new List<String>();
        if (phList != null) {
            for(Product_Hierarchy__c ph : phList){
                ph5List.add(ph.Product_Hierarchy_Code__c + ' - ' +
                            ph.Product_Hierarchy_Description__c);
            }
            ph5List.sort();
        }
        materialSearch.prodHierarchy5Options =
        Pricing_RebatePickListUtils.addPickListValuesFromList(ph5List, true);
    }

    public PageReference populateProductHierarchy6(){
        debug('populateProductHierarchy6');
        displayMaterialSelector = true;
        String ph5Code, ph5Desc;
        if(!isNull(materialSearch.prodHierarchy5)){
            String[] ph5 = materialSearch.prodHierarchy5.split('-');
            if(ph5 != null && ph5.size() > 1){
                ph5Desc = ph5.get(1).trim();
                ph5Code = ph5.get(0).trim();
            } else if(ph5 != null && ph5.size() == 1){
                ph5Code = ph5.get(0).trim();
            }
        }
        List<Product_Hierarchy__c> phList =
        SAP_Material_Queries.getProductLinesForFamily(rebate.Dist_Channel__c, ph5Code);
        if(phList != null){
            List<String> prodHie6List = new List<String>();
            for(Product_Hierarchy__c ph : phList){
                prodHie6List.add(ph.Product_Hierarchy_Code__c + ' - ' +
                                 ph.Product_Hierarchy_Description__c);
            }
            prodHie6List.sort();
            materialSearch.prodHierarchy6Options =
            Pricing_RebatePickListUtils.addPickListValuesFromList(prodHie6List, true);
        }
        return null;
    }

    public List<Pricing_RebateAccountWrapper> getAccountList() {
        accountList = new List<Pricing_RebateAccountWrapper>();
        if (apc == null) {return accountList;}
        debug('getAccountList');
        Integer n = apc.recordFrom; Pricing_RebateAccountWrapper w;
        for (Account acc : (List<Account>)apc.getRecords()){
            w = new Pricing_RebateAccountWrapper(acc, n++);
            for(Pricing_RebateAccountWrapper customer : selectedCustomers){
                if(customer.acc.Id == acc.Id && customer.addToRebate == true){
                    w.displayDeleteCheckBox = customer.displayDeleteCheckBox;
                    w.addToRebate = true;
                    if(customer.rebateDetail != null)
                        w.rebateDetail = customer.rebateDetail;
                    break;
                }
                else
                    w.addToRebate = false;
            }
            accountList.add(w);
        }
        return accountList;
    }

    public List<Pricing_RebateMaterialWrapper> getMaterialList() {
        materialList = new List<Pricing_RebateMaterialWrapper>();
        if (mpc == null) {return materialList;}
        debug('getMaterialList');
        Integer n = mpc.recordFrom; Pricing_RebateMaterialWrapper w;
        for(Material_Sales_Data2__c material : (List<Material_Sales_Data2__c>)mpc.getRecords()){
            w = new Pricing_RebateMaterialWrapper(material, n++);
            for(Pricing_RebateMaterialWrapper selectedMaterial : selectedMaterials){
                if (selectedMaterial.material.Id == material.Id &&
                    selectedMaterial.addToRebate == true){
                    w.addToRebate = true;
                    w.displayDeleteCheckBox = selectedMaterial.displayDeleteCheckBox;
                    if(selectedMaterial.rebateDetail != null)
                        w.rebateDetail = selectedMaterial.rebateDetail;
                    break;
                }
                else
                    w.addToRebate = false;
            }
            materialList.add(w);
        }
        return materialList;
    }

    public PageReference addCustomersToRebate(){
        debug('addCustomersToRebate');
        List<Pricing_RebateCustomerInfo> customersToAdd = new
        List<Pricing_RebateCustomerInfo>();
        List<Pricing_RebateAccountWrapper> a2list = new
        List<Pricing_RebateAccountWrapper>(accountList);
        for(Pricing_RebateAccountWrapper a1 : selectedCustomers){
            boolean isAccPresent = false;
            for(Pricing_RebateAccountWrapper a2 : a2list){
                if(a2.acc.Id == a1.acc.Id) {
                    isAccPresent = true; break;
                }
            }
            if(!isAccPresent) {a2list.add(a1);}
        }
        selectedCustomers = new List<Pricing_RebateAccountWrapper>();
        for(Pricing_RebateAccountWrapper a2 : a2list){
            if (!a2.addToRebate){continue;}
            Pricing_RebateCustomerInfo custInfo = new
            Pricing_RebateCustomerInfo(a2.acc, tables);
            if(a2.rebateDetail != null){
                custInfo.rebateDetail = a2.rebateDetail;
                custInfo.displayDeleteCheckBox = a2.displayDeleteCheckBox;
            } else {
                Pricing_Rebate_Detail__c rebateDetail = new Pricing_Rebate_Detail__c();
                if(!isNull(conditionType) && !conditionType.contains('%')) {
                    if(Pricing_RebateProperties.UOMDefault.equalsIgnoreCase(rebate.Sales_Org__c))
                        rebateDetail.UoM__c = 'LB';
                    else
                        rebateDetail.UoM__c = 'KG';
                    rebateDetail.Unit__c = currencyCode;
                    rebateDetail.Per__c = 1;
                }
                rebateDetail.Account__c = a2.acc.Id;
                rebateDetail.Pricing_Rebate__c = rebate.Id;
                custInfo.rebateDetail = rebateDetail;
                custInfo.displayDeleteCheckBox = true;
            }
            if (custInfo.accountLevel == SHIPTO) {renderShiptoLvlMsg = true;}
            customersToAdd.add(custInfo);
            a2.addToRebate = false;
            selectedCustomers.add(a2);
        }
        Set<Id> uniqueCustomerIds = new Set<Id>();
        if(customersAdded != null) {
            for(Pricing_RebateCustomerInfo prci : customersAdded)
                uniqueCustomerIds.add(prci.acc.Id);
        }
        if(!customersToAdd.isEmpty() && customersAdded != null) {
            for(Pricing_RebateCustomerInfo prci : customersToAdd) {
                if(!uniqueCustomerIds.contains(prci.acc.Id))
                    customersAdded.add(prci);
            }
        } else
        if(!customersToAdd.isEmpty() && customersAdded == null) {
            customersAdded = customersToAdd;
        }
        debug('addCustomersToRebate : customersAdded = ' + customersAdded);
        displayCustomerSelector = false; displayMaterialSelector = false;
        displayRebatePage = true;
        setReadOnlyTables(); apc = null;
        return null;
    }

    public void setRenderShiptoLvlMsg() {
        renderShiptoLvlMsg = false; if (customersAdded == null) {return;}
        debug('setRenderShiptoLvlMsg');
        for (Pricing_RebateCustomerInfo c : customersAdded) {
            if (c.accountLevel == SHIPTO && !c.accountLevelReadonly) {renderShiptoLvlMsg = true; break;}
        }
    }

    public PageReference addMaterialsToRebate(){
        debug('addMaterialsToRebate');
        List<Pricing_RebateMaterialInfo> materialsToAdd = new
        List<Pricing_RebateMaterialInfo>();
        List<Pricing_RebateMaterialWrapper> m2list = new
        List<Pricing_RebateMaterialWrapper>(materialList);
        for (Pricing_RebateMaterialWrapper m1 : selectedMaterials){
            boolean isMaterialPresent = false;
            for(Pricing_RebateMaterialWrapper m2 : m2list){
                if(m2.material.Id == m1.material.Id) {
                    isMaterialPresent = true; break;
                }
            }
            if(!isMaterialPresent) {m2list.add(m1);}
        }
        selectedMaterials = new List<Pricing_RebateMaterialWrapper>();
        for(Pricing_RebateMaterialWrapper m2 : m2list){
            if (!m2.addToRebate){continue;}
            Pricing_RebateMaterialInfo materialInfo = new Pricing_RebateMaterialInfo();
            materialInfo.material = m2.material;
            materialInfo.materialNumber = m2.materialNumber;
            if (m2.rebateDetail != null){
                materialInfo.rebateDetail = m2.rebateDetail;
                materialInfo.displayDeleteCheckBox = m2.displayDeleteCheckBox;
            } else {
                Pricing_Rebate_Detail__c rebateDetail = new Pricing_Rebate_Detail__c();
                if(!isNull(conditionType) && !conditionType.contains('%')) {
                    if(Pricing_RebateProperties.UOMDefault.equalsIgnoreCase(rebate.Sales_Org__c))
                        rebateDetail.UoM__c = 'LB';
                    else
                        rebateDetail.UoM__c = 'KG';
                    rebateDetail.Unit__c = currencyCode;
                    rebateDetail.Per__c = 1;
                }
                rebateDetail.Material_Sales_Data2__c = m2.material.Id;
                rebateDetail.Pricing_Rebate__c = rebate.Id;
                materialInfo.rebateDetail = rebateDetail;
                materialInfo.displayDeleteCheckBox = true;
            }
            materialsToAdd.add(materialInfo);
            m2.addToRebate = false;
            selectedMaterials.add(m2);
        }
        Set<Id> uniqueMaterialIds = new Set<Id>();
        if (materialsAdded != null) {
            for(Pricing_RebateMaterialInfo prmi : materialsAdded)
                uniqueMaterialIds.add(prmi.material.Id);
        }
        if (!materialsToAdd.isEmpty() && materialsAdded != null) {
            for (Pricing_RebateMaterialInfo prmi : materialsToAdd) {
                if (!uniqueMaterialIds.contains(prmi.material.Id))
                    materialsAdded.add(prmi);
            }
        } else
        if (!materialsToAdd.isEmpty() && materialsAdded == null) {
            materialsAdded = materialsToAdd;
        }

        displayCustomerSelector = false; displayMaterialSelector = false;
        displayRebatePage = true;
        setReadOnlyTables(); mpc = null;
        return null;
    }

    public PageReference cancelCustomerSelector(){
        debug('cancelCustomerSelector');
        displayCustomerSelector = false; displayMaterialSelector = false;
        displayRebatePage = true;
        return null;
    }

    public PageReference clearCustomerSelector(){
        debug('clearCustomerSelector');
        displayCustomerSelector = true;
        if(!isReadOnly)
            custSearch.salesOrg = '';
        custSearch.accNumber = '';
        if(!isReadOnly)
            custSearch.distChannel = '';
        custSearch.accName = '';
        if(!isReadOnly)
            custSearch.division = '';
        custSearch.accCity = '';
        custSearch.active = '';
        accountList = null;
        displayNext = false;
        displayPrevious = false;
        return null;
    }

    public PageReference deleteCustomers(){
        debug('deleteCustomers');
        List<Pricing_RebateCustomerInfo> customersAddedCopy = new
        List<Pricing_RebateCustomerInfo>(customersAdded);
        customersAdded = new List<Pricing_RebateCustomerInfo>();
        for (Pricing_RebateCustomerInfo customerAdded : customersAddedCopy){
            if (customerAdded.deleteCustomer == null || !customerAdded.deleteCustomer){
                customersAdded.add(customerAdded);
            }
        }
        if (customersAdded.isEmpty()) {customersAdded = null;}
        setReadOnlyTables();
        return null;
    }

    public PageReference deleteMaterials(){
        debug('deleteMaterials');
        List<Pricing_RebateMaterialInfo> materialsAddedCopy = new
        List<Pricing_RebateMaterialInfo>(materialsAdded);
        materialsAdded = new List<Pricing_RebateMaterialInfo>();
        for (Pricing_RebateMaterialInfo materialAdded : materialsAddedCopy){
            if (materialAdded.deleteMaterial == null || !materialAdded.deleteMaterial){
                materialsAdded.add(materialAdded);
            }
        }
        if (materialsAdded.isEmpty()) {materialsAdded = null;}
        setReadOnlyTables();
        return null;
    }

    public PageReference cancelMaterialSelector(){
        debug('cancelMaterialSelector');
        displayCustomerSelector = false; displayMaterialSelector = false;
        displayRebatePage = true;
        return null;
    }

    public PageReference clearMaterialSelector(){
        debug('clearMaterialSelector');
        displayMaterialSelector = true;
        if(!isReadOnly)
            materialSearch.salesOrg = null;
        materialSearch.materialNumber = '';
        if(!isReadOnly)
            materialSearch.distChannel = null;
        materialSearch.materialDesc = '';
        materialSearch.prodHierarchy5 = '';
        materialSearch.prodHierarchy6 = '';
        displayNext = false;
        displayPrevious = false;
        materialList = null;
        return null;
    }

    private void addErrorMsg(String s) {
        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, s));
    }

    private Boolean validateDate(Date startDate, Date endDate){
        debug('validateDate');
        Integer daysDiff = startDate.daysBetween(endDate);
        if(daysDiff < 0 || daysDiff > 1096)
            return false;
        else
            return true;
    }

    private Integer getMaxAmountLimit1() {
        Integer maxAmountLimit1 = 20;
        if (rebateRecipient != null) {
    //Line No:1220 Last Modified by Mukul Singh TechM for INC000000616833, maxAmountLimit1 from 40 to 45
            if (SAP_Queries_Functions.isAHWT(rebateRecipient)) {maxAmountLimit1 = 45;}
        }
        return maxAmountLimit1;
    }

    private Integer getMaxAmountLimit2() {return 30;}

    public String validateCustomerInformation(){
        if (customersAdded == null){return null;}
        debug('validateCustomerInformation');
        Integer m1 = getMaxAmountLimit1(), m2 = getMaxAmountLimit2();
        if (displayonlyAmountAndAccrual != null && displayonlyAmountAndAccrual){
            for (Pricing_RebateCustomerInfo custInfo : customersAdded){
                if (custInfo.rebateDetail.Amount__c == null ||
                    custInfo.rebateDetail.Accrual__c == null)
                    return 'When condition type is %, Amount and Accrual are required.';
                if (custInfo.rebateDetail.Amount__c < 0 ||
                    custInfo.rebateDetail.Accrual__c < 0)
                    return 'No negative numbers for Amount and Accrual in Customer Information.';
                if (custInfo.rebateDetail.Amount__c > m1 ||
                    custInfo.rebateDetail.Accrual__c > m1)
                    return 'If the condition type is %, then the fields Amount and ' +
                           'Accrual should not exceed ' + m1;
            }
        } else {
            for (Pricing_RebateCustomerInfo custInfo : customersAdded){
                if (custInfo.rebateDetail.Amount__c == null ||
                    custInfo.rebateDetail.Accrual__c == null ||
                    custInfo.rebateDetail.Unit__c == null ||
                    custInfo.rebateDetail.Per__c == null ||
                    custInfo.rebateDetail.UoM__c == null)
                    return 'When condition type is amount, all fields are required (except MFD).';
                if (custInfo.rebateDetail.Amount__c < 0 ||
                    custInfo.rebateDetail.Accrual__c < 0)
                    return 'No negative numbers for Amount and Accrual in Customer Information.';
                if (custInfo.rebateDetail.Amount__c > m2 ||
                    custInfo.rebateDetail.Accrual__c > m2)
                    return 'If the condition type is amount, then the fields Amount and ' +
                           'Accrual should not exceed ' + m2;
            }
        }
        return null;
    }

    public String validateMFD() {
        debug('validateMFD');
        String error = ' ';
        if((Pricing_RebateProperties.ApprovedStatus.equalsIgnoreCase(rebate.Status__c) ||
            rebate.Cloned_from_Pricing_Rebate__c != null) && displayCustomerAndMaterial) {
            Integer custMFDCount = 0, matMFDCount = 0, newCustCount = 0, newMatCount = 0;
            if(customersAdded != null && !customersAdded.isEmpty()) {
                for(Pricing_RebateCustomerInfo prci : customersAdded) {
                    if(prci.mfd == true) custMFDCount++;
                    if(prci.displayDeleteCheckBox != null &&
                       prci.displayDeleteCheckBox) {newCustCount++;}
                }
                if(materialsAdded != null && !materialsAdded.isEmpty()) {
                    for(Pricing_RebateMaterialInfo prmi : materialsAdded) {
                        if(prmi.mfd == true) matMFDCount++;
                        if(prmi.displayDeleteCheckBox != null &&
                           prmi.displayDeleteCheckBox) {newMatCount++;}
                    }
                    if(newMatCount > 0 && custMFDCount > 0 &&
                       custMFDCount == customersAdded.size()) {
                        error += 'When adding a new material to an approved or cloned rebate, '
                               + 'at least one customer must NOT be Marked for Deletion.';
                    }
                    if(newCustCount > 0 && matMFDCount > 0 &&
                       matMFDCount == materialsAdded.size()) {
                        error += ' When adding a new customer to an approved or cloned rebate, '
                               + 'at least one material must NOT be Marked for Deletion.';
                    }
                }
            }
        }
        return error;
    }

    public String validateMaterialInformation(){
        if(materialsAdded == null){return null;}
        debug('validateMaterialInformation');
        Integer m1 = getMaxAmountLimit1(), m2 = getMaxAmountLimit2();
        if (displayonlyAmountAndAccrual != null && displayonlyAmountAndAccrual){
            for (Pricing_RebateMaterialInfo matInfo : materialsAdded){
                if (matInfo.rebateDetail.Amount__c == null ||
                    matInfo.rebateDetail.Accrual__c == null)
                    return 'When condition type is %, Amount and Accrual are required.';
                if (matInfo.rebateDetail.Amount__c < 0 ||
                    matInfo.rebateDetail.Accrual__c < 0)
                    return 'No negative numbers for Amount and Accrual in Material Information.';
                if (matInfo.rebateDetail.Amount__c > m1 ||
                    matInfo.rebateDetail.Accrual__c > m1)
                    return 'If the condition type is %, then the fields Amount and ' +
                           'Accrual should not exceed ' + m1;
            }
        } else {
            for (Pricing_RebateMaterialInfo matInfo : materialsAdded){
                if (matInfo.rebateDetail.Amount__c == null ||
                    matInfo.rebateDetail.Accrual__c == null ||
                    matInfo.rebateDetail.Unit__c == null ||
                    matInfo.rebateDetail.Per__c == null ||
                    matInfo.rebateDetail.UoM__c == null)
                    return 'When condition type is amount, all fields are required (except MFD).';
                if (matInfo.rebateDetail.Amount__c < 0 ||
                    matInfo.rebateDetail.Accrual__c < 0)
                    return 'No negative numbers for Amount and Accrual in Material Information.';
                if (matInfo.rebateDetail.Amount__c > m2 ||
                    matInfo.rebateDetail.Accrual__c > m2)
                    return 'If the condition type is amount, then the fields Amount and ' +
                           'Accrual should not exceed ' + m2;
            }
        }
        return null;
    }

    private Map<String, String> getTableMap() {
        debug('getTableMap');
        Map<String, String> tmap = new Map<String, String>();
        if (!isNull(tables)) {
            String[] sa = tables.split(COMMA);
            if (sa != null && !sa.isEmpty()) {
                for (String s : sa) {s = s.trim();
                    if (s.contains(SOLDTO)) {tmap.put(SOLDTO, s);} else
                    if (s.contains(SHIPTO)) {tmap.put(SHIPTO, s);}
                }
            }
        }
        return tmap;
    }

    private String getRebateDetailKey(Pricing_Rebate_Detail__c d) {
        if (isNull(d.Account__c) || isNull(d.Material_Sales_Data2__c)) {return '';}
        return ('' + d.Account__c + d.Material_Sales_Data2__c);
    }

    private String getRebateDetailKey(Pricing_RebateCustomerInfo c,
                                      Pricing_RebateMaterialInfo m) {
        if (isNull(c.acc.Id) || isNull(m.material.Id)) {return '';}
        return ('' + c.acc.Id + m.material.Id);
    }

    private Set<String> getRebateDetailKeys() {
        debug('getRebateDetailKeys');
        Set<String> aset = new Set<String>();
        if (customersAdded == null || materialsAdded == null) {return aset;}
        for(Pricing_RebateCustomerInfo c : customersAdded) {
            for(Pricing_RebateMaterialInfo m : materialsAdded) {
                aset.add(getRebateDetailKey(c, m));
            }
        }
        return aset;
    }

    private void setMFDCheckbox(Pricing_Rebate_Detail__c[] prds) {
        debug('setMFDCheckbox');
        if (customersAdded != null && !customersAdded.isEmpty() &&
            prds != null && !prds.isEmpty()) {
            for (Pricing_RebateCustomerInfo customer : customersAdded) {
                for (Pricing_Rebate_Detail__c prd : prds) {
                    if (prd.Account__c == customer.rebateDetail.Account__c)
                        prd.MFD__c = customer.mfd;
                }
            }
            for (Pricing_RebateMaterialInfo material : materialsAdded) {
                for (Pricing_Rebate_Detail__c prd : prds) {
                    if (prd.Material_Sales_Data2__c == material.rebateDetail.Material_Sales_Data2__c &&
                       !prd.MFD__c) {prd.MFD__c = material.mfd;}
                }
            }
        }
    }

    private String getTable(String accLvl, Map<String, String> tableMap) {
        if (tableMap != null && !isNull(accLvl) &&
            tableMap.containsKey(accLvl)) {return tableMap.get(accLvl);}
        return null;
    }

    private Pricing_Rebate_Detail__c getRebateDetail(Pricing_Rebate__c r,
        Map<String, String> tableMap, Pricing_RebateCustomerInfo c) {
        Pricing_Rebate_Detail__c d = new Pricing_Rebate_Detail__c();
        setRebateDetail(r, tableMap, c, d);
        return d;
    }

    private void setRebateDetail(Pricing_Rebate__c r,
        Map<String, String> tableMap, Pricing_RebateCustomerInfo c, Pricing_Rebate_Detail__c d) {
        debug('setRebateDetail');
        d.Account__c = c.acc.Id;
        d.Table__c = getTable(c.accountLevel, tableMap);
        d.Accrual__c = c.rebateDetail.Accrual__c;
        d.Amount__c = c.rebateDetail.Amount__c;
        d.Unit__c = c.rebateDetail.Unit__c;
        d.Per__c = c.rebateDetail.Per__c;
        d.UoM__c = c.rebateDetail.UoM__c;
        d.Pricing_Rebate__c = r.Id;
    }

    private Pricing_Rebate_Detail__c getRebateDetail(Pricing_Rebate__c r,
        Map<String, String> tableMap, Pricing_RebateCustomerInfo c, Pricing_RebateMaterialInfo m) {
        Pricing_Rebate_Detail__c d = new Pricing_Rebate_Detail__c();
        setRebateDetail(r, tableMap, c, m, d);
        return d;
    }

    private void setRebateDetail(Pricing_Rebate__c r, Map<String, String> tableMap,
        Pricing_RebateCustomerInfo c, Pricing_RebateMaterialInfo m, Pricing_Rebate_Detail__c d) {
        debug('setRebateDetail');
        d.Account__c = c.acc.Id;
        d.Table__c = getTable(c.accountLevel, tableMap);
        d.Accrual__c = m.rebateDetail.Accrual__c;
        d.Amount__c = m.rebateDetail.Amount__c;
        d.Unit__c = m.rebateDetail.Unit__c;
        d.Per__c = m.rebateDetail.Per__c;
        d.UoM__c = m.rebateDetail.UoM__c;
        d.Material_Sales_Data2__c = m.material.Id;
        d.Pricing_Rebate__c = r.Id;
    }

    public Id cloneRebateAndDetailInfo(){
        debug('cloneRebateAndDetailInfo');
        Pricing_Rebate__c newRebate = rebate.clone(false, true);
        newRebate.Rebate_Agreement_Type__c = rebateAgreementType;
        newRebate.Condition_Type__c = conditionType;
        newRebate.Tables__c = tables;
        newRebate.Status__c = Pricing_RebateProperties.DraftStatus;
        newRebate.Cloned_from_Pricing_Rebate__c = rebate.Id;
        insert newRebate;
        Map<String, String> tableMap = getTableMap();
        Map<Id, List<Pricing_Rebate_Detail__c>> accandRebateMap = new
        Map<Id, List<Pricing_Rebate_Detail__c>>();
        List<Pricing_Rebate_Detail__c> upsertRebateDetails = new
        List<Pricing_Rebate_Detail__c>();
        Set<Id> materialCustIds = new Set<Id>(); String k;
        List<Pricing_Rebate_Detail__c> cloneRebateDetails = new
        List<Pricing_Rebate_Detail__c>();

        Map<Id, Pricing_Rebate_Detail__c> rebateDetailMap = new
        Map<Id, Pricing_Rebate_Detail__c>([
            select UoM__c, Unit__c, Pricing_Rebate__c, Per__c, Name,
                   Material_Sales_Data2__c, MFD__c, Id, Amount__c,
                   Accrual__c, Account__c, Account__r.SAP_Sales_Org__c,
                   Account__r.SAP_Sales_Org_Desc__c, Account__r.SAP_DistChannel__c,
                   Account__r.SAP_Dist_Channel_Desc__c, Account__r.Name,
                   Account__r.SAP_DivisionCode__c, Account__r.SAP_Division_Desc__c,
                   Account__r.Account_Number__c, Account__r.AccountNumber,
                   Material_Sales_Data2__r.Material_Number__c,
                   Material_Sales_Data2__r.Name
              from Pricing_Rebate_Detail__c
             where Pricing_Rebate__c = :rebate.Id]);
        Set<String> kset = getRebateDetailKeys();
        for(Pricing_Rebate_Detail__c d : rebateDetailMap.values()){
            k = getRebateDetailKey(d);
            if (!kset.contains(k)) {continue;}
            Pricing_Rebate_Detail__c newRebateDetail = d.clone(false,true);
            newRebateDetail.Pricing_Rebate__c = newRebate.Id;
            newRebateDetail.Approved_Rebate__c = true;
            cloneRebateDetails.add(newRebateDetail);
        }

        if (!cloneRebateDetails.isEmpty()) {
            insert cloneRebateDetails;
            for(Pricing_Rebate_Detail__c d : cloneRebateDetails){
                if(accandRebateMap.containsKey(d.Account__c)){
                    accandRebateMap.get(d.Account__c).add(d);
                } else {
                    List<Pricing_Rebate_Detail__c> rebateDetails = new
                    List<Pricing_Rebate_Detail__c>();
                    rebateDetails.add(d);
                    accandRebateMap.put(d.Account__c,rebateDetails);
                }
            }
        }

        if (displayCustomerAndMaterial){
            if (customersAdded != null){
                Map<String, Pricing_Rebate_Detail__c> materialRebateMap = new
                Map<String, Pricing_Rebate_Detail__c>();
                for(Pricing_Rebate_Detail__c d : cloneRebateDetails){
                    materialRebateMap.put(getRebateDetailKey(d),d);
                }
                for (Pricing_RebateCustomerInfo customer : customersAdded){
                    if (accandRebateMap.containsKey(customer.acc.Id)){
                        for(Pricing_RebateMaterialInfo material : materialsAdded){
                            if(material.rebateDetail.Account__c != null){
                                Pricing_Rebate_Detail__c oldRebateDetail =
                                materialRebateMap.get(getRebateDetailKey(customer, material));
                                Pricing_Rebate_Detail__c d = new
                                Pricing_Rebate_Detail__c();
                                if(oldRebateDetail != null){
                                    d = new Pricing_Rebate_Detail__c(Id=oldRebateDetail.Id);
                                }
                                setRebateDetail(newrebate, tableMap, customer, material, d);
                                upsertRebateDetails.add(d);
                            } else {
                                Pricing_Rebate_Detail__c d = getRebateDetail(
                                     newrebate, tableMap, customer, material);
                                upsertRebateDetails.add(d);
                            }
                        }
                    } else {
                        for (Pricing_RebateMaterialInfo material : materialsAdded){
                            Pricing_Rebate_Detail__c d = getRebateDetail(
                                 newrebate, tableMap, customer, material);
                            upsertRebateDetails.add(d);
                        }
                    }
                }
            }
        } else {
            if (customersAdded != null){
                for(Pricing_RebateCustomerInfo customer : customersAdded){
                    if(accandRebateMap.containsKey(customer.acc.Id)){
                        Pricing_Rebate_Detail__c d = new
                        Pricing_Rebate_Detail__c(Id=accandRebateMap.get(customer.acc.Id).get(0).Id);
                        setRebateDetail(newrebate, tableMap, customer, d);
                        upsertRebateDetails.add(d);
                    } else {
                        Pricing_Rebate_Detail__c d = getRebateDetail(newrebate, tableMap, customer);
                        upsertRebateDetails.add(d);
                    }
                }
            }
        }
        setMFDCheckbox(upsertRebateDetails);
        upsert upsertRebateDetails;
        return newRebate.Id;
    }

    public void updateRebateAndDetailInfo(){
        debug('updateRebateAndDetailInfo');
        rebate.Rebate_Agreement_Type__c = rebateAgreementType;
        rebate.Condition_Type__c = conditionType;
        rebate.Tables__c = tables;
        update rebate;
        Map<String, String> tableMap = getTableMap();
        List<Pricing_Rebate_Detail__c> deleteRebateDetails = new
        List<Pricing_Rebate_Detail__c>();
        List<Pricing_Rebate_Detail__c> upsertRebateDetails = new
        List<Pricing_Rebate_Detail__c>();
        Map<Id, List<Pricing_Rebate_Detail__c>> accandRebateMap = new
        Map<Id, List<Pricing_Rebate_Detail__c>>();
        Map<Id, Map<Id, Pricing_Rebate_Detail__c>> accandMaterialRebateMap = new
        Map<Id, Map<Id,Pricing_Rebate_Detail__c>>();
        for (Pricing_Rebate_Detail__c rebateDetail : rebateDetailMap.values()){
            if (accandRebateMap.containsKey(rebateDetail.Account__c)){
                accandRebateMap.get(rebateDetail.Account__c).add(rebateDetail);
            } else {
                List<Pricing_Rebate_Detail__c> rebateDetails = new
                List<Pricing_Rebate_Detail__c>();
                rebateDetails.add(rebateDetail);
                accandRebateMap.put(rebateDetail.Account__c, rebateDetails);
            }
            if (accandMaterialRebateMap.containsKey(rebateDetail.Account__c))
                accandMaterialRebateMap.get(rebateDetail.Account__c).put(
                      rebateDetail.Material_Sales_Data2__c, rebateDetail);
            else
            {
                Map<Id, Pricing_Rebate_Detail__c> materialRebateMap = new
                Map<Id, Pricing_Rebate_Detail__c>();
                materialRebateMap.put(rebateDetail.Material_Sales_Data2__c, rebateDetail);
                accandMaterialRebateMap.put(rebateDetail.Account__c, materialRebateMap);
            }
        }
        if (displayCustomerAndMaterial){
            if (customersAdded != null){
                Map<String, Pricing_Rebate_Detail__c> materialRebateMap = new
                Map<String, Pricing_Rebate_Detail__c>();
                Map<Id, Pricing_Rebate_Detail__c> rebateDetailMap = new
                Map<Id, Pricing_Rebate_Detail__c>([
                    select UoM__c, Unit__c, Pricing_Rebate__c, Per__c, Name,
                           Material_Sales_Data2__c, Approved_Rebate__c,
                           MFD__c, Id, Amount__c, Accrual__c, Account__c,
                           Account__r.SAP_Sales_Org__c, Account__r.SAP_Sales_Org_Desc__c,
                           Account__r.SAP_DistChannel__c, Account__r.SAP_Dist_Channel_Desc__c,
                           Account__r.Name, Account__r.SAP_DivisionCode__c,
                           Account__r.SAP_Division_Desc__c, Account__r.Account_Number__c,
                           Account__r.AccountNumber, Material_Sales_Data2__r.Material_Number__c,
                           Material_Sales_Data2__r.Name
                      from Pricing_Rebate_Detail__c
                     where Pricing_Rebate__c = :rebate.Id]);
                for (Pricing_Rebate_Detail__c d : rebateDetailMap.values()){
                    materialRebateMap.put(getRebateDetailKey(d), d);
                }
                for(Pricing_RebateCustomerInfo customer : customersAdded){
                    if (accandRebateMap.containsKey(customer.acc.Id)) {
                        for(Pricing_RebateMaterialInfo material : materialsAdded){
                            if(material.rebateDetail.Account__c != null){
                                Pricing_Rebate_Detail__c oldRebateDetail =
                                materialRebateMap.get(getRebateDetailKey(customer, material));
                                Pricing_Rebate_Detail__c d = new
                                Pricing_Rebate_Detail__c(Id=accandMaterialRebateMap.get(
                                          customer.acc.Id).get(material.material.Id).Id);
                                if(oldRebateDetail != null && d.Approved_Rebate__c){
                                    d = new Pricing_Rebate_Detail__c(Id=oldRebateDetail.Id);
                                }
                                setRebateDetail(rebate, tableMap, customer, material, d);
                                d.Approved_Rebate__c = accandMaterialRebateMap.get(
                                                       customer.acc.Id).get(material.material.Id).Approved_Rebate__c;
                                upsertRebateDetails.add(d);
                            } else {
                                Pricing_Rebate_Detail__c d = getRebateDetail(rebate, tableMap, customer, material);
                                upsertRebateDetails.add(d);
                            }
                        }
                    } else {
                        for (Pricing_RebateMaterialInfo material : materialsAdded){
                            Pricing_Rebate_Detail__c d = getRebateDetail(rebate, tableMap, customer, material);
                            upsertRebateDetails.add(d);
                        }
                    }
                }
            }
        } else {
            if (customersAdded != null){
                for (Pricing_RebateCustomerInfo customer : customersAdded){
                    if (accandRebateMap.containsKey(customer.acc.Id)){
                        Pricing_Rebate_Detail__c d = new
                        Pricing_Rebate_Detail__c(Id=customer.rebateDetail.Id);
                        setRebateDetail(rebate, tableMap, customer, d);
                        d.Approved_Rebate__c = customer.rebateDetail.Approved_Rebate__c;
                        upsertRebateDetails.add(d);
                    } else { // New customer information
                        Pricing_Rebate_Detail__c d = getRebateDetail(rebate, tableMap, customer);
                        upsertRebateDetails.add(d);
                    }
                }
            }
        }
        setMFDCheckbox(upsertRebateDetails);
        upsert upsertRebateDetails;

        Set<Id> upsertIds = new Set<Id>();
        for(Pricing_Rebate_Detail__c d : upsertRebateDetails){
            if(d.Id != null) {upsertIds.add(d.Id);}
        }
        for(Pricing_Rebate_Detail__c d : rebateDetailMap.values()){
            if(!upsertIds.contains(d.Id)) {deleteRebateDetails.add(d);}
        }
        delete deleteRebateDetails;
    }

    public void saveRebateAndDetailInfo(){
        debug('saveRebateAndDetailInfo');
        rebate.Rebate_Agreement_Type__c = rebateAgreementType;
        rebate.Condition_Type__c = conditionType;
        rebate.Tables__c = tables;
        insert rebate;
        List<Pricing_Rebate_Detail__c> rebateDetailList = new List<Pricing_Rebate_Detail__c>();
        if (customersAdded != null){
            Map<String, String> tableMap = getTableMap();
            if (materialsAdded != null && !materialsAdded.isEmpty()){
                for (Pricing_RebateCustomerInfo customer : customersAdded){
                    for (Pricing_RebateMaterialInfo material : materialsAdded){
                        Pricing_Rebate_Detail__c d = getRebateDetail(rebate, tableMap, customer, material);
                        rebateDetailList.add(d);
                    }
                }
            } else {
                for (Pricing_RebateCustomerInfo customer : customersAdded){
                    Pricing_Rebate_Detail__c d = getRebateDetail(rebate, tableMap, customer);
                    rebateDetailList.add(d);
                }
            }
        }
        if (!rebateDetailList.isEmpty()) {insert rebateDetailList;}
    }

    public PageReference save(){
        debug('save');
        if(rebateAgreementType == null){addErrorMsg(ERR_03); return null;}
        if(conditionType == null){addErrorMsg(ERR_04); return null;}
        if(tables == null){addErrorMsg(ERR_05); return null;}
        if(!validateDate(rebate.Rebate_Start_Date__c, rebate.Rebate_End_Date__c )){
            addErrorMsg(ERR_06); return null;
        }
        if(!displayCustomerAndMaterial){
            if(customersAdded == null || customersAdded.isEmpty()){
                addErrorMsg(ERR_07); return null;
            }
            String custErrorMsg = validateCustomerInformation();
            if(!isNull(custErrorMsg)){addErrorMsg(custErrorMsg); return null;}
        } else {
            if((customersAdded == null || customersAdded.isEmpty()) &&
               (materialsAdded == null || materialsAdded.isEmpty())){
                addErrorMsg(ERR_08); return null;
            }
            if(customersAdded == null || customersAdded.isEmpty()){
                addErrorMsg(ERR_07); return null;
            }
            if(materialsAdded == null || materialsAdded.isEmpty()){
                addErrorMsg(ERR_09); return null;
            }
            String mfdErrorMsg = validateMFD();
            if(!isNull(mfdErrorMsg)){addErrorMsg(mfdErrorMsg); return null;}
            String matErrorMsg = validateMaterialInformation();
            if(!isNull(matErrorMsg)){addErrorMsg(matErrorMsg); return null;}
        }
        if (rebate.Id != null &&
            Pricing_Rebate_Functions.STATUS_SET1.contains(rebate.Status__c)){
            Id newRebateId = cloneRebateAndDetailInfo();
            return new PageReference('/'+newRebateId);} else
        if (rebate.Id != null){updateRebateAndDetailInfo();} else
           {saveRebateAndDetailInfo();}
        return new PageReference('/'+rebate.Id);
    }

    public PageReference saveAndSubmit(){
        debug('saveAndSubmit');
        PageReference returnPage = save();
        if(returnPage != null){
            String rebateId = returnPage.getUrl().substring(1);
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(rebateId);
            Approval.ProcessResult result = Approval.process(req1);

        }
        return returnPage;
    }

/*
    public PageReference populateCustAndMaterialInfo(){
        debug('populateCustAndMaterialInfo');
        List<String> conditionTypeList = new List<String>();
        Set<String> conditionTypeSet = new Set<String>();  String[] sa;
        if(!isNull(rebateAgreementType)){
            sa = rebateAgreementType.split('-');
            if(sa != null && sa.size() > 1){
                rebateAgmTypedesc = sa.get(1).trim();
                rebateAgmTypeCode = sa.get(0).trim();
            } else if(sa != null && sa.size() == 1){
                rebateAgmTypeCode = sa.get(0).trim();
            }
            if(Pricing_RebateProperties.CustomerMaterialRebateType.equalsIgnoreCase(rebateAgmTypeCode))
                displayCustomerAndMaterial = false;
            else
                displayCustomerAndMaterial = true;
        } else {
                displayCustomerAndMaterial = true;
        }
        distChan = rebate.Dist_Channel__c; salesOrg = rebate.Sales_Org__c;
        for (Pricing_Rebate_Configuration__c c : getRebateConfigs()){
            conditionTypeSet.add(c.Condition_Type__c + ' - ' + c.Condition_Type_Desc__c);
        }
        conditionTypeList.addAll(conditionTypeSet);
        conditionTypeOptions = Pricing_RebatePickListUtils.addPickListValuesFromList(conditionTypeList, false);
        if(String.isBlank(conditionType) && !conditionTypeList.isEmpty()) {
            conditionType = conditionTypeList.get(0);}
        debug('conditionType = ' + conditionType);
        getRebateTables(); tables = null; initTableList();
        return null;
    }
*/

    public void submitRecipient(){
        debug('submitRecipient');
        String selectedAccId = System.currentPagereference().getParameters().get('SelectedAccId');
        for(Pricing_RebateAccountWrapper acc : accountList){
            if(selectedAccId == acc.acc.Id){
                rebate.Rebate_Recipient__c = acc.acc.Id;
                break;
            }
        }
        if (rebate.Rebate_Recipient__c != null) {
            rebateRecipient = Pricing_Rebate_Functions.getAccount(rebate.Rebate_Recipient__c);
        }
        displayCustomerSelector = false; displayMaterialSelector = false; displayRebatePage = true;
        isReadOnly = true; apc = null; init1();
    }

    public void updateRebateInfo() {
        if (rebate.Id == null) {return;}
        debug('updateRebateInfo');
        ApexPages.Severity inf = ApexPages.Severity.INFO, err = ApexPages.Severity.ERROR;
        Pricing_Rebate__c pr = new Pricing_Rebate__c(Id=rebate.Id);
        pr.SAP_Rebate_Agreement_Number__c = rebate.SAP_Rebate_Agreement_Number__c;
        ApexPages.Message msg1 = new ApexPages.Message(inf, 'SAP Rebate Agreement Number');
        try {
            update pr;
            Apexpages.addMessage(new ApexPages.Message(inf, 'Updated the following Info:'));
            Apexpages.addMessage(msg1);
        } catch(Exception e) {
            Apexpages.addMessage(new ApexPages.Message(err, e.getMessage()));
        }
    }

    public PageReference deleteRebate() {
        if (rebate == null || rebate.Id == null) {return null;}
        debug('deleteRebate');
        PageReference pr = new PageReference('/'+rebate.Rebate_Recipient__c);
        ApexPages.Severity err = ApexPages.Severity.ERROR;
        try {delete rebate;}
        catch(Exception e) {
            pr = null; Apexpages.addMessage(new ApexPages.Message(err, e.getMessage()));
        }
        return pr;
    }

    public void copyCustomerValues() {
        if (customersAdded == null || customersAdded.size() < 2) {return;}
        debug('copyCustomerValues');
        Pricing_RebateCustomerInfo p1 = customersAdded[0];
        for (Integer i = 1; i < customersAdded.size(); i++) {
            Pricing_RebateCustomerInfo p2 = customersAdded[i];
            p2.rebateDetail.Amount__c = p1.rebateDetail.Amount__c;
            p2.rebateDetail.Unit__c = p1.rebateDetail.Unit__c;
            p2.rebateDetail.UoM__c = p1.rebateDetail.UoM__c;
            p2.rebateDetail.Accrual__c = p1.rebateDetail.Accrual__c;
        }
    }

    public void copyMaterialValues() {
        if (materialsAdded == null || materialsAdded.size() < 2) {return;}
        debug('copyMaterialValues');
        Pricing_RebateMaterialInfo p1 = materialsAdded[0];
        for (Integer i = 1; i < materialsAdded.size(); i++) {
            Pricing_RebateMaterialInfo p2 = materialsAdded[i];
            p2.rebateDetail.Amount__c = p1.rebateDetail.Amount__c;
            p2.rebateDetail.Unit__c = p1.rebateDetail.Unit__c;
            p2.rebateDetail.UoM__c = p1.rebateDetail.UoM__c;
            p2.rebateDetail.Accrual__c = p1.rebateDetail.Accrual__c;
        }
    }

    public PageReference gotoAccountPage() {
        accountPageRef = new PageReference('/' + accountId);
        return accountPageRef;
    }

}
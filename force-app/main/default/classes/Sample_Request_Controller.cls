public without sharing class Sample_Request_Controller {

  private static final Integer PAGE_SIZE = 200;
  private static final Integer MAX_COUNT_1 = 200;
  private static final Map<String, Schema.RecordTypeInfo> SAMP_RECTYPES = Sample_Request__c.sObjectType.getDescribe().getRecordTypeInfosByName();
  private static final String SREQ_PAGE1A_URL = '/apex/Sample_Request_Page_1A';
  private static final String SERVER_URL = URL.getSalesforceBaseUrl().toExternalForm();
  private static final String draftRecTypeId = RecordType_Functions.LookupRecordTypeId('Draft','Sample_Request__c');

  private static final String ADDRESS_TYPE_ACCOUNT = 'Address from Account';
  private static final String ADDRESS_TYPE_CONTACT = 'Address from Contact';
  private static final String ADDRESS_TYPE_MANUAL  = 'Manually Entered Address';

  public static final Set<String> SAMPLE_CENTERS_CMC = Sample_Request_Config.getCMCSampleCenters();
  public static final Set<String> SAMPLE_CENTERS_LAB = Sample_Request_Config.getLabSampleCenters();
  public static final Set<String> SAMPLE_CENTERS_OTH = Sample_Request_Config.getOthSampleCenters();
  public static final Set<String> SAMPLE_CENTERS_SPS = Sample_Request_Config.getSPSSampleCenters();
  public static final Set<String> CANCELLED_STATS    = Sample_Request_Config.CANCELLED_STATS;

  Map<String, String> params;

  Account account;
  String accountRecordType;
  Case tsr;
  Contact contact;
  Opportunity opportunity;
  User usr;
  Sample_Material__c sampleMaterial;
  public Sample_Request__c sampleRequest;
  Sample_Request__c AccountAddressEntry;
  Sample_Request__c ContactAddressEntry;
  Sample_Request__c ManualAddressEntry;
  Boolean sampleRequestFromContact;
  String sobjId;
  public Sample_Request_Aquarius__c aquarius {get; set;}
  public Sample_Request_Aquarius aquariusRequest {get; set;}
  public List<Sample_Material__c> sampleMaterials;
  String validationErrorMessage = '', cancelURL = '';
  public boolean activeAccount {get; set;}
  public boolean emailcsrgroupbox{get; set;}
  public boolean disableAquariusBtn {get; private set;}
  public boolean renderApprovalProcPB {get; private set;}
  public boolean renderAquariusForm {get; private set;}
  public boolean renderPacIndustryInput {get; private set;}
  public boolean renderSampleCenterInput {get; private set;}
  public boolean renderSampleReasonInput {get; private set;}
  public boolean renderShipFromLocation {get; private set;}
  public boolean renderShipmntNotify {get; private set;}
  public boolean renderSmallPackSale {get; private set;}
  public boolean renderSmallPackChkbox {get; private set;}
  public boolean renderSpecSizeBtn {get; private set;}
  public boolean renderAddMaterialsBtn {get; private set;}
  public boolean renderMaxMsg1 {get; private set;}
  public boolean renderStep1PB1 {get; private set;}
  public boolean renderStep1PB2 {get; private set;}
  public boolean renderGoto1A {get; private set;}
  public boolean renderGoto2A {get; private set;}
  public boolean renderPage2A {get; private set;}
  public boolean renderemailcsrgroupbox{get; set;}
  public boolean readonlyInvoiceAddress {get; set;}
  public boolean commercialOrder {get; set;}
  public boolean noncmrcialOrder {get; set;}

  public Integer maxCount1 {get; private set;}
  public Integer qtyDecimals {get; private set;}
  public String getValidationErrorMessage() {return validationErrorMessage;}
  public String Carrier{get; set;}
  public String caseLabel {get; private set;}
  public String userLocale {get; private set;}
  public task onhold_followup_task{get; set;}
  public List<SelectOption> uomSelectOptions, countrySelectOptions,
                            salutationOptions, sampleCenterOpts,
                            sampleReasonOpts,filteredOptions, shipFromLocOpts,
                            distChanOpts, salesOrgOpts, matStatOpts;
  public List<SampleMaterial> materials {get; private set;}
  public Contact labContact {get; set;}

  private String accountId, contactId, opprtnyId, smpReason, smpRqstId;
  private List<Contact> contacts;
  public String contactSelected {get; set;}
  public String sampleReason {get; set;}

  public String totalItemCost {get; set;}
  public String totalSampCost {get; set;}
  public Integer pageSize {get; set;}

  public boolean renderLisd {get; private set;}
  public SAP_LISD lisd  {get; set;}

  private List<SelectOption> relatedAccountsList = new List<SelectOption>();
  public List<SelectOption> newOppAcctListOptions {get { return relatedAccountsList; } }
  public String newOppAcctList {get;set;}

  Map<String, List<Id>> partnerIds = new Map<String, List<Id>>();
  Map<Id, Account> accMap = new Map<Id, Account>();

    public Sample_Request_Controller(ApexPages.StandardController sc) {
        debug('SRC.Constructor(sc)'); init(sc.getRecord());
    }

    public Sample_Request_Controller() {
        debug('SRC.Constructor()');   init(new Sample_Request__c());
    }

    private void debug(String s) {System.debug(LoggingLevel.INFO, '>>>>>>>>> ' + s);}

    private Boolean isNull(String s) {return (s == null || s.trim().length() == 0);}

    private Boolean isNone(String s) {return isNull(s) || s.equals(SAP_LISD_Functions.NONE);}

    public Boolean isAHWT {
        get {return Sample_Request_Functions.isAWT(account);}
    }

    public Boolean isAPM {
        get {return Sample_Request_Functions.isAPM(account);}
    }

    public Boolean isASI {
        get {return Sample_Request_Functions.isASI(account);}
    }

    public Boolean isASK {
        get {return Sample_Request_Functions.isASK(account);}
    }

    public Boolean isFlint {
        get {return Sample_Request_Functions.isFlint(account);}
    }

    public Boolean isVALV {
        get {return Sample_Request_Functions.isACM(account);}
    }

    private String getString(String s) {if (isNone(s)) {return '';} return s;}

    private void addInfoMsg(String s) {
        ApexPages.Severity mtype = ApexPages.Severity.INFO;
        ApexPages.Message msg = new ApexPages.Message(mtype, s);
        ApexPages.addMessage(msg);
    }

    private void addErrMsg(String s) {
        ApexPages.Severity mtype = ApexPages.Severity.ERROR;
        ApexPages.Message msg = new ApexPages.Message(mtype, s);
        ApexPages.addMessage(msg);
    }

    private void addErrorMessage() {addErrMsg(validationErrorMessage);}

    private void addReqMsg(String s) {addErrMsg('Required a value for : <b>' + s + '</b>');}

    private void init(SObject sobj) {
        usr = User_Functions.getLoggedInUser();
        if (sobj != null) {
            sobjId = sobj.Id;
            if (sobj.getSObjectType() == Sample_Request__c.sObjectType) {
                sampleRequest = (Sample_Request__c)sobj;
            } else {initParams(); return;}
        }
        init();
    }

    private void initParams() {
        params = System.currentPageReference().getParameters();
        debug('params = ' + params);
        accountId = params.get('accountId');
        contactId = params.get('contactId');
        sampleRequestFromContact = !isNull(contactId);
        opprtnyId = params.get('oppId');
        smpReason = params.get('reason');
        smpRqstId = params.get('sampleRequestId');
        if (!isNull(smpRqstId)) {sobjId = smpRqstId;}
    }

    public void init() {
        debug('init : lisd = ' + lisd); lisd = null;
        userLocale = UserInfo.getLocale(); qtyDecimals = 2;
        renderLisd = true; renderPage2A = false; renderGoto1A = false; renderGoto2A = false;
        renderStep1PB1 = true; renderOppsPB = false; renderOppsList = false;
        renderSmallPackSale = false; readonlyInvoiceAddress = false;
        commercialOrder = false; noncmrcialOrder = false; createNewOpp = false;
        contact = null; contactId = null; contacts = null; sampleRequest = null;
        matSrchString = ''; contactSelected = ''; labContactName = ''; caseLabel = 'Case';
        totalItemCost = ''; totalSampCost = ''; materials = new List<SampleMaterial>();
        maxCount1 = MAX_COUNT_1; pageSize = PAGE_SIZE; renderMaxMsg1 = false;
        renderApprovalProcPB = false; renderAquariusForm = false; renderNochargeInput = false;
        renderSampleCenterInput = true; renderSampleReasonInput = false;
        renderLabContactInput = false; renderLabContactOutput = false;
        renderMatCatalog = false; renderMatCatalogPB = false;
        renderSpecialSize = false; renderSpecSizeBtn = false;
        renderShipFromLocation = false; renderConfirmDialogComp = false;
        sampleReason = Sample_Request_Config.RFS_OTHER; matStat = Sample_Request_Functions.ALL;
        labContact = new Contact();
        accountAddressEntry = new Sample_Request__c();
        contactAddressEntry = new Sample_Request__c();
        manualAddressEntry = new Sample_Request__c();

        initParams();

        sampleRequest = getSampleRequest(); if (isSampleRequestCancelled()) {return;}
        if (isNull(sampleRequest.Account__c) && !isNull(accountId)) {
            sampleRequest.Account__c = accountId;}
        if (isNull(sampleRequest.Contact__c) && !isNull(contactId)) {
            sampleRequest.Contact__c = contactId;}
        if (isNull(sampleRequest.Opportunity__c) && !isNull(opprtnyId)) {
            sampleRequest.Opportunity__c = opprtnyId;}
        if (isNull(sampleRequest.Reason_for_Sample__c)) {
            sampleRequest.Reason_for_Sample__c = smpReason;}

        initAccount();
        opportunity = getOpportunity();

        cancelURL = '/';
        if (!isNull(smpRqstId)) {cancelURL += smpRqstId;} else
        if (sampleRequestFromContact) {cancelURL += contactId;} else
        if (!isNull(opprtnyId)) {cancelURL += opprtnyId;} else
        if (!isNull(accountId)) {cancelURL += accountId;}

        showRelatedOpp = false;
    }

    public void onLisdComplete() {
        debug('onLisdComplete : lisd = ' + lisd);
        /*
        renderPage2A = (lisd != null && lisd.readOnlyInputs);
        renderGoto1A = (lisd != null && !lisd.readOnlyInputs);
        renderGoto2A = (lisd != null && !lisd.readOnlyInputs &&
                        lisd.seller != null && lisd.seller.Id != null);
        */

        renderPage2A = (lisd != null && !lisd.isMultiIndustyAcc);
        renderGoto1A = (lisd != null && lisd.isMultiIndustyAcc);
        renderGoto2A = (lisd != null && lisd.isMultiIndustyAcc &&
                        lisd.seller != null && lisd.seller.Id != null);

        if (lisd != null && lisd.acc != null) {
            sampleRequest.Account__c = lisd.acc.Id; initAccount();
        }
    }

    private void initAccount() {
        account = getAccount(); activeAccount = true; renderConfirmDialogComp = false;
        if (account != null && account.Inactive_Account__c != null && account.Inactive_Account__c) {
            activeAccount = false; initConfirmDialog();
        }
        if (isAHWT) {qtyDecimals = 5;}
        if (isASI) {caseLabel = 'Tech Service Request';}
        setAddress();
    }

    public ConfirmDialogParam cdp {get; private set;}

    public Boolean renderConfirmDialogComp {get; private set;}

    public void onConfirmComplete() {
        renderConfirmDialogComp = cdp.renderComp;
    }
	@testVisible
    private void initConfirmDialog() {
        if (cdp == null) {cdp = new ConfirmDialogParam();}
        cdp.cancelUrl = '/' + getString(accountId);
        cdp.warnMsg1 = 'Account is marked for deletion. Continue creating Sample Request?';
        renderConfirmDialogComp = isNull(sampleRequest.Id) && cdp.renderComp;
    }
	@testVisible
    private void initConfirmDialog2() {
        if (cdp == null) {cdp = new ConfirmDialogParam(false);}
        cdp.cancelUrl = '/' + getString(sampleRequest.Id);
        cdp.warnMsg1 = 'Cancelled Sample Request cannot be Submitted again.';
        renderConfirmDialogComp = cdp.renderComp;
    }

    private Boolean isSampleRequestCancelled() {
        Boolean b = false;
        b = sampleRequest != null && sampleRequest.Id != null &&
            sampleRequest.Status__c != null &&
            sampleRequest.Status__c == 'Cancelled';
        if (b) {initConfirmDialog2();}
        return b;
    }

    public PageReference gotoPage1A() {
        if (lisd == null) {init();}
        debug('gotoPage1A : lisd = ' + lisd);
        //renderPage2A = (lisd != null && lisd.readOnlyInputs);
        renderPage2A = (lisd != null && !lisd.isMultiIndustyAcc);
        renderGoto2A = !renderPage2A;
        if (!renderPage2A) {
            return Page.Sample_Request_Page_1A;
        }
        return null;
    }

    public void init1A() {
        debug('SRC.init1A :    lisd : ' + lisd);
        debug('SRC.init1A : account : ' + account);
        if (lisd == null) {
            lisd = new SAP_LISD();
            if (account != null) {lisd.setIndustries(account.Id);}
            else {lisd.readOnlyAC = false;}
        }
        onLisdComplete();
    }

    public PageReference gotoPage2A() {
        if (lisd == null) {init1A();}
        return Page.Sample_Request_Page_2A;
    }

    public void init2A() {
        if (lisd == null) {init1A();}
        lisd.copyDataTo(sampleRequest);
    }

    public PageReference nextFrom2A() {
        if (!step2A_Valid()) {return null;}
        PageReference pr = getPage3A();
        if (sampleRequestFromContact) {pr = Page.Sample_Request_Page_4A;}
        return pr;
    }

    public PageReference prevFrom4A() {
        PageReference pr = getPage3A();
        if (sampleRequestFromContact) {pr = Page.Sample_Request_Page_2A;}
        return pr;
    }

    private PageReference getPage3A() {
        if (aquarius != null && sampleRequest.Case__c != null) {
            if (isNull(tsrName)) {
                if (aquarius.Case__c != null &&
                    sampleRequest.Case__c == aquarius.Case__c) {aquarius = null;}
                sampleRequest.Case__c = null;
            } else if (aquarius.Case__c == null) {aquarius = null;}
        }
        return Page.Sample_Request_Page_3A;
    }

    public void init3A() {
        if (lisd == null) {init1A();}
        setContact();
    }

    public PageReference gotoPage4A() {
        if (step3A_Valid()) {return Page.Sample_Request_Page_4A;}
        return null;
    }

    public void init4A() {
        if (lisd == null) {init1A();}
        setAddress(); setSampleReason();
    }

    public PageReference gotoPage5A() {
        if (step4() == null) {return null;}
        initAquarius(); renderAquariusForm = false;
        return Page.Sample_Request_Page_5A;
    }

    public PageReference initAquarius() {
        debug('initAquarius : sampleRequest = ' + sampleRequest);
        if (aquarius == null) {
            aquariusRequest = new Sample_Request_Aquarius();
            aquarius = aquariusRequest.getAquariusRequest(sampleRequest);
        }
        onAquariusClose(); setUomSelectOptions();
        renderAquariusForm = true;
        return null;
    }

    public void onAquariusClose() {
        renderAquariusForm = !aquariusRequest.errorMessages.isEmpty();
        sampleRequest.Aquarius_Sample__c = aquariusRequest.isValid();
    }

    public void init5A() {
        if (lisd == null) {init1A();}
        setAddress(); setSampleCenter();
        setMatCatalogPC(); getSampleMaterials();
        if (isNull(sampleRequest.Reason_for_Sample__c)) {
            sampleRequest.Reason_for_Sample__c = sampleReason;
        }
    }

    public PageReference gotoPage6A() {
      if (step5() == null) {return null;}
      return Page.Sample_Request_Page_6A;
    }

    public void init6A() {
        if (lisd == null) {init1A();}
    }

    public PageReference gotoSObjectPage() {
        PageReference pr = null; String s = '/';
        if (sobjId != null) {s += sobjId;}
        debug('s : ' + s);
        pr = new PageReference(s); return pr;
    }

    private void setContact() {
        debug('setContact : sampleRequest1 : ' + sampleRequest);
        if ((sampleRequest != null) && isNull(contactSelected)) {
            contactSelected = sampleRequest.Contact__c;
        }

        if (isNull(contactSelected)) {
            if (isNull(contactId)) {
                getContacts();
                if (contacts != null && !contacts.isEmpty()) {
                    contactId = contacts[0].Id;
                }
            }
            if (!isNull(contactId)) {
                contactSelected = contactId;
                setSampleRequestContactInfo();
            }
        } else
        if (contactSelected == 'New Contact') {
            if (sampleRequest.Contact__c != null) {
                sampleRequest.Contact_Salutation__c = '';
                sampleRequest.Contact_First_Name__c = '';
                sampleRequest.Contact_Last_Name__c = '';
                sampleRequest.Contact_Phone_Number__c = '';
                sampleRequest.Contact_email__c = '';
            }
            sampleRequest.Contact__c = null;
        } else {setSampleRequestContactInfo();}
        debug('setContact : sampleRequest2 : ' + sampleRequest);
    }

    private void setSampleRequestContactInfo() {
        if (contact == null || isNull(contactSelected) ||
           (contact.Id != null && contact.Id != contactSelected)) {
            sampleRequest.Contact__c = contactSelected;
            getContact();
            sampleRequest.Contact_Salutation__c = contact.Salutation;
            sampleRequest.Contact_First_Name__c = contact.FirstName;
            sampleRequest.Contact_Last_Name__c = contact.LastName;
            sampleRequest.Contact_Phone_Number__c = contact.Phone;
            sampleRequest.Contact_Email__c = contact.email;
            if (isNull(sampleRequest.Id)) {
                sampleRequest.Ship_To_Address_Type__c = '';
            }
        }
    }

    private void setAddress() {
        setContact();
        if (isNull(sampleRequest.Ship_To_Address_Type__c)) {
            if (contact != null) {populateShipToAddress_from_Contact();}
            if (incompleteAddress()) {populateShipToAddress_from_Account();}
        }
        validateAddress();
    }

    private void validateAddress() {
        if (incompleteAddress()) {
            copyAddressInfoBetweenSampleRequests(sampleRequest, manualAddressEntry);
            populateShipToAddress_Manually();
        }
    }

    public void sampMatSrchAction() {
        debug('sampMatSrchAction');
        String dc = params.get('dc'), sc = params.get('sc');
        account = new Account(); sampleRequest = new Sample_Request__c();
        sampleRequest.Sales_Org__c = ''; sampleRequest.Dist_Channel__c = '';
        materials = new List<SampleMaterial>();
        changeDistChan();
    }

    public void changeDistChan() {
        sampleCenterOpts = null; accountRecordType = sampleRequest.Dist_Channel__c;
        if (isNull(accountRecordType)) {accountRecordType = Sample_Request_Config.DC_ALL;}
        else {sampleRequest.Sample_Center__c = null;}
        account.SAP_DistChannel__c = sampleRequest.Dist_Channel__c;
        setSampleCenter();
    }

    public void changeSalesOrg() {renderMatCatalog = false;}

    public void searchSampleMaterials() {
        account.SAP_Sales_Org__c = sampleRequest.Sales_Org__c;
        setMatCatalogPC();
        if (!renderMatCatalog) {addInfoMsg('No Sample Materials found');}
    }

    public void setSampleCenter() {
        renderMatCatalog = false;
        String sampleCenter = sampleRequest.Sample_Center__c;
        if (!isNull(sampleCenter)) {return;}
        getSampleCenterOpts();
        sampleCenter = Sample_Request_Config.SC_OTH;
        if (!sampleCenterOpts.isEmpty()) {
            sampleCenter = sampleCenterOpts[0].getValue();
        }
        if (!isNull(usr.Sample_Center__c)) {
            for (SelectOption o : sampleCenterOpts) {
                if (usr.Sample_Center__c == o.getValue()) {
                    sampleCenter = o.getValue(); break;
                }
            }
        }
        sampleRequest.Sample_Center__c = sampleCenter;
    }

    private void setSampleReason() {
        getSampleReasonOpts();
       //Added by SandhyaCH 9/20/2023 512-517
        if (!sampleReasonOpts.isEmpty()&& account.SAP_Sales_Org_Region_value__c != 'LA') {
            sampleReason = sampleReasonOpts[0].getValue();//Qualification
        }
        if (!sampleReasonOpts.isEmpty()&& account.SAP_Sales_Org_Region_value__c == 'LA') {
            sampleReason = sampleReasonOpts[8].getValue();//RFS_ASI_09(Samples)
        }
        changeSampleReason();
    }

    public void changeSampleReason() {
        sampleRequest.Reason_for_Sample__c = sampleReason;
        renderSampleReasonInput = (sampleReason == Sample_Request_Config.RFS_OTHER);
        if (renderSampleReasonInput) {sampleRequest.Reason_for_Sample__c = '';}
    }

    public void toggleAquariusBtn () {
        disableAquariusBtn = (samplerequest != null &&
                              samplerequest.Aquarius_Sample__c != null &&
                              samplerequest.Aquarius_Sample__c == false);
    }

    public PageReference cancel() {
        PageReference pr = new PageReference(cancelURL);
        pr.setRedirect(true); return pr;
    }

    public PageReference step1() {  return Page.Sample_Request_Wizard_Step_1;}
    public PageReference step2A() { return Page.Sample_Request_Wizard_Step_2A;}

    public pagereference step3() {
        PageReference pr = null;
        if (step3A_Valid()) {setAddress(); pr = Page.Sample_Request_Wizard_Step_3;}
        return pr;
    }

    public Boolean step2A_Valid() {
        validationErrorMessage = '';
        if (isNull(tsrName)) {sampleRequest.Case__c = null;}
        if (isNull(oppName)) {sampleRequest.Opportunity__c = null;}
        Boolean b1 = true, b2 = (isAPM && !isFlint);
        if (!b2) {return b1;}
        b1 = isNull(sampleRequest.Case__c) && isNull(sampleRequest.Opportunity__c) && !createNewOpp;
        if (b1) {
            validationErrorMessage = 'Case or Opportunity required';
            addErrorMessage();
        }
        return !b1;
    }

    public Boolean step3A_Valid() {
        Boolean result = true;
        validationErrorMessage = '';
        if (isNull(contactSelected)) {
            result = false;
            validationErrorMessage = system.label.Error_Contact_Not_Chosen;
            addErrorMessage();
        }
        return result;
    }

    public PageReference step4() {

      PageReference result = null;
      if (Step3_Valid() == true) {
        if(AddressManualEntry_Account_Visible == true) {
          copyAddressInfoBetweenSampleRequests(AccountAddressEntry, sampleRequest);
          sampleRequest.Ship_To_Address_Type__c = ADDRESS_TYPE_MANUAL;
          copyAddressInfoBetweenSampleRequests(AccountAddressEntry, ManualAddressEntry);
          AddressManualEntry_Account_Visible = false;
        }

        if(AddressManualEntry_Contact_Visible == true) {
          copyAddressInfoBetweenSampleRequests(ContactAddressEntry, sampleRequest);
          sampleRequest.Ship_To_Address_Type__c = ADDRESS_TYPE_MANUAL;
          copyAddressInfoBetweenSampleRequests(ContactAddressEntry, ManualAddressEntry);
          AddressManualEntry_Contact_Visible = false;
        }

        if(AddressManualEntry_Visible == true) {
          copyAddressInfoBetweenSampleRequests(ManualAddressEntry, sampleRequest);
          sampleRequest.Ship_To_Address_Type__c = ADDRESS_TYPE_MANUAL;
        }

        result = Page.Sample_Request_Wizard_Step_4;
      }
      return result;
    }

    public PageReference step5() {
      if (!Step4_Valid()) {return null;}
      populate_PM_CAST_Largest_Product_Line_Value_on_Sample();
      setLabContact();
      performApprovalProcessing();
      calculateTotalCost();
      return Page.Sample_Request_Wizard_Step_5;
    }

    public void calculateTotalCost() {
        sampleRequest.hold_Total_Line_Item_Costs__c = 0;
        sampleRequest.hold_Total_Value_of_Sample__c = 0;
        sampleRequest.Additional_Admin_Cost__c = 0;
        Sample_Material__c sm;
        for(SampleMaterial m : materials) {
            sm = m.sm;
            debug('Small_Pack_Cost__c : ' + sm.Small_Pack_Cost__c);
            sampleRequest.hold_Total_Line_Item_Costs__c += sm.Additional_Admin_Cost__c != null ?
                                                           sm.Additional_Admin_Cost__c : 0;
            sampleRequest.hold_Total_Line_Item_Costs__c += sm.Small_Pack_Cost__c != null ?
                                                           sm.Small_Pack_Cost__c : 0;
            sampleRequest.hold_Total_Value_of_Sample__c += sm.Estimated_Sample_Value__c != null ?
                                                           sm.Estimated_Sample_Value__c : 0;
        }
        sampleRequest.hold_Total_Sample_Cost__c = sampleRequest.hold_Total_Value_of_Sample__c +
                                                  sampleRequest.hold_Total_Line_Item_Costs__c +
                                                  sampleRequest.Additional_Admin_Cost__c;

        sampleRequest.hold_Total_Sample_Cost__c += sampleRequest.Freight_Cost__c != null ?
                                                   sampleRequest.Freight_Cost__c : 0;
        totalItemCost = String.valueOf(sampleRequest.hold_Total_Line_Item_Costs__c);
        totalSampCost = String.valueOf(sampleRequest.hold_Total_Sample_Cost__c);
    }


  public void populate_PM_CAST_Largest_Product_Line_Value_on_Sample() {

      String sampleRequest_Product_Line = '';
      Decimal sampleRequest_Product_Line_Value = -1;

      for(Sample_Material__c m:sampleMaterials)
        {
          //Product Line
          if ((m.PM_Castings_Product_Line__c != null) && (m.Estimated_Sample_Value__c != null))
            {
            if (m.Estimated_Sample_Value__c > sampleRequest_Product_Line_Value)
              {
              sampleRequest_Product_Line = m.PM_Castings_Product_Line__c;
              sampleRequest_Product_Line_Value = m.Estimated_Sample_Value__c;
              }
            }

        }

        if (sampleRequest_Product_Line != '')
            {sampleRequest.Largest_Material_by_Product_Line__c = sampleRequest_Product_Line;}



  }


  public Sample_Request__c getAccountAddressEntry() {return AccountAddressEntry;}
  public Sample_Request__c getContactAddressEntry() {return ContactAddressEntry;}
  public Sample_Request__c getManualAddressEntry() {return ManualAddressEntry;}

  public Decimal Additional_Cost_per_Sample = 0.0;
  public Decimal Additional_Cost_per_Line_Item = 0.0;

  public Boolean getRenderperSampleCost() {
    if (Additional_Cost_per_Sample > 0) {return true;} else {return false;}
  }

  public Boolean getRenderperLineItemCost() {
    if (Additional_Cost_per_Line_Item > 0) {return true;} else {return false;}
  }

  public boolean getGotAccount() {
    Boolean result = false;
    if (account != null) {result = true;}
    return result;
  }

  public boolean getGotContact() {
    Boolean result = false;
    if (contact != null) {result = true;}
    return result;
  }

  public boolean getGotOpportunity() {
    Boolean result = false;
    if (opportunity != null) {result = true;}
    return result;
  }

  public boolean getCreatingContact() {
    Boolean result = false;
    if ((contact == null) && (contactSelected == 'New Contact'))
      {result = true;}
    return result;
  }

// Object Get Queries
  public Account getAccount() {

    sampleRequest = getSampleRequest();

    Boolean runQuery = false;

    if (sampleRequest.Account__c == null) {runQuery = false;account = null;} //If no account is associated with Sample, null the account object
    else
      {
      if (account == null) {runQuery = true;} //SampleRequest has an account, but it has not been loaded, so load it
      else
        {
        if (sampleRequest.Account__c != account.id) {runQuery = true;}  //The account on the Sample Request has changed, so load the new one.
        else {runQuery = false;}
        }
      }

    if (runQuery == true)
      {
        try {
          account = Sample_Request_Functions.getAccount(sampleRequest.Account__c); 
         // account = [SELECT Id, SAP_Sales_Org_Region_value__c, RecordType.Name,Inactive_Account__c,SAP_Street__c, SAP_DistChannel__c,PAC_Industry_Segment__c, SAP_Sales_Org__c FROM Account WHERE Id = :sampleRequest.Account__c];
           
          accountId = account.Id;
          accountRecordType = Sample_Request_Functions.getAccountRecordType(account);
          renderPacIndustryInput = isNull(account.PAC_Industry_Segment__c);
          String accountRegion = '';
          accountRegion = SAP_Sales_Org_Lookup_Functions.lookup_Region_from_Sales_Org(account.SAP_Sales_Org__c);

          Additional_Cost_per_Sample = Sample_Request_Fixed_Costs_Functions.Retrieve_Additional_Cost_per_Sample(account.RecordType.Name, accountRegion);
          Additional_Cost_per_Line_Item = Sample_Request_Fixed_Costs_Functions.Retrieve_Additional_Cost_per_Line_Item(account.RecordType.Name, accountRegion);

          if (Additional_Cost_per_Sample == null) {Additional_Cost_per_Sample = 0;}
          if (Additional_Cost_per_Line_Item == null) {Additional_Cost_per_Line_Item = 0;}

          sampleRequest.Additional_Admin_Cost__c = Additional_Cost_per_Sample;
          for (Sample_Material__c m:sampleMaterials) {m.Additional_Admin_Cost__c = Additional_Cost_per_Line_Item;}

         }
      catch (Exception e) {}
      }
    return account;
  }

  public Contact getContact() {

    sampleRequest = getSampleRequest();

    Boolean runQuery = false;

    if (isNull(sampleRequest.Contact__c)) {runQuery = false;contact = null;} //If no contact is associated with Sample, null the contact object
    else
      {
      if (contact == null) {runQuery = true;} //SampleRequest has an contact, but it has not been loaded, so load it
      else
        {
        if (sampleRequest.Contact__c != contact.id) {runQuery = true;}  //The contact on the Sample Request has changed, so load the new one.
        else {runQuery = false;}
        }
      }

    if (runQuery == true)
      {
        try {
        contact = [select id,
                   AccountId,
                   OwnerId,
                   LastName,
                   FirstName,
                   Name,
                   Salutation,
                   MailingStreet,
                   MailingCity,
                   MailingState,
                   MailingPostalCode,
                   MailingCountry,
                   Phone,
                   Fax,
                   Email
              from Contact where id = : sampleRequest.Contact__c];
         } catch (Exception e) {}
      }
    return contact;
  }

  public Opportunity getOpportunity() {

    sampleRequest = getSampleRequest();

    Boolean runQuery = false;

    if (sampleRequest.Opportunity__c == null) {runQuery = false;opportunity = null;} //If no opportunity is associated with Sample, null the opportunity object
    else {if (opportunity == null) {runQuery = true;} //SampleRequest has an opportunity, but it has not been loaded, so load it
        else {
            if (sampleRequest.Opportunity__c != opportunity.id) {runQuery = true;}  //The opportunity on the Sample Request has changed, so load the new one.
            else {runQuery = false;}
        }
    }
    if (runQuery == true) {
        try {
            opportunity = [select id, AccountId, OwnerId, Name, Description,
                                  StageName, Amount, Probability
                             from Opportunity
                            where id = :sampleRequest.Opportunity__c];
            oppName = opportunity.Name;
         } catch (Exception e) {}
    }
    return opportunity;
  }

  public void setSampleRequest(String sampleRequestId) {
        sampleRequest = [SELECT
                                Account__c, Account_Region__c, AD_Compound__c,
                                Additional_Admin_Cost__c, Additional_Comments__c,
                                Address_Line_1__c, Address_Line_2__c,
                                Address_Line_3__c, Address_Line_4__c,
                                AHWT_Product_Lines__c, Approval_Date__c,
                                Approval_Process__c, Aqualon_Hazardous_Material__c,
                                Aquarius_Sample__c, Ashland_Requestor__c,
                                AST_Sample__c, Available_Actions__c,
                                Cancellation_Reason__c, Carrier_Account_Number__c,
                                Carrier_Type_for_Sample_Delivery__c, City__c,
                                Contact__c, Contact_Email__c,
                                Contact_First_Name__c, Contact_Last_Name__c,
                                Contact_Phone_Number__c, Contact_Salutation__c,
                                Contains_Material_Greater_Than_5_Gallons__c,
                                Cost_Center__c, Country__c,
                                Create_Contact_Record_on_Account__c,
                                CSR_Responsible_for_Order_Entry__c,
                                Customer_Requestor__c, Customer_Ship_To_Contact__c,
                                Date_Required_By__c, Dist_Channel__c,
                                Dist_Channel_Desc__c, Division__c, Division_Desc__c,
                                Estimated_Arrival_Date__c, Estimated_Sample_Value__c,
                                Estimated_Ship_Date__c, Id, If_unknown_product_description__c,
                                Material__c, Material_Plant__C, Material_Summary__c,
                                Most_Valuable_Item_Value__c, Name, New_Prospect_Account__c,
                                Number_of_Items__c, Oak_Creek__c, OEM__c, On_Hold_Reason__c,
                                Opportunity__c, OwnerId, Parent_Account_Name__c,
                                Parent_Account_Owner__c, Parent_Account_RecordType__c,
                                Postal_Zip_Code__c, Potential_Annual_Volume__c,
                                Potential_Annual_Volume_Quantifier__c, Product_Development__c,
                                Reason_for_Sample__c, RecordTypeId, Region__c,
                                Rush_Sample__c, Sales_District__c, Sales_District_Desc__c,
                                Sales_Group__c, Sales_Group_Desc__c, Sales_Office__c,
                                Sales_Office_Desc__c, Sales_Org__c, SalesOffice__c,
                                Sample_Approver__c, Sample_Center__c, Sample_Coordinator__c, Sample_Size__c,
                                Sample_Size_Other__c, SAP_Order_Number__c, Seller__c,
                                Ship_From_Location__c, Ship_To_Address_Type__c,
                                Shipment_Notification__c, Small_Package_Sale__c,
                                State__c, Status__c, Tectyl_Product__c,
                                Total_Line_Item_Costs__c, Total_Potential_Annual_Value_of_Sample__c,
                                Total_Sample_Cost__c, Total_Value_of_Sample__c,
                                Tracking_Air_Bill__c, Notes_Summary__c,Freight_Cost__c, No_Charge_Order__c,Update_All_Information__c, EndUse_Customer__c
                                FROM Sample_Request__c WHERE Id = :sampleRequestId];
  }

  public Sample_Request__c getSampleRequest() {
    if (sampleRequest == null) {
      if (!isNull(smpRqstId)) {
        setSampleRequest(smpRqstId); getSampleMaterials();
      } else {
        sampleRequest = new Sample_Request__c();
        if (draftRecTypeId != null) {sampleRequest.RecordTypeId = draftRecTypeId;}
        if (!isNull(accountId)) {sampleRequest.Account__c = accountId;}
      }
    }
    return sampleRequest;
  }

  public List<Sample_Material__c> getSampleMaterials() {
    if (sampleMaterials == null) {
      if (sampleRequest.Id != null) {
        sampleMaterials = Sample_Material_Functions.Select_All_Fields_Based_on_Sample_Request_Ids(sampleRequest.Id);
      } else {
        getaccount(); sampleMaterials = new List<Sample_Material__c>();
      }
      initMaterials();
    }
    return sampleMaterials;
  }

  private void initMaterials() {
    allMats = false; SampleMaterial m; Integer n = 0;
    materials = new List<SampleMaterial>();
    for (Sample_Material__c sm : sampleMaterials) {
        m = new SampleMaterial(sm, ++n); materials.add(m);
    }
  }

  public List<Contact> getContacts() {
    debug('getContacts : sampleRequest : ' + sampleRequest);
    if (sampleRequest.Account__c != null) {
      try {
      contacts = [select id, Name, Firstname, Lastname, Phone,
                         MobilePhone, Fax, Email, MailingStreet,
                         MailingCity, MailingState, MailingPostalCode,
                         MailingCountry, Salutation from Contact
                   where AccountId = :sampleRequest.Account__c
                   order by Name];
      } catch (Exception e) {}
    }
    if (contacts != null) {debug('contacts : ' + contacts.size());}
    return contacts;
  }

  private List<Opportunity> opportunities;
  public String opportunitySelected = '';

  public String getOpportunitySelected() {return opportunitySelected;}

  public void setOpportunitySelected(String s) {this.opportunitySelected = s;}

  public String getAlreadyHaveOpportunityMessage() {
    String result = '';
    getSampleRequest();
    if (sampleRequest.Opportunity__c != null)
      {
        result = system.label.Warning_Opp_Associated_1 + '<a HREF="/' + opportunity.Id + '" target="_blank">' + opportunity.Name + '</a>.' + system.label.Warning_Opp_Associated_2;
      }
    return result;
  }

  public Integer getOpportunityRelatedtoParentAccount_Count() {
    Integer result = 0;
    getOpportunities();
    if (opportunities != null)
        {
        result = opportunities.size();
        }
    return result;
  }

  private Boolean Step2B_Valid() {
    Boolean result = true;

    validationErrorMessage = '';

    return result;
  }

  public List<Opportunity> getOpportunities() {
    if ( opportunities == null ) {
      try {
        System.Debug('getOpportunities:showRelatedOpp = ' + showRelatedOpp);
        if (showRelatedOpp)
        {

          opportunities = [SELECT id,
                                  Name,
                                  RecordType.Name,
                                  Description,
                                  StageName,
                                  CloseDate,
                                  AccountId,
                                  Account.Name, Account.AccountNumber, Account.Type
                             FROM Opportunity
            WHERE AccountId in :accMap.keySet()
            ORDER BY Account.Name, Account.AccountNumber, Name];
        }
        else
        {
          opportunities = [SELECT id,
                                  Name,
                                  RecordType.Name,
                                  Description,
                                  StageName,
                                  CloseDate
                             FROM Opportunity
            WHERE AccountId = : sampleRequest.Account__c
              AND IsClosed = false];
        }
      }
       catch (Exception e) {}

      }
    return opportunities;
  }

  public PageReference Save_Sample_Request_with_New_Opportunity() {
    PageReference result = null;
    validationErrorMessage = '';
    if (sampleRequest != null) {
      if (opportunitySelected != '') {
        sampleRequest.Opportunity__c = opportunitySelected;
        //sampleRequest.Material_Summary__c = Sample_Material_Functions.SummarizeMaterialsonSampleRequest(sampleRequest.Id);
        update sampleRequest;
        PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
        sampleRequestPage.setRedirect(true);
        result = sampleRequestPage;
      } else {
        validationErrorMessage = System.label.Error_Opportunity_Not_Selected;
        addErrorMessage();
      }
    }
    return result;
  }

// Sample Wizard - Step 3 - Gather basic Sample Info - Address Info

  // Variable Declaration
  boolean AddressManualEntry_Visible = false;
  boolean AddressManualEntry_Account_Visible = false;
  boolean AddressManualEntry_Contact_Visible = false;
  boolean AddressSection_Visible = true;
  boolean UseContactAddressButton_Disabled = true;
  boolean UseAccountAddressButton_Disabled = true;
  String UseAccountAddressButton_Style = 'btnDisabled';
  String UseContactAddressButton_Style = 'btnDisabled';

  // Get/Set Functions
  public Boolean getEnableDisable_AccountAddressButton() {
    account = getAccount();

    if (account != null) {
        UseAccountAddressButton_Disabled = false;
        UseAccountAddressButton_Style = 'btn';
      }
    else {
        UseAccountAddressButton_Disabled = true;
        UseAccountAddressButton_Style = 'btnDisabled';
      }

    return UseAccountAddressButton_Disabled;
  }

  public Boolean getEnableDisable_ContactAddressButton() {
    contact = getContact();

    if (contact != null) {
        UseContactAddressButton_Disabled = false;
        UseContactAddressButton_Style = 'btn';
      }
    else {
        UseContactAddressButton_Disabled = true;
        UseContactAddressButton_Style = 'btnDisabled';
      }

    return UseContactAddressButton_Disabled;
  }

  public String getStyle_AccountAddressButton() {
    account = getAccount();

    if (account != null) {
        UseAccountAddressButton_Disabled = false;
        UseAccountAddressButton_Style = 'btn';
      }
    else {
        UseAccountAddressButton_Disabled = true;
        UseAccountAddressButton_Style = 'btnDisabled';
      }

    return UseAccountAddressButton_Style;
  }

  public String getStyle_ContactAddressButton() {
    contact = getContact();

    if (contact != null) {
        UseContactAddressButton_Disabled = false;
        UseContactAddressButton_Style = 'btn';
      }
    else {
        UseContactAddressButton_Disabled = true;
        UseContactAddressButton_Style = 'btnDisabled';
      }

    return UseContactAddressButton_Style;
  }

  public Boolean gethideshow_AddressManualEntry() {
    return AddressManualEntry_Visible;
  }

  public Boolean gethideshow_AddressManualEntry_Account() {
    return AddressManualEntry_Account_Visible;
  }

  public Boolean gethideshow_AddressManualEntry_Contact() {
    return AddressManualEntry_Contact_Visible;
  }

  public Boolean gethideshow_AddressSection() {
    return AddressSection_Visible;
  }

  public String getAccountAddress() {

    String AccountAddress = '';

    if (account != null) {

      List <String> addressLines = new List <String>();
      addressLines.add(account.SAP_Street__c);
      addressLines.add(account.SAP_StreetSuppl1__c);
      addressLines.add(account.SAP_StreetSuppl2__c);
      addressLines.add(account.SAP_StreetSuppl3__c);

      AccountAddress = Address_Functions.FormatAddressforWebDisplay(addressLines,
                                                                    account.SAP_City__c,
                                                                    account.SAP_State__c,
                                                                    account.SAP_Zip_Code__c,
                                                                    account.SAP_Country__c);

      }

    return AccountAddress;
  }

  public String getContactAddress() {
    String ContactAddress = '';

    if (contact != null) {
      ContactAddress = Address_Functions.FormatAddressforWebDisplay(contact.MailingStreet,
                                                                    contact.MailingCity,
                                                                    contact.MailingState,
                                                                    contact.MailingPostalCode,
                                                                    contact.MailingCountry);
      }
    return ContactAddress;
  }

  // Step Validation

  public Boolean Step3_Valid() {
    Boolean result = true;
    if (isNull(sampleRequest.Ship_To_Address_Type__c)) {
        result = false;
        validationErrorMessage = system.label.Error_No_Shipping_Address;
        addErrorMessage();
    }
    return result;
  }

  // General Functions
  public void populateShipToAddress_Manually() {

    AddressManualEntry_Account_Visible = false;
    AddressManualEntry_Contact_Visible = false;
    AddressManualEntry_Visible = true;
    AddressSection_Visible = false;
    sampleRequest.Ship_To_Address_Type__c = ADDRESS_TYPE_MANUAL;
    validationErrorMessage = ''; setCountry(manualAddressEntry);
    copyAddressInfoBetweenSampleRequests(manualAddressEntry, sampleRequest);
  }

  private void setCountry(Sample_Request__c sr) {
    if (isNull(sr.Country__c)) {sr.Country__c = 'US';}
  }

  public void copyAddressInfoBetweenSampleRequests(Sample_Request__c Source_Sample, Sample_Request__c Target_Sample) {
      Target_Sample.Address_Line_1__c = Source_Sample.Address_Line_1__c;
      Target_Sample.Address_Line_2__c = Source_Sample.Address_Line_2__c;
      Target_Sample.Address_Line_3__c = Source_Sample.Address_Line_3__c;
      Target_Sample.Address_Line_4__c = Source_Sample.Address_Line_4__c;
      Target_Sample.City__c = Source_Sample.City__c;
      Target_Sample.State__c = Source_Sample.State__c;
      Target_Sample.Postal_Zip_Code__c = Source_Sample.Postal_Zip_Code__c;
      Target_Sample.Country__c = Source_Sample.Country__c;
  }

  public void populateShipToAddress_from_Account() {

    AddressManualEntry_Account_Visible = false;
    AddressManualEntry_Contact_Visible = false;
    AddressManualEntry_Visible = false;
    AddressSection_Visible = true;
    validationErrorMessage = '';
    account = getAccount();

    if (account != null) {

        AccountAddressEntry.Address_Line_1__c = account.SAP_Street__c;
        AccountAddressEntry.Address_Line_2__c = account.SAP_StreetSuppl1__c;
        AccountAddressEntry.Address_Line_3__c = account.SAP_StreetSuppl2__c;
        AccountAddressEntry.Address_Line_4__c = account.SAP_StreetSuppl3__c;
        AccountAddressEntry.City__c = account.SAP_City__c;
        AccountAddressEntry.State__c = account.SAP_State__c;
        AccountAddressEntry.Postal_Zip_Code__c = account.SAP_Zip_Code__c;
        AccountAddressEntry.Country__c = account.SAP_Country__c;
        AccountAddressEntry.Ship_To_Address_Type__c = ADDRESS_TYPE_ACCOUNT;

        copyAddressInfoBetweenSampleRequests(AccountAddressEntry, ManualAddressEntry);
        copyAddressInfoBetweenSampleRequests(AccountAddressEntry, sampleRequest);
        sampleRequest.Ship_To_Address_Type__c = ADDRESS_TYPE_ACCOUNT;
        setCountry(accountAddressEntry);

    } else {sampleRequest.Address_Line_1__c = 'Not Found';}

    validateAddress();
  }

  private Boolean incompleteAddress() {
        Boolean b = isNull(sampleRequest.Address_Line_1__c) ||
                    isNull(sampleRequest.City__c) ||
                    isNull(sampleRequest.Postal_Zip_Code__c) ||
                    isNull(sampleRequest.Country__c);
        if (b) {
            sampleRequest.Ship_To_Address_Type__c = ADDRESS_TYPE_MANUAL;
            AddressManualEntry_Visible = false;
        }
        return b;
  }

  public void populateShipToAddress_from_Contact() {

    AddressManualEntry_Account_Visible = false;
    AddressManualEntry_Contact_Visible = false;
    AddressManualEntry_Visible = false;

    AddressSection_Visible = true;
    validationErrorMessage = '';
    contact = getContact();

    if (contact != null) {

        List<String> addressLines = Address_Functions.convert1LineAddressto4(contact.MailingStreet);
        sampleRequest.Address_Line_1__c = '';
        sampleRequest.Address_Line_2__c = '';
        sampleRequest.Address_Line_3__c = '';
        sampleRequest.Address_Line_4__c = '';

        if (addressLines != null) {
          if (addressLines.size() > 0) {sampleRequest.Address_Line_1__c = addressLines.get(0);}
          if (addressLines.size() > 1) {sampleRequest.Address_Line_2__c = addressLines.get(1);}
          if (addressLines.size() > 2) {sampleRequest.Address_Line_3__c = addressLines.get(2);}
          if (addressLines.size() > 3) {sampleRequest.Address_Line_4__c = addressLines.get(3);}
        } else {
          sampleRequest.Address_Line_1__c = '';
          sampleRequest.Address_Line_2__c = '';
          sampleRequest.Address_Line_3__c = '';
          sampleRequest.Address_Line_4__c = '';
        }

        sampleRequest.City__c = contact.MailingCity;
        sampleRequest.State__c = contact.MailingState;
        sampleRequest.Postal_Zip_Code__c = contact.MailingPostalCode;
        sampleRequest.Country__c = contact.MailingCountry;
        sampleRequest.Ship_To_Address_Type__c = ADDRESS_TYPE_CONTACT;

        copyAddressInfoBetweenSampleRequests(sampleRequest, ContactAddressEntry);
        ContactAddressEntry.Ship_To_Address_Type__c = ADDRESS_TYPE_CONTACT;
        copyAddressInfoBetweenSampleRequests(sampleRequest, ManualAddressEntry);
        setCountry(contactAddressEntry);

    } else {sampleRequest.Address_Line_1__c = 'Not Found';}

    validateAddress();
  }

  List<Sample_Material__c> sampleMaterials_toBeDeleted = new List<Sample_Material__c>();

  public Boolean getRenderTectyl() {
    if (account != null) {return Sample_Material_Functions.SupportsTectylProducts(account);}
    else {return false;}
  }

  public Boolean getRenderProductLine() {
    if (account != null) {return Sample_Material_Functions.SupportsProductLine(account);}
    else {return false;}
  }

  public Boolean getRenderAHWTProductLine() {
    if (account != null) {return Sample_Material_Functions.SupportsAHWTProductLine(account);}
    else {return false;}
  }

  public Boolean getRenderPMCastingsProductLine() {
    if (account != null) {return Sample_Material_Functions.SupportsPMCastingsProductLine(account);}
    else {return false;}
  }

  public Boolean getRenderADCompound() {
    if (account != null) {return Sample_Material_Functions.SupportsADCompoundProducts(account);}
    else {return false;}
  }

  public Boolean getRenderProductDevelopment() {
    if (account != null) {return Sample_Material_Functions.SupportsProductDevelopment(account);}
    else {return false;}
  }

  public Boolean getRenderASTSamples() {
    //if (account != null) {return Sample_Material_Functions.SupportsASTSamples();} else {return false;}
    return false;
  }

  public Boolean getRenderOakCreek() {
    if (account != null) {return Sample_Material_Functions.SupportsOakCreek(account);} else {return false;}
  }

  public Boolean getRenderGeneralMaterialQuestions() {
    Boolean result = false;
    if (account != null) {
      return  (  getRenderProductDevelopment()
              || getRenderASTSamples()
              || getRenderOakCreek()
              || isASI
              );
    }
    return result;
  }

  public String getBusiness() {

      String business = '';
      if(isASI){ business = 'Aqualon';}
      if(isAHWT) {business = 'AHWT';}
    return business;
  }
    public Boolean Step4_Valid() {
      Boolean result = true;
      String business = getBusiness();

      initSampleMaterials();
      sampleMaterials = Sample_Material_Functions.Remove_Blank_Rows_From_Material_List(sampleMaterials);

      if (sampleMaterials.size() == 0)
        {validationErrorMessage = system.label.Error_Need_one_material;}
      else
        {validationErrorMessage = String_Functions.Format_ListString_into_HTML_List(Sample_Material_Functions.Validate_Materials(sampleMaterials, account, 'InitialEntry', true, business),'','');}

      if (sampleRequest.Rush_Sample__c == true && isNull(sampleRequest.Carrier_Account_Number__c)){
        validationErrorMessage += String_Functions.Format_ListString_into_HTML_List('<u>UPS / Fed-Ex Number</u> ' + system.label.Required_for_Rushed_Samples,system.label.error + ': ',''); }

      if (sampleRequest.Rush_Sample__c == true && isNull(sampleRequest.Carrier_Type_for_Sample_Delivery__c)){
        validationErrorMessage += String_Functions.Format_ListString_into_HTML_List('<u>Carrier</u> ' + system.label.Required_for_Rushed_Samples,system.label.error + ': ',''); }

      if (sampleRequest.Rush_Sample__c == false && isNull(sampleRequest.Carrier_Type_for_Sample_Delivery__c) && sampleRequest.Carrier_Account_Number__c != null ){
        validationErrorMessage += String_Functions.Format_ListString_into_HTML_List('<u>Carrier</u> ' + system.label.Required, system.label.error + ': ',''); }
/*
      if (sampleRequest.Rush_Sample__c == false && !isNull(sampleRequest.Carrier_Type_for_Sample_Delivery__c) && sampleRequest.Carrier_Account_Number__c == null){
        validationErrorMessage += String_Functions.Format_ListString_into_HTML_List('<u>UPS / Fed-Ex Number</u> ' + system.label.Required, system.label.error + ': ',''); }
*/
      if (sampleRequest.Aquarius_Sample__c) {
        //validationErrorMessage += Sample_Request_Aquarius.validateRequiredFields(aquarius);
        validationErrorMessage += aquariusRequest.getErrorMessages();
        debug('Aquarius Errors : ' + validationErrorMessage);
      }

      if (validationErrorMessage != '')
        {result = false; addErrorMessage();}

      return result;
    }

  public String NoteToSampleCoordinator = '';

  public String getNoteToSampleCoordinator() {return NoteToSampleCoordinator;}

  public void setNoteToSampleCoordinator(String noteIn) {
    NoteToSampleCoordinator = noteIn;
  }

  public String getSampleRequestAddress() {

    String SampleRequestAddress = '';

    if (sampleRequest != null) {

      List <String> addressLines = new List <String>();
      addressLines.add(sampleRequest.Address_Line_1__c);
      addressLines.add(sampleRequest.Address_Line_2__c);
      addressLines.add(sampleRequest.Address_Line_3__c);
      addressLines.add(sampleRequest.Address_Line_4__c);

      SampleRequestAddress = Address_Functions.FormatAddressforWebDisplay(addressLines,
                                                                          sampleRequest.City__c,
                                                                          sampleRequest.State__c,
                                                                          sampleRequest.Postal_Zip_Code__c,
                                                                          sampleRequest.Country__c);
      }

    return SampleRequestAddress;
  }
  public boolean renderSampleAddress  {get{return !isNull(getSampleRequestAddress());}}

  public PageReference saveAndSubmitForApproval() {

    PageReference pageResult = null;

    if (contactSelected == 'New Contact') {
        Contact newContact;
        newContact = new Contact();

        newContact.Salutation = sampleRequest.Contact_Salutation__c;
        newContact.FirstName = sampleRequest.Contact_First_Name__c;
        newContact.LastName = sampleRequest.Contact_Last_Name__c;
        newContact.Phone = sampleRequest.Contact_Phone_Number__c;
        newContact.Email = sampleRequest.Contact_Email__c;

        String ContactAddress = '';
        if (sampleRequest.Address_Line_1__c != null)
          ContactAddress += sampleRequest.Address_Line_1__c + '\n';
        if (sampleRequest.Address_Line_2__c != null)
          ContactAddress += sampleRequest.Address_Line_2__c + '\n';
        if (sampleRequest.Address_Line_3__c != null)
          ContactAddress += sampleRequest.Address_Line_3__c + '\n';
        if (sampleRequest.Address_Line_4__c != null)
          ContactAddress += sampleRequest.Address_Line_4__c + '\n';

        newContact.MailingStreet = ContactAddress;
        newContact.MailingCity = sampleRequest.City__c;
        newContact.MailingState = sampleRequest.State__c;
        newContact.MailingPostalCode = sampleRequest.Postal_Zip_Code__c;
        newContact.MailingCountry = sampleRequest.Country__c;
        newContact.AccountId = sampleRequest.Account__c;

        string contactRecordType = '';
        contactRecordType = RecordType_Relationship_Functions.GetContactRecordType_Based_on_AccountRecordTypeId(account.RecordTypeId);
        if ((contactRecordType != null) && (contactRecordType != ''))
            {newContact.RecordTypeId = contactRecordType;}

        insert newContact;

        sampleRequest.Contact__c = newContact.Id;
      }

    if (createNewOpp) {
        insert newOpp; sampleRequest.Opportunity__c = newOpp.Id;
    }

    upsert sampleRequest; setSampleRequest(sampleRequest.Id);

    PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
    sampleRequestPage.setRedirect(true);
    pageResult = sampleRequestPage;

    if (sampleRequest.Aquarius_Sample__c && aquarius != null &&
        aquariusRequest != null && !aquariusRequest.isReadOnly) {
        aquarius.Sample_Request__c = sampleRequest.Id;
        upsert aquarius;
    }

    String sampleMaterial_RecordType = null;
    if (account != null) {sampleMaterial_RecordType = RecordType_Relationship_Functions.GetMaterialRecordType_Based_on_AccountRecordTypeId(account.RecordTypeId);}

    Sample_Material_Functions.Delete_Sample_Materials_Not_In_List(sampleRequest,sampleMaterials);

    if (sampleMaterials != null && sampleMaterials.size() > 0) {
        for (Sample_Material__c sm : sampleMaterials) {
            if (sm.Id == null) {
                sm.Sample_Request__c = sampleRequest.id;
                sm.Record_Status__c = sampleRequest.Status__c;
            }
            if (!isNull(sampleMaterial_RecordType)) {
                sm.RecordTypeId = sampleMaterial_RecordType;
            }
        }
        upsert sampleMaterials;
    }

    if (!String.isBlank(NoteToSampleCoordinator)) {
       Boolean noteCreationResult = Note_Functions.createNote(sampleRequest.Id, system.label.Additional_Comments_for_SC, NoteToSampleCoordinator);
    }

    Approval.ProcessSubmitRequest reql = new Approval.ProcessSubmitRequest();
    reql.setComments(system.label.Submitting_SR); reql.setObjectId(sampleRequest.id);

    if (!Test.isRunningTest()) {
        Approval.ProcessResult result = Approval.process(reql); System.assert(result.isSuccess());
    }

    return pageResult;
  }

  string noApprovalProcessMessage;

  public String getNoApprovalProcessMessage() {
    noApprovalProcessMessage = '';
    noApprovalProcessMessage += system.label.No_Approval_Process_SR;
    return noApprovalProcessMessage;
  }

  string ApproverQueue = '';

  public String getApproverQueue() {
    ApproverQueue = '';
    ApproverQueue += String_Functions.ConvertCRtoBR(SampleRequestApprovalProcess_Functions.lookup_Approver_Queue(sampleRequest.Approval_Process__c));
    return ApproverQueue;
  }

  string ApproverQueue2 = '';

  public String getApproverQueue2() {
    ApproverQueue2 = '';
    ApproverQueue2 += String_Functions.ConvertCRtoBR(SampleRequestApprovalProcess_Functions.lookup_Approver_Queue_2(sampleRequest.Approval_Process__c));
    return ApproverQueue2;
  }


  string ApproverQueue3 = '';

  public String getApproverQueue3() {
    ApproverQueue3 = '';
    ApproverQueue3 += String_Functions.ConvertCRtoBR(SampleRequestApprovalProcess_Functions.lookup_Approver_Queue_3(sampleRequest.Approval_Process__c));
    return ApproverQueue3;
  }


  string BackupApproverQueue = '';

  public String getBackupApproverQueue() {
    BackupApproverQueue = '';
    BackupApproverQueue += String_Functions.ConvertCRtoBR(SampleRequestApprovalProcess_Functions.lookup_Backup_Approver_Queue(sampleRequest.Approval_Process__c));
    return BackupApproverQueue;
  }

  string ApproverQueueName = '';

  public String getApproverQueueName() {
    ApproverQueueName = '';
    ApproverQueueName += String_Functions.ConvertCRtoBR(SampleRequestApprovalProcess_Functions.lookup_Approver_Queue_Name(sampleRequest.Approval_Process__c));
    return ApproverQueueName;
  }

  string ApprovalRequirements = '';

  public String getApprovalRequirements() {
    ApprovalRequirements = '';
    ApprovalRequirements += String_Functions.ConvertCRtoBR(SampleRequestApprovalProcess_Functions.lookup_Approval_Requirements(sampleRequest.Approval_Process__c));
    return ApprovalRequirements;
  }

  public void performApprovalProcessing() {
    Sample_Request_Functions.setApprovalFields(sampleRequest, sampleMaterials);
    renderApprovalProcPB = !isNull(sampleRequest.Approval_Process__c) && !isASI;
  }

  String accountName = '';
  String accountNumber = '';
  String opportunityName = '';
  String errorMessage = '';
  String validation_Error = '';
  public Sample_Material__c sampleMaterial_All = new Sample_Material__c();

  public String getErrorMessage() {return errorMessage;}

  public Sample_Material__c getsampleMaterial_All() {
    return sampleMaterial_All;
  }

  public String getSample_Request_Link() {
    String result = '';
    if (sampleRequest != null && sampleRequest.Id != null) {
        result = ' - <a href="/' + sampleRequest.Id +
                 '" target="_blank">' + sampleRequest.Name + '</a>';
    }
    return result;
  }

  public void Populate_SAP_Material_Numbers() {
    if (sampleMaterials != null)
      {
      if (sampleMaterials.size() > 0)
        {
        sampleMaterials = Sample_Material_Functions.Populate_SAP_Material_Number_from_Materials_Table(sampleMaterials);
        }
      }
  }

  public PageReference Save_Sample_Request() {
    PageReference result = null;
    if (sampleRequest != null)
      {
      update sampleRequest;

      PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
      sampleRequestPage.setRedirect(true);
      result = sampleRequestPage;
      }
    return result;
  }

  public PageReference Cancel_Save() {
    PageReference result = null;
    if (sampleRequest != null)
      {
      PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
      sampleRequestPage.setRedirect(true);
      result = sampleRequestPage;
      }
    return result;
  }

  public void ApplyChangesToAllMaterials() {
    for (Sample_Material__c sm : sampleMaterials) {
      if (sampleMaterial_All.Ship_From_Location__c != null) {sm.Ship_From_Location__c = sampleMaterial_All.Ship_From_Location__c;}
      if (sampleMaterial_All.Estimated_Ship_Date__c != null) {sm.Estimated_Ship_Date__c = sampleMaterial_All.Estimated_Ship_Date__c;}
      if (sampleMaterial_All.Estimated_Arrival_Date__c != null) {sm.Estimated_Arrival_Date__c = sampleMaterial_All.Estimated_Arrival_Date__c;}
      if (sampleMaterial_All.Actual_Ship_Date__c != null) {sm.Actual_Ship_Date__c = sampleMaterial_All.Actual_Ship_Date__c;}
      if (sampleMaterial_All.Shipping_Carrier__c != null) {sm.Shipping_Carrier__c = sampleMaterial_All.Shipping_Carrier__c;}
      if (sampleMaterial_All.Tracking_Air_Bill__c != null) {sm.Tracking_Air_Bill__c = sampleMaterial_All.Tracking_Air_Bill__c;}
    }
    sampleMaterial_All.Ship_From_Location__c = null;
    sampleMaterial_All.Estimated_Ship_Date__c = null;
    sampleMaterial_All.Estimated_Arrival_Date__c = null;
    sampleMaterial_All.Actual_Ship_Date__c = null;
    sampleMaterial_All.Shipping_Carrier__c = null;
    sampleMaterial_All.Tracking_Air_Bill__c = null;
  }

  Id oldCoordinator;

  public void init_Assign_a_Different_Coordinator() {

    getSampleRequest();
    getAccount();
    getContact();
    getOpportunity();

    oldCoordinator = sampleRequest.Sample_Coordinator__c;

  }

  public PageReference Assign_a_Different_Coordinator() {
    PageReference result = null;
    if (sampleRequest != null)
      {
      update sampleRequest;

      Id newCoordinator = sampleRequest.Sample_Coordinator__c;

      if (oldCoordinator != newCoordinator) {
          changeCoordinator(oldCoordinator, newCoordinator);
       }

      PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
      sampleRequestPage.setRedirect(true);
      result = sampleRequestPage;
      }
    return result;
  }

  public void changeCoordinator(Id oldCoordinator, Id newCoordinator) {
      String oldCoordinatorName = 'unknown';
      String newCoordinatorName = '';

      if (oldCoordinator != null) {oldCoordinatorName = User_Functions.RetrieveUserName(oldCoordinator);}
      if (newCoordinator != null) {newCoordinatorName = User_Functions.RetrieveUserName(newCoordinator);}

      List<String> toAddresses = new List<String>();
      if (oldCoordinator != null) {toAddresses.add(retrieveEmailAddressfromUserId(oldCoordinator));}
      if (newCoordinator != null) {toAddresses.add(retrieveEmailAddressfromUserId(newCoordinator));}

      String subject = sampleRequest.Name + ' - ' + system.label.another_SC;
      String body = newCoordinatorName + system.label.now_has_the_responsibility_for +
                    sampleRequest.Name + '.  ' + system.label.previous_SC +
                    oldCoordinatorName + '.' + '\n\n' + system.label.To_View_SR +
                    SERVER_URL + '/' +
                    sampleRequest.Id;

      Boolean emailResult = Email_Functions.sendEmail(toAddresses,
                            null,
                            null,
                            retrieveEmailAddressfromUserId(newCoordinator),newCoordinatorName,
                            false,false,
                            subject,
                            body,
                            null);

      Boolean noteCreationResult = Note_Functions.createNote(sampleRequest.Id,system.label.another_SC ,newCoordinatorName + system.label.now_has_the_responsibility_for + ' ' + sampleRequest.Name + '. ' + system.label.previous_SC + ' ' + oldCoordinatorName + '.');
      update SampleRequest;
  }

  public Sample_Request__c sampleRequest_CSR;
  public String accountType;
  String SAP_Order_Number_Label = '';
  Boolean CSRAlreadyAssigned = false;
  String CSRAlreadyAssignedtoEnterOrderMessage;
  public String NoteToCSR = '';

  public String getNoteToCSR() {
    return NoteToSampleCoordinator;
  }

  public void setNoteToCSR(String noteIn) {
    NoteToCSR = noteIn;
  }

  public String getAccountType() {

    if (accountType == null)
      {
      getSampleRequest();
      getAccount();
      accountType = RecordType_Relationship_Functions.GetAccountType_Based_on_AccountRecordTypeId(account.RecordTypeId);
      }
    return accountType;
  }

  Public String getCSR_Responsible_for_Order_Entry_Label() {
    return '<b>' + system.label.CSR_Responsible + ': <FONT COLOR="RED" SIZE="4">*</FONT></b>';
  }

  Public String getSAP_Order_Number_Label() {
    return '<b>' + system.label.Order_Number + ': <FONT COLOR="RED" SIZE="4">*</FONT></b>';
  }

  public String getCSRAlreadyAssignedtoEnterOrderMessage() {

    CSRAlreadyAssignedtoEnterOrderMessage = '';

    if (CSRAlreadyAssigned == true)
      {
      CSRAlreadyAssignedtoEnterOrderMessage = system.label.Warning_Activity_Sent_to + ' ' + User_Functions.RetrieveUserName(sampleRequest.CSR_Responsible_for_Order_Entry__c)+ ' ' + system.label.Warning_Activity_Sent_to_2;
      }

    return CSRAlreadyAssignedtoEnterOrderMessage;
  }

  public void init_Assign_Task_to_CSR_to_Enter_Order() {

    User sampleCSRUser = null;

    getSampleRequest();
    getAccount();
    getContact();
    getOpportunity();
    CSRAlreadyAssigned = false;
    emailcsrgroupbox = false;
    renderemailcsrgroupbox = !(account.SAP_CSR_Email__c == '' || account.sap_csr_email__c == null);

    if (sampleRequest.CSR_Responsible_for_Order_Entry__c == null)
      {
      if (account.SAP_CSR_Email__c != null)
        {
        try {sampleCSRUser = [SELECT Id, UserName, Email, Backup__c FROM User WHERE Email = :account.SAP_CSR_Email__c AND UserName = :account.SAP_CSR_Email__c];}
        catch (Exception e) {sampleCSRUser = null;}
        if (sampleCSRUser != null)
          {
          sampleRequest.CSR_Responsible_for_Order_Entry__c = sampleCSRUSer.Id;
          }
        }
      }
   else {CSRAlreadyAssigned = true;}
  }

  public Boolean Assign_Task_to_CSR_to_Enter_Order_Valid() {
    Boolean result = true;

    validationErrorMessage = '';

    if (sampleRequest.CSR_Responsible_for_Order_Entry__c == null)
      {
      validationErrorMessage = String_Functions.Format_ListString_into_HTML_List(system.label.Error_Must_Select_CSR,system.label.Error + ': ','');
      }

    validationErrorMessage += String_Functions.Format_ListString_into_HTML_List(Sample_Material_Functions.Validate_Materials(sampleMaterials, account, 'AssignOrderEntrytoCSR', true, getBusiness()),'','');

    if (validationErrorMessage != '')
      {result = false; addErrorMessage();}

    return result;
  }

  public String retrieveEmailAddressfromUserId(String id) {
    String s = '';
    try {User user = [SELECT email FROM User WHERE Id = :id]; s = user.email;}
    catch(Exception e) {}
    return s;
  }

  public PageReference AssignTasktoCSRtoEnterOrder() {
    PageReference result = null;

    if (Assign_Task_to_CSR_to_Enter_Order_Valid() == true) {
      createTasktoCSRtoEnterOrder();
      PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
      sampleRequestPage.setRedirect(true);
      result = sampleRequestPage;
    }
    return result;
  }

    public void createTasktoCSRtoEnterOrder() {
      sampleMaterials = Sample_Material_Functions.Populate_SAP_Material_Number_from_Materials_Table(sampleMaterials);

      update sampleMaterials;

      if (!String.isBlank(NotetoCSR)) {
          Boolean noteCreationResult = Note_Functions.createNote(sampleRequest.Id, system.label.Additional_Comments_for_CSR, NoteToCSR);
      }

      update sampleRequest;

      Task task = new Task();

      task.OwnerId = sampleRequest.CSR_Responsible_for_Order_Entry__c;
      task.WhatId = sampleRequest.Id;
      task.Subject = system.label.Sample_Request + '# ' + sampleRequest.name + ' for ' + account.name + ' - ' + system.label.Order_needs_to_be_created;
      task.ActivityDate = System.today();
      task.Status = 'Not Started';
      task.RecordTypeId = RecordType_Relationship_Functions.GetCSRTaskType_Based_on_AccountRecordTypeId(account.RecordTypeId);
      task.Type = system.label.Sample_Request;
      task.Priority = 'Normal';
      task.Description = NoteToCsr + '\n\n' + system.label.Order_needs_to_be_created+'. ' + system.label.Sample_request + ': ' +
                         SERVER_URL + '/' + sampleRequest.Id;

      insert task;

      List<String> toAddresses = new List<String>();
      toAddresses.add(retrieveEmailAddressfromUserId(sampleRequest.CSR_Responsible_for_Order_Entry__c));
      if(emailcsrgroupbox == true && account.SAP_CSR_Email__c != '' && account.SAP_CSR_Email__c != null){toAddresses.add(account.SAP_CSR_Email__c);}

      String targetURL = SERVER_URL +
                        '/apex/Sample_Request_Enter_Order_Info_CSR?sampleRequestId=' + sampleRequest.Id + '&taskId=' + task.Id + '"';

      Boolean emailResult = Email_Functions.sendEmail(toAddresses, null, null,
                              retrieveEmailAddressfromUserId(sampleRequest.Sample_Coordinator__c), system.label.Sample_Coordinator,
                              false,false,
                              system.label.Sample_Request + '# ' + sampleRequest.name + ' for ' + account.name + ' - ' + system.label.Order_needs_to_be_Created,
                              system.label.Order_needs_to_be_created+'. ' + system.label.Sample_request + ' :' + targetURL,
                              system.label.Order_needs_to_be_created+'. ' + system.label.Sample_request + ' : <a href="' +
                              targetURL + '" target="_blank">Click Here to Enter Order</a><br/><br/>Sample Notes: ' + samplerequest.Notes_Summary__c);

    }

  public void init_Cancel_Request() {
    errorMessage = '';

    getSampleRequest();
    getAccount();
    getContact();
    getOpportunity();

    if (sampleRequest.Sample_Coordinator__c != UserInfo.getUserId())
      {
      errorMessage = system.label.error_can_not_cancel;
      }
  }

  public Boolean Cancel_Request_Valid() {
    Boolean result = true;

    validationErrorMessage = '';

    if (sampleRequest.Cancellation_Reason__c == null) {
      validationErrorMessage = String_Functions.Format_ListString_into_HTML_List('You must enter a cancellation reason above before this Sample Request can be cancelled.','Error: ','');
      result = false; addErrorMessage();
    }

    return result;
  }
  public PageReference Cancel_Sample_Request() {
    PageReference result = null;

    errorMessage = '';

    if (sampleRequest != null)
      {
      if (Cancel_Request_Valid() == true)
        {
        if (sampleRequest.Sample_Coordinator__c == UserInfo.getUserId())
          {
          String NewRecordTypeId = RecordType_Functions.LookupRecordTypeId('Cancelled','Sample_Request__c');
          sampleRequest.RecordTypeId = NewRecordTypeId;
          sampleRequest.Status__c = 'Cancelled';
          sampleRequest.Sample_Approver__c = null;
          sampleRequest.Sample_Coordinator__c = null;
          sampleRequest.CSR_Responsible_for_Order_Entry__c = null;
          update sampleRequest;

          //Create a Note on the Sample Request with the Cancelled Reason
          Boolean noteCreationResult = Note_Functions.createNote(sampleRequest.Id,'Sample Request Cancelled',sampleRequest.Cancellation_Reason__c);
          update sampleRequest;

          PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
          sampleRequestPage.setRedirect(true);
          result = sampleRequestPage;
          }
        else
          {
          //Display an Error Message
          errorMessage = system.label.error_can_not_cancel;
          result = null;
          }
       }
      }
    else {result = null;}
  return result;
  }

  List<Sample_Material__c> sampleMaterials_toDelete;

  public List<Sample_Material__c> getSampleMaterials_toDelete() {

    if (sampleMaterials_toDelete == null)
      {
      String materialIds = System.currentPageReference().getParameters().get('materialIds');
      if ((materialIds != '') && (materialIds != null))
        {
        List<String> materialIdArray = materialIds.split(',');

        sampleMaterials_toDelete = [SELECT Id,
                                           Name,
                                           Actual_Ship_Date__c,
                                           AD_Compound__c,
                                           CurrencyIsoCode,
                                           Date_Required_By__c,
                                           Estimated_Arrival_Date__c,
                                           Estimated_Sample_Value__c,
                                           Estimated_Ship_Date__c,
                                           Existing_Material_in_SAP__c,
                                           Material_Must_Ship_From_Location__c,
                                           Potential_Annual_Value__c,
                                           Sample_Quantity__c,
                                           Sample_Request__c,
                                           Sample_UOM__c,
                                           SAP_Material__c,
                                           SAP_Material_Number__c,
                                           Ship_From_Location__c,
                                           Shipping_Carrier__c,
                                           Tectyl_Product__c,
                                           Tracking_Air_Bill__c,
                                           SAP_Material_MSD2__c
                                     FROM Sample_Material__c WHERE Id IN :materialIdArray];
        }
      }
    return sampleMaterials_toDelete;
  }

  public void init_Delete_Materials() {
    errorMessage = '';

    getSampleRequest();
    getAccount();
    getContact();
    getOpportunity();

    if (sampleRequest.OwnerId != UserInfo.getUserId())
      {
      errorMessage = system.label.error_can_not_delete;
      }
  }

  public PageReference Delete_Materials() {
    if (sampleMaterials_toDelete != null)
      {
      delete sampleMaterials_toDelete;
      }
    PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
    sampleRequestPage.setRedirect(true);
    return sampleRequestPage;
  }

  public void init_Edit_Materials() {
    errorMessage = '';
    getSampleRequest();
    getAccount();
    getContact();
    getOpportunity();
  }

  public PageReference Edit_Materials_Save() {

    PageReference result = null;

    getSampleRequest();
    getSampleMaterials();

    Boolean validMaterials = true;

    validationErrorMessage = '';

    sampleMaterials = Sample_Material_Functions.Remove_Blank_Rows_From_Material_List(sampleMaterials);

    validationErrorMessage = String_Functions.Format_ListString_into_HTML_List(Sample_Material_Functions.Validate_Materials(sampleMaterials, account, 'InitialEntry', true, getbusiness()),'','');
    if (validationErrorMessage != '')
      {validMaterials = false; addErrorMessage();}

    if (validMaterials == true)
      {

      String sampleMaterial_RecordType = RecordType_Relationship_Functions.GetMaterialRecordType_Based_on_AccountRecordTypeId(account.RecordTypeId);

      for (Sample_Material__c sm : sampleMaterials) {
        if (sm.Sample_Request__c == null) {
          Sample_Material__c newSampleMaterial = new Sample_Material__c(Additional_Admin_Cost__c = Additional_Cost_per_Line_Item);
          newSampleMaterial.Sample_Request__c = sampleRequest.id;
          newSampleMaterial.Name = sm.Name;
          newSampleMaterial.Sample_Quantity__c = sm.Sample_Quantity__c;
          newSampleMaterial.Sample_UOM__c = sm.Sample_UOM__c;
          newSampleMaterial.Date_Required_By__c = sm.Date_Required_By__c;
          newSampleMaterial.CurrencyIsoCode = sm.CurrencyIsoCode;
          newSampleMaterial.Estimated_Sample_Value__c = sm.Estimated_Sample_Value__c;
          newSampleMaterial.Potential_Annual_Value__c = sm.Potential_Annual_Value__c;
          newSampleMaterial.Ship_From_Location__c = sm.Ship_From_Location__c;
          newSampleMaterial.Tectyl_Product__c = sm.Tectyl_Product__c;
          newSampleMaterial.AD_Compound__c = sm.AD_Compound__c;
          newSampleMaterial.RecordTypeId = sampleMaterial_RecordType;

          insert newSampleMaterial;
        } else {
          if (isNull(sm.Name)) {delete sm;}
          else {update sm;}
        }
      }

      PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
      sampleRequestPage.setRedirect(true);
      result = sampleRequestPage;
    }

    return result;
  }

  String sampleRequestCompleted = 'true';

    public String getSampleRequestCompleted() {return sampleRequestCompleted;}
    public void setSampleRequestCompleted(String valueIn) {sampleRequestCompleted = valueIn;}

    public Boolean getRenderMarkSampleCompletedCheckbox() {
        Boolean result = false;

//            if ((SAMP_RECTYPES.get('Request Completed').getrecordtypeid() == sampleRequest.recordtypeid) && (errorMessage == ''))
            if ((sampleRequest.Status__c != 'Request Completed') && (errorMessage == ''))
                  {result = true;}

            return result;
    }

  public void init_Enter_Actual_Shipping_Information() {
    errorMessage = '';

    getSampleRequest();
    getAccount();
    getContact();
    getOpportunity();

    if (sampleRequest.Sample_Coordinator__c != UserInfo.getUserId() && sampleRequest.CSR_Responsible_for_order_Entry__c != UserInfo.getUserID())
      {
      errorMessage = system.label.Error_actual_shipping_info;
      }
    else{
      sampleMaterials = getsamplematerials();
      for(sample_material__c sm:samplematerials){
        if(sm.Actual_Ship_Date__c == null && sm.Estimated_Ship_Date__c != null){
        sm.Actual_Ship_Date__c = sm.Estimated_Ship_Date__c;}
      }//end for
    }//end else
  }

 public Boolean Actual_Shipping_Information_Valid() {
    Boolean result = true;

    validationErrorMessage = '';

    validationErrorMessage = String_Functions.Format_ListString_into_HTML_List(Sample_Material_Functions.Validate_Materials(sampleMaterials, account, 'OrderShipped', true, getbusiness()),'','');
    if (validationErrorMessage != '')
      {result = false; addErrorMessage();}

    return result;
  }

  public PageReference Save_Actual_Shipping_Information() {
    PageReference result = null;

    validationErrorMessage = '';

    if ((Actual_Shipping_Information_Valid() == true) || (sampleRequestCompleted == 'false'))
      {
      if (sampleRequestCompleted == 'true')
        {
        String NewRecordTypeId = RecordType_Functions.LookupRecordTypeId('Request Completed','Sample_Request__c');
        sampleRequest.RecordTypeId = NewRecordTypeId;
        sampleRequest.Status__c = 'Request Completed';
        update sampleRequest;
        }

      update sampleMaterials;

      PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
      sampleRequestPage.setRedirect(true);
      result = sampleRequestPage;
      }
    return result;
  }

  public String ShowMaterials='false';
  String sampleRequestOrderEntered = 'true';
  String prospectAccountInformation;
  String materialSpecificInstructions;
  public List<Note> sampleNotes;
  public Integer sampleNotesSize;

  public Integer getSampleNotesSize() {
    getsampleNotes();
    Integer result = 0;
    if (sampleNotes != null)
      {result = sampleNotes.Size();}
    return result;
  }

  public List<Note> getsampleNotes() {
    if (sampleNotes == null)
      {
        sampleNotes = Note_Functions.returnNotesRelatedtoObject(sampleRequest.Id);
      }

    return sampleNotes;
  }

  public Boolean getRenderSampleNotes() {
        Boolean result = false;

        if ((getSampleNotesSize() > 0) && (errorMessage == ''))
                {result = true;}

        return result;
  }

  public String getShowMaterials() {return ShowMaterials;}

  public String getCSR_Found_on_Account() {return null;}

  public String getSampleRequestOrderEntered() {return sampleRequestOrderEntered;}
  public void setSampleRequestOrderEntered(String valueIn) {sampleRequestOrderEntered = valueIn;}

  public String getProspectAccountInformation() {
    prospectAccountInformation = '';
    prospectAccountInformation += system.label.ProspectAccountInfo1 + '<BR>';
    prospectAccountInformation += '<ul type=circle>';
    prospectAccountInformation += '<li>' + system.label.ProspectAccountInfo2 + ' <a href="http://prod.tradepointsystems.com/" target="_blank">http://prod.tradepointsystems.com/</a><BR><BR>';
    prospectAccountInformation += '<li>' + system.label.ProspectAccountInfo3 + '<BR><BR>';
    prospectAccountInformation += '<ul type=circle>';
    prospectAccountInformation += '<li>' + system.label.ProspectAccountInfo4 + '<BR><BR>';
    prospectAccountInformation += '<li>' + system.label.ProspectAccountInfo5;
    prospectAccountInformation += '</ul>';
    prospectAccountInformation += '</ul>';

    return prospectAccountInformation;
  }

  public String getMaterialSpecificInstructions() {
    materialSpecificInstructions = '';
    materialSpecificInstructions += system.label.SAP_Material_Instructions;

    return materialSpecificInstructions;
  }

    public String getEnterOrderInformationPageTitle() {
        String result = System.label.Enter_the_Order_Info;

            if (SAMP_RECTYPES.get('Waiting for Order Creation').getRecordtypeID() == sampleRequest.recordtypeid)
                  {result = system.label.update_estimated_dates;}

            return result;
    }

    public Boolean getRenderMarkOrderCreatedCheckbox() {
        Boolean result = false;

            if ((SAMP_RECTYPES.get('Waiting for Order Creation').getRecordtypeID() == sampleRequest.recordtypeid) && (errorMessage == ''))
                  {result = true;}

            return result;
    }

  public void init_Enter_Order_Information() {
    errorMessage = '';
                        debug('sampleRequest1 = ' + sampleRequest);
    getSampleRequest();
    getAccount();
    getContact();
    getOpportunity();

    if (sampleRequest.Sample_Coordinator__c != UserInfo.getUserId())
      {
      errorMessage = system.label.Error_actual_shipping_info    ;
      }
  }

  public Boolean Order_Entry_by_Coordinator_Valid() {
    Boolean result = true;

    validationErrorMessage = '';

    validationErrorMessage = String_Functions.Format_ListString_into_HTML_List(Sample_Request_Functions.Validate_SAP_Order_Number(sampleRequest.SAP_Order_Number__c, true),system.label.Error + ': ','');
    validationErrorMessage += String_Functions.Format_ListString_into_HTML_List(Sample_Material_Functions.Validate_Materials(sampleMaterials, account, 'OrderEntry-Coordinator', true, getbusiness()),'','');


    if (validationErrorMessage != '')
      {result = false; addErrorMessage();}

    return result;
  }

  public void ToggleShowMaterials() {
    if (ShowMaterials == 'true') {ShowMaterials='false';} else {ShowMaterials='true';}
  }

  public PageReference Save_Order_Information_Coordinator() {
    PageReference result = null;

    if ((Order_Entry_by_Coordinator_Valid() == true) || (sampleRequestOrderEntered == 'false'))
      {
      if (sampleRequestOrderEntered == 'true')
        {
        String NewRecordTypeId = RecordType_Functions.LookupRecordTypeId('Order Created for Sample Request','Sample_Request__c');
        sampleRequest.RecordTypeId = NewRecordTypeId;
        sampleRequest.Status__c = 'Order Created for Sample Request';

        //Update Estimated_Ship_Date__c on Sample Request
        List<Date> EstimatedShipDates = new List<Date>();
        for (Sample_Material__c material:sampleMaterials)
          {
          EstimatedShipDates.Add(material.Estimated_Ship_Date__c);
          }
        sampleRequest.Estimated_Ship_Date__c = Date_Functions.returnLargestDate(EstimatedShipDates);

        String taskId = System.currentPageReference().getParameters().get('taskId');

        if ((taskId != '') && (taskId != null))
          {
          Task task = [SELECT Id, Status FROM Task WHERE Id = :taskId];
          task.status = 'Completed';
          update task;
          }
        }

      sampleMaterials = Sample_Material_Functions.Populate_SAP_Material_Number_from_Materials_Table(sampleMaterials);

      update sampleRequest;
      update sampleMaterials;

      PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
      sampleRequestPage.setRedirect(true);
      result = sampleRequestPage;
      }

    return result;
  }


    public Boolean Allow_CSR_to_Take_OrderEntry_Responsibility = false;

    public Boolean getAllow_CSR_to_Take_OrderEntry_Responsibility() {
        return Allow_CSR_to_Take_OrderEntry_Responsibility;
    }

  public void init_Enter_Order_Information_CSR() {
    errorMessage = '';

    getSampleRequest();
    getAccount();
    getContact();
    getOpportunity();

    Boolean TaskIncludedinURL = false;

    if (sampleRequest.CSR_Responsible_for_Order_Entry__c != null)
      {
      if (sampleRequest.CSR_Responsible_for_Order_Entry__c != UserInfo.getUserId())
        {
        String taskId = System.currentPageReference().getParameters().get('taskId');

        if ((taskId != '') && (taskId != null)) {Allow_CSR_to_Take_OrderEntry_Responsibility = true;}

        if (Allow_CSR_to_Take_OrderEntry_Responsibility == true)
            {errorMessage = system.label.Error_Order_Info_1 +  '<BR><BR>' + system.label.error_order_info_2 + '<BR><BR> ' + system.label.error_order_info_3;}
        else
            {errorMessage = system.label.error_order_info_1 +  '<BR><BR>' + system.label.error_order_info_4;}
        }
      }
    else
      {errorMessage = system.label.error_CSR_not_requested + ' <BR><BR>' + system.label.error_sc_can_enter_order_info;}

    if (errorMessage != '')
        {
        String coordinatorName = '';
        String csrName = '';
        coordinatorName = User_Functions.RetrieveUserName(sampleRequest.Sample_Coordinator__c);
        csrName = User_Functions.RetrieveUserName(sampleRequest.CSR_Responsible_for_Order_Entry__c);
        if (coordinatorName != '') {errorMessage += '<BR><BR>' + system.label.Current_Sample_Coordinator + ': <a href="/' + sampleRequest.Sample_Coordinator__c + '" target="_blank">' + coordinatorName + '</a>';}
        if (csrName != '') {errorMessage += '<BR>' + system.label.CSR_Responsible + ': <a href="/' + sampleRequest.CSR_Responsible_for_Order_Entry__c + '" target="_blank">' + csrName + '</a>';}
        }

  }

  // Step Validation
  public Boolean Order_Entry_by_CSR_Valid() {
    Boolean result = true;

    validationErrorMessage = '';

    //Perform Sample Request
    validationErrorMessage = String_Functions.Format_ListString_into_HTML_List(Sample_Request_Functions.Validate_SAP_Order_Number(sampleRequest.SAP_Order_Number__c, true),system.label.Error+': ','');

    //Perform Validation
    validationErrorMessage += String_Functions.Format_ListString_into_HTML_List(Sample_Material_Functions.Validate_Materials(sampleMaterials, account, 'OrderEntry-CSR', true, getbusiness()),'','');

    if (validationErrorMessage != '')
      {result = false; addErrorMessage();}

    return result;
  }

  // General Functions
  public PageReference Save_Order_Information_CSR() {
    PageReference result = null;

    if ((Order_Entry_by_CSR_Valid() == true) || (sampleRequestOrderEntered == 'false'))
      {
      if (sampleRequestOrderEntered == 'true')
        {
        String NewRecordTypeId = RecordType_Functions.LookupRecordTypeId('Order Created for Sample Request','Sample_Request__c');
        sampleRequest.RecordTypeId = NewRecordTypeId;
        sampleRequest.Status__c = 'Order Created for Sample Request';

        //Update Estimated_Ship_Date__c on Sample Request
        List<Date> EstimatedShipDates = new List<Date>();
        for (Sample_Material__c material:sampleMaterials)
          {
          EstimatedShipDates.Add(material.Estimated_Ship_Date__c);
          }
        sampleRequest.Estimated_Ship_Date__c = Date_Functions.returnLargestDate(EstimatedShipDates);

        String taskId = System.currentPageReference().getParameters().get('taskId');

        if ((taskId != '') && (taskId != null))
          {
          Task task = [SELECT Id, Status, Total_Hours__c FROM Task WHERE Id = :taskId];
          task.status = 'Completed';
          if (task.Total_Hours__c == null) {task.Total_Hours__c = 0;}
          update task;
          }
        }

      sampleMaterials = Sample_Material_Functions.Populate_SAP_Material_Number_from_Materials_Table(sampleMaterials);

      update sampleRequest;
      update sampleMaterials;

      PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
      sampleRequestPage.setRedirect(true);
      result = sampleRequestPage;
      }

    return result;
  }

    public PageReference Reassign_CSR_Associated_with_Sample_Request() {
        PageReference result = null;

        //Get the current users information
        Id newUserId = UserInfo.getUserId();
        String newUserName = UserInfo.getName();

        //Get the old CSRs Info
        Id oldUserId = sampleRequest.CSR_Responsible_for_Order_Entry__c;
        String oldUserName = User_Functions.RetrieveUserName(oldUserId);

        //Get the Sample Coordinators Info
        Id coordinatorUserId = sampleRequest.Sample_Coordinator__c;
        String coordinatorUserName = User_Functions.RetrieveUserName(coordinatorUserId);

        //Update the Sample Request with the new CSR
        sampleRequest.CSR_Responsible_for_Order_Entry__c = newUserId;
        //sampleRequest.Material_Summary__c = Sample_Material_Functions.SummarizeMaterialsonSampleRequest(sampleRequest.Id);
        update sampleRequest;
        
            List<String> toAddresses = new List<String>();
            toAddresses.add(retrieveEmailAddressfromUserId(oldUserId));
        toAddresses.add(retrieveEmailAddressfromUserId(coordinatorUserId));

        String subject = sampleRequest.Name + ' - ' + system.label.Backup_CSR_taken_over;
        String body = newUserName + system.label.is_backing_up + oldUserName + system.label.and_has_taken_over + sampleRequest.Name + '.' + '\n\n' +
                      system.label.to_view_SR + ' ' + SERVER_URL + '/' + sampleRequest.Id + '\n\nSample Notes: ' + sampleRequest.Notes_Summary__c ;

            Boolean emailResult = Email_Functions.sendEmail(toAddresses, null, null,
                                  retrieveEmailAddressfromUserId(newUserId), newUserName,
                                  false, false, subject, body, null);

        //Create a Note with the content of the Email
        Boolean noteCreationResult = Note_Functions.createNote(sampleRequest.Id,system.label.Backup_CSR_taken_over,newUserName + ' is backing up ' + oldUserName + ' ' +system.label.and_has_taken_over);
        Update SampleRequest;
        //Update the owner of the task
        String taskId = System.currentPageReference().getParameters().get('taskId');

        if ((taskId != '') && (taskId != null))
          {
          Task task = [SELECT Id, OwnerId, Status FROM Task WHERE Id = :taskId];
          task.OwnerId = newUserId;
          update task;
          }

        //Perform a refresh of the screen so they see the order entry screen
        //String targetURL = '/apex/Sample_Request_Enter_Order_Info_CSR?sampleRequestId=' + sampleRequest.Id + '&taskId=' + taskId;
            PageReference CSROrderEntryPage = new PageReference('/apex/Sample_Request_Enter_Order_Info_CSR');
            CSROrderEntryPage.getParameters().put('sampleRequestId',sampleRequest.Id);
        CSROrderEntryPage.getParameters().put('taskId',taskId);
            CSROrderEntryPage.setRedirect(true);
        result = CSROrderEntryPage;

        return result;
    }


  public void init_Place_Request_On_Hold() {
    errorMessage = '';

    getSampleRequest();
    getAccount();
    getContact();
    getOpportunity();
    onhold_followup_task = new task();

    if (sampleRequest.Sample_Coordinator__c != UserInfo.getUserId())
            {
            errorMessage = system.label.error_can_not_place_on_hold;
            }

  }


  // Step Validation
  public Boolean Place_Request_On_Hold_Valid() {
    Boolean result = true;

    validationErrorMessage = '';

    //Perform Cancel Request Validation
    if (sampleRequest.On_Hold_Reason__c == null)
      {
      validationErrorMessage = String_Functions.Format_ListString_into_HTML_List(system.label.must_enter_reason,system.label.Error+': ','');
      result = false; addErrorMessage();
      }

    return result;
  }

  // General Functions
  public PageReference Place_Sample_Request_On_Hold() {
    PageReference result = null;
    errorMessage = '';

    if (sampleRequest != null)
      {
      if (Place_Request_On_Hold_Valid() == true)
        {
        String NewRecordTypeId = RecordType_Functions.LookupRecordTypeId('On-Hold','Sample_Request__c');
        sampleRequest.RecordTypeId = NewRecordTypeId;
        sampleRequest.Status__c = 'On-Hold';
        update sampleRequest;

        //Create a Note on the Sample Request with the Cancelled Reason
        Boolean noteCreationResult = Note_Functions.createNote(sampleRequest.Id,'Sample Request Placed On-Hold',sampleRequest.On_Hold_Reason__c);
        update sampleRequest;

        //Send FollowUp Task to Selected User

        if(onhold_followup_task.ownerid != null){
        onhold_followup_task.subject = 'Follow-Up Required: Sample Request ' + samplerequest.name + ' Placed On-Hold';
        task_Functions.createtaskandsendemails(onhold_followup_task.ownerid, Samplerequest.id, onhold_followup_task.subject, samplerequest.on_hold_reason__c, account );
        }


        PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
        sampleRequestPage.setRedirect(true);
        result = sampleRequestPage;
        }
      }
    else
      {
      result = null;
      }
  return result;
  }

// Generic Address Routines (Should eventually become a component
  // Variable Declaration
  public String Address_Street = '';
  public String Address_City = '';
  public String Address_State = '';
  public String Address_PostalCode = '';
  public String Address_Country = '';
  public String ShowUpdateAddressInformation='false';
  public String AddressChangeError = '';

  // Get/Set Functions
  public String getStreet() {return Address_Street;}
  public void setStreet(String street) {Address_Street = street;}

  public String getCity() {return Address_City;}
  public void setCity(String City) {Address_City = City;}

  public String getState() {return Address_State;}
  public void setState(String State) {Address_State = State;}

  public String getPostalCode() {return Address_PostalCode;}
  public void setPostalCode(String PostalCode) {Address_PostalCode = PostalCode;}

  public String getCountry() {return Address_Country;}
  public void setCountry(String Country) {Address_Country = Country;}

  public String getShowUpdateAddressInformation() {return ShowUpdateAddressInformation;}

  public String getAddressChangeError() {return AddressChangeError;}

  // Step Validation

  // General Functions
  public void UpdateAddressInformation_Button() {
    getSampleRequest();
    ShowUpdateAddressInformation = 'true';
    AddressChangeError = '';
    List <String> addressLines = new List<String>();
    addressLines.add(sampleRequest.Address_Line_1__c);
    addressLines.add(sampleRequest.Address_Line_2__c);
    addressLines.add(sampleRequest.Address_Line_3__c);
    addressLines.add(sampleRequest.Address_Line_4__c);
    String address = Address_Functions.convert4LineAddressto1(addressLines);

    Address_Street = address;
    Address_City = sampleRequest.City__c;
    Address_State = sampleRequest.State__c;
    Address_PostalCode = sampleRequest.Postal_Zip_Code__c;
    Address_Country = sampleRequest.Country__c;
  }


  public void SaveAddressChanges() {
    Boolean error = false;
    AddressChangeError = '';

    //Perform Validation
    if (Address_Street == '') {error = true;AddressChangeError+='<li>' + system.label.error_street_required;}
    if (Address_City == '') {error = true;AddressChangeError+='<li>' + system.label.error_city_is_required;}
//    if (Address_State == '') {error = true;AddressChangeError+='<li>Error: State/Province is Required.';}
    if (Address_PostalCode == '') {error = true;AddressChangeError+='<li>' + system.label.Error_Postal_Code_is_Required;}
    if (Address_Country == '') {error = true;AddressChangeError+='<li>' + system.label.error_country_required;}
    if (AddressChangeError!= '') {AddressChangeError = '<ul type=circle>' + AddressChangeError + '</ul>';}

    if (error == false)
            {
            List <String> addressLines = Address_Functions.convert1LineAddressto4(Address_Street);

            if (addressLines.size() > 0) {sampleRequest.Address_Line_1__c = addressLines.get(0);} else {sampleRequest.Address_Line_1__c = '';}
            if (addressLines.size() > 1) {sampleRequest.Address_Line_2__c = addressLines.get(1);} else {sampleRequest.Address_Line_2__c = '';}
            if (addressLines.size() > 2) {sampleRequest.Address_Line_3__c = addressLines.get(2);} else {sampleRequest.Address_Line_3__c = '';}
            if (addressLines.size() > 3) {sampleRequest.Address_Line_4__c = addressLines.get(3);} else {sampleRequest.Address_Line_4__c = '';}
            sampleRequest.City__c = Address_City;
            sampleRequest.State__c = Address_State;
            sampleRequest.Postal_Zip_Code__c = Address_PostalCode;
            sampleRequest.Country__c = Address_Country;
            sampleRequest.Ship_To_Address_Type__c = ADDRESS_TYPE_MANUAL;
            }

    ShowUpdateAddressInformation = 'false';
  }

  public void CancelAddressChanges() {
    AddressChangeError = '';
    ShowUpdateAddressInformation = 'false';
  }

    public List<SelectOption> getDistChanOpts() {
        if (distChanOpts == null) {
            distChanOpts = Sample_Request_Config.getDistChanOpts();
        }
        return distChanOpts;
    }

    public List<SelectOption> getSalesOrgOpts() {
        if (salesOrgOpts == null) {
            salesOrgOpts = SAP_Queries_Functions.getsalesOrgOpts();
        }
        return salesOrgOpts;
    }

    public List<SelectOption> getSampleCenterOpts() {
        if (sampleCenterOpts == null) {
          if(account!= null  && account.SAP_SALES_ORG__C !=null &&
                account.SAP_SALES_ORG__C.startsWith('X')){
                sampleCenterOpts = Sample_Request_Config.getSampleCenterOpts(Sample_Request_Config.DC_APM);

                } else
            if (isASK) {
                sampleCenterOpts = Sample_Request_Config.getSampleCenterOpts(Sample_Request_Config.DC_ASK);
            } else {
                sampleCenterOpts = Sample_Request_Config.getSampleCenterOpts(accountRecordType);
            }
        }
        return sampleCenterOpts;
    }

    public List<SelectOption> getSampleReasonOpts() {
        if (sampleReasonOpts == null) {
            sampleReasonOpts = Sample_Request_Config.getSampleReasonOpts(accountRecordType);
        }
        //Added by SandhyaCH 9/13/2023 for LA approval process 2605-2641
        List<SelectOption> filteredOptions = new List<SelectOption>();
        
        if (sampleReasonOpts != null) {
            if (account.SAP_Sales_Org_Region_value1__c != 'LA') {
                for (SelectOption option : sampleReasonOpts) {
                    String value = option.getValue();
                    if (!value.equals(Sample_Request_Config.RFS_ASI_09) &&
                        !value.equals(Sample_Request_Config.RFS_ASI_10) &&
                        !value.equals(Sample_Request_Config.RFS_ASI_11)) {
                            filteredOptions.add(option);
                        }
                }
            } else if (account.SAP_Sales_Org_Region_value1__c == 'LA') {
                if (account.SAP_Sales_Org__c == '0111' || account.SAP_Sales_Org__c == '5500') {
                    for (SelectOption option : sampleReasonOpts) {
                        String value = option.getValue();
                        if (value.equals(Sample_Request_Config.RFS_ASI_09) ||
                            value.equals(Sample_Request_Config.RFS_ASI_10) ||
                            value.equals(Sample_Request_Config.RFS_ASI_11) ||
                            value.equals(Sample_Request_Config.RFS_OTHER)) {
                                filteredOptions.add(option);
                            }
                    }
                } else {
                    for (SelectOption option : sampleReasonOpts) {
                        String value = option.getValue();
                        if (value.equals(Sample_Request_Config.RFS_ASI_09) ||
                           value.equals(Sample_Request_Config.RFS_OTHER)) {
                            filteredOptions.add(option);
                        }
                    }
                }
            }
        }
        
        // Only return sampleReasonOpts if filteredOptions is empty.
        return filteredOptions.isEmpty() ? sampleReasonOpts : filteredOptions;
    }

   
    public List<SelectOption> getShipFromLocOpts() {
        if (shipFromLocOpts == null) {
            shipFromLocOpts = Sample_Request_Config.getShipFromLocOpts(accountRecordType);
        }
        return shipFromLocOpts;
    }

    public List<SelectOption> getSalutationOptions() {
        if (salutationOptions == null) {
            Schema.DescribeFieldResult dfr = Sample_Request__c.Contact_Salutation__c.getDescribe();
            salutationOptions = Schema_Functions.getPicklistOptions(dfr);
        }
        return salutationOptions;
    }

    public List<SelectOption> getCountrySelectOptions() {
        if (countrySelectOptions == null) {
            countrySelectOptions = SAP_Queries_Functions.getCountrySelectList();
        }
        return countrySelectOptions;
    }

    public List<SelectOption> getUomSelectOptions() {
        if (uomSelectOptions == null) {setUomSelectOptions();}
        return uomSelectOptions;
    }

    private void setUomSelectOptions() {
        uomSelectOptions = UOM_Conversion_Functions.getUomSelectOptions(accountRecordType);
        /*
        if (sampleRequest != null &&
            sampleRequest.Aquarius_Sample__c) {
            List<SelectOption> alist = new List<SelectOption>();
            alist.add(new SelectOption('1 Kilogram', '1 Kilogram'));
            uomSelectOptions.addAll(alist);
        }
        */
    }

    public List<SelectOption> getMatStatOpts() {
        if (matStatOpts == null) {
            matStatOpts = Sample_Request_Functions.getDistChanMatStatOpts();
        }
        return matStatOpts;
    }

/*
    private void populate_AD_Carrier_Number(){
      if(Carrier != '' && Carrier!= null && SampleRequest.UPS_Fed_Ex_Number__c != null){
            SampleRequest.UPS_Fed_Ex_Number__c = Carrier + ' ' + SampleRequest.UPS_Fed_Ex_Number__c;
      }
   }
*/

    public String getAccName() {
        if (lisd != null) {return lisd.getAccountName();}
        else if (account != null) {return account.Name;}
        else {return '';}
    }

    public String getAccNum() {
        if (lisd != null) {return lisd.getAccountNum();}
        else if (account != null) {return account.AccountNumber;}
        else {return '';}
    }

    public String getSellerName() {
        if (lisd != null) {return lisd.getSellerName();}
        else if (account != null) {return account.Owner.Name;}
        else {return '';}
    }

    public String getIndustry() {
        if (lisd != null) {return lisd.getIndustryLabel();} else {return '';}
    }

    public String getEnduseCust() {
        String s = '';
        if (lisd != null) {s = getString(lisd.getEndUseCustLabel());}
        return s;
    }

    public String getCustGroup() {
        String s = ''; if (lisd != null) {s = lisd.getCustGroupLabel();}
        if (isNone(s) && account != null) {s = account.SAP_Customer_Group_Desc__c;}
        return s;
    }

    public String getSalesDistrict() {
        String s = ''; if (lisd != null) {s = lisd.getSalesDstLabel();}
        if (isNone(s) && account != null) {s = account.SAP_SALES_DISTRICT_DESC__C;}
        return s;
    }

    public String getSalesOffice() {
        String s = ''; if (lisd != null) {s = lisd.getSalesOfcLabel();}
        if (isNone(s) && account != null) {s = account.SAP_SALES_OFFICE_DESC__C;}
        return s;
    }

    public String getSalesGroup() {
        String s = ''; if (lisd != null) {s = lisd.getSalesGrpLabel();}
        if (isNone(s) && account != null) {s = account.SAP_SALES_GROUP_DESC__C;}
        return s;
    }

    public String getSalesArea() {
        if (lisd != null) {return lisd.salesArea;}
        else if (account != null) {return account.SAP_SALES_ORG__C + ' - ' +
                                          account.SAP_DISTCHANNEL__C + ' - ' +
                                          account.SAP_DIVISIONCODE__C;}
        else {return '';}
    }

    public boolean renderSampleCenter {
        get {return sampleRequest != null && !isNull(sampleRequest.Sample_Center__c);}
    }

    public String getVcpRating() {
        return account == null ? '' : account.Customer_Classification_ABC__c;
    }
    public boolean renderVcpRating  {get{return isASI;}}

    public String contactName {
        get {
            if (sampleRequest == null) {return '';}
            String s = getString(sampleRequest.Contact_First_Name__c) + ' ' +
                       getString(sampleRequest.Contact_Last_Name__c);
            return s;
        }
    }
    public boolean renderContactName  {get{return !isNull(contactName);}}

    public String contactPhone {
        get {
            if (sampleRequest == null) {return '';}
            String s = getString(sampleRequest.Contact_Phone_Number__c);
            return s;
        }
    }
    public boolean renderContactPhone  {get{return !isNull(contactPhone);}}

    public String contactEmail {
        get {
            if (sampleRequest == null) {return '';}
            String s = getString(sampleRequest.Contact_Email__c);
            return s;
        }
    }
    public boolean renderContactEmail  {get{return !isNull(contactEmail);}}

    public String requestReason {
        get {
            if (sampleRequest == null) {return '';}
            String s = getString(sampleRequest.Reason_for_Sample__c);
            return s;
        }
    }
    public boolean renderRequestReason  {get{return !isNull(requestReason);}}

    public Opportunity newOpp     {get; private set;}
    public String oppName         {get; set;}
    public boolean createNewOpp   {get; set;}
    public boolean renderOppsPB   {get; private set;}
    public boolean renderOppsList {get; private set;}
    public boolean renderOppName  {get{return !isNull(oppName);}}
    public boolean showRelatedOpp {get; set;}

    public void cancelSearchOpps() {
        debug('cancelSearchOpps : ' + sampleRequest.Opportunity__c + ' : ' + oppName);
        if (createNewOpp && !validNewOpp()) {return;}
        renderLisd = true; renderStep1PB1 = true; renderOppsPB = false;
    }

    public void selectOpp() {
        createNewOpp = false;
        String oppId = sampleRequest.Opportunity__c; if (isNull(oppId)) {return;}
        Opportunity o = [SELECT id, Name FROM Opportunity WHERE Id = :oppId];
        oppName = o.Name; cancelSearchOpps();
    }

    public void onCreateNewOppClick() {}

    public void onShowRelatedOppClick() { searchOpps(); }
	@testVisible
    private Boolean validNewOpp() {
        Boolean b1 = true, b2 = true, b3 = true;
        String s = 'Opportunity '; oppName = newOpp.Name;

        b1 = String.isBlank(oppName);
        if(b1) {b2 = false; addReqMsg(s + 'Name');}

        b1 = (newOpp.CloseDate == null);
        if(b1) {b2 = false; addReqMsg(s + 'Close Date');}

        b1 = (newOpp.Target_Volume__c == null || newOpp.Target_Volume__c <= 0);
        if(b1) {b2 = false; b3 = false; addReqMsg(s + 'Annual Volume');}

        b1 = (newOpp.ASP__c == null || newOpp.ASP__c <= 0);
        if(b1) {b2 = false; b3 = false; addReqMsg(s + 'Average Price');}

        if (b3) {newOpp.Amount = newOpp.Target_Volume__c * newOpp.ASP__c;}

        b1 = String.isBlank(newOpp.Description);
        if(b1) {b2 = false; addReqMsg(s + 'Description');}

        b1 = String.isBlank(newOpp.StageName);
        if(b1) {b2 = false; addReqMsg(s + 'Stage');}

        return b2;
    }

    private void initNewOpp() {
        newOpp = new Opportunity();
        newOpp.AccountId = sampleRequest.Account__c;
        newOpp.OwnerId = account.OwnerId;
        Map<String, Id> rtmap = Schema_Functions.getRecordTypeNameMap('Opportunity');
        Id rtid = null; if (isAPM) {rtid = rtmap.get('Performance Materials - PM');}
        if (rtid != null) {newOpp.RecordTypeId = rtid;}
        initRelatedAccts();
    }

    private void initRelatedAccts()
    {
        accMap = Account_Partner_Functions.getParentAccounts(sampleRequest.Account__c);
        BuildAcctListSelectOptions();
    }

    public void BuildAcctListSelectOptions()
    {
        for (Account a:accMap.Values())
        {
            relatedAccountsList.add(new SelectOption(a.Id, a.Name + ' ' + a.AccountNumber));
        }

    }

    public void OnNewOppAcctChange()
    {
        newOpp.OwnerId = accMap.get(newOpp.AccountId).OwnerId;

    }

    public void searchOpps() {
        renderLisd = false; renderStep1PB1 = false;
        renderOppsPB = true; renderMaxMsg1 = false;
        opportunities = new List<Opportunity>();
        if (newOpp == null) {initNewOpp();}
        if (sampleRequest.Account__c == null) {return;}
        String accId = sampleRequest.Account__c;
        String q = '';

        System.Debug('searchOpps:showRelatedOpp ' + showRelatedOpp);
        if (showRelatedOpp)
        {
            String accountIdsParam = '';
            for (Id i:accMap.keySet())
            {
                if (accountIdsParam == '')
                    accountIdsParam = '\'' + i + '\'';
                else
                    accountIdsParam += ',' + '\'' + i + '\'';
            }
            q = 'SELECT id, Name, RecordType.Name, Description, StageName, CloseDate, AccountId, Account.Name, Account.AccountNumber, Account.Type ';
            q += 'FROM Opportunity WHERE AccountId in (' + accountIdsParam + ')' ;
        }
        else
        {
            q = 'SELECT id, Name, RecordType.Name, Description, StageName, CloseDate, AccountId, Account.Name, Account.AccountNumber, Account.Type  ';
            q += 'FROM Opportunity WHERE AccountId = :accId ';
        }
        if (isASI) {q += ' AND IsClosed = false';}
        if (!isNull(oppName)) {q += ' and Name like \'%' + oppName + '%\'';}
        q += ' ORDER BY Account.Name, Account.AccountNumber, Name ';
        q += ' limit ' + String.valueOf(maxCount1 + 1); debug(q);
        //try {opportunities = Database.query(q);} catch(Exception e) {}
        opportunities = Database.query(q);
        renderOppsList = (opportunities != null && !opportunities.isEmpty());
        renderMaxMsg1 = renderOppsList && opportunities.size() > maxCount1;
    }

    public String tsrName         {get; set;}
    public List<Case> tsrs        {get; private set;}
    public boolean renderTsrsPB   {get; private set;}
    public boolean renderTsrsList {get; private set;}
    public boolean renderTsrName  {get{return !isNull(tsrName);}}

    public void cancelSearchTsrs() {
        renderLisd = true; renderStep1PB1 = true; renderTsrsPB = false;
    }

    public void searchTsrs() {
        renderLisd = false; renderStep1PB1 = false;
        renderTsrsPB = true; renderMaxMsg1 = false;
        tsrs = new List<Case>();
        if (sampleRequest.Account__c == null) {return;}
        Set<String> rtset = new Set<String>{'AAFI-TSR', 'AAFI-TSR-Approved',
            'AAFI-TSSR', 'AAFI-TSSR-Approved'};
        String accId = sampleRequest.Account__c;
        String q = 'SELECT Id, CaseNumber, RecordType.Name, Status, Subject';
        q += ' FROM Case where AccountId = :accId AND IsClosed = false';
        if (isASI) {q += ' AND RecordType.Name in :rtset';}
        if (!isNull(tsrName)) {q += ' and Subject like \'%' + tsrName + '%\'';}
        q += ' order by Subject, CaseNumber';
        q += ' limit ' + String.valueOf(maxCount1 + 1); debug(q);
        try {tsrs = Database.query(q);} catch(Exception e) {}
        renderTsrsList = (tsrs != null && !tsrs.isEmpty());
        renderMaxMsg1 = renderTsrsList && tsrs.size() > maxCount1;
    }

    public String leadName         {get; set;}
    public List<Lead> leads        {get; private set;}
    public boolean renderLeadsPB   {get; private set;}
    public boolean renderLeadsList {get; private set;}
    public boolean renderLeadName  {get{return !isNull(leadName);}}

    public void cancelSearchLeads() {
        renderLisd = true; renderStep1PB1 = true; renderLeadsPB = false;
    }

    public void searchLeads() {
        renderLisd = false; renderStep1PB1 = false;
        renderLeadsPB = true; renderMaxMsg1 = false;
        leads = new List<Lead>();
        if (sampleRequest.Account__c == null) {return;}
        if (account == null) {getAccount();}
        String accId = sampleRequest.Account__c, artId = account.RecordTypeId;
        Set<String> lrtIds = RecordType_Relationship_Functions.getAccountLeadRecordTypeIds(artId);
        Set<String> lstats = new Set<String>{'Open', 'Potential', 'Qualified'};
        String q = 'SELECT Id, Name, RecordType.Name, Status FROM Lead ';
        q += 'where isConverted = false and Status in :lstats ';
        if (!lrtIds.isEmpty()) {q += ' and RecordTypeId in :lrtIds ';}
        if (!isNull(leadName)) {q += ' and Name like \'%' + leadName + '%\'';}
        q += ' order by Name';
        q += ' limit ' + String.valueOf(maxCount1 + 1); debug(q);
        try {leads = Database.query(q);} catch(Exception e) {}
        renderLeadsList = (leads != null && !leads.isEmpty());
        renderMaxMsg1 = renderLeadsList && leads.size() > maxCount1;
    }

    public class SampleMaterial {
        public Boolean cancelled     {get; set;}
        public Boolean selected      {get; set;}
        public Boolean specialUom    {get; set;}
        public Integer recNum        {get; set;}
        public String matName        {get; set;}
        public String matStat        {get; set;}
        public String matId          {get; set;}
        public String qtyStr         {get; set;}
        //public NumberClass qty       {get; set;}
        public Sample_Material__c sm {get; set;}

        public SampleMaterial() {}
        public SampleMaterial(Sample_Material__c m) {this(m, 1);}
        public SampleMaterial(Sample_Material__c m, Integer n) {
            recNum = n; selected = false; specialUom = false; sm = m; qtyStr = '';
            //qty = new NumberClass();
            cancelled = (m.Record_Status__c != null &&
                         CANCELLED_STATS.contains(m.Record_Status__c));
        }
    }

    public class SampleMaterialCatalog {
        public Boolean selected   {get; set;}
        public Integer recNum     {get; set;}
        public String distChan    {get; set;}
        public String matId       {get; set;}
        public String matName     {get; set;}
        public String matStat     {get; set;}
        public String matUom      {get; set;}
        public String matUwt      {get; set;}
        public String outOfStock  {get; set;}
        public String sampleMtrl  {get; set;}
        public String salesOrg    {get; set;}
        public String styleClass  {get; set;}

        public String catId       {get; set;}
        public String msdId       {get; set;}

        public SampleMaterialCatalog() {}
        public SampleMaterialCatalog(SObject a) {this(a, 1);}
        public SampleMaterialCatalog(SObject a, Integer n) {
            init1(n);
            if (a instanceof Sample_Material_Catalog__c) {
                init2((Sample_Material_Catalog__c)a);
            } else
            if (a instanceof Material_Sales_Data2__c) {
                init2((Material_Sales_Data2__c)a);
            }
        }

        private void init1(Integer n) {
            recNum = n; selected = false; outOfStock = ''; styleClass = ''; sampleMtrl = '';
            distChan = ''; salesOrg = '';
        }

        private void init2(Sample_Material_Catalog__c a) {
            catId = a.Id; matId = a.Id; matUom = a.Sample_Size__c; matUwt = a.Unit_Weight__c;
            matName = a.Product_Name__c + ' - ' + a.Product_Code__c;
            if (a.Out_of_Stock__c != null && a.Out_of_Stock__c) {outOfStock = 'Yes';}
        }

        private void init2(Material_Sales_Data2__c a) {
            msdId = a.Id; matId = a.Id; matName = a.Name;
            matUom = a.Container_Desc__c; sampleMtrl = a.Sample_Material__c;
            distChan = a.Dist_Channel_Code__c; salesOrg = a.Sales_Org_Code__c;
            matStat = a.Dist_Channel_Material_Status__c;
        }
    }

    private Set<String> selectedMatIds = new Set<String>();

    public List<SampleMaterialCatalog> matCatalog {get; private set;}
    public String sampleCenterMsg {get; private set;}
    public String sampleCenterMsgStyle {get; private set;}
    public String labContactName {get; private set;}

    public String matSrchString {get; set;}
    public String matStat {get; set;}
    public Boolean allMatCatalog {get; set;}
    public Boolean allMats {get; set;}
    public PaginationController pc1 {get; private set;}
    public Boolean renderLabContactInput  {get; private set;}
    public Boolean renderLabContactOutput {get; private set;}
    public Boolean isCMCSampCenter {get; private set;}
    public Boolean isOthSampCenter {get; private set;}
    public Boolean renderMatCatalog {get; private set;}
    public Boolean renderMatCatalogPB {get; private set;}
    public Boolean renderNochargeInput  {get; private set;}
    public Boolean renderSpecialSize {get; private set;}

    public void pc1Size() {setMatCatalog(null);}
    public void pc1Frst() {setMatCatalog(PaginationController.Page.FIRST);}
    public void pc1Prev() {setMatCatalog(PaginationController.Page.PREV);}
    public void pc1Next() {setMatCatalog(PaginationController.Page.NEXT);}
    public void pc1Last() {setMatCatalog(PaginationController.Page.LAST);}
	@testVisible
    private void setLabContact() {
        renderLabContactOutput = (labContact.OwnerId != null);
        if (!renderLabContactOutput) {return;}
        sampleRequest.RD_Lab_Contact__c = labContact.OwnerId;
        User u = [select Name from User where Id = :labContact.OwnerId];
        if (u != null) {labContactName = u.Name;}
    }

    private void setMatCatalog() {setMatCatalog(null);}

    private void setMatCatalog(PaginationController.Page p) {
        renderMatCatalog = false;
        matCatalog = new List<SampleMaterialCatalog>();
        List<SObject> slist = null; Integer n = 0;
        sampleCenterMsg = ''; sampleCenterMsgStyle = '';
        if (pc1 != null) {
            pc1.gotoPage(p); n = pc1.recordFrom;
            slist = pc1.getRecords(); pageSize = pc1.getPageSize();
        }
        if (slist == null || slist.isEmpty()) {
            //sampleCenterMsg = 'Material Catalog not found';
            sampleCenterMsgStyle = 'Warning'; return;
        }
        SampleMaterialCatalog mc;
        for (SObject a : slist) {
            mc = new SampleMaterialCatalog(a, n++); setStyleClass(mc);
            matCatalog.add(mc);
        }
        renderMatCatalog = !matCatalog.isEmpty();
    }
	
    private void setStyleClass(SampleMaterialCatalog mc) {
        mc.styleClass = '';
        if (selectedMatIds.contains(mc.matId)) {mc.styleClass = 'boldblue';}
    }

    private void setNochargeOrder() {
        renderAddMaterialsBtn = true;
        if (sampleRequest.No_Charge_Order__c == null) {sampleRequest.No_Charge_Order__c = false;}
        if (isAHWT && !isOthSampCenter && !sampleRequest.No_Charge_Order__c) {renderAddMaterialsBtn = false;}
        renderNochargeInput = (isAHWT && materials.isEmpty() && !isOthSampCenter);
    }

    public void setMatCatalogPC() {
        renderLabContactInput = false; renderMatCatalog = false;
        String sc = sampleRequest.Sample_Center__c;
        isCMCSampCenter = Sample_Request_Functions.isCMCSampleCenter(sc);
        isOthSampCenter = Sample_Request_Functions.isOthSampleCenter(sc);
        renderShipFromLocation = !isASI && !isCMCSampCenter;
        sampleCenterMsgStyle = ''; sampleCenterMsg = '';
        initSmallPackSale(); setNochargeOrder();
        debug('sampleRequest : ' + sampleRequest);
        if (!renderAddMaterialsBtn) {return;}
        if (!isAHWT) {matStat = null;}
        pc1 = Sample_Request_Functions.getMatCatalogPC(sampleRequest, account, matSrchString, matStat, pageSize);
        setMatCatalog();
    }

    public void changeCommercialOrder() {
        renderMatCatalog = false;
        sampleRequest.No_Charge_Order__c = false;
        sampleRequest.Commercial_Order__c = false;
        if (commercialOrder) {
            noncmrcialOrder = false;
            sampleRequest.No_Charge_Order__c = true;
            sampleRequest.Commercial_Order__c = true;
        }
    }

    public void changeNoncmrcialOrder() {
        renderMatCatalog = false;
        sampleRequest.No_Charge_Order__c = false;
        sampleRequest.Commercial_Order__c = false;
        if (noncmrcialOrder) {
            commercialOrder = false;
            sampleRequest.No_Charge_Order__c = true;
        }
    }

    public void commercialOrderAction() {
        changeCommercialOrder(); setMatCatalogPC();
    }

    public void noncmrcialOrderAction() {
        changeNoncmrcialOrder(); setMatCatalogPC();
    }

    public void selectMaterialsAndReturn() {
        selectCatalogMaterials(); returnFromMatCatalog();
    }

    public void selectCatalogMaterials() {
        allMatCatalog = false; Sample_Material__c sm; SampleMaterial m;
        Integer n = materials.size() + 1;
        for (SampleMaterialCatalog mc : matCatalog) {
            if (mc.selected) {
                sm = getNewMaterial(); sm.Name = mc.matName;
                sm.Sample_UOM__c = mc.matUom; sm.Sample_Material_Catalog__c = mc.catId;
                sm.SAP_Material_MSD2__c = mc.msdId;
                if (renderLabContactInput) {
                    sm.Ship_From_Location__c = Sample_Request_Config.SFL_OTHER;
                }
                m = new SampleMaterial(sm, n++); m.matId = mc.matId; m.matStat = mc.matStat;
                materials.add(m); selectedMatIds.add(m.matId);
                mc.selected = false;
            }
            setStyleClass(mc);
        }
    }

    public void returnFromMatCatalog() {
        String sampleCenter = sampleRequest.Sample_Center__c;
        renderMatCatalogPB = false;
        validationErrorMessage = '';
        renderSampleCenterInput = materials.isEmpty();
        renderSmallPackSale = sampleRequest.Small_Package_Sale__c;
        renderSpecSizeBtn = isASI && SAMPLE_CENTERS_CMC.contains(sampleCenter) &&
                            !materials.isEmpty();
        setNochargeOrder(); sortMaterials();
    }

    public String matNotes {get; set;}

    public void copyNotesToMats() {
        for (SampleMaterial m : materials) {m.sm.Notes__c = matNotes;}
    }
	@testVisible
    private Sample_Material__c getNewMaterial() {
        Sample_Material__c sm = new sample_material__c();
        sm.Additional_Admin_Cost__c = Additional_Cost_per_Line_Item;
        sm.Notes__c = matNotes;
        if (account != null && !renderPacIndustryInput) {
            sm.PAC_Industry_Segment__c = account.PAC_Industry_Segment__c;
        }
        return sm;
    }

    public void addNewMaterial() {
        if (sampleMaterials == null) {return;}
        renderMatCatalogPB = false;
        if (isOthSampCenter) {
            Integer n = materials.size() + 1;
            Sample_Material__c sm = getNewMaterial();
            sampleMaterials.add(sm);
            SampleMaterial m = new SampleMaterial(sm, n++); m.specialUom = true;
            materials.add(m); sortMaterials();
        } else {
            renderSmallPackSale = false;
            renderMatCatalogPB = true; setMatCatalog();
        }
        renderSampleCenterInput = false; renderNochargeInput = false;
    }

    private String getZeroFilled(String s, Integer n) {
        String r = s.trim(); Integer m = r.length();
        while (m++ < n) {r = '0' + r;}
        return r;
    }

    private void sortMaterials() {
        if (materials.isEmpty()) {return;}
        Map<String, SampleMaterial> amap = new Map<String, SampleMaterial>();
        List<String> slist = new List<String>(); String k; Integer n = 1;
        List<SampleMaterial> tlist = new List<SampleMaterial>();
        for (SampleMaterial m : materials) {
            k = m.sm.name + ' - ' + getZeroFilled(String.valueOf(n++), 4);
            amap.put(k, m); slist.add(k);
        }
        slist.sort(); SampleMaterial m; n = 1;
        for (String s : slist) {
            m = amap.get(s); m.recNum = n++; tlist.add(m);
        }
        materials = tlist;
    }

    public void removeMaterial() {}

    public void clearMaterialGrid() {
        sampleMaterials.clear(); materials.clear();
        renderSampleCenterInput = true;
        //initMaterial();
    }

    public void deleteMaterials() {
        List<SampleMaterial> mlist = new List<SampleMaterial>();
        Set<String> mset = new Set<String>(); Integer n = 1;
        renderSpecialSize = false;
        for (SampleMaterial m : materials) {
            if (!m.selected) {
                m.recNum = n++; mlist.add(m); mset.add(m.matId);
                if (m.sm.Special_Size__c) {renderSpecialSize = true;}
            }
            m.selected = false;
        }
        materials = mlist; selectedMatIds = mset; allMats = false;
        returnFromMatCatalog();
    }

    public void specialSizeMaterials() {
        for (SampleMaterial m : materials) {
            if (m.selected) {
                m.specialUom = true; m.sm.Special_Size__c = true;
                m.selected = false; renderSpecialSize = true;
            }
        }
        allMats = false;
    }

    private List<SampleMaterial> getSelectedMaterials() {
        List<SampleMaterial> slist = new List<SampleMaterial>();
        for (SampleMaterial m : materials) {
            if (m.selected) {slist.add(m);}
        }
        return slist;
    }

    private void initSampleMaterials() {
        validationErrorMessage = ''; String s;
        sampleMaterials = new List<Sample_Material__c>();
        for (SampleMaterial m : materials) {
            //debug('m.qty = ' + m.qty); m.sm.Sample_Quantity__c = m.qty.val;
            s = m.qtyStr; m.sm.Sample_Quantity__c = 0;
            debug('s = ' + s);
            if (!String.isBlank(s)) {
                s = s.replace(' ', ''); s = s.replace(',','.');
                m.sm.Sample_Quantity__c = Decimal.valueOf(s);
            }
            sampleMaterials.add(m.sm);
        }
    }

    public void initSmallPackSale() {
        String sampleCenter = sampleRequest.Sample_Center__c;
        renderLabContactInput = isASI && SAMPLE_CENTERS_LAB.contains(sampleCenter);
        renderShipmntNotify = isASI && !SAMPLE_CENTERS_CMC.contains(sampleCenter);
        renderSmallPackChkbox = isASI && SAMPLE_CENTERS_SPS.contains(sampleCenter);
        if (!renderSmallPackChkbox) {sampleRequest.Small_Package_Sale__c = false;}
        renderSmallPackSale = renderSmallPackChkbox && sampleRequest.Small_Package_Sale__c;
        if (renderSmallPackSale) {
            readonlyInvoiceAddress = true;
            initInvoiceAddress(); return;
        }
        sampleRequest.Invoice_Salutation__c = '';
        sampleRequest.Invoice_FirstName__c  = '';
        sampleRequest.Invoice_LastName__c   = '';
        sampleRequest.Invoice_Phone__c      = '';

        sampleRequest.Invoice_Company__c    = '';
        sampleRequest.Invoice_Address1__c   = '';
        sampleRequest.Invoice_Address2__c   = '';
        sampleRequest.Invoice_Address3__c   = '';

        sampleRequest.Invoice_City__c       = '';
        sampleRequest.Invoice_State__c      = '';
        sampleRequest.Invoice_PostalCode__c = '';
        sampleRequest.Invoice_Country__c    = '';
        if (materials == null) {return;}
        for(SampleMaterial m : materials) {
            if (!sampleRequest.Small_Package_Sale__c) {m.sm.Small_Pack_Cost__c = 0;}
        }
        calculateTotalCost();
    }

    public void initInvoiceAddress() {
        if (!readonlyInvoiceAddress) {return;}
        sampleRequest.Invoice_Salutation__c = sampleRequest.Contact_Salutation__c;
        sampleRequest.Invoice_FirstName__c  = sampleRequest.Contact_First_Name__c;
        sampleRequest.Invoice_LastName__c   = sampleRequest.Contact_Last_Name__c;
        sampleRequest.Invoice_Phone__c      = sampleRequest.Contact_Phone_Number__c;

        sampleRequest.Invoice_Company__c    = getAccName();
        sampleRequest.Invoice_Address1__c   = sampleRequest.Address_Line_1__c;
        sampleRequest.Invoice_Address2__c   = sampleRequest.Address_Line_2__c;
        sampleRequest.Invoice_Address3__c   = sampleRequest.Address_Line_3__c;

        sampleRequest.Invoice_City__c       = sampleRequest.City__c;
        sampleRequest.Invoice_State__c      = sampleRequest.State__c;
        sampleRequest.Invoice_PostalCode__c = sampleRequest.Postal_Zip_Code__c;
        sampleRequest.Invoice_Country__c    = sampleRequest.Country__c;
    }

    public Boolean cancelMaterials_init   {get; private set;}
    public Boolean cancelMaterials_review {get; private set;}

    public void cancelMaterials_init() {
        cancelMaterials_init = true; cancelMaterials_review = false;
    }

    public PageReference cancelMaterials_goback() {
        initMaterials(); cancelMaterials_init(); return null;
    }

    public void cancelMaterials_review() {
        List<SampleMaterial> slist = getSelectedMaterials();
        if (slist.isEmpty()) {return;}
        materials = slist;
        cancelMaterials_init = false; cancelMaterials_review = true;
    }

    public PageReference cancelMaterials() {
        PageReference pr = null;
        List<SampleMaterial> slist = getSelectedMaterials();
        if (slist.isEmpty()) {return cancelMaterials_goback();}
        List<Sample_Material__c> smlist = new List<Sample_Material__c>();
        Set<String> aset = new Set<String>{
            Sample_Material_Functions.STAT_CANCELLED,
            Sample_Material_Functions.STAT_CMC_SHIPD,
            Sample_Material_Functions.STAT_SHIPPED
        };
        for (SampleMaterial m : slist) {
            if (!aset.contains(m.sm.Record_Status__c)) {
                m.sm.Record_Status__c = Sample_Request_Config.CANCELLED;
                smlist.add(m.sm);
            }
        }
        try {update smlist; pr = cancel();}
        catch(Exception e) {addErrMsg(e.getMessage());}
        return pr;
    }
}
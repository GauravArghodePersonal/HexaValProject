public class PricingSurcharge_Controller {

    public static final String DELIM = '-';
    public static final String PARAM_ACCOUNT_ID   = 'a';
    public static final String PARAM_PLANT_ID     = 'p';
    public static final String PARAM_SURCHARGE_ID = 's';
    public static final String PARAM_SRCHRGBRK_ID = 'b';

    public static final String DC_ASI = '50';

    public static final ApexPages.Severity INFO  = ApexPages.Severity.INFO;

    public Integer  rowNum1 {get; set;}

    public String accNumber {get; set;}
    public String salesOrg  {get; set;}
    public String distChan  {get; set;}
    public String divsnCode {get; set;}
    public String plantCode {get; set;}
    public String uomCode   {get; set;}

    public Boolean                 renderFindBtn {get; private set;}
    public Boolean               renderCancelBtn {get; private set;}
    public Boolean                 renderSaveBtn {get; private set;}

    public Account                           acc {get; private set;}
    public SAP_Plant__c                    plant {get; private set;}
    public SAP_UOM_Description__c        uomDesc {get; private set;}

    public Pricing_Surcharge__c        surcharge {get; private set;}
    public Pricing_Surcharge_Break__c  srchrgbrk {get; private set;}
    public List<Pricing_Surcharge_Break__c> psbs {get; private set;}

    public List<SelectOption>       salesOrgOpts {get; private set;}
    public List<SelectOption>       distChanOpts {get; private set;}
    public List<SelectOption>       dvsnCodeOpts {get; private set;}
    public List<SelectOption>       plntCodeOpts {get; private set;}
    public List<SelectOption>       currencyOpts {get; private set;}
    public List<SelectOption>       suomCodeOpts {get; private set;}

    public String                        accName {get; private set;}
    public String                      plantName {get; private set;}

    public Boolean                renderPageMsgs {get {return ApexPages.hasMessages();} private set;}

    public class Scale {
        public Integer                    rowNum {get; set;}
        public Pricing_Surcharge_Break__c    psb {get; set;}

        public Scale(Pricing_Surcharge_Break__c b, Integer n) {psb = b; rowNum = n;}
    }
    public List<Scale>                    scales {get; private set;}

    private List<Pricing_Surcharge_Break__c> dlist;

    private Set<Id> dset;

    private Map<String, String> params;

    private String accKey, accId, plantId, surchargeId, srchrgbrkId;

    private Boolean allowedToSave;

    public PricingSurcharge_Controller() {init1();}

    private void debug(String s) {System.debug(LoggingLevel.INFO, s);}

    private void addMsg(String s) {
        ApexPages.Message msg = new ApexPages.Message(INFO, s);
        ApexPages.addMessage(msg);
    }

    private void addMsg(String s, Exception e) {addMsg(s + ' : ' + e.getMessage());}

    private String getZeroPaddedString(String s, Integer n) {
        if (s == null) {s = '';}
        return s.trim().leftpad(n).replace(' ','0').right(n);
    }

    private void init1() {
        debug('init1'); params = ApexPages.currentPage().getParameters();
        accId       = params.get(PARAM_ACCOUNT_ID);   debug('accId       : ' + accId      );
        plantId     = params.get(PARAM_PLANT_ID);     debug('plantId     : ' + plantId    );
        surchargeId = params.get(PARAM_SURCHARGE_ID); debug('surchargeId : ' + surchargeId);
        srchrgbrkId = params.get(PARAM_SRCHRGBRK_ID); debug('srchrgbrkId : ' + srchrgbrkId);
        allowedToSave = Pricing_Security__c.getInstance().Allowed_to_Create_Surcharges__c;
        initSurcharge(); accName = ''; plantName = ''; accNumber = '0000490172';
        salesOrg = '1021'; plantCode = '1096'; uomCode = 'KG';
        distChan = DC_ASI; divsnCode = DC_ASI; init2(); initSOpts();
        if (!String.isBlank(accId))       {setAccount();  } else
        if (!String.isBlank(srchrgbrkId)) {setSrchrgbrk();} else
        if (!String.isBlank(surchargeId)) {setSurcharge();}
        if (acc != null) {plantCode = acc.SAP_ShippingPlant__c;}
        if (!String.isBlank(accNumber) && !String.isBlank(plantCode)) {find1();}
    }

    private void init2() {
        renderFindBtn = true; renderCancelBtn = false; renderSaveBtn = false;
        psbs = new List<Pricing_Surcharge_Break__c>(); scales = new List<Scale>();
    }

    private void initSOpts() {
        salesOrgOpts = new List<SelectOption>();
        String s; Set<String> aset = new Set<String>();
        for (SAP_Sales_Org__c sorg : [select Sales_Org_Code__c
                from SAP_Sales_Org__c where Deleted__c = false
            order by Sales_Org_Code__c]) {s = sorg.Sales_Org_Code__c;
            if (s < '0001' || s > '9999') {continue;}
            if (!aset.contains(s)) {aset.add(s);
                salesOrgOpts.add(new SelectOption(s, s));
            }
        }

        plntCodeOpts = new List<SelectOption>(); aset = new Set<String>();
        for (SAP_Plant__c plnt : [select Plant_Code__c, Plant_Name__c
                from SAP_Plant__c where Deleted__c = false
            order by Plant_Code__c]) {s = plnt.Plant_Code__c;
            if (s.endsWith('G2') || s.startsWith('Y') ||
                s < '0001' || s > '9999' ||
                plnt.Plant_Name__c == null ||
                plnt.Plant_Name__c.contains('DO NOT USE')) {continue;}
            if (!aset.contains(s)) {aset.add(s);
                plntCodeOpts.add(new SelectOption(s, s));
            }
        }

        currencyOpts = CurrencyFunctions.getCurrencyCodes();

        distChanOpts = new List<SelectOption>();
        distChanOpts.add(new SelectOption(DC_ASI, DC_ASI));

        dvsnCodeOpts = new List<SelectOption>();
        dvsnCodeOpts.add(new SelectOption(DC_ASI, DC_ASI));

        suomCodeOpts = new List<SelectOption>();
        suomCodeOpts.add(new SelectOption('KG', 'KG'));
        suomCodeOpts.add(new SelectOption('LB', 'LB'));
    }

    @TestVisible
    private void initSurcharge() {
        surcharge = new Pricing_Surcharge__c(); srchrgbrk = new Pricing_Surcharge_Break__c();
        surcharge.Begin_Date__c = Date.today(); surcharge.CurrencyIsoCode = 'USD';
    }

    public PageReference initAction() {
        debug('initAction'); return null;
    }

    private void setAccount() {
        acc = new Account(); accName = '';
        String q1 = 'select Id, Name, AccountNumber, Account_Number__c,'
                  + ' SAP_Sales_Org__c, SAP_DistChannel__c, SAP_DivisionCode__c,'
                  + ' SAP_ShippingPlant__c from Account where ';
        String q2 = ' and Inactive_Account__c = false limit 1';
        String q  = q1;
        if (String.isBlank(accId)) {q += 'Account_Number__c = :accKey';} else {
            q += 'Id = :accId' ;} q += q2;
        List<Account> alist = Database.query(q);
        if (alist.isEmpty()) {addMsg('SoldTo not found or it is Inactive');} else {
            acc = alist[0]; accName = acc.Name; accKey = acc.Account_Number__c;
            accNumber = acc.AccountNumber; salesOrg = acc.SAP_Sales_Org__c;
            distChan = acc.SAP_DistChannel__c; divsnCode = acc.SAP_DivisionCode__c;
        }
    }

    private void setPlant() {
        plant = new SAP_Plant__c(); plantName = '';
        List<SAP_Plant__c> alist = [select Id, Plant_Code__c, Plant_Name__c
            from SAP_Plant__c where Plant_Code__c = :plantCode limit 1];
        if (!alist.isEmpty()) {plant = alist[0]; plantName = plant.Plant_Name__c;}
        else {addMsg('Plant not found');}
    }

    private void setUomDesc() {
        uomDesc = SAP_Queries_Functions.getSapUomDesc(uomCode);
        if (uomDesc == null) {addMsg('UOM not found'); uomDesc = new SAP_UOM_Description__c();}
    }

    private String getSurchargeKey() {return getSurchargeKey(accKey, plantCode);}

    public String getSurchargeKey(String accKey, String plantCode) {
        return (accKey + DELIM + plantCode);
    }

    private String getSrchrgBrkKey(Decimal scaleQty) {
        return getSrchrgBrkKey(surcharge, scaleQty);
    }

    public String getSrchrgBrkKey(Pricing_Surcharge__c ps, Decimal scaleQty) {
        String s = String.valueOf(scaleQty.intValue());
        return (ps.Record_Key__c + DELIM + s);
    }

    @TestVisible
    private void setSurcharge() {
        try {surcharge = [select Id, Name
                            from Pricing_Surcharge__c where Id = :surchargeId];
        } catch(Exception e) {return;}
    }

    private void setSrchrgbrk() {
        try {srchrgbrk = [select Id, Name, Pricing_Surcharge__c
                            from Pricing_Surcharge_Break__c where Id = :srchrgbrkId];
        } catch(Exception e) {return;}
        surchargeId = srchrgbrk.Pricing_Surcharge__c; setSurcharge();
    }

    private void findSurcharge() {
        psbs = new List<Pricing_Surcharge_Break__c>();
        dlist = new List<Pricing_Surcharge_Break__c>(); dset = new Set<Id>();
        List<Pricing_Surcharge__c> alist = [
            select Id, Name, CurrencyIsoCode, Account__c, Begin_Date__c, End_Date__c,
                   Price_UOM__c, Record_Key__c, SAP_Plant__c, Scale_UOM__c,
                  (select Id, Name, CurrencyIsoCode, Amount__c, Per__c,
                          Pricing_Surcharge__c, Record_Key__c, Scale_Qty__c
                     from Pricing_Surcharge_Breaks__r order by Scale_Qty__c)
              from Pricing_Surcharge__c
             where Account__c = :acc.Id and SAP_Plant__c = :plant.Id limit 1];
        if (alist.isEmpty()) {
            init2(); addMsg('No Surcharges found for the following SoldTo and Plant');
        } else {
            surcharge = alist[0]; psbs = surcharge.Pricing_Surcharge_Breaks__r;
        }
        setScales();
    }

    private void setScales() {
        Integer n = 1; scales = new List<Scale>();
        for (Pricing_Surcharge_Break__c b : psbs) {scales.add(new Scale(b, n++));}
    }

    private void setScaleRowNums() {
        Integer n = 1; for (Scale s : scales) {s.rowNum = n++;}
    }

    @TestVisible
    private void setSurchargeFields() {
        surcharge.Account__c    = acc.Id;
        surcharge.End_Date__c   = Date.newInstance(2099, 12, 31);
        surcharge.Price_UOM__c  = uomDesc.Id;
        surcharge.Record_Key__c = getSurchargeKey();
        surcharge.SAP_Plant__c  = plant.Id;
        surcharge.Scale_UOM__c  = uomDesc.Id;
        debug('setSurchargeFields : ' + surcharge);
    }

    private void setPSBFields(Pricing_Surcharge_Break__c psb) {
        psb.CurrencyIsoCode      = surcharge.CurrencyIsoCode;
        psb.Pricing_Surcharge__c = surcharge.Id;
        psb.Per__c               = 1;
        psb.Record_Key__c        = getSrchrgBrkKey(psb.Scale_Qty__c);
        if (psb.Amount__c == null) {psb.Amount__c = 0;}
        debug('setPSBFields : ' + psb);
    }

    private Boolean validate1() {
        accNumber = getZeroPaddedString(accNumber, 10);
        accKey = accNumber + salesOrg + distChan + divsnCode;
        setAccount(); if (acc.Id     == null) {return false;}
        setPlant();   if (plant.Id   == null) {return false;}
        setUomDesc(); if (uomDesc.Id == null) {return false;}
        return true;
    }

    public void find1() {
        if (!validate1()) {return;} findSurcharge(); if (!allowedToSave) {return;}
        renderFindBtn = false; renderCancelBtn = true; renderSaveBtn = true;
    }

    public void cancel1() {init2();}

    public void add1() {
        Pricing_Surcharge_Break__c b; Integer r;
        for (Integer n = 0; n < 1; n++) {
            b = new Pricing_Surcharge_Break__c(); r = scales.size() + 1;
            scales.add(new Scale(b, r));
        }
    }

    public void del1() {
        Scale s = scales.remove(rowNum1-1); setScaleRowNums();
        if (s.psb.Id != null && !dset.contains(s.psb.Id)) {
            dlist.add(s.psb); dset.add(s.psb.Id);
        }
    }

    @TestVisible
    private Boolean insert1(List<Pricing_Surcharge_Break__c> alist) {
        if (alist == null || alist.isEmpty()) {return true;}
        if (surcharge.Id == null) {
            setSurchargeFields();
            try {insert surcharge;} catch(Exception e) {
                addMsg('Failed to insert Surcharge', e); return false;
            }
        }
        for (Pricing_Surcharge_Break__c psb : alist) {setPSBFields(psb);}
        try {insert alist;} catch(Exception e) {
            addMsg('Failed to insert Scales', e); return false;
        }
        return true;
    }

    private Boolean update1(List<Pricing_Surcharge_Break__c> alist) {
        try {update surcharge;} catch(Exception e) {
            addMsg('Failed to update Surcharge', e); return false;
        }
        if (alist == null || alist.isEmpty()) {return true;}
        for (Pricing_Surcharge_Break__c a : alist) {
            if (a.Amount__c == null) {a.Amount__c = 0;}
        }
        try {update alist;} catch(Exception e) {
            addMsg('Failed to update Scales', e); return false;
        }
        return true;
    }

    @TestVisible
    private Boolean delete1(List<Pricing_Surcharge_Break__c> alist) {
        if (alist == null || alist.isEmpty()) {return true;}
        try {delete alist;} catch(Exception e) {
            addMsg('Failed to delete Scales', e); return false;
        }
        return true;
    }

    public void save1() {
        Pricing_Surcharge_Break__c psb;
        List<Pricing_Surcharge_Break__c> ilist = new List<Pricing_Surcharge_Break__c>(),
                                         ulist = new List<Pricing_Surcharge_Break__c>();
        for (Scale s : scales) {
            psb = s.psb; if (psb.Scale_Qty__c == null) {continue;}
            if (psb.Id == null) {ilist.add(psb);} else {ulist.add(psb);}
        }
        if (!insert1(ilist)) {return;}
        if (!update1(ulist)) {return;}
        if (!delete1(dlist)) {return;}
        findSurcharge(); addMsg('Save Successful');
        renderFindBtn = true; renderCancelBtn = false; renderSaveBtn = false;
    }

}
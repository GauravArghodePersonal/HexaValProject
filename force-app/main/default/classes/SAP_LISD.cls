public class SAP_LISD {

    private static final String FS1 = SAP_LISD_Functions.DELIM;

    public SAP_Line_Item_Sales_Detail__c lisd {get; set;}
    public SAP_LISD_Settings__c settings      {get; set;}
    public Account acc                        {get; set;}
    public User seller                        {get; set;}
    public String salesArea                   {get; set;}
    public Boolean isInactiveAcc              {get; set;}
    public Boolean isMultiIndustyAcc          {get; set;}
    public Boolean readOnlyInputs             {get; set;}

    public Boolean readOnlyAC                 {get; set;}
    public Boolean readOnlyL1                 {get; set;}
    public Boolean readOnlyEC                 {get; set;}
    public Boolean readOnlySD                 {get; set;}
    public Boolean readOnlySO                 {get; set;}
    public Boolean readOnlySG                 {get; set;}
    public Boolean readOnlyCG                 {get; set;}
    public Boolean readOnlyL2                 {get; set;}
    public Boolean readOnlySL                 {get; set;}

    public SelectOption industry              {get; set;}
    public SelectOption endUseCust            {get; set;}
    public SelectOption salesDst              {get; set;}
    public SelectOption salesOfc              {get; set;}
    public SelectOption salesGrp              {get; set;}
    public SelectOption custGroup             {get; set;}
    public SelectOption pacIndustry           {get; set;}
    public SelectOption sellerOpt             {get; set;}

    public List<SelectOption> industries      {get; set;}
    public List<SelectOption> endUseCusts     {get; set;}
    public List<SelectOption> salesDsts       {get; set;}
    public List<SelectOption> salesOfcs       {get; set;}
    public List<SelectOption> salesGrps       {get; set;}
    public List<SelectOption> custGroups      {get; set;}
    public List<SelectOption> pacIndustries   {get; set;}
    public List<SelectOption> sellerOpts      {get; set;}

    public String industryValue               {get; set;}
    public String endUseCustValue             {get; set;}
    public String endUseCustId                {get; set;}
    public String salesDstValue               {get; set;}
    public String salesOfcValue               {get; set;}
    public String salesGrpValue               {get; set;}
    public String custGroupValue              {get; set;}
    public String pacIndustryValue            {get; set;}
    public String sellerValue                 {get; set;}

    public String helpText_cg {get {return settings.Customer_Group_Help__c;}}
    public String helpText_sd {get {return settings.Sales_District_Help__c;}}
    public String helpText_so {get {return settings.Sales_Office_Help__c;}}
    public String helpText_sg {get {return settings.Sales_Group_Help__c;}}

    public Map<String, Id> lisdMap            {get; set;}

    public SAP_LISD() {this(new SAP_Line_Item_Sales_Detail__c());}

    public SAP_LISD(SAP_Line_Item_Sales_Detail__c o) {lisd = o; init1();}

    public SAP_LISD(Account a) {acc = a; copyDataFrom(a);}

    private void debug(String s) {System.debug(LoggingLevel.INFO, '>>>>>>>>> SAP_LISD : ' + s);}

    private Boolean isNull(String s) {return String.isBlank(s);}

    public void init1() {
        acc = null; isInactiveAcc = false; isMultiIndustyAcc = true; readOnlyAC = true;
        lisdMap = new Map<String, Id>(); initL1(); init2();
        settings = SAP_LISD_Functions.getLisdSettings(acc);
    }

    private void initL1() {industryValue    = null; industries    = null; readOnlyL1 = true; initEC(); initL2();}
    private void initEC() {endUseCustValue  = null; endUseCusts   = null; readOnlyEC = true; initSD();}
    private void initSD() {salesDstValue    = null; salesDsts     = null; readOnlySD = true; initSO();}
    private void initSO() {salesOfcValue    = null; salesOfcs     = null; readOnlySO = true; initSG();}
    private void initSG() {salesGrpValue    = null; salesGrps     = null; readOnlySG = true; initCG();}
    private void initCG() {custGroupValue   = null; custGroups    = null; readOnlyCG = true; initSL();}
    private void initSL() {sellerValue      = null; sellerOpts    = null; readOnlySL = true; seller = new User();}
    private void initL2() {pacIndustryValue = null; pacIndustries = null; readOnlyL2 = true;}

    public void init2() {
        readOnlyInputs = (readOnlyAC && readOnlyL1 && readOnlyEC && readOnlySD &&
                          readOnlySO && readOnlySG && readOnlyCG && readOnlySL && seller.Id != null);
    }

    private void setIndustryValue(String s) {
        industryValue = s; setIndustry();
    }

    private void setIndustry() {
        industry = SAP_LISD_Functions.getSelectOption(industries, industryValue);
        setPacIndustries();
    }

    public void setPacIndustries() {
        pacIndustries = SAP_LISD_Functions.getL2Segments(acc.SAP_DistChannel__c, industryValue);
        if (pacIndustries != null && pacIndustries.size() >= 1) {
            pacIndustry = pacIndustries[0]; pacIndustryValue = pacIndustry.getValue();
            if (pacIndustries.size() > 1) {readOnlyL2 = false;}
        }
    }

    public void setPacIndustry(String s) {
        pacIndustryValue = s;
        pacIndustry = SAP_LISD_Functions.getSelectOption(pacIndustries, pacIndustryValue);
    }

    private void setEndUseCustId(String s) {
        endUseCustValue = SAP_LISD_Functions.getAccountNumber(s); setEndUseCust();
    }

    private void setEndUseCust() {
        endUseCust  = SAP_LISD_Functions.getSelectOption(endUseCusts,  endUseCustValue);
        endUseCustId = null; Account a = SAP_LISD_Functions.getEndUseCust(endUseCustValue);
        if (a != null) {endUseCustId = a.Id;}
    }

    private void setSalesDstValue(String s) {
        salesDstValue = s; setSalesDst();
    }

    private void setSalesDst() {
        salesDst  = SAP_LISD_Functions.getSelectOption(salesDsts,  salesDstValue);
    }

    private void setSalesOfcValue(String s) {
        salesOfcValue = s; setSalesOfc();
    }

    private void setSalesOfc() {
        salesOfc  = SAP_LISD_Functions.getSelectOption(salesOfcs,  salesOfcValue);
    }

    private void setSalesGrpValue(String s) {
        salesGrpValue = s; setSalesGrp();
    }

    private void setSalesGrp() {
        salesGrp  = SAP_LISD_Functions.getSelectOption(salesGrps,  salesGrpValue);
    }

    private void setCustGroupValue(String s) {
        custGroupValue = s; setCustGroup();
    }

    private void setCustGroup() {
        custGroup  = SAP_LISD_Functions.getSelectOption(custGroups,  custGroupValue);
    }

    private void setSellerValue(String s) {
        sellerValue = s; setSellerOpt();
    }

    private void setSellerOpt() {
        sellerOpt  = SAP_LISD_Functions.getSelectOption(sellerOpts,  sellerValue);
    }

    private String getStr1(String s) {return s == null ? '' : s;}
    private String getStr2(String s) {return s == null ? '' : FS1 + s;}

    private void setAcc(Id accountId) {
        acc = SAP_LISD_Functions.getAccount(accountId);
        isInactiveAcc = (acc.Inactive_Account__c != null && acc.Inactive_Account__c);
        isMultiIndustyAcc = SAP_LISD_Functions.isMultiLevelIndustryAccount(acc);
        settings = SAP_LISD_Functions.getLisdSettings(acc);
        salesArea = getStr1(acc.SAP_Sales_Org__c) +
                    getStr2(acc.SAP_DistChannel__c) +
                    getStr2(acc.SAP_DivisionCode__c);
    }

    public void setIndustries(Id accountId) {setIndustries(accountId, true);}

    public void setIndustries(Id accountId, Boolean b) {
        debug('setIndustries begins');
        initL1(); readOnlyAC = b;
        if (accountId == null) {readOnlyAC = false; return;}
        setAcc(accountId); lisdMap = SAP_LISD_Functions.getLisdMap(acc);
        industries =  SAP_LISD_Functions.getL1Segments(lisdMap, acc);
        if (industries == null || industries.isEmpty()) {return;}
        if (industries.size() > 1) {readOnlyL1 = false;}
        //industry = industries[0];
        industry = SAP_LISD_Functions.getSellerIndustry(lisdMap, industries);
        if (industry != null) {
            industryValue = industry.getValue(); setPacIndustries();
            //if (industries.size() == 1) {setEndUseCusts();} else {readOnlyL1 = false;}
            setEndUseCusts();
        }
    }

    public void setEndUseCusts() {
        initEC(); setIndustry();
        endUseCusts =  SAP_LISD_Functions.getEndUseCusts(lisdMap, industryValue);
        if (endUseCusts != null && endUseCusts.size() >= 1) {
            endUseCust = endUseCusts[0]; endUseCustValue = endUseCust.getValue();
            if (endUseCusts.size() == 1) {setSalesDsts();} else {readOnlyEC = false;}
        }
    }

    public void setSalesDsts() {
        initSD(); setEndUseCust();
        salesDsts =  SAP_LISD_Functions.getSalesDistricts(lisdMap, acc, industryValue,
                     endUseCustValue);
        if (salesDsts != null && salesDsts.size() >= 1) {
            salesDst = salesDsts[0]; salesDstValue = salesDst.getValue();
            if (salesDsts.size() == 1) {setSalesOfcs();} else {readOnlySD = false;}
        }
    }

    public void setSalesOfcs() {
        initSO(); setSalesDst();
        salesOfcs =  SAP_LISD_Functions.getSalesOffices(lisdMap, acc, industryValue,
                     endUseCustValue, salesDstValue);
        if (salesOfcs != null && salesOfcs.size() >= 1) {
            salesOfc = salesOfcs[0]; salesOfcValue = salesOfc.getValue();
            if (salesOfcs.size() == 1) {setSalesGrps();} else {readOnlySO = false;}
        }
    }

    public void setSalesGrps() {
        initSG(); setSalesOfc();
        salesGrps =  SAP_LISD_Functions.getSalesGroups(lisdMap, acc, industryValue,
                     endUseCustValue, salesDstValue, salesOfcValue);
        if (salesGrps != null && salesGrps.size() >= 1) {
            salesGrp = salesGrps[0]; salesGrpValue = salesGrp.getValue();
            if (salesGrps.size() == 1) {setcustGroups();} else {readOnlySG = false;}
        }
    }

    public void setCustGroups() {
        initCG(); setSalesGrp();
        custGroups =  SAP_LISD_Functions.getCustomerGroups(lisdMap, acc, industryValue,
                      endUseCustValue, salesDstValue, salesOfcValue, salesGrpValue);
        if (custGroups != null && custGroups.size() >= 1) {
            custGroup = custGroups[0]; custGroupValue = custGroup.getValue();
            //if (custGroups.size() == 1) {setSeller();} else {readOnlyCG = false;}
            if (custGroups.size() == 1) {setSellerOpts();} else {readOnlyCG = false;}
        }
    }

    public void setSellerOpts() {
        initSL(); setCustGroup();
        SAP_LISD_Functions.SelectOpts sopts = SAP_LISD_Functions.getSellerOpts(
            lisdMap, acc, industryValue, endUseCustValue, salesDstValue,
            salesOfcValue, salesGrpValue, custGroupValue);
        sellerOpts = sopts.sos;

        if (sellerOpts != null && sellerOpts.size() >= 1) {
            readOnlySL = sellerOpts.size() == 1; sellerOpt = sopts.so;
            if (sellerOpt != null) {sellerValue = sellerOpt.getValue();}
            setSeller();
        }
    }

    public void setSeller() {
        if (acc == null || custGroupValue == null) {return;}
        if (!isNull(sellerValue)) {setSellerOpt();}
        seller = SAP_LISD_Functions.getSeller(acc, sellerValue);
        init2();
    }
/*
    public void setSeller() {
        if (acc == null || salesGrpValue == null) {return;} setCustGroup();
        List<SAP_LISD> sapLisds = SAP_LISD_Functions.getAccountLisds(acc.Id);
        seller = SAP_LISD_Functions.getSeller(sapLisds, acc, industryValue,
                 endUseCustValue, salesDstValue, salesOfcValue, salesGrpValue,
                 custGroupValue);
        init2();
    }
*/
    public String getAccountName() {
        return acc == null ? '' : acc.Name;
    }

    public String getAccountNum() {
        return acc == null ? '' : String_Functions.removeLeadingZeros(acc.AccountNumber);
    }

    public String getSellerName() {
        return seller == null ? '' : seller.Name;
    }

    public String getIndustryLabel() {
        return industry == null ? '' : industry.getLabel();
    }

    public String getPacIndustryLabel() {
        return pacIndustry == null ? '' : pacIndustry.getLabel();
    }

    public String getEndUseCustLabel() {
        return endUseCust == null ? '' : endUseCust.getLabel();
    }

    public String getCustGroupLabel() {
        return custGroup == null ? '' : custGroup.getLabel();
    }

    public String getSalesDstLabel() {
        return salesDst == null ? '' : salesDst.getLabel();
    }

    public String getSalesOfcLabel() {
        return salesOfc == null ? '' : salesOfc.getLabel();
    }

    public String getSalesGrpLabel() {
        return salesGrp == null ? '' : salesGrp.getLabel();
    }

    public String getSellerLabel() {
        return sellerOpt == null ? '' : sellerOpt.getLabel();
    }

    /* -------------------------- Account ----------------------- */

    private void copyDataFrom(Account a) {
        salesDstValue  = a.SAP_SalesDistrict__c;
        salesOfcValue  = a.SAP_Sales_Office__c;
        salesGrpValue  = a.SAP_SalesGroup__c;
        custGroupValue = a.SAP_Customer_Group__c;
    }

    /* -------------------------- Case ----------------------- */

    public void copyDataFrom(Case r) {copyDataFrom(r, false);}
    public void setDataLists(Case r) {copyDataFrom(r, true);}

    private void copyDataFrom(Case r, Boolean b) {
        setIndustryValue(r.Industry__c);        if(b) {setEndUseCusts();}
        setEndUseCustId(r.EndUse_Customer__c);  if(b) {setSalesDsts();}
        setSalesDstValue(r.Sales_District__c);  if(b) {setSalesOfcs();}
        setSalesOfcValue(r.Sales_Office__c);    if(b) {setSalesGrps();}
        setSalesGrpValue(r.Sales_Group__c);     if(b) {setCustGroups();}
        setCustGroupValue(r.Customer_Group__c); if(b) {setSeller();}
    }

    public void copyDataTo(Case r) {
        r.AccountId               = acc.Id;

        r.Industry__c             = industryValue;
        r.Industry_Desc__c        = getIndustryLabel();

        r.EndUse_Customer__c      = endUseCustId;
        r.EndUse_Customer_Desc__c = getEndUseCustLabel();

        r.Sales_District__c       = salesDstValue;
        r.Sales_District_Desc__c  = getSalesDstLabel();

        r.Sales_Office__c         = salesOfcValue;
        r.Sales_Office_Desc__c    = getSalesOfcLabel();

        r.Sales_Group__c          = salesGrpValue;
        r.Sales_Group_Desc__c     = getSalesGrpLabel();

        r.Customer_Group__c       = custGroupValue;
        r.Customer_Group_Desc__c  = getCustGroupLabel();

        r.Seller__c               = seller.Id;
    }

    /* -------------------------- Opportunity ----------------------- */

    public void copyDataFrom(Opportunity r) {copyDataFrom(r, false);}
    public void setDataLists(Opportunity r) {copyDataFrom(r, true);}

    private void copyDataFrom(Opportunity r, Boolean b) {
        setIndustryValue(r.Industry__c);        if(b) {setEndUseCusts();}
        setEndUseCustId(r.Account_End_Customer__c);  if(b) {setSalesDsts();}
        setSalesDstValue(r.Sales_District__c);  if(b) {setSalesOfcs();}
        setSalesOfcValue(r.Sales_Office__c);    if(b) {setSalesGrps();}
        setSalesGrpValue(r.Sales_Group__c);     if(b) {setCustGroups();}
        setCustGroupValue(r.Customer_Group__c); if(b) {setSeller();}
        setPacIndustry(r.PAC_Industry_Code__c);
    }

    public void copyDataTo(Opportunity r) {
        r.AccountId               = acc.Id;

        r.Industry__c             = industryValue;
        r.Industry_Desc__c        = getIndustryLabel();

        r.Account_End_Customer__c = endUseCustId;
        r.EndUse_Customer_Desc__c = getEndUseCustLabel();

        r.Sales_District__c       = salesDstValue;
        r.Sales_District_Desc__c  = getSalesDstLabel();

        r.Sales_Office__c         = salesOfcValue;
        r.Sales_Office_Desc__c    = getSalesOfcLabel();

        r.Sales_Group__c          = salesGrpValue;
        r.Sales_Group_Desc__c     = getSalesGrpLabel();

        r.Customer_Group__c       = custGroupValue;
        r.Customer_Group_Desc__c  = getCustGroupLabel();

        r.PAC_Industry_Code__c    = pacIndustryValue;
        setPacIndustry(r.PAC_Industry_Code__c);
        r.PAC_Description__c      = getPacIndustryLabel();

        r.Seller__c               = seller.Id;
    }

    /* -------------------------- Pricing Rebate ----------------------- */

    public void copyDataFrom(Pricing_Rebate__c r) {copyDataFrom(r, false);}
    public void setDataLists(Pricing_Rebate__c r) {copyDataFrom(r, true);}

    private void copyDataFrom(Pricing_Rebate__c r, Boolean b) {
        setIndustryValue(r.Industry__c);        if(b) {setEndUseCusts();}
        setEndUseCustId(r.EndUse_Customer__c);  if(b) {setSalesDsts();}
        setSalesDstValue(r.Sales_District__c);  if(b) {setSalesOfcs();}
        setSalesOfcValue(r.Sales_Office__c);    if(b) {setSalesGrps();}
        setSalesGrpValue(r.Sales_Group__c);     if(b) {setCustGroups();}
        setCustGroupValue(r.Customer_Group__c); if(b) {setSeller();}
    }

    public void copyDataTo(Pricing_Rebate__c r) {
        r.Industry__c             = industryValue;
        r.Industry_Desc__c        = getIndustryLabel();

        r.EndUse_Customer__c      = endUseCustId;
        r.EndUse_Customer_Desc__c = getEndUseCustLabel();

        r.Sales_District__c       = salesDstValue;
        r.Sales_District_Desc__c  = getSalesDstLabel();

        r.Sales_Office__c         = salesOfcValue;
        r.Sales_Office_Desc__c    = getSalesOfcLabel();

        r.Sales_Group__c          = salesGrpValue;
        r.Sales_Group_Desc__c     = getSalesGrpLabel();

        r.Customer_Group__c       = custGroupValue;
        r.Customer_Group_Desc__c  = getCustGroupLabel();

        r.Seller__c               = seller.Id;
    }

    /* -------------------------- Risk ----------------------- */

    public void copyDataFrom(Risk__c r) {copyDataFrom(r, false);}
    public void setDataLists(Risk__c r) {copyDataFrom(r, true);}

    private void copyDataFrom(Risk__c r, Boolean b) {
        setIndustryValue(r.Industry__c);        if(b) {setEndUseCusts();}
        setEndUseCustId(r.EndUse_Customer__c);  if(b) {setSalesDsts();}
        setSalesDstValue(r.Sales_District__c);  if(b) {setSalesOfcs();}
        setSalesOfcValue(r.Sales_Office__c);    if(b) {setSalesGrps();}
        setSalesGrpValue(r.Sales_Group__c);     if(b) {setCustGroups();}
        setCustGroupValue(r.Customer_Group__c); if(b) {setSeller();}
        setPacIndustry(r.PAC_Industry_Code__c);
    }

    public void copyDataTo(Risk__c r) {
        r.Account__c              = acc.Id;

        r.Industry__c             = industryValue;
        r.Industry_Desc__c        = getIndustryLabel();

        r.EndUse_Customer__c      = endUseCustId;
        r.EndUse_Customer_Desc__c = getEndUseCustLabel();

        r.Sales_District__c       = salesDstValue;
        r.Sales_District_Desc__c  = getSalesDstLabel();

        r.Sales_Office__c         = salesOfcValue;
        r.Sales_Office_Desc__c    = getSalesOfcLabel();

        r.Sales_Group__c          = salesGrpValue;
        r.Sales_Group_Desc__c     = getSalesGrpLabel();

        r.Customer_Group__c       = custGroupValue;
        r.Customer_Group_Desc__c  = getCustGroupLabel();

        r.PAC_Industry_Code__c    = pacIndustryValue;
        setPacIndustry(r.PAC_Industry_Code__c);
        r.PAC_Description__c      = getPacIndustryLabel();

        r.Seller__c               = seller.Id;
    }

    /* -------------------------- Sample Request ----------------------- */

    public void copyDataFrom(Sample_Request__c r) {copyDataFrom(r, false);}
    public void setDataLists(Sample_Request__c r) {copyDataFrom(r, true);}

    private void copyDataFrom(Sample_Request__c r, Boolean b) {
        setIndustryValue(r.Industry__c);        if(b) {setEndUseCusts();}
        setEndUseCustId(r.EndUse_Customer__c);  if(b) {setSalesDsts();}
        setSalesDstValue(r.Sales_District__c);  if(b) {setSalesOfcs();}
        setSalesOfcValue(r.Sales_Office__c);    if(b) {setSalesGrps();}
        setSalesGrpValue(r.Sales_Group__c);     if(b) {setCustGroups();}
        setCustGroupValue(r.Customer_Group__c); if(b) {setSeller();}
    }

    public void copyDataTo(Sample_Request__c r) {
        r.Industry__c             = industryValue;
        r.Industry_Desc__c        = getIndustryLabel();

        r.EndUse_Customer__c      = endUseCustId;
        r.EndUse_Customer_Desc__c = getEndUseCustLabel();

        r.Sales_District__c       = salesDstValue;
        r.Sales_District_Desc__c  = getSalesDstLabel();

        r.Sales_Office__c         = salesOfcValue;
        r.Sales_Office_Desc__c    = getSalesOfcLabel();

        r.Sales_Group__c          = salesGrpValue;
        r.Sales_Group_Desc__c     = getSalesGrpLabel();

        r.Customer_Group__c       = custGroupValue;
        r.Customer_Group_Desc__c  = getCustGroupLabel();

        r.Seller__c               = seller.Id;
    }

}
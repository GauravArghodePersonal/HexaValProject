public class IRF_Functions {

    public static final Integer MAX_RECS = 10000;
    public static final Integer IMD_DAYS = 30;

    public static final IRF_Settings__c IRF_SETTINGS = IRF_Settings__c.getOrgDefaults();

    public static final Double KG2LB = Material_UOM_Functions.KG2LB;

    public static final String IRF_STAT_CLOSED   = 'Closed';
    public static final String IRF_STAT_DRAFT    = 'Draft';
    public static final String IRF_STAT_RELEASED = 'Released';

    public static final String IMD_STAT_APPROVED = 'Approved';
    public static final String IMD_STAT_DRAFT    = 'Draft';
    public static final String IMD_STAT_INVOICED = 'Invoiced';
    public static final String IMD_STAT_REJECTED = 'Rejected';
    public static final String IMD_STAT_SUBMITED = 'Submitted';
    
    public static final Set<String> IMD_STATS_1  = new Set<String>{
        IMD_STAT_DRAFT, IMD_STAT_REJECTED, IMD_STAT_SUBMITED
        //,IMD_STAT_APPROVED, IMD_STAT_INVOICED
    };

    public static final Set<String> IMD_STATS_2  = new Set<String>{
        IMD_STAT_APPROVED, IMD_STAT_INVOICED
    };

    // Permission Sets
    public static final String PSET_CONTRACT_TEAM   = 'AWT_IRF_Contract_Team';
    public static final String PSET_COMMERCIAL_TEAM = 'AWT_IRF_Commercial_Team';

    public static final String CHG_TRACKNG_PRICE = 'Price Changed';

    public static final String OPT_VAL_NO  = 'No';
    public static final String OPT_VAL_YES = 'Yes';

    public static final String    LBL_TOTL = 'Total';
    public static final String     SC_TOTL = 'totl';
    public static final String     SC_HILI = 'hili';
    public static final String     SC_HIL2 = 'hil2';
    public static final String     SC_REQD = 'reqd';

    // Contract Types
    public static final String CT_ZCCC_LBL = 'ZCCC - Consumption based Consignment';
    public static final String CT_ZCCC_VAL = 'ZCCC';

    public static final String CT_ZPCC_LBL = 'ZPCC - Production based Consignment';
    public static final String CT_ZPCC_VAL = 'ZPCC';

    public static final String CT_ZTCC_LBL = 'ZTCC - Total Cost Consignment';
    public static final String CT_ZTCC_VAL = 'ZTCC';

    public static final String CT_ZPNC_LBL = 'ZPNC - Production Non Consignment';
    public static final String CT_ZPNC_VAL = 'ZPNC';
    
    public static final String CT_ZTNC_LBL = 'ZTNC - Total Cost Non Consignment'; // added vishnu 2
    public static final String CT_ZTNC_VAL = 'ZTNC'; // added vishnu 2

    public static final String SHIPTO = Account_Partner_Functions.ACC_TYPE_SHIPTO;
    public static final Set<String> SORGS_LB = new Set<String>{'1020'};
    public static final Set<String> UOM_CODES = new Set<String>{'KG', 'LB'};

    public static final String SDT_ZCCF = 'ZCCF';
    public static final String SDT_ZCCR = 'ZCCR';
    public static final String SDT_ZCCP = 'ZCCP';
    public static final Set<String> SDT_SET = new Set<String>{SDT_ZCCF,SDT_ZCCP};
    //public static final Set<String> SDT_SET = new Set<String>{SDT_ZCCF, SDT_ZCCR};

    public static final String MSD_QRY1 = ''
        + 'select Id, Name, Dist_Channel_Code__c, Sales_Org_Code__c, '
        + '       Material_Number__c, Material_Desc__c, Net_Weight__c'
        + '  from Material_Sales_Data2__c';

    public static final String MSD_OB1 = ' order by Name, Dist_Channel_Code__c, Sales_Org_Code__c';

    public static final String IRF_QRY1 = ''
        + 'select Id, Name, Batches_Required__c, Comments__c, Contract_Number__c,Previous_Contract_Number__c, Contract_Type__c,CurrencyIsoCode,'
        + '       Currency_for_Invoicing__c, PO_for_Billing_Period__c, Purchase_Order_Number__c,'
        + '       ShipTo__c, SoldTo__c, Status__c, Units_UOM__c'
        + '  from Invoicing_Report_Form__c';

    public static final String MAT_QRY1 = ''
        + 'select Id, Name, Beginning_Inventory__c, Change_Tracking__c, Customer_Material_Number__c,'
        + '       Discount_Percent__c, Effective_Date__c, Estimated_Quantity__c, Contract_Price__c, Eligible_for_Variance_calculation__c, Related_Unit__c, IRF__c,IRF__r.Contract_Type__c, MFD__c,'
        + '       Material__r.Id, Material__r.Material_Desc__c, Material__r.Material_Number__c, Packages__c,'
        // + '       Parent_Material__r.Id, Parent_Material__r.Material_Description__c, Parent_Material__r.Material_Number__c,'
        + '       Parent_Material_Desc__c, Parent_Material_Number__c,'
        + '       Price__c, Revenue_Allocation__c, Tank_Number__c,'
        + '       Weight_per_Container__c, Weight_per_Volume__c, Marked_for_deletion_Date__c, Flat_Rate__c'
        + '  from IRF_Material__c'; //added by vishnu Contract_Price__c and Related_Unit__c and Eligible_for_Variance_calculation__c

    public static final String MAT_OB1 = ' order by Material__r.Material_Desc__c, Name';
    
    public static final String MAT_OB1_new = ' order by Material__r.Material_Desc__c';
    
    /*public static final String UNT_QRY1 = ''
        + 'select Id, Name, Description__c, Effective_Date__c, IRF__c, MFD__c, Price__c, Marked_for_deletion_Date__c, Discount_Percent__c, Flat_Rate__c'
        + '  from IRF_Unit__c'; */
    
        public static final String UNT_QRY1 = ''
        + 'select Id, Name, Description__c, Effective_Date__c, IRF__c, MFD__c, Price__c, Expected_production__c, Expected_monthly_revenue__c, Marked_for_deletion_Date__c, Discount_Percent__c, Flat_Rate__c'
        + '  from IRF_Unit__c'; //added by vishnu Expected_production__c and Expected_monthly_revenue__c

    public static final String UNT_OB1 = ' order by Description__c, Name';
    
    public static final String UNT_OB1_new = ' order by Description__c';

   public static final String IMD_QRY1 = ''
        + 'select Id, Name, CreatedBy.Name, Current_Month_Production__c, Days_in_Period__c, End_Date__c,'
        + '       Foresee_at_Normal__c, General_Comments__c, IRF__c, IRF__r.Name, IRF__r.ShipTo__c,'
        + '       Invoice_Numbers__c, Operating_Comments__c, Operating_at_Normal__c,'
        + '       Purchase_Order_Number__c, Start_Date__c, Status__c, Production__c,Expected_production__c,'
        + '       Submitted_By__c, Submitted_By__r.Name, Submitted_DateTime__c, Upcoming_Changes__c, Applicable_Month__c, Applicable_Year__c'
        + '  from IRF_Monthly_Data__c'; // added by vishnu Expected_production__c new 4/10 and Production__c
    

    public static final String IMM_QRY1 = ''
        + 'select Id, Name, Adjustment_Inventory__c, Batches__c, Beginning_Inventory__c,'
        + '       Billing_Value__c, Comments__c, Comments_Usage__c, Consumed_Inventory__c, Consumed_per_Day__c,'
        + '       Days_Inventory__c, Discount_Percent__c, Flat_Rate__c, Ending_Inventory__c, Estimated_Quantity__c, Contract_Price__c, Related_Unit__c,Usage_Expected_lbs_ton__c, Dollar_per_month__c,Usage_Variance_lbs_ton__c,Usage_Actual_lbs_ton__c,'
        + '       Inventory_Variance__c, Variance_Inv__c, IRF__c, IRF_Material__c, IRF_Material__r.Beginning_Inventory__c,'
        + '       IRF_Material__r.Discount_Percent__c, IRF_Material__r.Flat_Rate__c, IRF_Material__r.Estimated_Quantity__c, IRF_Material__r.Eligible_for_Variance_calculation__c, IRF_Material__r.Contract_Price__c,'
        + '       IRF_Material__r.Material__c, IRF_Material__r.MFD__c, IRF_Material__r.Related_Unit__c, IRF_Material__r.Price__c,'
        + '       IRF_Material__r.Tank_Number__c, IRF_Monthly_Data__c,'
        + '       IRF_Monthly_Data__r.Days_in_Period__c, IRF_Monthly_Data__r.Status__c, IRF_Monthly_Data__r.Production__c, IRF_Monthly_Data__r.Expected_production__c,'
        + '       Material__c, Material__r.Material_Desc__c, Material__r.Material_Number__c,'
        + '       Other_Charges__c, Price__c, Projected_Monthly_Average__c, Received_Inventory__c, Tank_Number__c,Handle_Marked_for_Deletion__c,MFD__c'
        + '  from IRF_Monthly_Material__c'; // added by vishnu IRF_Material__r.Contract_Price__c and Variance_Inv__c and Contract_Price__c and Dollar_per_month__c and Usage_Actual_lbs_ton__c and Usage_Variance_lbs_ton__c and Usage_Expected_lbs_ton__c 
    										//and IRF_Monthly_Data__r.Expected_production__c and IRF_Material__r.Related_Unit__c and IRF_Material__r.Eligible_for_Variance_calculation__c and Comments_Usage__c

    public static final String IMM_OB1 = ' order by IRF_Material__r.Material__r.Material_Desc__c, Name';
    
    public static final String IMM_OB2 = ' order by Material_Description__c';

   /* public static final String IMU_QRY1 = ''
        + 'select Id, Name, Amount__c, IRF_Monthly_Data__c, IRF_Monthly_Data__r.Status__c, IRF_Unit__c, Discount_Percent__c, Flat_Rate__c, Sub_Total__c,'
        + '       IRF_Unit__r.Description__c, IRF_Unit__r.Price__c, IRF_Unit__r.MFD__c, IRF__c, IRF_Unit__r.Discount_Percent__c, IRF_Unit__r.Flat_Rate__c,'
        + '       Price__c, Production__c, Handle_Marked_for_Deletion__c, MFD__c'
        + '  from IRF_Monthly_Unit__c'; */
    
    public static final String IMU_QRY1 = ''
        + 'select Id, Name, Amount__c, IRF_Monthly_Data__c, IRF_Monthly_Data__r.Status__c, IRF_Monthly_Data__r.Expected_production__c, IRF_Unit__c, Discount_Percent__c, Flat_Rate__c, Sub_Total__c,'
        + '       IRF_Unit__r.Description__c, IRF_Unit__r.Price__c, IRF_Unit__r.MFD__c, IRF__c, IRF_Unit__r.Discount_Percent__c, IRF_Unit__r.Flat_Rate__c, IRF_Unit__r.Expected_production__c, IRF_Unit__r.Expected_monthly_revenue__c,'
        + '       Price__c, Production__c, Expected_monthly_revenue__c, Expected_production__c, Handle_Marked_for_Deletion__c, MFD__c'
        + '  from IRF_Monthly_Unit__c';  //added by vishnu Expected_production__c and Expected_monthly_revenue__c 

    public static final String IMU_OB1 = ' order by IRF_Unit__r.Description__c, Name';
    
    public static final String IMU_OB1_new = ' order by IRF_Unit__r.Description__c';

    public static final String MAX_LIMIT;

    static {
        Integer maxRecs = MAX_RECS; if (Test.isRunningTest()) {maxRecs = 100;}
        MAX_LIMIT = ' limit ' + maxRecs;
    }

    private static void debug(String s) {System.debug(LoggingLevel.INFO, 'IRF_Functions : ' + s);}

    private static Boolean isNull(String s) {return String.isBlank(s);}

    private static Decimal n2z(Decimal d) {return (d == null ? 0 : d);}

    private static Decimal z2n(Decimal d) {return (d == 0 ? null : d);}

    public static Boolean isChanged(Decimal d1, Decimal d2) {
        d1 = n2z(d1); d2 = n2z(d2); return d1 != d2;
    }

    private static Decimal round(Decimal d, Integer n) {
        if (d == null || d == 0) {return 0;}
        Decimal d1 = 10;
        Decimal d2 = d1.pow(n);
        Decimal d3 = (d * d2).round(RoundingMode.HALF_UP);
        Decimal d4 = d3.divide(d2, n);
        return  d4;
    }

    public static Boolean apexTriggersDisabled() {
        if (IRF_SETTINGS == null) {return false;}
        return IRF_SETTINGS.Apex_Triggers_Disabled__c;
    }

    public static void doBeforeInsert(List<Invoicing_Report_Form__c> alist) {
    }

    public static void doBeforeUpdate(Map<Id, Invoicing_Report_Form__c> nmap,
                                      Map<Id, Invoicing_Report_Form__c> omap) {
        List<Invoicing_Report_Form__c> alist = nmap.values();
    }

    public static void doBeforeInsert(List<IRF_Material__c> alist) {
    }

    public static void doBeforeUpdate(Map<Id, IRF_Material__c> nmap,
                                      Map<Id, IRF_Material__c> omap) {
        List<IRF_Material__c> alist = nmap.values(), blist = new
        List<IRF_Material__c>(); IRF_Material__c b;
        for (IRF_Material__c a : alist) {b = omap.get(a.Id);
            if (isChanged(a.Price__c, b.Price__c)) {a.Change_Tracking__c = CHG_TRACKNG_PRICE;}
        }
    }

    public static void doAfterUpdate(Map<Id, IRF_Material__c> nmap,
                                     Map<Id, IRF_Material__c> omap) {
        Set<Id> nset = nmap.keySet();
        String qry = IMM_QRY1 + ' where IRF_Material__c in :nset';
        qry += ' and IRF_Monthly_Data__r.Status__c in :IMD_STATS_1';
        for(List<IRF_Monthly_Material__c> alist : Database.query(qry)) {
            setImmFields1(alist); try {update alist;} catch(Exception e) {}
        } 
    }

    public static void doBeforeInsert(List<IRF_Unit__c> alist) {
    }

    public static void doBeforeUpdate(Map<Id, IRF_Unit__c> nmap,
                                      Map<Id, IRF_Unit__c> omap) {
        List<IRF_Unit__c> alist = nmap.values(), blist = new
        List<IRF_Unit__c>(); IRF_Unit__c b;
        for (IRF_Unit__c a : alist) {b = omap.get(a.Id);
            if (isChanged(a.Price__c, b.Price__c)) {a.Change_Tracking__c = CHG_TRACKNG_PRICE;}
        }
    }

    public static void doAfterUpdate(Map<Id, IRF_Unit__c> nmap,
                                     Map<Id, IRF_Unit__c> omap) {
        Set<Id> nset = nmap.keySet();
        String qry = IMU_QRY1 + ' where IRF_Unit__c in :nset';
        qry += ' and IRF_Monthly_Data__r.Status__c in :IMD_STATS_1';
        for(List<IRF_Monthly_Unit__c> alist : Database.query(qry)) {
            setImuFields1(alist); try {update alist;} catch(Exception e) {}
        } 
    }

    public static void doBeforeInsert(List<IRF_Monthly_Data__c> alist) {
        setIrfs(alist); setImdFields1(alist);
    }

    public static void doBeforeUpdate(Map<Id, IRF_Monthly_Data__c> nmap,
                                      Map<Id, IRF_Monthly_Data__c> omap) {
        List<IRF_Monthly_Data__c> alist = nmap.values();
        setIrfs(alist); setImdFields1(alist);
    }
    
    public static void doBeforeInsert(List<IRF_Monthly_Material__c> alist) {
        System.debug('it is before insert>>>'+alist);
        system.debug('Last Hope'+alist);
        setImmFields1fix(alist);
        system.debug('list info'+alist);
        setIrfMats(alist); setImmFields1(alist);  
    }
    
    private static void setImmFields1fix(List<IRF_Monthly_Material__c> alist) {
    system.debug('Last Hope entered here'+alist);
        if (alist == null || alist.isEmpty()) {return;}
        for (IRF_Monthly_Material__c a : alist) {
            if(a.IRF_Material__r.MFD__c == TRUE){
                a.Handle_Marked_for_Deletion__c = TRUE ;   
            }
        }
    }

    public static void doBeforeUpdate(Map<Id, IRF_Monthly_Material__c> nmap,
                                      Map<Id, IRF_Monthly_Material__c> omap) {
        //System.debug('it is before update>>>'+alist);
        List<IRF_Monthly_Material__c> alist = nmap.values();
        setIrfMats(alist); setImmFields1(alist);
    }

    public static void doBeforeInsert(List<IRF_Monthly_Unit__c> alist) {
        setIrfUnts(alist); System.debug('##it is before Insert>>>'+alist); setImuFields1(alist);
        System.debug('###it is before Insert>>>'+alist);
    }

    public static void doBeforeUpdate(Map<Id, IRF_Monthly_Unit__c> nmap,
                                      Map<Id, IRF_Monthly_Unit__c> omap) {
        List<IRF_Monthly_Unit__c> alist = nmap.values();
        setIrfUnts(alist); System.debug('##it is before Update>>>'+alist); setImuFields1(alist);
                                          System.debug('##it is after Update>>>'+alist);
    }

    public static String getSOptLbl(List<SelectOption> slist, String val) {
        if (slist == null || slist.isEmpty()) {return '';}
        SelectOption so = new SelectOption('', ''); String v;
        for (SelectOption s : slist) {v = s.getValue();
            if (!isNull(v) && !isNull(val) && v.equals(val)) {so = s; break;}
        }
        return so.getLabel();
    }

    public static Boolean isContractTeam() {
        return isUserInPset(UserInfo.getUserId(), PSET_CONTRACT_TEAM);
    }

    private static Boolean isUserInPset(Id userId, String psetName) {
        List<PermissionSetAssignment> alist = [
            select AssigneeId, PermissionSetId from PermissionSetAssignment
             where AssigneeId = :userId and PermissionSet.Name = :psetName];
        return (alist != null && !alist.isEmpty());
    }

    public static Account getAccount(String accId) {
        Account acc = [select
        AccountNumber, CurrencyIsoCode, Id, Inactive_Account__c,
        Name, Owner.Name, OwnerId,
        SAP_Customer_Group__c, SAP_Customer_Group_Desc__c,
        SAP_Dist_Channel_Desc__c, SAP_DistChannel__c,
        SAP_Division_Desc__c, SAP_DivisionCode__c,
        SAP_Sales_Org_Desc__c, SAP_Sales_Org__c, SAP_ShippingPlant__c,
        SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_StreetSuppl3__c,
        SAP_City__c, SAP_State__c, SAP_Zip_Code__c, SAP_Country__c
        from Account where Id = :accId];
        return acc;
    }

    public static List<SelectOption> getContractOpts() {
        List<SelectOption> alist = new List<SelectOption>();
        alist.add(new SelectOption(CT_ZCCC_VAL, CT_ZCCC_LBL));
        alist.add(new SelectOption(CT_ZPCC_VAL, CT_ZPCC_LBL));
        alist.add(new SelectOption(CT_ZTCC_VAL, CT_ZTCC_LBL));
        alist.add(new SelectOption(CT_ZPNC_VAL, CT_ZPNC_LBL));
        alist.add(new SelectOption(CT_ZTNC_VAL, CT_ZTNC_LBL)); // added vishnu 2
        return alist;
    }

    public static List<SelectOption> getImdStatOpts() {
        List<SelectOption> alist = new List<SelectOption>();
        alist.add(new SelectOption(IMD_STAT_DRAFT,    IMD_STAT_DRAFT));
        alist.add(new SelectOption(IMD_STAT_SUBMITED, IMD_STAT_SUBMITED));
        alist.add(new SelectOption(IMD_STAT_APPROVED, IMD_STAT_APPROVED));
        alist.add(new SelectOption(IMD_STAT_REJECTED, IMD_STAT_REJECTED));
        alist.add(new SelectOption(IMD_STAT_INVOICED, IMD_STAT_INVOICED));
        return alist;
    }

    public static List<SelectOption> getIrfStatOpts() {
        List<SelectOption> alist = new List<SelectOption>();
        alist.add(new SelectOption(IRF_STAT_DRAFT,    IRF_STAT_DRAFT));
        alist.add(new SelectOption(IRF_STAT_RELEASED, IRF_STAT_RELEASED));
        alist.add(new SelectOption(IRF_STAT_CLOSED,   IRF_STAT_CLOSED));
        return alist;
    }

    public static List<SelectOption> getUomOpts() {
        return SAP_Queries_Functions.getSapUomOpts(UOM_CODES);
    }

    public static List<SelectOption> getYnOpts() {
        List<SelectOption> alist = new List<SelectOption>();
        alist.add(new SelectOption(OPT_VAL_YES, OPT_VAL_YES));
        alist.add(new SelectOption(OPT_VAL_NO,  OPT_VAL_NO));
        return alist;
    }

    public static Map<Id, Invoicing_Report_Form__c> getIrfMap(Set<Id> aset) {
        Map<Id, Invoicing_Report_Form__c> amap = new Map<Id, Invoicing_Report_Form__c>();
        if (aset == null || aset.isEmpty()) {return amap;}
        String qry = IRF_QRY1 + ' where Id in :aset';
        for (Invoicing_Report_Form__c a : Database.query(qry)) {amap.put(a.Id, a);}
        return amap;
    }

    public static IRF_Class getIrfClass1(String irfId) {
        IRF_Class irfc = new IRF_Class();
        if (String.isBlank(irfId)) {return irfc;}
        String qry = IRF_QRY1 + ' where Id = :irfId';
        List<Invoicing_Report_Form__c> alist = Database.query(qry);
        if (alist != null && !alist.isEmpty()) {irfc = new IRF_Class(alist[0]);}
        return irfc;
    }

    public static IRF_Class getIrfClass2(String matId) {
        IRF_Class irfc = new IRF_Class();
        if (String.isBlank(matId)) {return irfc;}
        List<IRF_Material__c> mlist = [select IRF__c, Marked_for_deletion_Date__c from IRF_Material__c where Id = :matId];
        if (mlist != null && !mlist.isEmpty() && mlist[0].IRF__c != null) {
            irfc = getIrfClass1(mlist[0].IRF__c);
        }
        return irfc;
    }

    public static IRF_Class getIrfClass3(String untId) {
        IRF_Class irfc = new IRF_Class();
        if (String.isBlank(untId)) {return irfc;}
        List<IRF_Unit__c> ulist = [select IRF__c, MFD__c from IRF_Unit__c where Id = :untId];
        if (ulist != null && !ulist.isEmpty() && ulist[0].IRF__c != null) {
            irfc = getIrfClass1(ulist[0].IRF__c);
        }
        return irfc;
    }

    public static Boolean isNewPeriod(String irfId, Date sdate, Date edate) {
        if (String.isBlank(irfId) || sdate == null || edate == null) {return false;}
        String qry = IMD_QRY1 + ' where IRF__c = :irfId';
        qry += ' and End_Date__c >= :sdate limit 1';
        List<IRF_Monthly_Data__c> alist = Database.query(qry);
        return (alist == null || alist.isEmpty());
    }

    public static Map<Id, IRF_Monthly_Data__c> getImdMap(Set<Id> aset) {
        Map<Id, IRF_Monthly_Data__c> amap = new Map<Id, IRF_Monthly_Data__c>();
        if (aset == null || aset.isEmpty()) {return amap;}
        String qry = IMD_QRY1 + ' where Id in :aset';
        for (IRF_Monthly_Data__c a : Database.query(qry)) {amap.put(a.Id, a);}
        return amap;
    }

    public static Map<Id, IRF_Material__c> getIrfMatMap(Set<Id> aset) {
        Map<Id, IRF_Material__c> amap = new Map<Id, IRF_Material__c>();
        if (aset == null || aset.isEmpty()) {return amap;}
        String qry = MAT_QRY1 + ' where Id in :aset';
        for (IRF_Material__c a : Database.query(qry)) {amap.put(a.Id, a);}
        return amap;
    }

    public static PaginationController getIrfMatPC(String irfId, Integer pageSize, Boolean exclMFD ,Boolean sortMat) {
        if (String.isBlank(irfId)) {return null;}
        String qry = MAT_QRY1 + ' where IRF__c = :irfId';
        if (exclMFD) {qry += ' and MFD__c = false';}
        //qry += MAT_OB1;
        qry += MAT_OB1_new;
        qry += sortMat ? ' DESC' : ' ASC'; 
        debug('getIrfMatPC : qry = ' + qry);
        Database.Querylocator ql; PaginationController pc = null;
        try {
            ql = Database.getQueryLocator(qry);
            pc = new PaginationController(ql, pageSize);
        } catch(Exception e) {debug('getIrfMatPC : ' + e.getMessage());}
        return pc;
    }

    public static Set<String> getIrfMatIds(String irfId) {
        Set<String> matIds = new Set<String>();
        if (String.isBlank(irfId)) {return matIds;}
        String qry = MAT_QRY1 + ' where IRF__c = :irfId' + MAX_LIMIT;
        for (IRF_Material__c m : Database.query(qry)) {matIds.add(m.Material__c);}
        return matIds;
    }

    public static Map<Id, IRF_Unit__c> getIrfUntMap(Set<Id> aset) {
        Map<Id, IRF_Unit__c> amap = new Map<Id, IRF_Unit__c>();
        if (aset == null || aset.isEmpty()) {return amap;}
        String qry = UNT_QRY1 + ' where Id in :aset';
        for (IRF_Unit__c a : Database.query(qry)) {amap.put(a.Id, a);}
        return amap;
    }

    public static PaginationController getIrfUntPC(String irfId, Integer pageSize, Boolean exclMFD, Boolean sortMat) {
        if (String.isBlank(irfId)) {return null;}
        String qry = UNT_QRY1 + ' where IRF__c = :irfId';
        if (exclMFD) {qry += ' and MFD__c = false';}
        qry += UNT_OB1_new;
        qry += sortMat ? ' DESC' : ' ASC';
        Database.Querylocator ql; PaginationController pc = null;
        try {
            ql = Database.getQueryLocator(qry);
            pc = new PaginationController(ql, pageSize);
        } catch(Exception e) {debug('getIrfUntPC : ' + e.getMessage());}
        return pc;
    }

    public static PaginationController getImdMatPC(String imdId, Integer pageSize, Boolean exclMFD, Boolean sortMat) {
        if (String.isBlank(imdId)) {return null;}
        String qry = IMM_QRY1 + ' where IRF_Monthly_Data__c = :imdId';
        if (exclMFD) {qry += ' and MFD__c = false';}
        qry += IMM_OB2;
        //string s3 = IMM_OB2;
        qry += sortMat ? ' DESC' : ' ASC';
        //s3 += qry2;
        //System.debug('It queries the materials for IMD'+s3);
        Database.Querylocator ql; PaginationController pc = null;
        try {
            ql = Database.getQueryLocator(qry);
            System.debug('materials for IMD'+ql);
            pc = new PaginationController(ql, pageSize);
        } catch(Exception e) {debug('getImdMatPC : ' + e.getMessage());}
        return pc;
    }

    public static List<IRF_Monthly_Material> getNewImdMats(IRF_Monthly_Data__c imd) {
        List<IRF_Monthly_Material> alist = new List<IRF_Monthly_Material>();
        if (imd == null) {return alist;} String imdId = imd.Id;
        if (String.isBlank(imdId)) {return alist;}
        String qry = IMM_QRY1 + ' where IRF_Monthly_Data__c = :imdId';
        qry += ' and IRF_Material__c = null' + IMM_OB1 + MAX_LIMIT;
        List<IRF_Monthly_Material__c> mlist = Database.query(qry);
        if (mlist == null || mlist.isEmpty()) {return alist;}
        SObject so; Integer n = 1; IRF_Monthly_Material a;
        for (IRF_Monthly_Material__c m : mlist) {
            so = m; a = new IRF_Monthly_Material(imd, so, n++); alist.add(a);
        }
        system.debug('returning from getNewImdMats'+alist);
        return alist;
    }

    public static PaginationController getImdUntPC(String imdId, Integer pageSize, Boolean exclMFD, Boolean sortMat) {
        if (String.isBlank(imdId)) {return null;}
        String qry = IMU_QRY1 + ' where IRF_Monthly_Data__c = :imdId';
        if (exclMFD) {qry += ' and MFD__c = false';}
        qry += IMU_OB1_new;
        qry += sortMat ? ' DESC' : ' ASC';
        Database.Querylocator ql; PaginationController pc = null;
        try {
            ql = Database.getQueryLocator(qry);
            System.debug('<<<<ql>>>'+ql);
            pc = new PaginationController(ql, pageSize);
        } catch(Exception e) {debug('getImdUntPC : ' + e.getMessage());}
        System.debug('<<<pc>>>'+pc);
        return pc;
    }

    public static Boolean imdApprovalHistoryExists(String imdId) {
        if (String.isBlank(imdId)) {return null;}
        List<IRF_Monthly_Data__c> alist = [
            Select Id, (Select Id From ProcessSteps limit 1)
              From IRF_Monthly_Data__c
             where Id = :imdId];
        if (alist == null || alist.isEmpty()) {return null;}
        List<ProcessInstanceHistory> blist = alist[0].ProcessSteps;
        return (blist != null && !blist.isEmpty());
    }

    private static String getMsd2Qry(Account acc, String matName) {
        String salesOrg = '', distChan = '', qry = '', orderBy = '';
        if (acc != null) {distChan = acc.SAP_DistChannel__c;
                          salesOrg = acc.SAP_Sales_Org__c;}
        qry = MSD_QRY1; orderBy = MSD_OB1;
        qry += ' where Active_Material__c = \'Y\'';
        if (!isNull(distChan)) {qry += ' and Dist_Channel_Code__c = \'' + distChan + '\'';}
        if (!isNull(salesOrg)) {qry += ' and Sales_Org_Code__c = \'' + salesOrg + '\'';}
        if (!isNull(matName))  {qry += ' and Name like \'%' + matName + '%\'';}
        qry += orderBy + MAX_LIMIT;
        debug('qry = ' + qry);
        return qry;
    }

    public static PaginationController getMsd2PC(Account acc, String matName, Integer pageSize) {
        String qry = getMsd2Qry(acc, matName);
        if (isNull(qry)) {return null;}
        debug('getMsd2PC : qry = ' + qry);
        Database.Querylocator ql; PaginationController pc = null;
        try {
            ql = Database.getQueryLocator(qry);
            pc = new PaginationController(ql, pageSize);
        } catch(Exception e) {debug('getMsd2PC : ' + e.getMessage());}
        return pc;
    }

    @TestVisible
    private static Set<String> getMatNums(List<Material_Sales_Data2__c> msd2s) {
        Set<String> matNums = new Set<String>();
        for (Material_Sales_Data2__c m : msd2s) {matNums.add(m.Material_Number__c);}
        return matNums;
    }

    @TestVisible
    private static Map<String, Material_UOM2__c> getAltUoms(List<Material_Sales_Data2__c> msd2s) {
        Set<String> matNums = getMatNums(msd2s); return getAltUoms(matNums);
    }

    private static Map<String, Material_UOM2__c> getAltUoms(Set<String> matNums) {
        return Material_UOM_Functions.getAltUoms(matNums);
    }

    private static List<CPI_Functions.Parameter> getCPIParams(String accId, List<Material_Sales_Data2__c> msd2s) {
        List<CPI_Functions.Parameter> plist = new List<CPI_Functions.Parameter>(); CPI_Functions.Parameter p;
        for (Material_Sales_Data2__c msd2 : msd2s) {
            p = new CPI_Functions.Parameter();
            p.accId = accId; p.accType = SHIPTO; p.cpiMapKey = msd2.Id; p.matId = msd2.Id; plist.add(p);
        }
        return plist;
    }

    private static Map<String, Customer_Product_Info__c> getCPIMap(String accId, List<Material_Sales_Data2__c> msd2s) {
        Map<String, Customer_Product_Info__c> cpiMap = new Map<String, Customer_Product_Info__c>();
        Set<Id> accIds = new Set<Id>{accId};
        Map<Id, Map<String, List<Id>>> partnerIds = Account_Partner_Functions.getPartnerIds(accIds);
        Map<Id, Account> accMap = Account_Partner_Functions.getAccountsMap(partnerIds);
        Map<Id, Material_Sales_Data2__c> msd2map = Material_Sales_Data_Functions.getMaterialSalesData2Map(msd2s);
        List<CPI_Functions.Parameter> cpiParams = getCPIParams(accId, msd2s);
        cpimap = CPI_Functions.getCPIMap(cpiParams, partnerIds, accMap, msd2map); debug('cpimap : ' + cpimap);
        return cpiMap;
    }

    private static Set<String> getPlantCodes(Account acc, Map<String, Customer_Product_Info__c> cpiMap) {
        Set<String> plntCodes = new Set<String>(); String accPlant = acc.SAP_ShippingPlant__c, cpiPlant;
        if (!String.isBlank(accPlant)) {plntCodes.add(accPlant);}
        if (cpiMap == null || cpiMap.isEmpty()) {return plntCodes;}
        for (Customer_Product_Info__c cpi : cpiMap.values()) {
            cpiPlant = cpi.Plant_Code__c; if (!String.isBlank(cpiPlant)) {plntCodes.add(cpiPlant);}
        }
        return plntCodes;
    }

    private static Map<String, Material_General_Data2__c> getParentMats(String shipToNum, String soldToNum,
                                                                        List<Material_Sales_Data2__c> msd2s,
                                                                        Set<String> plntCodes) {
        Set<String> matNums = getMatNums(msd2s);
        for (Material_Plant2__c p : [select Plant_Code__c from Material_Plant2__c
            where Material_Number__c in :matNums]) {plntCodes.add(p.Plant_Code__c);}
        return Material_Substitute_Functions.getMatSubsts(shipToNum, soldToNum, matNums, plntCodes);
    }

    private static void setMatWeights(IRF_Material__c mc, Map<String, Material_UOM2__c> altUoms) {
        Material_Sales_Data2__c msd2 = mc.Material__r;
        String matNum = msd2.Material_Number__c, salesOrg = msd2.Sales_Org_Code__c;
        Double wpc = msd2.Net_Weight__c, wpv = null;
        if (wpc != null) {
            if (SORGS_LB.contains(salesOrg)) {wpc *= KG2LB;
                wpv = Material_UOM_Functions.getLbPerGallon(altUoms, matNum);
            } else {
                wpv = Material_UOM_Functions.getKgPerLiter(altUoms, matNum);
            }
        }
        mc.Weight_per_Container__c = wpc; mc.Weight_per_Volume__c = wpv;
    }

    public static List<IRF_Material> getIrfMaterials(Account acc, String soldToNum,
                                                     List<Material_Sales_Data2__c> msd2s) {
        String accId = acc.Id, shipToNum = acc.AccountNumber;
        List<IRF_Material> mlist = new List<IRF_Material>(); Material_General_Data2__c mgd2;
        Customer_Product_Info__c cpi; IRF_Material m; IRF_Material__c mc; String msd2Id, matNum;
        Map<String, Customer_Product_Info__c> cpiMap = getCPIMap(accId, msd2s);
        Set<String> plntCodes = getPlantCodes(acc, cpiMap);
        Map<String, Material_General_Data2__c> pmatMap = getParentMats(shipToNum, soldToNum, msd2s, plntCodes);
        Map<String, Material_UOM2__c> altUoms = getAltUoms(msd2s);
        for (Material_Sales_Data2__c msd2 : msd2s) {msd2Id = msd2.Id; matNum = msd2.Material_Number__c;
            mc = new IRF_Material__c(); mc.Material__c = msd2Id; mc.Material__r = msd2;
            setMatWeights(mc, altUoms);
            if (cpiMap.containsKey(msd2Id)) {cpi = cpiMap.get(msd2Id);
                mc.Customer_Material_Number__c = cpi.Customer_Material_Number__c;
            }
            if (pmatMap.containsKey(matNum)) {
                mgd2 = pmatMap.get(matNum); //mc.Parent_Material__c = mgd2.Id; mc.Parent_Material__r = mgd2;
                mc.Parent_Material_Desc__c = mgd2.Material_Description__c;
                mc.Parent_Material_Number__c = String_Functions.removeLeadingZeros(mgd2.Material_Number__c);
            }
            m = new IRF_Material(mc); mlist.add(m);
        }
        return mlist;
    }

    private static String upsertIrfMats(List<IRF_Material> mats, Id irfId) {
        if (mats == null || mats.isEmpty()) {return null;}
        IRF_Material__c m; List<IRF_Material__c> mlist = new List<IRF_Material__c>();
        for (IRF_Material mat : mats) {
            m = mat.sobj; if (m.IRF__c == null) {m.IRF__c = irfId;}
            //if (String.isBlank(mat.parentMatNum)) {m.Parent_Material__c = null;}
            //if (String.isBlank(m.Parent_Material_Number__c)) {m.Parent_Material_Desc__c = null;}
            mlist.add(m);
        }
        try {upsert mlist;} catch(Exception e) {return 'Failed to Upsert IRF Materials : ' + e.getMessage();}
        return null;
    }

    private static String upsertIrfUnts(List<IRF_Unit> unts, Id irfId) {
        if (unts == null || unts.isEmpty()) {return null;}
        IRF_Unit__c u; List<IRF_Unit__c> ulist = new List<IRF_Unit__c>();
        for (IRF_Unit unt : unts) {
            u = unt.sobj; if (u.IRF__c == null) {u.IRF__c = irfId;} ulist.add(u);
        }
        try {upsert ulist;} catch(Exception e) {return 'Failed to Upsert IRF Units : ' + e.getMessage();}
        return null;
    }

    private static String deleteSObjs(List<SObject> sobjs) {
        if (sobjs == null || sobjs.isEmpty()) {return null;}
        try {delete sobjs;} catch(Exception e) {return e.getMessage();}
        return null;
    }

    private static String mfdIrfMats(List<IRF_Material__c> mlist) {
        if (mlist == null || mlist.isEmpty()) {return null;}
        for (IRF_Material__c m : mlist) {
            m.MFD__c = true;
            m.Marked_for_deletion_Date__c = system.now(); // Added by Vinu for fixing MFD Issue
            //m.Undeletion_Date__c = NULL;
        }
        try {update mlist;} catch(Exception e) {return e.getMessage();}
        return null;
    }

    private static String mfdIrfUnts(List<IRF_Unit__c> ulist) {
        if (ulist == null || ulist.isEmpty()) {return null;}
        for (IRF_Unit__c u : ulist) {
            u.MFD__c = true;
            u.Marked_for_deletion_Date__c = system.now();
            //u.Undeletion_Date__c = NULL; 
        }
        try {update ulist;} catch(Exception e) {return e.getMessage();}
        return null;
    }

    public static Boolean isIrfReleased(String irfStat) {
        return irfStat != null && irfStat.equalsIgnoreCase(IRF_STAT_RELEASED);
    }

    private static Boolean isIrfDraft(String irfStat) {
        return irfStat != null && irfStat.equalsIgnoreCase(IRF_STAT_DRAFT);
    }

    private static String deleteIrfMats(Set<String> ids, String irfStat) {
        String s = null;
        if (ids == null || ids.isEmpty() || String.isBlank(irfStat) ||
            irfStat.equalsIgnoreCase(IRF_STAT_CLOSED)) {return s;}
        List<IRF_Material__c> mlist = [select Id, MFD__c, Marked_for_deletion_Date__c from IRF_Material__c where Id in :ids];
        if (isIrfDraft(irfStat))    {s = deleteSObjs(mlist);} else
        if (isIrfReleased(irfStat)) {s = mfdIrfMats(mlist);}
        if (s == null) {return s;} return 'Failed to Delete IRF Materials : ' + s;
    }

    private static String deleteIrfUnts(Set<String> ids, String irfStat) {
        String s = null;
        if (ids == null || ids.isEmpty() || String.isBlank(irfStat) ||
            irfStat.equalsIgnoreCase(IRF_STAT_CLOSED)) {return s;}
        List<IRF_Unit__c> ulist = [select Id, MFD__c, Marked_for_deletion_Date__c from IRF_Unit__c where Id in :ids];
        if (isIrfDraft(irfStat))    {s = deleteSObjs(ulist);} else
        if (isIrfReleased(irfStat)) {s = mfdIrfUnts(ulist);}
        if (s == null) {return s;} return 'Failed to Delete IRF Units : ' + s;
    }

    public static String saveIrf(IRF_Class irfc, List<IRF_Material> mats, List<IRF_Unit> unts,
                                 Set<String> mfdMatIds, Set<String> mfdUntIds) {
        Invoicing_Report_Form__c irf = irfc.sobj;
        if (irf == null) {return 'Invalid IRF';} String s = null;
        try {upsert irf;} catch(Exception e) {s = 'Failed to Upsert IRF : ' + e.getMessage();}
        String irfId = irf.Id, irfStat = irf.Status__c;
        if (s == null) {s = upsertIrfMats(mats, irfId);}
        if (s == null) {s = upsertIrfUnts(unts, irfId);}
        if (s == null) {s = deleteIrfMats(mfdMatIds, irfStat);}
        if (s == null) {s = deleteIrfUnts(mfdUntIds, irfStat);}
        return s;
    }
// --------------------------------------------------------------------------------------------------------------
    public static IRF_Monthly_Data getIrfMD1(String irfId) {
        IRF_Monthly_Data__c imd = new IRF_Monthly_Data__c();
        if (!String.isBlank(irfId)) {imd.IRF__c = irfId;}
        Date sdate = Date.today().toStartOfMonth();
        IRF_Monthly_Data__c pmd = getLatestImd(irfId, null); debug('pmd : ' + pmd);
        if (pmd != null) {imd = pmd.clone();
            imd.General_Comments__c = ''; imd.Invoice_Numbers__c = '';
            imd.Operating_Comments__c = ''; imd.Upcoming_Changes__c = '';
            if (pmd.End_Date__c != null) {sdate = pmd.End_Date__c.addDays(1);}
        }
        //Date edate = sdate.addMonths(1).toStartOfMonth().addDays(-1);
        Date edate = sdate.addDays(IMD_DAYS);
        imd.Start_Date__c = sdate; imd.End_Date__c = edate; imd.Status__c = IMD_STAT_DRAFT;
        IRF_Monthly_Data d_hdr = new IRF_Monthly_Data(imd); d_hdr.pmd = pmd;
        setPrevMatData(d_hdr); setPrevUntData(d_hdr);
        return d_hdr;
    }

    public static IRF_Monthly_Data getIrfMD2(String imdId) {
        IRF_Monthly_Data imd = new IRF_Monthly_Data();
        if (String.isBlank(imdId)) {return imd;}
        String qry = IMD_QRY1 + ' where Id = :imdId';
        List<IRF_Monthly_Data__c> alist = Database.query(qry);
        if (alist != null && !alist.isEmpty()) {imd = new IRF_Monthly_Data(alist[0]);}
        return imd;
    }

    public static IRF_Monthly_Data getIrfMD3(String immId) {
        IRF_Monthly_Data imd = new IRF_Monthly_Data();
        if (String.isBlank(immId)) {return imd;}
        List<IRF_Monthly_Material__c> mlist = [
            select IRF_Monthly_Data__c from IRF_Monthly_Material__c where Id = :immId];
        if (mlist != null && !mlist.isEmpty() && mlist[0].IRF_Monthly_Data__c != null) {
            imd = getIrfMD2(mlist[0].IRF_Monthly_Data__c);
        }
        return imd;
    }

    public static IRF_Monthly_Data getIrfMD4(String imuId) {
        IRF_Monthly_Data imd = new IRF_Monthly_Data();
        if (String.isBlank(imuId)) {return imd;}
        List<IRF_Monthly_Unit__c> ulist = [
            select IRF_Monthly_Data__c from IRF_Monthly_Unit__c where Id = :imuId];
        if (ulist != null && !ulist.isEmpty() && ulist[0].IRF_Monthly_Data__c != null) {
            imd = getIrfMD2(ulist[0].IRF_Monthly_Data__c);
        }
        return imd;
    }

    public static PaginationController getImdPC(String irfId, Integer pageSize) {
        if (String.isBlank(irfId)) {return null;}
        String qry = IMD_QRY1 + ' where IRF__c = :irfId';
        qry += ' order by End_Date__c desc ';
        Database.Querylocator ql; PaginationController pc = null;
        try {
            ql = Database.getQueryLocator(qry);
            pc = new PaginationController(ql, pageSize);
        } catch(Exception e) {debug('getImdPC : ' + e.getMessage());}
        return pc;
    }

    public static PaginationController getSubmittedImdPC(Integer pageSize) {
        Set<String> oids; String rectype = 'IRF_Monthly_Data__c'; Integer maxNum = null;
        oids = Custom_Approval_Functions.getPendingApprovalObjectIds(rectype, maxNum);
        if (oids == null || oids.isEmpty()) {return null;} 
        String qry = 'select Id, Name, End_Date__c, IRF__c, IRF__r.Name, IRF__r.ShipTo__c'
        + ', IRF__r.ShipTo__r.AccountNumber, IRF__r.ShipTo__r.Name'
        + ', IRF__r.ShipTo__r.SAP_City__c, IRF__r.ShipTo__r.SAP_Sales_Org__c'
        + ', IRF__r.ShipTo__r.SAP_State__c, IRF__r.ShipTo__r.SAP_Street__c'
        + ', Start_Date__c, Submitted_By__r.Name, Submitted_DateTime__c'
        + '  from IRF_Monthly_Data__c where Id in :oids'
        + '  order by IRF__r.ShipTo__r.SAP_Sales_Org__c, IRF__r.ShipTo__r.Name'
        + ', IRF__r.ShipTo__r.SAP_City__c, IRF__r.ShipTo__r.SAP_State__c'
        + ', IRF__r.Name, End_Date__c'; 
        Database.Querylocator ql; PaginationController pc = null;
        try {
            ql = Database.getQueryLocator(qry);
            pc = new PaginationController(ql, pageSize);
        } catch(Exception e) {debug('getSubmittedImdPC : ' + e.getMessage());}
        return pc;
    }

    private static IRF_Monthly_Data__c getLatestImd(String irfId, Date sdate) {
        if (String.isBlank(irfId)) {return null;}
        String qry = IMD_QRY1 + ' where IRF__c = :irfId';
        if (sdate != null) {qry += ' and End_Date__c <= :sdate';}
        qry += ' order by End_Date__c desc limit 1';
        List<IRF_Monthly_Data__c> alist = Database.query(qry);
        if (alist == null || alist.isEmpty()) {return null;}
        return alist[0];
    }

    public static Map<String, IRF_Monthly_Material__c> getImms(String imdId, Set<String> matIds) {
        Map<String, IRF_Monthly_Material__c> amap = new Map<String, IRF_Monthly_Material__c>();
        if (String.isBlank(imdId) || matIds == null || matIds.isEmpty()) {return amap;}
        String qry = IMM_QRY1 + ' where IRF_Monthly_Data__c = :imdId and IRF_Material__c in :matIds ';
        for (IRF_Monthly_Material__c a : Database.query(qry)) {
            if (a.IRF_Material__c != null) {amap.put(a.IRF_Material__c, a);}
        }
        return amap;
    }

    private static Map<String, IRF_Monthly_Material__c> getImms(String imdId) {
        Map<String, IRF_Monthly_Material__c> amap = new Map<String, IRF_Monthly_Material__c>();
        if (String.isBlank(imdId)) {return amap;} Integer n = 0;
        String qry = IMM_QRY1 + ' where IRF_Monthly_Data__c = :imdId ' + MAX_LIMIT;
        for (IRF_Monthly_Material__c a : Database.query(qry)) {
            if (a.IRF_Material__c != null) {amap.put(a.IRF_Material__c, a);} else
            if (a.Material__c != null)     {amap.put(a.Material__c,     a);} else
                                           {amap.put('NewMat-' + (++n), a);}
        }
        return amap;
    }

    public static Map<String, IRF_Monthly_Unit__c> getImus(String imdId, Set<String> untIds) {
        Map<String, IRF_Monthly_Unit__c> amap = new Map<String, IRF_Monthly_Unit__c>();
        system.debug('the entered imdId: '+ imdId);
        if (String.isBlank(imdId) || untIds == null || untIds.isEmpty()) {return amap;}
        String qry = IMU_QRY1 + ' where IRF_Monthly_Data__c = :imdId and IRF_Unit__c in :untIds';
        system.debug('the getImus qry: '+ qry);
        system.debug('the getImus imdId: '+ imdId); 
        system.debug('the getImus untIds: '+ untIds);
        for (IRF_Monthly_Unit__c a : Database.query(qry)) {
            if (a.IRF_Unit__c != null) {amap.put(a.IRF_Unit__c, a);}
        }
        return amap;
    }

    private static Map<String, IRF_Monthly_Unit__c> getImus(String imdId) {
        Map<String, IRF_Monthly_Unit__c> amap = new Map<String, IRF_Monthly_Unit__c>();
        if (String.isBlank(imdId)) {return amap;}
        system.debug('imdId -->>##'+ imdId);
        String qry = IMU_QRY1 + ' where IRF_Monthly_Data__c = :imdId ' + MAX_LIMIT;
        system.debug('qry -->>##'+ qry);
        for (IRF_Monthly_Unit__c a : Database.query(qry)) {
            if (a.IRF_Unit__c != null) {amap.put(a.IRF_Unit__c, a);}
        }
        return amap;
    }

    private static void setPrevMatData(IRF_Monthly_Data d_hdr) {
        if (d_hdr.pmd == null) {return;} Id pmdId = d_hdr.pmd.Id; Decimal d1 = 0;
        for (IRF_Monthly_Material__c a : [
            select Billing_Value__c from IRF_Monthly_Material__c
             where IRF_Monthly_Data__c = :pmdId]) {d1 += n2z(a.Billing_Value__c);}
        d_hdr.prevMatAmt = d1;
    }

    private static void setPrevUntData(IRF_Monthly_Data d_hdr) {
        if (d_hdr.pmd == null) {return;} Id pmdId = d_hdr.pmd.Id; Decimal d1 = 0;
        for (IRF_Monthly_Unit__c a : [
            select Amount__c from IRF_Monthly_Unit__c
             where IRF_Monthly_Data__c = :pmdId]) {d1 += n2z(a.Amount__c);}
        d_hdr.prevUntAmt = d1;
    }

    public static void setPrevPeriodData(IRF_Monthly_Data d_hdr) {
        IRF_Monthly_Data__c imd = d_hdr.sobj;
        String irfId = imd.IRF__c; Date sdate = imd.Start_Date__c;
        d_hdr.startDate = sdate; d_hdr.pmd = getLatestImd(irfId, sdate);
        d_hdr.prevMatAmt = 0; d_hdr.prevUntAmt = 0;
        if (d_hdr.pmd == null) {return;}
        setPrevMatData(d_hdr); setPrevUntData(d_hdr);
    }

    public static void setPrevPeriodData(IRF_Monthly_Data d_hdr, List<IRF_Monthly_Material> alist) {
        if (d_hdr == null || alist == null || alist.isEmpty()) {return;}
        setPrevPeriodData(d_hdr);
        IRF_Monthly_Data__c pmd = d_hdr.pmd, imd = d_hdr.sobj;
        IRF_Monthly_Material__c imm, pmm; IRF_Material__c mat;
        String irfId = imd.IRF__c;
        Map<String, IRF_Monthly_Material__c> pmap = new Map<String, IRF_Monthly_Material__c>();
        if (pmd != null) {pmap = getImms(pmd.Id);}
        for (IRF_Monthly_Material a : alist) {
            imm = a.sobj; if (imm == null) {continue;}
            imm.Beginning_Inventory__c = 0;
            if (imm.IRF_Material__c == null && pmap.containsKey(imm.Material__c)) {
                pmm = pmap.get(imm.Material__c); if (pmm == null) {continue;}
                imm.Beginning_Inventory__c = pmm.Ending_Inventory__c;
            } else
            if (pmap.containsKey(imm.IRF_Material__c)) {
                pmm = pmap.get(imm.IRF_Material__c); if (pmm == null) {continue;}
                imm.Beginning_Inventory__c = pmm.Ending_Inventory__c;
            } else {
                mat = imm.IRF_Material__r; if (mat == null) {continue;}
                imm.Beginning_Inventory__c = mat.Beginning_Inventory__c;
            }
        }
    }

    public static PaginationController getDeliveriesPC(IRF_Monthly_Data d_hdr, List<IRF_Monthly_Material> alist,
                                                       String ordrType, Integer pageSize) {
        IRF_Monthly_Data__c imd = d_hdr.sobj;
        String sh = imd.IRF__r.ShipTo__c; Date d1 = imd.Start_Date__c, d2 = imd.End_Date__c;
        Set<String> matIds = new Set<String>(); for (IRF_Monthly_Material a : alist) {matIds.add(a.matId);}
        system.debug('<<<IRF__r.Contract_Number__c>>>'+ imd.IRF__r.Contract_Number__c);
        system.debug('<<<IRF__r.Previous_Contract_Number__c>>>'+ imd.IRF__r.Previous_Contract_Number__c);
        return SalesOrderDeliveriesFunctions.getDeliveriesPC(sh, d1, d2, ordrType, matIds, pageSize, imd.IRF__r.Contract_Number__c,imd.IRF__r.Previous_Contract_Number__c);
    }

    public static void setOrdrDelvryData(IRF_Monthly_Data d_hdr, List<IRF_Monthly_Material> alist) {
        setOrdrDelvryData(d_hdr, alist, false);
    }

    public static void setOrdrDelvryData(IRF_Monthly_Data d_hdr, List<IRF_Monthly_Material> alist, Boolean initQtys) {
        IRF_Monthly_Data__c imd = d_hdr.sobj; IRF_Monthly_Material__c imm;
        String sh = imd.IRF__r.ShipTo__c, uom = d_hdr.unitsUom;
        Date d1 = imd.Start_Date__c, d2 = imd.End_Date__c;
        Set<String> matIds = new Set<String>(); for (IRF_Monthly_Material a : alist) {matIds.add(a.matId);}
        //Map<String, Decimal> qmap = SalesOrderDeliveriesFunctions.getShippedQtys(sh, d1, d2, SDT_SET, matIds, uom);
        System.debug('Issue 40 Calling');
        Map<String, Decimal> qmap = SalesOrderDeliveriesFunctions.getShippedQtys(sh, d1, d2, SDT_SET, matIds, uom, imd.IRF__r.Contract_Number__c,imd.IRF__r.Previous_Contract_Number__c);
        System.debug('<<<qmap >>>'+qmap);
        //if (qmap == null || qmap.isEmpty()) {return;}
        for (IRF_Monthly_Material a : alist) {imm = a.sobj;
            if (initQtys) {imm.Received_Inventory__c = null;}
            a.qtyRecevd = SalesOrderDeliveriesFunctions.getShippedQty(qmap, a.matId, SDT_ZCCF);
            if (a.qtyRecevd != null && a.qtyRecevd != 0) {imm.Received_Inventory__c = round(a.qtyRecevd,0);} // added recent
            //if (initQtys) {imm.Adjustment_Inventory__c = null;}
            //a.qtyAdjstd = SalesOrderDeliveriesFunctions.getShippedQty(qmap, a.matId, SDT_ZCCR);
            //if (a.qtyAdjstd != null) {imm.Adjustment_Inventory__c = round(a.qtyAdjstd,2);}
        }
    }
    
    public static void markForDeletion(List<IRF_Monthly_Material> alist) {
        //IRF_Monthly_Data__c imd = d_hdr.sobj;
        IRF_Monthly_Material__c imm;
        for (IRF_Monthly_Material a : alist) {
                    System.debug('i am on update'+a);    
        }
    }
// --------------------------------------------------------------------------------------------------------------
    private static void setIrfs(List<IRF_Monthly_Data__c> alist) {
        if (alist == null || alist.isEmpty()) {return;}
        Set<Id> irfIds = new Set<Id>();
        for (IRF_Monthly_Data__c a : alist) {
            if (a.IRF__c != null && a.IRF__r == null) {irfIds.add(a.IRF__c);}
        }
        if (irfIds.isEmpty()) {return;}
        Map<Id, Invoicing_Report_Form__c> irfMap = getIrfMap(irfIds);
        for (IRF_Monthly_Data__c a : alist) {
            if (a.IRF__c != null && a.IRF__r == null && irfMap.containsKey(a.IRF__c)) {
                a.IRF__r = irfMap.get(a.IRF__c);
            }
        }
    }

    public static void setImdFields1(IRF_Monthly_Data__c a) {
        List<IRF_Monthly_Data__c> sobjs = new List<IRF_Monthly_Data__c>();
        if (a != null) {sobjs.add(a);} setImdFields1(sobjs);
    }

    private static void setImdFields1(List<IRF_Monthly_Data__c> alist) {
        if (alist == null || alist.isEmpty()) {return;}
        for (IRF_Monthly_Data__c a : alist) {
            a.Days_in_Period__c = null;
            
            if (a.Start_Date__c == null || a.End_Date__c == null) {continue;}
            a.Days_in_Period__c = a.Start_Date__c.daysBetween(a.End_Date__c) + 1;
            if (a.IRF__r == null) {continue;}
            a.Key__c = a.IRF__r.Name + '-' + getStr1(a.Start_Date__c) + '-' + getStr1(a.End_Date__c);
        }
    }
    

    private static String getStr1(Date d) {
        Datetime dt = Datetime.newInstance(d.year(), d.month(), d.day());
        return dt.format('yyyyMMdd');
    }
// --------------------------------------------------------------------------------------------------------------
    private static void setIrfMats(List<IRF_Monthly_Material__c> alist) {
        if (alist == null || alist.isEmpty()) {return;}
        Set<Id> aset = new Set<Id>(), bset = new Set<Id>();
        for (IRF_Monthly_Material__c a : alist) {
            if (a.IRF_Material__c != null && a.IRF_Material__r == null) {aset.add(a.IRF_Material__c);}
            if (a.IRF_Monthly_Data__c != null && a.IRF_Monthly_Data__r == null) {bset.add(a.IRF_Monthly_Data__c);}
        }
        if (aset.isEmpty() && aset.isEmpty()) {return;}
        Map<Id, IRF_Material__c> amap = getIrfMatMap(aset);
        Map<Id, IRF_Monthly_Data__c> bmap = getImdMap(bset);
        for (IRF_Monthly_Material__c a : alist) {
            if (a.IRF_Material__c != null && a.IRF_Material__r == null && amap.containsKey(a.IRF_Material__c)) {
                a.IRF_Material__r = amap.get(a.IRF_Material__c);
            }
            if (a.IRF_Monthly_Data__c != null && a.IRF_Monthly_Data__r == null && bmap.containsKey(a.IRF_Monthly_Data__c)) {
                a.IRF_Monthly_Data__r = bmap.get(a.IRF_Monthly_Data__c);
            }
        }
    }

    private static void setImmFields1(List<IRF_Monthly_Material__c> alist) {
        if (alist == null || alist.isEmpty()) {return;}
        for (IRF_Monthly_Material__c a : alist) {setImmFields1(a);}
    }

    public static void setImmFields1(IRF_Monthly_Material__c a) {
        system.debug('<<<<enter method 1');
        IRF_Monthly_Data__c imd = a.IRF_Monthly_Data__r;
        IRF_Material__c m = a.IRF_Material__r; debug('a = from 956 ' + a); debug('m = ' + m);
        if (m == null) {return;}
        system.debug('<<<<enter method 2');
        Boolean newMat = (a.IRF_Material__c == null); 
        String imdStat = imd != null ? imd.Status__c : IMD_STAT_DRAFT;
        
        a.Billing_Value__c = null; a.Consumed_per_Day__c = null;
        a.Consumed_Inventory__c = null; a.Days_Inventory__c = null;
        a.Projected_Monthly_Average__c = null;
        if (IMD_STATS_1.contains(imdStat) && !newMat) {
            a.Discount_Percent__c = m.Discount_Percent__c;
            a.Flat_Rate__c = m.Flat_Rate__c; // Added by Vinu
            a.Estimated_Quantity__c = m.Estimated_Quantity__c;
            a.Contract_Price__c = m.Contract_Price__c; //Added by Vishnu
            a.Related_Unit__c = m.Related_Unit__c; //Added by Vishnu
            a.Price__c = m.Price__c; a.Tank_Number__c = m.Tank_Number__c;
        }
        System.debug('value of other'+a.Other_Charges__c);
        Decimal begInv = n2z(a.Beginning_Inventory__c);
        Decimal recInv = n2z(a.Received_Inventory__c);
        Decimal adjInv = n2z(a.Adjustment_Inventory__c);
        Decimal endInv = n2z(a.Ending_Inventory__c);
        a.Consumed_Inventory__c = z2n(begInv + recInv + adjInv - endInv);
       
        Decimal cnsInv = n2z(a.Consumed_Inventory__c); debug('cnsInv = ' + cnsInv);
        Decimal price  = n2z(a.Price__c); debug('price  = ' + price);
        Decimal bval1  = round(cnsInv * price, 2); debug('bval1 = ' + bval1);
        Decimal dprcnt = n2z(a.Discount_Percent__c); debug('dprcnt = ' + dprcnt);
        Decimal fltchrg = n2z(a.Flat_Rate__c); debug('fltchrg = ' + fltchrg); // Added by Vinu
       
        Decimal bval2  = round(bval1 * dprcnt / 100, 2); debug('bval2 = ' + bval2);
        Decimal ochrgs = n2z(a.Other_Charges__c); debug('ochrgs = ' + ochrgs);
        //a.Billing_Value__c = z2n(bval1 - bval2 + ochrgs);
        //a.Billing_Value__c=1000;
        system.debug('<<<a.Discount_Percent__c>>'+dprcnt /100);
        system.debug('<<<dprcnt>>'+dprcnt);
        
        system.debug('<<<a.Consumed_Inventory__c>>'+a.Consumed_Inventory__c);
        system.debug('<<<cnsInv >>'+cnsInv );
             
        system.debug('<<<price  >>'+price  );
        
        system.debug('<<<fltchrg>>'+fltchrg); 
        
        if(a.Flat_Rate__c==null){
            a.Flat_Rate__c=0;
        }
         if(a.Discount_Percent__c==null){
            a.Discount_Percent__c=0;
        }
        if(a.Price__c==null){
            a.Price__c=0;
        }
        system.debug('<<<a.Flat_Rate__c>>'+a.Flat_Rate__c);
        system.debug('<<<a.Price__c>>'+a.Price__c);   
        
       // a.Billing_Value__c=(cnsInv * price) * (1-dprcnt) + (cnsInv * fltchrg); 
        a.Billing_Value__c=(cnsInv  *price) * (1 - a.Discount_Percent__c/100) + (cnsInv   * a.Flat_Rate__c);     
       // a.Billing_Value__c=(a.Consumed_Inventory__c *a.Price__c) * (1 - a.Discount_Percent__c/100) + (a.Consumed_Inventory__c * a.Flat_Rate__c);
       // }
        //a.Billing_Value__c = z2n(bval1 - bval2 + ochrgs - fltchrg); // Added By Vinu
        Decimal estQty = n2z(a.Estimated_Quantity__c); debug('estQty = ' + estQty);
        Decimal mthAvg = round(estQty / 12, 0); a.Projected_Monthly_Average__c = z2n(mthAvg);
       
        Decimal ctrprice = n2z(a.Contract_Price__c);//added by vishnu
        a.Inventory_Variance__c = z2n(cnsInv - mthAvg);
        
        Decimal Exprd = n2z(imd.Expected_production__c);//  test added by vishnu new
        system.debug('##the value of Exprd' + imd.Expected_production__c);
        system.debug('##the value of Exprd' + Exprd);
        Decimal myprd = n2z(imd.Production__c); //test added by vishnu
        system.debug('##the myprd value is'+ imd.Production__c);
        system.debug('##the myprd value is'+ myprd);

        Boolean EforVarcal = m.Eligible_for_Variance_calculation__c == null?false:m.Eligible_for_Variance_calculation__c; //added by vishnu
        String Cntofunts = a.Related_Unit__c; //added by vishnu
        system.debug('the value of EforVarcal' + m.Eligible_for_Variance_calculation__c);
        system.debug('the value of Cntofunts' + a.Related_Unit__c);
        
        if(EforVarcal == true){
        Decimal usgexp = 0;//added by vishnu
        Decimal usgact = 0;//added by vishnu
        Decimal invavr = z2n(estQty - cnsInv);//added by vishnu
       if(Exprd != null && Exprd != 0){
             usgexp = round(estQty / Exprd, 4); }//added by vishnu

        if(myprd != null && myprd != 0){
             usgact = round(cnsInv / myprd, 4); }//added by vishnu
        Decimal UsgVar = n2z(usgexp - usgact) ;//added by vishnu
       
        Decimal UsgDollerpermn = n2z(UsgVar * ctrprice * myprd); //added by vishnu
        system.debug('###the value of usgact' + a.Usage_Expected_lbs_ton__c);
        }
        if (imd == null) {return;}
        Decimal ndays  = n2z(imd.Days_in_Period__c); debug('ndays  = ' + ndays);
        if (ndays != null && ndays != 0) {
            Decimal dayQty = round(cnsInv / ndays, 0); a.Consumed_per_Day__c = z2n(dayQty);
        }
        if (a.Consumed_per_Day__c != null && a.Consumed_per_Day__c != 0) {
            a.Days_Inventory__c = z2n(round(endInv / a.Consumed_per_Day__c, 0));
        }
            
        debug('a = from 991' + a);
    }

    private static void initImm(IRF_Monthly_Material__c imm) {
            imm.Adjustment_Inventory__c = 0;
            imm.Beginning_Inventory__c = 0;
            imm.Billing_Value__c = 0;
            imm.Consumed_Inventory__c = 0;
            imm.Consumed_per_Day__c = 0;
            imm.Ending_Inventory__c = 0;
            imm.Inventory_Variance__c = 0;
        	imm.Variance_Inv__c = 0; //added by vishnu
      	    imm.Usage_Actual_lbs_ton__c = 0; //added by vishnu
        	imm.Usage_Expected_lbs_ton__c = 0; //added by vishnu
        	imm.Usage_Variance_lbs_ton__c = 0; //added by vishnu
        	imm.Dollar_per_month__c = 0; //added by vishnu
            imm.Other_Charges__c = 0.00;
            imm.Projected_Monthly_Average__c = 0;
            imm.Received_Inventory__c = 0;
    }

    public static void setImmTotl(IRF_Monthly_Data d_hdr, List<IRF_Monthly_Material> alist,
                                  IRF_Monthly_Material t_mat) {
        IRF_Monthly_Data__c imd = d_hdr.sobj; String imdId = imd.Id;
        IRF_Monthly_Material__c imm = t_mat.sobj; initImm(imm);
        Map<String, IRF_Monthly_Material__c> amap = getImms(imdId);
        System.debug('setImmTotl>>amap'+amap);
        for (IRF_Monthly_Material a : alist) {
            if (LBL_TOTL.equals(a.matNum)) {continue;}
            if (a.sobj.IRF_Material__c != null) {a.scNohdr = '';
                amap.put(a.sobj.IRF_Material__c, a.sobj);} else {
                if (a.sobj.Material__c != null) {
                    amap.put(a.sobj.Material__c, a.sobj);
                } else {amap.put('NewMat-' + a.recNum, a.sobj);}
                a.scNohdr = SC_HILI;}
        }
        for (IRF_Monthly_Material__c m : amap.values()) {
            debug('getImmTotl : m = ' + m);
            debug('getImmTotl : m MFD__c = ' + m.MFD__c);
            //if(m.IRF_Material__r != null && m.IRF_Material__r.MFD__c) {continue;}
            if(m.IRF_Material__r != null && m.MFD__c) {continue;}
            imm.Adjustment_Inventory__c      += n2z(m.Adjustment_Inventory__c);
            imm.Beginning_Inventory__c       += n2z(m.Beginning_Inventory__c);
            imm.Billing_Value__c             += n2z(m.Billing_Value__c);
            imm.Consumed_Inventory__c        += n2z(m.Consumed_Inventory__c);
            imm.Consumed_per_Day__c          += n2z(m.Consumed_per_Day__c);
            imm.Ending_Inventory__c          += n2z(m.Ending_Inventory__c);
            imm.Inventory_Variance__c        += n2z(m.Inventory_Variance__c);
            imm.Variance_Inv__c				 += n2z(m.Variance_Inv__c); //added by vishnu
            imm.Usage_Actual_lbs_ton__c 	 += n2z(m.Usage_Actual_lbs_ton__c); //added by vishnu
            imm.Usage_Expected_lbs_ton__c	 += n2z(m.Usage_Expected_lbs_ton__c); //test added by vishnu
            imm.Usage_Variance_lbs_ton__c	 += n2z(m.Usage_Variance_lbs_ton__c);//test added by vishnu
            imm.Dollar_per_month__c			 += n2z(m.Dollar_per_month__c); //test added by vishnu
            imm.Other_Charges__c             += n2z(m.Other_Charges__c);
            imm.Projected_Monthly_Average__c += n2z(m.Projected_Monthly_Average__c);
            imm.Received_Inventory__c        += n2z(m.Received_Inventory__c);

            if (imm.Consumed_per_Day__c != 0) {
                imm.Days_Inventory__c = round(imm.Ending_Inventory__c / imm.Consumed_per_Day__c, 0);
            }
        }
        debug('getImmTotl : t_mat = ' + t_mat);
    }
// --------------------------------------------------------------------------------------------------------------
    private static void setIrfUnts(List<IRF_Monthly_Unit__c> alist) {
        if (alist == null || alist.isEmpty()) {return;}
        Set<Id> aset = new Set<Id>(), bset = new Set<Id>();
        for (IRF_Monthly_Unit__c a : alist) {
            if (a.IRF_Unit__c != null && a.IRF_Unit__r == null) {aset.add(a.IRF_Unit__c);}
            if (a.IRF_Monthly_Data__c != null && a.IRF_Monthly_Data__r == null) {bset.add(a.IRF_Monthly_Data__c);}
        }
        if (aset.isEmpty()) {return;}
        Map<Id, IRF_Unit__c> amap = getIrfUntMap(aset);
        Map<Id, IRF_Monthly_Data__c> bmap = getImdMap(bset);
        for (IRF_Monthly_Unit__c a : alist) {
            if (a.IRF_Unit__c != null && a.IRF_Unit__r == null && amap.containsKey(a.IRF_Unit__c)) {
                a.IRF_Unit__r = amap.get(a.IRF_Unit__c);
            }
            if (a.IRF_Monthly_Data__c != null && a.IRF_Monthly_Data__r == null && bmap.containsKey(a.IRF_Monthly_Data__c)) {
                a.IRF_Monthly_Data__r = bmap.get(a.IRF_Monthly_Data__c);
            }
        }
    }

    private static void setImuFields1(List<IRF_Monthly_Unit__c> alist) {
        if (alist == null || alist.isEmpty()) {return;}
        for (IRF_Monthly_Unit__c a : alist) {setImuFields1(a);}
    }
    
    public static void setImuFields1(IRF_Monthly_Unit__c a) {
        IRF_Unit__c u = a.IRF_Unit__r; 
        debug('a = ' + a); 
        debug('u = ' + u); 
        system.debug('the --> # u value' + u);
        if (u == null) { return;}
        IRF_Monthly_Data__c imd = a.IRF_Monthly_Data__r;
        //if (imd == null) { return;}
    	system.debug('the --> # imd value' + imd);
        String imdStat = imd != null ? imd.Status__c : IMD_STAT_DRAFT;
        Decimal exptprd = 0; // Initialize the value to be updated
        Decimal mthexptprd = 0; // Initialize the value to be updated
       // system.debug('the --> # imdStat value' + imdStat);
       // system.debug('the --> # IMD_STATS_1 value' + IMD_STATS_1);
        if (IMD_STATS_1.contains(imdStat)) {
            //system.debug('the # enter vishnu value');
            a.Price__c = u.Price__c;
            a.Discount_Percent__c = u.Discount_Percent__c;
            a.Flat_Rate__c = u.Flat_Rate__c;
            //a.Expected_production__c = n2z(u.Expected_production__c);
            system.debug('##before update Expected Production'+u.Expected_production__c);
            exptprd = n2z(u.Expected_production__c);
	    	mthexptprd = round(exptprd / 12, 0);
	    	a.Expected_production__c = z2n(mthexptprd);
        }
        else{
           mthexptprd = n2z(a.Expected_production__c);
           a.Discount_Percent__c = u.Discount_Percent__c;
           a.Flat_Rate__c = u.Flat_Rate__c;    
        }
        Decimal prd = n2z(a.Production__c);
        // Set the Expected_production__c on the parent IRF_Monthly_Data__c record
        if (a.IRF_Monthly_Data__c != null) {
            IRF_Monthly_Data__c imdToUpdate = new IRF_Monthly_Data__c(Id = a.IRF_Monthly_Data__c);
            //imdToUpdate.Expected_production__c = exptprd;
	    	imdToUpdate.Expected_production__c = mthexptprd;
            system.debug('###before update Expected Production'+imdToUpdate.Expected_production__c);
            imdToUpdate.Production__c = prd;
            system.debug('###before update Production'+imdToUpdate.Production__c);
            update imdToUpdate;
        } //added by vishnu
        
        
        Decimal ppu = n2z(a.Price__c);
        Decimal bval1  = round(prd * ppu, 2); debug('bval1 = ' + bval1);
        //a.Amount__c = z2n(prd * ppu);
        a.Sub_Total__c = z2n(prd * ppu);
        a.Expected_monthly_revenue__c = z2n(mthexptprd * ppu);//  Added by Vishnu
        Decimal dprcnt = n2z(a.Discount_Percent__c); debug('dprcnt = ' + dprcnt);
        Decimal fltchrg = n2z(a.Flat_Rate__c); debug('fltchrg = ' + fltchrg); // Added by Vinu
        Decimal bval2  = round(bval1 * dprcnt / 100, 2); debug('bval2 = ' + bval2); // Added by Vinu
        a.Amount__c = z2n(bval1 - bval2 - fltchrg); // Added By Vinu
        debug('a.Amount__c = ' + a.Amount__c); // Added by Vinu
    }

    public static void setImuTotl(IRF_Monthly_Data d_hdr, List<IRF_Monthly_Unit> alist,
                                  IRF_Monthly_Unit t_unt) {
        IRF_Monthly_Data__c imd = d_hdr.sobj; String imdId = imd.Id;
        IRF_Monthly_Unit__c imu = t_unt.sobj; imu.Amount__c = 0;
        Map<String, IRF_Monthly_Unit__c> amap = getImus(imdId);     
        for (IRF_Monthly_Unit a : alist) {
            if (a.sobj.IRF_Unit__c == null) {continue;}
            amap.put(a.sobj.IRF_Unit__c, a.sobj);
        }
        for (IRF_Monthly_Unit__c u : amap.values()) {
            debug('getImuTotl :   u = ' +   u);
            //if(u.IRF_Unit__r != null && u.IRF_Unit__r.MFD__c) {continue;}
            if(u.IRF_Unit__r != null && u.MFD__c) {continue;}
            imu.Amount__c += n2z(u.Amount__c);
            debug('getImuTotl : imu = ' + imu);
        }
        debug('getImuTotl : t_unt = ' + t_unt);
    }
// --------------------------------------------------------------------------------------------------------------
    private static String upsertImdMats(List<IRF_Monthly_Material> mats, Id imdId) {
        if (mats == null || mats.isEmpty()) {return null;}
        IRF_Monthly_Material__c m; List<IRF_Monthly_Material__c> mlist = new List<IRF_Monthly_Material__c>();
        for (IRF_Monthly_Material mat : mats) {
            System.debug('Material Info>'+mat);
            if (mat.recNum == null) {continue;}
            m = mat.sobj; if (m.IRF_Monthly_Data__c == null) {m.IRF_Monthly_Data__c = imdId;}
            m.IRF_Material__r = null; mlist.add(m);
            debug('upsertImdMats : m = ' + m);
        }
        try {upsert mlist;} catch(Exception e) {return 'Failed to Upsert IMD Materials : ' + e.getMessage();}
        return null;
    }

    private static String upsertImdUnts(List<IRF_Monthly_Unit> unts, Id imdId) {
        if (unts == null || unts.isEmpty()) {return null;}
        IRF_Monthly_Unit__c u; List<IRF_Monthly_Unit__c> ulist = new List<IRF_Monthly_Unit__c>();
        for (IRF_Monthly_Unit unt : unts) {
            if (unt.recNum == null) {continue;}
            u = unt.sobj; if (u.IRF_Monthly_Data__c == null) {u.IRF_Monthly_Data__c = imdId;}
            //u.IRF_Unit__r = null; 
            ulist.add(u);
            debug('upsertImdUnts : u = ' + u);
        }
        try {upsert ulist;} catch(Exception e) {return 'Failed to Upsert IMD Units : ' + e.getMessage();}
        return null;
    }

    private static String deleteImdMats(Set<String> ids, String imdStat) {
        String s = null;
        if (ids == null || ids.isEmpty() || String.isBlank(imdStat) || IMD_STATS_2.contains(imdStat)) {return s;}
        List<IRF_Monthly_Material__c> mlist = [select Id from IRF_Monthly_Material__c where Id in :ids];
        s = deleteSObjs(mlist); if (s == null) {return s;} return 'Failed to Delete IMD Materials : ' + s;
    }

    public static String saveImd(IRF_Monthly_Data irfmd, List<IRF_Monthly_Material> mats,
                                 List<IRF_Monthly_Unit> unts, Set<String> mfdMatIds) {
        System.debug('--IRF_Monthly_Data--' + JSON.serialize(irfmd));
        System.debug('--IRF_Monthly_Material--' + JSON.serialize(mats));
        System.debug('--IRF_Monthly_Unit--' + JSON.serialize(unts));
        System.debug('--mfdMatIds--' + JSON.serialize(mfdMatIds));
        IRF_Monthly_Data__c imd = irfmd.sobj; debug('saveImd : imd = ' + imd);
        if (imd == null) {return 'Invalid IMD';} String s = null;
      
        System.debug('--IRF_Monthly_Data--' + JSON.serialize(imd));
                                     
        updateIRFMonthlyMaterials(imd, mats, unts);
        try {upsert imd;} catch(Exception e) {s = 'Failed to Upsert IMD : ' + e.getMessage();}
        String imdId = imd.Id, imdStat = imd.Status__c;
        if (s == null) {s = upsertImdMats(mats, imdId);}
        if (s == null) {s = upsertImdUnts(unts, imdId);}
        if (s == null) {s = deleteImdMats(mfdMatIds, imdStat);}
        return s;
    }

    private static void updateIRFMonthlyMaterials(IRF_Monthly_Data__c imd, List<IRF_Monthly_Material> mats, List<IRF_Monthly_Unit> unts)
    {   System.debug(JSON.serialize(unts));
     	System.debug(JSON.serialize(imd));
     	System.debug(JSON.serialize(mats));
        for(IRF_Monthly_Material imm : mats){    
            IRF_Monthly_Material__c a = imm.sobj;        
            Decimal estQty = n2z(a.Estimated_Quantity__c); debug('estQty = ' + estQty);
            Decimal cnsInv = n2z(a.Consumed_Inventory__c); debug('cnsInv = ' + cnsInv);
            Decimal ctrprice = n2z(a.Contract_Price__c);//added by vishnu
            Decimal mthAvg = round(estQty / 12, 0); 
            a.Projected_Monthly_Average__c = z2n(mthAvg);
            a.Inventory_Variance__c = z2n(cnsInv - mthAvg);
            IRF_Material__c m = a.IRF_Material__r;
            system.debug('the value for IRF_Material__r'+ m);

            Boolean EforVarcal = m.Eligible_for_Variance_calculation__c == null?false:m.Eligible_for_Variance_calculation__c; //added by vishnu
            system.debug('the value of EforVarcal' + m.Eligible_for_Variance_calculation__c);

            if(EforVarcal){
                system.debug('the value of unitIndex' + a.Related_Unit__c);
                Integer unitIndex = Integer.valueOf(a.Related_Unit__c);
                system.debug('the value of unitIndex' + unitIndex);
                unitIndex = unitIndex-1;
                Decimal Exprd = n2z(unts[unitIndex]?.sobj?.IRF_Unit__r?.Expected_production__c);//  test added by vishnu new
                system.debug('##the value of Exprd' + imd.Expected_production__c);
                system.debug('##the value of Exprd' + Exprd);
                Decimal myprd = n2z(unts[unitIndex]?.sobj?.Production__c); //test added by vishnu
                system.debug('##the myprd value is'+ imd.Production__c);
                system.debug('##the myprd value is'+ myprd);
                String Cntofunts = a.Related_Unit__c; //added by vishnu
                Decimal usgexp = 0;//added by vishnu
                Decimal usgact = 0;//added by vishnu
               
                system.debug('the value of Cntofunts' + a.Related_Unit__c);

                if(Exprd != null && Exprd != 0){
                    usgexp = round(estQty / Exprd, 4); }//added by vishnu
                a.Usage_Expected_lbs_ton__c = z2n(usgexp);// test added by vishnu

                if(myprd != null && myprd != 0){
                    usgact = round(cnsInv / myprd, 4); }//added by vishnu

                a.Usage_Actual_lbs_ton__c = z2n(usgact);// test added by vishnu
                Decimal UsgVar = n2z(usgexp - usgact) ;//added by vishnu
                a.Usage_Variance_lbs_ton__c = z2n(UsgVar); // added by vishnu
                
                 Decimal invavr = z2n(myprd*UsgVar);
                a.Variance_Inv__c = invavr; //added by vishnu

                Decimal UsgDollerpermn = n2z(UsgVar * ctrprice * myprd); //added by vishnu
                a.Dollar_per_month__c = z2n(UsgDollerpermn); //added by vishnu
                system.debug('###the value of usgact' + a.Usage_Expected_lbs_ton__c);
            }
        }
    }

}
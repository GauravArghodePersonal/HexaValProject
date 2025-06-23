public class Rolling_Product_Sales_Info {

    public class RPSI_Field {
        String value, style;
        public RPSI_Field() {this('','');}
        public RPSI_Field(String v, String s) {value = v; style = s;}
        
        public String getStyle() {return style;}
        public void setStyle(String s) {style = s;}

        public String getValue() {return value;}
        public void setValue(String s) {value = s;}
    }
    
	public class RPSI_Line {
	    @AuraEnabled public Integer recNum        {get; private set;}     
	    @AuraEnabled public String matName        {get; private set;}
	    @AuraEnabled public String   matId        {get; private set;}
	    @AuraEnabled public String rpsView        {get; private set;}
	    
	    @AuraEnabled public String style_Month_01 {get; private set;}
	    @AuraEnabled public String style_Month_02 {get; private set;}
	    @AuraEnabled public String style_Month_03 {get; private set;}
	    @AuraEnabled public String style_Month_04 {get; private set;}
	    @AuraEnabled public String style_Month_05 {get; private set;}
	    @AuraEnabled public String style_Month_06 {get; private set;}
	    @AuraEnabled public String style_Month_07 {get; private set;}
	    @AuraEnabled public String style_Month_08 {get; private set;}
	    @AuraEnabled public String style_Month_09 {get; private set;}
	    @AuraEnabled public String style_Month_10 {get; private set;}
	    @AuraEnabled public String style_Month_11 {get; private set;}
	    @AuraEnabled public String style_Month_12 {get; private set;}
	    @AuraEnabled public String style_Month_13 {get; private set;}
	    @AuraEnabled public String style_FYTD     {get; private set;}
	    @AuraEnabled public String style_PFYTD    {get; private set;}
	    @AuraEnabled public String style_YTD_Var  {get; private set;}
	    @AuraEnabled public String style_FYF      {get; private set;}
	    @AuraEnabled public String style_PFYF     {get; private set;}
	    
	    @AuraEnabled public String value_Month_01 {get; private set;}
	    @AuraEnabled public String value_Month_02 {get; private set;}
	    @AuraEnabled public String value_Month_03 {get; private set;}
	    @AuraEnabled public String value_Month_04 {get; private set;}
	    @AuraEnabled public String value_Month_05 {get; private set;}
	    @AuraEnabled public String value_Month_06 {get; private set;}
	    @AuraEnabled public String value_Month_07 {get; private set;}
	    @AuraEnabled public String value_Month_08 {get; private set;}
	    @AuraEnabled public String value_Month_09 {get; private set;}
	    @AuraEnabled public String value_Month_10 {get; private set;}
	    @AuraEnabled public String value_Month_11 {get; private set;}
	    @AuraEnabled public String value_Month_12 {get; private set;}
	    @AuraEnabled public String value_Month_13 {get; private set;}
	    @AuraEnabled public String value_FYTD     {get; private set;}
	    @AuraEnabled public String value_PFYTD    {get; private set;}
	    @AuraEnabled public String value_YTD_Var  {get; private set;}
	    @AuraEnabled public String value_FYF      {get; private set;}
	    @AuraEnabled public String value_PFYF     {get; private set;}
	    
	    public RPSI_Line(
	           Rolling_Product_Sales_Info__c rpsi, String rv, Integer n) {
	        rpsView = rv; recNum = n;
	        if (String.isBlank(rpsi.Material2__c)) {
	            matId   = rpsi.Material_General_Data2__c; 
	            matName = rpsi.Material_General_Data2__r.Name;} else {
	            matId   = rpsi.Material2__c; 
	            matName = rpsi.Material2__r.Name;}
	              
	        Rolling_Product_Sales_Info.RPSI_Field f;
	
	        f = Rolling_Product_Sales_Info.getField(rpsi, rpsView, '01');
	        style_Month_01 = f.getStyle(); value_Month_01 = f.getValue(); 
	
	        f = Rolling_Product_Sales_Info.getField(rpsi, rpsView, '02');
	        style_Month_02 = f.getStyle(); value_Month_02 = f.getValue(); 
	
	        f = Rolling_Product_Sales_Info.getField(rpsi, rpsView, '03');
	        style_Month_03 = f.getStyle(); value_Month_03 = f.getValue(); 
	
	        f = Rolling_Product_Sales_Info.getField(rpsi, rpsView, '04');
	        style_Month_04 = f.getStyle(); value_Month_04 = f.getValue(); 
	
	        f = Rolling_Product_Sales_Info.getField(rpsi, rpsView, '05');
	        style_Month_05 = f.getStyle(); value_Month_05 = f.getValue(); 
	
	        f = Rolling_Product_Sales_Info.getField(rpsi, rpsView, '06');
	        style_Month_06 = f.getStyle(); value_Month_06 = f.getValue(); 
	
	        f = Rolling_Product_Sales_Info.getField(rpsi, rpsView, '07');
	        style_Month_07 = f.getStyle(); value_Month_07 = f.getValue(); 
	
	        f = Rolling_Product_Sales_Info.getField(rpsi, rpsView, '08');
	        style_Month_08 = f.getStyle(); value_Month_08 = f.getValue(); 
	
	        f = Rolling_Product_Sales_Info.getField(rpsi, rpsView, '09');
	        style_Month_09 = f.getStyle(); value_Month_09 = f.getValue(); 
	
	        f = Rolling_Product_Sales_Info.getField(rpsi, rpsView, '10');
	        style_Month_10 = f.getStyle(); value_Month_10 = f.getValue(); 
	
	        f = Rolling_Product_Sales_Info.getField(rpsi, rpsView, '11');
	        style_Month_11 = f.getStyle(); value_Month_11 = f.getValue(); 
	
	        f = Rolling_Product_Sales_Info.getField(rpsi, rpsView, '12');
	        style_Month_12 = f.getStyle(); value_Month_12 = f.getValue(); 
	
	        f = Rolling_Product_Sales_Info.getField(rpsi, rpsView, '13');
	        style_Month_13 = f.getStyle(); value_Month_13 = f.getValue(); 
	
	        f = Rolling_Product_Sales_Info.getField(rpsi, rpsView, 'FYTD');
	        style_FYTD = f.getStyle(); value_FYTD = f.getValue(); 
	
	        f = Rolling_Product_Sales_Info.getField(rpsi, rpsView, 'PFYTD');
	        style_PFYTD = f.getStyle(); value_PFYTD = f.getValue(); 
	
	        f = Rolling_Product_Sales_Info.getVariance(rpsi, rpsView, 'FYTD', 'PFYTD');
	        style_YTD_Var = f.getStyle(); value_YTD_Var = f.getValue(); 
	
	        f = Rolling_Product_Sales_Info.getField(rpsi, rpsView, 'FYF');
	        style_FYF = f.getStyle(); value_FYF = f.getValue(); 
	
	        f = Rolling_Product_Sales_Info.getField(rpsi, rpsView, 'PFYF');
	        style_PFYF = f.getStyle(); value_PFYF = f.getValue(); 
	    }
	    
	}

    public final static CustomSettings__c CUSTOM_SETTINGS;
    
    public final static Integer ARRAY_SIZE = 14;
    
    public final static Map<Integer,String> MNTH_LBL_MAP = new Map<Integer,String>{
        1 => 'JAN', 2 => 'FEB', 3 => 'MAR',  4 => 'APR',  5 => 'MAY',  6 => 'JUN',
        7 => 'JUL', 8 => 'AUG', 9 => 'SEP', 10 => 'OCT', 11 => 'NOV', 12 => 'DEC'};
        
    public final static Set<String> RPSI_FIELDS = getRpsiFields();
    
    public final static Integer MAX_RECS = 50000;
    public final static Integer PAGE_SIZE = 15;

    public final static Double KG2LB = 2.20462262185;
    public final static String DELIM = '-';
    public final static String UOMKG = 'KG';
    public final static String UOMLB = 'LB';
    public final static String NONE  = '-- None --';

    public final static String DC_ASI  = '50';

    public final static String GM_GP_AMOUNT    = 'GM_';
    public final static String GM_GP_PERCENT   = 'GMpct_';
    public final static String PLAN_AMOUNT     = 'Plan_Amount_';
    public final static String PLAN_VOLUME_KG  = 'Plan_Volume_in_KG_';
    public final static String PLAN_VOLUME_LB  = 'Plan_Volume_in_LB_';
    public final static String SALES_AMOUNT    = 'Amount_';
    public final static String SALES_VOLUME_GL = 'Volume_in_GL_';
    public final static String SALES_VOLUME_KG = 'Volume_in_KG_';
    public final static String SALES_VOLUME_LB = 'Volume_in_LB_';
    public final static String SALES_VOLUME_PT = 'Volume_in_PT_';
    public final static String SALES_VOLUME_UN = 'Volume_in_UN_';

    public final static String NUM_STYLE = 'm-NUM_STYLE ;text-align: right;';
    public final static String NEG_STYLE = 'm-NEG_STYLE ;text-align: right; color: red;';//NUM_STYLE + ' color: red;m-NEG_STYLE';
    public final static String ZRO_STYLE = 'm-ZRO_STYLE ;text-align: center;';
    
    public final static String ACCTYPE_HIER = 'HIER';
    public final static String ACCTYPE_SHIP = 'SHIP';
    public final static String ACCTYPE_SOLD = 'SOLD';
    
    public final static String RECTYPE_ACC = 'ACC';
    public final static String RECTYPE_MAT = 'MAT';

    public final static Boolean RUN_BATCH_JOBS_IN_SEQUENCE;
    
    public final static Map<String, String> ACC_TYPE_MAP = new Map<String, String>{
    	Account_Partner_Functions.ACC_TYPE_CHERKY => ACCTYPE_HIER,
        Account_Partner_Functions.ACC_TYPE_SHIPTO => ACCTYPE_SHIP,
        Account_Partner_Functions.ACC_TYPE_SOLDTO => ACCTYPE_SOLD
    };

    public final static Set<String> REC_TYPES1 = new Set<String>{
        'CM' 
    };
    
    public final static Set<String> REC_TYPES2 = new Set<String>{
        'FYF', 'FYTD', 'PFYF', 'PFYTD' 
    };
    
    public final static List<String> FLD_LIST1 = new List<String>{
        GM_GP_AMOUNT, GM_GP_PERCENT, SALES_AMOUNT, 
        SALES_VOLUME_GL, SALES_VOLUME_KG, SALES_VOLUME_LB,
        SALES_VOLUME_PT, SALES_VOLUME_UN 
    };
    
    public final static List<String> FLD_LIST3 = new List<String>{
        PLAN_AMOUNT, PLAN_VOLUME_KG, PLAN_VOLUME_LB 
    };
    
    public final static Set<String> NO_VAR_VIEWS = new Set<String>{
        PLAN_AMOUNT, PLAN_VOLUME_KG, PLAN_VOLUME_LB 
    };
    
    public final static Date START_DATE, END_DATE;
    
    public final static Date FYTD_StartDate, PFYTD_StartDate, 
                             FYTD_EndDate, PFYTD_EndDate;

    public final static Date FYF_StartDate, PFYF_StartDate, 
                             FYF_EndDate, PFYF_EndDate;
    
    public final static String START_FP;
    public final static String END_FP;
    
    public final static String FYF_Label;
    public final static String PFYF_Label;
    public final static String FYTD_Label;
    public final static String PFYTD_Label;

    public final static String[] MONTH_LABELS;

    static {
        CUSTOM_SETTINGS = CustomSettings__c.getOrgDefaults();
        RUN_BATCH_JOBS_IN_SEQUENCE = CUSTOM_SETTINGS.BW_Data_Batch_Sequence__c;
        
        START_DATE = getStartDate();
        END_DATE = START_DATE.addMonths(-12);

        FYTD_EndDate = START_DATE; PFYTD_EndDate = END_DATE;
        Integer y = getFiscalYear(START_DATE);

        FYF_StartDate = getFYF_StartDate(START_DATE);
        FYTD_StartDate = FYF_StartDate;

        PFYF_StartDate = getPFYF_StartDate(START_DATE);
        PFYTD_StartDate = PFYF_StartDate;

        FYF_EndDate = getFYF_EndDate(START_DATE);
        PFYF_EndDate = getPFYF_EndDate(START_DATE);

        START_FP = getFiscalPeriod(START_DATE);
        END_FP   = getFiscalPeriod(END_DATE);
    
        FYF_Label   = getString('FY Full',  FYF_StartDate,   FYF_EndDate);
        PFYF_Label  = getString('PFY Full', PFYF_StartDate,  PFYF_EndDate);
        FYTD_Label  = getString('FYTD',     FYTD_StartDate,  FYTD_EndDate);
        PFYTD_Label = getString('PFYTD',    PFYTD_StartDate, PFYTD_EndDate);

        MONTH_LABELS = getMonthLabels();
    }
    
    public final static String RPSI_QRY1 = ''
        + 'select Id, Name, CurrencyIsoCode, Account__c, Account_Type__c, '
        + 'Material2__c, Material2__r.Name, Month_01__c, '
        + 'Material_General_Data2__c, Material_General_Data2__r.Name, ' 

        + 'Amount_FYF__c, Amount_FYTD__c, Amount_PFYF__c, Amount_PFYTD__c, '
        + 'Amount_Month_01__c, Amount_Month_02__c, Amount_Month_03__c, '
        + 'Amount_Month_04__c, Amount_Month_05__c, Amount_Month_06__c, '
        + 'Amount_Month_07__c, Amount_Month_08__c, Amount_Month_09__c, '
        + 'Amount_Month_10__c, Amount_Month_11__c, Amount_Month_12__c, '
        + 'Amount_Month_13__c, '

        + 'Currency_Month_01__c, Currency_Month_02__c, Currency_Month_03__c, '
        + 'Currency_Month_04__c, Currency_Month_05__c, Currency_Month_06__c, '
        + 'Currency_Month_07__c, Currency_Month_08__c, Currency_Month_09__c, '
        + 'Currency_Month_10__c, Currency_Month_11__c, Currency_Month_12__c, '
        + 'Currency_Month_13__c, '

        + 'GM_FYF__c, GM_FYTD__c, GM_PFYF__c, GM_PFYTD__c, '
        + 'GM_Month_01__c, GM_Month_02__c, GM_Month_03__c, GM_Month_04__c, '
        + 'GM_Month_05__c, GM_Month_06__c, GM_Month_07__c, GM_Month_08__c, '
        + 'GM_Month_09__c, GM_Month_10__c, GM_Month_11__c, GM_Month_12__c, '
        + 'GM_Month_13__c, '

        + 'GMpct_FYF__c, GMpct_FYTD__c, GMpct_PFYF__c, GMpct_PFYTD__c, '
        + 'GMpct_Month_01__c, GMpct_Month_02__c, GMpct_Month_03__c, GMpct_Month_04__c, '
        + 'GMpct_Month_05__c, GMpct_Month_06__c, GMpct_Month_07__c, GMpct_Month_08__c, '
        + 'GMpct_Month_09__c, GMpct_Month_10__c, GMpct_Month_11__c, GMpct_Month_12__c, '
        + 'GMpct_Month_13__c, '

        + 'Label_Month_01__c, Label_Month_02__c, Label_Month_03__c, Label_Month_04__c, '
        + 'Label_Month_05__c, Label_Month_06__c, Label_Month_07__c, Label_Month_08__c, '
        + 'Label_Month_09__c, Label_Month_10__c, Label_Month_11__c, Label_Month_12__c, '
        + 'Label_Month_13__c, '

        + 'Plan_Amount_FYF__c, Plan_Amount_FYTD__c, '
        + 'Plan_Amount_PFYF__c, Plan_Amount_PFYTD__c, '
        + 'Plan_Amount_01__c, Plan_Amount_02__c, Plan_Amount_03__c, Plan_Amount_04__c, '
        + 'Plan_Amount_05__c, Plan_Amount_06__c, Plan_Amount_07__c, Plan_Amount_08__c, '
        + 'Plan_Amount_09__c, Plan_Amount_10__c, Plan_Amount_11__c, Plan_Amount_12__c, '
        + 'Plan_Amount_13__c, '

        + 'Plan_Volume_in_KG_FYF__c, Plan_Volume_in_KG_FYTD__c, '
        + 'Plan_Volume_in_KG_PFYF__c, Plan_Volume_in_KG_PFYTD__c, '
        + 'Plan_Volume_in_KG_01__c, Plan_Volume_in_KG_02__c, Plan_Volume_in_KG_03__c, '
        + 'Plan_Volume_in_KG_04__c, Plan_Volume_in_KG_05__c, Plan_Volume_in_KG_06__c, '
        + 'Plan_Volume_in_KG_07__c, Plan_Volume_in_KG_08__c, Plan_Volume_in_KG_09__c, '
        + 'Plan_Volume_in_KG_10__c, Plan_Volume_in_KG_11__c, Plan_Volume_in_KG_12__c, '
        + 'Plan_Volume_in_KG_13__c, '

        + 'Plan_Volume_in_LB_FYF__c, Plan_Volume_in_LB_FYTD__c, '
        + 'Plan_Volume_in_LB_PFYF__c, Plan_Volume_in_LB_PFYTD__c, '
        + 'Plan_Volume_in_LB_01__c, Plan_Volume_in_LB_02__c, Plan_Volume_in_LB_03__c, '
        + 'Plan_Volume_in_LB_04__c, Plan_Volume_in_LB_05__c, Plan_Volume_in_LB_06__c, '
        + 'Plan_Volume_in_LB_07__c, Plan_Volume_in_LB_08__c, Plan_Volume_in_LB_09__c, '
        + 'Plan_Volume_in_LB_10__c, Plan_Volume_in_LB_11__c, Plan_Volume_in_LB_12__c, '
        + 'Plan_Volume_in_LB_13__c, '

        + 'Volume_in_GL_FYF__c, Volume_in_GL_FYTD__c, '
        + 'Volume_in_GL_PFYF__c, Volume_in_GL_PFYTD__c, '
        + 'Volume_in_GL_Month_01__c, Volume_in_GL_Month_02__c, Volume_in_GL_Month_03__c, '
        + 'Volume_in_GL_Month_04__c, Volume_in_GL_Month_05__c, Volume_in_GL_Month_06__c, '
        + 'Volume_in_GL_Month_07__c, Volume_in_GL_Month_08__c, Volume_in_GL_Month_09__c, '
        + 'Volume_in_GL_Month_10__c, Volume_in_GL_Month_11__c, Volume_in_GL_Month_12__c, '
        + 'Volume_in_GL_Month_13__c, '

        + 'Volume_in_KG_FYF__c, Volume_in_KG_FYTD__c, '
        + 'Volume_in_KG_PFYF__c, Volume_in_KG_PFYTD__c, '
        + 'Volume_in_KG_Month_01__c, Volume_in_KG_Month_02__c, '
        + 'Volume_in_KG_Month_03__c, Volume_in_KG_Month_04__c, Volume_in_KG_Month_05__c, '
        + 'Volume_in_KG_Month_06__c, Volume_in_KG_Month_07__c, Volume_in_KG_Month_08__c, '
        + 'Volume_in_KG_Month_09__c, Volume_in_KG_Month_10__c, Volume_in_KG_Month_11__c, '
        + 'Volume_in_KG_Month_12__c, Volume_in_KG_Month_13__c, '

        + 'Volume_in_LB_FYF__c, Volume_in_LB_FYTD__c, '
        + 'Volume_in_LB_PFYF__c, Volume_in_LB_PFYTD__c, '
        + 'Volume_in_LB_Month_01__c, Volume_in_LB_Month_02__c, '
        + 'Volume_in_LB_Month_03__c, Volume_in_LB_Month_04__c, Volume_in_LB_Month_05__c, '
        + 'Volume_in_LB_Month_06__c, Volume_in_LB_Month_07__c, Volume_in_LB_Month_08__c, '
        + 'Volume_in_LB_Month_09__c, Volume_in_LB_Month_10__c, Volume_in_LB_Month_11__c, '
        + 'Volume_in_LB_Month_12__c, Volume_in_LB_Month_13__c, '

        + 'Volume_in_PT_FYF__c, Volume_in_PT_FYTD__c, '
        + 'Volume_in_PT_PFYF__c, Volume_in_PT_PFYTD__c, '
        + 'Volume_in_PT_Month_01__c, Volume_in_PT_Month_02__c, Volume_in_PT_Month_03__c, '
        + 'Volume_in_PT_Month_04__c, Volume_in_PT_Month_05__c, Volume_in_PT_Month_06__c, '
        + 'Volume_in_PT_Month_07__c, Volume_in_PT_Month_08__c, Volume_in_PT_Month_09__c, '
        + 'Volume_in_PT_Month_10__c, Volume_in_PT_Month_11__c, Volume_in_PT_Month_12__c, '
        + 'Volume_in_PT_Month_13__c, '

        + 'Volume_in_UN_FYF__c, Volume_in_UN_FYTD__c, '
        + 'Volume_in_UN_PFYF__c, Volume_in_UN_PFYTD__c, '
        + 'Volume_in_UN_Month_01__c, Volume_in_UN_Month_02__c, Volume_in_UN_Month_03__c, '
        + 'Volume_in_UN_Month_04__c, Volume_in_UN_Month_05__c, Volume_in_UN_Month_06__c, '
        + 'Volume_in_UN_Month_07__c, Volume_in_UN_Month_08__c, Volume_in_UN_Month_09__c, '
        + 'Volume_in_UN_Month_10__c, Volume_in_UN_Month_11__c, Volume_in_UN_Month_12__c, '
        + 'Volume_in_UN_Month_13__c  '

        + 'from Rolling_Product_Sales_Info__c';
        
    public final static String RPSI_OBY1 = ' order by '
        + 'Material_General_Data2__r.Name, Material_General_Data2__c, '
        + 'Material2__r.Name, Material2__r.Id ';

// -------------------------------------------------------------------------------------------
        
    public final static String ASF_QRY1 = ''
        + 'select Id, CurrencyIsoCode, Account__c, Account__r.Account_Number__c,' 
        + '       CustomerType__c, Date_Range_Label__c, FiscalPeriod__c, GM__c, GMpct__c,' 
        + '       Sales_Amount__c, Sales_Amount_Company__c, Sales_Amount_Local__c,'
        + '       Sales_Volume_in_GALs__c, Sales_Volume_in_KGs__c, Sales_Volume_in_LBs__c,' 
        + '       Sales_Volume_in_PTs__c, Sales_Volume_in_UNs__c' 
        + '  from Account_Sales_Figure__c';
        
    public final static String ASF_OBY1 = ' order by '
        + 'CustomerType__c, Account__c, FiscalPeriod__c';
        
// -------------------------------------------------------------------------------------------
        
    public final static String ASP_QRY1 = ''
        + 'select Id, CurrencyIsoCode, Account__c, Account__r.Account_Number__c,' 
        + '       CustomerType__c, FiscalPeriod__c, RecordType__c,' 
        + '       Sales_Amount_Company__c, Sales_Amount_Local__c,'
        + '       Sales_Volume__c, Sales_Volume_UOM__c' 
        + '  from Account_Sales_Plan__c';
        
    public final static String ASP_OBY1 = ' order by '
        + 'CustomerType__c, Account__c, FiscalPeriod__c';
        
// -------------------------------------------------------------------------------------------
        
    public final static String PSF_QRY1 = ''
        + 'select Id, CurrencyIsoCode, Account__c, Account__r.Account_Number__c,' 
        + '       CustomerType__c, Date_Range_Label__c, FiscalPeriod__c, GM__c, GMpct__c,' 
        + '       Material2__c, Material2__r.Material_Number__c,'
        + '       Material_General_Data2__c, Material_General_Data2__r.Material_Number__c,' 
        + '       Sales_Amount__c, Sales_Amount_Company__c, Sales_Amount_Local__c,'
        + '       Sales_Volume_in_GALs__c, Sales_Volume_in_KGs__c, Sales_Volume_in_LBs__c,' 
        + '       Sales_Volume_in_PTs__c, Sales_Volume_in_UNs__c' 
        + '  from Product_Sales_Figure__c';
        
    public final static String PSF_OBY1 = ' order by '
        + 'CustomerType__c, Account__c, Material_General_Data2__c, '
        + 'Material2__c, FiscalPeriod__c';
        
// -------------------------------------------------------------------------------------------
        
    public final static String PSP_QRY1 = ''
        + 'select Id, CurrencyIsoCode, Account__c, Account__r.Account_Number__c,' 
        + '       CustomerType__c, FiscalPeriod__c,' 
        + '       Material__c, Material__r.Material_Number__c, '
        + '       Material_General_Data2__c, Material_General_Data2__r.Material_Number__c,' 
        + '       RecordType__c, Sales_Amount_Company__c, '
        + '       Sales_Amount_Local__c, Sales_Volume__c, Sales_Volume_UOM__c' 
        + '  from Product_Sales_Plan__c';
        
    public final static String PSP_OBY1 = ' order by '
        + 'CustomerType__c, Account__c, Material_General_Data2__c, '
        + 'Material__c, FiscalPeriod__c';
        
// -------------------------------------------------------------------------------------------
        
    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'RPSI : ' + s);
    }
    
    public static Set<String> getRpsiFields() {
		Schema.DescribeSObjectResult dsr = 
		Rolling_Product_Sales_Info__c.sObjectType.getDescribe();
		Map<String, Schema.SObjectField> fmap = dsr.fields.getMap();
		return fmap.keySet();
    }

    public static Date getStartDate() {
        Date d = null;
        if (CUSTOM_SETTINGS != null) {d = CUSTOM_SETTINGS.BW_Data_Start_Date__c;}
        if (d == null) {d = System.today().addMonths(-1);}
        return d;
    }
    
    public static Date getStartDate(String fp) {
        Date dt = System.today(); 
        if (String.isBlank(fp) || !fp.isNumeric()) {return dt;}
        Integer y = 0, m = 0, d = 1;
        fp = fp.trim(); Integer n = fp.length();
        if (n > 3) {y = Integer.valueOf(fp.substring(0, 4));}
        if (n > 6) {m = Integer.valueOf(fp.substring(4, 7));}
        if (m < 1 || m > 12 || y < 1970 || y > 2970) {return dt;} 
        if (m < 4) {m += 9; y--;} else {m -= 3;}
        return Date.newInstance(y, m, d);
    }
    
    public static Integer getFiscalYear(Date d) {
        if (d == null) {return 0;}
        Integer m = d.month(), y = d.year();
        if (m < 10) {y -= 1;} return y;
    }
    
    public static Date getFYF_StartDate() {
        return getFYF_StartDate(Date.today());
    }
    
    public static Date getFYF_StartDate(Date d) {
        if (d == null) {return d;}
        Integer y = getFiscalYear(d);
        return Date.newInstance(y, 10, 1);
    }
    
    public static Date getFYF_EndDate() {
        return getFYF_EndDate(Date.today());
    }
    
    public static Date getFYF_EndDate(Date d) {
        if (d == null) {return d;}
        Integer y = getFiscalYear(d);
        return Date.newInstance(y+1, 9, 30);
    }
    
    public static Date getPFYF_StartDate() {
        return getPFYF_StartDate(Date.today());
    }
    
    public static Date getPFYF_StartDate(Date d) {
        if (d == null) {return d;}
        Integer y = getFiscalYear(d);
        return Date.newInstance(y-1, 10, 1);
    }
    
    public static Date getPFYF_EndDate() {
        return getPFYF_EndDate(Date.today());
    }
    
    public static Date getPFYF_EndDate(Date d) {
        if (d == null) {return d;}
        Integer y = getFiscalYear(d);
        return Date.newInstance(y, 9, 30);
    }
    
    public static String getFiscalPeriod(Date d) {
        if (d == null) {return '';}
        Integer m = d.month(), y = d.year();
        if (m > 9) {m -= 9; y++;} else {m += 3;}
        String s = String.valueOf(m);
        s = y + s.leftpad(3).replace(' ', '0');
        return s;
    }
    
    public static Set<String> getFiscalPeriods(String fp) {
        Set<String> aset = new Set<String>();
		Integer y2 = Integer.valueOf(fp.substring(0, 4)), y1 = y2 - 1,
		         m = Integer.valueOf(fp.substring(4));
		for (Integer n = m; n <= 12; n++) {aset.add(getFiscalPeriod(y1, n));}
		for (Integer n = 1; n <=  m; n++) {aset.add(getFiscalPeriod(y2, n));}
		return aset;
    }
    
    private static String getFiscalPeriod(Integer y, Integer m) {
        String s = String.valueOf(m); s = y + s.leftpad(3).replace(' ', '0');
        return s;
    }
    
    public static Integer getMonthsBetween(String fp1, String fp2) {
    	Date d1 = getStartDate(fp1), d2 = getStartDate(fp2);
        return d1.monthsBetween(d2); 
    }
    
    private static String getMM(Integer m) {
    	String s = ''; if (m < 10) {s = '0';} return s + m;
    }
    
    private static String[] getMonthLabels() {
        String[] sa = new String[ARRAY_SIZE]; Date ndate;
        for(Integer i = 1; i < ARRAY_SIZE; i++) {
            ndate = START_DATE.addMonths(1-i);
            sa[i] = MNTH_LBL_MAP.get(ndate.month())+'-'+ndate.year();
        }
        return sa;   
    }
    
    private static Map<String, Double> getUomVolumeMap(String uom, Decimal d) {
    	Double vol = d != null ? d.doubleValue() : null;
    	return getUomVolumeMap(uom, vol);
    }
    
    private static Map<String, Double> getUomVolumeMap(String uom, Double vol) {
    	Map<String, Double> amap = new Map<String, Double>();
    	if (String.isBlank(uom) || vol == null) {return amap;}
        if (uom == UOMKG) {amap.put(UOMLB, vol * KG2LB);} else 
        if (uom == UOMLB) {amap.put(UOMKG, vol / KG2LB);} 
    	amap.put(uom, vol); return amap;
    }
    
    private static void init_RPSI1(Rolling_Product_Sales_Info__c rpsi, String s2) {
        for (String s1 : FLD_LIST1) {rpsi.put(s1 + s2, 0.0);}
    }
    
    private static void init_RPSI3(Rolling_Product_Sales_Info__c rpsi, String s2) {
        for (String s1 : FLD_LIST3) {rpsi.put(s1 + s2, 0.0);}
    }
    
    private static void upsertRPSI(Map<String, Rolling_Product_Sales_Info__c> amap) {
        debug('amap = ' + amap);
        if (amap.isEmpty()) {return;}
        try {upsert amap.values() Key__c;} catch(Exception e) {
            debug('Exception : ' + e.getMessage());
        }
    }
    
// ASF ---------------------- before upsert --------------------------------------------------------------
    
    public static void doBeforeUpsert(List<Account_Sales_Figure__c> alist) {
        Map<String, Double> amap; Set<String> aset = new Set<String>();
        Date d1 = getPFYF_StartDate(), d2 = getFYF_EndDate(), d3 = Date.today().addMonths(-1);
        for (Account_Sales_Figure__c a : alist) {
            a.Name = a.Key__c;
            if (!String.isBlank(a.Account_Number__c)) {
                aset.add(getAccKey(a.Account_Number__c, a));
            }
            if (String.isBlank(a.CustomerType__c)) {a.CustomerType__c = ACCTYPE_SHIP;}
            setFiscalPeriod(a, d1, d2, d3);
            //if (DC_ASI.equals(a.DistChan_Code__c)) {
                if (a.Sales_Amount_Local__c != null) {
                    a.Sales_Amount__c = a.Sales_Amount_Local__c;} else
                if (a.Sales_Amount_Company__c != null) {
                    a.Sales_Amount__c = a.Sales_Amount_Company__c;}

	            amap = getUomVolumeMap(a.Sales_Volume_UOM__c, a.Sales_Volume__c);
	            if (amap.isEmpty()) {continue;}
	            if (amap.containsKey(UOMKG)) {a.Sales_Volume_in_KGs__c = amap.get(UOMKG);} 
	            if (amap.containsKey(UOMLB)) {a.Sales_Volume_in_LBs__c = amap.get(UOMLB);}
            //} 
        }
        Map<String, Account> accmap = getAccountMap(aset);
        String k; Account acc;
        for (Account_Sales_Figure__c a : alist) {
            if (!String.isBlank(a.Account_Number__c)) {
	            k = getAccKey(a.Account_Number__c, a);
	            if (accmap.containsKey(k)) {  
	                acc = accmap.get(k); a.Account__c = acc.Id;
	            }
            }
        }
    }
    
    private static String getAccKey(String accNum, Account_Sales_Figure__c a) {
        String s = accNum;
        s += getString(a.SalesOrg_Code__c);
        s += getString(a.DistChan_Code__c);
        s += getString(a.Division_Code__c);
        return s;
    }
    
    private static void setFiscalPeriod(Account_Sales_Figure__c a, Date d1, Date d2, Date d3) {
        if (DC_ASI.equals(a.DistChan_Code__c) || 
            a.Start_Date__c < d1 || a.End_Date__c > d2) {return;}
        a.FiscalPeriod__c = getFiscalPeriod(d3);
    }

    private static Map<String, Account> getAccountMap(Set<String> aset) {
        Map<String, Account> amap = new Map<String, Account>();
        if (aset.isEmpty()) {return amap;}
        List<Account> alist = [
            select Id, Account_Number__c from Account 
             where Account_Number__c in :aset];
        if (alist == null || alist.isEmpty()) {return amap;}
        for (Account a : alist) {amap.put(a.Account_Number__c, a);} 
        return amap;
    }

// ASF ---------------------- after upsert --------------------------------------------------------------
    
    public static void doAfterUpsert(List<Account_Sales_Figure__c> alist) {
    	//upsertRPSI_ASF(alist, START_FP);
    }
    
    private static List<Account_Sales_Figure__c> getData(
                   List<Account_Sales_Figure__c> alist) {
        Set<Id> aset = new Set<Id>(); String q = ASF_QRY1 + ' where Id in :aset'; 
        for (Account_Sales_Figure__c a : alist) {aset.add(a.Id);}
        List<Account_Sales_Figure__c> blist = Database.query(q);
        return blist;
    }

    public static void upsertRPSI_ASF(List<Account_Sales_Figure__c> alist, String fp2) {
        String fp1, rt, k, s; Integer m; alist = getData(alist);
        Map<String, Rolling_Product_Sales_Info__c> amap = new 
        Map<String, Rolling_Product_Sales_Info__c>();
        Rolling_Product_Sales_Info__c rpsi;
        for (Account_Sales_Figure__c a : alist) {
            fp1 = a.FiscalPeriod__c; rt = a.Date_Range_Label__c;
            if (fp1 != fp2 || String.isBlank(rt)) {continue;}
            m = getMonthsBetween(fp1, fp2);
            if (m < 0 || m > 12) {continue;} s = null;
            if (REC_TYPES2.contains(rt) && m == 0) {s = rt;}
            if (s == null) {continue;} s += '__c';
            k = getRecKey(a); 
            if (amap.containsKey(k)) {rpsi = amap.get(k);} else {
                rpsi = getRPSI_ASF(a, fp2, k); amap.put(k, rpsi);}
            setRPSI_ASF(s, a, rpsi);
        }
        upsertRPSI(amap);
    }

    private static String getRecKey(Account_Sales_Figure__c a) {
        //return a.CustomerType__c + DELIM + a.Account__r.Account_Number__c;
        return a.Account__r.Account_Number__c + DELIM + a.CustomerType__c;
    }
    
    private static Rolling_Product_Sales_Info__c getRPSI_ASF(Account_Sales_Figure__c asf,
                                                             String fp, String k) {
        Rolling_Product_Sales_Info__c a = new Rolling_Product_Sales_Info__c();
        a.CurrencyIsoCode = asf.CurrencyIsoCode; a.Account_Type__c = asf.CustomerType__c;
        a.Month_01__c = fp; a.Account__c = asf.Account__c; a.Record_Type__c = RECTYPE_ACC;  
        a.Key__c = k; a.Name = k;
        return a;
    }
    
    private static void setRPSI_ASF(String s, Account_Sales_Figure__c asf,
                                    Rolling_Product_Sales_Info__c rpsi) {
        String f;
        try {
            init_RPSI1(rpsi, s);
            f = GM_GP_AMOUNT + s;    rpsi.put(f, asf.GM__c);
            f = GM_GP_PERCENT + s;   rpsi.put(f, asf.GMpct__c);
            f = SALES_AMOUNT + s;    rpsi.put(f, asf.Sales_Amount__c);
            f = SALES_VOLUME_GL + s; rpsi.put(f, asf.Sales_Volume_in_GALs__c);
            f = SALES_VOLUME_KG + s; rpsi.put(f, asf.Sales_Volume_in_KGs__c);
            f = SALES_VOLUME_LB + s; rpsi.put(f, asf.Sales_Volume_in_LBs__c);
            f = SALES_VOLUME_PT + s; rpsi.put(f, asf.Sales_Volume_in_PTs__c);
            f = SALES_VOLUME_UN + s; rpsi.put(f, asf.Sales_Volume_in_UNs__c);
        } catch (Exception e) {debug('Exception : ' + e.getMessage());}
    }
    
// ASP -------------------------------------------------------------------------------------------------------
    
    public static void doAfterUpsert(List<Account_Sales_Plan__c> alist) {
    	//upsertRPSI_ASP(alist, START_FP);
    }
    
    private static List<Account_Sales_Plan__c> getData(
                   List<Account_Sales_Plan__c> alist) {
        Set<Id> aset = new Set<Id>(); String q = ASP_QRY1 + ' where Id in :aset'; 
        for (Account_Sales_Plan__c a : alist) {aset.add(a.Id);}
        List<Account_Sales_Plan__c> blist = Database.query(q);
        return blist;
    }

    public static void upsertRPSI_ASP(List<Account_Sales_Plan__c> alist, String fp2) {
        String fp1, rt, k, s; Integer m; alist = getData(alist);
        Map<String, Rolling_Product_Sales_Info__c> amap = new 
        Map<String, Rolling_Product_Sales_Info__c>();
        Rolling_Product_Sales_Info__c rpsi;
        for (Account_Sales_Plan__c a : alist) {
            fp1 = a.FiscalPeriod__c; rt = a.RecordType__c;
            if (fp1 != fp2 || String.isBlank(rt)) {continue;}
            m = getMonthsBetween(fp1, fp2);
            if (m < 0 || m > 12) {continue;} s = null;
            if (REC_TYPES2.contains(rt) && m == 0) {s = rt;}
            if (s == null) {continue;} s += '__c';
            k = getRecKey(a);
            if (amap.containsKey(k)) {rpsi = amap.get(k);} else {
                rpsi = getRPSI_ASP(a, fp2, k); amap.put(k, rpsi);}
            setRPSI_ASP(s, a, rpsi);
        }
        upsertRPSI(amap);
    }

    private static String getRecKey(Account_Sales_Plan__c a) {
        //return a.CustomerType__c + DELIM + a.Account__r.Account_Number__c;
        return a.Account__r.Account_Number__c + DELIM + a.CustomerType__c;
    }
    
    private static Rolling_Product_Sales_Info__c getRPSI_ASP(Account_Sales_Plan__c asp,
                                                             String fp, String k) {
        Rolling_Product_Sales_Info__c a = new Rolling_Product_Sales_Info__c();
        a.CurrencyIsoCode = asp.CurrencyIsoCode; a.Account_Type__c = asp.CustomerType__c;
        a.Month_01__c = fp; a.Account__c = asp.Account__c; a.Record_Type__c = RECTYPE_ACC;
        a.Key__c = k; a.Name = k;
        return a;
    }
    
    private static void setRPSI_ASP(String s, Account_Sales_Plan__c asp,
                                    Rolling_Product_Sales_Info__c rpsi) {
        String f;
        Map<String, Double> amap = getUomVolumeMap(asp.Sales_Volume_UOM__c, asp.Sales_Volume__c);
        try {
            init_RPSI3(rpsi, s);
            f = PLAN_AMOUNT + s; rpsi.put(f, asp.Sales_Amount_Local__c);
            if (amap.containsKey(UOMKG)) {
                f = PLAN_VOLUME_KG + s; rpsi.put(f, amap.get(UOMKG));
            } 
            if (amap.containsKey(UOMLB)) {
                f = PLAN_VOLUME_LB + s; rpsi.put(f, amap.get(UOMLB));
            } 
        } catch (Exception e) {debug('Exception : ' + e.getMessage());}
    }

// PSF -------------------- before upsert --------------------------------------------------------
    
    public static void doBeforeUpsert(List<Product_Sales_Figure__c> alist) {
        Set<String> aset = new Set<String>(), mset = new Set<String>(), 
                    nset = new Set<String>();
        for (Product_Sales_Figure__c a : alist) {
            a.Name = a.Key__c;
            if (!String.isBlank(a.Material_Number__c)) {
                mset.add(getMatKey(a)); nset.add(a.Material_Number__c);
            }
            aset.add(getAccKey(a.Account_Number__c, a));
            if (String.isBlank(a.CustomerType__c)) {a.CustomerType__c = ACCTYPE_SHIP;}
        	if (String.isBlank(a.Date_Range_Label__c)) {
        		a.Date_Range_Label__c = 'CM';}
        	if (String.isBlank(a.FiscalPeriod__c)) {
        		a.FiscalPeriod__c = getFiscalPeriod(a.Month_Year__c);}
            if (a.Sales_Amount__c == null) {
                if (a.Sales_Amount_Local__c != null) {
                    a.Sales_Amount__c = a.Sales_Amount_Local__c;} else 
                if (a.Sales_Amount_Company__c != null) {
                    a.Sales_Amount__c = a.Sales_Amount_Company__c;}
            }
        }
        Map<String, Account> amap = getAccountMap(aset);
        Map<String, Material_Sales_Data2__c> mmap = getMaterialMap(mset);
        Map<String, Material_General_Data2__c> nmap = getMGD2Map(nset);
        String k; Account acc; Material_Sales_Data2__c mat;
        Material_General_Data2__c mgd2;
        for (Product_Sales_Figure__c a : alist) {
            k = getAccKey(a.Account_Number__c, a);
            if (amap.containsKey(k)) {  
                acc = amap.get(k); a.Account__c = acc.Id;
            }
            if (!String.isBlank(a.Material_Number__c)) {
	            k = getMatKey(a);
	            if (mmap.containsKey(k)) {  
	                mat = mmap.get(k); a.Material2__c = mat.Id;
	            }
	            if (nmap.containsKey(a.Material_Number__c)) {
	            	mgd2 = nmap.get(a.Material_Number__c);
	            	a.Material_General_Data2__c = mgd2.Id;
	            }
            }
        }
    }

    private static String getAccKey(String accNum, Product_Sales_Figure__c a) {
        String s = accNum;
        s += getString(a.SalesOrg_Code__c);
        s += getString(a.DistChan_Code__c);
        s += getString(a.Division_Code__c);
        return s;
    }

    private static String getMatKey(Product_Sales_Figure__c a) {
        String s = '';
        s += getString(a.Material_Number__c);
        s += getString(a.SalesOrg_Code__c);
        s += getString(a.DistChan_Code__c);
        return s;
    }
    
    private static String getRecKey(Product_Sales_Figure__c a) {
        String s = '', m = 'MATERIAL-NUMBER';
        if (!String.isBlank(a.Material2__c)) {
            m = a.Material2__r.Material_Number__c;} else
        if (!String.isBlank(a.Material_General_Data2__c)){
            m = a.Material_General_Data2__r.Material_Number__c;}
        //s = a.CustomerType__c + DELIM + a.Account__r.Account_Number__c + DELIM + m;
        s = a.Account__r.Account_Number__c + DELIM + m + DELIM + a.CustomerType__c;
        return s;
    }
    
    private static Map<String, Material_Sales_Data2__c> getMaterialMap(Set<String> aset) {
        Map<String, Material_Sales_Data2__c> amap = new Map<String, Material_Sales_Data2__c>();
        if (aset.isEmpty()) {return amap;}
        List<Material_Sales_Data2__c> alist = [
            select Id, Record_Key__c from Material_Sales_Data2__c 
             where Record_Key__c in :aset];
        if (alist == null || alist.isEmpty()) {return amap;}
        for (Material_Sales_Data2__c a : alist) {amap.put(a.Record_Key__c, a);} 
        return amap;
    }

    private static Map<String, Material_General_Data2__c> getMGD2Map(Set<String> aset) {
        Map<String, Material_General_Data2__c> amap = new 
        Map<String, Material_General_Data2__c>();
        if (aset.isEmpty()) {return amap;}
        List<Material_General_Data2__c> alist = [
            select Id, Material_Number__c from Material_General_Data2__c 
             where Material_Number__c in :aset];
        if (alist == null || alist.isEmpty()) {return amap;}
        for (Material_General_Data2__c a : alist) {amap.put(a.Material_Number__c, a);} 
        return amap;
    }

// PSF -------------------- after upsert --------------------------------------------------------
    
    public static void doAfterUpsert(List<Product_Sales_Figure__c> alist) {
    	//upsertRPSI_PSF(alist, START_FP);
    }

    private static List<Product_Sales_Figure__c> getData(
                   List<Product_Sales_Figure__c> alist) {
        Set<Id> aset = new Set<Id>(); String q = PSF_QRY1 + ' where Id in :aset'; 
        for (Product_Sales_Figure__c a : alist) {aset.add(a.Id);}
        List<Product_Sales_Figure__c> blist = Database.query(q);
        return blist;
    }

    public static void upsertRPSI_PSF(List<Product_Sales_Figure__c> alist, String fp2) {
        String fp1, rt, k, s; Integer m; alist = getData(alist);
        Set<String> fpset = getFiscalPeriods(fp2);
        Map<String, Rolling_Product_Sales_Info__c> amap = new 
        Map<String, Rolling_Product_Sales_Info__c>();
        Rolling_Product_Sales_Info__c rpsi;
        for (Product_Sales_Figure__c a : alist) {
            fp1 = a.FiscalPeriod__c; rt = a.Date_Range_Label__c;
            if (!fpset.contains(fp1) || String.isBlank(rt)) {continue;}
            m = getMonthsBetween(fp1, fp2);
            if (m < 0 || m > 12) {continue;} s = null;
            if (REC_TYPES1.contains(rt)) {s = 'Month_' + getMM(m+1);} else 
            if (REC_TYPES2.contains(rt) && m == 0) {s = rt;}
            if (s == null) {continue;} s += '__c';
            k = getRecKey(a);
            if (amap.containsKey(k)) {rpsi = amap.get(k);} else {
                rpsi = getRPSI_PSF(a, fp2, k); amap.put(k, rpsi);}
            setRPSI_PSF(s, a, rpsi);
        }
        upsertRPSI(amap);
    }

    private static Rolling_Product_Sales_Info__c getRPSI_PSF(Product_Sales_Figure__c psf,
                                                             String fp, String k) {
        Rolling_Product_Sales_Info__c a = new Rolling_Product_Sales_Info__c();
        a.CurrencyIsoCode = psf.CurrencyIsoCode; a.Account_Type__c = psf.CustomerType__c;
        a.Record_Type__c = RECTYPE_MAT; a.Month_01__c = fp; 
        a.Account__c = psf.Account__c; a.Material2__c = psf.Material2__c;
        a.Material_General_Data2__c = psf.Material_General_Data2__c;
        a.Key__c = k; a.Name = k;
        return a;
    }
    
    private static void setRPSI_PSF(String s, Product_Sales_Figure__c psf,
                                    Rolling_Product_Sales_Info__c rpsi) {
        String f;
        try {
            init_RPSI1(rpsi, s);
            f = GM_GP_AMOUNT + s;    rpsi.put(f, psf.GM__c);
            f = GM_GP_PERCENT + s;   rpsi.put(f, psf.GMpct__c);
            f = SALES_AMOUNT + s;    rpsi.put(f, psf.Sales_Amount__c);
            f = SALES_VOLUME_GL + s; rpsi.put(f, psf.Sales_Volume_in_GALs__c);
            f = SALES_VOLUME_KG + s; rpsi.put(f, psf.Sales_Volume_in_KGs__c);
            f = SALES_VOLUME_LB + s; rpsi.put(f, psf.Sales_Volume_in_LBs__c);
            f = SALES_VOLUME_PT + s; rpsi.put(f, psf.Sales_Volume_in_PTs__c);
            f = SALES_VOLUME_UN + s; rpsi.put(f, psf.Sales_Volume_in_UNs__c);
        } catch (Exception e) {debug('Exception : ' + e.getMessage());}
    }
    
// PSP -------------------------------------------------------------------------------------------------------
    
    public static void doAfterUpsert(List<Product_Sales_Plan__c> alist) {
    	//upsertRPSI_PSP(alist, START_FP);
    }
    
    private static List<Product_Sales_Plan__c> getData(
                   List<Product_Sales_Plan__c> alist) {
    	Set<Id> aset = new Set<Id>(); String q = PSP_QRY1 + ' where Id in :aset'; 
        for (Product_Sales_Plan__c a : alist) {aset.add(a.Id);}
    	List<Product_Sales_Plan__c> blist = Database.query(q);
    	return blist;
    }

    public static void upsertRPSI_PSP(List<Product_Sales_Plan__c> alist, String fp2) {
        String fp1, rt, k, s; Integer m; alist = getData(alist);
        Set<String> fpset = getFiscalPeriods(fp2);
        Map<String, Rolling_Product_Sales_Info__c> amap = new 
        Map<String, Rolling_Product_Sales_Info__c>();
        Rolling_Product_Sales_Info__c rpsi;
        for (Product_Sales_Plan__c a : alist) {
            fp1 = a.FiscalPeriod__c; rt = a.RecordType__c;
            if (!fpset.contains(fp1) || String.isBlank(rt)) {continue;}
            m = getMonthsBetween(fp1, fp2);
            if (m < 0 || m > 12) {continue;} s = null;
            if (REC_TYPES1.contains(rt)) {s = getMM(m+1);} else 
            if (REC_TYPES2.contains(rt) && m == 0) {s = rt;}
            if (s == null) {continue;} s += '__c';
            k = getRecKey(a);
            if (amap.containsKey(k)) {rpsi = amap.get(k);} else {
                rpsi = getRPSI_PSP(a, fp2, k); amap.put(k, rpsi);}
            setRPSI_PSP(s, a, rpsi);
        }
        upsertRPSI(amap);
    }

    private static String getRecKey(Product_Sales_Plan__c a) {
        String s = '', m = 'MATERIAL-NUMBER';
        if (!String.isBlank(a.Material__c)) {
            m = a.Material__r.Material_Number__c;} else
        if (!String.isBlank(a.Material_General_Data2__c)){
            m = a.Material_General_Data2__r.Material_Number__c;}
        //s = a.CustomerType__c + DELIM + a.Account__r.Account_Number__c + DELIM + m;
        s = a.Account__r.Account_Number__c + DELIM + m + DELIM + a.CustomerType__c;
        return s;
    }
    
    private static Rolling_Product_Sales_Info__c getRPSI_PSP(Product_Sales_Plan__c psp,
                                                             String fp, String k) {
        Rolling_Product_Sales_Info__c a = new Rolling_Product_Sales_Info__c();
        a.CurrencyIsoCode = psp.CurrencyIsoCode; a.Account_Type__c = psp.CustomerType__c;
        a.Record_Type__c = RECTYPE_MAT; a.Month_01__c = fp; 
        a.Account__c = psp.Account__c; a.Material2__c = psp.Material__c;
        a.Material_General_Data2__c = psp.Material_General_Data2__c;
        a.Key__c = k; a.Name = k;
        return a;
    }
    
    private static void setRPSI_PSP(String s, Product_Sales_Plan__c psp,
                                    Rolling_Product_Sales_Info__c rpsi) {
        String f;
        Map<String, Double> amap = getUomVolumeMap(psp.Sales_Volume_UOM__c, psp.Sales_Volume__c);
        try {
        	init_RPSI3(rpsi, s);
            f = PLAN_AMOUNT + s; rpsi.put(f, psp.Sales_Amount_Local__c);
            if (amap.containsKey(UOMKG)) {
                f = PLAN_VOLUME_KG + s; rpsi.put(f, amap.get(UOMKG));
            } 
            if (amap.containsKey(UOMLB)) {
                f = PLAN_VOLUME_LB + s; rpsi.put(f, amap.get(UOMLB));
            } 
        } catch (Exception e) {debug('Exception : ' + e.getMessage());}
    }
    
// -------------------------------------------------------------------------------------------------------

    public static SelectOption getSelectOption(List<SelectOption> slist, String val) {
        SelectOption so = new SelectOption(NONE, NONE); String v;
        if (slist == null || slist.isEmpty()) {return so;}
        for (SelectOption s : slist) {v = s.getValue();
            if (!String.isBlank(v) && !String.isBlank(val) && v.equals(val)) {
            	so = s; break;}
        }
        return so;
    }
    
    private static String getRPSIQuery(String mnth, String accId, String accType) {
        String qry = RPSI_QRY1; if (String.isBlank(mnth)) {return qry;} 
        qry += ' where Month_01__c = \'' + mnth + '\''; 
        if (!String.isBlank(accId))   {qry += ' and Account__c = \'' + accId + '\'';}
        if (!String.isBlank(accType)) {qry += ' and Account_Type__c = \'' + accType + '\'';}
        return qry; 
    }
    
    private static String getRPSIQuery(String mnth, String accId, String accType, String matName) {
        String qry = getRPSIQuery(mnth, accId, accType); 
        qry += ' and Record_Type__c = \'' + RECTYPE_MAT + '\'';
        if (!String.isBlank(matName)) {
        	qry += ' and Material2__r.Name like \'%' + matName + '%\'';
        }
        qry += RPSI_OBY1; return qry; 
    }
    
    public static Database.Querylocator getQueryLocator(String mnth, String accId, String accType, String matName) {
    	String qry = getRPSIQuery(mnth, accId, accType, matName); debug('RPSI-Query : ' + qry);
        Database.Querylocator ql = null;
        try {ql = Database.getQueryLocator(qry);}
        catch(Exception e) {debug('getQueryLocator : ' + e.getMessage());}
        return ql;
    }

    public static PaginationController getPaginationController(Integer pageSize, 
    	String mnth, String accId, String accType, String matName) {
        PaginationController pc = null;
        try {Database.Querylocator ql = getQueryLocator(mnth, accId, accType, matName);
            if (ql != null) {pc = new PaginationController(ql, pageSize);}
        } catch(Exception e) {debug('getPaginationController : ' + e.getMessage());}
        return pc;
    }

    public static PaginationController getPaginationController(String accId, String accType, String matName) {
    	return getPaginationController(PAGE_SIZE, START_FP, accId, accType, matName);
    }
    
    public static Rolling_Product_Sales_Info__c getRPSI(String accId) {
        String s = Account_Partner_Functions.getAccountType(accId), accType = '';
        if (!String.isBlank(s) && ACC_TYPE_MAP.containsKey(s)) {accType = ACC_TYPE_MAP.get(s);}
    	String qry = getRPSIQuery(START_FP, accId, accType); 
    	Rolling_Product_Sales_Info__c rpsi = getAccRPSI(qry);
    	if (rpsi == null) {
    		if (accType == ACCTYPE_SOLD) {accType = ACCTYPE_SHIP;} else
            if (accType == ACCTYPE_SHIP) {accType = ACCTYPE_SOLD;}
            qry = getRPSIQuery(START_FP, accId, accType);
            rpsi = getAccRPSI(qry);
    	}
    	//debug('rpsi = ' + rpsi); 
    	return rpsi;
    }
    
    private static Rolling_Product_Sales_Info__c getAccRPSI(String qry) {
        qry += ' and Record_Type__c = \'' + RECTYPE_ACC + '\' limit 1';
        Rolling_Product_Sales_Info__c rpsi = null;
        try {
            List<Rolling_Product_Sales_Info__c> alist = Database.query(qry);
            if (alist != null && !alist.isEmpty()) {rpsi = alist[0];}
        } catch(Exception e) {debug('getRPSI : ' + e.getMessage());}
        //debug('rpsi = ' + rpsi); 
        return rpsi;
    }

    public static Double getVariance(Decimal d1, Decimal d2) {
        if (d1 == null || d2 == null) {return null;} 
        return (d1 - d2);
    }

    public static Double getVPercent(Decimal d1, Decimal d2) {
        if (d1 == null || d2 == null || d2 == 0.0) {return null;} 
        return (d1 - d2) * 100 / d2;
    }

    public static Double getVariance(Double d1, Double d2) {
        if (d1 == null || d2 == null) {return null;} 
        return (d1 - d2);
    }
    
    public static Double getVPercent(Double d1, Double d2) {
        if (d1 == null || d2 == null || d2 == 0.0 ) {return null;} 
        return (d1 - d2) * 100 / d2;
    }
    
    public static Boolean isNegative(Double d) {return (d != null && d < 0.0);}
    public static Boolean isPositive(Double d) {return (d != null && d > 0.0);}

    public static String  getString(String s) {return s == null ? '' : s;}

    public static String getString(Double d, Integer n, String u) {
        String s = ''; if (d == null) {return s;}
        s = Math_Functions.formatNumber(d, n);
        if (s != '0') {s += ' ' + getString(u);} else {s = '';}
        return s;
    }

    public static String getString(Double d, String u) {return getString(d, 0, u);}

    public static String getString(Double d, Integer n) {return getString(d, n, null);}

    public static String getString(Double d) {return getString(d, 0);}

    public static String getString(Decimal f, Integer n, String u) {
        Double d = f != null ? f.doubleValue() : null; return getString(d, n, u);
    }

    public static String getString(Decimal f, String u) {return getString(f, 0, u);}

    public static String getString(Decimal f, Integer n) {return getString(f, n, null);}

    public static String getString(Decimal f) {return getString(f, 0);}

    public static String getString(String s, Date d1, Date d2) {
        if (d1 == null || d2 == null) {return '';} 
        return s + ' (' + MNTH_LBL_MAP.get(d1.month()) + '-' + d1.year() + ' - ' + 
                          MNTH_LBL_MAP.get(d2.month()) + '-' + d2.year() + ')';
    }
    
    public static String formatPercent(Double d) {
        String s = ''; if (d == null) {return s;}
        s = Math_Functions.formatNumber(d, 2);
        if (s != '0.00') {s += ' %';} else {s = '';}
        return s;
    }

    public static String formatPercent(Decimal f) {
        Double d = f != null ? f.doubleValue() : null; return formatPercent(d);
    }

    public static String getStyle(Double d) {
        String s = NUM_STYLE; if (d == null) {return s;}
        if (d == 0.0) {return ZRO_STYLE;} else
        if (d <  0.0) {return NEG_STYLE;}          
        return s;          
    }

    public static String getStyle(Decimal f) {
        Double d = f != null ? f.doubleValue() : null; return getStyle(d);
    }

    public static String getStyle(Integer n) {
        Double d = n != null ? Double.valueOf(n) : null; return getStyle(d);
    }
    
    public static String getFieldName(String rpsView, String timePeriod) {
    	String s1 = rpsView.toLowerCase(), 
    	       s2 = '_' + timePeriod.toLowerCase() + '__c';
    	for (String s : RPSI_FIELDS) {
    		if (s.startsWith(s1) && s.endsWith(s2)) {return s;}
    	}
    	return null;
    }
    
    public static Double getDoubleValue(Rolling_Product_Sales_Info__c rpsi, 
                                        String rpsView, String timePeriod) {
        String fn = getFieldName(rpsView, timePeriod);
        if (rpsi == null || fn == null) {return null;}
        Object obj = rpsi.get(fn); if (obj == null) {return null;}
        return (Double)obj;
    }

    public static RPSI_Field getField(Rolling_Product_Sales_Info__c rpsi, 
                                      String rpsView, String timePeriod) {
        RPSI_Field f = new RPSI_Field();  
        Double d = getDoubleValue(rpsi, rpsView, timePeriod); String s;
        if (d != null) {
        	if (rpsView.startsWith(GM_GP_PERCENT)) {s = formatPercent(d);} 
        	else {s = getString(d);}
	        f.setStyle(getStyle(d)); f.setValue(s);
        }
        return f;
    }

    public static RPSI_Field getVariance(Rolling_Product_Sales_Info__c rpsi, 
                                         String rpsView, String tp1, String tp2) {
        RPSI_Field f = new RPSI_Field();
        if (NO_VAR_VIEWS.contains(rpsView)) {return f;}  
        Double d1 = getDoubleValue(rpsi, rpsView, tp1),
               d2 = getDoubleValue(rpsi, rpsView, tp2), d;
        if (d1 != null && d2 != null) {
        	d = d1 - d2;
            f.setStyle(getStyle(d)); f.setValue(getString(d));
        }
        return f;
    }

}
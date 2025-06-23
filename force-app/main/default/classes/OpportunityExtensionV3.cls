public class OpportunityExtensionV3 {

    // Start: Variable Declarations Section
    private static final Integer PAGE_SIZE = 10;
    private static final Integer MAX_LIMIT = 10000;
    private static final Integer MAX_COUNT_1 = 200;

    public static final String OPP_PAGE_URL = '/apex/OpportunityCPIV3';

    public static final Set<String> RECTYPES_1 = new Set<String>{
        'Aqualon Opportunity - EMEA',
        'Aqualon Opportunity - Latin Amer',
        'Aqualon Opportunity - NA'
    };

    public static final String MSD_QRY1 = 'select Id, Name, '
        + 'Material_General_Data__c, Material_Number__c, Material_Desc__c, '
        + 'Sales_Org_Code__c, PH5_Family__c, PH6_Segment__c From Material_Sales_Data2__c ';

    public final Opportunity opp { get; set; }
    //ApexPages.StandardController stdCtrl;
    private String RecordTypeId, RecordTypeName;
    private string strRecordTypeParam, strRetURLParam, strCancelURLParam, strAccidParam, strOppIdParam, strConIdParam ;
    private Account acc;
    private OpportunityRatingConfigFunctions orcFuncs;

    private string m_VCPRating;
    public String m_vfPageMessageSummary { get; set; }
    public String strErrMsg {get; private set;}
    public String requireUnrequireStyle {get; private set;}
    public String OppNameRequireStyle {get; private set;}
    public String CloseDateRequireStyle {get; private set;}
    public String StageNameRequireStyle {get; private set;}
    public String AccountIdRequireStyle {get; private set;}
    public String RegionRequireStyle {get; private set;}
    public String CurrencyIsoCodeRequireStyle {get; private set;}
    public String BusinessSegmentRequireStyle {get; private set;}
    public String BusinessUnitRequireStyle {get; private set;}
    public String OpportunityStatusRequireStyle {get; private set;}
    public String PACDescriptionRequireStyle {get; set;}
    public String SBURequireStyle {get; private set;}
    public String PrimaryCompetitorRequireStyle {get; private set;}
    public String SupplierContactRequireStyle {get; private set;}
    public String ExpectedRevenueDateRequireStyle {get; private set;}
    public String CurrentYearRevInPlanRequireStyle {get; private set;}
    public String CurrentYearRevAbovePlanRequireStyle {get; private set;}
    public String ResultReasonRequireStyle {get; private set;}
    public String ActualDecisionDateRequireStyle {get; private set;}
    public String FocusField {get; set; }

    public Decimal TotalOpportunityValue {get; private set;}
    public Decimal WeightedOpportunityRevenueValue {get; private set; }
    public Boolean salesPotentialConvertedToUSD {get {return (true);} set; }


    public String RequiredFieldCheckParam {get {return RequiredFieldCheckParam;} set {RequiredFieldCheckParam= value;}}
    public String SAPSalesOffice { get; set; }
    public String SAPDistChannel { get; set; }
    public String SAPSalesOrg { get; set; }
    public Boolean CreatingFromAccountPage {get; set; }
    public Boolean CreatingFromContactPage {get {return (false);} set; }
    public Boolean isOppCreated {get;set;}
    public Decimal WeightedAbovePlanRevenueThisYear {get; set;}

    public String prodHierarchy5{get;set;}
    public String prodHierarchy6{get;set;}

    public String materialNumber {get;set;}
    public String materialDesc {get;set;}
    public boolean displayOpportunityPage{get;set;}
    public Boolean displayCustomerAndMaterial{get;set;}
    public Boolean allMat1{get;set;}
    public boolean displayMaterialSelector{get;set;}
    public PaginationController mpc {get; set;}
    public Boolean allMat2{get;set;}
    public Boolean disableSave {get;set;}
    public Boolean renderStage1Section {get; set;}
    public Boolean renderStage2Section {get; set;}
    public Boolean renderStage3Section {get; set;}
    public Boolean renderStage4Section {get; set;}
    public boolean activeAccount {get; set;}
    //public Boolean renderPage2           {get; private set;}
    public Boolean InnovaStageReadOnly {get; set;}
    public Boolean TSRStatusReadOnly {get; set;}
    public Boolean CanOverrideRating {get; set;}
    public Integer intPageSize {get; set;}

    public Decimal OppRatingToReachStage2 {get; private set; }
    public Decimal OppRatingToReachStage3 {get; private set; }
    public Decimal OppRatingToReachStage4 {get; private set; }

    private List<String> errList = new List<String>();
    public List<SelectOption> prodHierarchy5Options{get;set;}
    public List<SelectOption> prodHierarchy6Options{get;set;}
    public Map<id, MaterialInfoClass> materialInfoMap = New Map<id, MaterialInfoClass>();
    // List of materials on the VF Page
    //public List<MaterialInfoClass> materialsAdded{get {return materialInfoMap.values();} set;}
    public List<MaterialInfoClass> materialsAdded{get; set;}

    public List<MaterialSearchWrapper> materialList = new List<MaterialSearchWrapper>();

    private List<String> FormRequiredFieldNamesList = new List<String>
        {
            'Name', 'AccountId', 'Opportunity_Status__c', 'PAC_Description__c',
            'SBU__c', 'CurrencyIsoCode', 'CloseDate', 'Expected_Revenue_Date__c',
            'Current_Year_Revenue_in_Plan__c', 'Current_Year_Revenue_Above__c',
            'Primary_Competitor__c', 'Contact__c', 'Result_Reason__c',
            'Actual_Decision_Date__c', 'Type__c'

        };

    private List<String> FormRequiredFieldLabelsList = new List<String>
        {
            'Opportunity Name', 'Customer / Prospect', 'Opportunity Status', 'PAC Description',
            'SBU', 'Opportunity Currency', 'Close Date',
            'Expected Revenue Date', 'Current Year Revenue in Plan',
            'Current Year Revenue Above Plan', 'Primary Competitor',
            'Contact', 'Result Reason', 'Actual Decision Date',
            'Type'

        };

    // Fields common to the custom lookup forms
    public boolean renderLisd {get; private set;}
    public boolean renderMaxMsg1 {get; private set;}
    public Integer maxCount1 {get; private set;}

    // Contact search form
    public String contactName         {get; set;}
    public boolean renderContactsList {get; private set;}
    private List<Contact> contacts;
    public boolean renderContactForm {get; private set;}

    // Coach/Champion search form
    public String coachName         {get; set;}
    public boolean renderCoachesList {get; private set;}
    private List<Contact> coaches;
    public boolean renderCoachForm {get; private set;}

    // Evaluator/Formulator search form - Evaluator_Formulator_Contact__c
    public String evaluatorName         {get; set;}
    public boolean renderEvaluatorsList {get; private set;}
    private List<Contact> evaluators;
    public boolean renderEvaluatorForm {get; private set;}

    // Value Descision Maker / Economic Buyer search form - Value_Descision_Maker_Economic_Buyer_Con__c
    public String econBuyerName         {get; set;}
    public boolean renderEconBuyersList {get; private set;}
    private List<Contact> econBuyers;
    public boolean renderEconBuyerForm {get; private set;}

    // Primary Competitor search form - Primary_Competitor__c
    public String competitorName         {get; set;}
    public boolean renderCompetitorsList {get; private set;}
    private List<Competitor__c> Competitors;
    public boolean renderCompetitorForm {get; private set;}

    // Primary Competitor Lost to Won from search form - Competitor_Lost_To_Won_From__c
    public String compLostWonName         {get; set;}
    public boolean renderCompsLostWonList {get; private set;}
    private List<Competitor__c> CompsLostWon;
    public boolean renderCompLostWonForm {get; private set;}

    //CPI
    public SAP_LISD lisd  {get; set;}
    private String lisdCustomerGroup {get;set;}
    public Boolean renderNextButton           {get; private set;}
    //public Boolean renderGoto1           {get; private set;}

    //Debugging related
    public String debugTextValue {get; set;}
    public Boolean renderDebugPanel {get; set;}

    private Material_Sales_Data2__c defaultMat1;
    private Boolean                 defaultMat1Added = false;

// End: Variable Declarations Section

    public PageReference CalculateWeightedAbovePlanRevenueThisYear(){

        if (this.opp.Current_Year_Revenue_Above__c != null && this.opp.Probability_Winning_Above_Plan_Rev__c != null)
            WeightedAbovePlanRevenueThisYear = (this.opp.Current_Year_Revenue_Above__c * this.opp.Probability_Winning_Above_Plan_Rev__c) / 100;


        return null;
    }

    public PageReference CalculateAQRevenueLocal(){

        //strErrMsg += ' inside CalculateAQRevenueLocal';
        if (materialsAdded != null && materialsAdded.size() > 0)
        {
            TotalOpportunityValue = 0;

            //LogDebugMsg('CalculateAQRevenueLocal materialInfoMap before: ' + materialInfoMap);
            //LogDebugMsg('CalculateAQRevenueLocal materialsAdded before: ' + materialsAdded);

            for (MaterialInfoClass mic :materialsAdded)
            {
                LogDebugMsg('mic.OppMaterial.Sales_Price__c = ' + mic.OppMaterial);

                if (mic.OppMaterial.Quantity__c != null && mic.OppMaterial.Sales_Price__c !=null)
                {
                    mic.AQRevenueLocal = mic.OppMaterial.Quantity__c * mic.OppMaterial.Sales_Price__c;

                    if (TotalOpportunityValue == null) TotalOpportunityValue = 0;
                    TotalOpportunityValue = TotalOpportunityValue + mic.AQRevenueLocal;

                }

            }

            //LogDebugMsg('CalculateAQRevenueLocal materialsAdded after: ' + materialsAdded);
            //LogDebugMsg('CalculateAQRevenueLocal materialInfoMap after: ' + materialInfoMap);

            //Set Sales Potential based on Total opportunity Value - C1 Testing
            if (TotalOpportunityValue != null)
                setSalesPotential();

            //Update Weighted Opportunity Revenue
            if (TotalOpportunityValue != null && this.opp.Opportunity_Rating_Overall__c != null)
            {
                WeightedOpportunityRevenueValue = (TotalOpportunityValue * Decimal.valueOf(this.opp.Opportunity_Rating_Overall__c))/100;
                this.opp.Weighted_Opportunity_Revenue__c = WeightedOpportunityRevenueValue;
            }


        }

        return null;
    }

    private void setSalesPotential()
    {
        LogDebugMsg('Entered: setSalesPotential');
        String SalesPotentialBeforeChange = this.opp.Sales_Potential__c;

        LogDebugMsg('TotalOpportunityValue = ' + TotalOpportunityValue);
        LogDebugMsg('lisdCustomerGroup = ' + lisdCustomerGroup);
        LogDebugMsg('this.opp.CurrencyIsoCode is null? ' + String.ValueOf(this.opp.CurrencyIsoCode == null));

        if (lisdCustomerGroup == null) lisdCustomerGroup = '';

        //Set Sales Potential based on Total opportunity Value - C1 Testing
        this.opp.Sales_Potential__c = SalesPotentialConfigurationFunctions.GetStaticSalesPotentialRangeFromList(
                                        TotalOpportunityValue,
                                        lisdCustomerGroup.trim(),
                                        this.opp.CurrencyIsoCode);

        LogDebugMsg('Sales_Potential__c = ' + this.opp.Sales_Potential__c);

        if (SalesPotentialBeforeChange != opp.Sales_Potential__c)
            OverrideStageOnChange();

        LogDebugMsg('Exiting: setSalesPotential');

    }

    ///
    /*
        Called when an existing opportunity is loaded to load Opportunity Materials
    */
    ///
    private void GetOppMatForOpp(string oppId)
    {
        LogDebugMsg('Entered: GetOppMatForOpp');
        List<Opportunity_Material__c> oppMats =
            [SELECT id, Material__r.Material_General_Data__c, Material__r.Material_Number__c, Material__r.Name,
                SBU__c, New_Product__c, Quantity__c, Unit_of_Measure__c, Sales_Price__c, AQ_Revenue__c, Opportunity__c
              FROM Opportunity_Material__c WHERE Opportunity__r.id = :oppId];

        //strErrMsg += 'oppMats.size(): ' + oppMats.size();
        if (oppMats != null)
        {
            if (oppMats.size() > 0)
            {
                LogDebugMsg('GetOppMatForOpp oppMats: ' + oppMats);

                for (Opportunity_Material__c om:oppMats)
                {
                        MaterialInfoClass mic = new MaterialInfoClass();
                        mic.OppMaterial = om;

                        //retrieve Uoms for material and select the choice based on Unit_of_Measure__c
                        if (mic.materialUoMSelectoptions == null)
                            mic.materialUoMSelectoptions = new
                                List<SelectOption>(getAltUoms(om.Material__r.Material_General_Data__c));

                        //strErrMsg += 'mic.materialUoMSelectoptions = ' + mic.materialUoMSelectoptions + '</br>';

                        //strErrMsg += 'om.Unit_of_Measure__c = ' + om.Unit_of_Measure__c + '</br>' ;

                        if (om.Unit_of_Measure__c != null)
                            mic.materialUoMSelect = om.Unit_of_Measure__c.toUpperCase();

                        LogDebugMsg('mic.OppMaterial is null?' + String.valueOf(mic.OppMaterial == null));
                        LogDebugMsg('mic.OppMaterial.Material__r is null?' + String.valueOf(mic.OppMaterial.Material__r == null));

                        if (mic.OppMaterial.Material__r != null)
                            mic.OppMaterial.Material__r.Material_Number__c =  String_Functions.removeLeadingZeros(mic.OppMaterial.Material__r.Material_Number__c);
                        mic.displayDeleteCheckBox = true;
                        if (om.Quantity__c != null && om.Sales_Price__c != null)
                        {
                            mic.AQRevenueLocal = om.Quantity__c * om.Sales_Price__c;

                        }

                        LogDebugMsg('GetOppMatForOpp mic.OppMaterial.id: ' + mic.OppMaterial.id);
                        LogDebugMsg('GetOppMatForOpp mic.OppMaterial.Material__c: ' + mic.OppMaterial.Material__c);
                        LogDebugMsg('GetOppMatForOpp mic.OppMaterial.SBU__c: ' + mic.OppMaterial.SBU__c);
                        LogDebugMsg('GetOppMatForOpp mic.OppMaterial.Quantity__c: ' + mic.OppMaterial.Quantity__c);
                        LogDebugMsg('GetOppMatForOpp mic.OppMaterial.Unit_of_Measure__c: ' + mic.OppMaterial.Unit_of_Measure__c);
                        LogDebugMsg('GetOppMatForOpp mic.OppMaterial.Sales_Price__c: ' + mic.OppMaterial.Sales_Price__c);

                        materialInfoMap.put(mic.OppMaterial.Material__r.id, mic);

                        if (materialsAdded == null)
                            materialsAdded = new List<MaterialInfoClass>();
                        materialsAdded.add(mic);

                        if (TotalOpportunityValue == null) TotalOpportunityValue = 0;
                        if (mic.AQRevenueLocal != null)
                            TotalOpportunityValue = TotalOpportunityValue + mic.AQRevenueLocal;



                }

                LogDebugMsg('GetOppMatForOpp materialInfoMap: ' + materialInfoMap);
            }
        }

        LogDebugMsg('Exiting: GetOppMatForOpp');
        //strErrMsg += 'materialInfoMap.size(): ' + materialInfoMap.size();


    }

    public void searchMaterials(){
        //Pricing_RebateMaterialSelectorSearch sp = ext.materialSearch;
        //debug(''+sp);
        String ph5Code;
        if(prodHierarchy5 != null){
            String[] ph5 = prodHierarchy5.split('-');
            if(ph5 != null && ph5.size() >= 1){
                ph5Code = ph5.get(0).trim();
            }
        }
        String ph6Code;
        if(prodHierarchy6 != null){
            String[] ph6 = prodHierarchy6.split('-');
            if(ph6 != null && ph6.size() >= 1){
                ph6Code = ph6.get(0).trim();
            }
        }
        String query = MSD_QRY1 + ' WHERE ';
        if (String.isBlank(SAPSalesOrg) && String.isBlank(SAPDistChannel)) {return;}
        if (SAPSalesOrg != null)
        {
            query += ' Sales_Org_Code__c = \'' + String.escapeSingleQuotes(SAPSalesOrg) + '\'';
            if (SAPDistChannel != null)
                query += ' AND Dist_Channel_Code__c = \'' + String.escapeSingleQuotes(SAPDistChannel) + '\'';
        }
        else if (SAPDistChannel != null)
            query += ' Dist_Channel_Code__c = \'' + String.escapeSingleQuotes(SAPDistChannel) + '\'';

        Boolean b1, b2, b3, b4;
        b1 = Pricing_RebateStringUtils.isNullOrBlank(materialNumber);
        if(!b1)
            query += ' AND Material_Number__c LIKE \'%' + String.escapeSingleQuotes(materialNumber) + '%\'';
        b2 = Pricing_RebateStringUtils.isNullOrBlank(materialDesc);
        if(!b2)
            query += ' AND Material_Desc__c LIKE \'%' + String.escapeSingleQuotes(materialDesc) + '%\'';
        b3 = Pricing_RebateStringUtils.isNullOrBlank(ph5Code);
        if(!b3)
            query += ' AND PH5_Family_Code__c = \'' + String.escapeSingleQuotes(ph5Code) + '\'';
        b4 = Pricing_RebateStringUtils.isNullOrBlank(ph6Code);
        if(!b4)
            query += ' AND PH6_Segment_Code__c = \'' + String.escapeSingleQuotes(ph6Code) + '\'';
        query += ' order by Name LIMIT ';
        if (Test.isRunningTest()) {query += 100;} else {query += MAX_LIMIT;}
        //debug('*********** QUERY ' + query);
        if (b1 && b2 && b3 && b4) {return;}
        Database.Querylocator ql = Database.getQueryLocator(query);

        if (intPageSize == null) intPageSize = PAGE_SIZE;
        mpc = new PaginationController(ql, intPageSize);
        //LogDebugMsg('mpc.getPageSize() = ' + mpc.getPageSize());
    }

    public void matPageSizeChange()
    {

        if (mpc != null)
            intPageSize = mpc.getPageSize();
        else
            intPageSize =  PAGE_SIZE;

        //LogDebugMsg('intPageSize = ' + intPageSize);
    }

    /*
    Method populates all the product hierarchy 6 based on dist channel and prod hierarchy 5
    @param Pricing_RebateControllerExt
    */
    public void DoPopulateProductHierarchy6(){
        String ph5Code;
        String ph5Desc;

        try
        {
            if(prodHierarchy5 != null){
              String[] ph5 = prodHierarchy5.split('-');
              if(ph5 != null && ph5.size() > 1){
                ph5Desc = ph5.get(1).trim();
                ph5Code = ph5.get(0).trim();
              } else if(ph5 != null && ph5.size() == 1){
                ph5Code = ph5.get(0).trim();
              }
            }
            //List<Product_Hierarchy__c> prodHieList = SAP_Material_Queries.getProductLinesForFamily(SAPDistChannel, ph5Code);
            List<Product_Hierarchy__c> prodHieList = Product_Hierarchy_Functions.getProductSegments(SAPDistChannel, ph5Code);

            if (prodHierarchy6Options == null)
            {
                prodHierarchy6Options = new List<SelectOption>();
            }
            else
            {
                prodHierarchy6Options.clear();

            }

            prodHierarchy6Options.add(new SelectOption('','- None -'));

            if(prodHieList != null){

              for(Product_Hierarchy__c ph : prodHieList){

                prodHierarchy6Options.add(new
                    SelectOption(ph.Product_Hierarchy_Code__c+' - '+ph.Product_Hierarchy_Description__c,
                    ph.Product_Hierarchy_Code__c+' - '+ph.Product_Hierarchy_Description__c));
              }

            }

        } catch (Exception ex) {LogException('DoPopulateProductHierarchy6', ex) ;}

    }

    /*
    Method populates all the product hierarchy 5 based on dist channel
    @param distChannel
    @return List
    */
    private void populateProductHierarchy5(){

        try
        {
            //List<Product_Hierarchy__c> prodHieList = SAP_Material_Queries.getProductFamiliesForDistChan(SAPDistChannel);
            List<Product_Hierarchy__c> prodHieList = Product_Hierarchy_Functions.getProductFamilies(SAPDistChannel);

            if (prodHierarchy5Options == null)
            {
                prodHierarchy5Options = new List<SelectOption>();
            }
            else
            {
                prodHierarchy5Options.clear();

            }

            prodHierarchy5Options.add(new SelectOption('','- None -'));

            if(prodHieList != null)
            {
              for(Product_Hierarchy__c ph : prodHieList){

                prodHierarchy5Options.add(new
                    SelectOption(ph.Product_Hierarchy_Code__c+' - '+ph.Product_Hierarchy_Description__c,
                    ph.Product_Hierarchy_Code__c+' - '+ph.Product_Hierarchy_Description__c));
              }
            }
        }catch (Exception ex){LogException('populateProductHierarchy5', ex);}


    }


    /**
    * Set the default values for the Search criteria in the material selector
    * @param Pricing_RebateControllerExt
    * @return void
    */
    public void defaultSearchForMaterialSelector(){
        displayMaterialSelector = true;
        populateProductHierarchy5();
        populateProductHierarchy6();
        if (materialList != null)
            materialList.clear();
    }

    public List<MaterialSearchWrapper> getMaterialList() {

        if (mpc == null) {return new List<MaterialSearchWrapper>();}
        materialList = constructMaterialWrapper();

        return materialList;
    }

    public List<MaterialSearchWrapper> constructMaterialWrapper(){
        List<MaterialSearchWrapper> wrapperList = new List<MaterialSearchWrapper>();

        Integer n = mpc.recordFrom;
        for(Material_Sales_Data2__c material : (List<Material_Sales_Data2__c>)mpc.getRecords()){
            MaterialSearchWrapper wrapper = new MaterialSearchWrapper(material, n++);

            wrapperList.add(wrapper);
        }

        return wrapperList;
    }

    /**
    * Invoked when cancel is clicked on the material selector
    * @return PageReference
    */
    public PageReference cancelMaterialSelector(){
        ShowForm('renderOppForm');
    return null;
    }

    /**
    * Invoked when the Ok button is clicked on the Materials selector
    */
    public PageReference addMaterialsToOpp(){
        Integer currentlySelectedFromSearchResults = 0;

        for (MaterialSearchWrapper m : materialList) {
            if (m.addToOpp) {currentlySelectedFromSearchResults++;}
        }

        if (materialsAdded != null && materialsAdded.size() > 0) {
            if ((currentlySelectedFromSearchResults + materialsAdded.size()) > 10) {
                LogException('addMaterialsToOpp',
                    'Currently selected materials (' + currentlySelectedFromSearchResults +
                    ') + existing materials on opportunity (' + String.valueOf(materialsAdded.size()) +
                    ') exceeds the allowed limit of 10 Materials on an Opportunity.');
                return null;
            }
        }

        for (MaterialSearchWrapper m : materialList) {
            if (m.addToOpp) {addMaterialToOpp(m.material);}
        }

        ShowForm('renderOppForm'); mpc = null; return null;
    }

    private Boolean addMaterialToOpp(Material_Sales_Data2__c msd) {
        if (materialInfoMap.containsKey(msd.Id)) {return false;}
        MaterialInfoClass mic = new MaterialInfoClass();

        if (this.opp.id != null) {mic.oppId = this.opp.id;}

        Opportunity_Material__c oppMat = new Opportunity_Material__c();
        oppMat.Material__r = msd;
        oppMat.Material__c = msd.id;
        oppMat.SBU__c = this.opp.SBU__c;
        setMatUomOpts(mic, oppMat);

        oppMat.Material__r.Material_Number__c =  String_Functions.removeLeadingZeros(oppMat.Material__r.Material_Number__c);
        mic.OppMaterial = oppMat;

        mic.displayDeleteCheckBox = true;


        materialInfoMap.put(mic.OppMaterial.Material__r.id, mic);

        if (materialsAdded == null) {materialsAdded = new List<MaterialInfoClass>();}

        materialsAdded.add(mic); return true;
    }

    private void setMatUomOpts(MaterialInfoClass mic, Opportunity_Material__c oppMat) {
        if (oppMat.Material__r.Material_General_Data__c == null) {return;}
        mic.materialUoMSelectoptions = new List<SelectOption>(getAltUoms(oppMat.Material__r.Material_General_Data__c));
        if (mic.materialUoMSelectoptions == null || mic.materialUoMSelectoptions.isEmpty()) {return;}
        mic.materialUoMSelect = 'KG'; if (RecordTypeName == 'Aqualon Opportunity - NA') {mic.materialUoMSelect = 'LB';}
    }

    private void setDefaultMat1() {
        String rkey = '000000000000840319' + SAPSalesOrg + SAPDistChannel; defaultMat1 = null;
        String q = MSD_QRY1 + ' where Record_Key__c = :rkey limit 1';
        List<Material_Sales_Data2__c> alist = Database.query(q);
        if (!alist.isEmpty()) {defaultMat1 = alist[0];}
    }

    /**
    * Invoked when clear is clicked on the material selector
    * @return PageReference
    */
    public PageReference clearMaterialSelector(){
        displayMaterialSelector = true;

        materialNumber = '';
        materialDesc = '';
        prodHierarchy5 = '';
        prodHierarchy6 = '';
        if (prodHierarchy6Options != null)
            prodHierarchy6Options.clear();
        //displayNext = false;
        //displayPrevious = false;
        if (materialList != null)
            materialList.clear();

        return null;
    }


    /*
    Method populates all the product hierarchy 6 based on dist channel and prod hierarchy 5
    @return PageReference
    */
    public PageReference populateProductHierarchy6(){
        displayMaterialSelector = true;
        DoPopulateProductHierarchy6();
        return null;
    }

    public void copyMaterialValues() {

        if (materialsAdded == null || materialsAdded.size() < 2) {return;}
        MaterialInfoClass p1 = materialsAdded[0];
        for (Integer i = 1; i < materialsAdded.size(); i++) {
            materialsAdded[i].OppMaterial.SBU__c = p1.OppMaterial.SBU__c;
            materialsAdded[i].OppMaterial.Quantity__c = p1.OppMaterial.Quantity__c;
            materialsAdded[i].OppMaterial.Unit_of_Measure__c = p1.OppMaterial.Unit_of_Measure__c;
            materialsAdded[i].OppMaterial.Sales_Price__c = p1.OppMaterial.Sales_Price__c;

        }

    }

    /**
    * Invoked when search is clicked on the material selector or Add Material is clicked on the main page
    * @return PageReference
    */
    public PageReference searchMaterial()
    {

        if (this.Opp.AccountId == null)
        {
            LogException('searchMaterial', 'Please select a Customer/Prospect first' ) ;
            return null;
        }

        if (materialsAdded != null && materialsAdded.size() == 10)
        {
            LogException('searchMaterial', 'Only 10 Materials allowed at a time. Please remove existing ones to add new ones' ) ;
            return null;
        }

        allMat1 = false; allMat2 = false; mpc = null;
        String invokedFromMaterialAdd = ApexPages.currentPage().getParameters().get('invokedFromAddMaterial');

        //default the search fields if the selector was launched by clicking on the Add Material link
        if(invokedFromMaterialAdd == 'true')
        {
            defaultSearchForMaterialSelector();
        }
        else
            searchMaterials();
        ShowForm('renderMateriaSelectorForm');
        return null;

    }


    private void deleteMaterial(Id matId) {deleteMaterials(new Set<Id>{matId});}

    private void deleteMaterials(Set<Id> matIds) {
        for (MaterialInfoClass mic : materialInfoMap.values()) {
            mic.deleteMaterial = matIds.contains(mic.OppMaterial.Material__r.id);
        }
        deleteMaterials();
    }

    /**
    * Invoked when delete is clicked on the Material info section
    * @return PageReference
    */
    public PageReference deleteMaterials() {
        String methodName = 'deleteMaterials';
        LogDebugMsg('Entered ' + methodName);
        if (materialsAdded == null || materialsAdded.isEmpty()) {return null;}
        try {
            for (MaterialInfoClass mic : materialInfoMap.values()) {
                if (mic.deleteMaterial != null && !mic.deleteMaterial) {continue;}

                if (materialInfoMap.containsKey(mic.OppMaterial.Material__r.id)) {
                    materialInfoMap.remove(mic.OppMaterial.Material__r.id) ;
                    for (integer i=0; i<materialsAdded.size(); i++) {
                        if (materialsAdded[i].OppMaterial.Material__r.id == mic.OppMaterial.Material__r.id)    {
                            materialsAdded.remove(i);
                        }
                    }
                }

                if (mic.OppMaterial.Opportunity__c != null) {delete mic.OppMaterial;}

                if (mic.AQRevenueLocal != null && TotalOpportunityValue != null && TotalOpportunityValue > 0) {
                    TotalOpportunityValue = TotalOpportunityValue - mic.AQRevenueLocal;
                }
            }

            LogDebugMsg('TotalOpportunityValue ' + TotalOpportunityValue);
        } catch (Exception ex){LogException(methodName, ex);}

        LogDebugMsg('Exiting ' + methodName);
        allMat1 = false; return null;
    }

    public string OppStageName
    {   get;
        set
        {
            Decimal OppOverallRating = 0.0;
            if (this.opp.Opportunity_Rating_Overall__c != null)
                OppOverallRating = Decimal.valueOf(this.opp.Opportunity_Rating_Overall__c);

            if (this.Opp.Override_Stage__c)
            {
                if (OppOverallRating < OppRatingToReachStage2)
                {
                    OppStageName = 'Stage 1';

                }
                else if (OppOverallRating < OppRatingToReachStage3)
                {
                    OppStageName = 'Stage 2';
                }
                else if (OppOverallRating < OppRatingToReachStage4)
                {
                    OppStageName = 'Stage 3';
                }
                else
                {
                    OppStageName = 'Stage 4';
                }

            }
            else
            {
                OppStageName = value;

            }

            //strErrMsg += 'Stage: ' + OppStageName + '<br/>';
            //strErrMsg += 'Overall Rating: ' + OppOverallRating+ '<br/>';


            this.Opp.StageName = OppStageName ;
            this.Opp.Stage_Changed_On__c = Date.today() ;

        }

    }

    public OpportunityExtensionV3(ApexPages.StandardController controller) {
        materialsAdded = new List<MaterialInfoClass>();
        try
        {
            LogDebugMsg('Entered: OpportunityExtensionV3');
            debugTextValue = '';
            if (controller!= null) {
                this.opp = (Opportunity)controller.getRecord();
                //stdCtrl = controller;
            }
            else
            {
                this.opp = new Opportunity();


            }

            GetQueryStringParams();

            SetRecordTypeIdAndName();

            // If a new Opp is created this will be set to true in customsave method
            isOppCreated = false;

            renderLisd = true;
            //renderPage2 = false;
            renderNextButton = false;
            //renderGoto1 = false;
            activeAccount = false;

            renderConfirmDialogComp = false;
        }
        catch (Exception ex)
        {
            LogException('OpportunityExtensionV3', ex);
            LogDebugMsg('*** OpportunityExtensionV3 Error: ' + ex);
        }

        LogDebugMsg('Exiting: OpportunityExtensionV3');
    }

    public void initAction1() {
        LogDebugMsg('Entered: initAction1');

        if (isNull(strAccidParam))
            strAccidParam = opp.AccountId;
        else
            CreatingFromAccountPage = true;

        LogDebugMsg('strAccidParam:  ' + strAccidParam);

        if (lisd == null) {
            lisd = new SAP_LISD();
            if (!isNull(strAccidParam)) {lisd.setIndustries(strAccidParam);}
            else {lisd.readOnlyAC = false;}
        }

        if (opp.id == null)
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
        else if (opp.id != null && opp.Seller__c == null)
        {
            onLisdComplete();
        }
        else {
            //renderPage2 = true;
            renderLisd = false;
            if (!String.isBlank(lisd.industryValue) && String.isBlank(opp.Industry__c))
            {
                opp.Industry__c = lisd.industryValue;
            }
            lisd.copyDataFrom(opp);
            ShowForm('renderOppForm');
            OnFormLoaded();
        }

        LogDebugMsg('Exiting: initAction1');
    }

    public void onLisdComplete()
    {
        LogDebugMsg('Entered: onLisdComplete');
        //LogDebugMsg('opp.AccountId: ' + opp.AccountId);
        //LogDebugMsg('lisd: ' + lisd);
        //LogDebugMsg('lisd.acc: ' + lisd.acc);

        //LogDebugMsg('lisd.seller:  ' + lisd.seller);
        //LogDebugMsg('lisd.seller.Id:  ' + lisd.seller.Id);

        renderLisd = (lisd != null && !lisd.readOnlyInputs);

        renderNextButton = (renderLisd && lisd.seller != null && lisd.seller.Id != null);

        //LogDebugMsg('renderPage2:  ' + renderPage2);

        if (!renderLisd) {gotoPage2();}

        LogDebugMsg('Exiting: onLisdComplete');
    }

        public void gotoPage2()
        {
            LogDebugMsg('Entered: gotoPage2');
            if (lisd == null) {initAction1();}

            renderNextButton = false;

            //GetAccountInfo(lisd.acc.Id);

            lisd.copyDataTo(opp);

            //if (activeAccount)
            //{
                ShowForm('renderOppForm');
                OnFormLoaded();
            //}
            //else
            //{
                //ShowForm('renderConfirmDialogComp');
            //}


            LogDebugMsg('Exiting: gotoPage2');
        }

    public void OnFormLoaded()
    {
        LogDebugMsg('Entered: OnFormLoaded');

        LogDebugMsg('PAGE_SIZE = ' + PAGE_SIZE);

        try
        {

            if (RecordTypeName != 'Aqualon Opportunity - EMEA'
                && RecordTypeName != 'Aqualon Opportunity - Latin Amer'
                && RecordTypeName != 'Aqualon Opportunity - NA' )
            {

            }
            else
            {
                orcFuncs = new
                    OpportunityRatingConfigFunctions(opp.Customer_Group__c, opp.Sales_Office__c);

                TotalOpportunityValue = 0;

                disableSave = false;

                OppRatingToReachStage2 = Opportunity_Functions.getStageRating('Stage Rating 1');
                OppRatingToReachStage3 = Opportunity_Functions.getStageRating('Stage Rating 1')
                    + Opportunity_Functions.getStageRating('Stage Rating 2');
                OppRatingToReachStage4 = Opportunity_Functions.getStageRating('Stage Rating 1')
                    + Opportunity_Functions.getStageRating('Stage Rating 2')
                    + Opportunity_Functions.getStageRating('Stage Rating 3');

                if (this.opp.id == null)  // new opportunity
                {
                    this.Opp.OwnerId = UserInfo.getUserId();
                    this.opp.CurrencyIsoCode = UserInfo.getDefaultCurrency();
                    if (this.Opp.StageName == null)
                    {
                        OppStageName = 'Stage 1';
                        this.Opp.StageName = OppStageName ;
                        this.Opp.Stage_Changed_On__c = Date.today() ;
                    }

                    // set contact
                    if (strConIdParam != null)
                        GetContactInfo(strConIdParam);

                }
                else
                {
                    // Set account related infor
                    if (this.Opp.AccountId != null)
                        GetAccountInfo(this.Opp.AccountId);

                    // Set contactName controller field
                    if (this.Opp.Contact__c != null)
                        GetContactInfo(this.Opp.Contact__c);

                    // Set Coach controller field
                    if (opp.Coach_Champion_Contact__c != null)
                        GetCoachInfo(opp.Coach_Champion_Contact__c);

                    // Set Evaluator controller field
                    if (opp.Evaluator_Formulator_Contact__c != null)
                        GetEvaluatorInfo(opp.Evaluator_Formulator_Contact__c);

                    // Set Econ Buyer controller field
                    if (opp.Value_Descision_Maker_Economic_Buyer_Con__c != null)
                        GetEconBuyerInfo(opp.Value_Descision_Maker_Economic_Buyer_Con__c);

                    // Set Primary Competitor controller field
                    if (opp.Primary_Competitor__c != null)
                        GetCompetitorInfo(opp.Primary_Competitor__c);

                    // Set Competitor Lost Won controller field
                    if (opp.Competitor_Lost_To_Won_From__c != null)
                        GetCompLostWonInfo(opp.Competitor_Lost_To_Won_From__c);

                    ShowHideStages();
                    GetOppMatForOpp(this.opp.id);

                    if (this.opp.Current_Year_Revenue_Above__c != null && this.opp.Probability_Winning_Above_Plan_Rev__c != null)
                        WeightedAbovePlanRevenueThisYear = (this.opp.Current_Year_Revenue_Above__c * this.opp.Probability_Winning_Above_Plan_Rev__c) / 100;

                    if (this.opp.Aqualon_Amount__c != null && this.opp.Opportunity_Rating_Overall__c != null)
                    {
                        WeightedOpportunityRevenueValue = (this.opp.Aqualon_Amount__c * Decimal.valueOf(this.opp.Opportunity_Rating_Overall__c)) / 100;
                        this.opp.Weighted_Opportunity_Revenue__c = (this.opp.Aqualon_Amount__c * Decimal.valueOf(this.opp.Opportunity_Rating_Overall__c)) / 100;
                    }

                    TotalOpportunityValue = this.opp.Aqualon_Amount__c;

                    GetProjectSenseOfUrgencyNoScoreRecalc();

                }

                LogDebugMsg('opp.Customer_Group__c: ' + opp.Customer_Group__c);
                lisdCustomerGroup = opp.Customer_Group__c;
                if (isNull(lisdCustomerGroup))
                    lisdCustomerGroup = '';

                LogDebugMsg('SAPSalesOffice: ' + opp.Sales_Office__c);
                SAPSalesOffice = opp.Sales_Office__c;
                if (isNull(SAPSalesOffice))
                    SAPSalesOffice = '';

                displayCustomerAndMaterial = true;

                OnAshlandResReqChange();

                EnableDisableOverrideRating();

            }
        }
        catch (Exception ex)
        {
            LogException('OnFormLoaded', ex);
            System.debug('*** OnFormLoaded Error: ' + ex);
        }

        LogDebugMsg('Exiting: OnFormLoaded');
    }


    public void setPacIndustry() {
      lisd.setPacIndustry(opp.PAC_Industry_Code__c);
        opp.PAC_Description__c = lisd.getPacIndustryLabel();
    }

public void updateOppStageOnOverride()
{
    LogDebugMsg('Entered: updateOppStageOnOverride');

    Decimal OppOverallRating = 0.0;
    if (this.opp.Opportunity_Rating_Overall__c != null)
        OppOverallRating = Decimal.valueOf(this.opp.Opportunity_Rating_Overall__c);

    if (this.Opp.Override_Stage__c)
    {
        if (OppOverallRating < OppRatingToReachStage2)
        {
            OppStageName = 'Stage 1';

        }
        else if (OppOverallRating < OppRatingToReachStage3)
        {
            OppStageName = 'Stage 2';
        }
        else if (OppOverallRating < OppRatingToReachStage4)
        {
            OppStageName = 'Stage 3';
        }
        else
        {
            OppStageName = 'Stage 4';
        }

        this.Opp.StageName = OppStageName ;
        this.Opp.Stage_Changed_On__c = Date.today() ;

        //Update Weighted Opportunity Revenue
        if (TotalOpportunityValue != null && this.opp.Opportunity_Rating_Overall__c != null)
        {
            WeightedOpportunityRevenueValue = (TotalOpportunityValue * Decimal.valueOf(this.opp.Opportunity_Rating_Overall__c))/100;
            this.opp.Weighted_Opportunity_Revenue__c = (TotalOpportunityValue * Decimal.valueOf(this.opp.Opportunity_Rating_Overall__c))/100;
        }
        //Set Sales Potential
        /*
        if (this.opp.Weighted_Opportunity_Revenue__c != null)
            setSalesPotential();
        */

        //Set Sales Potential based on Total opportunity Value - C1 Testing
        if (TotalOpportunityValue != null)
            setSalesPotential();

        LogDebugMsg('TotalOpportunityValue ' + TotalOpportunityValue);

        LogDebugMsg('Exiting: updateOppStageOnOverride');

    }
}

    private String CurrentPageName()
    {
        String pageName = ApexPages.CurrentPage().getUrl();
        if (pageName != null) {
            pageName = pageName.replaceFirst('/apex/','');
            pageName = EncodingUtil.urlEncode(pageName, 'UTF-8');
            string[] pageNameExtra = pageName.split('%3F',0);
            pageName = pageNameExtra[0];
        }
        return pageName;
    }

    private Boolean RequiredFieldCheckOnSave()
    {
        try
        {
            // primary fields
            errList.clear();

            for (integer i=0; i < FormRequiredFieldNamesList.size(); i++)
            {
                if ( this.opp.get(FormRequiredFieldNamesList[i]) == null)
                {
                    if (FormRequiredFieldNamesList[i] ==  'Result_Reason__c' ||
                        FormRequiredFieldNamesList[i] ==  'Actual_Decision_Date__c')
                    {
                        if (this.opp.Opportunity_Status__c == 'Won' || this.opp.Opportunity_Status__c == 'Lost')
                        {
                            SetFieldRequired(FormRequiredFieldNamesList[i]);
                            errList.add(FormRequiredFieldLabelsList[i] + ' is required for ' +
                                this.opp.Opportunity_Status__c + ' Opportunity');
                            //LogException('RequiredFieldCheckOnSave', FormRequiredFieldLabelsList[i] + ' is required for ' +
                            //    this.opp.Opportunity_Status__c + ' Opportunity');
                            //return false;
                        }
                    }
                    else
                    {
                        SetFieldRequired(FormRequiredFieldNamesList[i]);
                        errList.add(FormRequiredFieldLabelsList[i] + ' is required ');
                        //LogException('RequiredFieldCheckOnSave', FormRequiredFieldLabelsList[i] + ' is required ');
                        //return false;
                    }
                }
            }

            // Opp Mat fields
            if (materialsAdded != null && materialsAdded.size() > 0)
            {
                // Require Quantity and Price
                for (MaterialInfoClass mic:materialsAdded)
                {
                    if ((mic.OppMaterial.Quantity__c == null || mic.OppMaterial.Quantity__c <= 0)
                        || (mic.OppMaterial.Sales_Price__c == null || mic.OppMaterial.Sales_Price__c <= 0))
                    {
                        errList.add('Quantity and Price is required in Material Information section and must be greater than 0');
                        break;
                        //LogException('RequiredFieldCheckOnSave', 'Quantity and Price is required in Material Information section and must be greater than 0');
                        //return false;
                    }
                }

            }
            else
            {
                errList.add('At least one material is required in the Material Information section');
                //LogException('RequiredFieldCheckOnSave', 'At least one material is required in the Material Information section');
                //return false;

            }


        }
        catch (Exception ex)
        {
            LogException('RequiredFieldCheckOnSave', ex);
            return false;
        }

        if (errList.size() > 0)
        {
            LogException(errList);
            return false;
        }
        else
            return true;
    }

    private void SetFieldRequired(String field)
    {
        try
        {
            if (field == 'CloseDate')
                CloseDateRequireStyle = 'error' ;
            else
                CloseDateRequireStyle = null;

            if (field == 'Expected_Revenue_Date__c')
                ExpectedRevenueDateRequireStyle = 'error' ;
            else
                ExpectedRevenueDateRequireStyle = null;

            if (field == 'Current_Year_Revenue_in_Plan__c')
                CurrentYearRevInPlanRequireStyle = 'error' ;
            else
                CurrentYearRevInPlanRequireStyle = null;

            if (field == 'Current_Year_Revenue_Above__c')
                CurrentYearRevAbovePlanRequireStyle = 'error' ;
            else
                CurrentYearRevAbovePlanRequireStyle = null;

            if (field == 'Name')
                OppNameRequireStyle = 'error' ;
            else
                OppNameRequireStyle = null;

            if (field == 'StageName')
                StageNameRequireStyle = 'error' ;
            else
                StageNameRequireStyle = null;

            if (field == 'AccountId')
                AccountIdRequireStyle = 'error' ;
            else
                AccountIdRequireStyle = null;

            if (field == 'CurrencyIsoCode')
                CurrencyIsoCodeRequireStyle = 'error' ;
            else
                CurrencyIsoCodeRequireStyle = null;

            if (field == 'Opportunity_Status__c')
                OpportunityStatusRequireStyle = 'error' ;
            else
                OpportunityStatusRequireStyle = null;

            if (field == 'PAC_Description__c')
                PACDescriptionRequireStyle = 'error' ;
            else
                PACDescriptionRequireStyle = null;

            if (field == 'SBU__c')
                SBURequireStyle = 'error' ;
            else
                SBURequireStyle = null;

            if (field == 'Primary_Competitor__c')
                PrimaryCompetitorRequireStyle = 'error' ;
            else
                PrimaryCompetitorRequireStyle = null;

            if (field == 'Contact__c')
                SupplierContactRequireStyle = 'error' ;
            else
                SupplierContactRequireStyle = null;

            if (field == 'Result_Reason__c')
                ResultReasonRequireStyle = 'error' ;
            else
                ResultReasonRequireStyle = null;

            if (field == 'Actual_Decision_Date__c')
                ActualDecisionDateRequireStyle = 'error' ;
            else
                ActualDecisionDateRequireStyle = null;


        }
        catch (Exception ex)
        {
            LogException('SetFieldRequired', ex);
        }
    }

    // OverrideStageOnChange
    public PageReference OverrideStageOnChange()
    {
        LogDebugMsg('Entered: OverrideStageOnChange');

        LogDebugMsg('Override_Stage__c ' + this.Opp.Override_Stage__c);

        if (this.Opp.Opportunity_Status__c != 'Won'
            && this.Opp.Opportunity_Status__c != 'Lost'
            && this.Opp.Opportunity_Status__c != 'Cancelled by Customer'
            && this.Opp.Opportunity_Status__c != 'Not Pursued by ASI')
        {
            if (!this.Opp.Override_Stage__c)
            {
                Opportunity_Functions.TotalOpportunityValue = TotalOpportunityValue;
                LogDebugMsg('Opportunity_Functions.TotalOpportunityValue = ' + Opportunity_Functions.TotalOpportunityValue);
                LogDebugMsg('Before calculating the ratings Weighted_Opportunity_Revenue__c = ' + Opp.Weighted_Opportunity_Revenue__c);
                Opportunity_Functions.CalculateRatingsFromUI(opp);
                LogDebugMsg('After calculating the ratings Aqualon_Amount__c = ' + Opp.Aqualon_Amount__c);
                LogDebugMsg('After calculating the ratings Weighted_Opportunity_Revenue__c = ' + Opp.Weighted_Opportunity_Revenue__c);
                WeightedOpportunityRevenueValue = Opp.Weighted_Opportunity_Revenue__c;
            }
            else
            {
                //Update Weighted Opportunity Revenue
                if (TotalOpportunityValue != null && this.opp.Opportunity_Rating_Overall__c != null)
                {
                    this.opp.Weighted_Opportunity_Revenue__c = (TotalOpportunityValue * Decimal.valueOf(this.opp.Opportunity_Rating_Overall__c))/100;
                    WeightedOpportunityRevenueValue = Opp.Weighted_Opportunity_Revenue__c;
                }
            }
        }

        LogDebugMsg('Exiting: OverrideStageOnChange');
        return null;
    }


    public string getVCPRatingField()
    {
        if (this.Opp.AccountId != null)
        {
            GetAccountInfo(this.Opp.AccountId);
            //OverrideStageOnChange();
        }

        return this.m_VCPRating;
    }

    public void updateVCPRating()
    {
        //strErrMsg += 'inside updateVCPRating' ;
        if (this.Opp.AccountId != null)
            GetAccountInfo(this.Opp.AccountId);
    }

    public string getRecordTypeId()
    {   return RecordTypeId;
    }
    public string getRecordTypeName()
    {   return RecordTypeName;
    }

    public PageReference redirect() {
        PageReference pr;

        //String param = getParameters() ;

        if (!RECTYPES_1.contains(RecordTypeName)) {
            String prefix = Opportunity.SObjectType.getDescribe().getKeyPrefix();
            //pr = new PageReference('/'+prefix+'/e?nooverride=1&'+param);
            pr = new PageReference('/' + prefix + '/e');
        } else {
            //pr = new PageReference('/apex/OpportunityCPIV3?'+param);
            pr = Page.OpportunityCPIV3;
            //pr.setRedirect(true);
        }
        pr.getParameters().putAll(ApexPages.currentPage().getParameters());
        pr.getParameters().put('nooverride', '1');
        pr.getParameters().remove('save_new');
        return pr.setRedirect(true);
    }

    // Overriding Cancel behaviour otherwise it was going back to the Home page
    // instead of Opp home page when cancel is clicked on the opportunityaqualon
    // VF page
    public PageReference cancel(){
        try
        {
            PageReference oppHome;
            //PageReference oppHome = new PageReference('/006/o');
            if (strRetURLParam == null)
                 oppHome = new PageReference(strCancelURLParam);
            else
                 oppHome = new PageReference(strRetURLParam);
            oppHome.setRedirect(true);
            return oppHome;
        }
        catch (Exception ex)
        {
            LogException('cancel', ex);
        }
        return null;

    }

    public PageReference save()
    {
        try
        {
            // SS - dont remove this line. for some reason opp standard page doens't show correct value
            // even when the code has the correct value
            LogDebugMsg('save this.opp.Weighted_Opportunity_Revenue__c = ' + this.opp.Weighted_Opportunity_Revenue__c);

            if (RequiredFieldCheckOnSave() == true)
            {
                //return stdCtrl.save();

                Savepoint sp = Database.setSavepoint();

                if (!customSave())
                {
                    Database.rollback(sp);
                    return null;
                }
                else
                {
                    // if a new Opp is created go to that opp
                    if (isOppCreated)
                    {
                        return new PageReference('/' + this.Opp.id);
                    }
                    else // otherwise go back to where came from
                        return cancel();
                }


            }
            else
                return null;
        }
        catch (Exception ex)
        {
            LogException('save', ex);
        }
        return null;

    }

    public Boolean customSave()
    {
        Boolean returnValue = False;

        try
        {
            //Set sfdc Opportunity.Probability field
            if (this.Opp.Opportunity_Rating_Overall__c != null)
                this.Opp.Probability = double.valueOf(this.Opp.Opportunity_Rating_Overall__c);

            /*
            //Update Weighted Opportunity Revenue
            LogDebugMsg('customSave TotalOpportunityValue = ' + TotalOpportunityValue);
            LogDebugMsg('customSave this.opp.Opportunity_Rating_Overall__c = ' + this.opp.Opportunity_Rating_Overall__c);
            if (TotalOpportunityValue != null && this.opp.Opportunity_Rating_Overall__c != null)
            {
                this.opp.Weighted_Opportunity_Revenue__c = (TotalOpportunityValue * Decimal.valueOf(this.opp.Opportunity_Rating_Overall__c))/100;
            }
            LogDebugMsg('customSave before upsert this.opp.Weighted_Opportunity_Revenue__c = ' + this.opp.Weighted_Opportunity_Revenue__c);
            */

            //NOTE: using Database.upsert to customized the errors displayed
            Database.UpsertResult result = Database.upsert(this.opp);

            //LogDebugMsg('customSave after upsert this.opp.Weighted_Opportunity_Revenue__c = ' + this.opp.Weighted_Opportunity_Revenue__c);

            if (result != null)
            {
                //strErrMsg += 'result.getId(): ' + result.getId();

                if (result.isSuccess())
                {
                    isOppCreated = result.isCreated();

                    // upsert opp materials
                    if (!materialInfoMap.isEmpty())
                    {
                        LogDebugMsg('customSave before upsert materialInfoMap: ' + materialInfoMap);
                        List<MaterialInfoClass> addUpdateMatsList = materialInfoMap.values();
                        LogDebugMsg('customSave before upsert addUpdateMatsList: ' + addUpdateMatsList);

                        if (addUpdateMatsList.size() > 0)
                        {
                            Opportunity_Material__c[] OppMaterials = new Opportunity_Material__c[]{};
                            for (MaterialInfoClass mic:addUpdateMatsList)
                            {

                                if (mic.OppMaterial.Opportunity__c == null)
                                    mic.OppMaterial.Opportunity__c = this.opp.id; //result.getId();

                                mic.OppMaterial.Unit_of_Measure__c = mic.materialUoMSelect;

                                // Set Opp Mat currency same as Opportunity
                                mic.OppMaterial.CurrencyIsoCode = this.opp.CurrencyIsoCode ;

                                OppMaterials.add(mic.OppMaterial);

                            }
                            //upsert OppMaterials;
                            Database.UpsertResult[] result2 = Database.upsert(OppMaterials);
                            if (result2 != null)
                            {

                                String strErrString = '';

                                for (Database.Upsertresult upResult: result2)
                                {
                                    for (Database.Error err:upResult.getErrors())
                                    {
                                        strErrString =
                                        'Status Code: ' + err.getStatusCode() + '</BR>' +
                                        'Message: ' + err.getMessage() + '</BR>' ;
                                    }
                                }

                                if (strErrString != '')
                                {
                                    LogException('customSave', 'Error in method customSave, saving Opportunity Materials: </BR>' +
                                        strErrString + '</BR>'
                                        );

                                    return False;
                                }

                            }
                            LogDebugMsg('customSave after upsert materialInfoMap: ' + materialInfoMap);
                            LogDebugMsg('customSave after upsert addUpdateMatsList: ' + addUpdateMatsList);
                        }

                    }
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
                            LogException('customSave', 'Error in method customSave, saving Opportunity: </BR>' +
                                strErrString + '</BR>');
                            return False;
                        }
                    }
                }
            }
            //*/
            returnValue = True;
        }
        catch(System.DmlException dex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, dex.getDmlMessage(0)));
        }
        catch (Exception ex)
        {

            if (ex.getTypeName() == 'CustomException')
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            }
            else
                LogException('customSave', ex);
        }

        return returnValue;

    }

    private void GetQueryStringParams()
    {
        strRecordTypeParam = ApexPages.currentPage().getParameters().get('RecordType');
        strRetURLParam = ApexPages.currentPage().getParameters().get('retURL');
        strCancelURLParam = ApexPages.currentPage().getParameters().get('cancelURL');
        if (strCancelURLParam == null)
            strCancelURLParam = '/006/o';
        strAccidParam = ApexPages.currentPage().getParameters().get('accid');
        strOppIdParam = ApexPages.currentPage().getParameters().get('id');
        strConIdParam = ApexPages.currentPage().getParameters().get('conid');
        if (ApexPages.currentPage().getParameters().get('debug') != null)
            renderDebugPanel = true;


    }

    private void GetAccountInfo(string strAccountId)
    {
        renderConfirmDialogComp = false;
        try
        {
            //System.Debug('Inside GetAccountInfo param strAccountId = ' + strAccountId);
            acc = [select Id, Name, Inactive_Account__c, Customer_Classification_ABC__c, SAP_Sales_Office__c,
                    SAP_DistChannel__c, SAP_Sales_Org__c
                    from Account
                    where Id = :strAccountId];

            if (acc != null)
            {

                this.Opp.Customer_Prospect__r = acc;
                this.Opp.AccountId = acc.Id;
                this.m_VCPRating = acc.Customer_Classification_ABC__c;
                this.SAPDistChannel = acc.SAP_DistChannel__c;
                this.SAPSalesOrg = acc.SAP_Sales_Org__c;
                this.Opp.Account = acc;
                setDefaultMat1();

                if (acc.Inactive_Account__c != null && acc.Inactive_Account__c) {
                    activeAccount = false;
                    initConfirmDialog();
                }
                else
                {
                    activeAccount = true;
                    CreatingFromAccountPage = true;
                }

            }

        }
        catch (Exception ex)
        {
            //LogException('GetAccountInfo', 'strAccountId: '+ strAccountId + '</br>ex.getMessage: ' + ex.getMessage());

            if ((strAccountId == '' || strAccountId == '000000000000000') && ex.getMessage() == 'List has no rows for assignment to SObject')
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
            //ShowForm('renderOppForm');
            //OnFormLoaded();
        }
    }

    private void initConfirmDialog() {
        if (cdp == null) {cdp = new ConfirmDialogParam();}
        cdp.cancelUrl = strRetURLParam;
        cdp.warnMsg1 = 'Account is marked for deletion. Continue creating Opportunity?';
        renderConfirmDialogComp = cdp.renderComp;
    }

    private void GetContactInfo(string strContactId)
    {
        Contact cont;
        try
        {
            System.Debug('GetContactInfo: Entered');

            System.Debug('strContactId: ' + strContactId);

            cont = [select Id, AccountId, Name
                    from Contact
                    where Id = :strContactId];

            System.Debug('Before setting this.Opp.Contact__c: ' + this.Opp.Contact__c);

            this.Opp.Contact__c = cont.Id;
            contactName = cont.Name;

            System.Debug('cont.Id: ' + cont.Id);

            System.Debug('After setting this.Opp.Contact__c: ' + this.Opp.Contact__c);

            if (cont.AccountId != null && this.Opp.AccountId == null)
                GetAccountInfo(cont.AccountId);

        }
        catch (Exception ex)
        {
            LogException('GetContactInfo', ex);

        }

        System.Debug('GetContactInfo: Exit');
    }

    private void GetCoachInfo(string strContactId)
    {
        Contact cont;
        try
        {
            System.Debug('GetCoachInfo: Entered');

            System.Debug('strContactId: ' + strContactId);

            cont = [select Id, AccountId, Name
                    from Contact
                    where Id = :strContactId];

            System.Debug('Before setting this.Opp.Coach_Champion_Contact__c: ' + this.Opp.Coach_Champion_Contact__c);

            this.Opp.Coach_Champion_Contact__c = cont.Id;
            coachName = cont.Name;

            System.Debug('cont.Id: ' + cont.Id);

            System.Debug('After setting this.Opp.Coach_Champion_Contact__c: ' + this.Opp.Coach_Champion_Contact__c);


        }
        catch (Exception ex)
        {
            LogException('GetCoachInfo', ex);

        }

        System.Debug('GetCoachInfo: Exit');
    }

    private void GetEvaluatorInfo(string strContactId)
    {
        Contact cont;
        try
        {
            LogDebugMsg('GetEvaluatorInfo: Entered');

            System.Debug('strContactId: ' + strContactId);

            cont = [select Id, AccountId, Name
                    from Contact
                    where Id = :strContactId];

            LogDebugMsg('Before setting this.Opp.Evaluator_Formulator_Contact__c: ' + this.Opp.Evaluator_Formulator_Contact__c);

            this.Opp.Evaluator_Formulator_Contact__c = cont.Id;
            evaluatorName = cont.Name;

            LogDebugMsg('cont.Id: ' + cont.Id);

            LogDebugMsg('After setting this.Opp.Evaluator_Formulator_Contact__c: ' + this.Opp.Evaluator_Formulator_Contact__c);


        }
        catch (Exception ex)
        {
            LogException('GetEvaluatorInfo', ex);

        }

        System.Debug('GetEvaluatorInfo: Exit');
    }

    private void GetEconBuyerInfo(string strContactId)
    {
        Contact cont;
        try
        {
            System.Debug('GetEconBuyerInfo: Entered');

            System.Debug('strContactId: ' + strContactId);

            cont = [select Id, AccountId, Name
                    from Contact
                    where Id = :strContactId];

            System.Debug('Before setting this.Opp.Value_Descision_Maker_Economic_Buyer_Con__c: ' + this.Opp.Value_Descision_Maker_Economic_Buyer_Con__c);

            this.Opp.Value_Descision_Maker_Economic_Buyer_Con__c = cont.Id;
            econBuyerName = cont.Name;

            System.Debug('cont.Id: ' + cont.Id);

            System.Debug('After setting this.Opp.Value_Descision_Maker_Economic_Buyer_Con__c: ' + this.Opp.Value_Descision_Maker_Economic_Buyer_Con__c);


        }
        catch (Exception ex)
        {
            LogException('GetEconBuyerInfo', ex);

        }

        System.Debug('GetEconBuyerInfo: Exit');
    }

    private void GetCompetitorInfo(string strCompetitorId)
    {
        Competitor__c comp;
        try
        {
            System.Debug('GetCompetitorInfo: Entered');

            System.Debug('strCompetitorId: ' + strCompetitorId);

            comp = [select Id, Name
                    from Competitor__c
                    where Id = :strCompetitorId];

            System.Debug('Before setting this.Opp.Primary_Competitor__c: ' + this.Opp.Primary_Competitor__c);

            this.Opp.Primary_Competitor__c = comp.Id;
            competitorName = comp.Name;

            System.Debug('comp.Id: ' + comp.Id);

            System.Debug('After setting this.Opp.Primary_Competitor__c: ' + this.Opp.Primary_Competitor__c);


        }
        catch (Exception ex)
        {
            LogException('GetCompetitorInfo', ex);

        }

        System.Debug('GetCompetitorInfo: Exit');
    }

    private void GetCompLostWonInfo(string strCompetitorId)
    {
        Competitor__c comp;
        try
        {
            System.Debug('GetCompLostWonInfo: Entered');

            System.Debug('strCompetitorId: ' + strCompetitorId);

            comp = [select Id, Name
                    from Competitor__c
                    where Id = :strCompetitorId];

            System.Debug('Before setting this.Opp.Competitor_Lost_To_Won_From__c: ' + this.Opp.Competitor_Lost_To_Won_From__c);

            this.Opp.Competitor_Lost_To_Won_From__c = comp.Id;
            compLostWonName = comp.Name;

            System.Debug('comp.Id: ' + comp.Id);

            System.Debug('After setting this.Opp.Competitor_Lost_To_Won_From__c: ' + this.Opp.Competitor_Lost_To_Won_From__c);


        }
        catch (Exception ex)
        {
            LogException('GetCompLostWonInfo', ex);

        }

        System.Debug('GetCompLostWonInfo: Exit');
    }

    private void SetRecordTypeIdAndName() {
        RecordTypeName = '';
        RecordTypeId = this.opp.RecordTypeId;


        // if record type value is passed in use that
        if (strRecordTypeParam != null)
        {
            for (RecordType rt: [select id,name from recordtype where id = :strRecordTypeParam]) {
                RecordTypeId = rt.id;
                RecordTypeName = rt.name;

                this.opp.RecordTypeId = RecordTypeId;
            }

        }
        else //otherwise
        {
            // If the controller didn't have this value get the Opp default
            if (RecordTypeId == null) {
                RecordTypeId = RecordType_Functions.getDefaultRecordTypeId('Opportunity');


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
        String[] keys = new String[]{'RecordType', 'retURL', 'cancelURL', 'accid', 'id', 'conid'};
        for(String s : keys){
            if(strMap.containsKey(S)) param += s + '=' +  strMap.get(s) + '&';
        }
        if(param.length() > 0) param = param.substring(0, param.length()-1);
        return param;
    }

    private Decimal GetOppRatingConfigScore2For(
        String fieldName)
    {
        Decimal returnValue = 0.0;
        List<Opportunity_Rating_Configuration__c> oppRatingConfig;
        string fieldValue;
        String oppRatingConfigSQL = '';

        try
        {
            if (fieldName == 'VCP_Rating__c')
                fieldValue = this.m_VCPRating;
            else
                fieldValue = String.valueOf(this.Opp.get(fieldName)).trim();

            String key = fieldName+fieldValue.replace(' ', '');
            LogDebugMsg('Key: ' + key.toLowerCase());
            returnValue = orcFuncs.GetScoreForFieldValueFromMap(key.toLowerCase());
            if (returnValue == null) returnValue = 0.0;
            LogDebugMsg('fieldValueScore: ' + returnValue);

        }
        catch (Exception ex)
        {
            LogException('GetOppRatingConfigScore2For', ex);
        }

        return  returnValue ;


    }

    public PageReference OpportunityStatusChange()
    {

        if (this.Opp.Opportunity_Status__c == 'Won')
        {
            if (TotalOpportunityValue == null) TotalOpportunityValue = 0;
            this.Opp.Opportunity_Rating_Overall__c = '100';
            WeightedOpportunityRevenueValue = (TotalOpportunityValue * Decimal.valueOf(this.opp.Opportunity_Rating_Overall__c))/100;
            this.opp.Weighted_Opportunity_Revenue__c = WeightedOpportunityRevenueValue;
            this.Opp.Override_Stage__c = false;
        }
        else if (this.Opp.Opportunity_Status__c == 'Lost' || this.Opp.Opportunity_Status__c == 'Cancelled by Customer'
            || this.Opp.Opportunity_Status__c == 'Not Pursued by ASI')
        {
            //this.Opp.Opportunity_Rating_Overall__c = '0';
            //WeightedOpportunityRevenueValue = (TotalOpportunityValue * Decimal.valueOf(this.opp.Opportunity_Rating_Overall__c))/100;
            WeightedOpportunityRevenueValue = 0;
            this.opp.Weighted_Opportunity_Revenue__c = WeightedOpportunityRevenueValue;
            this.Opp.Override_Stage__c = false;
        }
        else
        {
            OverrideStageOnChange();
        }

        return null;
    }


    public PageReference ShowHideStages()
    {
        if (this.Opp.Type__c != null &&
            (this.Opp.Type__c.contains('Price Increase')
                || this.Opp.Type__c.contains('Upside Volume')
                || this.Opp.Type__c.contains('Spot Opportunity')
                )
            )
        {
            renderStage1Section = false;
            renderStage2Section = false;
            renderStage3Section = false;
            renderStage4Section = false;
            this.Opp.Override_Stage__c = true;
        }
        else
        {
            renderStage1Section = true;
            renderStage2Section = true;
            renderStage3Section = true;
            renderStage4Section = true;
            // SS - Request-5833 - don't uncheck if it's overridden
            if (!this.Opp.Override_Stage__c)
                this.Opp.Override_Stage__c = false;
        }

        EnableDisableOverrideRating(); checkForDefaultMat1();

        return null;

    }

    private void checkForDefaultMat1() {
        if (defaultMat1 == null || defaultMat1.Id == null) {return;}
        if (Opp.Type__c != null && (
            Opp.Type__c.contains('New Product - New to ASI') ||
            Opp.Type__c.contains('New Product - New to the World'))) {
            if (!defaultMat1Added) {
                defaultMat1Added = addMaterialToOpp(defaultMat1);
            }
        } else if (defaultMat1Added) {
            deleteMaterial(defaultMat1.Id); defaultMat1Added = false;
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
    }

    private void LogException(string methodName, string strErrMsg)
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strErrMsg));

        System.debug(methodName + strErrMsg);
    }

    private void LogException(List<string> ErrMsgList)
    {
        String sDetails = '';
        for (String s : ErrMsgList) {sDetails += '</br>' + s;}
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, sDetails));

        System.debug(sDetails);
    }

    public List<SelectOption> getAltUoms(Id mgd2Id)
    {
        LogDebugMsg('Entered: getAltUoms');
        Boolean blnUSPoundsExists = false;
        Boolean blnKGExists = false;

        List<SelectOption> UomsSelOpForMatList = new List<SelectOption>();

        LogDebugMsg('About to call Material_UOM_Functions.getMaterialUoms');

        List<SAP_UOM_Description__c> UomList = Material_UOM_Functions.getMaterialUoms(mgd2Id);

        LogDebugMsg('UomList null? ' + String.ValueOf(UomList == null));

        if (UomList != null)
        {
            for (SAP_UOM_Description__c uom : UomList) {

                UomsSelOpForMatList.add(new SelectOption(uom.UOM_Code__c, uom.UOM_Description__c));
            }
        }

        LogDebugMsg('Exiting: getAltUoms');
        return UomsSelOpForMatList;

    }


    public class MaterialSearchWrapper {
        public Material_Sales_Data2__c material{get;set;}
        public boolean addToOpp{get;set;}
        public Opportunity_Material__c OppMaterial{get;set;}
        public boolean displayDeleteCheckBox{get;set;}
        public String materialNumber{get;set;}
        public Integer recordNumber {get; set;}

        public MaterialSearchWrapper() {this(null);}

        public MaterialSearchWrapper(Material_Sales_Data2__c m) {this(m, 1);}

        public MaterialSearchWrapper(Material_Sales_Data2__c m, Integer n) {
            addToOpp = false; material = m; recordNumber = n;
            if (m != null && m.Material_Number__c != null) {
                materialNumber = String_Functions.removeLeadingZeros(m.Material_Number__c);
            }
        }


    }

    public class MaterialInfoClass {

        public Opportunity_Material__c OppMaterial {get;set;}
        public boolean deleteMaterial{get;set;}
        public boolean displayDeleteCheckBox{get; set;}
        public String oppId{get;set;}
        public Decimal AQRevenueLocal{get; set;}
        public String materialUoMSelect {get; set;}
        public List<SelectOption> materialUoMSelectoptions {get; set;}
    }


// *** Start: Used by the Contact search form ***
    public PageReference searchContacts() {

        ShowForm('renderContactForm');
        renderMaxMsg1 = false;
        contacts = new List<Contact>();

        try {
            System.Debug('searchContacts: opp.AccountId = ' + opp.AccountId);
            if (opp.AccountId == null)
            {
                String errMsg = 'Missing Account information. Please select an account first or contact System Administrator';
                CustomException.throwException(errMsg);
                return null;
            }

            String q = 'SELECT id, Name, Email, Phone, MailingCity, MailingCountry, VCP_Rating__c, RecordType.Name, AccountId, Account.Name ';
            q += 'FROM Contact WHERE WV_Contact_Status__c = \'Active\' ';

            if (opp.Account_End_Customer__c != null)
                q += ' and (AccountId  = \'' + opp.AccountId + '\' or AccountId  = \'' + opp.Account_End_Customer__c + '\')';
            else
                q += ' and AccountId  = \'' + opp.AccountId + '\'';

            if (!isNull(contactName)) {q += ' and Name like \'%' + contactName + '%\'';}
            q += ' order by Name';
            q += ' limit ' + String.valueOf(MAX_COUNT_1 + 1);

            LogDebugMsg('searchContacts: q = ' + q) ;
            contacts = Database.query(q);
            renderContactsList = (contacts != null && !contacts.isEmpty());
            renderMaxMsg1 = rendercontactsList && contacts.size() > MAX_COUNT_1;


        }
        catch(Exception ex)
        {
            if (ex.getTypeName() == 'CustomException')
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            }
            else
                LogException('searchContacts', ex);
        }
        return null;
    }

    public PageReference cancelSearchContacts() {
        ShowForm('renderOppForm');
        return null;
    }

    public List<Contact> getContacts() {
        if ( contacts == null ) {
          try {
          contacts = [SELECT id, Name, Email, Phone, MailingCity, MailingCountry, VCP_Rating__c, RecordType.Name
                        FROM Contact
                        WHERE WV_Contact_Status__c = 'Active' and AccountId = : opp.AccountId]; }
           catch (Exception e) {}

          }
        return contacts;
    }

// *** End: Used by the Contact search form ***

// *** Start: Used by the Coach search form ***
    public PageReference searchCoaches() {

        LogDebugMsg('Entered: searchCoaches');
        ShowForm('renderCoachForm');
        renderMaxMsg1 = false;
        coaches = new List<Contact>();

        try {
            System.Debug('searchCoaches: opp.AccountId = ' + opp.AccountId);
            if (opp.AccountId == null)
            {
                String errMsg = 'Missing Account information. Please select an account first or contact System Administrator';
                CustomException.throwException(errMsg);
                return null;
            }
            String accId = opp.AccountId;

            String q = 'SELECT id, Name, Email, Phone, MailingCity, MailingCountry, VCP_Rating__c, RecordType.Name, AccountId, Account.Name ';
            q += 'FROM Contact WHERE WV_Contact_Status__c = \'Active\' ';

            if (opp.Account_End_Customer__c != null)
                q += ' and (AccountId  = \'' + opp.AccountId + '\' or AccountId  = \'' + opp.Account_End_Customer__c + '\')';
            else
                q += ' and AccountId  = \'' + opp.AccountId + '\'';

            if (!isNull(coachName)) {q += ' and Name like \'%' + coachName + '%\'';}
            q += ' order by Name';
            q += ' limit ' + String.valueOf(MAX_COUNT_1 + 1);

            LogDebugMsg('searchCoaches: q = ' + q) ;
            coaches = Database.query(q);
            renderCoachesList = (coaches != null && !coaches.isEmpty());
            renderMaxMsg1 = rendercoachesList && coaches.size() > MAX_COUNT_1;


        }
        catch(Exception ex)
        {
            if (ex.getTypeName() == 'CustomException')
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            }
            else
                LogException('searchCoaches', ex);
        }
        LogDebugMsg('Exiting: searchCoaches');
        return null;
    }

    public PageReference cancelSearchCoaches() {
        FocusField = 'coachfld';
        ShowForm('renderOppForm');
        return null;
    }

    public List<Contact> getCoaches() {
        if ( coaches == null ) {
          try {
          coaches = [SELECT id, Name, Email, Phone, MailingCity, MailingCountry, VCP_Rating__c, RecordType.Name
                        FROM Contact
                        WHERE WV_Contact_Status__c = 'Active' and AccountId = : opp.AccountId]; }
           catch (Exception e) {}

          }
        return coaches;
    }

// *** End: Used by the Coach search form ***

// *** Start: Used by the Evaluator search form ***
    public PageReference searchEvaluators() {

        ShowForm('renderEvaluatorForm');
        renderMaxMsg1 = false;
        evaluators = new List<Contact>();

        try {
            System.Debug('searchEvaluator: opp.AccountId = ' + opp.AccountId);
            if (opp.AccountId == null)
            {
                String errMsg = 'Missing Account information. Please select an account first or contact System Administrator';
                CustomException.throwException(errMsg);
                return null;
            }
            String accId = opp.AccountId;

            String q = 'SELECT id, Name, Email, Phone, MailingCity, MailingCountry, VCP_Rating__c, RecordType.Name, AccountId, Account.Name ';
            q += 'FROM Contact WHERE WV_Contact_Status__c = \'Active\' ';

            if (opp.Account_End_Customer__c != null)
                q += ' and (AccountId  = \'' + opp.AccountId + '\' or AccountId  = \'' + opp.Account_End_Customer__c + '\')';
            else
                q += ' and AccountId  = \'' + opp.AccountId + '\'';

            if (!isNull(evaluatorName)) {q += ' and Name like \'%' + evaluatorName + '%\'';}
            q += ' order by Name';
            q += ' limit ' + String.valueOf(MAX_COUNT_1 + 1);

            LogDebugMsg('searchEvaluator: q = ' + q) ;
            evaluators = Database.query(q);
            renderEvaluatorsList = (evaluators != null && !evaluators.isEmpty());
            renderMaxMsg1 = renderEvaluatorsList && evaluators.size() > MAX_COUNT_1;


        }
        catch(Exception ex)
        {
            if (ex.getTypeName() == 'CustomException')
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            }
            else
                LogException('searchEvaluator', ex);
        }
        return null;
    }

    public PageReference cancelSearchEvaluators() {
        FocusField = 'evaluatorfld';
        ShowForm('renderOppForm');
        return null;
    }

    public List<Contact> getEvaluators() {
        if ( evaluators == null ) {
          try {
          evaluators = [SELECT id, Name, Email, Phone, MailingCity, MailingCountry, VCP_Rating__c, RecordType.Name
                        FROM Contact
                        WHERE WV_Contact_Status__c = 'Active' and AccountId = : opp.AccountId]; }
           catch (Exception e) {}

          }
        return evaluators;
    }

// *** End: Used by the Evaluator search form ***

// *** Start: Used by the Econ Buyer search form ***
    public PageReference searchEconBuyers() {

        ShowForm('renderEconBuyerForm');
        renderMaxMsg1 = false;
        econBuyers = new List<Contact>();

        try {
            System.Debug('searchEconBuyers: opp.AccountId = ' + opp.AccountId);
            if (opp.AccountId == null)
            {
                String errMsg = 'Missing Account information. Please select an account first or contact System Administrator';
                CustomException.throwException(errMsg);
                return null;
            }
            String accId = opp.AccountId;

            String q = 'SELECT id, Name, Email, Phone, MailingCity, MailingCountry, VCP_Rating__c, RecordType.Name, AccountId, Account.Name ';
            q += 'FROM Contact WHERE WV_Contact_Status__c = \'Active\' ';

            if (opp.Account_End_Customer__c != null)
                q += ' and (AccountId  = \'' + opp.AccountId + '\' or AccountId  = \'' + opp.Account_End_Customer__c + '\')';
            else
                q += ' and AccountId  = \'' + opp.AccountId + '\'';

            if (!isNull(econBuyerName)) {q += ' and Name like \'%' + econBuyerName + '%\'';}
            q += ' order by Name';
            q += ' limit ' + String.valueOf(MAX_COUNT_1 + 1);

            LogDebugMsg('searchEconBuyers: q = ' + q) ;
            econBuyers = Database.query(q);
            renderEconBuyersList = (econBuyers != null && !econBuyers.isEmpty());
            renderMaxMsg1 = renderEconBuyersList && econBuyers.size() > MAX_COUNT_1;


        }
        catch(Exception ex)
        {
            if (ex.getTypeName() == 'CustomException')
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            }
            else
                LogException('searchEconBuyers', ex);
        }
        return null;
    }

    public PageReference cancelSearchEconBuyers() {
        FocusField = 'econBuyerfld';
        ShowForm('renderOppForm');
        return null;
    }

    public List<Contact> getEconBuyers() {
        if ( econBuyers == null ) {
          try {
          econBuyers = [SELECT id, Name, Email, Phone, MailingCity, MailingCountry, VCP_Rating__c, RecordType.Name
                        FROM Contact
                        WHERE WV_Contact_Status__c = 'Active' and AccountId = : opp.AccountId]; }
           catch (Exception e) {}

          }
        return econBuyers;
    }

// *** End: Used by the Econ Buyer search form ***


// *** Start: Used by the Primary Competitor search form ***
    public PageReference searchCompetitors() {

        ShowForm('renderCompetitorForm');
        renderMaxMsg1 = false;
        competitors = new List<Competitor__c>();

        try {

            String q = 'Select id, Name, Location__c, AAFIIndustry__c, Status__c ';
            q += 'FROM Competitor__c WHERE Competes_With__c Includes (\'AAFI\') ';
            if (!isNull(competitorName)) {q += ' and Name like \'%' + competitorName + '%\'';}
            q += ' order by Name';
            q += ' limit ' + String.valueOf(MAX_COUNT_1 + 1);

            LogDebugMsg('searchCompetitors: q = ' + q) ;
            competitors = Database.query(q);
            renderCompetitorsList = (competitors != null && !competitors.isEmpty());
            renderMaxMsg1 = renderCompetitorsList && competitors.size() > MAX_COUNT_1;


        }
        catch(Exception ex)
        {
            if (ex.getTypeName() == 'CustomException')
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            }
            else
                LogException('searchCompetitors', ex);
        }
        return null;
    }

    public PageReference cancelSearchCompetitors() {
        ShowForm('renderOppForm');
        return null;
    }

    public List<Competitor__c> getCompetitors() {
        if ( Competitors == null )
        {
            try
            {
              Competitors = [Select id, Name, Location__c, AAFIIndustry__c, Status__c
                            FROM Competitor__c
                            WHERE Competes_With__c Includes ('AAFI')];
            }
            catch (Exception e) {}
        }
        return Competitors;
    }

// *** End: Used by the Primary Competitor search form ***


// *** Start: Used by the Competitor Lost To/Won From search form ***
    public PageReference searchCompsLostWon() {
        ShowForm('renderCompLostWonForm');
        renderMaxMsg1 = false;
        CompsLostWon = new List<Competitor__c>();

        try {

            String q = 'Select id, Name, Location__c, AAFIIndustry__c, Status__c ';
            q += 'FROM Competitor__c WHERE Competes_With__c Includes (\'AAFI\') ';
            if (!isNull(compLostWonName)) {q += ' and Name like \'%' + compLostWonName + '%\'';}
            q += ' order by Name';
            q += ' limit ' + String.valueOf(MAX_COUNT_1 + 1);

            LogDebugMsg('searchCompsLostWon: q = ' + q) ;
            CompsLostWon = Database.query(q);
            renderCompsLostWonList = (CompsLostWon != null && !CompsLostWon.isEmpty());
            renderMaxMsg1 = renderCompsLostWonList && CompsLostWon.size() > MAX_COUNT_1;


        }
        catch(Exception ex)
        {
            if (ex.getTypeName() == 'CustomException')
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            }
            else
                LogException('searchCompsLostWon', ex);
        }
        return null;
    }

    public PageReference cancelSearchCompsLostWon() {
        FocusField = 'compLostWonfld';
        ShowForm('renderOppForm');
        return null;
    }

    public List<Competitor__c> getCompsLostWon() {

        if ( CompsLostWon == null )
        {
            try
            {
              CompsLostWon = [Select id, Name, Location__c, AAFIIndustry__c, Status__c
                            FROM Competitor__c
                            WHERE Competes_With__c Includes ('AAFI')];
            }
            catch (Exception e) {}
        }
        return CompsLostWon;

    }

// *** End: Used by the Competitor Lost To/Won From search form ***



    private void ShowForm(String formToshow)
    {
        if (formToshow == 'renderOppForm')
        {
            displayOpportunityPage = true;
            renderContactForm = false;
            displayMaterialSelector = false;
            renderCoachForm = false;
            renderEvaluatorForm = false;
            renderEconBuyerForm = false;
            renderCompetitorForm = false;
            renderCompLostWonForm = false;
            renderLisd = false;
            renderConfirmDialogComp = false;
        }
        else if (formToshow == 'renderContactForm')
        {
            renderContactForm = true;
            displayOpportunityPage = false;
            displayMaterialSelector = false;
            renderCoachForm = false;
            renderEvaluatorForm = false;
            renderEconBuyerForm = false;
            renderCompetitorForm = false;
            renderCompLostWonForm = false;
            renderLisd = false;
            renderConfirmDialogComp = false;
        }
        else if (formToshow == 'renderMateriaSelectorForm')
        {
            displayMaterialSelector = true;
            displayOpportunityPage = false;
            renderContactForm = false;
            renderCoachForm = false;
            renderEvaluatorForm = false;
            renderEconBuyerForm = false;
            renderCompetitorForm = false;
            renderCompLostWonForm = false;
            renderLisd = false;
            renderConfirmDialogComp = false;
        }
        else if (formToshow == 'renderCoachForm')
        {
            renderCoachForm = true;
            renderContactForm = false;
            displayOpportunityPage = false;
            displayMaterialSelector = false;
            renderEvaluatorForm = false;
            renderEconBuyerForm = false;
            renderCompetitorForm = false;
            renderCompLostWonForm = false;
            renderLisd = false;
            renderConfirmDialogComp = false;
        }
        else if (formToshow == 'renderEvaluatorForm')
        {
            renderEvaluatorForm = true;
            renderCoachForm = false;
            renderContactForm = false;
            displayOpportunityPage = false;
            displayMaterialSelector = false;
            renderEconBuyerForm = false;
            renderCompetitorForm = false;
            renderCompLostWonForm = false;
            renderLisd = false;
            renderConfirmDialogComp = false;
        }
        else if (formToshow == 'renderEconBuyerForm')
        {
            renderEconBuyerForm = true;
            renderEvaluatorForm = false;
            renderCoachForm = false;
            renderContactForm = false;
            displayOpportunityPage = false;
            displayMaterialSelector = false;
            renderCompetitorForm = false;
            renderCompLostWonForm = false;
            renderLisd = false;
            renderConfirmDialogComp = false;
        }
        else if (formToshow == 'renderCompetitorForm')
        {
            renderCompetitorForm = true;
            renderEconBuyerForm = false;
            renderEvaluatorForm = false;
            renderCoachForm = false;
            renderContactForm = false;
            displayOpportunityPage = false;
            displayMaterialSelector = false;
            renderCompLostWonForm = false;
            renderLisd = false;
            renderConfirmDialogComp = false;
        }
        else if (formToshow == 'renderCompLostWonForm')
        {
            renderCompLostWonForm = true;
            renderCompetitorForm = false;
            renderEconBuyerForm = false;
            renderEvaluatorForm = false;
            renderCoachForm = false;
            renderContactForm = false;
            displayOpportunityPage = false;
            displayMaterialSelector = false;
            renderLisd = false;
            renderConfirmDialogComp = false;
        }
        else if (formToShow == 'renderConfirmDialogComp')
        {
            renderConfirmDialogComp = true;
            renderCompLostWonForm = false;
            renderCompetitorForm = false;
            renderEconBuyerForm = false;
            renderEvaluatorForm = false;
            renderCoachForm = false;
            renderContactForm = false;
            displayOpportunityPage = false;
            renderLisd = false;
            displayMaterialSelector = false;
        }



    }

    private Boolean isNull(String s) {return (s == null || s.trim().length() == 0);}

    public PageReference ContactOnChangeEvent()
    {
        LogDebugMsg('Entered: ContactOnChangeEvent');
        try
        {
            if (contactName != null && contactName!= '')
            {

            }
            else
            {
                opp.Contact__c = null;

            }

        }
        catch (Exception ex)
        {
            LogException('ContactOnChangeEvent', ex);
        }
        return null;
    }

    public PageReference CoachOnChangeEvent()
    {
        LogDebugMsg('Entered: CoachOnChangeEvent');
        try
        {
            LogDebugMsg('coachName = ' + coachName);
            if (coachName != null && coachName != '')
            {

            }
            else
            {
                opp.Coach_Champion_Contact__c = null;

            }
            LogDebugMsg('opp.Coach_Champion_Contact__c = ' + opp.Coach_Champion_Contact__c);
        }
        catch (Exception ex)
        {
            LogException('CoachOnChangeEvent', ex);
        }
        LogDebugMsg('Exiting: CoachOnChangeEvent');
        return null;
    }

    public PageReference EvaluatorOnChangeEvent()
    {
        LogDebugMsg('Entered: EvaluatorOnChangeEvent');
        try
        {
            LogDebugMsg('evaluatorName = ' + evaluatorName);
            if (evaluatorName != null && evaluatorName != '')
            {

            }
            else
            {
                opp.Evaluator_Formulator_Contact__c = null;

            }
            LogDebugMsg('opp.Evaluator_Formulator_Contact__c = ' + opp.Evaluator_Formulator_Contact__c);
        }
        catch (Exception ex)
        {
            LogException('EvaluatorOnChangeEvent', ex);
        }
        LogDebugMsg('Exiting: EvaluatorOnChangeEvent');
        return null;
    }

    public PageReference EconBuyerOnChangeEvent()
    {
        try
        {
            if (econBuyerName != null && econBuyerName != '')
            {

            }
            else
            {
                opp.Value_Descision_Maker_Economic_Buyer_Con__c = null;

            }

        }
        catch (Exception ex)
        {
            LogException('EconBuyerOnChangeEvent', ex);
        }
        return null;
    }

    public PageReference CompetitorOnChangeEvent()
    {
        try
        {
            if (competitorName != null && competitorName != '')
            {

            }
            else
            {
                opp.Primary_Competitor__c = null;

            }

        }
        catch (Exception ex)
        {
            LogException('CompetitorOnChangeEvent', ex);
        }
        return null;
    }

    public PageReference CompLostWonOnChangeEvent()
    {
        try
        {
            if (compLostWonName != null && compLostWonName != '')
            {

            }
            else
            {
                opp.Competitor_Lost_To_Won_From__c = null;

            }

        }
        catch (Exception ex)
        {
            LogException('CompLostWonOnChangeEvent', ex);
        }
        return null;
    }

    private void LogDebugMsg(String strErrMsg)
    {
        System.Debug('LogDebugMsg >>> ' +strErrMsg);
        try
        {
            if (renderDebugPanel)
            {
                strErrMsg = datetime.now() + ' ' + strErrMsg;
                if (debugTextValue.length() > 1000000) debugTextValue = '';
                if (debugTextValue == '') debugTextValue = strErrMsg;
                else debugTextValue += '\r\n' + strErrMsg;
            }
        }
        catch (Exception ex){}
    }

    public PageReference AcctEndCUOnChange()
    {
        try
        {
            if (opp.Account_End_Customer__c == null || opp.Account_End_Customer__c == '')
                opp.Account_End_Customer__c = null;
        }
        catch (Exception ex)
        {
            LogException('AcctEndCUOnChange', ex);
        }
        return null;
    }

    public PageReference GetProjectSenseOfUrgency()
    {
        LogDebugMsg('Entered: GetProjectSenseOfUrgency') ;

        date todaysDate = date.today();
        integer noOfMonths = 0;

        try
        {
            LogDebugMsg('CloseDate = ' + opp.CloseDate) ;
            if (opp.CloseDate != null)
            {
                noOfMonths = todaysDate.monthsBetween(opp.CloseDate);

                LogDebugMsg('noOfMonths = ' + noOfMonths) ;

                opp.Project_Sense_of_Urgency__c = GetNumOfMonthsRange(noOfMonths) ;

                LogDebugMsg('Project_Sense_of_Urgency__c = ' + opp.Project_Sense_of_Urgency__c) ;
            }
            else
            {
                opp.Project_Sense_of_Urgency__c = null;

            }
            OverrideStageOnChange();
        }
        catch (Exception ex)
        {
            LogException('GetProjectSenseOfUrgency', ex);
        }
        LogDebugMsg('Exiting: GetProjectSenseOfUrgency') ;
        return null;
    }

    public PageReference GetProjectSenseOfUrgencyNoScoreRecalc()
    {
        LogDebugMsg('Entered: GetProjectSenseOfUrgencyNoScoreRecalc') ;

        date todaysDate = date.today();
        integer noOfMonths = 0;

        try
        {
            LogDebugMsg('CloseDate = ' + opp.CloseDate) ;
            if (opp.CloseDate != null)
            {
                noOfMonths = todaysDate.monthsBetween(opp.CloseDate);

                LogDebugMsg('noOfMonths = ' + noOfMonths) ;

                opp.Project_Sense_of_Urgency__c = GetNumOfMonthsRange(noOfMonths) ;

                LogDebugMsg('Project_Sense_of_Urgency__c = ' + opp.Project_Sense_of_Urgency__c) ;
            }
            else
            {
                opp.Project_Sense_of_Urgency__c = null;

            }
        }
        catch (Exception ex)
        {
            LogException('GetProjectSenseOfUrgencyNoScoreRecalc', ex);
        }
        LogDebugMsg('Exiting: GetProjectSenseOfUrgencyNoScoreRecalc') ;
        return null;
    }

    public string GetNumOfMonthsRange(integer noOfMonths)
    {
        LogDebugMsg('Entered: GetNumOfMonthsRange') ;

        String returnValue = '';

        try
        {
            if (noOfMonths <= 3)
                returnValue = '< 3 months';
            else if (noOfMonths > 3 && noOfMonths <= 6)
                returnValue = '3 - 6 months';
            else if (noOfMonths > 6 && noOfMonths <= 12)
                returnValue = '6 - 12 months';
            else if (noOfMonths > 12 && noOfMonths <= 18)
                returnValue = '12 - 18 months';
            else if (noOfMonths > 18 && noOfMonths <= 24)
                returnValue = '18 - 24 months';
            else if (noOfMonths > 24)
                returnValue = '> 24 months';
        }
        catch (Exception ex)
        {
            LogException('GetNumOfMonthsRange', ex);
        }
        LogDebugMsg('Exiting: GetNumOfMonthsRange') ;

        return returnValue;

    }

    public PageReference OnAshlandResReqChange()
    {
        LogDebugMsg('Entered: OnAshlandResReqChange') ;

        try
        {
            OnAshlandResReqChangeNoScoreReCalc();

            //Rating field on change
            OverrideStageOnChange();

        }
        catch (Exception ex)
        {
            LogException('OnAshlandResReqChange', ex);
        }
        LogDebugMsg('Exiting: OnAshlandResReqChange') ;
        return null;
    }

    public PageReference OnAshlandResReqChangeNoScoreReCalc()
    {
        LogDebugMsg('Entered: OnAshlandResReqChangeNoScoreReCalc') ;

        try
        {
            if (opp.ISP_Resources_Required__c == null)
            {
                TSRStatusReadOnly = true;
                InnovaStageReadOnly = true;
                opp.Innova_Stage__c = 'Not Required';
                opp.TSR_Status__c = 'Not Required';
            }
            else if (opp.ISP_Resources_Required__c.toLowerCase() == 'Not Required'.toLowerCase())
            {
                TSRStatusReadOnly = true;
                InnovaStageReadOnly = true;
                opp.Innova_Stage__c = 'Not Required';
                opp.TSR_Status__c = 'Not Required';

            }
            else if (opp.ISP_Resources_Required__c.toLowerCase() == 'PIDA (confidentiality agreement) Only'.toLowerCase())
            {
                TSRStatusReadOnly = true;
                InnovaStageReadOnly = true;
                opp.Innova_Stage__c = 'Not Required';
                opp.TSR_Status__c = 'Not Required';

            }
            else if (opp.ISP_Resources_Required__c.toLowerCase() == 'TSR'.toLowerCase())
            {
                TSRStatusReadOnly = false;
                InnovaStageReadOnly = true;
                opp.Innova_Stage__c = 'Not Required';
            }
            else if (opp.ISP_Resources_Required__c.toLowerCase() == 'INNOVA Project'.toLowerCase())
            {
                TSRStatusReadOnly = false;
                InnovaStageReadOnly = false;
            }
            else
            {
                TSRStatusReadOnly = true;
                InnovaStageReadOnly = true;
                opp.Innova_Stage__c = 'Not Required';
                opp.TSR_Status__c = 'Not Required';
            }
        }
        catch (Exception ex)
        {
            LogException('OnAshlandResReqChangeNoScoreReCalc', ex);
        }
        LogDebugMsg('Exiting: OnAshlandResReqChangeNoScoreReCalc') ;
        return null;

    }

    public PageReference EnableDisableOverrideRating()
    {

        if (this.Opp.Type__c != null &&
            (this.Opp.Type__c.contains('Price Increase')
                || this.Opp.Type__c.contains('Upside Volume')
                || this.Opp.Type__c.contains('Spot Opportunity')
                )
            )
        {
            CanOverrideRating = true;
        }
        else if (OppSecurity__c.getInstance().Override_Stage__c)
        {
            CanOverrideRating = true;
        }
        else
        {
            CanOverrideRating = false;
        }

        return null;

    }



}
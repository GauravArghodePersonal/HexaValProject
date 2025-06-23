public class Mass_Edit_Opp {

    public static final Integer PAGE_SIZE = 25;

    public List<Opportunity> selOpps{get;set;}
    Set<Id> oppIds = new Set<Id>();
    public Boolean selOneOppFlag { get; set; }
    public Boolean selSameOppsFlag { get; set; }
    public String url { get; set; }
    public String recTypeName{get; set;}

    //Opportunity Name, Account Name, Opportunity Record Type, Stage & Close Date fields to be rendered for all record types

    //Fields to be rendered for Distribution record types only
    public Boolean isRenderStage{get;set;}
    public Boolean isRenderAmount{get;set;}
    public Boolean isRenderAnnualUsage{get;set;}
    public Boolean isRenderOpportunityVolume{get;set;}
    public Boolean isRenderOpportunityGrossMarginPercent{get;set;}
    public Boolean isRenderSalesPriority{get;set;}
    public Boolean isRenderTargetPrice{get;set;}
    public Boolean isRenderServices{get;set;}
    public Boolean isRenderAshlandSupplier{get;set;}
    public Boolean isRenderSAPMaterial{get;set;}

    //Fields to be rendered for Aqualon record types only
    public Boolean isRenderSbu{get;set;}
    public Boolean isRenderProbability{get;set;}

    //Fields to be rendered for PM record types only
    public Boolean isRenderCustomerMarket{get;set;}
    public Boolean isRenderMetalCastings{get;set;}
    public Boolean isRenderSpecificCasting{get;set;}
    public Boolean isRenderTargetVolume{get;set;}
    public Boolean isRenderPlatform{get;set;}
    public Boolean isRenderCode{get;set;}
    public Boolean isRenderUnitGrossMargin{get;set;}
    public Boolean isRenderProductFamily{get;set;}
    public Boolean isRenderSubFamily{get;set;}
    public Boolean isRenderMaterialWonLost{get;set;}

    //Fields to be rendered for ASK record types only
    public Boolean isRenderCurrentStatus{get;set;}
    public Boolean isRenderNextSteps{get;set;}
    public Boolean isRenderGrossProfit{get;set;}

    //Fields to be rendered for Valvoline record types only
    public Boolean isRenderAnnualVolume{get;set;}
    public Boolean isRenderContractExpDate{get;set;}

    //Fields to be rendered for Water record type only
    public Boolean isRenderAGP{get;set;}
    public Boolean isRenderPrimaryReasonWonLost{get;set;}
    public Boolean isRenderSecondaryReasonWonLost{get;set;}
    public Boolean isRenderAppSupportRequested{get;set;}
    public Boolean isRenderAppSupportEngineer{get;set;}
    public Boolean isRenderAppSupportManager{get;set;}
    public Boolean isRenderCompetitorLostToWonFrom{get;set;}

    //Fields to be rendered for Distribution & Valvoline record types
    public Boolean isRenderReasonWonLost{get;set;}

    //Fields to be rendered for Aqualon, PM & Valvoline record types
    public Boolean isRenderPrimaryCompetitor{get;set;}

    //Fields to be rendered for Aqualon & Valvoline record types
    public Boolean isRenderDescription{get;set;}

    List<Opp_RecordType_PicklistValue_Relation__c> picklistValues =
        new List<Opp_RecordType_PicklistValue_Relation__c>();

    private static Map<String, List<Opp_RecordType_PicklistValue_Relation__c>> plvmap = null;

    Map<String, OpportunityStage> stageMap;

    public List<SelectOption> stage;
    public List<SelectOption> salesPriority;
    public List<SelectOption> ashSupplier;
    public List<SelectOption> reasonWonLost;
    public List<SelectOption> customerMarket;
    public List<SelectOption> productFamily;
    public List<SelectOption> productSubFamily1;
    public List<SelectOption> productSubFamily2;
    public List<SelectOption> productSubFamily3;
    public List<SelectOption> productSubFamily4;
    public List<SelectOption> primaryWonLost;
    public List<SelectOption> secondaryWonLost;

    public Boolean errorMsgStage{get;set;}
    //To avoid displaying validation error in the first page
    public Boolean isRenderError{get;set;}
    //To enable/disable the dependency fields
    public String tempValue{get;set;}

    public String saveUrl;

    public String testOpp{get;set;}

    private void debug(String s) {System.debug(LoggingLevel.INFO, '>>>>>>>>> Mass_Edit_Opp : ' + s);}

    private List<Opp_RecordType_PicklistValue_Relation__c> getPickListValues(String recType) {
        List<Opp_RecordType_PicklistValue_Relation__c> plvlist = new List<Opp_RecordType_PicklistValue_Relation__c>();
        if (plvmap == null) {
            plvmap = new Map<String, List<Opp_RecordType_PicklistValue_Relation__c>>();
            List<Opp_RecordType_PicklistValue_Relation__c> plvs = [Select Controlling_Field_Value__c,
                                                                          Field_Name__c,
                                                                          Field_Values__c,
                                                                          Record_Type_Name__c
                                                                     from Opp_RecordType_PicklistValue_Relation__c
                                                                    order by Record_Type_Name__c];
            for (Opp_RecordType_PicklistValue_Relation__c p : plvs) {
                if (!plvmap.containsKey(p.Record_Type_Name__c)) {
                    plvmap.put(p.Record_Type_Name__c, new List<Opp_RecordType_PicklistValue_Relation__c>());
                }
                plvmap.get(p.Record_Type_Name__c).add(p);
            }
        }
        if (plvmap.containsKey(recType)) {
            plvlist = plvmap.get(recType);
        }
        return plvlist;
    }

    public List<SelectOption> getStage(){
        stage = new List<SelectOption>();
        List<String> picklist = new List<String>();
        stage.add(new SelectOption('','--None--'));
        for(Integer i=0;i<picklistValues.size();i++)
            if(picklistValues[i].Field_Name__c == 'Stage')
                picklist = picklistValues[i].Field_Values__c.split(',');
        for(Integer i=0;i<picklist.size();i++)
            stage.add(new SelectOption(picklist[i],picklist[i]));
        return stage;
    }

    public List<SelectOption> getSalesPriority(){
        salesPriority = new List<SelectOption>();
        List<String> picklist = new List<String>();
        salesPriority.add(new SelectOption('','--None--'));
        for(Integer i=0;i<picklistValues.size();i++)
            if(picklistValues[i].Field_Name__c == 'Sales Priority')
                picklist = picklistValues[i].Field_Values__c.split(',');
        for(Integer i=0;i<picklist.size();i++)
            salesPriority.add(new SelectOption(picklist[i],picklist[i]));
        return salesPriority;
    }

    public List<SelectOption> getAshSupplier(){
        ashSupplier = new List<SelectOption>();
        List<String> picklist = new List<String>();
        ashSupplier.add(new SelectOption('','--None--'));
        for(Integer i=0;i<picklistValues.size();i++)
            if(picklistValues[i].Field_Name__c == 'Ashland Supplier')
                picklist = picklistValues[i].Field_Values__c.split(',');
        for(Integer i=0;i<picklist.size();i++)
            ashSupplier.add(new SelectOption(picklist[i],picklist[i]));
        return ashSupplier;
    }

    public List<SelectOption> getReasonWonLost(){
        reasonWonLost = new List<SelectOption>();
        List<String> picklist = new List<String>();
        reasonWonLost.add(new SelectOption('','--None--'));
        for(Integer i=0;i<picklistValues.size();i++)
            if(picklistValues[i].Field_Name__c == 'Reason Won/Lost')
                picklist = picklistValues[i].Field_Values__c.split(',');
        for(Integer i=0;i<picklist.size();i++)
            reasonWonLost.add(new SelectOption(picklist[i],picklist[i]));

        return reasonWonLost;
    }

    public List<SelectOption> getCustomerMarket(){
        customerMarket = new List<SelectOption>();
        List<String> picklist = new List<String>();
        customerMarket.add(new SelectOption('','--None--'));

        for(Integer i=0;i<picklistValues.size();i++)
            if(picklistValues[i].Field_Name__c == 'Customer Market')
                picklist = picklistValues[i].Field_Values__c.split(',');
        for(Integer i=0;i<picklist.size();i++)
            customerMarket.add(new SelectOption(picklist[i],picklist[i]));

        return customerMarket;
    }

    public List<SelectOption> getProductFamily(){
        productFamily = new List<SelectOption>();
        List<String> picklist = new List<String>();
        productFamily.add(new SelectOption('','--None--'));

        for(Integer i=0;i<picklistValues.size();i++)
            if(picklistValues[i].Field_Name__c == 'Product Family')
                picklist = picklistValues[i].Field_Values__c.split(',');
        for(Integer i=0;i<picklist.size();i++)
            productFamily.add(new SelectOption(picklist[i],picklist[i]));

        return productFamily;
    }

    public List<SelectOption> getProductSubFamily1(){
        productSubFamily1 = new List<SelectOption>();
        List<String> picklist = new List<String>();
        productSubFamily1.add(new SelectOption('','--None--'));

        for(Integer i=0;i<picklistValues.size();i++)
            if(picklistValues[i].Field_Name__c == 'Product Sub Family')
                if(picklistValues[i].Controlling_Field_Value__c == 'P&C - Packaging and Converting')
                    picklist = picklistValues[i].Field_Values__c.split(',');
        for(Integer i=0;i<picklist.size();i++)
            productSubFamily1.add(new SelectOption(picklist[i],picklist[i]));

        return productSubFamily1;
    }
    public List<SelectOption> getProductSubFamily2(){
        productSubFamily2 = new List<SelectOption>();
        List<String> picklist = new List<String>();
        productSubFamily2.add(new SelectOption('','--None--'));

        for(Integer i=0;i<picklistValues.size();i++)
            if(picklistValues[i].Field_Name__c == 'Product Sub Family')
                if(picklistValues[i].Controlling_Field_Value__c == 'Structural & Industrial Adhesives')
                    picklist = picklistValues[i].Field_Values__c.split(',');
        for(Integer i=0;i<picklist.size();i++)
            productSubFamily2.add(new SelectOption(picklist[i],picklist[i]));

        return productSubFamily2;
    }
    public List<SelectOption> getProductSubFamily3(){
        productSubFamily3 = new List<SelectOption>();
        List<String> picklist = new List<String>();
        productSubFamily3.add(new SelectOption('','--None--'));

        for(Integer i=0;i<picklistValues.size();i++)
            if(picklistValues[i].Field_Name__c == 'Product Sub Family')
                if(picklistValues[i].Controlling_Field_Value__c == 'UPR - Unsaturated Polyester Resin')
                    picklist = picklistValues[i].Field_Values__c.split(',');
        for(Integer i=0;i<picklist.size();i++)
            productSubFamily3.add(new SelectOption(picklist[i],picklist[i]));

        return productSubFamily3;
    }
    public List<SelectOption> getProductSubFamily4(){
        productSubFamily4 = new List<SelectOption>();
        productSubFamily4.add(new SelectOption('','--None--'));
        return productSubFamily4;
    }

    public List<SelectOption> getPrimaryWonLost(){
        primaryWonLost = new List<SelectOption>();
        List<String> picklist = new List<String>();
        primaryWonLost.add(new SelectOption('','--None--'));
        List<Schema.PicklistEntry> picklistSchema =
            Opportunity.W_Primary_Won_Lost_Reason__c.getDescribe().getPicklistValues();
        for(Integer i=0;i<picklistSchema.size();i++)
            primaryWonLost.add(new SelectOption(picklistSchema[i].getValue(),
                                                picklistSchema[i].getLabel()));
        return primaryWonLost;
    }
    public List<SelectOption> getSecondaryWonLost(){
        secondaryWonLost = new List<SelectOption>();
        List<String> picklist = new List<String>();
        secondaryWonLost.add(new SelectOption('','--None--'));
        List<Schema.PicklistEntry> picklistSchema =
            Opportunity.W_secondary_Won_Lost_Reason__c.getDescribe().getPicklistValues();
        for(Integer i=0;i<picklistSchema.size();i++)
            secondaryWonLost.add(new SelectOption(picklistSchema[i].getValue(),
                                                  picklistSchema[i].getLabel()));
        return secondaryWonLost;
    }

    public Mass_Edit_Opp(ApexPages.StandardSetController stdSetController)
    {
        url = ApexPages.currentPage().getParameters().get('retURL');
        selOneOppFlag = True;
        selSameOppsFlag = True;
        isRenderStage = true;
        selOpps = (List<Opportunity>) stdSetController.getSelected();
        stdSetController.setPageSize(PAGE_SIZE);
        if(selOpps.size() > 0)
        {
            if (stageMap == null) {
                stageMap = Opportunity_Functions.getOpportunityStageMap();
            }
            for(Opportunity opp : selOpps)
            oppIds.add(opp.Id);

            List<Opportunity> opps = [Select RecordTypeId, RecordType.Name from Opportunity where Id IN : oppIds];
            recTypeName = opps[0].RecordType.Name;
            for(Opportunity opp : opps)
            {
                if(opp.RecordType.Name != recTypeName)
                {
                    selSameOppsFlag = False;
                    break;
                }
            }

            isRenderSAPMaterial = false;
            isRenderAmount = true;

            if(recTypeName=='Distribution Chemicals'
               ||recTypeName=='Distribution Plastics'){
                isRenderAnnualUsage = true;
                isRenderReasonWonLost = true;
                isRenderSAPMaterial = true;
            }
            if(recTypeName=='Distribution Targets'){
                isRenderAnnualVolume = true;
                isRenderOpportunityVolume = true;
                isRenderOpportunityGrossMarginPercent = true;
                isRenderAnnualUsage = false;
                isRenderReasonWonLost = true;
                isRenderSAPMaterial = true;
            }
            if(recTypeName=='Distribution Chemicals'
               ||recTypeName=='Distribution Plastics'
               ||recTypeName=='Distribution Targets'
               ||recTypeName=='Distribution Environmental Services'){
                isRenderSalesPriority = true;
                isRenderTargetPrice = true;
                isRenderAshlandSupplier = true;
                isRenderSAPMaterial = true;
            }
            if(recTypeName=='Distribution Environmental Services'){
                isRenderServices = true;
            }
            if(recTypeName=='Aqualon Opportunity - EMEA'
               ||recTypeName=='Aqualon Opportunity - NA'
               ||recTypeName=='Aqualon Opportunity - Latin Amer'){
                isRenderStage = false;
                isRenderSbu = true;
                isRenderProbability = true;
                isRenderPrimaryCompetitor = true;
                isRenderDescription = true;
            }

            if(recTypeName=='Performance Materials - CAST'){
                isRenderPrimaryCompetitor = true;
                isRenderCustomerMarket = true;
                isRenderMetalCastings = true;
                isRenderSpecificCasting = true;
                isRenderTargetVolume = true;
            }
            if(recTypeName=='Performance Materials - PM'){
                isRenderPlatform = true;
                isRenderCode = true;
                isRenderTargetVolume = true;
                isRenderUnitGrossMargin = true;
                isRenderProductFamily = true;
                isRenderSubFamily = true;
                isRenderPrimaryCompetitor = true;
                isRenderCustomerMarket = true;
                isRenderMaterialWonLost = true;
                isRenderSAPMaterial = true;
            }
            if(recTypeName=='Valvoline DIFM'||recTypeName=='Valvoline DIY'){
                isRenderReasonWonLost = true;
                isRenderAnnualVolume = true;
                isRenderContractExpDate = true;
                isRenderPrimaryCompetitor = true;
                isRenderDescription = true;
            }
            if(recTypeName=='Water Opportunity'){
                isRenderAGP = true;
                isRenderPrimaryReasonWonLost = true;
                isRenderSecondaryReasonWonLost = true;
                isRenderAppSupportRequested = true;
                isRenderAppSupportEngineer = true;
                isRenderAppSupportManager = true;
                isRenderCompetitorLostToWonFrom = true;
            }
            if(recTypeName == 'ASK-Target' || recTypeName == 'ASK-Growth Project' ||
               recTypeName == 'ASK-Margin Improvement' || recTypeName == 'ASK-Commodity Sale'){
                isRenderCurrentStatus = true;
                isRenderNextSteps = true;
                isRenderGrossProfit = true;
            }
        }
        else selOneOppFlag = False;
        /*************************/
        selOpps = [Select Id, Name, AccountId, RecordType.Name, CurrencyIsoCode, StageName,
                   Probability, CloseDate, Amount, Annual_Usage__c, Target_Price__c,
                   Opportunity_Volume__c, Opportunity_Gross_Margin_Percent__c,
                   Services__c, Sales_Priority__c,
                   Ashland_Supplier__c, Sbu__c, Primary_Competitor__c,
                   V_Competitor__c, Description, T_Market__c,Material_won_or_lost__c,
                   Metal_Castings__c, Specific_Molding_Casting_Process__c,
                   Target_Volume__c, Platform__c, Code__c,
                   T_ProductFamily__c, Product_Sub_Family__c, T_UGM__c,
                   T_Reason_Won_Lost__c, V_Annual_Volume__c,
                   Contract_Expiration_Date__c, Annualized_Gross_Profit_GP__c,
                   W_Primary_Won_Lost_Reason__c, W_Secondary_Won_Lost_Reason__c,
                   Application_Support_Requested__c,
                   Application_Support_Engineer__c,
                   Application_Support_Manager__c,T_Product_Line__c, Competitor_Lost_To_Won_From__c, SAP_Material__c,
                   Current_Status__c, Next_Steps__c, Percent_Gross_Profit__c, Purchase_Order__c
                   from Opportunity where id in :oppIds order by Name];
        recSize = PAGE_SIZE;
        isNext = true;
        isPrevious = false;
        /*************************/
        saveUrl = ApexPages.currentPage().getParameters().get('retURL');
/*
        picklistValues = [Select Field_Values__c, Field_Name__c, Controlling_Field_Value__c
                          from Opp_RecordType_PicklistValue_Relation__c
                          Where Record_Type_Name__c = :recTypeName];
*/
        picklistValues = getPickListValues(recTypeName);
        errorMsgStage = false;
        isRenderError = false;
        isRenderErrorOnOtherPages = false;
    }
    /********************Pagination codes*****************************/
    public List<Opportunity> errorOpty;
    public String errorOnOtherPage{get;set;}
    public Integer recSize{get;set;}
    public Integer CurrPageNo;
    public Integer TotalPageNo;
    public Integer index=0;
    public Boolean isNext;
    public Boolean isPrevious;
    public Boolean isRenderErrorOnOtherPages{get;set;}
    public List<Mass_Edit_Opp_WrapperClass> paginationObjList;
    public List<Mass_Edit_Opp_WrapperClass> getPaginationObjList(){
        paginationObjList = new List<Mass_Edit_Opp_WrapperClass>();
        for(Integer i=index*recSize;i<((index*recSize)+recSize);i++){
            if(i<selOpps.size() && i>=0){
                paginationObjList.add(new Mass_Edit_Opp_WrapperClass(selOpps[i],
                                      selOpps[i].StageName,
                                      selOpps[i].Sales_Priority__c,
                                      selOpps[i].Ashland_Supplier__c,
                                      selOpps[i].T_Reason_Won_Lost__c,
                                      selOpps[i].T_Market__c,
                                      selOpps[i].T_ProductFamily__c,
                                      selOpps[i].Product_Sub_Family__c,
                                      selOpps[i].W_Primary_Won_Lost_Reason__c,
                                      selOpps[i].W_Secondary_Won_Lost_Reason__c));
            }
        }
        return paginationObjList;
    }
    public PageReference goNext(){
        List<Opportunity> validateOpps = new List<Opportunity>();
        for(Integer i=0;i<paginationObjList.size();i++){
            validateOpps.add(paginationObjList[i].opp);
        }
        validation(validateOpps);
        if(!errorMsgStage){
            index++;
            isRenderError = false;
        }
        return null;
    }
    public PageReference goPrevious(){
        List<Opportunity> validateOpps = new List<Opportunity>();
        for(Integer i=0;i<paginationObjList.size();i++){
            validateOpps.add(paginationObjList[i].opp);
        }
        validation(validateOpps);
        if(!errorMsgStage){
            index--;
            isRenderError = false;
        }
        return null;
    }
    public Boolean getIsNext(){
        if(((index*recSize)+recSize)>=selOpps.size())
            isNext = false;
        else
            isNext = true;
        return isNext;
    }
    public Boolean getIsPrevious(){
        if(index==0)
            isPrevious = false;
        else
            isPrevious = true;
        return isPrevious;
    }
    public PageReference goFirst(){
        List<Opportunity> validateOpps = new List<Opportunity>();
        for(Integer i=0;i<paginationObjList.size();i++){
            validateOpps.add(paginationObjList[i].opp);
        }
        validation(validateOpps);
        if(!errorMsgStage){
            index = 0;
            isRenderError = false;
        }
        return null;
    }
    public PageReference goLast(){
        List<Opportunity> validateOpps = new List<Opportunity>();
        for(Integer i=0;i<paginationObjList.size();i++){
            validateOpps.add(paginationObjList[i].opp);
        }
        validation(validateOpps);
        if(!errorMsgStage){
            index = selOpps.size()/recsize;
            Integer mod = selOpps.size()-(index*recsize);
            if(mod==0)
                index--;
            isRenderError = false;
        }
        return null;
    }
    public Integer getTotalPageNo(){
         TotalPageNo = selOpps.size()/recSize;
         Integer mod = selOpps.size() - (totalPageNo * recSize);
         if(mod>0)
             TotalPageNo++;
         return TotalPageNo;
    }
    public Integer getCurrPageNo(){
        currPageNo = index+1;
        return currPageNo;
    }
    /********************Pagination codes*****************************/
    public PageReference stageOnChange(){
        OpportunityStage ostage;
        for(Integer i=0;i<selOpps.size();i++) {
            if(selOpps[i].Id==tempValue) {
                if(!(selOpps[i].StageName=='6-Closed Won'||selOpps[i].StageName=='7-Closed Lost - Dead'||selOpps[i].StageName=='8-Closed Lost - Future Opportunity')){
                    selOpps[i].W_Primary_Won_Lost_Reason__c = '';
                    selOpps[i].W_Secondary_Won_Lost_Reason__c = '';
                }
                if (stageMap.containsKey(selOpps[i].StageName)) {
                    ostage = stageMap.get(selOpps[i].StageName);
                    selOpps[i].Probability = ostage.DefaultProbability;
                }
            }
        }
        return null;
    }
    public PageReference saveSelOpps(){
        validation(selOpps); errorOnOtherPage = '';
        if(!errorMsgStage){
            try {
                update selOpps;
                PageReference pageRef = new PageReference(saveUrl);
                return pageRef;
            } catch(Exception e) {
                errorMsgStage = true; errorOnOtherPage = e.getMessage();
                debug(errorOnOtherPage);
            }
        }

        if(errorMsgStage){
            isRenderErrorOnOtherPages = true;
            Integer errorPageNo = 0;
            Integer tempPageNo = 0;
            Integer mod = 0;
            for(Integer i=0;i<errorOpty.size();i++){
                for(Integer j=0;j<selOpps.size();j++)
                    if(selOpps[j]==errorOpty[i]){
                        tempPageNo = (j+1)/recsize;
                        mod = selOpps.size()-(tempPageNo * recsize);
                        if(mod>0)
                            tempPageNo++;
                    }
                if(errorPageNo != tempPageNo){
                    errorPageNo = tempPageNo;
                    errorOnOtherPage += errorPageNo+', ';
                }
            }
            if(errorOnOtherPage!=null)
                errorOnOtherPage = errorOnOtherPage.subString(0,errorOnOtherPage.length()-2);
        }
        return null;
    }
    public void validation(List<Opportunity> validateOpps){
        errorMsgStage = false;
        isRenderError = true;
        isRenderErrorOnOtherPages = false;
        errorOpty = new List<Opportunity>();
        for(Integer i=0;i<validateOpps.size();i++){
            if(validateOpps[i].StageName==null){
                errorMsgStage = true;
                errorOpty.add(selOpps[i]);
            }
/*
            if((recTypeName=='Distribution Chemicals'
               ||recTypeName=='Distribution Environmental Services'
               ||recTypeName=='Distribution Plastics'
               ||recTypeName=='Distribution Targets')
               && validateOpps[i].Ashland_Supplier__c==null){
                errorMsgStage = true;
                errorOpty.add(selOpps[i]);
            }
            if((recTypeName=='Distribution Chemicals'
               ||recTypeName=='Distribution Plastics'
               ||recTypeName=='Distribution Targets')
               &&(validateOpps[i].StageName=='Closed Won'
                  ||validateOpps[i].StageName=='Closed - Not Awarded / Lost')
               && validateOpps[i].T_Reason_Won_Lost__c==null){
                errorMsgStage = true;
                errorOpty.add(selOpps[i]);
            }

           if((recTypeName=='Distribution Chemicals'
               ||recTypeName=='Distribution Plastics'
               ||recTypeName=='Distribution Targets'
               ||recTypeName=='Performance Materials - PM')
               &&(validateOpps[i].StageName=='Closed Won'
                  ||validateOpps[i].StageName=='Closed - Not Awarded / Lost')
               && validateOpps[i].SAP_Material__c==null){
                errorMsgStage = true;
                errorOpty.add(selOpps[i]);
            }
*/
            if(recTypeName=='Performance Materials - PM'
               && validateOpps[i].StageName=='Closed Won'
               && validateOpps[i].Material_won_or_lost__c==null){
                errorMsgStage = true;
                errorOpty.add(selOpps[i]);
            }
            if(recTypeName=='Water Opportunity'
               && validateOpps[i].Application_Support_Requested__c
               && validateOpps[i].Application_Support_Manager__c==null){
                errorMsgStage = true;
                errorOpty.add(selOpps[i]);
            }
            if(recTypeName=='Water Opportunity'
               &&(validateOpps[i].StageName=='6-Closed Won'
               || validateOpps[i].StageName=='7-Closed Lost - Dead'
               || validateOpps[i].StageName=='8-Closed Lost - Future Opportunity'
               || validateOpps[i].StageName=='Closed'
               || validateOpps[i].StageName=='Lost Opportunity'
               || validateOpps[i].StageName=='Lost Business')
               && (validateOpps[i].W_Primary_Won_Lost_Reason__c==null
                   || validateOpps[i].W_Secondary_Won_Lost_Reason__c==null
                   || validateOpps[i].Competitor_Lost_To_Won_From__c==null)){
                   errorOpty.add(selOpps[i]);
                   errorMsgStage = true;
            }
        }
    }
}
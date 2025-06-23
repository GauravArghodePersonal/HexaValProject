public class Opportunity_Functions {

	/********************
	 * AppLog Constants
	 ********************/
    public static final String CLASS_NAME = 'Opportunity_Functions';
    public static final String PROCESS_NAME = 'Opportunity' ; //AppLogV2.PROCESS_ACCOUNTMANAGEMENT;
    public static final String SUBPROCESS_NAME = 'Opportunity Scoring' ; // AppLogV2.SUBPROCESS_ACCOUNTRELATIONSHIPS;
    public static final String CATEGORY_NAME = 'Opportunity Scoring' ; // AppLogV2.LOGCATEGORY_BATCHPROCESS;
    public static final String TASK_NAME = 'Calculate Opportunity Scoring ';
    
    private static final String OBJ_NAME = 'Opportunity';
    private static final String LTGT = '<>';
    private static final String UOM_CODE_MT = 'TO';
    private static final Map<String, OpportunitiesConfig__c> OPP_CNFG_MAP = OpportunitiesConfig__c.getAll();
    private static final Map<Id, String> OPP_RT_MAP = RecordType_Functions.RetrieveRecordTypeIdMap(OBJ_NAME);
    private static final Map<String, ID> MAT_RT_MAP = RecordType_Functions.RetrieveRecordTypeNameMap('Opportunity_Material__c');
    private static final Set<String> STAGES_TO_SET_CLOSED_DATE = new Set<String>{
    	'Closed', 'Dead', 'Lost Business', 'Lost Opportunity'
    };
    
    private static Map<String, OpportunityStage> smap = null;
    private static Map<String, Opportunity_Change_Log__c> stageNameChangeMap = null;
    private static Map<String, Opportunity_Change_Log__c> recordTypeChangeMap = null;
    
    private static AppLogV2 appLog = null;
     
    private static List<string> CompetitorInfoFields = new List<string> 
        {'Pricing_Formulation_Cost__c', 'Dependency_on_Primary_Competitor__c'}  ;
        
    private static List<string> RelationshipFields = new List<string>
        {'Relationship_Status_Coach__c', 'Relationship_Status_Evaluator__c', 'Relationship_Status_Value__c' } ;
            
    private static List<string> Stage1Fields = new List<string> 
        {'Client_has_Need_Interest_for_Prod_Sol__c', 'Lead_Source__c', 'VCP_Rating__c', 'Project_Sense_of_Urgency__c'}  ;
           
    private static List<string> Stage2Fields = new List<string> 
        {'ISP_Resources_Required__c', 'Sales_Potential__c', 
            'Credit_Risk__c', 'Customer_s_Project_Plan__c',
            'Willingness_to_share__c'}  ;

                 
    private static List<string> Stage3Fields = new List<string> 
        {'Price_Value_Discussed_Assessment__c', 'Samples_Evaluation__c',
            'TSR_Status__c', 'Validate_regulatory_requirements__c', 
            'Customer_Trial_Stage__c', 'Innova_Stage__c', 'Sol_has_documented_financial_benefit__c',
            'Management_Support_Funding__c' }  ;  
        
    private static List<string> Stage4Fields = new List<string> 
        {'P_O_Volume_Commitment__c', 'Contract__c', 
            'Proposal_Quote__c', 'Special_ASI_Conditions_Capabilities__c'}  ;        
            
    private static List<string> AllScoringFields = new List<string> 
        {
        	'Client_has_Need_Interest_for_Prod_Sol__c', 'Lead_Source__c', 'VCP_Rating__c', 'Project_Sense_of_Urgency__c',
        	'ISP_Resources_Required__c', 'Sales_Potential__c', 'Credit_Risk__c', 'Customer_s_Project_Plan__c', 'Willingness_to_share__c',
        	'Price_Value_Discussed_Assessment__c', 'Samples_Evaluation__c', 'TSR_Status__c', 'Validate_regulatory_requirements__c', 
        	'Customer_Trial_Stage__c', 'Innova_Stage__c', 'Sol_has_documented_financial_benefit__c','Management_Support_Funding__c',
        	'Relationship_Status_Coach__c', 'Relationship_Status_Evaluator__c', 'Relationship_Status_Value__c',
        	'Pricing_Formulation_Cost__c', 'Dependency_on_Primary_Competitor__c',
        	'P_O_Volume_Commitment__c', 'Contract__c', 'Proposal_Quote__c', 'Special_ASI_Conditions_Capabilities__c',
        	'Customer_Group__c', 'Sales_Office__c'
        };
            
    public static Decimal Stage1RatingsTotal { get; set; }
    public static Decimal Stage2RatingsTotal { get; set; }
    public static Decimal Stage3RatingsTotal { get; set; }
    public static Decimal Stage4RatingsTotal { get; set; }  
    public static Decimal CompetitorInfoRatingsTotal { get; set; }      
    public static Decimal RelationshipRatingsTotal { get; set; }          
    public static Decimal AllRatingsTotal { get; set; }    
    private static OpportunityRatingConfigFunctions orcFuncs;     
    private static Set<Id> recalcAcctsSet = new Set<Id>();							// unique account ids for which to get the VCP ratings  
    private static Map<Id, Account> recalcAcctsVCPMap = new Map<Id, Account>();		// map of account id and VCP rating
    private static List<Id> recalcRatingForOppList = new List<Id>();				// Opp list to recalc rating
    private static List<String> recalAppLogDebugList = new List<String>();			// used in collecting all debug statements  
    private static string recalAppLogRecordAction = ''; 							// record load, record new, record update  
    private static Boolean writeToAppLogBoolean = false;
    public static Decimal TotalOpportunityValue {get; set;}
            
    public static Decimal GetOppRatingToReachStage2() {return getStageRating('Stage Rating 1');}
    public static Decimal GetOppRatingToReachStage3() 
    	{return getStageRating('Stage Rating 1') + Opportunity_Functions.getStageRating('Stage Rating 2');} 
    public static Decimal GetOppRatingToReachStage4() 
    {	
    	Decimal returnValue = 0;
    	returnValue = getStageRating('Stage Rating 1') 
	        + getStageRating('Stage Rating 2')
	        + getStageRating('Stage Rating 3');
	    debug(String.valueOf(returnValue));    
	    return returnValue;
    } 	 
     
     
    public static Decimal GetOppRatingConfigScoreFor(Opportunity opp,
        String fieldName, String fieldValue)
    {
    	recalAppLogDebugList.add('Entered: GetOppRatingConfigScoreFor') ;
        Decimal returnValue = 0.0;
        List<Opportunity_Rating_Configuration__c> oppRatingConfig;
             
        try
        {
        	if (orcFuncs == null)
	            orcFuncs = new 
	                OpportunityRatingConfigFunctions(opp.Customer_Group__c, opp.Sales_Office__c);    
	                      	        	
            String key = fieldName+fieldValue.replace(' ', '');     
            recalAppLogDebugList.add('Key: ' + key.toLowerCase());
            returnValue = orcFuncs.GetScoreForFieldValueFromMap(key.toLowerCase());
            if (returnValue == null) returnValue = 0.0;
            recalAppLogDebugList.add('fieldName: ' + fieldName + 'fieldValueScore: ' + returnValue);   

        }  
        catch (Exception ex)
        {
            recalAppLogDebugList.add('GetOppRatingConfigScoreFor: ' + ex);
        }
        
        recalAppLogDebugList.add('Exiting: GetOppRatingConfigScoreFor');        
        return  returnValue ;
    
    
    } 
    
    public static Decimal FindStageFieldsTotalRatings(List<string> stageFieldsList, Opportunity Opp)
    {
        Decimal returnValue = 0.0;
        Object fieldValue ;

        try
        {
        	if (orcFuncs == null)
	            orcFuncs = new 
	                OpportunityRatingConfigFunctions(Opp.Customer_Group__c, opp.Sales_Office__c);    
	                  	
        
            //For the given Stage fields
            for (String f : stageFieldsList) { 

            	//System.Debug('Opp.Account.Customer_Classification_ABC__c = ' + Opp.Account.Customer_Classification_ABC__c);
                if (f == 'VCP_Rating__c'){
                    fieldValue = GetAccountVCP(opp.AccountId); //Opp.Account.Customer_Classification_ABC__c;
                }
                else
                    fieldValue = Opp.get(f); 
                    
                recalAppLogDebugList.add('Stage field: ' + f + ' field value: ' + fieldValue);
                     
                // At least have the following field values
                if ( fieldValue != null &&
                    opp.Customer_Group__c != null)
                {  
                    returnValue += GetOppRatingConfigScoreFor(Opp, f, String.valueOf(fieldValue));
                }
                                
            }
                
        }
        catch (Exception ex)
        {
            recalAppLogDebugList.add('FindStageFieldsTotalRatings: ' + ex);
        }


        return returnValue;
    }   
    
    // Calculate Opp Rating - method call from UI
    public static string CalculateRatingsFromUI(Opportunity Opp)
    {
    	String returnValue = '0';
    	try	
    	{
	    	
	    	writeToAppLogBoolean = getOppWriteToAppLog();
	    	if (appLog == null) appLog = new AppLogV2(PROCESS_NAME,SUBPROCESS_NAME,CLASS_NAME,'');
	    	     	
	    	recalAppLogRecordAction = 'from UI';
	    	// used in getting the VCP for the account
	    	recalcAcctsSet.add(Opp.AccountId);
	
	        //Get map of account id, vcp used in recalc ratings
	        GetAcctVCPMapForAccts(recalcAcctsSet);  
	
			returnValue =  CalculateRatings(Opp); 
			
	        //Update Weighted Opportunity Revenue
	        SetWeightedOpportunityRevenueValue(Opp);			
			  
	        if (writeToAppLogBoolean)
	        {
	        	if (Opp.Name != null)
					writeToAppLog('Opp: ' + Opp.Name + ' - ' + Datetime.now(), recalAppLogDebugList);
				else
					writeToAppLog('Opp Name is null ' + Datetime.now(), recalAppLogDebugList);
	        }
						
			appLog.flushCache(); 
    	}
        catch (Exception ex)
        {
        	writeExceptionTpAppLog('Exception in CalculateRatingsFromUI', ex);       
        }  		
		
		return returnValue;
	
    }
    
    
    // Calculates Opportunity Rating
    public static string CalculateRatings(Opportunity Opp)
    {
    	String returnValue = '0';
    	try
    	{
	    	recalAppLogDebugList.clear();
	    	       
	        recalAppLogDebugList.add('Entered: CalculateRatings') ; 
	
	        AllRatingsTotal = 0.0; Stage1RatingsTotal = 0.0; Stage2RatingsTotal = 0.0;
	        Stage3RatingsTotal = 0.0; Stage4RatingsTotal = 0.0; CompetitorInfoRatingsTotal = 0.0;
	        RelationshipRatingsTotal = 0.0;
	        
	        // Dont bother if customer group or sales office is missing
			if (opp.Customer_Group__c == null)
			{
				recalAppLogDebugList.add('Customer_Group__c is missing');
				return '0';
			}	
			else if (opp.Sales_Office__c == null)
			{
				recalAppLogDebugList.add('Sales_Office__c is missing');
				return '0';
			}
				        
	        
	        Stage1RatingsTotal = FindStageFieldsTotalRatings(Stage1Fields, Opp) ;
	        recalAppLogDebugList.add('Stage1RatingsTotal = ' + Stage1RatingsTotal );
	        Stage2RatingsTotal = FindStageFieldsTotalRatings(Stage2Fields, Opp) ;
	        recalAppLogDebugList.add('Stage2RatingsTotal = ' + Stage2RatingsTotal) ;        
	        Stage3RatingsTotal = FindStageFieldsTotalRatings(Stage3Fields, Opp) ;  
	        recalAppLogDebugList.add('Stage3RatingsTotal before CompetitorInfoRatingsTotal and RelationshipRatingsTotal = ' + Stage3RatingsTotal) ;           
	        Stage4RatingsTotal = FindStageFieldsTotalRatings(Stage4Fields, Opp) ;    
	        recalAppLogDebugList.add('Stage4RatingsTotal = ' + Stage4RatingsTotal) ;   
	        
	        CompetitorInfoRatingsTotal = FindStageFieldsTotalRatings(CompetitorInfoFields, Opp) ;  
	        recalAppLogDebugList.add('CompetitorInfoRatingsTotal = ' + CompetitorInfoRatingsTotal) ;                   
	        RelationshipRatingsTotal = FindStageFieldsTotalRatings(RelationshipFields, Opp) ;  
	        recalAppLogDebugList.add('RelationshipRatingsTotal = ' + RelationshipRatingsTotal) ;  
	        
	        Stage3RatingsTotal = Stage3RatingsTotal  + CompetitorInfoRatingsTotal + RelationshipRatingsTotal ;                 
	        recalAppLogDebugList.add('Stage3RatingsTotal = ' + Stage3RatingsTotal) ;
	                         
	        AllRatingsTotal = Stage1RatingsTotal + Stage2RatingsTotal +
	            Stage3RatingsTotal  + Stage4RatingsTotal ; 
	            
	        recalAppLogDebugList.add('AllRatingsTotal = ' + String.valueof(AllRatingsTotal)) ;            
	
			//recalAppLogDebugList.add('GetOppRatingToReachStage2() = ' + String.valueof(GetOppRatingToReachStage2())) ;
			
			//recalAppLogDebugList.add('AnyOfTheGivenStageFieldsMissingValue(Stage1Fields, Opp) = ' + String.valueof(AnyOfTheGivenStageFieldsMissingValue(Stage1Fields, Opp))) ; 
			            
	        // Rates and stages are assigned base on the following rules
	        if (Stage1RatingsTotal < GetOppRatingToReachStage2() ||
	            AnyOfTheGivenStageFieldsMissingValue(Stage1Fields, Opp))   
	        {
	            Opp.Opportunity_Rating_Overall__c = String.valueOf(Stage1RatingsTotal.SetScale(2)) ;
	            Opp.StageName = 'Stage 1';
	            Opp.Stage_Changed_On__c = Date.today() ;
	
	        }
	        else if ((Stage1RatingsTotal + Stage2RatingsTotal) < GetOppRatingToReachStage3() ||
	            AnyOfTheGivenStageFieldsMissingValue(Stage2Fields, Opp))   
	        {
	            Opp.Opportunity_Rating_Overall__c = String.valueOf(Stage1RatingsTotal.SetScale(2) + Stage2RatingsTotal.SetScale(2)) ;
	            Opp.StageName = 'Stage 2';
	            Opp.Stage_Changed_On__c = Date.today() ;            
	        }
	        else if ((Stage1RatingsTotal + Stage2RatingsTotal + Stage3RatingsTotal) < GetOppRatingToReachStage4() ||
	            AnyOfTheGivenStageFieldsMissingValue(Stage3Fields, Opp))   
	        {
	            Opp.Opportunity_Rating_Overall__c = String.valueOf(Stage1RatingsTotal.SetScale(2) 
	            + Stage2RatingsTotal.SetScale(2) + Stage3RatingsTotal.SetScale(2)) ;
	            Opp.StageName = 'Stage 3';
	            Opp.Stage_Changed_On__c = Date.today() ;                        
	        }
	        else
	        {
	            Opp.Opportunity_Rating_Overall__c = String.valueOf(AllRatingsTotal.SetScale(2)) ; 
	            Opp.StageName = 'Stage 4';
	            Opp.Stage_Changed_On__c = Date.today() ;                              
	        }
	   
	        //Update Weighted Opportunity Revenue
	        if (Opp.Aqualon_Amount__c != null && Opp.Opportunity_Rating_Overall__c != null)
	        {
	            Opp.Weighted_Opportunity_Revenue__c = (Opp.Aqualon_Amount__c * Decimal.valueOf(Opp.Opportunity_Rating_Overall__c))/100;   
	        }
	        	   
			recalAppLogDebugList.add('Aqualon_Amount__c = ' + Opp.Aqualon_Amount__c);	
	        recalAppLogDebugList.add('*** AllRatingsTotal = ' + AllRatingsTotal);
	        recalAppLogDebugList.add('*** OppStageName = ' + Opp.StageName);
	        
			recalAppLogDebugList.add('After calling calculate ratings Opportunity_Rating_Overall__c = ' + Opp.Opportunity_Rating_Overall__c);        
	        returnValue = Opp.Opportunity_Rating_Overall__c;
	        
	        recalAppLogDebugList.add('Exiting: CalculateRatings') ;
	        //recalAppLogDebugString += '\nCalculateRatings opp = ' + opp;
        }
        catch (Exception ex)
        {
            recalAppLogDebugList.add('CalculateRatings: ' + ex);           
        }         
            
        return returnValue ;
        
    }   
    
    public static void SetWeightedOpportunityRevenueValue(Opportunity Opp)
    {
        if (TotalOpportunityValue != null && Opp.Opportunity_Rating_Overall__c != null)
        {
            Opp.Weighted_Opportunity_Revenue__c = (TotalOpportunityValue * Decimal.valueOf(Opp.Opportunity_Rating_Overall__c))/100;   
        }     	
        recalAppLogDebugList.add('Weighted_Opportunity_Revenue__c = ' + Opp.Weighted_Opportunity_Revenue__c);
    }
    
    public static void writeToAppLog(String Summary, List<String> Details)
    {
    	String sDetails = '';
    	for (String s : Details) {sDetails += '\n' + s;}
    	appLog.cachedWrite(CATEGORY_NAME,TASK_NAME + recalAppLogRecordAction,AppLogV2.LOGTYPE_INFO,Summary,sDetails);
    }
    public static void writeExceptionTpAppLog(String Summary, String Details)
    {
    	if (appLog == null) appLog = new AppLogV2(PROCESS_NAME,SUBPROCESS_NAME,CLASS_NAME,'');
    	appLog.cachedWrite(CATEGORY_NAME,TASK_NAME,AppLogV2.LOGTYPE_INFO,Summary,Details); 
    	appLog.flushCache();   	
    }
    public static void writeExceptionTpAppLog(String Summary, Exception ex)
    {
    	String sDetails = '';
    	if (appLog == null) appLog = new AppLogV2(PROCESS_NAME,SUBPROCESS_NAME,CLASS_NAME,'');
    	
    	sDetails = 'Type: ' + ex.getTypeName();
    	sDetails += '\nCause: ' + ex.getCause();
    	sDetails += '\nLine Number: ' + ex.getLineNumber();
    	sDetails += '\nMessage: ' + ex.getMessage();
    	sDetails += '\nStack Trace: ' + ex.getStackTraceString();
    	
    	appLog.cachedWrite(CATEGORY_NAME,TASK_NAME,AppLogV2.LOGTYPE_INFO,Summary,sDetails); 
    	appLog.flushCache();   	
    }    
    
    public static void setSalesPotential(Opportunity Opp)
    {
        recalAppLogDebugList.add('Entered: setSalesPotential');
        String SalesPotentialBeforeChange = Opp.Sales_Potential__c;
        String lisdCustomerGroup = Opp.Customer_Group__c;

        if (lisdCustomerGroup == null) lisdCustomerGroup = '';
        
        recalAppLogDebugList.add('TotalOpportunityValue = ' + String.ValueOf(Opp.Aqualon_Amount__c));
        recalAppLogDebugList.add('lisdCustomerGroup = ' + lisdCustomerGroup);
        recalAppLogDebugList.add('this.opp.CurrencyIsoCode is null? ' + String.ValueOf(opp.CurrencyIsoCode == null));        
                                        
        //Set Sales Potential based on Total opportunity Value
        Opp.Sales_Potential__c = SalesPotentialConfigurationFunctions.GetStaticSalesPotentialRangeFromList(
                                        Opp.Aqualon_Amount__c,
                                        lisdCustomerGroup.trim(),
                                        Opp.CurrencyIsoCode);      
        
        recalAppLogDebugList.add('Sales_Potential__c = ' + Opp.Sales_Potential__c);
                                            
        recalAppLogDebugList.add('Exiting: setSalesPotential');

    }  
    
    public static void setSalesPotentialForTotalOppValue(Opportunity Opp)
    {
        recalAppLogDebugList.add('Entered: setSalesPotentialForTotalOppValue');
        String SalesPotentialBeforeChange = Opp.Sales_Potential__c;
        String lisdCustomerGroup = Opp.Customer_Group__c;

        if (lisdCustomerGroup == null) lisdCustomerGroup = '';
        
        recalAppLogDebugList.add('TotalOpportunityValue = ' + String.ValueOf(TotalOpportunityValue));
        recalAppLogDebugList.add('lisdCustomerGroup = ' + lisdCustomerGroup);
        recalAppLogDebugList.add('this.opp.CurrencyIsoCode is null? ' + String.ValueOf(opp.CurrencyIsoCode == null));        
                                        
        //Set Sales Potential based on Total opportunity Value
        Opp.Sales_Potential__c = SalesPotentialConfigurationFunctions.GetStaticSalesPotentialRangeFromList(
                                        TotalOpportunityValue,
                                        lisdCustomerGroup.trim(),
                                        Opp.CurrencyIsoCode);      
        
        recalAppLogDebugList.add('Sales_Potential__c = ' + Opp.Sales_Potential__c);
                                            
        recalAppLogDebugList.add('Exiting: setSalesPotentialForTotalOppValue');

    }        
    
    // if any field of the given stage fields is null, return true
    private static boolean AnyOfTheGivenStageFieldsMissingValue(List<string> stageFieldsList, Opportunity Opp)
    {
        Object fieldValue ;
        
        try
        {
               
            //For each field of the given stage
            for (String f : stageFieldsList) { 

                if (f == 'VCP_Rating__c')
                    fieldValue = GetAccountVCP(opp.AccountId);
                else
                    fieldValue = Opp.get(f) ;  
                     
                if ( fieldValue == null)
                {  
                    return true;
                }
                                
            }
                
        }
        catch (Exception ex)
        {
            recalAppLogDebugList.add('AnyOfTheGivenStageFieldsMissingValue: ' + ex);           
        } 
        
        return false;   
    }     
/*    
	public static Account GetAccountInfo(Id strAccountId)
	{
		Account acc = null;
		if (strAccountId == null) return acc;
        try
        {
            acc = [select Id, Name, Inactive_Account__c, Customer_Classification_ABC__c, SAP_Sales_Office__c, 
                    SAP_DistChannel__c, SAP_Sales_Org__c
                    from Account
                    where Id = :strAccountId];        	
        }
		catch (Exception ex)
        {
            debug('GetAccountInfo: ' + ex);           
        } 
        System.Debug('GetAccountInfo:acc = ' + acc);
        return acc;
	} 
*/
	
	public static Map<Id, Account> GetAcctVCPMapForAccts(Set<Id> AcctsSet)
	{
		recalAppLogDebugList.add('Entered: GetAcctVCPMapForAccts');
        try
        {
            recalcAcctsVCPMap = new Map<Id, Account>([select Id, Customer_Classification_ABC__c
                    from Account where Id in :AcctsSet]);     
                    
            
            recalAppLogDebugList.add('recalcAcctsVCPMap Size: ' + recalcAcctsVCPMap.size());        
               	
        }
		catch (Exception ex)
        {
            recalAppLogDebugList.add('GetAcctVCPMapForAccts: ' + ex);           
        } 
        recalAppLogDebugList.add('Exiting: GetAcctVCPMapForAccts');
        return recalcAcctsVCPMap;
	}	
	
	public static String GetAccountVCP(String strAccountId)
	{
		String returnValue = '';
		
		recalAppLogDebugList.add('GetAccountVCP:strAccountId = ' + strAccountId);
		
		//Account acc = GetAccountInfo(strAccountId);
		Account acc = recalcAcctsVCPMap.get(strAccountId);
		
		if (acc != null)
		{
			//System.Debug('GetAccountVCP:acc.Customer_Classification_ABC__c = ' + acc.Customer_Classification_ABC__c);
			returnValue = acc.Customer_Classification_ABC__c;
		}
		else
		{
			recalAppLogDebugList.add('GetAccountVCP:acc is null');
		}
		
		//System.Debug('GetAccountVCP:returnValue = ' + returnValue);
		return returnValue;
	}  
    
    public static Boolean hasRatingFieldChanged(Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap) 
    {
        Boolean ratingFieldChanged = false;
        Opportunity oldOpp;
        
        // all opportunities
		for (Opportunity newOpp : newMap.values()) {
			oldOpp = oldMap.get(newOpp.Id);
			
			// all scoring fields
	        for (String f : AllScoringFields) { 

	            if (f == 'VCP_Rating__c')
	            {
		            if (GetAccountVCP(oldOpp.AccountId) != GetAccountVCP(newOpp.AccountId))
		            {
		                ratingFieldChanged = true;
		                recalcRatingForOppList.add(newOpp.Id);                
		            }	                
	            }
	            else
				{
		            if (oldOpp.get(f) != newOpp.get(f)) 
		            {
		                ratingFieldChanged = true;
		                recalcRatingForOppList.add(newOpp.Id);			                
		            }					
				}
	                 
	                  
	        }   			
			
		}            
        
        return ratingFieldChanged;
    }    
           
    
    private static void debug(String s) {
    	System.debug(LoggingLevel.INFO, 'Opportunity_Functions : ' + s);
    }
    
    public static void processAfterUpdate(Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap) {
    	createOpportunityChangeLogs(oldMap, newMap);   	       	
    }
    
    public static void processBeforeInsert(List<Opportunity> opps) {
        Date tdate = Date.today(); writeToAppLogBoolean = getOppWriteToAppLog(); recalAppLogDebugList.clear();
        try
        {
	        for (Opportunity op : opps) {
	            op.Stage_Changed_On__c = tdate;
	        	setProjectType(op);
	        	
		    	// used in getting the VCP for these accounts
		    	recalcAcctsSet.add(op.AccountId);
	        }

       
	        //Get map of account id, vcp used in recalc ratings
	        GetAcctVCPMapForAccts(recalcAcctsSet);     
	        
	        if (appLog == null) appLog = new AppLogV2(PROCESS_NAME,SUBPROCESS_NAME,CLASS_NAME,'');
	        recalAppLogRecordAction = 'on record insert';
	        for (Opportunity op : opps) {
				// SS - Request-5833 - Cal ratings when not overridden
	            if (!op.Override_Stage__c)
	            {		        	
			    	CalculateRatings(op);
			    	TotalOpportunityValue = op.Aqualon_Amount__c;
			        //Update Weighted Opportunity Revenue
			        SetWeightedOpportunityRevenueValue(op);
			        if (writeToAppLogBoolean)
			        {
			        	if (op.Name != null)
							writeToAppLog('Opp: ' + op.Name + ' - ' + Datetime.now(), recalAppLogDebugList);
						else
							writeToAppLog('Opp Name is null ' + Datetime.now(), recalAppLogDebugList);
			        }
	            }    	    	    
	        }  
			appLog.flushCache();
		
        }
        catch (Exception ex)
        {
            writeExceptionTpAppLog('Exception in processBeforeInsert', ex);               
        } 		
    }
    
    public static void processBeforeUpdate(Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap) {
        Opportunity oldOpp; Date tdate = Date.today(); writeToAppLogBoolean = getOppWriteToAppLog(); recalAppLogDebugList.clear();
        try
        {
	        for (Opportunity newOpp : newMap.values()) {
	            oldOpp = oldMap.get(newOpp.Id);
	            if (stageChanged(newOpp, oldOpp)) {
	            	newOpp.Stage_Changed_On__c = tdate;
					if (STAGES_TO_SET_CLOSED_DATE.contains(newOpp.StageName)) 
					{
		            	// SS - Request-5867 - dont set the close date to today's date for ASI 
		            	String RecordTypeName =  OPP_RT_MAP.get(newOpp.RecordTypeId);
			            if (RecordTypeName != 'Aqualon Opportunity - EMEA' 
			                && RecordTypeName != 'Aqualon Opportunity - Latin Amer' 
			                && RecordTypeName != 'Aqualon Opportunity - NA' )
			            {						
							newOpp.CloseDate = tdate;
			            }	
					} 
	            }
	            setProjectType(newOpp);	
	
		    	// used in getting the VCP for these accounts
		    	recalcAcctsSet.add(newOpp.AccountId);                	         
	        }
	
	        // if any of the rating field has changed
	        if (hasRatingFieldChanged(oldMap, newMap))
	        {
		        //Get map of account id, vcp used in recalc ratings
		        GetAcctVCPMapForAccts(recalcAcctsSet);  
		        if (appLog == null) appLog = new AppLogV2(PROCESS_NAME,SUBPROCESS_NAME,CLASS_NAME,'');  
		        recalAppLogRecordAction = 'on record update';    	
	        	for (Id recalcOppId : recalcRatingForOppList)
	        	{
	        		Opportunity newOpp = newMap.get(recalcOppId);
					// SS - Request-5833 - Cal ratings when not overridden
		            if (!newOpp.Override_Stage__c)
		            {		        		
		        		CalculateRatings(newOpp);
				    	TotalOpportunityValue = newOpp.Aqualon_Amount__c;
				        //Update Weighted Opportunity Revenue
				        SetWeightedOpportunityRevenueValue(newOpp);	        		
				        if (writeToAppLogBoolean)
				        {
				        	if (newOpp.Name != null)
								writeToAppLog('Opp: ' + newOpp.Name + ' - ' + Datetime.now(), recalAppLogDebugList);
							else
								writeToAppLog('Opp Name is null ' + Datetime.now(), recalAppLogDebugList);
				        }
		            }
	
	        	}
				appLog.flushCache();
	        }
        }
        catch (Exception ex)
        {
            writeExceptionTpAppLog('Exception in processBeforeUpdate', ex);          
        }         
    }
    
    public static void processBeforeUpsert(List<Opportunity_Material__c> alist) {
        Id aqMatRecTypeId = MAT_RT_MAP.get('AQ Opportunity Material');
        List<Opportunity_Material__c> blist = new List<Opportunity_Material__c>();
        Set<String> mset = new Set<String>();
	    for (Opportunity_Material__c a : alist) {       
	        if (a.RecordTypeID == aqMatRecTypeId && a.SAP_Material_Code__c != null){
	        	blist.add(a); mset.add(a.SAP_Material_Code__c);
	        }
	    }
	    updateAqMaterials(blist, mset);
    }
    
    private static void setProjectType(Opportunity op) {
        String recType = OPP_RT_MAP.get(op.RecordTypeId);
        if (recType != null && OPP_CNFG_MAP.containsKey(recType)) {
            OpportunitiesConfig__c oc = OPP_CNFG_MAP.get(recType);
            op.Project_Type__c = oc.Project_Type__c;
        }
    }
    
    private static void createOpportunityChangeLogs(Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap) {
    	setOpportunityChangeLogMaps(newMap.keySet());
    	List<Opportunity_Change_Log__c> ocls = new List<Opportunity_Change_Log__c>();
    	Opportunity_Change_Log__c ocl; Opportunity oldOpp; String k;
    	for (Opportunity newOpp : newMap.values()) {
    		oldOpp = oldMap.get(newOpp.Id);
    		if (!changeLogNeeded(newOpp, oldOpp)) {continue;}
    		ocl = new Opportunity_Change_Log__c();
    		ocl.Account__c = newOpp.AccountId;
    		ocl.Close_Date__c = newOpp.CloseDate;
            ocl.Opportunity__c = newOpp.Id;
    		ocl.Opportunity_Modified_By__c = newOpp.LastModifiedById;
    		ocl.Opportunity_Modified_Date__c = newOpp.LastModifiedDate;
    		if (newOpp.StageName != oldOpp.StageName) {
    			ocl.Stage_Change__c = true;
    			ocl.New_Stage__c = newOpp.StageName;
    			ocl.Previous_Stage__c = oldOpp.StageName;
                k = ocl.Opportunity__c + LTGT + ocl.Previous_Stage__c;
                ocl.Stage_Duration__c = getPreviousValueDuration(stageNameChangeMap, k, newOpp);
    		}
    		if (newOpp.Amount != oldOpp.Amount) {
    			ocl.Amount_Change__c = true;
    			ocl.New_Amount__c = newOpp.Amount;
    			ocl.Previous_Amount__c = oldOpp.Amount;
    		}
    		if (newOpp.RecordTypeId != oldOpp.RecordTypeId) {
    			ocl.RecordType_Change__c = true;
    			ocl.New_RecordType__c = OPP_RT_MAP.get(newOpp.RecordTypeId);
    			ocl.Previous_RecordType__c = OPP_RT_MAP.get(oldOpp.RecordTypeId);
                k = ocl.Opportunity__c + LTGT + ocl.Previous_RecordType__c;
                ocl.RecordType_Duration__c = getPreviousValueDuration(recordTypeChangeMap, k, newOpp);
    		}
    		ocls.add(ocl);
    	}
    	if (!ocls.isEmpty()) {insert ocls;}
    }
    
    private static Integer getPreviousValueDuration(Map<String, Opportunity_Change_Log__c> oclMap, 
                                                    String key, Opportunity opp) {
        Date d1 = opp.CreatedDate.date(), d2 = opp.LastModifiedDate.date();
        if (oclMap.containsKey(key)) {d1 = oclMap.get(key).CreatedDate.date();}
    	return d1.daysBetween(d2);
    }
    
    private static void setOpportunityChangeLogMaps(Set<Id> oppIds) {
        stageNameChangeMap = new Map<String, Opportunity_Change_Log__c>();
        recordTypeChangeMap = new Map<String, Opportunity_Change_Log__c>();
        List<Opportunity_Change_Log__c> ocls = [
            select createdDate, Opportunity__c, New_Stage__c, New_RecordType__c,
                   Stage_Change__c, RecordType_Change__c
              from Opportunity_Change_Log__c
             where Opportunity__c in :oppIds
               and (Stage_Change__c = true or RecordType_Change__c = true)];
        if (ocls == null || ocls.isEmpty()) {return;}
        String k;
        for (Opportunity_Change_Log__c ocl : ocls) {
        	if (ocl.Stage_Change__c) {
	        	k = ocl.Opportunity__c + LTGT + ocl.New_Stage__c;
	        	stageNameChangeMap.put(k, ocl);
        	}
            if (ocl.RecordType_Change__c) {
	            k = ocl.Opportunity__c + LTGT + ocl.New_RecordType__c;
	            recordTypeChangeMap.put(k, ocl);
            }
        }
    }
    
    private static Boolean stageChanged(Opportunity newOpp, Opportunity oldOpp) {
        return (newOpp.StageName != oldOpp.StageName);
    }
    
    private static Boolean changeLogNeeded(Opportunity newOpp, Opportunity oldOpp) {
    	return (newOpp.StageName != oldOpp.StageName || 
    	        newOpp.Amount != oldOpp.Amount || 
    	        newOpp.RecordTypeId != oldOpp.RecordTypeId);
    }
    
    public static Map<String, OpportunityStage> getOpportunityStageMap() {
    	if (smap != null) {return smap;}
    	smap = new Map<String, OpportunityStage>();
    	List<OpportunityStage> slist = [select Id, 
                                               DefaultProbability,
    	                                       ForecastCategoryName, 
    	                                       ForecastCategory,
                                               MasterLabel,
                                               SortOrder
    	                                  from OpportunityStage
    	                                 where IsActive = true];
        if (slist != null && !slist.isEmpty()) {
        	for (OpportunityStage s : slist) {
        		smap.put(s.MasterLabel, s);
        	}
        }
        return smap;
    }
    
    public static Decimal getStageRating(String stageName) {
    	Decimal stageRating = 0;
        if (stageName != null && OPP_CNFG_MAP.containsKey(stageName)) {
            OpportunitiesConfig__c oc = OPP_CNFG_MAP.get(stageName);
            stageRating = oc.Stage_Rating__c;
        }
        return stageRating;
    }
    
    public static Boolean getOppWriteToAppLog() {
    	Boolean OppWriteToAppLog = false;
        if (OPP_CNFG_MAP.containsKey('OppWriteToAppLog')) {
            OpportunitiesConfig__c oc = OPP_CNFG_MAP.get('OppWriteToAppLog');
            OppWriteToAppLog = oc.WriteToAppLog__c;
        }
        return OppWriteToAppLog;
    }    
    
    public static void updateAqMaterials(List<Opportunity_Material__c> matlist,
                                         Set<String> matNums) {
        if (matlist.isEmpty() || matNums.isEmpty()) {return;}
        Set<String> mtUoms = new Set<String>{UOM_CODE_MT}; Double uomConvFac;
        Map<String, Map<String, String>> mumap = Material_UOM_Functions.getUomConversionFactors(matNums, mtUoms);
        debug('mumap : ' + mumap);
        for (Opportunity_Material__c mat : matlist) {
            debug('mat : ' + mat);
        	uomConvFac = Material_UOM_Functions.getUomConversionFactor(
                mat.SAP_Material_Code__c, mat.Unit_of_Measure__c, UOM_CODE_MT, mumap);
            debug('uomConvFac : ' + uomConvFac);
            if (mat.Quantity__c != null) {mat.Quantity_in_MT__c = mat.Quantity__c * uomConvFac;}
            if (mat.Sales_Price__c != null) {mat.Sales_Price_per_MT__c = mat.Sales_Price__c / uomConvFac;}     
            mat.Revenue__c = 0.0;
            if (mat.Sales_Price__c != null && mat.Quantity__c != null) { 
                mat.Revenue__c = mat.Sales_Price__c * mat.Quantity__c;
            }
        }
    }
    
    
}
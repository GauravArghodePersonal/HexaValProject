/**
*	Class Name: OpportunityRatingConfigFunctions
*	Purpose: This class provide functions for Opportunity Scoring that can be used
*		by VF page, trigger, etc.
*	Note: since the scoring data is related to a custoemr group and sales office,
*		these two fields are required, therefore, to use this instantiate this class
*		passing in those values
*
*/
public class OpportunityRatingConfigFunctions {

	private string customerGroup = '';
	private string salesOffice = '';
	private List<Opportunity_Rating_Configuration__c> orcList;
	private Map<String, Decimal> fieldValueScoreMap = new Map<String, Decimal>();

	/**
	*	Name: OpportunityRatingConfigFunctions
	* 	Input: Customer Group and Sales Office
	*	Purpose: this constructor takes in two parmeters and then calls the GetRatingsListFor
	* 		to get the scoring map built for this customer group and sales office
	*/	
	public OpportunityRatingConfigFunctions(String CustomerGroup, String SalesOffice)
	{
		GetRatingsListFor(CustomerGroup, SalesOffice);

	}
	/**
	*	Name: GetRatingsListFor
	* 	Input: Customer Group and Sales Office
	*	Purpose: get rating config data for customer group and sales office then create a map where
	*		key: is combination of field name and field value and the value: is the score
	*/	
	public List<Opportunity_Rating_Configuration__c> GetRatingsListFor(String CustomerGroup, String SalesOffice)
	{
		orcList = 
			[SELECT Field_Name__c, Field_Value__c, Score__c, Business_Unit__c, Sales_Office__c
		        FROM Opportunity_Rating_Configuration__c
		            WHERE 
		                Business_Unit__c = :CustomerGroup AND
		                Sales_Office__c = :SalesOffice
            ];	
        
        system.debug('Total records: ' + orcList.size() + ' for customer group: ' + CustomerGroup +
        	' and Sales Office: ' + SalesOffice);   
        	
        if (orcList.size() > 0)
        {
        	for (Opportunity_Rating_Configuration__c orc : orcList)
        	{
	        	String key = orc.Field_Name__c + orc.Field_Value__c.replace(' ', '');
	        	//system.debug('GetRatingsListFor Key: ' + key.toLowerCase());
	        	fieldValueScoreMap.put(key.toLowerCase(), orc.Score__c);
        	}
        }
        //system.debug('fieldValueScoreMap get: ' + fieldValueScoreMap.get('relationshipstatuscoachcfavorus'.toLowerCase()));

        return orcList;		
	}
	/**
	*	Name: GetScoreForFieldValueFromMap
	* 	Input: Key
	* 	Output: Score
	*	Purpose: returns the score for the field. The key is a combination of field name and field value 
	*		but remove spaces from field value
	*/	
	public Decimal GetScoreForFieldValueFromMap(String key)
	{
		Decimal returnValue = 0.00;
		system.debug('GetScoreForFieldValueFromMap input: ' + key);
		returnValue = fieldValueScoreMap.get(key);
		system.debug('GetScoreForFieldValueFromMap returnValue: ' + returnValue);
		return returnValue;
	}
	/**
	*	Name: propOppRatingConfigList
	* 	Output: Rating config data
	*	Purpose: Returns the config data retrieved for the customer group and sales force
	*		at the time of class instantiation
	*/		
	public List<Opportunity_Rating_Configuration__c> propOppRatingConfigList
	{
		get {return orcList; }
	}
	
}
/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class SalesPotentialConfigurationFunctions_T {
	
	/* Start: Used in data creation */
	
	static integer expectedRange = 6;
	static string defaultCurrency = 'USD';
	static List<string> BUList = new list<string>
	{
		'50', '51', '52', '53', '54', '56', '57', '58', '59', '5B', '5G', '5H', '5I', '5J', '5K', '5L'
	};
	static List<string> salesPotentialRangeList = new List<string>
	{
		'<10M', '10M-25M', '25M-50M', '50M-100M', '100M-500M', '>500M'
	};
	static List<string> rangeMaxList = new List<string>
	{
		'9999', '24999', '49999', '99999', '499999', '2147483647'
	};	
	static List<string> rangeMinList = new List<string>
	{
		'0', '10000', '25000', '50000', '100000', '500000'
	};	
	
	/* End: Used in data creation */

	static List<Sales_Potential_Configuration__c> returnList;
	static Map<ID, Sales_Potential_Configuration__c> returnMap;

    static testMethod void myUnitTest() {
 		
 		createTestData();
    	
        returnMap = getSalesPotentialConfigMap();
        
        GetSalesPotentialRange();                       
                
    }

    static testMethod Map<ID, Sales_Potential_Configuration__c> getSalesPotentialConfigMap()
    {
    	return SalesPotentialConfigurationFunctions.getSalesPotentialConfigMap();
    } 
    
    static testMethod void GetSalesPotentialRange()
    {
    	String salesPotenRange;
    	
    	system.debug('***** test static method *****');
        salesPotenRange = GetSalesPotentialRangeFromList(0, '50', 'CAD');
        system.debug('***salesPotenRange: ' + salesPotenRange);
        
        salesPotenRange = GetSalesPotentialRangeFromList(10000, '50', 'USD');
        system.debug('***salesPotenRange: ' + salesPotenRange);
      
        salesPotenRange = GetSalesPotentialRangeFromList(100000, '51', 'USD');
        system.debug('***salesPotenRange: ' + salesPotenRange);
        
        salesPotenRange = GetSalesPotentialRangeFromList(1000000, '5B', 'USD');
        system.debug('***salesPotenRange: ' + salesPotenRange);  
        
        system.debug('***** test instance method *****');
        SalesPotentialConfigurationFunctions spcf = new SalesPotentialConfigurationFunctions();
        
        salesPotenRange = spcf.GetSalesPotentialRangeFromList(0, '50', 'CAD');
        system.debug('***salesPotenRange: ' + salesPotenRange);
        
        salesPotenRange = spcf.GetSalesPotentialRangeFromList(10000, '50', 'USD');
        system.debug('***salesPotenRange: ' + salesPotenRange);
      
        salesPotenRange = spcf.GetSalesPotentialRangeFromList(100000, '51', 'USD');
        system.debug('***salesPotenRange: ' + salesPotenRange);
        
        salesPotenRange = spcf.GetSalesPotentialRangeFromList(1000000, '5B', 'USD');
        system.debug('***salesPotenRange: ' + salesPotenRange);          
           	
    }
    
    static String GetSalesPotentialRangeFromList(Decimal amount, String BusinessUnit, String CurrencyCode)
    {
    	return SalesPotentialConfigurationFunctions.GetStaticSalesPotentialRangeFromList(amount, BusinessUnit, CurrencyCode);
    }     
    

	  
    /******************************************** Start: Create test data ********************************************/
    static void createTestData()
    {
    	List<Sales_Potential_Configuration__c> spcs = new List<Sales_Potential_Configuration__c>();
    	for (string bu : BUList)
    	{
    		createSalesPotenConfigFor(bu, spcs);
    	}
    	insert spcs;
    }
    
    static void createSalesPotenConfigFor(string BU, List<Sales_Potential_Configuration__c> spcs)
    {

    	for (integer i=0; i<expectedRange; i++)
    	{
    		Sales_Potential_Configuration__c spc = new Sales_Potential_Configuration__c();
    		spc.Business_Unit__c = BU;
    		spc.CurrencyIsoCode = defaultCurrency;
    		spc.Sales_Potential__c = salesPotentialRangeList[i];
    		spc.Range_Min__c = Decimal.valueOf(rangeMinList[i]);
    		spc.Range_Max__c = Decimal.valueOf(rangeMaxList[i]);
    		spcs.add(spc);
    		
    	}

    }
    /******************************************** End: Create test data ********************************************/
}
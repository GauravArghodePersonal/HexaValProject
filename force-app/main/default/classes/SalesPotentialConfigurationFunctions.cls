public class SalesPotentialConfigurationFunctions {

	private List<Sales_Potential_Configuration__c> allSalesPotentialConfigList;
	private static List<Sales_Potential_Configuration__c> allStaicSalesPotentialConfigList;
	
	public SalesPotentialConfigurationFunctions()
	{
		allSalesPotentialConfigList = getSalesPotentialConfigList();
		
	}

	public List<Sales_Potential_Configuration__c> getSalesPotentialConfigList()
	{
		List<Sales_Potential_Configuration__c> returnValue = 
				[SELECT Business_Unit__c, Sales_Potential__c, Range_Min__c, Range_Max__c, CurrencyIsoCode
		         FROM Sales_Potential_Configuration__c 
		        ] ; 
		                    
		return returnValue;
	}

	public String GetSalesPotentialRangeFromList(Decimal amount, String BusinessUnit, String CurrencyCode)
	{
		String returnValue = '';
		if (allSalesPotentialConfigList == null) getSalesPotentialConfigList();
		amount = ConvertAmountToUSD(amount, CurrencyCode);
		if (allSalesPotentialConfigList.size() > 0)
		{ 
			for (Sales_Potential_Configuration__c spc : allSalesPotentialConfigList)
			{
				if (spc.Business_Unit__c == BusinessUnit 
					&& spc.Range_Min__c <= amount && spc.Range_Max__c >= amount 
					&& spc.CurrencyIsoCode == CurrencyCode)
				{
					returnValue = spc.Sales_Potential__c;
					break;
				}
			}
		}
		return returnValue;						
		
	}
	
	public Decimal ConvertAmountToUSD(Decimal amount, String CurrencyCode)
	{
		Decimal returnValue = 0;
        if (CurrencyCode != 'USD')
        {
            CurrencyConverter.ExchangeRate exchRateObj = CurrencyConverter.getConvertedCurrency(
                Double.valueOf(amount), 
                CurrencyCode, 'USD');                                       
                
            if (exchRateObj != null)
            {   
                returnValue = exchRateObj.valueTo;         
            }
            else
            {       
                String errMsg = 'Unable to convert currency to USD, please contact System Administrator';
                CustomException.throwException(errMsg);
            
            }

        }		
		
		return returnValue; 
	}
	
	/******************************************** Start: Static methods ********************************************/
	
	public static String GetStaticSalesPotentialRangeFromList(Decimal amount, String BusinessUnit, String CurrencyCode)
	{
		system.debug('GetStaticSalesPotentialRangeFromList amount: ' + amount);
		system.debug('GetStaticSalesPotentialRangeFromList BusinessUnit: ' + BusinessUnit);
		system.debug('GetStaticSalesPotentialRangeFromList CurrencyCode: ' + CurrencyCode);
		
		String returnValue = '';
		if (allStaicSalesPotentialConfigList == null) allStaicSalesPotentialConfigList = getStaticSalesPotentialConfigList();
		amount = ConvertAmountToUSDStatic(amount, CurrencyCode);
		if (allStaicSalesPotentialConfigList.size() > 0)
		{ 
			for (Sales_Potential_Configuration__c spc : allStaicSalesPotentialConfigList)
			{
				if (spc.Business_Unit__c == BusinessUnit 
					&& spc.Range_Min__c <= amount && spc.Range_Max__c >= amount 
					&& spc.CurrencyIsoCode == CurrencyCode)
				{
					returnValue = spc.Sales_Potential__c;
					break;
				}
			}
		}
		system.debug('GetStaticSalesPotentialRangeFromList returnValue: ' + returnValue);
		
		return returnValue;						
		
	}	
	
	public static List<Sales_Potential_Configuration__c> getStaticSalesPotentialConfigList()
	{
		List<Sales_Potential_Configuration__c> returnValue = 
				[SELECT Business_Unit__c, Sales_Potential__c, Range_Min__c, Range_Max__c, CurrencyIsoCode
		         FROM Sales_Potential_Configuration__c 
		        ] ; 
		                    
		return returnValue;
	}	
	
	public static Map<ID, Sales_Potential_Configuration__c> getSalesPotentialConfigMap()
	{
		Map<ID, Sales_Potential_Configuration__c> returnValue = 
			new Map<ID, Sales_Potential_Configuration__c>
			([SELECT Business_Unit__c, Sales_Potential__c, Range_Min__c, Range_Max__c, CurrencyIsoCode 
		      FROM Sales_Potential_Configuration__c 
		     ]);
		      
		return returnValue;
	}
	
	public static Decimal ConvertAmountToUSDStatic(Decimal amount, String CurrencyCode)
	{
		system.debug('ConvertAmountToUSDStatic amount: ' + amount);
		system.debug('ConvertAmountToUSDStatic CurrencyCode: ' + CurrencyCode);
		Decimal returnValue = amount;
        if (CurrencyCode != 'USD')
        {
            CurrencyConverter.ExchangeRate exchRateObj = CurrencyConverter.getConvertedCurrency(
                Double.valueOf(amount), 
                CurrencyCode, 'USD');                                       
                
            if (exchRateObj != null)
            {   
                returnValue = exchRateObj.valueTo;         
            }
            else
            {       
                String errMsg = 'Unable to convert currency to USD, please contact System Administrator';
                CustomException.throwException(errMsg);
            
            }

        }		
		system.debug('ConvertAmountToUSDStatic returnValue: ' + returnValue);
		return returnValue; 
	}		
	
	/******************************************** End: Static methods ********************************************/	

}
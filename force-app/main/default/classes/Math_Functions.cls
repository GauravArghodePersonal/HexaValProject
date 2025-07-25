public class Math_Functions {

    private static void debug(String s) {
    	System.debug(LoggingLevel.INFO, 'Math_Functions : ' + s);
    }
    
    public static Double roundNumber(Double numbertoRound,Integer decimalPlaces) {
    	Double result, multiplier = math.pow(10,decimalPlaces);
		if (decimalPlaces > 0) {
			Double numerator = (numbertoRound * multiplier).round();
			result = numerator / multiplier; 
		} else {result = numbertoRound.round();}
    	return result;
    }

    public static String formatNumber(Double valueIn) {
    	Integer decimalPlaces = 0; 
        return formatNumber(valueIn, decimalPlaces);
    }
    
    public static String formatNumber(Double valueIn,Integer decimalPlaces) {
    	Boolean round = true; Boolean includeCommas = true; 
    	return formatNumber(valueIn, decimalPlaces, round, includeCommas);
    }
    
	public static String formatNumber(Double valueIn,Integer decimalPlaces, Boolean round, Boolean includeCommas) {

		String result = '';	
		debug('valueIn = ' + valueIn);

		try {
		
			if (valueIn != null)
				{
				Double rounded_truncatedValue;
		
				if(round == true)
					{rounded_truncatedValue = roundNumber(valueIn,decimalPlaces);}
				else
					{rounded_truncatedValue = roundNumber(valueIn,decimalPlaces);}  // Need to write Trunc version of Round function
		
				debug('rounded_truncatedValue = ' + rounded_truncatedValue);
		
				//Convert Double to String
				String stringValue = String.valueOf(rounded_truncatedValue);
				
				if (stringValue.indexOf('E') > 0)
					{
					String nbr = stringValue.substring(0,(stringValue.indexOf('E')));
					Integer e = Integer.valueOf(stringValue.substring((stringValue.indexOf('E') + 1),stringValue.length()));
					Integer currentDecimalPlace = nbr.indexOf('.');
		
					debug('nbr = ' + nbr + ' --- e = ' + e + ' --- currentDecimalPlace = ' + currentDecimalPlace);
					if ((nbr.length() + 2) < e) {for(integer i=0; i<e; i++) {nbr += '0';}}
					debug('nbr = ' + nbr + ' --- e = ' + e + ' --- currentDecimalPlace = ' + currentDecimalPlace);
		
		
					debug('nbr.substring(0,currentDecimalPlace) = ' + nbr.substring(0,currentDecimalPlace));
					debug('nbr.substring(currentDecimalPlace + 1,nbr.length()) = ' + nbr.substring(currentDecimalPlace + 1,nbr.length()));
					nbr = nbr.substring(0,currentDecimalPlace) + nbr.substring(currentDecimalPlace + 1,nbr.length());
					debug('nbr 1= ' + nbr);
					String nbr2 = '';
					nbr2 =  nbr.substring(0,currentDecimalPlace + e);
					if((currentDecimalPlace + e) >= nbr.length())
						{nbr2 += '.0';}
					else
						{nbr2 += '.' + nbr.substring(currentDecimalPlace + e,nbr.length());}
						
					debug('nbr 2= ' + nbr2);
					
					stringValue = nbr2;
					
					}
		
				debug('stringValue = ' + stringValue);
		
				//Add Correct Number of Decimal Places.  If requested is zero, remove decimal point and trailing 0
				Integer locOfDecimalPlace = stringValue.indexOf('.');
				Integer LengthofString = stringValue.length();
				Integer CurrentNumberofDecimals = LengthofString - (locOfDecimalPlace + 1);
				Integer decimalstoAdd = 0;Integer decimalstoRemove = 0;
				if(decimalPlaces < CurrentNumberofDecimals) {decimalstoRemove = CurrentNumberofDecimals - decimalPlaces;}
				if(decimalPlaces > CurrentNumberofDecimals) {decimalstoAdd = decimalPlaces - CurrentNumberofDecimals;}
		
				if(decimalstoRemove > 0)
					{
					stringValue = stringValue.substring(0,(LengthofString - decimalstoRemove));
					if (stringValue.endsWith('.') == true) {stringValue = stringValue.substring(0,(stringValue.length() - 1));}
					}
		
				if(decimalstoAdd > 0)
					{
					for(integer i=0;i<decimalstoAdd;i++) {stringValue += '0';}
					}
		
				//Add Commas appropriately
				if(includeCommas == true)
					{
					locOfDecimalPlace = stringValue.indexOf('.');
					if (locOfDecimalPlace == -1) {locOfDecimalPlace = stringValue.length();}
					for(integer i=locOfDecimalPlace;i>=0;i--)
						{
						Integer numberPos = locOfDecimalPlace - i;				
						if ((numberPos==3) || (numberPos==6) || (numberPos==9) || (numberPos==12) || (numberPos==15) || (numberPos==18))
						    {stringValue = stringValue.substring(0,i) + ',' + stringValue.substring(i,stringValue.length());}
						}
					if (stringValue.startsWith(',') == true) {stringValue = stringValue.substring(1,stringValue.length());}
					if (stringValue.startsWith('-,') == true) {stringValue = '-' + stringValue.substring(2,stringValue.length());}
					}
			
				result = stringValue;
				}
			}
		catch (Exception e) {
			String body = 'The try/catch errored in the formatNumber function.  The values passed into the function are:\n';
			body += 'valueIn = ' + valueIn + '\n';
			body += 'decimalPlaces = ' + decimalPlaces + '\n';
			body += 'round = ' + round + '\n';
			body += 'includeCommas = ' + includeCommas + '\n';
			body += '\n\n Exception Info = ' + e;
            debug('Exception Occurred in Math_Functions.formatNumber : ' + body);
		}
		
		return result;
	}



//******************
//Test Method 
//******************
  @isTest static void TestMe() {

	Double test1 = 1.2345;
	Double test2 = 1.9999;

	debug('roundNumber - 1.2345 (2)= ' + roundNumber(test1,2));
	debug('roundNumber - 1.9999 (2)= ' + roundNumber(test2,2));
	debug('roundNumber - 1.2345 (0)= ' + roundNumber(test1,0));
	debug('roundNumber - 1.9999 (0)= ' + roundNumber(test2,0));

	debug('formatNumber - 1.2345 (2)= ' + formatNumber(test1,2,true,true));
	debug('formatNumber - 1.9999 (2)= ' + formatNumber(test2,2,true,true));
	debug('formatNumber - 1.9999 (2)= ' + formatNumber(test2,2,false,true));
	debug('formatNumber - 1.2345 (0)= ' + formatNumber(test1,0,true,true));
	debug('formatNumber - 1.9999 (0)= ' + formatNumber(test2,0,true,true));
	debug('formatNumber - 1.9999 (0)= ' + formatNumber(test2,0,false,true));

	debug(formatNumber(1.0,2,true,true));
	debug(formatNumber(11.1234,2,true,true));
	debug(formatNumber(111.1234,2,true,true));
	debug(formatNumber(1111.1234,2,true,true));
	debug(formatNumber(11111.1234,2,true,true));
	debug(formatNumber(111111.1234,2,true,true));
	debug(formatNumber(1111111.1234,2,true,true));
	debug(formatNumber(11111111.1234,2,true,true));
	debug(formatNumber(111111111.1234,2,true,true));
	debug(formatNumber(1111111111.1234,2,true,true));
	debug(formatNumber(11111111111.1234,2,true,true));
	debug(formatNumber(111111111111.1234,2,true,true));

	debug(formatNumber(1.0,0,true,true));
	debug(formatNumber(11.1234,0,true,true));
	debug(formatNumber(111.1234,0,true,true));
	debug(formatNumber(1111.1234,0,true,true));
	debug(formatNumber(11111.1234,0,true,true));
	debug(formatNumber(111111.1234,0,true,true));
	debug(formatNumber(1111111.1234,0,true,true));
	debug(formatNumber(11111111.1234,0,true,true));
	debug(formatNumber(111111111.1234,0,true,true));
	debug(formatNumber(1111111111.1234,0,true,true));
	debug(formatNumber(11111111111.1234,0,true,true));
	debug(formatNumber(111111111111.1234,0,true,true));

	debug(formatNumber(100000000000.0,0,true,true));


  }

//The End


}
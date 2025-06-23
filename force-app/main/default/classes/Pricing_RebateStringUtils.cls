/*
 * Class        : Pricing_RebateStringUtils
 * Developer/Org: Krishna Krupal/Bluewolf
 * Created      : Nov 16, 2011
 * Objective    : This is a utility class for any operations involving strings that can be reused
*/
public with sharing class Pricing_RebateStringUtils {
	
	/**
	 * Checks if the string is null or blank
	 * @param String
	 * @return Boolean 
	*/
	public static boolean isNullOrBlank(String str){
		if(str != null && str.length() > 0)
			return false;
		else
			return true;	
	}
}
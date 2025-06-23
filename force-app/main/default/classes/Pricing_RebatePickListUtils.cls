/*
 * Class        : Pricing_RebatePickListUtils
 * Developer/Org: Krishna Krupal/Bluewolf
 * Created      : Nov 15, 2011
 * Objective    : This is a utility class for any operations involving picklists that can be reused
*/
public with sharing class Pricing_RebatePickListUtils {
	
	public static List<SelectOption> addPickListValues(Set<String> options, boolean addNoneOption){
		List<SelectOption> statusOptions = new List<SelectOption>();
    	//add the None option if specifid
    	if(addNoneOption)
    		statusOptions.add(new SelectOption('','--None--'));
    	//create a picklist value for each of the specified options
    	for(String option : options){
    		statusOptions.add(new SelectOption(option,option));
    	}
    	return statusOptions;
	}
	
	/*
		This method takes list as an argument because we need ordered collection
	 */
	public static List<SelectOption> addPickListValuesFromList(List<String> options, boolean addNoneOption){
		List<SelectOption> statusOptions = new List<SelectOption>();
    	//add the None option if specifid
    	if(addNoneOption)
    		statusOptions.add(new SelectOption('','--None--'));
    	//create a picklist value for each of the specified options
    	for(String option : options){
    		statusOptions.add(new SelectOption(option,option));
    	}
    	return statusOptions;
	}
	
}
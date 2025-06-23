@isTest
private class UOM_Conversion_Functions_Test {

    static String testUom = 'Test UOM';
    static String accountRecordType = 'Test AccountRecordType';
    
    static testMethod void myUnitTest() {
    	UOM_Conversion__c uomc = new UOM_Conversion__c();
    	uomc.UOM__c = testUom;
    	uomc.Qty_Greater_Than_or_Equal_to_5_Gallons__c = 1;
    	insert uomc;
    	
    	UOM_Account_Record_Type__c uart = new UOM_Account_Record_Type__c();
    	uart.UOM_Conversion__c = uomc.Id;
    	uart.Account_Record_Type__c = accountRecordType;
    	uart.Record_Key__c = accountRecordType + '-' + uomc.Id;
    	uart.Sample_Quantity_1__c = 1;
    	insert uart;
    	 
	    UOM_Conversion_Functions.UOMQty_Greater_Than_5_Gallons(testUom, 10);
	    
        UOM_Conversion_Functions.getUomSelectOptions('xxxxxxxxx');  
	    List<SelectOption> sol = UOM_Conversion_Functions.getUomSelectOptions(accountRecordType);  
        System.debug(sol);
	    
        UOM_Conversion_Functions.getSampleQuantities('xxxxxxxxx');
	    Map<String, Map<String, Double>> qmap = UOM_Conversion_Functions.getSampleQuantities(accountRecordType);
	    System.debug(qmap);
	    
    }
}
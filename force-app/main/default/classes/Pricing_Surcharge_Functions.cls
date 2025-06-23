global class Pricing_Surcharge_Functions {

  Webservice static List<Pricing_Surcharge_Break__c> Retrieve_Pricing_Surcharges(Id accountId,Id plantId) {
    List<Pricing_Surcharge_Break__c> results;
    
    List<Pricing_Surcharge__c> surcharge_Rec;

	// First try to retrieve by the account passed in
	try {    
	    surcharge_Rec = [SELECT Id, 
	                            Account__c, 
	                            SAP_Plant__c, 
	                            Begin_Date__c, 
	                            End_Date__c 
	                       FROM Pricing_Surcharge__c
	                      WHERE Account__c = :accountId 
	                        AND SAP_Plant__c = :plantId 
	                    ];
	    } catch (Exception e) {}
	    
	//if nothing was retrieved, look up Sold To Account and try again
	if (surcharge_Rec.size() == 0)
		{
		Id SoldToId;
		
		SoldToId = Account_Partner_Functions.getSoldToId(accountId);
		System.debug('SoldToId = ' + SoldToId);
		
		try {    
		    surcharge_Rec = [SELECT Id, 
		                            Account__c, 
		                            SAP_Plant__c, 
		                            Begin_Date__c, 
		                            End_Date__c 
		                       FROM Pricing_Surcharge__c
		                      WHERE Account__c = :SoldToId 
		                        AND SAP_Plant__c = :plantId 
		                    ];
		    } catch (Exception e) {}
		}	     

	if (surcharge_Rec.size() > 0)
		{
		String surchargeId = surcharge_Rec[0].Id;
			
		try {
			//Retrieve the Breaks for the surcharge_Rec
			results = [SELECT Id, Pricing_Surcharge__c,
			                  Scale_Qty__c, 
			                  Scale_UOM_Code__c, 
			                  Scale_UOM_Description__c, 
			                  Scale_UOM_Id__c, 
			                  Amount__c, 
			                  CurrencyISOCode, 
			                  Per__c, 
			                  Price_UOM_Code__c, 
			                  Price_UOM_Description__c, 
			                  Price_UOM_Id__c 
			             FROM Pricing_Surcharge_Break__c
			            WHERE Pricing_Surcharge__c = :surchargeId
			            ORDER BY Scale_Qty__c
			          ];
			} catch (Exception e) {}
		}	     
    
    //if nothing was retrieved from a Sold To, or Sold To didn't exist, return an empty list.
    if (results == null)
    	{
    	results = new List<Pricing_Surcharge_Break__c>();
    	}
    
    return results;                                                        
  }

}
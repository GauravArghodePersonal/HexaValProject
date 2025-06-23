global with sharing class Price_Book_Functions 
{
    
    public static final String ACTIVE = 'Active';
    public static final Set<String> ACTIVE_RECS = new Set<String>{ACTIVE};

  webservice static Boolean submitPriceBookforApproval(Id pbId) 
  {
        
    //Create an approval request for the price book
    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
    req.setComments('Submitting Price Book for Approval.');
    req.setObjectId(pbId);
    
    //Submit the approval request for the price book
    Approval.ProcessResult result = Approval.process(req);  
    
    return result.isSuccess();                                                        
  }
  
  
  webservice Static List<SAP_Customer_Group__c> getPACIndustrySegments () {
        /*
        List<String> PACCodes = new List<String>();
        PACCodes.add('50');
        PACCodes.add('51');
        PACCodes.add('52');
        PACCodes.add('53');
        PACCodes.add('54');
        //PACCodes.add('55');
        PACCodes.add('56');
        PACCodes.add('57');
        PACCodes.add('58');
        PACCodes.add('59');
        */
        String dc = SAP_Queries_Functions.DIST_CHAN_AAFI;
        
        Set<String> cgs = SAP_Queries_Functions.CUST_GROUP_CODES.get(dc);
      
        List<SAP_Customer_Group__c> plist = new List<SAP_Customer_Group__c>();
        for (SAP_Customer_Group__c p : [SELECT Id,Customer_Group_Code__c,Customer_Group_Name__c 
                                          FROM SAP_Customer_Group__c 
                                         WHERE Customer_Group_Code__c IN :cgs
                                      ORDER BY Customer_Group_Name__c]) {
            plist.add(p);
        }
        return plist;
      
  }
  
  webservice Static List<SAP_Payment_Term_Explanation__c> getPaymentTermExplanations() {
        List<SAP_Payment_Term_Explanation__c> plist = new List<SAP_Payment_Term_Explanation__c>();
        for (SAP_Payment_Term_Explanation__c p : [SELECT Payment_Term_Explanation__c, Payment_Term_Code__c 
                                                    FROM SAP_Payment_Term_Explanation__c
                                                 ]) {
            plist.add(p);
        }
        return plist;
  }

  webservice static List<Id> getPriceBooksIdsForCustomer(Id accId)
  {
    
    List<Price_Book__c> priceBooks = getPriceBooksForCustomer(accId, false);

    List<Id> priceBookIds = new List<Id>();

    if (priceBooks != null && priceBooks.size() > 0) { 
        for (Price_Book__c pb : priceBooks) {
            priceBookIds.add(pb.Id);
        }
    }

    System.debug('Price Book Ids Found for ' + accId + ' : ' + priceBookIds);
       
    return priceBookIds;
  }

 webservice static List<DistributorEndUseCustomer__c> getEndUseCustomers (Id DistributionId)
 {
     List<DistributorEndUseCustomer__c> endUseCustomers = new List<DistributorEndUseCustomer__c>();
     endUseCustomers = [SELECT Id, 
                               End_Use_Customer__c, 
                               Distribution_Channel__c, 
                               Distributor_Sold_To__c, 
                               Division__c, 
                               End_Use_Customer_Account_Name__c, 
                               End_Use_Customer_Account_Number__c, 
                               End_Use_Customer_Country__c, 
                               Sales_Org__c 
                          FROM DistributorEndUseCustomer__c 
                         WHERE Distributor_Sold_To__c = :DistributionId];
     return endUseCustomers;
 }   

/*
  webservice static List<Id> getPriceBooksForCustomerProductLine(Id accId, String productLineCode) {
    List<Price_Book__c> priceBooks = getPriceBooksForCustomer(accId, false);
    List<Id> priceBookIds = new List<Id>();
    if (priceBooks != null && priceBooks.size() > 0) { 
        for (Price_Book__c pb : priceBooks) {
            if (pb.Product_Segment_Code__c == productLineCode) {
                priceBookIds.add(pb.Id);
            }
        }
    }
    return priceBookIds;
  }
*/  
    
  webservice static List<Price_Book__c> getPriceBooks(String salesOrgIds,
                                                      String distChanId,
                                                      String divisionId,
                                                      String prodLineCodes,
                                                      String familyCodes,
                                                      String regionIds, 
                                                      String custGroupIds,
                                                      String vcpGrade,
                                                       Boolean exactMatch) {
                                                     system.debug('vcpGrade :: '+vcpGrade);
    return PriceBookFunctions.getPriceBooks(salesOrgIds,
                                            distChanId,
                                            divisionId,
                                            prodLineCodes,
                                            familyCodes,
                                            regionIds,
                                            custGroupIds,
                                            vcpGrade,
                                             exactMatch);                                                   
                                             

  }
    
//------------------------------------------------------------------------------------------
    
    public static List<Price_Book__c> getPriceBooksForCustomer(Id accId, Boolean includeChild) {
    
        List<Id> salesOrgIds = new List<Id>();
        List<Id> distChannelIds = new List<Id>();
        List<Id> divIds = new List<Id>();
        List<Id> regIds = new List<Id>();
        List<Id> custGroupIds = new List<Id>();
        List<Id> vcpgrade = new List<Id>();
        set<string> Valvcpgrade = new set<string>();
        
        for(Account acc : [Select Name, SAP_Sales_Org__c, 
                                  SAP_DistChannel__c, SAP_DivisionCode__c, 
                                  SAP_Country__c, SAP_Customer_Group__c ,SAP_Customer_Price_Group_Desc__c
                             from Account 
                            where Id =: accId]) {

            for(SAP_Sales_Org__c sapSalesOrg : [Select Id 
                                                  from SAP_Sales_Org__c 
                                                 where Sales_Org_Code__c =: acc.SAP_Sales_Org__c]) {
                salesOrgIds.add(sapSalesOrg.Id);
            }
                        
            for(SAP_Distribution_Channel__c sapDistChannel : [Select Id 
                                                                from SAP_Distribution_Channel__c 
                                                               where Distribution_Channel_Code__c =: acc.SAP_DistChannel__c]) {
                distChannelIds.add(sapDistChannel.Id);
            }
        
            for(SAP_Sales_Division__c sapSalesDiv : [Select Id 
                                                       from SAP_Sales_Division__c 
                                                      where Sales_Division_Code__c =: acc.SAP_DivisionCode__c]) {
                divIds.add(sapSalesDiv.Id);
            }
        
            for(SAP_Country_Name__c sapRegion : [Select Id 
                                                   from SAP_Country_Name__c 
                                                  where Country_Code__c =: acc.SAP_Country__c]) {
                regIds.add(sapRegion.Id);
            }
        
            for(SAP_Customer_Group__c sapCustGroup : [Select Id 
                                                        from SAP_Customer_Group__c 
                                                       where Customer_Group_Code__c =: acc.SAP_Customer_Group__c]) {
                custGroupIds.add(sapCustGroup.Id);
            }
           
           for(Price_Book__c pricebookGroup : [Select Id,VCP_Grade__c
                                                        from Price_Book__c
                                                       where  VCP_Grade__c =: acc.SAP_Customer_Price_Group_Desc__c]) {
                vcpgrade.add(pricebookGroup.Id);
                Valvcpgrade.add(pricebookGroup.VCP_Grade__c );
                system.debug('custGroupIds'+  vcpgrade);
            }
            
            
        }
        
        if(includeChild == True) {
            getSalesAreaIdsForChildAccounts(accId, salesOrgIds, distChannelIds, divIds, regIds, custGroupIds);
        }
    
        //System.debug('custGroupIds = ' + custGroupIds);
        //System.debug('regIds = ' + regIds);
        //System.debug('salesOrgIds = ' + salesOrgIds);
        //System.debug('distChannelIds = ' + distChannelIds);
        //System.debug('divIds = ' + divIds);
       // System.debug('custGroupIds1 = ' + custGroupIds1);
    
        Set<Id> pbIdsForCustGroups = PriceBookCustGroupFunctions.getPriceBookIdsForCustGroups(custGroupIds);
        Set<Id> pbIdsForRegions = PriceBookRegionFunctions.getPriceBookIdsForRegions(regIds);
        Set<Id> pbIdsForSalesOrgs = PriceBookSalesOrgFunctions.getPriceBookIdsForSalesOrgs(salesOrgIds);
        //Set<Id> pbIdsForvcpgrade = PriceBookvcpFunctions.getPriceBookIdsForvcpgrades(vcpgrade);

        //System.debug('pbIdsForCustGroups = ' + pbIdsForCustGroups);
        //System.debug('pbIdsForRegions = ' + pbIdsForRegions);
        //System.debug('pbIdsForSalesOrgs = ' + pbIdsForSalesOrgs);
        
        
        String qry = PriceBookFunctions.SELECT_QRY_1 + 
                     ' where Record_Status__c IN :ACTIVE_RECS ' +
                     '   AND VCP_GRADE__c IN : Valvcpgrade' +
                     '   AND Dist_Channel__c IN: distChannelIds ' +
                     '   AND Id IN :pbIdsForCustGroups ' +
                     '   AND Id IN :pbIdsForRegions ' +
                     '   AND Id IN :pbIdsForSalesOrgs ';
                             
                             
 // 
// Removed per request from Matthew - 2013-03-28                            
//                     '   AND Division__c IN: divIds ' +
                                 
        List<Price_Book__c> priceBooks = Database.query(qry);
    
        if (priceBooks.size() > 0) {
            return priceBooks; 
        }
       
        return null;
    }
    
    private static void getSalesAreaIdsForChildAccounts(Id accId, 
                                                        List<Id> salesOrgIds,
                                                        List<Id> distChannelIds,
                                                        List<Id> divIds,
                                                        List<Id> regIds,
                                                        List<Id> custGroupIds) {
        List<String> salesOrgCode = new List<String>();
        List<String> distChannelCode = new List<String>();
        List<String> divCode = new List<String>();
        List<String> regCode = new List<String>();
        List<String> custGroupCode = new List<String>();
        //List<String> vcpgrade= new List<String>();

        for(Account childAcc : [Select Name, SAP_Sales_Org__c, 
                                       SAP_DistChannel__c, SAP_DivisionCode__c, 
                                       Country_Code__c, SAP_Customer_Group__c ,SAP_Customer_Price_Group_Desc__c
                                  from Account 
                                 where ParentId =: accId]) {
            salesOrgCode.add(childAcc.SAP_Sales_Org__c);
            distChannelCode.add(childAcc.SAP_DistChannel__c);
            divCode.add(childAcc.SAP_DivisionCode__c);
            regCode.add(childAcc.Country_Code__c);
            custGroupCode.add(childAcc.SAP_Customer_Group__c); 
            //vcpgrade.add(childAcc.SAP_Customer_Price_Group_Desc__c); 
        }
            
        for(SAP_Sales_Org__c sapSalesOrg : [Select Id 
                                              from SAP_Sales_Org__c 
                                             where Sales_Org_Code__c IN: salesOrgCode]) {
            salesOrgIds.add(sapSalesOrg.Id);
        }
                    
        for(SAP_Distribution_Channel__c sapDistChannel : [Select Id 
                                                            from SAP_Distribution_Channel__c 
                                                           where Distribution_Channel_Code__c IN: distChannelCode]) {
            distChannelIds.add(sapDistChannel.Id);
        }
    
        for(SAP_Sales_Division__c sapSalesDiv : [Select Id 
                                                   from SAP_Sales_Division__c 
                                                  where Sales_Division_Code__c IN: divCode]) {
            divIds.add(sapSalesDiv.Id);
        }
    
        for(SAP_Country_Name__c sapRegion : [Select Id 
                                               from SAP_Country_Name__c 
                                              where Country_Code__c IN: regCode]) {
            regIds.add(sapRegion.Id);
        }
    
        for(SAP_Customer_Group__c sapCustGroup : [Select Id 
                                                    from SAP_Customer_Group__c 
                                                   where Customer_Group_Code__c IN: custGroupCode]) {
            custGroupIds.add(sapCustGroup.Id);
        }
        /*for(Price_Book__c pricebookGroup : [Select Id 
                                                        from Price_Book__c
                                                       where VCP_Grade__c =:'GRADE A' AND VCP_Grade__c IN :vcpgrade]) {
                custGroupIds.add(pricebookGroup.Id);
            }*/
    }

/*
 **********************************************************
 Test Methods are in Price_Book_Functions_Test class
 ********************************************************** 
 */    

}
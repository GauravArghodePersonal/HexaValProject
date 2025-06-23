global with sharing class PricingWebServices {


    /*
    PricingWebServices.retrievePricingWizardSettings(); 
    */

    Webservice static Account_Relationship_Tree_Functions.AccountTreeData getRelatedAccounts(Id accountId) {
        
        /* Test Call Code
            Account_Relationship_Tree_Functions.AccountTreeData accountTreeData = PricingWebServices.getRelatedAccounts('0015000000SivTQAAZ');
            System.debug('*** accountTreeData - topLevelId = ' + accountTreeData.topLevelId);
            System.debug('*** accountTreeData - HQAccountId = ' + accountTreeData.HQAccountId);
            for (Account account : accountTreeData.accountDetails) {
                System.debug('*** accountTreeData - Account = ' + account.Id + ' - ' + account.Name);
            }       
        */
        
        return Account_Relationship_Tree_Functions.getRelatedAccountsV2(accountId);
    }

    Webservice static PricingWizardSettings.Settings retrievePricingWizardSettings() {
        return PricingWizardSettings.retrieveSettings();
    } 
 
    webservice static List<SAP_Customer_Group__c> getPACIndustrySegments(String marketPriceBookId) {
        List<SAP_Customer_Group__c> results = new List<SAP_Customer_Group__c>();
        
        if (marketPriceBookId == '') {
            results = Price_Book_Functions.getPACIndustrySegments();
        }
        else {
            List<Market_Price_Book_PAC_Industry_Segment__c> MPB_PAC_Records = retrievePACIndustrySegmentsForMarketPriceBook(marketPriceBookId);
            
            List<Id> validSAPCustomerGroupIds = new List<Id>();
            
            for (Market_Price_Book_PAC_Industry_Segment__c MPB_PAC_Record:MPB_PAC_Records) {
                validSAPCustomerGroupIds.add(MPB_PAC_Record.PAC_Industry_Segment__c);   
            }   
            
            results = [SELECT Id,Customer_Group_Code__c,Customer_Group_Name__c 
                         FROM SAP_Customer_Group__c 
                        WHERE Id IN :validSAPCustomerGroupIds
                     ORDER BY Customer_Group_Name__c];
        }       
        
        return results;     
    }

    Webservice static Integer retrievePricingConditionsforMPBECount(Id marketPriceBookEntryId) {
        Integer result;
        
        try {
            result = [
                      SELECT COUNT() 
                        FROM Pricing_Condition__c 
                       WHERE Market_Price_Book_Entry__c = :marketPriceBookEntryId
                     ];
        } catch (Exception e) {
            result = 0;
        }
        
        return result;
    }
 
    Webservice static List<Pricing_Condition__c> retrievePricingConditionsforMPBE(Id marketPriceBookEntryId) {
        List<Pricing_Condition__c> results;
        
        try {
            results = [
                       SELECT Id,
                              Account__c,
                              Market_Price_Book_Entry__c,
                              Market_Price_Book_Entry__r.Market_Price_Book__c,
                              Record_Status__c          
                         FROM Pricing_Condition__c 
                        WHERE Market_Price_Book_Entry__c = :marketPriceBookEntryId
                       ];
        } catch (Exception e) {
            results = new List<Pricing_Condition__c>();
        }
        
        return results;
    }
 
    Webservice static List<Pricing_Condition__c> retrieveActivePricingConditionsforAccountandMPB(Id accountId, Id marketPriceBookId) {
        List<Pricing_Condition__c> results = new List<Pricing_Condition__c>();
        
        List<Pricing_Condition__c> records = [SELECT Id,
                                                     Account__c,
                                                     Market_Price_Book_Entry__c,
                                                     Market_Price_Book_Entry__r.Market_Price_Book__c,
                                                     Record_Status__c
                                                FROM Pricing_Condition__c
                                               WHERE Account__c = :accountId
                                                 AND (Record_Status__c = 'Active'
                                                      OR
                                                      Record_Status__c = 'In Approval Process')
                                             ];

        for (Pricing_Condition__c record : records) {
            if (record.Market_Price_Book_Entry__r.Market_Price_Book__c == marketPriceBookId) {
                results.add(record);
            }
        }
        
        //TEST - Force a record to be returned
        /*
        if (results.size() == 0) {
            results = [SELECT Id,
                              Account__c,
                              Market_Price_Book_Entry__c,
                              Market_Price_Book_Entry__r.Market_Price_Book__c,
                              Record_Status__c
                         FROM Pricing_Condition__c 
                        LIMIT 1
                      ];
        }
        */
        
        return results;
    }

    Webservice static List<Pricing_Condition__c> retrieveActivePricingConditionsforAccountandMPBandMaterial(Id accountId, Id marketPriceBookId, Id materialSalesData2Id) {
        List<Pricing_Condition__c> results = new List<Pricing_Condition__c>();
        
        List<Pricing_Condition__c> records = [SELECT Id,
                                                     Account__c,
                                                     Market_Price_Book_Entry__c,
                                                     Market_Price_Book_Entry__r.Market_Price_Book__c,
                                                     Record_Status__c
                                                FROM Pricing_Condition__c
                                               WHERE Account__c = :accountId
                                                 AND (Record_Status__c = 'Active'
                                                      OR
                                                      Record_Status__c = 'In Approval Process')
                                                 AND  Material2__c = :materialSalesData2Id
                                             ];

        for (Pricing_Condition__c record : records) {
            if (record.Market_Price_Book_Entry__r.Market_Price_Book__c == marketPriceBookId) {
                results.add(record);
            }
        }
        
        //TEST - Force a record to be returned
        /*
        if (results.size() == 0) {
            results = [SELECT Id,
                              Account__c,
                              Market_Price_Book_Entry__c,
                              Market_Price_Book_Entry__r.Market_Price_Book__c,
                              Record_Status__c
                         FROM Pricing_Condition__c 
                        LIMIT 1
                      ];
        }
        */
        
        return results;
    }

    Webservice static List<Pricing_Condition__c> retrieveActivePricingConditionsforAccountandMaterial(Id accountId, Id materialSalesData2Id) {
        List<Pricing_Condition__c> results = new List<Pricing_Condition__c>();
        
        List<Pricing_Condition__c> records = [SELECT Id,
                                                     Account__c,
                                                     Market_Price_Book_Entry__c,
                                                     Market_Price_Book_Entry__r.Market_Price_Book__c,
                                                     Record_Status__c
                                                FROM Pricing_Condition__c
                                               WHERE Account__c = :accountId
                                                 AND (Record_Status__c = 'Active'
                                                      OR
                                                      Record_Status__c = 'In Approval Process')
                                                 AND  Material2__c = :materialSalesData2Id
                                             ];

        for (Pricing_Condition__c record : records) {
            results.add(record);
        }
        
        //TEST - Force a record to be returned
        /*
        if (results.size() == 0) {
            results = [SELECT Id,
                              Account__c,
                              Market_Price_Book_Entry__c,
                              Market_Price_Book_Entry__r.Market_Price_Book__c,
                              Record_Status__c
                         FROM Pricing_Condition__c 
                        LIMIT 1
                      ];
        }
        */
        
        return results;
    }

    Webservice static Boolean newAssociatedPricingConditionCanBeCreated(String currentPCNId, String accountId, String materialSalesData2Id, String marketPriceBookId) {
        Boolean result = true;
        
        System.debug('currentPCNId = ' + currentPCNId);
        System.debug('accountId = ' + accountId);
        System.debug('materialSalesData2Id = ' + materialSalesData2Id);
        System.debug('marketPriceBookId = ' + marketPriceBookId);
        
        List<Pricing_Condition__c> records = [SELECT Id,
                                                     Account__c,
                                                     Market_Pricing_Type__c,
                                                     Market_Price_Book_Entry__c,
                                                     Market_Price_Book_Entry__r.Market_Price_Book__c,
                                                     Record_Status__c
                                                FROM Pricing_Condition__c
                                               WHERE Account__c = :accountId
                                                 AND (Record_Status__c = 'Active'
                                                      OR
                                                      Record_Status__c = 'In Approval Process')
                                                 AND  Material2__c = :materialSalesData2Id
                                             ];

        for (Pricing_Condition__c record : records) {
            if ((String.isEmpty(currentPCNId)) || (record.Id != currentPCNId)) {
                if (record.Market_Pricing_Type__c == 'hardWired' || record.Market_Pricing_Type__c == 'softWired') {
                    result = false;
                    break;
                }
            }
        }

        System.debug('result = ' + result);
        
        return result;
    }

    Webservice static List<Pricing_Condition__c> retrieveActivePricingConditionsforAccountandMPBE(Id accountId, Id marketPriceBookEntryId) {
        List<Pricing_Condition__c> results = new List<Pricing_Condition__c>();
        
        results = [SELECT Id,
                          Account__c,
                          Market_Price_Book_Entry__c,
                          Market_Price_Book_Entry__r.Market_Price_Book__c,
                          Record_Status__c
                     FROM Pricing_Condition__c
                    WHERE Account__c = :accountId
                      AND Market_Price_Book_Entry__c = :marketPriceBookEntryId
                      AND (Record_Status__c = 'Active'
                           OR
                           Record_Status__c = 'In Approval Process')
        ];

        //TEST - Force a record to be returned
        /*
        if (results.size() == 0) {
            results = [SELECT Id,
                              Account__c,
                              Market_Price_Book_Entry__c,
                              Market_Price_Book_Entry__r.Market_Price_Book__c,
                              Record_Status__c
                         FROM Pricing_Condition__c 
                        LIMIT 1
                      ];
        }
        */

        return results;
    }

    Webservice static List<Pricing_Condition__c> retrieveActivePricingConditionsforAccountandMPBEs(Id accountId, List<Id> marketPriceBookEntryIds) {
        List<Pricing_Condition__c> results = new List<Pricing_Condition__c>();
        
        results = [SELECT Id,
                          Account__c,
                          Market_Price_Book_Entry__c,
                          Market_Price_Book_Entry__r.Market_Price_Book__c,
                          Record_Status__c
                     FROM Pricing_Condition__c
                    WHERE Account__c = :accountId
                      AND Market_Price_Book_Entry__c IN :marketPriceBookEntryIds
                      AND (Record_Status__c = 'Active'
                           OR
                           Record_Status__c = 'In Approval Process')
        ];

        //TEST - Force a record to be returned
        /*
        if (results.size() == 0) {
            results = [SELECT Id,
                              Account__c,
                              Market_Price_Book_Entry__c,
                              Market_Price_Book_Entry__r.Market_Price_Book__c,
                              Record_Status__c
                         FROM Pricing_Condition__c 
                        WHERE Market_Price_Book_Entry__c != ''
                        LIMIT 1
                      ];
        }
        */

        return results;
    }
 
 
    Webservice static List<Account_To_Market_Price_Book_Entry__c> getRelatedMarketPricingDetailsforAccountId(id accountId) {
        List<Account_To_Market_Price_Book_Entry__c> results;
         
        try {
            results = [SELECT Id, 
                              Account__c, 
                              Available_Market_Pricing_Types__c,
                              Market_Price_Book_Entry__c, 
                              Market_Price_Book_Entry__r.Market_Price_Book__c, 
                              Market_Price_Book_Entry__r.Market_Price_Book__r.Description__c, 
                              Market_Price_Book_Entry__r.Market_Price_Book__r.IncoTerm_Key__c, 
                              Market_Price_Book_Entry__r.Material_Sales_Data2__c, 
                              Market_Price_Book_Entry__r.Material_Sales_Data2__r.Name
                         FROM Account_To_Market_Price_Book_Entry__c 
                        WHERE Account__c = :accountId
                      ];
        } catch (Exception e) {results = new List<Account_To_Market_Price_Book_Entry__c>();}
                  
        System.debug('Results = ' + results);
                      
        return results;                                                        
    }


      Webservice static List<Market_Price_Book_PAC_Industry_Segment__c> retrievePACIndustrySegmentsForMarketPriceBook(Id marketPriceBookId) {
        List<Market_Price_Book_PAC_Industry_Segment__c> results;
        results = [SELECT Id,
                          Market_Price_Book__c,
                          PAC_Industry_Segment__c,
                          PAC_Industry_Segment_Code__c,
                          PAC_Industry_Segment_Desc__c
                     FROM Market_Price_Book_PAC_Industry_Segment__c
                    WHERE Market_Price_Book__c = :marketPriceBookId
                  ];
        return results;                                                        
      }



    Webservice static Market_Price_Book_Entry__c retrieveMarketPricingEntryforAccountMaterial(id accountId, id materialId) {
        Market_Price_Book_Entry__c result;
         
        try {
            Account_To_Market_Price_Book_Entry__c relatedRec = [SELECT Market_Price_Book_Entry__c 
                                                                  FROM Account_To_Market_Price_Book_Entry__c
                                                                 WHERE Account__c = :accountId
                                                                   AND Market_Price_Book_Entry__r.Material_Sales_Data2__r.Id = :materialId
                                                               ];
            
            result = retrieveMarketPricingEntryforId(relatedRec.Market_Price_Book_Entry__c);
        } catch (Exception e) {}
                  
        System.debug('Result = ' + result);
                      
        return result;                                                        
    }

    Webservice static Market_Price_Book_Entry__c retrieveMarketPricingEntryforId(id marketPricingEntryId) {
        Market_Price_Book_Entry__c result;
         
        try {
            result = [SELECT Id, 
                             Name,
                             Active__c, 
                             Cloned_From__c,
                             CurrencyIsoCode, 
                             Record_Status__c,
                             Selling_UOM__c,
                             Volume_UOM__c,
                             Uses_Scaled_Pricing__c,
                             Valid_To_Date__c,
                             Valid_From_Date__c,
                             Market_Price_Book__c, 
                             Market_Price_Book__r.Description__c, 
                             Market_Price_Book__r.Name, 
                             Market_Price_Book__r.Manually_Defined_Segmentation_Key__c,
                             Market_Price_Book__r.IncoTerm_Key__c, 
                             Material_Sales_Data2__c, 
                             Material_Sales_Data2__r.Name, 
                             Material_Sales_Data2__r.Sales_Org_Code__c,
                             Material_Sales_Data2__r.SalesOrg_Desc__c,
                             Material_Sales_Data2__r.Dist_Channel_Code__c,
                             Material_Sales_Data2__r.Material_Number__c,
                             Material_Sales_Data2__r.Material_Desc__c,
                             Material_Sales_Data2__r.Sales_UOM_Desc__c,
                             Material_Sales_Data2__r.Net_Weight__c,
                             Material_Sales_Data2__r.Net_Weight_in_LBs__c,
                             Material_Sales_Data2__r.Deletion_Flag__c,
                             Material_Sales_Data2__r.Product_Hierarchy__r.PH1_Division__c,
                             Material_Sales_Data2__r.Product_Hierarchy__r.PH2_Line__c,
                             Material_Sales_Data2__r.Product_Hierarchy__r.PH3_Group__c,
                             Material_Sales_Data2__r.Product_Hierarchy__r.PH4_Supplier__c,
                             Material_Sales_Data2__r.Product_Hierarchy__r.PH5_Family__c,
                             Material_Sales_Data2__r.Product_Hierarchy__r.PH6_Segment__c,
                             Material_Sales_Data2__r.Product_Hierarchy__r.PH7_SubSegment__c,
                             Material_Sales_Data2__r.Material_General_Data__r.Material_Base_Code_Desc__c,
                             Material_Sales_Data2__r.Material_General_Data__r.Base_UOM_Desc__c,
                             Material_Sales_Data2__r.Material_General_Data__r.Base_UOM__c,
                             Material_Sales_Data2__r.Material_General_Data__r.Material_Container_Desc__c,
                             Material_Sales_Data2__r.Material_General_Data__r.Material_Group_Desc__c,
                             Material_Sales_Data2__r.Material_General_Data__r.Material_Type_Desc__c,
                             Material_Sales_Data2__r.Material_General_Data__r.Marked_for_deletion__c,
                             (SELECT Id, 
                                     Cloned_From__c,
                                     Floor_Price__c,
                                     Market_Price_Book_Entry__c,
                                     Minimum_Volume__c,
                                     Maximum_Volume__c,
                                     Selling_Price__c,
                                     Surcharge__c,
                                     Quantity_Surcharge__c
                                FROM Market_Price_Book_Scaled_Pricing_Entries__r
                              ORDER BY Minimum_Volume__c
                             )
                        FROM Market_Price_Book_Entry__c 
                       WHERE Id = :marketPricingEntryId
                    ];
        } catch (Exception e) {}
                  
        System.debug('Result = ' + result);
                      
        return result;                                                        
    }

/***********************************************************
 * Services for Market Price Maintenance Batch Jobs
 ***********************************************************/

    public static void updatePricingConditionswithMarketPricingforMarketPriceEntry(Id mpeId) {
        
    }
    
    public static void updatePricingConditionfromMarketPriceBookEntry(Id pcId, Id mpeId) {
    
        //Market_Price_Book_Entry__c mpbe = [SELECT ]   
        
        
//      List<Market_Price_Book_Scaled_Pricing_Entry__c> mpeScaledPricingList = [SELECT Market_Price_Book_Entry__c, Minimum_Volume__c, Maximum_Volume__c, Floor_Price__c, Selling_Price__c, Surcharge__c, CurrencyISOCode 
//                                                                            FROM Market_Price_Book_Scaled_Pricing_Entry__c
//                                                                           WHERE  Market_Price_Book_Entry__c = :mpeId
//                                                                          ORDER BY Minimum_Volume__c];
//                                                                    
//      List<Pricing_Condition_Scaled_Pricing__c> oldScaledPricing = [SELECT Id FROM Pricing_Condition_Scaled_Pricing__c WHERE Pricing_Condition__c = :pcId];
//      
//      delete oldScaledPricing;
//      
//      List<Pricing_Condition_Scaled_Pricing__c> newScaledPricingList = new List<Pricing_Condition_Scaled_Pricing__c>();
//      
//      for (Market_Price_Book_Scaled_Pricing_Entry__c mpeScaledPricing : mpeScaledPricingList) {
//          Pricing_Condition_Scaled_Pricing__c newScaledPricing = new Pricing_Condition_Scaled_Pricing__c();
//          newScaledPricing.Pricing_Condition__c = pcId;
//          newScaledPricing.Minimum_Volume__c = mpeScaledPricing.Minimum_Volume__c;
//          newScaledPricing.Maximum_Volume__c = mpeScaledPricing.Maximum_Volume__c;
//          newScaledPricing.Selling_Price__c = mpeScaledPricing.Selling_Price__c;
//          newScaledPricing.Surcharge__c = mpeScaledPricing.Surcharge__c;
//          newScaledPricing.CurrencyISOCode = mpeScaledPricing.CurrencyISOCode;
//          
//          newScaledPricingList.add(newScaledPricing);
//      }
//       
//      //handle adjustments
//      
//      //handle currency diff
//                
//      insert newScaledPricingList;                                                    
    }

/*
    private static void cloneAndSubmitForApproval(Pricing_Condition__c p,
                                                  Double priceIncreaseAmount,
                                                  Double priceIncreasePercnt, 
                                                  Date effectFromDate,
                                                  Date effectToDate,
                                                  Boolean submitForApproval) {
        List<Pricing_Condition__c> plist = new List<Pricing_Condition__c>();
        plist.add(p);
        cloneAndSubmitForApproval(plist,priceIncreaseAmount,priceIncreasePercnt,effectFromDate,effectToDate,submitForApproval);
   }    
    
    private static void cloneAndSubmitForApproval(List<Pricing_Condition__c> plist,
                                                  Double priceIncreaseAmount,
                                                  Double priceIncreasePercnt, 
                                                  Date effectFromDate,
                                                  Date effectToDate,
                                                  Boolean submitForApproval) {
        PricingConditionUpdateFunctions.cloneAndSubmitForApproval(plist,priceIncreaseAmount,priceIncreasePercnt,effectFromDate,effectToDate,submitForApproval);
   }
*/

/***********************
 * LISD Wrapper Methods
 ***********************/

    Webservice static List<SAP_Line_Item_Sales_Detail__c> getAccountLisds(Id accountId) {
        List<SAP_Line_Item_Sales_Detail__c> results;
        try {
            Account acc = [SELECT Id, OwnerId FROM Account WHERE Id = :accountId];
            results = SAP_LISD_Functions.getAccountLisds(acc);
        }
        catch (Exception e) {
            results = new List<SAP_Line_Item_Sales_Detail__c>();    
        }
        return results;
    }
    
    global class LISDData {
        webservice Account account;
        webservice List<LISDDataItem> industries = new List<LISDDataItem>();
        webservice List<LISDDataItem> endUseCusts = new List<LISDDataItem>();
        webservice List<LISDDataItem> salesDsts = new List<LISDDataItem>();
        webservice List<LISDDataItem> salesOfcs = new List<LISDDataItem>();
        webservice List<LISDDataItem> salesGrps = new List<LISDDataItem>();
        webservice List<LISDDataItem> custGroups = new List<LISDDataItem>();
        webservice User seller;
        
        webservice String accountId;
        webservice String industryValue; 
        webservice String industryDesc; 
        webservice String endUseCustId; 
        webservice String endUseCustValue; 
        webservice String endUseCustDesc; 
        webservice String salesDstValue; 
        webservice String salesDstDesc; 
        webservice String salesOfcValue; 
        webservice String salesOfcDesc; 
        webservice String salesGrpValue; 
        webservice String salesGrpDesc; 
        webservice String custGroupValue;
        webservice String custGroupDesc;
        
        webservice Boolean industryLocked = true;
        webservice Boolean endUseCustLocked = true;
        webservice Boolean salesDstLocked = true;
        webservice Boolean salesOfcLocked = true;
        webservice Boolean salesGrpLocked = true;
        webservice Boolean custGroupLocked = true;
        
        webservice String focusPreference = 'n/a';
        
        webservice Boolean sellerIdentified = false;
    }
    
    global class LISDDataItem {
        webservice String label;
        webservice String value;
    }
    
    Webservice static LISDData getLISDData(String accountId,
                                   String industryValue, 
                                   String endUseCustValue, 
                                   String salesDstValue, 
                                   String salesOfcValue, 
                                   String salesGrpValue, 
                                   String custGroupValue
                                  ) {
        LISDData result = new PricingWebServices.LISDData();                                 

        List<SelectOption> industries;
        List<SelectOption> endUseCusts;
        List<SelectOption> salesDsts;
        List<SelectOption> salesOfcs;
        List<SelectOption> salesGrps;
        List<SelectOption> custGroups;
        User seller;
                     
        String endUseCustId = ''; 

        String industryDesc = ''; 
        String endUseCustDesc = ''; 
        String salesDstDesc = ''; 
        String salesOfcDesc = ''; 
        String salesGrpDesc = ''; 
        String custGroupDesc = '';
 
                                    
        Account acc = SAP_LISD_Functions.getAccount(accountId);
        result.account = acc;                   

        List<SAP_LISD> sapLisds = SAP_LISD_Functions.getAccountLisds(acc.Id);
        Map<String,Id> lisdMap = SAP_LISD_Functions.getLisdMap(accountId);
        
        industries = SAP_LISD_Functions.getL1Segments(lisdMap, acc);
        result.industries = convertSelectOptionstoLISDDataItems(industries);                
        if (String.isEmpty(industryValue) && result.industries.size() == 1) {industryValue = result.industries[0].value;industryDesc = result.industries[0].label;}
        
        if (String.isNotEmpty(industryValue)) {
            //-*-*-*-*-*-*-*-*-*-*
            // Industry Processing
            //-*-*-*-*-*-*-*-*-*-*
            if (String.isEmpty(industryDesc)) {
                for (SelectOption industryOpt : industries) {
                    if (industryOpt.getValue() == industryValue) {
                        industryDesc = industryOpt.getLabel();
                        break;
                    }
                }
            }
                
            endUseCusts = SAP_LISD_Functions.getEndUseCusts(lisdMap, industryValue);
            result.endUseCusts = convertSelectOptionstoLISDDataItems(endUseCusts);  
            if (String.isEmpty(endUseCustValue) && result.endUseCusts.size() == 1) {
                endUseCustValue = result.endUseCusts[0].value;
                endUseCustDesc = result.endUseCusts[0].label;
                Account endUseCustAccount = SAP_LISD_Functions.getEndUseCust(endUseCustValue);
                if (endUseCustAccount != null) {
                    endUseCustId = endUseCustAccount.Id;
                    endUseCustDesc = endUseCustAccount.Name;
                }
            }
            
            if (String.isNotEmpty(endUseCustValue)) {
                //-*-*-*-*-*-*-*-*-*-*-*-*-*-*
                // End Use Customer Processing
                //-*-*-*-*-*-*-*-*-*-*-*-*-*-*
                salesDsts = SAP_LISD_Functions.getSalesDistricts(lisdMap, acc, industryValue, endUseCustValue);
                result.salesDsts = convertSelectOptionstoLISDDataItems(salesDsts);                  
                if (String.isEmpty(salesDstValue) && result.salesDsts.size() == 1) {salesDstValue = result.salesDsts[0].value;salesDstDesc = result.salesDsts[0].label;}                
                
                if (String.isNotEmpty(salesDstValue)) {
                    //-*-*-*-*-*-*-*-*-*-*-*-*-*
                    // Sales District Processing
                    //-*-*-*-*-*-*-*-*-*-*-*-*-*
                    salesOfcs = SAP_LISD_Functions.getSalesOffices(lisdMap, acc, industryValue, endUseCustValue, salesDstValue);
                    result.salesOfcs = convertSelectOptionstoLISDDataItems(salesOfcs);                  
                    if (String.isEmpty(salesOfcValue) && result.salesOfcs.size() == 1) {salesOfcValue = result.salesOfcs[0].value;salesOfcDesc = result.salesOfcs[0].label;}                

                    if (String.isNotEmpty(salesOfcValue)) {
                        //-*-*-*-*-*-*-*-*-*-*-*-*
                        // Sales Office Processing
                        //-*-*-*-*-*-*-*-*-*-*-*-*
                        salesGrps = SAP_LISD_Functions.getSalesGroups(lisdMap, acc, industryValue, endUseCustValue, salesDstValue, salesOfcValue);
                        result.salesGrps = convertSelectOptionstoLISDDataItems(salesGrps);                  
                        if (String.isEmpty(salesGrpValue) && result.salesGrps.size() == 1) {salesGrpValue = result.salesGrps[0].value;salesGrpDesc = result.salesGrps[0].label;}                
                        
                        if (String.isNotEmpty(salesGrpValue)) {
                            //-*-*-*-*-*-*-*-*-*-*-*-*
                            // Sales Group Processing
                            //-*-*-*-*-*-*-*-*-*-*-*-*
                            custGroups = SAP_LISD_Functions.getCustomerGroups(lisdMap, acc, industryValue, endUseCustValue, salesDstValue, salesOfcValue, salesGrpValue);
                            result.custGroups = convertSelectOptionstoLISDDataItems(custGroups);                
                            if (String.isEmpty(custGroupValue) && result.custGroups.size() == 1) {custGroupValue = result.custGroups[0].value;custGroupDesc = result.custGroups[0].label;}              
                                
                            if (String.isNotEmpty(custGroupValue)) {
                                //-*-*-*-*-*-*-*-*-*
                                // Seller Processing
                                //-*-*-*-*-*-*-*-*-*
                                seller = SAP_LISD_Functions.getSeller(sapLisds, acc, industryValue, endUseCustValue, salesDstValue, salesOfcValue, salesGrpValue, custGroupValue);
                                result.seller = seller;
                                result.sellerIdentified = true;                 
                            }
                        }
                    }
                }
            }
        }
        
        result.accountId = accountId;
        result.industryValue = industryValue;
        result.endUseCustValue = endUseCustValue;
        result.salesDstValue = salesDstValue;
        result.salesOfcValue = salesOfcValue;
        result.salesGrpValue = salesGrpValue;
        result.custGroupValue = custGroupValue;
      
        if (String.isNotEmpty(endUseCustValue)) {
            Account endUseCustAccount = SAP_LISD_Functions.getEndUseCust(endUseCustValue);
            if (endUseCustAccount != null) {
                endUseCustId = endUseCustAccount.Id;
                endUseCustDesc = endUseCustAccount.Name;
            }
        }
        
        if (IdMethods.isId(endUseCustId)) {
            result.endUseCustId = endUseCustId;
        }
        else {
            result.endUseCustId = '';
        } 

        result.industryDesc = industryDesc; 
        result.endUseCustDesc = endUseCustDesc; 
        result.salesDstDesc = salesDstDesc; 
        result.salesOfcDesc = salesOfcDesc; 
        result.salesGrpDesc = salesGrpDesc; 
        result.custGroupDesc = custGroupDesc;
        
        
        
        // Set the interface settings
        
        if (result.custGroups.size() > 1) {
            result.custGroupLocked = false;
            if (String.isEmpty(result.custGroupValue)) {
                result.focusPreference = 'custGroups';
            }
        }
        
        if (result.salesGrps.size() > 1) {
            result.salesGrpLocked = false;
            if (String.isEmpty(result.salesGrpValue)) {
                result.focusPreference = 'salesGrps';
            }
        }
        
        if (result.salesOfcs.size() > 1) {
            result.salesOfcLocked = false;
            if (String.isEmpty(result.salesOfcValue)) {
                result.focusPreference = 'salesOfcs';
            }
        }
        
        if (result.salesDsts.size() > 1) {
            result.salesDstLocked = false;
            if (String.isEmpty(result.salesDstValue)) {
                result.focusPreference = 'salesDsts';
            }
        }
        
        if (result.endUseCusts.size() > 1) {
            result.endUseCustLocked = false;
            if (String.isEmpty(result.endUseCustValue)) {
                result.focusPreference = 'endUseCusts';
            }
        }
        
        if (result.industries.size() > 1) {
            result.industryLocked = false;
            if (String.isEmpty(result.industryValue)) {
                result.focusPreference = 'industries';
            }
        }
        
        return result;              
    }
    
    private static List<LISDDataItem> convertSelectOptionstoLISDDataItems(List<SelectOption> items) {
        List<LISDDataItem> results = new List<LISDDataItem>();
        for (SelectOption item : items) {
            LISDDataItem newItem = new LISDDataItem();
            newItem.label = item.getLabel();
            newItem.value = item.getValue();  
            results.add(newItem);           
        }
        return results;
    }
 
}
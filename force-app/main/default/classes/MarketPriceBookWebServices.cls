global with sharing class MarketPriceBookWebServices {

  public static final Set<String> PB_STATS2 = MarketPriceBookMethods.PB_STATS2;

  public static final Set<String> SALES_ORG_CODE_FILTER = new Set<String>{
            '0310','0322','0330','0340','0390','0410','0430','0445','0460',
            '0481','0490','1021','1800','0869','0656','1031','1700','3580',
            '0432','0345','0463'
            };

  public static final Set<String> DIST_CHANNEL_CODE_FILTER = new Set<String>{
            '50'
            };

  public static final Set<String> DIVISION_CODE_FILTER = new Set<String>{
            '50'
            };

  public static final Set<String> PAC_INDUSTRY_SEGMENT_CODE_FILTER = new Set<String>{
            '50','21','51','52','53','54','56','57','58','59','5B','5G',
            '5H','5I','5J','5L'
            };

  public static final Set<String> FAMILY_CODE_FILTER = new Set<String>{
            '000','B59','B58','B62','B65','B66','B67','B70','B69','B06',
            'B63','C46','B64','B57','B60','B68','B61','B02','B04','B89',
            'B71','983','B61','D13','D14','D15','D16','D17','D18','D19',
            'D20','D21','D22','D23','D24','D25','D26','D27','D28'
            };

  public static final Set<String> COUNTRY_CODE_FILTER = new Set<String>{
            'AD','CG','UA','AE','AG','TZ','AO','GB','AL','AM','AN','RU',
            'RW','AR','NE','TJ','AT','ET','KW','NC','AU','AW','MM','AZ',
            'PH','QA','BA','BH','PR','ZW','BB','LB','BD','JE','LV','BE',
            'BY','IN','RO','VE','BG','NP','BI','CI','HR','BO','CO','SE',
            'BR','SV','BS','SY','FR','MX','CA','DM','GQ','HU','FJ','MU',
            'PF','CD','DE','CH','GW','KP','CL','PE','UY','VG','CM','ID',
            'MK','CN','SA','CR','SG','ES','GA','CY','PG','CZ','MW','DK',
            'DO','DZ','EG','EC','EE','FI','JO','FO','GE','IQ','KH','MY',
            'NI','IL','ME','SM','GH','GL','GT','GN','LK','LU','GR','KE',
            'PT','SJ','GU','HK','HN','HT','KM','IE','IO','IS','US','VU',
            'IT','JM','JP','KR','KS','MQ','TN','KZ','LC','UZ','LI','NL',
            'LT','SI','LY','PM','MA','MD','SB','ML','OM','MT','MV','TH',
            'NG','PK','NO','NZ','PA','PL','ZA','SR','PY','RS','SK','SN',
            'SZ','TR','TT','TW','VN','YE','UG','VI','YT','BL','MF','MN',
            'UM','AX','GG','BF','BN','BW','CI','CV','LR','LS','ST','TD',
            'TM','AI','BZ','GP','GY','VC','CC','FM','LA','TV'
            };

  public static final Set<String> SEGMENT_CODE_FILTER = new Set<String>{
            '000','767','770','771','772','774','789','790','779','818',
            '760','791','033','806','785','786','787','738','803','793',
            '811','839','840','799','802','794','804','769','773','782',
            '796','797','808','810','777','240','838','781','783','816',
            '762','763','764','765','820','766','792','775','776','778',
            '780','788','798','800','801','807','809','817','207','768',
            '784','795','813','814'
            };

  public static final Set<String> SUBSEGMENT_CODE_FILTER = new Set<String>{
            '000','E42','E47','E48','E77','E50','E45','E73','E67','E81',
            'E61','E32','500','190','249','305','685','C05','C94','E69',
            '091','D30','C93','274','999','D78','E75','F54','E68','E63',
            'E72','D16','D17','E46','E66','E49','E76','E70','E57','E71',
            'E79','E82','E33','E34','E35','E36','E37','E38','E39','E40',
            'F04','F10','F12','F50','F51','F52','E51','E52','E53','E54',
            '983','B61','D14','D15','D16','D17','D18','D19','D20','D21',
            'D22','D23','D24'
            };

  public static final Set<String> INCOTERM_FILTER = new Set<String>{
            'ZD1','ZD4','ZO1','ZO2','ZO3','EXW','FCA','CPT','CIP','DAP','DAT',
            'DDP','FAS','FOB','CFR','CIF'
            };

  public static final Set<String> CUSTOMER_GROUP_1_FILTER = new Set<String>{
            '501','502','504','506','508'
            };

  global class SelectionOptions {
      webservice List<SAP_Sales_Org__c> salesOrgs;
      webservice List<SAP_Distribution_Channel__c> distChannels;
      webservice List<SAP_Sales_Division__c> divisions;
      webservice List<SAP_Customer_Group__c> industries;
      webservice List<SAP_Country_Name__c> countries;
  }

  Webservice static SelectionOptions retrieveSelectionOptions() {
      SelectionOptions result = new SelectionOptions();

      result.salesOrgs = getSalesOrgs();
      result.distChannels = getDistChannels();
      result.divisions = getDivisions();
      result.industries = getPACIndustrySegments();
      result.countries = getCountries();

      return result;
  }

  global class MarketPriceBookEntry_Result {
        webservice Market_Price_Book_Entry__c rec;
        webservice Decimal palletSizeInMPBEVolumeUOM = 0;

        global MarketPriceBookEntry_Result(Market_Price_Book_Entry__c rec) {
            this.rec = rec;
        }
  }

  global class RetrieveMarketPriceBookEntries_Result {
    webservice String soql;
    webservice List<MarketPriceBookEntry_Result> records = new List<MarketPriceBookEntry_Result>();
    //webservice List<Market_Price_Book_Entry__c> records = new List<Market_Price_Book_Entry__c>();
    webservice List<Material_UOM2__c> uoms = new List<Material_UOM2__c>();
    webservice Boolean success;
    webservice String message;
  }

  Webservice static RetrieveMarketPriceBookEntries_Result retrieveMarketPriceBookEntries(
    String distChannel,
    String div,
    String country,
    String industry,
    DateTime pricingDate,
    String salesOrg,
    String materialSearch
    )
    {
        RetrieveMarketPriceBookEntries_Result result = new RetrieveMarketPriceBookEntries_Result();

        String whereClause = '';
        List<String> whereParts = new List<String>();

        whereParts.add('Market_Price_Book__r.Current_State__c = \'Active\'');

        if (String.isNotBlank(distChannel)) {whereParts.add('Market_Price_Book__r.Dist_Channel_Key__c INCLUDES(\'' + distChannel + '\')');}
        if (String.isNotBlank(div)) {whereParts.add('Market_Price_Book__r.Division_Key__c INCLUDES(\'' + div + '\')');}
        if (String.isNotBlank(country)) {whereParts.add('Market_Price_Book__r.Country_Key__c INCLUDES(\'' + country + '\')');}
        if (String.isNotBlank(industry)) {whereParts.add('Market_Price_Book__r.PAC_Industry_Segment_Key__c INCLUDES(\'' + industry + '\')');}
        if (String.isNotBlank(salesOrg)) {whereParts.add('Market_Price_Book__r.Sales_Org_Key__c INCLUDES(\'' + salesOrg + '\')');}

        if (String.isNotBlank(salesOrg)) {whereParts.add('Material_Sales_Data2__r.Sales_Org_Code__c = \'' + salesOrg + '\'');}

        if (pricingDate != null) {
            whereParts.add('Market_Price_Book__r.Valid_From_Date__c <= ' + pricingDate.format('YYYY-MM-dd') + '');
            whereParts.add('Market_Price_Book__r.Valid_To_Date__c >= ' + pricingDate.format('YYYY-MM-dd') + '');
        }

        List<String> wherePartsMaterialOr = new List<String>();
        if (String.isNotBlank(materialSearch)) {
            wherePartsMaterialOr.add('Material_Sales_Data2__r.Material_Number__c LIKE \'%' + materialSearch + '%\'');
            wherePartsMaterialOr.add('Material_Sales_Data2__r.Material_Desc__c LIKE \'%' + materialSearch + '%\'');

            wherePartsMaterialOr.add('Material_Sales_Data2__r.Product_Hierarchy__r.PH4_Supplier__c LIKE \'%' + materialSearch + '%\'');
            wherePartsMaterialOr.add('Material_Sales_Data2__r.Product_Hierarchy__r.PH5_Family__c LIKE \'%' + materialSearch + '%\'');
            wherePartsMaterialOr.add('Material_Sales_Data2__r.Product_Hierarchy__r.PH6_Segment__c LIKE \'%' + materialSearch + '%\'');
            wherePartsMaterialOr.add('Material_Sales_Data2__r.Product_Hierarchy__r.PH7_SubSegment__c LIKE \'%' + materialSearch + '%\'');

            wherePartsMaterialOr.add('Material_Sales_Data2__r.Product_Hierarchy__r.PH4__c LIKE \'%' + materialSearch + '%\'');
            wherePartsMaterialOr.add('Material_Sales_Data2__r.Product_Hierarchy__r.PH5__c LIKE \'%' + materialSearch + '%\'');
            wherePartsMaterialOr.add('Material_Sales_Data2__r.Product_Hierarchy__r.PH6__c LIKE \'%' + materialSearch + '%\'');
            wherePartsMaterialOr.add('Material_Sales_Data2__r.Product_Hierarchy__r.PH7__c LIKE \'%' + materialSearch + '%\'');

            wherePartsMaterialOr.add('Material_Sales_Data2__r.Material_General_Data__r.Material_Base_Code_Desc__c LIKE \'%' + materialSearch + '%\'');

            String materialSearchWhere = '(' + String.join(wherePartsMaterialOr,' OR ') + ')';
            whereParts.add(materialSearchWhere);
        }

        whereClause = String.join(whereParts,' AND ');

        String mySOQL = '';

        mySOQL += 'SELECT Id,Name,Active__c,Cloned_From__c,Market_Price_Book__c,Material_Sales_Data2__c,Record_Status__c,Selling_UOM__c,Uses_Scaled_Pricing__c,Volume_UOM__c,CurrencyIsoCode,';

        mySOQL += 'Market_Price_Book__r.Id,Market_Price_Book__r.Name,Market_Price_Book__r.Active__c,Market_Price_Book__r.Cloned_From__c,Market_Price_Book__r.Country_Key__c,';
        mySOQL += 'Market_Price_Book__r.Current_State__c,Market_Price_Book__r.Customer_Group_1_Key__c,Market_Price_Book__r.Description__c,Market_Price_Book__r.Dist_Channel_Key__c,Market_Price_Book__r.Division_Key__c,';
        mySOQL += 'Market_Price_Book__r.Valid_From_Date__c,Market_Price_Book__r.Valid_To_Date__c,Market_Price_Book__r.Family_Key__c,Market_Price_Book__r.IncoTerm_Key__c,Market_Price_Book__r.Manually_Defined_Segmentation_Key__c,';
        mySOQL += 'Market_Price_Book__r.PAC_Industry_Segment_Key__c,Market_Price_Book__r.Product_Line_Key__c,Market_Price_Book__r.Record_Status__c,Market_Price_Book__r.Sales_Org_Key__c,';
        mySOQL += 'Market_Price_Book__r.Segment_Key__c,Market_Price_Book__r.Sub_Segment_Key__c,Market_Price_Book__r.VCP_Rating_Key__c,';

        mySOQL += 'Material_Sales_Data2__r.Sales_Org_Code__c,Material_Sales_Data2__r.SalesOrg_Desc__c,Material_Sales_Data2__r.Dist_Channel_Code__c,Material_Sales_Data2__r.Material_Number__c,';
        mySOQL += 'Material_Sales_Data2__r.Material_Desc__c,Material_Sales_Data2__r.Sales_UOM__c,Material_Sales_Data2__r.Sales_UOM_Desc__c,Material_Sales_Data2__r.Net_Weight__c,';
        mySOQL += 'Material_Sales_Data2__r.Net_Weight_in_LBs__c,Material_Sales_Data2__r.CurrencyIsoCode,Material_Sales_Data2__r.Product_Hierarchy__r.PH1_Division__c,';
        mySOQL += 'Material_Sales_Data2__r.Product_Hierarchy__r.PH2_Line__c,Material_Sales_Data2__r.Product_Hierarchy__r.PH3_Group__c,Material_Sales_Data2__r.Product_Hierarchy__r.PH3__c,';
        mySOQL += 'Material_Sales_Data2__r.Product_Hierarchy__r.PH4_Supplier__c,Material_Sales_Data2__r.Product_Hierarchy__r.PH4__c,';
        mySOQL += 'Material_Sales_Data2__r.Product_Hierarchy__r.PH5_Family__c,Material_Sales_Data2__r.Product_Hierarchy__r.PH5__c,';
        mySOQL += 'Material_Sales_Data2__r.Product_Hierarchy__r.PH6_Segment__c,Material_Sales_Data2__r.Product_Hierarchy__r.PH6__c,';
        mySOQL += 'Material_Sales_Data2__r.Product_Hierarchy__r.PH7_SubSegment__c,Material_Sales_Data2__r.Product_Hierarchy__r.PH7__c,';
        mySOQL += 'Material_Sales_Data2__r.Material_General_Data__r.Id,';
        mySOQL += 'Material_Sales_Data2__r.Material_General_Data__r.Material_Base_Code_Desc__c,';
        mySOQL += 'Material_Sales_Data2__r.Material_General_Data__r.Base_UOM_Desc__c,Material_Sales_Data2__r.Material_General_Data__r.Base_UOM__c,';
        mySOQL += 'Material_Sales_Data2__r.Material_General_Data__r.Material_Container_Desc__c,Material_Sales_Data2__r.Material_General_Data__r.Material_Group_Desc__c,';
        mySOQL += 'Material_Sales_Data2__r.Material_General_Data__r.Material_Type_Desc__c,Material_Sales_Data2__r.Material_General_Data__r.Marked_for_deletion__c,';

        mySOQL += ' (SELECT Id, Cloned_From__c, Floor_Price__c, Maximum_Volume__c, Minimum_Volume__c, Selling_Price__c, Quantity_Surcharge__c, Surcharge__c FROM Market_Price_Book_Scaled_Pricing_Entries__r ORDER BY Minimum_Volume__c) ';

        mySOQL += ' FROM Market_Price_Book_Entry__c';

        if (whereClause != '' && whereClause != null) {
            mySOQL += ' WHERE ' + whereClause;
        }

        mySOQL += ' ORDER BY Market_Price_Book__r.Name,Name ';

        System.debug('mySOQL = ' + mySOQL);

        result.soql = mySOQL;

        try {
            List<Market_Price_Book_Entry__c> records = Database.query(mySOQL);
            for (Market_Price_Book_Entry__c mpbe : records) {
                result.records.add(new MarketPriceBookEntry_Result(mpbe));
            }
            result.success = true;
            result.message = 'Success!';
        }
        catch (Exception e) {
            result.records = new List<MarketPriceBookEntry_Result>();
            result.success = false;
            result.message = e.getMessage();
        }

        Set<String> matNums = new Set<String>();
        Set<String> sellingUoms = new Set<String>();

        sellingUoms.add('PAL');
        if (result.success) {
            for (MarketPriceBookEntry_Result item : result.records) {
                matNums.add(item.rec.Material_Sales_Data2__r.Material_Number__c);
                sellingUoms.add(item.rec.Volume_UOM__c);
            }

            Map<String, Map<String, String>> mumap = Material_UOM_Functions.getUomConversionFactors(matNums, sellingUoms);

            Double uomConvFac;
            Map<Id,Double> uomConversionFactors = new Map<Id,Double>();
            for (MarketPriceBookEntry_Result item : result.records) {
                String matNum = item.rec.Material_Sales_Data2__r.Material_Number__c;
                String baseUom = 'PAL';
                String sellingUOM = item.rec.Volume_UOM__c;
                uomConvFac = Material_UOM_Functions.getUomConversionFactor(matNum, baseUom, sellingUom, mumap);
                item.palletSizeInMPBEVolumeUOM = uomConvFac;
                uomConversionFactors.put(item.rec.Id,uomConvFac);
            }

            System.debug('uomConversionFactors = ' + uomConversionFactors);
        }




        /*
        Set<Id> distinctMaterialGeneralData2Ids = new Set<Id>();
        if (result.success) {
            for (Market_Price_Book_Entry__c rec : result.records) {
                distinctMaterialGeneralData2Ids.add(rec.Material_Sales_Data2__r.Material_General_Data__r.Id);
            }

            Map<Id,Material_UOM2__c> uomMap = getMaterialUOM2Map(distinctMaterialGeneralData2Ids);

            result.uoms = uomMap.values();
        }
        */


        return result;
    }

  private static Map<Id,Material_UOM2__c> getMaterialUOM2Map(Set<Id> materialGeneralData2Ids) {
    Map<Id,Material_UOM2__c> results;
    List<Material_UOM2__c> uoms;

    try {
        uoms = [SELECT Id,
                    Alternative_UOM__c,
                    Alternative_UOM_Desc__c,
                    Material_General_Data__c,
                    Alt_Gross_Weight__c,
                    Alt_Net_Weight__c,
                    Alt_UOM_Desc__c,
                    Base_Gross_Weight__c,
                    Base_Net_Weight__c,
                    Base_UOM_Code__c,
                    Base_UOM_Desc__c,
                    Deleted__c,
                    Den_Num_Conversion_Factor__c,
                    Denominator__c,
                    Gross_Weight_in_LBs__c,
                    Material_Number__c,
                    Net_Weight_in_LBs__c,
                    Num_Den_Conversion_Factor__c,
                    Numerator__c,
                    Record_Key__c
                FROM Material_UOM2__c
                WHERE Material_General_Data__c IN :materialGeneralData2Ids
            ];
    }
//                   AND Alternative_UOM__c = 'PAL'
    catch (Exception e) {uoms = new List<Material_UOM2__c>();}

    results = new Map<Id,Material_UOM2__c>();

    if (!uoms.isEmpty()) {
        for (Material_UOM2__c uom : uoms) {
            results.put(uom.Material_General_Data__c,uom);
        }
    }

    return results;
  }



  Webservice static List<SAP_Sales_Org__c> getSalesOrgs() {
    List<SAP_Sales_Org__c> results;
    results = [SELECT Id,
                      Name,
                      Sales_Org_Code__c,
                      Sales_Org_Description__c
                 FROM SAP_Sales_Org__c
                WHERE Deleted__c = false
                  AND Sales_Org_Code__c IN :SALES_ORG_CODE_FILTER
             ORDER BY Sales_Org_Description__c];
    return results;
  }

  Webservice static List<SAP_Distribution_Channel__c> getDistChannels() {
    List<SAP_Distribution_Channel__c> results;
    results = [SELECT Id,
                      Name,
                      Distribution_Channel_Code__c,
                      Distribution_Channel_Description__c
                 FROM SAP_Distribution_Channel__c
                WHERE Deleted__c = false
                  AND Distribution_Channel_Code__c IN :DIST_CHANNEL_CODE_FILTER
             ORDER BY Distribution_Channel_Description__c];
    return results;
  }

  Webservice static List<SAP_Sales_Division__c> getDivisions() {
    List<SAP_Sales_Division__c> results;
    results = [SELECT Id,
                      Name,
                      Sales_Division_Code__c,
                      Sales_Division_Description__c
                 FROM SAP_Sales_Division__c
                WHERE Deleted__c = false
                  AND Sales_Division_Code__c IN :DIVISION_CODE_FILTER
             ORDER BY Sales_Division_Description__c];
    return results;
  }

  Webservice static List<SAP_Customer_Group__c> getPACIndustrySegments() {
    List<SAP_Customer_Group__c> results;
    results = [SELECT Id,
                      Name,
                      Customer_Group_Code__c,
                      Customer_Group_Name__c
                 FROM SAP_Customer_Group__c
                WHERE Deleted__c = false
                  AND Customer_Group_Code__c IN :PAC_INDUSTRY_SEGMENT_CODE_FILTER
             ORDER BY Customer_Group_Name__c];
    return results;
  }

  Webservice static List<SAP_Country_Name__c> getCountries() {
    List<SAP_Country_Name__c> results;
    results = [SELECT Id,
                      Name,
                      Country_Name__c,
                      Country_Code__c
                 FROM SAP_Country_Name__c
                WHERE Country_Code__c IN :COUNTRY_CODE_FILTER
             ORDER BY Country_Name__c];
    return results;
  }

  Webservice static List<Product_Hierarchy__c> getSegments(String distChan,
                                                           List<String> prodFamilies) {

    if (distChan=='')
    {
        distChan = '50';
    }

    if (prodFamilies.size() == 0)
    {
        List<Product_Hierarchy__c> phfamilies = getFamilies(distChan);
        for(Product_Hierarchy__c phfamily:phfamilies)
        {
            prodFamilies.add(phfamily.Product_Hierarchy_Code__c);
        }
    }

    return SAP_Material_Queries.getProductLinesForFamilies(distChan,prodFamilies);
  }


  Webservice static List<Product_Hierarchy__c> getFamilies(String distChan) {
    if (distChan=='') {distChan = '50';}

    List<Product_Hierarchy__c> alist = SAP_Material_Queries.getProductFamiliesForDistChan(distChan);
    return alist;
  }

  Webservice static List<Product_Hierarchy__c> getSubSegments(String distChan,
                                                              List<String> prodFamilies,
                                                              List<String> prodSegments) {

    if (distChan=='') {distChan = '50';}

    if (prodSegments.size() == 0)
    {
        List<Product_Hierarchy__c> phSegments = Product_Hierarchy_Functions.getProductSegments(distChan);
        for(Product_Hierarchy__c phSegment:phSegments)
        {
            prodSegments.add(phSegment.Product_Hierarchy_Code__c);
        }
    }

    if (prodFamilies.size() == 0)
    {
        List<Product_Hierarchy__c> phfamilies = Product_Hierarchy_Functions.getProductFamilies(distChan, prodSegments);
        for(Product_Hierarchy__c phfamily:phfamilies)
        {
            prodFamilies.add(phfamily.Product_Hierarchy_Code__c);
        }
    }


    List<Product_Hierarchy__c> phSubSegments = SAP_Material_Queries.getProductSubSegments(distChan, prodFamilies, prodSegments);
    return phSubSegments;
  }


  Webservice static List<SAP_Customer_Group1__c> getCustomerGroup1s() {
    List<SAP_Customer_Group1__c> results;
    results = [SELECT Id,
                      Name,
                      Customer_Group1_Code__c,
                      Customer_Group1_Name__c
                 FROM SAP_Customer_Group1__c
                WHERE Customer_Group1_Code__c IN :CUSTOMER_GROUP_1_FILTER
             ORDER BY Customer_Group1_Name__c];
    return results;
  }

  Webservice static List<SAP_INCO_Term__c> getIncoTerms() {
    List<SAP_INCO_Term__c> results;
    results = [SELECT Id,
                      INCO_Term_Code__c,
                      INCO_Term_Name__c
                 FROM SAP_INCO_Term__c
                WHERE Deleted__c = false
                  AND INCO_Term_Code__c IN :INCOTERM_FILTER
               ];
    return results;
  }

  Webservice static List<SAP_UOM_Description__c> getMaterialUoms(Id materialId) {
      return SAP_Material_Queries.getMaterialUoms(materialId);
  }

  private static List<Id> retrieveAccountIdsFromCPIforIncoTerms(List<String> incoTerms) {
      List<Customer_Product_Info2__c> CPIs = [SELECT ShipTo__c, Customer__c FROM Customer_Product_Info2__c WHERE INCO_Terms1__c IN :incoTerms];

      Map<Id,Boolean> uniqueCPIAccountIdMap = new Map<Id,Boolean>();

      for (Customer_Product_Info2__c CPI : CPIs) {
        uniqueCPIAccountIdMap.put(CPI.ShipTo__c,true);
        uniqueCPIAccountIdMap.put(CPI.Customer__c,true);
      }

      List<Id> CPIAccountIds = new List<Id>(uniqueCPIAccountIdMap.keySet());

      return CPIAccountIds;
  }

/*
  Webservice static Integer getAccountsRelatedtoMarketPriceBookKeyRecordCount_OLD(
                                      List<String> salesOrgs,
                                      List<String> distChannels,
                                      List<String> divisions,
                                      List<String> PACIndustrySegments,
                                      List<String> countries,
                                      List<String> families,
                                      List<String> segments,
                                      List<String> subSegments,
                                      List<String> incoTerms,
                                      List<String> customerGroup1s,
                                      List<String> vcpRatings
                                  ) {
        Integer result;

        result = 0;

        List<Id> CPIAccountIds = retrieveAccountIdsFromCPIforIncoTerms(incoTerms);

        result = [SELECT count()
                    FROM Account
                   WHERE (
                              SAP_Sales_Org__c IN :salesOrgs
                          AND SAP_DistChannel__c IN :distChannels
                          AND SAP_DivisionCode__c IN :divisions
                          AND SAP_Customer_Group__c IN :PACIndustrySegments
                          AND SAP_Country__c IN :countries
                          AND SAP_INCO_Terms1__c IN :incoTerms
                          AND SAP_Customer_Group_1__c IN :customerGroup1s
                          AND Customer_Classification_ABC__c IN :vcpRatings
                         )
                         OR
                         (
                              Id IN :CPIAccountIds
                          AND SAP_DistChannel__c IN :distChannels
                          AND SAP_DivisionCode__c IN :divisions
                          AND SAP_Customer_Group__c IN :PACIndustrySegments
                          AND SAP_Country__c IN :countries
                          AND SAP_Customer_Group_1__c IN :customerGroup1s
                          AND Customer_Classification_ABC__c IN :vcpRatings
                         )
                 ];

        return result;

//                     AND PAC_Industry_Segment__c IN :PACIndustrySegments

    }
*/

  Webservice static Integer getAccountsRelatedtoMarketPriceBookKeyRecordCount(
                                      List<String> salesOrgs,
                                      List<String> distChannels,
                                      List<String> divisions,
                                      List<String> PACIndustrySegments,
                                      List<String> countries,
                                      List<String> families,
                                      List<String> segments,
                                      List<String> subSegments,
                                      List<String> incoTerms,
                                      List<String> customerGroup1s,
                                      List<String> vcpRatings
                                  ) {
        Integer result;

        result = 0;

        List<Id> validAccountIds = getAccountIdsRelatedtoMarketPriceBookKey(
            salesOrgs,
            distChannels,
            divisions,
            PACIndustrySegments,
            countries,
            families,
            segments,
            subSegments,
            incoTerms,
            customerGroup1s,
            vcpRatings);

        result = validAccountIds.size();

        return result;
    }

  Webservice static Integer getMaterialsRelatedtoMarketPriceBookKeyRecordCount(
                                      List<String> salesOrgs,
                                      List<String> distChannels,
                                      List<String> families,
                                      List<String> segments
                                  ) {
        Integer result;

        result = 0;

        result = [SELECT count()
                    FROM Material_Sales_Data2__c
                   WHERE Material_General_Data__r.Marked_for_deletion__c = ''
                     AND Deletion_Flag__c = ''
                     AND Sales_Org_Code__c IN :salesOrgs
                     AND Dist_Channel_Code__c IN :distChannels
                     AND PH5_Family_Code__c IN :families
                     AND PH6_Segment_Code__c IN :segments
                 ];

        return result;

    }

/*
  Webservice static List<Account> getAccountsRelatedtoMarketPriceBookKey_OLD(
                                      List<String> salesOrgs,
                                      List<String> distChannels,
                                      List<String> divisions,
                                      List<String> PACIndustrySegments,
                                      List<String> countries,
                                      List<String> families,
                                      List<String> segments,
                                      List<String> subSegments,
                                      List<String> incoTerms,
                                      List<String> customerGroup1s,
                                      List<String> vcpRatings
                                  ) {
    List<Account> results;

    List<Id> CPIAccountIds = retrieveAccountIdsFromCPIforIncoTerms(incoTerms);

    results = [SELECT   ShippingStreet,
                        ShippingState,
                        ShippingPostalCode,
                        ShippingCountry,
                        ShippingCity,
                        SAP_Street__c,
                        SAP_State__c,
                        SAP_ShippingPlant__c,
                        SAP_Sales_Org__c,
                        SAP_Sales_Org_Desc__c,
                        SAP_Sales_Office__c,
                        SAP_Sales_Office_Desc__c,
                        SAP_SalesGroup__c,
                        SAP_SalesDistrict__c,
                        SAP_Region__c,
                        SAP_Partner_Functions__c,
                        SAP_INCO_Terms1__c,
                        SAP_INCO_Terms1_Desc__c,
                        SAP_Division_Desc__c,
                        SAP_DivisionCode__c,
                        SAP_Dist_Channel_Desc__c,
                        SAP_DistChannel__c,
                        SAP_Customer_Segment__c,
                        SAP_Customer_Number__c,
                        SAP_Customer_Group__c,
                        SAP_Customer_Group_Desc__c,
                        SAP_Customer_Group_1__c,
                        SAP_Customer_Group_1_Desc__c,
                        SAP_Country__c,
                        SAP_City__c,
                        Region__c,
                        RecordTypeId,
                        PAC_Industry_Segment__c,
                        OwnerId,
                        Id,
                        BillingStreet,
                        BillingState,
                        BillingPostalCode,
                        BillingCountry,
                        BillingCity,
                        Annual_Volume__c,
                        Annual_Orders__c,
                        Account_Number_and_Status__c,
                        Account_Number__c,
                        AccountNumber,
                        Customer_Classification_ABC__c,
                        Name
                  FROM Account
                 WHERE (
                            SAP_Sales_Org__c IN :salesOrgs
                        AND SAP_DistChannel__c IN :distChannels
                        AND SAP_DivisionCode__c IN :divisions
                        AND SAP_Customer_Group__c IN :PACIndustrySegments
                        AND SAP_Country__c IN :countries
                        AND SAP_INCO_Terms1__c IN :incoTerms
                        AND SAP_Customer_Group_1__c IN :customerGroup1s
                        AND Customer_Classification_ABC__c IN :vcpRatings
                       )
                       OR
                       (
                            Id IN :CPIAccountIds
                        AND SAP_DistChannel__c IN :distChannels
                        AND SAP_DivisionCode__c IN :divisions
                        AND SAP_Customer_Group__c IN :PACIndustrySegments
                        AND SAP_Country__c IN :countries
                        AND SAP_Customer_Group_1__c IN :customerGroup1s
                        AND Customer_Classification_ABC__c IN :vcpRatings
                       )
                  ];
    return results;

//                   AND PAC_Industry_Segment__c IN :PACIndustrySegments

  }
*/

  private static List<Id> getAccountIdsRelatedtoMarketPriceBookKey(
                                      List<String> salesOrgs,
                                      List<String> distChannels,
                                      List<String> divisions,
                                      List<String> PACIndustrySegments,
                                      List<String> countries,
                                      List<String> families,
                                      List<String> segments,
                                      List<String> subSegments,
                                      List<String> incoTerms,
                                      List<String> customerGroup1s,
                                      List<String> vcpRatings
  ) {
    List<Id> results = new List<Id>();

    /******************************************
     * Holders for Valid Account Ids to return
     ******************************************/
    Set<Id> validAccountIdsSet = new Set<Id>();

    /********************************************
     * Retrieve Accounts Directly Related to Key
     ********************************************/
    List<Id> CPIAccountIds = retrieveAccountIdsFromCPIforIncoTerms(incoTerms);
    List<Account> accountsDirectlyRelatedtoKey;
    try {
        accountsDirectlyRelatedtoKey =
            [
            SELECT Id,
                SAP_Sales_Org__c,
                SAP_DistChannel__c,
                SAP_DivisionCode__c,
                SAP_Customer_Group__c,
                SAP_Country__c,
                SAP_INCO_Terms1__c,
                SAP_Customer_Group_1__c,
                Customer_Classification_ABC__c
            FROM Account
            WHERE (
                SAP_Sales_Org__c IN :salesOrgs
                AND SAP_DistChannel__c IN :distChannels
            AND SAP_DivisionCode__c IN :divisions
            AND SAP_Customer_Group__c IN :PACIndustrySegments
            AND SAP_Country__c IN :countries
            AND SAP_INCO_Terms1__c IN :incoTerms
            AND SAP_Customer_Group_1__c IN :customerGroup1s
            AND Customer_Classification_ABC__c IN :vcpRatings
            )
            OR
            (
                Id IN :CPIAccountIds
            AND SAP_Sales_Org__c IN :salesOrgs
            AND SAP_DistChannel__c IN :distChannels
            AND SAP_DivisionCode__c IN :divisions
            AND SAP_Customer_Group__c IN :PACIndustrySegments
            AND SAP_Country__c IN :countries
            AND SAP_Customer_Group_1__c IN :customerGroup1s
            AND Customer_Classification_ABC__c IN :vcpRatings
            )
            ];
    }
    catch (Exception e) {
        accountsDirectlyRelatedtoKey = new List<Account>();
    }

    /**********************************
     * Retrieve Accounts Based on LISD
     **********************************/
    List<SAP_Line_Item_Sales_Detail__c> accountsRelatedByLISDtoKey;

    try {
        accountsRelatedByLISDtoKey =
            [
            SELECT Id,
                ShipTo_Account__r.Id,
                ShipTo_Account__r.SAP_Sales_Org__c,
                ShipTo_Account__r.SAP_DistChannel__c,
                ShipTo_Account__r.SAP_DivisionCode__c,
                ShipTo_Account__r.SAP_Customer_Group__c,
                ShipTo_Account__r.SAP_Country__c,
                ShipTo_Account__r.SAP_INCO_Terms1__c,
                ShipTo_Account__r.SAP_Customer_Group_1__c,
                ShipTo_Account__r.Customer_Classification_ABC__c
            FROM SAP_Line_Item_Sales_Detail__c
            WHERE (
                ShipTo_Account__r.SAP_Sales_Org__c IN :salesOrgs
                AND ShipTo_Account__r.SAP_DistChannel__c IN :distChannels
            AND ShipTo_Account__r.SAP_DivisionCode__c IN :divisions
            AND Customer_Group__c IN :PACIndustrySegments
            AND ShipTo_Account__r.SAP_Country__c IN :countries
            AND ShipTo_Account__r.SAP_INCO_Terms1__c IN :incoTerms
            AND ShipTo_Account__r.SAP_Customer_Group_1__c IN :customerGroup1s
            AND ShipTo_Account__r.Customer_Classification_ABC__c IN :vcpRatings
            )
            ];
    }
    catch (Exception e) {
        accountsRelatedByLISDtoKey = new List<SAP_Line_Item_Sales_Detail__c>();
    }

    /************************************
     * Populate the validAccountIds List
     ************************************/
    for (Account account : accountsDirectlyRelatedtoKey) {
        validAccountIdsSet.Add(account.Id);
    }

    for (SAP_Line_Item_Sales_Detail__c lisd : accountsRelatedByLISDtoKey) {
        validAccountIdsSet.Add(lisd.ShipTo_Account__r.Id);
    }

    results = new List<Id>(validAccountIdsSet);

    return results;
  }

  Webservice static List<Account> getAccountsRelatedtoMarketPriceBookKey(
                                      List<String> salesOrgs,
                                      List<String> distChannels,
                                      List<String> divisions,
                                      List<String> PACIndustrySegments,
                                      List<String> countries,
                                      List<String> families,
                                      List<String> segments,
                                      List<String> subSegments,
                                      List<String> incoTerms,
                                      List<String> customerGroup1s,
                                      List<String> vcpRatings
                                  ) {
    List<Account> results;

    List<Id> validAccountIds = getAccountIdsRelatedtoMarketPriceBookKey(
        salesOrgs,
        distChannels,
        divisions,
        PACIndustrySegments,
        countries,
        families,
        segments,
        subSegments,
        incoTerms,
        customerGroup1s,
        vcpRatings);

    /***************************
     * Retrieve Account Details
     ***************************/
    results = [SELECT ShippingStreet,
                      ShippingState,
                      ShippingPostalCode,
                      ShippingCountry,
                      ShippingCity,
                      SAP_Street__c,
                      SAP_State__c,
                      SAP_ShippingPlant__c,
                      SAP_Sales_Org__c,
                      SAP_Sales_Org_Desc__c,
                      SAP_Sales_Office__c,
                      SAP_Sales_Office_Desc__c,
                      SAP_SalesGroup__c,
                      SAP_SalesDistrict__c,
                      SAP_Region__c,
                      SAP_Partner_Functions__c,
                      SAP_INCO_Terms1__c,
                      SAP_INCO_Terms1_Desc__c,
                      SAP_Division_Desc__c,
                      SAP_DivisionCode__c,
                      SAP_Dist_Channel_Desc__c,
                      SAP_DistChannel__c,
                      SAP_Customer_Segment__c,
                      SAP_Customer_Number__c,
                      SAP_Customer_Group__c,
                      SAP_Customer_Group_Desc__c,
                      SAP_Customer_Group_1__c,
                      SAP_Customer_Group_1_Desc__c,
                      SAP_Country__c,
                      SAP_City__c,
                      Region__c,
                      RecordTypeId,
                      PAC_Industry_Segment__c,
                      OwnerId,
                      Id,
                      BillingStreet,
                      BillingState,
                      BillingPostalCode,
                      BillingCountry,
                      BillingCity,
                      Annual_Volume__c,
                      Annual_Orders__c,
                      Account_Number_and_Status__c,
                      Account_Number__c,
                      AccountNumber,
                      Customer_Classification_ABC__c,
                      Name
                 FROM Account
                WHERE Id IN :validAccountIds
    ];
    return results;
  }





/***********************************************************
 * Services for App_MarketPriceToCustomerRelationshipBuilder
 ***********************************************************/

    Webservice static Account getAccountDetails(Id accountId) {
        Account acct;

        try {
        acct = [SELECT Id,
                    Name,
                    NameLocal,
                    Type,
                    RecordTypeId,
                    ParentId,
                    BillingStreet,
                    BillingCity,
                    BillingState,
                    BillingPostalCode,
                    BillingCountry,
                    AccountNumber,
                    OwnerId,
                    Owner.Name,
                    SAP_Partner_Functions__c,
                    SAP_Sales_Office__c,
                    SAP_Customer_Group__c,
                    SAP_Customer_Group_Desc__c,
                    SAP_Customer_Group_1__c,
                    SAP_Customer_Group_1_Desc__c,
                    SAP_Dist_Channel_Desc__c,
                    SAP_Division_Desc__c,
                    SAP_Sales_Office_Desc__c,
                    SAP_Sales_Group_Desc__c,
                    SAP_Sales_District_Desc__c,
                    SAP_Country__c,
                    Country_Code__c,
                    SAP_Currency__c,
                    CurrencyIsoCode,
                    SAP_Customer_Number__c,
                    SAP_Customer_Type__c,
                    SAP_DistChannel__c,
                    SAP_DivisionCode__c,
                    SAP_Exempt_Quantity_Surcharge__c,
                    SAP_PartnerFunctionCodeText__c,
                    SAP_INCO_Terms1__c,
                    SAP_INCO_Terms1_Desc__c,
                    SAP_National_Account__c,
                    SAP_PartnerFunctionText__c,
                    SAP_Payment_Terms__c,
                    SAP_Region__c,
                    SAP_SalesDistrict__c,
                    SAP_SalesGroup__c,
                    SAP_Sales_Org__c,
                    SAP_Seller__c,
                    SAP_Seller_Name__c,
                    SAP_ShippingPlant__c,
                    SAP_State__c,
                    SAP_Street__c,
                    SAP_Zip_Code__c,
                    Active_Account__c,
                    Street_Address__c,
                    State_City_Country__c,
                    sales_area__c,
                    SAP_Sales_Org_Desc__c,
                    Full_Address__c,
                    Account_Number_and_Status__c,
                    Inside_Seller_Number__c,
                    Inside_Seller_Name__c,
                    Customer_Classification_ABC__c
               FROM Account WHERE id = :accountId];
        } catch (Exception e) {acct = new Account();}

        return acct;
    }

    private static List<Customer_Product_Info2__c> retrieveCPIRecordsforAccountId(Id accountId) {
        List<Customer_Product_Info2__c> CPIs = [SELECT ShipTo__c,
                                                       Customer__c,
                                                       Material__c,
                                                       INCO_Terms1__c
                                                  FROM Customer_Product_Info2__c
                                                 WHERE ShipTo__c = :accountId
                                                    OR Customer__c = :accountId
                                               ];
        return CPIs;
    }

    private static List<String> getDistinctINCOTerms1FromCPIRecords(List<Customer_Product_Info2__c> CPIs) {
        Map<String,Boolean> incotermsMap = new Map<String,Boolean>();

        for (Customer_Product_Info2__c CPI : CPIs) {
            if (CPI.INCO_Terms1__c != null && CPI.INCO_Terms1__c != '') {
                incotermsMap.put(CPI.INCO_Terms1__c,true);
            }
        }

        return new List<String>(incotermsMap.keySet());
    }

    private static List<Id> getDistinctMaterialIdsFromCPIRecords(List<Customer_Product_Info2__c> CPIs) {
        Map<Id,Boolean> materialIdsMap = new Map<Id,Boolean>();

        for (Customer_Product_Info2__c CPI : CPIs) {
            if (CPI.Material__c != null) {
                materialIdsMap.put(CPI.Material__c,true);
            }
        }

        return new List<Id>(materialIdsMap.keySet());
    }

/*
    Webservice static List<Market_Price_Book_Entry__c> getEntriesAvailableforAccount_OLD(Id accountId) {
        Account acct;
        Boolean error = false;

        List<Market_Price_Book_Entry__c> results;
        try {
            acct = [SELECT Id, Name, SAP_Sales_Org__c, SAP_DistChannel__c, SAP_DivisionCode__c, SAP_Customer_Group__c, SAP_Country__c, SAP_INCO_Terms1__c, SAP_Customer_Group_1__c, Customer_Classification_ABC__c FROM Account WHERE Id = :accountId];
        }
        catch (Exception e) {
            System.debug('ERROR! Account Record for ' + accountId + ' Not Found!');
            results = new List<Market_Price_Book_Entry__c>();
            error=true;
        }

        List<Account_To_Market_Price_Book_Entry__c> relationshipRecs;

        try {
            relationshipRecs = [SELECT Id,
                                       Account__c,
                                       Available_Market_Pricing_Types__c,
                                       Material_Sales_Data2__c,
                                       Market_Price_Book_Entry__c
                                  FROM Account_To_Market_Price_Book_Entry__c
                                 WHERE Account__c = :accountId
                               ];
        }
        catch (Exception e) {relationshipRecs = new List<Account_To_Market_Price_Book_Entry__c>();}

        List<Id> entryIds = new List<Id>();

        for (Account_To_Market_Price_Book_Entry__c rec : relationshipRecs) {entryIds.add(rec.Market_Price_Book_Entry__c);}


        List<Customer_Product_Info2__c> CPIs = retrieveCPIRecordsforAccountId(accountId);
        List<String> distinctCPIIncoTerms = getDistinctINCOTerms1FromCPIRecords(CPIs);
        List<Id> distinctCPIMaterialIds = getDistinctMaterialIdsFromCPIRecords(CPIs);

        System.debug('*** CPIs = ' + CPIs);
        System.debug('*** distinctCPIIncoTerms = ' + distinctCPIIncoTerms);
        System.debug('*** distinctCPIMaterialIds = ' + distinctCPIMaterialIds);

        if (!error) {
            try {
                results = [SELECT Id,
                                  Name,
                                  Active__c,
                                  Cloned_From__c,
                                  Market_Price_Book__c,
                                  Material_Sales_Data2__c,
                                  Record_Status__c,
                                  Selling_UOM__c,
                                  Uses_Scaled_Pricing__c,
                                  Volume_UOM__c,
                                  Market_Price_Book__r.Id,
                                  Market_Price_Book__r.Name,
                                  Market_Price_Book__r.Active__c,
                                  Market_Price_Book__r.Cloned_From__c,
                                  Market_Price_Book__r.Country_Key__c,
                                  Market_Price_Book__r.Current_State__c,
                                  Market_Price_Book__r.Customer_Group_1_Key__c,
                                  Market_Price_Book__r.Description__c,
                                  Market_Price_Book__r.Dist_Channel_Key__c,
                                  Market_Price_Book__r.Division_Key__c,
                                  Market_Price_Book__r.Valid_From_Date__c,
                                  Market_Price_Book__r.Valid_To_Date__c,
                                  Market_Price_Book__r.Family_Key__c,
                                  Market_Price_Book__r.IncoTerm_Key__c,
                                  Market_Price_Book__r.Manually_Defined_Segmentation_Key__c,
                                  Market_Price_Book__r.PAC_Industry_Segment_Key__c,
                                  Market_Price_Book__r.Product_Line_Key__c,
                                  Market_Price_Book__r.Record_Status__c,
                                  Market_Price_Book__r.Sales_Org_Key__c,
                                  Market_Price_Book__r.Segment_Key__c,
                                  Market_Price_Book__r.Sub_Segment_Key__c,
                                  Market_Price_Book__r.VCP_Rating_Key__c,
                                  Material_Sales_Data2__r.Sales_Org_Code__c,
                                  Material_Sales_Data2__r.SalesOrg_Desc__c,
                                  Material_Sales_Data2__r.Dist_Channel_Code__c,
                                  Material_Sales_Data2__r.Material_Number__c,
                                  Material_Sales_Data2__r.Material_Desc__c,
                                  Material_Sales_Data2__r.Sales_UOM__c,
                                  Material_Sales_Data2__r.Sales_UOM_Desc__c,
                                  Material_Sales_Data2__r.Net_Weight__c,
                                  Material_Sales_Data2__r.Net_Weight_in_LBs__c,
                                  Material_Sales_Data2__r.CurrencyIsoCode,
                                  Material_Sales_Data2__r.Product_Hierarchy__r.PH1_Division__c,
                                  Material_Sales_Data2__r.Product_Hierarchy__r.PH2_Line__c,
                                  Material_Sales_Data2__r.Product_Hierarchy__r.PH3_Group__c,
                                  Material_Sales_Data2__r.Product_Hierarchy__r.PH3__c,
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
                                  (SELECT Id, Cloned_From__c, Floor_Price__c, Maximum_Volume__c, Minimum_Volume__c, Selling_Price__c, Surcharge__c FROM Market_Price_Book_Scaled_Pricing_Entries__r ORDER BY Minimum_Volume__c)
                             FROM Market_Price_Book_Entry__c
                            WHERE Id NOT IN :entryIds
                              AND (
                                    (
                                         Market_Price_Book__r.Country_Key__c INCLUDES (:acct.SAP_Country__c)
                                     AND Market_Price_Book__r.Customer_Group_1_Key__c INCLUDES (:acct.SAP_Customer_Group_1__c)
                                     AND Market_Price_Book__r.Dist_Channel_Key__c INCLUDES (:acct.SAP_DistChannel__c)
                                     AND Market_Price_Book__r.Division_Key__c INCLUDES (:acct.SAP_DivisionCode__c)
                                     AND Market_Price_Book__r.IncoTerm_Key__c INCLUDES (:acct.SAP_INCO_Terms1__c)
                                     AND Market_Price_Book__r.PAC_Industry_Segment_Key__c INCLUDES (:acct.SAP_Customer_Group__c)
                                     AND Market_Price_Book__r.Sales_Org_Key__c INCLUDES (:acct.SAP_Sales_Org__c)
                                     AND Market_Price_Book__r.VCP_Rating_Key__c INCLUDES (:acct.Customer_Classification_ABC__c)
                                     AND Material_Sales_Data2__r.Sales_Org_Code__c = :acct.SAP_Sales_Org__c
                                    )
                                    OR
                                    (
                                         Market_Price_Book__r.Country_Key__c INCLUDES (:acct.SAP_Country__c)
                                     AND Market_Price_Book__r.Customer_Group_1_Key__c INCLUDES (:acct.SAP_Customer_Group_1__c)
                                     AND Market_Price_Book__r.Dist_Channel_Key__c INCLUDES (:acct.SAP_DistChannel__c)
                                     AND Market_Price_Book__r.Division_Key__c INCLUDES (:acct.SAP_DivisionCode__c)
                                     AND Market_Price_Book__r.PAC_Industry_Segment_Key__c INCLUDES (:acct.SAP_Customer_Group__c)
                                     AND Market_Price_Book__r.Sales_Org_Key__c INCLUDES (:acct.SAP_Sales_Org__c)
                                     AND Market_Price_Book__r.VCP_Rating_Key__c INCLUDES (:acct.Customer_Classification_ABC__c)
                                     AND Material_Sales_Data2__r.Sales_Org_Code__c = :acct.SAP_Sales_Org__c
                                     AND
                                         Market_Price_Book__r.IncoTerm_Key__c IN :distinctCPIIncoTerms
                                     AND Material_Sales_Data2__c IN :distinctCPIMaterialIds
                                    )
                                  )

                            ORDER BY Market_Price_Book__r.Id
                          ];



                          // AND Market_Price_Book__r.Active__c = TRUE
            } catch (Exception e) {results = new List<Market_Price_Book_Entry__c>();}
        }

        return results;
    }
*/

    Webservice static List<Market_Price_Book_Entry__c> getEntriesAvailableforAccount(Id accountId) {
        List<Market_Price_Book_Entry__c > results;
        Boolean error = false;

        /*************************************
         * Retrieve Necessary Account Details
         *************************************/
        Account acct;
        try {acct = [SELECT Id, Name, SAP_Sales_Org__c, SAP_DistChannel__c, SAP_DivisionCode__c, SAP_Customer_Group__c, SAP_Country__c, SAP_INCO_Terms1__c, SAP_Customer_Group_1__c, Customer_Classification_ABC__c FROM Account WHERE Id = :accountId];}
        catch (Exception e) {
            System.debug('ERROR! Account Record for ' + accountId + ' Not Found!');
            results = new List<Market_Price_Book_Entry__c>();
            error=true;
        }

        Boolean isSoldTo = Account_Partner_Functions.isSoldTo(accountId);

        /********************************************************
         * Find All Market Price Book Entries already associated
         * with the Account so they can be excluded
         ********************************************************/
        List<Account_To_Market_Price_Book_Entry__c> relationshipRecs;
        List<Id> entryIdstoExclude = new List<Id>();
        try {
            relationshipRecs = [SELECT Id, Account__c, Available_Market_Pricing_Types__c,
                                       Material_Sales_Data2__c, Market_Price_Book_Entry__c
                                  FROM Account_To_Market_Price_Book_Entry__c
                                 WHERE Account__c = :accountId];
        } catch (Exception e) {relationshipRecs = new List<Account_To_Market_Price_Book_Entry__c>();}
        for (Account_To_Market_Price_Book_Entry__c rec : relationshipRecs) {entryIdstoExclude.add(rec.Market_Price_Book_Entry__c);}

        /************************************************
         * Identify Market Price Book Entries to Include
         ************************************************/
        List<Market_Price_Book_Entry__c> entriesDirectlyRelatedToAccount;
        Set<String> validCustomerGroupsSet = new Set<String>();
        List<String> validCustomerGroups = new List<String>();

        Set<Id> validEntryIdsSet = new Set<Id>();
        List<Id> validEntryIds = new List<Id>();
        validCustomerGroupsSet.add(acct.SAP_Customer_Group__c);

        // Retrieve CPI Information
        List<Customer_Product_Info2__c> CPIs = retrieveCPIRecordsforAccountId(accountId);
        List<String> distinctCPIIncoTerms = getDistinctINCOTerms1FromCPIRecords(CPIs);
        List<Id> distinctCPIMaterialIds = getDistinctMaterialIdsFromCPIRecords(CPIs);

        // Retrieve LISD Information

        System.debug('*** validCustomerGroupsSet Before LISD = ' + validCustomerGroupsSet);

        if (isSoldTo) {
            List<SAP_LISD> lisds = SAP_LISD_Functions.getAccountLisds(accountId);
            for (SAP_LISD lisd : lisds) {
                if (lisd.lisd.Customer_Group__c != null) {
                    validCustomerGroupsSet.addAll(lisd.lisd.Customer_Group__c.split(';'));
                }
            }
        }

        System.debug('*** validCustomerGroupsSet After LISD = ' + validCustomerGroupsSet);

        // Populate Key Lookups
        validCustomerGroups = new List<String>(validCustomerGroupsSet);

        System.debug('*** validCustomerGroups = ' + validCustomerGroups);

        // Get Valid Entries Related to the Account
        try {
            entriesDirectlyRelatedToAccount = [SELECT Id,
                                                    Market_Price_Book__c,
                                                    Material_Sales_Data2__c,
                                                    Market_Price_Book__r.Country_Key__c,
                                                    Market_Price_Book__r.Customer_Group_1_Key__c,
                                                    Market_Price_Book__r.Dist_Channel_Key__c,
                                                    Market_Price_Book__r.Division_Key__c,
                                                    Market_Price_Book__r.IncoTerm_Key__c,
                                                    Market_Price_Book__r.PAC_Industry_Segment_Key__c,
                                                    Market_Price_Book__r.Sales_Org_Key__c,
                                                    Market_Price_Book__r.VCP_Rating_Key__c,
                                                    Material_Sales_Data2__r.Sales_Org_Code__c
                                                FROM Market_Price_Book_Entry__c
                                                WHERE Id NOT IN :entryIdstoExclude
                                                AND (
                                                        (
                                                            Market_Price_Book__r.Country_Key__c INCLUDES (:acct.SAP_Country__c)
                                                        AND Market_Price_Book__r.Customer_Group_1_Key__c INCLUDES (:acct.SAP_Customer_Group_1__c)
                                                        AND Market_Price_Book__r.Dist_Channel_Key__c INCLUDES (:acct.SAP_DistChannel__c)
                                                        AND Market_Price_Book__r.Division_Key__c INCLUDES (:acct.SAP_DivisionCode__c)
                                                        AND Market_Price_Book__r.IncoTerm_Key__c INCLUDES (:acct.SAP_INCO_Terms1__c)
                                                        AND Market_Price_Book__r.Sales_Org_Key__c INCLUDES (:acct.SAP_Sales_Org__c)
                                                        AND Market_Price_Book__r.VCP_Rating_Key__c INCLUDES (:acct.Customer_Classification_ABC__c)
                                                        AND Material_Sales_Data2__r.Sales_Org_Code__c = :acct.SAP_Sales_Org__c
                                                        )
                                                    OR
                                                        (
                                                            Market_Price_Book__r.Country_Key__c INCLUDES (:acct.SAP_Country__c)
                                                        AND Market_Price_Book__r.Customer_Group_1_Key__c INCLUDES (:acct.SAP_Customer_Group_1__c)
                                                        AND Market_Price_Book__r.Dist_Channel_Key__c INCLUDES (:acct.SAP_DistChannel__c)
                                                        AND Market_Price_Book__r.Division_Key__c INCLUDES (:acct.SAP_DivisionCode__c)
                                                        AND Market_Price_Book__r.Sales_Org_Key__c INCLUDES (:acct.SAP_Sales_Org__c)
                                                        AND Market_Price_Book__r.VCP_Rating_Key__c INCLUDES (:acct.Customer_Classification_ABC__c)
                                                        AND Material_Sales_Data2__r.Sales_Org_Code__c = :acct.SAP_Sales_Org__c
                                                        AND Market_Price_Book__r.IncoTerm_Key__c IN :distinctCPIIncoTerms
                                                        AND Material_Sales_Data2__c IN :distinctCPIMaterialIds
                                                        )
                                                    )
                                                  AND Market_Price_Book__r.Current_State__c in :PB_STATS2
                                                ORDER BY Market_Price_Book__r.Id
                                            ];
        } catch (Exception e) {entriesDirectlyRelatedToAccount = new List<Market_Price_Book_Entry__c>();}

        /*
                                                        AND Market_Price_Book__r.PAC_Industry_Segment_Key__c INCLUDES (:acct.SAP_Customer_Group__c)
                                                        AND Market_Price_Book__r.PAC_Industry_Segment_Key__c INCLUDES (:acct.SAP_Customer_Group__c)

        */


        /*****************************
         * Populate the validEntryIds
         *****************************/
        for (Market_Price_Book_Entry__c entry : entriesDirectlyRelatedToAccount) {
            Set<String> entryCustomerGroups = new Set<String>(entry.Market_Price_Book__r.PAC_Industry_Segment_Key__c.split(';'));

            System.debug('*** - validCustomerGroupsSet = ' + validCustomerGroupsSet);
            System.debug('*** - entryCustomerGroups = ' + entryCustomerGroups);

            entryCustomerGroups.retainAll(validCustomerGroupsSet);

            System.debug('*** - entryCustomerGroups after retainAll = ' + entryCustomerGroups);

            if (!entryCustomerGroups.isEmpty()) {
                validEntryIdsSet.Add(entry.Id);
            }
        }
        validEntryIds = new List<Id>(validEntryIdsSet);

        /*************************
         * Get the actual results
         *************************/

        if (!error) {
            try {
                results = [SELECT Id,
                                  Name,
                                  Active__c,
                                  Cloned_From__c,
                                  Market_Price_Book__c,
                                  Material_Sales_Data2__c,
                                  Record_Status__c,
                                  Selling_UOM__c,
                                  Uses_Scaled_Pricing__c,
                                  Volume_UOM__c,
                                  Market_Price_Book__r.Id,
                                  Market_Price_Book__r.Name,
                                  Market_Price_Book__r.Active__c,
                                  Market_Price_Book__r.Cloned_From__c,
                                  Market_Price_Book__r.Country_Key__c,
                                  Market_Price_Book__r.Current_State__c,
                                  Market_Price_Book__r.Customer_Group_1_Key__c,
                                  Market_Price_Book__r.Description__c,
                                  Market_Price_Book__r.Dist_Channel_Key__c,
                                  Market_Price_Book__r.Division_Key__c,
                                  Market_Price_Book__r.Valid_From_Date__c,
                                  Market_Price_Book__r.Valid_To_Date__c,
                                  Market_Price_Book__r.Family_Key__c,
                                  Market_Price_Book__r.IncoTerm_Key__c,
                                  Market_Price_Book__r.Manually_Defined_Segmentation_Key__c,
                                  Market_Price_Book__r.PAC_Industry_Segment_Key__c,
                                  Market_Price_Book__r.Product_Line_Key__c,
                                  Market_Price_Book__r.Record_Status__c,
                                  Market_Price_Book__r.Sales_Org_Key__c,
                                  Market_Price_Book__r.Segment_Key__c,
                                  Market_Price_Book__r.Sub_Segment_Key__c,
                                  Market_Price_Book__r.VCP_Rating_Key__c,
                                  Material_Sales_Data2__r.Sales_Org_Code__c,
                                  Material_Sales_Data2__r.SalesOrg_Desc__c,
                                  Material_Sales_Data2__r.Dist_Channel_Code__c,
                                  Material_Sales_Data2__r.Material_Number__c,
                                  Material_Sales_Data2__r.Material_Desc__c,
                                  Material_Sales_Data2__r.Sales_UOM__c,
                                  Material_Sales_Data2__r.Sales_UOM_Desc__c,
                                  Material_Sales_Data2__r.Net_Weight__c,
                                  Material_Sales_Data2__r.Net_Weight_in_LBs__c,
                                  Material_Sales_Data2__r.CurrencyIsoCode,
                                  Material_Sales_Data2__r.Product_Hierarchy__r.PH1_Division__c,
                                  Material_Sales_Data2__r.Product_Hierarchy__r.PH2_Line__c,
                                  Material_Sales_Data2__r.Product_Hierarchy__r.PH3_Group__c,
                                  Material_Sales_Data2__r.Product_Hierarchy__r.PH3__c,
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
                                  (SELECT Id, Cloned_From__c, Floor_Price__c, Maximum_Volume__c, Minimum_Volume__c, Selling_Price__c, Surcharge__c FROM Market_Price_Book_Scaled_Pricing_Entries__r ORDER BY Minimum_Volume__c)
                             FROM Market_Price_Book_Entry__c
                            WHERE Id IN :validEntryIds
                            ORDER BY Market_Price_Book__r.Id
                          ];
            } catch (Exception e) {results = new List<Market_Price_Book_Entry__c>();}
        }
        return results;
    }

    Webservice static List<Market_Price_Book_Entry__c> getEntriesRelatedtoAccount(Id accountId) {
        List<Market_Price_Book_Entry__c> results;
        List<Account_To_Market_Price_Book_Entry__c> relationshipRecs;

        try {
            relationshipRecs = [SELECT Id,
                                       Account__c,
                                       Available_Market_Pricing_Types__c,
                                       Material_Sales_Data2__c,
                                       Market_Price_Book_Entry__c
                                  FROM Account_To_Market_Price_Book_Entry__c
                                 WHERE Account__c = :accountId
                               ];

            System.debug('*** - ' + relationshipRecs);
        }
        catch (Exception e) {relationshipRecs = new List<Account_To_Market_Price_Book_Entry__c>();System.debug('*** Error Getting Relationship Recs');}

        List<Id> entryIds = new List<Id>();

        for (Account_To_Market_Price_Book_Entry__c rec : relationshipRecs) {entryIds.add(rec.Market_Price_Book_Entry__c);}

            System.debug('*** EntryIds - ' + entryIds);

        try {
            results = [SELECT Id,
                              Name,
                              Active__c,
                              Cloned_From__c,
                              Market_Price_Book__c,
                              Material_Sales_Data2__c,
                              Record_Status__c,
                              Selling_UOM__c,
                              Uses_Scaled_Pricing__c,
                              Volume_UOM__c,
                              Market_Price_Book__r.Id,
                              Market_Price_Book__r.Name,
                              Market_Price_Book__r.Active__c,
                              Market_Price_Book__r.Cloned_From__c,
                              Market_Price_Book__r.Country_Key__c,
                              Market_Price_Book__r.Current_State__c,
                              Market_Price_Book__r.Customer_Group_1_Key__c,
                              Market_Price_Book__r.Description__c,
                              Market_Price_Book__r.Dist_Channel_Key__c,
                              Market_Price_Book__r.Division_Key__c,
                              Market_Price_Book__r.Valid_From_Date__c,
                              Market_Price_Book__r.Valid_To_Date__c,
                              Market_Price_Book__r.Family_Key__c,
                              Market_Price_Book__r.IncoTerm_Key__c,
                              Market_Price_Book__r.Manually_Defined_Segmentation_Key__c,
                              Market_Price_Book__r.PAC_Industry_Segment_Key__c,
                              Market_Price_Book__r.Product_Line_Key__c,
                              Market_Price_Book__r.Record_Status__c,
                              Market_Price_Book__r.Sales_Org_Key__c,
                              Market_Price_Book__r.Segment_Key__c,
                              Market_Price_Book__r.Sub_Segment_Key__c,
                              Market_Price_Book__r.VCP_Rating_Key__c,
                              Material_Sales_Data2__r.Sales_Org_Code__c,
                              Material_Sales_Data2__r.SalesOrg_Desc__c,
                              Material_Sales_Data2__r.Dist_Channel_Code__c,
                              Material_Sales_Data2__r.Material_Number__c,
                              Material_Sales_Data2__r.Material_Desc__c,
                              Material_Sales_Data2__r.Sales_UOM__c,
                              Material_Sales_Data2__r.Sales_UOM_Desc__c,
                              Material_Sales_Data2__r.Net_Weight__c,
                              Material_Sales_Data2__r.Net_Weight_in_LBs__c,
                              Material_Sales_Data2__r.CurrencyIsoCode,
                              Material_Sales_Data2__r.Product_Hierarchy__r.PH1_Division__c,
                              Material_Sales_Data2__r.Product_Hierarchy__r.PH2_Line__c,
                              Material_Sales_Data2__r.Product_Hierarchy__r.PH3_Group__c,
                              Material_Sales_Data2__r.Product_Hierarchy__r.PH3__c,
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
                              (SELECT Id, Cloned_From__c, Floor_Price__c, Maximum_Volume__c, Minimum_Volume__c, Selling_Price__c, Surcharge__c FROM Market_Price_Book_Scaled_Pricing_Entries__r ORDER BY Minimum_Volume__c),
                              (SELECT Id, Account__c, Available_Market_Pricing_Types__c, Market_Price_Book_Entry__c FROM Account_to_Market_Price_Book_Entries__r WHERE Account__c = :accountId)
                         FROM Market_Price_Book_Entry__c
                        WHERE Id IN :entryIds
                        ORDER BY Market_Price_Book__r.Id
                      ];
        } catch (Exception e) {results = new List<Market_Price_Book_Entry__c>();}

        return results;
    }

    Webservice static Id relateMarketPriceEntrytoAccount(id marketPriceEntryId, id accountId, String availableMarketPricingTypes) {
        return MarketPriceBookMethods.relateMarketPriceEntrytoAccount(marketPriceEntryId,accountId,availableMarketPricingTypes);
    }

    Webservice static void unrelateMarketPriceEntrytoAccount(id marketPriceEntryId, id accountId) {
        MarketPriceBookMethods.unrelateMarketPriceEntrytoAccount(marketPriceEntryId,accountId);
    }

    webservice static Integer retrieveExistingMarketPriceBookCountforKey(
        String description,
        List<String> salesOrgs,
        List<String> distChannels,
        List<String> divisions,
        List<String> PACIndustrySegments,
        List<String> countries,
        List<String> families,
        List<String> segments,
        List<String> subSegments,
        List<String> incoTerms,
        List<String> custGroup1s,
        List<String> vcpRatings,
        List<String> productLines,
        String manuallyDefinedSegmentationKey,
        Date validFromDate,
        Date validToDate,
        String currencyValue
        ) {

        Integer result;

        /*
        Set<String> salesOrgSet = new Set<String>();
        Set<String> distChannelSet = new Set<String>();
        Set<String> divisionSet = new Set<String>();
        Set<String> PACIndustrySegmentSet = new Set<String>();
        Set<String> countrySet = new Set<String>();
        Set<String> familySet = new Set<String>();
        Set<String> segmentSet = new Set<String>();
        Set<String> subSegmentSet = new Set<String>();
        Set<String> incoTermSet = new Set<String>();
        Set<String> custGroup1Set = new Set<String>();
        Set<String> vcpRatingSet = new Set<String>();
        Set<String> productLineSet = new Set<String>();

        for (String code : salesOrgs) {salesOrgSet.add(rec.Sales_Org_Code__c);}
        for (String code : distChannels) {distChannelSet.add(rec.Distribution_Channel_Code__c);}
        for (String code : divisions) {divisionSet.add(rec.Division_Code__c);}
        for (String code : PACIndustrySegments) {PACIndustrySegmentSet.add(rec.PAC_Industry_Segment_Code__c);}
        for (String code : countries) {countrySet.add(rec.Country_Code__c);}
        for (String code : families) {familySet.add(rec.Family_Code__c);}
        for (String code : segments) {segmentSet.add(rec.Segment_Code__c);}
        for (String code : subSegments) {subSegmentSet.add(rec.Sub_Segment_Code__c);}
        for (String code : incoTerms) {incoTermSet.add(rec.Inco_Term_Code__c);}
        for (String code : custGroup1s) {custGroup1Set.add(rec.Customer_Group1_Code__c);}
        for (String code : vcpRatings) {vcpRatingSet.add(rec.VCP_Rating_Code__c);}
        for (String code : productLines) {productLineSet.add(rec.Product_Line_Code__c);}

        String salesOrgKey = String.join(new List<String>(salesOrgSet),';');
        String distChannelKey = String.join(new List<String>(distChannelSet),';');
        String divisionKey = String.join(new List<String>(divisionSet),';');
        String PACIndustrySegmentKey = String.join(new List<String>(PACIndustrySegmentSet),';');
        String countryKey = String.join(new List<String>(countrySet),';');
        String familyKey = String.join(new List<String>(familySet),';');
        String segmentKey = String.join(new List<String>(segmentSet),';');
        String subSegmentKey = String.join(new List<String>(subSegmentSet),';');
        String incoTermKey = String.join(new List<String>(incoTermSet),';');
        String custGroup1Key = String.join(new List<String>(custGroup1Set),';');
        String vcpRatingKey = String.join(new List<String>(vcpRatingSet),';');
        String productLineKey = String.join(new List<String>(productLineSet),';');
        */

        String salesOrgKey = String.join(salesOrgs,';');
        String distChannelKey = String.join(distChannels,';');
        String divisionKey = String.join(divisions,';');
        String PACIndustrySegmentKey = String.join(PACIndustrySegments,';');
        String countryKey = String.join(countries,';');
        String familyKey = String.join(families,';');
        String segmentKey = String.join(segments,';');
        String subSegmentKey = String.join(subSegments,';');
        String incoTermKey = String.join(incoTerms,';');
        String custGroup1Key = String.join(custGroup1s,';');
        String vcpRatingKey = String.join(vcpRatings,';');
        String productLineKey = String.join(productLines,';');

        result = retrieveExistingMarketPriceBookCountforKey_withDelimitedKeyInfo(
            salesOrgKey,
            distChannelKey,
            divisionKey,
            PACIndustrySegmentKey,
            countryKey,
            familyKey,
            segmentKey,
            subSegmentKey,
            incoTermKey,
            custGroup1Key,
            vcpRatingKey,
            productLineKey
            );

        //Force 1 for testing
        //result = 1;

        return result;
    }

    webservice static Integer retrieveExistingMarketPriceBookCountforKey_withDelimitedKeyInfo(
        String salesOrgKey,
        String distChannelKey,
        String divisionKey,
        String PACIndustrySegmentKey,
        String countryKey,
        String familyKey,
        String segmentKey,
        String subSegmentKey,
        String incoTermKey,
        String custGroup1Key,
        String vcpRatingKey,
        String productLineKey) {

        Integer result;

        System.debug('*** - retrieveExistingMarketPriceBookCountforKey_withDelimitedKeyInfo Keys:');
        System.debug('*** - salesOrgKey = ' + salesOrgKey);
        System.debug('*** - distChannelKey = ' + distChannelKey);
        System.debug('*** - divisionKey = ' + divisionKey);
        System.debug('*** - PACIndustrySegmentKey = ' + PACIndustrySegmentKey);
        System.debug('*** - countryKey = ' + countryKey);
        System.debug('*** - familyKey = ' + familyKey);
        System.debug('*** - segmentKey = ' + segmentKey);
        System.debug('*** - subSegmentKey = ' + subSegmentKey);
        System.debug('*** - incoTermKey = ' + incoTermKey);
        System.debug('*** - custGroup1Key = ' + custGroup1Key);
        System.debug('*** - vcpRatingKey = ' + vcpRatingKey);
        System.debug('*** - productLineKey = ' + productLineKey);

        try {
            List<Market_Price_Book__c> marketPriceBooks =
            MarketPriceBookMethods.getMpbs(
                salesOrgKey,
                distChannelKey,
                divisionKey,
                PACIndustrySegmentKey,
                countryKey,
                familyKey,
                segmentKey,
                subSegmentKey,
                incoTermKey,
                custGroup1Key,
                vcpRatingKey,
                productLineKey);
            result = marketPriceBooks.size();
        }
        catch (Exception e) {
            result = 0;
        }

        return result;
    }

    global class MarketPriceBookStatus {

        MarketPriceBookStatus() {
            this.editable = false;
            this.cloneable = false;
        }

        webservice Boolean editable;
        webservice Boolean cloneable;
    }

    webservice static MarketPriceBookStatus retrieveMarketPriceBookStatus(Id marketPriceBookId) {
        MarketPriceBookStatus result = new MarketPriceBookStatus();

        Market_Price_Book__c marketPriceBook;

        try {
            marketPriceBook = [SELECT Id, Record_Status__c FROM Market_Price_Book__c WHERE Id = :marketPriceBookId];
            if (marketPriceBook.Record_Status__c == 'Draft') {result.editable = true;}
            result.cloneable = true;
        }
        catch (Exception e) {}

        //result.editable = false;
        //result.cloneable = false;

        return result;
    }

    webservice static List<String> availableSalesOrgsForCountry(String countryCode) {
        return XREF_Country_to_SalesOrg.availableSalesOrgsForCountry(countryCode);
    }


}
@isTest
private class ConsumptionObject_TestMethod  {

//*
   static testMethod void myUnitTest() {
   
      List<Consumption__c> conList = new List<Consumption__c>();
      final Integer MAX_LIMIT = 50;
      
      List<Account> accts = new List<Account>();
        
        Map<String, Id> AcctRecTypes = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
        
        Account acct_AD_Chemicals = new Account(Name='AD_Chemicals',
                                                RecordTypeId=AcctRecTypes.get('Aqualon Customer'),
                                                SAP_Division_Desc__c = 'Chemicals');accts.add(acct_AD_Chemicals);
        Account acct_AD_Plastics = new Account(Name='AD_Plastics',
                                                RecordTypeId=AcctRecTypes.get('Aqualon Customer'),
                                                SAP_Division_Desc__c = 'Plastics');accts.add(acct_AD_Plastics);
        Account acct_PM_COMP = new Account(Name='PM_COMP',
                                                RecordTypeId=AcctRecTypes.get('Aqualon Customer'),
                                                SAP_Division_Desc__c = 'Composite Polymers');accts.add(acct_PM_COMP);
                                                        
        insert accts;



      
      //Get the Consumption Record Type IDs
      
      String distributionChemicals_RecordType = RecordType_Functions.LookupRecordTypeId('Distribution Chemicals','Consumption__c');
      String distributionPlastics_RecordType = RecordType_Functions.LookupRecordTypeId('Distribution Plastics','Consumption__c');
      String PMChina_RecordType = RecordType_Functions.LookupRecordTypeId('PM China','Consumption__c');
      
      String DistributionCustomer_RecordType = RecordType_Functions.LookupRecordTypeId('Aqualon Customer','Account');
      String PMCustomer_RecordType = RecordType_Functions.LookupRecordTypeId('Aqualon Customer','Account');
      

        System.debug('distchemicalsrecordtype='+distributionChemicals_RecordType);
        System.debug('distplasticsrecordtype='+distributionPlastics_RecordType);
        System.debug('pmchinarecordtype='+PMChina_RecordType);
      
      for (Integer i = 0; i < MAX_LIMIT; i++)  {

          Consumption__c c1 = new Consumption__c();
          Consumption__c c2 = new Consumption__c();
          Consumption__c c3 = new Consumption__c();
          Consumption__c c4 = new Consumption__c();
          Consumption__c c5 = new Consumption__c();
          
          // Distribution Plastics Consumption 1
          c1.account_name__c = acct_AD_Plastics.Id;
          c1.RecordTypeId = distributionPlastics_RecordType;
          c1.annual_usage_t_y__c = 100;
          c1.product_group__c = 'LCP';
          c1.current_supplier_producer__c = 'AERC';
          c1.market__c = 'Household';
          c1.technology_activity__c = 'Cast film';
          c1.other_material_in_use__c = 'My Material';
          conList.add(c1);
    
          // Distribution Plastics Consumption 2
          c2.account_name__c = acct_AD_Plastics.Id;
          c2.RecordTypeId = distributionPlastics_RecordType;
          c2.annual_usage_t_y__c = 100;
          c2.product_group__c = 'LCP';
          c2.current_supplier_producer__c = 'AERC';
          c2.market__c = 'Household';
          c2.technology_activity__c = 'Cast film';
          c2.other_material_in_use__c = 'My Material';
          conList.add(c2);
    
          // Distribution Chemicals Consumption 1
          c3.account_name__c = acct_AD_Chemicals.Id;    
          c3.RecordTypeId = distributionChemicals_RecordType;
          c3.family__c = 'Acids';
          c3.market__c = 'Offshore';
          c3.technology__c = 'Jobbers';
          c3.other_material_in_use__c = 'My Material';      
          conList.add(c3);
          
          // Distribution Chemicals Consumption 2
          c4.account_name__c = acct_AD_Chemicals.Id;   
          c4.RecordTypeId = distributionChemicals_RecordType;
          c4.family_other__c = 'My Family Value';
          c4.market__c = 'Offshore';
          c4.technology__c = 'Jobbers';
          //c4.ashland_material_in_use__c = m.Id;    
          c4.current_supplier_producer_other__c = 'Unknown Supplier';
          conList.add(c4);
          
          // Performance Materials China Consumption 1
          c5.account_name__c = acct_PM_COMP.Id;   
          c5.RecordTypeId = PMChina_RecordType;
          c5.Price__c = 2.2565;
          c5.annual_usage_volume__c = 500000;
          //c5.ashland_material_in_use__c = m.Id;    
          c5.current_supplier_producer_other__c = 'Unknown Supplier';
          conList.add(c5);

          
      }
      
      insert(conList);
   
   }
//*/   
    static testMethod void test02() {
        ConsumptionExtension c = new ConsumptionExtension(null);
        c.getAqualonConsumptionInformationSectionRendered();
        c.getAWTConsumptionInformationSectionRendered();
        c.getAWTMarketKnowledgeRendered();
        c.getBrandName();
        c.getBrandNameFieldDisabled();
        c.getBrandNames();
        c.getChemClass();
        c.getChemSubClass1();
        c.getChemSubClass2();
        c.getCompetitiveDataSectionRendered();
        c.getConsumptionObject();
        c.getDescInfoCommentsSectionRendered();
        c.getDescInfoSectionRendered();
        c.getDistribChemicalsInfoSectionRendered();
        c.getDistribChemMrktKnwldgRendered();
        c.getDistribCompositesInfoSectionRendered();
        c.getDRTKCnsmptnInfoSectionRendered();
        c.getDRTKMrktKnwldgRendered();
        c.getDRTKQualityMngdRendered();
        c.getDstrbCmpstsMrktKnwldgRendered();
        c.getDstrbPlstcsMrktKnwldgRendered();
        c.getGrade();
        c.getIndustries();
        c.getIndustry();
        c.getOtherBrandName();
        c.getOtherBrandNameFieldDisabled();
        c.getPMChinaInfoSectionRendered();
        c.getPMChinaMrktKnwldgRendered();
        c.getPriceRequired();
        c.getProductFunction();
        c.getProductFunctions();
        c.getRecordTypeId();
        c.getRecordTypeName();
        c.getSBUProduct();
        c.getSupplier();
        c.getSysInfoWithRecordSourceSectionRendered();
        c.getSystemInformationSectionRendered();
        c.getVolumeMTasSoldorWetSectionRendered();
        Consumption_Competitive_Product__c ccp = new Consumption_Competitive_Product__c();
        String s = 'test';
        ccp.Brand_Name__c = s;
        ccp.Chem_Class__c = s;
        ccp.Chem_SubClass1__c = s;
        ccp.Chem_SubClass2__c = s;
        ccp.Grade__c = s;
        ccp.Industry__c = s;
        ccp.Product_Function__c = s;
        ccp.SBU_Product__c = s;
        ccp.Supplier__c = s;
        insert ccp;
        c.setChemClass(null); c.setChemClass(s);
        c.setChemSubClass1(null); c.setChemSubClass1(s);
        c.setChemSubClass2(null); c.setChemSubClass2(s);
        c.setGrade(null); c.setGrade(s);
        c.setIndustry(null); c.setIndustry(s);
        c.setOtherBrandName(null); c.setOtherBrandName(s);
        c.setProductFunction(null); c.setProductFunction(s);
        c.setSBUProduct(null); c.setSBUProduct(s);
        c.setSupplier(null); c.setSupplier(s);
        c.setBrandName(null); c.setBrandName(s);
    }
}
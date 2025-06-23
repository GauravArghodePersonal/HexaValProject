@isTest(SeeAllData=false)
private class MarketPriceBookMethods_T {

    static ApexPages.Severity ERROR = ApexPages.Severity.ERROR;
    static Date tdate       = Date.today(), ydate = tdate - 1;
    static Id myUserId      = UserInfo.getUserId();


    static String ACTIVE    = MarketPriceBookMethods.ACTIVE;
    static String APPROVED  = MarketPriceBookMethods.APPROVED;

    static String sorg      = '1021', soDesc = 'ASI';
    static String dchan     = '50',   dcDesc = 'ASI';
    static String divsn     = '50',   dvDesc = 'ASI';
    static String cgrp      = '1X',   cgDesc = 'OIL and GAS';
    static String street    = '1234 Street';
    static String city      = 'City';
    static String state     = 'ST';
    static String zip       = '12345';
    static String country   = 'USA';
    static String uomLB     = 'LB';
    static String uomGLL    = 'GLL';
    static String cpiRT1    = '1';
    static String soldToNum = 'MPBSoldToA';
    static String soldToKey = soldToNum + sorg + dchan + divsn;
    static String shipToNum = 'MPBShipToA';
    static String shipToKey = shipToNum + sorg + dchan + divsn;
    static String custMatA  = 'MPBCMatA';
    static String custMatB  = 'MPBCMatB';
    static String matNumA   = '00000000000MPBMatA';
    static String matKeyA   = matNumA + sorg + dchan;
    static String matNumB   = '00000000000MPBMatB';
    static String matKeyB   = matNumB + sorg + dchan;
    static String matNumC   = '00000000000MPBMatC';
    static String matKeyC   = matNumC + sorg + dchan;
    static String muomKeyA  = matNumA + uomLB;
    static String muomKeyA2 = matNumA + uomGLL;
    static String muomKeyB  = matNumB + uomLB;
    static String muomKeyB2 = matNumB + uomGLL;
    static String cpiKeyA   = cpiRT1+ sorg + dchan + soldToNum + shipToNum + custMatA + matNumA;
    static String cpiKeyB   = cpiRT1+ sorg + dchan + soldToNum + shipToNum + custMatB + matNumB;

    static Account                                          soldTo, shipTo;
    static Account_To_Market_Price_Book_Entry__c            ampbe1, ampbe2;
    static Customer_Product_Info__c                         cpiA, cpiB;
    static Market_Price_Book__c                             mpb1, mpb2;
    static Market_Price_Book_Entry__c                       mpbe1, mpbe2;
    static Market_Price_Book_Scaled_Pricing_Entry__c        mpbes1, mpbes2;
    static Market_Price_Book_Work_When_Approved__c          mpbw1, mpbw2;
    static Material_Description__c                          mdscA, mdscB, mdscC;
    static Material_Determination_ShipTo__c                 mdshA;
    static Material_General_Data2__c                        mgd2A, mgd2B, mgd2C;
    static Material_Sales_Data2__c                          msd2A, msd2B;
    static Material_Substitution__c                         msubA;
    static Material_UOM2__c                                 muomA, muomB;
    static Pricing_Condition__c                             pc1, pc2;
    static Pricing_Condition_Scaled_Pricing__c              pcsp1, pcsp2;
    static Product_Hierarchy2__c                            ph2;
    static SAP_ECOM_Customer__c                             ecomCust;
    static SAP_Plant__c                                     plant;
    static SAP_UOM_Description__c                           uomDesc;

    static List<Account_To_Market_Price_Book_Entry__c>      ampbes;
    static List<Market_Price_Book_Work_When_Approved__c>    mpbws;
    static List<Pricing_Condition__c>                       pcs;
    static List<Pricing_Condition_Scaled_Pricing__c>        pcsps;

    static Set<Id>                                          mpbIds;
    static Map<String, String>                              pageParams;

    static void debug(String s) {System.debug(LoggingLevel.INFO, '>>>>>>>>> MarketPriceBookMethods_T : ' + s);}

    static void showPageMsgs() {
        if (!ApexPages.hasMessages()) {return;}
        for (ApexPages.Message m : ApexPages.getMessages()) {debug(m.getSummary());}
    }

    private static void setup1() {
        //MarketPriceBookMethods.setDebugMode(true);
        ph2 = Product_Hierarchy_Functions_Test.getTestProdHerky2(dchan);
        // --------------------------------------------------------------------------------------------------
        soldTo = new Account(Name='MPB SoldTo A', AccountNumber=soldToNum, Account_Number__c=soldToKey,
                             SAP_Customer_Number__c=soldToNum, Ship_To_Customer_Number__c=soldToNum,
                             SAP_Sales_Org__c=sorg, SAP_Sales_Org_Desc__c=soDesc,
                             SAP_DistChannel__c=dchan, SAP_Dist_Channel_Desc__c=dcDesc,
                             SAP_DivisionCode__c=divsn, SAP_Division_Desc__c=dvDesc,
                             SAP_Customer_Group__c=cgrp, SAP_Customer_Group_Desc__c=cgDesc,
                             SAP_Street__c=street, SAP_City__c=city, SAP_State__c=state,
                             SAP_Zip_Code__c=zip, SAP_Country__c=country);
        shipTo = new Account(Name='MPB ShipTo A', AccountNumber=shipToNum, Account_Number__c=shipToKey,
                             SAP_Customer_Number__c=shipToNum, Ship_To_Customer_Number__c=shipToNum,
                             SAP_Sales_Org__c=sorg, SAP_Sales_Org_Desc__c=soDesc,
                             SAP_DistChannel__c=dchan, SAP_Dist_Channel_Desc__c=dcDesc,
                             SAP_DivisionCode__c=divsn, SAP_Division_Desc__c=dvDesc,
                             SAP_Customer_Group__c=cgrp, SAP_Customer_Group_Desc__c=cgDesc,
                             SAP_Street__c=street, SAP_City__c=city, SAP_State__c=state,
                             SAP_Zip_Code__c=zip, SAP_Country__c=country);
        soldTo = SObject_Services.upsertAccount(soldTo); shipTo.ParentId = soldTo.Id;
        shipTo = SObject_Services.upsertAccount(shipTo);
        // --------------------------------------------------------------------------------------------------
        ecomCust = new SAP_ECOM_Customer__c();
        ecomCust.Ship_To__c = shipTo.Id; ecomCust.Sold_To__c = soldTo.Id;
        ecomCust.Key__c = soldToNum + '-' + shipToNum;
        ecomCust = SObject_Services.upsertEcomCust(ecomCust);
        // --------------------------------------------------------------------------------------------------
        uomDesc = new SAP_UOM_Description__c(External_UOM__c='KG', UOM_Code__c='KG',
                                             UOM_Description__c='Kilogram');
        uomDesc = SObject_Services.upsertUomDesc(uomDesc);

        uomDesc = new SAP_UOM_Description__c(External_UOM__c='LB', UOM_Code__c='LB',
                                             UOM_Description__c='US pound');
        uomDesc = SObject_Services.upsertUomDesc(uomDesc);
        // --------------------------------------------------------------------------------------------------
        mdscA = new Material_Description__c(Material_Number__c=matNumA, Material_Description__c='Material A');
        mdscA = SObject_Services.upsertMatDesc(mdscA);

        mdscB = new Material_Description__c(Material_Number__c=matNumB, Material_Description__c='Material B');
        mdscB = SObject_Services.upsertMatDesc(mdscB);

        mdscC = new Material_Description__c(Material_Number__c=matNumC, Material_Description__c='Material C');
        mdscC = SObject_Services.upsertMatDesc(mdscC);
        // --------------------------------------------------------------------------------------------------
        mgd2A = new Material_General_Data2__c(Material_Number__c=matNumA, Material_Desc_Code__c=mdscA.Id,
                                              Net_Weight__c=10);
        mgd2A = SObject_Services.upsertMgd2(mgd2A);

        mgd2B = new Material_General_Data2__c(Material_Number__c=matNumB, Material_Desc_Code__c=mdscB.Id,
                                              Net_Weight__c=20);
        mgd2B = SObject_Services.upsertMgd2(mgd2B);

        mgd2C = new Material_General_Data2__c(Material_Number__c=matNumC, Material_Desc_Code__c=mdscC.Id,
                                              Net_Weight__c=30);
        mgd2C = SObject_Services.upsertMgd2(mgd2C);
        // --------------------------------------------------------------------------------------------------
        muomA = new Material_UOM2__c(Alternative_UOM__c=uomGLL, Material_Number__c=matNumA,
                                     Material_General_Data__c=mgd2A.Id,
                                     Denominator__c=10, Numerator__c=48, Record_Key__c=muomKeyA2);
        muomA = SObject_Services.upsertMuom2(muomA);

        muomA = new Material_UOM2__c(Alternative_UOM__c=uomLB, Material_Number__c=matNumA,
                                     Material_General_Data__c=mgd2A.Id,
                                     Denominator__c=1, Numerator__c=1, Record_Key__c=muomKeyA);
        muomA = SObject_Services.upsertMuom2(muomA);

        muomB = new Material_UOM2__c(Alternative_UOM__c=uomGLL, Material_Number__c=matNumB,
                                     Material_General_Data__c=mgd2B.Id,
                                     Denominator__c=10, Numerator__c=48, Record_Key__c=muomKeyB2);
        muomB = SObject_Services.upsertMuom2(muomB);

        muomB = new Material_UOM2__c(Alternative_UOM__c=uomLB, Material_Number__c=matNumB,
                                     Material_General_Data__c=mgd2B.Id,
                                     Denominator__c=1, Numerator__c=1, Record_Key__c=muomKeyB);
        muomB = SObject_Services.upsertMuom2(muomB);
        // --------------------------------------------------------------------------------------------------
        msd2A = new Material_Sales_Data2__c(Active_Material__c = 'Y', Material_Number__c=matNumA,
                                            Record_Key__c=matKeyA, Sales_Org_Code__c=sorg,
                                            Dist_Channel_Code__c=dchan, Product_Hierarchy__c = ph2.Id,
                                            Material_General_Data__c=mgd2A.Id, Sales_UOM__c=muomA.Id);
        msd2A = SObject_Services.upsertMsd2(msd2A);

        msd2B = new Material_Sales_Data2__c(Active_Material__c = 'Y', Material_Number__c=matNumB,
                                            Record_Key__c=matKeyB, Sales_Org_Code__c=sorg,
                                            Dist_Channel_Code__c=dchan, Product_Hierarchy__c = ph2.Id,
                                            Material_General_Data__c=mgd2B.Id, Sales_UOM__c=muomB.Id);
        msd2B = SObject_Services.upsertMsd2(msd2B);
        // --------------------------------------------------------------------------------------------------
        mpb1 = new Market_Price_Book__c(Active__c=true,  Current_State__c=ACTIVE,   Record_Status__c=ACTIVE,
                                        Valid_From_Date__c=tdate, Valid_To_Date__c=tdate);
        mpb2 = new Market_Price_Book__c(Active__c=false, Current_State__c=APPROVED, Record_Status__c=APPROVED,
                                        Valid_From_Date__c=tdate, Valid_To_Date__c=tdate);
        insert mpb1; insert mpb2; mpbIds = new Set<Id>{mpb1.Id, mpb2.Id};
        mpb1 = MarketPriceBookMethods.getMpb(mpb1.Id);

        mpbe1 = new Market_Price_Book_Entry__c(); mpbe2 = new Market_Price_Book_Entry__c();

        mpbe1.Market_Price_Book__c = mpb1.Id; mpbe1.Material_Sales_Data2__c = msd2A.Id; insert mpbe1;
        mpbe2.Market_Price_Book__c = mpb2.Id; mpbe2.Material_Sales_Data2__c = msd2A.Id; insert mpbe2;
        // --------------------------------------------------------------------------------------------------
        ampbe1 = new Account_To_Market_Price_Book_Entry__c(Account__c=shipTo.Id, Market_Price_Book_Entry__c=mpbe1.Id,
                                                           Material_Sales_Data2__c = msd2A.Id);
        ampbe2 = new Account_To_Market_Price_Book_Entry__c(Account__c=shipTo.Id, Market_Price_Book_Entry__c=mpbe2.Id,
                                                           Material_Sales_Data2__c = msd2A.Id);
        ampbes = new List<Account_To_Market_Price_Book_Entry__c>{ampbe1, ampbe2}; insert ampbes;
        // --------------------------------------------------------------------------------------------------
        mpbes1 = new Market_Price_Book_Scaled_Pricing_Entry__c(Market_Price_Book_Entry__c=mpbe1.Id,
                                                               Minimum_Volume__c=0, Maximum_Volume__c=1000,
                                                               Quantity_Surcharge__c=0.1,Selling_Price__c=1.1);
        mpbes2 = new Market_Price_Book_Scaled_Pricing_Entry__c(Market_Price_Book_Entry__c=mpbe2.Id,
                                                               Minimum_Volume__c=0, Maximum_Volume__c=2000,
                                                               Quantity_Surcharge__c=0.2,Selling_Price__c=2.2);
        insert mpbes1; insert mpbes2;
        mpbe1 = MarketPriceBookMethods.getMpbe(mpbe1.Id); mpbe2 = MarketPriceBookMethods.getMpbe(mpbe2.Id);
        // --------------------------------------------------------------------------------------------------
        plant = PricingConditionFunctions_Test.getPlant();
        pc1 = PricingConditionFunctions_Test.getPc1(shipTo, msd2A, plant, mpbe1.Id);
        pc2 = PricingConditionFunctions_Test.getPc1(shipTo, msd2A, plant, mpbe2.Id);
        pcs = new List<Pricing_Condition__c>{pc1, pc2};
        pcsp1 = PricingConditionFunctions_Test.getPcsp1(pc1);
        pcsp2 = PricingConditionFunctions_Test.getPcsp1(pc2);
        pc1 = PricingConditionFunctions.getPricingCondition(pc1.Id);
        pc2 = PricingConditionFunctions.getPricingCondition(pc2.Id);
        // --------------------------------------------------------------------------------------------------
        mpbw1 = new Market_Price_Book_Work_When_Approved__c(Market_Price_Book__c=mpb1.Id, Pricing_Condition__c=pc1.Id);
        mpbw2 = new Market_Price_Book_Work_When_Approved__c(Market_Price_Book__c=mpb2.Id, Pricing_Condition__c=pc2.Id);
        mpbws = new List<Market_Price_Book_Work_When_Approved__c>{mpbw1, mpbw2}; insert mpbws;
    }

//*
    private static testMethod void test01() {
        setup1(); Test.startTest();

        MarketPriceBookMethods.relateMarketPriceEntrytoAccount(mpbe1.Id, shipTo.Id, 'softWired');
        MarketPriceBookMethods.relateMarketPriceEntrytoAccount(mpbe1.Id, shipTo.Id, 'softWired');

        MarketPriceBookMethods.unrelateMarketPriceEntrytoAccount(mpbe1.Id, shipTo.Id);
        MarketPriceBookMethods.unrelateMarketPriceEntrytoAccount(mpbe1.Id, shipTo.Id);

        MarketPriceBookMethods.expire(mpb1.Id);
        MarketPriceBookMethods.canBeExpired(mpb1.Id);
        MarketPriceBookMethods.unexpireAndMakeDraft(mpb1.Id);
        MarketPriceBookMethods.canBeExpired(mpb1.Id);

        MarketPriceBookMethods.canBeUnexpired(mpb1.Id);
        MarketPriceBookMethods.expire(mpb1.Id);
        MarketPriceBookMethods.canBeUnexpired(mpb1.Id);
        MarketPriceBookMethods.unexpireAndMakeDraft(mpb1.Id);

        MarketPriceBookMethods.getMpbWrkQry();
        MarketPriceBookMethods.getPcnQry();
        MarketPriceBookMethods.getAccMpbeQry();
        MarketPriceBookMethods.isExpiredByClone(mpb1);
        MarketPriceBookMethods.getMpbList();
        MarketPriceBookMethods.getMpbePcnList();
        List<String> alist = new List<String>{mpbe1.Id};
        MarketPriceBookMethods.getMpbeMap(alist);
    }

    private static testMethod void test02() {
        setup1(); Test.startTest();

        MarketPriceBookMethods.isChanged(mpbe1, mpbe2);
        mpbIds = new Set<Id>{mpb1.Id}; MarketPriceBookMethods.getAccMpbes(mpbIds);
        MarketPriceBookMethods.setMatchingMpbsToExpire(mpbIds);
        mpbIds = new Set<Id>{mpb2.Id}; MarketPriceBookMethods.activateMpbs(mpbIds);
        mpbIds = new Set<Id>{mpb1.Id};
        mpb1.Valid_From_Date__c = ydate; mpb1.Valid_To_Date__c = ydate; update mpb1;
        MarketPriceBookMethods.expireMpbs(mpbIds);

        Test.stopTest();
    }

    private static testMethod void test03() {
        setup1(); Test.startTest();

        Set<Id> pcnIds = new Set<Id>{pc2.Id};
        MarketPriceBookMethods.processMpbWrkPcns(pcnIds);
        Set<Id> wrkIds = new Set<Id>{mpbw2.Id};
        MarketPriceBookMethods.processMpbWrks(wrkIds);
        mpbe1.Expired_By__c = mpbe2.Id; update mpbe1;
        MarketPriceBookMethods.setToExpire(mpb1);
        mpb1.Expired_By__c = mpb2.Id;  update mpb1;
        pcnIds = new Set<Id>{pc1.Id};
        pc1.Record_Status__c = 'Active';
        pc1.Market_Pricing_Adjustment_Type__c = 'softWired';
        pcsps = new List<Pricing_Condition_Scaled_Pricing__c>();
        MarketPriceBookMethods.getClonedPcn(pc1, mpbe1, pcsps);
        MarketPriceBookMethods.processPcns(pcnIds);
        MarketPriceBookMethods.expirePcns(pcnIds);
        Set<String> sset = new Set<String>{pc1.Id};
        MarketPriceBookMethods.recallPcns(sset);
        MarketPriceBookMethods.submitPcnsForApproval(sset);

        Test.stopTest();
    }

    private static testMethod void test04() {
        setup1(); Test.startTest();

        mpbe1.Expired_By__c = mpbe2.Id; update mpbe1;
        MarketPriceBookMethods.setToExpire(mpb1);
        mpb1.Expired_By__c = mpb2.Id;  update mpb1;
        Set<Id> ids = new Set<Id>{ampbe1.Id};
        MarketPriceBookMethods.processAccMpbes(ids);

        Test.stopTest();
    }
//*/

    private static void runSteps(MarketPriceBookListController c) {
        c.selectRows(c.mpbList);   c.activateMpbs();
        c.selectRows(c.mpbList);   c.expireMpbs();
        c.selectRows(c.wrkList);   c.processWrks();
        c.selectRows(c.pcnList);   c.processPcns();
        c.selectRows(c.ampbeList); c.processAmpbes();
    }

    private static testMethod void test05() {
        setup1(); Test.startTest();

        MarketPriceBookListController c = new MarketPriceBookListController(null);
        c.initAction(); c.mpbId = mpb1.Id; c.debugMode = true; c.addInfoMsg('');
        c.searchMpbes(); c.searchMpbes1(); c.searchAmpbes(); c.searchAmpbes1();
        c.searchPcns(); c.searchPcns1(); c.searchWrks(); c.searchWrks1();

        c.batchJob = false; runSteps(c); c.batchJob = true; runSteps(c);

        c.pc1Frst(); c.pc1Next(); c.pc1Prev(); c.pc1Last(); c.pc1Size();
        c.pc2Frst(); c.pc2Next(); c.pc2Prev(); c.pc2Last(); c.pc2Size();
        c.pc3Frst(); c.pc3Next(); c.pc3Prev(); c.pc3Last(); c.pc3Size();
        c.pc5Frst(); c.pc5Next(); c.pc5Prev(); c.pc5Last(); c.pc5Size();
        c.pc7Frst(); c.pc7Next(); c.pc7Prev(); c.pc7Last(); c.pc7Size();

        c.submitAllJobs();

        Test.stopTest();
    }
}
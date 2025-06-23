@isTest(SeeAllData=false)
private class IRF_Test {

    static ApexPages.Severity ERROR = ApexPages.Severity.ERROR;
    static Date tdate       = Date.today();
    
    static String sorg      = '1020', soDesc = 'HERCULES INCORPORATE';
    static String dchan     = '10',   dcDesc = 'AHWT';
    static String divsn     = '11',   dvDesc = 'AHWT';
    static String cgrp      = '1X',   cgDesc = 'OIL and GAS';
    static String street    = '1234 Street';
    static String city      = 'City';
    static String state     = 'ST';
    static String zip       = '12345';
    static String country   = 'USA';
    static String uomLB     = 'LB';
    static String uomGLL    = 'GLL';
    static String cpiRT1    = '1';
    static String soldToNum = 'IRFSoldToA';
    static String soldToKey = soldToNum + sorg + dchan + divsn;
    static String shipToNum = 'IRFShipToA';
    static String shipToKey = shipToNum + sorg + dchan + divsn;
    static String custMatA  = 'IRFCMatA';
    static String custMatB  = 'IRFCMatB';
    static String matNumA   = '00000000000IRFMatA';
    static String matKeyA   = matNumA + sorg + dchan;
    static String matNumB   = '00000000000IRFMatB';
    static String matKeyB   = matNumB + sorg + dchan;
    static String matNumC   = '00000000000IRFMatC';
    static String matKeyC   = matNumC + sorg + dchan;
    static String muomKeyA  = matNumA + uomLB;
    static String muomKeyA2 = matNumA + uomGLL;
    static String muomKeyB  = matNumB + uomLB;
    static String muomKeyB2 = matNumB + uomGLL;
    static String cpiKeyA   = cpiRT1+ sorg + dchan + soldToNum + shipToNum + custMatA + matNumA;
    static String cpiKeyB   = cpiRT1+ sorg + dchan + soldToNum + shipToNum + custMatB + matNumB;
    
    static Account                          soldTo, shipTo;
    static Customer_Product_Info__c         cpiA, cpiB;
    static Material_Description__c          mdscA, mdscB, mdscC;
    static Material_Determination_ShipTo__c mdshA;
    static Material_General_Data2__c        mgd2A, mgd2B, mgd2C;
    static Material_Sales_Data2__c          msd2A, msd2B;
    static Material_Substitution__c         msubA;
    static Material_UOM2__c                 muomA, muomB;
    static Open_Orders__c                   opnOrdrA, opnOrdrB;
    static Sales_Order_Deliveries__c        ordrDlvryA, ordrDlvryB;
    static SAP_ECOM_Customer__c             ecomCust;
    static SAP_UOM_Description__c           uomDesc;

    static Invoicing_Report_Form__c         irf;
    static IRF_Material__c                  irfMat;
    static IRF_Unit__c                      irfUnt;
    
    static IRF_Monthly_Data__c              imd;
    static IRF_Monthly_Material__c          imdMat;
    static IRF_Monthly_Unit__c              imdUnt;
    
    static Map<String, String>              pageParams;
    
    static void debug(String s) {System.debug(LoggingLevel.INFO, '>>>>>>>>> IRF_Test : ' + s);}
    
    static void showPageMsgs() {
        if (!ApexPages.hasMessages()) {return;}
        for (ApexPages.Message m : ApexPages.getMessages()) {debug(m.getSummary());}
    }
    
    static void setup1() {
        // --------------------------------------------------------------------------------------------------
    	soldTo = new Account(Name='IRF SoldTo A', AccountNumber=soldToNum, Account_Number__c=soldToKey, 
    	                     SAP_Customer_Number__c=soldToNum, Ship_To_Customer_Number__c=soldToNum,
    	                     SAP_Sales_Org__c=sorg, SAP_Sales_Org_Desc__c=soDesc,
    	                     SAP_DistChannel__c=dchan, SAP_Dist_Channel_Desc__c=dcDesc,
    	                     SAP_DivisionCode__c=divsn, SAP_Division_Desc__c=dvDesc,
    	                     SAP_Customer_Group__c=cgrp, SAP_Customer_Group_Desc__c=cgDesc,
    	                     SAP_Street__c=street, SAP_City__c=city, SAP_State__c=state,
    	                     SAP_Zip_Code__c=zip, SAP_Country__c=country);
        shipTo = new Account(Name='IRF ShipTo A', AccountNumber=shipToNum, Account_Number__c=shipToKey, 
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
    	                                    Dist_Channel_Code__c=dchan,  
    	                                    Material_General_Data__c=mgd2A.Id, Sales_UOM__c=muomA.Id); 
    	msd2A = SObject_Services.upsertMsd2(msd2A);

        msd2B = new Material_Sales_Data2__c(Active_Material__c = 'Y', Material_Number__c=matNumB, 
                                            Record_Key__c=matKeyB, Sales_Org_Code__c=sorg, 
                                            Dist_Channel_Code__c=dchan,  
                                            Material_General_Data__c=mgd2B.Id, Sales_UOM__c=muomB.Id); 
        msd2B = SObject_Services.upsertMsd2(msd2B);
        // --------------------------------------------------------------------------------------------------
        cpiA = new Customer_Product_Info__c(CPI_Record_Type__c=cpiRT1, Material_Number__c=matNumA, 
                                            Sales_Org_Code__c=sorg, Distribution_Channel_Code__c=dchan,
                                            Customer_Number__c=soldToNum, ShipTo_Number__c=shipToNum,
                                            Customer_Material_Number__c=custMatA, Record_Key__c=cpiKeyA,
                                            Primary_Indicator__c='X'); 
        cpiA = SObject_Services.upsertCpi(cpiA);

        cpiB = new Customer_Product_Info__c(CPI_Record_Type__c=cpiRT1, Material_Number__c=matNumB, 
                                            Sales_Org_Code__c=sorg, Distribution_Channel_Code__c=dchan,
                                            Customer_Number__c=soldToNum, ShipTo_Number__c=shipToNum,
                                            Customer_Material_Number__c=custMatB, Record_Key__c=cpiKeyB,
                                            Primary_Indicator__c='X'); 
        cpiB = SObject_Services.upsertCpi(cpiB);
        // --------------------------------------------------------------------------------------------------
        mdshA = new Material_Determination_ShipTo__c(Application__c='A', Condition_Record_Number__c=shipToNum,
                                            Determination_Type__c=sorg, Material_Number__c=matNumA,
                                            Record_Key__c=matKeyA, Shipto_Party__c=shipToNum); 
        mdshA = SObject_Services.upsertMdetShip(mdshA);
        // --------------------------------------------------------------------------------------------------
        msubA = new Material_Substitution__c(Condition_Record_Number__c=shipToNum, Substitute_Material__c=matNumC); 
        msubA = SObject_Services.upsertMatSubst(msubA);
        // --------------------------------------------------------------------------------------------------
        opnOrdrA = new Open_Orders__c(Key__c='OpenOrderA',Material__c=msd2A.Id,ShipTo__c=shipTo.Id,
                                      Line_Item_Number__c='0001',Sales_Order_Number__c='0001',
                                      Sales_Doc_Type__c='ZCCF');
        opnOrdrA = SObject_Services.upsertOpenOrder(opnOrdrA);
        
        opnOrdrB = new Open_Orders__c(Key__c='OpenOrderB',Material__c=msd2b.Id,ShipTo__c=shipTo.Id,
                                      Line_Item_Number__c='0001',Sales_Order_Number__c='0001',
                                      Sales_Doc_Type__c='ZCCF');
        opnOrdrB = SObject_Services.upsertOpenOrder(opnOrdrB);
        // --------------------------------------------------------------------------------------------------
        ordrDlvryA = new Sales_Order_Deliveries__c(ShipTo__c=shipTo.Id, Material__c=msd2A.Id, Open_Orders__c=opnOrdrA.Id,
                                                   Record_Key__c='OrdrDlvryA', Actual_Goods_Issue_Date_Text__c='2013-11-01',
                                                   Quantity_Shipped_in_BU__c=1000, UOM_Quantity_Shipped_in_BU__c='KG');
        ordrDlvryA = SObject_Services.upsertOrderDelivery(ordrDlvryA);

        ordrDlvryB = new Sales_Order_Deliveries__c(ShipTo__c=shipTo.Id, Material__c=msd2A.Id, Open_Orders__c=opnOrdrA.Id,
                                                   Record_Key__c='OrdrDlvryB', Actual_Goods_Issue_Date_Text__c='2013-11-02',
                                                   Quantity_Shipped_in_BU__c=2000, UOM_Quantity_Shipped_in_BU__c='KG');
        ordrDlvryB = SObject_Services.upsertOrderDelivery(ordrDlvryB);
    }
    
    static void setup2() {
    	IRF_Material m = new IRF_Material();
    	m = new IRF_Material(msd2A); m = new IRF_Material(ordrDlvryA, 1);
    	IRF_Monthly_Unit mu; SObject sobj;
    	
    	irf = new Invoicing_Report_Form__c(); 
        initIrf(); 
        
        insert irf;

        List<IRF_Material__c> irfMats = new List<IRF_Material__c>();
    	irfMat = new IRF_Material__c(); initIrfMat(); irfMat.IRF__c = irf.Id; 
    	irfMat.Material__c = msd2A.Id; 
        //irfMat.Material__r = msd2A; 
        //Uncomment
    	//irfMat.Parent_Material__c = mgd2A.Id; irfMat.Parent_Material__r = mgd2A;
    	irfMat.Parent_Material_Desc__c = mgd2A.Material_Description__c;
    	irfMat.Parent_Material_Number__c = mgd2A.Material_Number__c;
    	irfMats.add(irfMat); irfMats.add(irfMat.clone()); irfMats.add(irfMat.clone());
    	insert irfMats; 
        m = new IRF_Material(irfMat);

        List<IRF_Unit__c> irfUnts = new List<IRF_Unit__c>();
    	irfUnt = new IRF_Unit__c(); initIrfUnt(); irfUnt.IRF__c = irf.Id; 
    	irfUnts.add(irfUnt); irfUnts.add(irfUnt.clone()); irfUnts.add(irfUnt.clone());
    	insert irfUnts; sobj = irfUnt; mu = new IRF_Monthly_Unit(sobj, 1);
    }
    
    static void setup3() {
        IRF_Monthly_Data md = new IRF_Monthly_Data(); 
        IRF_Monthly_Material mm; IRF_Monthly_Unit mu; SObject sobj;
        
        imd = new IRF_Monthly_Data__c(); initImd(); 
        imd.IRF__c = irf.Id; insert imd;
        sobj = irfMat; mm = new IRF_Monthly_Material(imd, sobj, 1);

        imdMat = new IRF_Monthly_Material__c(); initImdMat();
        imdMat.IRF_Monthly_Data__c = imd.Id; 
        imdMat.IRF_Material__c = irfMat.Id; imdMat.IRF_Material__r = irfMat; 
        insert imdMat;
        sobj = imdMat; mm = new IRF_Monthly_Material(imd, sobj, 1);
         
        imdUnt = new IRF_Monthly_Unit__c(); initImdUnt();
        imdUnt.IRF_Monthly_Data__c = imd.Id; 
        imdUnt.IRF_Unit__c = irfUnt.Id; //insert imdUnt;
        sobj = imdUnt; mu = new IRF_Monthly_Unit(sobj, 1);
    }
    
    static void initIrf() {
        //New Code for Account
         List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        
        
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        pfxCustomList.add(p);
        insert pfxCustomList;
        
        
        Account acct5=new Account();
        acct5.Name = 'Test 5';
        acct5.ParentId = '0015000000tvxEv';
        acct5.Type = 'Prospect';
        acct5.AccountNumber = 'P704122';
        acct5.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        acct5.country_picklist__c = 'Afghanistan (AF)';
        acct5.Prospect_Division__c = 'AAFI (50)';
        acct5.Prospect_Sales_District__c = 'ADDITIVES (11100)';
        acct5.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
        acct5.Prospect_Sales_Group__c = 'AM ARG/URU';
        acct5.Prospect_Dist_Channel__c = 'AAFI (50)';
        acct5.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
        acct5.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
        acct5.Prospect_Customer_Group__c = 'ADDITIVES (11)';
        acct5.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
        acct5.Prospect_Customer_Price_Group_Desc__c = 'A';
        acct5.SAP_Country__c = 'US';
        acct5.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
        acct5.SAP_Customer_Number__c = '12345';
        acct5.Ship_To_Customer_Number__c = '12345';
        acct5.SAP_Sales_Office__c='IW31';
        acct5.SAP_SalesGroup__c='18I';        
        acct5.SAP_SalesDistrict__c='IWNA1';
        acct5.RecordTypeId = '01250000000HmZ3AAK';
        insert acct5;     
        //Invoicing_Report_Form__c irf=new Invoicing_Report_Form__c();
        irf.ShipTo__c=acct5.Id;
       // insert irf;
        
        
	system.debug('>>>>>>>>>>>>Donald'+acct5.Id);
    	//irf.ShipTo__c = shipTo.Id; 
        irf.Batches_Required__c = 'Yes';
        irf.Contract_Number__c = '1234'; irf.Contract_Type__c = 'ZPCC'; 
        irf.Currency_for_Invoicing__c = 'USD'; irf.Units_UOM__c = 'LB';
    }
    
    static void initIrfMat() {
        irfMat.Beginning_Inventory__c = 0; irfMat.Effective_Date__c = tdate;
        irfMat.Price__c = 1.0; irfMat.Estimated_Quantity__c = 1.0;
        irfMat.Related_Unit__c = '1';
    }
    
    static void initIrfUnt() {
        irfUnt.Description__c = 'TestUnit'; irfUnt.Effective_Date__c = tdate;
        irfUnt.Price__c = 1.0;
        IRF_Unit u = new IRF_Unit();
    }
    
    static void initImd() {
    	imd.Start_Date__c = tdate; imd.End_Date__c = tdate.addDays(30);
    	imd.Current_Month_Production__c = 1000; imd.Days_in_Period__c = 30;
    	imd.Foresee_at_Normal__c = 'Yes'; imd.General_Comments__c = 'test';
    	imd.Invoice_Numbers__c = '1234'; imd.Operating_at_Normal__c = 'Yes';
    	imd.Operating_Comments__c = 'test'; imd.Purchase_Order_Number__c = '1234';
    	imd.Status__c = 'test'; imd.Upcoming_Changes__c = 'test';
    }
    
    static void initImdMat() {
    	imdMat.Adjustment_Inventory__c = 10; imdMat.Batches__c = '1234';
    	imdMat.Beginning_Inventory__c = 1000; imdMat.Billing_Value__c = 1000;
    	imdMat.Comments__c = 'test'; imdMat.Ending_Inventory__c = 500;
    	imdMat.Other_Charges__c = 10; imdMat.Received_Inventory__c = 2000;
        imdMat.Related_Unit__c = '1';
    }
    
    static void initImdUnt() {
    	imdUnt.Production__c = 1000;
    }
    
    static void setPageParam(String k, String v) {
        pageParams.clear(); pageParams.put(k, v);
        debug('pageParams : ' + pageParams);
    }
//*    
    static testMethod void test01() {setup1();
    	PageReference pr = Page.IRF_Page_1A; pageParams = pr.getParameters();
    	setPageParam(IRF_Controller.PARAM_ACCID, shipTo.Id);
    	Test.setCurrentPage(pr); Test.startTest();
    	IRF_Controller c = new IRF_Controller();
    	c.initAction1(); irf = c.m_hdr.sobj; initIrf(); 
    	c.onContractChange(); c.showIRF(); 
    	c.initAddMats(); debug('Mats : ' + c.mats);
    	for (IRF_Material m : c.mats) {m.selected = true;}
    	c.selectMaterialsAndReturn(); debug('Irf-Mats : ' + c.m_mats);
    	if (c.m_mats != null && c.m_mats.size() > 1) {c.m_mats[1].selected = true;}
    	c.deleteMaterials(); c.addUnits(); c.addUnits();
    	c.m_unts[1].selected = true; c.deleteUnits();
    //	irfMat = c.m_mats[0].sobj; initIrfMat(); 
    //	irfUnt = c.m_unts[0].sobj; initIrfUnt();
    	c.saveIrf(); c.setEditable(); c.onIrfStatChange(); showPageMsgs();
    }

    static testMethod void test02() {setup1(); Test.startTest();setup2();
        PageReference pr = Page.IRF_Page_1A; Test.setCurrentPage(pr); 
        IRF_Controller c = new IRF_Controller(); pageParams = c.params;
        setPageParam(IRF_Controller.PARAM_IRFID, irf.Id);    c.initAction1();
        setPageParam(IRF_Controller.PARAM_MATID, irfMat.Id); c.initAction1();
        setPageParam(IRF_Controller.PARAM_UNTID, irfUnt.Id); c.gotoRetUrl();
        c.initActionIrf(); c.initActionMat(); c.initActionUnt();
        c.initActionImd(); c.initActionImm(); c.initActionImu();
        c.pc1Frst(); c.pc1Next(); c.pc1Prev(); c.pc1Last(); c.pc1Size();
        c.pc2Frst(); c.pc2Next(); c.pc2Prev(); c.pc2Last(); c.pc2Size();
        c.pc3Frst(); c.pc3Next(); c.pc3Prev(); c.pc3Last(); c.pc3Size();
        update irfMat; update irfUnt; 
        irf.Status__c = IRF_Functions.IRF_STAT_RELEASED; update irf;
        setPageParam(IRF_Controller.PARAM_IRFID, irf.Id);   c.initAction1();
        c.m_mats[2].selected = true; c.deleteMaterials();
        c.m_unts[2].selected = true; c.deleteUnits(); c.saveIrf();
        irf.Status__c = IRF_Functions.IRF_STAT_DRAFT; update irf;
        c.m_mats[1].selected = true; c.deleteMaterials();
        c.m_unts[1].selected = true; c.deleteUnits(); c.saveIrf();
        IRF_Functions.getIrfClass3(irfUnt.Id); showPageMsgs();
    }
//*/

    static testMethod void test03() {setup1(); Test.startTest();setup2();
        PageReference pr = Page.IRF_Page_2A; pageParams = pr.getParameters();
        setPageParam(IRF_Controller.PARAM_IRFID, irf.Id);
        Test.setCurrentPage(pr); 
        IRF_Controller c = new IRF_Controller(); c.initAction2(); 
        c.pc4Frst(); c.pc4Next(); c.pc4Prev(); c.pc4Last(); c.pc4Size();
        c.pc5Frst(); c.pc5Next(); c.pc5Prev(); c.pc5Last(); c.pc5Size();
        c.showAdjstdInvs(); c.showRecevdInvs(); 
        c.pc6Frst(); c.pc6Next(); c.pc6Prev(); c.pc6Last(); c.pc6Size();
        c.showIMD(); imd = c.d_hdr.sobj; initImd();
        c.initAddImdMats(); for (IRF_Material m : c.mats) {m.selected = true;}
        c.selectMatsAndReturn();
        for (IRF_Monthly_Material m : c.d_mats) {m.selected = true;}
        c.deleteImdMats(); c.showHideMatsMFD();
        for (Integer n = 0; n < c.d_mats.size(); n++) {imdMat = c.d_mats[n].sobj; initImdMat();} 
        for (Integer n = 0; n < c.d_unts.size(); n++) {imdUnt = c.d_unts[n].sobj; initImdUnt();}
        c.saveAndSubmitImd(); showPageMsgs();
    }

//*    
    static testMethod void test04() {setup1(); Test.startTest();setup2(); setup3();
        PageReference pr = Page.IRF_Page_2A; pageParams = pr.getParameters();
        setPageParam(IRF_Controller.PARAM_IMDID, imd.Id);
        Test.setCurrentPage(pr); 
        IRF_Controller c = new IRF_Controller(); c.initAction3(); c.initAction4();
        c.pc7Frst(); c.pc7Next(); c.pc7Prev(); c.pc7Last(); c.pc7Size();
        c.saveImd(); c.viewImdAsPdf(); c.viewImdApprovalHistory(); 
        c.initAddUnts(); c.onBatchReqChange(); c.onCurrencyChange();
        c.onImdStatChange(); c.onSiteOper1Change(); c.onSiteOper2Change();
        c.onUomChange(); c.onDateChange(); c.showHideUntsMFD(); 
        c.gotoImdPage(); c.d_hdr.pmd = imd; c.validateImd(); showPageMsgs();
        update imd; update imdMat; //update imdUnt;
        IRF_Functions.getNewImdMats(imd); 
        IRF_Functions.getIrfMD3(imdMat.Id);
        IRF_Functions.getIrfMD4(imdUnt.Id);
        Set<String> matIds = new Set<String>{irfMat.Id};
        Set<String> untIds = new Set<String>{irfUnt.Id};
        List<Material_Sales_Data2__c> msd2AIds = new  List<Material_Sales_Data2__c>{msd2A};
        IRF_Functions.getImms(imd.Id, matIds);
        IRF_Functions.getImus(imd.Id, untIds);
        IRF_Functions.imdApprovalHistoryExists(imd.Id);
        IRF_Functions.getMatNums(msd2AIds);
        IRF_Functions.getAltUoms(msd2AIds);
        IRF_Functions.getIrfMaterials(soldTo, soldToNum, msd2AIds);
                                     //added by vishnu
         IRF_Class irfClass = new IRF_Class(irf);
        // Call setAccounts method
        irfClass.setAccounts(shipTo, soldTo);
    }
//*/
}
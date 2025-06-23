@isTest
public class Sample_Request_Functions_Test {

    static Account acc1;
    static Material_Sales_Data2__c mat1;
    static Sample_Request__c sr1;
    static Open_Orders__c OpOr;
    static Sample_Material__c sm1;
    static List<Sample_Request__c> srs1;
    static Sales_Order_Deliveries__c sod;
    static List<Sample_Material__c> sms1;
    static Sample_Material_Catalog__c smc;
    static List<Sample_Material_Catalog__c> smclist;
    static String sampleCenter = 'Test-SC';
    
    static void addSMC(String ssize) {
        smc = new Sample_Material_Catalog__c();
        smc.Product_Code__c = 'Test1234';
        smc.Product_Name__c = 'TestProduct';
        smc.Sample_Center__c = sampleCenter;
        smc.Sample_Size__c = ssize;
        smclist.add(smc);
    }
        
    static void createTestData() {
        acc1 = new Account(Name='Test Account');
        sod= TestDataFactory.create_Sales_Order_Deliveries(false);
        acc1.SAP_DistChannel__c = '50'; acc1.SAP_Sales_Org__c = '1021'; 
       	//acc1.RecordTypeId='01250000000HmZ3AAK';
       	acc1.RecordTypeId=[Select Name, Id From RecordType where sObjectType='Account' and isActive=true limit 1].Id;
        insert acc1;
        
        mat1 = Material_Sales_Data_Functions_Test.getTestMsd2();
        OpOr =TestDataFactory.create_Open_Orders(true,acc1.id);
        sr1 = new Sample_Request__c();
        sr1.Account__c = acc1.Id;
        sr1.Name='Test';
        insert sr1;
        sm1 = new Sample_Material__c();
        sm1.Sample_Request__c = sr1.Id;
        sm1.SAP_Material_MSD2__c = mat1.Id;
        insert sm1;
        srs1 = new List<Sample_Request__c>(); srs1.add(sr1);
        sms1 = new List<Sample_Material__c>(); sms1.add(sm1);
        sod.Record_Key__c=sr1.Name;
        insert sod;
        smclist = new List<Sample_Material_Catalog__c>();
        addSMC('TestSize1'); addSMC('TestSize2'); addSMC('TestSize3');
        insert smclist;
        User usr = User_Functions.getLoggedInUser();
        usr.Sample_Center__c = sampleCenter;
        try {update usr;} catch(Exception e){}
    }
    
    public static Sample_Request__c getSampleRequest() {
        createTestData(); Id srid = sr1.Id;
        String q = Sample_Request_Functions.QRY1 + ' where Id = :srid';
        List<Sample_Request__c> srs = Database.query(q);
        sr1 = srs[0];
        return sr1;
    }
     
    public static Sample_Material__c getSampleMaterial() {
        if (sr1 == null) {createTestData();}
        return sm1;
    }
    
    static testMethod void test01() {
        createTestData();
        map<string,Sales_Order_Deliveries__c> Msod = New map<string,Sales_Order_Deliveries__c>();
        for(Sales_Order_Deliveries__c od:[select id,name,Record_Key__c from Sales_Order_Deliveries__c limit 1]){
            Msod.put(od.Record_Key__c, od);
        }
        //Added by Sandhya
        map<string,Open_Orders__c> MOpOr = New map<string,Open_Orders__c>();
        for(Open_Orders__c od1:[select id,name,Key__c from Open_Orders__c limit 1]){
            MOpOr.put(od1.Key__c, od1);
        }
        Sample_Request_Functions.Validate_SAP_Order_Number('', false);
        Sample_Request_Functions.Validate_SAP_Order_Number('', true);
        Sample_Request_Functions.AssignMyselfasCoordinator(sr1.Id);
        Sample_Request_Functions.AssignMyselfasCoordinatorLTD(sr1.Id);
        Sample_Request_Functions.RemoveRequestfromHoldLTD(sr1.Id);
        Sample_Request_Functions.RemoveRequestfromHold(sr1.Id);
        Sample_Request_Functions.Update_Approval_Process(sr1.Id);
        Sample_Request_Functions.Update_Approval_ProcessLTD(sr1.Id);
        Sample_Request_Functions.setRouteForApprovalFlags(acc1, sr1, sms1);
        Sample_Request_Functions.getMatCatalogPC(sr1, acc1);
        sr1.No_Charge_Order__c = true;
        Sample_Request_Functions.getMatCatalogPC(sr1, acc1);
        Sample_Request_Functions.getMatCatalogPC(sr1, acc1, 'matName');
        Sample_Request_Functions.getDistChanMatStats();
        Sample_Request_Functions.getDistChanMatStatOpts();
        Sample_Request_Functions.getMatStats('None');
        Sample_Request_Functions.skipToUpdate(sr1);
        Sample_Request_Functions.isASK(acc1);
        Sample_Request_Functions.isFlint(acc1);
        Sample_Request_Functions.isDataChanged1(sod, sr1);
        Sample_Request_Functions.isDataChanged2(sod,sm1);
        Sample_Request_Functions.updateDeliveriesData(Msod); 
        Sample_Request_Functions.getSampleRequests(Msod); 
        Sample_Request_Functions.isDataChanged1(OpOr,sr1);
        Sample_Request_Functions.isDataChanged2(OpOr,sm1);//sandhya
        Sample_Request_Functions.updateOpenOrdersData(MOpOr); //sandhya
    }

    
    static testMethod void test02() {
        createTestData();
        acc1.SAP_DistChannel__c = '10'; acc1.SAP_Sales_Org__c = '1020';
        Sample_Request_Functions.isACM(acc1); 
        Sample_Request_Functions.isAPM(acc1); 
        Sample_Request_Functions.setRouteForApprovalFlags(acc1, sr1, sms1);
    }
     static testMethod void test03() {
        createTestData();
        acc1.SAP_DistChannel__c = '10'; acc1.SAP_Sales_Org__c = '1020';
       Sample_Request_Config.getDistChanOpt('test'); 
         Sample_Request_Config.getDistChanOpts(); 
        Sample_Request_Functions.isAPM(acc1); 
        Sample_Request_Functions.setRouteForApprovalFlags(acc1, sr1, sms1);
         Sample_Request_Config DELIM;
         Sample_Request_Config COMMA;
         Sample_Request_Config ACM;
         Sample_Request_Config ALL;
         Sample_Request_Config APM;
         Sample_Request_Config ASI;
         Sample_Request_Config ASK;
         Sample_Request_Config AWT;
         Sample_Request_Config CMC;
         Sample_Request_Config LAB;
         Sample_Request_Config MSD;
         Sample_Request_Config OTH;
         Sample_Request_Config DC_AWT;
         Sample_Request_Config DC_APM;
         
            Sample_Request_Config DC_ACM;
         Sample_Request_Config DC_ASI;
         Sample_Request_Config DC_ASK;
         Sample_Request_Config DC_ALL;
         Sample_Request_Config CMC_EU;
 
          
            Sample_Request_Config CMC_US;
         Sample_Request_Config SC_JNG;
         Sample_Request_Config SC_OTH;
         Sample_Request_Config SC_NNJ;
           Sample_Request_Config SC_ASH;
         Sample_Request_Config SC_PLC;

         
         
          
            Sample_Request_Config RFS_APM_01;
         Sample_Request_Config RFS_APM_02;
         Sample_Request_Config RFS_APM_03;
         Sample_Request_Config RFS_APM_04;
           Sample_Request_Config RFS_APM_05;
         Sample_Request_Config RFS_APM_06;
         Sample_Request_Config RFS_APM_07;
           Sample_Request_Config RFS_APM_08;
         Sample_Request_Config RFS_APM_09;
           Sample_Request_Config RFS_APM_10;
         Sample_Request_Config RFS_APM_11;
           Sample_Request_Config RFS_APM_12;
         Sample_Request_Config RFS_APM_13;

         Sample_Request_Config RFS_ASI_01;
           Sample_Request_Config RFS_ASI_02;
         Sample_Request_Config RFS_ASI_03;
         Sample_Request_Config RFS_ASI_04;
           Sample_Request_Config RFS_ASI_05;
         Sample_Request_Config RFS_ASI_06;
           Sample_Request_Config RFS_ASI_07;
         Sample_Request_Config RFS_ASI_08;
     
           Sample_Request_Config RFS_OTHER;
           Sample_Request_Config SFL_OTHER;
         Sample_Request_Config QTY1;
           Sample_Request_Config QTY2;
         Sample_Request_Config QTY3;

         Sample_Request_Config.getSampleCenterOpts('test');
             Sample_Request_Config.getSPSSampleCenters();
         List<Material_Sales_Data2__c> msdList=new List<Material_Sales_Data2__c>();
         msdList.add(mat1);
             Sample_Request_Config.upsertSampleRequestConfig(msdList);
             Sample_Request_Config.getQuantityLimits('test');
    }
}
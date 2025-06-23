@isTest
public with sharing class TestDataFactory{
     
            
    /** 
    * ******************************************************
    * This method is test data for create Account
    * ******************************************************
    */
    
    public static Account createAccount(Boolean doInsert){
    
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
        
        Account acc = new Account();
        acc.Name = 'Test 5';
        acc.ParentId = '0015000000tvxEv';
        acc.Type = 'Prospect';
        acc.AccountNumber = 'P704122';
        acc.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        acc.country_picklist__c = 'Afghanistan (AF)';
        acc.Prospect_Division__c = 'AAFI (50)';
        acc.Prospect_Sales_District__c = 'ADDITIVES (11100)';
        acc.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
        acc.Prospect_Sales_Group__c = 'AM ARG/URU';
        acc.Prospect_Dist_Channel__c = 'AAFI (50)';
        acc.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
        acc.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Group__c = 'ADDITIVES (11)';
        acc.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Price_Group_Desc__c = 'A';
        acc.SAP_Country__c = 'US';
        acc.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
        acc.SAP_Customer_Number__c = '12345';
        acc.Ship_To_Customer_Number__c = '12345';
        acc.SAP_Sales_Office__c='IW31';
        acc.SAP_SalesGroup__c='18I';        
        acc.SAP_SalesDistrict__c='IWNA1';
        acc.RecordTypeId = '01250000000HmZ3AAK';
    
        if(doInsert)
        {
            insert acc;
        }        
        return acc;
    }
    
     public static Account createAccountCus(Boolean doInsert){
    
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
        
        Account acc = new Account();
        acc.Name = 'Test 5';
        acc.ParentId = '0015000000tvxEv';
        acc.Type = 'Customer';
        acc.AccountNumber = 'P704122';
        acc.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        acc.country_picklist__c = 'Afghanistan (AF)';
        acc.Prospect_Division__c = 'AAFI (50)';
        acc.Prospect_Sales_District__c = 'ADDITIVES (11100)';
        acc.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
        acc.Prospect_Sales_Group__c = 'AM ARG/URU';
        acc.Prospect_Dist_Channel__c = 'AAFI (50)';
        acc.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
        acc.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Group__c = 'ADDITIVES (11)';
        acc.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Price_Group_Desc__c = 'A';
        acc.SAP_Country__c = 'US';
        acc.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
        acc.SAP_Customer_Number__c = '12345';
        acc.Ship_To_Customer_Number__c = '12345';
        acc.SAP_Sales_Office__c='IW31';
        acc.SAP_SalesGroup__c='18I';        
        acc.SAP_SalesDistrict__c='IWNA1';
        acc.RecordTypeId = '01250000000HmZ3AAK';
    
        if(doInsert)
        {
            insert acc;
        }        
        return acc;
    }
    
     public static Account createAccount2(Boolean doInsert){ 
       
        
        Account acc = new Account();
        acc.Name = 'Test 6';
        acc.ParentId = '0015000000tvxEv';
        acc.Type = 'Prospect';
        acc.AccountNumber = 'P704122';
        acc.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        acc.country_picklist__c = 'Afghanistan (AF)';
        acc.Prospect_Division__c = 'AAFI (50)';
        acc.Prospect_Sales_District__c = 'ADDITIVES (11100)';
        acc.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
        acc.Prospect_Sales_Group__c = 'AM ARG/URU';
        acc.Prospect_Dist_Channel__c = 'AAFI (50)';
        acc.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
        acc.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Group__c = 'ADDITIVES (11)';
        acc.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
        acc.Prospect_Customer_Price_Group_Desc__c = 'A';
        acc.SAP_Country__c = 'US';
        acc.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
        acc.SAP_Customer_Number__c = '12345';
        acc.Ship_To_Customer_Number__c = '12345';
        acc.SAP_Sales_Office__c='IW31';
        acc.SAP_SalesGroup__c='18I';        
        acc.SAP_SalesDistrict__c='IWNA1';
        acc.RecordTypeId = '01250000000HmZ3AAK';
    
        if(doInsert)
        {
            insert acc;
        }        
        return acc;
    }
       
     /**
     * *******************************************************
     * This method is test data for create contact object
     * *******************************************************
     */
    public static Contact createContact(Boolean doInsert){
        return createContact(doInsert, createAccount(true).Id);
    }
    
    public static Contact createContact(Boolean doInsert, Id accId){
        Contact con = new Contact();
        con.AccountId = accId;
        con.FirstName = 'FirstName';
        con.LastName = 'LastName';
        con.Email = 'FirstName@test.com' + Math.floor(Math.random() * 1000);
        if(doInsert)
        {
            insert con;
        }
        return con;
    }

    /**
    * ***********************************************************
    * This method is test data for create Opportunity object
    * ***********************************************************
    */
    
    public static Opportunity createOpportunity(Boolean doInsert, Id accId){
        Opportunity Opp = new Opportunity();
        //opp.RecordTypeId = OPP_RT_MAP.get('Water Opportunity');
       // opp.RecordTypeId = oppRTId.Id;
        opp.accountid = accId;
        //opp.SAP_Material__c = mat.id;
        opp.product_of_interest_other__c = '12345'; 
        opp.price_unit_of_measure__c = 'KG';       
        //opp.details__c = 'These are my details';
        //Opp.product_group__c = 'ABS';
        opp.stagename = 'Defining/Prospecting';
        Opp.Name = 'Opportunity';
        opp.closedate = system.today();        
        if(doInsert){
            insert opp;
        }
        return opp;
    }   
    
    /**
    * ************************************************************
    * This method is test data for create Case object
    * ************************************************************
    */
        
    public static Case  createCase(Boolean doInsert ){
    
        Case cas = new Case(Status ='New', Priority = 'Medium', Origin = 'Email');
        if(doInsert)
        {
            insert cas ;
        }
        return cas ;
    }    
    
    /**
    * ************************************************************
    * This method is test data for create Machine object
    * ************************************************************
    */
        
    public static Machine__c createMachine(Boolean doInsert,id accId ){
    
        Machine__c Mac = new Machine__c();            
            Mac.Name='test Machine';
            Mac.Account__c=accId;
            Mac.Site_Code__c='780';
            Mac.Site_Region__c='NA';
            Mac.Site_Shipping_Address__c='232 E. Eighth Street';
            Mac.Site_Shipping_City__c='Chillicothe';
            Mac.Site_Shipping_State_Province__c='Ohio';
            Mac.Site_Shipping_Country__c='United States';
            Mac.Site_Corporation_Name__c='Glatfelter';
            Mac.Site_Name__c='Chillicothe';
            Mac.Machine_Type__c='Fiber Line';
            //Mac.Pulp_and_Paper_Machine_Status__c='operational';
            Mac.Major_Grade__c='Printing and Writing';
            Mac.Avg_Rank_Paper_Machine_Total__c=6.07;
            Mac.Sum_of_TPY_Queried_Products_by_Machine__c=32594;
            Mac.CI_machine_last_update_date__c=system.today();

        
        if(doInsert)
        {
            insert Mac;
        }
        return Mac;
    }
    
    /**
    * ************************************************************
    * This method is test data for create Competitor__c object
    * ************************************************************
    */
    
    public static Competitor__c createApplication(Boolean doInsert){    
       Competitor__c Comp = New Competitor__c ();                      
                Comp.Name='test';
                Comp.Competes_With__c='Water';
                Comp.AAFIIndustry__c='Coatings';
                Comp.Status__c='Active';
                Comp.Stock_Ticker__c='Test Stock Ticker';
                Comp.Web_Site__c='www.test.com';                            
        if(doInsert)
        {
            insert Comp;
        }
        return Comp;
    }        
        
    /**
    * ************************************************************
    * This method is test data for create Application__c object
    * ************************************************************
    */
    
    public static Application__c createApplication(Boolean doInsert,id MachineId){
    
        Application__c Ap= new Application__c();
            Ap.Name='12CM Coating Batch Biocide';
            Ap.Machine__c=MachineId;
            Ap.Machine_Type__c='P&W Machine';
            Ap.Process_Area__c='Coaters';
            Ap.Application_Type__c='Defoamer';
            //Ap.Product_SBU__c='';
            Ap.Supplier__c='Solenis';
            Ap.Supplier_Other__c='Test Other';
            Ap.Process_Area_Other__c='Test Area Other';
            Ap.Application_Other__c='Test Application';
            Ap.Prouduct_Tradename__c='SpectrumRX9100';
            Ap.UOM__c='LBS';
            Ap.Annual_Consumption__c=4800;
            Ap.Annual_Consumption_Confidence__c='High';
            Ap.Annual_revenue_curr__c=100;
            Ap.Annual_Revenue_Confidence__c='High';
            Ap.CI_Application_last_update_date__c=System.Today();       
        
        if(doInsert)
        {
            insert Ap;
        }
        return Ap;
    }    
   
  
    /**
    * ************************************************************
    * This method is test data for create Opportunity_Material__c object
    * ************************************************************
    */
    
    public static Opportunity_Material__c createOpportunityMaterial(Boolean doInsert,id OppId){
    
        Opportunity_Material__c OppMat = New Opportunity_Material__c();
            OppMat.Opportunity__c= OppId;
            OppMat.Trial_Start_Date__c=System.Today();
            OppMat.Delta_End_Date__c=System.Today()+1;
            OppMat.Annual_Revenue__c=900;
            OppMat.CurrencyIsoCode='USD';    
        
        if(doInsert)
        {
            insert OppMat;
        }
        return OppMat;
    }    
    
     /**
    * ************************************************************
    * This method is test data for create Asset object
    * ************************************************************
    */
    
    public static Asset createAsset(Boolean doInsert,id AccId){
    
        Asset Ast= New Asset();
           Ast.Name='Test Asset'; 
           Ast.Accountid= AccId;
           Ast.Sales_Org_Region__c = 'NA';
        
        if(doInsert)
        {
            insert Ast;
        }
        return Ast;
    }    
    
    
    
    
    /**
    * ************************************************************
    * This method is test data for create Work Order object
    * ************************************************************
    */
    
    public static WorkOrder createWorkOrder(Boolean doInsert,id AstId,id AccId){
    
        WorkOrder Wor= New WorkOrder();
           Wor.Accountid= AccId;
           Wor.Assetid= AstId;
           Wor.Subject='Test Workorder';
           Wor.Description_of_work_to_be_done_del__c='test Desc';
           Wor.Product_ESR__c='Test Product ESR';
           Wor.Business_Unit__c='IWT';
           //Wor.Requested_Date__c=System.Now();
           Wor.FSL_Requested_Date__c=System.Now();
           Wor.StartDate=System.Today()+21;
           Wor.Status='Draft';
           
        system.debug('<<<Wor>>>'+Wor);
        if(doInsert)
        {
            insert Wor;
        }
        
        return Wor;
    }  
   
    /**
    * ************************************************************
    * This method is test data for create Service Appointment object
    * ************************************************************
    */
    
    public static ServiceAppointment createServiceAppointment(Boolean doInsert,id WorId){
    
        ServiceAppointment SA= New ServiceAppointment();
           SA.Status='None';
           SA.ParentRecordid=WorId;
           SA.SAP_Service_Region__c='EMEA';
           SA.EarliestStartTime=System.Now();
           SA.DueDate=System.Now()+1;
           
        
        if(doInsert)
        {
            insert SA;
        }
        return SA;
    }   
    
     /**
    * ************************************************************
    * This method is test data for create Service Appointment object
    * ************************************************************
    */
    
    public static user createUser(Boolean doInsert,String userName,string empId){
    Profile prof = [select id from profile where name LIKE '%solenis%' limit 1];
        User user = new User();
        user.firstName = 'test1';
        user.lastName = 'test2';
        user.profileId = prof.id;
        user.Alias='tes';
        user.username = userName;
        user.email = 'test@test.com';
        user.Ashland_Employee_Number__c=empId;
        user.Sub_Business__c='IWT';
        user.Rollout_Region__c='EMEA';
        user.Business_Role__c='IT';
        user.TimeZoneSidKey='Europe/London';
        user.LocaleSidKey='en_GB';
        user.LanguageLocaleKey='en_US';
        user.DefaultCurrencyIsoCode='USD';
        user.EmailEncodingKey = 'ISO-8859-1';

        
           
        
        if(doInsert)
        {
            insert user;
        }
        return user;
    } 
    
    
     /**
    * ************************************************************
    * This method is test data for create Service Appointment object
    * ************************************************************
    */
    
    public static  EmailTemplate createEmailTemplate(Boolean doInsert,String tempName,String folderid){
       EmailTemplate emailTemp = new EmailTemplate();
            emailTemp.developerName = 'test'; 
            emailTemp.FolderId = folderid; 
            emailTemp.TemplateType= 'Text'; 
            emailTemp.Name = tempName;

        
           
        
        if(doInsert)
        {
            insert emailTemp;
        }
        return emailTemp;
    } 
    
    /**
    * ************************************************************
    * This method is test data for create Service Appointment object
    * ************************************************************
    */
    
    public static  SAP_Payer_Credit_Information__c  create_SAP_Payer_Credit_Information(Boolean doInsert,id accid){
       SAP_Payer_Credit_Information__c  s = new SAP_Payer_Credit_Information__c();
            s.SAP_Payer_Balance__c = 0.00;
            s.SAP_Payer_Credit_Limit__c = 0.00;
            s.SAP_Payer_Credit_Control__c = 'ECCA';
            s.SAP_Payer_Current__c = 0.00;
            s.SAP_Payer_Dist_Channel__c = '10';
            s.SAP_Payer_Division__c = '11';
            s.SAP_Payer_Past_Due_1_15_Days__c = 0.00;
            s.SAP_Payer_Past_Due_16_30_Days__c = 0.00;
            s.SAP_Payer_Past_Due_31_60_Days__c = 0.00;
            s.SAP_Payer_Past_Due_61_90_Days__c = 0.00;
            s.SAP_Payer_Past_Due_over_90Days__c = 0.00;
            s.SAP_Payer_Sales_Org__c = '0070';
            s.SAP_Payer_Total_Past_Due__c = 0.00;
            s.Record_Key__c = '000064784700701111ECCARUB';
            s.SAP_Payer_Account__c =accid;
            s.SAP_Payer_Account_Number__c = '0000647837';
        
           
        
        if(doInsert)
        {
            insert s;
        }
        return s;
    }     
    
      /**
    * ************************************************************
    * This method is test data for create Service Appointment object
    * ************************************************************
    */
    
    public static  Material_Sales_Data2__c  create_Material_Sales_Data2(Boolean doInsert){
      Material_Sales_Data2__c objMaterialSalesData2 = new Material_Sales_Data2__c();
            objMaterialSalesData2.Material_Number__c = '0000001';
            objMaterialSalesData2.Name = 'Material-1';
            objMaterialSalesData2.Dist_Channel_Code__c = '30';
            objMaterialSalesData2.Record_Key__c = objMaterialSalesData2.Name;
            objMaterialSalesData2.Sales_Org_Code__c = '1000';
                           
                if(doInsert)
                {
                    insert objMaterialSalesData2;
                }
                return objMaterialSalesData2;
            }     
       
       
        /**
    * ************************************************************
    * This method is test data for create Service Appointment object
    * ************************************************************
    */
    
    public static  Shipping_Instruction__c create_Shipping_Instruction(Boolean doInsert,id accid){
     Shipping_Instruction__c objShipInst = new Shipping_Instruction__c();
            objShipInst.Account__c = accid;
            objShipInst.Customer_Type__c = 'Bulk Customer';
            objShipInst.Is_Delivery_Appointment_Necessary__c = 'Yes';
            objShipInst.Receiving_Hours_Start__c = 'System.Now()';
            objShipInst.Receiving_Hours_End__c = 'System.Now()+1';
            objShipInst.Certificate_of_Analysis_Required__c = 'Yes';
            objShipInst.Certificate_of_Analysis_attention__c = 'Test';
            objShipInst.Customer_PO_required_on_paperwork__c = 'Yes';   
                if(doInsert)
                {
                    insert objShipInst;
                }
                return objShipInst;
            }     
            
               /**
    * ************************************************************
    * This method is test data for create Service Appointment object
    * ************************************************************
    */
    
    public static  Tank_Requirement__c create_Tank_Requirement(Boolean doInsert,id accid,id conid,id SD2){
      Tank_Requirement__c objTR = new Tank_Requirement__c();
            objTR.Status__c = 'New Order';
            objTR.Customer_Prospect__c = accid;
            objTR.Tank_Status__c = 'New Order';
            objTR.Type__c = 'Bulk Tank';
            objTR.Program_Type__c = 'Pro-Serv/Custom Bulk';
            objTR.SAP_Material__c = SD2;
            objTR.Contact__c = conid;
            objTR.Est_Yearly_Program_Revenue__c = 100;
            objTR.Est_Yearly_Chemical_Cost__c = 9900;
            objTR.Justification_Comments__c = 'TestArea';   
                if(doInsert)
                {
                    insert objTR;
                }
                return objTR;
            }     
            
            public static  Account createAccount3(Boolean doInsert){
            
                //Creating PriceFx test data    
                        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
                        PriceFx__c p = new PriceFx__c();
                        p.allowed_recordtype_id__c = '01250000000HmZV';
                        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
                        p.Name='callAccount';
                        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
                        p.password__c='Testuser@123';
                        p.username__c='sfdctestuser';
                        pfxCustomList.add(p);
                        
                        PriceFx__c p1 = new PriceFx__c();
                        p1.allowed_recordtype_id__c = '01250000000HmZV';
                        p1.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
                        p1.Name='callMaterialSalesData2';
                        p1.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
                        p1.password__c='Testuser@123';
                        p1.username__c='sfdctestuser';
                        pfxCustomList.add(p1);
                        
                        PriceFx__c p2 = new PriceFx__c();
                        p2.allowed_recordtype_id__c = '01250000000HmZV';
                        p2.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
                        p2.Name='callCustomerProductInfo2';
                        p2.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
                        p2.password__c='Testuser@123';
                        p2.username__c='sfdctestuser';
                        pfxCustomList.add(p2);
                        
                        PriceFx__c p3 = new PriceFx__c();
                        p3.allowed_recordtype_id__c = '01250000000HmZV';
                        p3.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
                        p3.Name='callMaterialPlant2';
                        p3.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
                        p3.password__c='Testuser@123';
                        p3.username__c='sfdctestuser';
                        pfxCustomList.add(p3);
                        insert pfxCustomList;
                        
                        Account acct2 = new Account(); 
                        acct2.Name = 'Test'; 
                        acct2.Prospect_Sales_Org__c = 'Solenis LLC(1020)'; 
                        acct2.country_picklist__c = 'Afghanistan (AF)'; 
                        acct2.Prospect_Division__c = 'AAFI (50)'; 
                        acct2.Prospect_Sales_District__c = 'ADDITIVES (11100)'; 
                        acct2.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)'; 
                        acct2.Prospect_Sales_Group__c = 'AM ARG/URU'; 
                        acct2.Prospect_Dist_Channel__c = 'AAFI (50)'; 
                        acct2.Prospect_Customer_Group1__c = 'AFFILIATE (412)'; 
                        acct2.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)'; 
                        acct2.Prospect_Customer_Group__c = 'ADDITIVES (11)'; 
                        acct2.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)'; 
                        acct2.Prospect_Customer_Price_Group_Desc__c = 'ZL'; 
                        acct2.SAP_Country__c = 'US'; 
                        acct2.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4'; 
                        acct2.SAP_Customer_Number__c = '12345';
                        acct2.SAP_Street__c = 'Jamesbond';
                        acct2.SAP_StreetSuppl1__c = 'Test1';
                        acct2.SAP_StreetSuppl2__c = 'Test2';
                        acct2.SAP_City__c = 'Mahopac';
                        acct2.SAP_state__c = 'New York';
                        acct2.SAP_ZIP_Code__c = '10118';
                        acct2.Full_Address__c = 'SolenisTest';
                        acct2.SAP_Sales_Org_Region_value1__c = 'NA';
                        
                if(doInsert)
                {
                    insert acct2;
                }
                return acct2;
            }     
         
      /**
    * ************************************************************
    * This method is test data for create Service Appointment object
    * ************************************************************
    */
    
    public static  Sales_Order_Deliveries__c create_Sales_Order_Deliveries(Boolean doInsert){
     Sales_Order_Deliveries__c SOD= new Sales_Order_Deliveries__c();
            SOD.Record_Key__c= 'Test';           
                if(doInsert)
                {
                    insert SOD;
                }
                return SOD;
            }         
            
    
    /**
    * ************************************************************
    * This method is test data for create Service Appointment object
    * ************************************************************
    */
    
    public static  Open_Orders__c create_Open_Orders(Boolean doInsert,id accid){
     Open_Orders__c OO= new Open_Orders__c();
            OO.Sales_Order_Number__c= 'Test';   
            OO.ShipTo__c= accid;
            OO.Line_Item_Number__c='12455';
            OO.Key__c='2345';                     
                   
                if(doInsert)
                {
                    insert OO;
                }
                return OO;
            }           
    
    /**
    * ************************************************************
    * This method is test data for create GSI object
    * ************************************************************/    
    public static Global_Strategic_Initiative__c createGlobalStrategicInitiative(Boolean doInsert, Id user){
        
        ID rctId = Schema.SObjectType.Global_Strategic_Initiative__c.getRecordTypeInfosByDeveloperName().get('Opportunity_GSI').getRecordTypeID();
    
        Global_Strategic_Initiative__c gsi= New Global_Strategic_Initiative__c();
        gsi.Name = 'PAM - NA IWT';
        gsi.Assigned_To__c = user;
        gsi.Active__c =True;
        gsi.RecordTypeId = rctId;
        gsi.GSI_Code__c = 'PAM';
        gsi.Regions__c = 'NA';
        gsi.Vertical__c = 'IWT';
        if(doInsert)
        {
            insert gsi;
        }
        return gsi;
    } 
    
    /**
    * ************************************************************
    * This method is test data for create Category(Milestone) object
    * ************************************************************/    
    public static Category__c createCategory(Boolean doInsert, Id gsiId, Id user){
        
        ID rctId = Schema.SObjectType.Category__c.getRecordTypeInfosByDeveloperName().get('Solenis_Sub_Region_Milestones').getRecordTypeID();
        
        Category__c cat= New Category__c();
        cat.Name= 'Gulf and West';
        cat.Assigned_To__c= user;
        cat.RecordTypeId= rctId;
        cat.Global_Strategic_Initiative__c= gsiId;
        cat.Category_Code__c= 'IWNA1IW41';
        if(doInsert)
        {
            insert cat;
        }
        return cat;
    }
    
    /**
    * ************************************************************
    * This method is test data for create Project(ActionItem) object
    * ************************************************************/    
    public static Action_Item__c createActionItem(Boolean doInsert, Id gsiId, Id catId, Id oppId){
        
        ID rctId = Schema.SObjectType.Action_Item__c.getRecordTypeInfosByDeveloperName().get('Opportunity_Record_Type').getRecordTypeID();
        
        Action_Item__c actItem= New Action_Item__c();
        actItem.Name= 'Test Project';
        actItem.Global_Strategic_Initiative__c= gsiId;
        actItem.Category__c= catId;
        actItem.Region__c= 'NA';
        actItem.Vertical__c= 'IWT';
        actItem.RecordTypeId= rctId;
        actItem.Opportunity_AI__c= oppId;
        if(doInsert)
        {
            insert actItem;
        }
        return actItem;
    }
    
    /**
    * ************************************************************
    * This method is test data for SAP Contact object
    * ************************************************************/    
    public static SAP_Contact__c createSAPContact(Boolean doInsert, Id accId){
        
        SAP_Contact__c sapCont = New SAP_Contact__c();
        sapCont.Name = 'Test';
        sapCont.Account_Name__c=accId;
        sapCont.SAP_Full_Name__c ='Test';
        sapCont.SAP_Status__c='Active';
        sapCont.SAP_Title__c='Manager';
        sapCont.SAP_Email__c='test@solenis.com';
        sapCont.SAP_Fax__c='123546';
        sapCont.SAP_Phone__c='514-384-3152';
        if(doInsert)
        {
            insert sapCont;
        }
        return sapCont;
    }

    /**
    * ************************************************************
    * This method is test data for Customer Creation Request object
    * ************************************************************/    
    public static Customer_Creation_Request__c createCCR(Boolean doInsert, Id accId){
        
        ID rctId = Schema.SObjectType.Customer_Creation_Request__c.getRecordTypeInfosByDeveloperName().get('Solenis_CCR_RecordType').getRecordTypeID();
        
        Customer_Creation_Request__c ccr = New Customer_Creation_Request__c();
        ccr.Account__c = accId;
        ccr.Region__c = 'NA';
        ccr.Request_Type__c = 'SOLD TO';
        ccr.RecordTypeId= rctId;
        ccr.Status__c = 'New';
        ccr.CCR_Sales_Organization__c = 'Solenis LLC(1020)';
        ccr.CCR_Sales_District__c = 'RSD IWT NA (IWNA1)';
        ccr.CCR_Sales_Office__c = 'IWT NA CENTRAL (IW35)';
        ccr.Sales_Group__c = 'IWT NA SUPERIOR (33I)';
        ccr.CCR_DIst_Channel__c = 'AHWT (10)';
        ccr.CCR_Division__c = 'AHWT (11)';
        ccr.CCR_Customer_Group__c = 'DIRECT SALE (501)';
        ccr.CCR_Customer_Group2__c = 'IWT PRINTING&WRITING (176)';
        if(doInsert)
        {
            insert ccr;
        }
        return ccr;
    }

    /**
    * ************************************************************
    * This method is test data for lwr object
    * ************************************************************/    
     public static LWR__c createlwr(Boolean doInsert, Id accId){
        
        ID rctId = Schema.SObjectType.LWR__c.getRecordTypeInfosByDeveloperName().get('Non_Analytical_Recurrence').getRecordTypeID();
        LWR__c lwr = New LWR__c();
        lwr.Customer_Name__c = accId;
        lwr.RecordTypeId = rctId;
        lwr.Request__c = 'Standard Request';
        lwr.Technical_Center__c = 'Wilmington';
        lwr.Request_Type__c = 'PPD';
        lwr.Sections__c = 'Analytical';
        lwr.Priority__c = 'Critical'; 
        lwr.Reason_for_Urgent_Priority__c = 'Test';
        if(doInsert)
        {
            insert lwr;
        }
        return lwr;
    }     
}
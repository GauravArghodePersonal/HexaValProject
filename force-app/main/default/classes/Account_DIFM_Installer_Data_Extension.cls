public class Account_DIFM_Installer_Data_Extension {

    private final Account Account_from_stdController;
    private DIFM_Installer_Data__c DIFM_Installer_Data;
    private List<Contact> Contacts;

    public String DIFM_Installer_Data_Exists { get; set; }                         
    public String getDIFM_Installer_Data_Does_Not_Exist() {if(DIFM_Installer_Data_Exists=='true') {return 'False';} else {return 'True';}}
    public String ShowServiceProviderProfile_Create_Section {get;set;}
    
    public Account_DIFM_Installer_Data_Extension(ApexPages.StandardController stdController) {
        this.Account_from_stdController = (Account)stdController.getRecord();
        
        InitialActions();
    }

    public void InitialActions() {
        getDIFM_Installer_Data();
        getContacts();
        
        SPP_How_to_Create = 'Default';
        if (DIFM_Installer_Data != null) {SelectedContactId_for_New_SPP = DIFM_Installer_Data.Contact__c;}
        
        if (DIFM_Installer_Data == null) {DIFM_Installer_Data_Exists = 'False';} else {DIFM_Installer_Data_Exists = 'True';}
       
        if (DIFM_Installer_Data != null) 
            {
            getQuarterList();
            //getCurrentandNextQuarters();
            
//            if ((CurrentQtr_AlreadyExists == true) && (NextQtr_AlreadyExists == true))
            if (QtrCount == 0)
                {ShowServiceProviderProfile_Create_Section = 'False';}
            else
                {ShowServiceProviderProfile_Create_Section = 'True';}
            }
        
    }
 


    public DIFM_Installer_Data__c getDIFM_Installer_Data() {
        
        if (DIFM_Installer_Data == null)
            {
            try {
                DIFM_Installer_Data = [SELECT DIFM_Installer_Data__c.Id,
                                         DIFM_Installer_Data__c.Account__c,
                                         DIFM_Installer_Data__c.Contact__c,
                                         (SELECT Id,
                                                 Name,
                                                 CreatedDate,
                                                 LastModifiedDate,
                                                 CreatedById,
                                                 CreatedBy.Name,
                                                 LastModifiedById,
                                                 LastModifiedBy.Name,
                                                 Contact__c,
                                                 Effective_Date__c,
                                                 Expiry_Date__c 
                                            FROM Service_Provider_Profile__r
                                         ORDER BY Effective_Date__c DESC,Expiry_Date__c DESC
                                         )
                                    FROM DIFM_Installer_Data__c 
                                   WHERE Account__c = :Account_from_stdController.Id];
                } catch (Exception e) {}
            }
        return DIFM_Installer_Data;
    }

    public List<Contact> getContacts() {
        if (Contacts == null)
            {
            try {
                Contacts = [SELECT Id,
                                   Name,
                                   AccountId,
                                   OwnerId,
                                   LastName,
                                   FirstName,
                                   Salutation,
                                   MailingStreet,
                                   MailingCity,
                                   MailingState,
                                   MailingPostalCode,
                                   MailingCountry,
                                   Title,
                                   Phone,
                                   Fax,
                                   Email
                              FROM Contact 
                             WHERE AccountId = :Account_from_stdController.Id
                             ORDER BY LastName, FirstName];
                } catch (Exception e) {}
            }
        return Contacts;
    }

    public void createDIFM_Installer_Data() {
        if (DIFM_Installer_Data == null)
            {
            DIFM_Installer_Data = new DIFM_Installer_Data__c();
            DIFM_Installer_Data.Account__c = Account_from_stdController.Id;
            insert DIFM_Installer_Data;
            DIFM_Installer_Data_Exists = 'True';
            }
    }


    public String SPP_How_to_Create { get; set; }                         

    public List<SelectOption> getCreateNewServiceProviderProfile_HowtoCreateList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Default','Create using Default Values'));
        
        for(Service_Provider_Profile__c spp:DIFM_Installer_Data.Service_Provider_Profile__r)
            {
            String spp_Label = Date_Functions.getFormattedDate(spp.Effective_Date__c,1) + ' - ' + Date_Functions.getFormattedDate(spp.Expiry_Date__c,1);
            options.add(new SelectOption(spp.Id,spp_Label));
            }
        
        return options;
        }

    public Id SelectedContactId_for_New_SPP { get; set;}

    public List<SelectOption> getContactSelectOptions() {
        List<SelectOption> options = new List<SelectOption>();
        for(Contact c:Contacts)
            {
            String c_Label = isNull(c.Name) + ' - ' + isNull(c.Title) + ' | ' + isNull(c.MailingStreet) + ' ' +
                             isNull(c.MailingCity) + ', ' + isNull(c.MailingState) + ' ' + isNull(c.MailingPostalCode);
            options.add(new SelectOption(c.Id,c_Label));
            }
        
        return options;
        }

    private Integer QtrCount = 0;

//    private Date CurrentQtr_StartDate;
//    private Date CurrentQtr_EndDate;
//    private Date NextQtr_StartDate;
//    private Date NextQtr_EndDate;
//    private Boolean CurrentQtr_AlreadyExists = false;
//    private Boolean NextQtr_AlreadyExists = false;

    public String Qtr_to_Add { get; set;}
    
    public List<SelectOption> getQuarterList() {
        QtrCount = 0;
        List<SelectOption> options = new List<SelectOption>();
        
        Date StartDate = date.newInstance(2010, 7, 1);
        Date TodaysDate = date.today();
        
        Boolean allQuartersProcessed = false;
        Date CurrentDate = StartDate;
        Date QtrStartDate;
        Date QtrEndDate;
        Boolean QtrExists = false;
        
        
        do {
            Integer CurrentMonth = CurrentDate.toStartOfMonth().month();
            if ((CurrentMonth >=1) && (CurrentMonth <=3))   {QtrStartDate = date.newinstance(CurrentDate.year(), 1, 1);}
            if ((CurrentMonth >=4) && (CurrentMonth <=6))   {QtrStartDate = date.newinstance(CurrentDate.year(), 4, 1);}
            if ((CurrentMonth >=7) && (CurrentMonth <=9))   {QtrStartDate = date.newinstance(CurrentDate.year(), 7, 1);}
            if ((CurrentMonth >=10) && (CurrentMonth <=12)) {QtrStartDate = date.newinstance(CurrentDate.year(), 10, 1);}

            QtrEndDate = QtrStartDate.addMonths(3).addDays(-1);
            
            QtrExists = false;
            for(Service_Provider_Profile__c spp:DIFM_Installer_Data.Service_Provider_Profile__r)
            {
                if (spp.Effective_Date__c == QtrStartDate) {QtrExists = true;}
            }
            
            if (!QtrExists)
            {
                String spp_Label = Date_Functions.getFormattedDate(QtrStartDate,1) + ' - ' + Date_Functions.getFormattedDate(QtrEndDate,1);
                options.add(new SelectOption(String.valueOf(QtrStartDate),spp_Label));
                QtrCount++;
            }
            
            CurrentDate = QtrStartDate.addMonths(3);
            
            if (CurrentDate > TodaysDate.addMonths(3))
            {
                allQuartersProcessed = true;
            }
            
        } while (allQuartersProcessed == false);
        
        return options;
    }

/*
    public List<SelectOption> getCurrentandNextQuarters() {
        List<SelectOption> options = new List<SelectOption>();
        
        Date TodaysDate = date.today();
        
        Integer CurrentMonth = TodaysDate.toStartOfMonth().month();
        if ((CurrentMonth >=1) && (CurrentMonth <=3))   {CurrentQtr_StartDate = date.newinstance(TodaysDate.year(), 1, 1);}
        if ((CurrentMonth >=4) && (CurrentMonth <=6))   {CurrentQtr_StartDate = date.newinstance(TodaysDate.year(), 4, 1);}
        if ((CurrentMonth >=7) && (CurrentMonth <=9))   {CurrentQtr_StartDate = date.newinstance(TodaysDate.year(), 7, 1);}
        if ((CurrentMonth >=10) && (CurrentMonth <=12)) {CurrentQtr_StartDate = date.newinstance(TodaysDate.year(), 10, 1);}
        
        CurrentQtr_EndDate = CurrentQtr_StartDate.addMonths(3).addDays(-1);
        NextQtr_StartDate = CurrentQtr_StartDate.addMonths(3);
        NextQtr_EndDate = NextQtr_StartDate.addMonths(3).addDays(-1);

        for(Service_Provider_Profile__c spp:DIFM_Installer_Data.Service_Provider_Profile__r)
            {
            if (spp.Effective_Date__c == CurrentQtr_StartDate) {CurrentQtr_AlreadyExists = true;}
            if (spp.Effective_Date__c == NextQtr_StartDate) {NextQtr_AlreadyExists = true;}
            }

        String spp_Label = ''; 
        if (CurrentQtr_AlreadyExists == false)
            {
            spp_Label = Date_Functions.getFormattedDate(CurrentQtr_StartDate,1) + ' - ' + Date_Functions.getFormattedDate(CurrentQtr_EndDate,1);
            options.add(new SelectOption('CurrentQtr',spp_Label));
            }
            
        if (NextQtr_AlreadyExists == false)
            {
            spp_Label = Date_Functions.getFormattedDate(NextQtr_StartDate,1) + ' - ' + Date_Functions.getFormattedDate(NextQtr_EndDate,1);
            options.add(new SelectOption('NextQtr',spp_Label));
            }
        
        return options;
    }
*/
    public PageReference createServiceProviderProfile() {
        PageReference result;
        
        //Create ServiceProviderProfile Object
        Service_Provider_Profile__c newSPP = new Service_Provider_Profile__c();

        Date Qtr_StartDate = date.valueOf(Qtr_to_Add);
        Date Qtr_EndDate = Qtr_StartDate.addMonths(3).addDays(-1);

        newSPP.Effective_Date__c = Qtr_StartDate;
        newSPP.Expiry_Date__c = Qtr_EndDate;
        newSPP.Workdays_in_a_Year__c = 307;

/*
        if (Qtr_to_Add == 'CurrentQtr') 
            {
            newSPP.Effective_Date__c = CurrentQtr_StartDate;
            newSPP.Expiry_Date__c = CurrentQtr_EndDate;
            newSPP.Workdays_in_a_Year__c = 307;
            }
        else
        if (Qtr_to_Add == 'NextQtr') 
            {
            newSPP.Effective_Date__c = NextQtr_StartDate;
            newSPP.Expiry_Date__c = NextQtr_EndDate;
            newSPP.Workdays_in_a_Year__c = 307;
            }
*/
        
        newSPP.Contact__c = SelectedContactId_for_New_SPP;
        newSPP.DIFM_Installer_Data__c = DIFM_Installer_Data.Id;
        
        if (DIFM_Installer_Data.Contact__c != SelectedContactId_for_New_SPP)
            {DIFM_Installer_Data.Contact__c = SelectedContactId_for_New_SPP;
             update DIFM_Installer_Data;}

        if (SPP_How_to_Create == 'Default') 
            {
            newSPP.Oil_Change_Volume_Number_of_Months__c = 12;
            newSPP.CPRO_Vol_Verification_Number_of_Months__c = 12;
            newSPP.Average_Quarts_of_Oil_per_Oil_Change__c = 5;
            }
        else
            {
            Id SPPtoCloneFromId;
            Service_Provider_Profile__c SPPtoCloneFrom;
            
            SPPtoCloneFromId = SPP_How_to_Create;
            
            SPPtoCloneFrom = [SELECT Percentage_of_Premium_Oil_Sales__c,
                                     Oil_Change_Volume_Number_of_Months__c,
                                     Number_of_Stores__c,
                                     Effective_Hourly_Labor_Rate__c,
                                     Customers_Returning_for_First_Oil_Change__c,
                                     Channel__c,
                                     Car_Wash__c,
                                     CPRO_Vol_Verification_Number_of_Months__c,
                                     Avg_Annual_Lubricant_Volume_per_Store__c,
                                     Average_Quarts_of_Oil_per_Oil_Change__c,
                                     Average_Monthly_Used_Vehicle_Sales__c,
                                     Average_Monthly_New_Vehicle_Sales__c,
                                     Average_Monthly_Customer_Retention_Rate__c,
                                     Average_Monthly_CPRO_Volume__c,
                                     Average_Hours_per_Repair_Order__c,
                                     Average_Daily_Total_Car_Count_per_Store__c,
                                     Total_Annual_Lubricant_Volume_per_Store__c
                                FROM Service_Provider_Profile__c
                               WHERE Id = :SPPtoCloneFromId];
                
            newSPP.Percentage_of_Premium_Oil_Sales__c = SPPtoCloneFrom.Percentage_of_Premium_Oil_Sales__c;
            newSPP.Oil_Change_Volume_Number_of_Months__c = SPPtoCloneFrom.Oil_Change_Volume_Number_of_Months__c;
            newSPP.Number_of_Stores__c = SPPtoCloneFrom.Number_of_Stores__c;
            newSPP.Effective_Hourly_Labor_Rate__c = SPPtoCloneFrom.Effective_Hourly_Labor_Rate__c;
            newSPP.Customers_Returning_for_First_Oil_Change__c = SPPtoCloneFrom.Customers_Returning_for_First_Oil_Change__c;
            newSPP.Channel__c = SPPtoCloneFrom.Channel__c;
            newSPP.Car_Wash__c = SPPtoCloneFrom.Car_Wash__c;
            newSPP.CPRO_Vol_Verification_Number_of_Months__c = SPPtoCloneFrom.CPRO_Vol_Verification_Number_of_Months__c;
            newSPP.Total_Annual_Lubricant_Volume_per_Store__c = SPPtoCloneFrom.Total_Annual_Lubricant_Volume_per_Store__c;
            newSPP.Average_Quarts_of_Oil_per_Oil_Change__c = SPPtoCloneFrom.Average_Quarts_of_Oil_per_Oil_Change__c;
            newSPP.Average_Monthly_Used_Vehicle_Sales__c = SPPtoCloneFrom.Average_Monthly_Used_Vehicle_Sales__c;
            newSPP.Average_Monthly_New_Vehicle_Sales__c = SPPtoCloneFrom.Average_Monthly_New_Vehicle_Sales__c;
            newSPP.Average_Monthly_Customer_Retention_Rate__c = SPPtoCloneFrom.Average_Monthly_Customer_Retention_Rate__c;
            newSPP.Average_Monthly_CPRO_Volume__c = SPPtoCloneFrom.Average_Monthly_CPRO_Volume__c;
            newSPP.Average_Hours_per_Repair_Order__c = SPPtoCloneFrom.Average_Hours_per_Repair_Order__c;
            newSPP.Average_Daily_Total_Car_Count_per_Store__c = SPPtoCloneFrom.Average_Daily_Total_Car_Count_per_Store__c;
            }
        
        insert newSPP;
        
        //Populate ServiceProfile Records
        
        List<Service_Profile__c> newSPs = new List<Service_Profile__c>();
        
        List<Valvoline_Services_Question_Default__c> questionList;

        if (SPP_How_to_Create == 'Default') 
            {       
            questionList = [SELECT 
                                    Buying_Valvoline_Default__c, 
                                    Average_Daily_Service_Volume_Default__c, 
                                    Retail_Price_Default__c, 
                                    Current_Installer_Product_Cost_Default__c, 
                                    Include_Labor_Rate_Default__c, 
                                    Percent_of_Hour_to_Complete_Default__c, 
                                    Average_Labor_Hourly_Cost_Default__c, 
                                    Show_Labor_Costs__c, 
                                    Average_Daily_Service_Volume_Suffix__c, 
                                    Current_Installer_Product_Cost_Suffix__c, 
                                    Quart_Cost_Label__c, 
                                    Quart_Cost_Suffix__c, 
                                    Id, 
                                    Name, 
                                    LastActivityDate, 
                                    Service_Question__c,
                                    Generic_Question__c,
                                    Generic_Question__r.Id,
                                    Generic_Question__r.Question__c,
                                    Generic_Question__r.Question_Abbreviated__c,
                                    Generic_Question__r.List_Position__c,
                                    Generic_Question__r.Type__c,
                                    Generic_Question__r.Indent_Level__c,
                                    Generic_Question__r.Answer_Field_Type__c,
                                    Generic_Question__r.Answer_Field_Type_Custom__c,
                                    Generic_Question__r.Number_of_Decimal_Places__c,
                                    Generic_Question__r.Default_Value__c,
                                    Generic_Question__r.Answer_Target_Object__c,
                                    Generic_Question__r.Answer_Target_Field__c,
                                    Generic_Question__r.Answer_Picklist_Values__c,
                                    Generic_Question__r.Answer_Prefix__c,
                                    Generic_Question__r.Answer_Suffix__c
                               FROM Valvoline_Services_Question_Default__c
                              WHERE Generic_Question__r.Active__c = True
                           ORDER BY Generic_Question__r.List_Position__c ASC];
                           
            for (Valvoline_Services_Question_Default__c q:questionList) 
                {
                Service_Profile__c newSP = new Service_Profile__c();
                newSP.Valvoline_Services_Question_Default__c = q.Id;
                newSP.Generic_Question__c = q.Generic_Question__c;
                newSP.Service_Provider_Profile__c = newSPP.Id;
                
                newSP.Retail_Price__c = q.Retail_Price_Default__c;
                newSP.Percent_of_Hours_to_Complete__c = q.Percent_of_Hour_to_Complete_Default__c;
                newSP.Include_Labor_Rate__c = q.Include_Labor_Rate_Default__c;
                newSP.Current_Installer_Product_Cost__c = q.Current_Installer_Product_Cost_Default__c;
                newSP.Buying_Valvoline__c = q.Buying_Valvoline_Default__c;
                newSP.Average_Daily_Service_Volume__c = q.Average_Daily_Service_Volume_Default__c;
                
                newSPs.add(newSP);
                }   
            }               
        else
            {
            //Support Clone Functionality
            Id SPPtoCloneFromId;
            Service_Provider_Profile__c SPPtoCloneFrom;
            
            SPPtoCloneFromId = SPP_How_to_Create;
            
            List<Service_Profile__c> SPstoCloneFrom = new List<Service_Profile__c>();
            
            SPstoCloneFrom = [SELECT Generic_Question__c,
                                     Generic_Question__r.List_Position__c,
                                     Valvoline_Services_Question_Default__c,
                                     Retail_Price__c,
                                     Percent_of_Hours_to_Complete__c,
                                     Include_Labor_Rate__c,
                                     Current_Installer_Product_Cost__c,
                                     Buying_Valvoline__c,
                                     Average_Daily_Service_Volume__c
                                FROM Service_Profile__c
                               WHERE Service_Provider_Profile__c = :SPPtoCloneFromId
                              ORDER BY Generic_Question__r.List_Position__c ASC];


            for (Service_Profile__c q:SPstoCloneFrom) 
                {
                Service_Profile__c newSP = new Service_Profile__c();
                newSP.Valvoline_Services_Question_Default__c = q.Valvoline_Services_Question_Default__c;
                newSP.Generic_Question__c = q.Generic_Question__c;
                newSP.Service_Provider_Profile__c = newSPP.Id;
                
                newSP.Retail_Price__c = q.Retail_Price__c;
                newSP.Percent_of_Hours_to_Complete__c = q.Percent_of_Hours_to_Complete__c;
                newSP.Include_Labor_Rate__c = q.Include_Labor_Rate__c;
                newSP.Current_Installer_Product_Cost__c = q.Current_Installer_Product_Cost__c;
                newSP.Buying_Valvoline__c = q.Buying_Valvoline__c;
                newSP.Average_Daily_Service_Volume__c = q.Average_Daily_Service_Volume__c;
                
                newSPs.add(newSP);
                }   
                               
            }           
        
        insert newSPs;
        
        
        //Clear the DIFM_Installer_Data object so it requeries
        DIFM_Installer_Data = null;
        InitialActions();
        
        //Go to Edit Screen of ServiceProviderProfile   
        //result = new PageReference('/' + newSPP.id + '/e');
        //result.setRedirect(true);
        
        EditURL = '/' + newSPP.id + '/e?retURL=/' + Account_from_stdController.Id;

        return result;
    }

    public String EditURL { get; set; }

    public PageReference deleteSPP()
    {
     Id idToDelete = System.currentPageReference().getParameters().get('idToDelete');

    try {
         Service_Provider_Profile__c sppToDelete = [SELECT Id FROM Service_Provider_Profile__c WHERE Id = :idToDelete];
         delete sppToDelete;
    } catch (Exception e) {}
     
     return null;
    }
    
    public String isNull(String ValueIn, String ReturnValue) {
        String result = '';
        if ((ValueIn == null) || (ValueIn == 'null')) {result = ReturnValue;} else {result = ValueIn;}      
        return result;
    }
    
    public String isNull(String ValueIn) {
        String result = '';
        if ((ValueIn == null) || (ValueIn == 'null')) {result = '';} else {result = ValueIn;}       
        return result;
    }
    
}
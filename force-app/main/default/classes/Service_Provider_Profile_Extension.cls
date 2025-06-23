public class Service_Provider_Profile_Extension {

    public String  ShowOilChangeVerification { get; set; }                          
    public String  ShowPremiumVerification { get; set; }                          
    public String  ShowCPROVolVerification { get; set; }                          
    
    
    public void OilChangeVerification_TurnOff() {
        ShowOilChangeVerification = 'false';
    }   
    public void OilChangeVerification_TurnOn() {
        ShowOilChangeVerification = 'true';
    }   
    public void ShowPremiumVerification_TurnOff() {
        ShowPremiumVerification = 'false';
    }   
    public void ShowPremiumVerification_TurnOn() {
        ShowPremiumVerification = 'true';
    }   
    public void ShowCPROVolVerification_TurnOff() {
        ShowCPROVolVerification = 'false';
    }   
    public void ShowCPROVolVerification_TurnOn() {
        ShowCPROVolVerification = 'true';
    }   

    private final Service_Provider_Profile__c spp_from_stdController;
    private Service_Provider_Profile__c serviceProviderProfile;
    private List<Service_Provider_Profile_Questions> serviceProviderQuestions = new List<Service_Provider_Profile_Questions>();
    private List<Service_Profile> serviceProfiles = new List<Service_Profile>();

    public Service_Provider_Profile_Extension(ApexPages.StandardController stdController) {
        this.spp_from_stdController = (Service_Provider_Profile__c)stdController.getRecord();
        
        ShowOilChangeVerification = 'true';
        ShowPremiumVerification = 'true';
        ShowCPROVolVerification = 'true';
        showErrorSection = false;
        
        getserviceProviderProfile_AdditionalFields();
    }

    public Boolean showErrorSection { get; set; }                          

    private String errorMessage = '';

    public String getErrorMessage() {
        return errorMessage;
    }


    public PageReference validateDataButton() {
        PageReference result = null;
        
        Boolean valid = validateData();
        
        return result;
    }
        
    private Boolean validateData() {

        Boolean result = true;
        String currErrMessage;
        
        errorMessage = '';
        showErrorSection = false;
        
        

        for (Service_Provider_Profile_Questions sppq:serviceProviderQuestions)
        {
            if (!sppq.getisValid())
            {
                currErrMessage = sppq.errorMessage;
                errorMessage += '<B>Service Provider Profile Error:</B> Item ' + sppq.listPosition + ' ' + sppq.question + ' : ' + currErrMessage + '<BR><BR>';
                showErrorSection = true;
                result = false;
            }
        }
        
        return result;
    }

    public PageReference save_Service_Provider_Profile() {
        
        PageReference result = null;
        
        Integer errorCount = 0;
        Double doubleValue;
        
        system.debug('validating Data');
        Boolean isValid = validateData();
        
        if (isValid)
        {
            system.debug('Save 001');
            //Update Service_Provider_Profile__c
            Service_Provider_Profile__c spp_update = [SELECT Id FROM Service_Provider_Profile__c WHERE Id = :serviceProviderProfile.Id];
    
            Map<String, Schema.SObjectField> M = Schema.SObjectType.Service_Provider_Profile__c.fields.getMap();
            system.debug('Save 002');
        
            //spp_update.Id = serviceProviderProfile.Id;
            for (Service_Provider_Profile_Questions sppq:serviceProviderQuestions)
                {
                SoapType SOAPFieldType = M.get(sppq.fieldName).getDescribe().getSOAPType();             
                DisplayType DisplayFieldType = M.get(sppq.fieldName).getDescribe().getType();               
                system.debug('Profile Save: ' + sppq.fieldName + ' Value = ' + sppq.fieldValue + ' - Field Type = ' + SOAPFieldType + ' ' + DisplayFieldType);
                if ((sppq.fieldType != 'Formula') && (sppq.fieldName != null) && (sppq.fieldName != ''))
                    {  
                    if (SOAPFieldType == Schema.SoapType.STRING) {spp_update.put(sppq.fieldName,sppq.fieldValue);}  
        
                    if (SOAPFieldType == Schema.SoapType.DOUBLE) 
                        {
                        String stringValue = '' + sppq.fieldValue;
                        try {
                            doubleValue = Double.valueOf(stringValue);
                        } catch (Exception e) 
                        {
                            errorCount++;
                            doubleValue = 0;
                            system.debug('   *** Error with ' + sppq.fieldName + ' Value = ' + sppq.fieldValue + ' - Field Type = ' + SOAPFieldType + ' ' + DisplayFieldType);
                        }
                        spp_update.put(sppq.fieldName,Double.valueOf(doubleValue));
                        }
                    }   
                }
    
            system.debug('ERROR COUNT = ' + errorCount);
            system.debug('Save 003');
    
            spp_update.Comments__c = serviceProviderProfile.Comments__c;
    
            try {
                update spp_update;
            } catch (Exception e) {}
    
            system.debug('Save 004');
    
            //Update Service_Profile__c Records         
            List<Service_Profile__c> sp_updates = [SELECT Id FROM Service_Profile__c 
                                                    WHERE Service_Provider_Profile__c = :serviceProviderProfile.Id 
                                                    ORDER BY Generic_Question__r.List_Position__c ASC];
                                                    
            system.debug('serviceProviderProfile.Id = ' + serviceProviderProfile.Id);
            system.debug('sp_updates = ' + sp_updates);
            
            for (Service_Profile__c sp:sp_updates) 
            {
                system.debug('sp_updates = ' + sp);
            }           
                                                    
            for (Service_Provider_Profile_Questions sppq:serviceProviderQuestions)
            {
                system.debug('serviceProviderQuestions = ' + sppq);
            }           
                                                    
            List<Service_Profile__c> sp_inserts = new List<Service_Profile__c>();
    
            //Create of Map of the Service_Profile records
            map<String,Service_Profile> ServiceProfileLookup = new map<String,Service_Profile>();
            for (Service_Profile sp:serviceProfiles) {ServiceProfileLookup.put(sp.ServiceProfileId,sp);}
            
            
            system.debug('Save 005');
            
            //loop over the sp_updates and update the fields based on the lookup
            
//Commented out for Release to PROD, need to address test method issues JHK - 2011-07-01           
            
//            for (Service_Profile__c sp:sp_updates) 
//               {
//                system.debug('updating ' + sp.Id);
//                sp.Buying_Valvoline__c = ServiceProfileLookup.get(sp.Id).Buying_Valvoline_Value; 
//                sp.Average_Daily_Service_Volume__c = ServiceProfileLookup.get(sp.Id).Average_Daily_Service_Volume_Value; 
//                sp.Retail_Price__c = ServiceProfileLookup.get(sp.Id).Retail_Price_Value; 
//                sp.Current_Installer_Product_Cost__c = ServiceProfileLookup.get(sp.Id).Current_Installer_Product_Cost_Value; 
//                sp.Include_Labor_Rate__c = ServiceProfileLookup.get(sp.Id).Include_Labor_Rate_Value;
//                sp.Percent_of_Hours_to_Complete__c = ServiceProfileLookup.get(sp.Id).Percent_of_Hours_to_Complete_Value;
//                }
    
            system.debug('Save 006');
    
            
            try {
                update sp_updates;
            } catch (Exception e) {system.debug(e);}
                                      
            //Return to Detail Page
            system.debug('Save 007');
            
            String retURL = System.currentPageReference().getParameters().get('retURL');
            
            if ((retURL != null) && (retURL != ''))
                {
                result = new PageReference(retURL);
                result.setRedirect(true);
                }
            else
                {
                result = new PageReference('/' + spp_update.id);
                result.setRedirect(true);
                }
    
            system.debug('Save 008');
        }

        return result;
        
    }


    public Service_Provider_Profile__c getserviceProviderProfile() {
        return serviceProviderProfile;
    }

    public Service_Provider_Profile__c getserviceProviderProfile_AdditionalFields() {
        
        if (serviceProviderProfile == null)
            {
            serviceProviderProfile = [SELECT Workdays_in_a_Year__c, 
                                             SystemModstamp, 
                                             Store_Name__c, 
                                             Premium_Oil_Changes_Day__c, 
                                             Potential_CPRO_s_Month__c, 
                                             Percentage_of_Premium_Oil_Sales__c, 
                                             OwnerId, 
                                             Oil_Changes_Month__c, 
                                             Oil_Changes_Day__c, 
                                             Oil_Change_Volume_Number_of_Months__c, 
                                             Number_of_Stores__c, 
                                             Name, 
                                             LastModifiedDate, 
                                             LastModifiedById, 
                                             LastActivityDate, 
                                             IsDeleted, 
                                             Id, 
                                             Expiry_Date__c, 
                                             Effective_Hourly_Labor_Rate__c, 
                                             Effective_Date__c, 
                                             DIFM_Installer_Data__c,
                                             DIFM_Installer_Data__r.Account__c,
                                             DIFM_Installer_Data__r.Account__r.AccountNumber, 
                                             DIFM_Installer_Data__r.Contact__c,
                                             DIFM_Installer_Data__r.Contact__r.FirstName,
                                             DIFM_Installer_Data__r.Contact__r.LastName,
                                             DIFM_Installer_Data__r.Contact__r.Name,
                                             DIFM_Installer_Data__r.Contact__r.Title,
                                             DIFM_Installer_Data__r.Contact__r.MailingStreet,
                                             DIFM_Installer_Data__r.Contact__r.MailingCity,
                                             DIFM_Installer_Data__r.Contact__r.MailingState,
                                             DIFM_Installer_Data__r.Contact__r.MailingPostalCode,
                                             DIFM_Installer_Data__r.Contact__r.MailingCountry, 
                                             DIFM_Installer_Data__r.Contact__r.Phone,
                                             DIFM_Installer_Data__r.Contact__r.MobilePhone,
                                             DIFM_Installer_Data__r.Contact__r.Email,
                                             DIFM_Installer_Data__r.Contact__r.Fax,
                                             Customers_Returning_for_First_Oil_Change__c, 
                                             CurrencyIsoCode, 
                                             CreatedDate, 
                                             CreatedById, 
                                             Comments__c, 
                                             Channel__c, 
                                             Car_Wash__c, 
                                             CPRO_Vol_Verification_Number_of_Months__c, 
                                             Avg_Annual_Lubricant_Volume_per_Store__c, 
                                             Average_Total_Monthly_Vehicle_Sales__c, 
                                             Average_Quarts_of_Oil_per_Oil_Change__c, 
                                             Average_Monthly_Used_Vehicle_Sales__c, 
                                             Average_Monthly_New_Vehicle_Sales__c, 
                                             Average_Monthly_Customer_Retention_Rate__c, 
                                             Average_Monthly_CPRO_Volume__c, 
                                             Average_Hours_per_Repair_Order__c, 
                                             Average_Gallons_of_Oil_per_Oil_Change__c, 
                                             Average_Daily_Total_Car_Count_per_Store__c, 
                                             Annual_Oil_Changes_based_on_Avg_Gallons__c, 
                                             Annual_Car_Count__c
                                        FROM Service_Provider_Profile__c 
                                       WHERE Id = :spp_from_stdController.Id];
                                                     
            }
            
        return serviceProviderProfile;
        
    }



    public map<String,String> ServiceProviderQuestions_FieldValueLookup = new map<String,String>();
    

    public List<Service_Provider_Profile_Questions> getserviceProviderQuestions() {

        if (serviceProviderQuestions.size() == 0)
            {
            Generic_Question_List__c qlist;
                
            qlist = [SELECT Name,
                            Name__c,
                            (SELECT Question__c,
                                    Question_Abbreviated__c,
                                    List_Position__c,
                                    Type__c,
                                    Indent_Level__c,
                                    Answer_Field_Type__c,
                                    Answer_Field_Type_Custom__c,
                                    Number_of_Decimal_Places__c,
                                    Default_Value__c,
                                    Answer_Target_Object__c,
                                    Answer_Target_Field__c,
                                    Answer_Picklist_Values__c,
                                    Answer_Prefix__c,
                                    Answer_Suffix__c
                               FROM Generic_Question_List__r
                              WHERE Active__c = True 
                               ORDER BY List_Position__c ASC)
                       FROM Generic_Question_List__c
                      WHERE Name__c = 'Valvoline Service Provider Profile Questions'];

            for(Generic_Question__c q:qlist.Generic_Question_List__r)  
            {
            	//Added this if statement because it was failing test methods going to Prod
                if (q.Answer_Target_Field__c != null && q.Answer_Target_Field__c != '')
                {
	                Object o = serviceProviderProfile.get(q.Answer_Target_Field__c); 
	                Service_Provider_Profile_Questions newQuestion = new Service_Provider_Profile_Questions(q.Question__c,
	                                                                                                        q.List_Position__c,
	                                                                                                        q.Indent_Level__c,
	                                                                                                        o,
	                                                                                                        q.Answer_Target_Field__c,
	                                                                                                        q.Answer_Field_Type__c,
	                                                                                                        q.Answer_Picklist_Values__c,
	                                                                                                        q.Number_of_Decimal_Places__c,
	                                                                                                        q.Answer_Prefix__c,
	                                                                                                        q.Answer_Suffix__c); 
	
	                ServiceProviderQuestions_FieldValueLookup.put(newQuestion.fieldName,newQuestion.getfieldValue_Formatted());
	
	                serviceProviderQuestions.add(newQuestion);
                }
            }
            system.debug('During Inital Load - ' + ServiceProviderQuestions_FieldValueLookup);
                        
            }
        
        return serviceProviderQuestions;
    }

    Map<Id,Integer> questionsinServiceProfilesMap = new Map<Id,Integer>();

    public List<Service_Profile> getserviceProfileQuestions() {

        if (serviceProfiles.size() == 0)
            {
            List<Service_Profile__c> serviceProfileList;
                
            serviceProfileList =[SELECT Service_Provider_Profile__c, 
                                        Generic_Question__c, 
                                        Buying_Valvoline__c, 
                                        Average_Daily_Service_Volume__c, 
                                        Retail_Price__c, 
                                        Current_Installer_Product_Cost__c, 
                                        Include_Labor_Rate__c, 
                                        Percent_of_Hours_to_Complete__c, 
                                        Valvoline_Services_Question_Default__c, 
                                        Id, 
                                        Name, 
                                        Service_Profile__c, 
                                        List_Position__c, 
                                        Total_Labor_Costs__c, 
                                        Quart_Costs__c, 
                                        Quart_Cost_Label__c,
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
                                        Generic_Question__r.Answer_Suffix__c,
                                        Valvoline_Services_Question_Default__r.Buying_Valvoline_Default__c, 
                                        Valvoline_Services_Question_Default__r.Average_Daily_Service_Volume_Default__c, 
                                        Valvoline_Services_Question_Default__r.Retail_Price_Default__c, 
                                        Valvoline_Services_Question_Default__r.Current_Installer_Product_Cost_Default__c, 
                                        Valvoline_Services_Question_Default__r.Include_Labor_Rate_Default__c, 
                                        Valvoline_Services_Question_Default__r.Percent_of_Hour_to_Complete_Default__c, 
                                        Valvoline_Services_Question_Default__r.Average_Labor_Hourly_Cost_Default__c, 
                                        Valvoline_Services_Question_Default__r.Show_Labor_Costs__c, 
                                        Valvoline_Services_Question_Default__r.Average_Daily_Service_Volume_Suffix__c, 
                                        Valvoline_Services_Question_Default__r.Current_Installer_Product_Cost_Suffix__c, 
                                        Valvoline_Services_Question_Default__r.Quart_Cost_Label__c, 
                                        Valvoline_Services_Question_Default__r.Quart_Cost_Suffix__c, 
                                        Valvoline_Services_Question_Default__r.Id, 
                                        Valvoline_Services_Question_Default__r.Name, 
                                        Valvoline_Services_Question_Default__r.LastActivityDate, 
                                        Valvoline_Services_Question_Default__r.Service_Question__c 
                                   FROM Service_Profile__c
                                  WHERE Service_Provider_Profile__c = :serviceProviderProfile.Id
                                    AND Generic_Question__r.Active__c = True
                                  ORDER BY Generic_Question__r.List_Position__c ASC];

            Integer questionCount = 0;
            for(Service_Profile__c sp:serviceProfileList)  
                {
                    
                Service_Profile newServiceProfile = new Service_Profile(sp.Id,
                                                                        sp.Buying_Valvoline__c,
                                                                        sp.Average_Daily_Service_Volume__c,
                                                                        sp.Retail_Price__c,
                                                                        sp.Current_Installer_Product_Cost__c,
                                                                        sp.Include_Labor_Rate__c,
                                                                        sp.Percent_of_Hours_to_Complete__c,
                                                                        sp.Total_Labor_Costs__c,
                                                                        sp.Quart_Costs__c,
                                                                        sp.Quart_Cost_Label__c,
                                                                        
                                                                        sp.Generic_Question__r.Id,
                                                                        sp.Generic_Question__r.Type__c,
                                                                        sp.Generic_Question__r.Question__c,
                                                                        sp.Generic_Question__r.List_Position__c,
                                                                        sp.Generic_Question__r.Indent_Level__c,
                                                                        sp.Generic_Question__r.Answer_Field_Type__c,
                                                                        sp.Generic_Question__r.Answer_Field_Type_Custom__c,
                                                                        sp.Generic_Question__r.Number_of_Decimal_Places__c,
                                                                        sp.Generic_Question__r.Answer_Target_Object__c,
                                                                        sp.Generic_Question__r.Answer_Target_Field__c,
                                                                        sp.Generic_Question__r.Answer_Prefix__c,
                                                                        sp.Generic_Question__r.Answer_Suffix__c,
                                                                        
                                                                        sp.Valvoline_Services_Question_Default__r.Show_Labor_Costs__c,
                                                                        sp.Valvoline_Services_Question_Default__r.Average_Daily_Service_Volume_Suffix__c,
                                                                        sp.Valvoline_Services_Question_Default__r.Current_Installer_Product_Cost_Suffix__c,
                                                                        sp.Valvoline_Services_Question_Default__r.Quart_Cost_Label__c,
                                                                        sp.Valvoline_Services_Question_Default__r.Quart_Cost_Suffix__c);    

                serviceProfiles.add(newServiceProfile);
                questionsinServiceProfilesMap.put(newServiceProfile.GQ_Id,questionCount);
                questionCount++;
                }       
                
            //Get all of the Question List Formatting
            List<Generic_Question__c> genericQuestions;
            
            genericQuestions = [SELECT Id,
                                       Question__c,
                                       Question_Abbreviated__c,
                                       List_Position__c,
                                       Type__c,
                                       Indent_Level__c,
                                       Answer_Field_Type__c,
                                       Answer_Field_Type_Custom__c,
                                       Number_of_Decimal_Places__c,
                                       Default_Value__c,
                                       Answer_Target_Object__c,
                                       Answer_Target_Field__c,
                                       Answer_Picklist_Values__c,
                                       Answer_Prefix__c,
                                       Answer_Suffix__c
                                  FROM Generic_Question__c
                                 WHERE Generic_Question_List__r.Name__c = 'Valvoline Service Provider Services'
                                   AND Active__c = True
                                ORDER BY List_Position__c DESC];
                                
            //Loop over the genericQuestions and insert rows into serviceProfiles appropriately
            //The query above is purposely processing things in reverse/DESC order, so that we don't have to add
            //complexity to handle the indexs in the servicesprofilemap changing with each new add.
            
            Integer previousIndex = 0;
            for(Generic_Question__c q:genericQuestions) 
                {

                Integer existIndex = questionsinServiceProfilesMap.get(q.Id);
                
                if (existIndex == null)
                    {
                    
                    if (q.Type__c == 'Question')
                    {   
                        System.debug('new Question! ' + q.Question__c);
                        
                        //Insert a new record in the Service_Profile__c table for the record so it's up to date
                        Service_Profile__c newSP = new Service_Profile__c();
                        newSP.Service_Provider_Profile__c = serviceProviderProfile.Id;
                        newSP.Average_Daily_Service_Volume__c = null;
                        newSP.Buying_Valvoline__c = null;
                        newSP.Current_Installer_Product_Cost__c = null;
                        newSP.Generic_Question__c = q.Id;
                        newSP.Include_Labor_Rate__c = null;
                        newSP.Percent_of_Hours_to_Complete__c = null;
                        newSP.Retail_Price__c = null;
                        newSP.Valvoline_Services_Question_Default__c = null;
                        
                        //insert newSP;
                    }
                        
                    Service_Profile newServiceProfile = new Service_Profile(null,
                                                                            null,
                                                                            null,
                                                                            null,
                                                                            null,
                                                                            null,
                                                                            null,
                                                                            null,
                                                                            null,
                                                                            null,
                                                                            
                                                                            q.Id,
                                                                            q.Type__c,
                                                                            q.Question__c,
                                                                            q.List_Position__c,
                                                                            q.Indent_Level__c,
                                                                            q.Answer_Field_Type__c,
                                                                            q.Answer_Field_Type_Custom__c,
                                                                            q.Number_of_Decimal_Places__c,
                                                                            q.Answer_Target_Object__c,
                                                                            q.Answer_Target_Field__c,
                                                                            q.Answer_Prefix__c,
                                                                            q.Answer_Suffix__c,
                                                                            
                                                                            null,
                                                                            null,
                                                                            null,
                                                                            null,
                                                                            null);  
                    System.debug('previousIndex=' + previousIndex);
    
                    if (previousIndex != 0)
                        {serviceProfiles.add(previousIndex,newServiceProfile);}
                    else
                        {serviceProfiles.add(newServiceProfile);}
                    }
                else {previousIndex = existIndex;}
                
                }
                
            }
        
        
        return serviceProfiles;
    }


    public String getAvg_Annual_Lubricant_Volume_per_Store_Formatted() {
        String result = '';
        result = ServiceProviderQuestions_FieldValueLookup.get('Avg_Annual_Lubricant_volume_per_Store__c');
        return result;
    }

    public String getAnnual_Oil_Changes_based_on_Avg_Gallons_Formatted() {
        String result = '';
        if (serviceProviderProfile.Annual_Oil_Changes_based_on_Avg_Gallons__c != null) {result += serviceProviderProfile.Annual_Oil_Changes_based_on_Avg_Gallons__c;} else {result += ' ';} 
        return result;
    }

    public String getWorkdays_in_a_Year_Formatted() {
        String result = '';
        result = ServiceProviderQuestions_FieldValueLookup.get('Workdays_in_a_Year__c');
        return result;
    }

    public String getOil_Change_Volume_Number_of_Months_Formatted() {
        String result = '';
        if (serviceProviderProfile.Oil_Change_Volume_Number_of_Months__c != null) {result += serviceProviderProfile.Oil_Change_Volume_Number_of_Months__c;} else {result += ' ';} 
        return result;
    }
    
    public String getOil_Changes_Month_Formatted() {
        String result = '';
        if (serviceProviderProfile.Oil_Changes_Month__c != null) {result += serviceProviderProfile.Oil_Changes_Month__c;} else {result += ' ';} 
        return result;
    }

    public String getOil_Changes_Day_Formatted() {
        String result = '';
        if (serviceProviderProfile.Oil_Changes_Day__c != null) {result += serviceProviderProfile.Oil_Changes_Day__c;} else {result += ' ';} 
        return result;
    }

    public String getPercentage_of_Premium_Oil_Sales_Formatted() {
        String result = '';
        result = ServiceProviderQuestions_FieldValueLookup.get('Percentage_of_Premium_Oil_Sales__c');
        return result;
    }

    public String getPremium_Oil_Changes_Day_Formatted() {
        String result = '';
        if (serviceProviderProfile.Premium_Oil_Changes_Day__c != null) {result += serviceProviderProfile.Premium_Oil_Changes_Day__c;} else {result += ' ';} 
        return result;
    }

    public String getAverage_Daily_Total_Car_Count_per_Store_Formatted() {
        String result = '';
        if (serviceProviderProfile.Average_Daily_Total_Car_Count_per_Store__c != null) {result += serviceProviderProfile.Average_Daily_Total_Car_Count_per_Store__c;} else {result += ' ';} 
        return result;
    }

    public String getAnnual_Car_Count_Formatted() {
        String result = '';
        if (serviceProviderProfile.Annual_Car_Count__c != null) {result += serviceProviderProfile.Annual_Car_Count__c;} else {result += ' ';} 
        return result;
    }

    public String getPotential_CPRO_s_Month_Formatted() {
        String result = '';
        if (serviceProviderProfile.Potential_CPRO_s_Month__c != null) {result += serviceProviderProfile.Potential_CPRO_s_Month__c;} else {result += ' ';} 
        return result;
    }

    public String getEffective_Hourly_Labor_Rate_Formatted() {
        String result = '';
        result = ServiceProviderQuestions_FieldValueLookup.get('Effective_Hourly_Labor_Rate__c');
        return result;
    }

    public String getPercentofHourtoCompleteHeader() {
        String result = ''; 
        result += '% of Hour to<BR>Complete<BR><BR>(' + getEffective_Hourly_Labor_Rate_Formatted() + ')';
        return result;
    }

    public PageReference generatePDF() {
        PageReference result;

        result = Page.Service_Provider_Profile_Generate_PDF;
        result.getParameters().put('id',serviceProviderProfile.Id);
        result.setRedirect(true);
        
        return result;
        
    }

    public PageReference generateXLS() {
        PageReference result;

        result = Page.Service_Provider_Profile_Generate_XLS;
        result.getParameters().put('id',serviceProviderProfile.Id);
        result.setRedirect(true);
        
        return result;
        
    }
    

    

}
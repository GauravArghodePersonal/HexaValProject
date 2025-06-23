global class CaseWebService {
    
    private final static String MemoFileLocation = '\\\\wayfmsstg1\\Interface\\INBOUND\\MemoFiles\\';
    private final static String DevExProjectTypeInternal = '1040';
    private final static String DevExProjectTypeExternal = '1022';
    private final static String DoubleQuoteString = '"';
    private final static String FieldSeparatorString = '~';
    private final static String LineSeparatorString = '\n';
    private final static String FileSeparatorString = '~';
    private final static String SeparatorAfterFirstField = '^';
    private final static String EndOfTheLineSeparatorString = '|';
    
    // Aquarius field name, DevEx attr name
    private final static List<String[]> AQUARIUS_NON_MEMO_FIELDS = new List<String[]>{
        new String[]{       'Certificate_of_Analysis__c', 'ASH_TSR_COA'                },
        new String[]{                   'Clear_Color__c', 'ASH_TSR_CLEAR_COL'          },
        new String[]{                 'Coated_Tablet__c', 'ASH_TSR_COATED_TAB'         },
        new String[]{            'Coating_Conditions__c', 'ASH_TSR_COAT_COND'          },
        new String[]{                   'Core_Amount__c', 'ASH_TSR_CORE_AMOUNT'        },
        new String[]{     'Countries_of_End_Use_Sale__c', 'ASH_TSR_COUNTRY_END_USE'    },
        new String[]{                  'Custom_Color__c', 'ASH_TSR_CUST_COLOR'         },
        new String[]{       'Customer_Cores_Provided__c', 'ASH_TSR_CUST_CORE_PROV'     },
        new String[]{    'Declaration_of_Ingredients__c', 'ASH_TSR_DEC_INGREDIENTS'    },
        new String[]{                'Desired_Solids__c', 'ASH_TSR_SOLIDS_LOADING'     },
        new String[]{           'Desired_Weight_Gain__c', 'ASH_TSR_WEIGHT_GAIN'        },
        new String[]{       'Exact_Formulation_Match__c', 'ASH_TSR_EXACT_FORM_MATCH'   },
        new String[]{                   'Food_Market__c', 'ASH_TSR_FOOD'               },
        new String[]{                   'Label_Match__c', 'ASH_TSR_LABEL_MATCH'        },
        new String[]{                          'MSDS__c', 'ASH_TSR_MSDS'               },
        new String[]{            'Nutritional_Market__c', 'ASH_TSR_NUTRITION'          },
        new String[]{           'Other_Documentation__c', 'ASH_TSR_OTHER_DOCS'         },
        new String[]{                  'Other_Market__c', 'ASH_TSR_OTHER_MKTS'         },
        new String[]{                  'Other_Target__c', 'ASH_TSR_OTHER_TGTS'         },
        new String[]{          'Other_Target_Details__c', 'ASH_TSR_OTHER_TGTS_DET'     },
        new String[]{                 'Pharma_Market__c', 'ASH_TSR_PHARMA'             },
        new String[]{        'Plasticizer_Preference__c', 'ASH_TSR_PLASTICIZER_PREF'   },
        new String[]{         'Product_Specification__c', 'ASH_TSR_PRODUCT_SPECS'      },
        new String[]{   'Reconstitution_Instructions__c', 'ASH_TSR_RECONST_INSTRUCT'   },
        new String[]{                'Standard_Color__c', 'ASH_TSR_STD_COLOR'          },
        new String[]{                   'White_Color__c', 'ASH_TSR_WHITE_COLOR'        },
		new String[]{         'Product_to_be_matched__c', 'ASH_TSR_PRODUCT_TO_MATCH'   },
		new String[]{                 'Color_Details__c', 'ASH_TSR_COLOR_DETAILS'      },
		new String[]{           'Colorants_Preferred__c', 'ASH_TSR_PREF_PIGMENTS'      },
		new String[]{ 'Colorants_that_cannot_be_used__c', 'ASH_TSR_PROHIB_PIGMENTS'    }        
    };
    
    

    // TSR field name, DevEx attr name
    private final static List<String[]> TSR_NON_MEMO_FIELDS = new List<String[]>{
        new String[]{       						'Id', 'ISP_PROJ_TSR_ID'            },
        new String[]{           'Related_Opportunity__c', 'ISP_PROJ_OPP_ID'            },
        new String[]{          'Req_Comp_Date_String__c', 'ISP_PROJ_COMP_DATE'         },
        new String[]{         'Est_Start_Date_String__c', 'ISP_PROJ_START_DATE'        },
        new String[]{          'Est_Comp_Date_String__c', 'ISP_PROJ_TGT_DATE'          },
        new String[]{     	   'Tech_App_Date_String__c', 'ISP_PROJ_TECH_APP_DATE'     },
        new String[]{         'DevEx_Project_Manager__c', 'ISP_PROJ_RESOURCE_FN'       },
        new String[]{ 							'Reason', 'ISP_PROJ_REASONS'     	   },
        new String[]{   'Technical_Approval_Priority__c', 'ISP_PROJ_TECH_APP_PRI'      },
        new String[]{     'Technical_Risk_Assessment__c', 'ISP_PROJ_RISK_ASS'          }
    };
    
    // Aquarius field name, DevEx attr name - for value/memo file
    private final static List<String[]> AQUARIUS_MEMO_FIELDS = new List<String[]>
    { 
        new String[]{             'Coating_Objective__c', 'ASH_TSR_COAT_OBJECTIVE'     }, 
		new String[]{           'Coating_Description__c', 'ASH_TSR_COAT_DESC'          }, 
		new String[]{        'Coating_Equipment_Used__c', 'ASH_TSR_COAT_EQUIPMENT'     },
		new String[]{             'Coating_Substrate__c', 'ASH_TSR_COAT_SUBSTRATE'     },
		new String[]{              'Current_Supplier__c', 'ASH_TSR_CURRENT_SUPPLIER'   },
		new String[]{     'Customer_Core_Description__c', 'ASH_TSR_CUST_CORE_DESC'     },
		new String[]{          'Customer_Core_Issues__c', 'ASH_TSR_CUST_CORE_ISSUES'   },
		new String[]{             'Customer_Problems__c', 'ASH_TSR_CUST_CORE_PROBS'    },
		new String[]{'Customer_Product_Sensitivities__c', 'ASH_TSR_CUST_PROD_SENSITIVE'},
		new String[]{               'Desired_Solvent__c', 'ASH_TSR_SOLVENT'            },
		new String[]{   'Other_Documentation_Details__c', 'ASH_TSR_OTHER_DOCS_DETAILS' },	
		new String[]{          'Other_Market_Details__c', 'ASH_TSR_OTHER_MKTS_DET'     },
		new String[]{        'Required_Functionality__c', 'ASH_TSR_REQ_FUNCTIONALITY'  },
		new String[]{          'Quantitative_Formula__c', 'ASH_TSR_QUANT_FORMULA'  	   },																	
        new String[]{           'List_of_Ingredients__c', 'ASH_TSR_LIST_OF_INGRED'     },
        new String[]{           'Additional_Comments__c', 'ASH_TSR_ADD_COMMENTS'       }
    };
    
    // tsr field name, DevEx attr name - for value/memo file
    private final static List<String[]> TSR_MEMO_FIELDS = new List<String[]>
    { 
    	new String[]{             				'Objective__c', 'ISP_PROJ_OBJ'     		},
		new String[]{	   'What_type_of_sample_being_sent__c', 'ISP_PROJ_SMPMAT_RCV'   },
    	new String[]{             	 'Competitive_Products__c', 'ISP_PROJ_COMP_PRODUCT' },    	   
        new String[]{        		 'Describe_Work_Needed__c', 'ISP_PROJ_DET_DESC'     }
    };    

    webservice Static List<String> GetAllTSRData() {
        
        List<String> returnList = new List<String>();
        
        String currentRecord = '';
        
        try {
            List<String> OcBriefDataList = getAllOCBRIEFData();     
            if (OcBriefDataList.size() > 0) {returnList.addAll(OcBriefDataList);}
        
            List<String> OcProjAttValueList = getAllOcProjAttValueData();
            if (OcProjAttValueList.size() > 0) {returnList.addAll(OcProjAttValueList);}

            List<String> OcAttValueMemo = getAllOcAttValueMemo();
            if (OcAttValueMemo.size() > 0) {returnList.addAll(OcAttValueMemo);}
        } catch (Exception e) {
            System.debug('Error in Method GetAllTSRData: ' + e.getTypeName() + 
                         ' - ' + e.getCause() + ': ' + e.getMessage());
        }           
        return returnList;      
    
    }
    
    /*
        Method: updateCaseCreatedInDevEx
        Summary: Updates Cases created in DevEx
        Input: Comma separate string of case Ids
    */
    webservice Static void updateCasesFromCaseNumbers(string caseNumbers) {
        List<Case> caselist = GetCaseListFromCaseNumbers(caseNumbers);
        if (caseList == null || caseList.isEmpty()) {return;} 
        for (Case c: caseList) {
            c.DevEx_Transfer_Status__c = 'Created In DevEx';
        }
            
        try {DoUpdateCases(caselist);}
        catch (Exception e) {
            System.debug('Error in Method updateCasesFromCaseNumbers: ' + e.getTypeName() + 
                         ' - ' + e.getCause() + ': ' + e.getMessage());
            sendExceptionEmail('GetCaseListFromCaseNumbers', e);
        }       
    }
    
    /*
        Method: getAllOCBRIEFData
        Summary: Returns list of records that are used to write OCBRIEF.TXT file
        Sample Data Returned:
            "OCBRIEF2668.TXT", "","null","00110805","1000","00110805","null","APPROVED","0","1","APPROVED"
    */  
    private Static List<String> getAllOCBRIEFData() {
        List<String> returnList = new List<String>();
        List<Case> caseList = GetCaseListForDevEx();
        if (caseList == null || caseList.isEmpty()) {return returnList;}
        String currentRecord = '';

        for (Case c : caseList) {
            currentRecord = '' + 
            DoubleQuoteString + 'OCBRIEF' + c.CaseNumber + '.txt' + 
            DoubleQuoteString + SeparatorAfterFirstField + DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
            DoubleQuoteString + GetDevExProjectNumber(c.Internal_External__c) + DoubleQuoteString + FieldSeparatorString +
            DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString +
            DoubleQuoteString + '1000' + DoubleQuoteString + FieldSeparatorString +
            DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString +
            DoubleQuoteString + RemoveDelimiter(c.Subject) + DoubleQuoteString + FieldSeparatorString +
            DoubleQuoteString + 'APPROVED' + DoubleQuoteString + FieldSeparatorString +
            DoubleQuoteString + '0' + DoubleQuoteString + FieldSeparatorString +
            DoubleQuoteString + '1' + DoubleQuoteString + FieldSeparatorString +
            DoubleQuoteString + 'APPROVED' + DoubleQuoteString + EndOfTheLineSeparatorString;
                
            returnList.add(currentRecord);
        }       
        return returnList;
    }  


    /*
        Method: getCasesForOcBriefFileForCaseNumbers
        Summary: Returns list of records that are used to write OCBRIEF.TXT file
        Sample Data Returned:
            "","null","00110805","1000","00110805","null","APPROVED","0","1","APPROVED"
    */  
    private Static List<String> getCasesForOcBriefFileForCaseNumbers(string caseNumbers) {
        List<String> returnList = new List<String>();
        List<Case> caseList = GetCaseListFromCaseNumbers(caseNumbers);
        if (caseList == null || caseList.isEmpty()) {return returnList;}
        String currentRecord = '';
        
        for (Case c : caseList) {
            currentRecord = '' +
            DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
            DoubleQuoteString + GetDevExProjectNumber(c.Internal_External__c) + DoubleQuoteString + FieldSeparatorString +
            DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString +
            DoubleQuoteString + '1000' + DoubleQuoteString + FieldSeparatorString +
            DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString +
            DoubleQuoteString + NullStringToEmptyString(c.Subject) + DoubleQuoteString + FieldSeparatorString +
            DoubleQuoteString + 'APPROVED' + DoubleQuoteString + FieldSeparatorString +
            DoubleQuoteString + '0' + DoubleQuoteString + FieldSeparatorString +
            DoubleQuoteString + '1' + DoubleQuoteString + FieldSeparatorString +
            DoubleQuoteString + 'APPROVED' + DoubleQuoteString ;

            returnList.add(currentRecord);
        }       
        return returnList;
    }
   

    /*
        Method: getAllOcProjAttValueData
        Summary: Returns list of records for the input case numbers to write OCPROJATTVALUE.TXT file
        Input: Case Numbers
        Sample Data Returned:
            "OCPROJATTVALUE2668.TXT", "","1022","2668","ISP_PROJ_COMPANY","0","AAA Arz Dev Test”^","1022","2668","ISP_PROJ_CONTACT_FN","0","Joe"^"","1022","2668","ISP_BU","0","15"^
            "","1022","2668","ISP_PROJ_TECH_APP_PRI","0","10"
            "","1022","2668","ISP_PROJ_RISK_ASS","0","30"
            "","1022","2668","DXPM_PROJECT_ORG_UNIT","0","BIO"
            "OCPROJATTVALUE2669.TXT", "","1022","2668","ISP_PROJ_COMPANY","0","AAA Arz Dev Test”^","1022","2669","ISP_PROJ_CONTACT_FN","0","Joe"^"","1022","2669","ISP_BU","0","15"^
            "","1022","2669","ISP_PROJ_TECH_APP_PRI","0","10"
            "","1022","2669","ISP_PROJ_RISK_ASS","0","30"
            "","1022","2669","DXPM_PROJECT_ORG_UNIT","0","BIO"
    */  
    private Static List<String> getAllOcProjAttValueData() {
        List<String> returnList = new List<String>();
        List<Case> caseList = GetCaseListForDevEx();
        if (caseList == null || caseList.isEmpty()) {return returnList;}   
        String currentRecord = '';
        
        for (Case c : caseList) {
            String devExProjectType = GetDevExProjectNumber(c.Internal_External__c) ;
            
            returnList.Add(DoubleQuoteString + 'OCPROJATTVALUE' + c.CaseNumber + '.txt' + 
                DoubleQuoteString + SeparatorAfterFirstField +
                DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + devExProjectType + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + 'ISP_PROJ_COMPANY' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + '0' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + RemoveDelimiter(c.Account.Name) + DoubleQuoteString + EndOfTheLineSeparatorString) ;           

            returnList.Add(DoubleQuoteString + 'OCPROJATTVALUE' + c.CaseNumber + '.txt' + 
                DoubleQuoteString + SeparatorAfterFirstField +                        
                DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + devExProjectType + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + 'ISP_PROJ_COMP_ID' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + '0' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + RemoveDelimiter(c.Account.Id) + DoubleQuoteString + EndOfTheLineSeparatorString);
            
            returnList.Add(DoubleQuoteString + 'OCPROJATTVALUE' + c.CaseNumber + '.txt' + 
                DoubleQuoteString + SeparatorAfterFirstField +                        
                DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + devExProjectType + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString +               
                DoubleQuoteString + 'ISP_PROJ_CONT_ID' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + '0' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + RemoveDelimiter(c.Contact.Id) + DoubleQuoteString + EndOfTheLineSeparatorString);
       
            returnList.Add(DoubleQuoteString + 'OCPROJATTVALUE' + c.CaseNumber + '.txt' + 
                DoubleQuoteString + SeparatorAfterFirstField +                        
                DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + devExProjectType + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + 'ISP_PROJ_CONTACT_FN' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + '0' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + RemoveDelimiter(c.Contact.FirstName) + DoubleQuoteString + EndOfTheLineSeparatorString);
                                  
            returnList.Add(DoubleQuoteString + 'OCPROJATTVALUE' + c.CaseNumber + '.txt' + 
                DoubleQuoteString + SeparatorAfterFirstField +                        
                DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + devExProjectType + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + 'ISP_PROJ_CONTACT_LN' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + '0' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + RemoveDelimiter(c.Contact.LastName) + DoubleQuoteString + EndOfTheLineSeparatorString);

			string add1 = '', add2 = '', add3 = '';
			if (NullStringToEmptyString(c.Contact.MailingStreet) != '')
			{
				List<String> addressLines = c.Contact.MailingStreet.split('\n',3);
				if (addressLines.Size() > 0)
				{
					for (integer i = 0; i < addressLines.Size(); i++ )
					{
						if (i == 0) add1 = NullStringToEmptyString(addressLines[i]);
						if (i == 1) add2 = NullStringToEmptyString(addressLines[i]);
						if (i == 2) add3 = NullStringToEmptyString(addressLines[i]);						
					}

				}
			}			
                         
            returnList.Add(DoubleQuoteString + 'OCPROJATTVALUE' + c.CaseNumber + '.txt' + 
                DoubleQuoteString + SeparatorAfterFirstField +                        
                DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + devExProjectType + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + 'ISP_CONTACT_ADD1' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + '0' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + RemoveDelimiter(add1) + DoubleQuoteString + EndOfTheLineSeparatorString);
                                    
            returnList.Add(DoubleQuoteString + 'OCPROJATTVALUE' + c.CaseNumber + '.txt' + 
                DoubleQuoteString + SeparatorAfterFirstField +                        
                DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + devExProjectType + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + 'ISP_CONTACT_ADD2' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + '1' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + RemoveDelimiter(add2) + DoubleQuoteString + EndOfTheLineSeparatorString);
                                                
            returnList.Add(DoubleQuoteString + 'OCPROJATTVALUE' + c.CaseNumber + '.txt' + 
                DoubleQuoteString + SeparatorAfterFirstField +                        
                DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + devExProjectType + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + 'ISP_CONTACT_ADD3' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + '2' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + RemoveDelimiter(add3) + DoubleQuoteString + EndOfTheLineSeparatorString);
                                                                            
            returnList.Add(DoubleQuoteString + 'OCPROJATTVALUE' + c.CaseNumber + '.txt' + 
                DoubleQuoteString + SeparatorAfterFirstField +                        
                DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + devExProjectType + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + 'ISP_CONTACT_CITY' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + '0' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + RemoveDelimiter(c.Contact.MailingCity) + DoubleQuoteString + EndOfTheLineSeparatorString);
                                
            returnList.Add(DoubleQuoteString + 'OCPROJATTVALUE' + c.CaseNumber + '.txt' + 
                DoubleQuoteString + SeparatorAfterFirstField +                        
                DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + devExProjectType + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + 'ISP_CONTACT_STATE' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + '0' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + RemoveDelimiter(c.Contact.MailingState) + DoubleQuoteString + EndOfTheLineSeparatorString);
                                                                                             
            returnList.Add(DoubleQuoteString + 'OCPROJATTVALUE' + c.CaseNumber + '.txt' + 
                DoubleQuoteString + SeparatorAfterFirstField +                        
                DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + devExProjectType + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + 'ISP_CONTACT_ZIP' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + '0' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + RemoveDelimiter(c.Contact.MailingPostalCode) + DoubleQuoteString + EndOfTheLineSeparatorString);

            returnList.Add(DoubleQuoteString + 'OCPROJATTVALUE' + c.CaseNumber + '.txt' + 
                DoubleQuoteString + SeparatorAfterFirstField +                        
                DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + devExProjectType + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + 'ISP_PROJ_REG' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + '0' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + RemoveDelimiter(c.Account.SAP_Sales_Office_Desc__c) + DoubleQuoteString + EndOfTheLineSeparatorString);
            
            returnList.Add(DoubleQuoteString + 'OCPROJATTVALUE' + c.CaseNumber + '.txt' + 
                DoubleQuoteString + SeparatorAfterFirstField +                        
                DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + devExProjectType + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + 'ISP_PROJ_SUB_REG' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + '0' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + RemoveDelimiter(c.Account.SAP_Sales_Group_Desc__c) + DoubleQuoteString + EndOfTheLineSeparatorString);
            
            returnList.Add(DoubleQuoteString + 'OCPROJATTVALUE' + c.CaseNumber + '.txt' + 
                DoubleQuoteString + SeparatorAfterFirstField +                        
                DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + devExProjectType + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + 'ISP_PROJ_COUNTRY' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + '0' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + RemoveDelimiter(c.Account.BillingCountry) + DoubleQuoteString + EndOfTheLineSeparatorString);
            
            returnList.Add(DoubleQuoteString + 'OCPROJATTVALUE' + c.CaseNumber + '.txt' + 
                DoubleQuoteString + SeparatorAfterFirstField +                        
                DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + devExProjectType + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + 'ISP_PROJ_TECH_APP_FN' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + '0' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + RemoveDelimiter(c.Technical_Lab_Group_Manager__r.FirstName) + DoubleQuoteString + EndOfTheLineSeparatorString);                      
        
            returnList.Add(DoubleQuoteString + 'OCPROJATTVALUE' + c.CaseNumber + '.txt' + 
                DoubleQuoteString + SeparatorAfterFirstField +                        
                DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + devExProjectType + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + 'ISP_PROJ_TECH_APP_LN' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + '0' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + RemoveDelimiter(c.Technical_Lab_Group_Manager__r.LastName) + DoubleQuoteString + EndOfTheLineSeparatorString);

/*                
            returnList.Add(DoubleQuoteString + 'OCPROJATTVALUE' + c.CaseNumber + '.txt' + 
                DoubleQuoteString + SeparatorAfterFirstField +                        
                DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + devExProjectType + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + 'ISP_PROJ_TECH_OUTPUT' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + '0' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + NullStringToEmptyString(c.Required_Technical_Output__c) + DoubleQuoteString);
*/            

/*            
            returnList.Add(DoubleQuoteString + 'OCPROJATTVALUE' + c.CaseNumber + '.txt' + 
                DoubleQuoteString + SeparatorAfterFirstField +                        
                DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + devExProjectType + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + 'ISP_BU' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + '0' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + NullStringToEmptyString(c.Business_Unit__c) + DoubleQuoteString);
                
*/

            returnList.Add(DoubleQuoteString + 'OCPROJATTVALUE' + c.CaseNumber + '.txt' + 
                DoubleQuoteString + SeparatorAfterFirstField +                        
                DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
                DoubleQuoteString + devExProjectType + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + c.CaseNumber + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + 'DXPM_PROJECT_ORG_UNIT' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + '0' + DoubleQuoteString + FieldSeparatorString +
                DoubleQuoteString + 'Pharma Coatings' + DoubleQuoteString + EndOfTheLineSeparatorString) ;
                // Based on the email on Jun 17, hard code the value
                //DoubleQuoteString + NullStringToEmptyString(c.Technical_Lab_Group__c) + DoubleQuoteString) ;     
                
	    	List<String> sListReturned;
	    	for (String[] sa : TSR_NON_MEMO_FIELDS) {
	    		String attrValue = '';
	    		if (c.get(sa[0]) != null) attrValue = String.valueOf(c.get(sa[0]));
	    		sListReturned = getOPAttrList(devExProjectType, c.caseNumber, sa[1], attrValue); 
	    		returnList.addAll(sListReturned);
	    	}                            
       
            addAquariusAttrs(devExProjectType, c, returnList);
        } 
        return returnList;
    }
    
    private static void addAquariusAttrs(String devExProjType, Case c, List<String> slist) {
    	List<Sample_Request_Aquarius__c> alist = c.Aquarius_Requests__r;
    	if (alist == null || alist.isEmpty()) {return;} 
    	Sample_Request_Aquarius__c a = alist[0]; 
    	String caseNumber = c.CaseNumber;
    	List<String> sListReturned;
    	for (String[] sa : AQUARIUS_NON_MEMO_FIELDS) {
    		//System.Debug('sa[1]: ' + sa[1] + ' sa[0]: ' + sa[0] + ' a.get(sa[0]): ' + a.get(sa[0]));
    		String attrValue = '';
    		if (a.get(sa[0]) != null) attrValue = String.valueOf(a.get(sa[0]));
    		//System.Debug('attrValue: ' + attrValue);
    		sListReturned = getOPAttrList(devExProjType, caseNumber, sa[1], attrValue); slist.addAll(sListReturned);
    	}
    }   
    

    private static List<String> getOPAttrList(String devExProjType, String caseNumber, String attrName, String attrValue) {
        attrValue = RemoveDelimiter(attrValue);
        string returnValue = '';
        List<String> slist = new List<String>();

		// Jun 18 - issue with sending multiple list value, we'll now send them as they are stored in SF
		// semi-colon separated values
		
/*        
        if (attrName == 'ASH_TSR_COUNTRY_END_USE')
        {
        	
	        List<String> countryList = s.split(';');
	        if (countryList.size() > 0)
			{
				integer counter = 0;
		        for (String c : countryList) 
		        {
		        	returnValue = 
			        DoubleQuoteString + 'OCPROJATTVALUE' + caseNumber + '.txt' + 
			        DoubleQuoteString + SeparatorAfterFirstField +                        
			        DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
			        DoubleQuoteString + devExProjType + DoubleQuoteString + FieldSeparatorString +
			        DoubleQuoteString + caseNumber + DoubleQuoteString + FieldSeparatorString +
			        DoubleQuoteString + attrName + DoubleQuoteString + FieldSeparatorString +
			        DoubleQuoteString + counter + DoubleQuoteString + FieldSeparatorString +
			        DoubleQuoteString + c + DoubleQuoteString; 
			        slist.add(returnValue);	
			        counter++;        	
		        } 
			}     	
        }
*/
		if (attrName == 'ASH_TSR_CLEAR_COL' || attrName == 'ASH_TSR_COA' || attrName == 'ASH_TSR_COATED_TAB' ||
			attrName == 'ASH_TSR_COAT_COND' || attrName == 'ASH_TSR_CUST_COLOR' || attrName == 'ASH_TSR_CUST_CORE_PROV' ||
			attrName == 'ASH_TSR_DEC_INGREDIENTS' || attrName == 'ASH_TSR_EXACT_FORM_MATCH' || attrName == 'ASH_TSR_FOOD' ||
			attrName == 'ASH_TSR_LABEL_MATCH' || attrName == 'ASH_TSR_MSDS' || attrName == 'ASH_TSR_NUTRITION' ||
			attrName == 'ASH_TSR_OTHER_DOCS' || attrName == 'ASH_TSR_OTHER_MKTS' || attrName == 'ASH_TSR_OTHER_TGTS' ||
			attrName == 'ASH_TSR_PHARMA' || attrName == 'ASH_TSR_PRODUCT_SPECS' || attrName == 'ASH_TSR_RECONST_INSTRUCT' ||
			attrName == 'ASH_TSR_STD_COLOR' || attrName == 'ASH_TSR_WHITE_COLOR')
		{
			
			attrValue = attrValue.toLowerCase().equals('true') ? '1' : '0';
			
		}
        else if (attrName == 'ASH_TSR_CORE_AMOUNT' || attrName == 'ASH_TSR_SOLIDS_LOADING' || attrName == 'ASH_TSR_WEIGHT_GAIN')
        {
        	if (NullStringToEmptyString(attrValue).trim() == '')
        		attrValue = '0.00';
       
        }
        
        returnValue = 
        DoubleQuoteString + 'OCPROJATTVALUE' + caseNumber + '.txt' + 
        DoubleQuoteString + SeparatorAfterFirstField +                        
        DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
        DoubleQuoteString + devExProjType + DoubleQuoteString + FieldSeparatorString +
        DoubleQuoteString + caseNumber + DoubleQuoteString + FieldSeparatorString +
        DoubleQuoteString + attrName + DoubleQuoteString + FieldSeparatorString +
        DoubleQuoteString + '0' + DoubleQuoteString + FieldSeparatorString +
        DoubleQuoteString + attrValue + DoubleQuoteString + EndOfTheLineSeparatorString;   
        slist.add(returnValue);	         
        
        System.Debug('returnValue: ' + returnValue);
        
        return slist;
    }
    
    /*
        Method: GetAllOcAttValueMemo
        Summary: Returns list of string to write data for ISP_PROJ_OBJ2668.txt, ISP_PROJ_DET_DESC2668.txt,
            ISP_PROJ_SMPMAT_RCV2668.txt, ISP_PROJ_COMP_PRODUCT2668.txt
        Input: Case Numbers
        Sample Data returned: 
            "OCATTVALUEMEMO","","1022   2668","ISP_PROJ_OBJ","0", "FIELD VALUE","\\wayfmsstg1\Interface\INBOUND\MemoFiles\ISP_PROJ_OBJ2668.txt"
            "OCATTVALUEMEMO","","1022   2668","ISP_PROJ_DET_DESC","0", "FIELD VALUE","\\wayfmsstg1\Interface\INBOUND\MemoFiles\ISP_PROJ_DET_DESC2668.txt"
            "OCATTVALUEMEMO","","1022   2668","ISP_PROJ_SMPMAT_RCV","0", "FIELD VALUE","\\wayfmsstg1\Interface\INBOUND\MemoFiles\ISP_PROJ_SMPMAT_RCV2668.txt"
            "OCATTVALUEMEMO","","1022   2668","ISP_PROJ_COMP_PRODUCT","0", "FIELD VALUE",\\wayfmsstg1\Interface\INBOUND\MemoFiles\ISP_PROJ_COMP_PRODUCT2668.txt

    */      
    private Static List<String> getAllOcAttValueMemo() {
        List<String> returnList = new List<String>();
        List<Case> caseList = GetCaseListForDevEx() ;
        if (caseList == null || caseList.isEmpty()) {return returnList;}   
        String currentRecord = '';
        
        for (Case c : caseList) {
            try {
        
	            String devExProjectType = GetDevExProjectNumber(c.Internal_External__c) ;
				List<String> sListReturned;
		    	for (String[] sa : TSR_MEMO_FIELDS) {
		    		String attrValue = '';
		    		if (c.get(sa[0]) != null)
		    		{
		    			attrValue = String.valueOf(c.get(sa[0]));
		    		}    		
		    		sListReturned = getValueMemoList(devExProjectType, c.CaseNumber, sa[1], attrValue); 
		    		returnList.addAll(sListReturned);
		    	}				
				
				addAquariusMemoAttrs(devExProjectType, c, returnList);				
                    
            } catch (Exception e) {
                System.debug('Error in Method getAllOcAttValueMemo: ' + e.getTypeName() + 
                             ' - ' + e.getCause() + ': ' + e.getMessage());
            }           
        }
        return returnList;      
    }

   
    private static void addAquariusMemoAttrs(String devExProjType, Case c, List<String> slist) {
    	List<Sample_Request_Aquarius__c> alist = c.Aquarius_Requests__r;
    	if (alist == null || alist.isEmpty()) {return;} 
    	Sample_Request_Aquarius__c a = alist[0]; 
    	String caseNumber = c.CaseNumber;
    	List<String> sListReturned;
    	for (String[] sa : AQUARIUS_MEMO_FIELDS) {
    		String attrValue = '';
    		if (a.get(sa[0]) != null) attrValue = String.valueOf(a.get(sa[0]));  		
    		sListReturned = getValueMemoList(devExProjType, caseNumber, sa[1], attrValue); slist.addAll(sListReturned);
    	}
    } 
    

    private static List<String> getValueMemoList(String devExProjType, String caseNumber, String attrName, String attrValue) {
        string returnValue = '';
        List<String> slist = new List<String>();
        //if (attrValue.containsAny('\\|'))
        attrValue = RemoveDelimiter(attrValue);
		returnValue = DoubleQuoteString + 'OCATTVALUEMEMO' + caseNumber + '.txt' + DoubleQuoteString + SeparatorAfterFirstField +
		                DoubleQuoteString + DoubleQuoteString + FieldSeparatorString + 
		                DoubleQuoteString + devExProjType + '\t' + caseNumber + DoubleQuoteString + FieldSeparatorString + 
		                DoubleQuoteString + attrName + DoubleQuoteString + FieldSeparatorString +
		                DoubleQuoteString + '0' + DoubleQuoteString + FieldSeparatorString +
		                DoubleQuoteString + attrValue + DoubleQuoteString + FieldSeparatorString +
		                DoubleQuoteString + attrName + caseNumber + '.txt' + DoubleQuoteString + EndOfTheLineSeparatorString ;
		                
		slist.add(returnValue);	        

        System.Debug('returnValue: ' + returnValue);
        
        return slist;
    }

    /*
        Method: DoUpdateCases
        Summary: Updates Cases created in DevEx
    */  
    private Static void DoUpdateCases(List<Case> caselist) {
        try {
            Database.SaveResult[] results = Database.update(caselist,false);
            if (results == null || results.isEmpty()){return;}
            for (Database.SaveResult result : results) {
                if (!result.isSuccess()) {
                    Database.Error[] errs = result.getErrors();
                    for(Database.Error err : errs) {
                        System.debug('Error in Method DoUpdateCases: ' + err.getStatusCode() + 
                                     ' - ' + err.getMessage());
                    }
                }
            }
        } catch (Exception e) {
            System.debug('Error in Method DoUpdateCases: ' + e.getTypeName() + 
                         ' - ' + e.getCause() + ': ' + e.getMessage());
            sendExceptionEmail('DoUpdateCases', e);
        }           
    }
    
    private Static List<Case> GetCaseListFromCaseNumbers(String caseNumbers) {
        List<Case> caselist = new List<Case>();
        if (String.isBlank(caseNumbers)) {return caselist;}
        List<String> caseNumbersList = caseNumbers.split(',');
        //System.debug('caseNumbersList: ' + caseNumbersList);
            
        Set<String> caseNumbersSet = new Set<String>();
            
        for (String s : caseNumbersList) {caseNumbersSet.add(s.trim());}
            
        try {
            caselist = [SELECT Id, CaseNumber, Reason, Status, Business_Unit__c, 
            c.Account.BillingCountry, c.Account.Id, c.Account.Name,
            c.Account.SAP_Sales_Group_Desc__c, c.Account.SAP_Sales_Office_Desc__c,
            c.Contact.FirstName, c.Contact.Id, c.Contact.LastName, 
            c.Contact.MailingCity, c.Contact.MailingPostalCode,
            c.Contact.MailingState, c.Contact.MailingStreet,
            c.Technical_Lab_Group_Manager__r.FirstName, c.Technical_Lab_Group_Manager__r.LastName,
            c.Technical_Lab_Group_Manager__r.Name, Competitive_Products__c,
            Describe_Work_Needed__c, DevEx_Project_Manager__c, DevEx_Transfer_Status__c,
            Estimated_Start_Date__c, Internal_External__c, Subject,
            Related_Opportunity__c, Required_Technical_Output__c,
            T_Estimated_Complete_Date__c, T_RequestedCompletionDate__c,
            Technical_Approval_Date__c, Technical_Approval_Priority__c,
            Technical_Lab_Group__c, Technical_Risk_Assessment__c, 
            What_type_of_sample_being_sent__c, Est_Comp_Date_String__c,
            Est_Start_Date_String__c, Req_Comp_Date_String__c, Tech_App_Date_String__c,
            DevEx_Project_Manager_FN__c, DevEx_Project_Manager_LN__c
                            
            FROM Case c WHERE CaseNumber in :caseNumbersSet];   
        } catch (Exception e) {
            sendExceptionEmail('GetCaseListFromCaseNumbers', e);
        }                           
        return caselist;    
    }
    
    public Static List<Case> GetCaseListForDevEx() {

        List<Case> caselist = [SELECT Id, CaseNumber, Reason, Status, Background__c,
            Business_Unit__c, Account.BillingCountry, Account.Id, Account.Name,
            Account.SAP_Sales_Group_Desc__c, Account.SAP_Sales_Office_Desc__c,
            Contact.FirstName, Contact.Id, Contact.LastName,
            Contact.MailingCity, Contact.MailingPostalCode,
            Contact.MailingState, Contact.MailingStreet,
            Objective__c, Technical_Lab_Group_Manager__r.FirstName,
            Technical_Lab_Group_Manager__r.LastName, c.Technical_Lab_Group_Manager__r.Name,
            Competitive_Products__c, Describe_Work_Needed__c, 
            DevEx_Project_Manager__c, DevEx_Transfer_Status__c,
            Estimated_Start_Date__c, Internal_External__c,
            Subject, Related_Opportunity__c, Required_Technical_Output__c,
            T_Estimated_Complete_Date__c, T_RequestedCompletionDate__c,
            Technical_Approval_Date__c, Technical_Approval_Priority__c,
            Technical_Lab_Group__c, Technical_Risk_Assessment__c,
            What_type_of_sample_being_sent__c, Est_Comp_Date_String__c,
            Est_Start_Date_String__c, Req_Comp_Date_String__c, Tech_App_Date_String__c,
            DevEx_Project_Manager_FN__c, DevEx_Project_Manager_LN__c,
            (select Id, Additional_Comments__c, Certificate_of_Analysis__c, Clear_Color__c, 
                    Coated_Tablet__c, Coating_Conditions__c, Coating_Description__c,
                    Coating_Equipment_Used__c, Coating_Objective__c, Coating_Substrate__c,
                    Color_Details__c, Colorants_Preferred__c, Colorants_that_cannot_be_used__c,
                    Core_Amount__c, Countries_of_End_Use_Sale__c, Current_Supplier__c, 
                    Custom_Color__c, Customer_Core_Description__c, Customer_Core_Issues__c, 
                    Customer_Cores_Provided__c, Customer_Problems__c,
                    Customer_Product_Sensitivities__c, Declaration_of_Ingredients__c,
                    Desired_Solids__c, Desired_Solvent__c, Desired_Weight_Gain__c,
                    Exact_Formulation_Match__c, Food_Market__c, Label_Match__c,
                    List_of_Ingredients__c, MSDS__c, Nutritional_Market__c,
                    Other_Documentation__c, Other_Documentation_Details__c, Other_Market__c,
                    Other_Market_Details__c, Other_Target__c, Other_Target_Details__c,
                    Pharma_Market__c, Plasticizer_Preference__c, 
                    Product_Specification__c, Product_to_be_matched__c,
                    Quantitative_Formula__c, Reconstitution_Instructions__c, 
                    Required_Functionality__c, Standard_Color__c, White_Color__c
               from Aquarius_Requests__r)

            FROM Case c WHERE (c.DevEx_Transfer_Status__c = 'Create DevEx Project')
            ORDER BY CreatedDate Desc];
            
        return caselist;    
    }   
    
    private Static String GetDevExProjectNumber(String InternalExternal) {
        String returnValue = '';
        
        if (InternalExternal == 'Internal')
            returnValue = DevExProjectTypeInternal;
        else if (InternalExternal == 'External')
            returnValue = DevExProjectTypeExternal;
                    
        return returnValue;
    }

    public Static void sendExceptionEmail(string strMethodName, Exception ex) {
        string strMessageSubject = 'Error in method: ' + strMethodName ;
        string strMessageBody = ex.getMessage() + '</br>' +
        'Error Line: ' + ex.getLineNumber() + '</br>' +
        'Error Type: ' + ex.getTypeName() ;
        
        sendExceptionEmail(strMessageSubject, strMessageBody, null);
        
    }
    
    public Static void sendExceptionEmail(string strSubject, string strBody, List<String> emailIds) {
        System.Debug('Entered method: sendExceptionEmail');
        /*
        User lmb ;
        String userid = UserInfo.getuserid();
        lmb = [select id, email, firstname, lastname from user where id = :userid LIMIT 1];

        if (emailIds == null || emailIds.isEmpty()) {
        	emailIds = new List<String>(); emailIds.add(lmb.Email);
        }

        List<String> cc = null, bcc = null;
        String replyTo = lmb.Email;
        String sender = lmb.FirstName + ' ' + lmb.LastName;
        Boolean bccSender = false, signature = false;
        String subject = strSubject;
        String body = null;
        String htmlBody = strBody;
        Boolean result = Email_Functions.sendEmail(emailIds, cc, bcc,
                                                   replyTo, sender, 
                                                   bccSender, signature,
                                                   subject, body, htmlBody);   
                                                   
                                                   
        System.Debug('Return from Email_Functions.sendEmail:' + result);
        */                                     
        System.Debug('Exit method: sendExceptionEmail');     
    
    }
    
    private Static String NullStringToEmptyString(String fieldValue) {
        return (fieldValue == null ? '' : fieldValue.trim()); 
        //return (fieldValue == null ? '' : fieldValue);
    }
    
    private Static String NullDateToEmptyString(DateTime fieldValue) {
        return (fieldValue == null ? '' : String.valueOf(fieldValue)); 
    }  
    private Static String RemoveDelimiter(String attrValue) {
    	if (attrValue != null)
    		attrValue = attrValue.replaceAll('\\|', ' ').replaceAll(DoubleQuoteString, ' ').replaceAll(FieldSeparatorString, ' ').replaceAll(FileSeparatorString, ' ').replaceAll('\\^', ' ').replaceAll('\'', ' ');
		else attrValue = ''; 
        return (attrValue);
    }      
    


}
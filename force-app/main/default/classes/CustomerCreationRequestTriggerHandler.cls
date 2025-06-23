public class CustomerCreationRequestTriggerHandler { 
    
    @AuraEnabled
    public static void updateChangeRequestApprover(List<Customer_Creation_Request__c> newlist)
    {
        
        //Get all list of Account details to compare
        Set<Id> accountId=new Set<Id>();
        for(Customer_Creation_Request__c ccr:newlist)
        {
            if(ccr.Account__c!=null)
            {
            accountId.add(ccr.Account__c);
            }
        }
        
        //Get all the District Manager from SFDC ValueAdvantage_Approver_List__c
        List<String> dogKeyList=new List<String>();
        Map<String,Id> rsdkeyMap=new Map<String,Id>();
        String dist;
        String off;
        String grp;
        String dogKey;
        for(Customer_Creation_Request__c ccr1:newList)
        {
            dist='';
            off='';
            grp='';
            if(ccr1.CCR_Sales_District__c!=null)
            {
                dist=String_Functions.inParenthesis(ccr1.CCR_Sales_District__c);
            }
            if(ccr1.CCR_Sales_Office__c!=null)
            {
                off=String_Functions.inParenthesis(ccr1.CCR_Sales_Office__c);
            }
            if(ccr1.Sales_Group__c!=null)
            {
                grp=String_Functions.inParenthesis(ccr1.Sales_Group__c);
            }
            dogKey=dist+off+grp;
            system.debug('dogKey'+dogKey);
            if(dogKey!=null)
            {
                dogKeyList.add(dogKey);
                
            }
            //Set water or papger
            // Paper_or_Water__c
            if(ccr1.CCR_Sales_District__c!=null)
            {
                dist=String_Functions.inParenthesis(ccr1.CCR_Sales_District__c);
                If(dist.startsWith('PP'))
                {
                    system.debug('Paper');  
                    ccr1.Paper_or_Water__c='Paper';
                }
                 else if (dist.startsWithIgnoreCase('PS'))
                {
                    system.debug('Paper');  
                    ccr1.Paper_or_Water__c='Paper';                       
                }
                else if (dist.startsWithIgnoreCase('IW'))
                {
                    system.debug('Water');  
                    ccr1.Paper_or_Water__c='Water';                       
                }
                else
                {
                    system.debug('Others');
                    ccr1.Paper_or_Water__c='Others';    
                }
                
            }
        }
        if(dogKeyList!=null)
        {
            
            List<ValueAdvantage_Approver_List__c> rsdKey=[select District_Manager_User_Id__c,DOGId__c,CR_Approve_Level__c,Group_Manager_User_Id__c,Office_Manager_User_Id__c,Active_District_Manager__c,Active_Office_Manager__c,Active_Group_Manager__c from ValueAdvantage_Approver_List__c where DOGId__c IN:dogKeyList];
            for(ValueAdvantage_Approver_List__c vap:rsdKey)
            {
                if(vap.CR_Approve_Level__c == 'AM' && vap.Group_Manager_User_Id__c !=NULL && vap.Active_Group_Manager__c == TRUE){
                    rsdkeyMap.put(vap.DOGId__c,vap.Group_Manager_User_Id__c);
                }
                else if(vap.CR_Approve_Level__c == 'DM' && vap.Office_Manager_User_Id__c !=NULL && vap.Active_Office_Manager__c == TRUE){
                    rsdkeyMap.put(vap.DOGId__c,vap.Office_Manager_User_Id__c);
                }
                else if(vap.CR_Approve_Level__c == 'RSD' && vap.District_Manager_User_Id__c !=NULL && vap.Active_District_Manager__c == TRUE){
                rsdkeyMap.put(vap.DOGId__c,vap.District_Manager_User_Id__c);
                }
                else if(vap.CR_Approve_Level__c == 'AM' && vap.Group_Manager_User_Id__c ==NULL && vap.Active_Group_Manager__c == False && vap.Office_Manager_User_Id__c !=NULL && vap.Active_Office_Manager__c == TRUE){
                rsdkeyMap.put(vap.DOGId__c,vap.Office_Manager_User_Id__c);
                }
                else if(vap.CR_Approve_Level__c == 'DM' && vap.Office_Manager_User_Id__c ==NULL && vap.Active_Office_Manager__c == False){
                rsdkeyMap.put(vap.DOGId__c,vap.District_Manager_User_Id__c);
                }
            }
        }
        
        //Get all the fields from the account
        Map<Id,Account> accValues=new Map<Id,Account>();
        accValues.putAll([select Id,SAP_INCO_Terms2__c,SAP_Currency__c,BillingStreet,StreetFormulaFields__c,SAP_StreetSuppl1__c,SAP_StreetSuppl2__c,SAP_House_Number__c,SAP_House_Number_2__c,BillingState,BillingCity,BillingPostalCode,V_PO_Box__c,BillingCountry,SAP_CustomerGroup_Desc3__c,SAP_CustomerGroup_Desc2__c,SAP_CustomerGroup_Desc__c,Name,SAP_Account_Name_2__c,SAP_INCO_Terms1_Desc__c,SAP_INCO_Terms1__c,HQ_Account__c,OwnerId,SAP_SalesDistrict_Desc__c,SAP_SalesOffice_Desc__c,SAP_SalesGroup_Desc__c from Account where id IN:accountId ]);
        for(Customer_Creation_Request__c ccr:newList)
        {
            //Need to check the logic for field update
            //functionality will work only for Status SUbmit
            if(ccr.Status__c!='Cancelled'&&ccr.Account__c!=null)
            {
                system.debug('INside Submit-->');
                //update 
                String accDistVal=accValues.get(ccr.Account__c).SAP_SalesDistrict_Desc__c;
                system.debug('accDistVal-->'+accDistVal);
                if(accDistVal==null)
                {
                    accDistVal='';
                }
                system.debug('CCR_Sales_District__c-->'+ccr.CCR_Sales_District__c);
                String accOffVal=accValues.get(ccr.Account__c).SAP_SalesOffice_Desc__c;
                if(accOffVal==null)
                {
                    accOffVal='';
                }
                system.debug('accOffVal-->'+accOffVal);
                system.debug('CCR_Sales_Office__c-->'+ccr.CCR_Sales_Office__c);
                String accGrpVal=accValues.get(ccr.Account__c).SAP_SalesGroup_Desc__c;
                if(accGrpVal==null)
                {
                    accGrpVal='';
                }
                system.debug('accGrpVal-->'+accGrpVal);
                system.debug('Sales_Group__c-->'+ccr.Sales_Group__c);
                String accNameVAl=accValues.get(ccr.Account__c).Name;
                if(accNameVAl==null)
                {
                    accNameVAl='';
                }
                system.debug('accNameVAl-->'+accNameVAl);
                system.debug('Name-->'+ccr.Company_Legal_Name__c);
                String accName2VAl='';
                    accName2VAl=accValues.get(ccr.Account__c).SAP_Account_Name_2__c;
                if(accName2VAl==null)
                {
                    accName2VAl='';
                }
                system.debug('accName2VAl-->'+accName2VAl);
                system.debug('Name_2__c-->'+ccr.Name_2__c);
                   String accName3VAl='';
                system.debug('accName3VAl-->'+accName3VAl);
                system.debug('Name_3__c-->'+ccr.Name_3__c);
                String accIncoTm1=accValues.get(ccr.Account__c).SAP_INCO_Terms1__c+' - '+accValues.get(ccr.Account__c).SAP_INCO_Terms1_Desc__c;
                if(accIncoTm1==null)
                {
                    accIncoTm1='';
                }
                system.debug('accIncoTm1-->'+accIncoTm1);
                system.debug('Incoterms__c-->'+ccr.Incoterms__c);
                String hqAccount=accValues.get(ccr.Account__c).HQ_Account__c;
                if(hqAccount==null)
                {
                    hqAccount='';
                }
                system.debug('hqAccount-->'+hqAccount);
                system.debug('HQAccount__c-->'+ccr.HQAccount__c);
                String accOwnerId=accValues.get(ccr.Account__c).OwnerId;
                if(accOwnerId==null)
                {
                    accOwnerId='';
                }
                system.debug('accOwnerId-->'+accOwnerId);
                system.debug('Account_Owner__c-->'+ccr.Account_Owner__c);
                //Customer group cusGroup1 Customer_Group__c cusGroup2 Customer_Group_2__c cusGroup3 Customer_Group_3__c
                 String cusGroup3=accValues.get(ccr.Account__c).SAP_CustomerGroup_Desc3__c;
                if(cusGroup3==null)
                {
                    cusGroup3='';
                }
                system.debug('cusGroup3-->'+cusGroup3);
                system.debug('-->'+ccr.Customer_Group_3__c);
                    String cusGroup2=accValues.get(ccr.Account__c).SAP_CustomerGroup_Desc2__c;
                
                if(cusGroup2==null)
                {
                    cusGroup2='';
                }system.debug('cusGroup2-->'+cusGroup2);
                system.debug('Account_Owner__c-->'+ccr.Customer_Group_2__c);
                    String cusGroup1=accValues.get(ccr.Account__c).SAP_CustomerGroup_Desc__c;
               if(cusGroup1==null)
                {
                    cusGroup1='';
                }
                system.debug('cusGroup1-->'+cusGroup1);
                system.debug('Account_Owner__c-->'+ccr.Customer_Group__c);
                //Customer Address
                        String billStreet=accValues.get(ccr.Account__c).StreetFormulaFields__c;
                if(billStreet==null)
                {
                    billStreet='';
                }
                system.debug('billStreet-->'+billStreet);
                  String street2=accValues.get(ccr.Account__c).SAP_StreetSuppl1__c;
                if(street2==null)
                {
                    street2='';
                }
                system.debug('street2-->'+street2);
                String street3=accValues.get(ccr.Account__c).SAP_StreetSuppl2__c;
                if(street3==null)
                {
                    street3='';
                }
                system.debug('street3-->'+street3);
                String houseNo=accValues.get(ccr.Account__c).SAP_House_Number__c;
                if(houseNo==null)
                {
                    houseNo='';
                }
                system.debug('houseNo-->'+houseNo);
                 String houseNo2=accValues.get(ccr.Account__c).SAP_House_Number_2__c;
                if(houseNo2==null)
                {
                    houseNo2='';
                }
                system.debug('street3-->'+houseNo2);
                
                String poBoxAdd=accValues.get(ccr.Account__c).BillingPostalCode;
                if(poBoxAdd==null)
                {
                    poBoxAdd='';
                }
                system.debug('poBoxAdd-->'+poBoxAdd);
                
                
                    String billCity=accValues.get(ccr.Account__c).BillingCity;
                if(billCity==null)
                {
                    billCity='';
                }
                system.debug('billCity-->'+billCity);
                
                  String postalCode=accValues.get(ccr.Account__c).V_PO_Box__c;
                if(postalCode==null)
                {
                    postalCode='';
                }
                system.debug('postalCode-->'+postalCode);
                
                
                system.debug('Account_Owner__c-->'+ccr.Account_Owner__c);
                    String billpost=accValues.get(ccr.Account__c).BillingPostalCode;
                if(billpost==null)
                {
                    billpost='';
                }
                system.debug('billpost-->'+billpost);
                system.debug('Account_Owner__c-->'+ccr.Account_Owner__c);
                
                //SAP_INCO_Terms2__c
                 String icoTerm2=accValues.get(ccr.Account__c).SAP_INCO_Terms2__c;
                if(icoTerm2==null)
                {
                    icoTerm2='';
                }
                system.debug('icoTerm2-->'+icoTerm2);
                system.debug('Account_Owner__c-->'+ccr.Account_Owner__c);
                //SAP_Currency__c
                   String curren=accValues.get(ccr.Account__c).SAP_Currency__c;
                if(curren==null)
                {
                    curren='';
                }
                system.debug('curren-->'+curren);
                
                system.debug('SAP_Currency__c-->'+ccr.SAP_Currency__c);
                 //Address
                   String addStreet=accValues.get(ccr.Account__c).StreetFormulaFields__c;
                if(addStreet==null)
                {
                    addStreet='';
                }
                system.debug('addStreet-->'+addStreet);
                
                system.debug('BillingCity-->'+ccr.City__c);
                  String addCity=accValues.get(ccr.Account__c).BillingCity;
                if(addCity==null)
                {
                    addCity='';
                }
                system.debug('addCity-->'+addCity);               
                system.debug('BillingCity-->'+ccr.City__c);
                
                  system.debug('Postal_Code__c-->'+ccr.Postal_Code__c);
                  String addPost=accValues.get(ccr.Account__c).BillingPostalCode;
                if(addPost==null)
                {
                    addPost='';
                }
                system.debug('addPost-->'+addPost);               
                system.debug('Postal_Code__c-->'+ccr.Postal_Code__c);
                
                system.debug('State_Region__c-->'+ccr.State_Region__c);
                  String addState=accValues.get(ccr.Account__c).BillingState;
                if(addState==null)
                {
                    addState='';
                }
                system.debug('addState-->'+addState);               
                system.debug('State_Region__c-->'+ccr.State_Region__c);
                
                    system.debug('State_Region__c-->'+ccr.Country__c);
                  String addCountry=accValues.get(ccr.Account__c).BillingCountry;
                if(addCountry==null)
                {
                    addCountry='';
                }
                system.debug('addState-->'+addState);               
                system.debug('State_Region__c-->'+ccr.Country__c);
                
                System.debug('Region-->'+ccr.Region__c);
                //
                // Empty all data
                ccr.ChangeReqCredit__c=false;
                ccr.ChangeReqDOGTeam__c=false;
                ccr.ChangeReqPricing__c=false;
                ccr.ChangeReqComRSD__c=false;
                ccr.changeReqInco2__c=false;
                ccr.changeReqCur__c=false;
                ccr.changeReqAddress__c=false;
                 ccr.changeReqCusGroup__c=false;
                
                //Credit Process
                if(ccr.SAP_Partner_Functions__c!=null)
                    
                {
                if(((ccr.Region__c=='NA')||(ccr.Region__c=='EMEA')||(ccr.Region__c=='LA')||(ccr.Region__c=='AP')) && ((ccr.SAP_Partner_Functions__c.contains('Sold To')) || (ccr.SAP_Partner_Functions__c.contains('Payer'))))
                {
                    //Credit Section
                    if(ccr.Company_Legal_Name__c!=null&&accNameVAl!=null)
                    {
                        if(!accNameVAl.equalsIgnoreCase(ccr.Company_Legal_Name__c))
                        {
                            ccr.ChangeReqCredit__c=true;
                        }
                    }
                    if(ccr.Name_2__c!=null&&accName2VAl!=null)
                    {
                        if(!accName2VAl.equalsIgnoreCase(ccr.Name_2__c))
                        {
                            ccr.ChangeReqCredit__c=true;
                        }
                    }
                     if(ccr.Name_3__c!=null&&accName3VAl!=null)
                    {
                        if(ccr.Name_3__c!='')
                        {
                            ccr.ChangeReqCredit__c=true;
                        }
                        
                    }
                }
            }
                //DOG Process
                if((ccr.Region__c=='NA')||(ccr.Region__c=='EMEA')||(ccr.Region__c=='LA')||(ccr.Region__c=='AP'))
                {
                    
                    //DOG Section
                    if(ccr.CCR_Sales_District__c!=null&&accDistVal!=null)
                    {
                        if(!accDistVal.equalsIgnoreCase(ccr.CCR_Sales_District__c))
                        {
                            ccr.ChangeReqDOGTeam__c=true;
                        }
                    }
                    //DOG Section
                    if(ccr.CCR_Sales_Office__c!=null&&accOffVal!=null)
                    {
                        if(!accOffVal.equalsIgnoreCase(ccr.CCR_Sales_Office__c))
                        {
                            ccr.ChangeReqDOGTeam__c=true;
                        }
                    }
                    //DOG Section
                    if(ccr.Sales_Group__c!=null&&accGrpVal!=null)
                    {
                        if(!accGrpVal.equalsIgnoreCase(ccr.Sales_Group__c))
                        {
                            ccr.ChangeReqDOGTeam__c=true;
                        }
                    }
                    
                }
                
                //INCO Term
                if((ccr.Region__c=='NA')||(ccr.Region__c=='EMEA')||(ccr.Region__c=='LA')||(ccr.Region__c=='AP'))
                {
                    system.debug('Pricing CHeck-->'+ccr.Incoterms__c);
                    system.debug('Pricing CHeck-->'+accIncoTm1);
                    //INCO Term Section
                    if(ccr.Incoterms__c!=null&&accIncoTm1!=null)
                    {
                        if(!accIncoTm1.equalsIgnoreCase(ccr.Incoterms__c))
                        {
                            system.debug('Pricing INside 1');
                            ccr.ChangeReqPricing__c=true;
                        }
                    }
                    //INcoterm2
                    if(ccr.Incoterms_2__c!=null&&icoTerm2!=null)
                    {
                        if(!icoTerm2.equalsIgnoreCase(ccr.Incoterms_2__c))
                        {
                            system.debug('Pricing INside 2');
                            ccr.changeReqInco2__c=true;
                        }
                    }
                    //Currency
                   
                     if(ccr.Currency__c!=null&&curren!=null)
                    {
                        
                        if(!curren.equalsIgnoreCase(ccr.Currency__c))
                        {
                            ccr.changeReqCur__c=true;
                        }
                    }
                    //cusGroup1 Customer_Group__c cusGroup2 Customer_Group_2__c cusGroup3 Customer_Group_3__c
                    system.debug('DA ccr.Customer_Group__c'+ccr.Customer_Group__c);
                     system.debug('DA cusGroup1'+ccr.Customer_Group__c);
                     if(ccr.CCR_Customer_Group__c!=null&&cusGroup1!=null)
                    {
                        
                        if(!cusGroup1.equalsIgnoreCase(ccr.CCR_Customer_Group__c))
                        {
                            ccr.changeReqCusGroup__c=true;
                        }
                    }
                      if(ccr.CCR_Customer_Group2__c!=null&&cusGroup2!=null)
                    {
                        if(!cusGroup2.equalsIgnoreCase(ccr.CCR_Customer_Group2__c))
                        {
                            ccr.changeReqCusGroup__c=true;
                        }
                    }
                      if(ccr.Customer_Group_3__c!=null&&cusGroup3!=null)
                    {
                        if(!cusGroup3.equalsIgnoreCase(ccr.Customer_Group_3__c))
                        {
                            ccr.changeReqCusGroup__c=true;
                        }
                    }
                    //Address Check
                    ////StreetFormulaFields__c
                      if(ccr.BillingStreet__c!=null&&billStreet!=null)
                    {
                        if(!billStreet.equalsIgnoreCase(ccr.BillingStreet__c))
                        {
                            ccr.changeReqAddress__c=true;
                        }
                    }
                    //SAP_StreetSuppl1__c
                     if(ccr.Street_2__c!=null&&street2!=null)
                    {
                        if(!street2.equalsIgnoreCase(ccr.Street_2__c))
                        {
                            ccr.changeReqAddress__c=true;
                        }
                    }
                    //SAP_StreetSuppl2__c
                     if(ccr.Street_3__c!=null&&street3!=null)
                    {
                        if(!street3.equalsIgnoreCase(ccr.Street_3__c))
                        {
                            ccr.changeReqAddress__c=true;
                        }
                    }
                    //SAP_House_Number__c
                    if(ccr.House_Number1__c!=null&&houseNo!=null)
                    {
                        if(!houseNo.equalsIgnoreCase(ccr.House_Number1__c))
                        {
                            ccr.changeReqAddress__c=true;
                        }
                    }
                    //SAP_House_Number_2__c
                     if(ccr.House_Number2__c!=null&&houseNo2!=null)
                    {
                        if(!houseNo2.equalsIgnoreCase(ccr.House_Number2__c))
                        {
                            ccr.changeReqAddress__c=true;
                        }
                    }
                    //BillingPostalCode
                      if(ccr.PO_Box__c!=null&&poBoxAdd!=null)
                    {
                        if(!poBoxAdd.equalsIgnoreCase(ccr.PO_Box__c))
                        {
                            ccr.changeReqAddress__c=true;
                        }
                    }
                   //BillingCity
                       if(ccr.City__c!=null&&billCity!=null)
                    {
                        if(!billCity.equalsIgnoreCase(ccr.City__c))
                        {
                            ccr.changeReqAddress__c=true;
                        }
                    }
                    //V_PO_Box__c
                       if(ccr.Postal_Code__c!=null&&postalCode!=null)
                    {
                        if(!postalCode.equalsIgnoreCase(ccr.Postal_Code__c))
                        {
                            ccr.changeReqAddress__c=true;
                        }
                    }
                    //no value
                       if(ccr.PO_Box_postal_code__c!=null&&ccr.State_Region__c!='')
                    {
                        
                            ccr.changeReqAddress__c=true;
                               
                    }
                    
                    System.Debug('====ChangeReqCredit__c======'+ccr.ChangeReqCredit__c);
                    System.Debug('====ChangeReqDOGTeam__c======'+ccr.ChangeReqDOGTeam__c);
                    System.Debug('====ChangeReqPricing__c======'+ccr.ChangeReqPricing__c);
                    System.Debug('====changeReqInco2__c======'+ccr.changeReqInco2__c);
                    System.Debug('====changeReqCur__c======'+ccr.changeReqCur__c);
                    System.Debug('====changeReqCusGroup__c===='+ccr.changeReqCusGroup__c);
                    System.Debug('====changeReqAddress__c===='+ccr.changeReqAddress__c);
                    system.debug('ccr1.Paper_or_Water__c'+ccr.Paper_or_Water__c);
                }
                
                //HQ and Parent Term
                if((ccr.Region__c=='NA')||(ccr.Region__c=='EMEA')||(ccr.Region__c=='LA')||(ccr.Region__c=='AP'))
                {
                    dist='';
                    off='';
                    grp='';
                    //get RSD 
                    if(ccr.CCR_Sales_District__c!=null)
                    {
                        dist=String_Functions.inParenthesis(ccr.CCR_Sales_District__c);
                    }
                    if(ccr.CCR_Sales_Office__c!=null)
                    {
                        off=String_Functions.inParenthesis(ccr.CCR_Sales_Office__c);
                    }
                    if(ccr.Sales_Group__c!=null)
                    {
                        grp=String_Functions.inParenthesis(ccr.Sales_Group__c);
                    }
                    dogKey=dist+off+grp;
                    //HQ and Parent Term Section
                    if(ccr.HQAccount__c!=null&&hqAccount!=null)
                    {
                        if(!hqAccount.equalsIgnoreCase(ccr.HQAccount__c))
                        {
                            ccr.ChangeReqComRSD__c=true;
                            //set RSD
                            Id rsd=rsdkeyMap.get(dogKey);
                            if(rsd!=null)
                            {
                                ccr.RSDApprover__c=rsd;
                            }
                        }
                        System.Debug('====ChangeReqComRSD__c===='+ccr.ChangeReqComRSD__c);
                    }
                    if(ccr.Account_Owner__c!=null&&accOwnerId!=null)
                    {
                        if(!accOwnerId.equalsIgnoreCase(ccr.Account_Owner__c))
                        {
                            ccr.ChangeReqComRSD__c=true;
                            //set RSD
                            Id rsd=rsdkeyMap.get(dogKey);
                            if(rsd!=null)
                            {
                                ccr.RSDApprover__c=rsd;
                                System.Debug('====RSD Found===='+rsd);
                            }else{
                                ccr.ChangeReqComRSD__c=false;
                                System.Debug('====No RSD Found===='+ccr.ChangeReqComRSD__c);
                            }
                            System.Debug('====ChangeReqComRSD__c===='+ccr.ChangeReqComRSD__c);
                        }
                    }
                }
                    system.debug('ChangeReqCredit__c---1'+ccr.ChangeReqCredit__c);
               system.debug('Region---1'+ccr.Region__c);
                system.debug('Status---1'+ccr.Status__c);
                system.debug('Blank company---1'+String.isBlank(ccr.IV_Company_Legal_Name__c));
                system.debug('Street---1'+ccr.IV_Street__c);
                system.debug('Street---1'+ccr.IV_Street__c);
                system.debug('Street---1'+ccr.IV_Street_2__c);
                system.debug('changeReqAddress__c---1'+ccr.changeReqAddress__c);
                
               if(ccr.CCR_Sales_Organization__c!=null && ccr.Change_Request__c == TRUE)
               {
                if((ccr.Region__c=='AP'&&(ccr.Status__c=='Submitted'||ccr.Status__c=='Waiting for Approval'||ccr.Status__c=='Masterdata Review'||ccr.Status__c=='Completed'))&&((ccr.CCR_Sales_Organization__c.contains('0070'))||(ccr.CCR_Sales_Organization__c.contains('0869'))||(ccr.CCR_Sales_Organization__c.contains('8861'))))
                {
                    //Name Validation
                    if((ccr.ChangeReqCredit__c==true)&&(String.isBlank(ccr.IV_Company_Legal_Name__c))&&(String.isBlank(ccr.IV_Name_2__c)))
                    {
                   ccr.addError('Please Enter International Version Name,Since Local Name Changed');
                    }
                    //Address Validation changeReqAddress__c
                     if((ccr.changeReqAddress__c==true)&&(String.isBlank(ccr.IV_Street__c))&&(String.isBlank(ccr.IV_Street_2__c))&&(String.isBlank(ccr.IV_Street_3__c))&&(String.isBlank(ccr.IV_House_Number_1__c))&&(String.isBlank(ccr.IV_House_Number_2__c))&&(String.isBlank(ccr.IV_Postal_Code__c))&&(String.isBlank(ccr.IV_PO_Box__c))&&(String.isBlank(ccr.IV_PO_Box_postal_code__c)&&(String.isBlank(ccr.IV_City__c))))
                       //  if((ccr.IV_Street__c=='')&&(ccr.IV_Street_2__c=='')&&(ccr.IV_Street_3__c=='')&&(ccr.IV_House_Number_1__c=='')&&(ccr.IV_House_Number_2__c=='')&&(ccr.IV_Postal_Code__c=='')&&(ccr.IV_Postal_Code__c=='')&&(ccr.IV_Postal_Code__c=='')&&(ccr.IV_Postal_Code__c=='')
                    {
                   ccr.addError('Please Enter International Version Address,Since Local Address changed');
                    }
                }
            }
                
            }
        }
        
    }
    
    @AuraEnabled
    Public static void updateRequestCreation(List<Customer_Creation_Request__c> newlist){
        List<String> accId = new List<String>();
        for(Customer_Creation_Request__c ccr:newlist){
            if(ccr.Account__c !=Null){
                accId.add(ccr.Account__c); 
            }
            System.Debug('===accId===='+accId);
        }
        Map <Id,Account > mapAccount = new Map < Id, Account >();
        for(Account acct :[Select Type,NameLocal,Name,SAP_Sales_Org_Region_value__c,SAP_Account_Name_2__c,SAP_CustomerGroup_Desc3__c,SAP_INCO_Terms1__c,SAP_INCO_Terms1_Desc__c,SAP_INCO_Terms2__c,SAP_Currency__c,ParentId,HQ_Account__c,OwnerId,BillingStreet,StreetFormulaFields__c, BillingCity,BillingPostalCode,BillingCountry,BillingState,
                           CIS_Prospect_Number__c,Prospect_Sales_Org__c, Country_picklist__c, SAP_State__c,Prospect_Sales_District__c,Prospect_Sales_Office__c,Prospect_Sales_Group__c ,Prospect_Customer_Group__c,Prospect_Customer_Group1__c,
                           Prospect_Customer_Group2__c, Prospect_Division__c,Prospect_Dist_Channel__c, Prospect_Customer_Price_Group_Desc__c,SAP_SalesOrg_Desc__c, SAP_SalesDistrict_Desc__c,SAP_Customer_Price_Group__c, SAP_SalesOffice_Desc__c, V_PO_Box__c, 
                           SAP_SalesGroup_Desc__c, SAP_DivisionCode_Desc__c, SAP_DistChannel_Desc__c, SAP_CustomerGroup_Desc__c, SAP_CustomerGroup_Desc1__c,SAP_CustomerGroup_Desc2__c, SAP_PriceGroup_Desc__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_StreetSuppl3__c, SAP_House_Number__c,SAP_House_Number_2__c 
                           From Account Where Id IN:accId]){
                               mapAccount.put(acct.Id, acct);
                           }
        System.Debug('===mapAccount===='+mapAccount);
        for(Customer_Creation_Request__c ccr:newlist){
            if(ccr.Change_Request__c !=True && ccr.ChangeReqSAPContact__c !=True && ccr.Account__c !=Null && mapAccount.containskey(ccr.Account__c)){
                if(mapAccount.get(ccr.Account__c).Type == 'Prospect'){
                    ccr.CCR_Sales_Organization__c=mapAccount.get(ccr.Account__c).Prospect_Sales_Org__c;
                    ccr.Country__c=mapAccount.get(ccr.Account__c).Country_picklist__c;
                    ccr.CCR_Sales_District__c=mapAccount.get(ccr.Account__c).Prospect_Sales_District__c;
                    ccr.CCR_Sales_Office__c=mapAccount.get(ccr.Account__c).Prospect_Sales_Office__c;
                    ccr.Sales_Group__c=mapAccount.get(ccr.Account__c).Prospect_Sales_Group__c;
                    ccr.CCR_Division__c=mapAccount.get(ccr.Account__c).Prospect_Division__c;
                    ccr.CCR_DIst_Channel__c=mapAccount.get(ccr.Account__c).Prospect_Dist_Channel__c;
                    ccr.CCR_Customer_Group__c=mapAccount.get(ccr.Account__c).Prospect_Customer_Group__c;
                    ccr.CCR_Customer_Group1__c=mapAccount.get(ccr.Account__c).Prospect_Customer_Group1__c;
                    ccr.CCR_Customer_Group2__c=mapAccount.get(ccr.Account__c).Prospect_Customer_Group2__c;
                    ccr.Price_Group__c=mapAccount.get(ccr.Account__c).Prospect_Customer_Price_Group_Desc__c;
                    ccr.SFDC_Prospect_Number__c=mapAccount.get(ccr.Account__c).CIS_Prospect_Number__c;
                    //ccr.RecordTypeId = '012m000000028AiAAI';
                }
                else if(mapAccount.get(ccr.Account__c).Type == 'Customer'){
                    ccr.CCR_Sales_Organization__c=mapAccount.get(ccr.Account__c).SAP_SalesOrg_Desc__c;                                        
                    ccr.CCR_Sales_District__c=mapAccount.get(ccr.Account__c).SAP_SalesDistrict_Desc__c;
                    ccr.CCR_Sales_Office__c=mapAccount.get(ccr.Account__c).SAP_SalesOffice_Desc__c;
                    ccr.Sales_Group__c=mapAccount.get(ccr.Account__c).SAP_SalesGroup_Desc__c;
                    ccr.CCR_Division__c=mapAccount.get(ccr.Account__c).SAP_DivisionCode_Desc__c;
                    ccr.CCR_DIst_Channel__c=mapAccount.get(ccr.Account__c).SAP_DistChannel_Desc__c;
                    ccr.CCR_Customer_Group__c=mapAccount.get(ccr.Account__c).SAP_CustomerGroup_Desc__c;
                    ccr.CCR_Customer_Group1__c=mapAccount.get(ccr.Account__c).SAP_CustomerGroup_Desc1__c;
                    ccr.CCR_Customer_Group2__c=mapAccount.get(ccr.Account__c).SAP_CustomerGroup_Desc2__c;
                    ccr.Price_Group__c=mapAccount.get(ccr.Account__c).SAP_Customer_Price_Group__c;
                    
                }  
            }
            else if(ccr.Change_Request__c ==True)
            {
                //Request type
                system.debug('Request Type is Customer change request'); 
                //  ccr.Request_Type__c = 'SOLD TO';
                ccr.Region__c=mapAccount.get(ccr.Account__c).SAP_Sales_Org_Region_value__c;
                //code change for intenation version NameLocal
               // ccr.Company_Legal_Name__c=mapAccount.get(ccr.Account__c).Name;
               system.debug('Local'+mapAccount.get(ccr.Account__c).NameLocal);
               if((mapAccount.get(ccr.Account__c).SAP_SalesOrg_Desc__c.contains('0070'))||mapAccount.get(ccr.Account__c).SAP_SalesOrg_Desc__c.contains('0869'))	
               {
                    ccr.Company_Legal_Name__c=mapAccount.get(ccr.Account__c).NameLocal;
                
               }
                else
                {
               ccr.Company_Legal_Name__c=mapAccount.get(ccr.Account__c).Name;   
                }
                ccr.Name_2__c=mapAccount.get(ccr.Account__c).SAP_Account_Name_2__c;
                ccr.CCR_Sales_Organization__c=mapAccount.get(ccr.Account__c).SAP_SalesOrg_Desc__c;                                        
                ccr.CCR_Sales_District__c=mapAccount.get(ccr.Account__c).SAP_SalesDistrict_Desc__c;
                ccr.CCR_Sales_Office__c=mapAccount.get(ccr.Account__c).SAP_SalesOffice_Desc__c;
                ccr.Sales_Group__c=mapAccount.get(ccr.Account__c).SAP_SalesGroup_Desc__c;
                ccr.CCR_DIst_Channel__c=mapAccount.get(ccr.Account__c).SAP_DistChannel_Desc__c;
                ccr.CCR_Division__c=mapAccount.get(ccr.Account__c).SAP_DivisionCode_Desc__c;
                ccr.CCR_Customer_Group__c=mapAccount.get(ccr.Account__c).SAP_CustomerGroup_Desc__c;
                ccr.CCR_Customer_Group1__c=mapAccount.get(ccr.Account__c).SAP_CustomerGroup_Desc1__c;
                ccr.CCR_Customer_Group2__c=mapAccount.get(ccr.Account__c).SAP_CustomerGroup_Desc2__c;
                ccr.Customer_Group_3__c=mapAccount.get(ccr.Account__c).SAP_CustomerGroup_Desc3__c;
               if(mapAccount.get(ccr.Account__c).SAP_INCO_Terms1__c!=null&&mapAccount.get(ccr.Account__c).SAP_INCO_Terms1_Desc__c!=null)
               {
                ccr.Incoterms__c=mapAccount.get(ccr.Account__c).SAP_INCO_Terms1__c+' - '+mapAccount.get(ccr.Account__c).SAP_INCO_Terms1_Desc__c;
               }
                
                ccr.Incoterms_2__c=mapAccount.get(ccr.Account__c).SAP_INCO_Terms2__c;
                ccr.Currency__c=mapAccount.get(ccr.Account__c).SAP_Currency__c;
                //For Account Relationship fields
                //ccr.Parent_Account__c=mapAccount.get(ccr.Account__c).Parent;
                ccr.HQAccount__c=mapAccount.get(ccr.Account__c).HQ_Account__c;
                ccr.Account_Owner__c=mapAccount.get(ccr.Account__c).OwnerId;
                //For Address fields
                ccr.BillingStreet__c=mapAccount.get(ccr.Account__c).StreetFormulaFields__c;
               // ccr.Street_1__c=mapAccount.get(ccr.Account__c).SAP_StreetSuppl1__c;
                ccr.Street_2__c=mapAccount.get(ccr.Account__c).SAP_StreetSuppl1__c;
                ccr.Street_3__c=mapAccount.get(ccr.Account__c).SAP_StreetSuppl2__c;
                ccr.House_Number1__c=mapAccount.get(ccr.Account__c).SAP_House_Number__c;
                ccr.House_Number2__c=mapAccount.get(ccr.Account__c).SAP_House_Number_2__c;
                ccr.PO_Box__c=mapAccount.get(ccr.Account__c).BillingPostalCode;
                ccr.City__c=mapAccount.get(ccr.Account__c).BillingCity;
                ccr.Postal_Code__c=mapAccount.get(ccr.Account__c).V_PO_Box__c;
                // ccr.Country__c=mapAccount.get(ccr.Account__c).BillingCountry;
                // ccr.State_Region__c=mapAccount.get(ccr.Account__c).BillingState;
                system.debug('Request Type is Customer change request Completed'); 
            }
        }
    }
    
    @AuraEnabled
    Public static void updateSAPContactDetails(List<Customer_Creation_Request__c> newlist){
        List<String> contId = new List<String>();
        for(Customer_Creation_Request__c ccr:newlist){
            if(ccr.SAP_Contact__c !=Null){
                contId.add(ccr.SAP_Contact__c);
            }
            System.Debug('===contId===='+contId);
        }
        Map <Id,SAP_Contact__c > mapSAPContact = new Map < Id, SAP_Contact__c >();
        for(SAP_Contact__c sapCont :[Select Id,Name,First_Name__c,Last_Name__c,SAP_Email__c,SAP_Title__c,SAP_Fax__c,SAP_Phone__c,Account_Name__c,Account_Name__r.SAP_Sales_Org_Region_value__c,SAP_Customer_Number__c,
                                     SAP_Contact_Number__c,SAP_Contact_Person_Function__c,SAP_Department_Desc__c From SAP_Contact__c Where Id IN:contId]){
                                         mapSAPContact.put(sapCont.Id, sapCont);
                                     }
        for(Customer_Creation_Request__c ccr:newlist){
            if(ccr.ChangeReqSAPContact__c ==True && ccr.SAP_Contact__c !=Null && mapSAPContact.containskey(ccr.SAP_Contact__c)){
                //  ccr.Request_Type__c = 'SOLD TO';
                  system.debug('Check'+mapSAPContact);
                system.debug('Check'+ccr.SAP_Contact__c);
                ccr.Region__c=mapSAPContact.get(ccr.SAP_Contact__c).Account_Name__r.SAP_Sales_Org_Region_value__c;
                ccr.SAP_Contact__c=mapSAPContact.get(ccr.SAP_Contact__c).Id;
                if(mapSAPContact.get(ccr.SAP_Contact__c).First_Name__c!=Null)
                {
                ccr.First_Name__c=mapSAPContact.get(ccr.SAP_Contact__c).First_Name__c;
                }
                   if(mapSAPContact.get(ccr.SAP_Contact__c).Last_Name__c!=Null)
                   {
               ccr.Last_Name__c=mapSAPContact.get(ccr.SAP_Contact__c).Last_Name__c;
                   }
                if(mapSAPContact.get(ccr.SAP_Contact__c).SAP_Email__c!=Null)
                {
                ccr.SAP_Email__c=mapSAPContact.get(ccr.SAP_Contact__c).SAP_Email__c;
                }
                if(mapSAPContact.get(ccr.SAP_Contact__c).SAP_Title__c!=Null)
                {
                ccr.SAP_Title__c=mapSAPContact.get(ccr.SAP_Contact__c).SAP_Title__c;
                }
                if(mapSAPContact.get(ccr.SAP_Contact__c).SAP_Fax__c!=Null)
                {
                ccr.SAP_Fax__c=mapSAPContact.get(ccr.SAP_Contact__c).SAP_Fax__c;
                }
                if(mapSAPContact.get(ccr.SAP_Contact__c).SAP_Phone__c!=Null)
                {
                ccr.SAP_Phone__c=mapSAPContact.get(ccr.SAP_Contact__c).SAP_Phone__c;
                }
                if(mapSAPContact.get(ccr.SAP_Contact__c).Account_Name__c!=Null)
                {
                ccr.Account__c=mapSAPContact.get(ccr.SAP_Contact__c).Account_Name__c;
                }
                if(mapSAPContact.get(ccr.SAP_Contact__c).SAP_Customer_Number__c!=Null)
                {
                ccr.SAP_Customer_Number__c=mapSAPContact.get(ccr.SAP_Contact__c).SAP_Customer_Number__c;
                }
                if(mapSAPContact.get(ccr.SAP_Contact__c).SAP_Contact_Number__c!=Null)
                {
                ccr.SAP_ContactNumber__c=mapSAPContact.get(ccr.SAP_Contact__c).SAP_Contact_Number__c;
                }
                if(mapSAPContact.get(ccr.SAP_Contact__c).SAP_Contact_Person_Function__c!=Null)
                {
                ccr.SAP_Contact_Person_FunctionCode__c=mapSAPContact.get(ccr.SAP_Contact__c).SAP_Contact_Person_Function__c;
                }
            }
        }
    }
    
    Public static void updateApprovalId(List<Customer_Creation_Request__c> newlist){
        Map<string,CCR_EMEA_Credit_team_approval__c> CCRSettngMap = CCR_EMEA_Credit_team_approval__c.getAll();   
        for(Customer_Creation_Request__c ccr:newlist){
            system.debug('ccr.Region__c'+ccr.Region__c);
            system.debug('ccr.Request_Type__c'+ccr.Request_Type__c);
            system.debug('CCRSettngMap.get(ccr.Sales_Org_Code__c)-->'+CCRSettngMap.get(ccr.Sales_Org_Code__c));
            system.debug('ccr.CCR_Sales_Organization__c'+ccr.CCR_Sales_Organization__c);
            system.debug('=========filed val'+ ccr.Sales_Org_Code__c );
            //system.debug('=========map val'+ CCRSettngMap.get(ccr.Sales_Org_Code__c).name);  
            if((ccr.Region__c == 'EMEA') && (ccr.Request_Type__c == 'PAYER TO'|| ccr.Request_Type__c == 'SOLD TO') && (ccr.CCR_Sales_Organization__c != Null && CCRSettngMap.get(ccr.Sales_Org_Code__c)!=null)){                                
                system.debug('condition true 1');
                If(ccr.Sales_Org_Code__c==CCRSettngMap.get(ccr.Sales_Org_Code__c).name){
                    system.debug('condition true');
                    ccr.EMEA_Credit_Approver__c = CCRSettngMap.get(ccr.Sales_Org_Code__c).Approver_ID__c;				
                }
                else{
                    //Empty Approver data
                    system.debug('Empty Inner Sales Org not Exist for Credit Approver');
                    ccr.EMEA_Credit_Approver__c=null;
                }              	
            }
            else{
                system.debug('Empty Outer Sales Org not Exist for Credit Approver');
                ccr.EMEA_Credit_Approver__c=null;
            }
        }  
        
    }
    
}
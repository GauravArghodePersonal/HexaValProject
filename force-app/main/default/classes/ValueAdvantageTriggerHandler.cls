public class ValueAdvantageTriggerHandler {
    public static boolean ValueAdvantage = true; 
    
    public static void afterUpdateTrigger(List<ValueAdvantage__c> newlist,Map<id,ValueAdvantage__c> oldmapValue){
      //  if(checkRecursive.runOnce()){         
        List<ValueAdvantage__c> vdpList = new List<ValueAdvantage__c>();
       
        List<CurrencyType> currencyValueList = New List<CurrencyType>([SELECT id, ISOCode, ConversionRate FROM CurrencyType]);
        Map<string,Decimal> currencyValueMap = New Map<string,Decimal>();
        
        For(CurrencyType CV : currencyValueList){
            currencyValueMap.Put(CV.ISOCode,CV.ConversionRate);
        }
        
        Map<id,id> contentMap = new  Map<id,id>();
        Boolean ROICount = false;
        List<String> validId = new List<String>();
        List<String> LinkedIds = new List<String>();
        List<task> tasklist = new List<task>();
        List<ValueAdvantage__c> VdpListNew = new List<ValueAdvantage__c>();
        
        for(ValueAdvantage__c v : newlist){
            
            System.debug('vdpList>>'+v.Project_Status__c);
            if(v.Total_Cost_Savings__c!=Null){
                if((v.Project_Status__c =='Completed' || v.Project_Status__c =='Approved' || v.Project_Status__c =='Rejected') ){
                    System.debug('v>>>'+v);
                    vdpList.add(v);
                    validId.add(v.Id);
                    LinkedIds.add(v.id);
                    System.debug('vdpList>>'+vdpList);
                }    
            }   
        }
        for(Task ts : [select id,WhatId,Document_Type__c  from Task where WhatId IN:vdpList]){
            
            System.debug('ts'+ts);
            
            If(ts.Document_Type__c == 'ROI Calculator' || ts.Document_Type__c == 'Sustainability Calculator'){
                LinkedIds.add(ts.id);
				ROICount = true;
                tasklist.add(ts);
                
                System.debug('Inside if LinkedIds>>'+LinkedIds);
            }
            
        }
		
		If(ROICount == false && tasklist.size()>0){
			LinkedIds.clear();
            System.debug('Inside else LinkedIds>>'+LinkedIds);
        }
			
        System.debug('LinkedIds>>'+LinkedIds);
        if(ValueAdvantageTriggerHandler.ValueAdvantage){
            if(validId != null && validId.size() >0){  
                
                ValueAdvantageTriggerHandler.ValueAdvantage = false;
                // validIds.addAll(validId);
                List<ContentDocumentLink> contentDocList = new List<ContentDocumentLink>();
                if(LinkedIds.size()>0){
                for(ContentDocumentLink contentDoc : [SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: LinkedIds]){
                    contentDocList.add(contentDoc);
                }
                }
                for(ContentDocumentLink c:contentDocList){      
                    contentMap.put(c.LinkedEntityId,c.ContentDocumentId);                 
                }
                
                
                System.debug('contentDocList>>'+contentMap);
                ByPass__c profileCustomSetting = ByPass__c.getInstance(UserInfo.getProfileId());
                for(ValueAdvantage__c v : vdpList){
                    Decimal isoCodeValue = currencyValueMap.get(v.CurrencyIsoCode);
                    if( contentMap.keyset().size()==0 && !profileCustomSetting.Disable_Trigger__c && v.Total_Cost_Savings__c/isoCodeValue >30000){
                        system.debug('v.Total_Cost_Savings__c/isoCodeValue :: ' + v.Total_Cost_Savings__c/isoCodeValue);
                        v.addError('Total Cost Savings is greater than 30K.  Click on Cancel, and Attach files (such as ROI worksheet, CVA document, or other customer provided details) under Files section or VA update for ROI calculator');
                        
                        
                    } 
                    else if(contentMap.keyset().size()==0 && isValidPicklistValue(v) && v.Customer_Region__c =='AP' && v.Project_Status__c=='Completed') 
                    {
                        v.addError('Please change the status to Delivering value, save, attach Return on Investment document under Files section. When done, you can complete the VA');
                        
                    }                    
                }     
                
            }     
            
             if(AccountCard.ValueAdvantage3){
                system.debug('inside if');
                ValueAdvantage_Approver_List__c vaalNA = ValueAdvantage_Approver_List__c.getValues('NA/LA');
                ValueAdvantage_Approver_List__c vaalEA = ValueAdvantage_Approver_List__c.getValues('EMEA/APAC');
                List<ValueAdvantage__c> VDPFinalList = New List<ValueAdvantage__c>();
                Boolean flag;
                List<ValueAdvantage_Approver_List__c> vdpOfficeMap = New List<ValueAdvantage_Approver_List__c>();
                vdpOfficeMap =[select id,District_Manager__c,District_Manager_User_Id__c,Office_Manager__c,Office_Manager_User_Id__c,SAP_Sales_District__c,SAP_Sales_Office__c,User_Id__c,Username__c,Active_District_Manager__c,Active_Office_Manager__c,Region__c,DOGId__c,Group_Manager__c,Group_Manager_User_Id__c,Active_Group_Manager__c from ValueAdvantage_Approver_List__c];
                VDPFinalList = [select id,name,Approver__c,Customer__c,Customer__r.SAP_SalesDistrict__c,Project_Status__c,Approval_Status__c ,Customer__r.SAP_Sales_Office__c,Customer__r.SAP_Sales_Org_Region_value__c,Customer__r.SAP_SalesGroup__c from ValueAdvantage__c where id in :newlist];
                
                For(ValueAdvantage__c vdp:VDPFinalList){
                    AccountCard.ValueAdvantage3 = False;
                   if(vdp.Approval_Status__c != oldmapValue.get(vdp.Id).Approval_Status__c){
                    
                    If(vdp.Approval_Status__c=='Approved'){
                        vdp.Project_Status__c='Approved';
                    }
                    If(vdp.Approval_Status__c=='Rejected'){
                         System.debug('vdp.Project_Status__c' +vdp.Project_Status__c);
                        vdp.Project_Status__c='Rejected';
                    }
                   }
                    System.debug('vdp.Project_Status__c' +vdp.Project_Status__c);
                    flag=false;
                    //Update Office Manager
                    For(ValueAdvantage_Approver_List__c userlist:vdpOfficeMap ){
                        String groupName;
                        groupName=vdp.Customer__r.SAP_SalesDistrict__c+vdp.Customer__r.SAP_Sales_Office__c+vdp.Customer__r.SAP_SalesGroup__c;
                        If(groupName==userlist.DOGId__c && userlist.DOGId__c!=null &&  userlist.Active_Group_Manager__c==True  && UserInfo.getUserId()!=userlist.Group_Manager_User_Id__c && flag==false){
                            vdp.Approver__c=userlist.Group_Manager_User_Id__c;
                            flag=true;
                        }
                    }                
                    For(ValueAdvantage_Approver_List__c userlist:vdpOfficeMap ){
                        String groupName;
                        groupName=vdp.Customer__r.SAP_SalesDistrict__c+vdp.Customer__r.SAP_Sales_Office__c+vdp.Customer__r.SAP_SalesGroup__c;
                        If(groupName==userlist.DOGId__c && userlist.DOGId__c!=null && vdp.Customer__r.SAP_Sales_Office__c==userlist.SAP_Sales_Office__c && userlist.SAP_Sales_Office__c!=null && vdp.Customer__r.SAP_SalesDistrict__c==userlist.SAP_Sales_District__c  &&  userlist.Active_Office_Manager__c==True && flag==false){
                            vdp.Approver__c=userlist.Office_Manager_User_Id__c;
                            flag=true;
                        }
                    }        
                    For(ValueAdvantage_Approver_List__c userlist :vdpOfficeMap ){
                        String groupName;
                        groupName=vdp.Customer__r.SAP_SalesDistrict__c+vdp.Customer__r.SAP_Sales_Office__c+vdp.Customer__r.SAP_SalesGroup__c;
                        if(groupName==userlist.DOGId__c && userlist.DOGId__c!=null && vdp.Customer__r.SAP_SalesDistrict__c==userlist.SAP_Sales_District__c && userlist.SAP_Sales_District__c !=null && userlist.Active_District_Manager__c==True && flag==false){     
                            vdp.Approver__c=userlist.District_Manager_User_Id__c;
                            flag=true;
                        }
                        
                        
                    }  
                    if((vdp.Customer__r.SAP_Sales_Org_Region_value__c=='NA' || vdp.Customer__r.SAP_Sales_Org_Region_value__c=='LA')  && flag==false){
                        vdp.Approver__c = vaalNA.Office_Manager_User_Id__c;
                    } 
                    if((vdp.Customer__r.SAP_Sales_Org_Region_value__c=='EMEA' || vdp.Customer__r.SAP_Sales_Org_Region_value__c=='AP') && flag==false){
                        vdp.Approver__c = vaalEA.Office_Manager_User_Id__c;
                    }
                    System.debug('vdp.Project_Status__c' +vdp.Project_Status__c);
                    ValueAdvantage__c vnew = new ValueAdvantage__c();
                    vnew.id = vdp.id;
                    vnew.Approver__c = vdp.Approver__c;
                    vnew.Project_Status__c =vdp.Project_Status__c; 
                    VdpListNew.add(vnew);
                    System.debug('vdp.Project_Status__c' +vnew.Project_Status__c);
                } 
                
                Upsert VDPFinalList;
            }
            
            
        }
       // }
    }    
    public static void beforeInsertTrigger (List<ValueAdvantage__c> newlist){        
    }
    
    public static void afterInsertTrigger (List<ValueAdvantage__c> newlist){
        
        List<ValueAdvantage__c> vdpList = new List<ValueAdvantage__c>();
        List<CurrencyType> currencyValueList = New List<CurrencyType>([SELECT id, ISOCode, ConversionRate FROM CurrencyType]);
        Map<string,Decimal> currencyValueMap = New Map<string,Decimal>();
        
        For(CurrencyType CV : currencyValueList){
            currencyValueMap.Put(CV.ISOCode,CV.ConversionRate);
        }
        
        Map<id,id> contentMap = new  Map<id,id>();
        List<String> validId = new List<String>();
        List<ValueAdvantage__c> VdpListNew = new List<ValueAdvantage__c>();
        
        for(ValueAdvantage__c v : newlist){
            
            if(v.Total_Cost_Savings__c!=Null){
                if((v.Project_Status__c =='Completed' || v.Project_Status__c =='Approved' || v.Project_Status__c =='Rejected') ){
                    System.debug('v>>>'+v);
                    vdpList.add(v);
                    validId.add(v.Id);
                    
                    System.debug('vdpList>>'+vdpList);
                }    
            }   
        }
        if(ValueAdvantageTriggerHandler.ValueAdvantage){
            if(validId != null && validId.size() >0){  
                
                ValueAdvantageTriggerHandler.ValueAdvantage = false;
                // validIds.addAll(validId);
                List<ContentDocumentLink> contentDocList = new List<ContentDocumentLink>();
                for(ContentDocumentLink contentDoc : [SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: validId]){
                    contentDocList.add(contentDoc);
                }
                
                for(ContentDocumentLink c:contentDocList){      
                    contentMap.put(c.LinkedEntityId,c.ContentDocumentId);                 
                }
                
                 ByPass__c profileCustomSetting = ByPass__c.getInstance(UserInfo.getProfileId());
                for(ValueAdvantage__c v : vdpList){
                    Decimal isoCodeValue = currencyValueMap.get(v.CurrencyIsoCode);
                    if( !contentMap.containskey(v.id) && !profileCustomSetting.Disable_Trigger__c && v.Total_Cost_Savings__c/isoCodeValue >30000){
                        
                        v.addError('Total Cost Savings is greater than 30K.  Click on Cancel, and Attach files (such as ROI worksheet, CVA document, or other customer provided details) under Files section or VA update for ROI calculator');
                        
                        
                    } 
                    else if(!contentMap.containskey(v.id) && isValidPicklistValue(v) && v.Customer_Region__c =='AP' && v.Project_Status__c=='Completed') 
                    {
                        v.addError('Please change the status to Delivering value, save, attach Return on Investment document under Files section. When done, you can complete the VA');
                       
                    }                    
                }     
                
            }     
            
            if(AccountCard.ValueAdvantage3){
                
                ValueAdvantage_Approver_List__c vaalNA = ValueAdvantage_Approver_List__c.getValues('NA/LA');
                ValueAdvantage_Approver_List__c vaalEA = ValueAdvantage_Approver_List__c.getValues('EMEA/APAC');
                List<ValueAdvantage__c> VDPFinalList = New List<ValueAdvantage__c>();
                Boolean flag;
                List<ValueAdvantage_Approver_List__c> vdpOfficeMap = New List<ValueAdvantage_Approver_List__c>();
                vdpOfficeMap =[select id,District_Manager__c,District_Manager_User_Id__c,Office_Manager__c,Office_Manager_User_Id__c,SAP_Sales_District__c,SAP_Sales_Office__c,User_Id__c,Username__c,Active_District_Manager__c,Active_Office_Manager__c,Region__c,DOGId__c,Group_Manager__c,Group_Manager_User_Id__c,Active_Group_Manager__c from ValueAdvantage_Approver_List__c];
                VDPFinalList = [select id,name,Approver__c,Customer__c,Customer__r.SAP_SalesDistrict__c,Project_Status__c,Approval_Status__c ,Customer__r.SAP_Sales_Office__c,Customer__r.SAP_Sales_Org_Region_value__c,Customer__r.SAP_SalesGroup__c from ValueAdvantage__c where id in :newlist];
                
                For(ValueAdvantage__c vdp:VDPFinalList){
                    if(!Test.isRunningTest()){ AccountCard.ValueAdvantage3 = False;}
                   
                    If(vdp.Approval_Status__c=='Approved'){
                        vdp.Project_Status__c='Approved';
                    }
                    If(vdp.Approval_Status__c=='Rejected'){
                        vdp.Project_Status__c='Rejected';
                    }
                    System.debug('vdp.Project_Status__c' +vdp.Project_Status__c);
                    flag=false;
                    //Update Office Manager
                    For(ValueAdvantage_Approver_List__c userlist:vdpOfficeMap ){
                        String groupName;
                        groupName=vdp.Customer__r.SAP_SalesDistrict__c+vdp.Customer__r.SAP_Sales_Office__c+vdp.Customer__r.SAP_SalesGroup__c;
                        If(groupName==userlist.DOGId__c && userlist.DOGId__c!=null &&  userlist.Active_Group_Manager__c==True  && UserInfo.getUserId()!=userlist.Group_Manager_User_Id__c && flag==false){
                            vdp.Approver__c=userlist.Group_Manager_User_Id__c;
                            flag=true;
                        }
                    }                
                    For(ValueAdvantage_Approver_List__c userlist:vdpOfficeMap ){
                        String groupName;
                        groupName=vdp.Customer__r.SAP_SalesDistrict__c+vdp.Customer__r.SAP_Sales_Office__c+vdp.Customer__r.SAP_SalesGroup__c;
                        If(groupName==userlist.DOGId__c && userlist.DOGId__c!=null && vdp.Customer__r.SAP_Sales_Office__c==userlist.SAP_Sales_Office__c && userlist.SAP_Sales_Office__c!=null && vdp.Customer__r.SAP_SalesDistrict__c==userlist.SAP_Sales_District__c  &&  userlist.Active_Office_Manager__c==True && flag==false){
                            vdp.Approver__c=userlist.Office_Manager_User_Id__c;
                            flag=true;
                        }
                    }        
                    For(ValueAdvantage_Approver_List__c userlist :vdpOfficeMap ){
                        String groupName;
                        groupName=vdp.Customer__r.SAP_SalesDistrict__c+vdp.Customer__r.SAP_Sales_Office__c+vdp.Customer__r.SAP_SalesGroup__c;
                        if(groupName==userlist.DOGId__c && userlist.DOGId__c!=null && vdp.Customer__r.SAP_SalesDistrict__c==userlist.SAP_Sales_District__c && userlist.SAP_Sales_District__c !=null && userlist.Active_District_Manager__c==True && flag==false){     
                            vdp.Approver__c=userlist.District_Manager_User_Id__c;
                            flag=true;
                        }
                        
                        
                    }  
                    if((vdp.Customer__r.SAP_Sales_Org_Region_value__c=='NA' || vdp.Customer__r.SAP_Sales_Org_Region_value__c=='LA')  && flag==false){
                        vdp.Approver__c = vaalNA.Office_Manager_User_Id__c;
                    } 
                    if((vdp.Customer__r.SAP_Sales_Org_Region_value__c=='EMEA' || vdp.Customer__r.SAP_Sales_Org_Region_value__c=='AP') && flag==false){
                        vdp.Approver__c = vaalEA.Office_Manager_User_Id__c;
                    }
                    System.debug('vdp.Project_Status__c' +vdp.Project_Status__c);
                    ValueAdvantage__c vnew = new ValueAdvantage__c();
                    vnew.id = vdp.id;
                    vnew.Approver__c = vdp.Approver__c;
                    vnew.Project_Status__c =vdp.Project_Status__c; 
                    VdpListNew.add(vnew);
                    System.debug('vdp.Project_Status__c' +vnew.Project_Status__c);
                } 
                
                Upsert VDPFinalList;
            }
            
            
        }
    }
    
    public static void updateStatus(List<ValueAdvantage__c> vdpnewlist,Map<id,ValueAdvantage__c> vdpoldlist){
        List<ValueAdvantage__c> vdplist = New List<ValueAdvantage__c>(); 
        List<ValueAdvantage__c> VdpListNew = new List<ValueAdvantage__c>();
        System.debug('###########-vdpnewlist-->'+vdpnewlist);
        vdplist=[Select id,Approval_Status__c,Project_Status__c,Actual_Date_Approved__c,Actual_Date_Completed__c from ValueAdvantage__c where id in :vdpnewlist];
        System.debug('###########-vdplist-->'+vdplist);
        if(AccountCard.ValueAdvantage3){
            For(ValueAdvantage__c vdp:vdplist){  
                AccountCard.ValueAdvantage3 = false;
                if(AccountCard.ValueAdvantage){
                    AccountCard.ValueAdvantage = false;
                    If(vdp.Approval_Status__c=='Approved'){
                        vdp.Project_Status__c='Approved';
                    }
                    If(vdp.Approval_Status__c=='Rejected'){
                        vdp.Project_Status__c='Rejected';
                    }                    
                    // } 
                    ValueAdvantage__c vnew = new ValueAdvantage__c();
                    vnew.id = vdp.id;
                    vnew.Approval_Status__c = vdp.Approval_Status__c;
                    VdpListNew.add(vnew);                           
                }    
            }
        }
        Update VdpListNew;
    }
    
    public static void UpdateApprover(List<ValueAdvantage__c> vdpnewlist){
        ValueAdvantage_Approver_List__c vaalNA = ValueAdvantage_Approver_List__c.getValues('NA/LA');
        ValueAdvantage_Approver_List__c vaalEA = ValueAdvantage_Approver_List__c.getValues('EMEA/APAC');
        List<ValueAdvantage__c> VDPList = New List<ValueAdvantage__c>();
        Boolean flag;
        List<ValueAdvantage_Approver_List__c> vdpOfficeMap = New List<ValueAdvantage_Approver_List__c>();
        vdpOfficeMap =[select id,District_Manager__c,District_Manager_User_Id__c,Office_Manager__c,Office_Manager_User_Id__c,SAP_Sales_District__c,SAP_Sales_Office__c,User_Id__c,Username__c,Active_District_Manager__c,Active_Office_Manager__c,Region__c,DOGId__c,Group_Manager__c,Group_Manager_User_Id__c,Active_Group_Manager__c from ValueAdvantage_Approver_List__c];
        VDPList = [select id,name,Approver__c,Customer__c,Customer__r.SAP_SalesDistrict__c,Customer__r.SAP_Sales_Office__c,Customer__r.SAP_Sales_Org_Region_value__c,Customer__r.SAP_SalesGroup__c from ValueAdvantage__c where id in :vdpnewlist];
        List<ValueAdvantage__c> VdpListNew = new List<ValueAdvantage__c>();
        if(AccountCard.ValueAdvantage2){
            For(ValueAdvantage__c vdp:VDPList){
                AccountCard.ValueAdvantage2  = false;
                flag=false;
                //Update Office Manager
                For(ValueAdvantage_Approver_List__c userlist:vdpOfficeMap ){
                    String groupName;
                    groupName=vdp.Customer__r.SAP_SalesDistrict__c+vdp.Customer__r.SAP_Sales_Office__c+vdp.Customer__r.SAP_SalesGroup__c;
                    If(groupName==userlist.DOGId__c && userlist.DOGId__c!=null &&  userlist.Active_Group_Manager__c==True  && UserInfo.getUserId()!=userlist.Group_Manager_User_Id__c && flag==false){
                        vdp.Approver__c=userlist.Group_Manager_User_Id__c;
                        flag=true;
                    }
                }                
                For(ValueAdvantage_Approver_List__c userlist:vdpOfficeMap ){
                    String groupName;
                    groupName=vdp.Customer__r.SAP_SalesDistrict__c+vdp.Customer__r.SAP_Sales_Office__c+vdp.Customer__r.SAP_SalesGroup__c;
                    If(groupName==userlist.DOGId__c && userlist.DOGId__c!=null && vdp.Customer__r.SAP_Sales_Office__c==userlist.SAP_Sales_Office__c && userlist.SAP_Sales_Office__c!=null && vdp.Customer__r.SAP_SalesDistrict__c==userlist.SAP_Sales_District__c  &&  userlist.Active_Office_Manager__c==True && flag==false){
                        vdp.Approver__c=userlist.Office_Manager_User_Id__c;
                        flag=true;
                    }
                }        
                For(ValueAdvantage_Approver_List__c userlist :vdpOfficeMap ){
                    String groupName;
                    groupName=vdp.Customer__r.SAP_SalesDistrict__c+vdp.Customer__r.SAP_Sales_Office__c+vdp.Customer__r.SAP_SalesGroup__c;
                    if(groupName==userlist.DOGId__c && userlist.DOGId__c!=null && vdp.Customer__r.SAP_SalesDistrict__c==userlist.SAP_Sales_District__c && userlist.SAP_Sales_District__c !=null && userlist.Active_District_Manager__c==True && flag==false){     
                        vdp.Approver__c=userlist.District_Manager_User_Id__c;
                        flag=true;
                    }
                    
                    
                }  
                if((vdp.Customer__r.SAP_Sales_Org_Region_value__c=='NA' || vdp.Customer__r.SAP_Sales_Org_Region_value__c=='LA')  && flag==false){
                    vdp.Approver__c = vaalNA.Office_Manager_User_Id__c;
                } 
                if((vdp.Customer__r.SAP_Sales_Org_Region_value__c=='EMEA' || vdp.Customer__r.SAP_Sales_Org_Region_value__c=='AP') && flag==false){
                    vdp.Approver__c = vaalEA.Office_Manager_User_Id__c;
                }
                ValueAdvantage__c vnew = new ValueAdvantage__c();
                vnew.id = vdp.id;
                vnew.Approver__c = vdp.Approver__c;
                VdpListNew.add(vnew); 
                
            }    
        }
        Upsert VdpListNew;
    }
    
    
    public static boolean isValidPicklistValue(ValueAdvantage__c v){
        
        if(v.Customer_Value_Type_Cost_Savings__c!= NULL &&
           (v.Customer_Value_Type_Cost_Savings__c.contains('Fresh Water Savings (m3/Yr)')|| 
            v.Customer_Value_Type_Cost_Savings__c.contains('Environmental (CO2 t/Yr)') ||
            v.Customer_Value_Type_Cost_Savings__c.contains('Energy (kW/Yr)') ||
            v.Customer_Value_Type_Cost_Savings__c.contains('Energy Fuel t/yr'))){
                
                return true;
                
            }
        return false;
    } 
    
}
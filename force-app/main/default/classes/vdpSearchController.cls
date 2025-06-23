Public class vdpSearchController{

    Public List<WrapProjectStatusList> ProjectStatusList{get;set;}
    Public List<WrapSavingsTypeList> SavingsTypeList{get;set;}
    Public List<WrapValueFocusAreaList> ValueFocusAreaList{get;set;}
    Public List<WrapCustomerValueTypeList> CustomerValueTypeList{get;set;}   
    Public List<WrapCostSavingsList> CostSavingsList {get;set;}
    Public List<WrapBusinessTypeList> BusinessTypeList {get;set;}
    Public List<WrapRegionList> RegionList{get;set;}
    public list<ValueAdvantage__c> multipdfList {get;set;}
    public string query;
    Public Boolean PageFlag{get;set;}
    Public Boolean ProjectStatusflag{get;set;}
    Public Boolean ValueFocusAreaflag{get;set;}
    Public Boolean businessTypeflag{get;set;}
    Public Boolean regionTypeflag{get;set;}
    Public Boolean Masterflag{get;set;}
    Public Boolean Filterflag{get;set;}
    Public Boolean leftflag{get;set;}
    Public Boolean Rightflag{get;set;}
    Public Boolean PdfXlsflag{get;set;}
    Public Boolean PdfXlsflagBW{get;set;}
    Public Boolean Xlsflag{get;set;}
    Public Boolean XlsflagBW{get;set;}
    Public string param{get;set;}
    public Boolean strictSearch{get;set;}
   
    
    
    Public List<ValueAdvantage__c> VdpList{get;set;}//Main List
    Public String searchString{get;set;}
    

    Public vdpSearchController(){
        Project_Status_List();
        Savings_Type_List();
        Value_Focus_Area();
        //Customer_Value_Type();
        //CostSavingsType();
        BusinessType();
        RegionType();
        //SearchVdp();
        //PageFlag=False;
        //Filterflag=false;
        leftflag=false;
        rightflag=false;
        
        PdfXlsflagBW=true;
        XlsflagBW=true;
    }
    
    
    public void Project_Status_List(){
        ProjectStatusList= New List<WrapProjectStatusList>();
        Schema.DescribeFieldResult fieldResult = ValueAdvantage__c.Project_Status__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            System.debug('<<<<ple>>>'+ple);
            for( Schema.PicklistEntry pickListVal : ple){
                   if(pickListVal.getLabel() =='Proposed' || pickListVal.getLabel() =='Delivering Value'){
                            ProjectStatusList.add(new WrapProjectStatusList(pickListVal.getLabel(),false));
                           // p.picklistvalue=pickListVal.getLabel(); 
                        }                     
            }  
            ProjectStatusList.add(new WrapProjectStatusList('Waiting For Approval',false));
            ProjectStatusList.add(new WrapProjectStatusList('Approved',false));
            ProjectStatusList.add(new WrapProjectStatusList('Rejected',false));
            
           
           // ProjectStatusList.picklistvalue='Approved';
           // ProjectStatusList.picklistvalue='Reject';  
    }
    public void Savings_Type_List(){
        SavingsTypeList= New List<WrapSavingsTypeList>();
        Schema.DescribeFieldResult fieldResult = ValueAdvantage__c.Customer_Value_Type_Cost_Avoidance__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                SavingsTypeList.add(new WrapSavingsTypeList(pickListVal.getLabel(),false));
            }  
    }
    public void Value_Focus_Area(){
        ValueFocusAreaList= New List<WrapValueFocusAreaList>();
        Schema.DescribeFieldResult fieldResult = ValueAdvantage__c.Value_Focus_Area__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                ValueFocusAreaList.add(new WrapValueFocusAreaList(pickListVal.getLabel(),false));
            }          
    }
    /*public void Customer_Value_Type(){
        CustomerValueTypeList= New List<WrapCustomerValueTypeList>();
        Schema.DescribeFieldResult fieldResult = ValueAdvantage__c.Customer_Value_Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                CustomerValueTypeList.add(new WrapCustomerValueTypeList(pickListVal.getLabel(),false));
            }    
    }
    public void CostSavingsType(){
        CostSavingsList= New List<WrapCostSavingsList>();
        Schema.DescribeFieldResult fieldResult = ValueAdvantage__c.Customer_Value_Type_Cost_Savings__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                CostSavingsList.add(new WrapCostSavingsList(pickListVal.getLabel(),false));
            }    
    }*/
     public void BusinessType(){
        BusinessTypeList= New List<WrapBusinessTypeList>();
        BusinessTypeList.add(new WrapBusinessTypeList('IWT (Water)',false));
        BusinessTypeList.add(new WrapBusinessTypeList('P&P (Paper)',false));        
    }
    public void RegionType(){
        RegionList= New List<WrapRegionList>();
        RegionList.add(new WrapRegionList('NA',false));
        RegionList.add(new WrapRegionList('AP',false));
        RegionList.add(new WrapRegionList('LA',false));
        RegionList.add(new WrapRegionList('EMEA',false));        
    }
    
    public void MainSearch(){
        clearPicklist();
        Masterflag=false;
        Filterflag=true;
        leftflag=False;
        rightflag=false;
        PdfXlsflag=false; //test
        PdfXlsflagBW=true; //test
        Xlsflag=false;
        XlsflagBW=true;
        SearchVdp();
        PageFlag=false;
        if(VdpList.size()>0||!VdpList.isEmpty()){
            PageFlag=True;           
            leftflag=True;
            
        }
        System.debug('<<PageFlag>>>'+PageFlag);
    }   
    public void SearchVdp(){
        VdpList= New List<ValueAdvantage__c>();
       If(searchString!=''){ 
        String Str;
        Str = '{'+searchString.replace(' ',' OR ')+'}';
        system.debug('<<<Str>>>'+Str);
        VdpList= New List<ValueAdvantage__c>();
        List<ValueAdvantage__c> dubVdpList = New List<ValueAdvantage__c>();
        set<ValueAdvantage__c> RemovedubVdpList = New set<ValueAdvantage__c>();
        List<ValueAdvantage__c> OppNameVDPList= New List<ValueAdvantage__c>();
        List<opportunity> OppList = New List<Opportunity>();
        List<List<SObject>> data = New List<List<SObject>>();
         If(searchString!=''){
                query ='FIND :Str IN ALL FIELDS RETURNING ValueAdvantage__c(id,Name,Check__c,Customer__c,Customer__r.Name,Customer__r.SAP_City__c,Opportunity__r.Name,Opportunity_Name__c,Project_Status__c,Value_Proposition__c,Problem_Statement__c,Opportunity__c,Opportunity__r.SBU_Multi__c,Customer__r.SAP_Partner_Functions__c,Business_Type__c,Customer__r.HQ_Account__r.Name,Customer__r.SAP_Sales_Org_Region_value__c,Solenis_Recommendation__c,Value_Focus_Area__c,Customer_Value_Type_Cost_Savings__c,Customer_Value_Type_Cost_Avoidance__c,Total_Cost_Savings__c where Project_Status__c!=\'Inactive\' and Name!=null),Opportunity(id,name' ;
               // checkTextbox2(selectedProduct,selectedPackage,selectedCountry2,selectedCustomerType);
                query+=')';
               // data= [FIND :searchString IN ALL FIELDS RETURNING ValueAdvantage__c(id,Name,Customer__c,Customer__r.Name,Customer__r.SAP_City__c,Opportunity__r.Name,Project_Status__c,Value_Proposition__c,Savings_Type__c,Problem_Statement__c,Platform_Product_Family__c,Opportunity__c,Opportunity__r.SBU_Multi__c,Customer__r.SAP_Partner_Functions__c,Customer__r.HQ_Account__r.Name,Customer_Value_Type__c,Solenis_Recommendation__c)];
               System.debug('<<<query>>>>'+query);
               data=search.query(query); 
            }
            
            If(searchString !=''){
            dubVdpList=((list<ValueAdvantage__c>)data[0]);
            OppList=((list<opportunity>)data[1]);
            system.debug('<<dubVdpList>>'+dubVdpList.size());
            system.debug('<<OppList>>'+OppList.size());
            set<id> oppId = New set<id>();
            if(OppList.size()>0){
            for(opportunity opp:OppList){
                oppId.add(opp.id);
            } 
            OppNameVDPList=[select id,Name,Check__c,Customer__c,Customer__r.Name,Customer__r.SAP_City__c,Opportunity__r.Name,Opportunity_Name__c,Project_Status__c,Customer__r.SAP_Sales_Org_Region_value__c,Value_Proposition__c,/*Savings_Type__c,*/Problem_Statement__c,/*Platform_Product_Family__c,*/Opportunity__c,Opportunity__r.SBU_Multi__c,Customer__r.SAP_Partner_Functions__c,Customer__r.HQ_Account__r.Name,/*Customer_Value_Type__c,*/Solenis_Recommendation__c,Value_Focus_Area__c,Business_Type__c,Customer_Value_Type_Cost_Savings__c,Customer_Value_Type_Cost_Avoidance__c,Total_Cost_Savings__c from ValueAdvantage__c where Project_Status__c!='Inactive' and Opportunity__c IN :oppId];
            system.debug('<<OppNameVDPList>>'+OppNameVDPList);
            }
            }
            RemovedubVdpList.addAll(OppNameVDPList);
            RemovedubVdpList.addAll(dubVdpList);    
            if(strictSearch==false){
                List<String> searchStringList= searchString.split(' ');
                for(String searchString:searchStringList){                   
                    For(ValueAdvantage__c vdp:RemovedubVdpList){            
                            If(vdp.Name.containsIgnoreCase(searchString) || (vdp.Problem_Statement__c!=null && vdp.Problem_Statement__c.containsIgnoreCase(searchString)) || (vdp.Solenis_Recommendation__c!=null && vdp.Solenis_Recommendation__c.containsIgnoreCase(searchString))|| (vdp.Value_Proposition__c!=null && vdp.Value_Proposition__c.containsIgnoreCase(searchString)) || (vdp.Opportunity_Name__c!=null && vdp.Opportunity_Name__c.containsIgnoreCase(searchString))){
                               VdpList.add(vdp); 
                            }
                    }
                }
             }  
             else{
                 For(ValueAdvantage__c vdp:RemovedubVdpList){            
                            If(vdp.Name.containsIgnoreCase(searchString) || (vdp.Problem_Statement__c!=null && vdp.Problem_Statement__c.containsIgnoreCase(searchString)) || (vdp.Solenis_Recommendation__c!=null && vdp.Solenis_Recommendation__c.containsIgnoreCase(searchString))|| (vdp.Value_Proposition__c!=null && vdp.Value_Proposition__c.containsIgnoreCase(searchString)) || (vdp.Opportunity_Name__c!=null && vdp.Opportunity_Name__c.containsIgnoreCase(searchString))){
                               VdpList.add(vdp); 
                            }
                    }
             } 
            set<ValueAdvantage__c> dubVdpSet = New set<ValueAdvantage__c>();
            dubVdpSet.addAll(VdpList);
            VdpList.clear();
            VdpList.addAll(dubVdpSet);
    
      }
      else{
          Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+'Please enter atleast one word'));
      }    
    }
    
    public void filterSearch(){
        SearchVdp();
        List<ValueAdvantage__c> dubVdpList = New List<ValueAdvantage__c>();
        set<ValueAdvantage__c> Vdpset = New set<ValueAdvantage__c>();
          Boolean isProjectStatus=false;
          Boolean isValueFocusArea=false;
          Boolean isBusinessType=false;
          Boolean isRegion=false;
        
        dubVdpList.clear();
        dubVdpList = VdpList.clone();
        System.debug('<<<VdpList>>>>'+VdpList);
        System.debug('<<<dubVdpList>>>>'+dubVdpList);
        For(WrapProjectStatusList wlist:ProjectStatusList){
           If(wlist.CheckFlag==True){ 
            VdpList.clear();
            Vdpset.clear();
            isProjectStatus=true;
            break;
            }
        }
      
        For(WrapValueFocusAreaList wlist:ValueFocusAreaList){
           If(wlist.CheckFlag==True){ 
            VdpList.clear();
            Vdpset.clear();
            isValueFocusArea=true;
            break;
            }
        }
        For(WrapBusinessTypeList wlist:BusinessTypeList ){
           If(wlist.CheckFlag==True){ 
            VdpList.clear();
            Vdpset.clear();
            isBusinessType=true;
            break;
            }
        }  
        For(WrapRegionList wlist:RegionList){
           If(wlist.CheckFlag==True){ 
            VdpList.clear();
            Vdpset.clear();
            isRegion=true;
            break;
            }
        }  
      
      
      For(ValueAdvantage__c WDP:dubVdpList){     
          Boolean ProjectStatus=True;
          Boolean ValueFocusArea=True;
          Boolean BusinessType=True;
          Boolean Region=True;
             if(isProjectStatus==true){
                 ProjectStatus=false;
                For(WrapProjectStatusList wlist:ProjectStatusList){
                    If(wlist.CheckFlag==true && dubVdpList.size()>0){                
                            If(wlist.picklistvalue==WDP.Project_Status__c){ 
                                  ProjectStatus=true;
                                  break; 
                            }                   
                        }
                    }       
               }
             if(isValueFocusArea==true){  
                 ValueFocusArea=false; 
               For(WrapValueFocusAreaList wlist:ValueFocusAreaList){
                    If(wlist.CheckFlag==true && dubVdpList.size()>0){                    
                            If(wlist.picklistvalue==WDP.Value_Focus_Area__c){ 
                                  ValueFocusArea=true; 
                                  break;
                            }                   
                        }
               }        
             }   
             if(isBusinessType==true){  
                 BusinessType=false;
               For(WrapBusinessTypeList wlist:BusinessTypeList){
                    If(wlist.CheckFlag==true && dubVdpList.size()>0){    
                            If(wlist.picklistvalue==WDP.Business_Type__c){ 
                                 BusinessType=true;
                                 break;
                            }                   
                        }            
               } 
             }  
             if(isRegion==true){  
                 Region=false;
               For(WrapRegionList wlist:RegionList){
                    If(wlist.CheckFlag==true && dubVdpList.size()>0){                  
                            If(wlist.picklistvalue==WDP.Customer__r.SAP_Sales_Org_Region_value__c){ 
                                Region=true;
                                break;
                                  //Vdpset.add(wdp);  
                            }                                   
                    }             
               } 
             }        
       if(ProjectStatus==True && ValueFocusArea==True && BusinessType==True && Region==True){
           Vdpset.add(wdp);
       }
       
      }
          System.debug('<<<Vdpset>>>'+Vdpset.size());
          System.debug('<<<VdpList1>>>'+VdpList.size());
          
          If(Vdpset.size()>0){
          VdpList.clear();
        VdpList.addAll(Vdpset);  
        }
        System.debug('<<<VdpList2>>>'+Vdpset.size());    
        ProjectStatusReset(); 
        ValueFocusAreaReset();
        BusinessTypeReset();
        RegionReset();
    }
    
    
    public void ProjectStatus(){
        
    }
    
    
    Public void SelectProjectStatus(){
        For(WrapProjectStatusList wpsl:ProjectStatusList){
                wpsl.CheckFlag=ProjectStatusflag;
        }
        filterSearch();
        
    }
    
    Public void SelectValueFocusArea(){
        For(WrapValueFocusAreaList wpsl:ValueFocusAreaList){
                wpsl.CheckFlag=ValueFocusAreaflag;
        }
        filterSearch();
        
    }
    Public void SelectBusinessType(){
        For(WrapBusinessTypeList wpsl:BusinessTypeList){
                wpsl.CheckFlag=businessTypeflag;
        }
        filterSearch();
        
    }
    Public void SelectRegionType(){
        For(WrapRegionList wpsl:RegionList){
                wpsl.CheckFlag=regionTypeflag;
        }
        filterSearch();
        
    }
    Public void clearPicklist(){
        For(WrapValueFocusAreaList wpsl:ValueFocusAreaList){
                wpsl.CheckFlag=false;
        }
        For(WrapProjectStatusList wpsl:ProjectStatusList){
                wpsl.CheckFlag=false;
        }
         For(WrapBusinessTypeList wpsl:BusinessTypeList){
                wpsl.CheckFlag=false;
        }
        For(WrapRegionList wpsl:RegionList){
                wpsl.CheckFlag=false;
        }
        ProjectStatusflag=false;
        ValueFocusAreaflag=false;
        businessTypeflag=false;
        regionTypeflag=false;
        
    }
    
    Public void mastercheck(){        
        For(ValueAdvantage__c vdp : VdpList){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Approved Records Only Download in PDF, All record can be downloaded from excel.'));
            
                vdp.Check__c=Masterflag;
           
        }
        ShowPdfXls();
        ShowPdf();
        callpageredirectpdf();
    }
    public void ProjectStatusReset(){
        for(WrapProjectStatusList PSL: ProjectStatusList){
            if(PSL.CheckFlag==false){
               ProjectStatusflag=false;
               break;     
            }
            else{
                ProjectStatusflag=True;
            }
        }
        
        
    }
    public void ValueFocusAreaReset(){
        for(WrapValueFocusAreaList VFA: ValueFocusAreaList){
            if(VFA.CheckFlag==false){
               ValueFocusAreaflag=false;
               break;     
            }
            else{
                ValueFocusAreaflag=True;
            }
        }
        
        
    }
    public void BusinessTypeReset(){
        for(WrapBusinessTypeList PSL: BusinessTypeList){
            if(PSL.CheckFlag==false){
               businessTypeflag=false;
               break;     
            }
            else{
                businessTypeflag=True;
            }
        }
        
        
    }
    
    public void RegionReset(){
        for(WrapRegionList PSL: RegionList){
            if(PSL.CheckFlag==false){
               regionTypeflag=false;
               break;     
            }
            else{
                regionTypeflag=True;
            }
        }
        
        
    }
    
    public void GridReset(){
        system.debug('<<VdpList>>'+VdpList);
        for(ValueAdvantage__c VFA: VdpList){
            if(VFA.Check__C==false){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Approved Records Only Download in PDF, All record can be downloaded from excel.'));
               Masterflag=false;
               system.debug('<V>'+Masterflag) ;
               break;    
               
            }
            else{
                Masterflag=True;
            }
        }
        
        ShowPdfXls();
        ShowPdf();
        callpageredirectpdf();
    }
    
    public void callpageredirectpdf(){
            multipdfList=New List<ValueAdvantage__c>();
            param='';
            system.debug('<<>>'+VdpList);
            For(ValueAdvantage__c ac: VdpList){
                 if(ac.Check__c==true){
                     multipdfList.add(ac);
                     if(param==null){
                         param=ac.id;
                         }
                         else{
                             param+=','+ac.id;
                         }
                 }
            }
            system.debug('<><><>'+multipdfList.size());
            //PageReference demoPage = new pagereference('/apex/VdpMultiPdfDownload?id='+param);
            //demoPage.setRedirect(true);
            //return demoPage;
            system.debug('<><><>'+param);
            }
            
     public pagereference callpageredirectxls(){
            multipdfList=New List<ValueAdvantage__c>();
            string param;
            system.debug('<<>>'+VdpList);
            For(ValueAdvantage__c ac: VdpList){
                 if(ac.Check__c==true){
                     multipdfList.add(ac);
                     if(param==null){
                         param=ac.id;
                         }
                         else{
                             param+=','+ac.id;
                         }
                 }
            }
            system.debug('<><><>'+multipdfList.size());
            PageReference demoPage = new pagereference('/apex/VDPMultiXLS?id='+param +'&retUrl=/');        
            demoPage.setRedirect(true);
            return demoPage;
            }
            
       Public void AccordianHide(){
               if(Filterflag==true){
               Filterflag=false;
                   leftflag=false;
                   rightflag=true;
               }
               else if(Filterflag==false){
                   Filterflag=True;
                   leftflag=true;
                   rightflag=false;
               }
                    
       }    
       
       Public void ShowPdfXls(){
           system.debug('<VdpList>'+VdpList.size());
           For(ValueAdvantage__c ac: VdpList){
               if(ac.Check__c==true && ac.Project_Status__c=='Approved'){                    
                     PdfXlsflag=True;
                     PdfXlsflagBW=false;                     
                     system.debug('<<<<<<<<<<<PdfXlsflag>>>>>>>>>>>>>>>>>'+PdfXlsflag);
                     system.debug('<<<<<<<<<<<PdfXlsflagBW>>>>>>>>>>>>>>>>>'+PdfXlsflagBW);
                    
                     Break;  
                     
               }
               else{
                   system.debug('>><<<><><><><><<><');
                   PdfXlsflag=false;
                   PdfXlsflagBW=true;
                   
               }
           
           } 
      }       
      Public void ShowPdf(){
           system.debug('<VdpList>'+VdpList.size());
           For(ValueAdvantage__c ac: VdpList){
               if(ac.Check__c==true){                    
                     Xlsflag=True;
                     XlsflagBW=false;
                     system.debug('<<<<<<<<<<<Xlsflag>>>>>>>>>>>>>>>>>'+Xlsflag);
                     system.debug('<<<<<<<<<<<XlsflagBW>>>>>>>>>>>>>>>>>'+XlsflagBW);                   
                     Break;  
                     
               }
               else{
                   system.debug('>><<<><><><><><<><');                   
                   Xlsflag=false;
                   XlsflagBW=true;
               }
           
           } 
      }         
    //Wraper classes
    Public class WrapProjectStatusList{
        public String picklistvalue {get;set;}
        public boolean CheckFlag{get;set;}
        public WrapProjectStatusList(String picklistvalue ,boolean CheckFlag){
        this.picklistvalue=picklistvalue;
        this.CheckFlag=false;
        }
        
    }
    
    
    Public class WrapSavingsTypeList{
        public String picklistvalue {get;set;}
        public boolean CheckFlag{get;set;}
        public WrapSavingsTypeList(String picklistvalue ,boolean CheckFlag){
        this.picklistvalue=picklistvalue;
        this.CheckFlag=false;
        }
        
    }
    Public class WrapValueFocusAreaList{
        public String picklistvalue {get;set;}
        public boolean CheckFlag{get;set;}
        public WrapValueFocusAreaList(String picklistvalue ,boolean CheckFlag){
        this.picklistvalue=picklistvalue;
        this.CheckFlag=false;
        }
        
    }
    Public class WrapCustomerValueTypeList{
        public String picklistvalue {get;set;}
        public boolean CheckFlag{get;set;}
        public WrapCustomerValueTypeList(String picklistvalue ,boolean CheckFlag){
        this.picklistvalue=picklistvalue;
        this.CheckFlag=false;
        }
        
    }
    Public class WrapCostSavingsList{
        public String picklistvalue {get;set;}
        public boolean CheckFlag{get;set;}
        public WrapCostSavingsList(String picklistvalue ,boolean CheckFlag){
        this.picklistvalue=picklistvalue;
        this.CheckFlag=false;
        }
        
    }
        Public class WrapBusinessTypeList{
        public String picklistvalue {get;set;}
        public boolean CheckFlag{get;set;}
        public WrapBusinessTypeList(String picklistvalue ,boolean CheckFlag){
        this.picklistvalue=picklistvalue;
        this.CheckFlag=false;
        }
        
    }
    Public class WrapRegionList{
        public String picklistvalue {get;set;}
        public boolean CheckFlag{get;set;}
        public WrapRegionList(String picklistvalue ,boolean CheckFlag){
        this.picklistvalue=picklistvalue;
        this.CheckFlag=false;
        }
        
    }
    
    
}
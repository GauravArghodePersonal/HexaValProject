public with sharing class Material_Sales_Data2_Controller {
    
    private static final String XX = 'X';
    
    private final String userProfileName;
    private final Set<String> allViewProfiles = new Set<String>{
        'CA Team - Tier 3 Support',
            'System Administrator',
            'System Administrator - SSO Enabled'
            };
                
                private final Set<String> baseCodeViewProfiles = new Set<String>{
                    'W-Business Manager',
                        'W-Business Manager - EMEA',
                        'W-Business Manager - EMEA - NON SSO',
                        'W-Business Manager - non G3'        // added in NPI Project
                        };
                            
                            public Material_Sales_Data2__c msd {get; private set;}
    public Boolean showBaseCode        {get; set;}
    public String reqLeadTimeHelp      {get; private set;}
    public String deletedHelp           {get; private set;}
    
    public Boolean showDeletedPlants {get; set;}
    public Boolean renderPlantShowHidePanel {get; set;}
    private List<Material_Plant2__c> allPlants = new List<Material_Plant2__c>();
    private List<Material_Plant2__c> nonDeletedPlants= new List<Material_Plant2__c>();
    
    public Material_Sales_Data2_Controller(ApexPages.StandardController stdController) {
        msd = (Material_Sales_Data2__c)stdController.getRecord(); init1();
        userProfileName = User_Functions.getLoggedInUserProfileName();
        showBaseCode = (allViewProfiles.contains(userProfileName) || 
                        baseCodeViewProfiles.contains(userProfileName));
        System.debug(userProfileName + ':' + showBaseCode);
        reqLeadTimeHelp = Material_Plant2__c.Required_Lead_Time__c.getDescribe().getInlineHelpText();
        deletedHelp = Material_Plant2__c.Deletion_Flag__c.getDescribe().getInlineHelpText();
        showDeletedPlants = false;
     //   System.debug('allPlants3-->'+allPlants.size());
        
    }
    @TestVisible
    private void init1() {
        if (msd == null || msd.Id == null) {return;}
        msd = [select Id, Name, 
               Deletion_Flag__c,
               DistChannel_Desc__c,
               Dist_Channel_Code__c,
               Dist_Channel_Material_Status__c,
               Division_Code__c,
               Gross_Weight__c,
               Gross_Weight_in_LBs__c,
               Material_Desc__c,
               Material_General_Data__r.Base_UOM_Desc__c,
               Material_General_Data__r.Cross_Dist_Material_Status__c,
               Material_General_Data__r.Division_Desc__c,
               Material_General_Data__r.Marked_for_deletion__c,
               Material_General_Data__r.Material_Base_Code_Desc__c,
               Material_General_Data__r.Material_Container_Desc__c,
               Material_General_Data__r.Material_Group_Desc__c,
               Material_General_Data__r.Material_Type_Desc__c,
               Material_General_Data__r.Weight_UOM_Desc__c,
               Material_General_Data__r.id,
               Material_Group1_Desc__c,
               Material_Group2_Desc__c,
               Material_Number__c,
               Minimum_Order_Qty__c,
               Net_Weight__c,
               Net_Weight_in_LBs__c,
               Product_Hierarchy__r.PH1_Division__c,
               Product_Hierarchy__r.PH1__c,
               Product_Hierarchy__r.PH2_Line__c,
               Product_Hierarchy__r.PH2__c,
               Product_Hierarchy__r.PH3_Group__c,
               Product_Hierarchy__r.PH3__c,
               Product_Hierarchy__r.PH4_Supplier__c,
               Product_Hierarchy__r.PH4__c,
               Product_Hierarchy__r.PH5_Family__c,
               Product_Hierarchy__r.PH5__c,
               Product_Hierarchy__r.PH6_Segment__c,
               Product_Hierarchy__r.PH6__c,
               Product_Hierarchy__r.PH7_SubSegment__c,
               Product_Hierarchy__r.PH7__c,
               SalesOrg_Desc__c,
               Sales_Org_Code__c,
               Sales_UOM_Desc__c,
               NP_Base_Code__c,
               Sample_Material__c,LastModifiedDate,LastModifiedById,NPI_Product__c,NP_Effective_Date__c,NP_Global_Region__c,NPI_Record_key__c,NP_Industry__c,NP_DistrChannel__c,NP_Customer_group__c,NP_Product_category__c
               
               from Material_Sales_Data2__c where Id = :msd.Id];
     //   System.debug('msdMaterial_General_Data__c'+msd.Material_General_Data__c);
        allPlants =  Material_Sales_Data_Functions.getPlants(msd); 
       // System.debug('allPlants-->'+allPlants.size());
        RemoveQM01Plants(); 
        PopulateNonDeletedPlants();  
        // New Function by Donald to Add lead time form Material leadtime table for Non 3 rd party plant.
        PopulateLeadtimeNon3Party();
       // System.debug('allPlants2-->'+allPlants.size());
    }
    private void PopulateLeadtimeNon3Party()
    {
        List<String> leadtimekey=new List<String>();
        Map<String,Material_Plant_Leadtime__c> mltmap=new  Map<String,Material_Plant_Leadtime__c>();
        Material_Plant_Leadtime__c mplval=new Material_Plant_Leadtime__c();
        String plantval;
        String key1;
        // SalesOrg + Material No + Family code+ Plant code  --> Display Exception Lead time 
        String key2;     
        // SalesOrg + Family code + Plant code    --> Display Exception Lead time 
        String key3;       
        // Family code + Plant code    --> Display Standard Lead time 
   
        if ((allPlants != null)&&(allPlants.size()>0))
        {
            for(Integer i=0;i<allPlants.size();i++)
            {
                if(allPlants[i].Third_Party_Plant__c==false)
                {
                   //  system.debug('inside TESTTTT');
                  //  system.debug('allPlants[i]'+allPlants[i].MRP_Type__c);
                  //  system.debug('allPlants[i].Plant_Code__c'+allPlants[i].Plant_Code__c);
                    //Key change to include MRP Type in 
                    // Add Key1 to Query List 
                    // Salesorg+ Material No + Family code+ Plant code  
                    if(allPlants[i].MRP_Type__c!=null)
                    {
                      key1=msd.Sales_Org_Code__c+msd.Material_Number__c+msd.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c+allPlants[i].MRP_Type__c;   
                    }
                    else
                    {
                    key1=msd.Sales_Org_Code__c+msd.Material_Number__c+msd.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c;
                    }
                        //  system.debug('key11111'+key1);
                    if(key1!=null)
                    {
                        leadtimekey.add(key1);
                    }
                    else
                    {
                        system.debug('Key 1 Found Null');
                    }
                    // Add Key2 to Query List 
                     if(allPlants[i].MRP_Type__c!=null)
                    {
                    key2=msd.Material_Number__c+msd.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c+allPlants[i].MRP_Type__c;
                    }
                    else
                    {
                         key2=msd.Material_Number__c+msd.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c; 
                    }
                        //  system.debug('key2'+key2);
                    if(key2!=null)
                    {
                        leadtimekey.add(key2);
                    }
                    else
                    {
                        system.debug(' Key 2 Nulll Found Null');
                    }
                    // Add Key2 to Query List 
                               if(allPlants[i].MRP_Type__c!=null)
                    {
                    key2=msd.Material_Number__c+msd.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c+allPlants[i].MRP_Type__c;
                    }
                    else
                    {
                       key2=msd.Material_Number__c+msd.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c;  
                    }
                        system.debug('key2'+key2);
                    if(key2!=null)
                    {
                        leadtimekey.add(key2);
                    }
                    else
                    {
                        system.debug(' Key 2 Nulll Found Null');
                    }
                    // Add Key2 to Query List 
                             if(allPlants[i].MRP_Type__c!=null)
                    {
                    key3=msd.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c+allPlants[i].MRP_Type__c;
                    }
                    else
                    {
                      key3=msd.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c;  
                    }
                  //  system.debug('key3'+key3);
                    if(key3!=null)
                    {
                        leadtimekey.add(key3);
                    }
                    else
                    {
                        system.debug(' Key 2 Nulll Found Null');
                    }
                }
                else
                {
                    system.debug('----Else-->'+i);
                    system.debug('TInside Else for record'+allPlants[i].Third_Party_Plant__c);
                }
            
        }
            //Execute query to get list of leadtime
            if(leadtimekey.size()>=1)
            {
                List<Material_Plant_Leadtime__c> mlt=[select LeadTimeKey__c,QueryKey__c,Name,Standard_Lead_Time__c,Exception_Lead_Time__c,id from Material_Plant_Leadtime__c where QueryKey__c in:leadtimekey and Deletion_Indicator__c!='x' order by LeadTimeKey__c desc ];
                //add to MAP        
                if(mlt.size()>=1)
                {
                    for(Material_Plant_Leadtime__c m:mlt )
                    {
                        String keygen=m.QueryKey__c;
                        mltmap.put(keygen,m);
                    }
                }
            }
           // system.debug('DDD'+mltmap.size());
          //  system.debug('DDD'+mltmap);
          //  system.debug('DDD'+allPlants.size());
            for(Integer i=0;i<allPlants.size();i++)
            {
                if(allPlants[i].Third_Party_Plant__c==false)
                {           
                              if(allPlants[i].MRP_Type__c!=null)
                    {
                    // Check Key1
                    key1=msd.Sales_Org_Code__c+msd.Material_Number__c+msd.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c+allPlants[i].MRP_Type__c;
                    // Check Key2
                    key2=msd.Material_Number__c+msd.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c+allPlants[i].MRP_Type__c;
                    // check key3
                    key3=msd.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c+allPlants[i].MRP_Type__c;   
                    }
                    else
                    {
                       // Check Key1
                    key1=msd.Sales_Org_Code__c+msd.Material_Number__c+msd.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c;
                    // Check Key2
                    key2=msd.Material_Number__c+msd.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c;
                    // check key3
                    key3=msd.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c;      
                    }
                    if(mltmap.get(key1)!=null)
                    {
                   //     system.debug('Key 1 --> '+mltmap.get(key1));
                        mplval=mltmap.get(key1);
                        allPlants[i].Required_Lead_Time__c=mplval.Standard_Lead_Time__c;
                        system.debug('Key 1 Exception time set--> '+mplval.Standard_Lead_Time__c);
                    }
                    else if(mltmap.get(key2)!=null)
                    {
                    //    system.debug('Key 2 --> '+mltmap.get(key2));
                        mplval=mltmap.get(key2);
                        allPlants[i].Required_Lead_Time__c=mplval.Standard_Lead_Time__c;
                        system.debug('Key 2 Exception time set--> '+mplval.Standard_Lead_Time__c);
                    }
                    else if(mltmap.get(key3)!=null)
                    {
                    //    system.debug('Key 3 --> '+mltmap.get(key3));
                        mplval=mltmap.get(key3);
                        allPlants[i].Required_Lead_Time__c=mplval.Standard_Lead_Time__c;
                        system.debug('Key 3 Standard time set--> '+mplval.Standard_Lead_Time__c);
                    }
                    else
                    {
                        
                        system.debug('Else --> ');
                    }
                }
            }
            
        }
    }
    private void RemoveQM01Plants()
    {
        if (allPlants != null)
        {
            for (Integer i = 0; i < allPlants.size(); i++)
            {
                if (allPlants[i].Plant_Code__c.equals('QM01'))
                    allPlants.remove(i);            
            }
        }
    }
    
    private void PopulateNonDeletedPlants()
    {
        if (allPlants != null)
        {
            renderPlantShowHidePanel = false;
            if (allPlants.size()>0)
            {
                for (Material_Plant2__c mp : allPlants)
                {
                    if (mp.Deletion_Flag__c == XX)
                        renderPlantShowHidePanel = true;
                    else
                        nonDeletedPlants.add(mp);               
                }
            }
        }
    }
    
    public void ToggleDeletedPlants()
    {
        showDeletedPlants = !showDeletedPlants;
    }
    
    public String getMaterial_Sales_Data2() {
        return 'Material_Sales_Data2__c ' + ' (' + msd + ')';
    }
    
    public String getMaterialNumber() {
        String matnum = String_Functions.removeLeadingZeros(msd.Material_Number__c);
        return matnum;
    }
    
    public Boolean getSampleMaterial() {
        return XX.equalsIgnoreCase(msd.Sample_Material__c);
    }
    
    public List<Material_UOM2__c> getAltUOMs() {
        return Material_Sales_Data_Functions.getAltUOMs(msd);
    }
    
    public List<Material_Plant2__c> getPlants() {
        
        if (showDeletedPlants)
            return allPlants;
        else
        {
            return nonDeletedPlants;
            
        }
    }
    
    /*
**************************************************************
Test Methods are in Material_Sales_Data2_Controller_Test class
************************************************************** 
*/    
    
}
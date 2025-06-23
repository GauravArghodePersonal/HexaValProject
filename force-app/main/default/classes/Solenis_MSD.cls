public with sharing class Solenis_MSD {

    @AuraEnabled
    public Material_Sales_Data2__c CaseObject{get; set;}
    
    @AuraEnabled
    public string Matnum{get; set;}
    
    @AuraEnabled
    public List<Material_Plant2__c> allPlants{get; set;}
    
    @AuraEnabled
    public List<Material_UOM2__c> AltUOM{get; set;}
    
    @AuraEnabled
    public List<Material_UOM2__c> AltUOM2{get; set;}
    
    public class plantInfo{
        @AuraEnabled public string nameCode;
        @AuraEnabled public string address;
        @AuraEnabled public string partyPlant = '-';
        @AuraEnabled public Decimal requiredLeadtime;
        @AuraEnabled public string isDeleted;
    }
    
    @AuraEnabled public boolean enableNPI = false;
    @AuraEnabled public boolean enableSample = false;
        
    @AuraEnabled
    public List<plantInfo> plants{get; set;}

    @AuraEnabled public string baseUOM;
    @AuraEnabled public string weightUOM;
    @AuraEnabled public string materialContainerDesc;
    @AuraEnabled public string materialGroupDesc;
    @AuraEnabled public string materialTypeDesc;
    @AuraEnabled public string markedForDeletion;
    @AuraEnabled public string divisionDesc;
    @AuraEnabled public string distMatStatus;
    @AuraEnabled public string phd;
    @AuraEnabled public string PH2_Line;
    @AuraEnabled public string  PH3_Group;
    @AuraEnabled public string   PH4_Supplier;
    @AuraEnabled public string   PH5_Family;
    @AuraEnabled public string   PH6_Segment;
    @AuraEnabled public string   PH7_SubSegment;
    @AuraEnabled public string   PH1;
    @AuraEnabled public string   PH2;
    @AuraEnabled public string   PH3;
    @AuraEnabled public string   PH4;
    @AuraEnabled public string   PH5;
    @AuraEnabled public string   PH6;
    @AuraEnabled public string   PH7;
    
    public Solenis_MSD(String oppid, boolean filterValue) {
        CaseObject = new Material_Sales_Data2__c();
        //Material_Sales_Data2__c o = [select id,  Name from Material_Sales_Data2__c where id =:oppid];
        CaseObject = [select Id, Name, 
                    Deletion_Flag__c,
                    DistChannel_Desc__c,
                    Dist_Channel_Code__c,
                    Dist_Channel_Material_Status__c,
                    Division_Code__c,
                    Gross_Weight__c,
                    Gross_Weight_in_LBs__c,
                    Material_Desc__c,
                    Material_General_Data__c,
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
                    solenisNPI_Product__c,
                    solenisLastmodyName__c,
                      Sales_Org_Region__c,
                    Sample_Material__c,LastModifiedDate,LastModifiedById,NPI_Product__c,NP_Effective_Date__c,NP_Global_Region__c,NPI_Record_key__c,NP_Industry__c,NP_DistrChannel__c,NP_Customer_group__c,NP_Product_category__c
                    
                     from Material_Sales_Data2__c where id =:oppid];
               // if(o !=NULL){
                 //   CaseObject.Name = o.Name;
                
                //}
     Matnum =  String_Functions.removeLeadingZeros(CaseObject.Material_Number__c);
     baseUOM = CaseObject.Material_General_Data__r.Base_UOM_Desc__c;
     weightUOM = CaseObject.Material_General_Data__r.Weight_UOM_Desc__c;
     materialContainerDesc = CaseObject.Material_General_Data__r.Material_Container_Desc__c;
     materialGroupDesc = CaseObject.Material_General_Data__r.Material_Group_Desc__c;
     materialTypeDesc = CaseObject.Material_General_Data__r.Material_Type_Desc__c;
     markedForDeletion = CaseObject.Material_General_Data__r.Marked_for_deletion__c;
     divisionDesc = CaseObject.Material_General_Data__r.Division_Desc__c + ' - ' + CaseObject.Division_Code__c;
     distMatStatus = CaseObject.Material_General_Data__r.Cross_Dist_Material_Status__c;
     phd= CaseObject.Product_Hierarchy__r.PH1_Division__c;
     PH2_Line= CaseObject.Product_Hierarchy__r.PH2_Line__c;
     PH3_Group = CaseObject.Product_Hierarchy__r.PH3_Group__c;
     PH4_Supplier = CaseObject.Product_Hierarchy__r.PH4_Supplier__c;
     PH5_Family = CaseObject.Product_Hierarchy__r.PH5_Family__c;
     PH6_Segment = CaseObject.Product_Hierarchy__r.PH6_Segment__c;
     PH7_SubSegment = CaseObject.Product_Hierarchy__r.PH7_SubSegment__c;
     PH1 = CaseObject.Product_Hierarchy__r.PH1__c;
     PH2 = CaseObject.Product_Hierarchy__r.PH2__c;
     PH3 = CaseObject.Product_Hierarchy__r.PH3__c;
     PH4 = CaseObject.Product_Hierarchy__r.PH4__c;
     PH5 = CaseObject.Product_Hierarchy__r.PH5__c;
     PH6 = CaseObject.Product_Hierarchy__r.PH6__c;
     PH7 = CaseObject.Product_Hierarchy__r.PH7__c;
     
     List<Material_Plant2__c> allPlantsData = new List<Material_Plant2__c>();
     allPlantsData =  Material_Sales_Data_Functions.getPlants(CaseObject);
        system.debug('TTT 123'+allPlantsData);
     AltUOM = new List<Material_UOM2__c>();
     /*AltUOM = [select Alt_Gross_Weight__c, Material_Number__c,
                           Alt_Net_Weight__c,
                           Alternative_UOM__c,
                           Alternative_UOM_Desc__c,
                           Base_UOM_Desc__c,
                           Gross_Weight_in_LBs__c, 
                           Net_Weight_in_LBs__c, Material_General_Data__c
                      from Material_UOM2__c where Material_General_Data__c =: CaseObject.Material_General_Data__c];
    AltUOM2 = new List<Material_UOM2__c>();*/
    
     if (allPlantsData != null)
        {
            for (Integer i = 0; i < allPlantsData.size(); i++)
            {
                if (allPlantsData[i].Plant_Code__c.equals('QM01'))
                    allPlantsData.remove(i);            
            }
        }
    
    AltUOM = Material_Sales_Data_Functions.getAltUOMs(CaseObject);
    allPlants = new List<Material_Plant2__c>();
    allPlants = getNonDeletadPlants(allPlantsData, filterValue); 
        //New Function Added for Lead time 28/5/2020
     allPlants=PopulateLeadtimeNon3Party(allPlants,CaseObject);
    plants = new List<plantInfo>();
    for(Material_Plant2__c p:allPlants){

        system.debug(p.Plant_Name__c + ' - '+p.Plant_Code__c);
        system.debug(p.Third_Party_Plant__c);
        system.debug(p.Required_Lead_Time__c);
         system.debug('DONALD Test End');
        plantInfo pinfo = new plantInfo();
        pinfo.nameCode = p.Plant_Name__c + ' - '+p.Plant_Code__c;
        pinfo.address = p.Plant_Address__c;
        if(p.Third_Party_Plant__c){
            pinfo.partyPlant ='Yes';    
        }
        pinfo.requiredLeadtime = p.Required_Lead_Time__c;
        pinfo.isDeleted = p.Deletion_Flag__c;
        plants.add(pinfo);
    }
    
    if(CaseObject.solenisNPI_Product__c== 'True'){
        enableNPI = True;
    }
    else {
        enableNPI = false;
    }
    
    if(CaseObject.Sample_Material__c=='X'){
        enableSample = true;   
    }
    
    /*nameCode = 
    address;
    partyPlant;
    requiredLeadtime;
    isDeleted;*/
    System.debug('plants>>>'+plants);
    }
    
    
    public static List<Material_Plant2__c> getNonDeletadPlants (List<Material_Plant2__c> allPlants, boolean filterValue){
            List<Material_Plant2__c> nonDeleted = new List<Material_Plant2__c>();
            List<Material_Plant2__c> Deleted = new List<Material_Plant2__c>();
            if (allPlants != null && allPlants.size()>0){
                    for (Material_Plant2__c mp : allPlants)
                    {
                        if (mp.Deletion_Flag__c == 'X'){
                            Deleted.add(mp); 
                            }
                         else{nonDeleted.add(mp);}              
                    }
            }
            if(filterValue){
                nonDeleted.addAll(Deleted);
            }
            
            return nonDeleted;
    }
    
@AuraEnabled(cacheable=true)
    public static Solenis_MSD init(String oppid, boolean filterValue){
        System.debug('oppid>>>'+oppid);
        System.debug('filterValue>>>'+filterValue);
        Solenis_MSD objCase = new Solenis_MSD(oppid, filterValue);
        return objCase;
    }
    
     public static List<Material_Plant2__c> PopulateLeadtimeNon3Party(List<Material_Plant2__c> allPlants, Material_Sales_Data2__c CaseObject)  
    {
        system.debug('11111111');
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
        if (allPlants.size()>0)
        {
            for(Integer i=0;i<allPlants.size();i++)
            {
                if(allPlants[i].Third_Party_Plant__c==false)
                {
                    // Add Key1 to Query List 
                    // Salesorg+ Material No + Family code+ Plant code  
                 //   if(allPlants[i].MRP_Type__c==null)
                            if(CaseObject.Sales_Org_Region__c=='NA')
                    {
                        
                       key1=CaseObject.Sales_Org_Code__c+CaseObject.Material_Number__c+CaseObject.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c;  
                    }
                    else
                    {
                    key1=CaseObject.Sales_Org_Code__c+CaseObject.Material_Number__c+CaseObject.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c+allPlants[i].MRP_Type__c;
                    }
                        system.debug('key1'+key1);
                    if(key1!=null)
                    {
                        leadtimekey.add(key1);
                    }
                    else
                    {
                        system.debug('Key 1 Found Null');
                    }
                    // Add Key2 to Query List 
                   /* key2=CaseObject.Material_Number__c+CaseObject.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c+allPlants[i].MRP_Type__c;
                    system.debug('key2'+key2);
                    if(key2!=null)
                    {
                        leadtimekey.add(key2);
                    }
                    else
                    {
                        system.debug(' Key 2 Nulll Found Null');
                    }*/
                    // Add Key2 to Query List 
                    // // Code change for MRP Type NA
                     //if(allPlants[i].MRP_Type__c==null)
                     if(CaseObject.Sales_Org_Region__c=='NA')
                    {
                        key2=CaseObject.Material_Number__c+CaseObject.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c;
                    }
                    else
                    {
                       key2=CaseObject.Material_Number__c+CaseObject.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c+allPlants[i].MRP_Type__c;  
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
                    // Add Key2 to Query List CaseObject.Sales_Org_Region__c!='NA'
                       // if(allPlants[i].MRP_Type__c==null)
                              if(CaseObject.Sales_Org_Region__c=='NA')
                    {
                        key3=CaseObject.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c;
                    }
                    else
                    {
                       key3=CaseObject.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c+allPlants[i].MRP_Type__c;
                    }
                   
                    system.debug('key3'+key3);
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
                List<Material_Plant_Leadtime__c> mlt;
                if(CaseObject.Sales_Org_Region__c=='NA')
                {
                  mlt=[select LeadTimeKey__c,QueryKey__c,QueryKeyNA__c,Name,Standard_Lead_Time__c,Exception_Lead_Time__c,id from Material_Plant_Leadtime__c where QueryKeyNA__c in:leadtimekey and Deletion_Indicator__c!='x' order by LeadTimeKey__c desc];   
                system.debug('mlt--NA'+mlt);
                }
                else
                {
                mlt=[select LeadTimeKey__c,QueryKey__c,QueryKeyNA__c,Name,Standard_Lead_Time__c,Exception_Lead_Time__c,id from Material_Plant_Leadtime__c where QueryKey__c in:leadtimekey and Deletion_Indicator__c!='x' order by LeadTimeKey__c desc];
                 system.debug('mlt'+mlt);
                }//add to MAP        
                if(mlt.size()>=1)
                {
                    if(CaseObject.Sales_Org_Region__c=='NA')
                    {
                    for(Material_Plant_Leadtime__c m:mlt )
                    {
                        String keygen=m.QueryKeyNA__c;
                        mltmap.put(keygen,m);
                    }
                    }
                    else
                    {
                       for(Material_Plant_Leadtime__c m:mlt )
                    {
                        String keygen=m.QueryKey__c;
                        mltmap.put(keygen,m);
                    }  
                    }
                }
            }
            system.debug('DDD'+mltmap.size());
            system.debug('DDD'+mltmap);
            for(Integer i=0;i<allPlants.size();i++)
            {
                if(allPlants[i].Third_Party_Plant__c==false)
                {                   
                    // Check Key1
                       // if(allPlants[i].MRP_Type__c==null)
                          if(CaseObject.Sales_Org_Region__c=='NA')
                    {
                    key1=CaseObject.Sales_Org_Code__c+CaseObject.Material_Number__c+CaseObject.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c;
                    // Check Key2
                    key2=CaseObject.Material_Number__c+CaseObject.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c;
                    // check key3
                    key3=CaseObject.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c;
                    }
                    else
                    {
                         key1=CaseObject.Sales_Org_Code__c+CaseObject.Material_Number__c+CaseObject.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c+allPlants[i].MRP_Type__c;
                    // Check Key2
                    key2=CaseObject.Material_Number__c+CaseObject.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c+allPlants[i].MRP_Type__c;
                    // check key3
                    key3=CaseObject.Product_Hierarchy__r.PH5__c+allPlants[i].Plant_Code__c+allPlants[i].MRP_Type__c; 
                    }
                    if(mltmap.get(key1)!=null)
                    {
                        system.debug('Key 1 --> '+mltmap.get(key1));
                        mplval=mltmap.get(key1);
                        allPlants[i].Required_Lead_Time__c=mplval.Standard_Lead_Time__c;
                        system.debug('Key 1 Exception time set--> '+mplval.Standard_Lead_Time__c);
                    }
                    else if(mltmap.get(key2)!=null)
                    {
                        system.debug('Key 2 --> '+mltmap.get(key2));
                        mplval=mltmap.get(key2);
                        allPlants[i].Required_Lead_Time__c=mplval.Standard_Lead_Time__c;
                        system.debug('Key 2 Exception time set--> '+mplval.Standard_Lead_Time__c);
                    }
                    else if(mltmap.get(key3)!=null)
                    {
                        system.debug('Key 3 --> '+mltmap.get(key3));
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
        return allPlants;
    }
}
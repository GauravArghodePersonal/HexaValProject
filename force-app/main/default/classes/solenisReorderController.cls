public Without Sharing class solenisReorderController {
     @AuraEnabled    
    public static List<Open_Orders__c> OpenOrdersDetailv1(Id accId,string contType) {
        List<Open_Orders__c> oprd = New List<Open_Orders__c>();
        
        date lastthreemonth = date.today()-90;
     String query_openOrder='Select Id,Agreed_Ship_Date2__c,Line_Item_Number__c,Material_Desc__c,Material__c,Material__r.Material_Desc__c,Material__r.Material_General_Data__c,Material__r.Material_Number__c,Material__r.Sales_Org_Code__c,Material__r.Net_Weight_in_LBs__c,Material__r.Net_Weight__c,Name,Ordered_Qty_UOM__c,Ordered_Qty__c,Plant_Desc__c,Sales_Order_Number__c,Sales_UOM__c,ShipTo__c,ShipTo__r.Name,ShipTo__r.ShippingCity,ShipTo__r.ShippingCountry,ShipTo__r.ShippingPostalCode,ShipTo__r.ShippingState,ShipTo__r.ShippingStreet,SoldTo__c From Open_Orders__c where ShipTo__c = :accId  and Created_Date2__c >= :lastthreemonth';
           
          if(contType=='Standard Billing'){
             query_openOrder+=' AND Sales_Doc_Type__c=\'ZOR\'';
             }
              else{
                 query_openOrder+=' AND Sales_Doc_Type__c!=\'ZOR\'';
             }
             
            query_openOrder+= ' order by Created_Date2__c DESC limit 1000';
             system.debug('<<<query_openOrder>>>'+query_openOrder); 
           oprd= Database.query(query_openOrder);
        return oprd;
    }
    
    @AuraEnabled    
    public static List<Open_Orders__c> OpenOrdersDetail(Id accId) {
        List<Open_Orders__c> oprd = New List<Open_Orders__c>();
        oprd=[Select
                    Id,Agreed_Ship_Date2__c,Line_Item_Number__c,Material_Desc__c,Material__c,Material__r.Material_Desc__c,Material__r.Material_General_Data__c,Material__r.Material_Number__c,Material__r.Sales_Org_Code__c,Material__r.Net_Weight_in_LBs__c,Material__r.Net_Weight__c,Name,Ordered_Qty_UOM__c,Ordered_Qty__c,Plant_Desc__c,Sales_Order_Number__c,Sales_UOM__c,ShipTo__c,ShipTo__r.Name,ShipTo__r.ShippingCity,ShipTo__r.ShippingCountry,ShipTo__r.ShippingPostalCode,ShipTo__r.ShippingState,ShipTo__r.ShippingStreet,SoldTo__c
              From 
                    Open_Orders__c 
              where 
                    ShipTo__c = :accId  and Created_Date2__c >= :date.today() - 90
              order by 
                    Created_Date2__c 
              DESC limit 1000];
        return oprd;
    }
    
    @AuraEnabled    
    public static list<Account> AcconutDetail(List<string> OpOrdId) {
        list<account> oprd  = New list<account>();
        oprd=[Select
                    id,Name,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet
              From 
                    Account 
              where 
                    id in :OpOrdId];
                    System.debug('<<<OpOrdId>>>'+OpOrdId);
        return oprd;
    }
    @AuraEnabled 
    public static List<Material_Sales_Data2__c> querymaterial(String accountId,String SearchText){
       // List<MaterialWrapper> theseMaterials = New List<MaterialWrapper>();
        List<Material_Sales_Data2__c> materialresults = New List<Material_Sales_Data2__c>();
       
        String queryText = '%' + SearchText+ '%';
        //String accountId = ApexPages.currentPage().getParameters().get('accountId');
        Account soldToAccount;
        System.debug('<<<accountId>>>'+accountId);
        if(accountId != null && accountId != '')
        {
          //  theseMaterials = new List<MaterialWrapper>();
            soldToAccount = [Select a.SAP_Sales_Org__c, a.SAP_DistChannel__c, a.Id From Account a
                                    WHERE a.Id =: accountId];
        }        
       /* if(searchtext.contains('*'))
        {
            searchtext = searchtext.replace('*','');
        }*/
        system.debug('<<<soldToAccount >>>'+soldToAccount);
        if(soldToAccount != null)
        {
          materialresults = [Select Id, Name, SalesOrg_Desc__c, Material_Number__c, Material_Desc__c, DistChannel_Desc__c 
                    From Material_Sales_Data2__c where (Sales_Org_Code__c =: soldToAccount.SAP_Sales_Org__c)
                              AND (Dist_Channel_Code__c =: soldToAccount.SAP_DistChannel__c)
                              AND Material_Number__c like :queryText ];
        }
        if(materialresults != null)
        {
       //   for(Material_Sales_Data2__c thisMat : materialresults)
        //  {
          //  MaterialWrapper mw = new MaterialWrapper(thisMat);
           // theseMaterials.add(mw);
           //}
          if(materialresults.size()>0)
          {
              //renderResultSets = true;
             // hasResults = true;
          }
          else
          {
             // renderResultSets = true;
            //  hasResults = false;
          }
        }
        System.Debug('<<<materialresults >>>>'+materialresults );
        return materialresults ;
        //test
        /*rtrtrt*/
    }
    @AuraEnabled     
    public static  list<Material_Sales_Data2__c> querymaterialwithAPI(String accountId,String searchtext,String soldToId){
       system.debug('<<accountId>>'+accountId);
       system.debug('<<searchtext13>>'+searchtext);
       system.debug('<<soldToId>>'+soldToId);
       List<Material_Sales_Data2__c> materialresults = New List<Material_Sales_Data2__c>();
       List<MaterialWrapper> theseMaterials = New List<MaterialWrapper>();
        List<Pricing_Material__c> pricedresults = New List<Pricing_Material__c>();
        List<Pricing_Material__c> pricedresultsBC= New List<Pricing_Material__c>();
        Boolean renderResultSets;
        Boolean hasResults;
        String firstquerytext='';
        materialresults=null;
                    
        //New Search Logic Start
        system.debug('INside '+searchtext);
    //   String checklength=searchtext.replaceAll('\\*','');
    //    system.debug('checklength '+checklength);
        boolean isNumCheck=searchtext.isNumeric();
        system.debug('Validation Count check-- Search text '+searchtext);
        system.debug('Validation Count check-- isNumCheck '+isNumCheck);
        if(searchtext.length()>=3)
        {
            String queryText='';
             queryText = '%'+searchtext + '%';
            firstquerytext=searchtext + '%';
          /*  if(searchtext.contains('*'))
            {
                system.debug('Inside1'+searchtext);
               queryText=searchtext.replaceAll('\\*', '%'); 
            }
            else
            {
                system.debug('Inside2'+searchtext);
               queryText=searchtext.leftPad(18,'0'); 
            }*/
         
        system.debug('Searchtext before '+searchtext);
       system.debug(searchtext.length());
           Integer lenthval=0;
           searchtext = searchtext.leftPad(18,'0');
        system.debug('Searchtext After '+searchtext);
        
        //Code change for Material search 14/7/2020
        
        Account soldToAccount;
        Account shipToAccount;
        // Fields to get from the Account 
        // 1.   Ship to Account id - Account
        //2.    Customer Number - Account
        //3.    Sale org - Account
        //4.    Price list - Account
        //5.    Base code - Material Material_Base_Code__c 
        //6.    Sold id
        String shiptokey;
        String soldtoKey;
        String priceListkey;
            String region;
                String shiptokeyCustomer;
        String soldtoKeyCustomer;
        String priceListkeyCustomer;
        //Ship to Account details
        system.debug('Ship to account'+accountId);
        system.debug('Sold to account'+soldToId);
            system.debug('Inside SHip to');
           if(accountId != null && accountId != '')
        {
            theseMaterials = new List<MaterialWrapper>();
        }
        if(accountId!=null && accountId!=''&&soldToId!=null && soldToId!='' && accountId==soldToId)
        {
            system.debug('Sold to and ship id are same');
               shipToAccount = [Select a.SAP_Customer_Number__c,a.SAP_Sales_Org_Region_value__c,a.SAP_Sales_Org__c,a.SAP_Price_List_Type__c,a.SAP_DistChannel__c, a.Id From Account a
                                    WHERE a.Id =: accountId];
            shiptokey=shipToAccount.SAP_Customer_Number__c+shipToAccount.SAP_Sales_Org__c+searchtext;
            shiptokeyCustomer=shipToAccount.SAP_Customer_Number__c+shipToAccount.SAP_Sales_Org__c;
            soldtoKey=shiptokey;
            region=shipToAccount.SAP_Sales_Org_Region_value__c;
            soldtoKeyCustomer=shiptokeyCustomer;
            priceListkey=shipToAccount.SAP_Price_List_Type__c+shipToAccount.SAP_Sales_Org__c;
            system.debug('Inside SHip to Same'+shiptoKeyCustomer+' test '+priceListkey);
        }
        else{
        if(accountId != null && accountId != '')
        {
        
            shipToAccount = [Select a.SAP_Customer_Number__c,a.SAP_Sales_Org_Region_value__c,a.SAP_Sales_Org__c,a.SAP_Price_List_Type__c,a.SAP_DistChannel__c, a.Id From Account a
                                    WHERE a.Id =: accountId];
            shiptokey=shipToAccount.SAP_Customer_Number__c+shipToAccount.SAP_Sales_Org__c+searchtext;
            shiptoKeyCustomer=shipToAccount.SAP_Customer_Number__c+shipToAccount.SAP_Sales_Org__c;
            priceListkey=shipToAccount.SAP_Price_List_Type__c+shipToAccount.SAP_Sales_Org__c;
            region=shipToAccount.SAP_Sales_Org_Region_value__c;
            system.debug('Inside SHip to'+shiptoKeyCustomer+' test '+priceListkey);
        }
        //Sold to Account details           
        if(soldToId!=null && soldToId!='')
        {
            system.debug('Inside SOld to account ');
            soldToAccount=[Select a.SAP_Customer_Number__c,a.SAP_Sales_Org_Region_value__c,a.SAP_Sales_Org__c,a.SAP_Price_List_Type__c,a.SAP_DistChannel__c, a.Id From Account a
                                    WHERE a.Id =: soldToId];
            soldtoKey=soldToAccount.SAP_Customer_Number__c+soldToAccount.SAP_Sales_Org__c+searchtext;
            soldtoKeyCustomer=soldToAccount.SAP_Customer_Number__c+soldToAccount.SAP_Sales_Org__c;
            system.debug('Inside sold to '+soldtoKeyCustomer + 'Test '+ soldToAccount);
        }
        }
        //Check if no material found then we need to pull all valid material for the ship to and sold to customer
        //
       
                system.debug(' we need to Pull All the valid Material');
                  system.debug('INSIde No Data found ');
    if(isNumCheck)
    {
            pricedresults=[select Id,Pricing_Table__c,QueryKey__c,CustomerSalesOrg__c,BaseCode__c,Material_Number__c,Sales_Org_Code__c from Pricing_Material__c where CustomerSalesOrg__c IN(:soldtoKeyCustomer, :shiptokeyCustomer) and Material_Number__c like :queryText];
    system.debug('select Id,Pricing_Table__c,QueryKey__c,CustomerSalesOrg__c,BaseCode__c,Material_Number__c,Sales_Org_Code__c from Pricing_Material__c where CustomerSalesOrg__c IN(:'+soldtoKeyCustomer+', :'+shiptokeyCustomer+') and Material_Number__c like :'+queryText+'');
    }else{
    pricedresults=[select Id,Pricing_Table__c,QueryKey__c,CustomerSalesOrg__c,BaseCode__c,Material_Number__c,Sales_Org_Code__c from Pricing_Material__c where CustomerSalesOrg__c IN(:soldtoKeyCustomer, :shiptokeyCustomer) and  Is_Valid__c=true];
    system.debug('select Id,Pricing_Table__c,QueryKey__c,CustomerSalesOrg__c,BaseCode__c,Material_Number__c,Sales_Org_Code__c from Pricing_Material__c where CustomerSalesOrg__c IN(:'+soldtoKeyCustomer+', :'+shiptokeyCustomer+') and Is_Valid__c=true');
 }
            //ONly Numeric
            /* 
 pricedresults=[select Id,Pricing_Table__c,QueryKey__c,CustomerSalesOrg__c,BaseCode__c,Material_Number__c,Sales_Org_Code__c from Pricing_Material__c where CustomerSalesOrg__c IN(:soldtoKeyCustomer, :shiptokeyCustomer) and Material_Number__c like :queryText and  Is_Valid__c=true];
    system.debug('select Id,Pricing_Table__c,QueryKey__c,CustomerSalesOrg__c,BaseCode__c,Material_Number__c,Sales_Org_Code__c from Pricing_Material__c where CustomerSalesOrg__c IN(:'+soldtoKeyCustomer+', :'+shiptokeyCustomer+') and Material_Number__c like :'+queryText+' and Is_Valid__c=true');
*/
        system.debug('soldtoKeyCustomer'+soldtoKeyCustomer);
        system.debug('shiptokeyCustomer'+shiptokeyCustomer);
        system.debug('priceListkey'+priceListkey);
        system.debug('priceListkey');
        System.debug(priceListkey);
        system.debug('Validation Count check-- pricedresults'+pricedresults.size());
       // system.debug('pricedresults select Id,Pricing_Table__c,QueryKey__c,BaseCode__c,Material_Number__c,Sales_Org_Code__c from Pricing_Material__c where CustomerSalesOrg__c IN(:'+soldtoKeyCustomer+', :'+shiptokeyCustomer+') or QuerykeyPrice__c In(:'+priceListkey+')');
     
            //Check price list if the region is NA
      system.debug('Validation Count check-- Account Region '+region);
      if(region!=null&&region=='NA')
      {
      pricedresultsBC=[select Id,Pricing_Table__c,QueryKey__c,CustomerSalesOrg__c,BaseCode__c,Material_Number__c,Sales_Org_Code__c from Pricing_Material__c where QuerykeyPrice__c In(:priceListkey) and Is_Valid__c=true];
      system.debug('select Id,Pricing_Table__c,QueryKey__c,CustomerSalesOrg__c,BaseCode__c,Material_Number__c,Sales_Org_Code__c from Pricing_Material__c where QuerykeyPrice__c In(:'+priceListkey+') and Is_Valid__c=true');
      system.debug('Validation Count check-- pricedresults_Basecode'+pricedresultsBC.size());
       pricedresults.addAll(pricedresultsBC);
      }
         system.debug('Validation Count check TOTAL-- pricedresults_Basecode'+pricedresults.size());
        if(pricedresults.size()>=1 &&pricedresults!=null)
        {
        Map<String,List<String>> pricingresult=new Map<String,List<String>>();
        List<Pricing_Material__c> shiptoprice=new List<Pricing_Material__c>();
         List<String> shiptopricematerials=new List<String>();
        List<Pricing_Material__c> soldtoprice=new List<Pricing_Material__c>();
        List<String> soldtopricematerials=new List<String>();
        List<Pricing_Material__c> basecodeprice =new List<Pricing_Material__c>();
        List<String> basecodepricematerials=new List<String>();
        for(Pricing_Material__c prlst:pricedresults)
        {
            if(prlst.Pricing_Table__c=='640'|| prlst.Pricing_Table__c=='968' || prlst.Pricing_Table__c=='564'|| prlst.Pricing_Table__c=='541')
            {
                system.debug('before Error'+prlst);
                shiptoprice.add(prlst);
                shiptopricematerials.add(prlst.Material_Number__c);
            }
             if(prlst.Pricing_Table__c=='641'|| prlst.Pricing_Table__c=='969' || prlst.Pricing_Table__c=='565'|| prlst.Pricing_Table__c=='538')
            {
                soldtoprice.add(prlst);
                soldtopricematerials.add(prlst.Material_Number__c);
                //shipto will  contain both shipto and sold to
                shiptopricematerials.add(prlst.Material_Number__c);
            }
              if(region!=null&&region=='NA')
      {
            if(prlst.Pricing_Table__c=='962')
            {
                basecodeprice.add(prlst);
                basecodepricematerials.add(prlst.BaseCode__c);
            }
      }
            
        }
                  system.debug('Validation Count check-- Ship to--> '+shiptopricematerials.size());
            system.debug('Validation Count check-- Sold to--> '+soldtopricematerials.size());
             system.debug('Validation Count check-- Base Code --> '+basecodepricematerials.size());
            system.debug('basecodepricematerials '+basecodepricematerials);
                 system.debug('soldtopricematerials '+soldtopricematerials);
                   system.debug('shiptopricematerials '+shiptopricematerials);
            //Add the material Number which we searched
          /*   materialresults = [Select Id, Name, SalesOrg_Desc__c, Material_Number__c, Material_Desc__c, DistChannel_Desc__c 
                                From Material_Sales_Data2__c where 
                                 (Sales_Org_Code__c =: shipToAccount.SAP_Sales_Org__c)
                                AND (Dist_Channel_Code__c =: shipToAccount.SAP_DistChannel__c)
                                 AND  (Material_Number__c in :soldtopricematerials or Material_Number__c in :shiptopricematerials or Material_Base_Code__c in :basecodepricematerials) 
                                AND  (Material_Number__c like:queryText)
                                AND  (NOT Name  like '%DO NOT USE%')
                                AND (DistChan_MatStat_Code__c !='ZO')
                                AND (Active_Material__c ='Y')                                                                  
                                order by Name desc LIMIT 1000];*/
            //Add material based on text
            system.debug('INside Num0 Check'+queryText);
             system.debug('INside Num0 Check'+isNumCheck);
            if(isNumCheck)
    {
        if(!firstquerytext.equals('000%'))
        {
        system.debug('INside Num Check'+queryText);
           materialresults = [Select Id, Name, SalesOrg_Desc__c, Material_Number__c, Material_Desc__c, DistChannel_Desc__c 
                                From Material_Sales_Data2__c where 
                                 (Sales_Org_Code__c =: shipToAccount.SAP_Sales_Org__c)
                                AND (Dist_Channel_Code__c =: shipToAccount.SAP_DistChannel__c)
                                 AND  (Material_Number__c in :soldtopricematerials or Material_Number__c in :shiptopricematerials or Material_Base_Code__c in :basecodepricematerials) 
                                AND  (Material_Number_Trimmed__c like:firstquerytext)
                                AND  (NOT Name  like '%DO NOT USE%')
                                AND (DistChan_MatStat_Code__c !='ZO')
                                AND (Active_Material__c ='Y')                                                                  
                                order by Name desc LIMIT 1000];
        }
        else
        {
             system.debug('INside 000'+queryText);
           materialresults = [Select Id, Name, SalesOrg_Desc__c, Material_Number__c, Material_Desc__c, DistChannel_Desc__c 
                                From Material_Sales_Data2__c where 
                                 (Sales_Org_Code__c =: shipToAccount.SAP_Sales_Org__c)
                                AND (Dist_Channel_Code__c =: shipToAccount.SAP_DistChannel__c)
                                 AND  (Material_Number__c in :soldtopricematerials or Material_Number__c in :shiptopricematerials or Material_Base_Code__c in :basecodepricematerials) 
                                AND  (Material_Number__c like:firstquerytext)
                                AND  (NOT Name  like '%DO NOT USE%')
                                AND (DistChan_MatStat_Code__c !='ZO')
                                AND (Active_Material__c ='Y')                                                                  
                                order by Name desc LIMIT 1000];
        }
    }
            else
            {
               materialresults = [Select Id, Name, SalesOrg_Desc__c, Material_Number__c, Material_Desc__c, DistChannel_Desc__c 
                                From Material_Sales_Data2__c where 
                                 (Sales_Org_Code__c =: shipToAccount.SAP_Sales_Org__c)
                                AND (Dist_Channel_Code__c =: shipToAccount.SAP_DistChannel__c)
                                 AND  (Material_Number__c in :soldtopricematerials or Material_Number__c in :shiptopricematerials or Material_Base_Code__c in :basecodepricematerials) 
                                AND  (Name like:queryText)
                                AND  (NOT Name  like '%DO NOT USE%')
                                AND (DistChan_MatStat_Code__c !='ZO')
                                AND (Active_Material__c ='Y')                                                                  
                                order by Name ];  
            }
         system.debug('Select Id, Name, SalesOrg_Desc__c, Material_Number__c, Material_Desc__c, DistChannel_Desc__c From Material_Sales_Data2__c where (Sales_Org_Code__c ='+ shipToAccount.SAP_Sales_Org__c+')');
          system.debug('AND (Dist_Channel_Code__c ='+ shipToAccount.SAP_DistChannel__c+')AND  (Material_Number__c in '+soldtopricematerials+' or Material_Number__c in '+shiptopricematerials+' or Material_Base_Code__c in '+basecodepricematerials+')');
            system.debug('AND  (Material_Number__c like'+queryText+')AND  (NOT Name  like %DO NOT USE% AND (DistChan_MatStat_Code__c !=ZO) AND (Active_Material__c =Y) order by Name desc LIMIT 1000');            
            system.debug('After material result'+materialresults.isEmpty());
               system.debug('Validation Count check Final Total-- pricedresults_Basecode'+materialresults.size());
            if(materialresults.isEmpty())
            {
         //  Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, 'No Valid priced Material for this customer'));
            }
            else
            {
             //   Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, 'Below the Valid Materials for the Customer'));
            }
            }
      
        if(materialresults != null)
        {
            for(Material_Sales_Data2__c thisMat : materialresults)
            {
                MaterialWrapper mw = new MaterialWrapper(thisMat);
                system.debug(materialresults.size());
                system.debug('thisMat '+thisMat);
                theseMaterials.add(mw);
            }
            system.debug('materialresults.size()'+materialresults.size());
            if(materialresults.size()>0)
            {
                renderResultSets = true;
                hasResults = true;
            }
            else
            {           
                renderResultSets = true;
                hasResults = false;
            }
        }}
        else
        {
            theseMaterials=null;
            renderResultSets = true;
                hasResults = false; 
           //  Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, 'Kindly enter atleast 3 digits, * to include wildcard search'));
        }

        
        //New Search Logic ends
            System.debug('<<materialresults>>'+materialresults );
            return materialresults ;
        }
            @AuraEnabled     
    public static  list<Material_Sales_Data2__c> querymaterialwithAPIv1(String accountId,String searchtext,String soldToId,Integer limitSize, Integer offset){
       system.debug('<<accountId>>'+accountId);
       system.debug('<<searchtext13>>'+searchtext);
       system.debug('<<soldToId>>'+soldToId);
       List<Material_Sales_Data2__c> materialresults = New List<Material_Sales_Data2__c>();
       List<MaterialWrapper> theseMaterials = New List<MaterialWrapper>();
        List<Pricing_Material__c> pricedresults = New List<Pricing_Material__c>();
        List<Pricing_Material__c> pricedresultsBC= New List<Pricing_Material__c>();
        Boolean renderResultSets;
        Boolean hasResults;
        String firstquerytext='';
        materialresults=null;
                    
        //New Search Logic Start
        system.debug('INside '+searchtext);
    //   String checklength=searchtext.replaceAll('\\*','');
    //    system.debug('checklength '+checklength);
        boolean isNumCheck=searchtext.isNumeric();
        system.debug('Validation Count check-- Search text '+searchtext);
        system.debug('Validation Count check-- isNumCheck '+isNumCheck);
        if(searchtext.length()>=3)
        {
            String queryText='';
             queryText = '%'+searchtext + '%';
            firstquerytext=searchtext + '%';
          /*  if(searchtext.contains('*'))
            {
                system.debug('Inside1'+searchtext);
               queryText=searchtext.replaceAll('\\*', '%'); 
            }
            else
            {
                system.debug('Inside2'+searchtext);
               queryText=searchtext.leftPad(18,'0'); 
            }*/
         
        system.debug('Searchtext before '+searchtext);
       system.debug(searchtext.length());
           Integer lenthval=0;
           searchtext = searchtext.leftPad(18,'0');
        system.debug('Searchtext After '+searchtext);
        
        //Code change for Material search 14/7/2020
        
        Account soldToAccount;
        Account shipToAccount;
        // Fields to get from the Account 
        // 1.   Ship to Account id - Account
        //2.    Customer Number - Account
        //3.    Sale org - Account
        //4.    Price list - Account
        //5.    Base code - Material Material_Base_Code__c 
        //6.    Sold id
        String shiptokey;
        String soldtoKey;
        String priceListkey;
            String region;
                String shiptokeyCustomer;
        String soldtoKeyCustomer;
        String priceListkeyCustomer;
        //Ship to Account details
        system.debug('Ship to account'+accountId);
        system.debug('Sold to account'+soldToId);
            system.debug('Inside SHip to');
           if(accountId != null && accountId != '')
        {
            theseMaterials = new List<MaterialWrapper>();
        }
        if(accountId!=null && accountId!=''&&soldToId!=null && soldToId!='' && accountId==soldToId)
        {
            system.debug('Sold to and ship id are same');
               shipToAccount = [Select a.SAP_Customer_Number__c,a.SAP_Sales_Org_Region_value__c,a.SAP_Sales_Org__c,a.SAP_Price_List_Type__c,a.SAP_DistChannel__c, a.Id From Account a
                                    WHERE a.Id =: accountId];
            shiptokey=shipToAccount.SAP_Customer_Number__c+shipToAccount.SAP_Sales_Org__c+searchtext;
            shiptokeyCustomer=shipToAccount.SAP_Customer_Number__c+shipToAccount.SAP_Sales_Org__c;
            soldtoKey=shiptokey;
            region=shipToAccount.SAP_Sales_Org_Region_value__c;
            soldtoKeyCustomer=shiptokeyCustomer;
            priceListkey=shipToAccount.SAP_Price_List_Type__c+shipToAccount.SAP_Sales_Org__c;
            system.debug('Inside SHip to Same'+shiptoKeyCustomer+' test '+priceListkey);
        }
        else{
        if(accountId != null && accountId != '')
        {
        
            shipToAccount = [Select a.SAP_Customer_Number__c,a.SAP_Sales_Org_Region_value__c,a.SAP_Sales_Org__c,a.SAP_Price_List_Type__c,a.SAP_DistChannel__c, a.Id From Account a
                                    WHERE a.Id =: accountId];
            shiptokey=shipToAccount.SAP_Customer_Number__c+shipToAccount.SAP_Sales_Org__c+searchtext;
            shiptoKeyCustomer=shipToAccount.SAP_Customer_Number__c+shipToAccount.SAP_Sales_Org__c;
            priceListkey=shipToAccount.SAP_Price_List_Type__c+shipToAccount.SAP_Sales_Org__c;
            region=shipToAccount.SAP_Sales_Org_Region_value__c;
            system.debug('Inside SHip to'+shiptoKeyCustomer+' test '+priceListkey);
        }
        //Sold to Account details           
        if(soldToId!=null && soldToId!='')
        {
            system.debug('Inside SOld to account ');
            soldToAccount=[Select a.SAP_Customer_Number__c,a.SAP_Sales_Org_Region_value__c,a.SAP_Sales_Org__c,a.SAP_Price_List_Type__c,a.SAP_DistChannel__c, a.Id From Account a
                                    WHERE a.Id =: soldToId];
            soldtoKey=soldToAccount.SAP_Customer_Number__c+soldToAccount.SAP_Sales_Org__c+searchtext;
            soldtoKeyCustomer=soldToAccount.SAP_Customer_Number__c+soldToAccount.SAP_Sales_Org__c;
            system.debug('Inside sold to '+soldtoKeyCustomer + 'Test '+ soldToAccount);
        }
        }
        //Check if no material found then we need to pull all valid material for the ship to and sold to customer
        //
       
                system.debug(' we need to Pull All the valid Material');
                  system.debug('INSIde No Data found ');
    if(isNumCheck)
    {
            pricedresults=[select Id,Pricing_Table__c,QueryKey__c,CustomerSalesOrg__c,BaseCode__c,Material_Number__c,Sales_Org_Code__c from Pricing_Material__c where CustomerSalesOrg__c IN(:soldtoKeyCustomer, :shiptokeyCustomer) and Material_Number__c like :queryText];
    system.debug('select Id,Pricing_Table__c,QueryKey__c,CustomerSalesOrg__c,BaseCode__c,Material_Number__c,Sales_Org_Code__c from Pricing_Material__c where CustomerSalesOrg__c IN(:'+soldtoKeyCustomer+', :'+shiptokeyCustomer+') and Material_Number__c like :'+queryText+'');
    }else{
    pricedresults=[select Id,Pricing_Table__c,QueryKey__c,CustomerSalesOrg__c,BaseCode__c,Material_Number__c,Sales_Org_Code__c from Pricing_Material__c where CustomerSalesOrg__c IN(:soldtoKeyCustomer, :shiptokeyCustomer) and  Is_Valid__c=true];
    system.debug('select Id,Pricing_Table__c,QueryKey__c,CustomerSalesOrg__c,BaseCode__c,Material_Number__c,Sales_Org_Code__c from Pricing_Material__c where CustomerSalesOrg__c IN(:'+soldtoKeyCustomer+', :'+shiptokeyCustomer+') and Is_Valid__c=true');
 }
            //ONly Numeric
            /* 
 pricedresults=[select Id,Pricing_Table__c,QueryKey__c,CustomerSalesOrg__c,BaseCode__c,Material_Number__c,Sales_Org_Code__c from Pricing_Material__c where CustomerSalesOrg__c IN(:soldtoKeyCustomer, :shiptokeyCustomer) and Material_Number__c like :queryText and  Is_Valid__c=true];
    system.debug('select Id,Pricing_Table__c,QueryKey__c,CustomerSalesOrg__c,BaseCode__c,Material_Number__c,Sales_Org_Code__c from Pricing_Material__c where CustomerSalesOrg__c IN(:'+soldtoKeyCustomer+', :'+shiptokeyCustomer+') and Material_Number__c like :'+queryText+' and Is_Valid__c=true');
*/
        system.debug('soldtoKeyCustomer'+soldtoKeyCustomer);
        system.debug('shiptokeyCustomer'+shiptokeyCustomer);
        system.debug('priceListkey'+priceListkey);
        system.debug('priceListkey');
        System.debug(priceListkey);
        system.debug('Validation Count check-- pricedresults'+pricedresults.size());
       // system.debug('pricedresults select Id,Pricing_Table__c,QueryKey__c,BaseCode__c,Material_Number__c,Sales_Org_Code__c from Pricing_Material__c where CustomerSalesOrg__c IN(:'+soldtoKeyCustomer+', :'+shiptokeyCustomer+') or QuerykeyPrice__c In(:'+priceListkey+')');
     
            //Check price list if the region is NA
      system.debug('Validation Count check-- Account Region '+region);
      if(region!=null&&region=='NA')
      {
      pricedresultsBC=[select Id,Pricing_Table__c,QueryKey__c,CustomerSalesOrg__c,BaseCode__c,Material_Number__c,Sales_Org_Code__c from Pricing_Material__c where QuerykeyPrice__c In(:priceListkey) and Is_Valid__c=true];
      system.debug('select Id,Pricing_Table__c,QueryKey__c,CustomerSalesOrg__c,BaseCode__c,Material_Number__c,Sales_Org_Code__c from Pricing_Material__c where QuerykeyPrice__c In(:'+priceListkey+') and Is_Valid__c=true');
      system.debug('Validation Count check-- pricedresults_Basecode'+pricedresultsBC.size());
       pricedresults.addAll(pricedresultsBC);
      }
         system.debug('Validation Count check TOTAL-- pricedresults_Basecode'+pricedresults.size());
        if(pricedresults.size()>=1 &&pricedresults!=null)
        {
        Map<String,List<String>> pricingresult=new Map<String,List<String>>();
        List<Pricing_Material__c> shiptoprice=new List<Pricing_Material__c>();
         List<String> shiptopricematerials=new List<String>();
        List<Pricing_Material__c> soldtoprice=new List<Pricing_Material__c>();
        List<String> soldtopricematerials=new List<String>();
        List<Pricing_Material__c> basecodeprice =new List<Pricing_Material__c>();
        List<String> basecodepricematerials=new List<String>();
        for(Pricing_Material__c prlst:pricedresults)
        {
            if(prlst.Pricing_Table__c=='640'|| prlst.Pricing_Table__c=='968' || prlst.Pricing_Table__c=='564')
            {
                system.debug('before Error'+prlst);
                shiptoprice.add(prlst);
                shiptopricematerials.add(prlst.Material_Number__c);
            }
             if(prlst.Pricing_Table__c=='641'|| prlst.Pricing_Table__c=='969' || prlst.Pricing_Table__c=='565')
            {
                soldtoprice.add(prlst);
                soldtopricematerials.add(prlst.Material_Number__c);
                //shipto will  contain both shipto and sold to
                shiptopricematerials.add(prlst.Material_Number__c);
            }
              if(region!=null&&region=='NA')
      {
            if(prlst.Pricing_Table__c=='962')
            {
                basecodeprice.add(prlst);
                basecodepricematerials.add(prlst.BaseCode__c);
            }
      }
            
        }
                  system.debug('Validation Count check-- Ship to--> '+shiptopricematerials.size());
            system.debug('Validation Count check-- Sold to--> '+soldtopricematerials.size());
             system.debug('Validation Count check-- Base Code --> '+basecodepricematerials.size());
            system.debug('basecodepricematerials '+basecodepricematerials);
                 system.debug('soldtopricematerials '+soldtopricematerials);
                   system.debug('shiptopricematerials '+shiptopricematerials);
            //Add the material Number which we searched
          /*   materialresults = [Select Id, Name, SalesOrg_Desc__c, Material_Number__c, Material_Desc__c, DistChannel_Desc__c 
                                From Material_Sales_Data2__c where 
                                 (Sales_Org_Code__c =: shipToAccount.SAP_Sales_Org__c)
                                AND (Dist_Channel_Code__c =: shipToAccount.SAP_DistChannel__c)
                                 AND  (Material_Number__c in :soldtopricematerials or Material_Number__c in :shiptopricematerials or Material_Base_Code__c in :basecodepricematerials) 
                                AND  (Material_Number__c like:queryText)
                                AND  (NOT Name  like '%DO NOT USE%')
                                AND (DistChan_MatStat_Code__c !='ZO')
                                AND (Active_Material__c ='Y')                                                                  
                                order by Name desc LIMIT 1000];*/
            //Add material based on text
            system.debug('INside Num0 Check'+queryText);
              system.debug('INside Num0 Check firstquerytext'+firstquerytext);
             system.debug('INside Num0 Check'+isNumCheck);
            if(isNumCheck)
    {
        if(!firstquerytext.equals('000%'))
        {
        system.debug('INside Num Check'+queryText);
        
           materialresults = [Select Id, Name, SalesOrg_Desc__c, Material_Number__c, Material_Desc__c, DistChannel_Desc__c 
                                From Material_Sales_Data2__c where 
                                 (Sales_Org_Code__c =: shipToAccount.SAP_Sales_Org__c)
                                AND (Dist_Channel_Code__c =: shipToAccount.SAP_DistChannel__c)
                                 AND  (Material_Number__c in :soldtopricematerials or Material_Number__c in :shiptopricematerials or Material_Base_Code__c in :basecodepricematerials) 
                                AND  (Material_Number_Trimmed__c like:firstquerytext)
                                AND  (NOT Name  like '%DO NOT USE%')
                                AND (DistChan_MatStat_Code__c !='ZO')
                                AND (Active_Material__c ='Y')                                                                  
                                order by Name desc 
                                LIMIT :offset];
        }
        else
        {
             system.debug('INside 000'+queryText);
             system.debug('INside 000 limitSize'+limitSize);
        system.debug('INside 000 offset'+offset);
           materialresults = [Select Id, Name, SalesOrg_Desc__c, Material_Number__c, Material_Desc__c, DistChannel_Desc__c 
                                From Material_Sales_Data2__c where 
                                 (Sales_Org_Code__c =: shipToAccount.SAP_Sales_Org__c)
                                AND (Dist_Channel_Code__c =: shipToAccount.SAP_DistChannel__c)
                                 AND  (Material_Number__c in :soldtopricematerials or Material_Number__c in :shiptopricematerials or Material_Base_Code__c in :basecodepricematerials) 
                                AND  (Material_Number__c like:firstquerytext)
                                AND  (NOT Name  like '%DO NOT USE%')
                                AND (DistChan_MatStat_Code__c !='ZO')
                                AND (Active_Material__c ='Y')                                                                  
                                order by Name desc 
                                LIMIT :offset];
        }
    }
            else
            {
               materialresults = [Select Id, Name, SalesOrg_Desc__c, Material_Number__c, Material_Desc__c, DistChannel_Desc__c 
                                From Material_Sales_Data2__c where 
                                 (Sales_Org_Code__c =: shipToAccount.SAP_Sales_Org__c)
                                AND (Dist_Channel_Code__c =: shipToAccount.SAP_DistChannel__c)
                                 AND  (Material_Number__c in :soldtopricematerials or Material_Number__c in :shiptopricematerials or Material_Base_Code__c in :basecodepricematerials) 
                                AND  (Name like:queryText)
                                AND  (NOT Name  like '%DO NOT USE%')
                                AND (DistChan_MatStat_Code__c !='ZO')
                                AND (Active_Material__c ='Y')                                                                  
                                order by Name 
                                LIMIT :offset];  
            }
         system.debug('Select Id, Name, SalesOrg_Desc__c, Material_Number__c, Material_Desc__c, DistChannel_Desc__c From Material_Sales_Data2__c where (Sales_Org_Code__c ='+ shipToAccount.SAP_Sales_Org__c+')');
          system.debug('AND (Dist_Channel_Code__c ='+ shipToAccount.SAP_DistChannel__c+')AND  (Material_Number__c in '+soldtopricematerials+' or Material_Number__c in '+shiptopricematerials+' or Material_Base_Code__c in '+basecodepricematerials+')');
            system.debug('AND  (Material_Number__c like'+queryText+')AND  (NOT Name  like %DO NOT USE% AND (DistChan_MatStat_Code__c !=ZO) AND (Active_Material__c =Y) order by Name desc LIMIT 1000');            
            system.debug('After material result'+materialresults.isEmpty());
               system.debug('Validation Count check Final Total-- pricedresults_Basecode'+materialresults.size());
            if(materialresults.isEmpty())
            {
         //  Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, 'No Valid priced Material for this customer'));
            }
            else
            {
             //   Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, 'Below the Valid Materials for the Customer'));
            }
            }
      
        if(materialresults != null)
        {
            for(Material_Sales_Data2__c thisMat : materialresults)
            {
                MaterialWrapper mw = new MaterialWrapper(thisMat);
                system.debug(materialresults.size());
                system.debug('thisMat '+thisMat);
                theseMaterials.add(mw);
            }
            system.debug('materialresults.size()'+materialresults.size());
            if(materialresults.size()>0)
            {
                renderResultSets = true;
                hasResults = true;
            }
            else
            {           
                renderResultSets = true;
                hasResults = false;
            }
        }}
        else
        {
            theseMaterials=null;
            renderResultSets = true;
                hasResults = false; 
           //  Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, 'Kindly enter atleast 3 digits, * to include wildcard search'));
        }

        
        //New Search Logic ends
            System.debug('<<materialresults>>'+materialresults );
            return materialresults ;
        }
     @AuraEnabled
     public static  list<Material_Sales_Data2__c> querymaterialwithAPI_All(String accountId,String searchtext,String soldToId){
       system.debug('<<accountId>>'+accountId);
       system.debug('<<searchtext12>>'+searchtext);
       system.debug('<<soldToId>>'+soldToId);
       List<Material_Sales_Data2__c> materialresults = New List<Material_Sales_Data2__c>();
       List<MaterialWrapper> theseMaterials = New List<MaterialWrapper>();
        List<Pricing_Material__c> pricedresults = New List<Pricing_Material__c>();
        List<Pricing_Material__c> pricedresultsBC= New List<Pricing_Material__c>();
        Boolean renderResultSets;
        Boolean hasResults;
        String firstquerytext='';
        materialresults=null;     
        //New Search Logic Start
        system.debug('INside '+searchtext);
    //   String checklength=searchtext.replaceAll('\\*','');
    //    system.debug('checklength '+checklength);
        boolean isNumCheck=searchtext.isNumeric();
        system.debug('Validation Count check-- Search text '+searchtext);
        system.debug('Validation Count check-- isNumCheck '+isNumCheck);
        if(searchtext.length()>=3)
        {
            String queryText='';
             queryText = '%'+searchtext + '%';
            firstquerytext=searchtext + '%';
          /*  if(searchtext.contains('*'))
            {
                system.debug('Inside1'+searchtext);
               queryText=searchtext.replaceAll('\\*', '%'); 
            }
            else
            {
                system.debug('Inside2'+searchtext);
               queryText=searchtext.leftPad(18,'0'); 
            }*/  
        system.debug('Searchtext before '+searchtext);
       system.debug(searchtext.length());
           Integer lenthval=0;
           searchtext = searchtext.leftPad(18,'0');
        system.debug('Searchtext After '+searchtext);    
        //Code change for Material search 14/7/2020
        Account shipToAccount;
        // Fields to get from the Account 
        // 1.   Ship to Account id - Account
        //2.    Customer Number - Account
        //3.    Sale org - Account
        //4.    Price list - Account
        //5.    Base code - Material Material_Base_Code__c 
        //6.    Sold id   
            String region;

            system.debug('Inside SHip to');
           if(accountId != null && accountId != '')
        {
            theseMaterials = new List<MaterialWrapper>();
         
        
            shipToAccount = [Select a.SAP_Customer_Number__c,a.SAP_Sales_Org_Region_value__c,a.SAP_Sales_Org__c,a.SAP_Price_List_Type__c,a.SAP_DistChannel__c, a.Id From Account a
                                    WHERE a.Id =: accountId];
                 
        }        
            //Add the material Number which we searched
          /*   materialresults = [Select Id, Name, SalesOrg_Desc__c, Material_Number__c, Material_Desc__c, DistChannel_Desc__c 
                                From Material_Sales_Data2__c where 
                                 (Sales_Org_Code__c =: shipToAccount.SAP_Sales_Org__c)
                                AND (Dist_Channel_Code__c =: shipToAccount.SAP_DistChannel__c)
                                 AND  (Material_Number__c in :soldtopricematerials or Material_Number__c in :shiptopricematerials or Material_Base_Code__c in :basecodepricematerials) 
                                AND  (Material_Number__c like:queryText)
                                AND  (NOT Name  like '%DO NOT USE%')
                                AND (DistChan_MatStat_Code__c !='ZO')
                                AND (Active_Material__c ='Y')                                                                  
                                order by Name desc LIMIT 1000];*/
            //Add material based on text
            system.debug('INside Num0 Check'+queryText);
             system.debug('INside Num0 Check'+isNumCheck);
            if(isNumCheck)
    {
        if(!firstquerytext.equals('000%'))
        {
        system.debug('INside Num Check'+queryText);
           materialresults = [Select Id, Name, SalesOrg_Desc__c, Material_Number__c, Material_Desc__c, DistChannel_Desc__c 
                                From Material_Sales_Data2__c where 
                                 (Sales_Org_Code__c =: shipToAccount.SAP_Sales_Org__c)
                                AND (Dist_Channel_Code__c =: shipToAccount.SAP_DistChannel__c)
                                 
                                AND  (Material_Number_Trimmed__c like:firstquerytext)
                                AND  (NOT Name  like '%DO NOT USE%')
                                AND (DistChan_MatStat_Code__c !='ZO')
                                AND (Active_Material__c ='Y')                                                                  
                                order by Name desc LIMIT 1000];
        }
        else
        {
             system.debug('INside 000'+queryText);
           materialresults = [Select Id, Name, SalesOrg_Desc__c, Material_Number__c, Material_Desc__c, DistChannel_Desc__c 
                                From Material_Sales_Data2__c where 
                                 (Sales_Org_Code__c =: shipToAccount.SAP_Sales_Org__c)
                                AND (Dist_Channel_Code__c =: shipToAccount.SAP_DistChannel__c)                           
                                AND  (Material_Number__c like:firstquerytext)
                                AND  (NOT Name  like '%DO NOT USE%')
                                AND (DistChan_MatStat_Code__c !='ZO')
                                AND (Active_Material__c ='Y')                                                                  
                                order by Name desc LIMIT 1000];
        }
    }
            else
            {
               materialresults = [Select Id, Name, SalesOrg_Desc__c, Material_Number__c, Material_Desc__c, DistChannel_Desc__c 
                                From Material_Sales_Data2__c where 
                                 (Sales_Org_Code__c =: shipToAccount.SAP_Sales_Org__c)
                                AND (Dist_Channel_Code__c =: shipToAccount.SAP_DistChannel__c)
                                AND  (Name like:queryText)
                                AND  (NOT Name  like '%DO NOT USE%')
                                AND (DistChan_MatStat_Code__c !='ZO')
                                AND (Active_Material__c ='Y')                                                                  
                                order by Name desc LIMIT 1000];  
            }
        
               system.debug('Validation Count check Final Total-- pricedresults_Basecode'+materialresults.size());
            if(materialresults.isEmpty())
            {
         //  Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, 'No Valid priced Material for this customer'));
            }
            else
            {
             //   Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, 'Below the Valid Materials for the Customer'));
            }
            
      
        if(materialresults != null)
        {
            for(Material_Sales_Data2__c thisMat : materialresults)
            {
                MaterialWrapper mw = new MaterialWrapper(thisMat);
                system.debug(materialresults.size());
                system.debug('thisMat '+thisMat);
                theseMaterials.add(mw);
            }
            system.debug('materialresults.size()'+materialresults.size());
            if(materialresults.size()>0)
            {
                renderResultSets = true;
                hasResults = true;
            }
            else
            {           
                renderResultSets = true;
                hasResults = false;
            }
        }}
        else
        {
            theseMaterials=null;
            renderResultSets = true;
                hasResults = false; 
           //  Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, 'Kindly enter atleast 3 digits, * to include wildcard search'));
        }

        
        //New Search Logic ends
            System.debug('<<materialresults>>'+materialresults );
            return materialresults ;
        }
        //For Lazy Load
     @AuraEnabled
     public static  list<Material_Sales_Data2__c> querymaterialwithAPI_Allv1(String accountId,String searchtext,String soldToId,Integer limitSize, Integer offset){
       system.debug('<<accountId>>'+accountId);
       system.debug('<<searchtext>>'+searchtext);
       system.debug('<<soldToId>>'+soldToId);
        system.debug('<<limitSize>>'+limitSize);
        system.debug('<<offset>>'+offset);
       List<Material_Sales_Data2__c> materialresults = New List<Material_Sales_Data2__c>();
       List<MaterialWrapper> theseMaterials = New List<MaterialWrapper>();
        List<Pricing_Material__c> pricedresults = New List<Pricing_Material__c>();
        List<Pricing_Material__c> pricedresultsBC= New List<Pricing_Material__c>();
        Boolean renderResultSets;
        Boolean hasResults;
        String firstquerytext='';
        materialresults=null;     
        //New Search Logic Start
        system.debug('INside11 '+searchtext);
    //   String checklength=searchtext.replaceAll('\\*','');
    //    system.debug('checklength '+checklength);
        boolean isNumCheck=searchtext.isNumeric();
        system.debug('Validation Count check-- Search text '+searchtext);
        system.debug('Validation Count check-- isNumCheck '+isNumCheck);
        if(searchtext.length()>=3)
        {
            String queryText='';
             queryText = '%'+searchtext + '%';
            firstquerytext=searchtext + '%';
          
        system.debug('Searchtext before '+searchtext);
       system.debug(searchtext.length());
           Integer lenthval=0;
           searchtext = searchtext.leftPad(18,'0');
        system.debug('Searchtext After '+searchtext);    
        //Code change for Material search 14/7/2020
        Account shipToAccount;
        // Fields to get from the Account 
        // 1.   Ship to Account id - Account
        //2.    Customer Number - Account
        //3.    Sale org - Account
        //4.    Price list - Account
        //5.    Base code - Material Material_Base_Code__c 
        //6.    Sold id   
            String region;

            system.debug('Inside SHip to');
           if(accountId != null && accountId != '')
        {
            theseMaterials = new List<MaterialWrapper>();
         
        
            shipToAccount = [Select a.SAP_Customer_Number__c,a.SAP_Sales_Org_Region_value__c,a.SAP_Sales_Org__c,a.SAP_Price_List_Type__c,a.SAP_DistChannel__c, a.Id From Account a
                                    WHERE a.Id =: accountId 
                                    ];
                 
        }        
           
            //Add material based on text
            system.debug('INside Num0 Check'+queryText);
             system.debug('INside Num0 Check'+isNumCheck);
            if(isNumCheck)
    {
        if(!firstquerytext.equals('000%'))
        {
        system.debug('INside Num Check'+queryText);
           materialresults = [Select Id, Name, SalesOrg_Desc__c, Material_Number__c, Material_Desc__c, DistChannel_Desc__c 
                                From Material_Sales_Data2__c where 
                                 (Sales_Org_Code__c =: shipToAccount.SAP_Sales_Org__c)
                                AND (Dist_Channel_Code__c =: shipToAccount.SAP_DistChannel__c)
                                 
                                AND  (Material_Number_Trimmed__c like:firstquerytext)
                                AND  (NOT Name  like '%DO NOT USE%')
                                AND (DistChan_MatStat_Code__c !='ZO')
                                AND (Active_Material__c ='Y')                                                                  
                                order by Name desc 
                                LIMIT :offset
                                ];
        }
        else
        {
             system.debug('INside 000'+queryText);
           materialresults = [Select Id, Name, SalesOrg_Desc__c, Material_Number__c, Material_Desc__c, DistChannel_Desc__c 
                                From Material_Sales_Data2__c where 
                                 (Sales_Org_Code__c =: shipToAccount.SAP_Sales_Org__c)
                                AND (Dist_Channel_Code__c =: shipToAccount.SAP_DistChannel__c)                           
                                AND  (Material_Number__c like:firstquerytext)
                                AND  (NOT Name  like '%DO NOT USE%')
                                AND (DistChan_MatStat_Code__c !='ZO')
                                AND (Active_Material__c ='Y')                                                                  
                                order by Name desc 
                                LIMIT :offset
                               ];
        }
    }
            else
            {
               materialresults = [Select Id, Name, SalesOrg_Desc__c, Material_Number__c, Material_Desc__c, DistChannel_Desc__c 
                                From Material_Sales_Data2__c where 
                                 (Sales_Org_Code__c =: shipToAccount.SAP_Sales_Org__c)
                                AND (Dist_Channel_Code__c =: shipToAccount.SAP_DistChannel__c)
                                AND  (Name like:queryText)
                                AND  (NOT Name  like '%DO NOT USE%')
                                AND (DistChan_MatStat_Code__c !='ZO')
                                AND (Active_Material__c ='Y')                                                                  
                                order by Name desc 
                                LIMIT :offset
                                ];
            }
        
               system.debug('Validation Count check Final Total-- pricedresults_Basecode'+materialresults.size());
            if(materialresults.isEmpty())
            {
         //  Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, 'No Valid priced Material for this customer'));
            }
            else
            {
             //   Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, 'Below the Valid Materials for the Customer'));
            }
            
      
        if(materialresults != null)
        {
            for(Material_Sales_Data2__c thisMat : materialresults)
            {
                MaterialWrapper mw = new MaterialWrapper(thisMat);
                system.debug(materialresults.size());
                system.debug('thisMat '+thisMat);
                theseMaterials.add(mw);
            }
            system.debug('materialresults.size()'+materialresults.size());
            if(materialresults.size()>0)
            {
                renderResultSets = true;
                hasResults = true;
            }
            else
            {           
                renderResultSets = true;
                hasResults = false;
            }
        }}
        else
        {
            theseMaterials=null;
            renderResultSets = true;
                hasResults = false; 
           //  Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, 'Kindly enter atleast 3 digits, * to include wildcard search'));
        }

        
        //New Search Logic ends
            System.debug('<<materialresults>>'+materialresults.size() );
            return materialresults ;
        }
        
        
        @AuraEnabled
     public static  list<Customer_Product_Info__c> querymaterialfromCPI(String accountId,String searchtext,String soldToId,Integer limitSize, Integer offset){
     
     return null;
     }

    public with sharing class MaterialWrapper{
      public Material_Sales_Data2__c thisMaterial {get; set;}
      public String matNumber {get; set;}
      public materialWrapper(Material_Sales_Data2__c tempMat)
      {
        thisMaterial = tempMat;
        matNumber = String_Functions.removeLeadingZeros(tempMat.Material_Number__c);
      }
   }
   
   @AuraEnabled     
   public static  List<Open_Orders__c> getSelectedMaterial(List<string> msdId){
       System.debug('<<<msdId>>>'+msdId);
       List<Open_Orders__c> oprd = New List<Open_Orders__c>();
        oprd=[Select Id,Name,Material__c,Plant_Desc__c,Material__r.Material_Number__c
              From  Open_Orders__c 
              where 
                    id IN :msdId];
   
   System.debug('<<<oprd>>>'+oprd);
   
   return oprd;
   }
    @AuraEnabled 
   public static  list<PlantWrapper> materialPlantDetail(String msdId,string MatNum,String MatDesc){
    system.debug('<<<MatDesc>>>'+MatDesc);
   List<PlantWrapper> PlantwithMat = New list<PlantWrapper>();
    list<Material_Plant2__c> allPlants= New  list<Material_Plant2__c>();
    list<Material_Plant2__c> delPlantList = New  list<Material_Plant2__c>();
    integer count=0;
   // allPlants = Material_Sales_Data_Functions.getPlants(msdId); 
   Map<Id, List<Material_Plant2__c>> MP2 = getMatPlants2(msdId);
      system.debug('<<<ID VAL mp2map>>>'+MP2);
       system.debug('ID VAL msdId'+msdId);
      
       for(integer i=0;i<MP2.get(msdId).size();i++){
          // Material_Plant2__c matp = New Material_Plant2__c();
             //  matp=MP2.get(msdId)[i];      
           allPlants.add(MP2.get(msdId)[i]);
       }
    
       System.debug('<<<<PlantList>>>++'+allPlants);
    System.debug('<<<<PlantList>>>'+allPlants.size());
    if (allPlants!= null){
            for (Integer i = 0; i < allPlants.size(); i++)
            {
                 system.debug('Inside Sabari Test0'+ allPlants[i].Plant_Code__c);
              /*  if (allPlants[i].Plant_Code__c.equals('QM01')){
                    allPlants.remove(i); 
                    system.debug('Inside Sabari Test'+ allPlants[i].Plant_Code__c);
                    }*/
                if (allPlants[i].Plant_Code__c.equals('QM01') || allPlants[i].Deletion_Flag__c=='X'){
                    allPlants.remove(i); 
                    i=i-1;
                    }
                        
            }
        }
        System.debug('<<<<PlantList>>>final'+allPlants);
        System.debug('<<<<PlantList>>>'+allPlants.size());
        Decimal LeadTime=0;
        list<PlantNameWrapper> PlantNames = New list<PlantNameWrapper>();
        for(Material_Plant2__c MP:allPlants){
            PlantNameWrapper PNW = New PlantNameWrapper();
                PNW.label=MP.Plant_Name__c +' - '+ MP.Plant_Code__c;
                PNW.value=MP.Plant_Name__c +' - '+ MP.Plant_Code__c;
                LeadTime=LeadTime<MP.Required_Lead_Time__c?MP.Required_Lead_Time__c:LeadTime;
            PlantNames.add(PNW);   
               
        }
        PlantWrapper Pw = New PlantWrapper();
        pw.msId = msdId;
        Pw.matNumber = MatNum;
        pw.matDesc= MatDesc;
        pw.Plants = PlantNames;
        pw.RequiredLeadTime=LeadTime;
       // pw.plantVal=pval;
        
       PlantwithMat.add(Pw); 
       system.debug('<<<PlantwithMat>>>>'+PlantwithMat);
   // getMatPlants2(msdId);
   return PlantwithMat; 
   
    }
   
  
    
    @AuraEnabled 
   public static  list<PlantWrapper> materialPlantDetailV1(String msdId,string MatNum,String MatDesc,string ShipTo){
       List<PlantWrapper> PlantwithMat = New list<PlantWrapper>();
       // String PlantCode;
       String appendToMatNum = '0'.repeat(18 - MatNum.length());
       String Material_Number= appendToMatNum + MatNum;
	   Decimal Leadtime=0;
        List<Customer_Product_Info2__c> PlantCode = new List<Customer_Product_Info2__c>();
        Material_Plant2__c MP = New Material_Plant2__c();
        Account Acc = new Account();
        Acc=[select id,SAP_Sales_Org__c,SAP_Customer_Number__c from account where id=:ShipTo];
        String UOM=[select id,Sales_UOM__r.Alternative_UOM__c from Material_Sales_Data2__c where id=:msdId].Sales_UOM__r.Alternative_UOM__c;
      
        system.debug('<<<<Material_Number >>>>'+Material_Number );
        system.debug('<<<<Acc.SAP_Customer_Number__c>>>>'+Acc.SAP_Customer_Number__c);
        system.debug('<<<<Acc.SAP_Sales_Org__c>>>>'+Acc.SAP_Sales_Org__c);
        
        PlantCode=[Select id,Plant_Code__c From Customer_Product_Info2__c where Material_Number__c=:Material_Number and ShipTo_Number__c=:Acc.SAP_Customer_Number__c and Sales_Org_Code__c=:Acc.SAP_Sales_Org__c and Plant_Code__c !=''];
         system.debug('<<<<PlantCode>>>>'+PlantCode);
       
        If(PlantCode.size()>0){
        MP =[Select id,Plant_Name__c,Plant_Code__c From Material_Plant2__c where Material_Number__c=:Material_Number and Plant_Code__c=:PlantCode[0].Plant_Code__c and SalesOrg_Code__c=:Acc.SAP_Sales_Org__c];
        String Plant= MP.Plant_Name__c +' - '+ MP.Plant_Code__c;
        Leadtime=getLeadTme(msdId,Plant);
        system.debug('<<<<Leadtime>>>>>'+Leadtime);
        
        
        PlantWrapper Pw = New PlantWrapper();
        pw.msId = msdId;
        Pw.matNumber = MatNum;
        pw.matDesc= MatDesc;
        //pw.Plants = PlantNames;
        pw.RequiredLeadTime=LeadTime;
        pw.plantVal=Plant;
        pw.umo= UOM;
        
        PlantwithMat.add(Pw); 
       system.debug('<<<PlantwithMat>>>>'+PlantwithMat);
       }
       else{
           PlantWrapper Pw = New PlantWrapper();
        pw.msId = msdId;
        Pw.matNumber = MatNum;
        pw.matDesc= MatDesc;
        //pw.Plants = PlantNames;
        pw.RequiredLeadTime=0;
        pw.plantVal='---';
        pw.umo= UOM;
        
        PlantwithMat.add(Pw); 
       
       }
   return PlantwithMat; 
 }
     @AuraEnabled 
         public static  List<string> createOrder(list<requestedDateWrapper> Requestdate,List<MaterialListWrapper> MatList,List<ReorderWrapper> Reorder,String ordertyp){
         system.debug('<<<ordertyp>>>'+ordertyp);
         system.debug('<<<MatList----------->>>'+MatList);
         system.debug('<<<Requestdate----------->>>'+Requestdate);
         system.debug('<<<Reorder----------->>>'+Reorder);
          system.debug('<<<Reorder>>>'+Reorder);
          string ordersummary=orderSummary(MatList);
          List<Reorder__c > Rord = New List<Reorder__c>();
           list<Reorder_Line_Item__c> RliList = New List<Reorder_Line_Item__c>();
           System.debug('<<<Reorder[0].soldTo>>>>'+Reorder[0].soldTo);
           System.debug('<<<Reorder[0].shipTo>>>>'+Reorder[0].shipTo);
          for(requestedDateWrapper rr: Requestdate){
              Reorder__c ord = New Reorder__c();
              ord.Sold_To__c= Reorder[0].soldTo;
              ord.Ship_To__c = Reorder[0].shipTo;
              ord.Customer_PO_Number__c= rr.ponumberList;
              ord.Requested_Delivery_Date__c= rr.requestDeliveryDate;
              ord.Estimated_Ship_Date__c=rr.estimateShipDate;
              ord.Special_Instructions__c=rr.specificIns;
              ord.ReOrder_Type__c = Reorder[0].orderType;
              ord.Contract_Number__c = Reorder[0].ContractNumber;
              ord.Order_Summary__c =ordersummary;
              ord.Order_Mode__c=ordertyp;
              Rord.add(ord);
          }  
                  
              insert Rord;  
              List<string> reorderIds = New List<string>();
              for(Reorder__c ro: Rord){
                  reorderIds.add(ro.id);
                 
                  for(MaterialListWrapper MW : MatList){
                      Reorder_Line_Item__c rli = new Reorder_Line_Item__c();
                      rli.Reorder__c = ro.id;
                      rli.Quantity__c = MW.Quantity;
                      rli.Material2__c = MW.msId;
                      rli.Tank_Number__c = MW.TankNumber;
                      rli.UOM_Code__c = MW.UMO;
                      rli.Plant_Name__c = MW.plant;
                      rli.Required_Lead_Time__c = MW.leadTime;
                      
                      RliList.add(rli);
                  }
              }
         
              insert RliList;
            //Gokul on 15/3/2021
            //SalesOrderFeedToSAP obj = new SalesOrderFeedToSAP();
            //String data = SalesOrderFeedToSAP.CalloutToDellBoomi(reorderIds,RliList);
              system.debug('<<<Rord>>>'+Rord);
              system.debug('<<<RliList>>>'+RliList);
          
         return reorderIds;
     }
    
    public with sharing class PlantWrapper{
    
      @AuraEnabled public String matNumber {get; set;}
      @AuraEnabled public String matDesc;
      @AuraEnabled public String msId {get; set;}
      @AuraEnabled public double qty {get; set;}
      @AuraEnabled public String umoval;
      @AuraEnabled public decimal RequiredLeadTime {get;set;}
      @AuraEnabled public list<PlantNameWrapper> Plants {get;set;}
      @AuraEnabled public String plantVal {get; set;}
      @AuraEnabled public String umo{get; set;}
      @AuraEnabled public decimal leadVal {get; set;}
      
      
   }
   public with sharing class PlantNameWrapper{
    
      @AuraEnabled public String label{get; set;}
      @AuraEnabled public String value {get;set;}
      
   }
   public with sharing class requestedDateWrapper{
    
      @AuraEnabled public String ponumberList{get; set;}
      @AuraEnabled public date requestDeliveryDate{get;set;}
      @AuraEnabled public date estimateShipDate{get;set;}
      @AuraEnabled public String specificIns{get; set;}
       
      
   }
   
   public with sharing class MaterialListWrapper{
      @AuraEnabled public String msId {get; set;}    
      @AuraEnabled public decimal Quantity{get; set;}
      @AuraEnabled public String UMO{get;set;}
      @AuraEnabled public String MaterialNumber{get;set;}
      @AuraEnabled public String plant{get; set;}
      @AuraEnabled public String TankNumber{get; set;}
      @AuraEnabled public String materialId{get; set;}
      @AuraEnabled public decimal leadTime{get; set;}
       
      
   }
    public with sharing class ReorderWrapper{
    
      @AuraEnabled public String soldTo{get; set;}
      @AuraEnabled public String shipTo{get;set;}
      @AuraEnabled public String orderType{get;set;}
      @AuraEnabled public String ContractNumber{get; set;}     
   }
   
   public static  Map<Id, List<Material_Plant2__c>> getMatPlants2(string msd2Ids){
            Set<id> msd2IdSet = new Set<id>();
            msd2IdSet.add(msd2Ids);
            //MatPlantOptionsList.clear();

            Map<Id, List<Material_Plant2__c>> mp2map = New Map<Id, List<Material_Plant2__c>>();
            mp2map = Material_Sales_Data_Functions.getMaterialPlantMap(msd2IdSet);
            system.debug('LEAD TEST mp2map'+mp2map );
              system.debug('LEAD TEST msd2IdSet'+msd2IdSet);
                if(mp2map !=null){
                    if(mp2map.get(msd2Ids)!=null&&msd2Ids!=null)
                    {
                        system.debug('Inside Leadtime logic');
                   mp2map.put(msd2Ids,PopulateLeadtimeNon3Party(mp2map.get(msd2Ids),msd2Ids));
                    }
                    system.debug('ID VAL mp2map '+mp2map.get(msd2Ids));
                   // Map<Id, List<SelectOption>> psomap = getPlantSelectOptions(mp2map);
        //MatPlantOptionsList = psomap.get(msd2Ids);
                   // system.debug('SBB'+MatPlantOptionsList);
               }
                   return mp2map;
                    
        }
    @AuraEnabled     
   public static  decimal getLeadTme(string msdId ,String Plant){
    System.debug('<<<<msdId >>>++'+msdId );
        System.debug('<<<<Plant>>>'+Plant);
    List<PlantWrapper> PlantwithMat = New list<PlantWrapper>();
    list<Material_Plant2__c> allPlants= New  list<Material_Plant2__c>();
    list<Material_Plant2__c> delPlantList = New  list<Material_Plant2__c>();
    decimal LeadTime;
   // allPlants = Material_Sales_Data_Functions.getPlants(msdId); 
       Map<Id, List<Material_Plant2__c>> MP2 = getMatPlants2(msdId);
      system.debug('<<<ID VAL mp2map>>>'+MP2);
       system.debug('ID VAL msdId'+msdId);
      if(MP2 != null){
           for(integer i=0;i<MP2.get(msdId).size();i++){
              // Material_Plant2__c matp = New Material_Plant2__c();
                 //  matp=MP2.get(msdId)[i];      
               allPlants.add(MP2.get(msdId)[i]);
           }
        }
       System.debug('<<<<PlantList>>>++'+allPlants);
        System.debug('<<<<PlantList>>>'+allPlants.size());
        if (allPlants!= null){
                for (Integer i = 0; i < allPlants.size(); i++)
            {
                
                String PlantCheck=allPlants[i].Plant_Name__c+' - '+allPlants[i].Plant_Code__c;
                System.debug('<<<<PlantCheck>>>++'+PlantCheck);
                System.debug('<<<<Plant>>>++'+Plant);
                if (PlantCheck.equals(Plant)){
                    LeadTime = allPlants[i].Required_Lead_Time__c;
                    }
                
            }
            
      } 
      system.debug('<<<LeadTime>>>'+LeadTime);
      return LeadTime;
     //return 22; 
      }    
   public static List<Material_Plant2__c> PopulateLeadtimeNon3Party(List<Material_Plant2__c> matPlant,Id msd2Ids){
        Material_Sales_Data2__c msd=new Material_Sales_Data2__c();
        msd=[select name,Material_Number__c,Sales_Org_Code__c,Product_Hierarchy__r.PH5__c from Material_Sales_Data2__c where id=:msd2Ids];
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
   
        if (matPlant != null&&matPlant.size()>0)
        {
            for(Integer i=0;i<matPlant.size();i++)
            {
                if(matPlant[i].Third_Party_Plant__c==false)
                {
                    // Add Key1 to Query List 
                    // Salesorg+ Material No + Family code+ Plant code  
                    key1=msd.Sales_Org_Code__c+msd.Material_Number__c+msd.Product_Hierarchy__r.PH5__c+matPlant[i].Plant_Code__c;
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
                    key2=msd.Material_Number__c+msd.Product_Hierarchy__r.PH5__c+matPlant[i].Plant_Code__c;
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
                    key2=msd.Material_Number__c+msd.Product_Hierarchy__r.PH5__c+matPlant[i].Plant_Code__c;
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
                    key3=msd.Product_Hierarchy__r.PH5__c+matPlant[i].Plant_Code__c;
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
                    system.debug('TInside Else for record'+matPlant[i].Third_Party_Plant__c);
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
            system.debug('DDD'+mltmap.size());
            system.debug('DDD'+mltmap);
            for(Integer i=0;i<matPlant.size();i++)
            {
                if(matPlant[i].Third_Party_Plant__c==false)
                {                   
                    // Check Key1
                    key1=msd.Sales_Org_Code__c+msd.Material_Number__c+msd.Product_Hierarchy__r.PH5__c+matPlant[i].Plant_Code__c;
                    // Check Key2
                    key2=msd.Material_Number__c+msd.Product_Hierarchy__r.PH5__c+matPlant[i].Plant_Code__c;
                    // check key3
                    key3=msd.Product_Hierarchy__r.PH5__c+matPlant[i].Plant_Code__c;                   
                    if(mltmap.get(key1)!=null)
                    {
                        system.debug('Key 1 --> '+mltmap.get(key1));
                        mplval=mltmap.get(key1);
                        matPlant[i].Required_Lead_Time__c=mplval.Standard_Lead_Time__c;
                        system.debug('Key 1 Exception time set--> '+mplval.Standard_Lead_Time__c);
                    }
                    else if(mltmap.get(key2)!=null)
                    {
                        system.debug('Key 2 --> '+mltmap.get(key2));
                        mplval=mltmap.get(key2);
                        matPlant[i].Required_Lead_Time__c=mplval.Standard_Lead_Time__c;
                        system.debug('Key 2 Exception time set--> '+mplval.Standard_Lead_Time__c);
                    }
                    else if(mltmap.get(key3)!=null)
                    {
                        system.debug('Key 3 --> '+mltmap.get(key3));
                        mplval=mltmap.get(key3);
                        matPlant[i].Required_Lead_Time__c=mplval.Standard_Lead_Time__c;
                        system.debug('Key 3 Standard time set--> '+mplval.Standard_Lead_Time__c);
                    }
                    else
                    {
                        
                        system.debug('Else --> ');
                    }
                }
            }
            
        }
        return matPlant;
    }
       @AuraEnabled 
   public static  list<PlantWrapper> materialPlantDetail_in(id openId,String msdId,string MatNum,string pval,decimal leadVal){
    List<Open_Orders__c > opr = New List<Open_Orders__c>();
    System.debug('<<<openId>>>'+openId);
    System.debug('<<<msdId>>>'+msdId);
    System.debug('<<<MatNum>>>'+MatNum);
    system.debug('<<<<leadVal>>>'+leadVal);
    opr=[select id,Material__r.Material_Number__c,Ordered_Qty__c,Ordered_Qty_UOM__c,Sales_UOM__c,Material_Desc__c from Open_Orders__c where id=:openId];
    system.debug('<<<msdId>>>'+msdId);
   List<PlantWrapper> PlantwithMat = New list<PlantWrapper>();
    list<Material_Plant2__c> allPlants= New  list<Material_Plant2__c>();
    list<Material_Plant2__c> delPlantList = New  list<Material_Plant2__c>();
    integer count=0;
   // allPlants = Material_Sales_Data_Functions.getPlants(msdId); 
   Map<Id, List<Material_Plant2__c>> MP2 = getMatPlants2(msdId);
      system.debug('<<<ID VAL mp2map>>>'+MP2);
       system.debug('ID VAL msdId'+msdId);
      
       for(integer i=0;i<MP2.get(msdId).size();i++){
          // Material_Plant2__c matp = New Material_Plant2__c();
             //  matp=MP2.get(msdId)[i];      
           allPlants.add(MP2.get(msdId)[i]);
       }
    
       System.debug('<<<<PlantList>>>++'+allPlants);
    System.debug('<<<<PlantList>>>'+allPlants.size());
    if (allPlants!= null){
            for (Integer i = 0; i < allPlants.size(); i++)
            {
                if (allPlants[i].Plant_Code__c.equals('QM01') || allPlants[i].Deletion_Flag__c=='X'){
                    allPlants.remove(i); 
                    i=i-1;
                    }
                         
            }
        }
        System.debug('<<<<PlantList>>>final'+allPlants);
        System.debug('<<<<PlantList>>>'+allPlants.size());
        Decimal LeadTime=0;
        list<PlantNameWrapper> PlantNames = New list<PlantNameWrapper>();
        for(Material_Plant2__c MP:allPlants){
            PlantNameWrapper PNW = New PlantNameWrapper();
                PNW.label=MP.Plant_Name__c +' - '+ MP.Plant_Code__c;
                PNW.value=MP.Plant_Name__c +' - '+ MP.Plant_Code__c;
                LeadTime=LeadTime<MP.Required_Lead_Time__c?MP.Required_Lead_Time__c:LeadTime;
            PlantNames.add(PNW);   
               
        }
        PlantWrapper Pw = New PlantWrapper();
        pw.msId = msdId;
        System.debug('<<<1>>>>'+opr[0].Material__r.Material_Number__c);
         System.debug('<<<2>>>'+ opr[0].Ordered_Qty__c.intValue());
          System.debug('<<<3>>>>'+ opr[0].Ordered_Qty_UOM__c);
           System.debug('<<<4>>>>'+opr[0].Sales_UOM__c);
       Decimal qtyfinal=UoM_Conversion.retrieve_UoM_Conversion(opr[0].Material__r.Material_Number__c, opr[0].Ordered_Qty__c.intValue(), opr[0].Ordered_Qty_UOM__c, opr[0].Sales_UOM__c).resultQty;
       qtyfinal=qtyfinal.round(System.RoundingMode.UP);
       pw.qty=qtyfinal;
       Pw.matNumber = MatNum;
        pw.Plants = PlantNames;
        pw.RequiredLeadTime=LeadTime;
        pw.matDesc= opr[0].Material_Desc__c;
        pw.umoval= opr[0].Ordered_Qty_UOM__c;
        pw.plantVal=pval;
        pw.leadVal=leadVal;
       PlantwithMat.add(Pw); 
       system.debug('<<<PlantwithMat>>>>'+PlantwithMat);
   // getMatPlants2(msdId);
   return PlantwithMat; 
   
    }
    
    @AuraEnabled 
   public static  list<PlantWrapper> materialPlantDetail_in_v1(id openId){   
   Open_Orders__c opr = New Open_Orders__c();
    List<PlantWrapper> PlantwithMat = New list<PlantWrapper>();
   opr=[select id,Material__c,Material__r.Material_Number__c,Ordered_Qty__c,Ordered_Qty_UOM__c,Sales_UOM__c,Material_Desc__c,Plant_Desc__c,Material__r.Sales_UOM__r.Alternative_UOM__c  from Open_Orders__c where id=:openId];
       Decimal Leadtime=0;
       system.debug('<<<7777>>>'+opr.Material__c);
       Leadtime=getLeadTme(opr.Material__c,opr.Plant_Desc__c);
       system.debug('<<<9999>>>'+Leadtime);
    PlantWrapper Pw = New PlantWrapper();
        pw.msId = opr.Material__c;
        if(!Test.isRunningTest()){        
       Decimal qtyfinal=UoM_Conversion.retrieve_UoM_Conversion(opr.Material__r.Material_Number__c, opr.Ordered_Qty__c.intValue(), opr.Ordered_Qty_UOM__c, opr.Sales_UOM__c).resultQty;
       qtyfinal=qtyfinal.round(System.RoundingMode.UP);
       pw.qty=qtyfinal;
       }
        Pw.matNumber = opr.Material__r.Material_Number__c;
       // pw.Plants = 
       // pw.RequiredLeadTime=LeadTime;
        pw.matDesc= opr.Material_Desc__c;
        pw.umoval= opr.Material__r.Sales_UOM__r.Alternative_UOM__c;
        pw.plantVal=opr.Plant_Desc__c;
        pw.leadVal=Leadtime;
        PlantwithMat.add(Pw); 
       system.debug('<<<PlantwithMat>>>>'+PlantwithMat);
   // getMatPlants2(msdId);
   return PlantwithMat;    
}
    
    public static String orderSummary(List<MaterialListWrapper> MatList) {
        List<id> mid = New List<id>();
        For(MaterialListWrapper mlw:MatList){
           mid.add(mlw.msId); 
        }
        Map<id,Material_Sales_Data2__c> MS2 = New map<id,Material_Sales_Data2__c>([Select id,Net_Weight__c,Material_Desc__c,Net_Weight_in_LBs__c,Material_Number__c from Material_Sales_Data2__c where id in :mid]);
       // MS2=[Select id,Net_Weight__c,Net_Weight_in_LBs__c,Material_Number__c from Material_Sales_Data2__c where id in :mid];
        String retVal = '';       
        String tnknum = '';
        Decimal  Totalkg = 0.0;
        Decimal  Totallb = 0.0;
        
        String TankNumber;
       // Decimal Qty = 0.0;
        
          For(MaterialListWrapper ml:MatList){
            tnknum = TankNumber;                    
            if(MS2.get(ml.msId).Net_Weight__c != null){
                Totalkg = (ml.Quantity) * (MS2.get(ml.msId).Net_Weight__c);
            }
            if(MS2.get(ml.msId).Net_Weight_in_LBs__c != null){
                Totallb = (ml.Quantity) * (MS2.get(ml.msId).Net_Weight_in_LBs__c);
            }
  
              
            if (tnknum == null ||
                tnknum.trim().length() == 0) {tnknum = '';}
            else {tnknum = 'Tank Number : ' + tnknum;}
            
           
           
            retVal += '(Quantity:'+ml.Quantity+
                      'UOM: '   + ml.UMO+')'+
                      ' Material Number: '  +MS2.get(ml.msId).Material_Number__c+
                      ' Description: '  +MS2.get(ml.msId).Material_Desc__c+
                      ' Tank Number: '  +ml.TankNumber+ 'Total KGS:' + Totalkg+ 'Total LBS:'+Totallb+
                      '.\n';
        }
       system.debug('<<<<retVal>>>'+retVal);
        return retVal;
    }
    @AuraEnabled 
   public static list<Reorder__c> reOrderList(List<String> reorderIds){  
   return [Select id,Name,SAP_Order_Number__c,Customer_PO_Number__c,Estimated_Ship_Date__c,Requested_Delivery_Date2__c,Special_Instructions__c,Requested_Delivery_Date__c from Reorder__c where id IN :reorderIds];
   }
   @AuraEnabled 
   public static Boolean pilotCheck(String userId,String PrjName){  
   Boolean pilotUsrFlag=false;
   String PilotUsr = [Select id,Name,Pilot_user__c from user where id = :userId].Pilot_user__c;
   System.debug('<<<<PilotUsr >>>>>'+PilotUsr);
   if(PilotUsr.contains(PrjName)){
       pilotUsrFlag=true;
   }
   
   return pilotUsrFlag;
   }
           
}
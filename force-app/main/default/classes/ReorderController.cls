//Modified for CR CHG30000954  Requested Delivery Date should not fall in Weekends(Saturday or Sunday)by Hariharan Ragothaman from TechM 
// Modified with New Picklist values for Request-0706 by Srinivasan Muthu from TechM 
public class ReorderController {

    private static final String NONE = PricingConditionApprovalFunctions.NONE;

    public String orderId;
    public String SortField{get; set;}
    private String PrevSortField;
    public String SortImage{get; set;}
    public static final String SORT_ASC_IMG = '/img/sort_asc_arrow.gif';
    public static final String SORT_DESC_IMG = '/img/sort_desc_arrow.gif';

    public String materialName {get; set;}
    public Id materialId {get; set;}

    private String salesOrg;
    private String distChan;

    //Changed for Request-0716
    private Integer additionalNumberOfDays = 2;
    private Boolean datesWarningDisplayed = false;

    private static final String MSD2_QRY1 = '' +
        'Select Id, Sales_UOM_Desc__c, ' +
        'Material_Number__c, Material_Desc__c,Net_Weight__c,Net_Weight_in_LBs__c,' +
        'Sales_UOM__r.Base_UOM_Desc__c, ' +
        'Material_General_Data__r.Base_UOM_Desc__c ' +
        'From Material_Sales_Data2__c ';

    public Open_Orders__c orderMaster       {get; set;}
    public List<Line_Item> LineItems        {get; set;}
    public List<New_Reorder> newOrders      {get; set;}
    public List<Open_Order> orderMasterList {get; set;}

    public Boolean allDateSelected          {get; set;}
    public Boolean allMatsSelected          {get; set;}
    public Boolean recordsInserted          {get; set;}

    public Boolean allOrderSelected         {get; set;}
    public Boolean isMultiReorder           {get; set;}

    public Integer LineItemsSize            {get; set;}
    public Integer newOrdersSize            {get; set;}

    public Reorder_Line_Item__c newRecMat   {get; set;}

    public String accountId                 {get; set;}
    public String errMsg                    {get; set;}
    public String reqLeadTimeHelp           {get; set;}

    public Reorder__c reorderHeader {
        get {
            if (reorderHeader == null) {
                reorderHeader = new Reorder__c();
            }
            return reorderHeader;
        }
        set;
    }

    private List<Open_Orders__c> orderMasters;

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>> ' + s);
    }

    private static String getZeroFilled(String s, Integer n) {
        String r = s.trim(); Integer m = r.length();
        while (m++ < n) {r = '0' + r;}
        return r;
    }

    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
   
    // Constructor Class //
    public ReorderController(ApexPages.StandardController  sc) {
   
        
        isMultiReorder = false; prevSortField = ''; SortImage = ''; SortField = '';
        orderMaster = null;

        reqLeadTimeHelp = '' +
            'Leadtime for products sourced from Solenis Plants is in ' +
            'business days and does NOT include transit time. ' +
            'The leadtime is Order to Ship.<br/><br/> ' +
            'Leadtime for products sourced from 3rd Party Plants is in ' +
            'business days and does NOT include transit time. ' +
            'The leadtime is Order to Ship.';

        additionalNumberOfDays = GetAdditionalNumberOfDays();
        Date reqDelvryDate = System.today() + additionalNumberOfDays;

        if(ApexPages.currentPage().getParameters().containsKey('Id'))
        {
            // Get the Id of the Open_Orders record being cloned.
            orderId = ApexPages.currentPage().getParameters().get('Id');

            // Get the Open_Orders record
            try {
                orderMaster = [Select
                    Agreed_Ship_Date2__c,
                    Line_Item_Number__c,
                    Material_Desc__c,
                    Material__c,
                    Material__r.Material_Desc__c,
                    Material__r.Material_General_Data__c,
                    Material__r.Material_Number__c,
                    Material__r.Sales_Org_Code__c,
                    Material__r.Net_Weight_in_LBs__c,
                    Material__r.Net_Weight__c,
                    Name,
                    Ordered_Qty_UOM__c,
                    Ordered_Qty__c,
                    Plant_Desc__c,
                    Sales_Order_Number__c,
                    Sales_UOM__c,
                    ShipTo__c,
                    ShipTo__r.ShippingCity,
                    ShipTo__r.ShippingCountry,
                    ShipTo__r.ShippingPostalCode,
                    ShipTo__r.ShippingState,
                    ShipTo__r.ShippingStreet,
                    SoldTo__c
                From Open_Orders__c where Id = :orderId LIMIT 1][0];
            } catch (Exception e) {debug('Error 1 : ' + e.getMessage());}

            // Get the Line Items for the Open Order

            LineItems = initLineItems();

            isMultiReorder = false;
        }
        else if(ApexPages.currentPage().getParameters().containsKey('accountId'))
        {
             //getting the Account ID
             accountId = ApexPages.currentPage().getParameters().get('accountId');
             orderMasters = new List<Open_Orders__c>();
             //get the Open Order Records
             try {
                orderMasters = [Select
                    Agreed_Ship_Date2__c,
                    Line_Item_Number__c,
                    Material_Desc__c,
                    Material__c,
                    Material__r.Material_Desc__c,
                    Material__r.Material_General_Data__c,
                    Material__r.Material_Number__c,
                    Material__r.Sales_Org_Code__c,
                    Material__r.Net_Weight_in_LBs__c,
                    Material__r.Net_Weight__c,
                    Name,
                    Ordered_Qty_UOM__c,
                    Ordered_Qty__c,
                    Plant_Desc__c,
                    Sales_Order_Number__c,
                    Sales_UOM__c,
                    ShipTo__c,
                    ShipTo__r.ShippingCity,
                    ShipTo__r.ShippingCountry,
                    ShipTo__r.ShippingPostalCode,
                    ShipTo__r.ShippingState,
                    ShipTo__r.ShippingStreet,
                    SoldTo__c
                From Open_Orders__c where ShipTo__c = :accountId
                and Created_Date2__c >= :date.today() - 90 order by Created_Date2__c DESC limit 1000];
            } catch (Exception e) {debug('Error 2 : ' + e.getMessage());}

            if(orderMasters != null && orderMasters.size() > 0) {
                orderMaster = orderMasters[0];
                isMultiReorder = true;

                Id SoldToId = Account_Partner_Functions.getSoldToId(accountId);

                if(soldToID == null) {
                    orderMaster.soldto__c = AccountID;
                } else {
                    orderMaster.soldto__c = soldToID;
                }
                orderMasterList = new List<Open_Order>();
                for(Open_Orders__c order : orderMasters) {
                    Open_Order oO = new Open_Order();
                    oO.openOrder = order;
                    oO.isSelected = false;
                    orderMasterList.add(oO);
                }
            }
            LineItems = initLineItems();
        }
        // Defining a temporary order master in case of no open orders //

        if (orderMaster == null) {
            Account shippingAccount = new Account();
            Account soldToAccount;
            try {
                shippingAccount = getAccount(accountId);
                Id SoldToId = Account_Partner_Functions.getSoldToId(accountId);
                soldToAccount = getAccount(SoldToId);
            } catch (Exception e) {debug('Error 4 : ' + e.getMessage());}

            if(soldToAccount == null) {soldToAccount = shippingAccount;}
            Open_Orders__c tempOrder = new Open_Orders__c();
            tempOrder.ShipTo__c = shippingAccount.Id;
            tempOrder.ShipTo__r = shippingAccount;
            tempOrder.SoldTo__c = soldToAccount.Id;
            orderMaster = tempOrder;
        }

        newOrders = new List<New_Reorder>();
        New_Reorder newOrder = new New_Reorder(orderMaster, reqDelvryDate);
        newOrder.isnew = false;
        newOrders.add(newOrder);

        allDateSelected = false;
        allMatsSelected = false;
        recordsInserted = false;
        allOrderSelected = false;

        newRecMat = new Reorder_Line_Item__c();

        updateSizes();

        getValidateDates();
    }

    public Integer GetAdditionalNumberOfDays()
    {
        //Integer returnValue = 5;
        //Changed from value 5 to 2 for the Reques CR-0716
        Integer returnValue = 2;
        try
        {
            ReorderCustomSettings__c CS;
            // first see if there is user or proffile specific setting available
            CS = ReorderCustomSettings__c.getInstance();
            if (CS != null) {if (CS.Add_No_Of_Days__c != null) returnValue = Integer.valueOf(CS.Add_No_Of_Days__c);}
            else {    // get org-wide value
                CS = ReorderCustomSettings__c.getOrgDefaults();
                if (CS != null) {if (CS.Add_No_Of_Days__c != null) returnValue = Integer.valueOf(CS.Add_No_Of_Days__c); }
            }
        }
        catch (Exception ex) {
         //returnValue = 5;
                 //Changed from value 5 to 2 for the Reques CR-0716 and Also in Custom Settings too.
         returnValue = 2; 
          }
        system.debug('GetAdditionalNumberOfDays:returnValue = ' + returnValue);
        return returnValue;
    }

    private Account getAccount(String accId) {
        Account a = null;
        try {
            a = [Select Name, SAP_DistChannel__c, SAP_Sales_Org__c,
                        ShippingCity, ShippingCountry, ShippingPostalCode,
                        ShippingState, ShippingStreet
                   from Account where Id =: accId][0];
            if (salesOrg == null) {salesOrg = a.SAP_Sales_Org__c;}
            if (distChan == null) {distChan = a.SAP_DistChannel__c;}
        } catch(Exception e) {
            debug('getAccount : ' + e.getMessage());
        }
        return a;
    }

    public class New_Reorder {
        public Reorder__c reOrder {get; set;}
        public Boolean selected {get; set;}
        public Boolean isnew {get; set;}
        public New_Reorder(Open_Orders__c oO) {
            reOrder = new Reorder__c();
            reOrder.Requested_Delivery_Date__c = System.today();
            initReOrder(oO);
        }
        public New_Reorder(Open_Orders__c oO, Date RequestedDeliveryDate)
        {
            reOrder = new Reorder__c();
            reOrder.Requested_Delivery_Date__c = RequestedDeliveryDate;
            initReOrder(oO);
        }
        public New_Reorder(Open_Orders__c oO, Date RequestedDeliveryDate, Date EstShipDate)
        {
            reOrder = new Reorder__c();
            reOrder.Requested_Delivery_Date__c = RequestedDeliveryDate;
            reOrder.Estimated_Ship_Date__c = EstShipDate;
            initReOrder(oO);
        }

        private void initReOrder(Open_Orders__c oO)
        {
            try {
                reOrder.Ship_To__c = oO.ShipTo__c;
                reOrder.Sold_To__c = oO.SoldTo__c;
            } catch(Exception e) {
                debug('New_Reorder Error : ' + e.getMessage());
            }
            selected = false;
            isnew = true;
        }


    }

    public Date GetValidReqDeliveryDate()
    {
        Date newDate = System.Today();
        //Changed for Request-0716
        //Integer maxLeadTime = MaxLeadTime() + additionalNumberOfDays;
        Integer maxLeadTime = ( MaxLeadTime() / 5) * 7  + additionalNumberOfDays;
        newDate = newDate.addDays(maxLeadTime);
  // changes  for janice kelly  CR CHG30000954  Requested Delivery Date should not fall in Weekends(Saturday or Sunday)
        
        Datetime dt = DateTime.newInstance(newDate, Time.newInstance(0, 0, 0, 0));
        String dayOfWeek=dt.format('EEEE');
           if(dayOfWeek == 'Saturday' || dayOfWeek == 'Sunday') {
                if (dayOfWeek == 'Saturday') {
                     newdate= newDate +1;
                }
                    else{
                       newdate= newDate +2;
                    }
            }   
          


        // Sat Sun Test
        
        //String dayOfWeek = newDate.format('E');
        //if(dayOfweek == 'Sat')
        //{
          //  Integer sat = 10;
           // newDate = newDate.addDays(sat); 
       // }
        
        // End Sat Sun test
        return newDate;
    }

    public Date GetValidEstShipDate()
    {
        Date newDate = System.Today();
        //Changed for Request-0716
        //Integer maxLeadTime = MaxLeadTime();
        Integer maxLeadTime = ( MaxLeadTime() / 5) * 7;
        
        newDate = newDate.addDays(maxLeadTime);
        return newDate;
    }

    public void SetValidReqDeliveryDateOnReorder()
    {
        Date newDate = GetValidReqDeliveryDate();
        for (New_Reorder no : newOrders)
        {
            no.reOrder.Requested_Delivery_Date__c = newDate ;
        }
    }
    public void SetValidEstShipDateOnReorder()
    {
        Date newDate = GetValidEstShipDate();
        for (New_Reorder no : newOrders)
        {
            no.reOrder.Estimated_Ship_Date__c = newDate ;
        }
    }

    public void OnPlantChange()
    {
        SetValidEstShipDateOnReorder();
        SetValidReqDeliveryDateOnReorder();
        String temp = getValidateDates();
    }

    public Integer MaxLeadTime()
    {
        Integer maxLeadTime = 0;
        for (Line_Item li : LineItems)
        {
            if (li.lineItem.Required_Lead_Time__c != null && maxLeadTime < li.lineItem.Required_Lead_Time__c)
                maxLeadTime = Integer.valueOf(li.lineItem.Required_Lead_Time__c) ;
        }

        //System.Debug('MaxLeadTime():maxLeadTime = ' + maxLeadTime);
        return maxLeadTime;

    }

    public Boolean ValidateReqDeliveryDate()
    {
        Boolean validDate = true;
        Date newDate = GetValidReqDeliveryDate();
        for (New_Reorder no : newOrders)
        {
            if (no.reOrder.Requested_Delivery_Date__c < newDate)
                validDate = false;
        }

        return validDate;

    }

    public Boolean ValidateEstShipDate()
    {
        Boolean validDate = true;
        Date newDate = GetValidEstShipDate();
        for (New_Reorder no : newOrders)
        {
            if (no.reOrder.Estimated_Ship_Date__c < newDate)
                validDate = false;
        }

        return validDate;

    }

    public String getValidateDates()
    {
        errMsg = '';
        Boolean foundError1 = false;
        Boolean foundError2 = false;

        for (New_Reorder no : newOrders)
        {
            if (no.reOrder.Requested_Delivery_Date__c <= no.reOrder.Estimated_Ship_Date__c) // && !foundError1)
            {
                errMsg += 'The requested delivery date ' + getformattedDate(no.reOrder.Requested_Delivery_Date__c) +
                ' is less or equal to the estimated ship date ' + getformattedDate(no.reOrder.Estimated_Ship_Date__c) +
                '     ';
                foundError1 = true;
            }
            if (no.reOrder.Requested_Delivery_Date__c > no.reOrder.Estimated_Ship_Date__c &&
                no.reOrder.Requested_Delivery_Date__c < no.reOrder.Estimated_Ship_Date__c.addDays(additionalNumberOfDays)) // && !foundError2)
            {
                errMsg += 'The requested delivery date ' + getformattedDate(no.reOrder.Requested_Delivery_Date__c) +
                ' is less than ' + additionalNumberOfDays +
                    ' days beyond the estimated ship date ' + getformattedDate(no.reOrder.Estimated_Ship_Date__c) + '. The transit time for the order is ' +
                    no.reOrder.Estimated_Ship_Date__c.daysBetween(no.reOrder.Requested_Delivery_Date__c) +
                    ' days, please confirm.     ';
                foundError2 = true;
            }
            /*
            if (foundError1 && foundError2)
                break;
                */

        }

        if (errMsg != '')
            errMsg += ' The order will need to be confirmed by the CSR. To continue click Ok or click Cancel and adjust the dates.     ';

        return errMsg;
    }

    private string getformattedDate(Date thisDate)
    {
        string[] validDateAry = string.valueOf(thisDate).split('-', -1);
        string dateYear = validDateAry[0];
        string dateMonth = validDateAry[1];
        string dateDay = validDateAry[2];
        return dateMonth + '/' + dateDay + '/' + dateYear;
    }

    public class Line_Item {
        public Reorder_Line_Item__c lineItem {get; set;}
        public Boolean selected {get; set;}
        public Boolean isnew {get; set;}
        public String UoM {get; set;}
        public String matDesc {get; set;}
        public String matNumber {get; set;}
        public String plantDesc {get; set;}
        public Decimal TotalLBs {get;set;}
        public Decimal TotalKGs {get;set;}

        // Plant related
        private List<SelectOption> MatPlantOptionsList = new List<SelectOption>();
        public List<SelectOption> MatPlants {get {return this.MatPlantOptionsList;}}
        public String MatPlant {get {return lineItem.Plant_Name__c;}
            set {
                lineItem.Plant_Name__c = value;
                lineItem.Required_Lead_Time__c = 0.0;
                lineItem.Required_Lead_Time__c = MatPlantLeadTimeMap.get(lineItem.Material2__c).get(value);
                //System.Debug('Line_Item: MatPlant Set lineItem.Plant_Name__c = ' + lineItem.Plant_Name__c );
                //System.Debug('Line_Item: MatPlant Set lineItem.Required_Lead_Time__c = ' + lineItem.Required_Lead_Time__c);
            }
        }

        //Lead Time related
        private Map<String, Decimal> PlantLeadTimeMap = new Map<String, Decimal>();
        private Map<Id, Map<String, Decimal>> MatPlantLeadTimeMap = new Map<Id, Map<String, Decimal>>();

        public Line_Item(Reorder_Line_Item__c li) {
            lineItem = li;
            selected = false;
            isnew = true;
            if (lineItem.Material2__c != null)
                getMatPlants(lineItem.Material2__c);
            //System.Debug('MatPlantLeadTimeMap = ' + MatPlantLeadTimeMap);
        }
        public void refresh() {
            // Do nothing
        }

        public void getMatPlants(id msd2Ids)
        {
            Set<id> msd2IdSet = new Set<id>();
            msd2IdSet.add(msd2Ids);
            MatPlantOptionsList.clear();

            Map<Id, List<Material_Plant2__c>> mp2map = Material_Sales_Data_Functions.getMaterialPlantMap(msd2IdSet);
            system.debug('LEAD TEST mp2map'+mp2map.get(msd2Ids));
              system.debug('LEAD TEST msd2IdSet'+msd2IdSet);
            if(mp2map.get(msd2Ids)!=null&&msd2Ids!=null)
            {
                system.debug('Inside Leadtime logic');
           mp2map.put(msd2Ids,PopulateLeadtimeNon3Party(mp2map.get(msd2Ids),msd2Ids));
            }
            system.debug('ID VAL mp2map '+mp2map.get(msd2Ids));
            Map<Id, List<SelectOption>> psomap = getPlantSelectOptions(mp2map);
            MatPlantOptionsList = psomap.get(msd2Ids);
            system.debug('SBB'+MatPlantOptionsList);

        }
        
      
        //Lead time FUnction
         public List<Material_Plant2__c> PopulateLeadtimeNon3Party(List<Material_Plant2__c> matPlant,Id msd2Ids)
    {
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
                system.debug('SIZE-->'+leadtimekey); 
                List<Material_Plant_Leadtime__c> mlt=[select LeadTimeKey__c,QueryKey__c,Name,Standard_Lead_Time__c,Exception_Lead_Time__c,id from Material_Plant_Leadtime__c where QueryKey__c in:leadtimekey and Deletion_Indicator__c!='x' order by LeadTimeKey__c desc ];
                //add to MAP 
               system.debug('SIZE-->'+mlt.size());       
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
        

        // Map<Material_Sales_Data2__c, List<SelectOption>>
        private Map<Id, List<SelectOption>> getPlantSelectOptions(Map<Id, List<Material_Plant2__c>> mp2map) {
            Map<Id, List<SelectOption>> amap = new Map<Id, List<SelectOption>>();
            if (mp2map == null || mp2map.isEmpty()) {return amap;}
            List<Material_Plant2__c> mp2s; List<SelectOption> sos;
            List<String> sa1, sa2; String d = '!@#';
            for (Id i : mp2map.keySet()) {
                    mp2s = mp2map.get(i);
                    sa1 = new List<String>();
                    for (Material_Plant2__c mp2 : mp2s) {
                            if (mp2.Deletion_Flag__c != 'X' && !mp2.Plant_Code__c.equals('QM01')) {
                            //debug(mp2.Plant_Name__c + d + mp2.Plant_Code__c + d + mp2.SAP_Plant__c);
                                    sa1.add(mp2.Plant_Name__c + d + mp2.Plant_Code__c + d + mp2.SAP_Plant__c);
                                    PlantLeadTimeMap.put(mp2.Plant_Name__c+' - '+mp2.Plant_Code__c, mp2.Required_Lead_Time__c);
                                    MatPlantLeadTimeMap.put(i, PlantLeadTimeMap);
                            }
                    }
                    sos = new List<SelectOption>();
                    sos.add(new SelectOption(NONE, NONE));
                    if (!sa1.isEmpty()) {
                            sa1.sort();
                            for (String s : sa1) {
                                    sa2 = s.split(d);
                                    //sos.add(new SelectOption(sa2[2], sa2[0]+' - '+sa2[1]));
                                    sos.add(new SelectOption(sa2[0]+' - '+sa2[1], sa2[0]+' - '+sa2[1]));
                            }
                    }
                    amap.put(i, sos);
            }
            return amap;
        }


    }

    public class Open_Order {
        public Open_Orders__c openOrder {get; set;}
        public Boolean isSelected {get; set;}
        public Open_Order()
        {
            openOrder = new Open_Orders__c();
            isSelected = false;
        }
    }

    public Pagereference callReorderPage()
    {
        // Get the Line Items for the Open Order
        LineItems = new List<Line_Item>();
        if (orderMasterList == null || orderMasterList.isEmpty()) {
            return Page.Reorder;
        }
        for(Open_Order oO : orderMasterList) {
            List<Line_Item> tempList = new List<Line_Item>();
            if(oO.isSelected) {
                orderMaster = oO.openOrder;
                tempList = initLineItems();
                for(Line_Item li : tempList) {
                    li.MatPlant = oO.openOrder.Plant_Desc__c;
                    LineItems.add(li);
                }
                SetValidReqDeliveryDateOnReorder();
                SetValidEstShipDateOnReorder();
            }
        }
        if(orderMasters != null && orderMasters.size() > 0) {
            orderMaster = orderMasters[0];
        }
        updateSizes();
        return Page.Reorder;
    }

    // Back Function for reorder Page //
    public PageReference callIntermediatePage()
    {
        Map<String, String> pmap = ApexPages.currentPage().getParameters();
        //System.debug(pmap);
        Boolean hasAccountId = ApexPages.currentPage().getParameters().containsKey('accountId');
        Boolean hasId = ApexPages.currentPage().getParameters().containsKey('Id');
        if (hasId || hasAccountId && !isMultiReorder) {
            String accountId = ApexPages.currentPage().getParameters().get('accountId');
            return new PageReference('/' + accountId);
        } else {
            return Page.ReorderRedirectPage;
        }
    }

    public PageReference gotoAccountPage() {
        Boolean hasAccountId = ApexPages.currentPage().getParameters().containsKey('accountId');
        if (hasAccountId) {
            String accountId = ApexPages.currentPage().getParameters().get('accountId');
            return new PageReference('/' + accountId);
        }
        return null;
    }

    public List<Line_Item> initLineItems() {
        List<Line_Item> liList = new List<Line_Item>();
        if (orderMaster == null) {
            return liList;
        }
        Reorder_Line_Item__c newReLi = new Reorder_Line_Item__c();
        newReLi.Material2__c = orderMaster.Material__c;
        Line_Item newLi = new Line_Item(newReLi);

        //String salesUOM = orderMaster.Material__r.Sales_UOM__r.Alternative_UOM__c;
        String salesUOM = orderMaster.Sales_UOM__c;
        newLi.UoM = salesUOM;

        if(salesUOM!=orderMaster.Ordered_Qty_UOM__c && salesUOM!=null) {
            newReLi.Quantity__c = UoM_Conversion.retrieve_UoM_Conversion(orderMaster.Material__r.Material_Number__c, orderMaster.Ordered_Qty__c.intValue(), orderMaster.Ordered_Qty_UOM__c, newLi.UoM).resultQty;
        system.debug('newReLi.Quantity__c'+ newReLi.Quantity__c);
        } else {
            newReLi.Quantity__c = orderMaster.Ordered_Qty__c;
        }
        if (newReLi.Quantity__c != null) {
            newReLi.Quantity__c = newReLi.Quantity__c.round(System.RoundingMode.UP);
        }

        newLi.matDesc = orderMaster.Material__r.Material_Desc__c;
        newLi.TotalLBs = orderMaster.Material__r.Net_Weight_in_LBs__c;
        newLi.TotalKGs = orderMaster.Material__r.Net_Weight__c;
        newLi.matNumber = String_Functions.removeLeadingZeros(orderMaster.Material__r.Material_Number__c);
        liList.add(newLi);

        return liList;
    }

    

    private String orderSummary() {
        String retVal = '';
       
        String tnknum = '';
        Decimal  Totalkg = 0.0;
        Decimal  Totallb = 0.0;
        Decimal Qty = 0.0;
        
        for(Integer i = 0 ; i < LineItems.size() ; i++) {
            tnknum = LineItems[i].lineItem.Tank_Number__c;
            //Totalkg = LineItems[i].TotalKGs;
           // Totallb = LineItems[i].TotalLBs;       
            Qty = LineItems[i].lineItem.Quantity__c;
            
            if(LineItems[i].TotalKGs != null){
                Totalkg = (Qty) * (LineItems[i].TotalKGs) ;
            }
            if(LineItems[i].TotalLBs != null){
                Totallb = (Qty) * (LineItems[i].TotalLBs) ;
            }
            
            system.debug('Tank----'+tnknum);
           // if( uom == null || uom == ''){uom='N/A';}
             //else{uom = + uom;}
              
            if (tnknum == null ||
                tnknum.trim().length() == 0) {tnknum = '';}
            else {tnknum = 'Tank Number : ' + tnknum;}
            
           
           
            retVal += '(Quantity:'+LineItems[i].lineItem.Quantity__c+
                      'UOM: '   + LineItems[i].lineItem.UOM_Code__c+')'+
                      ' Material Number: '  +LineItems[i].matNumber+
                      ' Description: '  +LineItems[i].matDesc+
                      ' Tank Number: '  +tnknum+ 'Total KGS:' + Totalkg+ 'Total LBS:'+Totallb+
                      '.\n';
        }
        return retVal;
    }

    public void addMat() {
        Reorder_Line_Item__c newReLi = new Reorder_Line_Item__c();
        newReLi.Quantity__c = 0;
        Material_Sales_Data2__c tmpMat;

        try {
            debug('addMat : ' + newRecMat.Material2__c + ' : ' + materialName);
            if (isNull(newRecMat.Material2__c)) {
                tmpMat = getMaterialByKey(materialName);
            } else {
                //newReLi.Material2__c = newRecMat.Material2__c;
                tmpMat = getMaterialById(newRecMat.Material2__c);
            }

            newReLi.Material2__c = tmpMat.Id;
            Line_Item newLi = new Line_Item(newReLi);
            newLi.matDesc = tmpMat.Material_Desc__c;
            newLi.TotalKGs = tmpMat.Net_Weight__c;
            newLi.TotalLBs = tmpMat.Net_Weight_in_LBs__c;
            newLi.matNumber = String_Functions.removeLeadingZeros(tmpMat.Material_Number__c);

            if('['+tmpMat.Sales_UOM_Desc__c+']'=='[null]') {
                newLi.UoM = tmpMat.Material_General_Data__r.Base_UOM_Desc__c;
            } else {
                newLi.UoM = tmpMat.Sales_UOM_Desc__c;
            }
            //newLi.getMatPlants(newLi.lineItem.Material2__c);
            LineItems.add(newLi);

            newRecMat = new Reorder_Line_Item__c();
            updateSizes();
            materialName = '';
        } catch(Exception e) {
            string errmsg = 'Select a valid Material from the lookup';
            ApexPages.Message mymsg = new ApexPages.Message(ApexPages.Severity.Error, errmsg);
            ApexPages.addMessage(mymsg);
            debug('addMat Error : ' + e.getMessage());
        }
    }

    private Material_Sales_Data2__c getMaterialById(String matId) {
        if (isNull(matId)) {return null;}
        String q = MSD2_QRY1 + 'where Id = :matId limit 1';
        debug(q);
        List<Material_Sales_Data2__c> msd2s = null;
        try {msd2s = Database.query(q);} catch(Exception e) {}
        if (msd2s == null || msd2s.isEmpty()) {return null;}
        return msd2s[0];
    }

    private Material_Sales_Data2__c getMaterialByKey(String matNum) {
        if (isNull(matNum)) {return null;}
        String recKey = getZeroFilled(matNum, 18) + salesOrg + distChan;
        debug(recKey);
        String q = MSD2_QRY1 + 'where Record_Key__c = :recKey limit 1';
        debug(q);
        List<Material_Sales_Data2__c> msd2s = null;
        try {msd2s = Database.query(q);} catch(Exception e) {}
        if (msd2s == null || msd2s.isEmpty()) {return null;}
        return msd2s[0];
    }

    public void delMat() {
        Integer liSize = LineItems.size() - 1;
        for (Integer i = liSize ; i >= 0 ; i--){
            if(LineItems[i].selected == true) {
                LineItems.remove(i);
            }
        }
        allMatsSelected = false;
        updateSizes();
    }

    public void addReorder() {
        // Add new New_Order record to newOrders list as a clone of orderMaster
        Open_Orders__c masterCopy = new Open_Orders__c();
        masterCopy = orderMaster.clone();
        New_Reorder newOrder = new New_Reorder(orderMaster, GetValidReqDeliveryDate(), GetValidEstShipDate());
        newOrder.isnew = false;
        //newOrder.reOrder.Requested_Delivery_Date__c = GetValidReqDeliveryDate();
        newOrders.add(newOrder);
        updateSizes();
    }

    public void delReorder() {
        // Removed selected (checked) New_Order records from Requested Date table
        Integer liSize = newOrders.size() - 1;
        for (Integer i = liSize ; i >= 0 ; i--){
            if(newOrders[i].selected == true) {
                newOrders.remove(i);
            }
        }
        allDateSelected = false;
        updateSizes();
    }

    public void updateSizes() {
        if (newOrders != null) {newOrdersSize = newOrders.size();}
        if (LineItems != null) {LineItemsSize = LineItems.size();}
    }

    private Boolean validateReorder() {
        String rotype = '';
        if (reorderHeader.ReOrder_Type__c != null) {
            rotype = reorderHeader.ReOrder_Type__c.trim();
        }
        if (rotype == 'Contract Billing') {
            String contractNumber = reorderHeader.Contract_Number__c;
            String s1 = 'Invalid Contract Number (Must be numeric and a maximum of 10 digits): ' + contractNumber;
            ApexPages.Message m1 = new ApexPages.Message(ApexPages.Severity.Error, s1);
            if (contractNumber == null || contractNumber.trim().length() < 1) {
                //ApexPages.addMessage(m1);
                //return false;
                return true;
            }
            contractNumber = contractNumber.trim();
            if (contractNumber.length() < 1 ||
                contractNumber.length() > 10) {
                ApexPages.addMessage(m1);
                return false;
            }
            try {
                Integer i = Integer.valueOf(contractNumber);
                return true;
            } catch (Exception e) {
                ApexPages.addMessage(m1);
                return false;
            }
        }
        return true;
    }

    // Save Function //
    public PageReference saveReorders() {
        if (!validateReorder()) {return null;}

        PageReference originalOpenOrders;
        if(isMultiReorder || orderId == null) {
            originalOpenOrders = new PageReference('/'+accountId);
        } else {
            originalOpenOrders = new PageReference('/'+orderId);
        }
        if(newOrders.size() > 0 && LineItems.size() > 0) {
            List<Reorder__c> newReorders = new List<Reorder__c>();
            List<Reorder_Line_Item__c> newReorderLis = new List<Reorder_Line_Item__c>();
           Set<Date> reOrderDates = new Set<Date>();
            boolean validOrder = true;
            Reorder__c newReorder;
            Reorder_Line_Item__c newReorderLi;
            for(Integer i = 0 ; i < newOrders.size() ; i++) {
                newReorder = new Reorder__c();
                // Set values in newReorder from newOrders[i] & orderMaster
                newReorder.Ship_To__c = orderMaster.ShipTo__c;
                newReorder.Sold_To__c = orderMaster.SoldTo__c;
                newReorder.ReOrder_Type__c = reorderHeader.ReOrder_Type__c;
                newReorder.Contract_Number__c = reorderHeader.Contract_Number__c;
                newReorder.Customer_PO_Number__c = newOrders[i].reOrder.Customer_PO_Number__c;
                newReorder.Requested_Delivery_Date__c = newOrders[i].reOrder.Requested_Delivery_Date__c;
                newReorder.Estimated_Ship_Date__c = newOrders[i].reOrder.Estimated_Ship_Date__c;
                newReorder.Special_Instructions__c = newOrders[i].reOrder.Special_Instructions__c;
                newReorder.Order_Summary__c = orderSummary();

                if (reorderDates.contains(newOrders[i].reOrder.Requested_Delivery_Date__c)){
                    string errmsg = 'Can not add a reorder with the same date';
                    ApexPages.Message mymsg = new ApexPages.Message(ApexPages.Severity.Error, errmsg);
                    ApexPages.addMessage(mymsg);
                    validOrder = false;
                    return null;
                }
                if (validOrder){
                   reorderDates.add(newOrders[i].reOrder.Requested_Delivery_Date__c);
                   newReorders.add(newReorder);
                }//end process valid order
            }// end for

            try {
                insert newReorders;
            } catch (Exception e) {
                debug('Error 8 : ' + e.getMessage());
            }

            for(Integer i = 0 ; i < newReorders.size() ; i++) {
                for(Integer j = 0 ; j < LineItems.size() ; j++) {
                    newReorderLi = new Reorder_Line_Item__c();
                    // Set values in newReorderLi from LineItems[j]
                    newReorderLi.Reorder__c = newReorders[i].Id;
                    newReorderLi.Material2__c = LineItems[j].lineItem.Material2__c;
                    newReorderLi.Quantity__c = LineItems[j].lineItem.Quantity__c;
                    //newReorderLi.Total_LBs__c = LineItems[j].lineItem.Total_LBs__c;
                    //Line 801 Added with New Picklist values for Request-0706 by TechM-->
                    newReorderLi.UOM_Code__c = LineItems[j].lineItem.UOM_Code__c;
                    newReorderLi.Tank_Number__c = LineItems[j].lineItem.Tank_Number__c;
                    newReorderLi.Plant_Name__c = LineItems[j].lineItem.Plant_Name__c;
                    newReorderLi.Required_Lead_Time__c = LineItems[j].lineItem.Required_Lead_Time__c;
                    newReorderLis.add(newReorderLi);
                }
            }

            try {
                insert newReorderLis;
            } catch (Exception e) {
                debug('Error 9 : ' + e.getMessage());
            }

            originalOpenOrders.setRedirect(true);
        } else {
         // Display error
            if (LineItemsSize == 0){
                string errmsg = 'At least one Line Item is required.';
                ApexPages.Message mymsg = new ApexPages.Message(ApexPages.Severity.Error, errmsg);
                ApexPages.addMessage(mymsg);
                return null;
            }
            if (newOrdersSize == 0){
                string errmsg = 'At least one Requested Date is required.';
                ApexPages.Message mymsg = new ApexPages.Message(ApexPages.Severity.Error, errmsg);
                ApexPages.addMessage(mymsg);
                return null;
            }
        }
        return originalOpenOrders;

    }

    public Boolean isContractType {get; private set;}

    public void updateOrderType() {
        debug('updateOrderType : '+reorderHeader.ReOrder_Type__c);
        isContractType = (reorderHeader.ReOrder_Type__c != null &&
                          reorderHeader.ReOrder_Type__c == 'Contract Billing');
    }

    public pagereference SortMasterList(){

        /*This checks to see if the same header was click two times in a row, if so
        it switches the order.*/
        boolean ascsortorder = true;
        if(prevSortField == sortField){
            ascsortOrder = false;
            prevSortField = '';
            sortimage = SORT_DESC_IMG;
        }else{
            ascsortOrder = true;
            prevSortField = sortField;
            sortimage = SORT_ASC_IMG;
        } 

       List<Open_Orders__c> templist = new list<Open_Orders__c>();
       Map<ID, boolean> selectedmap = new map<ID, boolean>();

       if(orderMasters != null && orderMasters.size() > 0) {
       for(Open_Order o:orderMasterList){
           templist.add(o.openorder);
           selectedmap.put(o.openorder.id, o.isselected);
       }
       Sort_Helper SH = new Sort_Helper();
       templist = SH.getSortedList(templist, SortField, ascsortorder);

       ordermasterlist.clear();
       for(integer i=0; i<templist.size(); i++){
           Open_Order open = new Open_Order();
           open.openorder = templist.get(i);
           open.isselected = selectedmap.get(open.openorder.id);
           orderMasterList.add(open);
       }
       templist.clear();
       }
       return null;
    }
    
     
 
}
global without sharing class Sample_Request_Functions {

    public static final String COLON = ':';
    public static final Integer PAGE_SIZE = 200;
    public static final Integer MAX_RECS = 1000;
    public static final Map<Id,String> ACCOUNT_RECTYPES = RecordType_Functions.RetrieveRecordTypeIdMap('Account');
    public static final Map<String, Schema.RecordTypeInfo> SAMP_RECTYPES = Sample_Request__c.sObjectType.getDescribe().getRecordTypeInfosByName();

    public static final Set<String> ACC_RECTYPES_FLINT = new Set<String>{'Flint Other Account'};

    // static flag to avoid recursion
    public static Boolean updated = false;

    public static final Set<String> STAT_SET1 = new Set<String>{'Request Completed', 'Rejected', 'Cancelled', 'Feedback Completed'};

    public static final String DC_AWT = '10';
    public static final String DC_APM = '20';
    public static final String DC_ACM = '40';
    public static final String DC_ASI = '50';
    public static final String DC_ASK = 'Y0';

    public static final String ALL    = 'ALL';
    public static final String NONE   = 'NONE';
    public static final String COMMA  = ',';
    public static final String DELIM  = ' - ';

    public static final String QRY1 = '' +
        'select Id, Name, Account__c, SAP_Order_Number__c, Status__c, ' +
        '      (select Name, Actual_Ship_Date__c, Date_Required_By__c, ' +
        '              Estimated_Arrival_Date__c, Estimated_Ship_Date__c, ' +
        '              Lot_Numbers__c, Open_Orders__c, ' +
        '              Sales_Order_Deliveries__c, Shipment_Completed__c, ' +
        '              SAP_Material_MSD2__c, Ship_From_Location__c, ' +
        '              Shipping_Carrier__c, Tracking_Air_Bill__c from Sample_Materials__r)' +
        '  from Sample_Request__c ';

    public static final String MAT_CATALOG_QRY1 = ''
        + 'select Id, Name, Out_of_Stock__c, '
        + '       Product_Code__c, Product_Name__c, Sample_Center__c, Sample_Size__c, Unit_Weight__c '
        + '  from Sample_Material_Catalog__c';

    public static final String MAT_CATALOG_OB1 = ' order by '
        + 'Product_Name__c, Product_Code__c';

    public static final String MAT_CATALOG_QRY2 = ''
        + 'select Id, Name, Container_Desc__c, Dist_Channel_Code__c, Dist_Channel_Material_Status__c,'
        + '       Sales_Org_Code__c, Sample_Material__c'
        + '  from Material_Sales_Data2__c';

    public static final String MAT_CATALOG_OB2 = ' order by Name, Dist_Channel_Code__c, Sales_Org_Code__c';

    public static final String MAX_LIMIT = ' limit ' + MAX_RECS;

    public static final Set<String> SAMPLE_CENTERS_CMC =
        Sample_Request_Config.getCMCSampleCenters();

    public static final Set<String> SAMPLE_CENTERS_OTH =
        Sample_Request_Config.getOthSampleCenters();

    public static final Set<String> SAMPLE_CENTERS_MSD =
        Sample_Request_Config.getMsdSampleCenters();

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Sample_Request_Functions : ' + s);
    }

    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }

    public static void doBeforeUpsert(List<Sample_Material_Catalog__c> mlist) {
        String k, d = ':';
        for (Sample_Material_Catalog__c m : mlist) {
            k = m.Sample_Center__c;
            if (!isNull(m.Product_Code__c)) {k += d + m.Product_Code__c;}
            if (!isNull(m.Sample_Size__c)) {k += d + m.Sample_Size__c;}
            m.Key__c = k;
        }
    }

    public static void doBeforeUpdate(Map<Id, Sample_Request__c> omap,
                                      Map<Id, Sample_Request__c> nmap) {
        if (updated) {return;}
        List<Sample_Request__c> alist = nmap.values();
        updateNotesSummary(alist);
    }

    public static void doAfterUpdate(Map<Id, Sample_Request__c> omap,
                                     Map<Id, Sample_Request__c> nmap) {
        if (updated) {return;} updated = true;
        updateMaterialStatus(omap, nmap);
    }

    private static void updateMaterialStatus(Map<Id, Sample_Request__c> omap,
                                             Map<Id, Sample_Request__c> nmap) {
        List<Sample_Material__c> alist = [select Id,
                 Record_Status__c, Sample_Request__c
            from Sample_Material__c where Sample_Request__c in :nmap.keySet()];
        if (alist == null || alist.isEmpty()) {return;}
        List<Sample_Material__c> blist = new List<Sample_Material__c>();
        String oldStatus, newStatus; Sample_Request__c oldReq, newReq;
        Set<String> aset = new Set<String>{'Approved'};
        for (Sample_Material__c a : alist) {
            oldReq = omap.get(a.Sample_Request__c);
            newReq = nmap.get(a.Sample_Request__c);
            if (oldReq == null || newReq == null) {continue;}
            oldStatus = oldReq.Status__c; newStatus = newReq.Status__c;
            if (!changed(oldStatus, newStatus)) {continue;}
            if (!aset.contains(newStatus)) {continue;}
            a.Record_Status__c = newStatus; blist.add(a);
        }
        if (!blist.isEmpty()) {update blist;}
    }

    private static Boolean changed(String a, String b) {
        return (a == null && b != null) ||
               (a != null && b == null) || (a != b);
    }

    private static void updateNotesSummary(List<Sample_Request__c> alist) {
        set<Id> aset = new set<Id>();
        List<Note> notes = new list<Note>();
        Map<Id, Sample_Request__c> amap = new Map<Id, Sample_Request__c>();
        for (Sample_Request__c a : alist) {
            if(a.Id != null){aset.add(a.Id); a.Notes_Summary__c = ''; amap.put(a.Id, a);}
        }
        notes = [select id, title, body, parentid, CreatedBy.Name
                   from Note where parentId in :aset order by ParentID, CreatedDate];

        for (Note n : notes){
            if (amap.containskey(n.ParentID)){
                amap.get(n.ParentID).Notes_Summary__c += n.title + '\n' + 'Created by: ' +
                                                         n.CreatedBy.Name + '\n' + n.body + '\n\n';
            }
        }

        for(Sample_Request__c a : alist){
            a.Notes_Summary__c = amap.get(a.Id).Notes_Summary__c;
        }
    }

    public static String Validate_SAP_Order_Number(String dataIn, Boolean required) {
        String result = '';

        if ((required == true) && ((dataIn == '') || (dataIn == null)))
            {result = 'The Order Number needs to be populated to Save';}

        return result;
    }

    WebService static void AssignMyselfasCoordinator(String SampleRequestId) {
        Sample_Request__c sampleRequest = [SELECT Id, Sample_Center__c, Sample_Coordinator__c
                                             FROM Sample_Request__c
                                            WHERE Id = :SampleRequestId];
        sampleRequest.Sample_Coordinator__c = UserInfo.getUserId();
        String NewRecordTypeId = RecordType_Functions.LookupRecordTypeId('Waiting for Order Creation','Sample_Request__c');
        sampleRequest.RecordTypeId = NewRecordTypeId;
        if (!isCMCSampleCenter(sampleRequest.Sample_Center__c)) {
            sampleRequest.Status__c = 'Waiting for Order Creation';
        }
        sampleRequest.On_Hold_Reason__c = '';
        sampleRequest.Cancellation_Reason__c = '';

        update sampleRequest;
    }

    WebService static void RemoveRequestfromHold(String SampleRequestId) {
        Sample_Request__c sampleRequest = [SELECT Id, Sample_Center__c, Sample_Coordinator__c
                                             FROM Sample_Request__c
                                            WHERE Id = :SampleRequestId];
        if (sampleRequest.Sample_Coordinator__c == UserInfo.getUserId()) {
            String NewRecordTypeId = RecordType_Functions.LookupRecordTypeId('Waiting for Order Creation','Sample_Request__c');
            sampleRequest.RecordTypeId = NewRecordTypeId;
            if (!isCMCSampleCenter(sampleRequest.Sample_Center__c)) {
                sampleRequest.Status__c = 'Waiting for Order Creation';
            }
            sampleRequest.On_Hold_Reason__c = '';
            sampleRequest.Cancellation_Reason__c = '';
            update sampleRequest;
        }
    }


    WebService static void Update_Approval_Process(String sampleRequestId) {
        Sample_Request__c sampleRequest = setApprovalFields(sampleRequestId);
        update sampleRequest;
    }

    public static Account getAccount(Id accId) {
        Account acc = [SELECT
        AccountNumber, Customer_Classification_ABC__c, Id, Inactive_Account__c, Name,
        Owner.Name, OwnerId, PAC_Industry_Segment__c, RecordType.Name, RecordTypeId,
        SALESOFFICE__C, SAP_City__c, SAP_Country__c, SAP_CSR__c, SAP_CSR_Email__c,
        SAP_Customer_Group__c, SAP_Customer_Group_1__c, SAP_Customer_Group_2__c,
        SAP_Customer_Group_3__c, SAP_Customer_Group_4__c, SAP_Customer_Group_5__c,
        SAP_Customer_Group_Desc__c, SAP_Customer_Number__c, SAP_DIST_CHANNEL_DESC__C,
        SAP_DISTCHANNEL__C, SAP_DIVISION_DESC__C, SAP_DIVISIONCODE__C, SAP_REGION__C,
        SAP_SALES_DISTRICT_DESC__C, SAP_SALES_GROUP_DESC__C, SAP_SALES_OFFICE__C,SAP_Sales_Org_Region_value__c,
        SAP_Sales_Org_Region_value1__c,
        SAP_SALES_OFFICE_DESC__C, SAP_SALES_ORG__C, SAP_SALESDISTRICT__C,
        SAP_SALESGROUP__C, SAP_State__c, SAP_Street__c, SAP_StreetSuppl1__c,
        SAP_StreetSuppl2__c, SAP_StreetSuppl3__c, SAP_Zip_Code__c
        FROM Account WHERE Id = :accId];
        return acc;
    }

    public static Sample_Request__c setApprovalFields(String sampleRequestId) {
        Sample_Request__c sampleRequest; List<Sample_Material__c> sampleMaterials;
        sampleRequest = Select_All_Fields(sampleRequestId);
        sampleMaterials = Sample_Material_Functions.Select_All_Fields_Based_on_Sample_Request_Ids(sampleRequestId);
        setApprovalFields(sampleRequest, sampleMaterials);
        return sampleRequest;
    }

    public static void setApprovalFields(Sample_Request__c sampleRequest,
                                         List<Sample_Material__c> sampleMaterials) {
        Account acc = getAccount(sampleRequest.Account__c);
        sampleRequest.Approval_Process__c = SampleRequestApprovalProcess_Functions.lookup_Approval_Process(sampleRequest, sampleMaterials);
        sampleRequest.New_Prospect_Account__c = Account_Functions.isNewProspect(sampleRequest.Account__c);
        //sampleRequest.Contains_Material_Greater_Than_5_Gallons__c = Sample_Material_Functions.List_Contains_Material_Greater_Then_5_Gallons(sampleMaterials);
        setRouteForApprovalFlags(acc, sampleRequest, sampleMaterials);
        sampleRequest.Parent_Account_Name__c = acc.Name;
        sampleRequest.Parent_Account_Owner__c = acc.OwnerId;
        sampleRequest.Account_Region__c = SAP_Sales_Org_Lookup_Functions.lookup_Region_from_Sales_Org(acc.SAP_Sales_Org__c);
    }

    public static void setRouteForApprovalFlags(Account acc, Sample_Request__c sampleRequest,
                                                List<Sample_Material__c> sampleMaterials) {
        sampleRequest.Route_for_Approval_1__c = false;
        sampleRequest.Route_for_Approval_2__c = false;
        sampleRequest.Route_for_Approval_3__c = false;
        if (sampleMaterials == null) {return;}
        if (isASI(acc)) {setApprovalFlags_ASI(acc, sampleRequest, sampleMaterials); return;} else
        if (isAWT(acc)) {setApprovalFlags_AWT(sampleRequest); return;}
        String accountRecordType = getAccountRecordType(acc), distChan = acc.SAP_DistChannel__c;
        Map<String, Map<String, Double>> umap = UOM_Conversion_Functions.getSampleQuantities(accountRecordType);
        Map<String, Map<String, Double>> cmap = Sample_Request_Config.getQuantityLimits(distChan);
        String msu; Double msq, usq; Map<String, Double> qmap;
        for (Sample_Material__c m : sampleMaterials) {
            msu = m.Sample_UOM__c; msq = m.Sample_Quantity__c;
            debug(m.Name + ' : uom = ' + msu + ' : ' + 'qty = ' + msq);
            if (umap.containsKey(msu)) {
                qmap = umap.get(msu);
                debug('qmap 1 : ' + qmap);
                UOM_Conversion_Functions.setRouteForApprovalFlags(sampleRequest, qmap, msq);
            } else
            if (cmap.containsKey(msu)) {
                qmap = cmap.get(msu);
                debug('qmap 2 : ' + qmap);
                Sample_Request_Config.setRouteForApprovalFlags(sampleRequest, qmap, msq);
            }
        }
    }

    private static void setApprovalFlags_ASI(Account acc, Sample_Request__c sampleRequest,
                                             List<Sample_Material__c> sampleMaterials) {
        Boolean b1 = false, b2 = false, b3 = false;
        //String vcpRating = acc.Customer_Classification_ABC__c;
        //b1 = !Sample_Request_Config.ASI_VCP_RATINGS.contains(vcpRating);
        b1 = isProspect(acc);
        b2 = sampleMaterials.size() > Sample_Request_Config.ASI_MATERIALS_LIMIT;
        for (Sample_Material__c m : sampleMaterials) {
            b3 = m.Special_Size__c || (m.Sample_Quantity__c > Sample_Request_Config.ASI_QUANTITY_LIMIT);
            if (b3) {break;}
        }
        sampleRequest.Route_for_Approval_1__c = (b1 || b2 || b3);
    }

    private static void setApprovalFlags_AWT(Sample_Request__c sampleRequest) {
        Boolean b1 = false, b2 = false, b3 = false;
        b1 = sampleRequest.Commercial_Order__c;
        debug('setApprovalFlags_AWT : b1 = ' + b1);
        sampleRequest.Route_for_Approval_1__c = (b1 || b2 || b3);
    }

    private static Boolean isProspect(Account acc) {
        return (acc != null && acc.AccountNumber != null &&
                acc.AccountNumber.startsWith('P'));
    }

  public static Sample_Request__c Select_All_Fields(Id sampleRequestId) {
    List<Id> sampleRequestIds = new List<Id>();
    sampleRequestIds.add(sampleRequestId);
    List<Sample_Request__c> sampleRequests = Select_All_Fields(sampleRequestIds);
    return sampleRequests[0];
  }

  public static List<Sample_Request__c> Select_All_Fields(List<Id> sampleRequestIds) {
        List<Sample_Request__c> sampleRequests = [SELECT
                                                        Id,
                                                        OwnerId,
                                                        Name,
                                                        RecordTypeId,
                                                        AD_Compound_Count__c,
                                                        AD_Compound__c,
                                                        AST_Sample__c,
                                                        Account_Region__c,
                                                        Account__c,
                                                        Additional_Comments__c,
                                                        Address_Line_1__c,
                                                        Address_Line_2__c,
                                                        Address_Line_3__c,
                                                        Address_Line_4__c,
                                                        Approval_Date__c,
                                                        Approval_Process__c,
                                                        Aqualon_Hazardous_Material__c,
                                                        Aquarius_Sample__c,
                                                        Ashland_Requestor__c,
                                                        Available_Actions__c,
                                                        CSR_Responsible_for_Order_Entry__c,
                                                        Cancellation_Reason__c,
                                                        Carrier_Type_for_Sample_Delivery__c,
                                                        City__c,
                                                        Contact_First_Name__c,
                                                        Contact_Last_Name__c,
                                                        Contact_Phone_Number__c,
                                                        Contact__c,
                                                        Contains_Material_Greater_Than_5_Gallons__c,
                                                        Cost_Center__c,
                                                        Country__c,
                                                        Create_Contact_Record_on_Account__c,
                                                        Customer_Requestor__c,
                                                        Customer_Ship_To_Contact__c,
                                                        Date_Required_By__c,
                                                        Dist_Channel_Desc__c,
                                                        Dist_Channel__c,
                                                        Division_Desc__c,
                                                        Division__c,
                                                        Estimated_Arrival_Date__c,
                                                        Estimated_Sample_Value__c,
                                                        Estimated_Ship_Date__c,
                                                        If_unknown_product_description__c,
                                                        Material_Summary__c,
                                                        Material__c,
                                                        Most_Valuable_Item_Value__c,
                                                        Nanjing_Material__c,
                                                        New_Prospect_Account__c,
                                                        Number_of_Items__c,
                                                        OEM__c,
                                                        Oak_Creek__c,
                                                        On_Hold_Reason__c,
                                                        Opportunity__c,
                                                        Parent_Account_Name__c,
                                                        Parent_Account_Owner__c,
                                                        Parent_Account_RecordType__c,
                                                        Postal_Zip_Code__c,
                                                        Potential_Annual_Volume_Quantifier__c,
                                                        Potential_Annual_Volume__c,
                                                        Product_Development__c,
                                                        Reason_for_Sample__c,
                                                        Region__c,
                                                        SAP_Order_Number__c,
                                                        SalesOffice__c,
                                                        Sales_District_Desc__c,
                                                        Sales_District__c,
                                                        Sales_Group_Desc__c,
                                                        Sales_Group__c,
                                                        Sales_Office_Desc__c,
                                                        Sales_Office__c,
                                                        Sales_Org__c,
                                                        Sample_Approver__c,
                                                        Sample_Coordinator__c,
                                                        Sample_Size_Other__c,
                                                        Sample_Size__c,
                                                        Shipment_Notification__c,
                                                        Ship_From_Location__c,
                                                        Ship_To_Address_Type__c,
                                                        State__c,
                                                        Status__c,
                                                        Tectyl_Product_Count__c,
                                                        Tectyl_Product__c,
                                                        Total_Potential_Annual_Value_of_Sample__c,
                                                        Total_Value_of_Sample__c,
                                                        Tracking_Air_Bill__c,
                                                        Update_All_Information__c
                                                        FROM Sample_Request__c WHERE Id IN :sampleRequestIds];
    return sampleRequests;
  }

    public static String getAccountRecordType(Account a) {
        if (a != null && ACCOUNT_RECTYPES.containsKey(a.RecordTypeId)) {
            return ACCOUNT_RECTYPES.get(a.RecordTypeId);
        }
        return null;
    }

    public static Boolean isASI(Account a) {
        if (a == null) {return false;}
        String dc = a.SAP_DistChannel__c;
        return (dc != null && dc == DC_ASI);
    }

    public static Boolean isASK(Account a) {
        if (a == null) {return false;}
        String dc = a.SAP_DistChannel__c;
        return (dc != null && dc == DC_ASK);
    }

    public static Boolean isAWT(Account a){
        if (a == null) {return false;}
        String dc = a.SAP_DistChannel__c;
        return (dc != null && dc == DC_AWT);
    }

    public static Boolean isACM(Account a) {
        if (a == null) {return false;}
        String dc = a.SAP_DistChannel__c;
        return (dc != null && dc == DC_ACM);
    }

    public static Boolean isAPM(Account a) {
        if (a == null) {return false;}
        String dc = a.SAP_DistChannel__c, rt = getAccountRecordType(a);
        Boolean b1 = (dc != null && dc == DC_APM),
                b2 = (rt != null && rt.startsWith('Performance Materials'));
        return (b1 || b2);
    }

    public static Boolean isFlint(Account a) {
        String rt = getAccountRecordType(a);
        return (rt != null && ACC_RECTYPES_FLINT.contains(rt));
    }

    public static List<Sample_Request__c> getSampleRequests(Map<String, Sales_Order_Deliveries__c> amap) {
        Set<String> aset = new Set<String>();
        for (String k : amap.keySet()) {
            debug('getSampleRequests : ' + k);
            String[] sa = k.split(COLON);
            if (sa != null && sa.size() > 0) {
                aset.add(sa[0]);
            }
        }
        if (aset.isEmpty()) {return null;}
        String q = QRY1 + ' where Name in :aset';
        List<Sample_Request__c> srs = Database.query(q);
        return srs;
    }

     @TestVisible private static Boolean skipToUpdate(Sample_Request__c sr) {
        Boolean b1, b2;
        b1 = sr.Sample_Materials__r == null || sr.Sample_Materials__r.isEmpty();
        b2 = sr.Status__c != null && STAT_SET1.contains(sr.Status__c);
        debug('skipToUpdate : sr = ' + sr);
        debug('skipToUpdate : b1 = ' + b1);
        debug('skipToUpdate : b2 = ' + b2);
        return (b1 || b2);
    }

    public static void updateDeliveriesData(Map<String, Sales_Order_Deliveries__c> amap) {
        List<Sample_Request__c> srs = getSampleRequests(amap);
        if ((srs == null || srs.isEmpty()) && !Test.isRunningTest()) {return;}
        Map<Id, Sample_Request__c> srmap = new Map<Id, Sample_Request__c>();
        Map<Id, Sample_Material__c> smmap = new Map<Id, Sample_Material__c>();
        Sales_Order_Deliveries__c od; String reqComp = 'Request Completed'; Integer shippedCount;
        String k, reqCompRecTypeId = RecordType_Functions.LookupRecordTypeId(reqComp,'Sample_Request__c');
        for (Sample_Request__c sr : srs) {
            if (skipToUpdate(sr)) {continue;}
            shippedCount = 0;
            for (Sample_Material__c sm : sr.Sample_Materials__r) {
                k = sr.Name + COLON + sm.SAP_Material_MSD2__c;
                debug('updateDeliveriesData2 : '+k);
                if (amap.containsKey(k)) {
                    od = amap.get(k);
                    debug(''+od);
                    if (isDataChanged1(od, sr)) {srmap.put(sr.Id, sr);}
                    if (isDataChanged2(od, sm)) {smmap.put(sm.Id, sm);}
                }
                if (sm.Shipment_Completed__c) {shippedCount++;}
            }
            debug('updateDeliveriesData3 : MaterialCount = ' + sr.Sample_Materials__r.size());
            debug('updateDeliveriesData4 : shippedCount = ' + shippedCount);
            if (shippedCount > 0 && shippedCount == sr.Sample_Materials__r.size()) {
                sr.RecordTypeId = reqCompRecTypeId; sr.Status__c = reqComp;
                srmap.put(sr.Id, sr);
                debug('updateDeliveriesData5 : sr.Status = ' + sr.Status__c);
            }
        }
        if (!srmap.isEmpty()) {
            debug(''+srmap.values());
            try {update srmap.values();} catch(Exception e) {}
        }
        if (!smmap.isEmpty()) {
            debug(''+smmap.values());
            try {update smmap.values();} catch(Exception e) {}
        }
    }

     @TestVisible private static Boolean isDataChanged1(Sales_Order_Deliveries__c od, Sample_Request__c sr) {
        Boolean b = false; String s, t;
        s = od.Sales_Order_Number__c; t = sr.SAP_Order_Number__c;
        if (s != null && !s.equals(t)) {sr.SAP_Order_Number__c = s; b = true;}
        return b;
    }

     @TestVisible private static Boolean isDataChanged2(Sales_Order_Deliveries__c od, Sample_Material__c sm) {
        Boolean b = false; String s, t; Date d1, d2;

        s = od.Id; t = sm.Sales_Order_Deliveries__c;
        if (s != null && !s.equals(t)) {sm.Sales_Order_Deliveries__c = s; b = true;}

        s = od.Carrier_PRO_Number__c; t = sm.Tracking_Air_Bill__c;
        if (s != null && !s.equals(t)) {sm.Tracking_Air_Bill__c = s; b = true;}

        s = 'UPS'; t = sm.Shipping_Carrier__c;
        if (t == null) {sm.Shipping_Carrier__c = s; b = true;}

        s = od.Plant_Name__c; t = sm.Ship_From_Location__c;
        if (s != null && !s.equals(t)) {sm.Ship_From_Location__c = s; b = true;}

        s = od.Material_Batch__c; t = sm.Lot_Numbers__c;
        if (s != null && !s.equals(t)) {sm.Lot_Numbers__c = s; b = true;}

        d1 = od.Actual_Goods_Issue_Date__c; d2 = sm.Actual_Ship_Date__c;
        if (d1 != null && (d2 == null ||
                          (d2 != null && !d1.isSameDay(d2)))) {sm.Actual_Ship_Date__c = d1; b = true;}

        d1 = od.Agreed_Ship_Date__c; d2 = sm.Estimated_Ship_Date__c;
        if (d1 != null && (d2 == null ||
                          (d2 != null && !d1.isSameDay(d2)))) {sm.Estimated_Ship_Date__c = d1; b = true;}

        d1 = od.Delivery_Date__c; d2 = sm.Estimated_Arrival_Date__c;
        if (d1 != null && (d2 == null ||
                          (d2 != null && !d1.isSameDay(d2)))) {sm.Estimated_Arrival_Date__c = d1; b = true;}

        d1 = od.Requested_Delivery_Date__c; d2 = sm.Date_Required_By__c;
        if (d1 != null && (d2 == null ||
                          (d2 != null && !d1.isSameDay(d2)))) {sm.Date_Required_By__c = d1; b = true;}

        if (!isNull(od.Shipment_Complete_Flag__c) &&
            'X'.equals(od.Shipment_Complete_Flag__c) &&
            !sm.Shipment_Completed__c) {sm.Shipment_Completed__c = true; b = true;}

        debug('SampleMaterial = ' + sm.Id + ' : Deliveries = ' + od.Id + ' : isDataChanged2 = ' + b);
        return b;
    }

    public static void updateOpenOrdersData(Map<String, Open_Orders__c> amap) {
        Set<String> aset = new Set<String>();
        for (String k : amap.keySet()) {
            //debug('updateOpenOrdersData1 : '+k);
            String[] sa = k.split(COLON);
            if (sa != null && sa.size() > 0) {
                aset.add(sa[0]);
            }
        }
        if (aset.isEmpty()) {return;}
        String q = QRY1 + ' where Name in :aset', k;
        List<Sample_Request__c> srs = Database.query(q);
        if (srs == null || srs.isEmpty()) {return;}
        Map<Id, Sample_Request__c> srmap = new Map<Id, Sample_Request__c>();
        Map<Id, Sample_Material__c> smmap = new Map<Id, Sample_Material__c>();
        Open_Orders__c oo; String reqComp = 'Request Completed'; Integer shippedCount;
        String reqCompRecTypeId = RecordType_Functions.LookupRecordTypeId(reqComp,'Sample_Request__c');
        for (Sample_Request__c sr : srs) {
            debug('SampleMaterials = ' + sr.Sample_Materials__r);
            if (skipToUpdate(sr)) {continue;}
            shippedCount = 0;
            for (Sample_Material__c sm : sr.Sample_Materials__r) {
                k = sr.Name + COLON + sm.SAP_Material_MSD2__c;
                //debug('updateOpenOrdersData2 : '+k);
                if (amap.containsKey(k)) {
                    oo = amap.get(k);
                    debug('OpenOrder = ' + oo);
                    if (isDataChanged1(oo, sr)) {srmap.put(sr.Id, sr);}
                    if (isDataChanged2(oo, sm)) {smmap.put(sm.Id, sm);}
                }
                if (sm.Actual_Ship_Date__c != null) {shippedCount++;}
            }
            //debug('updateOpenOrdersData3 : MaterialCount = ' + sr.Sample_Materials__r.size());
            //debug('updateOpenOrdersData4 : shippedCount = ' + shippedCount);
            if (shippedCount > 0 && shippedCount == sr.Sample_Materials__r.size()) {
                sr.RecordTypeId = reqCompRecTypeId; sr.Status__c = reqComp;
                srmap.put(sr.Id, sr);
                //debug('updateOpenOrdersData5 : sr.Status = ' + sr.Status__c);
            }
        }
        if (!srmap.isEmpty()) {
            //debug(''+srmap.values());
            try {update srmap.values();} catch(Exception e) {}
        }
        if (!smmap.isEmpty()) {
            //debug(''+smmap.values());
            try {update smmap.values();} catch(Exception e) {}
        }
    }

     @TestVisible private static Boolean isDataChanged1(Open_Orders__c oo, Sample_Request__c sr) {
        Boolean b = false; String s, t;
        s = oo.Sales_Order_Number__c; t = sr.SAP_Order_Number__c;
        if (s != null && !s.equals(t)) {sr.SAP_Order_Number__c = s; b = true;}
        return b;
    }
//Added by Sandhya 
   @TestVisible 
    private static Boolean isDataChanged2(Open_Orders__c oo, Sample_Material__c sm) {
        Boolean b = false; String s, t; Date d1, d2;

        s = oo.Id; t = sm.Open_Orders__c;
        if (s != null && !s.equals(t)) {sm.Open_Orders__c = s; b = true;}

        s = oo.Carrier_Tracking_Number__c; t = sm.Tracking_Air_Bill__c;
        if (s != null && !s.equals(t)) {sm.Tracking_Air_Bill__c = s; b = true;}

        s = 'UPS'; t = sm.Shipping_Carrier__c;
        if (t == null) {sm.Shipping_Carrier__c = s; b = true;}

        s = oo.Plant_Desc__c; t = sm.Ship_From_Location__c;
        if (s != null && !s.equals(t)) {sm.Ship_From_Location__c = s; b = true;}

        d1 = oo.Goods_Issue_Date2__c; d2 = sm.Actual_Ship_Date__c;
        if (d1 != null && (d2 == null ||
                          (d2 != null && !d1.isSameDay(d2)))) {sm.Actual_Ship_Date__c = d1; b = true;}

        debug('SampleMaterial = ' + sm.Id + ' : OpenOrders = ' + oo.Id + ' : isDataChanged2 = ' + b);
        return b;
    }

    public static Boolean isCMCSampleCenter(String sc) {
        return SAMPLE_CENTERS_CMC.contains(sc);
    }

    public static Boolean isOthSampleCenter(String sc) {
        return SAMPLE_CENTERS_OTH.contains(sc);
    }

    private static Boolean isAWTPartnerUser() {
        String p = User_Functions.getUserProfile(UserInfo.getUserId());
        return ('AWT - Distributor Partner Portal'.equals(p));
    }

     @TestVisible private static Set<String> getDistChanMatStats() {
        Set<String> aset = new Set<String>();
        PricingWizardSettings.Settings pws = PricingWizardSettings.retrieveSettings();
        String dcms = pws.awtDistChannelMaterialStatusFilter;
        if (String.isBlank(dcms)) {return aset;}
        dcms = dcms.replace('\'', '');
        for (String s : dcms.split(COMMA)) {s = s.trim();
            if (!String.isBlank(s)) {aset.add(s);}
        }
         system.debug('aset' +aset);
        return aset;
    }

     @TestVisible private static Set<String> getMatStats(String matStat) {
        Set<String> matStats = new Set<String>();
         set<String> matlistnew = new set<String>{'02','04','07','ZP'};
        if (String.isBlank(matStat)) {return matStats;}
        if (NONE.equals(matStat)) {
            matStats = new Set<String>{null,''};
        } else
        if (ALL.equals(matStat)) {
            matStats = new Set<String>{null,''};
            matStats.addAll(getDistChanMatStats());
            matStats.addall(matlistnew);
        } else {
            matStats = new Set<String>{matStat};
        }
        debug('matStats : ' + matStats);
         system.debug('matStats' +matStats);
         return matStats;
    }

    public static List<SelectOption> getDistChanMatStatOpts() {
        List<SelectOption> alist = new List<SelectOption>();
        alist.add(new SelectOption(ALL,  'All'));
        alist.add(new SelectOption(NONE, 'None'));
        List<String> dcmsList = new List<String>(); String v;
        Set<String> aset = getDistChanMatStats(); if (!aset.isEmpty()) {dcmsList.addAll(aset);}
        Map<String, String> dcmsMap = Material_Sales_Data_Functions.getDistMatStatusMap(dcmsList);
        for (String s : dcmsList) {
            if (!dcmsMap.containsKey(s)) {continue;}
            v = dcmsMap.get(s) + DELIM + s; alist.add(new SelectOption(s, v));
        }
        return alist;
    }

    private static String getMatCatalogQry(Sample_Request__c sreq, Account acc,
                                           String matName, String matStat) {
                                               System.debug('matStat' +matStat);
        String sampleCenter = sreq.Sample_Center__c;
        if (isOthSampleCenter(sampleCenter)) {return null;}
        String salesOrg = '', distChan = '', qry = '', orderBy = '';
        if (acc != null) {distChan = acc.SAP_DistChannel__c;
                          salesOrg = acc.SAP_Sales_Org__c;
            if (!isNull(acc.Id) && (isNull(distChan) || isNull(salesOrg))) {return null;}
        }
        if (SAMPLE_CENTERS_MSD.contains(sampleCenter) || sreq.No_Charge_Order__c) {
            qry = MAT_CATALOG_QRY2; orderBy = MAT_CATALOG_OB2;
            qry += ' where Active_Material__c = \'Y\'';
            if (!isNull(distChan)) {qry += ' and Dist_Channel_Code__c = \'' + distChan + '\'';}
            if (!isNull(salesOrg)) {qry += ' and Sales_Org_Code__c = \'' + salesOrg + '\'';}
            if (sreq.No_Charge_Order__c) {
                if (isAWTPartnerUser()) {qry += ' and PH5__c = \'B00\'';} //StreamLink
                if (!sreq.Commercial_Order__c) {
                    qry += ' and Sample_Material__c = \'X\'';
                } else {
                    qry += ' and Sample_Material__c != \'X\'';
                }
            } else {
                qry += ' and Sample_Material__c = \'X\'';
                if (isASI(acc)) {
                    if (Sample_Request_Config.SC_PLC.equals(sampleCenter)) {
                        qry += ' and PH3__c  = \'053\'';} else {
                        qry += ' and PH3__c != \'053\'';}
                }
            }
            if (!isNull(matName)) {qry += ' and Name like \'%' + matName + '%\'';}
            if (matStat != null) { qry += ' and DistChan_MatStat_Code__c in :matStats';}
            
        }else {
            qry = MAT_CATALOG_QRY1; orderBy = MAT_CATALOG_OB1;
            qry += ' where Sample_Center__c = \'' + sampleCenter + '\'';
            //qry += '   and Out_of_Stock__c = false';
            if (!isNull(matName)) {
                qry += ' and (Product_Name__c like \'%' + matName + '%\'';
                qry += '  or  Product_Code__c like \'%' + matName + '%\')';
            }
        }
        qry += orderBy + MAX_LIMIT; debug('getMatCatalogQry : ' + qry);
        System.debug('qry' +qry); 
                                               return qry;
                                              
    }

    public static PaginationController getMatCatalogPC(Sample_Request__c sreq, Account acc) {
        return getMatCatalogPC(sreq, acc, PAGE_SIZE);
    }

    public static PaginationController getMatCatalogPC(Sample_Request__c sreq,
        Account acc, Integer pageSize) {
        return getMatCatalogPC(sreq, acc, '', pageSize);
    }

    public static PaginationController getMatCatalogPC(Sample_Request__c sreq,
        Account acc, String matName) {
        return getMatCatalogPC(sreq, acc, matName, PAGE_SIZE);
    }

    public static PaginationController getMatCatalogPC(Sample_Request__c sreq,
        Account acc, String matName, Integer pageSize) {
        return getMatCatalogPC(sreq, acc, matName, '', pageSize);
    }

    public static PaginationController getMatCatalogPC(Sample_Request__c sreq,
        Account acc, String matName, String matStat, Integer pageSize) {
            set<String> matlistnew = new set<String>{'01','02','03','04','05','06','07'};
        String qry = getMatCatalogQry(sreq, acc, matName, matStat);
        if (isNull(qry)) {return null;}
        Set<String> matStats = getMatStats(matStat);
            
           matStats.addall(matlistnew); 
         
        Database.Querylocator ql; PaginationController pc = null;
            
        try {
            ql = Database.getQueryLocator(qry);
            pc = new PaginationController(ql, pageSize);
        } catch(Exception e) {debug('getMatCatalogPC : ' + e.getMessage());}
        return pc;
    }
        @AuraEnabled
        public static void AssignMyselfasCoordinatorLTD(String SampleRequestId) {
        Sample_Request__c sampleRequest = [SELECT Id, Sample_Center__c, Sample_Coordinator__c
                                             FROM Sample_Request__c
                                            WHERE Id = :SampleRequestId];
        sampleRequest.Sample_Coordinator__c = UserInfo.getUserId();
        String NewRecordTypeId = RecordType_Functions.LookupRecordTypeId('Waiting for Order Creation','Sample_Request__c');
        sampleRequest.RecordTypeId = NewRecordTypeId;
        if (!isCMCSampleCenter(sampleRequest.Sample_Center__c)) {
            sampleRequest.Status__c = 'Waiting for Order Creation';
        }
        sampleRequest.On_Hold_Reason__c = '';
        sampleRequest.Cancellation_Reason__c = '';

        update sampleRequest;
    }
     @AuraEnabled
     public static void Update_Approval_ProcessLTD(String sampleRequestId) {
        Sample_Request__c sampleRequest = setApprovalFields(sampleRequestId);
        update sampleRequest;
    }
    @AuraEnabled
    public static void RemoveRequestfromHoldLTD(String SampleRequestId) {
        Sample_Request__c sampleRequest = [SELECT Id, Sample_Center__c, Sample_Coordinator__c
                                             FROM Sample_Request__c
                                            WHERE Id = :SampleRequestId];
        if (sampleRequest.Sample_Coordinator__c == UserInfo.getUserId()) {
            String NewRecordTypeId = RecordType_Functions.LookupRecordTypeId('Waiting for Order Creation','Sample_Request__c');
            sampleRequest.RecordTypeId = NewRecordTypeId;
            if (!isCMCSampleCenter(sampleRequest.Sample_Center__c)) {
                sampleRequest.Status__c = 'Waiting for Order Creation';
            }
            sampleRequest.On_Hold_Reason__c = '';
            sampleRequest.Cancellation_Reason__c = '';
            update sampleRequest;
        }
    }

}
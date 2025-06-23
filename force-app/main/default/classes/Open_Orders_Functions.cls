public class Open_Orders_Functions {

    private static final String COLON = ':';
    private static final String DELIM = ' - ';
    private static final Time ZERO_TIME = Time.newInstance(0,0,0,0);
    private static final String SAMP_REQ_NAME1 = 'SAMP-';

    public static final String QRY1 = 'select Id, Name, '+
        'Carrier_Tracking_Number__c, Customer_PO_Number__c, ' +
        'Goods_Issue_Date2__c, Material__c, Plant_Desc__c, ' +
        'Sales_Order_Number__c, SFDC_Sample_Request_Number__c ' +
        'from Open_Orders__c';

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Open_Orders_Functions : ' + s);
    }

    public static void processBeforeUpsert(List<Open_Orders__c> olist) {
        updateFields(olist);
    }

    public static void processReordersBeforeUpsert(List<Reorder__c> olist) {
        updateReorderFields(olist);
    }

    public static void doAfterUpdate(List<Open_Orders__c> olist) {
        //emailOnCreditHoldRelease(olist);
    }

    public static void doBeforeInsert(List<Open_Orders__c> olist) {
        updateFields(olist);
    }

    public static void doBeforeUpdate(Map<Id, Open_Orders__c> omap,
                                      Map<Id, Open_Orders__c> nmap) {
        List<Open_Orders__c> nlist = nmap.values();
        updateFields(nlist);
        List<Open_Orders__c> ulist = new List<Open_Orders__c>();
        Date tdate = Date.today(); Open_Orders__c o;
        for (Open_Orders__c n : nlist) {
            o = omap.get(n.Id);
            if (dateChanged(o.Expected_Ship_Date2__c, n.Expected_Ship_Date2__c)) {
                n.Prev_Expected_Ship_Date__c = o.Expected_Ship_Date2__c;
                n.Expected_Ship_Date_LastChanged__c = tdate;
            }
            if (dateChanged(o.Delivery_Date2__c, n.Delivery_Date2__c)) {
                n.Prev_Planned_Delivery_Date__c = o.Delivery_Date2__c;
                n.Planned_Delivery_Date_LastChanged__c = tdate;
            }
        }
    }

    private static Boolean dateChanged(Date odate, Date ndate) {
        return (odate != null && ndate != null && odate != ndate);
    }

    private static void updateFields(List<Open_Orders__c> olist) {
        Map<Id, Material_Sales_Data2__c> mmap = getMaterialsMap(olist);
        Map<String, String> umap = Material_UOM_Functions.getExternalUOMCodes();
        Set<String> snums = new Set<String>(); Set<Id> oids = new Set<Id>();
        for (Open_Orders__c o : olist) {
            oids.add(o.Id);
            if (!String.isBlank(o.Seller_Number__c)) {snums.add(o.Seller_Number__c);}
            updateCurrencyCode(o);
            updateMaterialFields(o, mmap, umap);
            updateDateFields(o);
        }
        updateSampleRequests(olist); updateSellers(olist, snums);
        updateAttachmentCounts(olist, oids);
    }

    private static void updateCurrencyCode(Open_Orders__c o) {
        if (!isNull(o.Gross_Product_Value_Currency__c)) {
            try {o.CurrencyIsoCode = o.Gross_Product_Value_Currency__c.substring(0,3);}
            catch(Exception e){debug(e.getMessage());}
        }
    }

    private static void updateMaterialFields(Open_Orders__c o,
                                             Map<Id, Material_Sales_Data2__c> mmap,
                                             Map<String, String> umap) {
        if (mmap != null && mmap.containsKey(o.Material__c)) {
            Material_Sales_Data2__c m = mmap.get(o.Material__c);
            Material_General_Data2__c g = m.Material_General_Data__r;
            Product_Hierarchy2__c p = m.Product_Hierarchy__r;
            Material_UOM2__c u = m.Sales_UOM__r;
            if (g != null) {
                o.Material_BaseCode_Desc__c = g.Material_Base_Code_Desc__c;
                o.Material_Container_Desc__c = g.Material_Container_Desc__c;
            }
            if (p != null) {
                o.PH1_Division__c = p.PH1_Division__c + DELIM + p.PH1__c;
                o.PH2_Line__c = p.PH2_Line__c + DELIM + p.PH2__c;
                o.PH3_Group__c = p.PH3_Group__c + DELIM + p.PH3__c;
                o.PH4_Supplier__c = p.PH4_Supplier__c + DELIM + p.PH4__c;
                o.PH5_Family__c = p.PH5_Family__c + DELIM + p.PH5__c;
                o.PH6_Segment__c = p.PH6_Segment__c + DELIM + p.PH6__c;
                o.PH7_SubSegment__c = p.PH7_SubSegment__c + DELIM + p.PH7__c;
            }
            if (u != null && u.Alternative_UOM__c != null &&
                umap.containsKey(u.Alternative_UOM__c)) {
                o.Sales_UOM__c = umap.get(u.Alternative_UOM__c);
            }
        }
    }

    private static void updateDateFields(Open_Orders__c o) {
        o.Agreed_Ship_Date2__c = getDate(o.Agreed_Ship_Date__c);
        o.Created_Date2__c = getDate(o.Created_Date__c);
        o.Expected_Ship_Date2__c = getDate(o.Expected_Ship_Date__c);
        o.Goods_Issue_Date2__c = getDate(o.Goods_Issue_Date__c);
        o.Requested_Delivery_Date2__c = getDate(o.Requested_Delivery_Date__c);
        o.Delivery_Date2__c = getDate(o.Delivery_Date__c);
    }

    private static Date getDate(String s) {
        if (!isNull(s) && s.length() > 9) {
            try {
                Integer y = Integer.valueOf(s.substring(0, 4));
                Integer m = Integer.valueOf(s.substring(5, 7));
                Integer d = Integer.valueOf(s.substring(8, 10));
                if (y > 1970 && y < 2170 && m > 0 && m < 13) {
                    return Date.newInstance(y, m, d);
                }
            } catch(Exception e) {}
        }
        return null;
    }

    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }

    private static Map<Id, Material_Sales_Data2__c> getMaterialsMap(List<Open_Orders__c> olist) {
        Map<Id, Material_Sales_Data2__c> mmap = new Map<Id, Material_Sales_Data2__c>();
        Set<id> mset = new Set<id>();
        for (Open_Orders__c o : olist) {
            mset.add(o.Material__c);
        }
        mmap = Material_Sales_Data_Functions.getMaterialSalesData2Map(mset);
        return mmap;
    }

    private static void updateReorderFields(List<Reorder__c> olist) {
        for (Reorder__c o : olist) {
            updateDateFields(o);
        }
    }

    private static void updateDateFields(Reorder__c o) {
        o.Expected_Ship_Date2__c = getDateText(o.Expected_Ship_Date__c);
        o.Requested_Delivery_Date2__c = getDateText(o.Requested_Delivery_Date__c);
    }

    private static String getDateText(Date d) {
        String s = '';
        if (d != null) {
            DateTime dt = DateTime.newInstance(d, ZERO_TIME);
            s = dt.format('MMMM dd, yyyy');
        }
        //System.debug(s);
        return s;
    }

    private static Boolean sampleRequestRelated(Open_Orders__c o) {
        Boolean b = true;
        String s = o.SFDC_Sample_Request_Number__c;
        b = !isNull(s) && s.startsWith(SAMP_REQ_NAME1) &&
                          o.Goods_Issue_Date2__c != null;
        return b;
    }

    public static void updateSampleRequests(List<Open_Orders__c> alist) {
        List<Open_Orders__c> blist = new List<Open_Orders__c>();
        for (Open_Orders__c o : alist) {
            if (sampleRequestRelated(o)) {blist.add(o);}
        }
        if (blist.isEmpty()) {return;}
        Map<String, Open_Orders__c> amap = new Map<String, Open_Orders__c>();
        //String cn = 'Open_Orders_Functions', mn = 'updateSampleRequests';
        String k;
        for (Open_Orders__c o : blist) {
            k = o.SFDC_Sample_Request_Number__c + COLON + o.Material__c;
            debug(k);
            //DebugLog_Functions.logMessage(cn, mn, k);
            amap.put(k, o);
        }
        Sample_Request_Functions.updateOpenOrdersData(amap);
    }

    private static void updateSellers(List<Open_Orders__c> olist, Set<String> snums) {
        if (snums.isEmpty() || olist.isEmpty()) {return;} User u; String s;
        Map<String, User> smap = SAP_Seller_Functions.getSellerMap(snums);
        for (Open_Orders__c o : olist) {
            s = o.Seller_Number__c;
            if (String.isBlank(s)) {continue;}
            if (smap.containsKey(s)) {u = smap.get(s);
                try {o.Seller__c = u.Id;} catch (Exception e) {}
            }
        }
    }

    private static void updateAttachmentCounts(List<Open_Orders__c> olist, Set<Id> oids) {
        Map<Id, Integer> amap = new Map<Id, Integer>(),
                        nmap = new Map<Id, Integer>();
        AggregateResult[] ars; String oid;
        ars = [select ParentId, count(Id) cnt
                 from Attachment where ParentId in :oids
                group by rollup(ParentId)];
        setAttachCountMap(ars, amap);
        ars = [select ParentId, count(Id) cnt
                from Note where ParentId in :oids
                group by rollup(ParentId)];
        setAttachCountMap(ars, nmap);
        for (Open_Orders__c o : olist) {
            oid = o.Id;
            if (amap.containsKey(oid)) {o.Attachments_Count__c = amap.get(oid);}
            if (nmap.containsKey(oid)) {o.Notes_Count__c = nmap.get(oid);}
        }
    }

    private static void setAttachCountMap(AggregateResult[] ars, Map<Id, Integer> amap) {
        if (ars == null || ars.isEmpty()) {return;}
        Id i; Integer n;
        for (AggregateResult ar : ars) {
            i = (Id)ar.get('ParentId');
            if (i != null) {
                n = (Integer)ar.get('cnt');
                amap.put(i, n);
            }
        }
    }

    @TestVisible
    private static void emailOnCreditHoldRelease(List<Open_Orders__c> olist) {

        Set<Id> OrderIds = new Set<Id>();
        String OrderNumber, ShiptoDesc, OrderQty, ReqDeliveryDate, PlanDeliveryDate,
               AcctNumber, accOwnerEmail, sellerEmail;

        for(Open_Orders__c c : olist) {
            if(c.Credit_Release_Status_Code__c != 'B' && c.Seller__c != null) {OrderIds.add(c.id);}
        }

        List<Open_orders__c> ord = [Select id, Delivery_Date2__c, Requested_Delivery_Date2__c,
                                           Sales_Order_Number__c,
                                           Seller__c, Seller__r.Email,
                                           Shipto__c, Shipto__r.AccountNumber,
                                           Shipto__r.OwnerId, Shipto__r.Owner.Email,
                                           ShipTo_Desc__c
                                      from Open_orders__c where id IN :OrderIds];

        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail;

        for(Open_orders__c o : ord) {

            OrderNumber = o.Sales_Order_Number__c;
            ShiptoDesc = o.ShipTo_Desc__c;
            AcctNumber = o.Shipto__r.AccountNumber;

            accOwnerEmail = o.ShipTo__r.Owner.Email;
            sellerEmail = o.Seller__r.Email;
            if (sellerEmail == null) {sellerEmail = accOwnerEmail;}

            if(O.Requested_Delivery_Date2__c != null) {
                ReqDeliveryDate = O.Requested_Delivery_Date2__c.format();
            } else {
                ReqDeliveryDate = 'No Requested Delivery date';
            }

            if(O.Delivery_Date2__c != null) {
                PlanDeliveryDate = O.Delivery_Date2__c.format();
            } else {
                PlanDeliveryDate = 'No Planned Delivery date';
            }

            mail = new Messaging.SingleEmailMessage();

            if (selleremail == accOwnerEmail) {
                mail.setToAddresses(new String[] {sellerEmail});
            } else {
                mail.setToAddresses(new String[] {accOwnerEmail, sellerEmail});
            }

            mail.setSenderDisplayName('Credit Hold Information Email');
            mail.setSubject('RELEASED FROM CREDIT HOLD ' + ' Order Number  : ' + OrderNumber + ';' + ' Account Name : ' + ShiptoDesc);
            mail.setPlainTextBody('The following order has been released from credit hold:' + '\r\n' +
                                  'Order Number : ' + OrderNumber + '\r\n' +
                                  'Account Number : ' + acctNumber + '\r\n'+
                                  'Account Name : '+ ShiptoDesc + '\r\n' +
                                  'Requested Delivery date : '+ ReqDeliveryDate +  '\r\n'+
                                  'Planned Delivery date : ' + PlanDeliveryDate +'\r\n');
            messages.add(mail);
        }

        try {
            if (!Test.isRunningTest()) {Messaging.sendEmail(messages);}
        } catch (Exception e) {debug(e.getMessage());}
    }

}
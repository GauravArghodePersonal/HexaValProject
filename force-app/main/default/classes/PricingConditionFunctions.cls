global class PricingConditionFunctions {

    public static final String DELIM = '-';
    public static final String TAB = '\t';
    public static final String NL = '\n';
    public static final String YES = 'Yes';
    public static final String NO = 'No';
    public static final String OBJECT_NAME = 'Pricing_Condition__c';
    public static final String ACTIVE = 'Active';
    public static final String APPROVED = 'Approved,Not Yet Active';
    public static final String CANCELLED = 'Cancelled';
    public static final String DRAFT = 'Draft';
    public static final String EXPIRED = 'Expired';
    public static final String SUBMITTED = 'In Approval Process';
    public static final String SOLDTO = Account_Partner_Functions.ACC_TYPE_SOLDTO;
    private static Map<Id,String> ACCOUNT_RECTYPES = null;

    public static final Set<String> DLVRY_PGM_EXCL_PH3_SET = new Set<String>{'062'};
    public static final Set<String> DLVRY_PGM_EXCL_PLNT_SET = new Set<String>{'1223','2136'};

    // static flag to avoid recursion
    public static Boolean processBeforeUpdate = true;

    public static Boolean notUpdated = true;

    public static Integer MAX_REC_LIMIT = 10000;

    public static final String DIST_CHANNEL_AHWT = '10';
    public static final String DIST_CHANNEL_AAFI = '50';
    public static final String DISTRIBUTORS = 'DISTRIBUTORS';
    public static final String DVSN_STREAM_LINK = '13';
    public static final Set<String> DVSNS_AHWT = new Set<String>{'11','12','13','14'};

    public static final String SALES_OFFICE_SET = 'SALES_OFFICE';

    public static final String SELECT_QRY_1 = 'select'
        + ' Id, Name, CurrencyIsoCode,'
        + ' LastModifiedBy.Id, LastModifiedBy.Name, LastModifiedBy.Email,'
        + ' Account__r.AccountNumber, Account__r.CurrencyIsoCode, Account__r.Id,'
        + ' Account__r.Inactive_Account__c, Account__r.Multi_Level_Industry__c, Account__r.Name,'
        + ' Account__r.Owner.Id, Account__r.Owner.Email, Account__r.Owner.Name,'
        + ' Account__r.RecordTypeId, Account__r.Sales_Area__c, Account__r.SAP_Customer_Group_1_Desc__c,'
        + ' Account__r.SAP_Customer_Number__c, Account__r.SAP_DivisionCode__c, Account__r.SAP_Payment_Terms__c,'
        + ' Account__r.SAP_Seller_Name__c, Account__r.SAP_Seller__c, Account_Country__c,'
        + ' Account__r.SAP_Customer_Price_Group_Desc__c,'
        + ' Account_Level_Condition_Applies_To__c,'
        + ' Account_Owner__r.Ashland_Employee_Number__c, Account_Owner__r.Id,'
        + ' Account_Owner__r.Name, Account_Owner__r.SAP_Cust_Num__c,'
        + ' Account_Address__c, Account_Owner_Notified__c,'
        + ' Account_Sales_Group__c, Account_Sales_Office__c, Account_Type__c,'
        + ' Active__c, Approval_Process_Name__c, Approver_Comments__c, Base_Price__c, Base_Price_Text__c,'
        + ' Cloned_From__c, COGS__c, Comments__c, Comments_Exist__c, Condition_Key__c, Consignment__c, '
        + ' Contract__c, Contract_Duration__c, CPI_INCO_Term_Code__c, CPI_INCO_Term_to_be_Updated__c,'
        + ' Created_Date__c, Current_State__c, Customer_Group1_Desc__c, Customer_Group_Summary__c,'
        + ' Customer_Material_Lead_Time__c, Customer_Material_Number__c, Customer_Product_Info__c,'
        + ' Date_Entered_in_SAP__c, Date_Pricing_Condition_Approved__c, Date_Pricing_Submitted_for_Approval__c,'
        + ' Delivery_Program_Cost__c, Discount_Condition_Table_Desc__c,'
        + ' Discount_Condition_Table__c, Discount_on_Invoice_Text__c,'
        + ' Discount_Percent__c, DistChan_Code__c, Dist_Channel_Code__c, Division_Code__c,'
        + ' EndUse_Customer__c, EndUse_Customer__r.AccountNumber,'
        + ' EndUse_Customer_Desc__c, Entered_in_SAP__c, Equipment_On_Invoice__c, Equipment_on_Invoice_Text__c,'
        + ' Equipment_Upcharge_Table_Desc__c, Equipment_Upcharge_Table__c,'
        + ' Equipment_Upcharge_Text__c, Equipment_Up_Charge__c, Exported_to_IDoc__c,'
        + ' Family_Summary__c, Fleet_Cost__c, Floor_Price__c, Forecasted_Annual_Volume__c,'
        + ' Freight__c, Freight_Cost__c, Freight_Mark_Up__c, Freight_Term__c, Freight_Up_Charge__c,'
        + ' FCL_Invoice_Price__c, Generated_From_Increase__c, GP_on_Floor_Price__c, GP_on_Market_Price__c,'
        + ' GP_Percent_on_Floor_Price__c, GP_Percent_on_Market_Price__c,'
        + ' Gross_Profit__c, Gross_Profit_Percent__c, Has_On_Invoice_Discount__c, Has_3rd_Party_Shipping_Plant__c,'
        + ' Has_Rebate__c, INCO_Term_Code__c, INCO_Term_Name__c, Inco_Terms__c,'
        + ' Invoice_Price__c, Invoice_Price_Text__c, Item_Usage__c,'
        + ' Lead_Time__c, Level_1_Price_Approver__c,'
        /*+ ' LISD_Customer_Group__c, LISD_Customer_Group_Desc__c,'*/
        /*+ ' LISD_EndUse_Customer__c, LISD_EndUse_Customer_Desc__c,'*/
        /*+ ' LISD_Sales_District__c, LISD_Sales_District_Desc__c,'*/
       /* + ' LISD_Sales_Group__c, LISD_Sales_Group_Desc__c,'
        + ' LISD_Sales_Office__c, LISD_Sales_Office_Desc__c,'
        + ' LISD_Seller__c, LISD_Seller_Name__c,'*/
       /* + ' LISD_Seller__r.Id, LISD_Seller__r.Email, LISD_Seller__r.Name,'*/
        + ' Market_Price__c, Market_Price_Book_Entry__c, Market_Pricing_Adjustment_Value__c, Market_Pricing_Type__c,'
        + ' Material2__r.Material_Base_Code_Desc__c,'
        + ' Material2__r.Dist_Channel_Code__c, Material2__r.Id,'
        + ' Material2__r.Material_Desc__c, Material2__r.Material_Number__c,'
        + ' Material2__r.Sales_Org_Code__c, Material_Name__c, Material_Number__c,'
        + ' Minimum_Order_Quantity__c, Minimum_Order_Quantity_UOM__c, Minimum_Volume__c,'
        + ' Opportunity__c, OTC__c, Other_Up_Charge__c, Other_Up_Charge_Comments__c,'
        + ' PAC_Industry_Segment__c, PAC_Industry_Segment_Name__c,'
        + ' Packaging__c, Payment_Terms__c, Payment_Term_Explanation__c,'
        + ' PH3_Description__c, PH3_Product_Group__c, PH4_Description__c, PH4_Product_Supplier__c,'
        + ' PH5_Description__c, PH5_Product_Family__c,'
        + ' PH6_Description__c, PH6_Product_Segment__c, PH7_Description__c, PH7_Product_SubSegment__c,'
        + ' Plant_Address__c, Plant_Code__c, Plant_Name__c, Plant_Notes__c,'
        + ' Prev_Invoice_Price__c, Prev_Invoice_Price_Text__c,'
        + ' Prev_Selling_Price__c, Prev_Selling_Price_Text__c,'
        + ' Prev_Selling_Price_with_Upcharges__c, Prev_Selling_Price_with_Upcharges_Text__c,'
        + ' Previously_Discussed_with_BM__c, Price_Protection__c,'
        + ' Price_Book_Entry_Scaled_Pricing__c, Price_Book_Entry__c,'
        + ' Price_Book_Entry__r.Price_Book_Number__c, Price_Book_Entry__r.Price_Book__c,'
        + ' Pricing_Scales__c, Primary_Indicator__c, Product_Hierarchy__c,'
        + ' Product_Hierarchy__r.Product_Hierarchy5__r.Product_Hierarchy_Description__c,'
        + ' Product_Hierarchy__r.Product_Hierarchy6__r.Product_Hierarchy_Description__c,'
        + ' Product_Hierarchy__r.Product_Hierarchy7__r.Product_Hierarchy_Description__c,'
        + ' Product_Support_Cost__c, Program_Cost__c, Program_Type__c,'
        + ' Rebate_Amount__c, Relabel__c, Record_Status__c, Region_Summary__c,'
        + ' Rejection_Comments__c, Request_Reason__c, Request_Reason_Desc__c,'
        + ' Route_Price_for_Approval_1__c, Route_Price_for_Approval_2__c,'
        + ' Route_Price_for_Approval_3__c, Route_Price_for_Approval_4__c,'
        + ' Route_Price_for_Approval_5__c, Route_Price_for_Approval_6__c,'
        + ' SalesOrg_Code__c, Sales_Org_Summary__c, SAP_CSR_Email__c,'
        + ' SAP_INCO_Term__c, SAP_Plant__c, SAP_Plant_Locked__c,'
        + ' SAP_Pricing_Table__c, SAP_Pricing_Table_Desc__c,'
        + ' Selling_Price__c, Selling_Price_Text__c, Selling_UOM__c,'
        + ' Send_Notification_1__c, Send_Notification_2__c,'
        + ' Service__c, Shipment_Weight__c, Shipment_Weight_UOM__c, Shipment_Weight_UOM_Code__c,'
        + ' Shipping_Plant__c, SoldTo_Customer__c, Streamlink_EU_Payment_Terms__c,'
        + ' Surcharge_for_Distributors__c, Target_Gross_Profit_Percent__c,'
        + ' Used_Scaled_Pricing__c, Valid_From_Date__c, Valid_To_Date__c, Volume_UOM__c, VAT_Percent__c,'
        + '(select Invoice_Price__c, Maximum_Volume__c, Minimum_Volume__c,'
        + '        Quantity_Surcharge__c, Scaled_Selling_Price__c,'
        + '        Selling_Price__c, Selling_Price_with_Upcharges__c,'
        + '        Selling_UOM__c, Surcharge__c, Volume_UOM__c'
        + '   from Pricing_Condition_Scaled_Pricing__r'
        + '  order by Minimum_Volume__c'
        + '),'
        + '(select Comment__c, Competitor__c, Competitor_Inco_Term__c,'
        + '        Competitor_Price__c, Competitor_UOM__c,'
        + '        Competitor_Volume__c, Pricing_Condition__c'
        + '   from Pricing_to_Competitor__r'
        + ')'
        + ' from Pricing_Condition__c ';

    public static final String ORDER_BY_1 = ' order by Account__r.Name, Material2__r.Material_Desc__c, Valid_From_Date__c';

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>> ' + s);
    }

    private static String getString(Decimal d, String s) {
        return (d != null ? d.toPlainString() : s);
    }

    public static void processBeforeUpdate(List<Pricing_Condition__c> pca) {
        if (processBeforeUpdate) {
            processBeforeUpdate = false;
            //debug(' processBeforeUpdate begins');
            if (notUpdated) {doPricingConditionUpdates(pca);}
            deactivatePricingConditions(pca); sendNotifications(pca);
            //debug(' processBeforeUpdate ends');
        }
    }

    public static void processBeforeInsert(List<Pricing_Condition__c> pca) {
        //debug(' processBeforeInsert begins');
        if (notUpdated) {doPricingConditionUpdates(pca, true);}
        //debug(' processBeforeInsert ends');
    }

    public static void processAfterInsert(List<Pricing_Condition__c> pca) {
        // do nothing for now
    }

    public static void processAfterUpdate(List<Pricing_Condition__c> pca) {
        Set<String> pcids = getPricingConditionIds(pca);
        PricingConditionIDocFunctions.upsertIDocs(pcids);
    }

    public static void processAfterUpsert(List<Pricing_Condition_Scaled_Pricing__c> pcsps) {
        //debug(' processAfterUpsert pcsps begins');
        if (!processBeforeUpdate) {
            return;
        }
        Set<id> pcids = new Set<id>();
        for (Pricing_Condition_Scaled_Pricing__c pcsp : pcsps) {
            pcids.add(pcsp.Pricing_Condition__c);
        }
        if (!pcids.isEmpty()) {
            List<Pricing_Condition__c> pcs = getPricingConditions(pcids);
            if (pcs != null && !pcs.isEmpty()) {
                update pcs;
            }
        }
        //debug(' processAfterUpsert pcsps ends');
    }

    public static void processBeforeUpsert(List<Pricing_Condition_Scaled_Pricing__c> pcsps) {
        //debug(' processBeforeUpsert pcsps begins');
        Set<Id> pcids = new Set<Id>();
        Id pcid;
        List<Pricing_Condition__c> pcs;
        Map<Id, Double> ucmap; Map<Id, Pricing_Condition__c> pcmap;
        Map<Id, Integer> dmap;
        Double uc, ip, sp, vat; Pricing_Condition__c pc; Integer d;
        for (Pricing_Condition_Scaled_Pricing__c pcsp : pcsps) {pcids.add(pcsp.Pricing_Condition__c);}
        if (!pcids.isEmpty()) {
            pcs = getPricingConditions(pcids);
            if (pcs != null && !pcs.isEmpty()) {
                pcmap = new Map<Id, Pricing_Condition__c>();
                ucmap = new Map<Id, Double>();
                dmap = new Map<Id, Integer>();
                for (Pricing_Condition__c p : pcs) {
                    pcmap.put(p.Id, p);
                    uc = getTotalUpcharges(p);
                    ucmap.put(p.Id, uc);
                    dmap.put(p.Id, getDecimals(p.Division_Code__c));
                }
                for (Pricing_Condition_Scaled_Pricing__c pcsp : pcsps) {
                    d = 4; ip = 0.0; uc = 0.0; pcid = pcsp.Pricing_Condition__c;
                    if (pcmap.containsKey(pcid)) {pc = pcmap.get(pcid);}
                    if (ucmap.containsKey(pcid)) {uc = ucmap.get(pcid);}
                    if (dmap.containsKey(pcid)) {d = dmap.get(pcid);}
                    //debug(''+uc);
                    sp = pcsp.Selling_Price__c;
                    pcsp.Selling_Price_with_Upcharges__c = sp + uc;
                    ip = getInvoicePrice(pc, pc.Division_Code__c, sp, uc);
                    pcsp.Invoice_Price__c = ip;
                    if (pcsp.VAT_Percent__c != null && pcsp.VAT_Percent__c != 0) {
                        vat = getRoundedValue(ip * pcsp.VAT_Percent__c, d);
                        pcsp.VAT_Amount__c = vat;
                        pcsp.Invoice_Price_with_VAT__c = ip + vat;
                    }
                }
            }
        }
        //debug(' processBeforeUpsert pcsps ends');
    }

    private static void sendNotifications(List<Pricing_Condition__c> pcs) {
        if (pcs == null || pcs.isEmpty()) {return;}
        List<Pricing_Condition__c> submittedPcs = new List<Pricing_Condition__c>();
        for (Pricing_Condition__c pc : pcs) {
            if (isToNotify(pc)) {
                pc.Account_Owner_Notified__c = true; submittedPcs.add(pc);
            }
        }
        if (submittedPcs.isEmpty()) {return;}
        Map<Id, Pricing_Condition__c> pcmap = getPricingConditionsMap(submittedPcs);
        PricingConditionNotifications.sendNotificationsForSubmitted(submittedPcs, pcMap);
    }

    private static Boolean isToNotify(Pricing_Condition__c pc) {
        Boolean b1 = (pc.Record_Status__c == SUBMITTED && !pc.Account_Owner_Notified__c);  //b1 = true;
        return (b1);
    }

    private static Map<Id, Pricing_Condition__c> getPricingConditionsMap(List<Pricing_Condition__c> pca) {
        Map<Id, Pricing_Condition__c> pcmap = new Map<Id, Pricing_Condition__c>();
        if (pca == null || pca.isEmpty()) {return pcmap;}
        Set<id> pcids = new Set<id>();
        for (Pricing_Condition__c p : pca) {
             pcids.add(p.id);
        }
        List<Pricing_Condition__c> pcs = getPricingConditions(pcids);
        if (pcs == null || pcs.isEmpty()) {return pcmap;}
        for (Pricing_Condition__c p : pcs) {
            pcmap.put(p.Id, p);
        }
        return pcmap;
    }

    private static void doAccountUpdates(Map<Id, Account> accMap,
                                         Map<Id, Map<String, List<Id>>> partnerIds,
                                         Pricing_Condition__c p,
                                         Map<String, String> pterms) {
        if (accMap.containsKey(p.Account__c)) {
            Account acc = accMap.get(p.Account__c);
            p.Account_Owner__c = acc.Owner.Id;
            p.Account_Country__c = acc.BillingCountry;
            if (pterms.containsKey(p.Payment_Terms__c)) {
                p.Payment_Term_Explanation__c = pterms.get(p.Payment_Terms__c);
            }
        }
        if (partnerIds.containsKey(p.Account__c)) {
            Map<String, List<Id>> pmap = partnerIds.get(p.Account__c);
            if (pmap.containsKey(SOLDTO)) {
                List<Id> plist = pmap.get(SOLDTO);
                if (plist != null && !plist.isEmpty()) {
                    p.SoldTo_Customer__c = plist[0];
                }
            }
        }
    }

    private static String getZeroFilled(String s, Integer n) {
        String r = s.trim();
        Integer m = r.length();
        while (m++ < n) {r = '0' + r;}
        return r;
    }

    private static Map<String, Delivery_Program_Adder__c> getDeliveryProgramAdders() {
        Map<String, Delivery_Program_Adder__c> amap = new Map<String, Delivery_Program_Adder__c>(); String k;
        for (Delivery_Program_Adder__c a : [
            select Adder_Type__c, Amount__c, Dist_Channel_Code__c, PH3__c, Plant_Code__c,
                   Sales_Org_Code__c, SAP_Table_Name__c, ValidOn__c, ValidTo__c
              from Delivery_Program_Adder__c order by ValidOn__c]) {
            k = a.Sales_Org_Code__c + a.Dist_Channel_Code__c + getZeroFilled(a.PH3__c, 3) +
                a.Plant_Code__c + a.Adder_Type__c;
            //debug('DPA-Key : ' + k);
            amap.put(k, a);
        }
        return amap;
    }

    public static void doPricingConditionUpdates(List<Pricing_Condition__c> pca) {
        doPricingConditionUpdates(pca, false);
    }

    private static void doPricingConditionUpdates(List<Pricing_Condition__c> pca,
                                                  Boolean isBeforeInsert) {
        Date currentDate = System.today();
        Set<id> accIds = new Set<id>();
        Set<id> pcids = new Set<id>();
        Set<id> msd2ids = new Set<id>();
        Set<id> plantIds = new Set<id>();
        Set<String> matNums = new Set<String>();
        Set<String> sellingUoms = new Set<String>();
        Set<String> pbeIds = new Set<String>();
        List<CPI_Functions.Parameter> cpiParams = new List<CPI_Functions.Parameter>();
        List<Pricing_Rebate_Functions.Parameter> rebateParams = new List<Pricing_Rebate_Functions.Parameter>();
        Map<String, Pricing_Condition__c> pcMap = new Map<String, Pricing_Condition__c>();
        Integer i = 0; String k1 = '';
        for (Pricing_Condition__c p : pca) {
            if (isExpired(p)) {continue;}
            k1 = '00000' + (++i);
            k1 = k1.substring(k1.length() - 5);
            pcMap.put(k1, p);
            if (p.Price_Book_Entry__c != null) {pbeIds.add(p.Price_Book_Entry__c);}
            setCPIParameterList(cpiParams, p, k1);
            setRebateParameterList(rebateParams, p, k1);
            setRecordStatus(p, currentDate);
            accIds.add(p.Account__c);
            msd2ids.add(p.Material2__c);
            plantIds.add(p.SAP_Plant__c);
            sellingUoms.add(p.Selling_UOM__c);
            matNums.add(p.Material_Number__c);
            if (p.id != null) {pcids.add(p.id);}
        }
                                                      system.debug('accIdsaccIdsaccIds 335 : '+accIds);
        debug('msd2ids : ' + msd2ids);
        if (msd2ids.isEmpty()) {return;}
        Map<Id, Map<String, List<Id>>> partnerIds = Account_Partner_Functions.getPartnerIds(accIds);
                                                      system.debug('partnerIds  check : '+partnerIds);
        Map<Id, Account> accMap = Account_Partner_Functions.getAccountsMap(partnerIds, accIds);
                                                      system.debug('partnerIds  check : '+accMap);
        Map<String, String> pterms = getPaymentTerms(accMap);
        List<Material_Sales_Data2__c> msd2s = Material_Sales_Data_Functions.getMaterialSalesData2s(msd2ids);
        Map<Id, Material_Sales_Data2__c> msd2map = Material_Sales_Data_Functions.getMaterialSalesData2Map(msd2s);
        if (msd2map == null || msd2map.isEmpty()) {return;}
        Map<String, Material_Plant2__c> mpmap = Material_Sales_Data_Functions.getPlantsMap(msd2s, plantIds);
        debug('mpmap : ' + mpmap);
        Map<String, Map<String, String>> mumap = Material_UOM_Functions.getUomConversionFactors(matNums, sellingUoms);
        Map<String, Double> ccrmap = CurrencyConverter.getConversionRateMap();
        Map<id, List<Pricing_Condition_Scaled_Pricing__c>> spmap = getPricingScales(pcids);
        Map<String, Delivery_Program_Adder__c> dpamap = getDeliveryProgramAdders();
        Map<String, Customer_Product_Info__c> cpimap = null;
        Map<String, Pricing_Rebate_Detail__c> prdmap = null;
        Map<String, Price_Book_Entry__c> pbemap = null;
        debug('cpiParams : ' + cpiParams); debug('partnerIds : ' + partnerIds);
        debug('accMap : ' + accMap); debug('msd2map : ' + msd2map);
        cpimap = CPI_Functions.getCPIMap(cpiParams, partnerIds, accMap, msd2map);
                                                      system.debug('partnerIds  check : '+cpimap);
        debug('cpimap : ' + cpimap);
        prdmap = Pricing_Rebate_Functions.getRebateDetailMap(rebateParams, partnerIds);
        debug('prdmap : ' + prdmap);
        //if (isBeforeInsert && !pbeIds.isEmpty()) {
        //    pbemap = PriceBookEntryFunctions.getPriceBookEntries(pcMap, msd2map, pbeIds);
        //}
        system.debug('pcMap :: '+pcMap);
        system.debug('accMap :: '+accMap);
        system.debug('msd2map :: '+msd2map);
        system.debug(' accIdsaccIds :: '+accIds);
                                                              
        //pbemap = PriceBookEntryFunctions.getPriceBookEntries(pcMap, accMap, msd2map);
        pbemap = PriceBookEntryFunctions.getPriceBookEntries(pcMap, accMap, msd2map, accIds);//Adding the 'accIds' parameter for passing the corresponding data                                           
        system.debug('pbemap'+pbemap);
        Account acc;
        Material_Sales_Data2__c mat;
        List<Pricing_Condition_Scaled_Pricing__c> pcsps;
        Pricing_Condition__c p;
        String matNum, baseUom, sellingUom, shipUom;
        Double uomConvFac, shipUomFac, minPrice, minPriceWithUpcharges;
        for (String k2 : pcMap.keySet()) {
            p = pcMap.get(k2);
            if (isExpired(p)) {continue;}
            acc = accMap.get(p.Account__c);
            setKeyFields(acc, p);
            if (msd2Map.containsKey(p.Material2__c)) {
                mat = msd2Map.get(p.Material2__c);
                setMaterialFields(p, mat);
                matNum = mat.Material_Number__c;
                baseUom = mat.Base_UOM_Code__c;
                sellingUom = p.Selling_UOM__c;
                shipUom = p.Shipment_Weight_UOM_Code__c;
                if (isNull(shipUom)) {shipUom = sellingUom;}
                uomConvFac = Material_UOM_Functions.getUomConversionFactor(matNum, baseUom, sellingUom, mumap);
                shipUomFac = Material_UOM_Functions.getUomConversionFactor(matNum, shipUom, sellingUom, mumap);
            }
            if (uomConvFac == null || uomConvFac == 0) {uomConvFac = 1.0;}
            if (shipUomFac == null || shipUomFac == 0) {shipUomFac = 1.0;}
            doAccountUpdates(accMap, partnerIds, p, pterms);
            PricingConditionTables.setPricingTables(p);
            if (pbemap != null) {
                PriceBookEntryFunctions.setPriceBookEntryFields(p, pbemap, ccrmap, k2);
            }
            if (cpimap != null) {
            //setCPIFields(p, cpimap, k2);
            }
            setCogs(p, mpmap, msd2map, ccrmap, uomConvFac);
            setDeliveryProgramCosts(p, mpmap, msd2map, dpamap, shipUomFac);
            pcsps = p.Pricing_Condition_Scaled_Pricing__r;
            if (spmap != null && spmap.containsKey(p.Id)) {
                pcsps = spmap.get(p.id);
            }
            if (pcsps != null && !pcsps.isEmpty()) {
                p.Base_Price__c = pcsps[0].Selling_Price__c;
                p.Minimum_Volume__c = pcsps[0].Minimum_Volume__c;
                setPricingScales(p, pcsps);
            }
            if (p.Base_Price__c == null) {p.Base_Price__c = p.Selling_Price__c;}
            double upcharges = getTotalUpcharges(p);
            setInvoicePrice(p, p.Division_Code__c, upcharges);
            minPrice = getMinPrice(p, pcsps);
            p.FCL_Invoice_Price__c = getInvoicePrice(p, p.Division_Code__c, minPrice, upcharges);
            minPriceWithUpcharges = getMinPriceWithUpcharges(p, pcsps);
            if (isAPSalesOrg(acc)) {setGrossProfit(p, acc, minPriceWithUpcharges);}
            else {setGrossProfit(p, acc, minPrice);}
            if (prdmap != null) {setRebateFields(p, msd2map, mumap, ccrmap, prdmap, k2);}
            doTextFieldUpdates(p);
            PricingConditionApprovalCriteria.setRouteForApprovalFields(p, acc, minPrice);
        }
        notUpdated = false;
    }

    private static void setKeyFields(Account acc, Pricing_Condition__c pc) {
        //debug('setKeyFields : acc = ' + acc);
        if (acc == null) {return;}
        String dc = acc.SAP_DistChannel__c; String so = acc.SAP_Sales_Org__c;
        if (dc != null) {
            dc = dc.trim(); if (dc.length() > 1) {dc = dc.substring(0,2);}
            pc.DistChan_Code__c = dc;
        }
        if (so != null) {
            so = so.trim(); if (so.length() > 3) {so = so.substring(0,4);}
            pc.SalesOrg_Code__c = so;
        }
        //debug('setKeyFields : pc = ' + pc);
    }

    private static void setMaterialFields(Pricing_Condition__c p, Material_Sales_Data2__c m) {
         p.Product_Hierarchy__c = m.Product_Hierarchy__r.Id; String s = ' - ';
         p.PH3_Description__c = m.Product_Hierarchy__r.PH3_Group__c + s + m.Product_Hierarchy__r.PH3__c;
         p.PH4_Description__c = m.Product_Hierarchy__r.PH4_Supplier__c + s + m.Product_Hierarchy__r.PH4__c;
         p.PH5_Description__c = m.Product_Hierarchy__r.PH5_Family__c + s + m.Product_Hierarchy__r.PH5__c;
         p.PH6_Description__c = m.Product_Hierarchy__r.PH6_Segment__c + s + m.Product_Hierarchy__r.PH6__c;
         p.PH7_Description__c = m.Product_Hierarchy__r.PH7_SubSegment__c + s + m.Product_Hierarchy__r.PH7__c;
    }

    private static Double getMinPrice(Pricing_Condition__c pc,
                                      List<Pricing_Condition_Scaled_Pricing__c> pcsps) {
        Double minPrice = pc.Base_Price__c;
        if (pcsps != null && !pcsps.isEmpty()) {
            for (Pricing_Condition_Scaled_Pricing__c pcsp : pcsps) {
                if (minPrice > pcsp.Selling_Price__c) {minPrice = pcsp.Selling_Price__c;}
            }
        }
        return minPrice;
    }

    private static Double getMinPriceWithUpcharges(Pricing_Condition__c pc,
                                      List<Pricing_Condition_Scaled_Pricing__c> pcsps) {
        Double minPrice = pc.Selling_Price__c;
        if (pcsps != null && !pcsps.isEmpty()) {
            for (Pricing_Condition_Scaled_Pricing__c pcsp : pcsps) {
                if (minPrice > pcsp.Selling_Price_with_Upcharges__c) {minPrice = pcsp.Selling_Price_with_Upcharges__c;}
            }
        }
        return minPrice;
    }

    private static void setCPIParameterList(List<CPI_Functions.Parameter> plist,
                                            Pricing_Condition__c pc, String key) {
        CPI_Functions.Parameter p = new CPI_Functions.Parameter();
        p.accId = pc.Account__c;
        p.accType = pc.Account_Level_Condition_Applies_To__c;
        p.cpiMapKey = key;
        p.matId = pc.Material2__c;
        plist.add(p);
    }

   /* private static void setCPIFields(Pricing_Condition__c pc,
                                     Map<String, Customer_Product_Info__c> cpimap,
                                     String key) {
        pc.Customer_Product_Info__c = null;
        pc.CPI_INCO_Term_to_be_Updated__c = NO;
        //debug('key : ' + key);
        system.debug('cpimap'+cpimap);
        if (cpimap != null && cpimap.containsKey(key)) {
            Customer_Product_Info__c cpi = cpimap.get(key);
            pc.Customer_Product_Info__c = cpi.Id;
            String cpiIncoTerm = cpi.INCO_Terms1__c;
            String pcIncoTerm = pc.INCO_Term_Code__c;
            pc.CPI_INCO_Term_Code__c = cpiIncoTerm;
            pc.Customer_Material_Number__c = cpi.Customer_Material_Number__c;
            if (notNull(cpiIncoTerm) && notNull(pcIncoTerm) && cpiIncoTerm != pcIncoTerm) {
                pc.CPI_INCO_Term_to_be_Updated__c = YES;
            }
        }
    }*/ 

    private static Map<String, String> getPaymentTerms(Map<Id, Account> accMap) {
        Map<String, String> ptmap = new Map<String, String>();
        if (accMap == null || accMap.isEmpty()) {return ptmap;}
        Set<String> ptcodes = new Set<String>();
        for (Account acc : accMap.values()) {ptcodes.add(acc.SAP_Payment_Terms__c);}
        return SAP_Queries_Functions.getPaymentTermDescs(ptcodes);
    }

    private static void setRebateParameterList(List<Pricing_Rebate_Functions.Parameter> plist,
                                               Pricing_Condition__c pc, String key) {
        Pricing_Rebate_Functions.Parameter p = new Pricing_Rebate_Functions.Parameter(
            pc.Account__c, pc.Material2__c, pc.Valid_From_Date__c, pc.Valid_To_Date__c, key);
        plist.add(p);
    }

    private static void setRebateFields(Pricing_Condition__c pc, Map<Id, Material_Sales_Data2__c> msd2Map,
                                        Map<String, Map<String, String>> mumap, Map<String, Double> ccrmap,
                                        Map<String, Pricing_Rebate_Detail__c> prdmap, String key) {
        pc.Pricing_Rebate_Detail__c = null; pc.Rebate_Amount__c = 0.0;
        //debug('key : ' + key);
        if (prdmap == null || !prdmap.containsKey(key)) {return;}
        Pricing_Rebate_Detail__c prd = prdmap.get(key);
        pc.Pricing_Rebate_Detail__c = prd.Id;
        Pricing_Rebate__c pr = prd.Pricing_Rebate__r;
        if (Pricing_Rebate_Functions.isPercentageType(pr)) {
            pc.Rebate_Amount__c = prd.Accrual__c * pc.Invoice_Price__c / 100;
            return;
        }
        Double uomConvFac, currConvFac = 1.0;
        if (msd2Map.containsKey(pc.Material2__c)) {
            Material_Sales_Data2__c mat = msd2Map.get(pc.Material2__c);
            String matNum = mat.Material_Number__c;
            String prdUom = prd.UoM__c;
            String sellingUom = pc.Selling_UOM__c;
            if (!prdUom.equals(sellingUom)) {
                uomConvFac = Material_UOM_Functions.getUomConversionFactor(matNum, prdUom, sellingUom, mumap);
            }
        }
        if (uomConvFac == null || uomConvFac == 0) {uomConvFac = 1.0;}
        if (prd.Unit__c != null && !prd.Unit__c.equals(pc.CurrencyIsoCode)) {
            currConvFac = CurrencyConverter.getCurrencyConversionFactor(
                              ccrmap, prd.Unit__c, pc.CurrencyIsoCode);
        }
        pc.Rebate_Amount__c = prd.Accrual__c * currConvFac / uomConvFac;
    }

    private static void doTextFieldUpdates(Pricing_Condition__c p) {
        String currencyCode = p.CurrencyIsoCode;
        if (p.Base_Price__c != null) {
            p.Base_Price_Text__c = currencyCode + ' ' + getRoundedValue(p.Base_Price__c, 4);
        }
        if (p.Equipment_On_Invoice__c != null) {
            p.Equipment_On_Invoice_Text__c = p.Equipment_On_Invoice__c ? YES : NO;
        }
        if (p.Equipment_Up_Charge__c != null) {
            p.Equipment_Upcharge_Text__c = currencyCode + ' ' + getRoundedValue(p.Equipment_Up_Charge__c, 4);
        }
        if (p.Has_On_Invoice_Discount__c != null) {
            p.Discount_on_Invoice_Text__c = p.Has_On_Invoice_Discount__c ? YES : NO;
        }
        if (p.Invoice_Price__c != null) {
            p.Invoice_Price_Text__c = currencyCode + ' ' + getRoundedValue(p.Invoice_Price__c, 4);
        }
        if (p.Selling_Price__c != null) {
            p.Selling_Price_Text__c = currencyCode + ' ' + getRoundedValue(p.Selling_Price__c, 4);
        }
        p.Comments_Exist__c = notNull(p.Approver_Comments__c) || notNull(p.Comments__c);
    }

    private static Integer getBasePriceDecimals(Pricing_Condition__c p) {
        Integer d = 2;
        if (p.Base_Price__c == null) {return d;}
        try {
            Decimal basePrice = p.Base_Price__c;
            String s = basePrice.stripTrailingZeros().toPlainString();
            if (s.indexOf('.') >= 0) {
                List<String> sa = s.split('\\.');
                //debug(''+sa);
                if (sa.size() > 1) {
                    d = sa[1].length();
                    if (d < 2) {d = 2;} else
                    if (d > 4) {d = 4;}
                }
            }
        } catch (Exception e) {}
        return d;
    }

    private static Integer getDecimals(String divisionCode) {
        Integer decimals = 2;
        if (isAHWTDivision(divisionCode)) {decimals = 4;}
        return decimals;
    }

    private static void calculateFreightUpcharge(Pricing_Condition__c p) {

        //if (!isStreamLink(divisionCode)) {}
        if (p.Freight_Cost__c != null && p.Freight_Mark_Up__c != null) {
            Integer d = getBasePriceDecimals(p);
            Double c = 1.0 + p.Freight_Mark_Up__c / 100;
            //debug(''+d);
            p.Freight_Up_Charge__c = getRoundedValue(p.Freight_Cost__c * c, d);
            //debug(''+p.Freight_Up_Charge__c);
        }

    }
/*
    @isTest static void testFreightUpcharge() {
        Pricing_Condition__c p = new Pricing_Condition__c();
        p.Freight_Cost__c = 0.05;
        p.Freight_Mark_Up__c = 30;
        p.Base_Price__c = 3.14;
        Integer d = getBasePriceDecimals(p);
        debug(''+d);
        calculateFreightUpcharge(p);
        debug(''+p.Freight_Up_Charge__c);
    }
//*/

    public static Double getIncreasedBasePrice(Pricing_Condition__c p,
                                               Double priceIncreaseAmount,
                                               Double priceIncreasePercnt) {
        Decimal bp = p.Base_Price__c;
        if (bp == null) {return null;}
        Double d = bp;
        //debug('priceIncreaseAmount = '+priceIncreaseAmount);
        //debug('priceIncreasePercnt = '+priceIncreasePercnt);
        Integer n = getDecimals(p.Division_Code__c);
        if (priceIncreaseAmount != null && priceIncreaseAmount != 0.0) {
            d = getRoundedValue(bp + priceIncreaseAmount, n);
        } else
        if (priceIncreasePercnt != null && priceIncreasePercnt != 0.0) {
            d = getRoundedValue(bp * (1.0 + priceIncreasePercnt / 100.0), n);
        }
        //debug(bp+' : '+d+' (rounded to '+n+' decimals)');
        return d;
    }

    public static void increasePriceScales(Pricing_Condition__c p,
                                           Double priceIncreaseAmount,
                                           Double priceIncreasePercnt) {
        Double d, f = 0.0;
        List<Pricing_Condition_Scaled_Pricing__c> pcsps = p.Pricing_Condition_Scaled_Pricing__r;
        if (pcsps == null || pcsps.isEmpty()) {return;}
        Double uc = getTotalUpcharges(p);
        Integer n = getDecimals(p.Division_Code__c);
        if (priceIncreaseAmount != null && priceIncreaseAmount != 0.0) {
            f = priceIncreaseAmount;
        } else
        if (priceIncreasePercnt != null && priceIncreasePercnt != 0.0) {
            f = 1.0 + priceIncreasePercnt / 100.0;
        }
        for (Pricing_Condition_Scaled_Pricing__c pcsp : pcsps) {
            d = pcsp.Selling_Price__c;
            if (priceIncreaseAmount != null && priceIncreaseAmount != 0.0) {
                pcsp.Selling_Price__c = getRoundedValue(d + f, n);
            } else
            if (priceIncreasePercnt != null && priceIncreasePercnt != 0.0) {
                pcsp.Selling_Price__c = getRoundedValue(d * f, n);
            }
            pcsp.Selling_Price_with_Upcharges__c = pcsp.Selling_Price__c + uc;
        }
        setPricingScales(p, pcsps);
    }

    private static void setGrossProfit(Pricing_Condition__c pc, Account acc, Double minPrice) {
        double gpsp = 0.0, gpfp = 0.0, gpmp = 0.0;
        //debug('setGrossProfit : minPrice : '+minPrice);
        if (minPrice != null) {gpsp += minPrice;}
        if (pc.Floor_Price__c != null) {gpfp += pc.Floor_Price__c;}
        if (pc.Market_Price__c != null) {gpmp += pc.Market_Price__c;}
        if (pc.Discount_Percent__c != null) {
            gpsp -= (gpsp * pc.Discount_Percent__c / 100);
            gpfp -= (gpfp * pc.Discount_Percent__c / 100);
            gpmp -= (gpmp * pc.Discount_Percent__c / 100);
        }
        if (pc.COGS__c != null) {
            gpsp -= pc.COGS__c; gpfp -= pc.COGS__c; gpmp -= pc.COGS__c;
        }
        if (isAPSalesOrg(acc)) {
            if (pc.Freight_Cost__c != null) {
                gpsp -= pc.Freight_Cost__c; gpfp -= pc.Freight_Cost__c; gpmp -= pc.Freight_Cost__c;
            }
            if (pc.Other_Up_Charge__c != null) {
                gpsp -= pc.Other_Up_Charge__c; gpfp -= pc.Other_Up_Charge__c; gpmp -= pc.Other_Up_Charge__c;
            }
        }
        pc.Gross_Profit__c = gpsp; pc.GP_on_Floor_Price__c = gpfp; pc.GP_on_Market_Price__c = gpmp;
        //debug('setGrossProfit : Gross_Profit__c : '+gpsp);
        if (minPrice != null && minPrice != 0) {
            pc.Gross_Profit_Percent__c = (pc.Gross_Profit__c * 100 / minPrice);
        }
        if (pc.Floor_Price__c != null && pc.Floor_Price__c != 0) {
            pc.GP_Percent_on_Floor_Price__c = (pc.GP_on_Floor_Price__c * 100 / pc.Floor_Price__c);
        }
        if (pc.Market_Price__c != null && pc.Market_Price__c != 0) {
            pc.GP_Percent_on_Market_Price__c = (pc.GP_on_Market_Price__c * 100 / pc.Market_Price__c);
        }
    }

    private static void setCogs(Pricing_Condition__c pc,
                                Map<String, Material_Plant2__c> pmap,
                                Map<Id, Material_Sales_Data2__c> mmap,
                                Map<String, Double> ccrmap,
                                Double uomConvFac) {
        if (pmap == null || pmap.isEmpty() ||
            mmap == null || mmap.isEmpty()) {
            return;
        }
        Id msd2Id = pc.Material2__c;
        Material_Sales_Data2__c msd2 = mmap.get(msd2Id);
        String matnum = msd2.Material_Number__c;
        String sorg = msd2.Sales_Org_Code__c;
        String plant = pc.Plant_Code__c;
        String mp2key = matnum + plant;
        Double currConvFac = 1.0;
        if (pmap.containsKey(mp2key)) {
            Material_Plant2__c mp2 = pmap.get(mp2key);
            if (uomConvFac != 0 && mp2.COGS__c != null) {
                if (!mp2.COGS_Currency__c.equals(pc.CurrencyIsoCode)) {
                    currConvFac = CurrencyConverter.getCurrencyConversionFactor(
                                    ccrmap, mp2.COGS_Currency__c, pc.CurrencyIsoCode);
                }
                pc.COGS__c = mp2.COGS__c * currConvFac / uomConvFac;
            }
        }
    }

    private static void setDeliveryProgramCosts(Pricing_Condition__c pc,
                                                Map<String, Material_Plant2__c> pmap,
                                                Map<Id, Material_Sales_Data2__c> mmap,
                                                Map<String, Delivery_Program_Adder__c> dmap,
                                                Double uomConvFac) {
        //debug('dmap : ' + dmap);
        if (dmap == null || dmap.isEmpty() ||
            mmap == null || mmap.isEmpty() ||
            pmap == null || pmap.isEmpty()) {
            return;
        }
        Id msd2Id = pc.Material2__c;
        Material_Sales_Data2__c msd2 = mmap.get(msd2Id);
        String sorg = msd2.Sales_Org_Code__c;
        String dchan = pc.Dist_Channel_Code__c;
        String ph3 = pc.PH3_Product_Group__c;
        String plant = pc.Plant_Code__c;
        if (DLVRY_PGM_EXCL_PLNT_SET.contains(plant) && DLVRY_PGM_EXCL_PH3_SET.contains(ph3)) {return;}
        String k1 = sorg + dchan + ph3 + plant;
        String pgmCostKey = k1 + 'Z2D1'; //debug('pgmCostKey : ' + pgmCostKey);
        String fltCostKey = k1 + 'Z2D2';
        Delivery_Program_Adder__c dpa; Double amt;
        if (dmap.containsKey(pgmCostKey) && pc.Shipment_Weight__c != null && pc.Shipment_Weight__c > 0) {
            dpa = dmap.get(pgmCostKey); amt = dpa.Amount__c;
            //Integer d = getBasePriceDecimals(pc);
            pc.Program_Cost__c = getRoundedValue(amt / (pc.Shipment_Weight__c * uomConvFac), 2);
        }
        debug('fltCostKey : ' + fltCostKey);
        if (dmap.containsKey(fltCostKey)) {
            dpa = dmap.get(fltCostKey); pc.Fleet_Cost__c = dpa.Amount__c;
        }
    }

    private static double getTotalUpcharges(Pricing_Condition__c pc) {
        Integer n = getDecimals(pc.Division_Code__c);
        double d = 0.0;
        if (pc.Contract_Duration__c != null)           {d += pc.Contract_Duration__c;}
        calculateFreightUpcharge(pc);
        if (pc.Freight_Up_Charge__c != null)           {d += pc.Freight_Up_Charge__c;}
        if (pc.Lead_Time__c != null)                   {d += pc.Lead_Time__c;}
        if (pc.OTC__c != null)                         {d += pc.OTC__c;}
        if (pc.Other_Up_Charge__c != null)             {d += pc.Other_Up_Charge__c;}
        if (pc.Packaging__c != null)                   {d += pc.Packaging__c;}
        if (pc.Streamlink_EU_Payment_Terms__c != null) {d += pc.Streamlink_EU_Payment_Terms__c;}
        if (pc.Relabel__c != null)                     {d += pc.Relabel__c;}
        if (pc.Service__c != null)                     {d += pc.Service__c;}
        if (pc.Program_Cost__c != null)                {d += pc.Program_Cost__c;}
        if (pc.Fleet_Cost__c != null)                  {d += pc.Fleet_Cost__c;}
        if (pc.Product_Support_Cost__c != null)        {d += pc.Product_Support_Cost__c;}
        d = getRoundedValue(d, n);
        return d;
    }

    private static void setInvoicePrice(Pricing_Condition__c pc, String divisionCode, Double upcharges) {
        if (pc.Base_Price__c != null) {pc.Selling_Price__c = pc.Base_Price__c + upcharges;}
        Double maxScalePrice = pc.Base_Price__c;
        pc.Invoice_Price__c = getInvoicePrice(pc, divisionCode, maxScalePrice, upcharges);
        //debug('Invoice_Price__c : '+pc.Invoice_Price__c);
    }

    private static Double getInvoicePrice(Pricing_Condition__c pc, String divisionCode,
                                          Double scalePrice, Double upcharges) {
        //debug('scalePrice : ' + scalePrice);
        //debug('upcharges : ' + upcharges);
        double invoicePrice = scalePrice + upcharges;
        Integer decimals = getDecimals(divisionCode);
        //debug('decimals : '+decimals);
        invoicePrice = getRoundedValue(invoicePrice, decimals);
        if (pc.Equipment_Up_Charge__c != null &&
            pc.Equipment_On_Invoice__c != null &&
           !pc.Equipment_On_Invoice__c) {
            invoicePrice += getRoundedValue(pc.Equipment_Up_Charge__c, decimals);
        }
        invoicePrice -= getInvoiceDiscount(invoicePrice, pc, decimals);
        invoicePrice = getRoundedValue(invoicePrice, decimals);
        //debug(''+invoicePrice);
        return invoicePrice;
    }

    public static Double getRoundedValue(Decimal value) {
        return getRoundedValue(value, 2);
    }

    public static Double getRoundedValue(Double dbl, Integer decimals) {
        if (dbl == null) {dbl = 0.0;}
        return getRoundedValue(Decimal.valueOf(dbl), decimals);
    }

    public static Double getRoundedValue(Decimal value, Integer decimals) {
        if (decimals == null) {decimals = 2;}
        if (value == null) {value = 0;}
        //debug('value = '+value);
        Decimal d1 = 10;
        Decimal d2 = d1.pow(decimals);
        //debug('d2 = '+d2);
        Decimal d3 = (value * d2).round(RoundingMode.HALF_UP);
        //debug('d3 = '+d3);
        Decimal d4 = d3.divide(d2, decimals);
        //debug('d4 = '+d4);
        return d4.doubleValue();
    }

    private static Double getInvoiceDiscount(Double invoicePrice,
                                             Pricing_Condition__c pc, Integer decimals) {
        Double invoiceDiscount = 0.0;
        if (pc.Discount_Percent__c != null) {
            invoiceDiscount = (invoicePrice * pc.Discount_Percent__c / 100);
            invoiceDiscount = getRoundedValue(invoiceDiscount, decimals);
        }
        return invoiceDiscount;
    }

    private static void setPricingScales(Pricing_Condition__c pc,
                                         List<Pricing_Condition_Scaled_Pricing__c> pcsps) {
        if (pcsps == null || pcsps.isEmpty()) {
            return;
        }
        String ps = '';
        String s = '';
        s += 'Minimum';
        s += TAB + 'Maximum';
        s += TAB + 'Vol';
        s += TAB + 'Selling';
        s += TAB + 'Sel';
        if (isAAFI(pc)) {
            s += TAB + 'Scale';
            s += TAB + 'Scale';
        }
        ps += s + NL;
        s = '';
        s += 'Volume';
        s += TAB + 'Volume';
        s += TAB + 'UOM';
        s += TAB + 'Price';
        s += TAB + 'UOM';
        if (isAAFI(pc)) {
            s += TAB + 'Surcharge';
            s += TAB + 'Price';
        }
        ps += s + NL;
        for (Pricing_Condition_Scaled_Pricing__c pcsp : pcsps) {
            s = '';
            s += pcsp.Minimum_Volume__c;
            s += TAB + pcsp.Maximum_Volume__c;
            s += TAB + pcsp.Volume_UOM__c;
            s += TAB + pcsp.Selling_Price_with_Upcharges__c;
            s += TAB + pcsp.Selling_UOM__c;
            if (isAAFI(pc)) {
                s += TAB + getString(pcsp.Surcharge__c, '0.0000');
                s += TAB + pcsp.Scaled_Selling_Price__c;
            }
            ps += s + NL;
        }
        pc.Pricing_Scales__c = ps;
    }

    public static Map<id, List<Pricing_Condition_Scaled_Pricing__c>> getPricingScales(Set<id> pcids) {
        if (pcids == null || pcids.isEmpty()) {return null;}
        List<Pricing_Condition_Scaled_Pricing__c> alist; Id pcid;
        Map<id, List<Pricing_Condition_Scaled_Pricing__c>> amap = new Map<id, List<Pricing_Condition_Scaled_Pricing__c>>();
        for (Pricing_Condition_Scaled_Pricing__c pcsp : [select Maximum_Volume__c, Minimum_Volume__c,
                                                                Pricing_Condition__c,
                                                                Scaled_Selling_Price__c,
                                                                Selling_Price__c, Selling_UOM__c,
                                                                Selling_Price_with_Upcharges__c,
                                                                Surcharge__c, Volume_UOM__c
                                                           from Pricing_Condition_Scaled_Pricing__c
                                                          where Pricing_Condition__c in :pcids
                                                       order by Pricing_Condition__c, Minimum_Volume__c]) {
            pcid = pcsp.Pricing_Condition__c;
            if (!amap.containsKey(pcid)) {
                alist = new List<Pricing_Condition_Scaled_Pricing__c>();
                amap.put(pcid, alist);
            }
            alist = amap.get(pcid); alist.add(pcsp);
        }
        //system.debug(amap);
        if (amap.isEmpty()) {return null;}
        return amap;
    }

    private static void setRecordStatus(Pricing_Condition__c pc,
                                        Date currentDate) {
        String rs = pc.Record_Status__c;
        Date validFrom = pc.Valid_From_Date__c;
        Date validTo = pc.Valid_To_Date__c;
        if (rs == APPROVED && validFrom <= currentDate && validTo >= currentDate) {
            //pc.Active__c = true;
            //pc.Record_Status__c = ACTIVE;
            //pc.Current_State__c = ACTIVE;
        } else if (rs == ACTIVE && validFrom < currentDate && validTo < currentDate) {
            pc.Active__c = false;
            pc.Record_Status__c = EXPIRED;
            pc.Current_State__c = EXPIRED;
        }
    }

    public static List<Pricing_Condition> getPricingConditionsPendingApproval() {
        return getPricingConditionsPendingApproval(null);
    }

    public static List<Pricing_Condition> getPricingConditionsPendingApproval(Integer maxNum) {
        List<Pricing_Condition> plist;
        Set<String> oids = getPricingConditionIdsPendingApproval(maxNum);
        if (oids != null) {
            plist = getPricingConditions(oids);
        }
        return plist;
    }

    public static Set<String> getPricingConditionIdsPendingApproval(Integer maxNum) {
        Set<String> oids = Custom_Approval_Functions.getPendingApprovalObjectIds(OBJECT_NAME, maxNum);
        return oids;
    }

    public static void setAttachments(List<Pricing_Condition> pcs) {
        Set<Id> pcids = getPricingConditionIds(pcs);
        Map<Id, List<Attachment>> amap = Attachment_Functions.getAttachments(pcids);
        if (amap == null || amap.isEmpty()) {
            return;
        }
        for (Pricing_Condition p : pcs) {
            if (amap.containsKey(p.pricingCondition.Id)) {
                p.attachments = amap.get(p.pricingCondition.Id);
                p.attachmentsCount = p.attachments.size();
                p.attachmentsExist = p.attachmentsCount > 0 ? YES : NO;
            }
        }
    }

    public static Pricing_Condition__c getPricingCondition(Id pcid) {
        List<Pricing_Condition__c> pcs = getPricingConditions(new Set<id>{pcid});
        if (pcs == null || pcs.isEmpty()) {return null;} return pcs[0];
    }

    public static List<Pricing_Condition__c> getPricingConditions(Set<id> pcids) {
        String qry = SELECT_QRY_1 + ' where Id in :pcids';
        List<Pricing_Condition__c> alist = Database.query(qry);
        return alist;
    }

    public static List<Pricing_Condition> getPricingConditions(List<Pricing_Condition__c> alist) {
        return getPricingConditions(alist, 1);
    }

    public static List<Pricing_Condition> getPricingConditions(List<Pricing_Condition__c> alist, Integer recFrom) {
        List<Pricing_Condition> plist;
        if (alist != null && !alist.isEmpty()) {
            plist = new List<Pricing_Condition>();
            Integer n = recFrom;
            for (Pricing_Condition__c p : alist) {
                Pricing_Condition pc = new Pricing_Condition(p, n++);
                plist.add(pc);
            }
            setAttachments(plist);
        }
        return plist;
    }

    public static List<Pricing_Condition> getPricingConditions(Set<String> oids) {
        List<Pricing_Condition> plist;
        if (oids != null) {
            String qry = SELECT_QRY_1 + ' where Id in :oids ' + ORDER_BY_1;
            List<Pricing_Condition__c> alist = Database.query(qry);
            plist = getPricingConditions(alist);
        }
        return plist;
    }

    public static List<Pricing_Condition> getPricingConditionsForAccounts(Set<String> accountIds) {
        List<Pricing_Condition> plist;
        if (accountIds != null) {
            String qry = SELECT_QRY_1 + ' where Account__c in :accountIds ' + ORDER_BY_1;
            List<Pricing_Condition__c> alist = Database.query(qry);
            plist = getPricingConditions(alist);
        }
        return plist;
    }

    public static Set<String> getSelectedIds(List<Pricing_Condition> plist) {
        if (plist == null || plist.isEmpty()) {
            return null;
        }
        Set<String> ss = new Set<String>();
        for (Pricing_Condition pc : plist) {
            if (pc.selected) {
                ss.add(pc.pricingCondition.id);
            }
        }
        return ss;
    }

    public static Boolean setSelectedFlags(List<Pricing_Condition> plist,
                                           List<Pricing_Condition> slist) {
        if (plist == null || plist.isEmpty() ||
            slist == null || slist.isEmpty()) {
            return false;
        }
        Boolean allSelected = true;
        Set<String> ss = getSelectedIds(slist);
        for (Pricing_Condition pc : plist) {
            pc.selected = ss.contains(pc.pricingCondition.id);
            if (!pc.selected) {
                allSelected = false;
            }
        }
        return allSelected;
    }

    public static List<Pricing_Condition> getSelectedPricingConditions(List<Pricing_Condition> plist) {
        List<Pricing_Condition> slist = new List<Pricing_Condition>();
        if (plist != null && !plist.isEmpty()) {
            for (Pricing_Condition pc : plist) {if (pc.selected) {slist.add(pc);}}
            if (!slist.isEmpty()) {return slist;}
        }
        return null;
    }

    public static List<Pricing_Condition__c> getExpiredPricingConditions() {
        List<Pricing_Condition__c> alist = new List<Pricing_Condition__c>();
        Date currentDate = System.today();
        for (Pricing_Condition__c p : [select Id, Active__c,
                                              Record_Status__c,
                                              Valid_From_Date__c,
                                              Valid_To_Date__c
                                         from Pricing_Condition__c
                                        where Record_Status__c = :ACTIVE
                                          and Valid_To_Date__c < :currentDate
                                      ]) {
            alist.add(p);
        }
        return alist;
    }

    public static List<Pricing_Condition__c> getApprovedPricingConditions() {
        List<Pricing_Condition__c> alist = new List<Pricing_Condition__c>();
        Date currentDate = System.today();
        for (Pricing_Condition__c p : [select Id, Active__c,
                                              Record_Status__c,
                                              Valid_From_Date__c,
                                              Valid_To_Date__c
                                         from Pricing_Condition__c
                                        where Record_Status__c = :APPROVED
                                          and Valid_From_Date__c <= :currentDate
                                      ]) {
            alist.add(p);
        }
        return alist;
    }

    public static void activatePricingConditions(List<Pricing_Condition__c> pcs) {
        List<Pricing_Condition__c> ulist = new List<Pricing_Condition__c>();
        List<Pricing_Condition__c> alist = getListToBeActivated(pcs);
        if (!alist.isEmpty()) {
            ulist.addAll(alist);
        }
        List<Pricing_Condition__c> dlist = getListToBeDeactivated(pcs);
        if (!dlist.isEmpty()) {
            ulist.addAll(dlist);
        }
        updatePricingConditions(ulist);
    }

    private static List<Pricing_Condition__c> getListToBeActivated(List<Pricing_Condition__c> pcs) {
        List<Pricing_Condition__c> alist = new List<Pricing_Condition__c>();
        Date currentDate = System.today();
        for (Pricing_Condition__c pc : pcs) {
            if (pc.Record_Status__c == APPROVED &&
                pc.Valid_From_Date__c <= currentDate &&
                pc.Valid_To_Date__c >= currentDate) {
                setRecordStatus(pc, currentDate);
                //System.debug(pc);
                alist.add(pc);
            }
        }
        return alist;
    }

    private static List<Pricing_Condition__c> getListToBeDeactivated(List<Pricing_Condition__c> pcs) {
        List<Pricing_Condition__c> alist = new List<Pricing_Condition__c>();
        Date currentDate = System.today();
        for (Pricing_Condition__c pc : pcs) {
            if (pc.Record_Status__c == ACTIVE &&
                pc.Valid_From_Date__c < currentDate &&
                pc.Valid_To_Date__c < currentDate) {
                setRecordStatus(pc, currentDate);
                //System.debug(pc);
                alist.add(pc);
            }
        }
        return alist;
    }

    private static void updatePricingConditions(List<Pricing_Condition__c> ulist) {
        if (!ulist.isEmpty()) {
            try {
                update ulist;
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
        }
    }

    public static void expirePricingConditions(List<Pricing_Condition> slist) {
        List<Pricing_Condition__c> ulist = new List<Pricing_Condition__c>();
        for (Pricing_Condition pc : slist) {
            Pricing_Condition__c p = pc.pricingCondition;
            ulist.add(p);
        }
        expirePricingConditions(ulist);
    }

    public static void expirePricingConditions(Set<Id> pcids) {
        List<Pricing_Condition__c> plist = getPricingConditions(pcids);
        expirePricingConditions(plist);
    }

    public static void expirePricingConditions(List<Pricing_Condition__c> plist) {
        expirePricingConditions(plist, null);
    }

    public static void expirePricingConditions(List<Pricing_Condition__c> plist,
                                               Map<String, Pricing_Condition__c> pmap) {
        Date tdate = Date.today();
        List<Pricing_Condition__c> clist = getClonedPricingConditions(plist);
        List<Pricing_Condition__c> ulist = new List<Pricing_Condition__c>();
        Pricing_Condition__c pc; Set<String> cset = new Set<String>();
        for (Pricing_Condition__c p : plist) {
            debug('expirePricingConditions : pcn : ' + p.Name);
            if (pmap != null && pmap.containsKey(p.Id)) {
                pc = pmap.get(p.Id); tdate = pc.Valid_To_Date__c;
                debug('expirePricingConditions : pc : ' + pc);
            }
            //start.daysBetween(end) -- negative if start is after end
            Integer d1 = tdate.daysBetween(p.Valid_From_Date__c);
            Integer d2 = tdate.daysBetween(p.Valid_To_Date__c);
            if (d1 <= 0) {
                if (pmap == null || !pmap.containsKey(p.Id)) {
                    p.Valid_To_Date__c = tdate;
                }
                p.Record_Status__c = EXPIRED;
                p.Current_State__c = EXPIRED;
                p.Active__c = false;
                ulist.add(p);
            } else if (d1 > 0 && d2 > 0){
                p.Record_Status__c = CANCELLED;
                p.Current_State__c = CANCELLED;
                p.Active__c = false;
                ulist.add(p); cset.add(p.Id);
            }
        }
        if (!cset.isEmpty()) {PricingConditionIDocFunctions.deleteIDocs(cset);}
        updatePricingConditions(ulist);
        cancelPricingConditions(clist, pmap);
    }

    private static void cancelPricingConditions(List<Pricing_Condition__c> plist,
                                                Map<String, Pricing_Condition__c> pmap) {
        Date tdate = Date.today();
        Date fdate = tdate.addDays(1);
        List<Pricing_Condition__c> ilist = new List<Pricing_Condition__c>();
        Pricing_Condition__c pc;
        //debug('cancelPricingConditions : pmap : '+pmap);
        for (Pricing_Condition__c p : plist) {
            //debug('cancelPricingConditions : p.Cloned_From__c : '+p.Cloned_From__c);
            if (pmap != null && pmap.containsKey(p.Cloned_From__c)) {
                pc = pmap.get(p.Cloned_From__c);
                tdate = pc.Valid_To_Date__c;
                fdate = tdate.addDays(1);
                //debug('cancelPricingConditions : fdate : '+fdate);
            }
            //start.daysBetween(end) -- negative if start is after end
            Integer d1 = fdate.daysBetween(p.Valid_From_Date__c);
            Integer d2 = fdate.daysBetween(p.Valid_To_Date__c);
            //debug('cancelPricingConditions : d2 : '+d2);
            if (d1 <= 0 && d2 >= 0) {
                p.Valid_From_Date__c = fdate;
                p.Record_Status__c = CANCELLED;
                p.Current_State__c = CANCELLED;
                p.Active__c = false;
                ilist.add(p);
            }
        }
        if (!ilist.isEmpty()) {
            //debug(''+ilist);
            insert ilist;
            insertPricingScales(ilist);
            insertIDocRecords(ilist);
        }
    }

    private static void insertIDocRecords(List<Pricing_Condition__c> ilist) {
        Set<String> pcids = getPricingConditionIds(ilist);
        PricingConditionIDocFunctions.upsertIDocs(pcids);
    }

    public static Set<String> extendPricingConditions(List<Pricing_Condition> slist, Date edate) {
        Date fdate = Date.today();
        List<Pricing_Condition__c> ulist = new List<Pricing_Condition__c>();
        for (Pricing_Condition pc : slist) {
            if (pc.isExtendable) {
                Pricing_Condition__c p = pc.pricingCondition; ulist.add(p);
            }
        }
        List<Pricing_Condition__c> clist = getClonedPricingConditions(ulist);
        List<Pricing_Condition__c> ilist = new List<Pricing_Condition__c>();
        for (Pricing_Condition__c p : clist) {
            if (isExpired(p) && isAHWT(p)) {
                p.Request_Reason_Desc__c = 'Extend an exisiting Price because time has expired';
            }
            resetPricingConditionFields(p);
            ilist.add(p);
        }
        return insertPricingConditions(ilist);
    }

    public static void setExtendToFields(Pricing_Condition__c p, Date edate) {
        p.Valid_From_Date__c = p.Valid_To_Date__c.addDays(1);
        Date tdate = p.Valid_To_Date__c.addDays(getMaxDaysToExtend(p));
        Integer d = edate.daysBetween(tdate);
        if (d > 0) {p.Valid_To_Date__c = edate;}
        else {p.Valid_To_Date__c = tdate;}
        resetPricingConditionFields(p);
    }

    public static void resetPricingConditionFields(Pricing_Condition__c p) {
        p.Active__c = false; p.Current_State__c = DRAFT; p.Date_Entered_in_SAP__c = null;
        p.Entered_in_SAP__c = false; p.Exported_to_IDoc__c = false;
        p.Generated_From_Increase__c = false; p.Record_Status__c = DRAFT;
        p.Revised_by_Approver__c = false; p.Revision_Comments__c = '';
        p.Send_Notification_1__c = false; p.Send_Notification_2__c = false;
        Account acc = p.Account__r;
        if (acc != null) {
            p.Payment_Terms__c = acc.SAP_Payment_Terms__c;
        }
    }

    public static Pricing_Condition__c getClonedPricingCondition(Pricing_Condition__c p) {
        List<Pricing_Condition__c> plist = new List<Pricing_Condition__c>{p};
        List<Pricing_Condition__c> clist = getClonedPricingConditions(plist);
        resetPricingConditionFields(clist[0]); return clist[0];
    }

    public static List<Pricing_Condition__c> getClonedPricingConditions(List<Pricing_Condition__c> plist) {
        List<Pricing_Condition__c> clist = plist.deepClone(true);
        for (Pricing_Condition__c p : clist) {p.Cloned_From__c = p.Id;}
        clist = clist.deepClone(false); return clist;
    }

    public static Set<String> insertPricingConditions(List<Pricing_Condition__c> ilist) {
        if (!ilist.isEmpty()) {
            setPriceBookEntries(ilist);
            //debug(''+ilist);
            insert ilist;
            //debug(''+ilist);
            insertPricingScales(ilist);
            insertPricingCompetitors(ilist);
            return getPricingConditionIds(ilist);
        }
        return null;
    }

    public static void insertAndSubmitForApproval(List<Pricing_Condition__c> ilist) {
        Set<String> pcids = insertPricingConditions(ilist); submitForApproval(pcids);
    }

    public static void submitForApproval(Set<String> pcids) {
        if (pcids == null || pcids.isEmpty()) {return;}
        Approval.ProcessSubmitRequest psr; List<Approval.ProcessResult> prs;
        List<Approval.ProcessSubmitRequest> psrs = new List<Approval.ProcessSubmitRequest>();
        for (String pcid : pcids) {
            psr = new Approval.ProcessSubmitRequest();
            psr.setComments('Submitting Pricing Condition for Approval.');
            psr.setObjectId(pcId);
            psrs.add(psr);
        }
        try {prs = Approval.process(psrs);}
        catch(Exception e) {debug('submitForApproval : ' + e.getMessage());}
    }

    public static void deletePricingConditions(List<Pricing_Condition> slist) {
        List<Pricing_Condition__c> plist = new List<Pricing_Condition__c>();
        Pricing_Condition__c p;
        for (Pricing_Condition pc : slist) {p = pc.pricingCondition; plist.add(p);}
        deletePricingConditions(plist);
    }

    public static void deletePricingConditions(List<Pricing_Condition__c> plist) {
        List<Pricing_to_Competitor__c> clist = new List<Pricing_to_Competitor__c>();
        List<Pricing_Condition_Scaled_Pricing__c> slist = new List<Pricing_Condition_Scaled_Pricing__c>();
        for (Pricing_Condition__c p : plist) {
            if (p.Pricing_to_Competitor__r != null && !p.Pricing_to_Competitor__r.isEmpty()) {
                clist.addAll(p.Pricing_to_Competitor__r);
            }
            if (p.Pricing_Condition_Scaled_Pricing__r != null && !p.Pricing_Condition_Scaled_Pricing__r.isEmpty()) {
                slist.addAll(p.Pricing_Condition_Scaled_Pricing__r);
            }
        }
        //debug('clist : '+clist); debug('slist : '+slist); debug('plist : '+plist);
        savepoint sp = Database.setSavepoint();
        try {
            if (!clist.isEmpty()) {delete clist;}
            if (!slist.isEmpty()) {delete slist;}
            if (!plist.isEmpty()) {delete plist;}
        } catch(Exception e) {
            debug(e.getMessage());
            Database.rollback(sp);
        }
    }

    public static void setPriceBookEntries(List<Pricing_Condition> plist) {
        List<Pricing_Condition__c> pcs = new List<Pricing_Condition__c>();
        for (Pricing_Condition p : plist) {
            if (p.isExtendable){pcs.add(p.pricingCondition);}
        }system.debug('pcs-1351'+pcs);
        if (!pcs.isEmpty()) {setPriceBookEntries(pcs);}
    }

    public static void setPriceBookEntries(List<Pricing_Condition__c> pca) {
        system.debug('Entering setPriceBookEntries.....');
        system.debug('List of PCNs');
        Map<String, Pricing_Condition__c> pcMap = new Map<String, Pricing_Condition__c>();
        Set<id> accIds = new Set<id>();
        Set<id> msd2ids = new Set<id>();
        Integer i = 0;
        String k1 = '';
        system.debug('pca-1361'+pca);
        for (Pricing_Condition__c p : pca) {
            k1 = '00000' + (++i);
            k1 = k1.substring(k1.length() - 5);
            pcMap.put(k1, p);
            system.debug('p-1366'+p);
            accIds.add(p.Account__c);
            msd2ids.add(p.Material2__c);
        }
        Map<Id, Map<String, List<Id>>> partnerIds = Account_Partner_Functions.getPartnerIds(accIds);
        Map<Id, Account> accMap = Account_Partner_Functions.getAccountsMap(partnerIds);
        List<Material_Sales_Data2__c> msd2s = Material_Sales_Data_Functions.getMaterialSalesData2s(msd2ids);
        Map<Id, Material_Sales_Data2__c> msd2map = Material_Sales_Data_Functions.getMaterialSalesData2Map(msd2s);
       // system.debug('pcMap line1374'+pcMap);
        //system.debug('accmap line1375'+accmap);
        //system.debug('msd2map line 1376'+msd2map);
        //system.debug('msd2map line 1377'+accIds);
        Map<String, Price_Book_Entry__c> pbemap = PriceBookEntryFunctions.getPriceBookEntries(pcMap, accMap, msd2map, accIds);
        //system.debug('Displayed from here');
        //system.debug('PC Map : ' + pcMap);
        system.debug('pbemap-1379 Visible:'+pbemap);
        Map<String, Double> ccrmap = CurrencyConverter.getConversionRateMap();
        Pricing_Condition__c p; Account acc; Double minPrice;
        List<Pricing_Condition_Scaled_Pricing__c> pcsps;
        system.debug('pcMap 1383 : '+pcMap);
        for (String k2 : pcMap.keySet()) {
            p = pcMap.get(k2); resetPriceBookEntryFields(p); 
            system.debug('accMap'+accMap);
            system.debug('msd2map'+msd2map);
            system.debug('accIds'+accIds);
            system.debug('pbemap 1384'+pbemap);
            if (pbemap != null) {
                system.debug('pbemap 1386'+pbemap);
                PriceBookEntryFunctions.setPriceBookEntryFields(p, pbemap, ccrmap, k2);
            }
            system.debug('p for Pricing con'+p);
            
            debug('setPriceBookEntries : ' + p.Name + ' : ' + p.Price_Book_Entry__c);
            pcsps = p.Pricing_Condition_Scaled_Pricing__r;
            if (pcsps != null && !pcsps.isEmpty()) {
                minPrice = getMinPrice(p, pcsps);
                acc = accMap.get(p.Account__c);
                PricingConditionApprovalCriteria.setRouteForApprovalFields(p, acc, minPrice);
            }
        }
    }

    private static void resetPriceBookEntryFields(Pricing_Condition__c pc) {
        pc.Price_Book_Entry__c = null; pc.Price_Book_Entry_Scaled_Pricing__c = null;
        pc.Floor_Price__c = null; pc.Market_Price__c = null;
        pc.Target_Gross_Profit_Percent__c = null;
    }

    private static void insertPricingScales(List<Pricing_Condition__c> ilist) {
        List<Pricing_Condition_Scaled_Pricing__c> pcsps = new List<Pricing_Condition_Scaled_Pricing__c>();
        for (Pricing_Condition__c p : ilist) {
            for (Pricing_Condition_Scaled_Pricing__c pcsp : p.Pricing_Condition_Scaled_Pricing__r) {
                pcsp.Id = null;
                pcsp.Pricing_Condition__c = p.Id;
                pcsp.CurrencyIsoCode = p.CurrencyIsoCode;
                pcsps.add(pcsp);
            }
        }
        try {insert pcsps;} catch(Exception e) {
            Set<String> msgs = new Set<String>(); msgs.add(e.getMessage()); Integer n = 0;
            for (Pricing_Condition_Scaled_Pricing__c pcsp : pcsps) {msgs.add(++n + ' : ' + pcsp);}
            //DebugLog_Functions.logMessages('PricingConditionFunctions', 'insertPricingScales', msgs);
        }
    }

    private static void insertPricingCompetitors(List<Pricing_Condition__c> ilist) {
        List<Pricing_to_Competitor__c> p2cs = new List<Pricing_to_Competitor__c>();
        for (Pricing_Condition__c p : ilist) {
            for (Pricing_to_Competitor__c p2c : p.Pricing_to_Competitor__r) {
                p2c.Id = null;
                p2c.Pricing_Condition__c = p.Id;
                p2cs.add(p2c);
            }
        }
        insert p2cs;
    }

    private static Set<String> getPricingConditionIds(List<Pricing_Condition__c> plist) {
        Set<String> ids = new Set<String>();
        for (Pricing_Condition__c p : plist) {
            ids.add(p.Id);
        }
        return ids;
    }

    private static Set<Id> getPricingConditionIds(List<Pricing_Condition> plist) {
        Set<Id> ids = new Set<Id>();
        for (Pricing_Condition p : plist) {
            ids.add(p.pricingCondition.Id);
        }
        return ids;
    }

    public static void updateValidityToDate(List<Pricing_Condition> slist, Date tdate) {
        List<Pricing_Condition__c> ulist = new List<Pricing_Condition__c>();
        for (Pricing_Condition pc : slist) {
            Pricing_Condition__c p = pc.pricingCondition;
            p.Valid_To_Date__c = tdate;
            ulist.add(p);
        }
        if (!ulist.isEmpty()) {
            update ulist;
        }
    }

    public static String getPricingConditionKey(Pricing_Condition__c pc) {
        String key = PricingConditionTables.getVAKey(pc) + pc.SAP_Pricing_Table__c;
        //debug('getPricingConditionKey : pc = ' + pc.Id + ' : key = ' + key);
        return key;
    }

    public static void deactivatePricingConditions(List<Pricing_Condition__c> pcs) {
        Date currentDate = System.today();
        Set<id> accIds = new Set<id>();
        Set<id> pcIds = new Set<id>();
        Set<id> matIds = new Set<id>();
        for (Pricing_Condition__c p : pcs) {
            if (!isExpired(p)) {
                setRecordStatus(p, currentDate);
            }
            if (p.Active__c) {
                accIds.add(p.Account__c);
                pcIds.add(p.id);
                matIds.add(p.Material2__c);
            }
        }
        if (pcIds.isEmpty()) {return;}
        List<Pricing_Condition__c> alist = getPricingConditions(pcIds);
        Map<String, List<Pricing_Condition__c>> amap = getActivePricingConditions(accIds, matIds, pcIds);
        if (amap.isEmpty()) {return;}
        List<Pricing_Condition__c> dlist = new List<Pricing_Condition__c>();
        Map<String, Pricing_Condition__c> bmap = new Map<String, Pricing_Condition__c>();
        List<Pricing_Condition__c> blist;
        for (Pricing_Condition__c pc : alist) {
            String key = getPricingConditionKey(pc);
            if (amap.containsKey(key)) {
            blist = amap.get(key);
            dlist.addAll(blist);
            for (Pricing_Condition__c b : blist) {bmap.put(b.Id, pc);}
            }
        }
        if (dlist.isEmpty()) {return;}
/*
        for (Pricing_Condition__c pc : dlist) {
            pc.Active__c = false;
            pc.Record_Status__c = EXPIRED;
            pc.Current_State__c = EXPIRED;
        }
        updatePricingConditions(dlist);
//*/
        expirePricingConditions(dlist, bmap);
    }

    private static Map<String, List<Pricing_Condition__c>> getActivePricingConditions(Set<Id> accIds,
                                                                                      Set<Id> matIds,
                                                                                      Set<Id> pcIds) {
        Map<String, List<Pricing_Condition__c>> amap = new Map<String, List<Pricing_Condition__c>>();
        String qry = SELECT_QRY_1 + ' where Active__c = true and Account__c in :accIds' +
                                    '   and Material2__c in :matIds and Id not in :pcIds';
        for (Pricing_Condition__c pc : Database.query(qry)) {
            if (pc != null) {
                String key = getPricingConditionKey(pc);
                addPricingCondition(amap, pc, key);
            }
        }
        return amap;
    }

    private static void addPricingCondition(Map<String, List<Pricing_Condition__c>> amap,
                                            Pricing_Condition__c pc, String key) {
        List<Pricing_Condition__c> alist;
        if (amap.containsKey(key)) {
            alist = amap.get(key);
        } else {
            alist = new List<Pricing_Condition__c>();
        }
        alist.add(pc);
        amap.put(key, alist);
    }

    private static Boolean notNull(String s) {
        return (s != null && s.trim().length() > 0);
    }

    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }

    public static Boolean isStreamLink(String divisionCode) {
        return (DVSN_STREAM_LINK == divisionCode);
    }

    private static Boolean isAHWTDivision(String divisionCode) {
        return (DVSNS_AHWT.contains(divisionCode));
    }

    public static Boolean isAAFI(Pricing_Condition__c pc) {
        return (pc != null && pc.Dist_Channel_Code__c == DIST_CHANNEL_AAFI);
    }

    public static Boolean isAHWT(Pricing_Condition__c pc) {
        return (pc != null && pc.Dist_Channel_Code__c == DIST_CHANNEL_AHWT);
    }

    private static Boolean isAPSalesOrg(Account acc) {
        return SAP_Queries_Functions.isAPSalesOrg(acc);
    }

    public static Integer getMaxDaysToExtend(Pricing_Condition__c pc) {
        String distChan = pc != null ? pc.Dist_Channel_Code__c : null;
        return getMaxDaysToExtend(distChan);
    }

    public static Integer getMaxDaysToExtend(String dc) {
        Integer n = 365;
        //if (dc != null && dc == DIST_CHANNEL_AAFI) {n = 90;}
        return n;
    }

    public static Boolean isActive(Pricing_Condition__c pc) {
        String rs = pc.Record_Status__c;
        Date fd = pc.Valid_From_Date__c;
        Date td = pc.Valid_To_Date__c;
        Date currentDate = System.today();
        Integer validUntil = currentDate.daysBetween(td);
        Boolean b = (pc.Active__c || rs == ACTIVE) &&
                    (fd <= currentDate);
        // allow upto one week after expiration
        //            (rs == EXPIRED && validUntil >= -7);
        return b;
    }

    public static Boolean isApproved(Pricing_Condition__c pc) {
        String rs = pc.Record_Status__c;
        Date fd = pc.Valid_From_Date__c;
        Date currentDate = System.today();
        Boolean b = (rs == APPROVED && fd > currentDate);
        return b;
    }

    public static Boolean isCancelled(Pricing_Condition__c pc) {
        String rs = pc.Record_Status__c;
        Boolean b = (rs == CANCELLED);
        return b;
    }

    public static Boolean isExpired(Pricing_Condition__c pc) {
        String rs = pc.Record_Status__c;
        Date td = pc.Valid_To_Date__c;
        Date currentDate = System.today();
        Boolean b = (rs == EXPIRED || td < currentDate);
        return b;
    }

    public static Boolean isSubmitted(Pricing_Condition__c pc) {
        return (pc.Record_Status__c == SUBMITTED);
    }

    public static List<Pricing_Condition> getSubmittedPricingConditions(List<Pricing_Condition__c> pcs) {
        List<Pricing_Condition> pclist = new List<Pricing_Condition>();
        Set<String> pcids = getPricingConditionIds(pcs);
        Map<Id, List<ProcessInstanceWorkItem>> pmap = Custom_Approval_Functions.getProcessInstanceWorkItems(pcids);
        Map<Id, Set<String>> amap = Custom_Approval_Functions.getApproverNames(pmap);
        Map<Id, Set<String>> emap = Custom_Approval_Functions.getApproverEmails(pmap);
        Map<Id, Datetime> tmap = Custom_Approval_Functions.getProcessInstanceTimes(pmap);
        for (Pricing_Condition__c p : pcs) {
            if (amap != null && amap.containsKey(p.Id)) {
                Pricing_Condition pc = new Pricing_Condition(p);
                pc.setApprovers(amap);
                if (tmap != null && tmap.containsKey(p.Id)) {
                    pc.submittedDateTime = tmap.get(p.Id);
                    pc.submittedTime = tmap.get(p.Id).format();
                }
                if (emap != null && emap.containsKey(p.Id)) {
                    pc.approverEmails = emap.get(p.Id);
                }
                pclist.add(pc);
            }
        }
        return pclist;
    }

    public static Map<String, List<String>> getFieldValues(Set<String> recstatus) {
        Map<String, List<String>> amap = new Map<String, List<String>>();
        Set<String> salesOffices = new Set<String>();
        String salesOffice;
        for (Pricing_Condition__c p : [select Id, Name,
                                              Account_Sales_Office__c
                                         from Pricing_Condition__c
                                        where Record_Status__c in :recstatus
                                      ]) {
            salesOffice = p.Account_Sales_Office__c;
            if (notNull(salesOffice) && !salesOffices.contains(salesOffice)) {
                salesOffices.add(salesOffice);
            }
        }
        addToMapAsSortedList(SALES_OFFICE_SET, amap, salesOffices);
        return amap;
    }

    private static void addToMapAsSortedList(String key,
                                             Map<String, List<String>> amap,
                                             Set<String> aset) {
        if (!aset.isEmpty()) {
            List<String> alist = new List<String>();
            alist.addAll(aset);
            alist.sort();
            amap.put(key, alist);
        }
    }

    public static Set<Id> getApprovedPCNIds(Set<Id> accIds) {
        Set<Id> pcids = new Set<Id>(); Date tdate = Date.today();
        for (Pricing_Condition__c p : [
            select Id from Pricing_Condition__c
             where Account__c in :accIds
               and Record_Status__c = :APPROVED
               and Valid_To_Date__c >= :tdate
             limit :MAX_REC_LIMIT]) {pcids.add(p.Id);}
        return pcids;
    }

    public static Integer getProspectPCNDaysLimit() {
        Pricing_Security__c ps = Pricing_Security__c.getOrgDefaults();
        Integer ndays = 60;
        if (ps != null && ps.Prospect_PCN_Days_Limit__c != null) {
            ndays = ps.Prospect_PCN_Days_Limit__c.intValue();}
        return ndays;
    }

    @future(callout = false)
    public static void processProspectPCNIds(Set<Id> pcIds) {
        debug('processProspectPCNIds : pcIds = ' + pcIds);
        if (pcIds == null || pcIds.isEmpty()) {return;}
        Integer ndays = getProspectPCNDaysLimit(); Date tdate = Date.today();
        for (List<Pricing_Condition__c> plist : [
            select Id, Name, Date_Pricing_Condition_Approved__c, Record_Status__c
              from Pricing_Condition__c
             where Id in :pcIds]) {processProspectPCNs(plist, ndays, tdate);}
    }

    public static void processProspectPCNs(Set<Id> accIds) {
        debug('processProspectPCNs : accIds = ' + accIds);
        if (accIds == null || accIds.isEmpty()) {return;}
        Integer ndays = getProspectPCNDaysLimit(); Date tdate = Date.today();
        for (List<Pricing_Condition__c> plist : [
            select Id, Name, Date_Pricing_Condition_Approved__c, Record_Status__c
              from Pricing_Condition__c
             where Account__c in :accIds
               and Record_Status__c = :APPROVED
               and Valid_To_Date__c >= :tdate
             limit :MAX_REC_LIMIT]) {processProspectPCNs(plist, ndays, tdate);}
    }

    @TestVisible
    private static void processProspectPCNs(List<Pricing_Condition__c> plist,
                                            Integer ndays, Date tdate) {
        debug('processProspectPCNs : plist.size = ' + plist.size());
        if (plist == null || plist.isEmpty()) {return;} Integer n;
        Set<String> sfaSet = new Set<String>(), updSet = new Set<String>();
        for (Pricing_Condition__c p : plist) {
            n = ndays + 1;
            if (p.Date_Pricing_Condition_Approved__c != null) {
                n = p.Date_Pricing_Condition_Approved__c.date().daysBetween(tdate);
            }
            debug('p = ' + p); debug('n = ' + n);
            if (n > ndays) {sfaSet.add(p.Id);} else {updSet.add(p.Id);}
        }
        debug('sfaSet.size = ' + sfaSet.size()); debug('updSet.size = ' + updSet.size());

        if (!sfaSet.isEmpty()) {submitForApproval(sfaSet);}

        if (!updSet.isEmpty()) {
            PricingConditionIDocFunctions.deleteIDocs(updSet);
            PricingConditionIDocFunctions.upsertIDocs(updSet, false);
        }
    }

/*
 **********************************************************
 WebServices
 **********************************************************
 */

    webservice static Boolean submitPricingConditionforApproval(String pcId) {

        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitting Pricing Condition for Approval.');
        req.setObjectId(pcId); Boolean b = false; Approval.ProcessResult apr;
        try {
            apr = Approval.process(req); b = apr.isSuccess();
        } catch(Exception e) {debug(e.getMessage());}
        return b;
    }

    webservice static Double getFreightUpcharge(Double basePrice,
                                                Double freightCost,
                                                Double freightMarkup,
                                                String divisionCode) {
        Pricing_Condition__c p = new Pricing_Condition__c();
        p.Base_Price__c = basePrice;
        p.Freight_Cost__c = freightCost;
        p.Freight_Mark_Up__c = freightMarkup;
        calculateFreightUpcharge(p);

        return p.Freight_Up_Charge__c;
    }

    webservice static Double getInvoicePrice(Boolean applyDiscount,
                                             Double  basePrice,
                                             Double  contractDuration,
                                             Double  discountPercent,
                                             String  divisionCode,
                                             Boolean equipOnInvoice,
                                             Double  equipUpcharge,
                                             Double  fleetCost,
                                             Double  freightCost,
                                             Double  freightMarkup,
                                             Double  leadTime,
                                             Double  otc,
                                             Double  otherUpcharge,
                                             Double  packaging,
                                             Double  paymentTerms,
                                             Double  productSupportCost,
                                             Double  programCost,
                                             Double  relabel,
                                             Double  service) {
        Pricing_Condition__c pc = new Pricing_Condition__c();
        pc.Base_Price__c = basePrice;
        pc.Contract_Duration__c = contractDuration;
        pc.Discount_Percent__c = discountPercent;
        pc.Equipment_On_Invoice__c = equipOnInvoice;
        pc.Equipment_Up_Charge__c = equipUpcharge;
        pc.Fleet_Cost__c = fleetCost;
        pc.Freight_Cost__c = freightCost;
        pc.Freight_Mark_Up__c = freightMarkup;
        pc.Lead_Time__c = leadTime;
        pc.OTC__c = otc;
        pc.Other_Up_Charge__c = otherUpcharge;
        pc.Packaging__c = packaging;
        pc.Product_Support_Cost__c = productSupportCost;
        pc.Program_Cost__c = programCost;
        pc.Streamlink_EU_Payment_Terms__c = paymentTerms;
        pc.Relabel__c = relabel;
        pc.Service__c = service;
        double upcharges = getTotalUpcharges(pc);
        setInvoicePrice(pc, divisionCode, upcharges);
        if (applyDiscount) {
            return pc.Invoice_Price__c;
        } else {
            return pc.Selling_Price__c;
        }
    }

    webservice static List<User> getAqualonIndustryManagers() {
        List<User> ulist = new List<User>();
        List<Pricing_Condition_Approvers__c> alist = [select Approver__r.Id,
                                                            Approver__r.Name
                                                        from Pricing_Condition_Approvers__c
                                                    where Business__c = 'AAFI'
                                                        and Approval_Level__c = '1'
                                                    ];
        if (!alist.isEmpty()) {
            for (Pricing_Condition_Approvers__c a : alist) {
                ulist.add(a.Approver__r);
            }
        }
        return ulist;
    }

    webservice static Double getRebateAmount(Id accId, Id matId, Date validFromDate, Date validToDate,
        Double invoicePrice, String currencyCode, String uomCode) {
        //Date validToDate = Date.today(); Double invoicePrice = 1.0;
        Double rebateAmount = Pricing_Rebate_Functions.getRebateAmount(
            accId, matId, validFromDate, validToDate, invoicePrice, currencyCode, uomCode);
        return rebateAmount;
    }

/*
 **********************************************************
 Test Methods are in PricingConditionFunctions_Test class
 **********************************************************
 */

}
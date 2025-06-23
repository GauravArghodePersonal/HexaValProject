public class PricingConditionIDocFunctions {

    public static final String CANCELLED = 'Cancelled';
    public static final String CREATED = 'Created';
    public static final String UPDATED = 'Updated';
    public static final String EXPORTED = 'Exported';
    public static final String DISTRIBUTORS = 'DISTRIBUTORS';

    public static final Integer RECORDS_LIMIT = 50;

    public static final Set<String> PC_REC_STATS = new Set<String>{
        PricingConditionFunctions.ACTIVE,
        PricingConditionFunctions.APPROVED,
        PricingConditionFunctions.CANCELLED
    };

    public static final String DIST_CHANNEL_AHWT = '10';
    public static final String DIST_CHANNEL_AAFI = '50';

    public enum IdocType {OFFLIST_PRICE, INVCE_DSCOUNT, EQPMNT_UPCHRG}

    // Currency Codes for 4 decimals
    public static final Map<String, String> CC4_MAP = new Map<String, String>{
        'CAD' => 'CA4', 'CNY' => 'CN4', 'DKK' => 'DK4', 'EUR' => 'EU4',
        'GBP' => 'GB4', 'MXN' => 'MX4', 'NOK' => 'NO4', 'PLN' => 'PL4',
        'RUB' => 'RU4', 'SEK' => 'SE4', 'SGD' => 'SG4', 'USD' => 'US4',
        'ZAR' => 'ZA4'
    };

    public static final Map<String, String> UOM_ISO_CODES = getUomCodes();

    private static final String CNFG_DELIM = '-';
    private static final List<PricingIDocsConfig__c> CNFG_LIST = PricingIDocsConfig__c.getAll().values();

    private static final Set<String> CNFG_REC_KEYS = getConfigRecordKeys();

    public static final String SELECT_QRY_1 = 'select Id, Name, '
        + 'IDoc__c, Key__c, PC_Status__c, Pricing_Condition__c, Status__c '
        + 'from Pricing_Condition_IDoc__c ';

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>>> ' + s);
    }

    private static Set<String> getConfigRecordKeys() {
        Set<String> aset = new Set<String>();
        for (PricingIDocsConfig__c p : CNFG_LIST) {
            if (p.CreateIDoc__c) {aset.add(p.RecordKey__c);}
        }
        return aset;
    }

    public static void createIDoc(String pcid) {
        createIDocs(new Set<String>{pcid});
    }

    public static void createIDocs(Set<String> pcids) {
        List<Pricing_Condition_IDoc__c> idocs = upsertIDocs(pcids);
        updateIDocs(idocs);
    }

    public static void deleteIDoc(String pcid) {
        deleteIDocs(new Set<String>{pcid});
    }

    public static void deleteIDocs(Set<String> pcids) {
        String qry = SELECT_QRY_1 + ' where Status__c = :EXPORTED and Pricing_Condition__c in :pcids';
        List<Pricing_Condition_IDoc__c> idocs = Database.query(qry);
        if (idocs == null || idocs.isEmpty()) {return;}
        try {delete idocs;} catch(Exception e){}
    }

    public static List<Pricing_Condition_IDoc__c> upsertIDocs(Set<String> pcids) {return upsertIDocs(pcids, true);}

    public static List<Pricing_Condition_IDoc__c> upsertIDocs(Set<String> pcids, Boolean excludeProspects) {
        if (pcids == null || pcids.isEmpty()) {return null;}
        List<Pricing_Condition__c> pcs = getPricingConditions(pcids);
        Set<String> exportedPCIds = getExportedPricingConditionIds(pcids);
        List<Pricing_Condition_IDoc__c> idocs = new List<Pricing_Condition_IDoc__c>();
        Pricing_Condition_IDoc__c idoc; String cnfgRecKey;
        for (Pricing_Condition__c pc : pcs) {
            if (excludeProspects && pc.Account__r != null && pc.Account__r.AccountNumber != null &&
                pc.Account__r.AccountNumber.startsWith('P')) {continue;}
            cnfgRecKey = pc.Material2__r.Dist_Channel_Code__c + CNFG_DELIM + pc.Material2__r.Sales_Org_Code__c;
            if (PC_REC_STATS.contains(pc.Record_Status__c) && CNFG_REC_KEYS.contains(cnfgRecKey) &&
            !exportedPCIds.contains(pc.Id)) {
                //debug(''+pc);
                idoc = new Pricing_Condition_IDoc__c();
                idoc.Key__c = pc.Id;
                idoc.Pricing_Condition__c = pc.Id;
                idocs.add(idoc);
            }
        }
        try {
            //debug(''+idocs);
            if (!idocs.isEmpty()) {
                upsert idocs Pricing_Condition_IDoc__c.Fields.Key__c;
            }
            return idocs;
        } catch(Exception e) {debug(e.getMessage());}
        return null;
    }

    private static Set<String> getExportedPricingConditionIds(Set<String> pcids) {
        Set<String> eset = new Set<String>();
        String qry = SELECT_QRY_1 + ' where Status__c = :EXPORTED and Pricing_Condition__c in :pcids';
        for (Pricing_Condition_IDoc__c idoc : Database.query(qry)) {eset.add(idoc.Pricing_Condition__c);}
        return eset;
    }

    public static Database.Querylocator getQueryLocator(Integer recordsLimit) {
        Database.Querylocator ql; String qry = SELECT_QRY_1;
        qry += ' where Status__c = :CREATED';
        qry += '   and PC_Status__c in :PC_REC_STATS';
        qry += ' limit :recordsLimit';
        ql = Database.getQueryLocator(qry);
        return ql;
    }

    public static void updateIDocs() {
        updateIDocs(RECORDS_LIMIT);
    }

    public static void updateIDocs(Integer recordsLimit) {
        String q = getQueryLocator(recordsLimit).getQuery();
        for (List<Pricing_Condition_IDoc__c> idocs : Database.query(q)) {
            updateIDocs(idocs);
        }
    }

    public static void updateIDocs(List<Pricing_Condition_IDoc__c> idocs) {
        if (idocs == null || idocs.isEmpty()) {return;}
        Map<String, Pricing_Condition__c> pcmap = getPCMap(idocs);
        Pricing_Condition__c pc; String idocString;
        List<Pricing_Condition_IDoc__c> ulist = new List<Pricing_Condition_IDoc__c>(),
                                        dlist = new List<Pricing_Condition_IDoc__c>();
        for (Pricing_Condition_IDoc__c idoc : idocs) {
            pc = pcmap.get(idoc.Pricing_Condition__c);
            idocString = getIDocString(pc);
            //debug(idocString);
            if (isNotNull(idocString)) {
                idoc.IDoc__c = idocString;
                idoc.Status__c = UPDATED;
                ulist.add(idoc);
            } else {dlist.add(idoc);}
        }
        try {
            if (!dlist.isEmpty()) {delete dlist;}
            if (!ulist.isEmpty()) {update ulist;}
        } catch(Exception e) {debug(e.getMessage());}
    }

    private static Map<String, Pricing_Condition__c> getPCMap(List<Pricing_Condition_IDoc__c> idocs) {
        Map<String, Pricing_Condition__c> pcmap = new Map<String, Pricing_Condition__c>();
        Set<String> pcids = new Set<String>();
        for (Pricing_Condition_IDoc__c idoc : idocs) {
            pcids.add(idoc.Pricing_Condition__c);
        }
        debug('getPCMap : pcids : '+ pcids);
        String q = PricingConditionFunctions.SELECT_QRY_1 +
                   ' where Id in :pcids';
        for (Pricing_Condition__c pc : Database.query(q)) {
            pcmap.put(pc.Id, pc);
        }
        return pcmap;
    }

    public static List<String> getUpdatedIDocs(Integer batchSize) {
        List<String> slist = new List<String>();
        for (Pricing_Condition_IDoc__c r : [
            select IDoc__c from Pricing_Condition_IDoc__c
             where Status__c = :UPDATED limit :batchSize]) {
            if (isNotNull(r.IDoc__c)) {slist.add(r.Id + r.IDoc__c);}
        }
        return slist;
    }

    public static void setExportStatus(List<String> idocIds, Integer batchSize) {
        if (idocIds == null || idocIds.isEmpty()) {return;}
        List<Pricing_Condition_IDoc__c> ulist = new List<Pricing_Condition_IDoc__c>();
        List<Pricing_Condition__c> plist = new List<Pricing_Condition__c>();
        try {
            for (Pricing_Condition_IDoc__c r : [
                select IDoc__c, Pricing_Condition__c,
                    Pricing_Condition__r.Exported_to_IDoc__c
                from Pricing_Condition_IDoc__c
                where Id in :idocIds
                and Status__c = :UPDATED
                limit :batchSize]) {
                ulist.add(new Pricing_Condition_IDoc__c(Id=r.Id, Status__c=EXPORTED, IDoc__c=null));
                plist.add(new Pricing_Condition__c(Id=r.Pricing_Condition__c, Exported_to_IDoc__c=true));
            }
            if (!ulist.isEmpty()) {update ulist;}
            if (!plist.isEmpty()) {update plist;}
        }
        catch(Exception e) {}
    }

    private static Map<String, String> getUOMCodes() {
        Map<String, String> amap = new Map<String, String>();
        for (SAP_UOM_Code__c uom : [select ISO_Code__c,
                                           UOM_Code__c
                                      from SAP_UOM_Code__c
                                     where Deleted__c = false
                                   ]) {
           if (isNotNull(uom.UOM_Code__c)) {
               amap.put(uom.UOM_Code__c, uom.ISO_Code__c);
           }
        }
        return amap;
    }

    private static List<Pricing_Condition__c> getPricingConditions(Set<String> pcids) {
        String q = PricingConditionFunctions.SELECT_QRY_1;
        q += ' where id in :pcids';
        List<Pricing_Condition__c> pcs = Database.query(q);
        return pcs;
    }

    private static Pricing_Condition__c getPricingCondition(String pcid) {
        Set<String> pcids = new Set<String>{pcid};
        List<Pricing_Condition__c> pcs = getPricingConditions(pcids);
        return pcs[0];
    }

    public static String getIDocString(String pcid) {
        Pricing_Condition__c pc = getPricingCondition(pcid);
        return getIDocString(pc);
    }

    public static String getIDocString(Pricing_Condition__c pc) {
        if (pc == null) {return '';}
        XmlStreamWriter xsw = new XmlStreamWriter();
        //xsw.writeStartDocument('UTF-8', '1.0');
        //writeStartElement(xsw, 'ZCOND_A');
        String tbl = pc.SAP_Pricing_Table__c;
        debug(pc.Name + ' : SAP_Pricing_Table__c : ' + tbl);
        if (isNotNull(tbl)) {writeIDoc(IDocType.OFFLIST_PRICE, xsw, pc);}
        tbl = pc.Discount_Condition_Table__c;
        debug(pc.Name + ' : Discount_Condition_Table__c : ' + tbl);
        if (isNotNull(tbl)) {writeIDoc(IDocType.INVCE_DSCOUNT, xsw, pc);}
        tbl = pc.Equipment_Upcharge_Table__c;
        debug(pc.Name + ' : Equipment_Upcharge_Table__c : ' + tbl);
        if (isNotNull(tbl)) {writeIDoc(IDocType.EQPMNT_UPCHRG, xsw, pc);}
        //xsw.writeEndElement();
        //xsw.writeEndDocument();
        String xmlString = xsw.getXmlString();
        xsw.close();
        return xmlString;
    }

    private static void writeIDoc(IDocType idt, XmlStreamWriter xsw, Pricing_Condition__c pc) {
        writeStartElement(xsw, 'IDOC');
        writeAttribute(xsw, 'BEGIN','1');
        writeEDIDC40(xsw);
        writeE1KOMG(idt, xsw, pc);
        xsw.writeEndElement();
    }

    private static void writeAttribute(XmlStreamWriter xsw, String n, String v) {
        xsw.writeAttribute(null, null, n, v);
    }

    private static void writeElement(XmlStreamWriter xsw, String e, String c) {
        writeStartElement(xsw, e);
        if (isNotNull(c)) {xsw.writeCharacters(c.trim());}
        xsw.writeEndElement();
    }

    private static Boolean isNotNull(String s) {
        return (s != null && s.trim().length() > 0);
    }

    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }

    private static Boolean isAHWT(Pricing_Condition__c pc) {
        return (pc.Dist_Channel_Code__c == DIST_CHANNEL_AHWT);
    }

    private static Boolean isAAFI(Pricing_Condition__c pc) {
        return (pc.Dist_Channel_Code__c == DIST_CHANNEL_AAFI);
    }

    private static Boolean isOLP(IDocType idt) {return (idt == IDocType.OFFLIST_PRICE);}
    private static Boolean isOID(IDocType idt) {return (idt == IDocType.INVCE_DSCOUNT);}
    private static Boolean isEUC(IDocType idt) {return (idt == IDocType.EQPMNT_UPCHRG);}

    private static String getDateString(Date d) {
        String formattedDate = '';
        String formatString = 'yyyyMMdd';

        if (d != null) {
            Datetime dt = Datetime.newInstance(d.year(), d.month(), d.day());
            if ((formatString != null) && (formatString.length() > 0)) {
                formattedDate = dt.format(formatString);
            }
            else {
                formattedDate = dt.format();
            }
        }

        return formattedDate;
    }

    private static Integer getDecimals(Decimal d) {
        Integer n = 2;
        if (d == null) {return n;}
        try {
            String s = d.stripTrailingZeros().toPlainString();
            if (s.indexOf('.') >= 0) {
                List<String> sa = s.split('\\.');
                //debug(''+sa);
                if (sa.size() > 1) {
                    n = sa[1].length();
                    if (sa[1].length() < 2) {n = 2;}
                    if (sa[1].length() > 4) {n = 4;}
                }
            }
        } catch (Exception e) {}
        return n;
    }

    private static String getString(Double d) {
        if (d == null) {d = 0.0000;} return ('' + d);
    }

    private static String getString(Decimal d) {
        if (d == null) {d = 0.0000;} return ('' + d);
    }

    private static String getString(String s, Integer n) {
        String t = '';
        //debug(s);
        if (s != null) {
            t = s.trim();
            if (t.length() > n) {t = t.substring(0,n);}
        }
        return t;
    }

    private static void writeStartElement(XmlStreamWriter xsw, String s) {
        xsw.writeStartElement(null, s, null);
    }

    private static void writeEmptyElement(XmlStreamWriter xsw, String s) {
        xsw.writeEmptyElement(null, s, null);
    }

    private static void writeEDIDC40(XmlStreamWriter xsw) {
        writeStartElement(xsw, 'EDI_DC40');
        writeAttribute(xsw, 'SEGMENT','1');
        writeEmptyElement(xsw, 'TABNAM');
        writeEmptyElement(xsw, 'MANDT');
        writeEmptyElement(xsw, 'DOCNUM');
        writeEmptyElement(xsw, 'DOCREL');
        writeEmptyElement(xsw, 'STATUS');
        writeEmptyElement(xsw, 'DIRECT');
        writeEmptyElement(xsw, 'OUTMOD');
        writeEmptyElement(xsw, 'EXPRSS');
        writeEmptyElement(xsw, 'TEST');
        writeEmptyElement(xsw, 'IDOCTYP');
        writeEmptyElement(xsw, 'CIMTYP');
        writeEmptyElement(xsw, 'MESTYP');
        writeEmptyElement(xsw, 'MESCOD');
        writeEmptyElement(xsw, 'MESFCT');
        writeEmptyElement(xsw, 'STD');
        writeEmptyElement(xsw, 'STDVRS');
        writeEmptyElement(xsw, 'STDMES');
        writeEmptyElement(xsw, 'SNDPOR');
        writeEmptyElement(xsw, 'SNDPRT');
        writeEmptyElement(xsw, 'SNDPFC');
        writeEmptyElement(xsw, 'SNDPRN');
        writeEmptyElement(xsw, 'SNDSAD');
        writeEmptyElement(xsw, 'SNDLAD');
        writeEmptyElement(xsw, 'RCVPOR');
        writeEmptyElement(xsw, 'RCVPRT');
        writeEmptyElement(xsw, 'RCVPFC');
        writeEmptyElement(xsw, 'RCVPRN');
        writeEmptyElement(xsw, 'RCVSAD');
        writeEmptyElement(xsw, 'RCVLAD');
        writeEmptyElement(xsw, 'CREDAT');
        writeEmptyElement(xsw, 'CRETIM');
        writeEmptyElement(xsw, 'REFINT');
        writeEmptyElement(xsw, 'REFGRP');
        writeEmptyElement(xsw, 'REFMES');
        writeEmptyElement(xsw, 'ARCKEY');
        String s = Datetime.now().format('yyyyMMddHHmmss');
        writeElement(xsw, 'SERIAL', s);
        xsw.writeEndElement();
    }

    private static void writeE1KOMG(IDocType idt, XmlStreamWriter xsw, Pricing_Condition__c pc) {
        String tabnr = getKOTABNR(idt, pc);
        String kschl = getKSCHL(idt, pc);
        String vakey = PricingConditionTables.getVAKey(pc, 'A'+tabnr);
        String fdate = getDateString(pc.Valid_From_Date__c);
        String tdate = getDateString(pc.Valid_To_Date__c);
        writeStartElement(xsw, 'E1KOMG');
        writeAttribute(xsw, 'SEGMENT','1');
        writeElement(xsw, 'KVEWE', 'A');
        writeElement(xsw, 'KOTABNR', tabnr);
        writeElement(xsw, 'KAPPL', 'V');
        writeElement(xsw, 'KSCHL', kschl);
        writeElement(xsw, 'VAKEY', vakey);
        writeElement(xsw, 'VKORG', pc.Material2__r.Sales_Org_Code__c);
        writeElement(xsw, 'VTWEG', pc.Dist_Channel_Code__c);
        writeElement(xsw, 'SPART', pc.Account__r.SAP_DivisionCode__c);
        writeElement(xsw, 'KUNNR', pc.Account__r.AccountNumber);
        writeElement(xsw, 'MATNR', pc.Material2__r.Material_Number__c);
        writeElement(xsw, 'POSNR', '000001');
        writeElement(xsw, 'VAKEY_LONG', vakey);
        writeZ1KONH(idt, xsw, pc, tabnr, fdate, tdate);
        writeE1KONH(idt, xsw, pc, kschl, fdate, tdate);
        xsw.writeEndElement();
    }

    private static String getKOTABNR(IDocType idt, Pricing_Condition__c pc) {
        String s = '';
        if (isOLP(idt)) {s = pc.SAP_Pricing_Table__c;}
        else if (isOID(idt)) {s = pc.Discount_Condition_Table__c;}
        else if (isEUC(idt)) {s = pc.Equipment_Upcharge_Table__c;}
        if (s != null && s.length() > 1) return s.substring(1);
        return s;
    }

    private static String getKSCHL(IDocType idt, Pricing_Condition__c pc) {
        String s = '';
             if (isOLP(idt)) {s = 'Z00A';}
        else if (isOID(idt)) {s = 'Z209';}
        else if (isEUC(idt)) {s = 'Z398';
            if (pc.Equipment_On_Invoice__c)
                            {s = 'Z326';}
        }
        return s;
    }

    private static void writeZ1KONH(IDocType idt, XmlStreamWriter xsw,
                                    Pricing_Condition__c pc, String tabnr,
                                    String fdate, String tdate) {
        String c = '.';
        writeStartElement(xsw, 'Z1KONH');
        writeAttribute(xsw, 'SEGMENT','1');
        writeElement(xsw, 'KOTABNR', tabnr);
        writeElement(xsw, 'DATAB', fdate);
        writeElement(xsw, 'DATBI', tdate);
        String ernam = getString(pc.Account_Owner__r.Ashland_Employee_Number__c, 10);
        writeElement(xsw, 'ERNAM', ernam);
        writeElement(xsw, 'KTEXT', pc.Name);
        xsw.writeEndElement();
    }

    private static void writeE1KONH(IDocType idt, XmlStreamWriter xsw,
                                    Pricing_Condition__c pc, String kschl,
                                    String fdate, String tdate) {
        writeStartElement(xsw, 'E1KONH');
        writeAttribute(xsw, 'SEGMENT','1');
        writeElement(xsw, 'DATAB', fdate);
        writeElement(xsw, 'DATBI', tdate);
        writeE1KONP(idt, xsw, pc, kschl);
        xsw.writeEndElement();
    }

    private static void writeE1KONP(IDocType idt, XmlStreamWriter xsw,
                                    Pricing_Condition__c pc, String kschl) {
        Boolean oid = isOID(idt);
        writeStartElement(xsw, 'E1KONP');
        writeAttribute(xsw, 'SEGMENT','1');
        writeElement(xsw, 'KSCHL', kschl);
        String kbetr = getKBETR(idt, pc);
        writeElement(xsw, 'KBETR', kbetr);
        String konwa = getKONWA(idt, pc);
        writeElement(xsw, 'KONWA', konwa);
        String kpein = '00001';
        if (oid) {kpein = '00000';}
        writeElement(xsw, 'KPEIN', kpein);
        String uom;
        if (!oid) {
            uom = pc.Selling_UOM__c;
            if (UOM_ISO_CODES.containsKey(uom)) {uom = UOM_ISO_CODES.get(uom);}
            writeElement(xsw, 'KMEIN', uom);
            writeElement(xsw, 'KZNEP', 'X');
        }
        String krech = 'C';
        if (oid) {krech = 'A';}
        writeElement(xsw, 'KRECH', krech);
        Boolean sp = isScaledPricing(idt, pc);
        if (!oid) {
            writeElement(xsw, 'STFKZ', 'A');
            writeElement(xsw, 'KZBZG', 'C');
            uom = pc.Volume_UOM__c;
            if (UOM_ISO_CODES.containsKey(uom)) {uom = UOM_ISO_CODES.get(uom);}
            if (sp) {writeElement(xsw, 'KONMS', uom);}
        }
        if (CANCELLED.equals(pc.Record_Status__c)) {
            writeElement(xsw, 'LOEVM_KO', 'X');
        }
        if (sp) {writeE1KONM(xsw, pc);}
        xsw.writeEndElement();
    }

    private static Boolean isScaledPricing(IDocType idt, Pricing_Condition__c pc) {
        Boolean b1 = isOLP(idt) && !isDistributor(pc);
        Boolean b2 = false;
        Double d = 0.0;
        List<Pricing_Condition_Scaled_Pricing__c> sps = pc.Pricing_Condition_Scaled_Pricing__r;
        if (sps != null && !sps.isEmpty()) {
            d = sps[0].Minimum_Volume__c;
            Integer n = sps.size();
            b2 = (n > 1 || (n < 2 && d > 0));
        }
        return b1 && b2;
    }

    private static Boolean isDistributor(Pricing_Condition__c pc) {
        return (pc.Dist_Channel_Code__c == DIST_CHANNEL_AAFI &&
                pc.Customer_Group1_Desc__c == DISTRIBUTORS);
    }

    private static String getKBETR(IDocType idt, Pricing_Condition__c pc) {
        String s = '';
             if (isOLP(idt)) {s = '' + pc.Selling_Price__c;}
        else if (isOID(idt)) {s = '-' + pc.Discount_Percent__c;}
        else if (isEUC(idt)) {s = '' + pc.Equipment_Up_Charge__c;}
        return s;
    }

    private static String getKONWA(IDocType idt, Pricing_Condition__c pc) {
        if (isOID(idt)) {return '%';}
        String s = pc.CurrencyIsoCode;
        Integer n = 2;
             if (isOLP(idt)) {n = getSellingPriceDecimals(pc);}
        else if (isEUC(idt)) {n = getDecimals(pc.Equipment_Up_Charge__c);}
        if (n > 2 && CC4_MAP.containsKey(s)) {s = CC4_MAP.get(s);}
        return s;
    }

    private static Integer getSellingPriceDecimals(Pricing_Condition__c pc) {
        Integer n1 = 2, n2 = n1;
        List<Pricing_Condition_Scaled_Pricing__c> sps = pc.Pricing_Condition_Scaled_Pricing__r;
        if (sps == null) {return n2;}
        for (Pricing_Condition_Scaled_Pricing__c sp : sps) {
            n1 = getDecimals(sp.Selling_Price_with_Upcharges__c);
            if (n1 > n2) {n2 = n1;}
        }
        return n2;
    }

    private static void writeE1KONM(XmlStreamWriter xsw, Pricing_Condition__c pc) {
        String c = '.';
        List<Pricing_Condition_Scaled_Pricing__c> sps = pc.Pricing_Condition_Scaled_Pricing__r;
        if (sps == null) {return;}
        for (Pricing_Condition_Scaled_Pricing__c sp : sps) {
            writeStartElement(xsw, 'E1KONM');
            writeElement(xsw, 'KSTBM', getString(sp.Minimum_Volume__c));
            writeElement(xsw, 'KBETR', getString(sp.Selling_Price_with_Upcharges__c));
            xsw.writeEndElement();
        }
    }

}
public class Sample_Request_Config {

    public static final String DELIM = ' - ';
    public static final String COMMA = ',';

    public static final String ACM = 'ACM';
    public static final String ALL = 'ALL';
    public static final String APM = 'APM';
    public static final String ASI = 'ASI';
    public static final String ASK = 'ASK';
    public static final String AWT = 'AWT';
    public static final String CMC = 'CMC';
    public static final String LAB = 'LAB';
    public static final String MSD = 'MSD';
    public static final String OTH = 'OTH';
    public static final String SPS = 'SPS';

    public static final String DC_AWT = '10';
    public static final String DC_APM = '20';
    public static final String DC_ACM = '40';
    public static final String DC_ASI = '50';
    public static final String DC_ASK = 'Y0';
    public static final String DC_ALL = 'ZZ';

    // Sample Centers
    public static final String CMC_EU = 'CMC EU';
    public static final String CMC_US = 'CMC US';
    public static final String SC_JNG = 'Jiangmen';
    public static final String SC_OTH = 'Other';
    public static final String SC_NNJ = 'Nanjing';
    public static final String SC_ASH = 'Ashland Catalog';
    public static final String SC_PLC = 'Private Label Catalog';

    // Reasons for Sample
    public static final String RFS_APM_01 = 'Trial';
    public static final String RFS_APM_02 = 'University or Institution';
    public static final String RFS_APM_03 = 'Technical Issue';
    public static final String RFS_APM_04 = 'New Business- Opportunity';
    public static final String RFS_APM_05 = 'Lab test';
    public static final String RFS_APM_06 = 'Sample/Stock Room Replenish';
    public static final String RFS_APM_07 = 'Testing';
    public static final String RFS_APM_08 = 'Sample for Distributor';
    public static final String RFS_APM_09 = 'Customer Evaluation';
    public static final String RFS_APM_10 = 'Replace existing material';
    public static final String RFS_APM_11 = 'Evaluation';
    public static final String RFS_APM_12 = 'Food trial';
    public static final String RFS_APM_13 = 'Free material';

    public static final String RFS_ASI_01 = 'Qualification';
    public static final String RFS_ASI_02 = 'Customer Testing / R & D';
    public static final String RFS_ASI_03 = 'Lab Trials';
    public static final String RFS_ASI_04 = 'New Customer Formulation';
    public static final String RFS_ASI_05 = 'Restocking Lab Shelves';
    public static final String RFS_ASI_06 = 'University or Institution';
    public static final String RFS_ASI_07 = 'Sample for Distributor';
    //Code Chnage on 12/3/2021 for ESA – Equipment Supply Agreement
    public static final String RFS_ASI_08 = 'ESA - Equipment Supply Agreement';
	//Added by SandhyaCH 9/13/2023 for LA approval process 60-62
	public static final String RFS_ASI_09 = 'Samples';
    public static final String RFS_ASI_10 = 'Trials';
    public static final String RFS_ASI_11 = 'Bonification';
    public static final String RFS_OTHER  = 'Other';

    // Ship From Locations
    public static final List<String> SFL_ASI = Custom_Config_Functions.getCCList('Sample_Plants_50__c');
    public static final String SFL_OTHER  = 'Other';

    // ASI Auto Approval related
    public static final Set<String> ASI_VCP_RATINGS = new Set<String>{'AA', 'ZA', 'A', 'B'};
    public static final Integer ASI_MATERIALS_LIMIT = 3;
    public static final Integer ASI_QUANTITY_LIMIT  = 2;

    public static final String QTY1 = 'QTY1';
    public static final String QTY2 = 'QTY2';
    public static final String QTY3 = 'QTY3';

    public static final Map<String, String> DC_KEYS =
                    new Map<String, String>{
        DC_AWT => AWT, DC_APM => APM, DC_ACM => ACM, DC_ASI => ASI, DC_ASK => ASK, DC_ALL => ALL
    };

    public static final Map<String, String> DC_LABELS =
                    new Map<String, String>{
        DC_AWT => 'Ashland Water Technologies',
        DC_APM => 'Ashland Performance Materials',
        DC_ACM => 'Ashland Consumer Markets',
        DC_ASI => 'Ashland Speciality Ingredients'
    };

    public static final Map<String, String> ACC_RT_KEYS =
                    new Map<String, String>{
          'Aqualon Customer'                      => ASI
        , 'Aqualon Prospect'                      => ASI

        , 'Drew Customer'                         => AWT
        , 'Drew Other Account'                    => AWT
        , 'Water Prospect'                        => AWT
        , 'Pool Solutions NonERP'                        => AWT

        , 'Flint Other Account'                   => APM
        , 'Performance Materials Customer'        => APM
        , 'Performance Materials Other Account'   => APM
        , 'Performance Materials Prospect'        => APM
        , 'Performance Materials Prospect - CAST' => APM
        , 'Performance Materials Prospect - CP'   => APM
        , 'Performance Materials Prospect - SPA'  => APM

        , 'Valvoline Customer'                    => ACM
        , 'Valvoline DIFM EMEA Prospect'          => ACM
        , 'Valvoline DIFM Prospect'               => ACM
        , 'Valvoline DIY Prospect'                => ACM
        , 'Valvoline Other DIY Account'           => ACM

        , 'ASK Other Account'                     => ASK
    };

    public static final Map<String, List<String>> SAMPLE_CENTERS =
                    new Map<String, List<String>>{
          OTH => new List<String>{SC_OTH}
        , ALL => new List<String>{CMC_US, CMC_EU, SC_JNG, SC_NNJ, SC_ASH, SC_PLC}
        , ACM => new List<String>{SC_OTH}
        , ASK => new List<String>{SC_OTH}
        , APM => new List<String>{SC_ASH, SC_OTH}
        , ASI => new List<String>{CMC_US, CMC_EU, SC_JNG, SC_NNJ, SC_ASH, SC_PLC}
        , AWT => new List<String>{SC_ASH}
        , CMC => new List<String>{CMC_EU, CMC_US}
        , LAB => new List<String>{SC_ASH}
        , MSD => new List<String>{SC_ASH, SC_PLC}
        , SPS => new List<String>{CMC_EU}
    };
//Code change in 12/3/2021 for Sigura Picklist value RFS_ASI_08
////Added by SandhyaCH 9/13/2023 for LA approval process 144,148
    public static final Map<String, List<String>> SAMPLE_REASONS =
                    new Map<String, List<String>>{
          OTH => new List<String>{RFS_OTHER}

        , APM => new List<String>{RFS_APM_01, RFS_APM_02, RFS_APM_03, RFS_APM_04,
                                  RFS_APM_05, RFS_APM_06, RFS_APM_07, RFS_APM_08,
                                  RFS_APM_09, RFS_APM_10, RFS_APM_11, RFS_APM_12,
                                  RFS_APM_13, RFS_OTHER}

        , ASI => new List<String>{RFS_ASI_01, RFS_ASI_02, RFS_ASI_03, RFS_ASI_04,
                                  RFS_ASI_05, RFS_ASI_06, RFS_ASI_07, RFS_ASI_08,
            					  RFS_ASI_09, RFS_ASI_10, RFS_ASI_11, RFS_OTHER}

        , AWT => new List<String>{RFS_ASI_01, RFS_ASI_02, RFS_ASI_03, RFS_ASI_04,
                                  RFS_ASI_05, RFS_ASI_06, RFS_ASI_07, RFS_ASI_08,
            					  RFS_ASI_09, RFS_ASI_10, RFS_ASI_11, RFS_OTHER}
    };

    public static final Map<String, List<String>> SHIP_FROM_LOCATIONS =
                    new Map<String, List<String>>{
          OTH => new List<String>{SFL_OTHER}

        , ASI => SFL_ASI
    };

    public static final String CANCELLED = 'Cancelled';
    public static final Set<String> CANCELLED_STATS = new Set<String>{
        CANCELLED, 'CMC Cancelled'
    };

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Sample_Request_Config : ' + s);
    }

    private static String getMapKey(String s) {
        system.debug('String'+s);
        String key = OTH; if (String.isBlank(s)) {return key;}
        if (DC_KEYS.containsKey(s)) {key = DC_KEYS.get(s);} else
        if (ACC_RT_KEYS.containsKey(s)) {key = ACC_RT_KEYS.get(s);}
        return key;
    }
@TestVisible
    private static SelectOption getDistChanOpt(String v) {
        return new SelectOption(v, DC_LABELS.get(v) + DELIM + v);
    }

    public static List<SelectOption> getDistChanOpts() {
        List<SelectOption> alist = new List<SelectOption>();
        alist.add(new SelectOption('', 'All'));
        alist.add(getDistChanOpt(DC_ASI));
        alist.add(getDistChanOpt(DC_AWT));
        alist.add(getDistChanOpt(DC_APM));
        alist.add(getDistChanOpt(DC_ACM));
        return alist;
    }

    public static List<SelectOption> getSampleCenterOpts(String key) {
        return getSelectOpts(key, SAMPLE_CENTERS);
    }

    public static Set<String> getCMCSampleCenters() {return getSampleCenterSet(CMC);}
    public static Set<String> getLabSampleCenters() {return getSampleCenterSet(LAB);}
    public static Set<String> getMsdSampleCenters() {return getSampleCenterSet(MSD);}
    public static Set<String> getOthSampleCenters() {return getSampleCenterSet(OTH);}
    public static Set<String> getSPSSampleCenters() {return getSampleCenterSet(SPS);}

    private static Set<String> getSampleCenterSet(String key) {
        List<String> alist = SAMPLE_CENTERS.get(key);
        Set<String> aset = new Set<String>(); aset.addAll(alist);
        return aset;
    }

    public static List<SelectOption> getSampleReasonOpts(String key) {
        return getSelectOpts(key, SAMPLE_REASONS);
    }

    public static List<SelectOption> getShipFromLocOpts(String key) {
        return getSelectOpts(key, SHIP_FROM_LOCATIONS);
    }

    private static List<SelectOption> getSelectOpts(String key, Map<String, List<String>> smap) {
        List<String> slist = smap.get(OTH); String k = getMapKey(key);
        if (smap.containsKey(k)) {slist = smap.get(k);}
        return getSelectOpts(slist);
    }

    private static List<SelectOption> getSelectOpts(List<String> slist) {
        List<SelectOption> alist = new List<SelectOption>();
        for (String s : slist) {alist.add(new SelectOption(s, s));}
        return alist;
    }

    public static void upsertSampleRequestConfig(List<Material_Sales_Data2__c> alist) {
        Set<String> kset1 = new Set<String>(), kset2 = new Set<String>();
        Map<String, Material_Sales_Data2__c> mmap = new Map<String, Material_Sales_Data2__c>();
        for (Material_Sales_Data2__c a : alist) {
            mmap.put(a.Container_Desc__c + DELIM + a.Dist_Channel_Code__c, a);
        }
        kset1 = mmap.keySet();
        List<Sample_Request_Config__c> clist = [
            select Id, Name, Key__c
              from Sample_Request_Config__c
             where Key__c in :kset1];
        if (clist != null && !clist.isEmpty()) {
            for (Sample_Request_Config__c c : clist) {kset2.add(c.Key__c);}
        }
        List<Sample_Request_Config__c> ulist = new List<Sample_Request_Config__c>();
        Sample_Request_Config__c u; Material_Sales_Data2__c m;
        for (String k : kset1) {
            if (!kset2.contains(k)) {
                m = mmap.get(k);
                u = new Sample_Request_Config__c();
                u.Name = k; u.Key__c = k;
                u.Dist_Channel__c = m.Dist_Channel_Code__c;
                u.Sample_Size__c = m.Container_Desc__c;
                ulist.add(u);
            }
        }
        if (!ulist.isEmpty()) {
            try {upsert ulist Key__c;} catch(Exception e) {}
        }
    }

    public static Map<String, Map<String, Double>> getQuantityLimits(String distChan) {
        Map<String, Map<String, Double>> amap = new Map<String, Map<String, Double>>();
        List<Sample_Request_Config__c> alist = [
            select Quantity_Limit1__c, Quantity_Limit2__c, Quantity_Limit3__c, Sample_Size__c
              from Sample_Request_Config__c where Dist_Channel__c = :distChan];
        if (alist == null || alist.isEmpty()) {return amap;}
        for (Sample_Request_Config__c a : alist) {
            Map<String, Double> bmap = new Map<String, Double> {
                QTY1 => a.Quantity_Limit1__c,
                QTY2 => a.Quantity_Limit2__c,
                QTY3 => a.Quantity_Limit3__c
            };
            amap.put(a.Sample_Size__c, bmap);
        }
        return amap;
    }

    public static void setRouteForApprovalFlags(Sample_Request__c sampleRequest,
                                                Map<String, Double> qmap, Double msq) {
        if (sampleRequest.Route_for_Approval_1__c == false) {
            sampleRequest.Route_for_Approval_1__c = getApprovalFlag(msq, qmap,  QTY1);
        }
        if (sampleRequest.Route_for_Approval_2__c == false) {
            sampleRequest.Route_for_Approval_2__c = getApprovalFlag(msq, qmap,  QTY2);
        }
        if (sampleRequest.Route_for_Approval_3__c == false) {
            sampleRequest.Route_for_Approval_3__c = getApprovalFlag(msq, qmap,  QTY3);
        }
    }
@TestVisible
    private static Boolean getApprovalFlag(Double msq, Map<String, Double> qmap, String k) {
        if (qmap.containsKey(k)) {
            Double usq = qmap.get(k);
            debug(k + ' : msq = ' + msq + ' : usq = ' + usq);
            return (usq != null && msq > usq);
        }
        return false;
    }

}
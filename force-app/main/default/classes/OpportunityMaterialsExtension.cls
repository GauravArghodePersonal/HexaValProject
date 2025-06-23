public with sharing class OpportunityMaterialsExtension {
//     with sharing required for this class

    public Opportunity                opp {get; private set;}
    public Opportunity_Material__c oppMat {get; private set;}

    private final ApexPages.StandardController stdController;

    private final String PARAM_RETURL = 'retURL';

    private final String OPP_PAGE_URL = OpportunityExtensionV3.OPP_PAGE_URL;

    private final Set<String> RECTYPES_1 = OpportunityExtensionV3.RECTYPES_1;

    private Map<String, String> params;

    private String matUri, oppUri, oppRecType, retUrl;

    private void debug(String s) {System.debug(LoggingLevel.INFO, 'OppMatExtn : ' + s);}

    private void addInfoMsg(String s) {
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, s);
        ApexPages.addMessage(msg);
    }

    public OpportunityMaterialsExtension (ApexPages.StandardController sc) {
        stdController = sc; oppMat = new Opportunity_Material__c();
        if (sc!= null) {oppMat = (Opportunity_Material__c)sc.getRecord();}
        init1();
    }

    private void init1() {
        debug('init1 : ' + oppMat);
        oppRecType = ''; params = ApexPages.currentPage().getParameters();
        retUrl = params.get(PARAM_RETURL);
        matUri = '/' + Opportunity_Material__c.SObjectType.getDescribe().getKeyPrefix();
        if (oppMat == null) {return;}
        if (oppMat.Id != null) {
            oppMat = [select Id, RecordTypeId, Opportunity__c, Trial_Start_Date__c
                        from Opportunity_Material__c where Id = :oppMat.Id];
        }
        opp = [select Id, RecordTypeId, CloseDate from Opportunity
                where Id = :oppMat.Opportunity__c];
        oppRecType = RecordType_Functions.LookupRecordTypeName(opp.RecordTypeId);
    }

    private PageReference getOppPageRef() {
        PageReference pr = null;
        if (RECTYPES_1.contains(oppRecType)) {
            pr = new PageReference(OPP_PAGE_URL + '?id=' + oppMat.Opportunity__c);
            pr.getParameters().put(PARAM_RETURL, retURL);
        }
        return pr;
    }

    public PageReference gotoOpportunityPage() {
        PageReference pr = getOppPageRef(); Map<String, String> pmap;
        if (pr == null) {
            pr = new PageReference(matUri + '/e'); pmap = pr.getParameters();
	        pmap.putAll(params); pmap.put('nooverride', '1'); pmap.remove('save_new');
            //setMatParams(pmap);
        }
        return pr.setRedirect(true);
    }
/*
    private void setMatParams(Map<String, String> pmap) {
        String pn = '', pv = '';
        if (opp != null && opp.CloseDate != null && oppMat.Id == null) {
            pn = CustomSettings_Functions.getObjectFieldId('OppMat-Trial_Start_Date');
            pv = opp.CloseDate.format();
            pmap.put(pn, pv);
        }
    }
*/
    public PageReference deleteOppMaterial() {
        PageReference pr = getOppPageRef();
        if (pr == null) {
            try {delete oppMat;} catch(Exception e) {
                addInfoMsg('Failed to delete Opportunity Material');
            }
            pr = new PageReference(retURL);
        }
        return pr.setRedirect(true);
    }
}
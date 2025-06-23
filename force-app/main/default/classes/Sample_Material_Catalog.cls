public class Sample_Material_Catalog {

    private static final Integer PAGE_SIZE = 10;
    public static final String EDIT = 'Edit';
    public static final String UNDO = 'Undo';

    public static final String MAT_CATALOG_QRY1 = ''
        + 'select Id, Name, Out_of_Stock__c, '
        + '       Product_Code__c, Product_Name__c, '
        + '       Sample_Center__c, Sample_Size__c ' 
        + '  from Sample_Material_Catalog__c';

    public static final String MAT_CATALOG_OB1 = ' order by '
        + 'Product_Name__c, Product_Code__c, Sample_Size__c';
    
    public enum RecordAction {NEW_REC, CLONE_REC, DELETE_REC} 
    
    public class Rec {
        public Boolean editable               {get; set;}
        public Boolean selected               {get; set;}
        public Boolean isNewRec               {get; set;}
        public Integer recNum                 {get; set;}
        public String  editUndo               {get; set;}
        public String  comments               {get; set;}
        public Sample_Material_Catalog__c smc {get; set;}

        public Rec() {this(new Sample_Material_Catalog__c());}      
        public Rec(Integer n) {this(new Sample_Material_Catalog__c(), n);}      
        public Rec(Sample_Material_Catalog__c m) {this(m, 1);}
        public Rec(Sample_Material_Catalog__c m, Integer n) {
            recNum = n; smc = m; selected = false; comments = '';
            editable = false; editUndo = EDIT; isNewRec = false;
        }

    }
    
    public Boolean readonly               {get; private set;}
    public Boolean renderPage1            {get; private set;}
    public Boolean renderPage2            {get; private set;}
    public List<Rec> dlist                {get; private set;}
    public List<Rec> reclist              {get; private set;}
    public PaginationController pc1       {get; private set;}
    public Sample_Material_Catalog__c smc {get; private set;}
    public Sample_Request__c sreq         {get; private set;}
    public Map<String, Rec> undoRecMap    {get; private set;}
    
    public Boolean allRecs  {get; set;}
    public Integer recNum   {get; set;}
    
    private Boolean validForm;
    private Integer pageSize;
    private String smcId;
    private String retUrl = null;
    
    public Sample_Material_Catalog() {init(null);}
    
    public Sample_Material_Catalog(ApexPages.Standardcontroller sc) {
    	init(sc.getRecord());
    }
    
    private void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Sample_Material_Catalog : ' + s);
    }
    
    public void addErrorMessage(String msg) {
        ApexPages.Severity mtype = ApexPages.Severity.ERROR;
        ApexPages.addMessage(new ApexPages.Message(mtype, msg));
        validForm = false;
    }    

    private void init(SObject sobj) {
        readonly = false; retUrl = '/'; pageSize = PAGE_SIZE;
        undoRecMap = new Map<String, Rec>();
        User usr = User_Functions.getLoggedInUser(); sreq = new Sample_Request__c();
        if (String.isBlank(sreq.Sample_Center__c)) {
            sreq.Sample_Center__c = usr.Sample_Center__c;
        }
        Map<String, String> params = System.currentPageReference().getParameters();
        if (sobj != null && sobj.getSObjectType() == Sample_Material_Catalog__c.sObjectType) {
            smc = (Sample_Material_Catalog__c)sobj;
            smcId = smc.Id;
        } else {
            if (params != null) {smcId = params.get('id');}
        }
        setSMC(); setRecPC();
    }
    
    public void newSMC() {
        smc = new Sample_Material_Catalog__c();
        smc.Sample_Center__c = sreq.Sample_Center__c;
    }
    
    private void setSMC() {
        newSMC();
        if (String.isBlank(smcId)) {return;}
        retUrl = '/' + smcId;
        String q = getQuery();
        try {
        	List<Sample_Material_Catalog__c> alist = Database.query(q);
        	if (alist != null && !alist.isEmpty()) {smc = alist[0];}
        } catch(Exception e) {addErrorMessage('setSMC : ' + e.getMessage());}
    }
    
    private String getQuery() {
        String qry = '', orderBy = ''; 
        qry = MAT_CATALOG_QRY1; orderBy = MAT_CATALOG_OB1;
        if (String.isNotBlank(smcId)) {
            qry += ' where Id = \'' + smcId + '\''; return qry;
        }
        if (smc.Out_of_Stock__c == null) {smc.Out_of_Stock__c = false;}
        qry += ' where Out_of_Stock__c = ' + smc.Out_of_Stock__c;
        if (String.isNotBlank(sreq.Sample_Center__c)) {
            qry += ' and Sample_Center__c = \'' + sreq.Sample_Center__c + '\'';
        }
        if (String.isNotBlank(smc.Product_Name__c)) {
            qry += ' and Product_Name__c like \'%' + smc.Product_Name__c + '%\'';
        }
        if (String.isNotBlank(smc.Product_Code__c)) {
            qry += ' and Product_Code__c like \'%' + smc.Product_Code__c + '%\'';
        }
        if (String.isNotBlank(smc.Sample_Size__c)) {
            qry += ' and Sample_Size__c like \'%' + smc.Sample_Size__c + '%\'';
        }
        qry += orderBy;
        debug('getQuery : qry = ' + qry);
        return qry; 
    }

    public void setRecPC() {
        allRecs = false; renderPage1 = true; renderPage2 = false;
        //sampleCenterMsgStyle = ''; sampleCenterMsg = '';
        //if (isNull(sampleRequest.Sample_Center__c)) {sampleCenterMsg = 'Select a Sample Center'; return;}
        String qry = getQuery();
        Database.Querylocator ql; pc1 = null;
        try {
            ql = Database.getQueryLocator(qry);
            pc1 = new PaginationController(ql, pageSize);
        } catch(Exception e) {addErrorMessage('setRecPC : ' + e.getMessage());}
        setReclist();
    }
    
    public void pc1Size() {setReclist(null); pageSize = pc1.getPageSize();}
    public void pc1Frst() {setReclist(PaginationController.Page.FIRST);}
    public void pc1Prev() {setReclist(PaginationController.Page.PREV);}
    public void pc1Next() {setReclist(PaginationController.Page.NEXT);}
    public void pc1Last() {setReclist(PaginationController.Page.LAST);}

    private void setReclist() {setReclist(null);}
        
    private void setReclist(PaginationController.Page p) {
        reclist = new List<Rec>(); 
        if (pc1 == null) {checkForEmptyList(); return;}
        pc1.gotoPage(p); Integer n = pc1.recordFrom; Rec r;
        List<Sample_Material_Catalog__c> alist = (
        List<Sample_Material_Catalog__c>)pc1.getRecords();
        if (alist != null && !alist.isEmpty()) {
	        for (Sample_Material_Catalog__c a : alist) {
	        	r = new Rec(a, n++); reclist.add(r);
	        }
        }
        checkForEmptyList();
    }
    
    private void checkForEmptyList() {
        if (reclist.isEmpty()) {reclist.add(getNewRec()); allRecs = false;}
    }

    private Rec getNewRec() {
        return getNewRec(null);
    }
    
    private Rec getNewRec(Rec r) {
    	return getNewRec(r, false, false, false);
    }
    
    private Rec getNewRec(Rec r, Boolean preserveId, 
                          Boolean preserveTimestamps, Boolean preserveAutoNumbers) {
    	Rec c; Boolean deepClone = true;
    	if (r == null) {c = new Rec(); c.smc.Sample_Center__c = sreq.Sample_Center__c;}
    	else {c = new Rec(r.smc.clone(preserveId, deepClone, 
    		                          preserveTimestamps, preserveAutoNumbers));}
    	c.editable = true; c.isNewRec = !preserveId; c.editUndo = '';
    	return c;
    }
    
    private void addToList(List<Rec> rlist, Rec r, Integer n) {
    	r.recNum = n; rlist.add(r);
    }
    
    private void doRecordAction(RecordAction ra) {
    	debug('action : ' + ra + ' : recNum : ' + recNum);
        Integer n = reclist.size(), j = 0; Rec r = getNewRec();
        if (recNum == n) {
        	if (ra == RecordAction.DELETE_REC) {
	            r = reclist.remove(recNum-1); 
	            reviewRec(r);
        	} else {
                if (ra == RecordAction.CLONE_REC) {r = getNewRec(reclist[n-1]);}
        		addToList(reclist, r, n+1);
        	} 
        	return;
        }
        List<Rec> alist = new List<Rec>();
        for (Integer i = 1; i < n+1; i++) {
        	r = new Rec(); r = reclist[i-1];
            if (ra == RecordAction.DELETE_REC && i == recNum) {
            	reviewRec(r); continue;
            }
            j++; addToList(alist, r, j);
            if (i == recNum) {
                if (ra == RecordAction.NEW_REC) {r = getNewRec();} 
                if (ra == RecordAction.CLONE_REC) {r = getNewRec(r);} 
                j++; addToList(alist, r, j);
            }
        }
        reclist = alist;
        //if (ra == RecordAction.DELETE_REC) {checkForEmptyList();}
    } 
    
    public void blankRec()  {doRecordAction(RecordAction.NEW_REC);}
    
    public void cloneRec()  {doRecordAction(RecordAction.CLONE_REC);}
    
    public void deleteRec() {doRecordAction(RecordAction.DELETE_REC);}
    
    public void deleteRecs() {
        if (dlist.isEmpty()) {return;}
        List<SObject> alist = new List<SObject>();
        for (Rec r : dlist) {alist.add(r.smc);}
        try {
        	delete alist; 
        } catch (Exception e) {
            addErrorMessage('delete error : ' + e.getMessage());
        }
        setRecPC();
    }
    
    private void reviewRec(Rec r) {
        dlist = new List<Rec>();
        if (!r.isNewRec){dlist.add(r);}
        setRenderPage2(); 
    }
    
    public void reviewRecs() {
        dlist = new List<Rec>(); List<Rec> alist = new List<Rec>();
        Integer j = 0;
        for (Rec r : reclist) {
            if (r.selected) {
            	if (!r.isNewRec) {dlist.add(r);}
            	continue;
            }
            j++; addToList(alist, r, j); 
        }
        reclist = alist; setRenderPage2();
    }
    
    private void setRenderPage2() {
    	checkForEmptyList();
        if (!dlist.isEmpty()) {
            renderPage1 = false; renderPage2 = true;
        }
    }
    
    public void editRecs() {
        for (Rec r : reclist) {
            if (r.selected && !r.editable) {editRec(r.recNum);}
        }
    }
    
    public void undoRecs() {
        for (Rec r : reclist) {
            if (r.selected && r.editable && !r.isNewRec) {editRec(r.recNum);}
            r.selected = false;
        }
        allRecs = false;
    }
    
    private void editRec(Integer rn) {
        Rec r = reclist[rn-1];
        String k = r.smc.Id;
        Boolean preserveId = String.isNotBlank(k);
        if (r.editable) {
            if (undoRecMap.containsKey(k)) {
                r = undoRecMap.get(k); reclist[rn-1] = r;
            }
            r.editable = false; r.editUndo = EDIT;
        } else {
            Rec v = getNewRec(r, preserveId, preserveId, preserveId); v.recNum = rn;
            r.editable = true; r.editUndo = ''; r.isNewRec = true;
            if (preserveId) {
                undoRecMap.put(k, v); r.editUndo = UNDO; r.isNewRec = false;
            }
             
        }
    }
    
    public void editRec() {editRec(recNum);}
    
    public void saveRecs() {saveRecs(reclist);}
    
    private Boolean validRec(Rec r) {
    	Boolean b = true; r.comments = '';
        if (String.isBlank(sreq.Sample_Center__c)) {
        	b = false; r.comments += 'Sample Center Required<br/>';
        }
    	if (String.isBlank(r.smc.Product_Name__c)) {
    		b = false; r.comments += 'Product Name Required<br/>';
    	}
        if (String.isBlank(r.smc.Product_Code__c)) {
            b = false; r.comments += 'Product Code Required<br/>';
        }
        if (String.isBlank(r.smc.Sample_Size__c)) {
            b = false; r.comments += 'Sample Size Required<br/>';
        }
        return b;
    }
    
    private String getKey(Rec r) {
    	String k = sreq.Sample_Center__c + ':' +
    	           r.smc.Product_Code__c + ':' +
    	           r.smc.Sample_Size__c;
    	return k;
    }
    
    private void validateRecs(List<Rec> rlist) {
    	Map<String, String> amap = new Map<String, String>();
    	if (rlist == null || rlist.isEmpty()) {return;}
    	Set<String> kset = new Set<String>(); String k;
        for (Rec r : rlist) {
            if (r.selected && r.editable) {
            	if (validRec(r)) {kset.add(getKey(r));} 
            }
        }
        if (kset.isEmpty()) {return;}
        List<Sample_Material_Catalog__c> alist = [
            select Id, Name, Key__c 
              from Sample_Material_Catalog__c
             where Key__c in :kset];
        if (alist == null || alist.isEmpty()) {return;}
        for (Sample_Material_Catalog__c a : alist) {
        	amap.put(a.Key__c, a.Name);
        }
        String s1, s2;
        for (Rec r : rlist) {
            if (!r.selected || !r.editable) {continue;}
            if (String.isNotBlank(r.comments)) {continue;}
        	k = getKey(r);
        	if (amap.containsKey(k)) {
        		s1 = r.smc.Name; s2 = amap.get(k);
        		if (String.isBlank(s1) || s1 != s2) {
        			r.comments += 'Duplicate Data : ' + s2 + '<br/>';
        		}
        	}
        }
    }
    
    private void saveRecs(List<Rec> rlist) {
    	List<SObject> ilist = new List<SObject>(),
    	              ulist = new List<SObject>();
        validateRecs(rlist);
        for (Rec r : rlist) {
        	if (r.selected && r.editable) {
        		if (String.isBlank(r.comments)) {
	        		if (r.isNewRec) {ilist.add(r.smc);}
	        		else {ulist.add(r.smc);}
        		}
        		resetRec(r);
        	}
        }
        if (!ilist.isEmpty()) {
        	try {insert ilist; setRecPC();} catch (Exception e) {
        		addErrorMessage('insert error : ' + e.getMessage());
        	}
        }
        if (!ulist.isEmpty()) {
            try {update ulist;} catch (Exception e) {
                addErrorMessage('update error : ' + e.getMessage());
            }
        }
    }
    
    private void resetRec(Rec r) {
        r.selected = false; allRecs = false; r.editUndo = '';
        if (!r.isNewRec) {
            r.editable = false; r.isNewRec = false; r.editUndo = EDIT;
        }
    }
    
    public void saveRec() {
    	Rec r = reclist[recNum-1]; r.selected = true;
    	List<Rec> rlist = new List<Rec>{r}; saveRecs(rlist);
    }
    
}
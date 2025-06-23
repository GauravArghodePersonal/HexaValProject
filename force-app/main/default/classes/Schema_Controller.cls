public class Schema_Controller {
	
	public Schema_Controller() {init();}
	
    public class Obj {
        public Integer num                      {get; private set;}
        public Schema.DescribeSObjectResult dsr {get; private set;}
        
        public Obj(Schema.DescribeSObjectResult d, Integer n) {dsr = d; num = n;}
    }
    
	public class Fld {
		public Integer num                      {get; private set;}
		public Schema.DescribeFieldResult dfr   {get; private set;}
		
        public Fld(Schema.DescribeFieldResult d, Integer n) {dfr = d; num = n;}        

        private String getString(Boolean b) {return b ? 'Yes' : '';}
        
        public String getIsCustom()     {return getString(dfr.isCustom());}
        public String getIsExternalId() {return getString(dfr.isExternalId());}
	}
	
	public List<SelectOption> objNames {get; private set;}
	public String objName              {get; set;}
	
	Map<String, Schema.SObjectType> gd;
	Map<String, Schema.SObjectField> fmap;
	
	transient List<Obj> objs;
	transient List<Fld> flds;
	
	private void debug(String s) {
		System.debug(LoggingLevel.INFO, '>>>>>>>> Schema_Controller : ' + s);
	}

    private void init() {
    	gd = Schema.getGlobalDescribe(); setObjs();
    }
    
    public void initAction() {
    	debug('initAction');
    	objName = 'Contact'; getObjectInfo();
    }
    
    public List<Fld> getFlds() {return flds;}
    
    private Boolean skipObj(String s) {
    	return (s.endsWith('tag') || s.endsWith('__history'));
    }
    
    private void setObjs() {
    	objs = new List<Obj>(); Integer n = 0; String val, lbl;
    	objNames = new List<SelectOption>(); SelectOption so;
    	Schema.SObjectType ot; Schema.DescribeSObjectResult dsr;
    	List<String> sa = new List<String>();
    	sa.addAll(gd.keySet()); sa.sort();
    	for(String s : sa) {
    		if (skipObj(s)) {continue;}
	        ot = gd.get(s); dsr = ot.getDescribe();
            //debug('dsr : ' + dsr);
    		objs.add(new Obj(dsr, ++n));
    		val = dsr.getName(); lbl = dsr.getLabel() + ' (' + val + ')';
    		so = new SelectOption(val, val); objNames.add(so); 
    	}
        debug('objs : ' + objs);
    }
    
    public void getObjectInfo() {
    	Schema.SObjectType ot = gd.get(objName);
    	if (ot == null) {return;}
    	Schema.DescribeSObjectResult dsr = ot.getDescribe();
    	fmap = dsr.fields.getMap(); setFlds();
    }
    
    private void setFlds() {
    	if (fmap == null) {return;}
        flds = new List<Fld>(); Integer n = 0;
        List<String> fldNames = new List<String>();
        fldNames.addAll(fmap.keySet()); fldNames.sort();
        debug('fldNames : ' + fldNames);
        Schema.SObjectField sof; Schema.DescribeFieldResult dfr;
        for (String s : fldNames) {
        	sof = fmap.get(s); dfr = sof.getDescribe();
        	//debug('dfr : ' + dfr);
        	flds.add(new Fld(dfr, ++n));
        }
        debug('flds : ' + flds);
    }
    
}
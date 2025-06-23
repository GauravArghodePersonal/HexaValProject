public class VI_Reward_Card_Controller {

    public static final String DELIM = VI_Reward_Card_Functions.DELIM;
    public static final ApexPages.Severity INFO = ApexPages.Severity.INFO;
	
	public class RewardCard {
		public Boolean selected            {get; set;}
        public Integer rownumbr            {get; set;}
        public String cardValue            {get; set;}
        public String product              {get; set;}
        public String upsellPercent        {get; set;}
		public VI_Reward_Card_Value__c rcv {get; set;}
		
		public RewardCard(VI_Reward_Card_Value__c r) {this(r, 1, false);} 

        public RewardCard(VI_Reward_Card_Value__c r, Integer n, Boolean b) {
            rcv = r; rownumbr = n; selected = b;
        } 
	}
	
	private String promoId;
    private String prodCategory;
    
	private Map<String, VI_Promotion_Upsell__c> upsMap;
    private Map<String, VI_Reward_Card_Value__c> rcvMap;
	
    public Boolean allCards              {get; set;}

	public List<RewardCard> rewardCards  {get; private set;}
    public VI_Promotion__c promotion     {get; private set;}
    
	public VI_Reward_Card_Controller() {
        init(new VI_Reward_Card_Value__c());
	}
	
    public VI_Reward_Card_Controller(ApexPages.StandardController sc) {
        init(sc.getRecord());
    }
    
    private void debug(String s) {DebugLog_Functions.info('>>>>>>>> ' + s);}
    
    private Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    private void addInfoMsg(String s) {addMsg(INFO, s);}
    
    private void addMsg(ApexPages.Severity mtype, String s) {
        ApexPages.Message msg = new ApexPages.Message(mtype, s);
        ApexPages.addMessage(msg);
    }
    
    private void addNoProductsMsg() {
        String msg = 'No products found in Upsell % table for the Product Category : ' + prodCategory;
        addInfoMsg(msg);
        msg = 'Products exist in Upsell % table for the following Categories';
        addInfoMsg(msg);
        List<String> alist = VI_Reward_Card_Functions.getProductCategories();
        for (String a : alist) {addInfoMsg(a);}
    }
    
    private void init(SObject sobj) {
    	Map<String, String> pmap = ApexPages.currentPage().getParameters();
        debug('sobj : ' + sobj); debug('params : ' + pmap);
        promoId = pmap.get('promoid'); init2();
    }
    
    private void init2() {
    	promotion = new VI_Promotion__c();
        rewardCards = new List<RewardCard>();
        rcvMap = new Map<String, VI_Reward_Card_Value__c>();
    	if (isNull(promoId)) {return;}
    	promotion = VI_Reward_Card_Functions.getPromo(promoId);
    	prodCategory = promotion.Product_Category__c;
    	upsMap = VI_Reward_Card_Functions.getUpsellMap(prodCategory);
    	if (upsMap.isEmpty()) {addNoProductsMsg();}
    	init3(); init4(); sortRewardCards();
    }
    
    private void init3() {
        List<VI_Reward_Card_Value__c> clist = promotion.VI_Reward_Card_Values__r;
        if (clist == null || clist.isEmpty()) {return;}
        Integer n = rewardCards.size(); String k; RewardCard rc;
        VI_Promotion_Upsell__c upsell;
        for (VI_Reward_Card_Value__c c : clist) {
            k = VI_Reward_Card_Functions.getUpsellName(c); rcvMap.put(k, c);
            if (upsMap.containsKey(k)) {
            	upsell = upsMap.get(k);
            	rc = getRewardCard(upsell, c, ++n, true);
                rewardCards.add(rc);
            }
        }
    }
    
    private RewardCard getRewardCard(VI_Promotion_Upsell__c upsell, 
                                     VI_Reward_Card_Value__c rcv,
                                     Integer rowNum, Boolean selected) {
        RewardCard rc = new RewardCard(rcv, rowNum, selected);
        rc.product = upsell.Primary_Product__c;
        rc.cardValue = upsell.Reward_Card_Value__c;
        rc.upsellPercent = upsell.Upsell_Percent__c != null ? upsell.Upsell_Percent__c.format() : '';
        return rc;
    }
    
    private void init4() {
    	VI_Reward_Card_Value__c rcv; Integer n = rewardCards.size(); RewardCard rc;
        for (VI_Promotion_Upsell__c upsell : upsMap.values()) {
            if (!rcvMap.containsKey(upsell.Name)) {
                rcv = new VI_Reward_Card_Value__c();
                rcv.Promotion__c = promotion.Id; rcv.Reward_Card__c = upsell.Id;
                rcv.Key__c = promotion.Id + DELIM + upsell.Id;
                rc = getRewardCard(upsell, rcv, ++n, false);
                rewardCards.add(rc);
            }
        }
    }

    private String getZeroFilled(String s, Integer n) {
        String r = s.trim(); Integer m = r.length();
        while (m++ < n) {r = '0' + r;}
        return r;
    }
    
    private void sortRewardCards() {
    	List<String> keys = new List<String>(); String k; allCards = true;
    	Map<String, RewardCard> rcmap = new Map<String, RewardCard>();
    	for (RewardCard rc : rewardCards) {
    		k = rc.product + DELIM + getZeroFilled(rc.cardValue, 6);
    		keys.add(k); rcmap.put(k, rc);
    	}
    	keys.sort();
    	List<RewardCard> rewardCards2 = new List<RewardCard>();
    	RewardCard rc; Integer n = 0;
    	for (String s : keys) {
    		rc = rcmap.get(s); rc.rownumbr = ++n;
    		rewardCards2.add(rc);
    		if (!rc.selected) {allCards = false;}
    	}
    	rewardCards = rewardCards2;
    }
    
    public PageReference saveRewardCards() {
    	List<VI_Reward_Card_Value__c> dlist = new List<VI_Reward_Card_Value__c>(),
    	                              ulist = new List<VI_Reward_Card_Value__c>();
        for (RewardCard rc : rewardCards) {
        	if (rc.selected) {ulist.add(rc.rcv);} else
        	if (rc.rcv.Id != null) {dlist.add(rc.rcv);}
        }
        if (!dlist.isEmpty()) {delete dlist;}
        if (!ulist.isEmpty()) {upsert ulist Key__c;}
        return cancel();
    }
    
    public PageReference cancel() {
    	String s = '/' + promoId; if (isNull(promoId)) {s = '/home/home.jsp';}
    	PageReference pr = new PageReference(s); pr.setRedirect(true);
    	return pr;
    }
}
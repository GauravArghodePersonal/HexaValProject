global class SAP_LISD_Services {
	
	global class LISD_REC {
        webservice String customerGroup;
        webservice String enduseCustomer;
		webservice String industry;
        webservice String salesDistrict;
        webservice String salesOffice;
        webservice String salesGroup;
        webservice String seller;
        webservice String shipToNum;
        public LISD_REC(SAP_LISD s) {
            customerGroup  = s.getCustGroupLabel();
            enduseCustomer = s.getEndUseCustLabel();
            industry       = s.getIndustryLabel();
            salesDistrict  = s.getSalesDstLabel();
            salesOffice    = s.getSalesOfcLabel();
            salesGroup     = s.getSalesGrpLabel();
            seller         = s.getSellerLabel();
            setShipToNum(s);
        }
        
        private void setShipToNum(SAP_LISD s) {
        	if (s.lisd == null || s.lisd.ShipTo_Number__c == null) {shipToNum = '';}
        	else {shipToNum = String_Functions.removeLeadingZeros(s.lisd.ShipTo_Number__c);}
        }
	}

    webservice static List<LISD_REC> getSapLisds(Id accountId) {
    	List<SAP_LISD> lisds = SAP_LISD_Functions.getSapLisds(accountId);
    	List<LISD_REC> rlist = new List<LISD_REC>();
    	if (lisds == null || lisds.isEmpty()) {return rlist;}
    	for (SAP_LISD s : lisds) {rlist.add(new LISD_REC(s));}
    	return rlist;
    }
}
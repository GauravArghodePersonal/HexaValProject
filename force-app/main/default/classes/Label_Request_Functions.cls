public class Label_Request_Functions {

    private static final String EMAIL_SENDER_NAME = 'Ashland Label Request';
    private static final String EMAIL_SERVICE_NAME = 'Label_Request_Email_Service';
    private static final String EMAIL_TEMPLATE_NAME = 'AlmatekLabelRequest';
    private static final string LOTUS_NOTES_CONTACT_NAME = 'Label Request Mailbox';
    
    
    private static final Set<String> CARRIERS = new Set<String>{'UPS', 'FEDEX', 'USPS', 'TNT', 'DHS'};

    private static final String STATUS_SHIPPED = 'Shipped';

    private static final String CRNL = '\r\n';
    private static final String NL = '\n';
    
    public static void doAfterUpsert(List<Label_Request__c> lrs) { }
    
    public static void sendLabelRequestEmail(List<Label_Request__c> lrs) {
        system.debug('Inside sendLabelRequestEmail NNN');
        Map<String, Label_Vendor__c> cmap = getLabelVendors(lrs);
        system.debug('1111 cmap ---> '+cmap);
        Map<String, ID> tmap = gettemplateids(cmap);
        system.debug('2222 tmap ---> '+tmap);
        if (cmap.isEmpty()) {
               system.debug('Inside cmap NNN 333');
            AppLog.write('Label_Request_Functions', '', 'Security Error', 'Error', '', 
                         'sendLabelRequestEmail Error: getLabelVendors did not return any results.  Current User: ' + 
                         UserInfo.getUserId());
            return;
        } else {
              system.debug('Inside cmap NNN 4444');
            String cmapLog = '';
            Set <String> cmapKeySet = new Set<String>();
            cmapKeySet = cmap.keySet();
            for (String key : cmapKeySet) {cmapLog += 'cmap key: ' + key + '\n';}
            AppLog.write('Label_Request_Functions','','CMAP Label Vendor Keys','Info','',cmapLog);
        }
        List<Messaging.SingleEmailMessage> mlist = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage m;
        Id templateId;
        String replyTo = '';
        try {
            
            //replyTo = [select id, name, otherstreet from contact where name = :LOTUS_NOTES_CONTACT_NAME limit 1].otherstreet;}
            replyTo = CustomSettings__c.getInstance().Label_Request_Email__c;
            system.debug('NNNN'+replyTo);
        } catch(Exception e) {
            AppLog.write('Label_Request_Functions', '', 'Error', 'Error', '',
                         'sendLabelRequestEmail Error: Unable to retrieve replyTo.  Current User: ' + 
                         UserInfo.getUserId());
        }
        
        String so, dc, pt, ph4, ph5, ph6;
        Set<string> ph4Options = getPH4Options();
        Set<string> ph5Options = getPH5Options();
        Set<string> ph6Options = getPH6Options();

        Label_Vendor__c lv;
        
        String successLog = '';
        
        for (Label_Request__c lr : lrs) {
            so = lr.Sales_Org_Code__c;
            dc = lr.Dist_Channel_Code__c;
            
            if (ph4Options.contains(lr.product_hierarchy_4__c)) {
               ph4 = lr.product_hierarchy_4__c;
            }else{ ph4 = 'Any Other'; }
            
            if (ph5Options.contains(lr.product_hierarchy_5__c)) {
              ph5 = lr.product_hierarchy_5__c;
            }else{ ph5 = 'Any Other'; }
            
            if (ph6Options.contains(lr.product_hierarchy_6__c)) {
              ph6 = lr.product_hierarchy_6__c;
            }else{ ph6 = 'Any Other'; }
            
            
            pt = '';
            if (lr.program_Type__c != null){
            pt = lr.Program_Type__c;}
            //
            else
            {
                pt='Any Other';
                
            }
            
            system.debug('Key: ' + so + dc + pt + ph4 + ph5 + ph6);
            
            successLog += lr.Id + ' - ' + 'so=' + so + ';dc=' + dc + ';pt=' + pt + ';ph4=' + ph4+ ';ph5=' + ph5 + ';ph6=' + ph6 + '; ';
            successLog += ' Key: ' + so + dc + pt + ph4 + ph5 + ph6 + '; ';

system.debug('@@@@@ CMAP:'+ cmap+'-->');
           system.debug('@@@@'+ so +'--'+ dc +'--'+ pt +'--'+ ph4 +'--'+ ph5 +'--'+ ph6);
             
            system.debug('cmap.containsKey(so + dc + pt + ph4 + ph5 + ph6)-->'+cmap.containsKey(so + dc + pt + ph4 + ph5 + ph6));
          //Changes done by Donald for Email not working for program type option.
            //  if (so != null && dc != null && pt != null && ph4 != null && ph5 != null && ph6 != null && cmap.containsKey(so + dc + pt + ph4 + ph5 + ph6)) {
                if (so != null && dc != null && ph4 != null && ph5 != null && ph6 != null && cmap.containsKey(so + dc + pt + ph4 + ph5 + ph6)) {
                system.debug('Inside IF 999999');
                lv = cmap.get(so + dc + pt + ph4 + ph5 + ph6);
                system.debug('@@@@'+lv);
                templateid = tmap.get(lv.email_template_name__c);
                m = new Messaging.SingleEmailMessage();
                m.setReplyTo(replyTo);
                m.setSaveAsActivity(false);
                m.setSenderDisplayName(replyTo);
                system.debug('mmmmm --> '+m);
                 system.debug('mmmmm lv--> '+lv);
                setToAddresses(m, lv);
                system.debug('replyto: ' + replyto);
                m.setTargetObjectId(lv.Contact__c);
                system.debug('Contact: ' + lv.contact__c);
                m.setTemplateId(templateId);
                m.setWhatId(lr.Id);
                  
                mlist.add(m);
                successLog += 'message created\n';
                system.debug('message created');
            }
            else
            {
          
                successLog += 'message not created. cmap.containsKey result = ' + cmap.containsKey(so + dc + pt + ph4 + ph5 + ph6) + '\n';            
            }
        }
        
        system.debug('mlist: ' + mlist.isempty());
        if (!mlist.isEmpty()) {
            try {
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(mlist);
                System.debug('RESULTS: ' + results);
                successLog += '\n\nRESULTS: ' + results + '\n';
                
            } catch(Exception e) {
            
                successLog += '\n\nERROR: ' + e.getMessage() + '\n';
            }
        } else {
          
            AppLog.write('Label_Request_Functions','','Error','Error','',
                         'sendLabelRequestEmail Error: No valid emails were found based on Request Criteria.  Current User: ' + 
                         UserInfo.getUserId());
        }

        AppLog.write('Label_Request_Functions','','SuccessStatus','Info','',successLog);
    }
    
    private static Set<string> getPH4Options(){
    
	    Set<String> returnlist = new Set<string>();
	    Schema.DescribeFieldResult FR = Label_Vendor__c.Product_Supplier_PH4__c.getDescribe();
	    List<Schema.PicklistEntry> PL = FR.getPicklistValues();
	    for(schema.PickListEntry p:PL){
	       returnlist.add(p.getLabel());
	    }
	    return returnlist;
    }
    
    private static Set<string> getPH5Options(){
    
	    Set<String> returnlist = new Set<string>();
	    Schema.DescribeFieldResult FR = Label_Vendor__c.Product_Family_PH5__c.getDescribe();
	    List<Schema.PicklistEntry> PL = FR.getPicklistValues();
	    for(schema.PickListEntry p:PL){
	       returnlist.add(p.getLabel());
	    }
	    return returnlist;
    }
    
    private static Set<string> getPH6Options(){
    
	    Set<String> returnlist = new Set<string>();
	    Schema.DescribeFieldResult FR = Label_Vendor__c.Product_Segment_PH6__c.getDescribe();
	    List<Schema.PicklistEntry> PL = FR.getPicklistValues();
	    for(schema.PickListEntry p:PL){
	       returnlist.add(p.getLabel());
	    }
	    return returnlist;
    }


    private static void setToAddresses(Messaging.SingleEmailMessage m, Label_Vendor__c lv) {
        List<String> sa = new List<String>();
        if (lv.Additional_Emails__c != null) {sa = lv.Additional_Emails__c.split(CRNL);}
        if (sa != null && !sa.isEmpty()) {m.setToAddresses(sa);}
    } 
    
    private static map<string, id> gettemplateids(Map<String, Label_Vendor__c> lmap){
    
	    set<string> kset = new set<string>();
	    list<string> klist = new list<string>();
	    list<string> tlist = new list<string>();
	    list<emailtemplate> elist = new list<emailtemplate>();
	    map<string, id> tmap = new map<string, id>();
	    
	    kset = lmap.keyset();
	    klist.addall(kset);
	    
	    for(String s:klist){
	       tlist.add(lmap.get(s).email_template_name__c);   
	    }
	    
	    elist = [select id, name from emailtemplate where name in :tlist];
	    
	    for(emailtemplate e:elist){
	      tmap.put(e.name, e.id);
	    }
	
	    return tmap;
    }
    
    private static Map<String, Label_Vendor__c>getLabelVendors(List<Label_Request__c> lrs) {
        Map<String, Label_Vendor__c> cmap = new Map<String, Label_Vendor__c>(); 
        Set<String> salesOrgs = new Set<String>();
        Set<String> distChans = new Set<String>();
        String so, dc;
        for (Label_Request__c lr : lrs) {
            so = lr.Sales_Org_Code__c;
            dc = lr.Dist_Channel_Code__c;
            System.debug(so+dc);
            if (so != null) {salesOrgs.add(so);}
            if (dc != null) {distChans.add(dc);}
        }
        List<Label_Vendor__c> lvs = [select Id,
        Additional_Emails__c,                                         
        Contact__c,                                           
        Dist_Channel_Code__c,
        Sales_Org_Code__c,
        Program_Type__c,
        Product_Supplier_PH4__c,
        Product_Family_PH5__c,
        Product_Segment_PH6__c,
        Biosperse__c,
        Email_Template_name__c 
        from Label_Vendor__c where Sales_Org_Code__c in :salesOrgs
        and Dist_Channel_Code__c in :distChans
        ];
        system.debug('Size: ' + lvs.size());
        if (!lvs.isEmpty()) {
     
            
            for (Label_Vendor__c lv : lvs) {
                String[] PT = new string[]{};
                String[] PH4 = new string[]{};
                String[] PH5 = new string[]{};
                String[] PH6 = new string[]{};
                String[] k = new string[]{};
                String[] tempk = new string[]{};
                
                if(lv.Program_Type__c != null){
                    PT = lv.Program_Type__c.split(';',0);}
                else{ PT.add('Any Other');}
                if(lv.Product_Supplier_PH4__c != null){
                    PH4 = lv.Product_Supplier_PH4__c.split(';',0);}
                else{ PH4.add('Any Other');}
                if(lv.Product_Family_PH5__c != null){
                    PH5 = lv.Product_Family_PH5__c.split(';',0);}
                else{ PH5.add('Any Other');}
                if(lv.Product_Segment_PH6__c != null){
                    PH6 = lv.Product_Segment_PH6__c.split(';',0);}
                else{ PH6.add('Any Other');}
                
                    system.debug('K1: ' + k.size());
                    
                    for(integer i=0; i<PT.size(); i++){
                        k.add(lv.Sales_Org_Code__c + lv.Dist_Channel_Code__c + PT[i]);     
                    }
                    
                    system.debug('K2: ' + k.size());
                    tempk.addall(k);
                    k.clear();
                    
                    system.debug('PH4: ' + ph4.size());
                    for(integer i=0; i<PH4.size(); i++){
                       for(integer j=0; j<tempk.size(); J++){
                          k.add(tempk[j] + PH4[i]); }     
                    }
                    
                    system.debug('K3: ' + k.size());
                    tempk.clear();
                    tempk.addall(k);
                    k.clear();
                    system.debug('PH5: ' + ph5.size());
                    
                    for(integer i=0; i<PH5.size(); i++){
                       for(integer j=0; j<tempk.size(); J++){
                          k.add(tempk[j] + PH5[i]); }     
                    }
                    
                    system.debug('K4: ' + k.size());
                    tempk.clear();
                    tempk.addall(k);
                    k.clear();
                    system.debug('PH6: ' + ph6.size());
                    
                    for(integer i=0; i<PH6.size(); i++){
                       for(integer j=0; j<tempk.size(); J++){
                          k.add(tempk[j] + PH6[i]); }     
                    }
                    
                    system.debug('K5 Final: ' + k.size());
                              
                    
                    for(integer i=0; i<k.size(); i++){
                         system.debug('k[i]: ' + k[i]);
                                    system.debug('LV: ' + LV);
                        cmap.put(k[i], LV); 
                    }   

            }
        }
        system.debug('Cmap: ' + cmap);
        return cmap;
    }
    
    public static void updateLabelRequestResponse(String responseText) {
        system.debug('Inside Update reponse ');
        List<String> sa = responseText.split(NL);
        Boolean almatekReply = false; Id recordId = null;
        String dateShippedKey = 'Date Shipped (MM/DD/YYYY) :', 
               qtyShippedKey = 'Quantity Shipped :', 
               carrierKey = 'Carrier (UPS,FEDEX) :', 
               trackingNumKey = 'Tracking Number :', 
               recordIdKey = 'Label Request Reference # :';
           
        Map<String, String> smap = new Map<String,String>{
            dateShippedKey => '',
            qtyShippedKey => '',
            carrierKey => '',
            trackingNumKey => '',
            recordIdKey => ''
        };       
        for (String s : sa) {
          
            System.debug(s);
            if (s.contains('Replies:')){almatekReply = true;}
            if (almatekReply) {setMapItemValue(smap, s, dateShippedKey);
                setMapItemValue(smap, s,qtyShippedKey);
                setMapItemValue(smap, s,carrierKey);
                setMapItemValue(smap, s,trackingNumKey);
                setMapItemValue(smap, s,recordIdKey);
            }
        }
        System.debug(smap);
        
        try {recordId = smap.get(recordIdKey);} catch(Exception e) {}
        if (recordId == null) {
            AppLog.write('Label_Request_Functions','','Error','Error','',
                         'updateLabelRequestResponse : Invalid Id : ' + responseText);
        	return;
        }
        Date dateShipped = null;
        String dateShippedStr = smap.get(dateShippedKey);
        if (isNotNull(dateShippedStr)) {
      
            try {dateShipped = Date.parse(dateShippedStr);} catch(Exception e) {
	            AppLog.write('Label_Request_Functions','','Error','Error','',
	                         'updateLabelRequestResponse : Invalid ShipDate : ' + responseText);
            }
        }
        String qtyShipped = smap.get(qtyShippedKey);
        String carrier = smap.get(carrierKey);
        if (!CARRIERS.contains(carrier)) {carrier = null;}
        String trackingNum = smap.get(trackingNumKey);
        List<Label_Request__c> lrs = [select Id, Carrier__c, Date_Shipped__c, 
            Quantity_Shipped__c, Track_Label_Shipment__c, UPS_Tracking_Number__c
            from Label_Request__c where Id = :recordId];
        if (lrs.isEmpty()) {return;}
        Label_Request__c lr       = lrs[0];
        lr.Carrier__c             = carrier;
        lr.Date_Shipped__c        = dateShipped;
        lr.Quantity_Shipped__c    = qtyShipped;
        lr.Status__c              = STATUS_SHIPPED;
        lr.UPS_Tracking_Number__c = trackingNum;
        system.debug('Tracking: ' + trackingNum);

        try {
            system.debug('Status Success');
            update lr;} catch(Exception e) {
            system.debug('Status Failed');
            AppLog.write('Label_Request_Functions','','Error','Error','',
                         'updateLabelRequestResponse : Update LR : ' + responseText);
        }
    }
    
    private static Boolean isNotNull(String s) {
        return (s != null && s.trim().length() > 0);
    }
    
    private static void setMapItemValue(Map<String,String> smap, String s, String k) {
        if (s.contains(k)) {
            Integer n = s.indexOf(k);
            String v = s.substring(n + k.length());
            if (v != null) {
                smap.put(k, v.trim());
                System.debug('<<<<<<< '+ k + ' <=> [' + v.trim() + ']');
            }
        }
    }
}
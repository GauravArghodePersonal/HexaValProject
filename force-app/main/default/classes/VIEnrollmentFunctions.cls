public class VIEnrollmentFunctions {

    //private static final String DELIM = VIEnrollmentLocation.DELIM;
    private static final String COLON = ':';

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'VIEnrollmentFunctions : ' + s);
    }

    public static void processAfterUpsert(List<VI_Enrollment_Material_Order__c> emos) {
        Set<Id> elmids = new Set<Id>();
        for (VI_Enrollment_Material_Order__c emo : emos) {
            elmids.add(emo.Enrollment_Location_Material__c);
        }
        Map<Id, VI_Enrollment_Location_Material__c> elms = getELMs(elmids);
        updateELMQuantities(elms);
    }

    private static Map<Id, VI_Enrollment_Location_Material__c> getELMs(Set<Id> elmids) {
        Map<Id, VI_Enrollment_Location_Material__c> amap = new Map<Id, VI_Enrollment_Location_Material__c>();
        for (VI_Enrollment_Location_Material__c elm : [
            select Id, Name, Quantity__c, Quantity_Shipped__c,
                   Total_Quantity_Ordered__c, Total_Quantity_Shipped__c,
                  (select Id, Name, Quantity__c, Quantity_Shipped__c
                     from Enrollment_Material_Orders__r order by createdDate)
              from VI_Enrollment_Location_Material__c
             where Id in :elmids
        ]) {amap.put(elm.Id, elm);}

        return amap;
    }

    private static void updateELMQuantities(Map<Id, VI_Enrollment_Location_Material__c> elms) {
        List<VI_Enrollment_Location_Material__c> alist = new List<VI_Enrollment_Location_Material__c>();
        VI_Enrollment_Location_Material__c elm;
        for (Id i : elms.keySet()) {
            elm = elms.get(i);
            Double qo = 0.0, qs = 0.0, tqo = 0.0, tqs = 0.0;
            for (VI_Enrollment_Material_Order__c emo : elm.Enrollment_Material_Orders__r) {
                if (emo.Quantity__c != null) {qo = emo.Quantity__c; tqo += qo;}
                if (emo.Quantity_Shipped__c != null) {qs = emo.Quantity_Shipped__c; tqs += qs;}
            }
            Boolean b = true;
/*
            (elm.Quantity__c != null && elm.Quantity__c != qo) ||
            (elm.Quantity_Shipped__c != null && elm.Quantity_Shipped__c != qs) ||
            (elm.Total_Quantity_Ordered__c != null && elm.Total_Quantity_Ordered__c != tqo) ||
            (elm.Total_Quantity_Shipped__c != null && elm.Total_Quantity_Shipped__c != tqs);
*/
            if (b) {alist.add(new VI_Enrollment_Location_Material__c(
                    Id = elm.Id, Quantity__c = qo, Quantity_Shipped__c = qs,
                    Total_Quantity_Ordered__c = tqo, Total_Quantity_Shipped__c = tqs));}
        }
        if (!alist.isEmpty()) {
            try {update alist;} catch(Exception e){}
        }
    }

    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }

    public static Database.Querylocator getEnrollmentLocationsQL(String accountId, String status) {
        debug('accountId = ' + accountId + ' : status = ' + status);
        if (isNull(accountId)) {return null;}
        String q = 'select';
        q += ' Id, Name, Approval_Status__c,';
        q += ' Enrollment__r.Id, Enrollment__r.Name,';
        q += ' Facility__c, Facility__r.Name, Facility__r.AccountNumber,';
        q += ' Location__c, Location__r.Name, Location__r.AccountNumber,';
        q += ' Promotion__r.Name, Promotion__r.Program_Code__c';
        q += ' from VI_Enrollment_Location__c where (Facility__c = :accountId';
        q += ' or Facility__r.parentId = :accountId)';
        if (!isNull(status)) {q += ' and Approval_Status__c = :status';}
        q += ' order by Facility__r.Name, Location__r.Name,';
        q += ' Promotion__r.Program_Code__c, Approval_Status__c';
        debug(q);
        Database.Querylocator ql = Database.getQueryLocator(q);
        return ql;
    }

    public static void saveEnrollments(Id promoId, List<VIEnrollmentLocation> es) {
        Map<String, VI_Enrollment_Location__c> enrollmentMap = new Map<String, VI_Enrollment_Location__c>();
        saveEnrollments(promoId, es, enrollmentMap);
    }

    public static void saveEnrollments(Id promoId, List<VIEnrollmentLocation> es, Map<String, VI_Enrollment_Location__c> enrollmentMap) {
        List<VI_Enrollment_Material_Order__c> emos;
        List<VI_Enrollment_Location_Material__c> elms;
        List<VI_Enrollment_Location__c> els;
        List<VI_Enrollment__c> enrls = getEnrollments(promoId, es);
        if (enrls.isEmpty()) {return;}
        Savepoint sp = Database.setSavepoint(); Boolean sendNotifications = false;
        try {
            upsert enrls key__c;
            els = getEnrollmentLocations(es, enrollmentMap);
            if (els.isEmpty()) {return;}
            upsert els key__c;
            elms = getEnrollmentLocationMaterials(es);
            if (elms.isEmpty()) {return;}
            upsert elms key__c;
            emos = getEnrollmentMaterialOrders(elms);
            if (emos.isEmpty()) {return;}
            upsert emos;
            sendNotifications = true;
        } catch (Exception ex) {
            Database.rollback(sp);
            CustomException.throwException(new List<String>{ex.getMessage()});
            return;
        }
        if (sendNotifications) {
            VIEnrollmentNotification.sendNotifications(els);
        }
    }

    private static List<VI_Enrollment__c> getEnrollments(Id promoId, List<VIEnrollmentLocation> es) {
        List<VI_Enrollment__c> enrls = new List<VI_Enrollment__c>();
        VI_Enrollment__c e; String facId, key;
        Map<String, VI_Enrollment__c> emap = new Map<String, VI_Enrollment__c>();
        for (VIEnrollmentLocation el : es) {
            el.setMaterialTotals();
            //if (el.totalQuantity == 0) {continue;} // commented to allow enrollment without materials
            facId = el.viacc.fac.Id; key = promoId + COLON + facId;
            if (emap.containsKey(key)) {e = emap.get(key);}
            else {
                e = new VI_Enrollment__c();
                e.Facility__c = facId; e.Promotion__c = promoId; e.Key__c = key;
                emap.put(key, e); enrls.add(e);
            }
            el.setEnrollment(e);
            debug('e : ' + e);
        }
        return enrls;
    }

    private static List<VI_Enrollment__c> getEnrollments(List<VIEnrollmentLocation> es) {
        List<VI_Enrollment__c> enrls = new List<VI_Enrollment__c>();
        VI_Enrollment__c e; String facId, promoId, key;
        Map<String, VI_Enrollment__c> emap = new Map<String, VI_Enrollment__c>();
        for (VIEnrollmentLocation el : es) {
            if (el.viacc == null || el.viacc.facilityId == null) {continue;}
            facId = el.viacc.facilityId; promoId = el.promo.Id; key = promoId + COLON + facId;
            if (emap.containsKey(key)) {e = emap.get(key);}
            else {
                e = new VI_Enrollment__c();
                e.Facility__c = facId; e.Promotion__c = promoId; e.Key__c = key;
                emap.put(key, e); enrls.add(e);
            }
            el.setEnrollment(e);
        }
        return enrls;
    }

    private static List<VI_Enrollment_Location__c> getEnrollmentLocations(List<VIEnrollmentLocation> vels) {
        Map<String, VI_Enrollment_Location__c> enrollmentMap = new Map<String, VI_Enrollment_Location__c>();
        return getEnrollmentLocations(vels, enrollmentMap);
    }

    private static List<VI_Enrollment_Location__c> getEnrollmentLocations(List<VIEnrollmentLocation> vels, Map<String, VI_Enrollment_Location__c> enrollmentMap) {
        List<VI_Enrollment_Location__c> els = new List<VI_Enrollment_Location__c>();
        VI_Enrollment_Location__c el; String key;
        Set<String> aset = new Set<String>();
        for (VIEnrollmentLocation vel : vels) {
            debug('vel : ' + vel);
            if (vel.viacc == null || vel.viacc.acc == null ||
                vel.enrol == null) {continue;} //  || vel.totalQuantity == 0
            el = getEnrollmentLocation(vel); key = el.Key__c;
            if (enrollmentMap.containsKey(key)) {el = enrollmentMap.get(key);}
            else {els.add(el); enrollmentMap.put(key, el);}
            vel.setEnrollmentLocation(el);
        }
        return els;
    }

    private static VI_Enrollment_Location__c getEnrollmentLocation(VIEnrollmentLocation ve) {
        VI_Enrollment_Location__c el = new VI_Enrollment_Location__c();
        VI_Enrollment__c e = ve.enrol;
        Account a = ve.viacc.acc;
        el.Approval_Date__c = Datetime.now();
        el.Approval_Status__c = VIUtils.ENROLLMENT_STATUS_APPROVED;
        el.Enrollment__c = e.Id;
        el.Facility__c = e.Facility__c;
        el.Location__c = a.Id;
        el.Promotion__c = e.Promotion__c;
        el.Key__c = el.Promotion__c + COLON + el.Location__c;
        el.Shipping_City__c = a.BillingCity;
        el.Shipping_Postal_Code__c = a.BillingPostalCode;
        el.Shipping_State__c = a.BillingState;
        el.Shipping_Street__c = a.BillingStreet;
        debug('el : ' + el);
        return el;
    }

    private static List<VI_Enrollment_Location_Material__c> getEnrollmentLocationMaterials(List<VIEnrollmentLocation> vels) {
        List<VI_Enrollment_Location_Material__c> elms = new List<VI_Enrollment_Location_Material__c>();
        VI_Enrollment_Location_Material__c elm;
        Set<String> aset = new Set<String>();
        for (VIEnrollmentLocation vel : vels) {
            if (vel.enloc == null || vel.totalQuantity == 0) {continue;}
            VI_Enrollment_Location__c el = vel.enloc;
            for (VI_Enrollment_Location_Material__c m : vel.materials) {
                if (m.Quantity__c != null && m.Quantity__c > 0) {
                    String key = el.Id + COLON + m.Promotion_Material__c;
                    if (aset.contains(key)) {continue;}
                    aset.add(key);
                    elm = new VI_Enrollment_Location_Material__c();
                    elm.Cost__c = m.Cost__c;
                    elm.Enrollment_Location__c = el.Id;
                    elm.Key__c = key;
                    elm.Material__c = m.Material__c;
                    elm.Promotion_Material__c = m.Promotion_Material__c;
                    elm.Quantity__c = m.Quantity__c;
                    elms.add(elm);
                    debug('elm : ' + elm);
                }
            }
        }
        return elms;
    }

    private static List<VI_Enrollment_Material_Order__c> getEnrollmentMaterialOrders(List<VI_Enrollment_Location_Material__c> elms) {
        List<VI_Enrollment_Material_Order__c> emos = new List<VI_Enrollment_Material_Order__c>();
        for (VI_Enrollment_Location_Material__c elm : elms) {
            if (elm.Quantity__c == null || elm.Quantity__c == 0.0) {continue;}
            emos.add(new VI_Enrollment_Material_Order__c(
                         Enrollment_Location_Material__c = elm.Id,
                         Key__c = elm.Id,
                         Quantity__c = (elm.Quantity__c != null) ? elm.Quantity__c : 0));
        }
        debug('emos : ' + emos);
        return emos;
    }

    public static void createEnrollments(List<VIEnrollmentLocation> es) {
        if (es == null || es.isEmpty()) {return;}
        List<VI_Enrollment_Location__c> els;
        List<VI_Enrollment__c> enrls = getEnrollments(es);
        if (enrls.isEmpty()) {return;}
        Savepoint sp = Database.setSavepoint(); Boolean sendNotifications = false;
        try {
            upsert enrls key__c;
            debug('enrls : '+enrls);
            els = getEnrollmentLocations(es);
            if (els.isEmpty()) {return;}
            upsert els key__c;
            debug('els : '+els);
            sendNotifications = true;
        } catch (Exception ex) {
            Database.rollback(sp);
            CustomException.throwException(new List<String>{ex.getMessage()});
            return;
        }
        if (sendNotifications) {
            VIEnrollmentNotification.sendNotifications(els);
        }
    }

}
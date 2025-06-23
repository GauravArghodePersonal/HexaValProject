public with sharing class VIEnrollmentLocationFunctions {
	
	public static void updateEnrollmentMaterials(List<VI_Enrollment_Location__c> els) {
		if (els == null || els.isEmpty()) {return;}
		List<VI_Enrollment_Location_Material__c> elms = new List<VI_Enrollment_Location_Material__c>();
		Map<Id, Map<String, Id>> pmap = getPromotionMaterialsMap(els); 
		Id pid; Map<String, Id> mmap;
		for (VI_Enrollment_Location__c el : els) {
			pid = el.Enrollment__r.Promotion__c;
			if (!pmap.containsKey(pid)) {continue;}
			mmap = pmap.get(pid);
			for (VI_Enrollment_Location_Material__c elm : el.Enrollment_Location_Materials__r) {
                if (mmap.containsKey(elm.Material__c)) {
                	elm.Promotion_Material__c = mmap.get(elm.Material__c);
                	elms.add(elm);
                }
			} 
		}
		if (!elms.isEmpty()) {
			try {update elms;} catch(Exception e) {}
		} 
	}
	
	// Map<PromotionId, Map<Material, PromotionMaterialId>>
	private static Map<Id, Map<String, Id>> getPromotionMaterialsMap(List<VI_Enrollment_Location__c> els) {
		Map<Id, Map<String, Id>> pmap = new Map<Id, Map<String, Id>>();
        Set<Id> pids = new Set<Id>(); Map<String, Id> mmap;
        for (VI_Enrollment_Location__c el : els) {pids.add(el.Enrollment__r.Promotion__c);}
        for (VI_Promotion__c p : [
            select Id, (select Id, Material__c from Promotion_Materials__r)
              from VI_Promotion__c where Id in :pids]) {
	      	if (pmap.containsKey(p.Id)) {mmap = pmap.get(p.Id);}
	      	else {mmap = new Map<String, Id>(); pmap.put(p.Id, mmap);}
            for (VI_Promotion_Material__c pm : p.Promotion_Materials__r) {
            	mmap.put(pm.Material__c, pm.Id);
            }
        }
        return pmap; 
	}

}
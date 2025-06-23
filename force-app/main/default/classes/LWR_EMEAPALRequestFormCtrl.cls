public with sharing class LWR_EMEAPALRequestFormCtrl {

    /**
     * @description 
     */
    @AuraEnabled
    public static PALRequestFormWrapper getPALRequestForm(String sitRecordId, String lwrRecordId, String recordType) {
        PALRequestFormWrapper requestFormWrapperInstance = new PALRequestFormWrapper();
        List<Sample_Test_Information__c> stiRecords = getSITRecordDetails(sitRecordId);
        if(stiRecords.isEmpty()){
            requestFormWrapperInstance = getPALRequestFormWrapperInstance(lwrRecordId, recordType);
        } else {
            requestFormWrapperInstance = getPALRequestFormWrapperInstance(stiRecords[0]);
        }

        return requestFormWrapperInstance;
    }

    /**
     * @description 
     */
    @AuraEnabled
    public static string saveRequestForm(PALRequestFormWrapper requestFormWrapperInstance){
        system.debug('>>> requestFormWrapperInstance >>>' + JSON.serialize(requestFormWrapperInstance));
        Sample_Test_Information__c sitRecord = new Sample_Test_Information__c();
        sitRecord.Id = requestFormWrapperInstance.sampleTestInformation.recordId;
        sitRecord.recordTypeId = requestFormWrapperInstance.sampleTestInformation.recordTypeId;
        sitRecord.LWR__c = requestFormWrapperInstance.sampleTestInformation.lwrId;
        sitRecord.SBU_Area__c = requestFormWrapperInstance.sampleTestInformation.sbuOrArea;
        sitRecord.SBU_Area_Contact_Person__c = requestFormWrapperInstance.sampleTestInformation.contactPerson; 
        sitRecord.Additional_Comments__c = requestFormWrapperInstance.sampleTestInformation.addlComments;

        List<PAL_Request_Form__c> references = new List<PAL_Request_Form__c>();
        List<PAL_Request_Form__c> referencesToDelete = new List<PAL_Request_Form__c>();
        try{
            Upsert sitRecord;
            if(requestFormWrapperInstance.referencesByAreaAndTest != null) {
                for(AddlReferencesByTestAndSBU refByArea : requestFormWrapperInstance.referencesByAreaAndTest) {
                    for(AddlReferenceWrapper ref : refByArea.references) {
                        if(!refByArea.selected && String.isBlank(ref.recordId)){
                            continue;
                        }
                        
                        PAL_Request_Form__c record = new PAL_Request_Form__c();
                        record.Id = ref.recordId;
                        record.Area_SBU_Test_Ref__c = ref.sbuOrAreaId;
                        record.Area_SBU_Test_With_Addl_Reference__c = ref.ReferenceId;
                        record.Sample_Test_Information__c = sitRecord.Id;
                        record.Information__c = ref.information;
                        if(refByArea.selected) {
                            references.add(record);
                        } else if(String.isNotBlank(ref.recordId)) {
                            referencesToDelete.add(record);
                        }
                    }
                }

                if(!references.isEmpty()) {    
                    JSON.serialize(references);            
                    Upsert references;
                }

                if(!referencesToDelete.isEmpty()) {
                    delete referencesToDelete;
                }
            }
        }
        catch (DmlException ex) {
        throw new AurahandledException('Error Details : ' + ex.getDmlMessage(0));}//added catch Dml block
        catch(Exception ex){
            System.debug('>>> Exception >>>' + JSON.serialize(ex));
        }

        return sitRecord.Id;
    }

    /**
     * @description 
     */
    @TestVisible
    private static PALRequestFormWrapper getPALRequestFormWrapperInstance(String lwrRecordId, String recordTypeId) 
    {
        List<Area_SBU_Test_With_Addl_Reference__c> additionalRefs = getTestWithAddlReferences();            
        Map<String,List<Area_SBU_Test_With_Addl_Reference__c>> referencesByArea = getReferencesByArea(additionalRefs); 
        Map<String,String> areaByIdMap = getAreaByIdMap(referencesByArea.keySet());
        List<AddlReferencesByTestAndSBU> referencesByAreaAndTestInstances = new List<AddlReferencesByTestAndSBU>();
        for(String area : referencesByArea.keySet()){
            AddlReferencesByTestAndSBU instance = new AddlReferencesByTestAndSBU();
            instance.areaOrSbuAndTest = area;
            instance.selected = false;
            List<AddlReferenceWrapper> addlRefWrapperInstanceList = new List<AddlReferenceWrapper>();
            for(Area_SBU_Test_With_Addl_Reference__c ref : referencesByArea.get(area)) {
                AddlReferenceWrapper addlRefWrapperInstance = new AddlReferenceWrapper();
                addlRefWrapperInstance.ReferenceId = ref.Id;
                addlRefWrapperInstance.addlReference = ref.Addl_References__r.Name;
                addlRefWrapperInstance.textType = ref.Reference_Type__c == 'Text';
                addlRefWrapperInstance.checkboxType = ref.Reference_Type__c == 'Checkbox';
                addlRefWrapperInstance.information = '';
                addlRefWrapperInstanceList.add(addlRefWrapperInstance);
            }

            if(referencesByArea.get(area) != null && referencesByArea.get(area).isEmpty()){
                AddlReferenceWrapper addlRefWrapperInstance = new AddlReferenceWrapper();
                addlRefWrapperInstance.sbuOrAreaId = areaByIdMap.get(area);
                addlRefWrapperInstance.information = '';
                addlRefWrapperInstanceList.add(addlRefWrapperInstance);

            }
            instance.references = addlRefWrapperInstanceList;
            referencesByAreaAndTestInstances.add(instance);
        }

        STIWrapper sitWrapperInstance = new STIWrapper();
        sitWrapperInstance.lwrId = lwrRecordId;
        sitWrapperInstance.recordTypeId = recordTypeId;
        sitWrapperInstance.addlComments  = '';

        PALRequestFormWrapper requestFormWrapperInstance = new PALRequestFormWrapper();
        requestFormWrapperInstance.sampleTestInformation = sitWrapperInstance;
        requestFormWrapperInstance.referencesByAreaAndTest = referencesByAreaAndTestInstances;
        
        return requestFormWrapperInstance;
    }

    /**
     * @description 
     */   
    @TestVisible
    private static PALRequestFormWrapper getPALRequestFormWrapperInstance(Sample_Test_Information__c sitRecord) 
    {
        List<Area_SBU_Test_With_Addl_Reference__c> additionalRefs = getTestWithAddlReferences();            
        Map<String,List<Area_SBU_Test_With_Addl_Reference__c>> referencesByArea = getReferencesByArea(additionalRefs);  
        Map<String,Map<String,PAL_Request_Form__c>> palRequestFormMap = getPALRequestFormMap(sitRecord.PAL_Request_Forms__r);
        List<AddlReferencesByTestAndSBU> referencesByAreaAndTestInstances = new List<AddlReferencesByTestAndSBU>();
        for(String area : referencesByArea.keySet()){
            AddlReferencesByTestAndSBU instance = new AddlReferencesByTestAndSBU();
            instance.areaOrSbuAndTest = area;
            instance.selected = palRequestFormMap.containsKey(area);
            Map<String,PAL_Request_Form__c> referenceMap = palRequestFormMap.get(area);
            List<AddlReferenceWrapper> addlRefWrapperInstanceList = new List<AddlReferenceWrapper>();
            for(Area_SBU_Test_With_Addl_Reference__c ref : referencesByArea.get(area)) {
                AddlReferenceWrapper addlRefWrapperInstance = new AddlReferenceWrapper();
                if(ref != null){
                    addlRefWrapperInstance.ReferenceId = ref.Id;
                    addlRefWrapperInstance.addlReference = ref.Addl_References__r.Name;
                    addlRefWrapperInstance.textType = ref.Reference_Type__c == 'Text';
                    addlRefWrapperInstance.checkboxType = ref.Reference_Type__c == 'Checkbox';

                    if(ref.Addl_References__r != null && referenceMap != null && referenceMap.get(ref.Addl_References__r.Name) != null){
                        addlRefWrapperInstance.recordId = referenceMap.get(ref.Addl_References__r.Name).Id;
                        addlRefWrapperInstance.information = referenceMap.get(ref.Addl_References__r.Name).Information__c;
                        addlRefWrapperInstance.selected = addlRefWrapperInstance.information == 'true';
                    } 
                }
                
                addlRefWrapperInstanceList.add(addlRefWrapperInstance);
            }
            instance.references = addlRefWrapperInstanceList;
            referencesByAreaAndTestInstances.add(instance);
        }

        STIWrapper sitWrapperInstance = new STIWrapper();
        sitWrapperInstance.recordId      = sitRecord.Id;
        sitWrapperInstance.lwrId         = sitRecord.LWR__c;
        sitWrapperInstance.sbuOrArea     = sitRecord.SBU_Area__c;
        sitWrapperInstance.contactPerson = sitRecord.SBU_Area_Contact_Person__c;
        sitWrapperInstance.addlComments  = sitRecord.Additional_Comments__c;

        PALRequestFormWrapper requestFormWrapperInstance = new PALRequestFormWrapper();
        requestFormWrapperInstance.sampleTestInformation = sitWrapperInstance;
        requestFormWrapperInstance.referencesByAreaAndTest = referencesByAreaAndTestInstances;
        
        return requestFormWrapperInstance;
    }

    /**
     * @description 
     */   
    @AuraEnabled
    public static PALRequestFormWrapper getPALRequestFormForView(String sitRecordId) 
    {
        List<Sample_Test_Information__c> stiRecords = getSITRecordDetails(sitRecordId);
        Map<String,Map<String,PAL_Request_Form__c>> palRequestFormMap = getPALRequestFormMap(stiRecords[0].PAL_Request_Forms__r);
        List<AddlReferencesByTestAndSBU> referencesByAreaAndTestInstances = new List<AddlReferencesByTestAndSBU>();
        for(String area : palRequestFormMap.keySet()){
            AddlReferencesByTestAndSBU instance = new AddlReferencesByTestAndSBU();
            instance.areaOrSbuAndTest = area;
            Map<String,PAL_Request_Form__c> referenceMap = palRequestFormMap.get(area);
            List<AddlReferenceWrapper> addlRefWrapperInstanceList = new List<AddlReferenceWrapper>();
            for(String ref : referenceMap.keySet()) {
                AddlReferenceWrapper addlRefWrapperInstance = new AddlReferenceWrapper();
                addlRefWrapperInstance.addlReference = ref;
                addlRefWrapperInstance.information = referenceMap.get(ref).Information__c; 
                addlRefWrapperInstance.selected = addlRefWrapperInstance.information == 'true';
                addlRefWrapperInstance.textType = referenceMap.get(ref).Area_SBU_Test_With_Addl_Reference__r.Reference_Type__c == 'Text';
                addlRefWrapperInstance.checkboxType = referenceMap.get(ref).Area_SBU_Test_With_Addl_Reference__r.Reference_Type__c == 'Checkbox';
                addlRefWrapperInstanceList.add(addlRefWrapperInstance);
            }

            instance.references = addlRefWrapperInstanceList;
            referencesByAreaAndTestInstances.add(instance);
        }

        STIWrapper sitWrapperInstance = new STIWrapper();
        sitWrapperInstance.lwrId         = stiRecords[0].LWR__c;
        sitWrapperInstance.sbuOrArea     = stiRecords[0].SBU_Area__c;
        sitWrapperInstance.contactPerson = stiRecords[0].SBU_Area_Contact_Person__c;
        sitWrapperInstance.addlComments  = stiRecords[0].Additional_Comments__c;

        PALRequestFormWrapper requestFormWrapperInstance = new PALRequestFormWrapper();
        requestFormWrapperInstance.sampleTestInformation = sitWrapperInstance;
        requestFormWrapperInstance.referencesByAreaAndTest = referencesByAreaAndTestInstances;
        
        return requestFormWrapperInstance;
    }

    /**
     * 
     */
    private static void addAreasWithNoAddlReferences(Map<String,List<Area_SBU_Test_With_Addl_Reference__c>> referencesByArea) {
        for(PAL_Request_Form_Area_SBU_Test__c area :[SELECT Id, Name FROM PAL_Request_Form_Area_SBU_Test__c WHERE Name NOT IN :referencesByArea.keyset() AND Active__c = true ORDER BY Sequence_Order__c ASC]) 
        {
            referencesByArea.put(area.Name, new List<Area_SBU_Test_With_Addl_Reference__c>());
        }
    }

    private static Map<String,String> getAreaByIdMap(Set<String> areas) {
        Map<String,String> areaByIdMap = new Map<String,String>();
        for(PAL_Request_Form_Area_SBU_Test__c area :[SELECT Id, Name FROM PAL_Request_Form_Area_SBU_Test__c WHERE Name IN :areas]) 
        {
            areaByIdMap.put(area.Name, area.Id);
        }
        return areaByIdMap;
    }

    /**
     * @description Obtain sample test information along with associated references
     */
    private static Map<String,List<Area_SBU_Test_With_Addl_Reference__c>> getReferencesByArea(List<Area_SBU_Test_With_Addl_Reference__c> additionalRefs){
        Map<String,List<Area_SBU_Test_With_Addl_Reference__c>> referencesByArea = new Map<String,List<Area_SBU_Test_With_Addl_Reference__c>>();
        for(Area_SBU_Test_With_Addl_Reference__c addlReference : additionalRefs){
            List<Area_SBU_Test_With_Addl_Reference__c> refs = referencesByArea.get(addlReference.Area_SBU_Test__r.Name);
            refs = (refs == null)?new List<Area_SBU_Test_With_Addl_Reference__c>():refs;
            refs.add(addlReference);
            referencesByArea.put(addlReference.Area_SBU_Test__r.Name, refs);
        }         
        addAreasWithNoAddlReferences(referencesByArea);
        return referencesByArea;
    } 

    /**
     * @description Obtain sample test information along with associated references
     */    
    private static Map<String,Map<String,PAL_Request_Form__c>> getPALRequestFormMap(List<PAL_Request_Form__c> forms){
        Map<String,Map<String,PAL_Request_Form__c>> palRequestFormMap = new Map<String,Map<String,PAL_Request_Form__c>>();
        for(PAL_Request_Form__c form : forms){
            Map<String,PAL_Request_Form__c> referenceMap = palRequestFormMap.get(form.Area_SBU_Test__c);
            referenceMap = (referenceMap == null)?new Map<String,PAL_Request_Form__c>():referenceMap;
            if(String.isNotBlank(form.Addl_References__c)) {
                referenceMap.put(form.Addl_References__c,form);
            }           
            palRequestFormMap.put(form.Area_SBU_Test__c,referenceMap);
        }

        return palRequestFormMap;
    }

    /**
     * @description Obtain sample test information along with associated references
     */
    public static List<Sample_Test_Information__c> getSITRecordDetails(String sitRecordId) {
        return [SELECT Id, 
                       LWR__c,
                       SBU_Area__c, 
                       SBU_Area_Contact_Person__c, 
                       Additional_Comments__c,
                       (SELECT Id,
                               Area_SBU_Test_With_Addl_Reference__r.Reference_Type__c,
                               Addl_Reference_Sequence_Order__c,
                               Addl_References__c,
                               Area_SBU_Test__c,
                               Area_SBU_Test_Ref__c,
                               Information__c
                            FROM    
                                PAL_Request_Forms__r
                            WHERE 
                            ( Area_SBU_Test_With_Addl_Reference__r.Active__c = true OR 
                            Area_SBU_Test_With_Addl_Reference__c = null )
                            ORDER BY 
                                Area_SBU_Test_With_Addl_Reference__r.Area_SBU_Test_Order__c,
                                Area_SBU_Test_With_Addl_Reference__r.Sequence_Order__c
                                NULLS LAST
                       )
                    FROM 
                        Sample_Test_Information__c
                    WHERE
                        Id = :sitRecordId
                ];
    }

    /**
     * @description Obtain active additional reference records
     */
    public static List<Area_SBU_Test_With_Addl_Reference__c> getTestWithAddlReferences() {
        return [SELECT Id, 
                       Addl_References__c,
                       Area_SBU_Test__c,
                       Reference_Type__c,
                       Addl_References__r.Name,
                       Area_SBU_Test__r.Name
                FROM 
                    Area_SBU_Test_With_Addl_Reference__c
                WHERE 
                    Active__c = true
                ORDER BY
                    Area_SBU_Test_Order__c,
                    Sequence_Order__c
               ];
    }

    /**
     * @description Obtain active area/sbu and test combinations
     */
    @AuraEnabled(cacheable=true)
    public static list<string> getActiveAreaAndTestCombinations(){
        try {
            list<string> combinations = new list<string>();
            for(PAL_Request_Form_Area_SBU_Test__c prfast : [SELECT Name FROM PAL_Request_Form_Area_SBU_Test__c WHERE Active__c = true])
            {
                combinations.add(prfast.Name);
            }

            return combinations;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    /**
     * @description Wrapper class holds sample test information with 
     *              additional references with information
     */
    public class PALRequestFormWrapper {
        @AuraEnabled 
        public STIWrapper sampleTestInformation      { get;set; }
        @AuraEnabled 
        public List<AddlReferencesByTestAndSBU> referencesByAreaAndTest { get;set; }
    }

    /**
     * @description Wrapper class holds sample test information
     */
    public class STIWrapper {
        @AuraEnabled 
        public String recordId      { get;set; }
        @AuraEnabled 
        public String recordTypeId  { get;set; }
        @AuraEnabled 
        public String lwrId         { get;set; }
        @AuraEnabled 
        public String sbuOrArea     { get;set; }
        @AuraEnabled 
        public String contactPerson { get;set; }
        @AuraEnabled 
        public String addlComments  { get;set; }

        public STIWrapper() {
            this.recordId = null;
            this.sbuOrArea = '';
            this.contactPerson = '';
            this.addlComments = '';
        }
        
    }

    /**
     * @description Wrapper class holds additional reference information
     */
    public class AddlReferenceWrapper {
        @AuraEnabled 
        public String recordId          { get;set; }
        @AuraEnabled 
        public String addlReference     { get;set; }
        @AuraEnabled
        public String information       { get;set; }
        @AuraEnabled
        public Boolean selected         { get;set; }
        @AuraEnabled 
        public String sbuOrAreaId       { get;set; }
        @AuraEnabled
        public String ReferenceId { get;set; }
        @AuraEnabled
        public Boolean textType         { get;set; }
        @AuraEnabled
        public Boolean checkboxType     { get;set; }

        public AddlReferenceWrapper() {
            this.recordId = null;
            this.addlReference = '';
            this.information = '';
            this.sbuOrAreaId = null;
            this.ReferenceId = null;
        }
    }

    /**
     * @description Wrapper class groups additional reference information by test
     */
    public class AddlReferencesByTestAndSBU {
        @AuraEnabled 
        public String areaOrSbuAndTest { get;set; }
        @AuraEnabled 
        public Boolean selected        { get;set; }
        @AuraEnabled
        public List<AddlReferenceWrapper> references { get;set; }
    }

}
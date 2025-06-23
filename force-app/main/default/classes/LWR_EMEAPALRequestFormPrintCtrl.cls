public with sharing class LWR_EMEAPALRequestFormPrintCtrl {

    public Sample_Test_Information__c sampleTestInformation { get;set; }
    public Map<String,List<PAL_Request_Form__c>> requestFormsByArea { get;set; }

    public LWR_EMEAPALRequestFormPrintCtrl(ApexPages.StandardController stdController)
    {
    
        this.sampleTestInformation = (Sample_Test_Information__c)stdController.getRecord();
        this.sampleTestInformation = getSITRecordDetails()[0];
        this.requestFormsByArea = getPALRequestFormMap(this.sampleTestInformation.PAL_Request_Forms__r);
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=' + 'PAL Request Form - ' + this.sampleTestInformation.Name + '.pdf');
        
    }

    public LWR_EMEAPALRequestFormPrintCtrl() { 
        
    }
    
    public List<Sample_Test_Information__c> getSITRecordDetails() {
        return [SELECT Name,
                       SBU_Area__c, 
                       SBU_Area_Contact_Person__c, 
                       Additional_Comments__c,
                       (SELECT Addl_References__c,
                               Area_SBU_Test__c,
                               Information__c
                            FROM    
                                PAL_Request_Forms__r
                            WHERE 
                                ( Area_SBU_Test_With_Addl_Reference__r.Active__c = true OR 
                            		Area_SBU_Test_With_Addl_Reference__c = null )
                            ORDER BY 
                                Area_SBU_Test_With_Addl_Reference__r.Area_SBU_Test_Order__c,
                                Area_SBU_Test_With_Addl_Reference__r.Sequence_Order__c
                       )
                    FROM 
                        Sample_Test_Information__c
                    WHERE
                        Id = :this.sampleTestInformation.Id
                ];
    }

    @TestVisible
    private Map<String,List<PAL_Request_Form__c>> getPALRequestFormMap(List<PAL_Request_Form__c> forms){
        Map<String,List<PAL_Request_Form__c>> palRequestFormMap = new Map<String,List<PAL_Request_Form__c>>();
        for(PAL_Request_Form__c form : forms){
            List<PAL_Request_Form__c> references = palRequestFormMap.get(form.Area_SBU_Test__c);
            references = (references == null)?new List<PAL_Request_Form__c>():references;
            references.add(form);
            palRequestFormMap.put(form.Area_SBU_Test__c,references);
        }

        return palRequestFormMap;
    }
}
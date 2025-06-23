public with sharing class Material2ConversionController {

    private String objectName;
    private String oldField;
    private String newField;

    public String objectDetails {get; set;}
    
    PageReference ajpr = new PageReference('/apexpages/setup/listAsyncApexJobs.apexp');
    
    //String batchSize = CustomSettings_Functions.getBW_Data_BatchSize();
    
    public PageReference submitBatchJob() {
        if (objectDetails == null || objectDetails.trim().length() == 0) {
            return null;
        }
        List<String> sa = objectDetails.split(',');
        objectName = sa[0];
        oldField = sa[1];
        newField = sa[2];
        Material2ConversionBatchable b = new Material2ConversionBatchable(objectName,
                                                                          oldField,
                                                                          newField);
        Id processId;
        try {
            processId = Database.executeBatch(b);
            return ajpr;
        } catch(DmlException de) {
            System.debug(de.getMessage());
        }
        return null;
    }
    
}
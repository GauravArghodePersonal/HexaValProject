/**
 * @description This method is used for data factory for standard OOB application and construct data and modify the records based on dataCode
 * 
 * [SL-3]: Global Account - Documents tab: Add/Edit/Delete Validation Rule for Quality Roles
 */ 
@SuppressWarnings('PMD')
public class CQ_CCC_Test_Data_Factory {
    private static Integer disableCount = 0;
    private static final string CLIENT_CODE = 'SL';
    private static final string CLIENT_CODE_TEST_PREFIX = 'CQ_'+ CLIENT_CODE +'_Test';
    private CQ_SL_Test_SObject_Factory SobjectFactory;
    
    /**
     * @description constructor which ensure Object factory name is present or not depends upon given object type and create instance of sobject factory
     * @param sobjectType
     */
    public CQ_CCC_Test_Data_Factory(SObjectType sobjectType) {
        String factoryName;
        if(sobjectType.getDescribe().getName().contains('compliancequest__SQX')||sobjectType.getDescribe().getName().contains('CQ_SL_SQX'))
        {
            factoryName = sobjectType.getDescribe().getName().replace('compliancequest__SQX', CLIENT_CODE_TEST_PREFIX).replace('__c', '').replace('compliancequest', '').replace('CQ_SL_SQX',CLIENT_CODE_TEST_PREFIX) + '_Factory';
        }
        else{
            factoryName = sobjectType.getDescribe().getName().replace('__c', '').replace('CQ_SL',CLIENT_CODE_TEST_PREFIX) + '_Factory';
            if(!factoryName.startsWith('CQ_')) {
                // append sqx prefix for SF standard object
                if(factoryName=='Sales_Order_Deliveries_Factory'){
                    factoryName='SO_Deliveries_Factory';
                }
                factoryName = CLIENT_CODE_TEST_PREFIX+'_' + factoryName;
                
            }
        }
        Type factoryObj = Type.forName(factoryName);
        
        System.assert(factoryObj != null, 'No factory class named ' +factoryName+ ' is found for the object type ' + sobjectType);
        
        sobjectFactory = (CQ_SL_Test_SObject_Factory) factoryObj.newInstance();
    }
        
    /**
     * @description This method is used to construct data seingt depend upon dataCode which is pass through test setup. Also the modifier parameter defines the class used to modify the data.
     * @param dataCode
     * @return list of string
     */
    public Map<String, SObject> constructData(String dataCode) {
        try {
            //need to disable triggers or assign migration user permission to the user
            return sobjectFactory.constructData(dataCode);   
        } finally {//NOPMD
            system.assert(true,'Unable to Create Data');        
        }       
    }
}
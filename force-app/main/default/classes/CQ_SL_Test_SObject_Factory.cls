/** 
 * @description This interface will be used for testing purposes and will be invoked by the test setup to contruct data related to data code.
 */
public interface CQ_SL_Test_SObject_Factory {
    /**
     * @description returns result based on data code
     * @param dataCode
     * @return Map
     */
    Map<String, SObject> constructData(String dataCode);
}
/**
 * @description Class contains queries to retrieve the data
 * @author      Lavakusa
 * @date        Created: 14-Jul-2022
 */

public with sharing class BCS_DataAccessor {
    /**
     * @description Obtain bar code scanner configuration records
     * @author      Lavakusa
     * @date        Created: 14-Jul-2022
     * @param       none
     * @return      bar code scanner metadata object records
     */
    public static List<Barcode_Scanner_SObject_Configuration__mdt> getBarCodeScannerConfigurations(Boolean returnSearchConfig) {
        String objQueryFields = 'Id, Layout_Type__c, Mode__c, SObject_Type__c';
        String fieldQueryFields = 'Id, Field_API_Name__c, Active__c, UI_Display__c,Available_For_Search__c,';
        String fieldQueryOrderByClause = ' Parent_Object_Configuration__c,';
        if (returnSearchConfig) {
            fieldQueryFields += 'Field_Order_Record_Search__c, Editable_On_UI_Record_Search__c, Search_UI_Display__c';
            fieldQueryOrderByClause += 'Field_Order_Record_Search__c';
        } else {
            fieldQueryFields += 'Field_Order__c, Editable_On_UI__c';
            fieldQueryOrderByClause += 'Field_Order__c';
        }

        String fieldQuery = 'SELECT ' + fieldQueryFields + ' FROM Field_Configurations__r' + ' WHERE ' + (returnSearchConfig?'Available_For_Search__c = true':'Available_For_Scanner__c = true') + ' ORDER BY ' + fieldQueryOrderByClause;
        String objectQuery = ' SELECT ' + objQueryFields + ',' + '(' + fieldQuery + ')' + ' FROM Barcode_Scanner_SObject_Configuration__mdt ' + ' ORDER BY SObject_Type__c';
        System.debug(objectQuery);
        return (List<Barcode_Scanner_SObject_Configuration__mdt>) Database.query(objectQuery);
    }

    /**
     * @description Obtain records that match the code in the passed objects
     * @author      Lavakusa
     * @date        Created: 14-Jul-2022
     * @param       barcodeId  barcode value Identifier
     * @param       searchGroup Scope of fields to search
     * @param       returningFieldSpec Information to return in the search result
     * @return
     */
    public static List<List<SObject>> getSearchResults(String keyWord, String searchGroup, String returningFieldSpec) {
        String searchStr = string.escapeSingleQuotes(keyWord);
        String searchQuery = 'FIND \'' + searchStr + '\' IN ' + searchGroup + ' ' + returningFieldSpec;
        System.debug('>>> searchQuery >>>' + searchQuery);
        List<List<SObject>> results = search.query(searchQuery);
        if(results[0].isEmpty() && String.isNotBlank(keyWord)) {
            keyword = ('%' + keyword + '%');
            results.add([SELECT Id, 
                             Name, 
                             RecordTypeId, 
                             Account.AccountNumber,
                             Equipment_Number__c,
                             AccountId,
                             Sales_Org_Region__c,
                             Equipment_Status__c 
                             FROM Asset
                             WHERE Account.AccountNumber LIKE :keyword]);
        }
        
        return results;
    }

    /**
     * @description Obtain the record types of the SObject Type
     * @author      Lavakusa
     * @date        Created: 14-Jul-2022
     * @param       sobjType SObject Type
     * @return      List of SObject Record Types
     */
    public static List<RecordType> getRecordTypes(String sobjType) {
        return [
                SELECT Id
                FROM RecordType
                WHERE SObjectType = :sobjType
        ];
    }
}
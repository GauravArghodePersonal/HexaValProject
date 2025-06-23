/**
 * Created by ricardo on 11/2/20.
 */

public with sharing class CodeScannerController {

    @AuraEnabled
    public static Chemical_Container__c searchChemicalContainer(String code) {
        return [
                SELECT Id, Name
                FROM Chemical_Container__c
                WHERE QR_Code__c = :code
        ];
    }
}
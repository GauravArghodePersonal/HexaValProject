/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class RecordType_Functions_Test {

static testMethod void myUnitTest() {
        Test.startTest();
      
    String RecordTypeId = '';
    String RecordTypeName = '';
    String BusinessName = '';
    
    RecordTypeId = RecordType_Functions.LookupRecordTypeId('Customer Care','Account');
    RecordTypeName = RecordType_Functions.LookupRecordTypeName(RecordTypeId);
    BusinessName =  RecordType_Functions.getBusinessNameForAccountType(RecordTypeID);
    

    System.Debug('RecordTypeId = ' + RecordTypeId);
    System.Debug('RecordTypeName = ' + RecordTypeName);
    System.Debug('Business Name = ' + BusinessName);

    RecordTypeId = RecordType_Functions.LookupRecordTypeId('','');

    System.Debug('Bad RecordTypeId = ' + RecordTypeId);

    Map<String, Id> Map1 = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
    Map<Id, String> Map2 = RecordType_Functions.RetrieveRecordTypeIdMap('Account');
    Map<Id, String> Map3 = RecordType_Functions.RetrieveAccRecordTypeMap();
    System.debug('Map1=' + Map1);
    System.debug('Map2=' + Map2);
    System.debug('Map3=' + Map3);

}



}
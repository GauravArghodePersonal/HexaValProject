@isTest
private class SAP_Material_Queries_Test {

    // Most of the Test Coverage is included in Material_Sales_Data_Functions_Test
    
    static testMethod void myUnitTest() {
        List<String> prodLines = new List<String>();
        Test.startTest();
        SAP_Material_Queries.getProductLines('99');
        SAP_Material_Queries.getProductFamiliesForDistChan('007');
        SAP_Material_Queries.getProductFamilies('00','01');
        SAP_Material_Queries.getProductLinesForFamily('00','01');
        SAP_Material_Queries.getProductFamilyList('00',prodLines);
        SAP_Material_Queries.getProductLinesForFamilies('00',prodLines);
        SAP_Material_Queries.getProductSubSegments('00',prodLines,prodLines);
        Test.stopTest();
    }

}
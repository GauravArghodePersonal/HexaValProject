@IsTest
private class CF_NamespaceUtilsTest {

    @IsTest
    static void test_namespace() {

        Test.startTest();

        String namespace = [ SELECT NamespacePrefix FROM ApexClass WHERE Name = 'CF_NamespaceUtilsTest' LIMIT 1 ].NamespacePrefix;
        String namespaceApi = ( String.isBlank( namespace ) ? '' : namespace + '__' );

        Test.stopTest();

        System.assertEquals( namespace, CF_NamespaceUtils.NAMESPACE );
        System.assertEquals( namespaceApi, CF_NamespaceUtils.NAMESPACE_API );

    }

}
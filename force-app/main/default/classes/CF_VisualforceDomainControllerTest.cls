@IsTest
private class CF_VisualforceDomainControllerTest {

    @IsTest
    static void test_get_org_domain_url() {

        Test.setCurrentPage( Page.CF_VisualforceDomainPage );

        Test.startTest();

        CF_VisualforceDomainController controller = new CF_VisualforceDomainController();

        String domainURL = controller.getOrgDomainURL();

        System.assertEquals( URL.getOrgDomainUrl().toExternalForm(), domainURL );

        Test.stopTest();

    }

    @IsTest
    static void test_get_visualforce_domain_url() {

        Test.setCurrentPage( Page.CF_VisualforceDomainPage );

        Test.startTest();

        CF_VisualforceDomainController controller = new CF_VisualforceDomainController();

        String domainURL = controller.getVisualforceDomainURL();

        // The test is not running in Visualforce context,
        // so best we can get here is domain in Apex context.
        System.assertEquals( URL.getSalesforceBaseUrl().toExternalForm(), domainURL );

        Test.stopTest();

    }

}
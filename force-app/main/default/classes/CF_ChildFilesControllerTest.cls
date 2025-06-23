@IsTest
private class CF_ChildFilesControllerTest {

    @IsTest
    static void test_get_related_files_by_looked_up_activity() {

        /*Account acct = new Account(
            name = 'Test Account'
        );

        insert acct;*/
        Account acct = TestDataFactory.createAccount(true);
        

        Task tsk = new Task(
            whatId = acct.id,
            subject = 'Test Task',
            activityDate = Date.today()
        );

        insert tsk;

        List<Map<String, Object>> relatedFiles = null;

        Test.setMock( HttpCalloutMock.class, new CF_HttpCalloutMock() );

        Test.startTest();

        relatedFiles = CF_ChildFilesController.getRelatedFiles( 'Tasks', 'LookedUpFromActivity', 'AccountId', acct.id, 'FILES_AND_NOTES', '' );
        System.assertEquals( 0, relatedFiles.size() );

        ContentVersion newFile1 = new ContentVersion(
            title = 'Test File',
            pathOnClient = 'Test File.txt',
            versionData = Blob.valueOf( 'Test' ),
            firstPublishLocationId = tsk.id
        );

        ContentVersion newFile2 = new ContentVersion(
            title = 'Test File 2',
            pathOnClient = 'Test File 2.txt',
            versionData = Blob.valueOf( 'Test 2' ),
            firstPublishLocationId = tsk.id
        );

        insert new ContentVersion[] { newFile1, newFile2 };

        relatedFiles = CF_ChildFilesController.getRelatedFiles( 'Tasks', 'LookedUpFromActivity', 'AccountId', acct.id, 'FILES_AND_NOTES', '' );
        System.assertEquals( 2, relatedFiles.size() );

        Test.stopTest();

    }

    @IsTest
    static void test_get_related_files() {

       /* Account acct = new Account(
            name = 'Test Account'
        );

        insert acct;*/
        Account acct = TestDataFactory.createAccount(true);

        Contact cont = new Contact(
            firstName = 'Test',
            lastName = 'Contact',
            accountId = acct.id
        );

        insert cont;

        List<Map<String, Object>> relatedFiles = null;

        Test.setMock( HttpCalloutMock.class, new CF_HttpCalloutMock() );

        Test.startTest();

        relatedFiles = CF_ChildFilesController.getRelatedFiles( 'Contacts', 'Contact', 'AccountId', acct.id, 'FILES_AND_NOTES', '' );
        System.assertEquals( 0, relatedFiles.size() );

        ContentVersion newFile1 = new ContentVersion(
            title = 'Test File',
            pathOnClient = 'Test File.txt',
            versionData = Blob.valueOf( 'Test' ),
            firstPublishLocationId = cont.id
        );

        ContentVersion newFile2 = new ContentVersion(
            title = 'Test Note',
            pathOnClient = 'Test Note.snote',
            versionData = Blob.valueOf( 'Test 2' ),
            firstPublishLocationId = cont.id
        );

        insert new ContentVersion[] { newFile1, newFile2 };

        relatedFiles = CF_ChildFilesController.getRelatedFiles( 'Contacts', 'Contact', 'AccountId', acct.id, 'FILES_AND_NOTES', '' );
        System.assertEquals( 2, relatedFiles.size() );

        relatedFiles = CF_ChildFilesController.getRelatedFiles( 'Contacts', 'Contact', 'AccountId', acct.id, 'FILES_ONLY', '' );
        System.assertEquals( 1, relatedFiles.size() );
        System.assertEquals( newFile1.Id, relatedFiles[0].get( 'Id' ) );

        relatedFiles = CF_ChildFilesController.getRelatedFiles( 'Contacts', 'Contact', 'AccountId', acct.id, 'NOTES_ONLY', '' );
        System.assertEquals( 1, relatedFiles.size() );
        System.assertEquals( newFile2.Id, relatedFiles[0].get( 'Id' ) );

        Test.stopTest();

    }

  /*  @IsTest
    static void test_get_object_describe() {

        Test.setMock( HttpCalloutMock.class, new CF_HttpCalloutMock() );

        Test.startTest();

        Map<String, Object> objectDescribeMap = CF_ChildFilesController.getObjectDescribe( 'Account' );

        Test.stopTest();

        DescribeSObjectResult objectDescribe = Account.sobjectType.getDescribe();

        System.assertEquals( objectDescribeMap.get( 'name' ), objectDescribe.getName() );

    }*/

    @IsTest
    static void test_get_default_related_files_columns() {

        Test.setMock( HttpCalloutMock.class, new CF_HttpCalloutMock() );

        Test.startTest();

        List<Map<String, Object>> defaultColumns = CF_ChildFilesController.getDefaultRelatedFilesColumns();

        Test.stopTest();

        System.assertEquals( 4, defaultColumns.size() );
        System.assertEquals( 'Title', defaultColumns[0].get( 'label' ) );
        System.assertEquals( 'Owner', defaultColumns[1].get( 'label' ) );
        System.assertEquals( 'Last Modified', defaultColumns[2].get( 'label' ) );
        System.assertEquals( 'Size', defaultColumns[3].get( 'label' ) );

    }

    @IsTest
    static void test_queryCustomFieldMetadata_success() {

        Test.setMock( HttpCalloutMock.class, new CF_HttpCalloutMock() );

        Test.startTest();

        CF_ChildFilesController.CustomFieldMetadata metadata = CF_ChildFilesController.queryCustomFieldMetadata( 'Anything', 'Anything' );

        Test.stopTest();

        System.assertEquals( 'Test Relationship Label', metadata.relationshipLabel );

    }

    @IsTest
    static void test_queryCustomFieldMetadata_error() {

        Test.setMock( HttpCalloutMock.class, new CF_HttpCalloutMock() );

        Test.startTest();

        CF_ChildFilesController.CustomFieldMetadata metadata = CF_ChildFilesController.queryCustomFieldMetadata( 'ERROR', 'ERROR' );

        Test.stopTest();

        System.assertEquals( null, metadata );

    }

    @IsTest
    static void test_constructor_for_visualforce_case() {

        /*Account acct = new Account(
            name = 'Test Account'
        );

        insert acct;*/
        
        Account acct = TestDataFactory.createAccount(true);


        Case cs = new Case(
            accountId = acct.id,
            subject = 'Test Case'
        );

        insert cs;

        Test.setMock( HttpCalloutMock.class, new CF_HttpCalloutMock() );

        Test.startTest();

        Test.setCurrentPage( Page.CF_ChildFilesPage );

        ApexPages.currentPage().getParameters().put( 'id', cs.id );

        CF_ChildFilesController controller = new CF_ChildFilesController();

        Test.stopTest();

        System.assertEquals( cs.id, controller.recordId );
        System.assertEquals( 'Case', controller.sObjectName );

    }

    @IsTest
    static void test_get_org_namespace() {

        Test.setMock( HttpCalloutMock.class, new CF_HttpCalloutMock() );

        Test.startTest();

        CF_ChildFilesController controller = new CF_ChildFilesController();

       // String orgNamespace = controller.getOrgNamespace();

        Test.stopTest();

       // System.assertEquals( CF_NamespaceUtils.NAMESPACE, orgNamespace );

    }

}
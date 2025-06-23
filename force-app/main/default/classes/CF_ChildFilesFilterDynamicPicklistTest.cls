@IsTest
private class CF_ChildFilesFilterDynamicPicklistTest {

    @IsTest
    static void test_dynamic_picklist() {

        Test.startTest();

        CF_ChildFilesFilterDynamicPicklist picklist = new CF_ChildFilesFilterDynamicPicklist();

        System.assertEquals( 3, picklist.getValues().size() );

        VisualEditor.DataRow defaultValue = null;
        for ( VisualEditor.DataRow row : picklist.getValues().getDataRows() ) {
            if ( row.isSelected() ) {
                defaultValue = row;
            }
        }

        System.assertNotEquals( null, defaultValue );
        System.assertEquals( defaultValue.getLabel(), picklist.getDefaultValue().getLabel() );
        System.assertEquals( defaultValue.getValue(), picklist.getDefaultValue().getValue() );

        Test.stopTest();

    }

}
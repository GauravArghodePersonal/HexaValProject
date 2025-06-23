@IsTest
private class CF_ChildFilesFieldSetDynamicPicklistTest {

    @IsTest
    static void test_dynamic_picklist() {

        Map<String, FieldSet> fsMap = SObjectType.ContentVersion.fieldSets.getMap();

        Test.startTest();

        CF_ChildFilesFieldSetDynamicPicklist picklist = new CF_ChildFilesFieldSetDynamicPicklist();

        // an entry for each field set plus the "default" option
        System.assertEquals( fsMap.size() + 1, picklist.getValues().size() );

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
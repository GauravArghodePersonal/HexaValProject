public with sharing class CF_ChildFilesFieldSetDynamicPicklist extends VisualEditor.DynamicPickList {

    public override VisualEditor.DataRow getDefaultValue() {

        VisualEditor.DataRow defaultValue = null;

        for ( VisualEditor.DataRow row : getValues().getDataRows() ) {
            if ( row.isSelected() ) {
                defaultValue = row;
            }
        }

        return defaultValue;
    }

    public override VisualEditor.DynamicPickListRows getValues() {

        VisualEditor.DynamicPickListRows rows = new VisualEditor.DynamicPickListRows();

        Map<String, FieldSet> fsMap = SObjectType.ContentVersion.fieldSets.getMap();

        rows.addRow( new VisualEditor.DataRow( 'Default', '', true ) );

        for ( String fsName : fsMap.keySet() ) {
            FieldSet fs = fsMap.get( fsName );
            rows.addRow( new VisualEditor.DataRow( fs.getLabel(), fs.getName() ) );
        }

        return rows;
    }

}
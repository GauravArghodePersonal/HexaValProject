public with sharing class CF_ChildFilesFilterDynamicPicklist extends VisualEditor.DynamicPickList {

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

        rows.addRow( new VisualEditor.DataRow( 'Files Only', 'FILES_ONLY' ) );
        rows.addRow( new VisualEditor.DataRow( 'Notes Only', 'NOTES_ONLY' ) );
        rows.addRow( new VisualEditor.DataRow( 'Files and Notes', 'FILES_AND_NOTES', true ) );

        return rows;
    }

}
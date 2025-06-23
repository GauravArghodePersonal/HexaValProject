public with sharing class AdvancedDataTableColumn {
    
    public static final String SORT_ASCENDING = 'ASC';
    public static final String SORT_DESCENDING = 'DESC';
    
    public AdvancedDataTableColumn(Advanced_Data_Table_Column__c rec) {
        this.rec = rec;
        this.sorted = false;
        this.sortDirection = ''; 
    }
    
    public Advanced_Data_Table_Column__c rec {get;set;}
    
    public Boolean sorted {get;set;}
    public String sortDirection {get;set;}
    
    public Boolean getSortedAscending() {
        Boolean result = false;
        result = (sorted && (sortDirection == SORT_ASCENDING));
        System.debug('*** DataTableColumn getSortedAscending - ' + rec.Full_Field_Name__c + ' - sorted = ' + sorted + ' - sortDirection = ' + sortDirection + ' - result = ' + result );
        return result;
    }
    
    public Boolean getSortedDescending() {
        Boolean result = false;
        result = (sorted && (sortDirection == SORT_DESCENDING));
        System.debug('*** DataTableColumn getSortedDescending - ' + rec.Full_Field_Name__c + ' - sorted = ' + sorted + ' - sortDirection = ' + sortDirection + ' - result = ' + result );
        return result;
    }

    public Boolean getDisplayAsEditable() {
        Boolean result = false;
        result = (rec.Editable__c);
        return result;
    }
    
    public Boolean getDisplayAsText() {
        Boolean result = false;
        result = (rec.Field_Type__c == 'Text');
        return result;
    }
    
    public Boolean getDisplayAsNonEditableText() {
        Boolean result = false;
        result = (rec.Field_Type__c == 'Text' && !rec.Editable__c);
        return result;
    }
    
    public Boolean getDisplayAsEditableText() {
        Boolean result = false;
        result = (rec.Field_Type__c == 'Text' && rec.Editable__c);
        return result;
    }
    
    public Boolean getDisplayAsNonEditableField() {
        Boolean result = false;
        result = (rec.Field_Type__c == 'Field' && !rec.Editable__c);
        return result;
    }
    
    public Boolean getDisplayAsEditableField() {
        Boolean result = false;
        result = (rec.Field_Type__c == 'Field' && rec.Editable__c);
        return result;
    }
    
    public Boolean getDisplayAsField() {
        Boolean result = false;
        result = (rec.Field_Type__c == 'Field');
        return result;
    }
    
    public Boolean getDisplayAsResizableTextArea() {
        Boolean result = false;
        result = (rec.Field_Type__c == 'Resizable Text Area');
        return result;
    }
    
    public Boolean getDisplayAsEditableResizableTextArea() {
        Boolean result = false;
        result = (rec.Field_Type__c == 'Resizable Text Area' && !rec.Editable__c);
        return result;
    }
    
    public Boolean getDisplayAsNonEditableResizableTextArea() {
        Boolean result = false;
        result = (rec.Field_Type__c == 'Resizable Text Area' && rec.Editable__c);
        return result;
    }
    
    public Boolean getDisplayAsLink() {
        Boolean result = false;
        result = (rec.Field_Type__c == 'Link');
        return result;
    }
    
    public void enableSort(String direction) {
        sorted = true;
        sortDirection = direction;
        System.debug('*** Enabling Sort for ' + rec.Full_Field_Name__c + ' - ' + sortDirection);
    }

    public void disableSort() {
        sorted = false;
        sortDirection = '';
        System.debug('*** Disabling Sort for ' + rec.Full_Field_Name__c + ' - ' + sortDirection);
    }
    
    public void toggleDirection() {
        if (sortDirection == '' || sortDirection == SORT_DESCENDING) {
            sortDirection = SORT_ASCENDING;
        }
        else {
            sortDirection = SORT_DESCENDING;
        }
    }
}
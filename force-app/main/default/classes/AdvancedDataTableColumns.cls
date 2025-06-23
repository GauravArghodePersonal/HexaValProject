public with sharing class AdvancedDataTableColumns {
    
    public AdvancedDataTableColumns() {
        this.columns = new List<AdvancedDataTableColumn>();
    }
    
    public List<AdvancedDataTableColumn> columns {get;set;}
    
    
    public void add(AdvancedDataTableColumn column) {
        this.columns.add(column);
    }
    
    public void enableSort(String fullFieldName, String direction) {
        AdvancedDataTableColumn column = findDataTableColumn(fullFieldName);
        if (column != null) {column.enableSort(direction);}
    }
    
    public void disableSort(String fullFieldName) {
        AdvancedDataTableColumn column = findDataTableColumn(fullFieldName);
        if (column != null) {column.disableSort();}
    }
    
    public void toggleDirection(String fullFieldName) {
        AdvancedDataTableColumn column = findDataTableColumn(fullFieldName);
        if (column != null) {column.toggleDirection();}
    }

	public Boolean editable {
		get {
		Boolean result = false;
        for (AdvancedDataTableColumn item : this.columns) {
        	if (item.rec.Editable__c) {
        		result = true;
        		break;
        	}
        }	
        return result;	
		}
		set;
	}

    public AdvancedDataTableColumn findDataTableColumn(String fullFieldName) {
        AdvancedDataTableColumn result;
        for (AdvancedDataTableColumn item : this.columns) {
            if (item.rec.Full_Field_Name__c == fullFieldName) {
                System.debug('*** - findDataTableColumn - column found');
                result = item;break;
            }
        }
        if (result == null) {
            System.debug('*** - findDataTableColumn - column not found - |' + fullFieldName + '|');
        }
        return result;
    }
    
    public void disableAllSorts() {
        for (AdvancedDataTableColumn item : this.columns) {
            item.disableSort();
        }
    }
}
public with sharing class AdvancedDataTableCustomFilters {

    public AdvancedDataTableCustomFilters() {
        this.customFilters = new List<AdvancedDataTableCustomFilter>();
    }
    
    public List<AdvancedDataTableCustomFilter> customFilters {get;set;}
    
    
    public void add(AdvancedDataTableCustomFilter customFilter) {
        this.customFilters.add(customFilter);
    }
    
    public AdvancedDataTableCustomFilter findCustomFilter(String filterName) {
        AdvancedDataTableCustomFilter result;
        for (AdvancedDataTableCustomFilter item : this.customFilters) {
            if (item.rec.Name == filterName) {
                result = item;break;
            }
        }
        return result;
    }
}
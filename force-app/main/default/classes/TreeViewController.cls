public with sharing class TreeViewController {
	public TreeViewController() {
        selectable = false;
        selectNodeKeys = 'No value selected';
    }

    public Boolean selectable {get; set;}
    public String selectNodeKeys {get; set;}
    public String JsonData {get; set;}
    public String roleOrUserId {get; set;}
    public String filterText {get; set;}
    
    public String getJsonString() {
        return JsonData;
    }
}
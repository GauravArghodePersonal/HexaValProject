public with sharing class PriceBookEntryApprovalController {

    private static final String OBJECT_NAME = 'Price_Book_Entry__c';
    
    public class Price_Book_Entry {
        public Price_Book_Entry__c priceBookEntry {get; set;}
        public Boolean selected {get; set;}
        public String materialNumber {get; set;}
        public Price_Book_Entry(Price_Book_Entry__c p) {
            priceBookEntry = p;
            selected = false;
            materialNumber = String_Functions.removeLeadingZeros(p.Material_Sales_Data2__r.Material_Number__c);
        }
    }
    
    List<Price_Book_Entry> plist;
    List<Price_Book_Entry__c> slist;
    
    public String userComments {get; set;} 
    public Boolean allSelected {get; set;}
    
    private void init() {
        plist = new List<Price_Book_Entry>();
        slist = new List<Price_Book_Entry__c>();
        allSelected = false;
        userComments = '';
    } 
    
    public List<Price_Book_Entry> getPriceBookEntries() {
        Set<String> oids = Custom_Approval_Functions.getPendingApprovalObjectIds(OBJECT_NAME);
        if (oids != null) {
            init();
            for (Price_Book_Entry__c p : [select Id, Name, 
                                                 Floor_Price__c, Market_Price__c,
                                                 Material_Sales_Data2__r.Material_Number__c,
                                                 Material_Sales_Data2__r.Material_Desc__c
                                            from Price_Book_Entry__c
                                           where Id in :oids
                                         ]) {
                Price_Book_Entry pbe = new Price_Book_Entry(p);
                plist.add(pbe);
            }
        }
        return plist;
    }
    
    private Set<String> getSelectedObjectIds() {
        Set<String> ss = new Set<String>();
        for (Price_Book_Entry pbe : plist) {
            if (pbe.selected) {
                ss.add(pbe.priceBookEntry.id);
            }
        }
        return ss;
    }
    
    public PageReference approveSelectedList() {
        Set<String> oids = getSelectedObjectIds();
        Custom_Approval_Functions.approveObjects(oids, userComments);
        return null;
    }
    
    public PageReference rejectSelectedList() {
        if (userComments == null || userComments.trim().length() == 0) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                         'Reject Comments are required');
            ApexPages.addMessage(msg);
            return null;
        }
        Set<String> oids = getSelectedObjectIds();
        Custom_Approval_Functions.rejectObjects(oids, userComments);
        return null;
    }
    
}
@isTest
private class PriceBookMergeFunctions_Test {
	
	private static final String distChanCode = '10';
    private static final String divisionCode = '11';

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'PriceBookMergeFunctions : ' + s);
    }

    static testMethod void test01() {
    	List<Price_Book__c> pblist = [select Id 
    	                                from Price_Book__c 
    	                               where Dist_Channel_Code__c = :distChanCode
    	                                 and Division_Code__c = :divisionCode
    	                                 and Record_Status__c = 'Active'
    	                                 and Number_of_Materials_on_Price_Book__c < 200
    	                            order by Number_of_Materials_on_Price_Book__c limit 2];
        if (pblist == null || pblist.size() < 2) {return;}
        Set<String> pbIds = new Set<String>{pblist[0].Id, pblist[1].Id};
        pblist = PriceBookFunctions.getPriceBooks(pbIds);
        List<String> pbStats = new List<String>{'Active'};
        PriceBookMergeFunctions.getPriceBookIds(distChanCode, divisionCode, pbStats);
        Price_Book__c pb = PriceBookMergeFunctions.mergePriceBooks(pblist, 'New Test PriceBook');
        if(pb == null) {return;}
        String pid = pb.Id; 
        String q1 = PriceBookEntryFunctions.SELECT_QRY_1 + ' where Price_Book__c = :pid';
        List<Price_Book_Entry__c> alist = Database.query(q1);
        for (Price_Book_Entry__c e : alist) {
            debug(e + ' : ' + e.Price_Book_Entries_Scaled_Pricing__r);
            break;
        } 
    }
}
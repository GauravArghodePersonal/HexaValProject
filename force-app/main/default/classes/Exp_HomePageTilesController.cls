public class Exp_HomePageTilesController {
	
    @AuraEnabled(cacheable=true)
    public static TileWrapper getTileDetails() {
        TileWrapper wrapper = new TileWrapper();
        try{
            List<TileDetails> tiles = new List<TileDetails>();
            for(Exp_Configs__c tileObj: [SELECT ID, Name,
                                         Button_label__c, Button_link__c, Image_link__c, Content__c, Sub_Heading__c 
                                         FROM Exp_Configs__c
                                         WHERE RecordType.DeveloperName = 'Tiles' order by Order__c ASC])
            {
				TileDetails tile = new TileDetails();
                tile.tileLabel = tileObj.Button_label__c;
                tile.tileName = tileObj.Name;
                tile.tileLink = tileObj.Button_link__c;
                tile.tileImageUrl = tileObj.Image_link__c;
                tile.tileSubHeading = tileObj.Sub_Heading__c;
                tile.tileContent = tileObj.Content__c;
                tiles.add(tile);
            }
            
            if(tiles.isEmpty()){
                wrapper.status = 'Error';
            	wrapper.error.errorMessage = 'No data available';
            } else {
                wrapper.status = 'Success';
            	wrapper.tiles = tiles;
            }
        } catch(Exception ex) {
            wrapper.status = 'Error';
            wrapper.error.errorMessage = ex.getMessage();
        }
        return wrapper;
    }
    
    public class TileWrapper{
        @AuraEnabled public String status{ get; set; }
        @AuraEnabled public List<TileDetails> tiles{ get; set; }
        @AuraEnabled public ErrorDetails error{ get; set; }
        //@AuraEnabled public String tileLabel{ get; set; }
        public TileWrapper() {
            tiles = new List<TileDetails>();
            error = new ErrorDetails();
        }
    }
    public class TileDetails{
        @AuraEnabled public String tileLabel{ get; set; }
        @AuraEnabled public String tileName{ get; set; }
        @AuraEnabled public String tileLink{ get; set; }
        @AuraEnabled public String tileImage{ get; set; }
        @AuraEnabled public String tileImageUrl{ get; set; }
        @AuraEnabled public String tileContent{ get; set; }
        @AuraEnabled public String tileSubHeading{ get; set; }
        //@AuraEnabled public String tileLabel{ get; set; }
        //@AuraEnabled public String tileLabel{ get; set; }
    }
    
    public class ErrorDetails{
        @AuraEnabled public String errorMessage{ get; set; }
    }
}
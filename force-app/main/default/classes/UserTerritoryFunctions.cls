public class UserTerritoryFunctions {
    /*
     * 
     */
    public static List<User> updatedUsers = new List<User>();
 
    public Static Map<Id,List<Id>> getUserTerritoryIds(List<Id> userIds) {
        Map<Id,List<Id>> userTerrAssociations = new Map<Id,List<Id>>();
        List<Id> territoryIds = new List<Id>();
       
    UserTerritory2Association[] userTerritory2Associations = [SELECT UserId,Territory2Id FROM UserTerritory2Association where IsActive=true and UserId IN :userIds];
    
        for (UserTerritory2Association userTerritory2Association : userTerritory2Associations){
            if(userTerrAssociations.get(userTerritory2Association.UserId)!= null){
            territoryIds = userTerrAssociations.get(userTerritory2Association.UserId);
            territoryIds.add(userTerritory2Association.Territory2Id);
		
            }else{
             territoryIds.add(userTerritory2Association.Territory2Id);
            }
	         userTerrAssociations.put(userTerritory2Association.UserId,territoryIds);
        }
        return userTerrAssociations;
    }

    
}
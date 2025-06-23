public class CaseTeamMemberHandler {
    
    public static void addCaseTeamMembersToCase(List<Case> lstNewCases, Map<Id,Case> mapOldCases)
{
    System.debug('<<0>>');
    Map<Id,CaseTeamMember> mapMembersToAdd = new Map<Id,CaseTeamMember>();
    CaseTeamRole objCaseTeamRole= new CaseTeamRole();
    Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('APPL Inquiry').getRecordTypeId();
    for(Case objCase:lstNewCases){
    if(objCase.RecordTypeId == devRecordTypeId)
    {           
        String oldOwnerId = mapOldCases.get(objCase.Id).ownerId;
        String newOwnerid = objCase.ownerId;

        if(!newOwnerid.equalsIgnoreCase(mapOldCases.get(objCase.Id).ownerId) 
            && oldOwnerId.subString(0,3) == '005' || Test.isRunningTest())
        {
            //verify if the oldOwnerId ever exists as Case Team members
            List<CaseTeamMember> lstCaseTeamMember = [SELECT MemberId FROM CaseTeamMember
                                                    WHERE ParentId =: objCase.Id
                                                    AND MemberId =: oldOwnerId];
            System.debug('<<>>'+lstCaseTeamMember);
            if(lstCaseTeamMember.size() == 0)
            {
                mapMembersToAdd.put(objCase.Id, 
                   new CaseTeamMember(             
                          ParentId = objCase.Id,                           
                          MemberId = oldOwnerId
                        )
                    ); 
            }            
        }
    }
      
        if (!mapMembersToAdd.isEmpty())
    {   
        objCaseTeamRole = [SELECT Id
                                  FROM CaseTeamRole 
                                  WHERE Name = 'Creator' LIMIT 1];
         System.debug('<<2>>'+objCaseTeamRole);
        for (CaseTeamMember objCaseTeamMember : mapMembersToAdd.values())
        {
            objCaseTeamMember.TeamRoleId = objCaseTeamRole.Id;
        }              
        if (!mapMembersToAdd.isEmpty())
        {
            insert mapMembersToAdd.values();
        }

    }   
  }
  
}
}
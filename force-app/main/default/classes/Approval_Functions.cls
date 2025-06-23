public class Approval_Functions {

    public static Map<ID, String> getComments(Set<ID> ids){
       List<ProcessInstance> PIs = new list<ProcessInstance>();
       Set<ID> PISet = new set<ID>();
       List<User> users = new list<user>();
       Set<ID> UserIDs = new set<ID>();
       List<ProcessInstanceStep> PISteps = new list<ProcessInstanceStep>();
       Map<ID, String> CommentsMap = new Map<ID, String>();
       Map<ID, ID> ObjecttoPI = new Map<ID, ID>();
       Map<ID, String> UserMap = new map<ID, String>();
       Map<ID, String> returnmap = new map<ID, String>();

       PIs = [select id, TargetObjectId from ProcessInstance where TargetObjectId in :IDs];

       for(ProcessInstance PI:PIs){
          PISet.add(PI.id);
          ObjectToPI.put(PI.TargetObjectID, PI.id);
       }

       PISteps = [select id, comments, OriginalActorID, ActorID, ProcessInstanceID from ProcessinstanceStep where ProcessInstanceID in :PISet];

       for(ProcessInstanceStep PIstep:PISteps){
          userIDs.add(PIstep.ActorID);
          userIDs.add(PIstep.OriginalActorID);
       }

       users = [select id, name from user where id in :userids];

       for(user u:users){
         userMap.put(u.id, u.name);
       }

     for(ProcessInstanceStep PIstep:PISteps){

        if(CommentsMap.containskey(PIStep.ProcessInstanceID)){

               String s = CommentsMap.get(PIStep.ProcessInstanceID);
               if(PIStep.Comments != null){
                  s = s + '\n' + usermap.get(PIStep.ActorID) + ': ' + PIStep.Comments;
               }
               else {
                  s = s + '\n' + usermap.get(PIStep.ActorID) + ': No Comments';
               }     
               CommentsMap.put(PIStep.ProcessInstanceID, s);    
            }
       else{
               if(PIStep.Comments != null){
               CommentsMap.put(PIStep.ProcessInstanceID, usermap.get(PIStep.ActorID) + ': ' + PIStep.Comments);
               }
               else{
               CommentsMap.put(PIStep.ProcessInstanceID, usermap.get(PIStep.ActorID) + ': No Comments');
               }    
       }
    }

      for(ID i:IDs){
         for(ProcessInstance PI:PIs){
            if(i == PI.TargetObjectID){
               if(CommentsMap.containskey(PI.ID)){
                  if(returnmap.containskey(i)){
                     String s = returnmap.get(i);
                     s += '\n' + CommentsMap.get(PI.ID);
                     returnmap.put(i, s);
                  }
                  else{                
                    returnmap.put(i, CommentsMap.get(PI.ID));
                  }
            }
           }
          }
      }
   return returnmap;
   }
}
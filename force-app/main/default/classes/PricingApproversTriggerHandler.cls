public class PricingApproversTriggerHandler{
public static void afterUpdateTrigger(List<Pricing__c> newlist,Map<id,Pricing__c> oldmapValue){
     if(checkRecursive.runOnce()){         
         UpdateApprover(newlist);     
         validateIsfileExist(newlist,oldmapValue);
         }
     }      
     public static void beforeInsertTrigger (List<Pricing__c> newlist){        
     }
     
     public static void afterInsertTrigger (List<Pricing__c> newlist){
         UpdateApprover(newlist);
     }
     
     
   public static void UpdateApprover(List<Pricing__c> pnewlist){
     List<Pricing__c> PricingList= New List<Pricing__c>();
      Boolean flag;
       List<Pricing_Approvers__c> appOfficeMap = New List<Pricing_Approvers__c>();
       appOfficeMap =[select id,Office_Manager_Email__c,Active_Office_Manager__c,Office_Manager__c,Office_Manager_Id__c,SAP_Sales_Office__c from Pricing_Approvers__c];
        PricingList= [select id,Flag_Check__c,GSP_Check__c,Approver_Email__c,Total_Equipment_Cost__c,Pricing_Approver__c,Account__r.SAP_Sales_Office__c from Pricing__c where id in :pnewlist];
        
            For(Pricing__c pricing:PricingList){
                flag=false;
                //Update Office Manager
                For(Pricing_Approvers__c userlist:appOfficeMap){
                    //String groupName;
                   //groupName=pricing.Account__r.SAP_SalesDistrict__c+pricing.Account__r.SAP_Sales_Office__c+pricing.Account__r.SAP_SalesGroup__c;
                        if(userlist.SAP_Sales_Office__c == pricing.Account__r.SAP_Sales_Office__c && userlist.Active_Office_Manager__c==True  && UserInfo.getUserId()!=userlist.Office_Manager_Id__c&& flag==false){
                        pricing.Pricing_Approver__c=userlist.Office_Manager_Id__c;
                        pricing.Approver_Email__c= userlist.Office_Manager_Email__c;
                        system.debug('testing'+UserInfo.getUserId());
                        system.debug('<><1><>'+pricing.Pricing_Approver__c);
                        system.debug('<><2><>'+pricing.Approver_Email__c);    
                        flag=true;
                    }
                    
                    }
               /* For(Pricing_Approvers__c userlist:appOfficeMap  ){
                if(pricing.P_SAP_Sales_Office__c=='Not equal' && pricing.P_SAP_Sales_Office__c==userlist.SAP_Sales_Office__c){
                        pricing.Pricing_Approver__c=userlist.Office_Manager_Id__c;
                        pricing.Approver_Email__c= userlist.Office_Manager_Email__c;
                        }
                } */              
                      
            }
       Upsert PricingList;
     }
    
    public static void validateIsfileExist(List<Pricing__c> pnewlist,Map<id,Pricing__c> oldmapValue){
        for(Pricing__c price : pnewlist){
          Pricing__c OldPrice = oldmapValue.get(price.id);
            if(price.Pricing_Type__c == 'Equipment Pricing' && OldPrice.Status__c =='Draft' && price.Status__c == 'Submitted'){
                Integer contdocsize   = [SELECT count() FROM ContentDocumentLink where LinkedEntityId =: price.Id];
                if(contdocsize ==0){
                   price.addError(' Please attach Equipment Order Form and/or Customer PO before submitting for approval');
                }
                   
            }
        } 
    }
    
}
public class VdpMultiXls{
    
    public list<ValueAdvantage__c> multipdfList {get;set;}
    public VdpMultiXls(){
        multipdfList = New list<ValueAdvantage__c>();
        String vdpId  = apexpages.currentpage().getparameters().get('id');
        List<String> idList = vdpId.split(',');
        system.debug('<<<vdpId>>'+vdpId);
        system.debug('<<<idList>>'+idList);
        multipdfList = [select id,Name,Check__c,Customer__r.Name,Customer__r.SAP_City__c,Opportunity__r.Name,Project_Status__c,/*Savings_Type__c,*/Problem_Statement__c,/*Platform_Product_Family__c,*/Opportunity__r.SBU_Multi__c,Customer__r.SAP_Partner_Functions__c,Customer__r.HQ_Account__r.Name,/*Customer_Value_Type__c,*/Solenis_Recommendation__c,Learnings__c,Value_Proposition__c,Actual_Date_Completed__c,/*Actual_Delivered_Savings__c,*/Total_Cost_Savings__c,Value_Focus_Area__c,Customer_Team__c,Actual_Date_Approved__c,Customer_Value_Type_Cost_Savings__c,Customer_Value_Type_Cost_Avoidance__c from ValueAdvantage__c where id IN :idList];
       // system.debug('<><><>'+multipdfList[3].Learnings__c);
        for(ValueAdvantage__c va:multipdfList){
             If(va.Learnings__c!=null){
            va.Learnings__c=va.Learnings__c.replace('<br>',' ');
            }
        }
        multipdfList.sort();
    }
    
}
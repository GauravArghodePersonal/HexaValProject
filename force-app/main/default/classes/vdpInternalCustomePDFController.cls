Public Class vdpInternalCustomePDFController{
   
    Public Id vdpid;
    public vdpInternalCustomePDFController(ApexPages.StandardController controller) {
        vdpid = apexpages.currentpage().getparameters().get('id');
         splitLearnings();
         

    }

    public List<ValueAdvantage__c> VpdList{get;set;}
    //Public String Learnings{get;set;}
    
    Public void splitLearnings(){
        VpdList = New List<ValueAdvantage__c>();
        VpdList=[select id,Name,Customer__r.Name,Customer__r.SAP_City__c,Opportunity__r.Name,Project_Status__c,Problem_Statement__c,Opportunity__r.SBU_Multi__c,Customer__r.SAP_Partner_Functions__c,Customer__r.HQ_Account__r.Name,Solenis_Recommendation__c,Learnings__c,Value_Proposition__c,Actual_Date_Completed__c,Total_Cost_Savings__c,Value_Focus_Area__c,Customer_Team__c,Actual_Date_Approved__c from ValueAdvantage__c where id=:vdpid];
        If(VpdList[0].Learnings__c!=null){
        VpdList[0].Learnings__c='<ul style="font-size: 12px"><li>'+VpdList[0].Learnings__c.replace('<br>','</li><li>')+'</li></ul>';
        VpdList[0].Learnings__c=VpdList[0].Learnings__c.replace('</img>','</img>-->');
        VpdList[0].Learnings__c=VpdList[0].Learnings__c.replace('<img','<!--<img');
        system.debug('<<VpdList>>>'+VpdList[0].Learnings__c);
        }
        
        if(VpdList[0].Name!=Null){
            VpdList[0].Name=VpdList[0].name.replaceAll('#', '');
        }
        
    }
}
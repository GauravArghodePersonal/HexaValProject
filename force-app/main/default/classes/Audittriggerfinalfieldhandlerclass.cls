public class Audittriggerfinalfieldhandlerclass {
    
    public static void insertrecord(List<Audit_Detail__c> auditList){
        for (Audit_Detail__c obj : auditList) {
           
            Boolean checkBox = obj.Check_box_if_account_experienced__c;
            Decimal scoreP = obj.Score_P__c;
            Decimal scoreQ = obj.Score_Q__c;
            Decimal scoreR = obj.Score_R__c;
            Decimal scoreV = obj.Score_V__c;
            Boolean Checkbox1 = obj.Change_In_Key_Decision_Makers__c;
            Boolean Checkbox2 = obj.Did_we_request_price_inc__c;
            Boolean Checkbox3 = obj.Change_in_rep__c;
            Boolean Checkbox4 = obj.change_to_bad_results__c;
            Boolean Checkbox5 = obj.Have_had_no_dm__c;
            Boolean Checkbox6 = obj.Cust_has_signif__c;
            Boolean Checkbox7 = obj.Rfq_or_bid_or_tender__c;
            Boolean Checkbox8 = obj.Unable_to_complete_ROI__c;
            Boolean Checkbox9 = obj.Have_we_lost_any_app__c;
            Boolean Checkbox10 = obj.Do_we_have_less_then_75__c;
            Boolean Checkbox11 = obj.Are_we_without_a_formal__c;
            Boolean Checkbox12= obj.Is_there_increased_competition_in_LA__c;
            
            Decimal formulaValue = 0;
            if (checkBox) {
                formulaValue = 20;
                obj.Final_Calulated_Score__c = formulaValue;
            } else {
                formulaValue = (scoreP + scoreQ + scoreR + scoreV) / 4;
                
            Decimal multiplier = 1 - (
                (Checkbox1 ? 0.07 : 0) +
                (Checkbox2 ? 0.07 : 0) +
                (Checkbox3 ? 0.07 : 0) +
                (Checkbox4 ? 0.07 : 0) +
                (Checkbox5 ? 0.07 : 0) +
                (Checkbox6 ? 0.07 : 0) +
                (Checkbox7 ? 0.07 : 0) +
                (Checkbox8 ? 0.07 : 0) +
                (Checkbox9 ? 0.07 : 0) +
                (Checkbox10 ? 0.07 : 0) +
                (Checkbox11 ? 0.07 : 0) +
                (Checkbox12 ? 0.07 : 0));
                        
             Decimal result = formulaValue * multiplier;
             obj.Final_Calulated_Score__c = result;
            }             
        }  
    }
}
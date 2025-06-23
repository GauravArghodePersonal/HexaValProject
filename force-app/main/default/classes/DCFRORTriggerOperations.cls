/*****************************************************************
* Class Name     : DCFRORTriggerOperations                            *
* Author         : Donald JP                                  *
* Created Date   : 27-May-2021                                   *
* Modified Date  : 24-Sep-2021                                   *
* Description    : This is to handle DCFROR trigger operations	 *
*****************************************************************/

public class DCFRORTriggerOperations {
    
    public static void processBeforeInsert(List<DCFROR__c> dlist) {
        
        system.debug('Isinsert trigger');  
        set<Id> parentAccIds=new set<Id>();
        for(DCFROR__c dc:dlist)
        {
            parentAccIds.add(dc.Geer__c);
        }
        //get all parent Account currency
        Map<Id,Geer__c> accDetailById=new Map<Id,Geer__c>();
        accDetailById.putAll([select id,CurrencyIsoCode,Account_Region__c,Target_delivery_date__c from Geer__c where id IN :parentAccIds]);
        
        for(DCFROR__c gr:dlist)
        {
            system.debug('Isinsert trigger 1111'+accDetailById.get(gr.Geer__c).CurrencyIsoCode);  
            
            gr.CurrencyIsoCode=accDetailById.get(gr.Geer__c).CurrencyIsoCode;
            gr.Start_date__c=accDetailById.get(gr.Geer__c).Target_delivery_date__c;
            if(accDetailById.get(gr.Geer__c).Account_Region__c=='EMEA')
            {
                //gr.Project_Management_AdderPercent__c=16.8;
                gr.Project_Management_AdderPercent__c = DCFROR_Project_Management_AdderPercent__c.getInstance('EMEA').AdderPercent__c;
            }
            
            else if(accDetailById.get(gr.Geer__c).Account_Region__c=='AP')
            {
                //gr.Project_Management_AdderPercent__c=10;
                gr.Project_Management_AdderPercent__c = DCFROR_Project_Management_AdderPercent__c.getInstance('AP').AdderPercent__c;
            }
            else if(accDetailById.get(gr.Geer__c).Account_Region__c=='LA')
            {
                //gr.Project_Management_AdderPercent__c=12;
                gr.Project_Management_AdderPercent__c = DCFROR_Project_Management_AdderPercent__c.getInstance('LA').AdderPercent__c;
            }
            else if(accDetailById.get(gr.Geer__c).Account_Region__c=='NA')
            {
                //gr.Project_Management_AdderPercent__c=13.3;
                gr.Project_Management_AdderPercent__c = DCFROR_Project_Management_AdderPercent__c.getInstance('NA').AdderPercent__c;
            }
        }
        
    }
    
    public static void processAfterInsert(List<DCFROR__c> capexEvaluationLst){
        List<String> currencyCodeLst = new List<String>();
        Map<Id,GEER__c> geerRecordMap = new Map<Id,GEER__c>();
        for(DCFROR__c dcfrorObj: capexEvaluationLst){
            currencyCodeLst.add(dcfrorObj.CurrencyIsoCode);
        }
        
        if(currencyCodeLst.size() > 0){
            updateGEERExchangeRate(currencyCodeLst, capexEvaluationLst, geerRecordMap);
        }
        // Update Est Revenue & Est Gross Profit Generated
        updateEstRevenueAndGrossProfitOnGEER(capexEvaluationLst, geerRecordMap);
        
        if(!geerRecordMap.isEmpty()) {
            update geerRecordMap.values();
        }
    }
    
    public static void processBeforeUpdate(Map<Id,DCFROR__c> newMap, Map<Id,DCFROR__c> oldMap){
        List<Product_DCFROR__c> productCapexLst = [Select Id,DCFROR__c from Product_DCFROR__c WHERE DCFROR__c IN:newMap.keySet()];
        Map<Id,List<Product_DCFROR__c>> capexEvaluationMap = new Map<Id,List<Product_DCFROR__c>>();
        for(Product_DCFROR__c productCapexObj: productCapexLst){
            if(capexEvaluationMap != null && capexEvaluationMap.containsKey(productCapexObj.DCFROR__c)){
                capexEvaluationMap.get(productCapexObj.DCFROR__c).add(productCapexObj);
            }else{
                capexEvaluationMap.put(productCapexObj.DCFROR__c, new List<Product_DCFROR__c>{productCapexObj});
            }
        }
        
        List<CAPEX__c> capexLst = [Select Id,DCFROR__c from CAPEX__c WHERE DCFROR__c IN:newMap.keySet()];
        Map<Id,List<CAPEX__c>> capexMap = new Map<Id,List<CAPEX__c>>();
        for(CAPEX__c capexObj: capexLst){
            if(capexMap != null && capexMap.containsKey(capexObj.DCFROR__c)){
                capexMap.get(capexObj.DCFROR__c).add(capexObj);
            }else{
                capexMap.put(capexObj.DCFROR__c, new List<CAPEX__c>{capexObj});
            }
        }
        
        for(String capexEvaluationObj: newMap.keySet()){
            if(newMap.get(capexEvaluationObj).CurrencyIsoCode != oldMap.get(capexEvaluationObj).CurrencyIsoCode && 
               ((capexEvaluationMap.containsKey(capexEvaluationObj) && capexEvaluationMap.get(capexEvaluationObj).size() > 0) || 
               (capexMap.containsKey(capexEvaluationObj) && capexMap.get(capexEvaluationObj).size() > 0))){
                newMap.get(capexEvaluationObj).addError('Currency cannot be changed after CAPEX/Product creation. If the currency change is required, please delete the created CAPEX/Product records, change the currency and recreate the CAPEX/Product records.');
            }
        }
    }
    
    public static void processAfterUpdate(List<DCFROR__c> capexEvaluationLst, Map<Id,DCFROR__c> newMap, Map<Id,DCFROR__c> oldMap){
        List<DCFROR__c> currencyUpdateLst = new List<DCFROR__c>();
        List<DCFROR__c> estValuesUpdateLst = new List<DCFROR__c>();
        List<String> currencyCodeLst = new List<String>();
        Map<Id,GEER__c> geerRecordMap = new Map<Id,GEER__c>();
        for(DCFROR__c dcfrorObj: capexEvaluationLst){
            if(newMap.get(dcfrorObj.Id).CurrencyIsoCode != oldMap.get(dcfrorObj.Id).CurrencyIsoCode){
                currencyCodeLst.add(dcfrorObj.CurrencyIsoCode);
                currencyUpdateLst.add(dcfrorObj);
            }
            
            // NET TOTAL-Actual Chemical Revenue
            Boolean isNetTotalActChemicalRevUpdated = newMap.get(dcfrorObj.Id).NET_TOTAL_Actual_Chemical_Revenue__c != oldMap.get(dcfrorObj.Id).NET_TOTAL_Actual_Chemical_Revenue__c;
            
            // NET TOTAL GP @ Sell Price
            Boolean isNetTotalGPSellPriceUpdated = newMap.get(dcfrorObj.Id).NetTotal_GP_Sell_Price__c != oldMap.get(dcfrorObj.Id).NetTotal_GP_Sell_Price__c;
                
            // Lease / Contract Fee (Annual Charge)
            Boolean isLeaseAnnualFeeUpdated = newMap.get(dcfrorObj.Id).Lease_Contract_Fee_Annual_Charge__c != oldMap.get(dcfrorObj.Id).Lease_Contract_Fee_Annual_Charge__c;
            
            if(isNetTotalActChemicalRevUpdated || isNetTotalGPSellPriceUpdated || isLeaseAnnualFeeUpdated) {
                estValuesUpdateLst.add(dcfrorObj);
            }
        }
        
        if(currencyCodeLst.size() > 0 && currencyUpdateLst.size() > 0){
            updateGEERExchangeRate(currencyCodeLst, currencyUpdateLst, geerRecordMap);
        }
        
        // Update Est Revenue & Est Gross Profit Generated
        if(!estValuesUpdateLst.isEmpty()) {
       		updateEstRevenueAndGrossProfitOnGEER(estValuesUpdateLst, geerRecordMap);
    	}
        
        
        if(!geerRecordMap.isEmpty()) {
            update geerRecordMap.values();
        }
    }
    
    private static void updateGEERExchangeRate(List<String> currencyCodeLst, List<DCFROR__c> capexEvaluationLst, Map<Id,GEER__c> geerRecordMap){
        Map<String,Decimal> conversionRatesMap = updateConversionRate(currencyCodeLst);
        Set<String> geerIds = new Set<String>();
        for(DCFROR__c dcfrorObj: capexEvaluationLst){
            geerIds.add(dcfrorObj.GEER__c);
            geerRecordMap.put(dcfrorObj.GEER__c, new GEER__c(Id=dcfrorObj.GEER__c, CurrencyIsoCode = dcfrorObj.CurrencyIsoCode,
                                                Exchange_Rate__c = (1/conversionRatesMap.get(dcfrorObj.CurrencyIsoCode)).setScale(10)));
        }
        
        updateCurrencyISOCodeInEQ(capexEvaluationLst, geerIds);
    }
    
    public static Map<String,Decimal> updateConversionRate(List<String> currencyCodes){
        Map<String,Decimal> conversionRatesMap = new Map<String,Decimal>();
        for(CurrencyType ct:[SELECT ConversionRate,IsoCode FROM CurrencyType where IsoCode IN:currencyCodes])
        {
            conversionRatesMap.put(ct.IsoCode,ct.ConversionRate);
        }
        return conversionRatesMap;
    }
    
    public static void updateCurrencyISOCodeInEQ(List<DCFROR__c> capexEvaluationLst, Set<String> geerIds){
        Map<String,Set<String>> eqMap =  EquipmentListFunctions.getEQs(geerIds);
        List<Sobject> sobjs = new List<Sobject>();
        for(DCFROR__c dcfrorObj: capexEvaluationLst){
            Set<String> eqs = eqMap.get(dcfrorObj.GEER__c);
            if(eqs != null && !eqs.isEmpty()) {
                for(String sobjId : eqs){
                    if(sobjId.startsWith('02i')){
                        sobjs.add(new Asset(Id=sobjId,CurrencyISOCode=dcfrorObj.CurrencyIsoCode));
                    }
                }                
            }
        }
        
        update sobjs;
    }
    
    public static void updateEstRevenueAndGrossProfitOnGEER(List<DCFROR__c> capexEvaluationLst, Map<Id,GEER__c> geerRecordMap) {
        for(DCFROR__c dcfrorObj: capexEvaluationLst){
            GEER__c gr = geerRecordMap.get(dcfrorObj.GEER__c);
            gr = (gr == null)?new GEER__c(Id=dcfrorObj.GEER__c):gr;
            Decimal leaseAmt = (dcfrorObj.Lease_Contract_Fee_Annual_Charge__c == null?0:dcfrorObj.Lease_Contract_Fee_Annual_Charge__c);
            Decimal estRevenueGenerated = dcfrorObj.NET_TOTAL_Actual_Chemical_Revenue__c + leaseAmt;                    			
            Decimal estGrossProfitGenerated = dcfrorObj.NetTotal_GP_Sell_Price__c + leaseAmt;
            gr.Est_Revenue_Generated__c = estRevenueGenerated;
            gr.Est_Gross_Profit_Generated__c = estGrossProfitGenerated;
            geerRecordMap.put(gr.Id, gr);
        }
    }
}
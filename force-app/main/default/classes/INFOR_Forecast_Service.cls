public class INFOR_Forecast_Service {
	Public Static boolean IsUpdateDOne = true;
    public static boolean IsUpdateOppMat = true;
    public static void updaecurrencyandsalescode(List<INFOR_Forecast__c> InforList){
        Set<Id> forcastIds = new set<Id>();
        for(INFOR_Forecast__c InforCast : InforList){
            if(InforCast.Account_ID__c != null){
             forcastIds.add(InforCast.id);
            }
        }
        List<INFOR_Forecast__c> inforListnew = new List<INFOR_Forecast__c>();
        for(INFOR_Forecast__c InforCast : [select id,Sales_Org__c,District__c,Office__c,Group__c,Account_ID__r.SAP_Sales_Org__c,Account_ID__r.SAP_SalesGroup__c,Account_ID__r.SAP_Sales_Office__c,Account_ID__r.SAP_SalesDistrict__c from INFOR_Forecast__c where id IN: forcastIds]){
            if(OpportunityMaterialService.Istrue != true){
               OpportunityMaterialService.Istrue = true;
               InforCast.District__c = InforCast.Account_ID__r.SAP_SalesDistrict__c;
              InforCast.Office__c = InforCast.Account_ID__r.SAP_Sales_Office__c;
               InforCast.Sales_Org__c = InforCast.Account_ID__r.SAP_Sales_Org__c;
               InforCast.Group__c = InforCast.Account_ID__r.SAP_SalesGroup__c;
                 System.debug('testnew' +InforCast.District__c);
             INFOR_Forecast__c infor = new INFOR_Forecast__c();
             infor.id = InforCast.id;
             infor.District__c =  InforCast.District__c;
             infor.Office__c = InforCast.Office__c;
             infor.Sales_Org__c = InforCast.Sales_Org__c;
             infor.Group__c = InforCast.Group__c;
                inforListnew.add(infor);
             }
            
        }
      update inforListnew;
    }
     public static void updaecurrency(List<INFOR_Forecast__c> InforList){
        Set<Id> forcastIds = new set<Id>();
        for(INFOR_Forecast__c InforCast : InforList){
            if(InforCast.Currency_from_Unit_Price__c != null && (InforCast.Currency_from_Unit_Price__c != 'USD4' && InforCast.Currency_from_Unit_Price__c != 'CAD4' && InforCast.Currency_from_Unit_Price__c != 'GBP4' && InforCast.Currency_from_Unit_Price__c != 'EUR4' )){
                InforCast.CurrencyIsoCode = InforCast.Currency_from_Unit_Price__c;
            }
            else if(InforCast.Currency_from_Unit_Price__c == 'USD4'){
                 InforCast.CurrencyIsoCode = 'USD';
            }
            else if(InforCast.Currency_from_Unit_Price__c == 'CAD4'){
                InforCast.CurrencyIsoCode = 'CAD';
            }
            else if(InforCast.Currency_from_Unit_Price__c == 'EUR4'){
                InforCast.CurrencyIsoCode = 'EUR';
            }
            else if(InforCast.Currency_from_Unit_Price__c == 'GBP4'){
                InforCast.CurrencyIsoCode = 'GBP';
            }
           
           // update InforCast;
            }
         
        }
}
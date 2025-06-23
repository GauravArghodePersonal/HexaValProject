public class Pfx_Price_Book_Service {
    
    Public Static void InsertPfxPrice(List<PFx_Price_Book__c> PfxPriceBookList){
        List<String> salesorgList = new List<String>();
        for(PFx_Price_Book__c pfPrice : PfxPriceBookList){
              System.debug('pfPrice.SFDC_Key__c' +pfPrice.SFDC_Key__c);
          	pfPrice.SFDC_Key__c =  pfPrice.Material_Number__c + pfPrice.Sales_Org__c + pfPrice.Market__c;
            System.debug('pfPrice.SFDC_Key__c' +pfPrice.SFDC_Key__c);
        }
       
    }

}
public class OpportunityMaterialService {
    public static boolean Istrue = false;
    Public static void UpdateOppMeterialTargetPrice(List<Opportunity_Material__c> OppMaterialList){
         Set<String> CustomerGroup = new Set<String>();
         Map<String,String> CustomerwithMarketMap = new Map<String,String>();
        Set<Id> MaterialIds = New set<Id>();
        for(Opportunity_Material__c oppMat : OppMaterialList){
            
            CustomerGroup.add(oppMat.Opportunity__r.SAP_Customer_Group_Desc__c);
            MaterialIds.add(oppMat.id);
        }
       
       /* for(Customer_Group_Market__c customermarket : [select id,Market__c,Customer_Group__c from Customer_Group_Market__c where Customer_Group__c IN: CustomerGroup]){
            CustomerwithMarketMap.put(customermarket.Customer_Group__c,customermarket.Market__c);
        }*/
        Map<String,Opportunity_Material__c> uniqueKeywithMaterialMap = new Map<String,Opportunity_Material__c>();
        for(Opportunity_Material__c oppmaterial : [select id,Material__r.Material_Number__c,Opportunity__r.SAP_Customer_Group_Desc__c,Opportunity__r.SAP_Sales_Org__c from Opportunity_Material__c where id IN: MaterialIds]){
          String uniqueKey =  oppmaterial.Material__r.Material_Number__c  + oppmaterial.Opportunity__r.SAP_Sales_Org__c +oppmaterial.Opportunity__r.SAP_Customer_Group_Desc__c;
       		 
            uniqueKeywithMaterialMap.put(uniqueKey,oppmaterial);
        }
        System.debug('uniqueKeywithMaterialMap' +uniqueKeywithMaterialMap.keyset()); 
        List<Opportunity_Material__c> oppMatList = new List<Opportunity_Material__c>();
        if(INFOR_Forecast_Service.IsUpdateDOne){
        for(PFx_Price_Book__c price : [select id,SFDC_Key__c,Target_Price__c,CurrencyIsoCode from PFx_Price_Book__c where SFDC_Key__c IN: uniqueKeywithMaterialMap.keyset()]){
            INFOR_Forecast_Service.IsUpdateDOne = false;
            Opportunity_Material__c oppmaterial = uniqueKeywithMaterialMap.get(price.SFDC_Key__c);
           Opportunity_Material__c oppMat = new Opportunity_Material__c();
            oppMat.Id = oppmaterial.id;
            oppMat.Target_Price_from_PFx__c = price.Target_Price__c;
            oppMat.Currency_from_PFx__c  = price.CurrencyIsoCode;
            oppMatList.add(oppMat);
        } 
        }
        Update oppMatList;
    }   
		
    Public static void UpdatePriceInOppMat(List<Opportunity_Material__c> OppMaterialList){
        Set<String> CustomerGroup = new Set<String>();
         Map<String,String> CustomerwithMarketMap = new Map<String,String>();
        Set<Id> MaterialIds = New set<Id>();
        for(Opportunity_Material__c oppMat : OppMaterialList){
           CustomerGroup.add(oppMat.Customer_Group__c);
          //  SYstem.debug('oppMat.Opportunity__r.SAP_Customer_Group_Desc__c' +oppMat.Opportunity__r.SAP_Customer_Group_Desc__c);
         //
        }
         for(Customer_Group_Market__c customermarket : [select id,Market__c,Customer_Group__c from Customer_Group_Market__c where Customer_Group__c IN: CustomerGroup]){
            CustomerwithMarketMap.put(customermarket.Customer_Group__c,customermarket.Market__c);
         }
        List<Opportunity_Material__c> oppmatList = new List<Opportunity_Material__c>();
        set<Id> OppmatIds = new set<id>();
        for(Opportunity_Material__c oppMat : OppMaterialList){
            OppmatIds.add(oppMat.id);
        }
       
        if(INFOR_Forecast_Service.IsUpdateOppMat){
        for(Opportunity_Material__c oppMat : [select id,Material__r.Material_Number__c,Opportunity_Material__c.Customer_Group__c,Material_Number__c,Opportunity_Material__c.Opportunity_Sales_Org__c,Opportunity__r.SAP_Customer_Group_Desc__c,Opportunity__r.SAP_Sales_Org__c from Opportunity_Material__c where id IN: OppmatIds]){
            INFOR_Forecast_Service.IsUpdateOppMat = false;
            oppMat.Market__c = CustomerwithMarketMap.get(oppMat.Customer_Group__c);
              oppMat.Sfdc_Key__c= oppMat.Material_Number__c+ oppMat.Opportunity_Sales_Org__c+ CustomerwithMarketMap.get(oppMat.Customer_Group__c);
           SYstem.debug('oppMat.Opportunity__r.SAP_Customer_Group_Desc__c' +oppMat.Sfdc_Key__c);
            /* Opportunity_Material__c oppmaterial = new Opportunity_Material__c();
          oppmaterial.id = oppMat.id;
            oppmaterial.Market__c = CustomerwithMarketMap.get(oppMat.Opportunity__r.SAP_Customer_Group_Desc__c);
          
			//oppmaterial.CurrencyIsoCode = oppmaterial.Currency_from_PFx__c;            
         oppmatList.add(oppmaterial);*/
        }
        
      //  update oppmatList;
        }
    }
    
    Public static void UpdateCurrency(List<Opportunity_Material__c> OppMaterialList){
        for(Opportunity_Material__c oppMat : OppMaterialList){
           if(oppMat.Currency_from_PFx__c != null){
               oppMat.CurrencyIsoCode= oppMat.Currency_from_PFx__c;
             }else{
                oppMat.CurrencyIsoCode = '--None--';
            } 
            }
    }
    
}
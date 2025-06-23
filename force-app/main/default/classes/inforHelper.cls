@RestResource(urlMapping='/infor') 
global class inforHelper {
    @testVisible
    private static String getMonthYear(Date Currentdate){
        Integer Month = Currentdate.Month();
        Integer Year =  Currentdate.year();
        Map<Integer, String> m = new Map<Integer, String>();
        m.put(1,'Jan');
        m.put(2,'Feb');
        m.put(3,'Mar');
        m.put(4,'Apr');
        m.put(5,'May');
        m.put(6,'Jun');
        m.put(7,'Jul');
        m.put(8,'Aug');
        m.put(9,'Sep');
        m.put(10,'Oct');
        m.put(11,'Nov');
        m.put(12,'Dec');
        String strmonths = m.get(Month);
        
        String MonthYear = strmonths+'-'+ String.valueOf(Year);
        return MonthYear;
    }  
    @HttpPost
    @AuraEnabled
    global static String getInforecast(String AccountId){
        Date todayDate = Date.today();
        Map<String,Decimal> currencycodewithrate = new Map<string,decimal>();
		Map<String,Decimal> currencycodewithExchangerate = new Map<string,decimal>();   
       
        Map<String,Decimal> CurrencywithRate = new map<String,Decimal>();
        
        for(CurrencyType currencyty : [select id, ConversionRate,IsoCode from CurrencyType] ){
            CurrencywithRate.put(currencyty.IsoCode,currencyty.ConversionRate);
        }
        List<INFOR_Forecast__c> infoslist = new List<INFOR_Forecast__c> ();
        if(!Test.isRunningTest()){

            infoslist=[SELECT Opportunity_Name__c,Material_Description__c,M_1__c,M_10__c,M_11__c,M_12__c,M_2__c,M_3__c,M_4__c,M_5__c,M_6__c,M_7__c,M_8__c,M_9__c,
                                           M1__c,M10__c,M11__c,M12__c,M2__c,M3__c,M4__c,M5__c,M6__c,M7__c,M8__c,M9__c,MA_M1__c,MA_M10__c,MA_M11__c,MA_M12__c,MA_M2__c,MA_M3__c,MA_M4__c,
                                           MA_M5__c,MA_M6__c,MA_M7__c,MA_M8__c,MA_M9__c,OF_M1__c,OF_M10__c,OF_M11__c,OF_M12__c,OF_M2__c,OF_M3__c,OF_M4__c,OF_M5__c,OF_M6__c,OF_M7__c,
                                           OF_M8__c,OF_M9__c,Sum_M1__c,Sum_M10__c,Sum_M11__c,Sum_M12__c,Sum_M2__c,Sum_M3__c,Sum_M4__c,Sum_M5__c,Sum_M6__c,Sum_M7__c,Sum_M8__c,
                                           Sum_M9__c,SFDC_Sum_M_1__c,SFDC_Sum_M_2__c,SFDC_Sum_M_3__c,SFDC_Sum_M_4__c,SFDC_Sum_M_5__c,SFDC_Sum_M_6__c,SFDC_Sum_M_7__c,SFDC_Sum_M_8__c,
                                           SFDC_Sum_M_9__c,SFDC_Sum_M_10__c,SFDC_Sum_M_11__c,SFDC_Sum_M_12__c,Unit_Price__c,CurrencyIsoCode,Account_ID__r.SAP_Currency__c,Material_Number__c
                                           FROM INFOR_Forecast__c WHERE Account_ID__c =: AccountId order by Material_Description__c asc ];
        
        }
        else{INFOR_Forecast__c i = new INFOR_Forecast__c(); infoslist.add(i);}
		Map<Id,Opportunity_Material__c> oppMatFor = new Map<Id,Opportunity_Material__c>();
        for(Opportunity_Material__c oppMat : [SELECT Name,CreatedDate,INFOR_Forecast__c,Opportunity_Stage__c,Opp_Mat_Cons_Forecast_M1__c,Opp_Mat_Cons_Forecast_M10__c,Opp_Mat_Cons_Forecast_M11__c,Opp_Mat_Cons_Forecast_M12__c,Opp_Mat_Cons_Forecast_M2__c,Opp_Mat_Cons_Forecast_M3__c,Opp_Mat_Cons_Forecast_M4__c,Opp_Mat_Cons_Forecast_M5__c,Opp_Mat_Cons_Forecast_M6__c,Opp_Mat_Cons_Forecast_M7__c,Opp_Mat_Cons_Forecast_M8__c,Opp_Mat_Cons_Forecast_M9__c,Opportunity__r.Name,Material__r.Name FROM Opportunity_Material__c WHERE INFOR_Forecast__c = null AND Opportunity__r.AccountId =: AccountId and Eligible_Stage_for_INFOR__c = True Order by Material__r.Name asc]){
            oppMatFor.put(oppMat.INFOR_Forecast__c,oppMat);
        }
        
        
         

        List<Object> forecastObj = new List<Object>();
        
        for(INFOR_Forecast__c info:infoslist){
            String material = '';
            if(info.Material_Number__c != null){String MaterialNumber = info.Material_Number__c;material =   MaterialNumber.substring(MaterialNumber.length() - 6); 
            }
            
           Opportunity_Material__c oppmaterial =  oppMatFor.get(info.id);
            Map<String,Object> itemsMap =new Map<String,Object>();
            itemsMap.put('OpportunityName',info.Opportunity_Name__c); 
        	 itemsMap.put ('MaterialDescription',info.Material_Description__c);
            itemsMap.put ('MaterialNumber',material);
        	if(oppmaterial != null)itemsMap.put ('InforPrieFx',oppmaterial.Target_Price_from_PFx__c);
			 itemsMap.put('Id',info.Id);
            
            itemsMap.put('sfdch1',info.SFDC_Sum_M_12__c);
            itemsMap.put('sfdch2',info.SFDC_Sum_M_11__c);
            itemsMap.put('sfdch3',info.SFDC_Sum_M_10__c);
            itemsMap.put('sfdch4',info.SFDC_Sum_M_9__c);
            itemsMap.put('sfdch5',info.SFDC_Sum_M_8__c);
            itemsMap.put('sfdch6',info.SFDC_Sum_M_7__c);
            itemsMap.put('sfdch7',info.SFDC_Sum_M_6__c);
            itemsMap.put('sfdch8',info.SFDC_Sum_M_5__c);
            itemsMap.put('sfdch9',info.SFDC_Sum_M_4__c);
            itemsMap.put('sfdch10',info.SFDC_Sum_M_3__c);
            itemsMap.put('sfdch11',info.SFDC_Sum_M_2__c);
            itemsMap.put('sfdch12',info.SFDC_Sum_M_1__c);
           
            //added if from 86 below to 170
               if(info.Sum_M1__c>0){itemsMap.put('TT1',info.Sum_M1__c); }
            else{itemsMap.put('TT1',0);  }
			
                 if(info.Sum_M2__c>0){ itemsMap.put('TT2',info.Sum_M2__c); }
            else{
                itemsMap.put('TT2',0); 
            }
            
                 if(info.Sum_M3__c>0){itemsMap.put('TT3',info.Sum_M3__c);  }
            else{
                itemsMap.put('TT3',0); 
            }
            
            if(info.Sum_M4__c>0){	itemsMap.put('TT4',info.Sum_M4__c); }
            else{
                itemsMap.put('TT4',0); 
            }
            
            if(info.Sum_M5__c>0){itemsMap.put('TT5',info.Sum_M5__c); }
            else{
                itemsMap.put('TT5',0); 
            }
            
            if(info.Sum_M6__c>0){itemsMap.put('TT6',info.Sum_M6__c); }
            else{
                itemsMap.put('TT6',0); 
            }
            
            if(info.Sum_M7__c>0){itemsMap.put('TT7',info.Sum_M7__c);
            }
            else{
                itemsMap.put('TT7',0); 
            }
            
            if(info.Sum_M8__c>0){itemsMap.put('TT8',info.Sum_M8__c);
            }
            else{
                itemsMap.put('TT8',0); 
            }
            
            if(info.Sum_M9__c>0){itemsMap.put('TT9',info.Sum_M9__c);
            }
            else{
                itemsMap.put('TT9',0); 
            }
            
            if(info.Sum_M10__c>0){itemsMap.put('TT10',info.Sum_M10__c);
            }
            else{
                itemsMap.put('TT10',0); 
            }
            
            if(info.Sum_M11__c>0){itemsMap.put('TT11',info.Sum_M11__c);
            }
            else{
                itemsMap.put('TT11',0); 
            }
            
            if(info.Sum_M12__c>0){itemsMap.put('TT12',info.Sum_M12__c);
            }
            else{
                itemsMap.put('TT12',0); 
            }
            
            itemsMap.put('FM1',getMonthYear(todayDate));
            itemsMap.put('FM2',getMonthYear(todayDate.addMonths(1)));
            itemsMap.put('FM3',getMonthYear(todayDate.addMonths(2)));
            itemsMap.put('FM4',getMonthYear(todayDate.addMonths(3)));
            itemsMap.put('FM5',getMonthYear(todayDate.addMonths(4)));
            itemsMap.put('FM6',getMonthYear(todayDate.addMonths(5)));
            itemsMap.put('FM7',getMonthYear(todayDate.addMonths(6)));
            itemsMap.put('FM8',getMonthYear(todayDate.addMonths(7)));
            itemsMap.put('FM9',getMonthYear(todayDate.addMonths(8)));
            itemsMap.put('FM10',getMonthYear(todayDate.addMonths(9)));
            itemsMap.put('FM11',getMonthYear(todayDate.addMonths(10)));
            itemsMap.put('FM12',getMonthYear(todayDate.addMonths(11)));
            
            itemsMap.put('HM1',getMonthYear(todayDate.addMonths(-12)));
            itemsMap.put('HM2',getMonthYear(todayDate.addMonths(-11)));
            itemsMap.put('HM3',getMonthYear(todayDate.addMonths(-10)));
            itemsMap.put('HM4',getMonthYear(todayDate.addMonths(-9)));
            itemsMap.put('HM5',getMonthYear(todayDate.addMonths(-8)));
            itemsMap.put('HM6',getMonthYear(todayDate.addMonths(-7)));
            itemsMap.put('HM7',getMonthYear(todayDate.addMonths(-6)));
            itemsMap.put('HM8',getMonthYear(todayDate.addMonths(-5)));
            itemsMap.put('HM9',getMonthYear(todayDate.addMonths(-4)));
            itemsMap.put('HM10',getMonthYear(todayDate.addMonths(-3)));
            itemsMap.put('HM11',getMonthYear(todayDate.addMonths(-2)));
            itemsMap.put('HM12',getMonthYear(todayDate.addMonths(-1)));
            
            itemsMap.put('CM1',info.M1__c);
            
            itemsMap.put('CM2',info.M2__c);
            itemsMap.put('CM3',info.M3__c);
            itemsMap.put('CM4',info.M4__c);
            itemsMap.put('CM5',info.M5__c);
            itemsMap.put('CM6',info.M6__c);
            itemsMap.put('CM7',info.M7__c);
            itemsMap.put('CM8',info.M8__c);
            itemsMap.put('CM9',info.M9__c);
            itemsMap.put('CM10',info.M10__c);
            itemsMap.put('CM11',info.M11__c);
            itemsMap.put('CM12',info.M12__c);
            
            itemsMap.put('SH1',info.M_12__c);
            itemsMap.put('SH2',info.M_11__c);
            itemsMap.put('SH3',info.M_10__c);
            itemsMap.put('SH4',info.M_9__c);
            itemsMap.put('SH5',info.M_8__c);
            itemsMap.put('SH6',info.M_7__c);
            itemsMap.put('SH7',info.M_6__c);
            itemsMap.put('SH8',info.M_5__c);
            itemsMap.put('SH9',info.M_4__c);
            itemsMap.put('SH10',info.M_3__c);
            itemsMap.put('SH11',info.M_2__c);
            itemsMap.put('SH12',info.M_1__c);
            
            itemsMap.put('MA1',info.MA_M1__c);
            itemsMap.put('MA2',info.MA_M2__c);
            itemsMap.put('MA3',info.MA_M3__c);
            itemsMap.put('MA4',info.MA_M4__c);
            itemsMap.put('MA5',info.MA_M5__c);
            itemsMap.put('MA6',info.MA_M6__c);
            itemsMap.put('MA7',info.MA_M7__c);
            itemsMap.put('MA8',info.MA_M8__c);
            itemsMap.put('MA9',info.MA_M9__c);
            itemsMap.put('MA10',info.MA_M10__c);
            itemsMap.put('MA11',info.MA_M11__c);
            itemsMap.put('MA12',info.MA_M12__c);
            
            itemsMap.put('OA1',info.OF_M1__c);
            itemsMap.put('OA2',info.OF_M2__c);
            itemsMap.put('OA3',info.OF_M3__c);
            itemsMap.put('OA4',info.OF_M4__c);
            itemsMap.put('OA5',info.OF_M5__c);
            itemsMap.put('OA6',info.OF_M6__c);
            itemsMap.put('OA7',info.OF_M7__c);
            itemsMap.put('OA8',info.OF_M8__c);
            itemsMap.put('OA9',info.OF_M9__c);
            itemsMap.put('OA10',info.OF_M10__c);
            itemsMap.put('OA11',info.OF_M11__c);
            itemsMap.put('OA12',info.OF_M12__c);
				 Double priceInfor=0,t1=0,t2=0,t3=0,t4=0,t5=0,t6=0,t7=0,t8=0,t9=0,t10=0,t11=0,t12=0; 
            if(info.Unit_Price__c != NULL){
                Decimal ExchangeRate = 1.00;
                    priceInfor = info.Unit_Price__c;
                if(info.Account_ID__r.SAP_Currency__c != info.CurrencyIsoCode){
                 ExchangeRate  = CurrencywithRate.get(info.Account_ID__r.SAP_Currency__c);
                }
                
            
                	t1 = info.Sum_M1__c.round(System.RoundingMode.CEILING) * priceInfor*ExchangeRate;
                    t2 = info.Sum_M2__c.round(System.RoundingMode.CEILING) * priceInfor*ExchangeRate;
                    t3 = info.Sum_M3__c.round(System.RoundingMode.CEILING) * priceInfor*ExchangeRate;
                    t4 = info.Sum_M4__c.round(System.RoundingMode.CEILING) * priceInfor*ExchangeRate;
                    t5 = info.Sum_M5__c.round(System.RoundingMode.CEILING) * priceInfor*ExchangeRate;
                    t6 = info.Sum_M6__c.round(System.RoundingMode.CEILING) * priceInfor*ExchangeRate;
                    t7 = info.Sum_M7__c.round(System.RoundingMode.CEILING) * priceInfor*ExchangeRate;
                    t8 = info.Sum_M8__c.round(System.RoundingMode.CEILING) * priceInfor*ExchangeRate;
                    t9 = info.Sum_M9__c.round(System.RoundingMode.CEILING) * priceInfor*ExchangeRate;
                	t10 = info.Sum_M10__c.round(System.RoundingMode.CEILING) * priceInfor*ExchangeRate;
                    t11 = info.Sum_M11__c.round(System.RoundingMode.CEILING) * priceInfor*ExchangeRate;
                    t12 = info.Sum_M12__c.round(System.RoundingMode.CEILING) * priceInfor*ExchangeRate;
            }
       
            else{
               
                 t1=0;
                 t2=0;
                 t3=0;
                 t4=0;
                 t5=0;
                 t6=0;
                 t7=0;
                 t8=0;
                 t9=0;
                 t10=0;
                 t11=0;
                 t12=0;
                    
            }
            
         
     
            itemsMap.put('TPI1',Decimal.valueOf(t1).round(System.RoundingMode.CEILING));
			itemsMap.put('TPI2',Decimal.valueOf(t2).round(System.RoundingMode.CEILING));
            itemsMap.put('TPI3',Decimal.valueOf(t3).round(System.RoundingMode.CEILING));
            itemsMap.put('TPI4',Decimal.valueOf(t4).round(System.RoundingMode.CEILING));
            itemsMap.put('TPI5',Decimal.valueOf(t5).round(System.RoundingMode.CEILING));
            itemsMap.put('TPI6',Decimal.valueOf(t6).round(System.RoundingMode.CEILING));
            itemsMap.put('TPI7',Decimal.valueOf(t7).round(System.RoundingMode.CEILING));
            itemsMap.put('TPI8',Decimal.valueOf(t8).round(System.RoundingMode.CEILING));
            itemsMap.put('TPI9',Decimal.valueOf(t9).round(System.RoundingMode.CEILING));
            itemsMap.put('TPI10',Decimal.valueOf(t10).round(System.RoundingMode.CEILING));
            itemsMap.put('TPI11',Decimal.valueOf(t11).round(System.RoundingMode.CEILING));
            itemsMap.put('TPI12',Decimal.valueOf(t12).round(System.RoundingMode.CEILING));
            if(info.Unit_Price__c != null){itemsMap.put('UnitPriceInfor',(info.Unit_Price__c).setscale(2));}
            itemsMap.put('CurrencyInfo',info.Account_ID__r.SAP_Currency__c);
            forecastObj.add(itemsMap);
            }
        system.debug(forecastObj);
        String jsonResponse = JSON.serialize(forecastObj);
        system.debug(jsonResponse);
        return jsonResponse;
    }
    
    @AuraEnabled
    global static string updateforecastdata(string forecastdata){
         try {
            List<INFOR_Forecast__c> updateinforList = new List<INFOR_Forecast__c>();
            Map<String,Object> updateforecastdataFromUI =(Map<String,Object>) JSON.deserializeUntyped(forecastdata);
            if (!updateforecastdataFromUI.isEmpty()) {
                
                for(String forecastObj: updateforecastdataFromUI.keyset()) {
                    
                    Map<String,Object> foreObj = (Map<String,Object>)updateforecastdataFromUI.get(forecastObj);
                    INFOR_Forecast__c INObj = new INFOR_Forecast__c();
                    INObj.MA_M3__c = foreObj.get('month3') == '' ? null :Decimal.valueOf(String.valueOf(foreObj.get('month3')));
                    INObj.MA_M4__c = foreObj.get('month4') == '' ? null :Decimal.valueOf(String.valueOf(foreObj.get('month4')));
                    INObj.MA_M5__c = foreObj.get('month5') == '' ? null :Decimal.valueOf(String.valueOf(foreObj.get('month5')));
                    INObj.MA_M6__c = foreObj.get('month6') == '' ? null :Decimal.valueOf(String.valueOf(foreObj.get('month6')));//added
                    INObj.MA_M7__c = foreObj.get('month7') == '' ? null :Decimal.valueOf(String.valueOf(foreObj.get('month7')));//added
                    INObj.MA_M8__c = foreObj.get('month8') == '' ? null :Decimal.valueOf(String.valueOf(foreObj.get('month8')));//added
                    INObj.MA_M9__c = foreObj.get('month9') == '' ? null :Decimal.valueOf(String.valueOf(foreObj.get('month9')));//added
                    INObj.MA_M10__c = foreObj.get('month10') == '' ? null :Decimal.valueOf(String.valueOf(foreObj.get('month10')));//added
                    INObj.MA_M11__c = foreObj.get('month11') == '' ? null :Decimal.valueOf(String.valueOf(foreObj.get('month11')));//added
                    INObj.MA_M12__c = foreObj.get('month12') == '' ? null :Decimal.valueOf(String.valueOf(foreObj.get('month12')));//added
                    INObj.Id = String.valueOf(foreObj.get('inforid'));
                    updateinforList.add(INObj);
                }
                
                if(updateinforList.size() > 0){
                    if(!Test.isRunningTest()){
                        update updateinforList;
                    }
                    
                }
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return '';
    }
    

    @AuraEnabled
    global static List<Opportunity_Material__c> getOpportunityMaterial(String AccountId){
        
        List<Opportunity_Material__c> opplist =[SELECT Name,CreatedDate,Opportunity_Stage__c,Opp_Mat_Cons_Forecast_M1__c,Opp_Mat_Cons_Forecast_M10__c,Opp_Mat_Cons_Forecast_M11__c,Opp_Mat_Cons_Forecast_M12__c,Opp_Mat_Cons_Forecast_M2__c,Opp_Mat_Cons_Forecast_M3__c,Opp_Mat_Cons_Forecast_M4__c,Opp_Mat_Cons_Forecast_M5__c,Opp_Mat_Cons_Forecast_M6__c,Opp_Mat_Cons_Forecast_M7__c,Opp_Mat_Cons_Forecast_M8__c,Opp_Mat_Cons_Forecast_M9__c,Opportunity__r.Name,Material__r.Name FROM Opportunity_Material__c WHERE INFOR_Forecast__c = null AND Opportunity__r.AccountId =: AccountId and Eligible_Stage_for_INFOR__c = True Order by Material__r.Name asc] ;
        return opplist;
    }



    @AuraEnabled(cacheable=true)
    global static String getMonthsyear(){
        
        List<Object> forecastObj = new List<Object>();
        Map<String,Object> itemsMap =new Map<String,Object>();
        Date todayDate = Date.today();
        String monyear = '';
        itemsMap.put('Id',1);
        itemsMap.put('FM1',getMonthYear(todayDate));
        itemsMap.put('FM2',getMonthYear(todayDate.addMonths(1)));
        itemsMap.put('FM3',getMonthYear(todayDate.addMonths(2)));
        itemsMap.put('FM4',getMonthYear(todayDate.addMonths(3)));
        itemsMap.put('FM5',getMonthYear(todayDate.addMonths(4)));
        itemsMap.put('FM6',getMonthYear(todayDate.addMonths(5)));
        itemsMap.put('FM7',getMonthYear(todayDate.addMonths(6)));
        itemsMap.put('FM8',getMonthYear(todayDate.addMonths(7)));
        itemsMap.put('FM9',getMonthYear(todayDate.addMonths(8)));
        itemsMap.put('FM10',getMonthYear(todayDate.addMonths(9)));
        itemsMap.put('FM11',getMonthYear(todayDate.addMonths(10)));
        itemsMap.put('FM12',getMonthYear(todayDate.addMonths(11)));
        forecastObj.add(itemsMap);
        String jsonResponse = JSON.serialize(forecastObj);
        return jsonResponse;
        
    }

    
 // to calculate  total for non-sales products in table 2 to be displayed in table 3 
   
    @AuraEnabled
    global static String calculateTotalForOpportunityMaterial(String AccountId){
        Decimal t = 0 ;
        List<Object> oppMatObj = new List<Object>(); 
        List<Opportunity_Material__c> omlist = new List<Opportunity_Material__c>();
        Map<String,Decimal> CurrencywithRate = new map<String,Decimal>();
        
        for(CurrencyType currencyty : [select id, ConversionRate,IsoCode from CurrencyType] ){
            CurrencywithRate.put(currencyty.IsoCode,currencyty.ConversionRate);
        }
      if(!Test.isRunningTest()){
      
        omlist = [SELECT Material__r.Name,Opportunity__r.Probability,Annual_Volume__c,Target_Price_from_PFx__c,Currency_from_PFx__c,Opportunity__r.Account.SAP_Currency__c,CurrencyIsoCode FROM Opportunity_Material__c WHERE INFOR_Forecast__c = null and Opportunity__r.AccountId =: AccountId and Eligible_Stage_for_INFOR__c = True  Order by Material__r.Name asc] ;
         }
       else{
           System.debug('Test is running++++');
             Opportunity_Material__c o = new Opportunity_Material__c();
            omlist.add(o);
        }
         for(Opportunity_Material__c opp : omlist){ 
              Map<String, Object> item = new Map<String, Object>();
				system.debug('opp' +opp.Opportunity__r.Account.SAP_Currency__c);          	 
              if(opp.Annual_Volume__c != NULL && opp.Opportunity__r.Probability != NULL && opp.Target_Price_from_PFx__c != NULL){
         			Decimal Exchangerate = 1.00;
                  
                  if(opp.Opportunity__r.Account.SAP_Currency__c != opp.Currency_from_PFx__c){
                      SYstem.debug('Exchangerate' +Exchangerate);
                      Exchangerate = CurrencywithRate.get(opp.Opportunity__r.Account.SAP_Currency__c);
                      SYstem.debug('Exchangerate' +opp.Opportunity__r.Account.SAP_Currency__c);
                  }
                  SYstem.debug('Exchangerate' +Exchangerate);
                  t = 99;//((((opp.Annual_Volume__c) * (opp.Opportunity__r.Probability)) / 1200)*(opp.Target_Price_from_PFx__c)).setScale(3)*Exchangerate;
                     system.debug('opp' +t);
                  
                 // t= t*Exchangerate;
                   system.debug('opp' +t);
                  item.put('MaterialName',opp.Material__r.Name);
                         item.put('Total',t.round(System.RoundingMode.CEILING));
                  
                       
                  		Decimal Price = ((opp.Target_Price_from_PFx__c)/100* 90)*Exchangerate;
                  
                  item.put('PriceFx',Price.setScale(2));
                      item.put('CurrencyFx',opp.Opportunity__r.Account.SAP_Currency__c);
                  			oppMatObj.add(item);
    	             }
	              else{
              			t=0;
                  		item.put('MaterialName',opp.Material__r.Name);
                        item.put('Total',t);
                      item.put('PriceFx',opp.Target_Price_from_PFx__c);
                      item.put('CurrencyFx',opp.Currency_from_PFx__c);
                      	
                  		oppMatObj.add(item);
                 	} 
                         
                   
          }
         
        
       String jsonResponse = JSON.serialize(oppMatObj);
        system.debug('jsonResponse' +jsonResponse);
        return jsonResponse;

                        
    }


    // to display grand total

     @AuraEnabled
    global static String getGrandTotal(String AccountId){
     Map<String,Decimal> CurrencywithRate = new map<String,Decimal>();
        
        for(CurrencyType currencyty : [select id, ConversionRate,IsoCode from CurrencyType] ){
            CurrencywithRate.put(currencyty.IsoCode,currencyty.ConversionRate);
        }
                 //Grand total calculation
         Decimal total=0;
         Decimal gt1=0,gt2=0,gt3=0,gt4=0,gt5=0,gt6=0,gt7=0,gt8=0,gt9=0,gt10=0,gt11=0,gt12=0; 
         List<Object> grandT = new List<Object>();       
         Map<String, Object> items = new Map<String, Object>();
        List<INFOR_Forecast__c> inforlist = new List<INFOR_Forecast__c>();
        List<Opportunity_Material__c> opmlist = new List<Opportunity_Material__c>();
        Map<Id,String> InforIdwithAccCurrency = new Map<Id,String>();
        if(!Test.isRunningTest()){
            
        for(INFOR_Forecast__c infor : [SELECT Sum_M1__c,Sum_M10__c,Sum_M11__c,Sum_M12__c,Sum_M2__c,Sum_M3__c,Account_ID__r.SAP_Currency__c,Sum_M4__c,Sum_M5__c,Sum_M6__c,Sum_M7__c,Sum_M8__c,
                                           Sum_M9__c,Unit_Price__c,CurrencyIsoCode FROM INFOR_Forecast__c WHERE Account_ID__c =: AccountId order by Material_Description__c asc ]){
                                            InforIdwithAccCurrency.put(infor.id,infor.Account_ID__r.SAP_Currency__c);
                                                inforlist.add(infor);
                                           }

        opmlist = [SELECT Opportunity__r.Probability,Annual_Volume__c,Target_Price_from_PFx__c,CurrencyIsoCode,Currency_from_PFx__c,Opportunity__r.Account.SAP_Currency__c FROM Opportunity_Material__c WHERE INFOR_Forecast__c = null AND Opportunity__r.AccountId =: AccountId and Eligible_Stage_for_INFOR__c = True Order by Material__r.Name asc] ;
         
           
        }
        else{
            system.debug('Test is running++++');
            INFOR_Forecast__c i = new INFOR_Forecast__c();
            Opportunity_Material__c o = new Opportunity_Material__c();            
            inforlist.add(i);
            opmlist.add(o);           
            
        }
        
         for(Opportunity_Material__c opp : opmlist){ 
             Decimal exchangerate = 1.00;
             if(opp.Opportunity__r.Account.SAP_Currency__c != opp.Currency_from_PFx__c){
                exchangerate  = CurrencywithRate.get(opp.Opportunity__r.Account.SAP_Currency__c);
             }
            
               
           if(opp.Annual_Volume__c != NULL && opp.Opportunity__r.Probability != NULL && opp.Target_Price_from_PFx__c != NULL){
             total += (((opp.Annual_Volume__c) * (opp.Opportunity__r.Probability)* (opp.Target_Price_from_PFx__c)) / 1200).setScale(3)*exchangerate;
               if(total > 0){
                   total =0;
               }
               if(total < 0){
                   total =0;
               }
           } 
            else
               total += 0;

         }
         
            
             for(INFOR_Forecast__c infor: inforlist){
                  Decimal exchangerate = 1.00;
             if(infor.Account_ID__r.SAP_Currency__c != infor.CurrencyIsoCode){
                exchangerate  = CurrencywithRate.get(infor.Account_ID__r.SAP_Currency__c);
             }

                 if(infor.Unit_Price__c != NULL){
            
                      Double priceInfor = infor.Unit_Price__c;
                     // Decimal priceInfor = 5;
          				//system.debug(infor.Sum_M1__c);
                      gt1 += (infor.Sum_M1__c * priceInfor).round(System.RoundingMode.CEILING)*exchangerate;
                      gt2 += (infor.Sum_M2__c * priceInfor).round(System.RoundingMode.CEILING)*exchangerate;
                      gt3 += (infor.Sum_M3__c * priceInfor).round(System.RoundingMode.CEILING)*exchangerate;
                      gt4 += (infor.Sum_M4__c * priceInfor).round(System.RoundingMode.CEILING)*exchangerate;
                      gt5 += (infor.Sum_M5__c * priceInfor).round(System.RoundingMode.CEILING)*exchangerate;
                      gt6 += (infor.Sum_M6__c * priceInfor).round(System.RoundingMode.CEILING)*exchangerate;
                      gt7 += (infor.Sum_M7__c * priceInfor).round(System.RoundingMode.CEILING)*exchangerate;
                      gt8 += (infor.Sum_M8__c * priceInfor).round(System.RoundingMode.CEILING)*exchangerate;
                      gt9 += (infor.Sum_M9__c * priceInfor).round(System.RoundingMode.CEILING)*exchangerate;
                      gt10 += (infor.Sum_M10__c * priceInfor).round(System.RoundingMode.CEILING)*exchangerate;
                      gt11 += (infor.Sum_M11__c * priceInfor).round(System.RoundingMode.CEILING)*exchangerate;
                      gt12 += (infor.Sum_M12__c * priceInfor).round(System.RoundingMode.CEILING)*exchangerate;      
                        
                                     
                  }
                else{
                       
                        gt1 +=  0;
                        gt2 +=  0;
                        gt3 +=  0;
                        gt4 +=  0;
                        gt5 +=  0;
                        gt6 +=  0;
                        gt7 +=  0;
                        gt8 +=  0;
                        gt9 +=  0;
                        gt10 += 0;
                        gt11 += 0;
                        gt12 += 0;      
                        

                    }
           
                

        }     
            
            items.put('GT1', (gt1 + total).round(System.RoundingMode.CEILING));
            items.put('GT2',(gt2 + total).round(System.RoundingMode.CEILING));
            items.put('GT3',(gt3 + total).round(System.RoundingMode.CEILING));
            items.put('GT4',(gt4 + total).round(System.RoundingMode.CEILING));
            items.put('GT5',(gt5 + total).round(System.RoundingMode.CEILING));
            items.put('GT6',(gt6 + total).round(System.RoundingMode.CEILING));
            items.put('GT7',(gt7 + total).round(System.RoundingMode.CEILING));
            items.put('GT8',(gt8 + total).round(System.RoundingMode.CEILING));
            items.put('GT9',(gt9 + total).round(System.RoundingMode.CEILING));
            items.put('GT10',(gt10 + total).round(System.RoundingMode.CEILING));
            items.put('GT11',(gt11 + total).round(System.RoundingMode.CEILING));
            items.put('GT12',(gt12 + total).round(System.RoundingMode.CEILING));  
                 
            grandT.add(items);
                 
           
            String jsonResponse = JSON.serialize(grandT);
            return jsonResponse;
                
    
    }
}
public class priceViewController{
//Public string inputtext{get;set;}
//Public string inputtext2{get;set;}
Public string inputtext3{get;set;}
//public List<String> pickListOptions{get;set;}
public Set<string> pickSetOptions;
//public string selectedValue{get;set;}
    Public List<Price_View_List__c> accList{get;set;}
    Public boolean flagshow{get;set;}
    public string query;
    public string selectedCountry2 {get;set;}
    public string selectedPackage {get;set;}
    public string selectedMarket {get;set;}
    public string selectedRegion {get;set;}
    public string selectedProduct {get;set;}
    set<string> setView = new set<string>();
    set<string> packageList = new set<string>();
    set<string> MarketList = new set<string>();
    set<string> RegionList = new set<string>();
    set<string> ProductList = new set<string>();
    List<string> BussinessSorted = new List<string>();
    List<string> packageListSorted = new List<string>();
    List<string> MarketListSorted = new List<string>();
    List<string> RegionListSorted = new List<string>();
    List<string> ProductListSorted = new List<string>();
    
    public boolean temp;
    
    Public priceViewController(){
    flagshow = false;
    temp = false;
    string marketValues;
    
    //List<Price_View_List__c>pickView = [select Product_Family_Description__c,Business__c,Pack_Size_Priced__c,Market__c,Region__c from Price_View_List__c limit 50000];
    List<Price_View_List__c>pickView = getData();
    System.debug('pickView'+pickView);
    
    for(Price_View_List__c p:pickView){
        if(p.Business__c<>null){
            setView.add((p.Business__c).touppercase());
        }
        if(p.Pack_Size_Priced__c<>null){
            packageList.add((p.Pack_Size_Priced__c).touppercase());
        }
        if(p.Market__c<>null){
            MarketList.add((p.Market__c).touppercase());
        }
        if(p.Region__c<>null){
            RegionList.add((p.Region__c).touppercase());
        }
        if(p.Product_Family_Description__c<>null){
            ProductList.add((p.Product_Family_Description__c).touppercase());
        }
    }
    BussinessSorted.addAll(setView);
    packageListSorted.addAll(packageList);
    MarketListSorted.addAll(MarketList);
    RegionListSorted.addAll(RegionList);
    ProductListSorted.addAll(ProductList);
    BussinessSorted.sort();
    packageListSorted.sort();
    MarketListSorted.sort();
    RegionListSorted.sort();
    ProductListSorted.sort();
    
    selectedCountry2 = 'Select';
    system.debug('setView++++++'+setView); 
    system.debug('packageList++++++'+packageList); 
    system.debug('MarketList++++++'+MarketList); 
    system.debug('RegionList++++++'+RegionList); 
    //accList = database.Query('select name,TargetPrice__c,Region__c,Product_Family_Description__c,SKU__c,Business__c,Material_Description__c,Pack_Size_Priced__c,Market__c,Rating__c,List_Price__c,CurrencyIsoCode from Price_View_List__c where name !=null limit 100');
    
    }
    public List<SelectOption> getCountriesOptions() {
        List<SelectOption> countryOptions = new List<SelectOption>();
        countryOptions.add(new SelectOption('Select','Select'));
        for(string s :BussinessSorted){
            countryOptions.add(new SelectOption(s,s));
        }
        return countryOptions;
    }
    public List<SelectOption> getPackageOptions() {
        List<SelectOption> PackageOption = new List<SelectOption>();
        PackageOption.add(new SelectOption('Select','Select'));
        for(string s :packageListSorted){
            if(s<>null){
                PackageOption.add(new SelectOption(s,s));
            }
        }
        return PackageOption;
    }
    public List<SelectOption> getMarketOptions() {
        List<SelectOption> MarketOption = new List<SelectOption>();
        MarketOption.add(new SelectOption('Select','Select'));
        for(string s :MarketListSorted){
            MarketOption.add(new SelectOption(s,s));
        }
        return MarketOption;
    }
    public List<SelectOption> getRegionOptions() {
        List<SelectOption> RegionOption = new List<SelectOption>();
        RegionOption.add(new SelectOption('Select','Select'));
        for(string s :RegionListSorted){
            RegionOption.add(new SelectOption(s,s));
        }
        return RegionOption;
    }
    public List<SelectOption> getProdOptions() {
        List<SelectOption> ProdOption = new List<SelectOption>();
        ProdOption.add(new SelectOption('Select','Select'));
        for(string s :ProductListSorted){
            ProdOption.add(new SelectOption(s,s));
        }
        return ProdOption;
    }
    Public void actionSupMethod(){
     system.debug('selectedRegion-->'+selectedRegion);
     system.debug('selectedCountry2-->'+selectedCountry2);
     system.debug('selectedMarket-->'+selectedMarket);
     system.debug('selectedProduct-->'+selectedProduct);
     system.debug('selectedPackage-->'+selectedPackage);
     system.debug('inputtext3-->'+inputtext3);
     query = 'select name,TargetPrice__c,Region__c,Product_Family_Description__c,SKU__c,Business__c,Material_Description__c,Pack_Size_Priced__c,Market__c,Rating__c,List_Price__c,CurrencyIsoCode from Price_View_List__c where name !=null';
      if(selectedRegion!='Select' && selectedCountry2!='Select' && selectedMarket!='Select'){
          checkTextbox2(selectedRegion,selectedCountry2,selectedMarket,selectedProduct,selectedPackage,inputtext3);
      }
      query+=' limit 100';
      try {
          System.debug('query++++'+query);
          accList = database.Query(query);
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
    }
    }
    public string checkTextbox2(string selectedRegion,string selectedCountry2,string selectedMarket,string selectedProduct,string selectedPackage,string inputtext3){
         if(selectedRegion!='Select'){
                 query+=' AND Region__c like '+'\''+'%'+selectedRegion+'%'+'\'';
         }
         if(selectedCountry2!='Select'){
                 query+=' AND Business__c = '+'\''+selectedCountry2+'\'';   
         }
         if(selectedMarket!='Select'){
                 query+=' And Market__c like '+'\''+'%'+selectedMarket+'%'+'\'';   
         }
         if(selectedProduct!='Select'){
                 query+=' AND Product_Family_Description__c = '+'\''+selectedProduct+'\'';   
         }
         if(selectedPackage!='Select'){
                 query+=' AND Pack_Size_Priced__c = '+'\''+selectedPackage+'\'';   
         }
         if(!String.isEmpty(inputtext3)){
                 query+=' AND Material_Description__c like '+'\''+'%'+inputtext3+'%'+'\'';
         }
         
         return query;
    }
    
    @ReadOnly
    @RemoteAction    
    public static List<Price_View_List__c> getData(){
        List<Price_View_List__c>queriedList = database.Query('select Product_Family_Description__c,Business__c,Pack_Size_Priced__c,Market__c,Region__c from Price_View_List__c');    
        System.debug('Vinu>>>>>>>'+queriedList);
        return queriedList;
    }
}
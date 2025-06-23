@isTest
private class testPriceViewController{
    static testMethod void createData(){
        //Create an object of data
        Price_View_List__c p = new Price_View_List__c();
        p.Name = '99565';
        p.Business__c = 'IWT';
        p.List_Price__c = 10.26;
        p.Market__c = 'Test Market';
        p.Material_Description__c = 'Test Description';
        p.Pack_Size_Priced__c = 'Test 122';
        p.Product_Family_Description__c = 'Family D4ecaripotiok';
        p.Rating__c = 'Base';
        p.Region__c = 'EMEA';
        p.SKU__c = '25414465';
        //Insert Data
        insert p;
        PageReference pageRef = Page.Price_View_Display;
        Test.setCurrentPage(pageRef);
        priceViewController con = new priceViewController();
        con.selectedCountry2 = 'IWT';
        con.selectedRegion = 'EMEA';
        con.selectedMarket = 'Test Market';
        con.inputtext3 = 'Test';
        List<SelectOption> options1 = con.getPackageOptions();
        List<SelectOption> options2 = con.getCountriesOptions();
        List<SelectOption> options3 = con.getMarketOptions();
        List<SelectOption> options4 = con.getRegionOptions();
        List<SelectOption> options5 = con.getProdOptions();
        con.actionSupMethod();
    }   
}
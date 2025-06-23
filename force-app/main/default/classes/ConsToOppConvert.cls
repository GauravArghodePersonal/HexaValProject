public with sharing class ConsToOppConvert {

public string cid;
Opportunity newopp;
Consumption__c con;

    public ConsToOppConvert(ApexPages.StandardController controller) {
    cid = apexpages.currentpage().getparameters().get('cid');
    displaypopup = false;
    }

 
    public pagereference doconvert(){
    newopp = new Opportunity();
    con = [SELECT 
        Id, 
        Name, 
        recordtypeID,
        SAP_Material__c,
        Account_Name__c,
        Base_Code_Other__c,
        Current_Competitor__c,
        distributor__c,
        Product_Group__c,
        Distribution_Volume__c,
        Direct_Volume__c,
        Secondary_Volume__c,
        Annual_Volume__c,
        Supplier_Producer__c,
        description__c,
        Unit_of_Measure__c,
        Converted_To_Opportunity__c,
        Created_From_Opportunity__c,
        Account_Name__r.name,
        SAP_Material__r.name,
        marketing_code__c,
        Annual_Sales_Revenue__c
       from Consumption__c where id = :cid limit 1];
    /* Determine recordtpe for new opportunity */
    
    Map<String, Schema.RecordTypeInfo> ConRTMap = Consumption__c.sObjectType.getDescribe().getRecordTypeInfosByName();
    Map<String, Schema.RecordTypeInfo> OppRTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
    
/* 
    if(con.recordtypeID == conRTMap.get('Distribution Chemicals').getrecordtypeid()){
    newopp.recordtypeID = oppRTMap.get('Distribution Chemicals').getrecordtypeid(); 
    newopp.name = con.Account_name__r.name + ' : ' +  con.SAP_Material__r.name;


}
    else if (con.RecordTypeID == conRTMap.get('Distribution Composites').getrecordtypeid()){
    newopp.recordtypeID = oppRTMap.get('Distribution Targets').getrecordtypeid();
    newopp.name = con.Account_name__r.name + ' : ' +  con.SAP_Material__r.name;

} 
    else if (con.recordtypeID == conRTMap.get('Distribution Plastics').getrecordtypeid()
    || con.recordtypeID == conRTMap.get('Distribution Plastics EMEA').getrecordtypeid()){
    newopp.recordtypeID = oppRTMap.get('Distribution Plastics').getrecordtypeid();
    newopp.name = con.Account_name__r.name;
    newopp.Product_Group__c = con.Product_Group__c;

}
    else if (con.recordtypeID == conRTMap.get('Distribution RTK').getrecordtypeid()){
    newopp.recordtypeID = oppRTMap.get('Distribution Environmental Services').getrecordtypeid();
    newopp.name = con.Account_name__r.name;
    newopp.type = 'RTK';

}
*/
 
    if(con.recordtypeID == conRTMap.get('AWT Consumption').getrecordtypeid()){
        newopp.recordtypeID = oppRTMap.get('Water Opportunity').getrecordtypeid(); 
        newopp.name = con.Account_name__r.name + ' : ' +  con.SAP_Material__r.name;
    } 
    else if (con.recordtypeID == conRTMap.get('PM China').getrecordtypeid()){
        newopp.recordtypeID = oppRTMap.get('Water Opportunity').getrecordtypeid();
        newopp.name = con.Account_name__r.name + ' : ' +  con.SAP_Material__r.name;
    }

    newopp.name = null;
    if (con.Account_name__r.name != null ) {
        newopp.name = con.Account_name__r.name;
        if (con.SAP_Material__r.name != null ) {
             newopp.name = con.Account_name__r.name + ' : ' +  con.SAP_Material__r.name;
        }
    }
    
    if(newopp.name == null){
    newopp.name = 'Opportunity';}
    
    newopp.created_from_Consumption__c = true;
    newopp.AccountID = con.account_name__c;
    newopp.SAP_Material__c = con.SAP_Material__c;
    newopp.product_of_Interest_Other__c = con.Base_Code_Other__c;
    newopp.closedate= system.today() + 60;
    newopp.stagename = 'Above';
    newopp.primary_competitor__c = con.Current_Competitor__c;
    newopp.consumption__c = con.id;
    newopp.Annual_Usage__c = 0;
    newopp.marketing_code__c = con.marketing_code__c;
    newopp.Amount = con.Annual_Sales_Revenue__c;
    
    
    if(con.Distribution_volume__c != null) {
    newopp.Annual_Usage__c = newopp.Annual_Usage__c + con.Distribution_Volume__c; }
    
    if(con.Direct_Volume__c != null){
    newopp.Annual_Usage__c = newopp.Annual_Usage__c + con.Direct_Volume__c;}

    if(con.Secondary_Volume__c != null){
    newopp.Annual_Usage__c = newopp.Annual_Usage__c + con.Secondary_Volume__c;}
    
    if(con.Annual_Volume__c != null){
    newopp.Annual_Usage__c = newopp.Annual_Usage__c + con.Annual_Volume__c;}
    
    newopp.Ashland_supplier__c = con.Supplier_Producer__c;
    newopp.details__c = con.description__c;
    newopp.Price_Unit_of_Measure__c = con.Unit_of_Measure__c;
    
    pagereference pr;
    if(con.converted_to_Opportunity__c == true ||
       con.created_from_Opportunity__c == true){showpopup();}
    else{        
    pr = processcontinue();
    }

    return pr;
   
    
}

    public pagereference processcontinue(){
    insert newopp;
    pagereference pr = new pagereference('/' + newopp.id + '/e?retURL=' + newopp.id);
    con.converted_to_Opportunity__c = true;
    update con;
    return pr;   
    }
    
    public pagereference processcancel(){
    pagereference pr = new pagereference('/' + con.id);
    return pr;   
    }
    public boolean displayPopup {get; set;}
 
    public void closePopup() {
        displayPopup = false;
    }
 
    public pagereference showPopup() {
        displayPopup = true;
        return null;
    }
    

}
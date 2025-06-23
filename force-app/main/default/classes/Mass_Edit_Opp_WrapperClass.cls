public class Mass_Edit_Opp_WrapperClass
{
    public Opportunity opp{get;set;}
    public string selectedStage;
    public String selectedSalesPriority;
    public String selectedAshSupplier;
    public String selectedReasonWonLost;
    public String selectedCustomerMarket;
    public String selectedProductFamily;
    public String selectedProductSubFamily;
    public String selectedPrimaryWonLost;
    public String selectedSecondaryWonLost;
    
    public void setSelectedStage(String s){
        this.selectedStage = s;
        this.opp.StageName = selectedStage;
    }
    public String getSelectedStage(){
        return selectedStage;
    }
    
    public void setSelectedSalesPriority(String s){
        this.selectedSalesPriority = s;
        this.opp.Sales_Priority__c = selectedSalesPriority;
    }
    public String getSelectedSalesPriority(){
        return selectedSalesPriority;
    }
        
    public void setSelectedAshSupplier(String s){
        this.selectedAshSupplier = s;
        this.opp.Ashland_Supplier__c = selectedAshSupplier;
    }
    public String getSelectedAshSupplier(){
        return selectedAshSupplier;
    }
    
    public void setSelectedReasonWonLost(String s){
        this.selectedReasonWonLost = s;
        this.opp.T_Reason_Won_Lost__c = selectedReasonWonLost;
    }
    public String getSelectedReasonWonLost(){
        return selectedReasonWonLost;
    }
    
    public void setSelectedCustomerMarket(String s){
        this.selectedCustomerMarket = s;
        this.opp.T_Market__c = selectedCustomerMarket;
    }
    public String getSelectedCustomerMarket(){
        return selectedCustomerMarket;
    }
    
    public void setSelectedProductFamily(String s){
        this.selectedProductFamily = s;
        this.Opp.T_ProductFamily__c = selectedProductFamily;
    }
    public String getSelectedProductFamily(){
        return selectedProductFamily;
    }
    public void setSelectedProductSubFamily(String s){
        this.selectedProductSubFamily = s;
        this.Opp.Product_Sub_Family__c = selectedProductSubFamily;
    }
    public String getSelectedProductSubFamily(){
        return selectedProductSubFamily;
    }
    public void setSelectedPrimaryWonLost(String s){
        this.selectedPrimaryWonlost = s;
        this.Opp.W_Primary_Won_Lost_Reason__c = selectedPrimaryWonLost;
    }
    public String getSelectedPrimaryWonLost(){
        return selectedPrimaryWonlost;
    }
    public void setSelectedSecondaryWonLost(String s){
        this.selectedSecondaryWonlost = s;
        this.Opp.W_Secondary_Won_Lost_Reason__c = selectedSecondaryWonLost;
    }
    public String getSelectedSecondaryWonLost(){
        return selectedSecondaryWonlost;
    }
    
    public Mass_Edit_Opp_WrapperClass(Opportunity o, String selStage, String selSalesPriority,
                                      String selAshSupplier, String selReasonWonLost, String selCustomerMarket, 
                                      String selProductFamily, String selProductSubFamily, 
                                      String selPrimaryWonLost, String selSecondaryWonLost)
    {
    	if (o.Amount == null) {o.Amount = 0.0;}
        this.opp = o;
        this.selectedStage = selStage;
        this.selectedSalesPriority = selSalesPriority;
        this.selectedAshSupplier = selAshSupplier;
        this.selectedReasonWonLost = selReasonWonLost;
        this.selectedCustomerMarket = selCustomerMarket;
        this.selectedProductFamily = selProductFamily;
        this.selectedProductSubFamily = selProductSubFamily;
        this.selectedPrimaryWonLost = selPrimaryWonLost;
        this.selectedSecondaryWonLost = selSecondaryWonLost;
    }
    
}
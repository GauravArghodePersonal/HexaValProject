public class Account_Sales_Info {

    private final static Date START_DATE = Rolling_Product_Sales_Info.START_DATE;
    
    private String accountId;
    private Rolling_Product_Sales_Info__c rpsi;
    
    public Account_Sales_Info(){init1();}
    
    public Account_Sales_Info(String accId) {accountId = accId; init1();}
    
    public String accountType  {get; private set;}     
    public String currencyCode {get; private set;}     
    @AuraEnabled
    public String FYF_Label { 
        get {return Rolling_Product_Sales_Info.FYF_Label;} 
    }
    @AuraEnabled
    public String PFYF_Label { 
        get {return Rolling_Product_Sales_Info.PFYF_Label;} 
    }
    @AuraEnabled
    public String FYTD_Label { 
        get {return Rolling_Product_Sales_Info.FYTD_Label;} 
    }
    @AuraEnabled
    public String PFYTD_Label { 
        get {return Rolling_Product_Sales_Info.PFYTD_Label;} 
    }
    @AuraEnabled
    public String FYTDvsPFYTD_Label { 
        get{return 'FYTD vs PFYTD Variance';} 
    }
    @AuraEnabled    
    public String FYTDvsPFYTD_Percent_Label { 
        get{return FYTDvsPFYTD_Label + ' %';} 
    }
        
/*--------------------------------------------------------------------------------------------
    Sales Amount 
----------------------------------------------------------------------------------------------*/
    private Decimal FYF_Amount, FYTD_Amount, PFYF_Amount, PFYTD_Amount;     

    private Double  FYTDvsPFYTD_Amount_Variance {
        get {return getVariance(FYTD_Amount, PFYTD_Amount);}
    }

    private Double  FYTDvsPFYTD_Amount_VPercent {
        get {return getVPercent(FYTD_Amount, PFYTD_Amount);}
    }
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_Amount_Up {
        get {return isPositive(FYTDvsPFYTD_Amount_Variance);}
    }                                                    
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_Amount_Down {
        get {return isNegative(FYTDvsPFYTD_Amount_Variance);}
    }                                                    
    @AuraEnabled
    public String FYF_Amount_formatted {
        get {return getString(FYF_Amount, currencyCode);} 
    }     
    @AuraEnabled
    public String FYTD_Amount_formatted {
        get {return getString(FYTD_Amount, currencyCode);} 
    }     
    @AuraEnabled
    public String PFYF_Amount_formatted {
        get {return getString(PFYF_Amount, currencyCode);} 
    }     
    @AuraEnabled
    public String PFYTD_Amount_formatted {
        get {return getString(PFYTD_Amount, currencyCode);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Amount_Variance_formatted {
        get {return getString(FYTDvsPFYTD_Amount_Variance, currencyCode);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Amount_VPercent_formatted {
        get {return formatPercent(FYTDvsPFYTD_Amount_VPercent);} 
    }     
    @AuraEnabled
    public String FYF_Amount_style { 
        get {return getStyle(FYF_Amount);} 
    }     
    @AuraEnabled
    public String FYTD_Amount_style { 
        get {return getStyle(FYTD_Amount);} 
    }     
    @AuraEnabled
    public String PFYTD_Amount_style { 
        get {return getStyle(PFYTD_Amount);} 
    }     
    @AuraEnabled
    public String PFYF_Amount_style { 
        get {return getStyle(PFYF_Amount);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Amount_Variance_style { 
        get {return getStyle(FYTDvsPFYTD_Amount_Variance);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Amount_VPercent_style { 
        get {return getStyle(FYTDvsPFYTD_Amount_VPercent);} 
    }     

/*--------------------------------------------------------------------------------------------
    Plan Amount
----------------------------------------------------------------------------------------------*/

    private Decimal FYF_Plan_Amount, FYTD_Plan_Amount, PFYF_Plan_Amount, PFYTD_Plan_Amount;     

    private Double  FYTDvsPFYTD_Plan_Amount_Variance {
        get {return getVariance(FYTD_Plan_Amount, PFYTD_Plan_Amount);}
    }

    private Double  FYTDvsPFYTD_Plan_Amount_VPercent {
        get {return getVPercent(FYTD_Plan_Amount, PFYTD_Plan_Amount);}
    }
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_Plan_Amount_Up {
        get {return isPositive(FYTDvsPFYTD_Plan_Amount_Variance);}
    }                                                    
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_Plan_Amount_Down {
        get {return isNegative(FYTDvsPFYTD_Plan_Amount_Variance);}
    }                                                    
    @AuraEnabled
    public String FYF_Plan_Amount_formatted {
        get {return getString(FYF_Plan_Amount, currencyCode);} 
    }     
    @AuraEnabled
    public String FYTD_Plan_Amount_formatted {
        get {return getString(FYTD_Plan_Amount, currencyCode);} 
    }     
    @AuraEnabled
    public String PFYF_Plan_Amount_formatted {
        get {return getString(PFYF_Plan_Amount, currencyCode);} 
    }     
    @AuraEnabled
    public String PFYTD_Plan_Amount_formatted {
        get {return getString(PFYTD_Plan_Amount, currencyCode);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Plan_Amount_Variance_formatted {
        get {return getString(FYTDvsPFYTD_Plan_Amount_Variance, currencyCode);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Plan_Amount_VPercent_formatted {
        get {return formatPercent(FYTDvsPFYTD_Plan_Amount_VPercent);} 
    }     
    @AuraEnabled
    public String FYF_Plan_Amount_style { 
        get {return getStyle(FYF_Plan_Amount);} 
    }     
    @AuraEnabled
    public String FYTD_Plan_Amount_style { 
        get {return getStyle(FYTD_Plan_Amount);} 
    }     
    @AuraEnabled
    public String PFYTD_Plan_Amount_style { 
        get {return getStyle(PFYTD_Plan_Amount);} 
    }     
    @AuraEnabled
    public String PFYF_Plan_Amount_style { 
        get {return getStyle(PFYF_Plan_Amount);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Plan_Amount_Variance_style { 
        get {return getStyle(FYTDvsPFYTD_Plan_Amount_Variance);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Plan_Amount_VPercent_style { 
        get {return getStyle(FYTDvsPFYTD_Plan_Amount_VPercent);} 
    }     

/*--------------------------------------------------------------------------------------------
    Sales Volume in KGs 
----------------------------------------------------------------------------------------------*/

    private Double  FYF_Volume_in_KG, FYTD_Volume_in_KG, PFYF_Volume_in_KG, PFYTD_Volume_in_KG;     

    private Double  FYTDvsPFYTD_Volume_in_KG_Variance {
        get {return getVariance(FYTD_Volume_in_KG, PFYTD_Volume_in_KG);}
    }

    private Double  FYTDvsPFYTD_Volume_in_KG_VPercent {
        get {return getVPercent(FYTD_Volume_in_KG, PFYTD_Volume_in_KG);}
    }
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_Volume_in_KG_Up {
        get {return isPositive(FYTDvsPFYTD_Volume_in_KG_Variance);}
    }                                                    
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_Volume_in_KG_Down {
        get {return isNegative(FYTDvsPFYTD_Volume_in_KG_Variance);}
    }                                                    
    @AuraEnabled
    public String FYF_Volume_in_KG_formatted {
        get {return getString(FYF_Volume_in_KG);} 
    }     
    @AuraEnabled
    public String FYTD_Volume_in_KG_formatted {
        get {return getString(FYTD_Volume_in_KG);} 
    }     
    @AuraEnabled
    public String PFYF_Volume_in_KG_formatted {
        get {return getString(PFYF_Volume_in_KG);} 
    }     
    @AuraEnabled
    public String PFYTD_Volume_in_KG_formatted {
        get {return getString(PFYTD_Volume_in_KG);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Volume_in_KG_Variance_formatted {
        get {return getString(FYTDvsPFYTD_Volume_in_KG_Variance);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Volume_in_KG_VPercent_formatted {
        get {return formatPercent(FYTDvsPFYTD_Volume_in_KG_VPercent);} 
    }     
    @AuraEnabled
    public String FYF_Volume_in_KG_style { 
        get {return getStyle(FYF_Volume_in_KG);} 
    }     
    @AuraEnabled
    public String FYTD_Volume_in_KG_style { 
        get {return getStyle(FYTD_Volume_in_KG);} 
    }     
    @AuraEnabled
    public String PFYF_Volume_in_KG_style { 
        get {return getStyle(PFYF_Volume_in_KG);} 
    }     
    @AuraEnabled
    public String PFYTD_Volume_in_KG_style { 
        get {return getStyle(PFYTD_Volume_in_KG);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Volume_in_KG_Variance_style { 
        get {return getStyle(FYTDvsPFYTD_Volume_in_KG_Variance);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Volume_in_KG_VPercent_style { 
        get {return getStyle(FYTDvsPFYTD_Volume_in_KG_VPercent);} 
    } 

/*--------------------------------------------------------------------------------------------
    Plan Volume in KGs 
----------------------------------------------------------------------------------------------*/

    private Double  FYF_Plan_Volume_in_KG, FYTD_Plan_Volume_in_KG, 
                    PFYF_Plan_Volume_in_KG, PFYTD_Plan_Volume_in_KG;     

    private Double  FYTDvsPFYTD_Plan_Volume_in_KG_Variance {
        get {return getVariance(FYTD_Plan_Volume_in_KG, PFYTD_Plan_Volume_in_KG);}
    }

    private Double  FYTDvsPFYTD_Plan_Volume_in_KG_VPercent {
        get {return getVPercent(FYTD_Plan_Volume_in_KG, PFYTD_Plan_Volume_in_KG);}
    }
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_Plan_Volume_in_KG_Up {
        get {return isPositive(FYTDvsPFYTD_Plan_Volume_in_KG_Variance);}
    }                                                    
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_Plan_Volume_in_KG_Down {
        get {return isNegative(FYTDvsPFYTD_Plan_Volume_in_KG_Variance);}
    }                                                    
    @AuraEnabled
    public String FYF_Plan_Volume_in_KG_formatted {
        get {return getString(FYF_Plan_Volume_in_KG);} 
    }     
    @AuraEnabled
    public String FYTD_Plan_Volume_in_KG_formatted {
        get {return getString(FYTD_Plan_Volume_in_KG);} 
    }     
    @AuraEnabled
    public String PFYF_Plan_Volume_in_KG_formatted {
        get {return getString(PFYF_Plan_Volume_in_KG);} 
    }     
    @AuraEnabled
    public String PFYTD_Plan_Volume_in_KG_formatted {
        get {return getString(PFYTD_Plan_Volume_in_KG);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Plan_Volume_in_KG_Variance_formatted {
        get {return getString(FYTDvsPFYTD_Plan_Volume_in_KG_Variance);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Plan_Volume_in_KG_VPercent_formatted {
        get {return formatPercent(FYTDvsPFYTD_Plan_Volume_in_KG_VPercent);} 
    }     
    @AuraEnabled
    public String FYF_Plan_Volume_in_KG_style { 
        get {return getStyle(FYF_Plan_Volume_in_KG);} 
    }     
    @AuraEnabled
    public String FYTD_Plan_Volume_in_KG_style { 
        get {return getStyle(FYTD_Plan_Volume_in_KG);} 
    }     
    @AuraEnabled
    public String PFYF_Plan_Volume_in_KG_style { 
        get {return getStyle(PFYF_Plan_Volume_in_KG);} 
    }     
    @AuraEnabled
    public String PFYTD_Plan_Volume_in_KG_style { 
        get {return getStyle(PFYTD_Plan_Volume_in_KG);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Plan_Volume_in_KG_Variance_style { 
        get {return getStyle(FYTDvsPFYTD_Plan_Volume_in_KG_Variance);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Plan_Volume_in_KG_VPercent_style { 
        get {return getStyle(FYTDvsPFYTD_Plan_Volume_in_KG_VPercent);} 
    }     

/*--------------------------------------------------------------------------------------------
    Sales Volume in LBs 
----------------------------------------------------------------------------------------------*/

    private Double  FYF_Volume_in_LB, FYTD_Volume_in_LB, PFYF_Volume_in_LB, PFYTD_Volume_in_LB;     

    private Double  FYTDvsPFYTD_Volume_in_LB_Variance {
        get {return getVariance(FYTD_Volume_in_LB, PFYTD_Volume_in_LB);}
    }

    private Double  FYTDvsPFYTD_Volume_in_LB_VPercent {
        get {return getVPercent(FYTD_Volume_in_LB, PFYTD_Volume_in_LB);}
    }
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_Volume_in_LB_Up {
        get {return isPositive(FYTDvsPFYTD_Volume_in_LB_Variance);}
    }                                                    
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_Volume_in_LB_Down {
        get {return isNegative(FYTDvsPFYTD_Volume_in_LB_Variance);}
    }                                                    
    @AuraEnabled
    public String FYF_Volume_in_LB_formatted { 
        get {return getString(FYF_Volume_in_LB);} 
    }     
    @AuraEnabled
    public String FYTD_Volume_in_LB_formatted { 
        get {return getString(FYTD_Volume_in_LB);} 
    }     
    @AuraEnabled
    public String PFYF_Volume_in_LB_formatted { 
        get {return getString(PFYF_Volume_in_LB);} 
    }     
    @AuraEnabled
    public String PFYTD_Volume_in_LB_formatted { 
        get {return getString(PFYTD_Volume_in_LB);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Volume_in_LB_Variance_formatted { 
        get {return getString(FYTDvsPFYTD_Volume_in_LB_Variance);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Volume_in_LB_VPercent_formatted { 
        get {return formatPercent(FYTDvsPFYTD_Volume_in_LB_VPercent);} 
    }     
    @AuraEnabled
    public String FYF_Volume_in_LB_style { 
        get {return getStyle(FYF_Volume_in_LB);} 
    }     
    @AuraEnabled
    public String FYTD_Volume_in_LB_style { 
        get {return getStyle(FYTD_Volume_in_LB);} 
    }     
    @AuraEnabled
    public String PFYF_Volume_in_LB_style { 
        get {return getStyle(PFYF_Volume_in_LB);} 
    }     
    @AuraEnabled
    public String PFYTD_Volume_in_LB_style { 
        get {return getStyle(PFYTD_Volume_in_LB);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Volume_in_LB_Variance_style { 
        get {return getStyle(FYTDvsPFYTD_Volume_in_LB_Variance);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Volume_in_LB_VPercent_style { 
        get {return getStyle(FYTDvsPFYTD_Volume_in_LB_VPercent);} 
    }     

/*--------------------------------------------------------------------------------------------
    Plan Volume in LBs 
----------------------------------------------------------------------------------------------*/

    private Double  FYF_Plan_Volume_in_LB, FYTD_Plan_Volume_in_LB,
                    PFYF_Plan_Volume_in_LB, PFYTD_Plan_Volume_in_LB;     

    private Double  FYTDvsPFYTD_Plan_Volume_in_LB_Variance {
        get {return getVariance(FYTD_Plan_Volume_in_LB, PFYTD_Plan_Volume_in_LB);}
    }

    private Double  FYTDvsPFYTD_Plan_Volume_in_LB_VPercent {
        get {return getVPercent(FYTD_Plan_Volume_in_LB, PFYTD_Plan_Volume_in_LB);}
    }
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_Plan_Volume_in_LB_Up {
        get {return isPositive(FYTDvsPFYTD_Plan_Volume_in_LB_Variance);}
    }                                                    
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_Plan_Volume_in_LB_Down {
        get {return isNegative(FYTDvsPFYTD_Plan_Volume_in_LB_Variance);}
    }                                                    
    @AuraEnabled
    public String FYF_Plan_Volume_in_LB_formatted { 
        get {return getString(FYF_Plan_Volume_in_LB);} 
    }     
    @AuraEnabled
    public String FYTD_Plan_Volume_in_LB_formatted { 
        get {return getString(FYTD_Plan_Volume_in_LB);} 
    }     
    @AuraEnabled
    public String PFYF_Plan_Volume_in_LB_formatted { 
        get {return getString(PFYF_Plan_Volume_in_LB);} 
    }     
    @AuraEnabled
    public String PFYTD_Plan_Volume_in_LB_formatted { 
        get {return getString(PFYTD_Plan_Volume_in_LB);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Plan_Volume_in_LB_Variance_formatted { 
        get {return getString(FYTDvsPFYTD_Plan_Volume_in_LB_Variance);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Plan_Volume_in_LB_VPercent_formatted { 
        get {return formatPercent(FYTDvsPFYTD_Plan_Volume_in_LB_VPercent);} 
    }     
    @AuraEnabled
    public String FYF_Plan_Volume_in_LB_style { 
        get {return getStyle(FYF_Plan_Volume_in_LB);} 
    }     
    @AuraEnabled
    public String FYTD_Plan_Volume_in_LB_style { 
        get {return getStyle(FYTD_Plan_Volume_in_LB);} 
    }     
    @AuraEnabled
    public String PFYF_Plan_Volume_in_LB_style { 
        get {return getStyle(PFYF_Plan_Volume_in_LB);} 
    }     
    @AuraEnabled
    public String PFYTD_Plan_Volume_in_LB_style { 
        get {return getStyle(PFYTD_Plan_Volume_in_LB);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Plan_Volume_in_LB_Variance_style { 
        get {return getStyle(FYTDvsPFYTD_Plan_Volume_in_LB_Variance);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Plan_Volume_in_LB_VPercent_style { 
        get {return getStyle(FYTDvsPFYTD_Plan_Volume_in_LB_VPercent);} 
    }     

/*--------------------------------------------------------------------------------------------
    Sales Volume in Gallons 
----------------------------------------------------------------------------------------------*/

    private Double  FYTD_Volume_in_GL, PFYTD_Volume_in_GL;     

    private Double  FYTDvsPFYTD_Volume_in_GL_Variance {
        get {return getVariance(FYTD_Volume_in_GL, PFYTD_Volume_in_GL);}
    }

    private Double  FYTDvsPFYTD_Volume_in_GL_VPercent {
        get {return getVPercent(FYTD_Volume_in_GL, PFYTD_Volume_in_GL);}
    }
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_Volume_in_GL_Up {
        get {return isPositive(FYTDvsPFYTD_Volume_in_GL_Variance);}
    }                                                    
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_Volume_in_GL_Down {
        get {return isNegative(FYTDvsPFYTD_Volume_in_GL_Variance);}
    }                                                    
    @AuraEnabled
    public String FYTD_Volume_in_GL_formatted { 
        get {return getString(FYTD_Volume_in_GL);} 
    }     
    @AuraEnabled
    public String PFYTD_Volume_in_GL_formatted { 
        get {return getString(PFYTD_Volume_in_GL);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Volume_in_GL_Variance_formatted { 
        get {return getString(FYTDvsPFYTD_Volume_in_GL_Variance);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Volume_in_GL_VPercent_formatted { 
        get {return formatPercent(FYTDvsPFYTD_Volume_in_GL_VPercent);} 
    }     
    @AuraEnabled
    public String FYTD_Volume_in_GL_style { 
        get {return getStyle(FYTD_Volume_in_GL);} 
    }     
    @AuraEnabled
    public String PFYTD_Volume_in_GL_style { 
        get {return getStyle(PFYTD_Volume_in_GL);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Volume_in_GL_Variance_style { 
        get {return getStyle(FYTDvsPFYTD_Volume_in_GL_Variance);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Volume_in_GL_VPercent_style { 
        get {return getStyle(FYTDvsPFYTD_Volume_in_GL_VPercent);} 
    }     

/*--------------------------------------------------------------------------------------------
    Sales Volume in Points 
----------------------------------------------------------------------------------------------*/

    private Double  FYTD_Volume_in_PT, PFYTD_Volume_in_PT;     

    private Double  FYTDvsPFYTD_Volume_in_PT_Variance {
        get {return getVariance(FYTD_Volume_in_PT, PFYTD_Volume_in_PT);}
    }

    private Double  FYTDvsPFYTD_Volume_in_PT_VPercent {
        get {return getVPercent(FYTD_Volume_in_PT, PFYTD_Volume_in_PT);}
    }
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_Volume_in_PT_Up {
        get {return isPositive(FYTDvsPFYTD_Volume_in_PT_Variance);}
    }                                                    
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_Volume_in_PT_Down {
        get {return isNegative(FYTDvsPFYTD_Volume_in_PT_Variance);}
    }                                                    
    @AuraEnabled
    public String FYTD_Volume_in_PT_formatted { 
        get {return getString(FYTD_Volume_in_PT);} 
    }     
    @AuraEnabled
    public String PFYTD_Volume_in_PT_formatted { 
        get {return getString(PFYTD_Volume_in_PT);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Volume_in_PT_Variance_formatted { 
        get {return getString(FYTDvsPFYTD_Volume_in_PT_Variance);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Volume_in_PT_VPercent_formatted { 
        get {return formatPercent(FYTDvsPFYTD_Volume_in_PT_VPercent);} 
    }     
    @AuraEnabled
    public String FYTD_Volume_in_PT_style { 
        get {return getStyle(FYTD_Volume_in_PT);} 
    }     
    @AuraEnabled
    public String PFYTD_Volume_in_PT_style { 
        get {return getStyle(PFYTD_Volume_in_PT);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Volume_in_PT_Variance_style { 
        get {return getStyle(FYTDvsPFYTD_Volume_in_PT_Variance);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Volume_in_PT_VPercent_style { 
        get {return getStyle(FYTDvsPFYTD_Volume_in_PT_VPercent);} 
    }     

/*--------------------------------------------------------------------------------------------
    Sales Volume in Units 
----------------------------------------------------------------------------------------------*/

    private Double  FYTD_Volume_in_UN, PFYTD_Volume_in_UN;     

    private Double  FYTDvsPFYTD_Volume_in_UN_Variance {
        get {return getVariance(FYTD_Volume_in_UN, PFYTD_Volume_in_UN);}
    }

    private Double  FYTDvsPFYTD_Volume_in_UN_VPercent {
        get {return getVPercent(FYTD_Volume_in_UN, PFYTD_Volume_in_UN);}
    }
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_Volume_in_UN_Up {
        get {return isPositive(FYTDvsPFYTD_Volume_in_UN_Variance);}
    }                                                    
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_Volume_in_UN_Down {
        get {return isNegative(FYTDvsPFYTD_Volume_in_UN_Variance);}
    }                                                    
    @AuraEnabled
    public String FYTD_Volume_in_UN_formatted { 
        get {return getString(FYTD_Volume_in_UN);} 
    }     
    @AuraEnabled
    public String PFYTD_Volume_in_UN_formatted { 
        get {return getString(PFYTD_Volume_in_UN);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Volume_in_UN_Variance_formatted { 
        get {return getString(FYTDvsPFYTD_Volume_in_UN_Variance);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Volume_in_UN_VPercent_formatted { 
        get {return formatPercent(FYTDvsPFYTD_Volume_in_UN_VPercent);} 
    }     
    @AuraEnabled
    public String FYTD_Volume_in_UN_style { 
        get {return getStyle(FYTD_Volume_in_UN);} 
    }     
    @AuraEnabled
    public String PFYTD_Volume_in_UN_style { 
        get {return getStyle(PFYTD_Volume_in_UN);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Volume_in_UN_Variance_style { 
        get {return getStyle(FYTDvsPFYTD_Volume_in_UN_Variance);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_Volume_in_UN_VPercent_style { 
        get {return getStyle(FYTDvsPFYTD_Volume_in_UN_VPercent);} 
    }     

/*--------------------------------------------------------------------------------------------
    Gross Margin / Gross Profit 
----------------------------------------------------------------------------------------------*/

    private Decimal FYTD_GM, PFYTD_GM;     

    private Double  FYTDvsPFYTD_GM_Variance {
        get {return getVariance(FYTD_GM, PFYTD_GM);}
    }

    private Double  FYTDvsPFYTD_GM_VPercent {
        get {return getVPercent(FYTD_GM, PFYTD_GM);}
    }
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_GM_Up {
        get {return isPositive(FYTDvsPFYTD_GM_Variance);}
    }                                                    
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_GM_Down {
        get {return isNegative(FYTDvsPFYTD_GM_Variance);}
    }                                                    
    @AuraEnabled
    public String FYTD_GM_formatted { 
        get {return getString(FYTD_GM, currencyCode);} 
    }     
    @AuraEnabled
    public String PFYTD_GM_formatted { 
        get {return getString(PFYTD_GM, currencyCode);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_GM_Variance_formatted { 
        get {return getString(FYTDvsPFYTD_GM_Variance, currencyCode);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_GM_VPercent_formatted { 
        get {return formatPercent(FYTDvsPFYTD_GM_VPercent);} 
    }     
    @AuraEnabled
    public String FYTD_GM_style { 
        get {return getStyle(FYTD_GM);} 
    }     
    @AuraEnabled
    public String PFYTD_GM_style { 
        get {return getStyle(PFYTD_GM);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_GM_Variance_style { 
        get {return getStyle(FYTDvsPFYTD_GM_Variance);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_GM_VPercent_style { 
        get {return getStyle(FYTDvsPFYTD_GM_VPercent);} 
    }     
    
/*--------------------------------------------------------------------------------------------
    Gross Margin / Gross Profit % 
----------------------------------------------------------------------------------------------*/

    private Double  FYTD_GMpct, PFYTD_GMpct;     

    private Double  FYTDvsPFYTD_GMpct_Variance {
        get {return getVariance(FYTD_GMpct, PFYTD_GMpct);}
    }

    private Double  FYTDvsPFYTD_GMpct_VPercent {
        get {return getVPercent(FYTD_GMpct, PFYTD_GMpct);}
    }
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_GMpct_Up {
        get {return isPositive(FYTDvsPFYTD_GMpct_Variance);}
    }                                                    
    @AuraEnabled
    public Boolean  FYTDvsPFYTD_GMpct_Down {
        get {return isNegative(FYTDvsPFYTD_GMpct_Variance);}
    }                                                    
    @AuraEnabled
    public String FYTD_GMpct_formatted { 
        get {return formatPercent(FYTD_GMpct);} 
    }     
    @AuraEnabled 
    public String PFYTD_GMpct_formatted { 
        get {return formatPercent(PFYTD_GMpct);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_GMpct_Variance_formatted { 
        get {return formatPercent(FYTDvsPFYTD_GMpct_Variance);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_GMpct_VPercent_formatted { 
        get {return formatPercent(FYTDvsPFYTD_GMpct_VPercent);} 
    }     
    @AuraEnabled
    public String FYTD_GMpct_style { 
        get {return getStyle(FYTD_GMpct);} 
    }     
    @AuraEnabled
    public String PFYTD_GMpct_style { 
        get {return getStyle(PFYTD_GMpct);} 
    }     
    @AuraEnabled
    public String FYTDvsPFYTD_GMpct_Variance_style { 
        get {return getStyle(FYTDvsPFYTD_GMpct_Variance);} 
    }
    @AuraEnabled
    public String FYTDvsPFYTD_GMpct_VPercent_style { 
        get {return getStyle(FYTDvsPFYTD_GMpct_VPercent);} 
    }
    
/*--------------------------------------------------------------------------------------------
    Sales to Plan Variance - Amount 
----------------------------------------------------------------------------------------------*/
    private Double  S2P_FYTD_Amount_Variance {
        get {return getVariance(FYTD_Amount, FYTD_Plan_Amount);}
    }

    private Double  S2P_FYTD_Amount_VPercent {
        get {return getVPercent(FYTD_Amount, FYTD_Plan_Amount);}
    }
    @AuraEnabled
    public String S2P_FYTD_Amount_Variance_formatted {
        get {return getString(S2P_FYTD_Amount_Variance, currencyCode);} 
    }     
    @AuraEnabled
    public String S2P_FYTD_Amount_VPercent_formatted {
        get {return formatPercent(S2P_FYTD_Amount_VPercent);} 
    }     
    @AuraEnabled
    public String S2P_FYTD_Amount_Variance_style { 
        get {return getStyle(S2P_FYTD_Amount_Variance);} 
    }     
    @AuraEnabled
    public String S2P_FYTD_Amount_VPercent_style { 
        get {return getStyle(S2P_FYTD_Amount_VPercent);} 
    }     

/*--------------------------------------------------------------------------------------------
    Sales to Plan Variance - Volume in LBs 
----------------------------------------------------------------------------------------------*/
    private Double  S2P_FYTD_VLB_Variance {
        get {return getVariance(FYTD_Volume_in_LB, FYTD_Plan_Volume_in_LB);}
    }

    private Double  S2P_FYTD_VLB_VPercent {
        get {return getVPercent(FYTD_Volume_in_LB, FYTD_Plan_Volume_in_LB);}
    }
    @AuraEnabled
    public String S2P_FYTD_VLB_Variance_formatted {
        get {return getString(S2P_FYTD_VLB_Variance);} 
    }     
    @AuraEnabled
    public String S2P_FYTD_VLB_VPercent_formatted {
        get {return formatPercent(S2P_FYTD_VLB_VPercent);} 
    }     
    @AuraEnabled
    public String S2P_FYTD_VLB_Variance_style { 
        get {return getStyle(S2P_FYTD_VLB_Variance);} 
    }     
    @AuraEnabled
    public String S2P_FYTD_VLB_VPercent_style { 
        get {return getStyle(S2P_FYTD_VLB_VPercent);} 
    }     

/*--------------------------------------------------------------------------------------------
    Sales to Plan Variance - Volume in KGs 
----------------------------------------------------------------------------------------------*/
    private Double  S2P_FYTD_VKG_Variance {
        get {return getVariance(FYTD_Volume_in_KG, FYTD_Plan_Volume_in_KG);}
    }

    private Double  S2P_FYTD_VKG_VPercent {
        get {return getVPercent(FYTD_Volume_in_KG, FYTD_Plan_Volume_in_KG);}
    }
    @AuraEnabled
    public String S2P_FYTD_VKG_Variance_formatted {
        get {return getString(S2P_FYTD_VKG_Variance);} 
    }     
    @AuraEnabled
    public String S2P_FYTD_VKG_VPercent_formatted {
        get {return formatPercent(S2P_FYTD_VKG_VPercent);} 
    }     
    @AuraEnabled
    public String S2P_FYTD_VKG_Variance_style { 
        get {return getStyle(S2P_FYTD_VKG_Variance);} 
    }     
    @AuraEnabled
    public String S2P_FYTD_VKG_VPercent_style { 
        get {return getStyle(S2P_FYTD_VKG_VPercent);} 
    }     

/*--------------------------------------------------------------------------------------------
 
----------------------------------------------------------------------------------------------*/
    private void init1() {
        rpsi = Rolling_Product_Sales_Info.getRPSI(accountId);
        if (rpsi == null) {return;}
        accountType             = rpsi.Account_Type__c;
        currencyCode            = rpsi.CurrencyIsoCode;

        FYF_Amount              = rpsi.Amount_FYF__c;
        FYF_Plan_Amount         = rpsi.Plan_Amount_FYF__c;
        FYF_Plan_Volume_in_KG   = rpsi.Plan_Volume_in_KG_FYF__c;
        FYF_Plan_Volume_in_LB   = rpsi.Plan_Volume_in_LB_FYF__c;
        FYF_Volume_in_KG        = rpsi.Volume_in_KG_FYF__c;
        FYF_Volume_in_LB        = rpsi.Volume_in_LB_FYF__c;

        FYTD_Amount             = rpsi.Amount_FYTD__c;
        FYTD_GM                 = rpsi.GM_FYTD__c;
        FYTD_GMpct              = rpsi.GMpct_FYTD__c;
        FYTD_Plan_Amount        = rpsi.Plan_Amount_FYTD__c;
        FYTD_Plan_Volume_in_KG  = rpsi.Plan_Volume_in_KG_FYTD__c;
        FYTD_Plan_Volume_in_LB  = rpsi.Plan_Volume_in_LB_FYTD__c;
        FYTD_Volume_in_GL       = rpsi.Volume_in_GL_FYTD__c;
        FYTD_Volume_in_KG       = rpsi.Volume_in_KG_FYTD__c;
        FYTD_Volume_in_LB       = rpsi.Volume_in_LB_FYTD__c;
        FYTD_Volume_in_PT       = rpsi.Volume_in_PT_FYTD__c;
        FYTD_Volume_in_UN       = rpsi.Volume_in_UN_FYTD__c;
        
        PFYF_Amount             = rpsi.Amount_PFYF__c;
        PFYF_Plan_Amount        = rpsi.Plan_Amount_PFYF__c;
        PFYF_Plan_Volume_in_KG  = rpsi.Plan_Volume_in_KG_PFYF__c;
        PFYF_Plan_Volume_in_LB  = rpsi.Plan_Volume_in_LB_PFYF__c;
        PFYF_Volume_in_KG       = rpsi.Volume_in_KG_PFYF__c;
        PFYF_Volume_in_LB       = rpsi.Volume_in_LB_PFYF__c;

        PFYTD_Amount            = rpsi.Amount_PFYTD__c;
        PFYTD_GM                = rpsi.GM_PFYTD__c;
        PFYTD_GMpct             = rpsi.GMpct_PFYTD__c;
        PFYTD_Plan_Amount       = rpsi.Plan_Amount_PFYTD__c;
        PFYTD_Plan_Volume_in_KG = rpsi.Plan_Volume_in_KG_PFYTD__c;
        PFYTD_Plan_Volume_in_LB = rpsi.Plan_Volume_in_LB_PFYTD__c;
        PFYTD_Volume_in_GL      = rpsi.Volume_in_GL_PFYTD__c;
        PFYTD_Volume_in_KG      = rpsi.Volume_in_KG_PFYTD__c;
        PFYTD_Volume_in_LB      = rpsi.Volume_in_LB_PFYTD__c;
        PFYTD_Volume_in_PT      = rpsi.Volume_in_PT_PFYTD__c;
        PFYTD_Volume_in_UN      = rpsi.Volume_in_UN_PFYTD__c;
    }     

    public void addData(String datatoUpdate,
                        Date startDate,
                        Date endDate,
                        Double volumeinLB,
                        Double volumeinKG,
                        Double volumeinUN,
                        Double volumeinGL,
                        Double volumeinPT,
                        Decimal amount,
                        Decimal gm,
                        Double GMpct,
                        String recCurrency) {
    }
    
    private Double getVariance(Decimal d1, Decimal d2) {
        return Rolling_Product_Sales_Info.getVariance(d1, d2);
    }

    private Double getVariance(Double d1, Double d2) {
        return Rolling_Product_Sales_Info.getVariance(d1, d2);
    }
    
    private Double getVPercent(Decimal d1, Decimal d2) {
        return Rolling_Product_Sales_Info.getVPercent(d1, d2);
    }

    private Double getVPercent(Double d1, Double d2) {
        return Rolling_Product_Sales_Info.getVPercent(d1, d2);
    }
    
    private Boolean isNegative(Double d) {
        return Rolling_Product_Sales_Info.isNegative(d);
    }
    
    private Boolean isPositive(Double d) {
        return Rolling_Product_Sales_Info.isPositive(d);
    }

    private String  getString(String s) {
        return Rolling_Product_Sales_Info.getString(s);
    }

    private String getString(Double d, Integer n, String u) {
        return Rolling_Product_Sales_Info.getString(d, n, u);
    }

    private String getString(Double d, String u) {return getString(d, 0, u);}

    private String getString(Double d, Integer n) {return getString(d, n, null);}

    private String getString(Double d) {return getString(d, 0);}

    private String getString(Decimal f, Integer n, String u) {
        return Rolling_Product_Sales_Info.getString(f, n, u);
    }

    private String getString(Decimal f, String u) {return getString(f, 0, u);}

    private String getString(Decimal f, Integer n) {return getString(f, n, null);}

    private String getString(Decimal f) {return getString(f, 0);}

    private String getString(String s, Date d1, Date d2) {
        return Rolling_Product_Sales_Info.getString(s, d1, d2);
    }
    
    private String formatPercent(Double d) {
        return Rolling_Product_Sales_Info.formatPercent(d);
    }

    private String formatPercent(Decimal f) {
        return Rolling_Product_Sales_Info.formatPercent(f);
    }

    private String getStyle(Double d) {
        return Rolling_Product_Sales_Info.getStyle(d);
    }

    private String getStyle(Decimal d) {
        return Rolling_Product_Sales_Info.getStyle(d);
    }

    private String getStyle(Integer n) {
        return Rolling_Product_Sales_Info.getStyle(n);
    }

}
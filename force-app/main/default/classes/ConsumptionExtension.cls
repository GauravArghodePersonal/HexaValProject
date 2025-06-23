public class ConsumptionExtension {

    private Consumption__c cons;
    ApexPages.StandardController stdCtrl;
    private String RecordTypeId, RecordTypeName; 
    
    /* String value for the Industry */
    String m_industry; 
    /* String value for the Product Function */
    String m_productFunction;  
    /* String value for the Brand Name*/
    String m_brandName; 
    /* String value for the Grade*/
    String m_grade;     
    /* String value for the Supplier*/
    String m_Supplier;            
    /* String value for the ChemClass*/
    String m_ChemClass; 
    /* String value for the Chem SubClass1*/
    String m_ChemSubClass1;
    /* String value for the Chem SubClass2*/
    String m_ChemSubClass2;
    /* String value for the SBU Product*/
    String m_SBUProduct;
    /* String value for the Other Brand Name*/
    String m_OtherBrandName;        

                
    // The extension constructor initializes the private member
    // variable cons by using the getRecord method from the standard
    // controller.
    public ConsumptionExtension(ApexPages.StandardController stdController) {
        this.cons = new Consumption__c();
        if (stdController != null) {
            this.cons = (Consumption__c)stdController.getRecord();
            stdCtrl = stdController;
        }
        SetRecordTypeIdAndName();  
        
        //Set the following if edit existing record
        if (cons.Name != null)
        {  
            setIndustry(cons.Industry__c);
            setProductFunction(cons.Product_Function__c);
            setBrandName(cons.Brand_Name__c);
            setGrade(cons.Grade__c); 
            setSupplier(cons.AQ_Supplier__c);
            setChemClass(cons.Chem_Class__c);
            setChemSubClass1(cons.Chem_SubClass1__c);
            setChemSubClass2(cons.Chem_SubClass2__c);
            setSBUProduct(cons.SBU_Product__c);                            
            setOtherBrandName(cons.Other_Brand_Name__c);
        }  
        else //New Record
        {
            cons.Price__c = 0;
            cons.Price_Information__c = 'Competitive price provided by customer';       
        }   
    }

    public PageReference save()
    {
        return stdCtrl.save();

    }
    
    public PageReference cancel()
    {
        return stdCtrl.cancel();
    }

    public string getRecordTypeId()
    {   return RecordTypeId;
    }
    public string getRecordTypeName()
    {   return RecordTypeName;
    }

    private void SetRecordTypeIdAndName() {
        RecordTypeName = ''; RecordTypeId = this.cons.RecordTypeId;
        if (RecordTypeId == null) {
            RecordTypeId = RecordType_Functions.getDefaultRecordTypeId('Consumption__c');
        }
        for (RecordType rt: [select id,name from recordtype where id = :recordtypeid]) {
            RecordTypeName = rt.name;
        }
    }
          
    //testing
    public String getConsumptionObject() {
        //return 'Consumption: ' + cons;
        if (m_grade != null)
            return m_grade;
        else
            return 'null';
    }

    
    /* Getter which dynamically generates the Industries from the Consumption_Competitive_Product__c object. */
    public List<SelectOption> getIndustries() {
    
        List<SelectOption> optionList = new List<SelectOption>();
        Set<String> IndustriesSet = new Set<String>();
        
        /* Add a null option to force the user to make a selection. */
        optionList.add(new SelectOption('','- None -'));

        /* Loop through the Consumption_Competitive_Product__c records creating distinct set 
         that will  be used to create a selectOption for each result with the product 
         function as the value and as the label displayed in the selectList */
    
        for (Consumption_Competitive_Product__c ccp: [SELECT Industry__c FROM Consumption_Competitive_Product__c 
          ORDER BY Industry__c]){
        
            IndustriesSet.add(ccp.Industry__c);
        
        }
        
        List<String> uniqueCustomObjectList = new List<String>(IndustriesSet);
        uniqueCustomObjectList.sort();
        
        for(integer i=0; i<uniqueCustomObjectList.size(); i++){
            optionList.add(new SelectOption(uniqueCustomObjectList[i],uniqueCustomObjectList[i]));
        }    

        return optionList;    
    
    }  
     
    /* Getter for the Industry value */
    public String getIndustry() { return this.m_industry; }

    /* Setter for the Industry value */
    public void setIndustry(String s) 
    { 
        if (s == null || s != this.m_industry)
        {
            m_productFunction = null;
            m_brandName = null;
            m_grade = null;
            m_Supplier = null;
            m_ChemClass = null;
            m_ChemSubClass1 = null;
            m_ChemSubClass2 = null;
            m_SBUProduct = null;
            m_OtherBrandName = null ;
        }
        
        this.m_industry = s; 
        cons.Industry__c = s; 
                
    }      
    
    /* Getter for the Product Function value */
    public String getProductFunction() { return this.m_productFunction; }

    /* Setter for the Product Function value */
    public void setProductFunction(String s) 
    {     

        if (s == null || s != this.m_productFunction)
        {
            m_brandName = null;
            m_grade = null;
            m_Supplier = null;
            m_ChemClass = null;
            m_ChemSubClass1 = null;
            m_ChemSubClass2 = null;
            m_SBUProduct = null;
            m_OtherBrandName = null ;           
        }    
        
        this.m_productFunction = s; 
        cons.Product_Function__c = s; 
            
    }
    
    /* Getter which dynamically generates the Product Functions from the Consumption_Competitive_Product__c object. */
    public List<SelectOption> getProductFunctions() {
    
      List<SelectOption> optionList = new List<SelectOption>();
      Set<String> ProductFunctionsSet = new Set<String>();
    
      /* Add a null option to force the user to make a selection. */
      optionList.add(new SelectOption('','- None -'));

      /* Loop through the Consumption_Competitive_Product__c records creating a selectOption
         for each result with the product function as the value and as the label
         displayed in the selectList */

        if (m_industry!= null)
        {
          for (Consumption_Competitive_Product__c ccp: [SELECT Product_Function__c FROM Consumption_Competitive_Product__c 
              WHERE Industry__c = :m_industry ORDER BY Product_Function__c]){
            
            ProductFunctionsSet.add(ccp.Product_Function__c);        
          }        
        }

        List<String> uniqueCustomObjectList = new List<String>(ProductFunctionsSet);
        uniqueCustomObjectList.sort();
        
        for(integer i=0; i<uniqueCustomObjectList.size(); i++){
            if (uniqueCustomObjectList[i] == null)
                optionList.add(new SelectOption('',''));
            else
                optionList.add(new SelectOption(uniqueCustomObjectList[i],uniqueCustomObjectList[i]));
        }    
      return optionList;    
    
    }    

    /* Getter for the Brand Name value */
    public String getBrandName() { return this.m_brandName; }

    /* Setter for the Brand Name value */
    public void setBrandName(String s) 
    { 
        this.m_brandName= s; 
        cons.Brand_Name__c = s; 
        if (m_brandName== null)
        {
            m_grade = null;
            m_Supplier = null;
            m_ChemClass = null;
            m_ChemSubClass1 = null;
            m_ChemSubClass2 = null;
            m_SBUProduct = null;
            m_OtherBrandName = null ;
        
        } 
        else        
            GetCompetitiveDataForSelectedIndustryProdFuncBrand();
    }

    /* Getter which dynamically generates the Brand Name from the Consumption_Competitive_Product__c object. */
    public List<SelectOption> getBrandNames() {
    
        List<SelectOption> optionList = new List<SelectOption>();
        Set<String> BrandNameSet = new Set<String>();
        
        /* Add a null option to force the user to make a selection. */
        optionList.add(new SelectOption('','- None -'));
        
        if (m_productFunction == null)
            m_productFunction = '';
        
        
        for (Consumption_Competitive_Product__c ccp: [SELECT Brand_Name__c FROM Consumption_Competitive_Product__c 
           WHERE Industry__c = :m_industry and Product_Function__c = :m_productFunction  ORDER BY Brand_Name__c]){
        
            BrandNameSet.add(ccp.Brand_Name__c); 
        }   
                   
             
        List<String> uniqueCustomObjectList = new List<String>(BrandNameSet);
        uniqueCustomObjectList.sort();
        
        for(integer i=0; i<uniqueCustomObjectList.size(); i++){
            optionList.add(new SelectOption(uniqueCustomObjectList[i],uniqueCustomObjectList[i]));
        }          
      
        return optionList;    
    
    }
    
    /* Getter for the Grade value */
    public String getGrade() { return this.m_grade; }
    
    /* Setter for the Grade value */
    public void setGrade(String s) { this.m_grade= s; cons.Grade__c = s; }

    /* Getter for the Supplier value */
    public String getSupplier() { return this.m_Supplier; }
    
    /* Setter for the Supplier value */
    public void setSupplier(String s) { this.m_Supplier= s; cons.AQ_Supplier__c = s; }

    /* Getter for the Chem Class value */
    public String getChemClass() { return this.m_ChemClass; }
    
    /* Setter for the Chem Class value */
    public void setChemClass(String s) { this.m_ChemClass= s; cons.Chem_Class__c = s; }
    
    /* Getter for the Chem SubClass1 value */
    public String getChemSubClass1() { return this.m_ChemSubClass1 ; }
    
    /* Setter for the Chem SubClass1 value */
    public void setChemSubClass1(String s) { this.m_ChemSubClass1 = s; cons.Chem_SubClass1__c = s; }
    
    /* Getter for the Chem SubClass2 value */
    public String getChemSubClass2() { return this.m_ChemSubClass2 ; }
    
    /* Setter for the Chem SubClass2 value */
    public void setChemSubClass2(String s) { this.m_ChemSubClass2 = s; cons.Chem_SubClass2__c = s; }
            
    /* Getter for the Chem SBUProduct value */
    public String getSBUProduct() { return this.m_SBUProduct ; }
    
    /* Setter for the Chem SBUProduct value */
    public void setSBUProduct(String s) { this.m_SBUProduct = s; cons.SBU_Product__c = s; }
    
    /* Getter for the Other Brand Name value */
    public String getOtherBrandName() { return this.m_OtherBrandName ; }
    
    /* Setter for the Other Brand Name value */
    public void setOtherBrandName(String s) { this.m_OtherBrandName = s; cons.Other_Brand_Name__c = s; }    


    private void GetCompetitiveDataForSelectedIndustryProdFuncBrand()
    {
            for (Consumption_Competitive_Product__c ccp: 
                [SELECT SBU_Product__c, Grade__c, Supplier__c, Chem_Class__c, Chem_SubClass1__c, Chem_SubClass2__c 
                FROM Consumption_Competitive_Product__c 
                WHERE Industry__c = :m_industry
                    and Product_Function__c = :m_productFunction 
                    and Brand_Name__c = :m_brandName])
            {
                m_grade = ccp.Grade__c;
                cons.Grade__c = ccp.Grade__c;

                m_Supplier = ccp.Supplier__c;
                cons.AQ_Supplier__c = ccp.Supplier__c;
                
                m_ChemClass = ccp.Chem_Class__c;
                cons.Chem_Class__c = ccp.Chem_Class__c;
                
                m_ChemSubClass1 = ccp.Chem_SubClass1__c;
                cons.Chem_SubClass1__c = ccp.Chem_SubClass1__c;                

                m_ChemSubClass2 = ccp.Chem_SubClass2__c;
                cons.Chem_SubClass2__c = ccp.Chem_SubClass2__c; 

                m_SBUProduct = ccp.SBU_Product__c;
                cons.SBU_Product__c = ccp.SBU_Product__c;                     
                    
            }        
    
    }


    // Enable/Disable Brand Name field
    public Boolean getBrandNameFieldDisabled() 
    { 
        return (m_industry== null || m_productFunction == null); 
    }

    // Render Aqualon consumption information section or not
    public Boolean getAqualonConsumptionInformationSectionRendered()
    {
        return (RecordTypeName == 'Aqualon Consumption') ; 
    }

    // Render AWT consumption information section or not
    public Boolean getAWTConsumptionInformationSectionRendered()
    {
        return (RecordTypeName == 'AWT Consumption') ; 
    }

    // Render Distribution Chemicals information section or not
    public Boolean getDistribChemicalsInfoSectionRendered()
    {
        return (RecordTypeName == 'Distribution Chemicals') ; 
    }
    
    // Render Distribution Composites information section or not
    public Boolean getDistribCompositesInfoSectionRendered()
    {
        return (RecordTypeName == 'Distribution Composites') ; 
    }    
    
    // Render Distribution Plastics information section or not
    public Boolean getDstrbtnPlstcsCnsmptnInfoSectionRendered()
    {
        return (RecordTypeName == 'Distribution Plastics' 
            || RecordTypeName == 'Distribution Plastics EMEA') ; 
    }    
     
    // Render Distribution RTK information section or not
    public Boolean getDRTKCnsmptnInfoSectionRendered()
    {
        return (RecordTypeName == 'Distribution RTK') ; 
    }    
    
    // Render PM China information section or not
    public Boolean getPMChinaInfoSectionRendered()
    {
        return (RecordTypeName == 'PM China') ; 
    } 

    // Render AWT consumption information section or not
    public Boolean getAWTMarketKnowledgeRendered()
    {
        return (RecordTypeName == 'AWT Consumption') ; 
    }    

    // Render Distribution Chemicals Market Knowledge section or not
    public Boolean getDistribChemMrktKnwldgRendered()
    {
        return (RecordTypeName == 'Distribution Chemicals') ; 
    } 
    
    // Render Distribution Composites Market Knowledge section or not
    public Boolean getDstrbCmpstsMrktKnwldgRendered()
    {
        return (RecordTypeName == 'Distribution Composites') ; 
    }    
    
    // Render Distribution Plastics Market Knowledge section or not
    public Boolean getDstrbPlstcsMrktKnwldgRendered()
    {
        return (RecordTypeName == 'Distribution Plastics'
            || RecordTypeName == 'Distribution Plastics EMEA') ; 
    }      

    // Render DRTK Market Knowledge section or not
    public Boolean getDRTKMrktKnwldgRendered()
    {
        return (RecordTypeName == 'Distribution RTK') ; 
    } 

    // Render PM China Market Knowledge section or not
    public Boolean getPMChinaMrktKnwldgRendered()
    {
        return (RecordTypeName == 'PM China') ; 
    } 
    
    // Render DRTK Quality Managed section or not
    public Boolean getDRTKQualityMngdRendered()
    {
        return (RecordTypeName == 'Distribution RTK') ; 
    } 
        
    // Render competitive Data section or not
    public Boolean getCompetitiveDataSectionRendered()
    {
        return (RecordTypeName == 'Aqualon Consumption') ; 
    }   
     
    // Render Volume - MT as Sold or Wet section or not
    public Boolean getVolumeMTasSoldorWetSectionRendered()
    {
        return (RecordTypeName == 'Aqualon Consumption') ; 
    }     

    // Render Description Information (Comments field) section or not
    public Boolean getDescInfoCommentsSectionRendered()
    {
        return (RecordTypeName == 'Aqualon Consumption') ; 
    } 
    
    // Render Description Information (Description field) section or not
    public Boolean getDescInfoSectionRendered()
    {
        return (RecordTypeName == 'AWT Consumption' || RecordTypeName == 'Distribution Chemicals'
            || RecordTypeName == 'Distribution Composites' 
            || RecordTypeName == 'Distribution Plastics' 
            || RecordTypeName == 'Distribution Plastics EMEA'
            || RecordTypeName == 'PM China') ; 
    }     

    // Render System Information section or not
    public Boolean getSystemInformationSectionRendered()
    {
        return (RecordTypeName == 'Aqualon Consumption' || RecordTypeName == 'AWT Consumption'
            || RecordTypeName == 'Distribution Composites'
            || RecordTypeName == 'Distribution Plastics'
            || RecordTypeName == 'Distribution Plastics EMEA'
            || RecordTypeName == 'Distribution RTK'
            || RecordTypeName == 'PM China') ; 
    }

    // Render System Information section with record source or not
    public Boolean getSysInfoWithRecordSourceSectionRendered()
    {
        return (RecordTypeName == 'Distribution Chemicals') ; 
    }
    
    // Enable/Disable Other Brand Name field
    public Boolean getOtherBrandNameFieldDisabled() 
    {
        if (this.m_brandName == null)
            return true;
        else
            return (this.m_brandName.trim().toLowerCase() != 'OTHER'.toLowerCase()); 
    }
    
    // Require/Not require the Price field   
    public Boolean getPriceRequired()
    {
        if (cons.Price_Information__c == 'Competitive price provided by customer' ||
                cons.Price_Information__c == 'Competitive price estimated by ASI Sales rep')
            return true;
        else
            return false;       
        
    }
      
        
}
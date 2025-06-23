public class Service_Profile {

	public Service_Profile(Id      ServiceProfileId,
						   String  Buying_Valvoline_Value,                        
						   Double  Average_Daily_Service_Volume_Value,            
						   Decimal Retail_Price_Value,                            
						   Decimal Current_Installer_Product_Cost_Value,          
						   String  Include_Labor_Rate_Value,                      
						   Double  Percent_of_Hours_to_Complete_Value,            
						   Decimal Total_Labor_Costs_Value,                       
						   Decimal Quart_Costs_Value,                             
						   String  Quart_Cost_Label_Value,                        
						   
						   Id      GQ_Id,
						   String  GQ_Type,                                                     
						   String  GQ_Question,                                   
						   Double  GQ_List_Position,                              
						   Double  GQ_Indent_Level,                               
						   String  GQ_Answer_Field_Type,                          
						   String  GQ_Answer_Field_Type_Custom,                   
						   Double  GQ_Number_of_Decimal_Places,                   
						   String  GQ_Answer_Target_Object,                       
						   String  GQ_Answer_Target_Field,                        
						   String  GQ_Answer_Prefix,                              
						   String  GQ_Answer_Suffix,                              
							                                                       
						   Boolean VSQD_Show_Labor_Costs,                         
						   String  VSQD_Average_Daily_Service_Volume_Suffix,      
						   String  VSQD_Current_Installer_Product_Cost_Suffix,    
						   String  VSQD_Quart_Cost_Label,                         
						   String  VSQD_Quart_Cost_Suffix                         
                           ) {
		this.ServiceProfileId = 							ServiceProfileId;
		this.Buying_Valvoline_Value =                       Buying_Valvoline_Value;				   	
		this.Average_Daily_Service_Volume_Value =           Average_Daily_Service_Volume_Value;
		this.Retail_Price_Value =                           Retail_Price_Value;
		this.Current_Installer_Product_Cost_Value =         Current_Installer_Product_Cost_Value;
		this.Include_Labor_Rate_Value =                     Include_Labor_Rate_Value;
		this.Percent_of_Hours_to_Complete_Value =           Percent_of_Hours_to_Complete_Value;
		this.Total_Labor_Costs_Value =                      Total_Labor_Costs_Value;
		this.Quart_Costs_Value =                            Quart_Costs_Value;
		this.Quart_Cost_Label_Value =                       Quart_Cost_Label_Value;
		
		this.GQ_Id =                                        GQ_Id;
		this.GQ_Type =                                      GQ_Type;
		this.GQ_Question =                                  GQ_Question;
		this.GQ_List_Position =                             GQ_List_Position;
		this.GQ_Indent_Level =                              GQ_Indent_Level;
		this.GQ_Answer_Field_Type =                         GQ_Answer_Field_Type;
		this.GQ_Answer_Field_Type_Custom =                  GQ_Answer_Field_Type_Custom;
		this.GQ_Number_of_Decimal_Places =                  GQ_Number_of_Decimal_Places;
		this.GQ_Answer_Target_Object =                      GQ_Answer_Target_Object;
		this.GQ_Answer_Target_Field =                       GQ_Answer_Target_Field;
		this.GQ_Answer_Prefix =                             GQ_Answer_Prefix;
		this.GQ_Answer_Suffix =                             GQ_Answer_Suffix;
		
		this.VSQD_Show_Labor_Costs =                        VSQD_Show_Labor_Costs;
		this.VSQD_Average_Daily_Service_Volume_Suffix =     VSQD_Average_Daily_Service_Volume_Suffix;
		this.VSQD_Current_Installer_Product_Cost_Suffix =   VSQD_Current_Installer_Product_Cost_Suffix;
		this.VSQD_Quart_Cost_Label =                        VSQD_Quart_Cost_Label;
		this.VSQD_Quart_Cost_Suffix =                       VSQD_Quart_Cost_Suffix;    
		}

	public Id      ServiceProfileId { get; set; }     
    public String  Buying_Valvoline_Value { get; set; }                         
    public Double  Average_Daily_Service_Volume_Value { get; set; }        
    public Decimal Retail_Price_Value { get; set; }                        
    public Decimal Current_Installer_Product_Cost_Value { get; set; }      
    public String  Include_Labor_Rate_Value { get; set; }                  
    public Double  Percent_of_Hours_to_Complete_Value { get; set; }        
    public Decimal Total_Labor_Costs_Value { get; set; }                   
    public Decimal Quart_Costs_Value { get; set; }                         
    public String  Quart_Cost_Label_Value { get; set; }                    
                                                                           
    public Id      GQ_Id { get; set; }                               
    public String  GQ_Type { get; set; }                               
    public String  GQ_Question { get; set; }                               
    public Double  GQ_List_Position { get; set; }                          
    public Double  GQ_Indent_Level { get; set; }                           
    public String  GQ_Answer_Field_Type { get; set; }                      
    public String  GQ_Answer_Field_Type_Custom { get; set; }               
    public Double  GQ_Number_of_Decimal_Places { get; set; }               
    public String  GQ_Answer_Target_Object { get; set; }                   
    public String  GQ_Answer_Target_Field { get; set; }                    
    public String  GQ_Answer_Prefix { get; set; }                          
    public String  GQ_Answer_Suffix { get; set; }                          
                                                                           
    public Boolean VSQD_Show_Labor_Costs { get; set; }                     
    public String  VSQD_Average_Daily_Service_Volume_Suffix { get; set; }  
    public String  VSQD_Current_Installer_Product_Cost_Suffix { get; set; }
    public String  VSQD_Quart_Cost_Label { get; set; }                     
    public String  VSQD_Quart_Cost_Suffix { get; set; }                    

	public String getisQuestion() {
		String result = '';
		if (GQ_Type == 'Question') {result='true';} else {result='false';}
		return result;
	}

	public String getisBlankLine() {
		String result = '';
		if (GQ_Type == 'Blank Line') {result='true';} else {result='false';}
		return result;
	}

	public String getisHeaderLine() {
		String result = '';
		if (GQ_Type == 'Header Line') {result='true';} else {result='false';}
		return result;
	}

    public String getGQ_Question_Formatted() {
        String result = '';
        
        if (GQ_Question != null) 
            {
	        for (Integer i=0; i<GQ_Indent_Level; i++) {result += '&nbsp&nbsp&nbsp&nbsp ';}
	        result += GQ_Question;
            } else {result = '&nbsp ';}
        
        return result;
    }

    public String getBuying_Valvoline_Value_Formatted() {
    	String result = '';
    	
        if (Buying_Valvoline_Value != null) 
            {
	    	result += Buying_Valvoline_Value;
            } else {result = '&nbsp ';}
    	
    	return result;
    }
	
    public String getAverage_Daily_Service_Volume_Value_Formatted() {
    	String result = '';
    	
        if (Average_Daily_Service_Volume_Value != null) 
            {
	    	if (Average_Daily_Service_Volume_Value != null) {result += Average_Daily_Service_Volume_Value;} else {result += ' ';} 
	    	if (VSQD_Average_Daily_Service_Volume_Suffix != null) {result += ' ' + VSQD_Average_Daily_Service_Volume_Suffix;}
	
            } else {result = '&nbsp ';}
    	
    	return result;
    }

    public String getRetail_Price_Value_Formatted() {
        String result = '';

        if (Retail_Price_Value != null) 
            {
	        result += '$';        
	        result += Retail_Price_Value;
            } else {result = '&nbsp ';}
        
        return result;
    }

    public String getCurrent_Installer_Product_Cost_Value_Formatted() {
        String result = '';

        if (Current_Installer_Product_Cost_Value != null) 
            {
	        result += '$';        
	        result += Current_Installer_Product_Cost_Value;
	        if (VSQD_Current_Installer_Product_Cost_Suffix != null) {result += ' ' + VSQD_Current_Installer_Product_Cost_Suffix;}
	        
            } else {result = '&nbsp ';}
        
        return result;
    }

    public String getInclude_Labor_Rate_Value_Formatted() {
        String result = '';
        
        if (Include_Labor_Rate_Value != null) 
	        {
	        result += Include_Labor_Rate_Value;
	        } else {result = '&nbsp ';}
        
        return result;
    }

    public String getPercent_of_Hours_to_Complete_Value_Formatted() {
        String result = '';
        
        if ((Percent_of_Hours_to_Complete_Value != null) && (Include_Labor_Rate_Value == 'Yes'))
            {
	        result += Percent_of_Hours_to_Complete_Value;
	        result += '%';
            } else {result = '&nbsp ';}
        
        return result;
    }

    public String getTotal_Labor_Costs_Value_Formatted() {
        String result = '';
        
        if ((Total_Labor_Costs_Value != null) && (Total_Labor_Costs_Value != 0)) 
            {
	        result += '$';        
	        result += Total_Labor_Costs_Value;
            } else {result = '&nbsp ';}
        
        return result;
    }

    public String getQuart_Cost_Label_Value_Formatted() {
        String result = '';
        
        if (Quart_Cost_Label_Value != null) 
	        {
	        result += Quart_Cost_Label_Value;
	        } else {result = '&nbsp ';}
        
        return result;
    }

    public String getQuart_Costs_Value_Formatted() {
        String result = '';

        if (Quart_Costs_Value != null) 
            {
	        result += '$';        
	        result += Quart_Costs_Value;
	        if (VSQD_Quart_Cost_Suffix != null) {result += ' ' + VSQD_Quart_Cost_Suffix;}
	        
            } else {result = '&nbsp ';}
        
        return result;
    }


}
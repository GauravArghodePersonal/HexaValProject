public class Service_Provider_Profile_Questions {

	public Service_Provider_Profile_Questions(String question,
											  Decimal listPosition,
											  Double indentLevel,
											  Object fieldValue,
											  String fieldName,
											  String fieldType,
											  String fieldPicklistValues,
											  Double Number_of_Decimal_Places,
											  String prefix,
											  String suffix) {
		this.question = question; 
		this.listPosition = listPosition;
		this.indentLevel = indentLevel;
		this.fieldValue = fieldValue; 
		this.fieldName = fieldName; 
		this.fieldtype = fieldtype; 
		this.fieldPicklistValues = fieldPicklistValues;
		this.Number_of_Decimal_Places = Number_of_Decimal_Places; 
		this.prefix = prefix; 
		this.suffix = suffix; 
		

    }
	public String errorMessage { get; set; }
    
    public String question { get; set; }
    public Decimal listPosition { get; set; }
    public Double indentLevel { get; set; }
    public Object fieldValue { get; set; }

    public String fieldType { get; set; }
    public String fieldPicklistValues { get; set; }
    public String fieldName { get; set; }
    public Double Number_of_Decimal_Places { get; set; }
    public String prefix { get; set; }
    public String suffix { get; set; }
    
    public String getisPicklist() {
		String result = '';
		if (fieldType=='Picklist') {result='true';} else {result='false';}
		return result;    	
    }
 
 	public String getfieldValue_Picklist() {
 		return fieldValue + '';
 	}

 	public void setfieldValue_Picklist(String valueIn) {
 		fieldValue = valueIn;
 	}

 	public String getfieldValue_String() {
 		return fieldValue + '';
 	}

 	public void setfieldValue_String(String valueIn) {
 		fieldValue = valueIn;
 	}
    
  	public List<SelectOption> getpicklistValues() {
  		
  		//Parse by ;
  		
  	 	List<SelectOption> options = new List<SelectOption>();

  		List<String> values = new List<String>();
  		values = fieldPicklistValues.split(';');  
  		if (values != null)
  			{for(String s:values) {options.add(new SelectOption(s,s));}}
		
  	 	return options;
   	}
    
    public String getisTextBox() {
		String result = 'false';
		if (fieldType=='Whole Number') {result='true';}
		if (fieldType=='Number with Decimals') {result='true';}
		if (fieldType=='Percent') {result='true';}
		if (fieldType=='Text') {result='true';}
		if (fieldType=='Currency') {result='true';}
		return result;    	
    }

    public String getisTextArea() {
		String result = 'false';
		if (fieldType=='Text Area') {result='true';}
		return result;    	
    }

    public String getisOnetoFive() {
		String result = 'false';
		if (fieldType=='One to Five') {result='true';}
		return result;    	
    }

    public String getisOnetoTen() {
		String result = 'false';
		if (fieldType=='One to Ten') {result='true';}
		return result;    	
    }
    
    public String getlistPosition_Formatted() {
    	String result = '';
    	result += listPosition;
    	result = result.replaceFirst('(?<=\\.\\d{0,30}?)0*$', ''); //Removes trailing zeros
    	return result;
    }
    
    public String getfieldValue_Formatted() {
    	String result = '';
    	
    	if (prefix != null) {result += prefix + ' ';}
    	if (fieldValue != null) {result += fieldValue;} else {result += ' ';} 
    	if (suffix != null) {result += ' ' + suffix;}
    	
    	return result;
    }

	public String getquestion_Formatted() {
		String result = '';
		
		for (Integer i=0; i<indentLevel; i++) {result += '&nbsp&nbsp&nbsp&nbsp ';}
		result += question;
		
		return result;
	}
	
	
	private Boolean validateNumber(Object numIn) {
		Boolean result = true;
		Double doubleValue;
		try {
			    doubleValue = Double.valueOf(numIn);
			    errorMessage = '';
			} 
		catch (Exception e) 
			{
				errorMessage = 'Error: ' + numIn + ' is not a valid Number!';
				result = false;
			}
		
		return result;
	}
	
	public Boolean getisValid() {
		Boolean result = true;
		
		if (fieldType=='Whole Number') {result=validateNumber(fieldValue);}
		if (fieldType=='Number with Decimals') {result=validateNumber(fieldValue);}
		if (fieldType=='Percent') {result=validateNumber(fieldValue);}
		if (fieldType=='Text') {result=true;}
		if (fieldType=='Currency') {result=validateNumber(fieldValue);}
		if (fieldType=='Text Area') {result=true;}
		if (fieldType=='One to Five') {result=true;}
		if (fieldType=='One to Ten') {result=true;}
		
		return result;	
	}
	
	
}
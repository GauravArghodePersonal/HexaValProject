public class VIInputField {

	private String value;
	private transient String error;
	
	public VIInputField() {this('');}
	
	public VIInputField(String value) {setValue(value);}
	
	private String nullIfEmpty(String s) {
		if (String.isBlank(s)) {return null;} return s;
	}
	
	public String getValue()          {return value;}
	
	public void   setValue(String s)  {this.value = nullIfEmpty(s);}
    
    public void   setDecimal(Decimal d) {
        String s = String.valueOf(d); value = nullIfEmpty(s);
    }
    
    public Decimal getDecimal() {
    	try {return Decimal.valueOf(value);} catch(Exception e){return null;}
    }
    
	public String getError()         {return error;}
	public void setError(String s)   {this.error = nullIfEmpty(s);}
}
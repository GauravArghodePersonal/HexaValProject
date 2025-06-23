public class CustomInputField {

    private String value;

    private transient String error;
    private transient String style;
    private transient Boolean showError;
    
    public CustomInputField() {this(null);}
    
    public CustomInputField(String value) {setValue(value);}
    
    private Boolean isNull(String s) {return (s == null || s.trim().length() == 0);}
    
    private String getString(String s) {if (isNull(s)) {return null;} return s;}
    
    public String getValue() {return value;}
    
    public void setValue(String s) {value = getString(s);}
    
    public String getError() {return error;}
    
    public void setError(String s) {error = getString(s);}
    
    public Boolean getShowError() {return !isNull(error);}
    
    public String getStyle() {if (getShowError()) {return 'error';} return '';}
    
}
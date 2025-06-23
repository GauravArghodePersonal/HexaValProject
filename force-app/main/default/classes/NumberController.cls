public class NumberController {

    NumberClass numClass;
    
    public Boolean blankZero  {get; set;}
    public Integer decimals   {get; set;}
    public String  locale     {get; set;}
    public Boolean required   {get; set;}
    public Boolean rendered   {get; set;}
    public Integer size       {get; set;}
    public String  style      {get; set;}
    public String  styleClass {get; set;}
    public Decimal value      {get; set;}
    
    public String numberString {
        get {
            return getFormattedValue();
        }
    }
    
    public NumberController() {
    	debug('Constructor begins');
    	decimals = 2; required = false; rendered = false;
    	size = 10; style = ''; styleClass = '';
    }
    
    private void debug(String s) {System.debug(LoggingLevel.INFO, 'NumberController : ' + s);}
    
    public NumberClass getNumClass() {return numClass;}
    
    public void setNumClass(NumberClass nc) {
    	if (numClass != null) {return;}
    	if (nc == null) {nc = new NumberClass();}
    	numClass = nc;
    }
    
    private String getFormattedValue() {
        if (blankZero == null) {blankZero = true;}
        if (locale == null) {locale = 'en_US';}
        Decimal d = getRoundedValue();
        if (d == 0 && blankZero) {return '';}
        String s = CurrencyFunctions.getFormattedDecimal(locale, d);
        return s;
    }
    
    private Decimal getRoundedValue() {
        if (decimals == null) {decimals = 2;}
        if (value == null) {value = 0;}
        Decimal d1 = 10;
        Decimal d2 = d1.pow(decimals);
        Decimal d3 = (value * d2).round();
        Decimal d4 = d3.divide(d2, decimals);
        return d4;
    }

}
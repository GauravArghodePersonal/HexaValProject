public class NumberClass {

    public Decimal val {get; private set;}

    public String  valStr {get; 
    	set {
    		valStr = value; val = null;
    		if (!String.isBlank(value)) {
    			val = Decimal.valueOf(value.replace(',','.'));
    		}
    	}
    }

}
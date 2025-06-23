/**
* A common utility class
*/
public class CQ_CCC_Utils {

	/**
	 * This method truncates the string if the length of the string exceeds the maxSize.
	 * @param inputString The inputString that needs to be truncated
	 * @maxSize the maximum limit for a string to be not truncated
	 */    
    public static String truncate(String inputString,Integer maxSize){
        
        if(inputString != NULL && inputString.length() > maxSize ){
			inputString = inputString.left(maxSize - 3) + '...';        
        }
        return inputString;
    }
}
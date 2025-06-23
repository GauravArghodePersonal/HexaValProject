@isTest
public class TestTools {

   	private static final Integer MAX_CLASS_NAME_LENGTH = 40;
   	private static final String TESTCLASS_SUFFIX = '_T';

    static testMethod void myUnitTest() {
    }
    
    public static Integer uniqueIdx = 0;
    
	public static String newUniqueIdxStr() {
		return newUniqueIdxStr(1);
	}
		
	public static String newUniqueIdxStr(Integer length) {
		return String.valueOf(uniqueIdx++).leftPad(length).replace(' ','0');
	}
    
	public static Integer newUniqueIdxInt() {
		return uniqueIdx++;
	}
    
    public static String genTestClass(String className) {
    	String result = '';
    	String newLine = '\n';
		String truncatedClassName = '';
        truncatedClassName = className.left(MAX_CLASS_NAME_LENGTH - TESTCLASS_SUFFIX.length()) + TESTCLASS_SUFFIX;
    	
    	result += '@isTest' + newLine;
    	result += 'private class ' + truncatedClassName + ' {' + newLine;
    	result += '/****************************************************************************' + newLine;
     	result += '* Test Class ' + truncatedClassName + '' + newLine;
     	result += '* --------------------------------------------------------------------------' + newLine;
     	result += '* Responsible for Testing:' + newLine;
     	result += '*   - ' + className + ' Apex Class' + newLine;
     	result += '****************************************************************************/' + newLine;
    	result += ' ' + newLine;
        result += '    //Test Data' + newLine;
    	result += '' + newLine;    
    	result += '' + newLine;    
        result += '    //Test Settings' + newLine;
    	result += '' + newLine;    
    	result += '' + newLine;    
        result += '    private static testMethod void myUnitTest() {' + newLine;
		result += '        // Create Test Data' + newLine;       
        result += '        createTestData();' + newLine;
    	result += '' + newLine;
        result += '        // Execute Tests' + newLine;
        result += '        Test.startTest();' + newLine;
        result += '        executeTest01();' + newLine;
        result += '        Test.stopTest();' + newLine;
        result += '    }' + newLine;
    	result += '' + newLine;  
        result += '    private static void createTestData() {' + newLine;
        result += '        // No Test Data Needed' + newLine;
        result += '    }' + newLine;
    	result += '' + newLine;  
        result += '    private static void executeTest01() {' + newLine;
        result += '        // Execute Tests' + newLine;
        result += '    }' + newLine;
    	result += '}' + newLine;
    	result += '' + newLine;
     	
     	return result;    	
    }
}
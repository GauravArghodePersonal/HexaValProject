/**
 * Test class for CQ_Utils
 */
@isTest
public class CQ_CCC_Test_Utils {
    static testmethod void givenAString_WhenExceedsMaxSize_ShouldBeTruncatedToAGivenLength(){
        
        //Assert: The string should be truncated based on maxSize and trailed by 3 ellipsis.
        System.assertEquals('Te...', CQ_CCC_Utils.truncate('TestString',5));
        System.assertEquals('TestS...', CQ_CCC_Utils.truncate('TestString',8));
        System.assertEquals('TestString', CQ_CCC_Utils.truncate('TestString',10));
    }
}
@isTest
private class String_FunctionsTest {
    
    @isTest
    Private static void stringFunctionTest(){
        
        test.startTest();
        String_Functions strFunct = new String_Functions();
        String_Functions.convertCRtoBR('StringIn');
        String_Functions.convertBRtoCR('StringIn');
        String_Functions.removeLeadingZeros('Str');
        //String_Functions.trimAllStringsinListString('StringIn');
        String_Functions.Format_ListString_into_HTML_List('dataIn', 'prefix', 'suffix');
        String_Functions.Right('Str', 10001);
        String_Functions.Left('Str', 10001);
        String_Functions.Beforehypen('instring');
        String_Functions.Afterspace('instring');
        String_Functions.BeforeParenthesis('instring');
        String_Functions.inParenthesis('instring');
        String_Functions.Beforespace('instring');
        test.stopTest();
    }

}
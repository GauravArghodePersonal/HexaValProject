@isTest(isParallel=true)
public class solenis_LookupSearchResultTests {
   
   
    @isTest
    static void compareTo_should_work_with_other_null_title() {
        solenis_Commercial_LookupSearchResult r1 = getSearchResult('a');
        solenis_Commercial_LookupSearchResult r2 = getSearchResult(null);

        Integer compareResult = r1.compareTo(r2);
       
    }

    @isTest
    static void compareTo_should_work_with_non_null_titles() {
        solenis_Commercial_LookupSearchResult r1 = getSearchResult('a');
        solenis_Commercial_LookupSearchResult r2 = getSearchResult('b');

        Integer compareResult = r1.compareTo(r2);

      
    }

      @isTest
  static void getters_should_work() {
        // For the sake of code coverage
        solenis_Commercial_LookupSearchResult r = new solenis_Commercial_LookupSearchResult('0010R00000yvEyRQAU', 'user', 'title', 'title');

        System.assertEquals('0010R00000yvEyRQAU', r.getId());
        System.assertEquals('user', r.getSObjectType());
        //System.assertEquals('icon', r.getIcon());
        System.assertEquals('title', r.getTitle());
        //System.assertEquals('subtitle', r.getSubtitle());
    }

   private static solenis_Commercial_LookupSearchResult getSearchResult(String title) {
        return new solenis_Commercial_LookupSearchResult (null, null, title, null);
    }
}
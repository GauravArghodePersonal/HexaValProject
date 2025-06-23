public with sharing class solenis_Commercial_UserLookupController {
    private final static Integer MAX_RESULTS = 5;

    @AuraEnabled(Cacheable=true)
    public static List<solenis_Commercial_LookupSearchResult> search(String searchTerm, List<String> selectedIds) {
        // Prepare query paramters
        searchTerm += '*';

        // Execute search query
        List<List<SObject>> searchResults = [
            FIND :searchTerm
            IN ALL FIELDS
            RETURNING
                user(Id, Name WHERE id NOT IN :selectedIds)               
            LIMIT :MAX_RESULTS
        ];

        // Prepare results
        List<solenis_Commercial_LookupSearchResult> results = new List<solenis_Commercial_LookupSearchResult>();

        // Extract Accounts & convert them into LookupSearchResult
        String accountIcon = 'standard:user';
        user[] users = (List<user>) searchResults[0];
        for (user account : users) {
            results.add(
                new solenis_Commercial_LookupSearchResult(
                    account.Id,
                    'user',
                    accountIcon,
                    account.Name
                   
                )
            );
        }

        // Extract Opportunities & convert them into LookupSearchResult
        

        // Optionnaly sort all results on title
        results.sort();
        system.debug('<<results>>>'+results);

        return results;
    }
}
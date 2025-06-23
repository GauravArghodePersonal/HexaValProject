public without sharing class AdvancedDataTableQueryBuilder {

    public String queryStyle = '';
    public String startingId = '';
    public List<String> fieldList = new List<String>();
    public String sourceObject = '';
    public String accountRelationshipField = '';
    public String startsWithFilterField = '';
    public String startsWithFilter = '';
    public String filterField1 = '';
    public String filter1 = '';
    public String filterField2 = ''; 
    public String filter2 = '';
    public String filterField3 = '';
    public String filter3 = '';
    public String filterStyle = '';
    public String customWhereClause = '';
    public List<String> customFilters = new List<String>();
    public List<String> orderByFields = new List<String>();
    public Integer maxRecs = 0;
    public Integer offset = 0;

    public class AdvancedDataTableQueryBuilderResults {
        public String SOQL = '';
        public String debugSOQL = '';
    }

    public AdvancedDataTableQueryBuilderResults generateSOQL(String queryType) {
        AdvancedDataTableQueryBuilderResults results = new AdvancedDataTableQueryBuilderResults();
        
        if (queryType == 'COUNT') {
            if (queryStyle == 'Standard') {results.SOQL = queryBuilder('COUNT');}
            else if (queryStyle == 'Account Relationship Child Where Parent') {results.SOQL = queryBuilder_AccountRelationshipChildRec('COUNT');}
        }   
        else if (queryType == 'SELECT') {
            if (queryStyle == 'Standard') {results.SOQL = queryBuilder('SELECT');}
            else if (queryStyle == 'Account Relationship Child Where Parent') {results.SOQL = queryBuilder_AccountRelationshipChildRec('SELECT');}
        }   
        
        return results;
    } 

    private String queryBuilder(String queryType) {
        String query = '';
        
        // If query type is count, add count() to query
        if (queryType.toUpperCase() == 'COUNT') {query += 'SELECT COUNT() ';}

        // Add any fields in field list to query
        if (queryType.toUpperCase() == 'SELECT') {if (fieldList.size() > 0) {query += 'SELECT ' + ListtoString(fieldList,', ') + ' ';}}
        
        // Add From Clause
        query += 'FROM ' + sourceObject + ' ';
        
        List<String> whereParts = new List<String>();
        
        if (filterStyle == 'Include All Child Records') {
            whereParts.add(parentFieldWhereClause(isNull(accountRelationshipField,''),startingId));
        }
        
        if (filterStyle == 'Include Starting Record and Child Records') {
            whereParts.add(parentFieldWhereClause(isNull(accountRelationshipField,''),startingId,true));
        }
        
        // Add Filters if needed
        if (startsWithFilterField != '' && startsWithFilterField != null && startsWithFilter != '' && startsWithFilter != null) {whereParts.add(startsWithFilterField + ' LIKE ' + '\'' + startsWithFilter + '%\'');}

        // Add Filters if needed
        if (filterField1 != '' && filterField1 != null && filter1 != '' && filter1 != null) {whereParts.add(filterField1 + ' LIKE ' + '\'%' + filter1 + '%\'');}
        if (filterField2 != '' && filterField2 != null && filter2 != '' && filter2 != null) {whereParts.add(filterField2 + ' LIKE ' + '\'%' + filter2 + '%\'');}
        if (filterField3 != '' && filterField3 != null && filter3 != '' && filter3 != null) {whereParts.add(filterField3 + ' LIKE ' + '\'%' + filter3 + '%\'');}

        // Add Custom Where Clause if needed
        if (isNull(customWhereClause,'') != '') {whereParts.add(resolveEmbeddedVars(customWhereClause));}

        // Add Custom Filters if needed
        for (String customFilter : customFilters) {if (customFilter != '' && customFilter != null) {whereParts.add(resolveEmbeddedVars(customFilter));}}
        
        //Build the Actual WHERE Clause and append to query        
        if (whereParts.size() > 0) {
            // Add Where Clause
            query += 'WHERE ' + ListtoString(whereParts,' AND ') + ' ';
        }
        
        // Add Order By Clause
        if (orderByFields.size() > 0) {query += 'ORDER BY ' + ListtoString(orderByFields,',') + ' ';}
        
        // Add Limit Clause
        if (maxRecs > 0) {query += 'LIMIT ' + maxRecs + ' ';}
        
        // Add Offset Clause
        if (offset >= 0) {query += 'OFFSET ' + offset + ' ';}
       
        return query;                                   
    }

	private String resolveEmbeddedVars(String textIn) {
		String result = textIn;
		
		result = result.replace('{!CURRENTUSERID}',UserInfo.getUserId());
		Id currentUserRoleId = UserInfo.getUserRoleId();
		if (currentUserRoleId != null) {
			result = result.replace('{!CURRENTUSERROLEID}',currentUserRoleId);
		}
		result = result.replace('{!CURRENTPROFILEID}',UserInfo.getProfileId());
		
		return result;
	}

    private String queryBuilder_AccountRelationshipChildRec(String queryType) {
        String query = '';
        
        // If query type is count, add count() to query
        if (queryType.toUpperCase() == 'COUNT') {query += 'SELECT COUNT() ';}

        // Add any fields in field list to query
        if (queryType.toUpperCase() == 'SELECT') {if (fieldList.size() > 0) {query += 'SELECT ' + ListtoString(fieldList,', ') + ' ';}}
        
        // Add From Clause
        query += 'FROM ' + sourceObject + ' ';
        
        List<String> whereParts = new List<String>();
        
        if (filterStyle == 'Normal') {
            whereParts.add('ParentId IN (SELECT Child_Account__c FROM Account_Relationship__c WHERE Parent_Account__c = \'' + startingId + '\')');
        }
        
        if (filterStyle == 'Include All Child Records') {
            whereParts.add('ParentId IN (SELECT Child_Account__c FROM Account_Relationship__c WHERE Parent_Account__c = \'' + startingId + '\')');
        }
        
        if (filterStyle == 'Include Starting Record and Child Records') { //Not Supported here yet
            whereParts.add('ParentId IN (SELECT Child_Account__c FROM Account_Relationship__c WHERE Parent_Account__c = \'' + startingId + '\')');
        }
        
        // Add Filters if needed
        if (startsWithFilterField != '' && startsWithFilterField != null && startsWithFilter != '' && startsWithFilter != null) {whereParts.add(startsWithFilterField + ' LIKE ' + '\'' + startsWithFilter + '%\'');}

        // Add Filters if needed
        if (filterField1 != '' && filterField1 != null && filter1 != '' && filter1 != null) {whereParts.add(filterField1 + ' LIKE ' + '\'%' + filter1 + '%\'');}
        if (filterField2 != '' && filterField2 != null && filter2 != '' && filter2 != null) {whereParts.add(filterField2 + ' LIKE ' + '\'%' + filter2 + '%\'');}
        if (filterField3 != '' && filterField3 != null && filter3 != '' && filter3 != null) {whereParts.add(filterField3 + ' LIKE ' + '\'%' + filter3 + '%\'');}

        // Add Custom Where Clause if needed
        if (isNull(customWhereClause,'') != '') {whereParts.add(customWhereClause);}

        // Add Custom Filters if needed
        for (String customFilter : customFilters) {whereParts.add(customFilter);}
        
        //Build the Actual WHERE Clause and append to query        
        if (whereParts.size() > 0) {
            // Add Where Clause
            query += 'WHERE ' + ListtoString(whereParts,' AND ') + ' ';
        }
        
        // Add Order By Clause
        if (orderByFields.size() > 0) {query += 'ORDER BY ' + ListtoString(orderByFields,',') + ' ';}
        
        // Add Limit Clause
        if (maxRecs > 0) {query += 'LIMIT ' + maxRecs + ' ';}
        
        // Add Offset Clause
        if (offset >= 0) {query += 'OFFSET ' + offset + ' ';}
       
        return query;                                   
    }

    private String ListtoString(List<String> listData, String delimiter) {
        String result = '';
        for (String part:listData) {
            part = part.replace(' ','{|Space|}');
            result += part + ' ';
        }
        result = result.trim(); 
        result = result.replace(' ',delimiter);
        result = result.replace('{|Space|}',' ');     
        return result;
    }

    private String ListtoString(List<Id> listData, String delimiter) {
        return ListtoString(listData,delimiter,false);
    }
    
    private String ListtoString(List<Id> listData, String delimiter,Boolean use15CharId) {
        String result = '';
        for (Id Idpart:listData) {
            String part = Idpart;
            if (use15CharId) {part = part.substring(0,15);}
            part = part.replace(' ','{|Space|}');
            result += part + ' ';
        }
        result = result.trim(); 
        result = result.replace(' ',delimiter);
        result = result.replace('{|Space|}',' ');     
        return result;
    }

    private String SettoString(Set<String> setData, String delimiter) {
        String result = '';
        for (String part:setData) {
            part = part.replace(' ','{|Space|}');
            result += part + ' ';
        }
        result = result.trim(); 
        result = result.replace(' ',delimiter);     
        result = result.replace('{|Space|}',' ');     
        return result;
    }

    private String parentFieldWhereClause(String relationshipField,String id) {
        return parentFieldWhereClause(relationshipField,id,false);
    }

    private String parentFieldWhereClause(String relationshipField,String id,Boolean includeStartingId) {
        String result = '';
        
        String prefix = '';
        String suffix = '\'' + id + '\'';
        
        if (relationshipField != '') {
            prefix = relationshipField + '.';
        }
        
        result += ' (';
        
        List<String> whereParts = new List<String>();

        if (includeStartingId) {whereParts.add(prefix + 'Id = ' + suffix + ' ');}
        whereParts.add(prefix + 'ParentId = ' + suffix + ' ');
        whereParts.add(prefix + 'Parent.ParentId = ' + suffix + ' ');
        whereParts.add(prefix + 'Parent.Parent.ParentId = ' + suffix + ' ');
        whereParts.add(prefix + 'Parent.Parent.Parent.ParentId = ' + suffix + ' ');
//      whereParts.add(prefix + 'Parent.Parent.Parent.Parent.Parent.ParentId = ' + suffix + ' ');
//      whereParts.add(prefix + 'Parent.Parent.Parent.Parent.Parent.Parent.ParentId = ' + suffix + ' ');
//      whereParts.add(prefix + 'Parent.Parent.Parent.Parent.Parent.Parent.Parent.ParentId = ' + suffix + ' ');
//      whereParts.add(prefix + 'Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.ParentId = ' + suffix + ' ');
//      whereParts.add(prefix + 'Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.ParentId = ' + suffix + ' ');
//      whereParts.add(prefix + 'Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.ParentId = ' + suffix + ' ');
        
        
        result = ' (' + ListtoString(whereParts,' OR ') + ') ';
        
        return result;
    }

    private String isNull(String value,String whenNullReturn) {
        if (value == null) {
            return whenNullReturn;
        }
        else {
            return value;
        }   
    }
}
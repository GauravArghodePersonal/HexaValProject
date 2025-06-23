public with sharing class QueryBuilder {

	public class QueryBuilderInstruction {
		// TBD
	}

	public class SubQuery {
		String relationshipName = '';
		Set<String> fieldList = new Set<String>();
		String whereClause = '';
		
		public SubQuery() {}
		public SubQuery(String relationshipName, Set<String> fieldList) {
			this.relationshipName = relationshipName;
			this.fieldList = fieldList;
			this.whereClause = whereClause = '';
		}
		public SubQuery(String relationshipName, Set<String> fieldList, String whereClause) {
			this.relationshipName = relationshipName;
			this.fieldList = fieldList;
			this.whereClause = whereClause;
		}
	}
	

	public static String generateSOQL(String objectName, Set<String> fieldList,String whereClause) {
		return generateSOQL(objectName,fieldList,whereClause,new List<SubQuery>());
	}
	
	public static String generateSOQL(String objectName, Set<String> fieldList,String whereClause,List<SubQuery> subQueries) {
		String result = '';
		
		List<String> selectParts = new List<String>();
		selectParts.add(String.join(new List<String>(fieldList),','));
		
		if (!subQueries.isEmpty()) {
			for (SubQuery subQuery : subQueries) {selectParts.add(buildSubQuery(subQuery));}
		}
		
		result += 'SELECT ';
		result += String.join(selectParts,',');
		result += ' FROM ' + objectName;
		if (String.isNotEmpty(whereClause)) {
			result += ' WHERE ' + whereClause;
		}

		System.debug('QueryBuilder Query = ' + result);

		return result;
	}

	private static String buildSubQuery(SubQuery subQuery) {
		String result = '';

		result = '(SELECT ' + String.join(new List<String>(subQuery.fieldList),',');
		result += ' FROM ' + subQuery.relationshipName;
		if (String.isEmpty(subQuery.whereClause)) {
			result += ')';
		}
		else {
			if (String.isNotEmpty(subQuery.whereClause)) {
				result += ' WHERE ' + subQuery.whereClause;
			}
			result += ')';
		}
		
		return result;
	}

}
public with sharing class IdMethods {
	public static Boolean isId(String idToCheck) {
		Boolean result = false;
		
		try {
			if (String.isNotEmpty(idToCheck)) {
				Id id = idToCheck;
				result = true;
			}
		}
		catch (Exception e) {}
		
		return result;
	}
}
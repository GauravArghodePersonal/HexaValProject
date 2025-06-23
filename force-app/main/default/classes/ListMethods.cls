global with sharing class ListMethods {
	global static List<Blob>     newWithData(Blob item)     {List<Blob> results = new List<Blob>();results.add(item);return results;}
	global static List<Boolean>  newWithData(Boolean item)  {List<Boolean> results = new List<Boolean>();results.add(item);return results;}
	global static List<Date>     newWithData(Date item)     {List<Date> results = new List<Date>();results.add(item);return results;}
	global static List<Datetime> newWithData(Datetime item) {List<Datetime> results = new List<Datetime>();results.add(item);return results;}
	global static List<Decimal>  newWithData(Decimal item)  {List<Decimal> results = new List<Decimal>();results.add(item);return results;}
	global static List<Double>   newWithData(Double item)   {List<Double> results = new List<Double>();results.add(item);return results;}
	global static List<ID>       newWithData(ID item)       {List<ID> results = new List<ID>();results.add(item);return results;}
	global static List<Integer>  newWithData(Integer item)  {List<Integer> results = new List<Integer>();results.add(item);return results;}
	global static List<Long>     newWithData(Long item)     {List<Long> results = new List<Long>();results.add(item);return results;}
	global static List<String>   newWithData(String item)   {List<String> results = new List<String>();results.add(item);return results;}
	global static List<Time>     newWithData(Time item)     {List<Time> results = new List<Time>();results.add(item);return results;}
	global static List<Object>   newWithData(Object item)   {List<Object> results = new List<Object>();results.add(item);return results;}
	global static List<sObject>  newWithData(sObject item)  {List<sObject> results = new List<sObject>();results.add(item);return results;}
	
	global static Set<Id> extractSetId(List<sObject> items,String fieldName) {
		Set<Id> results = new Set<Id>();
		
		if (items != null) {
			for (sObject item : items) {
				Id id = (Id)item.get(fieldName);
				results.add(id);
			}
		}
		
		return results;
	}
}
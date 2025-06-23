global with sharing class SetMethods {
	global static Set<Blob>     newWithData(Blob item)     {Set<Blob> results = new Set<Blob>();results.add(item);return results;}
	global static Set<Boolean>  newWithData(Boolean item)  {Set<Boolean> results = new Set<Boolean>();results.add(item);return results;}
	global static Set<Date>     newWithData(Date item)     {Set<Date> results = new Set<Date>();results.add(item);return results;}
	global static Set<Datetime> newWithData(Datetime item) {Set<Datetime> results = new Set<Datetime>();results.add(item);return results;}
	global static Set<Decimal>  newWithData(Decimal item)  {Set<Decimal> results = new Set<Decimal>();results.add(item);return results;}
	global static Set<Double>   newWithData(Double item)   {Set<Double> results = new Set<Double>();results.add(item);return results;}
	global static Set<ID>       newWithData(ID item)       {Set<ID> results = new Set<ID>();results.add(item);return results;}
	global static Set<Integer>  newWithData(Integer item)  {Set<Integer> results = new Set<Integer>();results.add(item);return results;}
	global static Set<Long>     newWithData(Long item)     {Set<Long> results = new Set<Long>();results.add(item);return results;}
	global static Set<String>   newWithData(String item)   {Set<String> results = new Set<String>();results.add(item);return results;}
	global static Set<Time>     newWithData(Time item)     {Set<Time> results = new Set<Time>();results.add(item);return results;}
	global static Set<Object>   newWithData(Object item)   {Set<Object> results = new Set<Object>();results.add(item);return results;}
	global static Set<sObject>  newWithData(sObject item)  {Set<sObject> results = new Set<sObject>();results.add(item);return results;}
}
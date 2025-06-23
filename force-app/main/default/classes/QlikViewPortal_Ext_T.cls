@isTest
public with sharing class QlikViewPortal_Ext_T
{
  static testMethod void myUnitTest() { 
  QlikViewPortal_Controller c = new QlikViewPortal_Controller();
  QlikViewPortal_Ext q = new QlikViewPortal_Ext(c);
  q.Init();
  q.generateURL();
  q.getInsideIntranet();
  q.getOutsideIntranet();
  q.getUserIPAddress();
  q.getUserName();
}
}
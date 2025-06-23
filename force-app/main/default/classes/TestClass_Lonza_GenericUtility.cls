/*
* File Name         :       TestCalss_Lonza_GenericUtility
* Description       :       Test Generic Class for Holding any Static Values throughout implementation
* @author           :       sshenderov
* Modification Log
===================================================================================================
* Ver.    Date                  Author                          Modification
---------------------------------------------------------------------------------------------------
*      7/14/2016             sshenderov                                     
*/
@isTest 
private Class TestClass_Lonza_GenericUtility{
public static TestMethod void test_Lonza_genericUtility()
{
test.starttest();

    Date startDate = Lonza_GenericUtility.setStringToDateFormat('2016-01-01');
    Date endDate = Lonza_GenericUtility.setStringToDateFormat('2016-01-30');
    
    system.debug('Start Date is ' + startDate);
    system.debug('End Date is ' + endDate);
    
    Integer hol = Lonza_GenericUtility.getHolidays(startDate,endDate);
    
    system.debug('Amount of holidays is ' + hol);
    Integer holWithoutWeekends = Lonza_GenericUtility.daysBetweenExcludingWeekends(startDate,endDate);


    Integer workdays = Lonza_GenericUtility.getWorkingDays(startDate,endDate);
    
    Date checkDate = Lonza_GenericUtility.AddBusinessDays(Date.Today(), 25);
  checkDate = Lonza_GenericUtility.AddBusinessDaysExcludingHolidays(Date.Today(), 25);
  
  Boolean bWorkingDay = Lonza_GenericUtility.isWeekendDay(Date.Today());
  bWorkingDay = Lonza_GenericUtility.IsHoliday(Date.Today());
  
 test.stoptest();
}

}
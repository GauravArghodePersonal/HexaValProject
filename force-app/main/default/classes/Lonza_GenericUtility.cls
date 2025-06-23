/*
* File Name         :       Lonza_GenericUtility
* Description       :       Generic Class for Holding any Static Values throughout implementation
* @author           :       Deloitte consulting
* Modification Log
===================================================================================================
* Ver.    Date                  Author                          Modification
---------------------------------------------------------------------------------------------------
* 1.0    01/08/2012             Sushumna Mulugu                 Created the Class
*/

public with Sharing class Lonza_GenericUtility {
    public static String approvedInSAP = 'Approved and in SAP';
    public static String systemAdmin = 'System Administrator';
    public static String woodCust = 'Wood Customer';
    public static String disable_new_Error = 'You are not allowed to perform this action, please contact your salesforce administrator for assistance!';
    public static   List<Holiday> listholidays = [Select Id, ActivityDate From Holiday order by ActivityDate];
    
    public static Date setStringToDateFormat(String myDate) { 
  
   String[] strDate = myDate.split('-'); 
   Integer myIntDate = integer.valueOf(strDate[2]); 
   Integer myIntMonth = integer.valueOf(strDate[1]); 
   Integer myIntYear = integer.valueOf(strDate[0]); 
   Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate); 
   return d; 
} 
    
    public static Integer getHolidays(Date startDate, Date endDate){
    List<Holiday> holidays = [  Select Id, h.ActivityDate From Holiday h Where h.ActivityDate >= :startDate And h.ActivityDate <= :endDate];
    if (holidays != null)
        return holidays.size();
    return 0;
}
    public static Integer daysBetweenExcludingWeekends(Datetime startDate, Datetime endDate) {
    //Work out days in range
    Integer days = startDate.date().daysBetween(endDate.date());
     System.debug('Days between dates  '+days);
    if (days == 0 ) return 0;
    //Remove most weekends by removing 2 in 7 days (rounded down)
    days -= ((integer)Math.floor((days / 7)) * 2);
     System.debug('Remove most weekends  '+days);

    if (startDate.format('EEE') != 'Sat') {
    
        days -= 1;
        System.debug('Start Date is not Sat  '+days);

    } else if (startDate.format('EEE') != 'Sun') {
        System.debug('Start Date is not Sun  '+days);
    }

    return days;
}
//array of seven boolean indicating working days, Monday is index 0
private static final List<Boolean> isWorkingDay;
//count of the number of working days in the array
private static final Integer workingDaysInWeek;
static {
    //my real implementation uses the Salesforce BusinessHours Object to populate this array
    isWorkingDay = new List<Boolean> { true, true, true, true, true, false, false };
    //You will have real problems if this number does not match the number of true flags in the array
    workingDaysInWeek = 5;
}

private static final Date monday = Date.newInstance(1900, 1, 8);
private  static Integer getDayOfWeek(Date value) {
    return Math.mod(monday.daysBetween(value), 7);
}

public static Integer getWorkingDays(Date startDate, Date endDate) {
    system.debug(' getWorkingDays. Start Date is ' + startDate + ' end date is ' + endDate);
    //save some calculations when the number of working days is 0
    if(workingDaysInWeek == 0 || startDate == null || endDate == null) {
        return 0;
    } else {
        Integer difference = startDate.daysBetween(endDate);
         system.debug('getWorkingDays. Days between is ' + difference );

        if(difference == 0) {
            //If the 2 dates are the same day check if the day is a working day or not
            return isWorkingDay[getDayOfWeek(startDate)] ? 1 : 0;
        } else if(workingDaysInWeek == 7) {
            //when every day is a working day return the difference
            return difference;
        } else {
            //The guts of the solution
            Integer wholeWeeks = Math.floor(difference / 7).intValue();
            
            Integer workingDays = wholeWeeks * workingDaysInWeek;
            Integer dayOfWeek = getDayOfWeek(endDate);
             system.debug(' wholeWeeks is ' + wholeWeeks + ' workingDays is ' + workingDays + ' dayOfWeek is ' + dayOfWeek); 
            for(Integer remainder = Math.mod(difference, 7); remainder >= 0; remainder--) {
                if(isWorkingDay[dayOfWeek]) { // was reminder
                    workingDays++;
                }
                dayOfWeek--;
                if(dayOfWeek < 0) {
                    dayOfWeek = 6;
                }
             system.debug(' Reminder is ' + remainder + ' workingDays is ' + workingDays + ' dayOfWeek is ' + dayOfWeek); 
                
            }
            return workingDays;
        }
    }
  }  
   public static Boolean IsWeekendDay(Date dateParam) 
   { 
    Boolean result = false;
    system.debug('dateParam is ' + dateParam);
   
    /*BusinessHours stdBusinessHours = [select id from Businesshours where isDefault = true]; 
    result = BusinessHours.isWithin(stdBusinessHours.id, dateParam);
    return result;*/
     return isWorkingDay[getDayOfWeek(dateParam)] ? false : true;
    
   }  
   public static Boolean IsHolidayDay(Date checkDate){
    
    // cannot use SOQL against Holiday table because ActivityDate is the date when holiday was entered first and not for this year
   BusinessHours stdBusinessHours = [select id from Businesshours where isDefault = true]; 
   Boolean  result = BusinessHours.isWithin(stdBusinessHours.id, checkDate);
    return result? false: true ;
}

public static Boolean isHoliday(Date checkDate){ 
   /* BusinessHours stdBusinessHours = [select id from Businesshours where isDefault = true]; 
    Date outDate = (BusinessHours.add(stdBusinessHours.id, checkDate, 1)).date(); 
    if(checkDate == outDate){ 
        return false; 
    } else { 
        return true; 
   } */
   
   for (Holiday hol : listholidays)     
   {  
     if (date.valueof(hol.ActivityDate) == checkDate) return true;
   }
   return false;
} 

   public static Date AddBusinessDays(Date StartDate, integer BusinessDaysToAdd ) 
   { 
      //Add or decrease in BusinessDaysToAdd days  
      Date finalDate = StartDate; 
      system.debug('finaldate = '+finalDate); 
      integer direction = BusinessDaysToAdd < 0 ? -1 : 1; 
      system.debug('direction = '+direction); 
       while(BusinessDaysToAdd != 0) 
       { 
           finalDate = finalDate.AddDays(direction); 
           system.debug('BusinessDaysToAdd = '+BusinessDaysToAdd);             
           system.debug('finaldate = '+finalDate); 
           if (isWorkingDay[getDayOfWeek(finalDate)]) 
           { 
               BusinessDaysToAdd -= direction; 
           } 
        system.debug('BusinessDaysToAdd after checking weekend = '+BusinessDaysToAdd); 
       } 
 
       return finalDate; 

   } 
   public static Date AddBusinessDaysExcludingHolidays(Date StartDate, integer BusinessDaysToAdd ) 
   { 
      //Add or decrease in BusinessDaysToAdd days  
      Date finalDate = StartDate; 
      system.debug('finaldate = '+finalDate); 
      integer direction = BusinessDaysToAdd < 0 ? -1 : 1; 
      system.debug('direction = '+direction); 
       while(BusinessDaysToAdd != 0) 
       { 
           finalDate = finalDate.AddDays(direction); 
           system.debug('BusinessDaysToAdd = '+BusinessDaysToAdd);             
           system.debug('finaldate = '+finalDate); 
           if (isWorkingDay[getDayOfWeek(finalDate)] && !isHoliday(finalDate) ) 
           { 
               BusinessDaysToAdd -= direction; 
           } 
        } 
 
       return finalDate; 

   } 



}
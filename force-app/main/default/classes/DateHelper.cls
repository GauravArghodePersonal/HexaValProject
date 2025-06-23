/*****************************************************************
* Class Name     : DateHelper                                    *
* Author         : Aakash Wankhede                               *
* Created Date   : 16-Aug-2023                                   *
* Modified Date  :                                               *
* Description    : Class created for helper methods related to   *
* Calendar feature.								                 *
*****************************************************************/
public class DateHelper {
    @AuraEnabled(cacheable=true)
    public static List<Date> getHolidayDateList(){
        List<Date> holidayList=new List<Date>();
        //Using holiday list custom metadata
        for( Holiday_List__mdt holiday: [ SELECT Id, MasterLabel, Date__c FROM Holiday_List__mdt ]){
            holidayList.add(holiday.Date__c);
        }

        //Using Holiday object (Kept the code just for reference if in future if we want to use Holiday object instead of custom metadata)
        /*for( Holiday h: [SELECT ActivityDate,Description,EndTimeInMinutes,Id,IsAllDay,IsRecurrence,Name,StartTimeInMinutes FROM Holiday])
        {
            holidayList.add(h.ActivityDate);
        }*/
        return holidayList;
    }
}
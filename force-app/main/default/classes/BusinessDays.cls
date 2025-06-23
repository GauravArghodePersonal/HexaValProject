/**
 * BusinessDays Class
 * Use this class to operate only on business days 
 * and easily skip weekends and holidays from your logic

 * */
public class BusinessDays
{
    public BusinessHours bHours;
    /**
     * Constructor to set business hours name
     * */
    public BusinessDays(String businessHoursName){
        //get business hours
       
        bHours = [SELECT Id FROM BusinessHours WHERE Name =: businessHoursName];
        system.debug('INside the BusinessDays11 Hours'+bHours);

    }
     
    public BusinessDays(){
        //If no business hours name provided in paramaterized constructor, use deafault hours
        bHours = [SELECT Id FROM BusinessHours WHERE IsDefault = true];
        system.debug('INside the BusinessDays22 Hours'+bHours);
        
    }
    

    /**
     * Add number of working days in a date
     * @param - startDate - date to operate on
     * @param - days - number of days to add
 
     * */
    public Datetime addDays(Datetime startDate, Integer days)
    {
        //If startdate is not within working days, take next working day
        startDate = BusinessHours.nextStartDate(bHours.Id, startDate);
        
        for (Integer elapsed = 0; elapsed < days; elapsed++)
        {
            //Add 1 day
            startDate = startDate.addDays(1);
            system.debug('bHours.Id'+bHours.Id);
            system.debug('startDate'+startDate);
            system.debug('is Within Result-->'+BusinessHours.isWithin(bHours.Id, startDate));
            //Check if new date is within working days
            if (!BusinessHours.isWithin(bHours.Id, startDate))
            { 
                
                system.debug('Is within Function');
                //If new date is not within working days, get new working day
                startDate = BusinessHours.nextStartDate(bHours.Id, startDate);
            }
        }
        return startDate;
    }
    

    
    /*
     * Get numbe of business days between two dates

     * */
    public  Integer getNoOfBusinessDaysBetweenDates(DateTime startDate, DateTime endDate){
        Integer count = 0;
        system.debug('Inside');
        while(startDate <= endDate){
            system.debug('<<<<bHours.Id>>>'+bHours.Id);
            system.debug('<<<<startDate>>>'+startDate);
            system.debug('<<<<endDate>>>'+endDate);
            
            system.debug(startDate);
            system.debug('isWithin(bHours.Id, startDate)'+BusinessHours.isWithin(bHours.Id, startDate));            
            if(BusinessHours.isWithin(bHours.Id, startDate)){
                count++;
            }
            startDate = startDate.addDays(1);
            system.debug(startDate);
        }
      
        
        
        
        return count;
    }
    
      /*
     * Get Negative numbe of business days between two dates

     * */
    public  Integer getNoOfBusinessDaysBetweenDatesNeg(DateTime startDate, DateTime endDate){
        Integer count = 0;
        system.debug('Inside');
        while(startDate <= endDate){
            system.debug(bHours.Id);
              system.debug('<<<startDate>>'+startDate);
            system.debug('<<<endDate>>'+endDate);
            system.debug(startDate);
            system.debug('isWithin(bHours.Id, startDate)'+BusinessHours.isWithin(bHours.Id, startDate));            
            if(BusinessHours.isWithin(bHours.Id, startDate)){
                count++;
            }
            startDate = startDate.addDays(1);
            system.debug(startDate);
        }
      
        
        
        
        return -count;
    }
    /*
Converts the date field to datetime with added business hours
*/
    
    public datetime convertDatetime(date dateval)
    {
                string s = string.valueOfGmt(dateval);
        system.debug(s);
        
        // Code Change for Time Zone by Donald 20-DEC-2020
        Integer d = dateval.day();
Integer mo = dateval.month();
Integer yr = dateval.year();
//DateTime DT = DateTime.newInstance(yr, mo, d);

DateTime DT =  DateTime.newInstanceGMT(yr, mo, d, 13, 0, 0);
       
//String est = DT.format('yyyy-MM-dd HH:mm:ss', 'EST');
//DateTime acceptableDateTime = DateTime.Valueof(est.replace('T', ' '));
system.debug('<<DT>>>'+DT );
return DT ;
//Code change end
        
       // s = s.replace(' 00:00:00', ' 12:00:00');
      //  system.debug(s);
       // DateTime dt1 = DateTime.valueOf(s);
      //  system.debug('<<dt1>>>'+dt1);
       // return dt1;
    }
}
/**
 * @Project : Primark
 * @Author  : Kevin Snell
 * @Date    : 04/05/2022
 * @description : Check Business Hours to see whether Chat is available at current time
 * ************************************************************************************************
 * Name                       Date            Comments
 * Devendra Villa(EPAM)       26-DEC-22       CRM-619 as part of the Code Refactoring for Salesforce Code Analyzer
 */
public  without sharing class EinsteinBotSupportHoursHandler {
    
    @InvocableMethod(label = 'Chat Request Within Business Hours')
    
    /**
    * @description  : Calling function which called from all the other apex classes from the catch block
    * @author       : Kevin Snell
    * @param    businessHoursName to get the businessHoursName
    * @return       : List 
    **/
    public static List<Integer> makeGetCallout(List<String> businessHoursName) {
        String bhName= String.valueOf(+businessHoursName[0]);
        Integer bhResCode;
        //Date d = System.today();
        // Datetime dt = (DateTime)d; CRM-619 as part of the Code Refactoring for Salesforce Code Analyzer
        String dayOfWeek = DateTime.now().format('EEEE');

        
        // Get Business hours based on name, input from bot
        BusinessHours bh = [SELECT Id, MondayStartTime,MondayEndTime,TuesdayStartTime,TuesdayEndTime,WednesdayStartTime,WednesdayEndTime,ThursdayStartTime,ThursdayEndTime,FridayStartTime,FridayEndTime,SaturdayStartTime,SaturdayEndTime,SundayStartTime,SundayEndTime, Name FROM BusinessHours WHERE name= :bhName][0];
        
        // Create Datetime with current date/time in local time zone
        Datetime targetTime = Datetime.now();
        Time currentTime = targetTime.time();
        // Find whether the time is within business hours
        Boolean isWithin= BusinessHours.isWithin(bh.id, targetTime);
        Time endTime = getEndTime(dayOfWeek, bh);
        if(isWithin){
            if(currentTime < endTime && currentTime > endTime.addMinutes(-15) ){
                bhResCode = -1;
            }
            else{
                bhResCode = 1;
            }
        }
        else{
            bhResCode = -2;
        }
        
        return new List<Integer>{bhResCode};
    }
   /**
    * @description  : To get time
    * @author       : Kevin Snell
    * @param   day to get the day 
    * @param   bh to get the BusinessHours
    * @return       : Time 
    **/
    public static Time getEndTime(String day, BusinessHours bh){
        switch on day {
        when 'Sunday'{
        return bh.SundayEndTime;
        }
        when 'Monday'{
        return bh.MondayEndTime;
        }
        when 'Tuesday'{
        return bh.TuesdayEndTime;
        }
        when 'Wednesday'{
        return bh.WednesdayEndTime;
        }
        when 'Thursday'{
        return bh.ThursdayEndTime;
        }
        when 'Friday'{
        return bh.FridayEndTime;
        }
        when 'Saturday'{
        return bh.SaturdayEndTime;
        }
        when else{
        return null;
        }
        }
    }

    
}
/**
 * @Project : Primark
 * @Author  : Jack Tolladay
 * @Date    : 25/05/2022
 * @description : Utility class for Account object where store record type
 * ************************************************************************************************
 * Name                       Date            Comments
 * Devendra Villa(EPAM)       26-DEC-22       CRM-619 as part of the Code Refactoring for Salesforce Code Analyzer
 */
public class StoreLocationUtils {
    /**
    * @description  : Auto populate fields i.e. Display hours, Display Address
    * @author       : Jack Tolladay
    * @param       storeLocationRecords to get storeLocationRecords
    **/
    public static void autoPopulateFields(List<Account> storeLocationRecords) {
        for (Account storeLocation : storeLocationRecords) {
            prepareDisplayHours(storeLocation);
            prepareDisplayAddress(storeLocation);
        }
    }
    
    
    /**
    * @description  : To prepare display hours value,
                      If Holiday hours are present for current week then display holiday hours details
                      If not then display general day hours details
    * @author       : Jack Tolladay
    * @param      storeLocation to get storeLocation
    **/
    private static void prepareDisplayHours(Account storeLocation) {
        Map<String, String> dayAndHoursMap = new Map<String, String>();
        String [] dateAndHoursDetail = String.isBlank(storeLocation.Holiday_Hours__c) ? null : storeLocation.Holiday_Hours__c.split(',');
        if (dateAndHoursDetail != null) {
            dayAndHoursMap = prepareDayAndHoursMap(dateAndHoursDetail);
        }
        setDisplayHoursInRecord(storeLocation, dayAndHoursMap);
    }
    
    /**
    * @description  : To prepare Map of holiday date and hours from current week using holiday_hours field of Store_location record
    * @author       : Jack Tolladay
    * @param        dateAndHoursDetailArr to get  dateAndHoursDetailArr
    * @return       : DayandHours
    **/
    private static Map<String, String> prepareDayAndHoursMap(String[] dateAndHoursDetailArr) {
        Map<String, String> dayAndHoursMap = new Map<String, String>();
        
        for (String holidayDateAndHours : dateAndHoursDetailArr) {
            if (!String.isBlank(holidayDateAndHours)) {
                String dayOfWeek = getDayofDateFromCurrentWeek(holidayDateAndHours.split('::')[0]);
                if (!String.isBlank(dayOfWeek)) {
                    String mapValue = (dayOfWeek + ' ' + holidayDateAndHours.split('::')[1]);
                    dayAndHoursMap.put(dayOfWeek, mapValue);
                }
            }
        }
        return dayAndHoursMap;
    }
    
    /**
    * @description  : To get Day of week if holiday date exist in current week
    * @author       : Jack Tolladay
    * @param       holidayDateStr to get  holidayDateStr
    * @return       : datefromCurrentweek
    **/
    private static String getDayofDateFromCurrentWeek(String holidayDateStr) {
        Date holidayDate = Date.valueOf(holidayDateStr);
        if (checkIfDateExistInCurrentWeek(holidayDate) ) {
            Datetime holidayDateTime = DateTime.newInstance(holidayDate, Time.newInstance(0, 0, 0, 0));
            String dayOfWeek=holidayDateTime.format('EEEE');
            return dayOfWeek;
        } else {
            return null;
        }
    }
    
    /**
    * @description  : To calculate if holiday date exist in current week or no
    * @author       : Jack Tolladay
    * @param       holidayDate to get holidayDate
    * @return       : dateEaistInCurrentweek
    **/
    private static Boolean checkIfDateExistInCurrentWeek(Date holidayDate) {
        if (Date.today().toStartofWeek() == holidayDate.toStartOfWeek()) {
            return true;
        } 
        return false;
    }
    
    
    /**
    * @description  : To prepare display hour accordingly if holiday hours present in current week or not
    * @author       : Jack Tolladay
    * @param   storeLocation to get storelocation
    * @param   dayAndHours to get dayandHours
    **/
    private static void setDisplayHoursInRecord(Account storeLocation, Map<String, String> dayAndHours) {

        if (dayAndHours.get('Monday') != null) {
            storeLocation.Display_Hours__c = dayAndHours.get('Monday');
        } else if (storeLocation.Monday_Hours__c != null) {
            storeLocation.Display_Hours__c = storeLocation.Monday_Hours__c;
        }
        if (dayAndHours.get('Tuesday') != null) {
            storeLocation.Display_Hours__c += '\n' + dayAndHours.get('Tuesday');
        } else if (storeLocation.Tuesday_Hours__c != null) {
            storeLocation.Display_Hours__c += '\n' + storeLocation.Tuesday_Hours__c;
        }
        if (dayAndHours.get('Wednesday') != null) {
            storeLocation.Display_Hours__c += '\n' + dayAndHours.get('Wednesday');
        } else if (storeLocation.Wednesday_Hours__c != null) {
            storeLocation.Display_Hours__c += '\n' + storeLocation.Wednesday_Hours__c;
        }
        if (dayAndHours.get('Thursday') != null) {
            storeLocation.Display_Hours__c += '\n' + dayAndHours.get('Thursday');
        } else if (storeLocation.Thursday_Hours__c != null) {
            storeLocation.Display_Hours__c += '\n' + storeLocation.Thursday_Hours__c;
        }
        if (dayAndHours.get('Friday') != null) {
            storeLocation.Display_Hours__c += '\n' + dayAndHours.get('Friday');
        } else if (storeLocation.Friday_Hours__c != null) {
            storeLocation.Display_Hours__c += '\n' + storeLocation.Friday_Hours__c;
        }
        if (dayAndHours.get('Saturday') != null) {
            storeLocation.Display_Hours__c += '\n' + dayAndHours.get('Saturday');
        } else if (storeLocation.Saturday_Hours__c != null) {
            storeLocation.Display_Hours__c += '\n' + storeLocation.Saturday_Hours__c;
        }
        if (dayAndHours.get('Sunday') != null) {
            storeLocation.Display_Hours__c += '\n' + dayAndHours.get('Sunday');
        } else if (storeLocation.Sunday_Hours__c != null) {
            storeLocation.Display_Hours__c += '\n' + storeLocation.Sunday_Hours__c;
        }
    }
    
    //Method: To prepare display address using various fields i.e. address, city, state, zip
    /**
    * @description  : To prepare display address using various fields i.e. address, city, state, zip
    * @author       : Jack Tolladay
    * @param     storeLocation to get storeLocation
    **/
    private static void prepareDisplayAddress(Account storeLocation) {
        /*system.debug('Account Address 1: ' + storeLocation.Address_Line_1__c);
        system.debug('Address_Line_2__c: ' + storeLocation.Address_Line_2__c);
        system.debug('Account City__c 1: ' + storeLocation.City__c);
        system.debug('Account State__c 1: ' + storeLocation.State__c);
        system.debug('Account ZIP__c 1: ' + storeLocation.ZIP__c);
        CRM-619 as part of the Code Refactoring for Salesforce Code Analyzer */


        storeLocation.Display_Address__c = !String.isBlank(storeLocation.BillingStreet) ? storeLocation.BillingStreet : '';
        storeLocation.Display_Address__c += !String.isBlank(storeLocation.BillingCity) ? '\n'+storeLocation.BillingCity : '';
        storeLocation.Display_Address__c += !String.isBlank(storeLocation.BillingState) ? '\n'+storeLocation.BillingState : '';
        storeLocation.Display_Address__c += !String.isBlank(storeLocation.BillingPostalCode) ? '\n'+storeLocation.BillingPostalCode : '';
        storeLocation.Display_Address__c += !String.isBlank(storeLocation.BillingCountry) ? '\n'+storeLocation.BillingCountry : '';
    }
}
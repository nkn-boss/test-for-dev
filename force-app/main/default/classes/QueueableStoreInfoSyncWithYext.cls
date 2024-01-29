/**
 * @Project : Primark
 * @Author  : Anshul Sharma
 * @Date    : 25/02/2022
 * @description : Queueable class for Yext Integration to prepare request_url, send http request and parse response into Store_location__c object .
 * ************************************************************************************************
 * Name                       Date            Comments
 * Jack Tolladay              25-MAY-22       Class now parses into Account records where record type is store..
 * Devendra Villa(EPAM)       26-DEC-22       CRM-619 as part of the Code Refactoring for Salesforce Code Analyzer
 */
public class QueueableStoreInfoSyncWithYext implements Queueable, Database.AllowsCallouts {
    private final String metadataRecordName = 'Request_Param';
    String yextReqBasePath;
    String notifyEmail;
    String storeAccountRecordTypeName = 'Store';
    /**
    * @description  : Calling function which called from all the other apex classes from the catch block
    * @author       : Anshul Sharma
**/
    public QueueableStoreInfoSyncWithYext() {
        Store_Location_Yext_Setting__mdt yextReqSetting = [SELECT Yext_Entity_URL__c, V_Param__c, API_Key__c, Notify_Email__c FROM Store_Location_Yext_Setting__mdt WHERE QualifiedApiName = :metadataRecordName];
        notifyEmail = yextReqSetting.Notify_Email__c;
        yextReqBasePath = yextReqSetting.Yext_Entity_URL__c + '?api_key=' + yextReqSetting.API_Key__c + '&v=' + yextReqSetting.V_Param__c + '&entityTypes=location';
    }
    /**
    * @description  : Calling function which called from all the other apex classes from the catch block
    * @author       : Anshul sharma
    * @param    qc as queueable context
**/
    public void execute(QueueableContext qc) {
        List<Account> storeLocationRecords = new List<Account>();
        
        String pageToken = '';
        Boolean requestMoreRecords = true;
        while(requestMoreRecords) {
            String yextRequestURL = getYextRequestURL(pageToken);
            HttpResponse httpResponse;
            try {    
                httpResponse = sendHTTPRequestToYext(yextRequestURL); 
            } catch (System.CalloutException ex) {
                CustomException.logException(ex, notifyEmail);
            }
            
            if (httpResponse != null) {
                YextResponseWrapper responseWrapper;
                try {
                    responseWrapper = parseResponseIntoWrapper(httpResponse);
                    storeLocationRecords.addAll(prepareStoreLocationRecords(responseWrapper));
                    pageToken = responseWrapper.response.pageToken;
                } catch (Exception e) {
                    CustomException.logException(e, notifyEmail);
                }
            }
            if (String.isBlank(pageToken) || httpResponse == null){
                requestMoreRecords = false;
            }
        }
        if (storeLocationRecords.size() > 0) {
            try {
                upsert storeLocationRecords ;
            } catch (DmlException e) {
                CustomException.logException(e, notifyEmail);
            }
        }
    }
    
    //Method: To prepare request URL for http callout
    //If pagetoken is available in response then query for more
    //Default limit to get records is 10 so set the limit to 50 to fetch more in one go
    private String getYextRequestURL(String pageToken) {
        String yextRequestURL = yextReqBasePath;
        if (!String.isBlank(pageToken)) {
            yextRequestURL += ('&pageToken='+pageToken);
        }
        yextRequestURL += '&limit=50';
        return yextRequestURL;
    }
    
    //Method: Send Http GET request to Yext
    private HTTPResponse sendHTTPRequestToYext(String yextRequestURL){
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint(yextRequestURL);
        httpRequest.setMethod('GET');
        Http http = new Http();
        HTTPResponse httpResponse = http.send(httpRequest);
        return httpResponse;
    }
    
    //Method: To parse http response into wrapper class
    //Salesforce reserved keywords are present in response so replacing with custom keywords i.e. End-> endTime and date-> holidayDate
    private YextResponseWrapper parseResponseIntoWrapper(HttpResponse httpResponse) {
        String responseBodyWithoutReservedKeyword = httpResponse.getBody().replaceAll('"end"','"endTime"').replaceAll('"date"','"holidayDate"');
        YextResponseWrapper responseWrapper =(YextResponseWrapper) JSON.deserialize(responseBodyWithoutReservedKeyword, YextResponseWrapper.class);
        return responseWrapper;
    }
    
    //Method: To prepare Store_location record list from parsed http response wrapper 
    private List<Account> prepareStoreLocationRecords(YextResponseWrapper storeInfo){
        List<RecordType> recordTypeList = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Account' AND Name =: storeAccountRecordTypeName LIMIT 1];
        List<Account> storeLocationRecords = new List<Account>();
        for (YextResponseWrapper.cls_entities e: storeInfo.response.entities) {
            Account storeLocation = new Account();
            storeLocation.RecordTypeId = recordTypeList[0] != null ? recordTypeList[0].Id : '';
            storeLocation.Name = e.name;
            storeLocation.Address_Line_1__c = e.address != null ? e.address.line1 : '';
            storeLocation.Address_Line_2__c = e.address != null ? e.address.line2 : '';
            storeLocation.City__c = e.address != null ? e.address.city : '';
            storeLocation.State__c = e.address != null ? e.address.region : '';
            storeLocation.ZIP__c = e.address != null ? e.address.postalCode : '';
            storeLocation.BillingStreet = e.address != null ? e.address.line1 : '' + e.address.line2 != null ? ' ' + e.address.line2 : '';
            storeLocation.BillingCity= e.address != null ? e.address.city : '';
            storeLocation.BillingState = e.address != null ? e.address.region : '';
            storeLocation.BillingPostalCode = e.address != null ? e.address.postalCode : '';
            storeLocation.BillingCountry= e.address != null ? e.address.countryCode : '';
            storeLocation.Country_Code__c = e.address != null ? e.address.countryCode : '';
            storeLocation.Phone = e.mainPhone;
            storeLocation.Website = e.websiteUrl != null ? e.websiteUrl.url : '';
            storeLocation.Store_Id__c = e.meta.Id;
            storeLocation.Active_Store__c = e.closed != null ? !e.closed : false;
            storeLocation.Additional_Hours_Text__c = e.additionalHoursText;
            if (e.hours != null && e.hours.monday != null && e.hours.monday.openIntervals != null) {
                storeLocation.Monday_Hours__c = 'Monday ' + e.hours.monday.openIntervals[0].start +' - '+ e.hours.monday.openIntervals[0].endTime;
            }
            if (e.hours != null && e.hours.monday != null && e.hours.tuesday.openIntervals != null) {
                storeLocation.Tuesday_Hours__c = 'Tuesday ' + e.hours.tuesday.openIntervals[0].start +' - '+ e.hours.tuesday.openIntervals[0].endTime;
            }
            if (e.hours != null && e.hours.monday != null && e.hours.wednesday.openIntervals != null) {
                storeLocation.Wednesday_Hours__c = 'Wednesday ' + e.hours.wednesday.openIntervals[0].start +' - '+ e.hours.wednesday.openIntervals[0].endTime;
            }
            if (e.hours != null && e.hours.monday != null && e.hours.thursday.openIntervals != null) {
                storeLocation.Thursday_Hours__c = 'Thursday ' + e.hours.thursday.openIntervals[0].start +' - '+ e.hours.thursday.openIntervals[0].endTime;
            }
            if (e.hours != null && e.hours.monday != null && e.hours.friday.openIntervals != null) {
                storeLocation.Friday_Hours__c = 'Friday ' + e.hours.friday.openIntervals[0].start +' - '+ e.hours.friday.openIntervals[0].endTime;
            }
            if (e.hours != null && e.hours.monday != null && e.hours.saturday.openIntervals != null) {
                storeLocation.Saturday_Hours__c = 'Saturday ' + e.hours.saturday.openIntervals[0].start +' - '+ e.hours.saturday.openIntervals[0].endTime;
            } 
            if (e.hours != null && e.hours.monday != null && e.hours.sunday.openIntervals != null) {
                storeLocation.Sunday_Hours__c = 'Sunday ' + e.hours.sunday.openIntervals[0].start +' - '+ e.hours.sunday.openIntervals[0].endTime;
            }
            if (e.hours != null && e.hours.holidayHours != null && e.hours.holidayHours.size() > 0) {
                Boolean firstElement = true;
                for (YextResponseWrapper.cls_holidayHours hh : e.hours.holidayHours) {
                    if (!firstElement) {
                        storeLocation.Holiday_Hours__c += ', ';
                    } else {
                        storeLocation.Holiday_Hours__c = '';
                        firstElement = false;
                    }
                    if (hh.openIntervals != null) {
                        storeLocation.Holiday_Hours__c += hh.holidayDate + '::' + hh.openIntervals[0].start +' - '+ hh.openIntervals[0].endTime;
                    } else if (hh.isClosed != null) {
                        storeLocation.Holiday_Hours__c += hh.holidayDate + '::' + (hh.isClosed ? 'CLOSED' : 'OPEN') ;
                    }
                }
            }            
            storeLocationRecords.add(storeLocation);
        }
        return storeLocationRecords;
    }
}
/**
 * @Project : Primark
 * @Author  : Nitin Sourastriya
 * @Date    : 19/10/2022
 * @description : To lfetch account records.
 * ************************************************************************************************
 * Name                       Date            Comments
 * Devendra Villa(EPAM)       26-DEC-22       CRM-619 as part of the Code Refactoring for Salesforce Code Analyzer
 */
public without sharing class PersonAccountLeadUtility {
    public PersonAccountLeadUtility() {

    }
  /**
    * @description  : Calling function which called from all the other apex classes from the catch block
    * @author       : Nitin Sourastriya
    * @param      recordId to get recordId
    * @return    string
    **/
    @AuraEnabled
    public static string fetchLatestRecordID(String recordId){
        try {
            Account accExisting;
            List<Account> accNew = new List<Account>();

            if(String.IsNotBlank(recordId)){
                accNew = [SELECT Id,PersonEmail,IsDeleted FROM Account WHERE id = :recordId WITH SECURITY_ENFORCED ALL ROWS  ];
                /*accNew = [SELECT Id,PersonEmail,IsDeleted FROM Account WHERE id = :recordId ALL ROWS];
                CRM-619 as part of the Code Refactoring for Salesforce Code Analyzer */
                if(accNew!= null && !accNew.isEmpty() && accNew[0].IsDeleted ){
                    accExisting = [SELECT Id FROM Account WHERE PersonEmail = :accNew[0].PersonEmail WITH SECURITY_ENFORCED LIMIT 1];
                }
            }

            if(accExisting!=null && accExisting.id!=null){
                return accExisting.id;
            }else{
                return recordId;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
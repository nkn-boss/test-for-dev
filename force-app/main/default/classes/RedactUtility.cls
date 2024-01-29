/**
 * @Project : Primark
 * @Author  : Nitin K Nayan (EPAM)
 * @Date    : 08-NOV-2022
 * @description : Utility Class for Redaction.
 * ************************************************************************************************
 * Name                     Date            Comments
 * Nitin K Nayan (EPAM)     26-DEC-2022     CRM-619 - as part of the Code Refatroring for Salesfroce Code Analyzer
 */
public without sharing class RedactUtility {

    /**
    * @description It will take a string & check for the credit card details in it & redact it.
    * @author Nitin K Nayan | EPAM | 08-11-2022 
    * @param bodyText 
    * @return String 
    **/
    public static String redactCreditCardDetails(String bodyText){
        try{
            String regExp = '(([\\s]?[0-9]{4}[-])([0-9]{4}[-]){2}([0-9]{4}))|(([\\s]?[0-9]{4}[\\s])([0-9]{4}[\\s]){2}([0-9]{4}))|([0-9]{16})';
            Pattern cerdicardtPattern = Pattern.compile(regExp);

            system.debug('MatchOr Not-->'+cerdicardtPattern.matcher(bodyText));
            system.debug('MatchOr Not-12->'+cerdicardtPattern.matcher(bodyText).find());

            if(cerdicardtPattern.matcher(bodyText).find()){
                String creditKey = cerdicardtPattern.matcher(bodyText).replaceAll(' ####-####-####-#### ');
                system.debug('creditKey-->'+creditKey);
                system.debug('MatchOr Not-->'+cerdicardtPattern.matcher(bodyText));
                return creditKey;
            }
            
        }catch(Exception e)
        {
            CustomException.logException(e);
        }

        return bodyText;
    }
}
/**
 * @Project : Primark
 * @Author  : Tanya Jain
 * @Date    : 15/10/2022
 * @description : To Fetch Escalation Keyword Metadata and assign them to Escalation Queue.
 * ************************************************************************************************
 * Name                       Date            Comments
 * Devendra Villa(EPAM)       26-DEC-22       CRM-619 as part of the Code Refactoring for Salesforce Code Analyzer
 * Nitin K Nayan(EPAM)        07-FEB-23       DIGIX-1034 TO remove Store support cases from esacaltion  
 */
public with sharing class CaseEscalationTriggerHelper {

    public static Id clpRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Case' AND Name = 'CLP' LIMIT 1].Id;
    public static Id storeRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Store_Support').getRecordTypeId();
    public static Id storeInternalRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Internal_Store_Support').getRecordTypeId();
    public static Boolean firstApperence = false;
    public static Boolean secondApperence = false;
    public static Boolean flag = false;
    

    /**
    * @description  : to get keyword list
    * @author       : Tanya Jain
    * @param     labels to get the labels
    * @return       : List
**/
public static List<String> getKeywordList(String labels){
        Map<String, Escalation_Keyword__mdt> mcs = Escalation_Keyword__mdt.getAll();
        List<String> keywordValuesString = new List<String>();
        for(String key : mcs.keySet()){
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(mcs.get(key)));
            for(String label : m.keySet()){
                Object obj = m.get(label);
                if(label.toLowerCase().contains('label')&& label.contains(labels)&& obj != null){
                    keywordValuesString.add(String.valueOf(obj));
                }
            }   
        }
        
        //system.debug('keywordValuesString-->'+keywordValuesString);CRM-619 as part of the Code Refactoring for Salesforce Code Analyzer
        return keywordValuesString;
    }

    /**
    * @description  : TO ROUTE CASES
    * @author       : Tanya Jain
    * @param     caseList to get the caseList
**/
    public static void routeCases(List<Case> caseList){
        
        Group escalationQueue = [SELECT Id, DeveloperName from Group WHERE Type = 'Queue' AND Name = 'Escalations'][0];
        String language;
        Queue_Language__mdt[] queueLangMdt=[SELECT Customer_Language__c,Queue_Developer_Name__c,Store_Queue_Developer_Name__c from Queue_Language__mdt WITH SECURITY_ENFORCED];
        Map<String,Queue_Language__mdt> queueLangMdtMap = new  Map<String,Queue_Language__mdt>();
        for(Queue_Language__mdt qmtd : queueLangMdt){
            queueLangMdtMap.put(qmtd.Queue_Developer_Name__c,qmtd);
            queueLangMdtMap.put(qmtd.Store_Queue_Developer_Name__c,qmtd);
        }
        for(Case cs : caseList){
            if(cs.OwnerId!= null && cs.ownerid.getsobjecttype() == Group.SobjectType && cs.RecordTypeId != storeRecordTypeId && cs.RecordTypeId != storeInternalRecordTypeId && cs.RecordTypeId != clpRecordTypeId && queueLangMdtMap!=null && queueLangMdtMap.containsKey(cs.Owner_DeveloperName__c) && queueLangMdtMap.get(cs.Owner_DeveloperName__c)!=null){
                language = queueLangMdtMap.get(cs.Owner_DeveloperName__c).Customer_Language__c; 
                // System.debug('Language1 is'+ language);//CRM-619 as part of the Code Refactoring for Salesforce Code Analyzer
                String lan= multiCountryLangCheck(language);
                //Get all the escalation keywords
                List<String> keywordValues = getKeywordList(lan);
                
                String caseSubject = cs.Subject != null ? cs.Subject.toLowerCase() : '';
                String caseDesc = cs.Description != null ? cs.Description.toLowerCase() : '';
                    
                if(keywordCheck(keywordValues,caseSubject,caseDesc)){
                    cs.OwnerId = escalationQueue.Id;
                    cs.IsEscalated = true;
                    break;
                } 
            }          
        }  
    }
    /**
    * @description  : Keyword check
    * @author       : Tanya Jain
    * @param  keywordValues
    * @param  caseSubject
    * @param  caseDesc
    * @return :Boolean   
**/
    public static Boolean keywordCheck(List<String> keywordValues,String caseSubject,String caseDesc){
        List<String> sub = caseSubject.split(' ');
        List<String> des = caseDesc.split(' ');
        flag = false;
        for(String escKeyWrd : keywordValues){
            String escKey = escKeyWrd.toLowerCase();
            if(!escKey.contains(' ') && (sub.contains(escKey) || des.contains(escKey))){
                flag = true;
                break;
            }else if(escKey.contains(' ')){
                flag = checkOnSubjectDescription(escKey,sub,des);
                if(flag){break;}
            }
        }
        return flag;
    }
    /**
    * @description  : multicountry language check
    * @author       : Tanya Jain
    * @param  language
    * @return : String   
**/
    public static string multiCountryLangCheck(String language){
        if(language== 'English UK' || language== 'English USA' || language== 'English ROI'){
            language = 'English';
        } else if(language == null){
            language='Label';
            
        }
        return language;
        
    }
    /**
    * @description  : multicountry language check
    * @author       : Tanya Jain
    * @param  escKey
    * @param  sub
    * @param  des
    * @return : Boolean  
**/
    public static Boolean checkOnSubjectDescription(String escKey,String [] sub,String [] des){
        //Boolean flag = false;
        List<String> temp = escKey.split(' '); 
        Integer subCount = 0;//Store the Substraction for index of the keywords
        Integer desCount = 0;

        firstApperence = false;
        secondApperence = false;

        
        for(Integer i=0;i<temp.size();i++){
            
            subCount = calculateKeywordCount(sub,temp[i],subCount);
            desCount = calculateKeywordCount(des,temp[i],desCount);
        }
        if(secondApperence && (subCount==1 || desCount ==1) ){
            flag = true;
        }
        return flag;
        
    }
    /**
    * @description  : multicountry language check
    * @author       : Tanya Jain
    * @param  tempStr
    * @param  temp
    * @param  count
    * @return : Integer  
**/
    public static Integer calculateKeywordCount(String [] tempStr, String temp, Integer count){
        
        if(tempStr.contains(temp)){
            if(!firstApperence){
                count = tempStr.IndexOf(temp);
                firstApperence = true;
            }else{
                secondApperence = true;
                count = tempStr.IndexOf(temp) - count;
            } 
        }
        return count;
    }
}
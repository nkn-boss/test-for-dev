/**
 * @Project : Primark
 * @Author  : Nitin K Nayan (EPAM)
 * @Date    : 26-DEC-22
 * @description : Untility class to check the CRUD for the DML Opreations
 * ************************************************************************************************
 * Name                 Date            Comments
 * 
 */
public with sharing class DML_CRUDEnforce_Utility {
        
         /**
        * @description  : For INSERT
        * @author       : Nitin K Nayan(EPAM)
        * @param        objList SObject List to be inserted.
        **/
        public static void dmlInsert(List<SObject> objList)
        {
            if (objList == null || objList.isEmpty()) {return;}
            SObjectType myType = objList[0].getSObjectType();
            if (myType.getDescribe().isCreateable() == false) {
                throw new CustomException('You have no permission to insert this object: ' + myType);
            }

            new FLSCheck(false).check(objList, myType);
            insert objList;
        }

        /**
        * @description  : For UPDATE
        * @author       : Nitin K Nayan(EPAM)
        * @param       objList Object List to be updated.
        **/
        public static void dmlUpdate(List<SObject> objList)
        {
            if (objList == null || objList.isEmpty()) {return;}
            SObjectType myType = objList[0].getSObjectType();
            if (myType.getDescribe().isUpdateable() == false) {
                throw new CustomException('You have no permission to update this object: ' + myType);
            }

            new FLSCheck(true).check(objList, myType);
            update objList;
        }

         /**
        * @description  : For DELETE
        * @author       : Nitin K Nayan(EPAM)
        * @param       objList SObject List to be deleted.
        **/
        // Not needed as there is no Delete Operation being used
        /*
        public static void dmlDelete(List<SObject> objList)
        {
            if (objList == null || objList.isEmpty()) {return;}
            SObjectType myType = objList[0].getSObjectType();
            if (myType.getDescribe().isDeletable() == false) {
                throw new CustomException('You have no permission to delete this object: ' + myType);
            }
            delete objList;
        }
        */

     /**
        * @description  : Inner class for the FLS check.
        * @author       : Nitin K Nayan(EPAM)
    **/
    class FLSCheck {
        private Boolean updateable;
       /**
        * @description  : Inner class for the FLS check.
        * @author       : Nitin K Nayan(EPAM)
        * @param updateable
    **/
        public FLSCheck(Boolean updateable) {
            this.updateable = updateable;
        }

         /**
        * @description  : To check the FLS
        * @author       : Nitin K Nayan(EPAM)
        * @param        objList  List & Sobject Type
        * @param       myType
        **/
        public void check(SObject[] objList, SObjectType myType) {
            
            for (SObject so : objList) {
                Map<String, Schema.SObjectField> fieldMap = myType.getDescribe().fields.getMap();
                for (String fieldName : so.getPopulatedFieldsAsMap().keySet()) {
                    if (fieldName == 'Id') {continue;}
                    
                    //To Exclude any Custom Field for which there is no need to check the CRUD,just uncomment the below if statement & use it.
                    //if (fieldName == 'Geolocation__c') continue;

                    Schema.SObjectField myField = fieldMap.get(fieldName);
                    if (myField == null) {continue;}
                    throwException(this.updateable,myField,myType);

                    // if (this.updateable == true && myField.getDescribe().isUpdateable() == false) {
                    //     throw new CustomException('You have no permission to update this field: ' + myField + ' on this object ' + myType);
                    // } else if (myField.getDescribe().isCreateable() == false){
                    //     throw new CustomException('You have no permission to create this field: ' + myField + ' on this object ' + myType);
                    //     }                        
                    // }
                }
            }
        }

        /**
        * @description  : To throw a exception
        * @author       : Nitin K Nayan(EPAM)
        * @param       updateable
        * @param       myField
        * @param       myType
        **/
        public void throwException(Boolean updateable,Schema.SObjectField myField,SObjectType myType){
            if (updateable == true && myField.getDescribe().isUpdateable() == false) {
                throw new CustomException('You have no permission to update this field: ' + myField + ' on this object ' + myType);
            } else if (myField.getDescribe().isCreateable() == false){
                throw new CustomException('You have no permission to create this field: ' + myField + ' on this object ' + myType);
                }
        }
    }
}
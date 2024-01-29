import { LightningElement, wire,track } from 'lwc';
import { getObjectInfo, getPicklistValues  } from 'lightning/uiObjectInfoApi';
import { updateRecord } from 'lightning/uiRecordApi';
import CHATBOT_COPYTEXT_OBJECT from '@salesforce/schema/Chatbot_Copy_Text__c';
import LOCALE_FIELD from '@salesforce/schema/Chatbot_Copy_Text__c.Locale__c';

import FetchCopyTexts from '@salesforce/apex/ChatBotCopyTextUpdateController.getCoptTexts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [
    { label: 'Text', fieldName: 'Text__c',editable: true, wrapText: true, type: 'customRichText'},
    { label: 'Previous Text', fieldName: 'Previous_Text__c', wrapText: true, editable: false, displayReadOnlyIcon: true},
    { label: 'Last Updated By', fieldName: 'Last_Updated_By__c', editable: false},
    { label: 'Last Updated Date', fieldName: 'LastModifiedDate', editable: false, type: 'date',
        typeAttributes:{
            year: "numeric",
            month: "short",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit"
    }
}
];

const fieldNames = ['Text__c','Previous_Text__c','Last_Updated_By__c','LastModifiedDate'];


export default class ChatBotCopyTextUpdate extends LightningElement {
    selectedLocale = '';
    selectedBox = '';
    localeOptions = [];
    boxOptions = [];
    @track records = [];
    recordsPresent = false;
    editing = false;
    editingText = '';
    editingList = [];
    selectedRows = [];
    @track allLocaleRecords;
    draftValues = [];

    @wire(getObjectInfo, { objectApiName: CHATBOT_COPYTEXT_OBJECT })
    objectInfo;

    @wire(getPicklistValues, {
        recordTypeId: '$objectInfo.data.defaultRecordTypeId',
        fieldApiName: LOCALE_FIELD,
      })
      getPicklistValuesForField({ data, error }) {
        if (error) {
          // TODO: Error handling
          console.error(error)
        } else if (data) {
          this.localeOptions = [...data.values]
        }
      }


    handleLocaleChange(event) {
        //console.log('localechange-->1');
        this.selectedLocale = event.detail.value;
        this.editing = false;
        this.boxOptions = [];
        this.selectedBox = '';
        this.records = [];
        //console.log('localechange-->2'+this.selectedLocale);
        this.fetchCopytextMethod();
        //console.log('localechange-->3');   
    }

    fetchCopytextMethod(){
        FetchCopyTexts({ locale: this.selectedLocale })
            .then((result) => {
                //console.log('FetchCopyTexts 1-->'+result);
                this.allLocaleRecords = result.chatBotCopyTextMap;
                this.records = [];
                if(this.selectedBox!=''){
                    this.loadRecords(); 
                }
                let options = [];
                 
                for (var key in result.dialogues) {
                    // Here key will have index of list of records starting from 0,1,2,....
                    options.push({ label: result.dialogues[key], value: result.dialogues[key]  });
                    // Here Name and Id are fields from sObject list.
                }

                this.boxOptions = options;
                this.error = undefined;
                //console.log('FetchCopyTexts 2-->'+ this.boxOptions);
            })
            .catch((error) => {
                this.error = error;
                //console.log('FetchCopyTexts 3-->'+error);
            });
    }

    handleBoxChange(event) {
        this.selectedBox = event.detail.value;
        this.loadRecords();
    }

    loadRecords(){
        this.records = this.allLocaleRecords?.[this.selectedBox];
        this.recordsPresent = true;
    }

    handleSubmit(event){
        this.handleSave(event);

    }

    async handleSave(event) {
        // Convert datatable draft values into record objects
        const records1 = event.detail.draftValues.slice().map((draftValue) => {
            const fields = Object.assign({}, draftValue);
            return { fields };
        });

        // Clear all datatable draft values
        this.draftValues = [];

        try {
            // Update all records in parallel thanks to the UI API
            const recordUpdatePromises = records1.map((record) =>
                updateRecord(record)
            );
            await Promise.all(recordUpdatePromises);

            // Report success with a toast
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'ChatBotCopy Text updated',
                    variant: 'success'
                })
            );

            // Display fresh data in the datatable
            //await refreshApex(this.contacts);
        this.records = [];
        this.recordsPresent = false;
        this.fetchCopytextMethod();
        this.loadRecords();

        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating or reloading copytext.',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        }
    }

    
    get boxOptionsDisabled() {
        return !this.selectedLocale;
    }
    
    get columns() {
        return columns;
    }
    get fieldNames(){
        return fieldNames;
    }
    
    get recordsExist() {
        console.log('recordsExist-->');
        return this.records.length > 0;
    }

}
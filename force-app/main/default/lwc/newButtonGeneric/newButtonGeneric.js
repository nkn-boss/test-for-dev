import { LightningElement,wire,track,api} from 'lwc';

import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import fetchRecordId from '@salesforce/apex/PersonAccountLeadUtility.fetchLatestRecordID';

export default class NewButtonGeneric extends NavigationMixin(LightningElement) {

    @api
    objectApiName;

    objRecordId;

    showModal = true;

    recordTypeId ;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.recordTypeId = currentPageReference.state?.recordTypeId;
       }
    }

    handleSuccess (event){
        const even = new ShowToastEvent({
            title: 'Success!',
            message: 'Record created!',
            variant: 'success'
        });
        this.dispatchEvent(even);
        //this.objRecordId = event.detail.id;
        console.log('currentREcordId-->'+event.detail.id);
        fetchRecordId({ recordId: event.detail.id })
        .then((result) => {
            console.info('result-->',result);
            this.objRecordId = result;
            this.error = undefined;
            this.navigateToRecordViewPage(event.detail.id);
        })
        .catch((error) => {
            console.info('error-->',error);
            this.error = error;
            this.objRecordId = undefined;
        });
    }

    handleError (event){
        console.info ('event.detail.detail-->'+event.detail.error );
        console.info('test-->'+this.template.querySelectorAll('lightning-input'))
        inputf = this.template.querySelectorAll('lightning-input');

        if (inputf) {
            inputf.forEach(field => {
                console.log('1-->'+field.text);
            });
        }

        const evt = new ShowToastEvent({
            title: 'Error!',
            message: event.detail.detail,
            variant: 'error',
            mode:'dismissable'
        });
        this.dispatchEvent(evt);
        // if(event.detail.detail == 'The requested resource does not exist'){
        //     fetchRecordId({ recordId: event.detail.id })
        //     .then((result) => {
        //         console.info('result-->',result);
        //         this.objRecordId = result;
        //         this.error = undefined;
        //         this.navigateToRecordViewPage(event.detail.id);
        //     })
        //     .catch((error) => {
        //         console.info('error-->',error);
        //         this.error = error;
        //         this.objRecordId = undefined;
        //     });
        // }else{
        //     const evt = new ShowToastEvent({
        //         title: 'Error!',
        //         message: event.detail.detail,
        //         variant: 'error',
        //         mode:'dismissable'
        //     });
        //     this.dispatchEvent(evt);
        // }
        
    }

    handleCancel (){
         // Navigate to the Accounts object's Recent list view.
         this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: this.objectApiName,
                actionName: 'list'
            },
            state: {
                filterName: 'Recent' 
            }
        });
    }

    navigateToRecordViewPage(recId) {
        // View a custom object record.
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recId,
                objectApiName: this.objectApiName,
                actionName: 'view'
            }
        });
    }
}
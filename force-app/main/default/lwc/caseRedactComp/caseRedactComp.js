import { LightningElement,api } from 'lwc';
import LightningConfirm from 'lightning/confirm';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import fetchCase from '@salesforce/apex/CaseRedactController.fetchCase';
import fetchCaseComments from '@salesforce/apex/CaseRedactController.fetchCaseComments';
import updateCase from '@salesforce/apex/CaseRedactController.updateCase';
import updateCaseComments from '@salesforce/apex/CaseRedactController.updateCaseComments';
import fetchChat from '@salesforce/apex/CaseRedactController.fetchChat';
import updateChat from '@salesforce/apex/CaseRedactController.updateChat';


export default class CaseRedactComp extends LightningElement {

    @api recordId;
    @api objectApiName;

    loaded=true;
    caseDescription;
    redactCaseDescription;
    caseComments;
    redactCaseComment;
    case;
    selectedText = '';
    chatBody;
    redactChatBody;
    LiveChatTranscript;

    isCase = false;
    isLiveChatTranscript = false;




    connectedCallback(){
        
        if(this.objectApiName === 'Case'){
            this.isCase = true;
            this.getCase();
            this.getCaseComments();
        }
        else if(this.objectApiName === 'LiveChatTranscript'){
            this.isLiveChatTranscript = true;
            this.getLiveChatTranscript();
        }
    }

    updateRedactText(objectName,Id,redactText){
        this.loaded = false;
        if(objectName=='Case'){
            updateCase({ caseId: Id, redactDescription: redactText})
            .then((result) => {
                this.error = undefined;
                this.showNotification('Redacted Successfully !!!','Case has been update.','success');
                this.getCase();
                this.loaded = true;
                getRecordNotifyChange([{recordId: Id}]);
            })
            .catch((error) => {
                this.error = error;
            });
        }

        if(objectName=='CaseComment'){
            updateCaseComments({ commentId: Id, redactComment: redactText})
            .then((result) => {
                this.error = undefined;
                this.showNotification('Redacted Successfully !!!','CaseComment has been update.','success');
                this.getCaseComments();
                this.loaded = true;
                getRecordNotifyChange([{recordId: Id}]);
            })
            .catch((error) => {
                this.error = error;
            });
        }

        if(objectName=='LiveChatTranscript'){
            updateChat({ chatId: Id, redactBody: redactText})
            .then((result) => {
                this.error = undefined;
                this.showNotification('Redacted Successfully !!!','Chat has been update.','success');
                this.getLiveChatTranscript();
                this.loaded = true;
                getRecordNotifyChange([{recordId: Id}]);
            })
            .catch((error) => {
                this.error = error;
            });
        }      

    }

    getCase() {
        this.loaded = false;
        fetchCase({ caseId: this.recordId })
            .then((result) => {
                this.case = result;
                this.caseDescription = this.case.Description;
                this.error = undefined;
                this.loaded = true;
            })
            .catch((error) => {
                this.error = error;
                this.case = undefined;
            });
    }

    getCaseComments() {
        this.loaded = false;
        fetchCaseComments({ caseId: this.recordId })
            .then((result) => {
                if(result.length > 0){
                    this.caseComments = result;
                }
                this.error = undefined;
                this.loaded = true;
            })
            .catch((error) => {
                this.error = error;
                this.caseComments = undefined;
            });
    }

    getLiveChatTranscript() {
        this.loaded = false;
        fetchChat({ chatId: this.recordId })
            .then((result) => {
                this.LiveChatTranscript = result;
                this.chatBody = this.LiveChatTranscript.Body;
                this.error = undefined;
                this.loaded = true;
            })
            .catch((error) => {
                this.error = error;
                this.case = undefined;
            });
    }

    handleCaseRedact(){
        // document.getSelection
            let selectedText = this.getSelectedText();
            const range = selectedText.getRangeAt(0);
        if(this.selectedText.length > 0){
            let selectedTextArray = this.selectedText.split(/\r?\n/).filter(element => element);
    
            this.redactCaseDescription = this.caseDescription;
            selectedTextArray.forEach(element => {
                let replaceStr = this.createRedactString(element.length);
                //this.redactCaseDescription = this.redactCaseDescription.replace(element,replaceStr);
                this.redactCaseDescription = this.redactCaseDescription.substring(0, range.startOffset) + replaceStr + this.redactCaseDescription.substring(range.endOffset);
            });
    
            this.handleConfirmClick('Case',this.recordId,this.redactCaseDescription);
        }else{
            this.showNotification('Please Select the text to redact.','','error');
        }
       
    }

    async handleConfirmClick(objName,objId,redactText) {
        const result = await LightningConfirm.open({
            message: redactText,
            label: 'See below a preview how the information will be displayed once redacted. This cannot be amended. Press OK to continue.',
            // setting theme would have no effect
        });
        //Confirm has been closed
        //result is true if OK was clicked
        //and false if cancel was clicked
        if(result){
            this.updateRedactText(objName,objId,redactText);
        }
    }

    handleCommentRedact(event){
        // document.getSelection
        let selectedText = this.getSelectedText();
        const range = selectedText.getRangeAt(0);
        if(this.selectedText.length > 0){
            let selectedCommentId;
            selectedCommentId = event.target.value;

            let selectedTextArray = this.selectedText.split(/\r?\n/).filter(element => element);

            this.redactCaseComment = selectedText.anchorNode.textContent;
            selectedTextArray.forEach(element => {
                let replaceStr = this.createRedactString(element.length);
                //this.redactCaseComment = this.redactCaseComment.replace(element,replaceStr);
                this.redactCaseComment = this.redactCaseComment.substring(0, range.startOffset) + replaceStr + this.redactCaseComment.substring(range.endOffset);
            });

            this.handleConfirmClick('CaseComment',selectedCommentId,this.redactCaseComment);
        }else{
            this.showNotification('Please Select the text to redact.','','error');
        }
        
    }

    handleChatRedact(){
        // document.getSelection
        let selectedText = this.getSelectedText();
        const range = selectedText.getRangeAt(0);
        if(this.selectedText.length > 0){
            let selectedTextArray = this.selectedText.split(/\r?\n/).filter(element => element);

            this.redactChatBody = this.chatBody;
            selectedTextArray.forEach(element => {
                let replaceStr = this.createRedactString(element.length);
                //this.redactChatBody = this.redactChatBody.replace(element,replaceStr);
                this.redactChatBody = this.redactChatBody.substring(0, range.startOffset) + replaceStr + this.redactChatBody.substring(range.endOffset);
            });
    
            this.handleConfirmClick('LiveChatTranscript',this.recordId,this.redactChatBody);
        }else{
            this.showNotification('Please Select the text to redact.','','error');
        }
       
    }

    async handleConfirmClick(objName,objId,redactText) {
        const result = await LightningConfirm.open({
            message: redactText,
            label: 'See below a preview how the information will be displayed once redacted. This cannot be amended. Press OK to continue.',
            // setting theme would have no effect
        });
        //Confirm has been closed
        //result is true if OK was clicked
        //and false if cancel was clicked
        if(result){
            this.updateRedactText(objName,objId,redactText);
        }
    }

    getSelectedText(){
        let selectedText;
        if (document.getSelection) {
            selectedText = document.getSelection();
            this.selectedText = selectedText.toString();
        }
        return selectedText;
    }

    showNotification(title,message,variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    createRedactString(length){
        let tempStr = '\u2588';
        for(let i=0 ; i<length-1 ; i ++){
            tempStr = tempStr+'\u2588';
        }

        return tempStr;
    }

    
}
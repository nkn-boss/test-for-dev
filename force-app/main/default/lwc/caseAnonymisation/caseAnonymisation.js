import { LightningElement, track, wire } from "lwc";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import runFirstJob from "@salesforce/apex/CaseAnonymisationController.runFirstJob";
import scheduleJob from "@salesforce/apex/CaseAnonymisationController.scheduleJob";
export default class CaseAnonymisation extends LightningElement {
  
  methodName = "anonymiseCaseRecord";
  @track objectName;
 // @track caseId;
  currentCronAsString;
  @track objectCheck=false;
  drpValue='';
  metadataOptions=[
    {label:'Customer Service General Enquiry  - T1 Customer Service General Enquiry', value: 'Customer Service General Enquiry  - T1 Customer Service General Enquiry'},
    {label:'Customer Service Complaint - T2 Customer Service General Enquiry', value: 'Customer Service Complaint - T2 Customer Service General Enquiry'}
  ];
  objectOptions=[
    {label:'Case', value:'Case'}
  ];

  handleDrpChange(event){
    this.drpValue=event.detail.value;
    console.log('drp:;'+ this.drpValue);
  }

	handleObjectNameChange(event) {
        this.objectName = event.target.value;
        console.log('Obj Name' +this.objectName);
        if(this.objectName=='Case'){
          this.objectCheck = true;
        }
          else{
            this.objectCheck = false;
          }
        
        }
        
   /* handleCaseIdChange(event) {
    this.caseId = event.target.value;
    console.log('case Id' +this.caseId);
    }
    */

  /*runFirstJob() {
  if (!this.objectName  || this.objectName!='Case') {
        this.showToast('Error', 'Please provide the required fields', 'error');
        return;
        }
    
    runFirstJob({objectName: this.objectName, drpName:this.drpValue})
      .then(data => {
		    this.showToast('Success', 'Case anonymized successfully', 'success');
        this.checkFirstSecurityJobStatus();
      })
      .catch(error => {    
		  this.showToast('Error', error.body.message, 'error');
      });
  } */

  showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
    });
    this.dispatchEvent(event);

    }

    
    scheduleApexJob() {
      if (!this.objectName || !this.drpValue || this.objectName!='Case') {
        this.showToast('Error', 'Please provide the required fields', 'error');
        return;
        }
      
      scheduleJob({
        cronString: this.currentCronAsString,
        objName:this.objectName,
        //caId:this.caseId,
        drpName:this.drpValue
      })
        .then(data => {
          this.showToast('Success', 'Anonymization Scheduled successfully', 'success');
          console.log(data);
        })
        .catch(error => {
          
          console.log(error.message);
        });
    }
    
    handleTimeChange(event) {
      let time = event.target.value;
      let [hour, minute, seconds] = time.split(":");
      this.currentCronAsString = `0 ${minute} ${hour} ? * * *`;
    }
    
}
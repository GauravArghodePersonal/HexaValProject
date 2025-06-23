import { LightningElement, track, api, wire } from 'lwc';
import { loadStyle } from "lightning/platformResourceLoader";
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';

import customModalStyle from '@salesforce/resourceUrl/SampleTestInformationModalCSS';
import SAMPLETESTINFORMATION_OBJECT from '@salesforce/schema/Sample_Test_Information__c';
import getPreDefinedData from '@salesforce/apex/LWCSampleTestInformationCtrl.getPreDefinedData'; 
import getListViewsData from '@salesforce/apex/LWCSampleTestInformationCtrl.getListViews'; 
import getRecordTypeMap from '@salesforce/apex/LWCSampleTestInformationCtrl.getRecordTypes'; 

import RECORD_TYPE_LABEL_EMEA_PAL_REQUEST_FORM from '@salesforce/label/c.EMEA_PAL_Request_Form';
import RECORD_TYPE_LABEL_EMEA_WAL_REQUEST_FORM from '@salesforce/label/c.EMEA_Water_Application_Lab_WAL_request';

import { getRecord } from 'lightning/uiRecordApi';//added
import TechnicalCenter from '@salesforce/schema/LWR__c.Technical_Center__c';//added
import Request from '@salesforce/schema/LWR__c.Request__c';//addednew

import NAAnalyticalPaperURL from '@salesforce/label/c.LWR_NA_Analytical_Paper_Sheet_Url';//added
import NAAnalyticalWaterURL from '@salesforce/label/c.LWR_NA_Analytical_Water_Sheet_Url';//added
import EMEAAnalyticalWaterPaperURL from '@salesforce/label/c.LWR_EMEA_Analytical_Water_And_Paper_Url';//added
import APAnalyticalConsumerSolutionUrl from '@salesforce/label/c.LWR_AP_Analytical_Consumer_Solution_Url';//added
import APAnalyticalCouponUrl from '@salesforce/label/c.LWR_AP_Analytical_Coupon_Url';//added
import APAnalyticalIndustrialSolutionUrl from '@salesforce/label/c.LWR_AP_Analytical_Industrial_Solution_Url';//added
import LAMicrobiologicalUrl from '@salesforce/label/c.LWR_LA_Microbiological_Url';//added
import LALabmaterialsUrl from '@salesforce/label/c.LWR_LA_Lab_materials_Url';//added
import LAAnalyticalUrl from '@salesforce/label/c.LWR_LA_Analytical_Url';//added
import NACouponOrderattachmentUrl from '@salesforce/label/c.LWR_NA_Coupon_Order_attachment_Url';//added
import EMEACouponOrderattachmentUrl from '@salesforce/label/c.LWR_EMEA_Coupon_Order_Attachment_Url';//added
import EMEAWRAPattachmentUrl from '@salesforce/label/c.LWR_EMEA_WRAP_attachment_Url';//added
import NAWRAPattachmentUrl from '@salesforce/label/c.LWR_NA_WRAP_attachment_Url';//added

import NATechnicalCenters from '@salesforce/label/c.LWR_NA_Technical_Centers';//added
import LATechnicalCenters from '@salesforce/label/c.LWR_LA_Technical_Centers';//added
import EMEATechnicalCenters from '@salesforce/label/c.LWR_EMEA_Technical_Centers';//added
import APACTechnicalCenters from '@salesforce/label/c.LWR_APAC_Technical_Centers';//added

export default class LWR_CreateSampleTestInformation extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName;

    @track objectInfo;
    @track recordTypeId;
    recordTypeLabel;

    @track testListOptions = [];
    @track recordTypes = [];

    @track itemList = [
        {
            id: 0,
            deleteOption:false
        }
    ];

    @track TechnicalCenter;//added
	@track radioUrlOptions = [];//added

    keyIndex = 0;

    editLoadFormLoadingComplete = false;
    displayEMEAPalRequestForm = false;
    displayAppNatureFormer = false;
    displayAppPulpRequestForm = false;
    displayPaperOrWaterAppProcessForm = false;
    displayWaterApplicationForm = false;//added
    displayLAForms = false;
    displayAPACForms = false;
    displayNAColorantForms = false;
    
    displayRecordTypeSelection = true;
    displayLightningSpinner = false;

    listViewData = [];

    connectedCallback() {
        this.displayLightningSpinner = true;
        Promise.all([
            loadStyle(this, customModalStyle)
        ])  
        getListViewsData()
        .then(result => {
            this.listViewData = result;
            console.log(JSON.stringify(result));//added
        })
        .catch(error => {
            console.log(JSON.stringify(error));  
        }); 
        getRecordTypeMap({lwrId: this.recordId})//added
        //getRecordTypeMap({})
        .then(result => {
            this.recordTypes = result;
        })
        .catch(error => {
            console.log(JSON.stringify(error)); 
        });
        this.displayLightningSpinner = false;
    }
    
    //added from 110 to 166

    @wire(getRecord, { recordId: '$recordId', fields: [TechnicalCenter,Request]})
    currentrecordInfo({error, data}) {
        if (data) {
            this.TechnicalCenter = data.fields.Technical_Center__c.value;
            this.Request = data.fields.Request__c.value;//added
            this.TechnicalCenter === null?this.TechnicalCenterNull():this.updateRadioUrlOptions();
           // this.TechnicalCenter === null?this.dispatchEvent(evt):this.updateRadioUrlOptions();
            console.log("this TechnicalCenter data" + this.TechnicalCenter)
        } else if (error) {
            this.error = error ;
        }
    }

    TechnicalCenterNull()
    {
        const evt = new ShowToastEvent({
            title: 'No Technical Center!',
            message: 'Please select the Techincal Center in LWR record before creating Sample Test Information!',
            variant: 'warning'
        });
        this.dispatchEvent(evt);
    }

       NATechnicalCentersArray = NATechnicalCenters.split(';');
       LATechnicalCentersArray = LATechnicalCenters.split(';');
       EMEATechnicalCentersArray = EMEATechnicalCenters.split(';');
       APACTechnicalCentersArray = APACTechnicalCenters.split(';');
  
      updateRadioUrlOptions() {
       // console.log("this TechnicalCenter" + this.TechnicalCenter)
       // console.log("this NATechnicalCenters " + EMEATechnicalCenters);
       // console.log("this NATechnicalCentersArray " + this.EMEATechnicalCentersArray[0]);
        
        if(this.Request=='Standard Request'||this.Request=='R&D Standard Request'){//added
        if ( this.NATechnicalCentersArray.includes(this.TechnicalCenter)) {
          this.radioUrlOptions = [
            { label: 'NA Analytical Paper', value: NAAnalyticalPaperURL },
            { label: 'NA Analytical Water', value: NAAnalyticalWaterURL }
          ];
        } 
            else if (this.EMEATechnicalCentersArray.includes(this.TechnicalCenter)) {
          this.radioUrlOptions = [
            { label: 'EMEA Analytical Water & Paper', value: EMEAAnalyticalWaterPaperURL }
          ];
        } 
            else if ( this.APACTechnicalCentersArray.includes(this.TechnicalCenter)) {
            this.radioUrlOptions = [
            { label: 'APAC Analytical Consumer Solution', value: APAnalyticalConsumerSolutionUrl },
            { label: 'APAC Analytical Coupon ', value: APAnalyticalCouponUrl },
            { label: 'APAC Analytical Industrial Solution', value: APAnalyticalIndustrialSolutionUrl }
          ];
        }
          else if (this.LATechnicalCentersArray.includes(this.TechnicalCenter)) {
          this.radioUrlOptions = [
            { label: 'LA Microbiological', value: LAMicrobiologicalUrl },
            { label: 'LA Lab Materials', value: LALabmaterialsUrl },
            { label: 'LA Analytical', value: LAAnalyticalUrl }
          ];
        }
        }
        else if(this.Request == 'Coupon Ordering'){//added
            if ( this.NATechnicalCentersArray.includes(this.TechnicalCenter)) {
                this.radioUrlOptions = [
                  { label: 'NA Coupon Order', value: NACouponOrderattachmentUrl }
                ];}
                else if (this.EMEATechnicalCentersArray.includes(this.TechnicalCenter)) {
                    this.radioUrlOptions = [
                      { label: 'EMEA Coupon Order Request', value: EMEACouponOrderattachmentUrl }
                    ];
                  }
        }
        else if(this.Request == 'New Routine Analytical Request (WRAP)'){//added
            if ( this.NATechnicalCentersArray.includes(this.TechnicalCenter)) {
                this.radioUrlOptions = [
                  { label: 'NA WRAP', value: NAWRAPattachmentUrl }
                ];}
                else if (this.EMEATechnicalCentersArray.includes(this.TechnicalCenter)) {
                    this.radioUrlOptions = [
                      { label: 'EMEA Routine Analyses (Barcode Sample)', value: EMEAWRAPattachmentUrl }
                    ];
                  }
        }
      }

      @track selectedUrl;

      handleOptionChangeUrl(event) {
        this.selectedUrl = event.detail.value;
        window.open(this.selectedUrl, '_blank');
      }
    //added

    @wire(getObjectInfo, { objectApiName: SAMPLETESTINFORMATION_OBJECT })
    objectInfo;
    
    @wire(getPicklistValuesByRecordType, { objectApiName: SAMPLETESTINFORMATION_OBJECT, recordTypeId: '$recordTypeId' }) 
    TestListPicklistValues({error, data}) {
        if(data) {
            this.testListOptions = data.picklistFieldValues.Test_List__c.values;
        }
        else if(error) {
            window.console.log('error =====> '+JSON.stringify(error));
        }
    }

    get inputVariables() {
        return [
            {
                name: 'LWRRecordId',
                type: 'String',
                value: this.recordId
            },
            {
                name: 'RecordTypeId',
                type: 'String',
                value: this.recordTypeId
            }
        ];
    }

    handleLoad(event) {
        this.displayLightningSpinner = false;
        this.editLoadFormLoadingComplete = true; 
    }

    handleRecordTypeChange(event){
        this.displayLightningSpinner = true;
        this.displayRecordTypeSelection = false;
        this.recordTypeLabel = this.getRecordTypeLabel(event.detail.value);
        this.recordTypeId = event.detail.value;
        this.resetTestList();
        switch(this.recordTypeLabel) {
            case RECORD_TYPE_LABEL_EMEA_PAL_REQUEST_FORM:            
                this.displayEMEAPalRequestForm = true;
                this.displayEMEAWalRequestForm = false;
                break;
            case RECORD_TYPE_LABEL_EMEA_WAL_REQUEST_FORM:           
                this.displayEMEAPalRequestForm = false;
                this.displayEMEAWalRequestForm = true;
                this.displayWaterAppForm = false;
                break;
            case "NA Paper Application Bench Size Press":
                this.displayAppBenchSizePressForm = true;                
                this.displayAppHandsetForm = false;
                this.displayAppPilotPaperMachineForm = false;
                this.displayAppDixonCoaterForm = false;
                this.displayAppNatureFormer = false;
                this.displayAppPulpRequestForm = false;
                this.displayPaperOrWaterAppProcessForm = false;
                this.displayWaterApplicationForm = false;
                break;
            case "NA Paper Application Handsheet":
                this.displayAppBenchSizePressForm = false;                
                this.displayAppHandsetForm = true;
                this.displayAppPilotPaperMachineForm = false;
                this.displayAppDixonCoaterForm = false;
                this.displayAppNatureFormer = false;
                this.displayAppPulpRequestForm = false;
                this.displayPaperOrWaterAppProcessForm = false;
                this.displayWaterApplicationForm = false;
                break;
            case "NA Paper Application Pilot Paper Machine":
                this.displayAppBenchSizePressForm = false;                
                this.displayAppHandsetForm = false;
                this.displayAppPilotPaperMachineForm = true;
                this.displayAppDixonCoaterForm = false;
                this.displayAppNatureFormer = false;
                this.displayAppPulpRequestForm = false;
                this.displayPaperOrWaterAppProcessForm = false;
                this.displayWaterApplicationForm = false;
                break;
            case "NA Paper Applications Dixon Coater":
                this.displayAppBenchSizePressForm = false;                
                this.displayAppHandsetForm = false;
                this.displayAppPilotPaperMachineForm = false;
                this.displayAppDixonCoaterForm = true;
                this.displayAppNatureFormer = false;
                this.displayAppPulpRequestForm = false;
                this.displayPaperOrWaterAppProcessForm = false;
                this.displayWaterApplicationForm = false;
                break;
            case "NA Paper Applications Nature Former":
                this.displayAppBenchSizePressForm = false;                
                this.displayAppHandsetForm = false;
                this.displayAppPilotPaperMachineForm = false;
                this.displayAppDixonCoaterForm = false;
                this.displayAppNatureFormer = true;
                this.displayAppPulpRequestForm = false;
                this.displayPaperOrWaterAppProcessForm = false;
                this.displayWaterApplicationForm = false;
                break;
            case "NA Paper Applications Pulp Request":
                this.displayAppBenchSizePressForm = false;                
                this.displayAppHandsetForm = false;
                this.displayAppPilotPaperMachineForm = false;
                this.displayAppDixonCoaterForm = false;
                this.displayAppNatureFormer = false;
                this.displayAppPulpRequestForm = true;
                this.displayPaperOrWaterAppProcessForm = false;
                this.displayWaterApplicationForm = false;
                break;            
            case "NA Paper Application Processes":
                this.displayAppBenchSizePressForm = false;                
                this.displayAppHandsetForm = false;
                this.displayAppPilotPaperMachineForm = false;
                this.displayAppDixonCoaterForm = false;
                this.displayAppNatureFormer = false;
                this.displayAppPulpRequestForm = false;
                this.displayPaperOrWaterAppProcessForm = true;
                this.ApplicationProcesess = true;
                this.displayWaterApplicationForm = false;
                break;           
            case "NA Paper Application Paper Testing":
                this.displayAppBenchSizePressForm = false;                
                this.displayAppHandsetForm = false;
                this.displayAppPilotPaperMachineForm = false;
                this.displayAppDixonCoaterForm = false;
                this.displayAppNatureFormer = false;
                this.displayAppPulpRequestForm = false;
                this.displayPaperOrWaterAppProcessForm = true;
                this.ApplicationProcesess = false;
                this.displayWaterApplicationForm = false;
                break;                      
            case "NA Water Applications":
                this.displayAppBenchSizePressForm = false;                
                this.displayAppHandsetForm = false;
                this.displayAppPilotPaperMachineForm = false;
                this.displayAppDixonCoaterForm = false;
                this.displayAppNatureFormer = false;
                this.displayAppPulpRequestForm = false;
                this.displayPaperOrWaterAppProcessForm = false;
                this.displayWaterApplicationForm = true;
                break;                     
            case "LA Applications":
                this.displayLAForms = true;
                break; 
            case "APAC Applications":
                this.displayAPACForms = true;
                break;
            case "NA Paper Colorant":
                this.displayNAColorantForms = true;
                break;
          }
    }

    getRecordTypeLabel(recordTypeId){        
        this.displayLightningSpinner = true;
        let result = '';  
        this.recordTypes.forEach((item) => {
            if(item.value === recordTypeId){
                result = item.label;
            }
        });
        this.displayLightningSpinner = false;
        return result;
    }

    resetTestList() {
        this.itemList = [
            {
                id: 0,
                deleteOption:false
            }
        ];
    }

    handleTestListChange(event) {
        const rowId = event.target.name;
        const testListValue = event.target.value;
        this.template.querySelectorAll('.testListHdn')[rowId].value = testListValue;
        getPreDefinedData({'recordType': this.recordTypeLabel,'testList':testListValue})
        .then(result => {
            this.template.querySelectorAll('.analyses')[rowId].value = result.Analyses__c;
            this.template.querySelectorAll('.sampleVolume')[rowId].value = result.Sample_Volume__c;
        })
        .catch(error => {
            console.log(JSON.stringify(error));            
            this.analysis = '';
            this.sampleVolume = '';
        });

    }

    handleBack(event) {        
        this.displayRecordTypeSelection = true;
        this.displayAppBenchSizePressForm = false;                
        this.displayAppHandsetForm = false;
        this.displayAppPilotPaperMachineForm = false;
        this.displayAppDixonCoaterForm = false;
        this.displayAppNatureFormer = false;
        this.displayAppPulpRequestForm = false;
        this.displayPaperOrWaterAppProcessForm = false;
        this.displayWaterApplicationForm = false;
        this.displayLAForms = false;
        this.displayAPACForms = false;
        this.displayNAColorantForms = false;
    }

    addRow() {
        ++this.keyIndex;
        this.itemList.push(
            { 
                id: this.keyIndex,
                deleteOption: true
            }
        );
    }

    removeRow(event) {
        --this.keyIndex;
        if (this.itemList.length > 1) {
            this.itemList = this.itemList.filter(function (element) {
                return parseInt(element.id) !== parseInt(event.target.dataset.id);
            });
        }
    }

    handleCreate(event) {
        event.preventDefault();
        let isVal = true;
        this.template.querySelectorAll('lightning-input-field').forEach(element => {
            isVal = isVal && element.reportValidity();
        });
        if (isVal) {
            this.template.querySelectorAll('lightning-record-edit-form').forEach(element => {
                element.submit();
            });
            
            this.redirectToListView();
        } else {
            
        }
    }

    closeAction() {
      //this.dispatchEvent(new CloseActionScreenEvent());
      window.location.reload();
    }

    get listviewId() {
        let id = 'Recent';
        this.listViewData.forEach(obj => {
            if(obj['name'] === this.recordTypeLabel) {
                id = obj['id'];
            }
        });
        return id;
    }

    handleStatusChange(event) {
        if (event.detail.status === 'FINISHED') {
            this.redirectToListView();
        } else if (event.detail.status === 'FINISHED') { 
            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'Something went wrong!',
                variant: 'error'
            });
            this.dispatchEvent(event);
            this.closeAction();
        }
    }

    redirectToListView() {
        let filterNameId = this.listviewId;
        console.log('This filter name '+filterNameId)
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Sample_Test_Information__c',
                    actionName: 'list'
                },
                state: {
                    filterName: filterNameId
                }
            });

            setTimeout(() => {
                eval("$A.get('e.force:refreshView').fire();");
            }, 1000);
            
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'Sample Test Information record(s) created succesfully',
                variant: 'success'
            });
            this.dispatchEvent(event);
            const  closeEvent = new CustomEvent("cancel",{});
            this.dispatchEvent(closeEvent);
    }
}
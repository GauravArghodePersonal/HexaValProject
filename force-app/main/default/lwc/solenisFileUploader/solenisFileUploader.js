import { LightningElement, track, api} from 'lwc';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import fileIndicate from '@salesforce/resourceUrl/GreenIndicator';

const url = '/sfc/servlet.shepherd/document/download/';

export default class SolenisFileUploader extends LightningElement {
    
    @track files = [];
    @track isPreview;
    @track currentRecId;
    @api recordId;
    @track openmodel = false;
    @track openmodel1 = true;
    @track  fileIndicatorflag =false;
    fileIndicateImg=fileIndicate;

    get acceptedFilesFormat() {
        return ['.jpg', '.jpeg', '.png', '.pdf','.docx','.ppt','.pptx','.xls','.xlsx','.gif'];
    }

    handleFileUpload(event) {
        
        let uploadedFiles = event.detail.files;

        for (let index = 0; index < uploadedFiles.length; index++) { //for(let index in uploadedFiles) {
            if ({}.hasOwnProperty.call(uploadedFiles, index)) {
                this.files = [...this.files, {
                    Id: uploadedFiles[index].documentId,
                    name: uploadedFiles[index].name,
                    src: url + uploadedFiles[index].documentId,
                    description: ''
                }];
            }
        }
        console.log(" ==== ", JSON.stringify(this.files));
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Succesful Uploads',
                message: 'Files uploaded Successfully!',
                variant: 'Success',
            }),
        );
        this.fileIndicator();
        
    }

    handleFilePreview(event) {
        let previewId = event.target.getAttribute('data-id');
        this.currentRecId = previewId;
        this.isPreview = true;
    }

    handleDelete(event) {
       
        deleteRecord(this.currentRecId)
            .then(() => {
                for (let i = 0; i < this.files.length; i++) {
                    if (this.files[i].Id === this.currentRecId) {
                        this.files.splice(i, 1);
                    }
                }

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record deleted',
                        variant: 'success'
                    })
                );
                this.isPreview = false;
                this.fileIndicator();
            }).catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
            
    }

    handleSubmit(event) {
        event.preventDefault();

        this.template.querySelector('lightning-record-edit-form').submit(event.detail.fields);
        this.isPreview = false;

        this.dispatchEvent(new ShowToastEvent({
            title: 'Success!',
            message: ' file content updated.',
            variant: 'success'
        }), );
        this.fileIndicator();
    }

    handleSuccess(event) {
        
        var description = event.detail.fields.Description;

        for (let i = 0; i < this.files.length; i++) {
            if (this.files[i].Id === this.currentRecId) {
                this.files[i].Description = description.value;
            }
        }
        this.fileIndicator();
    }
    openupload(){
        this.openmodel =true;
    }
    closeModal(){
        this.openmodel=false;
      }
      fileIndicator(){
        if(this.files.length>0){
            this.fileIndicatorflag=true;
        }
        else{
            this.fileIndicatorflag=false;
        }
        console.log('<<<inde>>>'+this.fileIndicatorflag);

      }
}
import { LightningElement, api, wire } from 'lwc';
import getRelatedFilesByRecordId from '@salesforce/apex/filePreviewAndDownloadController.getRelatedFilesByRecordId'
import {NavigationMixin} from 'lightning/navigation'
export default class B2bFilesDownloadandPreview  extends NavigationMixin(LightningElement)  {

    @api recordId='01t59000005gqdbAAA'
    filesList =[]
    @wire(getRelatedFilesByRecordId, {recordId: '$recordId'})
    wiredResult({data, error}){ 
        if(data){ 
            console.log(data)
            this.filesList = Object.keys(data).map(item=>({"label":data[item],
             "value": item,
             "url":`/sfc/servlet.shepherd/document/download/${item}`
            }))
            console.log(this.filesList)
        }
        if(error){ 
            console.log(error)
        }
    }
    previewHandler(event){
        console.log(event.target.dataset.id)
        this[NavigationMixin.Navigate]({ 
            type:'standard__namedPage',
            attributes:{ 
                pageName:'filePreview'
            },
            state:{ 
                selectedRecordId: event.target.dataset.id
            }
        })
    }
}
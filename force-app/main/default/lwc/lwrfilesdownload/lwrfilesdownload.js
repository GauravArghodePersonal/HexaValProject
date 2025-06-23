import { LightningElement, track, api} from 'lwc';
    import getfileIds from '@salesforce/apex/MassFilesDownloadLWRFiles.getfileIds';
    export default class Lwrfilesdownload extends LightningElement {
        @api recordId;
        @track fileIds = '';
        @track error = '';
        
        connectedCallback() {
            getfileIds({
                
            })
            .then(result => {
                let fileDataList = JSON.parse(JSON.stringify(result));
                let fileIdsString = '';
                if(fileDataList) {
                    for (let i in fileDataList) {
                        fileIdsString += fileDataList[i]+'/';
                    }
                }
                if(fileIdsString.length > 0) {
                    fileIdsString =fileIdsString.replace(/.$/,"?");
                }
                this.fileIds = fileIdsString;
                this.error = undefined;
            })
            .catch(error => {  console.log('error : '+JSON.stringify(error));
                this.error = error;
            });
        }
        
        get getDownloaLink() {
            return '/sfc/servlet.shepherd/version/download/'+this.fileIds;
        }
    }
import { LightningElement, track } from 'lwc';
import createFile from '@salesforce/apex/HX_FileDownloadController.createFile';

export default class hexEvalUploadFileStartName extends LightningElement {
    @track showOptions = false;
    @track selectedOption;
    @track file;

    options = [
        { label: 'Option A', value: 'A' },
        { label: 'Option B', value: 'B' },
        { label: 'Option C', value: 'C' }
    ];

    handleFile(event) {
        this.file = event.target.files[0];
        if (this.file) {
            // Show the modal for selecting options
            this.showOptions = true;
        }
    }

    handleChange(event) {
        this.selectedOption = event.detail.value;
        // Once an option is selected, create the file with the chosen option
        this.createFileWithOption();
    }

    closeModal() {
        // Close the modal when the user clicks the close button
        this.showOptions = false;
    }

    createFileWithOption() {
        let fileName = this.selectedOption + '_' + this.file.name;
        let fileReader = new FileReader();
        fileReader.onloadend = (() => {
            let fileContents = fileReader.result.split(',')[1];
            createFile({ fileName: fileName, base64Data: fileContents })
                .then(result => {
                    console.log('File created successfully: ' +JSON.stringify(result));
                })
                .catch(error => {
                    console.error('Error creating file: ' +JSON.stringify(error));
                });
        });
        fileReader.readAsDataURL(this.file);
        // Close the modal after creating the file
        this.showOptions = false;
    }
}

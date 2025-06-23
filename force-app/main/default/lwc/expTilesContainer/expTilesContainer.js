import { LightningElement, wire } from 'lwc';
import getTileDetails from '@salesforce/apex/Exp_HomePageTilesController.getTileDetails';

export default class ExpTilesContainer extends LightningElement {

    tiles;
    error;
    isSuccess;

    @wire(getTileDetails)
    wiredData({ error, data }) {
        if (data) {
            console.log('*** data => '+data);
            //this.tiles = data;
            //this.error = undefined;
            
            //this.isSuccess = (this.tiles.status === 'Success') ? true : false;
            if(data.status === 'Success') {
                this.tiles = data.tiles;
                this.error = undefined;
                this.isSuccess = true;
            } else {
                this.tiles = undefined;
                this.error = data.error.errorMessage;
                this.isSuccess = false;
            }
            console.log('*** tiles => '+this.tiles);
            
        } else if (error) {
            this.error = error;
            this.tiles = undefined;
        }
    }

}
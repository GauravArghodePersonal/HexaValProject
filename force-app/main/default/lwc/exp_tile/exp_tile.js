import { LightningElement, api } from 'lwc';
import tilesImges from '@salesforce/resourceUrl/EXP_Resource';
export default class Exp_tile extends LightningElement {
    @api tile = {tileName:'Food Packaging & Processing'};
    get tileIconLink(){
        return tilesImges+this.tile.tileImageUrl;
    }
}
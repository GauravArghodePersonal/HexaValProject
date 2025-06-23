import { LightningElement,api,track,wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import communityId from '@salesforce/community/Id';
import communityPath from '@salesforce/community/basePath';
import getBrandDetails from '@salesforce/apex/B2BBrandsLogo.getBrandDetails';

export default class B2BBrandsListPage extends LightningElement {
    @track brandsList=[];
    @track showBrandList = [];
    @api effectiveAccountId;
    @track disableNext = true;
    @track disablePrev =true;
    tempList = [];
    @track prevNumber =0;
    @track newNumber = 0;
    @track brandsList123=[];

    connectedCallback() {
        console.log('Community Path+++++++++++ ', communityPath);
        this.homePath = communityPath +'/';
        console.log('effectiveAccountId+++++++++++ in parent', this.effectiveAccountId);
        
        getBrandDetails({accountId: this.effectiveAccountId}).then(response => {

            console.log('response from getOrderLineItems++++++++',response);
            this.brandsList = JSON.parse(JSON.stringify(response));
            console.log('brandsList1234567++++++++',this.brandsList);
            console.log('brandsList1234567++++++++',this.brandsList.length);
            //this.brandsList = response;

            if(this.brandsList.length >5){
                this.disableNext = false;
                console.log('adding in brand show list123++++++++');
                this.showBrandList = this.brandsList.slice(0,5);
                this.prevNumber =0;
                this.newNumber = 4;
            }
            else{
                this.showBrandList = response;
            }
            console.log('this.showBrandList+++++' , this.showBrandList);
            console.log('this.prevNumber+++++' , this.prevNumber);
            console.log('this.newNumber+++++' , this.newNumber);
            

        }).catch(error => {
            console.log('Error: ' +error.body.message);
        });
    }

    handleNext(){
        console.log('in shandleNext+++++++' , this.newNumber);
        console.log('in shandleNext+++++++' , this.brandsList);
        this.prevNumber = this.prevNumber + 1;
        console.log('in handleNext this.prevNumber+++++++' , this.prevNumber);
        this.newNumber = this.newNumber + 1;
        console.log('in handleNext this.newNumber+++++++', this.newNumber);
        
        if(this.newNumber < this.brandsList.length-1){
            this.showBrandList = [];
            this.showBrandList = this.brandsList.slice(this.prevNumber,this.newNumber+1);
            this.disablePrev = false;
        }
        
        else{
            console.log('disabling next button++++++');
            this.disableNext = true;
            this.disablePrev = false;
            this.showBrandList = [];
            this.showBrandList = this.brandsList.slice(this.prevNumber,this.brandsList.length);
        }
        console.log('in handleNext this.showBrandList+++++++', this.showBrandList);
    }
    handlePrev(){
        console.log('in handlePrev+++++++');
        this.prevNumber = this.prevNumber -1 ;
        this.newNumber = this.newNumber -1 ;

        if(this.prevNumber > 0){
            this.showBrandList = [];
            this.showBrandList = this.brandsList.slice(this.prevNumber,this.newNumber+1);
            this.disableNext = false;
        }
        
        else{
            console.log('disabling next button++++++');
            this.disableNext = false;
            this.disablePrev = true;
            this.prevNumber =0;
            this.showBrandList = [];
            this.showBrandList = this.brandsList.slice(this.prevNumber,this.newNumber+1);
        }
    }
   
}
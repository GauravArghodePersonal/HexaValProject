import { LightningElement,wire,api,track} from 'lwc';
import getInforecast from '@salesforce/apex/inforHelper.getInforecast';
import updateInforecast from '@salesforce/apex/inforHelper.updateforecastdata';
import getOpportunityMaterial from '@salesforce/apex/inforHelper.getOpportunityMaterial';
import calculateTotalForOpportunityMaterial from '@salesforce/apex/inforHelper.calculateTotalForOpportunityMaterial';
import getMonthsyear from '@salesforce/apex/inforHelper.getMonthsyear';
import getGrandTotal from '@salesforce/apex/inforHelper.getGrandTotal';
import {refreshApex} from '@salesforce/apex';
import hasInforTableAcess from '@salesforce/customPermission/Infor_Custom_Permission';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {NavigationMixin} from 'lightning/navigation';
import InforForecastlabel from '@salesforce/label/c.Alert';
import ForeCastAlert from "lightning/alert";
//import { refreshApex } from '@salesforce/apex';
export default class Infor extends LightningElement {

 @api recordId;
 @track infordata;
 dataExists = false;
 @track wiredAccountList = [];
 @track opportunitymaterialsList = [];
 @track forecast = {};
 @track opportunitymaterial ={};
 @track forecastAvailable = false;
 showInsertSuccess = false;
 saveButtonShow = true;
 @track opportunitymaterialAvailable = false;
 showInsertClosed = false;
 monthsyr= {};
 monthsyrAvailable = false;
 @track grandTotal = {};
 grandTotalAvailable = false; 
  @track totalopportunitymaterial ={};
  @track totalOpMatAvailable =false;
response;
error;

@wire(getMonthsyear)
wiredMonthsOnly(result){
   
   if(result.data){                            
      this.monthsyr=JSON.parse(result.data);
      this.monthsyrAvailable = true;
      console.log(this.monthsyr); 

   }
}

 connectedCallback(){
  // this.getMaterialmonth();
  console.log('In connectedCallback++++');
  console.log(this.recordId);
  getInforecast({AccountId: this.recordId}).then(response => {
        console.log('response from imperative++++++++');
        console.log(response);
        this.forecast = JSON.parse(response);
        this.forecastAvailable = true;
    }).catch(error => {
        console.log('Error: ' +error.body.message);
    });

    getOpportunityMaterial({AccountId: this.recordId}).then(response => {
        console.log('response from imperative++++++++12');
        console.log(response);
        this.opportunitymaterial = response;
        this.opportunitymaterialAvailable = true;
    }).catch(error => {
        console.log('Error: ' + error.body.message);
    });

   //to calculate total using table 2 data
   calculateTotalForOpportunityMaterial({AccountId: this.recordId}).then(response => {
      console.log('total++++++++++++++++++++');
      console.log(response);
        this.totalopportunitymaterial = JSON.parse(response);
        this.totalOpMatAvailable = true; 
   }).catch(error => {
      console.log('Error: ' + error.body.message);
   });

//to get grand total
   getGrandTotal({AccountId: this.recordId}).then(response => {
        console.log('grandtotal++++++++++++++++++++');
        console.log(JSON.parse(response));
        this.grandTotal = JSON.parse(response);
         this.grandTotalAvailable = true;
   }).catch(error => {
          console.log('Error: ' + error.body.message);
   });

 }
 get isReportVisible() {
   return hasInforTableAcess;
}
 renderedCallback(){
   var today = new Date();
   let day = today.getDate();
   
    // day = 16;
   console.log(day);
   if(Number(day) < 2 || Number(day)>=15){
      //this.template.querySelector('.textbox').style.color = 'red';
       if(this.template.querySelectorAll('.monthscolor').length > 0){
         for(let i=0;i<this.template.querySelectorAll('.monthscolor').length;i++){
            this.template.querySelectorAll('.monthscolor')[i].style.backgroundColor ="rgb(230, 93, 93)";
            this.template.querySelectorAll('.monthscolor')[i].disabled=true;
          }
       }

       if(this.template.querySelectorAll('.oamonth').length > 0){
         for(let i=0;i<this.template.querySelectorAll('.oamonth').length;i++){
            console.log('in setting color of MA color after window++');
            this.template.querySelectorAll('.oamonth')[i].style.backgroundColor ="rgb(49, 112, 230)";
          }
       }
       this.saveButtonShow = false; 
       this.showInsertClosed = true;
   }

//    let  bdate = this.addBusinessDays(today,11);
//    console.log(bdate);
  }
//  addBusinessDays(originalDate, numDaysToAdd){
//    const Sunday = 0;
//    const Saturday = 6;
//    const businessday = 11;
//    let daysRemaining = numDaysToAdd;
//    const newDate = originalDate.clone();
//    console.log(day);
//    while (daysRemaining > 0) {
//      newDate.add(1, 'days');
//      if (newDate.day() !== Sunday && newDate.day() !== Saturday ) {
//        daysRemaining--;
    
//       }
//    }
//    return newDate;
//  }

   //calling from custom label
  // label={InforForecastlabel};
 handleSave() {
   let rows = this.template.querySelectorAll(".editableRows");
 	let inforecastData =[];
   for(let i=0;i<rows.length;i++){
    let row_cls = {};
    let row_data =[];
    console.log(rows[i].querySelector('month3'));
    row_data["inforid"]= rows[i].querySelector('.inforid').value;
    row_data["month3"]= rows[i].querySelector('.month3').value;
    row_data["month4"]= rows[i].querySelector('.month4').value;
    row_data["month5"]= rows[i].querySelector('.month5').value;
    row_data["month6"]= rows[i].querySelector('.month6').value;//added
    row_data["month7"]= rows[i].querySelector('.month7').value;//added
    row_data["month8"]= rows[i].querySelector('.month8').value;//added
    row_data["month9"]= rows[i].querySelector('.month9').value;//added
    row_data["month10"]= rows[i].querySelector('.month10').value;//added
    row_data["month11"]= rows[i].querySelector('.month11').value;//added
    row_data["month12"]= rows[i].querySelector('.month12').value;//added
    row_cls = row_data;
    //to throw alert message if adjustment is 0
    if(row_data["month3"] === "0" || row_data["month4"] === "0" || row_data["month5"] === "0" || row_data["month6"]==="0" || row_data["month7"]==="0" || row_data["month8"]==="0" || row_data["month9"]==="0" || row_data["month10"]==="0" || row_data["month11"]==="0" || row_data["month12"]==="0")//added-month6-12
    {
      //window.alert('Please Enter Number Other than Zero');
      //used for showing the alert message
      ForeCastAlert.open({
         //calling from custom label
         message: InforForecastlabel,
         //message: "Please Enter Number Other than Zero",
         theme: "error",
         label: "Alert"
      });
      return;
    }
    inforecastData[row_data ['inforid']] = Object.assign({},row_cls);
   }
   //console.log(row_cls);
   //console.log(inforecastData--11);
   let jsonString = JSON.stringify(Object.assign({},inforecastData));
   //console.log(jsonString);
  // alert(jsonString);
   updateInforecast({forecastdata: jsonString})
            .then(result => {
               this.dispatchEvent(
                  new ShowToastEvent({
                     title : 'Success',
                     message : 'Saved Successfully{0}',
                     variant: 'success',
                  }),
               );
               getInforecast({AccountId: this.recordId}).then(response => {
                  console.log('after save imperative call++++11');
                  console.log(response);
                   this.forecast = JSON.parse(response);
                   this.forecastAvailable = true;
               }).catch(error => {
                   console.log('Error: ' +error.body.message);
               });
                console.log(result);
               //  this. showInsertSuccess = true;
            })
            .catch(error => {
                this.error = error;
            });
}
}
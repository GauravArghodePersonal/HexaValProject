import {  
LightningElement,api, 
track  
} from "lwc";  
import getContacts from "@salesforce/apex/ExportToExcelDemoController.getContacts"; 
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex'; 
const columns = [{  
  label: "Name1",  
  fieldName: "reqName",  
  type: "text"  
},  
{  
  label: "Email",  
  fieldName: "reqId",  
  type: "text"  
}  ,
{  
  label: "Company Name",  
  fieldName: "reqComName",  
  type: "text"  
} 
];  
export default class ExportToExcelDemo extends LightningElement {  
@track contactList;  
@track contactColumns = columns;  
@api recordId;
showToast() {
  const event = new ShowToastEvent({
      title: 'Masterdata CSV Downloaded Successfully',
      message: '',
      variant: 'success',
      mode: 'dismissable'
  });
  this.dispatchEvent(event);
}
showToastError() {
  const event = new ShowToastEvent({
      title: 'Not able to Download CSV, Contact Admin',
      message: '',
      variant: 'Error',
      mode: 'dismissable'
  });
  this.dispatchEvent(event);
}
async getContactsval() { 
      console.log('Inside Get Contacts Val'); 
    //  console.log('Inside 123recordId'+recordId); 
      console.log('Inside 123'+this.recordId); 
      await getContacts({accId:this.recordId})
      .then(result => {  
        this.contactList = result; 
        console.log('iii Query Retrieve '+result);
      })  
      .catch(error => {  
        this.error = error;  
        console.log('DD Error'+this.recordId+this.error);  
        return null; 
      }); 
  
    }
    async generateCSVData()
{
 // console.log('Inside3'+contactListval); 
  // This array holds the Column headers to be displayd
  let jsonKeys = ["csvformat"]; // This array holds the keys in the json data  
  var jsonRecordsData = this.contactList;  
  let csvIterativeData;  
      let csvSeperator  
      let newLineCharacter;  
      var splitdata;
      var splitrow;
      csvSeperator = ","; 
  newLineCharacter = "\n";  
  csvIterativeData = "";  
  for (let i = 0; i < jsonRecordsData.length; i++) {  
    let counter = 0;  
    for (let iteratorObj in jsonKeys)
     {  
      let dataKey = jsonKeys[iteratorObj];  
      if (counter > 0 && counter<1) {  
      }  
      if (  jsonRecordsData[i][dataKey] !== null &&  
        jsonRecordsData[i][dataKey] !== undefined  
      ) { 
        splitrow=jsonRecordsData[i][dataKey].split('***');

        for(let sr=0;sr<splitrow.length;sr++)
        {
          
          splitdata=splitrow[sr].split('~~');
          //Predefined Logic   
           for (let sp = 0; sp < splitdata.length; sp++) { 
 if(splitdata[sp]!==null&&splitdata[sp]!==undefined)
 {
   if(splitdata[sp]==='NULL')
   {
    csvIterativeData+=csvSeperator
   }
   else{
    csvIterativeData+='"=""'+splitdata[sp]+'"""'+csvSeperator
   }
   
 }
 
          }
          csvIterativeData+=newLineCharacter;
        }
         //csvIterativeData += '"' + jsonRecordsData[i][dataKey] + '"'; 
        
       //  csvIterativeData+=newLineCharacter;
      } else {  csvIterativeData += '""';  
      }  
      counter++;  
    }  
    csvIterativeData += newLineCharacter;  
  } 
console.log('RRRR'+csvIterativeData);

if(csvIterativeData!==null&& csvIterativeData!==undefined)
{
  if(csvIterativeData!=='')
  {
  console.log('csvIterativeData TEST'+csvIterativeData);
  this.csvIterativeDataGlobal=csvIterativeData;
let downloadElement = document.createElement('a');
var universalBOM = "\uFEFF";
  // This  encodeURI encodes special characters, except: , / ? : @ & = + $ # (Use encodeURIComponent() to encode these characters).
  downloadElement.href = 'data:text/xlsx;charset=utf-8,' + encodeURIComponent(universalBOM+csvIterativeData);
  downloadElement.target = '_self';
  // CSV File Name
  downloadElement.download = 'MasterData_Output.csv';
  // below statement is required if you are using firefox browser
  document.body.appendChild(downloadElement);
  // click() Javascript function to download CSV file
  downloadElement.click(); 
  this.showToast();
  }
  else
  {
    this.showToastError();
  }
}  
}
    async exportToCSV() { 
      this.contactList='';
      await this.getContactsval();
  await this.generateCSVData();
}

}
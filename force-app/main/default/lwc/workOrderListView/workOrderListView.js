import { LightningElement, api, wire, track } from 'lwc';
import getSA from '@salesforce/apex/serviceAppointmentListView.getSA';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';


const filesListColumns = [
    {
       label: 'Service Appointment', 
       fieldName: 'nameUrl',
       type: 'url', 
       typeAttributes: { 
         label: { fieldName: 'Name' },
           target: '_blank'
       },
       
   },
 
   
   { 
    label: "Created Date", 
    fieldName: "CreatedDate", 
    type: "date"
    
  },
  { 
    label: "Completed Date", 
    fieldName: "CompletedDate", 
    type: "date"
    
  },

 
  /* {
    label: 'Owner', 
    fieldName: 'Owner',
    type: 'url', 
        typeAttributes: { 
        label: { fieldName: 'OwnerName' },
            target: '_blank'
        },
    
    },*/

    
    {
        label: 'Service Resource', 
        fieldName: 'ServiceResource',
        type: 'url', 
            typeAttributes: { 
            label: { fieldName: 'ServiceResourceName' },
                target: '_blank'
            },
       
    },


    /*{ 
        label: "Target Return Date", 
        fieldName: "ReturnDate", 
        type: "datetime"
        
    },*/

    { 
        label: "Total Service Appointment Time", 
        fieldName: "AppointmentTime", 
        type: "Text"
        
    },  

    /*{
        label: 'Service Territory', 
        fieldName: 'ServiceTerritory',
        type: 'url', 
            typeAttributes: { 
            label: { fieldName: 'ServiceTerritoryName' },
                target: '_blank'
            },
       
        },*/

   /* { 
        label: "Subject", 
        fieldName: "Subject", 
        type: "Text"
        
    },*/
    
    {
        label: 'Created By', 
        fieldName: 'CreatedBy',
        type: 'url', 
            typeAttributes: { 
            label: { fieldName: 'CreatedByName' },
                target: '_blank'
            },
       
    }
/*,
      { 
        label: "Description", 
        fieldName: "Description", 
        type: "Text"
        
      },
      { 
        label: "Trip Report", 
        fieldName: "TripReport", 
        type: "Text"
        
      }   */

   ];

export default class workOrderListView extends LightningElement {
    @api recordId;
    data;
    error;
    @track SADetails; 
    @track filesListColumns = filesListColumns;
    @track sortBy;

     connectedCallback(){
        this.getSAData();
      }

      getSAData(){
        console.log('====This is woId'+this.recordId);
        if ((this.recordId !== undefined && this.recordId !== '' && this.recordId !== null)) {

        getSA({woId:this.recordId,}).then(result => {
             console.log('result'+JSON.stringify(result));
             var rows =result;
             console.log('<<<Rows>>'+JSON.stringify(rows));
             const listid = [];
             for (var i = 0; i < rows.length; i++) {
               listid.push({
                 Id: rows[i].Id,
                 Name: rows[i].AppointmentNumber,
                 nameUrl:'/lightning/r/ServiceAppointment/'+rows[i].Id+'/view',
                 CreatedDate: rows[i].CreatedDate,
                 CompletedDate: rows[i].CompletedDate,
                // OwnerName: rows[i].OwnerName,
                // Owner: '/lightning/r/User/'+rows[i].OwnerId+'/view',
                 CreatedByName: rows[i].CreatedByName,
                 CreatedBy: '/lightning/r/User/'+rows[i].CreatedById+'/view',
                // ReturnDate: rows[i].Target_Return_Dat,
                 AppointmentTime: rows[i].Total_Service_Appointment_Time,
                // ServiceTerritoryName: rows[i].ServiceTerritoryName,
                // ServiceTerritory:'/lightning/r/ServiceTerritory/'+rows[i].ServiceTerritoryId+'/view',
                // Subject: rows[i].Subject,
               //  Description: rows[i].Description,                 
                 ServiceResourceName: rows[i].ServiceResourcesName=='Null'?'':rows[i].ServiceResourcesName,                 
                 ServiceResource:rows[i].ServiceResourcesName=='Null'?'':'/lightning/r/ServiceResource/'+rows[i].ServiceResourcesId+'/view'                          
               });
             }


             this.SADetails= listid;
             console.log('<<<<<>>>>>>'+JSON.stringify(this.SADetails));            
        });
        console.log('getSAdetails2'+JSON.stringify(this.SADetails));
     }
     }
     handleSortdata(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
      }
      
      sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.filesListDatas));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = direction === 'asc' ? 1: -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : '';
            y = keyValue(y) ? keyValue(y) : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.filesListDatas = parseData;
      }

}
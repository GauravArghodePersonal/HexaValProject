import { LightningElement,api,track } from 'lwc';
import OpenOrdersAccDetail from '@salesforce/apex/solenisReorderController.AcconutDetail';
import { updateRecord } from 'lightning/uiRecordApi';
import MatrerialList from '@salesforce/apex/solenisReorderController.querymaterialwithAPI';
import ConMatrerialList from '@salesforce/apex/solenisReorderController.querymaterialwithAPI_All';
import SoldToId from '@salesforce/apex/Account_Partner_Functions.getSoldToId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import init from '@salesforce/apex/solenisReorderController.materialPlantDetail';
import init_in from '@salesforce/apex/solenisReorderController.materialPlantDetail_in';
import createOrder from '@salesforce/apex/solenisReorderController.createOrder';
import getleadtime from '@salesforce/apex/solenisReorderController.getLeadTme';
import OpenOrdersDetail from '@salesforce/apex/solenisReorderController.OpenOrdersDetail';
import OpenOrdersWithMat from '@salesforce/apex/solenisReorderController.getSelectedMaterial';
import pilotUsCheck from '@salesforce/apex/solenisReorderController.pilotCheck';
import usrId from '@salesforce/user/Id';
import CalloutToDellBoomi from '@salesforce/apex/SalesOrderFeedToSAP.CalloutToDellBoomi';



const filesListColumns = [ 
        { 
           label: "Material Number", 
           fieldName: "MaterialNumber", 
           type: "text"           
       },
     
       { 
         label: "Material Desc", 
         fieldName: "MaterialDesc", 
         wrapText: true,
         type: "text"
       },
     
       { 
         label: "SalesOrg Desc", 
         fieldName: "SalesOrgDesc", 
         wrapText: true,
         type: "text",    
       },
     
       { 
         label: "DistChannel Desc", 
         fieldName: "DistChannelDesc",
         wrapText: true,
         type: "text"
        
       },
    ];

    const filesListColumnss = [  
 

        { 
             label: "Open Order ID", 
             fieldName: "OpenOrderID", 
             type: "text",
             sortable: true 
             
         },
       
         { 
           label: "Sales Order Number", 
           fieldName: "SalesOrderNumber", 
           type: "text",
           wrapText: true,
           sortable: true 
           
         },
       
         { 
           label: "Line Item Number", 
           fieldName: "LineItemNumber", 
           type: "text",
           wrapText: true,
           sortable: true 
           
         },
       
         { 
           label: "Material Desc", 
           fieldName: "MaterialDesc",
           type: "text",
           wrapText: true,
           sortable: true 
         },
       
         { 
           label: "Ordered Qty", 
           fieldName: "OrderedQty", 
           type: "text",
           sortable: true 
           
         },
       
         { 
           label: "Ordered Qty UOM", 
           fieldName: "OrderedQtyUOM", 
           type: "text",
           sortable: true 
           
         },
       
         { 
           label: "Plant Desc", 
           fieldName: "PlantDesc", 
           type: "Text",
           wrapText: true,
           sortable: true 
           
         },
         { 
          label: "Agreed Ship Date", 
          fieldName: "AgreedShipDate",
          type: "Date",
          sortable: true 
        }
      
         ];

export default class SolenisReorderPage extends LightningElement {
    @api recordId;
    @api openOdId=[];
    @track AccountDetail = {};
    @track Street;
    @track Shipto;
    @track SoldTo;
    @track City;
    @track PostalCode;
    @track Country;
    @track ordertypeflag=false;
    @track ordertflag=true;
    @track openmodel=false;
    @track orderdeliverydateList=[];
    @track Count=0;
    @track errormsg;
    @track MatrialList = [];
    @track filesListColumns = filesListColumns;
    @track filesListColumnss = filesListColumnss;
    @track SerachMaterial;
    @track SoldToName;
    @track SelectedMatList=[];
    @track PlantList = [];
    @track matname;
    @track SelectedListId = [];
    @track reorderflag=false;
    @track reorderRedirectflag=true;
    @track sortBy;
    @track openOrderList = [];
    @track isLoading=false;
    @track Ponumberreq= false;
    @track Quantityreq=false;
    @track ordertypereq=false;
    @track uomreq=false;
    @track atachReorderIds = [];
    @track attachflag = false;
    @track reorderMainflag = true;
    @track cancelflag = true;
    @track err_orderSlect=false;
    @track roderypSelecte='';
    @track Ins_ContractNumberSelect='';
    @track flg_orderShw = false;
    @track flg_order =false;
    openOrder_flag = false;
    userId = usrId;
    flag_Pilotuser =false;
    flg_Next=false;
    chk_LeadTIme=true;
    
   
    
   
    connectedCallback(){    
        this.getOpenOrdersAccDetail();   
        this.getorderdeliverydate();  
        this.getSoldToId(); 
        this.getOpenOrdersDetail();  
        //this.checkpilotUsr();
        this.flag_Pilotuser = true;

        
    } 
    checkpilotUsr(){

        pilotUsCheck({
            userId : this.userId,
            PrjName : 'Pricing'
        })
        .then(result=>{
            this.flag_Pilotuser = result;
            console.log('<<<result>>>'+result);
            console.log('<<<flag_Pilotuser>>>'+this.flag_Pilotuser);
        })
        .catch((error)=>{
            this.showToast('Error', 'You do not have access. Please Contact System Administrator', 'error');
        })

    }

    getOpenOrdersAccDetail(){
        this.isLoading=true;
        OpenOrdersAccDetail({OpOrdId : this.recordId})
        .then(result=>{
            var rows = result;        
            const listid = [];  
            this.Street= rows[0].ShippingStreet;   
            this.Shipto= this.recordId;   
            this.SoldTo= rows[0].Id; 
            this.City= rows[0].ShippingCity; 
            this.PostalCode= rows[0].ShippingPostalCode; 
            this.Country= rows[0].ShippingCountry;          
          
            this.AccountDetail = listid;  
        })
        .catch((error) => {
            this.showToast('Error', 'Something went wrong', 'error');
            // eslint-disable-next-line no-console
            //console.error('Lookup error', JSON.stringify(error));
            this.errors = [error];
        });
        this.isLoading=false;
    }

    get genericNumberPicklist(){
        return [
            { label: 'Contract Billing', value: 'Contract Billing' },
            { label: 'Standard Billing', value: 'Standard Billing' },     
        ];
    }
    OnchangeReordertype(){
        this.err_orderSlect=false;
        var roderype;
        roderype= this.template.querySelector('[data-id="OrderTypeselect"]').value;
        if(roderype=='Contract Billing'){
            this.ordertypeflag=true;
        }
        else{
            this.ordertypeflag=false;
        }
        //this.Leadtime();
    }
    getorderdeliverydate(){        
        this.isLoading=true;
        const Datelist = [];
        var today = new Date(); 

        this.Count +=1;
        var requiredDate=new Date(today.getFullYear(),today.getMonth(),today.getDate()+6)
            Datelist.push({
                flag: false,
                Id: this.Count,
                PONUMBER: '',
                REQUESTEDDELIVERYDATE: requiredDate.toISOString(),
                ESTIMATEDSHIPDATE:  today.toISOString(),
                SPECIALINSTRUCTIONS: '',
                
            });    
      
        this.orderdeliverydateList = Datelist;   
        this.isLoading=false;
  
      }
      addOrderDeliveryDate(){

        let requestDeliveryDate = this.template.querySelectorAll('[data-id="requestDeliveryDate"]');
        let TempcompareDate = [];        
        for(var i = 0; i < requestDeliveryDate.length; i++){  
            TempcompareDate.push(requestDeliveryDate[i].value);
        }
        var compareDate = [];
        compareDate = this.removeDuplicates(TempcompareDate);   
        if(compareDate.length != requestDeliveryDate.length){

             this.errormsg='Error: Can not add a reorder with the same date';  
             this.isLoading=false; 
        }
        else{
            this.errormsg='';
        const Datelist = [];
        var today = new Date(); 
        var requiredDate=new Date(today.getFullYear(),today.getMonth(),today.getDate()+6)
            this.Count +=1;
  
            this.orderdeliverydateList.push({
                flag: false,
                Id: this.Count,
                PONUMBER: '',
                REQUESTEDDELIVERYDATE: requiredDate.toISOString(),
                ESTIMATEDSHIPDATE:  today.toISOString(),
                SPECIALINSTRUCTIONS: '',
                
            });  
        }    
      }
      removeOrderdeliveryDate(){
        let flag = this.template.querySelectorAll('[data-id="flag"]');
        let ponumber = this.template.querySelectorAll('[data-id="ponumber"]');
        let requestDeliveryDate = this.template.querySelectorAll('[data-id="requestDeliveryDate"]');
        let estimateShipDate = this.template.querySelectorAll('[data-id="estimateShipDate"]');
        let specificIns = this.template.querySelectorAll('[data-id="specificIns"]');        
        this.orderdeliverydateList=[];
        for(var i = 0; i < flag.length; i++){          
            if(flag[i].checked==false){
                this.orderdeliverydateList.push({
                    flag: flag[i].value,
                    Id: this.Count,
                    PONUMBER: ponumber[i].value,
                    REQUESTEDDELIVERYDATE: requestDeliveryDate[i].value,
                    ESTIMATEDSHIPDATE:  estimateShipDate[i].value,
                    SPECIALINSTRUCTIONS: specificIns[i].value,                   
                });                
            }
            

        }
      }
       removeDuplicates(array) {
        return array.filter((a, b) => array.indexOf(a) === b)
      }
      openAddMaterial(){
        this.openmodel=true;
          this.getMaterialDetail();
         
      }
      closeModal(){
        this.openmodel=false;
      }
      getMaterialDetail(){   
        this.isLoading=true;
        this.getSoldToId(); 
        var Sold;    
        this.SerachMaterial=this.template.querySelector('[data-id="SearchMaterial"]').value;
        Sold=this.template.querySelector('[data-id="SoldTo"]').value;  
        let Ins_OrderType= this.template.querySelector('[data-id="OrderType"]').value;   
        if(Ins_OrderType=='Contract Billing'){  
       // console.log('<<<Sold>>>>'+Sold);   
            if(this.SerachMaterial.length  > 2){
                ConMatrerialList({accountId: this.recordId, 
                            searchtext: this.SerachMaterial,
                            soldToId: Sold
                            })
                .then(result => {             
                    var rows = result;        
                    const listid = [];
                    for (var i = 0; i < rows.length; i++) {
                        listid.push({
                            Id: rows[i].Id,
                            MaterialNumber: rows[i].Material_Number__c.replace(/^0+/, ''),
                            MaterialDesc: rows[i].Material_Desc__c,
                            SalesOrgDesc: rows[i].SalesOrg_Desc__c,
                            DistChannelDesc: rows[i].DistChannel_Desc__c
                        });  

                    }  
                    this.isLoading=false;
                    this.MatrialList = listid;   
                    if(this.MatrialList.length<1){
                        this.showToast('', 'No customer price for the material search term.  Please proceed to Quote Creation process to create a new quote for additional materials. ', 'error');
                        this.isLoading=false;  
                    }
                            
                
                })
                .catch((error) => {
                    this.showToast('', 'No customer price for the material search term.  Please proceed to Quote Creation process to create a new quote for additional materials. ', 'error');
                    console.error('Lookup error', JSON.stringify(error));
                    this.errors = [error];
                    this.isLoading=false;  
                });
            }
            else{
                this.showToast(' ', 'Type atleast 3 digit Material Number or Name', 'error');
                   // console.error('Lookup error', JSON.stringify(error));
                  //  this.errors = [error];
                  this.isLoading=false;
            }
        }
        else{
            if(this.SerachMaterial.length  > 2){
                MatrerialList({accountId: this.recordId, 
                            searchtext: this.SerachMaterial,
                            soldToId: Sold
                            })
                .then(result => {             
                    var rows = result;        
                    const listid = [];
                    for (var i = 0; i < rows.length; i++) {
                        listid.push({
                            Id: rows[i].Id,
                            MaterialNumber: rows[i].Material_Number__c.replace(/^0+/, ''),
                            MaterialDesc: rows[i].Material_Desc__c,
                            SalesOrgDesc: rows[i].SalesOrg_Desc__c,
                            DistChannelDesc: rows[i].DistChannel_Desc__c
                        });  

                    }  
                    this.isLoading=false;
                    this.MatrialList = listid;   
                    if(this.MatrialList.length<1){
                        this.showToast('', 'No customer price for the material search term.  Please proceed to Quote Creation process to create a new quote for additional materials. ', 'error');
                        this.isLoading=false;  
                    }
                            
                
                })
                .catch((error) => {
                    this.showToast('', 'No customer price for the material search term.  Please proceed to Quote Creation process to create a new quote for additional materials. ', 'error');
                    console.error('Lookup error', JSON.stringify(error));
                    this.errors = [error];
                    this.isLoading=false;  
                });
            }
            else{
                this.showToast(' ', 'Type atleast 3 digit Material Number or Name', 'error');
                   // console.error('Lookup error', JSON.stringify(error));
                  //  this.errors = [error];
                  this.isLoading=false;
            }
        }
           
    }
    getSelectedRows(event) {
        const selectedRows = event.detail.selectedRows; 
      }
    getSoldToId(){
        SoldToId({accountId: this.recordId})
        .then(result => {   
            var rows = result;
            this.SoldToName =  rows==null?this.recordId:rows;
        })
        .catch((error) => {
            this.showToast('Lookup Error', 'An error occured while searching with the lookup field.', 'error');
            this.errors = [error];
        });                     
    }

    getMaterialSearchDetail(){   
        this.isLoading=true;
        this.MatrialList =[];
        this.SerachMaterial=[]; 
        var Sold;    

        this.SerachMaterial=this.template.querySelector('[data-id="SearchMatValue"]').value;
        let Ins_OrderType= this.template.querySelector('[data-id="OrderType"]').value;   
            if(Ins_OrderType=='Contract Billing'){
                if(this.SerachMaterial.length>2){
                    Sold=this.template.querySelector('[data-id="SoldTo"]').value;    
                    ConMatrerialList({accountId: this.recordId, 
                                searchtext: this.SerachMaterial,
                                soldToId: Sold
                                })
                    .then(result => {   
                        var rows = result;        
                        const listid = [];
                        for (var i = 0; i < rows.length; i++) {
                            listid.push({
                                Id: rows[i].Id,
                                MaterialNumber: rows[i].Material_Number__c.replace(/^0+/, ''),
                                MaterialDesc: rows[i].Material_Desc__c,
                                SalesOrgDesc: rows[i].SalesOrg_Desc__c,
                                DistChannelDesc: rows[i].DistChannel_Desc__c
                            });    
                        }  
                        this.isLoading=false;  
                        this.MatrialList = listid;   
                                
                    
                    })  
                    .catch((error) => {
                        this.showToast('', 'No customer price for the material search term.  Please proceed to Quote Creation process to create a new quote for additional materials. ', 'error');
                        console.error('Lookup error', JSON.stringify(error));
                        this.errors = [error];
                        this.isLoading=false;  
                    });
                }
                else{
                    this.showToast(' ', 'Enter at least first 3 digits of Material Number or Name, 000 to retrieve all the Priced materials ', 'error');
                    this.isLoading=false; 
                } 
            } 
            else{
                if(this.SerachMaterial.length>2){
                    Sold=this.template.querySelector('[data-id="SoldTo"]').value;    
                    MatrerialList({accountId: this.recordId, 
                                searchtext: this.SerachMaterial,
                                soldToId: Sold
                                })
                    .then(result => {   
                        var rows = result;        
                        const listid = [];
                        for (var i = 0; i < rows.length; i++) {
                            listid.push({
                                Id: rows[i].Id,
                                MaterialNumber: rows[i].Material_Number__c.replace(/^0+/, ''),
                                MaterialDesc: rows[i].Material_Desc__c,
                                SalesOrgDesc: rows[i].SalesOrg_Desc__c,
                                DistChannelDesc: rows[i].DistChannel_Desc__c
                            });    
                        }  
                        this.isLoading=false;  
                        this.MatrialList = listid;   
                                
                    
                    })  
                    .catch((error) => {
                        this.showToast('', 'No customer price for the material search term.  Please proceed to Quote Creation process to create a new quote for additional materials. ', 'error');
                        console.error('Lookup error', JSON.stringify(error));
                        this.errors = [error];
                        this.isLoading=false;  
                    });
                }
                else{
                    this.showToast(' ', 'Enter at least first 3 digits of Material Number or Name, 000 to retrieve all the Priced materials ', 'error');
                    this.isLoading=false; 
                } 
            }   
                  
               
    }
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant : variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
      }
       async addMatrial(){
        this.isLoading=true;
        this.openmodel=false;
        let selectedpricingLane = this.template.querySelector('[data-id="relatedFiles"]').getSelectedRows();
       // console.log('selectedpricingLane--->'+JSON.stringify(selectedpricingLane));
        var SelectedListId = [];
        var TempPlant1 =[];
        for(var i =0; i< selectedpricingLane.length; i++){
           await init({msdId: selectedpricingLane[i].Id,
            MatNum: selectedpricingLane[i].MaterialNumber,
            MatDesc: selectedpricingLane[i].MaterialDesc
        })
        .then((result)=>{
                var rows = result;
               // console.log('<<<<result1112>>>>'+JSON.stringify(rows));

              const listid = [];
                for (var j = 0; j < rows.length; j++) {                  
                    this.SelectedMatList.push({
                        msId: rows[j].msId,
                        matnameLink: '/'+rows[j].msId,
                        matname: rows[j].matNumber,
                        matDesc: rows[j].matDesc +'-'+rows[j].matNumber,
                        plants: rows[j].Plants, 
                        leadTime: 0                      
                    })
                }
           
            })
        }
        this.isLoading=false;
      }
      get UMOPicklist(){
        return [
            { label: 'Bags', value: 'Bags' },
            { label: 'KGS', value: 'KGS' },
            { label: 'LBS', value: 'LBS' },
            { label: 'DRS', value: 'DRS' },
            { label: 'GLS', value: 'GLS' },
            { label: 'PLS', value: 'PLS' },
            { label: 'SSK', value: 'SSK' },
            { label: 'IBC', value: 'IBC' }
         
        ];

    }
      insertorder(){  
        this.isLoading=true;  
        var Reorder = [];  
        var MaterialList = [];  
        this.Ponumberreq= false;
        this.Quantityreq = false;
        this.uomreq = false;
        this.ordertypereq = false;
        var requestDeliveryDatereq= false;
        var requestedDate =[];
       // var Quantityreq = false;
        //var errormsg='';
   // var uomreq = false;
        let Ins_SoldTo= this.template.querySelector('[data-id="SoldTo"]').value;
        let Ins_ShipTo= this.template.querySelector('[data-id="ShipTo"]').value;
        let Ins_OrderType= this.template.querySelector('[data-id="OrderType"]').value;
        console.log('<<<<<Ins_SoldTo>>>>>'+Ins_SoldTo);
        console.log('<<<<<Ins_ShipTo>>>>>'+Ins_ShipTo);
        if(Ins_OrderType==null || Ins_OrderType==''){
            this.ordertypereq=true;
        }
        let Ins_ContractNumber;
        if(Ins_OrderType == 'Contract Billing'){
            Ins_ContractNumber= this.template.querySelector('[data-id="ContractNumber"]').value;
        }    
        let Ins_ponumber = this.template.querySelectorAll('[data-id="ponumber"]');
        let Ins_requestDeliveryDate = this.template.querySelectorAll('[data-id="requestDeliveryDate"]');
        let Ins_estimateShipDate = this.template.querySelectorAll('[data-id="estimateShipDate"]');
        let Ins_specificIns = this.template.querySelectorAll('[data-id="specificIns"]');

        for(var i=0; i<Ins_ponumber.length;i++){
            if(Ins_ponumber[i].value==null || Ins_ponumber[i].value==''){
                this.Ponumberreq= true;
            }
            if(Ins_requestDeliveryDate[i].value==null || Ins_requestDeliveryDate[i].value==''){
                requestDeliveryDatereq = true;
            }

           
            requestedDate.push({
                ponumberList: Ins_ponumber[i].value,
                requestDeliveryDate: Ins_requestDeliveryDate[i].value,
                estimateShipDate: Ins_estimateShipDate[i].value,
                specificIns: Ins_specificIns[i].value
                    
            })



        }
       
        let Ins_id = this.template.querySelectorAll('[data-id="msId"]');
        let Ins_Quantity = this.template.querySelectorAll('[data-id="Quantity"]');
        let Ins_selectedPlant = this.template.querySelectorAll('[data-id="selectedPlant"]');
        let Ins_SelectedMaterialNumber = this.template.querySelectorAll('[data-id="SelectedMaterialNumber"]');
        let Ins_Plant = this.template.querySelectorAll('[data-id="Plant"]');
        let Ins_TankNumber = this.template.querySelectorAll('[data-id="TankNumber"]');
        let Ins_Lead_Time = this.template.querySelectorAll('[data-id="leadtime"]');
        
         for(var i=0; i<Ins_Quantity.length;i++){   
            if(Ins_Quantity[i].value==null || Ins_Quantity[i].value==''){
                this.Quantityreq = true;
            } 
           // console.log('^^^^^^^6666^^^^^^'+Ins_selectedPlant[i].value);
            if(Ins_selectedPlant[i].value==null || Ins_selectedPlant[i].value==''){
                this.uomreq = true;
            }
           MaterialList.push({
                msId : Ins_id[i].value,
                Quantity: Ins_Quantity[i].value,
                UMO: Ins_selectedPlant[i].value,
                MaterialNumber: Ins_SelectedMaterialNumber[i].value,
                plant: Ins_Plant[i].value,
                TankNumber: Ins_TankNumber[i].value,
                leadTime:  Ins_Lead_Time[i].value==''?0:Ins_Lead_Time[i].value
            })
                     
        }
        Reorder.push({
            soldTo: Ins_SoldTo,
            shipTo: Ins_ShipTo,
            orderType: Ins_OrderType,
            ContractNumber: Ins_ContractNumber

        })
        let TempcompareDate = []; 
        for(var i = 0; i < Ins_requestDeliveryDate.length; i++){  
            TempcompareDate.push(Ins_requestDeliveryDate[i].value);
        }
        var compareDate = [];
        compareDate = this.removeDuplicates(TempcompareDate); 
           if(Ins_requestDeliveryDate.length<1){
            this.showToast('', 'Please Add Atleat One Delivery Date', 'error');
            this.isLoading=false;  
           }
           else if(MaterialList.length < 1){
            this.showToast('', 'Please Add Atleat One Material', 'error');
            this.isLoading=false;   
           }
                else if(compareDate.length == Ins_requestDeliveryDate.length || Ins_requestDeliveryDate.length ==1){
                    if(this.Ponumberreq==false && requestDeliveryDatereq==false && this.Quantityreq==false && this.uomreq==false && this.ordertypereq==false){
                        createOrder({
                            Requestdate: requestedDate,
                            MatList: MaterialList,
                            Reorder: Reorder,
                            ordertyp:'Reorder'
                        })
                        .then((result) => {   
                            if(result[0].startsWith('a4Z')){
                                //Added by Gokul Start
                                console.log('Donald'+result.length);
                      
                                console.log('ReorderID - '+result[0]);
                                CalloutToDellBoomi({ReorderId: result[0]})
                                .then((response) => {
                                console.log('Response - '+response);
                            if(response == 'Success'){
                                this.showToast('', 'Sucessfully Created New Order', 'success');
                                //window.location.href = result;
                             
                                    this.attachflag=true; 
                                this.reorderMainflag=false;
                                this.atachReorderIds = result;
                                this.reorderRedirectflag=false;
                                this.reorderflag=false;
                                this.isLoading=false;
                                this.cancelflag=false;
                              
                            }
                            if(response == 'Failed'){
                                this.showToast('', 'Something went wrong', 'error');
                                this.isLoading=false;
                            }
                            if(response != 'Success' & response != 'Failed'){
                                this.showToast('', response, 'error');
                                this.isLoading=false;
                            }
                        }).catch((error) => {                  
                            this.showToast('', 'Something went wrong. Please contact your system administrator.', 'error');
                            this.isLoading=false;
                           
                         });
                    
                        //Added by Gokul End
                            }
                            else{
                                this.showToast('', 'Something went wrong', 'error');
                                this.isLoading=false; 
                            }

                        }) 
                        .catch((error) => {                  
                            this.showToast('', 'Something went wrong', 'error');
                            this.isLoading=false;
                           
                         });
                    }
                    else{
                        this.showToast(' ', 'Please fill the required fields', 'error');
                        this.isLoading=false; 
                    } 
                   
                }
                else{
                    this.errormsg='Error: Can not add a reorder with the same date';   
                    this.showToast('Error', 'Can not add a reorder with the same date', 'error');
                    this.isLoading=false;
                }  
               
                //this.isLoading=false;    
    }

    removeMaterial(){
        let flag = this.template.querySelectorAll('[data-id="Selectedflag"]');
        let Ins_Quantity = this.template.querySelectorAll('[data-id="Quantity"]');
        let Ins_selectedPlant = this.template.querySelectorAll('[data-id="selectedPlant"]');
        let Ins_Plant = this.template.querySelectorAll('[data-id="Plant"]');
        let Ins_Lead_Time = this.template.querySelectorAll('[data-id="leadtime"]');
        let Ins_TankNumber = this.template.querySelectorAll('[data-id="TankNumber"]');
        for(var i = 0; i < flag.length; i++){ 
            this.SelectedMatList[i].qty=Ins_Quantity[i].value;
            this.SelectedMatList[i].umoval=Ins_selectedPlant[i].value;
            this.SelectedMatList[i].plantval=Ins_Plant[i].value;
            this.SelectedMatList[i].leadTime=Ins_Lead_Time[i].value;
            this.SelectedMatList[i].TankNumber=Ins_TankNumber[i].value;
        }
             
        var REM_SelectedMatList=[];
        let Addleadtime_x = 0;
        console.log('<<<AddLeadTime>>>'+Addleadtime_x);
        for(var i = 0; i < this.SelectedMatList.length; i++){          
            if(flag[i].checked==false){
                REM_SelectedMatList.push(this.SelectedMatList[i]); 
                Addleadtime_x=Addleadtime_x<this.SelectedMatList[i].leadTime?this.SelectedMatList[i].leadTime:Addleadtime_x;
              
            }
        }
        Addleadtime_x=Math.floor(Addleadtime_x/5)*7+5;
        
      //  alert(AddLeadTime);
       // AddLeadTime+=3;
        this.SelectedMatList=[];
        this.SelectedMatList=REM_SelectedMatList;
        var ReqDate;
        ReqDate= this.datecorrection(Addleadtime_x);
        var DelDate = new Date();
        DelDate.setDate(DelDate.getDate() + Addleadtime_x-5);
       // console.log('<<<ReqDate>>>'+ReqDate);
            for(var i=0;i<this.orderdeliverydateList.length;i++){
                this.orderdeliverydateList[i].REQUESTEDDELIVERYDATE=ReqDate.toISOString();
                this.orderdeliverydateList[i].ESTIMATEDSHIPDATE=DelDate.toISOString();

            }
        //console.log('<<flag2>>>'+ JSON.stringify(this.orderdeliverydateList));

      }

      async Leadtime(){
        
                this.isLoading=true;
                // alert('LLead time enter');
                let Plant = this.template.querySelectorAll('[data-id="Plant"]');
                let msid = this.template.querySelectorAll('[data-id="msId"]');
            
                var leadtimevalue;
                var AddLeadTime=0;        
                var ReqDate;
                for(var i=0; i<msid.length;i++){  
                    await getleadtime({msdId : msid[i].value ,
                                Plant : Plant[i].value
                    })
                    .then(result=>{
                    leadtimevalue = result;
                    }) 
                    this.SelectedMatList[i].leadTime= leadtimevalue;  
                    AddLeadTime= AddLeadTime<leadtimevalue?leadtimevalue:AddLeadTime;                 
                }
                AddLeadTime=Math.floor(AddLeadTime/5)*7+5;
            
                //alert(AddLeadTime);
                var today = new Date(); 
                ReqDate= this.datecorrection(AddLeadTime);
                var DelDate = new Date();
                DelDate.setDate(DelDate.getDate() + AddLeadTime-5);
                    for(var i=0;i<this.orderdeliverydateList.length;i++){
                        this.orderdeliverydateList[i].REQUESTEDDELIVERYDATE=ReqDate.toISOString();
                        this.orderdeliverydateList[i].ESTIMATEDSHIPDATE=DelDate.toISOString();

                    }
                //  console.log('<<<this.orderdeliverydateList777>>>'+JSON.stringify(this.orderdeliverydateList));
                    this.isLoading=false;
                    this.chk_LeadTIme=false;
                 
      }

      async runOnceLeadtime(){
        if(this.chk_LeadTIme){
               this.isLoading=true;
               // alert('LLead time enter');
               let Plant = this.template.querySelectorAll('[data-id="Plant"]');
               let msid = this.template.querySelectorAll('[data-id="msId"]');
           
               var leadtimevalue;
               var AddLeadTime=0;        
               var ReqDate;
               for(var i=0; i<msid.length;i++){  
                   await getleadtime({msdId : msid[i].value ,
                               Plant : Plant[i].value
                   })
                   .then(result=>{
                   leadtimevalue = result;
                   }) 
                   this.SelectedMatList[i].leadTime= leadtimevalue;  
                   AddLeadTime= AddLeadTime<leadtimevalue?leadtimevalue:AddLeadTime;                 
               }
               AddLeadTime=Math.floor(AddLeadTime/5)*7+5;
           
               //alert(AddLeadTime);
               var today = new Date(); 
               ReqDate= this.datecorrection(AddLeadTime);
               var DelDate = new Date();
               DelDate.setDate(DelDate.getDate() + AddLeadTime-5);
                   for(var i=0;i<this.orderdeliverydateList.length;i++){
                       this.orderdeliverydateList[i].REQUESTEDDELIVERYDATE=ReqDate.toISOString();
                       this.orderdeliverydateList[i].ESTIMATEDSHIPDATE=DelDate.toISOString();

                   }
               //  console.log('<<<this.orderdeliverydateList777>>>'+JSON.stringify(this.orderdeliverydateList));
                   this.isLoading=false;
                   this.chk_LeadTIme=false;
           }        
     }

      datecorrection(leadtime){
        var startDate = new Date();
        startDate.setDate(startDate.getDate() + leadtime-1);
        var endDate = "", noOfDaysToAdd = 1, count = 0;
        while(count < noOfDaysToAdd){
            endDate = new Date(startDate.setDate(startDate.getDate()+1));
            if(endDate.getDay() != 0 && endDate.getDay() != 6){
               count++;
            }
        }   
        //alert(endDate);   
        return endDate;
      }

     async Next(){
        this.isLoading=true;
        this.SelectedMatList=[];
        let selectedOpenOrder = this.template.querySelector('[data-id="relatedFiles"]').getSelectedRows();
       if(selectedOpenOrder.length<1){
        this.error="please select atleast one Open order";
       }
       else{
        this.error='';
       this.SelectedListId=[];
        for(var i =0; i< selectedOpenOrder.length; i++){
          this.SelectedListId.push(selectedOpenOrder[i].Id);
        }
        var AddLeadTime=0;
         await OpenOrdersWithMat({msdId :  this.SelectedListId})
        .then(result => {  
            var rows = result; 
            console.log('<<<<result]]]]]]]]]]]>>>>'+ JSON.stringify(rows));
            for (var i = 0; i < rows.length; i++) {
                console.log('<<<Test Plant>>>'+rows[i].Plant_Desc__c);
            }
            for (var i = 0; i < rows.length; i++) {
                var plantvalue ='';
                plantvalue =rows[i].Plant_Desc__c;
               console.log('<<<plantvalue>>'+plantvalue);
                //var plantvalue = 'CA KATOEN NATIE LACHINE W3P';
                var leadtimevalue;          
                var ReqDate;

            //  for(var i=0; i<this.SelectedMatList.length;i++){  
              //  console.log('<<<<rows[i].Id>>>>'+rows[i].Id);
                    getleadtime({
                               msdId : rows[i].Material__c/*'a362J000000Bfp3QAC'*/,
                                Plant :plantvalue
                    })
                    .then(result=>{
                    leadtimevalue = result;
                  //  console.log('<<<leadtimevalue23212>>>>'+leadtimevalue);
                    })   
               AddLeadTime= AddLeadTime<leadtimevalue?leadtimevalue:AddLeadTime;                 
              //  console.log('<<<<Material__r.Material_Number__c>>>>'+ JSON.stringify(rows[i].Material__r.Material_Number__c));
                init_in({openId: rows[i].Id,
                         msdId: rows[i].Material__c/*a362J000000Bfp3QAC'*/,
                         MatNum: rows[i].Material__r.Material_Number__c,
                         pval: rows[i].Plant_Desc__c,
                         leadVal: leadtimevalue
                }) 
                .then((result)=>{
                    console.log('<<<<Plant---Value>>>>'+JSON.stringify(plantvalue));
                    var rowss = result;

                    console.log('<<<<rowss++++>>>>'+JSON.stringify(rowss));
                    
    
                  const listid = [];
                    for (var j = 0; j < rowss.length; j++) {                  
                        this.SelectedMatList.push({
                            msId: rowss[j].msId,
                            matnameLink: '/'+rowss[j].msId,
                            matname: rowss[j].matNumber.replace(/^0+/, ''),
                            plants: rowss[j].Plants, 
                            leadTime: rowss[j].leadVal,
                            plantval : rowss[j].plantVal,
                            qty:  rowss[j].qty,
                            matDesc: rowss[j].matDesc
                           

                        })
                    }
                    console.log('<<<<SelectedMatList111>>>>'+JSON.stringify(this.SelectedMatList));
                })
            }  
           
           
        })
        
        .catch((error) => {
         //   console.log('<<error>>>>'+error);
            this.showToast(' ', 'No customer price for the material search term.  Please proceed to Quote Creation process to create a new quote for additional materials. ', 'error');
            // eslint-disable-next-line no-console
          //  console.error('Lookup error', JSON.stringify(error));
            this.errors = [error];
            this.isLoading=false;  
        });
        //this.reorderflag=true;
        this.flg_orderShw=true;
        this.reorderRedirectflag=false;  
        this.flg_Next=true;     
      } 
     // console.log('<<<< var AddLeadTime=0;>>>>'+JSON.stringify(AddLeadTime));
   //   this.Leadtime();
    //  console.log('<<<this.orderdeliverydateList>>>'+JSON.stringify(this.orderdeliverydateList));
    this.isLoading=false;
    } 
     //alert msg
     @track isDialogVisible = false;
     @track originalMessage;
     @track displayMessage = 'Click on the \'Open Confirmation\' button to test the dialog.';
     @track isModalOpen = false;
     openModal() {
         // to open modal set isModalOpen tarck value as true
         this.isModalOpen = true;
     }
     closeModal1() {
         console.log('INside Close');
         // to close modal set isModalOpen tarck value as false
         this.isModalOpen = false;
         console.log('INside Close done');
     }
     submitDetails() {
         console.log('INside Submit');
         this.err_orderSlect=false;
         this.reorderflag=false;
         this.reorderRedirectflag=true;
         this.ordertypeflag=false;
         this.chk_LeadTIme=true;
         // to close modal set isModalOpen tarck value as false
         //Add your code to call apex method or do some processing
         this.isModalOpen = false;
         console.log('INside Submit done');
     }
    Previous(){
        this.err_orderSlect=false;
        this.reorderflag=false;
        this.reorderRedirectflag=true;
        this.ordertypeflag=false;
        this.chk_LeadTIme=true;
  
      }
    
      closeQuickAction() {
        const closeQA = new CustomEvent('close');     
        this.dispatchEvent(closeQA);
        var ReferreshAcc = '/'+this.recordId;
        window.location.href = ReferreshAcc;
    }

    handleSortdata(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
      }
      sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.openOrderList));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = direction === 'asc' ? 1: -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : '';
            y = keyValue(y) ? keyValue(y) : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.openOrderList = parseData;
      } 

    getOpenOrdersDetail(){
        this.isLoading=true;
        OpenOrdersDetail({accId : this.recordId})
        .then(result => {            
            var rows = result;        
            const listid = [];
            for (var i = 0; i < rows.length; i++) {
                listid.push({
                    Id: rows[i].Id,
                    OpenOrderID: rows[i].Name,
                    SalesOrderNumber: rows[i].Sales_Order_Number__c,
                    LineItemNumber: rows[i].Line_Item_Number__c,
                    MaterialDesc: rows[i].Material_Desc__c,
                    OrderedQty: rows[i].Ordered_Qty__c,
                    OrderedQtyUOM: rows[i].Ordered_Qty_UOM__c,
                    PlantDesc: rows[i].Plant_Desc__c,
                    AgreedShipDate: rows[i].Agreed_Ship_Date2__c
                });   
                this.isLoading=false; 
            }  
            this.openOrderList = listid;   
            if(this.openOrderList.length<1){
                this.openOrder_flag=true;
                this.isLoading=false; 
            }
                else{
                    this.openOrder_flag=false;
                }
        })
        .catch(error => {
            this.isLoading=false;
            let errorString = 'Something went wrong, Please contact your Salesforce Administrator';
                if ( error.body.message) {
                    errorString = error.body.message;
                }
            this.showToast('Error!', errorString, 'Error');
            this.spinner = true;
            const closeQA = new CustomEvent('close');
            this.dispatchEvent(closeQA);
        });
       
    }
    orderselect(){
        this.roderypSelecte='';
        this.roderypSelecte= this.template.querySelector('[data-id="OrderTypeselect"]').value;
        console.log('<<<<this.roderypSelecte>>>'+this.roderypSelecte);  
        if(this.roderypSelecte!=undefined){           
            this.Ins_ContractNumberSelect='';
            this.flg_orderShw = false;
            this.flg_order =true;
            
            this.reorderflag=true;
            this.flg_Next=false;
            
            if(this.roderypSelecte=='Contract Billing'){
                this.Ins_ContractNumberSelect= this.template.querySelector('[data-id="ContractNumberselect"]').value;
            }
        }
        else{
            this.err_orderSlect=true;
        }
    }
    Previousselect(){          
            this.flg_orderShw = true;
            this.flg_order =false;  
            this.ordertypeflag=false;
            this.SelectedMatList=[];
            
    }


}
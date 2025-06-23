import { LightningElement, track, api, wire } from 'lwc';
import assetFolder from '@salesforce/resourceUrl/Solenis_Exp_Icons';

// New code
import fetchAddress from '@salesforce/apex/b2bAddressComponentController.B2B_get_Addresses';
import { MessageContext } from 'lightning/messageService';
// getOrderlist() method in SolenisB2BgetOrders Apex class
import getOrderlist from '@salesforce/apex/SolenisB2BgetOrders.getOrders';
import getOrderStatus from '@salesforce/apex/SolenisB2BgetOrders.callWebServiceB2bOrderHeaderStoreStatus';
import { NavigationMixin } from 'lightning/navigation';
import Sorticon from '@salesforce/resourceUrl/Sorticon';
import communityPath from '@salesforce/community/basePath';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ExpOrderServiceDownError from '@salesforce/label/c.ExpOrderServiceDownError';
import UserId from '@salesforce/user/Id';
// New code end

export default class Solenis_OrderList extends NavigationMixin(LightningElement) {

    @api effectiveAccountId;
    @track openReorder = false;
    @track backIcon = assetFolder + "/Solenis_Exp_Icons/back.svg";
    @track buildingIcon = assetFolder + "/Solenis_Exp_Icons/building.svg";
    @track sorticonurl = assetFolder + "/Solenis_Exp_Icons/sortIcon.svg";
    calenderIcon = assetFolder + "/Solenis_Exp_Icons/calender.svg";
    @track showDatePicker = false;
    @api range = 3600000;
    @track startDate = "";
    @track endDate = "";
    // @track noData = true;
    @track firstNumber = 1;
    @track lastNumber = 10;
    value = 'Past 6 Months';
    get options() {
        return [
            { label: 'Past 3 Months', value: 'Past 3 Months' },
            { label: 'Past 6 Months', value: 'Past 6 Months' },
            { label: 'Past 1 Year', value: 'Past 1 Year' },
            { label: 'Past 2 Year', value: 'Past 2 Year' }
        ];
    }

    handleChange(event) {
        this.value = event.detail.value;
    }
    
    @track currentPage = 1;
    ROWS_PER_PAGE = 10;

    get TOTAL_ROWS() {
        return this.rows.length;
    }

    get totalPages() {
        return Math.ceil(this.TOTAL_ROWS / this.ROWS_PER_PAGE);
    }

    get displayedRows() {
        const startIndex = (this.currentPage - 1) * this.ROWS_PER_PAGE;
        const endIndex = startIndex + this.ROWS_PER_PAGE;
        return this.rows.slice(startIndex, endIndex);
    }

    get getPageNumbers() {
        return Array.from({ length: this.totalPages }, (_, index) => index + 1);
    }

    goToPage(event) {
        const selectedPage = parseInt(event.target.dataset.page, 10);
        if (selectedPage !== this.currentPage) {
            this.currentPage = selectedPage;
        }
        this.firstNumber = (this.currentPage - 1) * this.ROWS_PER_PAGE + 1;
        this.lastNumber = this.currentPage * this.ROWS_PER_PAGE;
    }
    
    // new code to get order header details
    @track address = '';
    @track accountName = '';
    @track accountNumber = '';
    // new code to get order header details end

    // New code
    label = { ExpOrderServiceDownError };
    @api recordId;
    // sorticonurl = Sorticon;
    searchKey = '';
    @track orders = [];
    @track orderShowList = [];
    @track mapOrderdetails = [];
    pageNumber = 1;
    orderCount = 0;
    pageSize = 10;
    @track loadingflag;
    OrderItemResult = '';
    @track orderDetailsflag = false;
    @track ordersflag = true;
    @track Orderlist = [];
    @track orderlinelist;
    @track orderstatusheader;
    // Load context for Lightning Messaging Service 
    @wire(MessageContext) messageContext;
    //page count
    @track pageStartIndex;
    @track pageEndIndex;

    showdropdown = false;

    // Address infomration
    @track orderDetails;
    @track orderStatus;
    @track poNumber;
    @track orderNumber;
    @track datePlaced;
    @track orderPlacedBy;
    @track billingCity;
    @track billingCountry;
    @track billingPostalCode;
    @track billingState;
    @track billingStreet;
    @track shippingCity;
    @track shippingCountry;
    @track shippingPostalCode;
    @track shippingState;
    @track shippingStreet;
    @track deliveryInst;
    @track totalAmount;
    @track cutomerNumber;
    @track salesOrg;
    @track division;
    @track channel;
    @track selectedsortValue;

    //Get result from the server status
    @track getStatus = [];
    @track orderliineitemFinal = [];

    showList() {
        this.showdropdown = (this.showdropdown ? false : true);
    }

    handleOnselectSort(event) {
        this.showdropdown = false;
        this.selectedsortValue = event.currentTarget.dataset.sort;//event.detail.value;
        if (this.selectedsortValue == 'DateSort') {
            this.loadOrders('OrderedDate');
        }
        if (this.selectedsortValue == 'OrderNumberSort') {
            this.loadOrders('OrderNumber');
        }
    }

    navigateToHomePage() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                pageName: 'OrderSummary'
            },
        });

        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: '/Order_Summary/' + this.re

            }
        }).then(vfURL => {
            window.open(vfURL);
        });
    }

    async loadOrders(sortby) {

        this.mapOrderdetails = [];
        this.orderShowList = [];
        await getOrderlist({ "AccountID": this.effectiveAccountId, "userID": UserId, "sortBy": sortby , "startDate": this.startDate, "endDate": this.endDate})
            .then(response => {
                console.log('response111-->' + JSON.stringify(response))
                this.orders = response;
                this.orderCount = response.length;

                if (response.length <= this.pageSize)
                    this.orderShowList = response;
                else {
                    for (var i = 0; i < this.pageSize; i++) {
                        this.orderShowList.push(response[i]);
                        this.mapOrderdetails[response[i].orderID] = response[i];

                    }
                    console.log('Initial Showlist' + JSON.stringify(this.orderShowList));
                }
            })
            .catch(error => {
                console.log('Error1');
                this.loadingflag = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'error',
                        message: 'Could not load Orders. Please try again later or contact customer service',
                        variant: 'error',
                        mode: 'dismissable'
                    })
                );
                //   this.showErrorToast(error);
            });
        // console.log('Initial Showlist--->' + JSON.stringify(this.mapOrderdetails));
        // console.log('Initial Showlist--->' + JSON.stringify(this.mapOrderdetails.length));
        this.pageStartIndex = 1;
        this.pageEndIndex = this.orderShowList.length;
        for (var j = 0; j < this.orderShowList.length; j++) {
            if(this.orderShowList[j].status!='Completed'){//Aakash W- Added condition for SFEC-249 Orders - Performance Improvement
                this.orderShowList[j].status = 'Checking...';
            }
        }
        for (var j = 0; j < this.orderShowList.length; j++) {

            this.OrderItemResult = '';
            //code added to checking
            if(this.orderShowList[j].status!='Completed'){ //Aakash W- Added condition for SFEC-249 Orders - Performance Improvement
                this.orderShowList[j].status = 'Checking...';
                // console.log('Result' + j + this.OrderItemResult);
                // console.log('Order Number' + j + '--mmm-->' + this.orderShowList[j].sapOrderNumber);
                // console.log('sapChannel' + j + '--mmm-->' + this.orderShowList[j].sapChannel);
                // console.log('sapCustomerNumber' + j + '--mmm-->' + this.orderShowList[j].sapCustomerNumber);
                // console.log('sapDivision' + j + '--mmm-->' + this.orderShowList[j].sapDivision);
                // console.log('sapOrg' + j + '--mmm-->' + this.orderShowList[j].sapOrg);
                // callWebServiceB2bOrderHeader(String recordId,String strSAPOrderNumber,
                // String sapChannel,String sapCustomerNumber,
                // String sapDivision,String sapOrg)
                // console.log('1' + this.orderShowList[j].sapOrderNumber);
                // console.log('2' + this.orderShowList[j].sapChannel);
                // console.log('3' + this.orderShowList[j].sapCustomerNumber);
                // console.log('4' + this.orderShowList[j].sapDivision);
                // console.log('5' + this.orderShowList[j].sapOrg);
                if (this.orderShowList[j].sapOrderNumber != null && this.orderShowList[j].sapOrderNumber != undefined &&
                    this.orderShowList[j].sapChannel != null && this.orderShowList[j].sapChannel != undefined &&
                    this.orderShowList[j].sapCustomerNumber != null && this.orderShowList[j].sapCustomerNumber != undefined &&
                    this.orderShowList[j].sapDivision != null && this.orderShowList[j].sapDivision != undefined &&
                    this.orderShowList[j].sapOrg != null && this.orderShowList[j].sapOrg != undefined
                ) {
                    await getOrderStatus({
                        "recordId": this.recordId,
                        "strSAPOrderNumber": this.orderShowList[j].sapOrderNumber,
                        "sapChannel": this.orderShowList[j].sapChannel,
                        "sapCustomerNumber": this.orderShowList[j].sapCustomerNumber,
                        "sapDivision": this.orderShowList[j].sapDivision, "sapOrg": this.orderShowList[j].sapOrg
                    })
                        .then(response => {
                            console.log('response222-->' + JSON.stringify(response))
                            console.log('1111-->');
                            this.OrderItemResult = response;
                            // this.orderShowList[j].sapOrg=JSON.stringify(response);
                        })
                        .catch(error => {
                            this.loadingflag = false;
                            console.log('Error2');
                            //  this.showErrorToast(error);
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'error',
                                    message: this.label.ExpOrderServiceDownError,
                                    variant: 'error',
                                    mode: 'dismissable'
                                })
                            );
                        });
                    console.log('1111-->' + this.orderShowList[j].sapOrg);
                    this.orderShowList[j].status = this.OrderItemResult;
                    console.log('222-->' + this.orderShowList[j].status);

                }
                else {
                    console.log('Status Product' + this.orderShowList[j].status);
                    this.orderShowList[j].status = '';
                    console.log('Status Product 2' + this.orderShowList[j].status);
                }
            }
        }

        this.loadingflag = false;
    }

    async connectedCallback() {
        this.loadingflag = true;
        console.log('EffectiveAccountId in Order List :: ' + this.effectiveAccountId);

        this.orderDetailsflag = false;
        this.ordersflag = true;
        this.loadOrders(null);
        fetchAddress({
            "AccountId": this.effectiveAccountId
        }).then(data => {
            // console.log({ data });
            this.address = data.ParentAccountAddress;
            this.accountName = data.ParentAccountName;
            this.accountNumber = data.ParentAccountNumber;
        }).catch(error => {
            console.log('error===');
            console.log({ error });
        });
    }

    async pageChange(event) {
        // this.pageNumber = event.detail;
        this.pageNumber = event.detail ?? 1;
        console.log('Page No:: ',this.pageNumber);
        this.orderShowList = [];
        this.mapOrderdetails = [];
        var startIndx = 0;
        var endIndx = this.pageSize - 1;

        startIndx = startIndx + (this.pageSize * (this.pageNumber - 1));
        //page

        this.pageStartIndex = startIndx + 1;
        endIndx = startIndx + this.pageSize;
        console.log('startIndx' + startIndx);
        console.log('endIndx' + endIndx);
        this.pageEndIndex = endIndx;
        for (var i = startIndx; i < endIndx; i++) {
            console.log('orderCount' + this.orderCount);
            if (i < this.orderCount) {

                this.orderShowList.push(this.orders[i]);
                //code added to save the Order header values for selected
                this.mapOrderdetails[this.orders[i].orderID] = this.orders[i];
            }
            else {
                this.pageEndIndex = this.orderCount;
            }
        }
        console.log('Current Page Showlist' + JSON.stringify(this.orderShowList));
        //From Order list we need to get the current status for each item.
        for(var j = 0; j < this.orderShowList.length; j++) {
            if(this.orderShowList[j].status!='Completed'){//Aakash W- Added condition for SFEC-249 Orders - Performance Improvement
                this.orderShowList[j].status = 'Checking...';
            }
        }
        for(var j = 0; j < this.orderShowList.length; j++) {
            //code addded for user friendly
            if(this.orderShowList[j].status!='Completed'){//Aakash W- Added condition for SFEC-249 Orders - Performance Improvement
                this.orderShowList[j].status = 'Checking...';
                console.log('Result' + j + this.OrderItemResult);
                this.OrderItemResult = '';
                // console.log('Order Number' + j + '--mmm-->' + this.orderShowList[j].sapOrderNumber);
                // console.log('sapChannel' + j + '--mmm-->' + this.orderShowList[j].sapChannel);
                // console.log('sapCustomerNumber' + j + '--mmm-->' + this.orderShowList[j].sapCustomerNumber);
                // console.log('sapDivision' + j + '--mmm-->' + this.orderShowList[j].sapDivision);
                // console.log('sapOrg' + j + '--mmm-->' + this.orderShowList[j].sapOrg);
                // console.log('SAP Status' + j + '--mmm-->' + this.orderShowList[j].status);
                // callWebServiceB2bOrderHeader(String recordId,String strSAPOrderNumber,
                // String sapChannel,String sapCustomerNumber,
                // String sapDivision,String sapOrg)
                if (this.orderShowList[j].sapOrderNumber != null && this.orderShowList[j].sapOrderNumber != undefined &&
                    this.orderShowList[j].sapChannel != null && this.orderShowList[j].sapChannel != undefined &&
                    this.orderShowList[j].sapCustomerNumber != null && this.orderShowList[j].sapCustomerNumber != undefined &&
                    this.orderShowList[j].sapDivision != null && this.orderShowList[j].sapDivision != undefined &&
                    this.orderShowList[j].sapOrg != null && this.orderShowList[j].sapOrg != undefined
                ) {
                    await getOrderStatus({
                        "recordId": this.recordId,
                        "strSAPOrderNumber": this.orderShowList[j].sapOrderNumber,
                        "sapChannel": this.orderShowList[j].sapChannel,
                        "sapCustomerNumber": this.orderShowList[j].sapCustomerNumber,
                        "sapDivision": this.orderShowList[j].sapDivision, "sapOrg": this.orderShowList[j].sapOrg
                    })
                        .then(response => {
                            // console.log('response222-->' + JSON.stringify(response))
                            // console.log('1111-->');
                            this.OrderItemResult = response;
                            // this.orderShowList[j].sapOrg=JSON.stringify(response);
                        })
                        .catch(error => {
                            //this.showErrorToast(error);
                            this.loadingflag = false;
                            // console.log('Error3');
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'error',
                                    message: this.label.ExpOrderServiceDownError,
                                    variant: 'error',
                                    mode: 'dismissable'
                                })
                            );
                        });
                    // console.log('1111-->' + this.orderShowList[j].sapOrg);
                    this.orderShowList[j].status = this.OrderItemResult;
                    // console.log('222-->' + this.orderShowList[j].status);
                } else {
                    // console.log('Status Product' + this.orderShowList[j].status);
                    this.orderShowList[j].status = '';
                    // console.log('Status Product 2' + this.orderShowList[j].status);
                }
            }
        }
    }

    async orderclickHandler(event) {
        this.url = '';
        // this.url = communityPath + '/OrderSummary/' + event.target.dataset.item;
        this.url = communityPath + '/OrderSummary?recordId=' + event.target.dataset.item;
        // this.url = communityPath + '/OrderSummaryDetail/' + event.target.dataset.item;
        //  this.url=this.url.replace("/s/", "/");
        // console.log('url 1==' + this.url);
        window.open(this.url);

        /* this[NavigationMixin.GenerateUrl]({
               type: 'standard__webPage',
               attributes: {
                   url: '/soleniseshop/s/OrderSummary/'+event.target.dataset.item
                //    url: '/soleniseshop/s/OrderSummaryDetail/'+event.target.dataset.item       
               }
           }).then(vfURL => {
           window.open(vfURL);
           });*/

        // console.log('Inside Order click Event');
    }

    handleSearchKeyChange(event) {
        this.searchKey = event.target.value.toLowerCase();
    }

    backToHome() {
        window.open(communityPath + '/landingpage', '_self');
    }
    // New code end

    handleReorderClick() {
        console.log('effective id on handle click'+this.effectiveAccountId);
        this.openReorder = true;
    }

    handleCalenderClick() {
        this.showDatePicker = true;
    }

    closeDatePickerModal() {
        this.showDatePicker = false;
    }

    handleGetDates(event) {
        console.log("FROM:: ", event.detail.startDate);
        console.log("TO::", event.detail.endDate);
        this.startDate = event.detail.startDate;
        this.endDate = event.detail.endDate;
        this.showDatePicker = false;
        if (this.startDate != "" && this.endDate != "") {
            if(this.selectedsortValue == 'DateSort') {
                this.loadOrders('OrderedDate');
            }
            if(this.selectedsortValue == 'OrderNumberSort') {
                this.loadOrders('OrderNumber');
            }
            else{
                this.loadOrders(null);
            }
        } else {
            this.loadOrders(null);
        }
    }

    // Close Date range picker modal on click of 'Escape' button on keyboard
    handleEscapeKey(event) {
        if (event.key === 'Escape' && this.showDatePicker) {
            //close the modal
            this.closeDatePickerModal();
        }
    }
}
import { LightningElement, track, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import communityPath from '@salesforce/community/basePath';
import assetFolder from '@salesforce/resourceUrl/Solenis_Exp_Icons';
// import getLatestOrders from '@salesforce/apex/Exp_LatestOrders.getLatestOrders';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getOrderlist from '@salesforce/apex/Exp_LatestOrders.getOrders';
import getOrderStatus from '@salesforce/apex/SolenisB2BgetOrders.callWebServiceB2bOrderHeaderStoreStatus';
import ExpOrderServiceDownError from '@salesforce/label/c.ExpOrderServiceDownError';

export default class Solenis_Orders extends LightningElement {
    calenderIcon = assetFolder + "/Solenis_Exp_Icons/calender.svg";
    @track showDatePicker = false;
    @api range = 3600000;
    @track startDate = "";
    @track endDate = "";
    @track noOrderData = true;
    @track isLoading = false;

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

    @track orderData = [
        // {
        //     orderNumber: '0008793376',
        //     orderStatus: 'Completed',
        //     orderDate: '2023-03-27',
        //     orderPONumber: 'TESTJUVSDU088_02',
        //     orderShipToNumber: '0000682131'
        // },
        // {
        //     orderNumber: '0008793233',
        //     orderStatus: 'Completed',
        //     orderDate: '2023-06-28',
        //     orderPONumber: 'TESTJUVSDU090_02',
        //     orderShipToNumber: '0000682131'
        // },
        // {
        //     orderNumber: '0008733877',
        //     orderStatus: 'Completed',
        //     orderDate: '2022-12-31',
        //     orderPONumber: 'TESTJUVSDU023_01',
        //     orderShipToNumber: '0000682131'
        // },
        // {
        //     orderNumber: '0008793379',
        //     orderStatus: 'Completed',
        //     orderDate: '2023-03-03',
        //     orderPONumber: 'TESTJUVSDU034_09',
        //     orderShipToNumber: '0000682131'
        // },
        // {
        //     orderNumber: '0008793380',
        //     orderStatus: 'Completed',
        //     orderDate: '2023-03-04',
        //     orderPONumber: 'TESTJUVSDU056_13',
        //     orderShipToNumber: '0000682131'
        // },
        // {
        //     orderNumber: '0008793381',
        //     orderStatus: 'Completed',
        //     orderDate: '2023-04-10',
        //     orderPONumber: 'TESTJUVSDU034_45',
        //     orderShipToNumber: '0000682131'
        // },
        // {
        //     orderNumber: '0008793382',
        //     orderStatus: 'Completed',
        //     orderDate: '2023-03-27',
        //     orderPONumber: 'TESTJUVSDU088_01',
        //     orderShipToNumber: '0000682131'
        // },
    ];

    // New Code
    label = { ExpOrderServiceDownError, };
    @api recordId;
    @api effectiveAccountId;
    orders;
    orderDetailsflag = false;
    ordersflag = true;
    @track orderShowList = [];
    // New Code end

    // @wire(getLatestOrders)
    // wiredGetRecentOrders(result) {
    //     let orders = [];
    //     if (result.data && result?.data?.orders) {
    //         orders = result.data.orders;
    //         this.formulateData(orders);
    //         if (orders?.length <= 0) {
    //             this.noOrderData = true;
    //         }
    //     } else {
    //         this.noOrderData = true;
    //     }
    // }

    // formulateData(dataRecieved) {
    //     if (dataRecieved != null && dataRecieved != undefined && dataRecieved != []) {
    //         dataRecieved.forEach(item => {
    //             let obj = {};
    //             obj.orderNumber = item["orderNumber"];
    //             obj.orderStatus = item["orderStatus"];
    //             obj.orderDate = item["orderDate"];
    //             obj.orderPONumber = item["poNumber"];
    //             obj.orderShipToNumber = item["shipToNumber"];
    //             this.orderData.push(obj);
    //         })
    //         if (this.orderData?.length <= 0 || this.orderData == []) {
    //             this.noOrderData = true;
    //         } else {
    //             this.noOrderData = false;
    //         }
    //     } else {
    //         this.orderData = [];
    //         this.noOrderData = true;
    //     }
    //     // console.log('Orders:: ',JSON.stringify(this.orderData));
    //     // console.log('No Data:: ',JSON.stringify(this.noOrderData));
    // }

    handleViewAllClick() {
        console.log('workking@@@');
        const config = {
            type: 'standard__webPage',
            attributes: {
                url: 'https://solenis--sit.sandbox.my.site.com/soleniseshop'
            }
        };
        this[NavigationMixin.Navigate](config);
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
        this.endDate = event.detail.endDate
        if (this.startDate != "" && this.endDate != "") {
            this.showDatePicker = false;
        }
    }

    // Close Date range picker modal on click of 'Escape' button on keyboard
    handleEscapeKey(event) {
        if (event.key === 'Escape' && this.showDatePicker) {
            //close the modal
            this.closeDatePickerModal();
        }
    }

    connectedCallback() {
        document.addEventListener("keydown", this.handleEscapeKey.bind(this));

        // New code
        this.loadingflag = true;
        console.log('effectiveAccountId in Latest Orders:: ' + this.effectiveAccountId);
        this.orderDetailsflag = false;
        this.ordersflag = true;
        this.loadOrders();
        // New Code end
    }

    // New code
    handleViewAllClick() {
        const config = {
            type: 'standard__webPage',
            attributes: {
                url: '/SolenisExperienceCloud/s/order-list'
            }
        };
        this[NavigationMixin.Navigate](config);
    }

    async loadOrders() {
        this.orderShowList = [];
        this.isLoading = true;
        // Hardcoding AccountId to test: '0015900000NAotBAAT'
        // await getOrderlist({ "AccountID": '0015900000NAotBAAT', "userID": this.recordId })
        await getOrderlist({ "AccountID": this.effectiveAccountId, "userID": this.recordId })
            .then(response => {
                console.log('response111-->' + JSON.stringify(response))
                //this.orders = response.ordersList;
                //this.orderCount = response.length;
                if (response.isSuccess) {
                    this.orderShowList = JSON.parse(JSON.stringify(response.ordersList));
                    if (this.orderShowList?.length <= 0 || this.orderShowList == []) {
                        this.noOrderData = true;
                    } else {
                        this.noOrderData = false;
                    }
                } else {
                    console.log('Error ' + response.message);
                    this.loadingflag = false;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'error',
                            message: '{0} could not load Orders. Please try again later or contact customer service',
                            variant: 'error',
                            mode: 'dismissable'
                        })
                    );
                }
                this.isLoading = false;
            })
            .catch(error => {
                // console.log('Error1');
                this.loadingflag = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'error',
                        message: '{0} could not load Orders. Please try again later or contact customer service',
                        variant: 'error',
                        mode: 'dismissable'
                    })
                );
                this.isLoading = false
                //   this.showErrorToast(error);
            });

        for (var j = 0; j < this.orderShowList.length; j++) {
            if(this.orderShowList[j].status!='Completed'){//Aakash W- Added condition for SFEC-249 Orders - Performance Improvement
                this.orderShowList[j].status = 'Checking...';
            }
            //Added
            this.orderShowList[j].orderUrl = '/SolenisExperienceCloud/s/OrderSummary/' + this.orderShowList[j].orderID;
        }
        for (var j = 0; j < this.orderShowList.length; j++) {
            this.OrderItemResult = '';
            //code added to checking
            if(this.orderShowList[j].status!='Completed'){//Aakash W- Added condition for SFEC-249 Orders - Performance Improvement
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
                            // console.log('response222-->' + JSON.stringify(response))
                            // console.log('1111-->');
                            this.OrderItemResult = response;
                            // this.orderShowList[j].sapOrg=JSON.stringify(response);
                        })
                        .catch(error => {
                            this.loadingflag = false;
                            // console.log('Error2');
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
                    // console.log('1111-->' + this.orderShowList[j].sapOrg);
                    this.orderShowList[j].status = this.OrderItemResult;
                    // console.log('222-->' + this.orderShowList[j].status);

                }
                else {
                    // console.log('Status Product' + this.orderShowList[j].status);
                    this.orderShowList[j].status = '';
                    // console.log('Status Product 2' + this.orderShowList[j].status);
                }
            }
        }

        this.loadingflag = false;
    }

    handleExploreMore() {
        window.open(communityPath + '/orders-list-page', '_self');
    }
    // New code end
}
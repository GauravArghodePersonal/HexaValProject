import { LightningElement, wire, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getOrderlist from '@salesforce/apex/Exp_LatestOrders.getOrders';
import getOrderStatus from '@salesforce/apex/SolenisB2BgetOrders.callWebServiceB2bOrderHeader';
import ExpOrderServiceDownError from '@salesforce/label/c.ExpOrderServiceDownError';
export default class Exp_latestOrders extends NavigationMixin(LightningElement) {
    label = {
        ExpOrderServiceDownError,
    };
    @api
    recordId;
    @api
    effectiveAccountId;
    orders;

    orderDetailsflag = false;
    ordersflag = true;
    @track orderShowList = [];

    connectedCallback() {
        this.loadingflag = true;
        console.log('effectiveAccountId' + this.effectiveAccountId);
        this.orderDetailsflag = false;
        this.ordersflag = true;
        this.loadOrders();
    }

    /*renderedCallback(){
        //code
        this.loadingflag = true;
        console.log('effectiveAccountId' + this.effectiveAccountId);
        this.orderDetailsflag = false;
        this.ordersflag = true;
        this.loadOrders();
    }*/


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
        await getOrderlist({ "AccountID": this.effectiveAccountId, "userID": this.recordId })
            .then(response => {
                console.log('response111-->' + JSON.stringify(response))
                //this.orders = response.ordersList;
                //this.orderCount = response.length;
                if(response.isSuccess){
                    this.orderShowList = JSON.parse(JSON.stringify(response.ordersList));
                }
                else{
                    console.log('Error '+response.message);
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
            })
            .catch(error => {
                console.log('Error1');
                this.loadingflag = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'error',
                        message: '{0} could not load Orders. Please try again later or contact customer service',
                        variant: 'error',
                        mode: 'dismissable'
                    })
                );
                //   this.showErrorToast(error);
            });

        for (var j = 0; j < this.orderShowList.length; j++) {
            this.orderShowList[j].status = 'Checking...';
            //Added
            this.orderShowList[j].orderUrl = '/SolenisExperienceCloud/s/OrderSummary/' + this.orderShowList[j].orderID;
        }
        for (var j = 0; j < this.orderShowList.length; j++) {

            this.OrderItemResult = '';
            //code added to checking
            this.orderShowList[j].status = 'Checking...';
            console.log('Result' + j + this.OrderItemResult);
            console.log('Order Number' + j + '--mmm-->' + this.orderShowList[j].sapOrderNumber);
            console.log('sapChannel' + j + '--mmm-->' + this.orderShowList[j].sapChannel);
            console.log('sapCustomerNumber' + j + '--mmm-->' + this.orderShowList[j].sapCustomerNumber);
            console.log('sapDivision' + j + '--mmm-->' + this.orderShowList[j].sapDivision);
            console.log('sapOrg' + j + '--mmm-->' + this.orderShowList[j].sapOrg);
            //callWebServiceB2bOrderHeader(String recordId,String strSAPOrderNumber,
            //     String sapChannel,String sapCustomerNumber,
            //   String sapDivision,String sapOrg)
            console.log('1' + this.orderShowList[j].sapOrderNumber);
            console.log('2' + this.orderShowList[j].sapChannel);
            console.log('3' + this.orderShowList[j].sapCustomerNumber);
            console.log('4' + this.orderShowList[j].sapDivision);
            console.log('5' + this.orderShowList[j].sapOrg);
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

        this.loadingflag = false;
    }
}
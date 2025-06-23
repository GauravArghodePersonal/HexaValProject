import { LightningElement,track, api } from 'lwc';
import getOrderProducts from '@salesforce/apex/B2BRecentOrderController.getOrderProducts';

export default class B2bRecentOrderProducts extends LightningElement {
    @api effectiveAccountId;
    @track productNameList = [];
    ordersItems = [];
    ordersItemCount = 0;
    showRecentOrder = false;
    connectedCallback() {
        console.log('Effective==='+this.effectiveAccountId);
        getOrderProducts({"accountId":this.effectiveAccountId})
        .then(response => {
            console.log(response);
            this.ordersItems = response;
            this.ordersItemCount = response.length;
            if(response.length > 0)
                this.showRecentOrder = true;

             //Test Event For Google Analytics
            //  if(this.ordersItems.length != 0){
            //     console.log('lenght===='+this.ordersItems.length);
            //     console.log('this.ordersItems=='+this.ordersItems);
            //     for(var i = 0 ; i < this.ordersItems.length ; i++){
            //         console.log('order Item'+JSON.stringify(this.ordersItems[i]));
            //         console.log('Name==='+this.ordersItems[i].Product2.Name);
                    
            //         // this.productNameList.push(this.ordersItems[i].Product2.Name);
            //     }


                
            //     // console.log('Event TEST==='+this.productNameList);
            //     // let tempEvent = {
            //     //     "tempEvt": "Popular Page : Home",
            //     //     "event_category": "Popular Product",
            //     //     "event_label": "Solenis"
            //     // }
            //     // this.dispatchEvent( 
            //     //     new CustomEvent( 
            //     //         'PopularProductEvent', // Event Name
            //     //         {
            //     //             detail: tempEvent,
            //     //             bubbles: true,
            //     //             composed: true,
            //     //         }
            //     //     )

            //     // );

            // }
            //test end
        })
        .catch(error => {
           console.log('error=='+error);
        });
        
       
    }

  //Event dispatched for Google Analytics
  handleAddtoCart(event){
    console.log('parent===='+event.detail);
    const testEvent = new CustomEvent("addToCartEvent", {
        detail: event.detail,
        bubbles: true,
        composed: true,
    });

    this.dispatchEvent(testEvent);
}
// End of Event
}
import { LightningElement,api } from 'lwc';
import reOrderList from '@salesforce/apex/solenisReorderController.reOrderList';

export default class ExOrderAttachment extends LightningElement {
   
     Insreorder =[];
    @api reorderIds;
    isLoading=true;
    

    connectedCallback(){ 
        // console.log('insidne callbackkkkk'+this.reorderIds);
        this.getreOrder();
    }

    


    getreOrder(){
    //    console.log('insidne fucntion');
        reOrderList({reorderIds: this.reorderIds})
        .then(result=>{
            // console.log('<<<<>>>>'+ JSON.stringify(result));
            this.Insreorder = result;
            for(var i=0;i<this.Insreorder.length;i++){
                this.Insreorder[i].Nameurl='/'+this.Insreorder[i].Id;
                // console.log('somthing'+(this.Insreorder[i].Nameurl='/'+this.Insreorder[i].Id));
                
            }
            this.isLoading=false;
        }
         

        )    
    }
   
}
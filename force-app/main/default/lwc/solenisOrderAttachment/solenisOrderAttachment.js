import { LightningElement, track, api } from 'lwc';
import reOrderList from '@salesforce/apex/solenisReorderController.reOrderList';

export default class SolenisOrderAttachment extends LightningElement {
    @track Insreorder =[];
    @api reorderIds;
  

    connectedCallback(){ 
        this.getreOrder();
    }

    getreOrder(){
       // var reorderd =[];
       // reorderd.push('a4Zm0000000FpKGEA0');
       // reorderd.push('a4Zm0000000FpJREA0');
        reOrderList({reorderIds: this.reorderIds})
        .then(result=>{
            console.log('<<<<>>>>'+ JSON.stringify(result));
            this.Insreorder = result;
            for(var i=0;i<this.Insreorder.length;i++){
                this.Insreorder[i].Nameurl='/'+this.Insreorder[i].Id;

                
            }
        }

        )    
    }
   

}
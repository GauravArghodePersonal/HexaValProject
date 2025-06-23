import { LightningElement,track } from 'lwc';
import getMyTeam from '@salesforce/apex/solenisPortnerPortalController.getcontactList';
import usrId from '@salesforce/user/Id';


export default class SolenisPortnerPortalMyTeam extends LightningElement {
    @track myteamList =[]; 
    userId = usrId;

    connectedCallback(){ 
        this.getMyTeam();
    }

    getMyTeam(){
        // var reorderd =[];
        // reorderd.push('a4Zm0000000FpKGEA0');
        // reorderd.push('a4Zm0000000FpJREA0');
       // alert('Test');
        getMyTeam({UserId: this.userId})
         .then(result=>{
           // alert('Test1');
             console.log('<<<<>>>>'+ JSON.stringify(result));
             this.myteamList = result;
            
         }) 
         .catch((error) => {          
            console.log('<<error>>>>'+JSON.stringify(error));            
        });   
     }
    

    
}
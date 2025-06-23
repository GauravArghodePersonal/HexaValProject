import { LightningElement, track } from 'lwc';
// import backgroundUrl from '@salesforce/resourceUrl/switch2light';
import ExpVAImg1 from '@salesforce/resourceUrl/ExpVAImg1';
import ExpVAImg2 from '@salesforce/resourceUrl/ExpVAImg2';
import ExpVAImg3 from '@salesforce/resourceUrl/ExpVAImg3';
import ExpVAImg4 from '@salesforce/resourceUrl/ExpVAImg4';
import assetFolder from '@salesforce/resourceUrl/Solenis_Exp_Icons';

export default class Solenis_ValueAdvantage extends LightningElement {
    @track compareButton = assetFolder + "/Solenis_Exp_Icons/compare.svg";
    @track flipButton = assetFolder + "/Solenis_Exp_Icons/flipButton.svg";
    @track tileList = [
        {
            Id: 1,
            Name: 'Tile 1',
            Value: "700,000M",
            Caption: "Gallons of water",
            bgImage: `background-image:url(${ExpVAImg1})`
            // Rating: 'Hot',
            // Industry: 'Boiler',
            // Phone: '999999999'
        },
        {
            Id: 2,
            Name: 'Tile 2',
            Value: "100,000,000",
            Caption: "KWH of energy",
            bgImage: `background-image:url(${ExpVAImg2})`
            // Rating: 'Cold',
            // Industry: 'Boiler',
            // Phone: '999999999'
        },
        {
            Id: 3,
            Name: 'Tile 3',
            Value: "50,000K",
            Caption: "Tons of CO2",
            bgImage: `background-image:url(${ExpVAImg3})`
            // Rating: 'Hottest',
            // Industry: 'Boiler',
            // Phone: '999999999'
        },
        {
            Id: 4,
            Name: 'Tile 4',
            Value: "800M",
            Caption: "USD",
            bgImage: `background-image:url(${ExpVAImg4})`
            // Rating: 'Warm',
            // Industry: 'Boiler',
            // Phone: '999999999'
        }
    ];

    // get backgroundStyle() {
    //     return `background-image:url(${backgroundUrl})`;
    // }
    // appResources = {
    //     bearSilhouette: `${accountResources}/Account_Tile/img/avtar1.PNG`,
    // };
}
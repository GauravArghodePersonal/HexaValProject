import { LightningElement, track, api } from 'lwc';
import assetFolder from '@salesforce/resourceUrl/Solenis_Exp_Icons';

export default class Solenis_slider extends LightningElement {
    successIcon = assetFolder + "/Solenis_Exp_Icons/success.svg";
    warningIcon = assetFolder + "/Solenis_Exp_Icons/warning.svg";
    blankAlarmIcon = assetFolder + "/Solenis_Exp_Icons/blankAlarm.svg";
    blueAlarmIcon = assetFolder + "/Solenis_Exp_Icons/blueAlarm.svg";
    flipButtonIcon = assetFolder + "/Solenis_Exp_Icons/blackFlipButton.svg";

    @track slideIndex = 1;
    @track showSlider = false;
    @api appList = [];
    @track appMenu =[];

    /*
    // Sample Data received from Parent
    @track appList = [
                {
                    "applicationId": "44348731",
                    "applicationName": "Cooling Tower-CT-7 Cooling Tower-CT-7 Cooling Tower-CT-7",
                    "applicationStateIcon": this.successIcon
                },
                {
                    "applicationId": "44356641",
                    "applicationName": "Cooling Tower CT-1",
                    "applicationStateIcon": this.successIcon
                },
                {
                    "applicationId": "44427859",
                    "applicationName": "Cooling Tower CT-2",
                    "applicationStateIcon": this.warningIcon
                },
                {
                    "applicationId": "44348731",
                    "applicationName": "Cooling Tower-CT-3",
                    "applicationStateIcon": this.successIcon
                },
                {
                    "applicationId": "44356641",
                    "applicationName": "Cooling Tower CT-4",
                    "applicationStateIcon": this.warningIcon
                },
                {
                    "applicationId": "44427859",
                    "applicationName": "Cooling Tower CT-5",
                    "applicationStateIcon": this.successIcon
                },{
                    "applicationId": "44348731",
                    "applicationName": "Cooling Tower-CT-6",
                    "applicationStateIcon": this.warningIcon
                },
                {
                    "applicationId": "44356641",
                    "applicationName": "Cooling Tower CT-7",
                    "applicationStateIcon": this.warningIcon
                },
                {
                    "applicationId": "44427859",
                    "applicationName": "Cooling Tower CT-8",
                    "applicationStateIcon": this.successIcon
                },{
                    "applicationId": "44348731",
                    "applicationName": "Cooling Tower-CT-9",
                    "applicationStateIcon": this.successIcon
                },
                {
                    "applicationId": "44356641",
                    "applicationName": "Cooling Tower CT-10",
                    "applicationStateIcon": this.successIcon
                },
                {
                    "applicationId": "44427859",
                    "applicationName": "Cooling Tower CT-11",
                    "applicationStateIcon": this.warningIcon
                }
            ]

    // Sample Data after formatting
    @track appMenu = [
        {
            "page_no": 1,
            "column_1_data": [
                {
                    "applicationId": "44348731",
                    "applicationName": "Cooling Tower-CT-7 Cooling Tower-CT-7 Cooling Tower-CT-7",
                    "applicationStateIcon": this.successIcon
                },
                {
                    "applicationId": "44356641",
                    "applicationName": "Cooling Tower CT-9",
                    "applicationStateIcon": this.successIcon
                },
                {
                    "applicationId": "44427859",
                    "applicationName": "Cooling Tower CT-10",
                    "applicationStateIcon": this.successIcon
                }
            ],
            "column_2_data": [
                {
                    "applicationId": "44348731",
                    "applicationName": "Cooling Tower-CT-7",
                    "applicationStateIcon": this.successIcon
                },
                {
                    "applicationId": "44356641",
                    "applicationName": "Cooling Tower CT-9",
                    "applicationStateIcon": this.successIcon
                },
                {
                    "applicationId": "44427859",
                    "applicationName": "Cooling Tower CT-10",
                    "applicationStateIcon": this.successIcon
                }
            ],
        },
        {
            "page_no": 2,
            "column_1_data": [
                {
                    "applicationId": "44348731",
                    "applicationName": "Cooling Tower-CT-7",
                    "applicationStateIcon": this.warningIcon
                },
                {
                    "applicationId": "44356641",
                    "applicationName": "Cooling Tower CT-9",
                    "applicationStateIcon": this.warningIcon
                },
                {
                    "applicationId": "44427859",
                    "applicationName": "Cooling Tower CT-10",
                    "applicationStateIcon": this.warningIcon
                }
            ],
            "column_2_data": [
                {
                    "applicationId": "44348731",
                    "applicationName": "Cooling Tower-CT-7",
                    "applicationStateIcon": this.warningIcon
                },
                {
                    "applicationId": "44356641",
                    "applicationName": "Cooling Tower CT-9",
                    "applicationStateIcon": this.warningIcon
                },
                {
                    "applicationId": "44427859",
                    "applicationName": "Cooling Tower CT-10",
                    "applicationStateIcon": this.warningIcon
                }
            ],
        }
    ]; */

    connectedCallback() {
        // console.log('appList:: ', JSON.stringify(this.appMenu));
        setTimeout(() => {
            this.showSlides(this.slideIndex);
        }, 500);

        // console.log('FORMATTED DATA:: ', JSON.stringify(this.formulateData(this.appList, 6)));
        this.appMenu = this.formulateData(this.appList, 6);
    }

    plusSlides(event) {
        let direction = event.currentTarget.dataset.direction;
        console.log(direction);
        if(direction == 'forward') {
            this.showSlides(this.slideIndex - 1);
        }
        if(direction == 'backward') {
            this.showSlides(this.slideIndex + 1);
        }
    }

    currentSlide(event) {
        let n = event.currentTarget.dataset.pagenumber;
        this.showSlides(this.slideIndex = n);
    }

    showSlides(n) {
        let i;
        let slides = this.template.querySelectorAll('.mySlides');
        let dots = this.template.querySelectorAll('.dot');
        if (n > slides?.length) { this.slideIndex = 1 }
        if (n < 1) { this.slideIndex = slides.length }
        for (i = 0; i < slides.length; i++) {
            slides[i].style.display = "none";
        }
        for (i = 0; i < dots.length; i++) {
            dots[i].className = dots[i]?.className.replace(" active", "");
        }
        slides[this.slideIndex - 1].style.display = "flex";
        dots[this.slideIndex - 1].className += " active";
    }

    // Method to process the received data to the required format
    formulateData(receivedData, itemsPerPage) {

        const transformedData = [];

        // Group the original data into pages
        for (let i = 0; i < receivedData.length; i += itemsPerPage) {
            const pageData = receivedData.slice(i, i + itemsPerPage);

            // Calculate the midpoint to split the array into two parts
            const midpoint = Math.ceil(pageData.length / 2);

            // Split the array into two parts
            const column1Data = pageData.slice(0, midpoint);
            const column2Data = pageData.slice(midpoint);

            transformedData.push({
                "page_no": Math.floor(i / itemsPerPage) + 1,
                "column_1_data": column1Data,
                "column_2_data": column2Data
            });
        }

        if(transformedData.length >= 2) {
            this.showSlider = true;
        }

        return transformedData;
    }
}
import { LightningElement, track, api } from 'lwc';
import communityPath from '@salesforce/community/basePath';
import assetFolder from '@salesforce/resourceUrl/Solenis_Exp_Icons';

export default class Solenis_technicalPerformanceDetail extends LightningElement {
    // Icons
    successIcon = assetFolder + "/Solenis_Exp_Icons/success.svg";
    warningIcon = assetFolder + "/Solenis_Exp_Icons/warning.svg";
    blankAlarmIcon = assetFolder + "/Solenis_Exp_Icons/blankAlarm.svg";
    blueAlarmIcon = assetFolder + "/Solenis_Exp_Icons/blueAlarm.svg";
    flipButtonIcon = assetFolder + "/Solenis_Exp_Icons/blackFlipButton.svg";
    calenderIcon = assetFolder + "/Solenis_Exp_Icons/calender.svg";
    @track backIcon = assetFolder + "/Solenis_Exp_Icons/back.svg";

    @track showDatePicker = false;
    @api range = 3600000;
    @track startDate = "";
    @track endDate = "";

    value = 'Past 6 Months';
    get options() {
        return [
            { label: 'Past 3 Months', value: 'Past 3 Months' },
            { label: 'Past 6 Months', value: 'Past 6 Months' },
            { label: 'Past 1 Year', value: 'Past 1 Year' },
            { label: 'Past 2 Year', value: 'Past 2 Year' }
        ];
    }

    @track finalData = [];

    // Gets from somewhere...
    @track data = [
        {
            Id: 1,
            titleName: "Site 1 - Extended Name",
            titleIcon: this.successIcon,
            titleStateIcon: this.blankAlarmIcon,
            noOfApplications: "8",
            noOfDevices: "0",
            applicationList: [
                {
                    applicationId: 1,
                    applicationName: "Cooling tower",
                    applicationStateIcon: this.successIcon
                },
                {
                    applicationId: 2,
                    applicationName: "Defoamer",
                    applicationStateIcon: this.successIcon
                },
                {
                    applicationId: 3,
                    applicationName: "Boiler",
                    applicationStateIcon: this.successIcon
                },
                {
                    applicationId: 4,
                    applicationName: "Waste water",
                    applicationStateIcon: this.successIcon
                }
            ]
        },
        {
            Id: 2,
            titleName: "Site 2",
            titleIcon: this.warningIcon,
            titleStateIcon: this.blueAlarmIcon,
            noOfApplications: "5",
            noOfDevices: "13",
            applicationList: [
                {
                    applicationId: 1,
                    applicationName: "Cooling tower",
                    applicationStateIcon: this.warningIcon
                },
                {
                    applicationId: 2,
                    applicationName: "Defoamer",
                    applicationStateIcon: this.successIcon
                },
                {
                    applicationId: 3,
                    applicationName: "Boiler",
                    applicationStateIcon: this.warningIcon
                },
                {
                    applicationId: 4,
                    applicationName: "Waste water",
                    applicationStateIcon: this.successIcon
                }
            ]
        },
        {
            Id: 3,
            titleName: "Site 3",
            titleIcon: this.successIcon,
            titleStateIcon: this.blankAlarmIcon,
            noOfApplications: "4",
            noOfDevices: "27",
            applicationList: [
                {
                    applicationId: 1,
                    applicationName: "Cooling tower",
                    applicationStateIcon: this.successIcon
                },
                {
                    applicationId: 2,
                    applicationName: "Defoamer",
                    applicationStateIcon: this.successIcon
                },
                {
                    applicationId: 3,
                    applicationName: "Boiler",
                    applicationStateIcon: this.successIcon
                },
                {
                    applicationId: 4,
                    applicationName: "Waste water",
                    applicationStateIcon: this.successIcon
                }
            ]
        },
        {
            Id: 4,
            titleName: "Site 4",
            titleIcon: this.warningIcon,
            titleStateIcon: this.blueAlarmIcon,
            noOfApplications: "5",
            noOfDevices: "17",
            applicationList: [
                {
                    applicationId: 1,
                    applicationName: "Cooling tower",
                    applicationStateIcon: this.successIcon
                },
                {
                    applicationId: 2,
                    applicationName: "Defoamer",
                    applicationStateIcon: this.warningIcon
                },
                {
                    applicationId: 3,
                    applicationName: "Boiler",
                    applicationStateIcon: this.successIcon
                },
                {
                    applicationId: 4,
                    applicationName: "Waste water",
                    applicationStateIcon: this.warningIcon
                }
            ]
        },
        {
            Id: 5,
            titleName: "Site 5",
            titleIcon: this.warningIcon,
            titleStateIcon: this.blueAlarmIcon,
            noOfApplications: "3",
            noOfDevices: "9",
            applicationList: [
                {
                    applicationId: 1,
                    applicationName: "Cooling tower",
                    applicationStateIcon: this.warningIcon
                },
                {
                    applicationId: 2,
                    applicationName: "Defoamer",
                    applicationStateIcon: this.successIcon
                },
                {
                    applicationId: 3,
                    applicationName: "Boiler",
                    applicationStateIcon: this.successIcon
                },
                {
                    applicationId: 4,
                    applicationName: "Waste water",
                    applicationStateIcon: this.successIcon
                }
            ]
        }
    ];

    handleChange(event) {
        this.value = event.detail.value;
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
        this.processIncomingData(this.data);
    }

    processIncomingData(data) {
        data.forEach(item => {
            let obj = {};
            obj.Id = item.Id;
            obj.titleName = item.titleName;
            obj.titleIcon = item.titleIcon;
            obj.noOfApplications = item.noOfApplications;
            item.applicationList.forEach(app => {
                obj[`${app.applicationName}`.split(" ").join("")] = app.applicationStateIcon;
            });
            this.finalData.push(obj);
        });
    }

    rows = [
        { id: 1, column1: 'Site 1 Site 1 Site 1', column2: '8', column3: 'Row 1', column4: 'Row 1', column5: 'Row 1', column6: 'Row 1' },
        { id: 2, column1: 'Site 2', column2: '8', column3: 'Row 2', column4: 'Row 2', column5: 'Row 2', column6: 'Row 2' },
        { id: 3, column1: 'Site 3', column2: '8', column3: 'Row 3', column4: 'Row 3', column5: 'Row 3', column6: 'Row 3' },
        // Add more rows as needed
    ];

    backToHome() {
        window.open(communityPath + '/landingpage', '_self');
    }
}
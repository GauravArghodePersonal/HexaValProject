import { LightningElement, track, api } from 'lwc';
import assetFolder from '@salesforce/resourceUrl/Solenis_Exp_Icons';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import cumulocityIoTDataLoadingMsg from '@salesforce/label/c.CumulocityIoTDataLoaderMsg';
import getTechnicalPerformanceData from '@salesforce/apex/EXP_TechnicalPerformanceCmpCtrl.getTechnicalPerformanceData';

export default class Solenis_TechnicalPerformance extends LightningElement {
    successIcon = assetFolder + "/Solenis_Exp_Icons/success.svg";
    warningIcon = assetFolder + "/Solenis_Exp_Icons/warning.svg";
    blankAlarmIcon = assetFolder + "/Solenis_Exp_Icons/blankAlarm.svg";
    blueAlarmIcon = assetFolder + "/Solenis_Exp_Icons/blueAlarm.svg";
    flipButtonIcon = assetFolder + "/Solenis_Exp_Icons/blackFlipButton.svg";
    @api effectiveAccountId;
    @track noData = true; 
    @track showViewAllSites = false;
    @track showViewMore = true;
    @track isLoading = true;

    @track data = [];

    @track resultDataFromApex = [];
    
    label = {
        cumulocityIoTDataLoadingMsg
      };

    async connectedCallback() {
        getTechnicalPerformanceData({
            accountId: this.effectiveAccountId
        })
            .then(result => {
                let resultData = JSON.parse(result);
                this.resultDataFromApex = resultData; // Store data received from Apex for later processing.
                if(result.length <= 0 || result == []) {
                    this.noData = true;
                } else {
                    this.formulateData(resultData, true);
                }
                this.isLoading = false;
            })
            .catch(error => {
                console.log('ERROR TECHNICAL PERFORMANCE:: ', error);
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: 'Error while fetching Technical Performance data. Please contact System Admin',
                    variant: 'error'
                });
                this.dispatchEvent(event);
                this.isLoading = false;
            });
    }

    handleViewAllSites() {
        this.showViewMore = !this.showViewMore;
        this.formulateData(this.resultDataFromApex, this.showViewMore);
    }

    handleSiteClick(event) {
        let link = event.currentTarget.dataset.redirectlink;
        if(link != undefined && link != null) {
            window.open(link, '_blank');
        }
    }

    // Method to process the received data to the required format
    formulateData(receivedData, showLimitedData) {
        console.log('Show Limited Data?:: ', JSON.stringify(showLimitedData));
        this.data = [];
        let processedData = [];
        receivedData.forEach(item => {
            let obj = {};
            obj.Id = item["siteId"];
            obj.titleName = item["siteName"];
            obj.titleIcon = this.successIcon;
            obj.titleStateIcon = this.blankAlarmIcon;
            obj.siteURL = (item["siteUrl"] != undefined && item["siteUrl"] != null) ? item["siteUrl"] : null;
            obj.noOfDevices = item["deviceCount"];
            obj.applicationList = [];
            if(item["apps"] != null && item["apps"] != undefined) {
                let appList = [];
                item["apps"].forEach(app => {
                    let appObj = {};
                    appObj.applicationId = app["appId"];
                    appObj.applicationName = app["appName"];
                    appObj.applicationStateIcon = app["appPerformanceStatus"] == 1 ? this.warningIcon : this.successIcon;
                    appList.push(appObj);

                    if(app["appPerformanceStatus"] == 1) {
                        obj.titleIcon = this.warningIcon;
                        obj.titleStateIcon = this.blueAlarmIcon;
                    }
                });
                obj.applicationList.push(...appList); // Max no.of Applications to display on tile: 50
            }

            if(item["apps"] != null && item["apps"] != undefined && item["apps"].length > 0) {
                obj.noOfApplications = `${obj.applicationList.length}`;
            } else {
                obj.noOfApplications = "0";
            }

            let totalAlarmCount = 0;
            if(item["alarm"] != null && item["alarm"] != undefined) {
                let alarmObj = { Critical: 0, Major: 0, Minor: 0, Warning: 0 };
                item["alarm"].forEach(alarm => {
                    alarmObj.Critical = alarm["severity"] == 'CRITICAL' ? alarmObj.Critical + alarm["count"] : alarmObj.Critical;
                    alarmObj.Major = alarm["severity"] == 'MAJOR' ? alarmObj.Major + alarm["count"] : alarmObj.Major;
                    alarmObj.Minor = alarm["severity"] == 'MINOR' ? alarmObj.Minor + alarm["count"] : alarmObj.Minor;
                    alarmObj.Warning = alarm["severity"] == 'WARNING' ? alarmObj.Warning + alarm["count"] : alarmObj.Warning;
                    totalAlarmCount = alarmObj.Critical + alarmObj.Major + alarmObj.Minor + alarmObj.Warning;
                });
                obj.alarmList = alarmObj;
            }

            obj.alarmCount = totalAlarmCount;
            obj.showAlarmCount = totalAlarmCount == 0 ? false : true;
            
            // add site data with contains device count (or) application count
            if(obj.noOfApplications != "0" || obj.noOfDevices != "0"){
                processedData.push(obj);
            }
            
        });

        if(showLimitedData) {
            this.data.push(...processedData.slice(0, 9)); // Max no.of Sites to display on page: 8
        } else {
            this.data.push(...processedData); // Max no.of Sites to display on page: all
        }

        if(this.data.length > 0 && this.data != null && this.data != undefined && this.data != []) {
            this.noData = false;
        } else {
            this.noData = true;
        }

        if(processedData.length > 6) { // Show link based on the limit of tiles. Max limit: 6
            this.showViewAllSites = true;
        } else {
            this.showViewAllSites = false;
        }

        console.log('Data:: ', JSON.stringify(this.data));
    }

    handleExploreMore() {
        window.open('https://cloud.iot.solenis.com/', '_blank');
    }
}
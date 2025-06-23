import { LightningElement, api } from 'lwc';
import getReport from '@salesforce/apex/CustomListViewInLwcCtrl.getReports';
import getDashboard from '@salesforce/apex/CustomListViewInLwcCtrl.getDashboard';

export default class ReportsForHexEval extends LightningElement {

    @api reports = [];
    @api dashboards = [];

    connectedCallback() {
        getReport()
            .then((data) => {
                this.reports = data;
                if (this.reports.length > 0) {
                    this.reports.forEach(item => item.redirectUrl = window.location.origin + '/hexeval/s/report/' + item.Id);
                }
            })
            .catch((error) => {
                console.log('Error ', error);
            });

        getDashboard()
            .then((data) => {
                this.dashboards = data;
            })
            .catch((error) => {
                console.log('Error ', error);
            });
    }

   handleClickDashboard(event) {
    const dashboardId = event.target.dataset.id;
    const dashboardTitle = this.dashboards.find(dashboard => dashboard.Id === dashboardId).Title;
    console.log('Clicked Dashboard Title:', dashboardTitle);
    if (dashboardTitle === 'HX CLEANINGS AND MECHANICAL COSTS v1') {
        window.open(window.location.origin + '/hexeval/s/dashboard1', '_blank');
    }
     if (dashboardTitle === 'HexEval Summary Dashboard (USC)') {
        window.open(window.location.origin + '/hexeval/s/dashboard2', '_blank');
    }
     if (dashboardTitle === 'HexEval Summary Dashboard (SI)') {
       window.open(window.location.origin + '/hexeval/s/dashboard3', '_blank');
    }
}
}
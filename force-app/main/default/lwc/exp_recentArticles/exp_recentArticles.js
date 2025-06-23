import { LightningElement, wire } from 'lwc';
import getRecentArticles from '@salesforce/apex/Exp_RecentArticles.getRecentArticles';
export default class Exp_recentArticles extends LightningElement {
    activeSectionMessage = '';
    articles;
    resources;
    @wire(getRecentArticles)
    wiredGetRecentArticles(result) {
        if (result.data) {
            if (result.data.isSuccess) {
                if (result.data.resources) {
                    //this.articles = result.data.articles;
                    this.resources = result.data.resources;
                }
            }
        }
    }

    handleToggleSection(event) {
        this.activeSectionMessage =
            'Open section name:  ' + event.detail.openSections;
    }

    /*get articles(){
        return [
            {title:'Solenis Opens Two New Centers of Excellence To Serve Growing Consumer Paper Packaging Market',content:''},
            {title:'Solenis To Acquire Paper Process Chemicals Business of KLK Kolb Group',content:''},
            {title:'Solenis Joins as New Partner in PulPac’s Expanding Dry Molded Fiber Network',content:''}
            ];
    }*/

    handleClick(event) {

    }
}
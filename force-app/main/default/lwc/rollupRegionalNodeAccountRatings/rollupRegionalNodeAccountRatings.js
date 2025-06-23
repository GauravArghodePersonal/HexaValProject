import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';//added
import { NavigationMixin } from 'lightning/navigation';
import getReportURL from '@salesforce/apex/RollUps_at_RegionalNodeLevel.getReportURL';
import CaminexDynamicPageRedirect from '@salesforce/label/c.CaminexDynamicPageRedirect';//added
import TargetPercent from '@salesforce/schema/Regional_Customer_Node__c.Target__c'//added
import BonusEarnedPoints from '@salesforce/schema/Regional_Customer_Node__c.Bonus_Extraordinary_Earned_Points__c'//added
import getAccountRatings from '@salesforce/apex/RollUps_at_RegionalNodeLevel.getAccountRatings';
import getStrengthandWeakness from '@salesforce/apex/RollUps_at_RegionalNodeLevel.getStrengthandWeakness';
import getConsRelatedToRegionalAcct from '@salesforce/apex/RollUps_at_RegionalNodeLevel.getConsRelatedToRegionalAcct';

export default class RollupRegionalNodeAccountRatings extends NavigationMixin(LightningElement) {
    @api recordId;
    @api recordTypeId;
    @track TargetPercent;//added
    @track BonusEarnedPoints;//added
    @track reportUrl;
    SFDCBaseUrl; //added
    CaminexDynamicPageRedirectUrl;

    isLoading = true; 
    accounts = [];
    // Account Ratings
    totalSituationalAssessmentRating = 0;
    totalActivityPerformanceRating = 0;
    totalKeyIndicatorRating = 0;
    totalOverviewRating = 0;
    totalMarketShareRating = 0;
    totalEarnedPointTotalSA = 0;
    totalMarketShareEarnedPoints = 0;
    totalPerceptionPointsEarned = 0;
    totalEarnedPointTotalAP = 0;
    totalEarnedPointTotalKI = 0;

    countSituationalAssessment = 0;
    countMarketShare = 0;
    countKeyIndicators = 0;
    countCompetitiveOverview = 0;
    countActivityPerformance = 0;

    totalMaxPointsSA = 0;
    totalMaxPointsAP = 0;
    totalMaxPointsKI = 0;
    totalMaxPointsOverview = 0;
    totalMaxPointsMarketShare = 0;

    totalVariancePointsSA = 0;
    totalVariancePointsAP = 0;
    totalVariancePointsKI = 0;
    totalVariancePointsOverview = 0;
    totalVariancePointsMarketShare = 0;

    // Strength and Weakness total
    totalStrengthWeaknessValue = 0;

    // Relationship summary
    totalRelationshipEarnedPoints = 0;
    totalRelationshipMaxPoints = 0;
    toatlRelationshipVariancepoints = 0;
    relationshipPenetrationIndex = 0;

    //Calculations for totals
    totalEarnedPoints = 0;
    totalMaxPoints = 0;
    totalRatings = 0;
    totalVariancePoints = 0;

    connectedCallback() {
        this.SFDCBaseUrl = window.location.origin;
        this.CaminexDynamicPageRedirectUrl = CaminexDynamicPageRedirect;
        getStrengthandWeakness({ regionalCustomerNodeId: this.recordId }).then((result) => { 
            this.totalStrengthWeaknessValue = 0;
            result.forEach(record => {
                console.log('the record'+ record);
                this.totalStrengthWeaknessValue += record.Strength_Weakness_Point_Value__c || 0;
                this.handleWireServiceResponse();
            });  
        }).catch((error) => {
            console.log('Error retrieving the strength and weakness');
            this.handleWireServiceResponse();
        });
        
        getConsRelatedToRegionalAcct({ regionalCustomerNodeId: this.recordId }).then((result) => { 
             console.log('the result'+ result);
            this.accounts = result;
            this.calculateTotalRelationshipPoints();
            this.calculateRelationshipPenetrationIndex();
            this.handleWireServiceResponse();
        }).catch((error) => {
            console.log('Error retrieving the contacts summary at regional node level');
            this.handleWireServiceResponse();
        });
    }

    @wire(getRecord, { recordId: '$recordId', fields: [TargetPercent,BonusEarnedPoints]})
    currentrecordInfo({error, data}) {
        if (data) {
            this.TargetPercent = data.fields.Target__c.value;
            this.BonusEarnedPoints = data.fields.Bonus_Extraordinary_Earned_Points__c.value;
        } else if (error) {
            this.error = error ;
        }
    }

    @wire(getAccountRatings, { regionalCustomerNodeId: '$recordId' })
    wiredAccountRatings({ error, data }) {
        if (data) {
            this.resetTotalsAndCounts();
            data.forEach(record => {
                this.updateCountsAndTotals(record);
            });
            this.calculateAverage();
            this.calculateMax();
            this.calculateVariance();
            this.calculateTotalRatings();
            this.handleWireServiceResponse();
        } else if (error) {
            console.error(error);
            this.handleWireServiceResponse();
        }
    }

    
    @wire(getReportURL, {  })
    wiredReportURL({ error, data }) {
        if (data) {
            this.reportUrl = data;
        } else if (error) {
            console.error('Error fetching report URL:', error);
        }
    }

    handleWireServiceResponse() {
        this.isLoading = false;
    }

    handleRefresh() {
        this.isLoading = true;
        window.location.reload();
        this.isLoading = false;
    }

    handleRefreshClick() {
        this.handleRefresh();
    }

    resetTotalsAndCounts() {
        const fieldsToReset = [
            'totalSituationalAssessmentRating', 'totalActivityPerformanceRating', 'totalKeyIndicatorRating',
            'totalOverviewRating', 'totalMarketShareRating', 'totalEarnedPointTotalSA', 'totalMarketShareEarnedPoints',
            'totalPerceptionPointsEarned', 'totalEarnedPointTotalAP', 'totalEarnedPointTotalKI', 'countSituationalAssessment',
            'countMarketShare', 'countKeyIndicators', 'countCompetitiveOverview', 'countActivityPerformance',
            'totalMaxPointsSA', 'totalMaxPointsAP', 'totalMaxPointsKI', 'totalMaxPointsOverview', 'totalMaxPointsMarketShare',
            'totalVariancePointsSA', 'totalVariancePointsAP', 'totalVariancePointsKI', 'totalVariancePointsOverview', 'totalVariancePointsMarketShare',
            'totalEarnedPoints', 'totalMaxPoints', 'totalRatings', 'totalVariancePoints'
        ];
        fieldsToReset.forEach(field => {
            this[field] = 0;
        });
    }

    updateCountsAndTotals(record) {
        const recordType = record.RecordType.Name;
        switch (recordType) {
            case 'Situational Assessment':
                this.countSituationalAssessment++;
                break;
            case 'Market Share by Site':
                this.countMarketShare++;
                break;
            case 'Key Indicators':
                this.countKeyIndicators++;
                break;
            case 'Competitive Overview':
                this.countCompetitiveOverview++;
                break;
            case 'Activity Performance':
                this.countActivityPerformance++;
                break;
            default:
                break;
        }

        this.totalSituationalAssessmentRating += record.Situational_Assessment_Total_Rating__c || 0;
        this.totalActivityPerformanceRating += record.Total_Activity_Performance_Rating__c || 0;
        this.totalKeyIndicatorRating += record.Key_Indicator_Rating__c || 0;
        this.totalOverviewRating += record.Overview_rating__c || 0;
        this.totalMarketShareRating += record.Market_share_rating_in__c || 0;
        this.totalEarnedPointTotalSA += record.Earned_Point_Total_SA_Section__c || 0;
        this.totalMarketShareEarnedPoints += record.Market_share_earned_points__c || 0;
        this.totalPerceptionPointsEarned += record.Perception_pts_earned__c || 0;
        this.totalEarnedPointTotalAP += record.Earned_Point_Total_AP_Section__c || 0;
        this.totalEarnedPointTotalKI += record.Earned_Point_Total_KI_Section__c || 0;
        // Calculate total earned points
        if(this.totalEarnedPointTotalSA && this.totalEarnedPointTotalAP && this.totalEarnedPointTotalKI && this.totalPerceptionPointsEarned && this.totalMarketShareEarnedPoints && this.totalRelationshipEarnedPoints && this.totalStrengthWeaknessValue && this.BonusEarnedPoints)
        this.totalEarnedPoints = this.totalEarnedPointTotalSA + this.totalEarnedPointTotalAP + this.totalEarnedPointTotalKI + this.totalPerceptionPointsEarned + this.totalMarketShareEarnedPoints + this.totalRelationshipEarnedPoints + this.totalStrengthWeaknessValue + this.BonusEarnedPoints; 
    }

    calculateAverage() {
        if(this.countSituationalAssessment !== 0){
            this.totalSituationalAssessmentRating /= this.countSituationalAssessment;
        }
        if(this.countActivityPerformance !== 0){
            this.totalActivityPerformanceRating /= this.countActivityPerformance;
        }
        if(this.countKeyIndicators !== 0){
            this.totalKeyIndicatorRating /= this.countKeyIndicators;
            }
        if(this.countCompetitiveOverview !== 0){
            this.totalOverviewRating /= this.countCompetitiveOverview;
        }
        if(this.countMarketShare !== 0){
            this.totalMarketShareRating /= this.countMarketShare;
        }
    }

    calculateMax() {
        if(this.totalSituationalAssessmentRating !== 0){
            this.totalMaxPointsSA += Math.round((100 / this.totalSituationalAssessmentRating) * this.totalEarnedPointTotalSA) || 0;
        }
        if(this.totalActivityPerformanceRating !== 0){
            this.totalMaxPointsAP += Math.round((100 / this.totalActivityPerformanceRating) * this.totalEarnedPointTotalAP) || 0;
        }
        if(this.totalKeyIndicatorRating !== 0){
            this.totalMaxPointsKI += Math.round((100 / this.totalKeyIndicatorRating) * this.totalEarnedPointTotalKI) || 0;
        }
        if(this.totalOverviewRating !== 0){
            this.totalMaxPointsOverview += Math.round((100 / this.totalOverviewRating) * this.totalPerceptionPointsEarned) || 0;
        }
        if(this.totalMarketShareRating !== 0){
            this.totalMaxPointsMarketShare += Math.round((100 / this.totalMarketShareRating) * this.totalMarketShareEarnedPoints) || 0;
        }
        //total max
        this.totalMaxPoints = this.totalMaxPointsSA + this.totalMaxPointsAP + this.totalMaxPointsKI + this.totalMaxPointsOverview + this.totalMaxPointsMarketShare + this.totalRelationshipMaxPoints;
    }

    calculateVariance() {
        this.totalVariancePointsSA += this.totalEarnedPointTotalSA - this.totalMaxPointsSA;
        this.totalVariancePointsAP += this.totalEarnedPointTotalAP - this.totalMaxPointsAP;
        this.totalVariancePointsKI += this.totalEarnedPointTotalKI - this.totalMaxPointsKI;
        this.totalVariancePointsOverview += this.totalPerceptionPointsEarned - this.totalMaxPointsOverview;
        this.totalVariancePointsMarketShare += this.totalMarketShareEarnedPoints - this.totalMaxPointsMarketShare;
        this.toatlRelationshipVariancepoints = this.totalRelationshipEarnedPoints - this.totalRelationshipMaxPoints;//added
        // Calculate total variance points
        this.totalVariancePoints = this.totalVariancePointsSA + this.totalVariancePointsAP + this.totalVariancePointsKI + this.totalVariancePointsOverview + this.totalVariancePointsMarketShare + this.toatlRelationshipVariancepoints;
    }

    calculateTotalRatings() {
        this.totalEarnedPoints = this.totalEarnedPointTotalSA + this.totalEarnedPointTotalAP + this.totalEarnedPointTotalKI + this.totalPerceptionPointsEarned + this.totalMarketShareEarnedPoints + this.totalRelationshipEarnedPoints + this.totalStrengthWeaknessValue + this.BonusEarnedPoints;
        this.totalMaxPoints = this.totalMaxPointsSA + this.totalMaxPointsAP + this.totalMaxPointsKI + this.totalMaxPointsOverview + this.totalMaxPointsMarketShare + this.totalRelationshipMaxPoints;
        this.totalVariancePoints = this.totalEarnedPoints - this.totalMaxPoints;
        if (this.totalMaxPoints !== 0) {
            this.totalRatings = (this.totalEarnedPoints / this.totalMaxPoints) * 100;
        } else {
            this.totalRatings = 0;
        }
    }

    calculateTotalRelationshipPoints() {
        this.totalRelationshipEarnedPoints = this.calculateRelationTotal(this.accounts, 'Alignment_points__c');
        this.totalRelationshipMaxPoints = this.calculateRelationTotal(this.accounts, 'Relationship_max_point__c');
        console.log('the this.totalRelationshipEarnedPoints '+  this.totalRelationshipEarnedPoints);
        console.log('the this.totalRelationshipMaxPoints '+  this.totalRelationshipMaxPoints);
    }

    calculateRelationTotal(data, fieldName) {
        return data.reduce((total, account) => {
            return total + (account?.Contacts?.reduce((conTotal, con) => {
                const value = parseFloat(con[fieldName]) || 0;
                return conTotal + value;
            }, 0) || 0);
        }, 0);
    }
    
    calculateRelationshipPenetrationIndex() {
        this.toatlRelationshipVariancepoints = this.totalRelationshipEarnedPoints - this.totalRelationshipMaxPoints;// new add
        console.log('the  this.toatlRelationshipVariancepoints '+   this.toatlRelationshipVariancepoints);
        if (this.totalRelationshipMaxPoints !== 0) {
            this.relationshipPenetrationIndex = (this.totalRelationshipEarnedPoints / this.totalRelationshipMaxPoints)*100;
            console.log('the this.relationshipPenetrationIndex '+  this.relationshipPenetrationIndex);
        } else {
            this.relationshipPenetrationIndex = 0;
            console.log('the this.relationshipPenetrationIndex else condition '+  this.relationshipPenetrationIndex);
        }
    }

    get totalSituationalAssessmentRatingStyle() {
        return this.getCellStyle(this.totalSituationalAssessmentRating);
    }

    get totalActivityPerformanceRatingStyle() {
        return this.getCellStyle(this.totalActivityPerformanceRating);
    }

     get totalMarketShareRatingStyle() {
        return this.getCellStyle(this.totalMarketShareRating);
    }

     get totalOverviewRatingStyle() {
        return this.getCellStyle(this.totalOverviewRating);
    }

     get totalKeyIndicatorRatingStyle() {
        return this.getCellStyle(this.totalKeyIndicatorRating);
    }

     get relationshipPenetrationIndexStyle() {
        return this.getCellStyle(this.relationshipPenetrationIndex);
    }

    get totalRatingsStyle() {
        return this.getCellStyle(this.totalRatings);
    }
 
    getCellStyle(percentage) {
        if (percentage > 55) {
            return 'background-color: green;'; 
        } else if (percentage >= 35) {
            return 'background-color: yellow;'; 
        } else {
            return 'background-color: red;'; 
        }
    }

    handleRowClick(event) {
        const cmpid = event.currentTarget.dataset.id;
        console.log('cmpid :: ',cmpid);
        //const url = this.SFDCBaseUrl+`/lightning/cmp/force__dynamicRelatedListViewAll?force__flexipageId=${this.CaminexDynamicPageRedirectUrl}&force__cmpId=${cmpid}&force__recordId=${this.recordId}&ws=%2Flightning%2Fr%2FRegional_Customer_Node__c%2F${this.recordId}%2Fview`;
        const url = this.SFDCBaseUrl+`${this.CaminexDynamicPageRedirectUrl}&force__cmpId=${cmpid}&force__recordId=${this.recordId}&ws=%2Flightning%2Fr%2FRegional_Customer_Node__c%2F${this.recordId}%2Fview`;
        console.log('url ::', url);
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: url,
            },
        });
    }

    handleRowClick1(event) {
        const repid = event.currentTarget.dataset.id;
        const url = repid +'/view?fv1=' + this.recordId;
       // const url = this.reportUrl + '/view?fv1=' + this.recordId;
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: url,
            },
        });
    }

    handleNavigate() {
        var compDefinition = {
            componentDef: "c:RollupRelationshipAtRegionalNode",
            attributes: {
                recordId: this.recordId
            }
        };
        // Base64 encode the compDefinition JS object
        var encodedCompDef = btoa(JSON.stringify(compDefinition));
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/one/one.app#' + encodedCompDef
            }
        });
    }
    
}
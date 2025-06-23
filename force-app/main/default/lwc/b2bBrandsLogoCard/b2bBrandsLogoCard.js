import { LightningElement, api, track } from 'lwc';
import communityId from '@salesforce/community/Id';
import communityPath from '@salesforce/community/basePath';
import getBrand from '@salesforce/apex/B2BBrandsLogo.getBrand';

export default class B2bBrandsLogoCard extends LightningElement {
    @api effectiveAccount;
    @api categoryId;
    @api categoryItem;

    @track categoryBannerUrl;
    @track categoryurl;
    @track categoryName;

    connectedCallback() {

        this.init();

    }
    init(){
        console.log('Community Path child+++++++++++ ', communityPath);
        this.homePath = communityPath +'/';
        console.log('categoryId child+++++++++++ ', this.categoryId);
        console.log('categoryItem child+++++++++++ ', this.categoryItem);
        console.log('effectiveAccountId+++++++ child' + this.effectiveAccount);
        console.log('communityId+++++++' + communityId);

        getBrand({"communityId": communityId,
                    "productCategoryId": this.categoryId,
                    "effectiveAccountId": this.effectiveAccount})
        .then(response => {
            console.log('response in child component+++++++' + response);
            //this.categoryBannerUrl = '/soleniseshop/s/sfsites/c'+response.bannerImage.url;
            this.categoryName = this.categoryItem.Name;
            if(response.bannerImage){
                console.log('Banner Image Exists++++++++++');
                this.categoryBannerUrl = communityPath +'/sfsites/c' + response.bannerImage.url;
            }
            this.categoryurl = this.homePath + 'category/brands/' + this.categoryItem.Name + '/' + this.categoryId;
            
            console.log('this.categoryBannerUrl+++++++++ ', this.categoryBannerUrl) ;
            console.log('this.categoryurl+++++++++ ', this.categoryurl) ;
        })
        .catch(error => {
            console.log('error+++++++++' , error);
           //this.showErrorToast(error);
        });
    }
}
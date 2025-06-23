import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import communityPath from '@salesforce/community/basePath';
import getSDSDocumenList from '@salesforce/apex/B2BProductDetailController.callWebServiceB2bSdsList';

import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id'; //to get the current logged in user Id
import NAME_FIELD from '@salesforce/schema/User.Name';

// A fixed entry for the home page.
const homePage = {
    name: 'Home',
    type: 'standard__namedPage',
    attributes: {
        pageName: 'home'
    }
};

/**
 * An organized display of product information.
 *
 * @fires ProductDetailsDisplay#addtocart
 * @fires ProductDetailsDisplay#createandaddtolist
 */
export default class ProductDetailsDisplay extends NavigationMixin(LightningElement) {
    @api recordId;
    @api accountname;
    //SDS
    @track sdsList;
    @track sdsnameList;
    @track sdsProductName;
    @track sdsMapKeyValue=[];
    @track sdsResult='';

    //BLOB
    @track blockResult;
    
    @track error;
    @track cuurentUserName = NAME_FIELD;

    //to get the current logged in user name
    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
           this.error = error ; 
        } else if (data) {
            this.cuurentUserName = data.fields.Name.value;
        }
    }
    @track url;
    value = 'CA';


    
    get options() {
        return [
            { label: 'CA', value: 'CA' },
            { label: 'EA', value: 'EA' }
        ];
    }

    /**
     * An event fired when the user indicates the product should be added to their cart.
     *
     * Properties:
     *   - Bubbles: false
     *   - Composed: false
     *   - Cancelable: false
     *
     * @event ProductDetailsDisplay#addtocart
     * @type {CustomEvent}
     *
     * @property {string} detail.quantity
     *  The number of items to add to cart.
     *
     * @export
     */

    /**
     * An event fired when the user indicates the product should be added to a new wishlist
     *
     * Properties:
     *   - Bubbles: false
     *   - Composed: false
     *   - Cancelable: false
     *
     * @event ProductDetailsDisplay#createandaddtolist
     * @type {CustomEvent}
     *
     * @export
     */

    /**
     * A product image.
     * @typedef {object} Image
     *
     * @property {string} url
     *  The URL of an image.
     *
     * @property {string} alternativeText
     *  The alternative display text of the image.
     */

    /**
     * A product category.
     * @typedef {object} Category
     *
     * @property {string} id
     *  The unique identifier of a category.
     *
     * @property {string} name
     *  The localized display name of a category.
     */

    /**
     * A product price.
     * @typedef {object} Price
     *
     * @property {string} negotiated
     *  The negotiated price of a product.
     *
     * @property {string} currency
     *  The ISO 4217 currency code of the price.
     */

    /**
     * A product field.
     * @typedef {object} CustomField
     *
     * @property {string} name
     *  The name of the custom field.
     *
     * @property {string} value
     *  The value of the custom field.
     */

    /**
     * An iterable Field for display.
     * @typedef {CustomField} IterableField
     *
     * @property {number} id
     *  A unique identifier for the field.
     */

    /**
     * Gets or sets which custom fields should be displayed (if supplied).
     *
     * @type {CustomField[]}
     */
    @api
    customFields;

    /**
     * Gets or sets whether the cart is locked
     *
     * @type {boolean}
     */
    @api
    cartLocked;

    /**
     * Gets or sets the name of the product.
     *
     * @type {string}
     */
    @api
    description;

    /**
     * Gets or sets the name of the product.
     *
     * @type {string}
     */
    @api
    uom;
    /**
     * Gets or sets the name of the product.
     *
     * @type {string}
     */
    @api
    productCode;

    /**
     * Gets or sets the product image.
     *
     * @type {Image}
     */
    @api
    image;

    /**
     * Gets or sets whether the product is "in stock."
     *
     * @type {boolean}
     */
    @api
    inStock = false;

    /**
     * Gets or sets the name of the product.
     *
     * @type {string}
     */
    @api
    name;

    /**
     * Gets or sets the price - if known - of the product.
     * If this property is specified as undefined, the price is shown as being unavailable.
     *
     * @type {Price}
     */
    @api
    price;

     /**
     * Gets or sets the oldMaterialNumber - if known - of the product.
     * If this property is specified as undefined, the price is shown as being unavailable.
     *
     * @type {oldMaterialNumber}
     */
    @api
    oldMaterialNumber;

    /**
     * Gets or sets teh stock keeping unit (or SKU) of the product.
     *
     * @type {string}
     */
    @api
    sku;

    _invalidQuantity = false;
    _quantityFieldValue = 1;
    _categoryPath;
    _resolvedCategoryPath = [];

    // A bit of coordination logic so that we can resolve product URLs after the component is connected to the DOM,
    // which the NavigationMixin implicitly requires to function properly.
    _resolveConnected;
    _connected = new Promise((resolve) => {
        this._resolveConnected = resolve;
    });

    connectedCallback() {
        console.log('INSIDE Price'+JSON.stringify(this.price));
             console.log('INSIDE Price'+this.price.negotiated);
                console.log('INSIDE URL'+this.image.url);
                console.log('Name'+this.name);
                console.log('sku====='+this.oldMaterialNumber);
               // this.name=decodeURI(this.name);
               //  console.log('Name2'+decodeURI(this.name));
        this._resolveConnected();
        this.getSDSDocumentlist();
    }

    disconnectedCallback() {
        this._connected = new Promise((resolve) => {
            this._resolveConnected = resolve;
        });
    }

    /**
     * Gets or sets the ordered hierarchy of categories to which the product belongs, ordered from least to most specific.
     *
     * @type {Category[]}
     */
    @api
    get categoryPath() {
        return this._categoryPath;
    }

    set categoryPath(newPath) {
        this._categoryPath = newPath;
        this.resolveCategoryPath(newPath || []);
    }

    get hasPrice() {
        console.log('MAIN'+((this.price || {}).negotiated || '').length);
        console.log('MAIN'+JSON.stringify(this.price));
//Code change for Price set from getprice method
        if(this.price!=null&&this.price!=undefined&&this.price.negotiated=='Price Not Available')
        {
            this.cartLocked=true;
return false;
        }
        console.log('cart lock-->'+((this.price || {}).negotiated || '').length > 0);
        return ((this.price || {}).negotiated || '').length > 0;
    }

    /**
     * Gets whether add to cart button should be displabled
     *
     * Add to cart button should be disabled if quantity is invalid,
     * if the cart is locked, or if the product is not in stock
     */
    get _isAddToCartDisabled() {
        return this._invalidQuantity || this.cartLocked || !this.inStock;
    }

    handleQuantityChange(event) {
        if (event.target.validity.valid && event.target.value) {
            this._invalidQuantity = false;
            this._quantityFieldValue = event.target.value;
        } else {
            this._invalidQuantity = true;
        }
    }

    /**
     * Emits a notification that the user wants to add the item to their cart.
     *
     * @fires ProductDetailsDisplay#addtocart
     * @private
     */
    notifyAddToCart() {
        let quantity = this._quantityFieldValue;
        this.dispatchEvent(
            new CustomEvent('addtocart', {
                detail: {
                    quantity
                }
            })
        );
    }

    /**
     * Emits a notification that the user wants to add the item to a new wishlist.
     *
     * @fires ProductDetailsDisplay#createandaddtolist
     * @private
     */
    notifyCreateAndAddToList() {
        this.dispatchEvent(new CustomEvent('createandaddtolist'));
    }

    /**
     * Updates the breadcrumb path for the product, resolving the categories to URLs for use as breadcrumbs.
     *
     * @param {Category[]} newPath
     *  The new category "path" for the product.
     */
    resolveCategoryPath(newPath) {
        const path = [homePage].concat(
            newPath.map((level) => ({
                name: level.name,
                type: 'standard__recordPage',
                attributes: {
                    actionName: 'view',
                    recordId: level.id
                }
            }))
        );

        this._connected
            .then(() => {
                const levelsResolved = path.map((level) =>
                    this[NavigationMixin.GenerateUrl]({
                        type: level.type,
                        attributes: level.attributes
                    }).then((url) => ({
                      
                        name: level.name,
                        url: url
                    }))
                );
                return Promise.all(levelsResolved);
            })
            .then((levels) => {
                //code to remove brands
                levels.splice(1, 1); 
                var pageNumber = 1;
var baseURL='';
if(levels.length>=1)
{
  baseURL = levels[0].url;
}
  var allproductsURL=baseURL+'/all-products'
                var url = window.location.href;
                // if(url.indexOf('?') != -1)
                if(url.indexOf('&') != -1)
                {
                   // pageNumber = url.split('?')[1].replace('pn=', '');
 pageNumber = url.split('&')[1].replace('pn=', '');
                    for(var i=0; i < levels.length; i++){
                        levels[i].url = levels[i].url  + '?pn='+pageNumber;
                    }
                }
                //get page Name
                var pageName='';
  if(url.indexOf('?') != -1&&url.indexOf('&') != -1)
                {
                   // pageNumber = url.split('?')[1].replace('pn=', '');
 pageName = url.substring(url.indexOf('?')+1,url.indexOf('&')); 
 pageName=pageName.replace('pname=', '');
 console.log('pageName-->'+pageName);
 //if Favorite make URL to Favorite
 if(pageName=='fav')
 {
      if( levels[1]!=undefined)
      {
        levels[1].name='Favorites';  
        levels[1].url=baseURL+ 'mylists?pn='+pageNumber;
      }

 }
 //if ALL make URL to Favorite
  if(pageName=='all')
 {
     if( levels[1]!=undefined)
      {
      levels[1].name='All Products';  
          levels[1].url=baseURL+ 'all-products?pn='+pageNumber;
      }
     
 }

                }


                this._resolvedCategoryPath = levels;
            });
    }

    /**
     * Gets the iterable fields.
     *
     * @returns {IterableField[]}
     *  The ordered sequence of fields for display.
     *
     * @private
     */
    get _displayableFields() {
        // Enhance the fields with a synthetic ID for iteration.
        return (this.customFields || []).map((field, index) => ({
            ...field,
            id: index
        }));
    }
    handleOnClickSDS(event)
    {
        console.log('INside Handle Onclick SDS1');
        console.log('Inside Record Click'+this.recordId);
        console.log('DOCKEY'+this.sdsMapKeyValue[event.target.dataset.item].DOCKEY);
        console.log(' GENVAR'+this.sdsMapKeyValue[event.target.dataset.item].GENVAR);
        console.log(' LANGU'+this.sdsMapKeyValue[event.target.dataset.item].LANGU);
        console.log(' MATNR'+this.sdsMapKeyValue[event.target.dataset.item].MATNR);
        console.log(' RECN_DH'+this.sdsMapKeyValue[event.target.dataset.item].RECN_DH);
        this.url='';
        this.url=communityPath+'/b2bViewPDF?DOCKEY='+this.sdsMapKeyValue[event.target.dataset.item].DOCKEY+'&GENVAR='+
        this.sdsMapKeyValue[event.target.dataset.item].GENVAR+'&LANGU='+
        this.sdsMapKeyValue[event.target.dataset.item].LANGU+'&MATNR='+
        this.sdsMapKeyValue[event.target.dataset.item].MATNR+'&RECN_DH='+
        this.sdsMapKeyValue[event.target.dataset.item].RECN_DH+'&recordID='+
        this.recordId;
        this.url=this.url.replace("/s/", "/");

        console.log('account Name==='+this.cuurentUserName);
        //Test Event For Google Analytics
        console.log('Event TEST=='+this.sku);
        let tempEvent = {
            "tempEvt": "SDS Document : "+this.oldMaterialNumber,
           //  "tempEvt": "Popular Product"+this.displayableProduct.name,
            "event_category": "SDS Document",
            "event_label": "Solenis_"+this.accountname+"_"+this.cuurentUserName
           //  +this.cuurentUserName
        }
        this.dispatchEvent( 
            new CustomEvent( 
                'PopularProductEvent', // Event Name
                {
                    detail: tempEvent,
                    bubbles: true,
                    composed: true,
                }
            )

        );
        //END OF EVENT

        window.open(this.url);
       //Call this method from your .html file
         /*  this[NavigationMixin.GenerateUrl]({
	    type: 'standard__webPage',
            attributes: {
                url: '/apex/b2bViewPDF?DOCKEY='+this.sdsMapKeyValue[event.target.dataset.item].DOCKEY+'&GENVAR='+
                this.sdsMapKeyValue[event.target.dataset.item].GENVAR+'&LANGU='+
                this.sdsMapKeyValue[event.target.dataset.item].LANGU+'&MATNR='+
                this.sdsMapKeyValue[event.target.dataset.item].MATNR+'&RECN_DH='+
                this.sdsMapKeyValue[event.target.dataset.item].RECN_DH+'&recordID='+
                this.recordId

            }
        }).then(vfURL => {
        window.open(vfURL);
        });*/
    }
 
    getSDSDocumentlist()
    {
        try{
            this.showdetailsLoading=true;
            this.sdsResult=false;
            this.sdsList ='';
            this.sdsnameList='';
            this.sdsMapKeyValue=[];
            this.showsdsflag=false;
            
            getSDSDocumenList({ recordId: this.recordId, PI_LANGUAGE:'E', PI_MATERIAL:this.productCode })
                    .then((result) => {
console.log('Inside result SDS BLOB'+JSON.stringify(result));
                if(result != null && result != undefined&& JSON.stringify(result)!='"Error"'){
console.log('i am in ');
                    this.sdsList = JSON.parse(result);
                    this.sdsnameList=this.sdsList.PT_DOC_KEYS;
                    console.log('i am in 1 '+this.sdsnameList);
                    if(this.sdsnameList)
                    {
                    this.sdsResult=true;
                    }
                      console.log('i am in test ');
                      if(this.sdsList.PT_DOC_KEYS!=null&&this.sdsList.PT_DOC_KEYS!=undefined)
                      {
                    for(let i=0; i<this.sdsList.PT_DOC_KEYS.length; i++){
                        this.sdsMapKeyValue[this.sdsList.PT_DOC_KEYS[i].DOCKEY]=this.sdsList.PT_DOC_KEYS[i];
                             console.log('i am in 3 '+this.sdsList.PT_DOC_KEYS[i]);
                    }
                      }
                      else
                      {
                              console.log('inside Master');
                      }
                    this.showdetailsLoading=false;
                } else {
                    console.log('Inside else');
                    this.sdsResult=false;
                    this.showdetailsLoading=false;
                }
            })
            .catch((error) => {
                console.log('INSIDE SDS Error');
                this.showdetailsLoading=false;
                this.error = error;
                this.showregistrationLoading=false;
                if(error && error.body && error.body.message){
                    console.log('error msg-', error.body.message);
                }
            });
        }
        catch(e)
        {
              console.log('INSIDE SDS Error1');
            this.showdetailsLoading=false;
        }
    }

  
}
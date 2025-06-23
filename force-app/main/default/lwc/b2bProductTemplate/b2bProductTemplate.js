import { LightningElement, wire, api } from 'lwc';

import communityId from '@salesforce/community/Id';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { resolve } from 'c/cmsResourceResolver';
import TreeViewResources from '@salesforce/resourceUrl/TreeViewResources';

export default class B2bProductTemplate extends LightningElement {
/**
 * Gets the effective account - if any - of the user viewing the product.
 *
 * @type {string}
 */
    @api
    get effectiveAccountId() {
        return this._effectiveAccountId;
    }

    /**
     * Sets the effective account - if any - of the user viewing the product
     * and fetches updated cart information
     */
    set effectiveAccountId(newId) {
        this._effectiveAccountId = newId;
    }

    /**
     * Gets or sets the unique identifier of a product.
     *
     * @type {string}
     */
    @api
    recordId;

    @api customDisplayFields;

    /**
     * The connectedCallback() lifecycle hook fires when a component is inserted into the DOM.
     */
    conectedCallback() {
        //alert(this.resolvedEffectiveAccountId);
    }

    /**
     * Gets the normalized effective account of the user.
     *
     * @type {string}
     * @readonly
     * @private
     */
    get resolvedEffectiveAccountId() {
        const effectiveAccountId = this.effectiveAccountId || '';
        let resolved = null;

        if (
            effectiveAccountId.length > 0 &&
            effectiveAccountId !== '000000000000000'
        ) {
            resolved = effectiveAccountId;
        }
        return resolved;
    }

    showProducts = true;
    sortValue = 'Name asc';
    applySort(event){
        this.sortValue = event.detail;
        this.showProducts = false;

        setTimeout(() => {
            this.showProducts = true;
        }, 1000);
    }

    searchValue = '';
    applySearch(event){
        this.searchValue = event.detail;
        this.showProducts = false;
       
        setTimeout(() => {
            this.showProducts = true;
        }, 1000);
    }
     //Method to pass the product result list to implemnent Google Analytics for search product
     handlesearchresultproduct(event){
        console.log('event.detail');
        console.log(event.detail);
        // let tempEvent = {
        //     "tempEvt": event.detail,
        //     "event_category": "Search",
        //     "event_label": "Solenis"
        // }
        console.log('tempEvent');
        // console.log(tempEvent);
        this.dispatchEvent( 
            new CustomEvent( 
                'PopularPageEvent', // Event Name
                {
                    detail: event.detail,
                    bubbles: true,
                    composed: true,
                }
            )

        );
    }

      //Method to pass the product result list to implemnent Google Analytics on load of all products
    //   handleallresultproducts(event){
    //     console.log('event.detail');
    //     console.log(event.detail);
    //     let tempEvent = {
    //         "tempEvt": event.detail,
    //         "event_category": "Popular Product",
    //         "event_label": "Solenis"
    //     }
    //     console.log('tempEvent');
    //     console.log(tempEvent);
    //     this.dispatchEvent( 
    //         new CustomEvent( 
    //             'PopularProductEvent', // Event Name
    //             {
    //                 detail: tempEvent,
    //                 bubbles: true,
    //                 composed: true,
    //             }
    //         )

    //     );
    // }
}
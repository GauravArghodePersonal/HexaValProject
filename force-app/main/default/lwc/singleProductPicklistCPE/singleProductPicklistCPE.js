import { LightningElement, track, api } from 'lwc';
import searchProducts from '@salesforce/apex/AdVic_ProductSearchController.searchProducts';
import getProductById from '@salesforce/apex/AdVic_ProductSearchController.getProductById';

export default class singleProductPicklistCPE extends LightningElement {
    @track searchResults;
    @track isLoading = false;
    searchTerm = '';
    @track selectedProductName = ''; // Added to keep track of the selected product's name
    @track _selectedProductId = ''; // Added to keep track of the selected product's ID

    @api
    set value(valueString) {
        this._selectedProductId = valueString ? valueString.trim() : '';
        this.fetchInitialProductName(valueString);
    }

    get value() {
        return this._selectedProductId;
    }

    get selectedValue() {
        return this.selectedProductName;
    }

    fetchInitialProductName(id) {
        getProductById({ productId: id })
            .then((product) => {
                if (product) {
                    this.selectedProductName = product.Name;
                }
            })
            .catch((error) => {
                console.error('Error fetching initial product:', error);
            });
    }

    handleSearchChange(event) {
        this.searchTerm = event.detail.value;
        if (this.searchTerm.length > 0) {
            this.debounceSearch();
        } else {
            this.clearSearchResults();
        }
    }

    debounceSearch() {
        window.clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
            this.isLoading = true;
            this.performSearch();
        }, 300); // 300 ms delay
    }

    performSearch() {
        searchProducts({ searchTerm: this.searchTerm })
            .then((result) => {
                this.searchResults = result.map(product => ({
                    label: product.Name,
                    value: product.Id
                }));
                this.isLoading = false;
            })
            .catch((error) => {
                this.isLoading = false;
                console.error('Error fetching products:', error);
            });
    }

    selectSearchResult(event) {
        const selectedId = event.currentTarget.dataset.value;
        const selectedProduct = this.searchResults.find(
            product => product.value === selectedId
        );

        this.value = selectedId; // Store the selected product ID
        this.selectedProductName = selectedProduct.label; // Store the selected product name for display

        this.dispatchEvent(new CustomEvent('valuechange', { detail: { value: this.value } }));
        this.clearSearchResults();
    }

    clearSearchResults() {
        this.searchResults = null;
        this.isLoading = false;
    }
}
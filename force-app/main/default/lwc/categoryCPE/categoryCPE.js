import { LightningElement, api, track } from 'lwc';
import getTopLevelCategories from '@salesforce/apex/AdVic_ProductCategoryController.getTopLevelCategories';
import getChildCategories from '@salesforce/apex/AdVic_ProductCategoryController.getChildCategories';
import getCategory from '@salesforce/apex/AdVic_ProductCategoryController.getCategory';
import getParentCategories from '@salesforce/apex/AdVic_ProductCategoryController.getParentCategories';

export default class CategoryCPE extends LightningElement {
    @track isLoading = true; // Add this property to track loading state

    @api
    get value() {
        return this._value;
    }

    set value(newValue) {
        if (newValue !== this._value) {
            this._value = newValue;
            this.initializeWithCategory(newValue);
        }
    }

    _value;

    @track categories = [];
    @track breadcrumbs = [{ label: 'Parent categories', value: null }];

    connectedCallback() {
        if (this.value) {
            this.initializeWithCategory(this.value);
        } else {
            this.loadInitialCategories();
        }
        this.isLoading = false; // Set isLoading to false to hide the spinner and show the component
    }    
    
    initializeWithCategory(categoryId) {
        this.loadChildCategories(categoryId);
        this.updateBreadcrumbsWithParents(categoryId);
    }

    updateBreadcrumbsWithParents(categoryId) {
        getParentCategories({ childId: categoryId })
            .then(parents => {
                this.breadcrumbs = [{ label: 'Parent categories', value: null }];
    
                // Create a new array from the parents array and reverse it
                [...parents].reverse().forEach(cat => {
                    this.breadcrumbs.push({ label: cat.Name, value: cat.Id });
                });
    
                getCategory({ categoryId })
                    .then(currentCategory => {
                        // Check if current category is already the last item in breadcrumbs
                        if (!this.breadcrumbs.some(b => b.value === currentCategory.Id)) {
                            this.breadcrumbs.push({ label: currentCategory.Name, value: currentCategory.Id });
                        }
                    })
                    .catch(error => {
                        console.error('Error fetching current category:', error);
                    });
            })
            .catch(error => {
                console.error('Error fetching parent categories:', error);
            });
    }        
    

    loadInitialCategories() {
        getTopLevelCategories()
            .then(result => {
                this.categories = result.map(cat => ({ label: cat.Name, value: cat.Id }));
            })
            .catch(error => {
                console.error(error);
            });
    }

    handleCategoryChange(event) {
        const selectedCategoryId = event.detail.value;
        this.value = selectedCategoryId;
        this.fireValueChangeEvent();
        this.loadChildCategories(selectedCategoryId);
        this.updateBreadcrumbsWithParents(selectedCategoryId); // Ensure this method is called
    }       

    loadChildCategories(parentId) {
        getChildCategories({ parentId })
            .then(result => {
                // Fetch the current category details
                getCategory({ categoryId: parentId })
                    .then(currentCategory => {
                        // Create an option for the current category
                        let currentCategoryOption = { label: currentCategory.Name, value: currentCategory.Id };
                        
                        if (result.length > 0) {
                            // If there are children, prepend the current category to them
                            this.categories = [currentCategoryOption, ...result.map(cat => ({ label: cat.Name, value: cat.Id }))];
                        } else {
                            // If no children, show only the current category
                            this.categories = [currentCategoryOption];
                        }
                    })
                    .catch(error => {
                        console.error('Error fetching current category:', error);
                    });
            })
            .catch(error => {
                console.error(error);
            });
    }     

    updateBreadcrumbs(categoryId) {
        getCategory({ categoryId })
            .then(result => {
                // Find index of the current category in breadcrumbs
                const index = this.breadcrumbs.findIndex(b => b.value === categoryId);
                if (index === -1) {
                    // If not found, add new breadcrumb
                    this.breadcrumbs = [...this.breadcrumbs, { label: result.Name, value: categoryId }];
                } else {
                    // If found, trim breadcrumbs up to the current category
                    this.breadcrumbs = this.breadcrumbs.slice(0, index + 1);
                }
            })
            .catch(error => {
                console.error(error);
            });
    }

    handleBreadcrumbClick(breadcrumbValue) {
        if (breadcrumbValue) {
            this.value = breadcrumbValue;
            this.fireValueChangeEvent(); // Add this line to fire the event
            this.loadChildCategories(breadcrumbValue);
            this.updateBreadcrumbs(breadcrumbValue);
        } else {
            this.resetToTopLevel();
        }
    }

    get processedBreadcrumbs() {
        return this.breadcrumbs.map((breadcrumb, index) => ({
            ...breadcrumb,
            cssClass: 'breadcrumb clickable',
            showSeparator: index < this.breadcrumbs.length - 1,
            onClick: () => this.handleBreadcrumbClick(breadcrumb.value)
        }));
    }

    resetToTopLevel() {
        this.value = null;
        this.loadInitialCategories();
        this.breadcrumbs = [{ label: 'Parent categories', value: null }];
    }

    fireValueChangeEvent() {
        this.dispatchEvent(new CustomEvent('valuechange', { detail: { value: this.value } }));
    }    
}
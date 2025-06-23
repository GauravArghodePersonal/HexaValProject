import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import loadImagesFromObject from '@salesforce/apex/ExpHomePageBannerHandler.imageforCarousel';

const image_hide = 'customanimate slds-hide';
const image_show = 'customanimate slds-show';
const dot_visible = 'dot active';
const dot_hidden = 'dot';
const timer_for_slider = 5000;

export default class ExpHomePageBanner extends NavigationMixin(
    LightningElement
) {
    timeSet;
    imagePosition = 1;
    recordTypeName = 'Carousel';
    imagevalue;
    active;
    test;
    @track imageSlider = [];
    @track positionStore = [];

    @wire(loadImagesFromObject, { recordTypeDeveloperName: '$recordTypeName' })
    wiredContacts({ data, error }) {
        if (data) {
            if (data.carousel) {

                for (var i = 0; i < data.carousel.length; i++) {
                    this.positionStore.push({
                        position: i + 1
                    });
                }

                for (var i = 0; i < data.carousel.length; i++) {
                    if (i === 0) {
                        this.imageSlider.push({
                            image: data.carousel[i].ImageCarousel,
                            visiblity: image_show,
                            dotCheck: dot_visible,
                            position: this.positionStore[i].position,
                            id: data.carousel[i].Id,
                            textOnImage: data.carousel[i].ImageLabel,
                            redirectUrl: data.carousel[i].ImageLink
                        });
                    } else {
                        this.imageSlider.push({
                            image: data.carousel[i].ImageCarousel,
                            visiblity: image_hide,
                            dotCheck: dot_hidden,
                            position: this.positionStore[i].position,
                            id: data.carousel[i].Id,
                            textOnImage: data.carousel[i].ImageLabel,
                            redirectUrl: data.carousel[i].ImageLink
                        });
                    }
                }
            }

        }
        else if (error) {
            console.log('error');
        }
    }


    connectedCallback() {
        this.timeSet = window.setInterval(() => {
            this.imagePositionHandler(this.imagePosition + 1)
        }, Number(timer_for_slider))
    }


    disconnectedCallback() {
        window.clearInterval(this.timeSet);
    }

    backArrowClick() {
        let imageSliderBackClick = this.imagePosition - 1;
        this.imagePositionHandler(imageSliderBackClick)
    }

    nextArrowClick() {
        let imageSliderNxtClick = this.imagePosition + 1;
        this.imagePositionHandler(imageSliderNxtClick)
    }

    imagePositionHandler(id) {
        if (id > this.imageSlider.length) {
            this.imagePosition = 1;
        } else if (id < 1) {
            this.imagePosition = this.imageSlider.length;
        } else {
            this.imagePosition = id;
        }

        this.imageSlider = this.imageSlider.map(item => {
            return this.imagePosition == item.position ? {
                ...item,
                visiblity: image_show,
                dotCheck: dot_visible
            } : {
                ...item,
                visiblity: image_hide,
                dotCheck: dot_hidden
            }
        })

    }

    handleNavigate(event) {
        let dotPositionHolder = Number(event.currentTarget.dataset.id);
        let dotPositionindex = dotPositionHolder - 1;
        let urlToRedirect = this.imageSlider[dotPositionindex].redirectUrl;
       
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: urlToRedirect
            },
        });
    }

    dotHandler(event) {
        let dotPosition = Number(event.target.dataset.id);
        this.imagePositionHandler(dotPosition);
    }

}
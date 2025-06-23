import siteId from '@salesforce/site/Id';
import { LightningElement, api, track } from 'lwc';
import basePath from '@salesforce/community/basePath';
import LIGHTNING_ICONS from '@salesforce/resourceUrl/SalesforceLightningIcons';
import { NavigationMixin } from 'lightning/navigation';

export default class HeroCarousel extends NavigationMixin(LightningElement) {

    @api channelId;

    @api collectionId;

    @api contentId1;
    @api contentId2;
    @api contentId3;
    @api contentId4;
    @api contentId5;
    @api contentId6;
    @api contentId7;

    @api text1 = 'Placeholder Text 1';
    @api text2 = 'Placeholder Text 2';
    @api text3 = 'Placeholder Text 3';
    @api text4 = 'Placeholder Text 4';
    @api text5 = 'Placeholder Text 5';
    @api text6 = 'Placeholder Text 6';
    @api text7 = 'Placeholder Text 7';

    @api richText1;

    @api subText2 = 'Placeholder subText 1';
    @api subText1 = 'Placeholder subText 2';
    @api subText3 = 'Placeholder subText 3';
    @api subText4 = 'Placeholder subText 4';
    @api subText5 = 'Placeholder subText 5';
    @api subText6 = 'Placeholder subText 6';
    @api subText7 = 'Placeholder subText 7';

    @api buttonText1 = 'Default Button Text 1';
    @api buttonText2 = 'Default Button Text 2';
    @api buttonText3 = 'Default Button Text 3';
    @api buttonText4 = 'Default Button Text 4';
    @api buttonText5 = 'Default Button Text 5';
    @api buttonText6 = 'Default Button Text 6';
    @api buttonText7 = 'Default Button Text 7';

    @api buttonLink1 = 'Home';
    @api buttonLink2 = 'Home';
    @api buttonLink3 = 'Home';
    @api buttonLink4 = 'Home';
    @api buttonLink5 = 'Home';
    @api buttonLink6 = 'Home';
    @api buttonLink7 = 'Home';

    @api switchInterval = 10000;

    @track carouselImages = [];
    @track currentIndex = 0;

    leftButton = LIGHTNING_ICONS + '/utility-sprite/svg/symbols.svg#chevronleft';
    rightButton = LIGHTNING_ICONS + '/utility-sprite/svg/symbols.svg#chevronright';
    @track pauseButton = LIGHTNING_ICONS + '/utility-sprite/svg/symbols.svg#pause';
    playButton = LIGHTNING_ICONS + '/utility-sprite/svg/symbols.svg#play';

    timerId;

    get currentImage() {
        return this.carouselImages[this.currentIndex] || {};
    }

    connectedCallback() {
        this.contentKeys.forEach((contentId, index) => {    
            const imageUrl = `${basePath}/sfsites/c/cms/delivery/media/${contentId}`;
            console.log('IMAGE URL 1: ' + imageUrl);
            this.carouselImages.push({
                src: imageUrl,
                header: this[`text${index + 1}`],
                buttonText: this[`buttonText${index + 1}`],
                buttonLink: this[`buttonLink${index + 1}`],
                alternativeText: `Image ${index + 1}`,
                href: 'javascript:void(0);',
                style: `background-image: url(${imageUrl})`
            });
        });
        this.startImageRotation();
    }

    get contentKeys() {
        return [this.contentId1, this.contentId2, this.contentId3, this.contentId4, this.contentId5, this.contentId6, this.contentId7].filter(key => key); // ensuring that we only include defined keys
    }

    navigateToLink(event) {
        const link = event.currentTarget.dataset.link;
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: link
            }
        });
    }

    onLeft() {
        if (this.currentIndex === 0) {
            this.currentIndex = this.carouselImages.length - 1;
        } else {
            this.currentIndex -= 1;
        }
        this.updateCurrentSlide();
    }
    
    onRight() {
        if (this.currentIndex === this.carouselImages.length - 1) {
            this.currentIndex = 0;
        } else {
            this.currentIndex += 1;
        }
        this.updateCurrentSlide();
    }
    
    onPause() {
        if (this.timerId) {
            clearInterval(this.timerId); // clear the timer
            this.timerId = null;
            this.pauseButton = this.playButton; // Switch to play icon
        } else {
            this.startImageRotation();
            this.pauseButton = LIGHTNING_ICONS + '/utility-sprite/svg/symbols.svg#pause'; // Switch back to pause icon
        }
    }        
    
    startImageRotation() {
        if (this.timerId) {
            clearInterval(this.timerId);
        }
        
        this.timerId = setInterval(() => {
            if (this.currentIndex === this.carouselImages.length - 1) {
                this.currentIndex = 0;
            } else {
                this.currentIndex += 1;
            }
            this.updateCurrentSlide();
        }, this.switchInterval);
    }
    
    updateCurrentSlide() {
        this.carouselImages.forEach((_, index) => {
            const slideElem = this.template.querySelector(`[data-key="${index}"]`);
            slideElem.style.opacity = index === this.currentIndex ? 1 : 0;
        });
    }
}
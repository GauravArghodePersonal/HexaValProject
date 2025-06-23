import { LightningElement, api, track } from 'lwc';
import basePath from '@salesforce/community/basePath';
import LIGHTNING_ICONS from '@salesforce/resourceUrl/SalesforceLightningIcons';
import { NavigationMixin } from 'lightning/navigation';
import FORM_FACTOR from '@salesforce/client/formFactor';

export default class HeroCarousel extends NavigationMixin(LightningElement) {
    @api componentHeight;

    @api contentId1;
    @api contentId2;
    @api contentId3;
    @api contentId4;
    @api contentId5;
    @api contentId6;
    @api contentId7;

    @api text1;
    @api text2;
    @api text3;
    @api text4;
    @api text5;
    @api text6;
    @api text7;

    @api subText1;
    @api subText2;
    @api subText3;
    @api subText4;
    @api subText5;
    @api subText6;
    @api subText7;

    @api color1;
    @api color2;
    @api color3;
    @api color4;
    @api color5;
    @api color6;
    @api color7;

    @api shadow1;
    @api shadow2;
    @api shadow3;
    @api shadow4;
    @api shadow5;
    @api shadow6;
    @api shadow7;

    @api textAlign1;
    @api textAlign2;
    @api textAlign3;
    @api textAlign4;
    @api textAlign5;
    @api textAlign6;
    @api textAlign7;

    @api h1Style1;
    @api h1Style2;
    @api h1Style3;
    @api h1Style4;
    @api h1Style5;
    @api h1Style6;
    @api h1Style7;

    @api h2Style1;
    @api h2Style2;
    @api h2Style3;
    @api h2Style4;
    @api h2Style5;
    @api h2Style6;
    @api h2Style7;

    @api buttonText1;
    @api buttonText2;
    @api buttonText3;
    @api buttonText4;
    @api buttonText5;
    @api buttonText6;
    @api buttonText7;

    @api buttonStyle1;
    @api buttonStyle2;
    @api buttonStyle3;
    @api buttonStyle4;
    @api buttonStyle5;
    @api buttonStyle6;
    @api buttonStyle7;

    @api contentAlign1;
    @api contentAlign2;
    @api contentAlign3;
    @api contentAlign4;
    @api contentAlign5;
    @api contentAlign6;
    @api contentAlign7;

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

    @track pauseButton = LIGHTNING_ICONS + '/utility-sprite/svg/symbols.svg#pause';
    leftButton = LIGHTNING_ICONS + '/utility-sprite/svg/symbols.svg#chevronleft';
    rightButton = LIGHTNING_ICONS + '/utility-sprite/svg/symbols.svg#chevronright';
    playButton = LIGHTNING_ICONS + '/utility-sprite/svg/symbols.svg#play';

    touchStartX = 0;
    touchEndX = 0;

    timerId;

    get hideBecauseMobile(){
        if(FORM_FACTOR == 'Small'){
            return true;
        }
        return false;
    }

    get componentHeightStyle(){
        return 'height: ' + this.componentHeight + 'px;';
    }

    get currentImage() {
        return this.carouselImages[this.currentIndex] || {};
    }

    get hasCurrentButtonText() {
        const currentImage = this.carouselImages[this.currentIndex];
        return !!currentImage && !!currentImage.buttonText && !!currentImage.buttonText.trim();
    }    

    connectedCallback() {
        if(!this.hideBecauseMobile){
            this.contentKeys.forEach((contentId, index) => {    
                const imageUrl = `${basePath}/sfsites/c/cms/delivery/media/${contentId}`;

                // Construct textStyle based on color and shadow properties
                let textStyleValue = '';

                if (this[`shadow${index + 1}`]) {
                    textStyleValue += 'text-shadow: 1px 1px 5px rgba(0, 0, 0, 0.5);';
                }

                textStyleValue += ' color:' + this[`color${index+1}`];

                let contentPosValue = this.contentPosition(this[`contentAlign${index + 1}`]);

                this.carouselImages.push({
                    src: imageUrl,
                    header: this[`text${index + 1}`],
                    subheader: this[`subText${index + 1}`],
                    buttonText: this[`buttonText${index + 1}`],
                    buttonLink: this[`buttonLink${index + 1}`],
                    alternativeText: `Image ${index + 1}`,
                    href: 'javascript:void(0);',
                    style: `background-image: url(${imageUrl})`,
                    divPosition: contentPosValue,
                    textAlign: 'text-align: ' + this[`textAlign${index + 1}`] + ';',
                    h1Style: this[`h1Style${index + 1}`] + textStyleValue,
                    h2Style: this[`h2Style${index + 1}`] + textStyleValue,
                    buttonStyle: this[`buttonStyle${index + 1}`],
                });
            });
            this.startImageRotation();
        }
    }

    contentPosition(pos){
        if(pos == 'top-left'){
            return 'align-items: flex-start; justify-content: flex-start;';
        }
        if(pos == 'top-center'){
            return 'align-items: center; justify-content: flex-start;';
        }
        if(pos == "top-right"){
            return 'align-items: flex-end; justify-content: flex-start;';
        }
        if(pos == 'center-left'){
            return 'align-items: flex-start; justify-content: center;';
        }
        if(pos == 'center-center'){
            return 'align-items: center; justify-content: center;';
        }
        if(pos == "center-right"){
            return 'align-items: flex-end; justify-content: center;';
        }
        if(pos == 'bottom-left'){
            return 'align-items: flex-start; justify-content: flex-end;';
        }
        if(pos == 'bottom-center'){
            return 'align-items: center; justify-content: flex-end;';
        }
        if(pos == "bottom-right"){
            return 'align-items: flex-end; justify-content: flex-end;';
        }
    }

    get contentKeys() {
        return [this.contentId1, this.contentId2, this.contentId3, this.contentId4, this.contentId5, this.contentId6, this.contentId7].filter(key => key); // ensuring that we only include defined keys
    }

    navigateToLink(event) {
        const link = event.currentTarget.dataset.link;

        // Check if the link is a standard URL
        if (/^(http|https|www\.)/.test(link)) {
            // Open standard URL
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: link
                }
            });
        }

        else {
            // Use Salesforce navigation for named pages
            this[NavigationMixin.Navigate]({
                type: 'comm__namedPage',
                attributes: {
                    name: link
                }
            });
        }
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
            if(slideElem) {
                slideElem.style.opacity = index === this.currentIndex ? 1 : 0;
            }
        });
    }

    handleSwipeStart(event) {
        this.touchStartX = event.touches[0].clientX;
    }
    
    handleSwipeEnd(event) {
        this.touchEndX = event.changedTouches[0].clientX;
        if (this.touchStartX - this.touchEndX > 75) {
            this.onRight();
        }
        if (this.touchStartX - this.touchEndX < -75) {
            this.onLeft();
        }
    }
    
}
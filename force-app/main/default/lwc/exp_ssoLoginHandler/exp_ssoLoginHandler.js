import { LightningElement, wire } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
export default class Exp_ssoLoginHandler extends NavigationMixin(LightningElement) {
    parameters = {};

    ErrorCode = null;
    ErrorDescription = null;
    startURL = null;

    showSuccess = false;

    resultLoaded = false;

    iframelocation = 'about:blank';

    connectedCallback() {
        document.title = "Solenis Registration";
        this.parameters = this.getQueryParameters();
        console.log(this.parameters);
        if(this.parameters){
            if(this.parameters.ErrorDescription){
                if(this.parameters.ErrorDescription.includes('Please wait for approval')){
                    this.showSuccess = true;
                    this.resultLoaded = true;
                    /*const config = {
                        type: 'standard__webPage',
                        attributes: {
                            url: 'https://cloud.qa.solenis.com/SolenisExperienceCloud/s/new-user-registration'
                        }
                    };
                    this[NavigationMixin.Navigate](config);*/
                    //document.cookie.split(";").forEach(function(c) { document.cookie = c.replace(/^ +/, "").replace(/=.*/, "=;expires=" + new Date().toUTCString() + ";path=/"); });
                    //window.location.reload(true);
                    //caches.keys().then((keyList) => Promise.all(keyList.map((key) => caches.delete(key))))

                    /*********************/
                    /*this.iframelocation = "https://cloud.qa.solenis.com/SolenisExperienceCloud/services/auth/sso/MyAzure";
                    if (!location.hash) {
                        location.hash = "#reloading";
                        location.reload(true);
                    } 
                    else {
                        location.hash = "#reloaded";
                    }*/
                    //
                    /*async() =>{
                        await fetch("/path/cache", {
                            headers: { "Forced-Revalidate": 1 },
                            credentials: "include"
                        });
                        //
                        await fetch('/path/cache', {Cache: 'reload', credentials: 'include'});
                        //
                        await fetch('/path/cache', {method:'POST'});
                    }*/
                    
                    
                }
                else if(this.parameters.ErrorCode && 
                this.parameters.ErrorCode=='Remote_Error' && (
                this.parameters.ErrorDescription=='server_error' ||  this.parameters.ErrorDescription=='access_denied')
                ){
                    /*const config = {
                        type: 'standard__webPage',
                        attributes: {
                            url: 'https://cloud.qa.solenis.com/SolenisExperienceCloud/services/auth/sso/MyAzure'
                        }
                    };
                    this[NavigationMixin.Navigate](config,true);*/
                    if(this.parameters.ErrorDescription=='server_error'){
                        window.location.replace("https://"+window.location.host+"/SolenisExperienceCloud/services/auth/sso/MyAzure");
                    }
                    else{
                        window.location.replace("https://"+window.location.host+"/SolenisExperienceCloud/");
                    }
                    setTimeout(() => {
                        this.resultLoaded = true;
                      }, 5000);
                }
                else{
                    this.resultLoaded = true;
                }
                //////////////////////////////////////
            }
        }
    }


    getQueryParameters() {

        var params = {};
        var search = location.search.substring(1);

        if (search) {
            params = JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g, '":"') + '"}', (key, value) => {
                return key === "" ? value : decodeURIComponent(value)
            });
        }

        return params;
    }

    /*currentPageReference = null; 
    urlStateParameters = null;
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.urlStateParameters = currentPageReference.state;
          this.setParametersBasedOnUrl();
       }
    }

    setParametersBasedOnUrl() {
       this.ErrorCode = this.urlStateParameters.ErrorCode || null;
       this.ErrorDescription = this.urlStateParameters.ErrorDescription || null;
       this.startUrl = this.urlStateParameters.startUrl || '10';
    }*/
}
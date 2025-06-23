public with sharing class CF_VisualforceDomainController {

    public String getVisualforceDomainURL() {
        URL requestURL = URL.getCurrentRequestUrl();
        return requestURL.toExternalForm().substringBefore( requestURL.getPath() );
    }

    public String getOrgDomainURL() {
        return URL.getOrgDomainUrl().toExternalForm();
    }

}
public class CustomComponentController {

    public String linkLabel {get; set;}
    public String linkParam {get; set;}
    
    public String serverURL {
        get {return System.URL.getSalesforceBaseUrl().toExternalForm();}
    }

    public String linkURL {
        get {return serverURL + '/' + linkParam;}
    }
    
}
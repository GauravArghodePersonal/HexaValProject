public with sharing class VIAdwizardFunctions {
	
    private static final String CONTENT_TYPE = 'text/xml; charset=utf-8';

	private static final String URI_SOAPENV = 'http://schemas.xmlsoap.org/soap/envelope/';
    private static final String URI_XSD = 'http://www.w3.org/2001/XMLSchema';
    private static final String URI_XSI = 'http://www.w3.org/2001/XMLSchema-instance';
    private static final String URI_DEFNS = 'address.webservices.ams.saepio.com';

    private static final String UPD_ADDRESS_ENDPOINT = 'http://valvolineadwizard.saepio.com/ams-manager/services/AddressPortType';
    private static final String UPD_ADDRESS_ACTION = 'http://www.saepio.com/ams/services/Address/updateAddresses';
    
    private enum SendAddressStatus {FAILURE, SUCCESS, USER_NOT_FOUND}

    public static void sendAddressesToAdwizard(List<Account> locations, User u, String loginUrl) {
        //u.Username = 'test@test.test'; // to test user not found error msg
        SendAddressStatus sendStatus;
        String addresses = getAddressesXml(locations, u);
        sendStatus = sendAddressesToAdwizard(addresses, u);
        if (sendStatus == SendAddressStatus.USER_NOT_FOUND) {
        	Integer statCode = loginToAdwizard(loginUrl);
        	if (statCode == 200) {
        		sendStatus = sendAddressesToAdwizard(addresses, u);
        	}
        }
    }
    
    public static Integer loginToAdwizard(String loginUrl) {
    	Integer statCode = 0; HttpRequest req = new HttpRequest();
        req.setEndpoint(loginUrl); req.setMethod('GET');
        Http h = new Http(); HttpResponse res = h.send(req);
        statCode = res.getStatusCode();
        String s = statCode + ' : ' + res.getStatus();
        if (statCode == 302) {
            String ep = res.getHeader('Location');
            req.setEndpoint(ep); res = h.send(req);
            statCode = res.getStatusCode();
            s = statCode + ' : ' + res.getStatus();
        }
        return statCode;
    }

    private static SendAddressStatus sendAddressesToAdwizard(String addresses, User u) {
        String userNotFoundMsg = 'User ' + u.Username + ' doesn\'t exist in our system';
        HttpRequest req = getHttpRequest(UPD_ADDRESS_ENDPOINT, UPD_ADDRESS_ACTION, addresses);
        Http h = new Http();
        HttpResponse res = h.send(req);
        String s = res.getStatusCode() + ' : ' + res.getStatus();
        List<String> errMsgs;
        if (res.getStatusCode() != 200) {
            s = 'Error sending addresses to Adwizard : ' + s;
            errMsgs = new List<String>{s};
            return SendAddressStatus.FAILURE;
        }
        Dom.Document doc = res.getBodyDocument();
        errMsgs = parseResponseDoc(doc, u, userNotFoundMsg);
        if (!errMsgs.isEmpty()) {
        	if (userNotFoundMsg.equalsIgnoreCase(errMsgs[0])) {
        		return SendAddressStatus.USER_NOT_FOUND;
        	}
            CustomException.throwException(errMsgs);
        }
        return SendAddressStatus.SUCCESS;
    }
    
    private static HttpRequest getHttpRequest(String endPoint, String soapAction, String body) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', CONTENT_TYPE);
        req.setHeader('SOAPAction', soapAction);
        req.setBody(body);
        return req;
    }
    
    private static String getAddressesXml(List<Account> locations, User u) {
    	XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument('UTF-8', '1.0');
	        w.writeStartElement('soapenv', 'Envelope', URI_SOAPENV);
		        w.writeNamespace('soapenv', URI_SOAPENV);
		        w.writeNamespace('xsd', URI_XSD);
		        w.writeNamespace('xsi', URI_XSI);
		        w.writeStartElement('soapenv', 'Body', URI_SOAPENV);
			        w.writeStartElement(null, 'updateAddressesInputType', null);
			            w.writeDefaultNamespace(URI_DEFNS);
                        writeElement(w, 'username', u.Username);
				        w.writeStartElement(null, 'addresses', null);
					    	for (Account a : locations) {
					    		writeAddress(a, u, w);
					    	}
				        w.writeEndElement();
			        w.writeEndElement();
		        w.writeEndElement();
	        w.writeEndElement();
        w.writeEndDocument();
        String xmlString = w.getXmlString();
        w.close();
    	return xmlString;
    }
    
    private static void writeAddress(Account a, User u, XmlStreamWriter w) {
    	if (a.BillingCountry == null) {a.BillingCountry = 'US';}
    	
    	w.writeStartElement(null, 'address', null);

	        writeElement(w, 'externalAddressID', a.Id);
	        writeElement(w, 'firstName', u.FirstName);
	        writeElement(w, 'lastName', u.LastName);
	        writeElement(w, 'phoneNumber', a.Phone);
	        writeElement(w, 'company', a.BillingCity+' ('+a.BillingStreet+')');
	        writeElement(w, 'street1', a.BillingStreet);
	        writeElement(w, 'street2', null);
	        writeElement(w, 'city', a.BillingCity);
	        writeElement(w, 'stateProvince', a.BillingState);
	        writeElement(w, 'zipPostalCode', a.BillingPostalCode);
	        writeElement(w, 'country', a.BillingCountry);
	        writeElement(w, 'externalAddressDefault', 'true');
	        writeElement(w, 'defaultBilling', 'false');
	        writeElement(w, 'defaultShipping', 'false');
	
            w.writeStartElement(null, 'attributes', null);
	        
                w.writeStartElement(null, 'attribute', null);
			        writeElement(w, 'name', 'Store No.');
			        writeElement(w, 'value', a.BillingStreet);
		        w.writeEndElement();
		
                w.writeStartElement(null, 'attribute', null);
			        writeElement(w, 'name', 'Store Name');
			        writeElement(w, 'value', a.Name);
		        w.writeEndElement();
	
	        w.writeEndElement();

        w.writeEndElement();

    }
    
    private static void writeElement(XmlStreamWriter w, String ename, String s) {
        w.writeStartElement(null, ename, null);
        if (s != null) {w.writeCharacters(s);}
        w.writeEndElement();
    }
    
    public static void readXml(String xml) {
        XmlStreamReader r = new XmlStreamReader(xml);
        String lname;
        while (r.hasNext()) {
            XmlTag t = r.getEventType();
            System.debug(t);
            if (r.isStartElement()) {
                lname = r.getLocalName();
                System.debug(lname);
            }
            if (r.isCharacters() && r.hasText()) {
                String s = r.getText();
                System.debug(s);
            }
            r.next();
        }
    }
    
    public static List<String> parseResponseDoc(Dom.Document doc, User u, String userNotFoundMsg) {
    	List<String> errMsgs = new List<String>();
    	Dom.Xmlnode node = doc.getRootElement();
    	node = getChildElement(node, 'Body');
        node = getChildElement(node, 'updateAddressesOutputType');
        List<Dom.Xmlnode> nodes = node.getChildElements();
        String msg;
        for (Dom.Xmlnode n : nodes) {
            node = getChildElement(n, 'message');
            msg = node.getText();
            System.debug(msg);
            if (userNotFoundMsg.equalsIgnoreCase(msg)) {
                errMsgs.add(userNotFoundMsg);
            	break;
            }
        }
        return errMsgs;
    }
    
    private static Dom.Xmlnode getChildElement(Dom.Xmlnode n, String s) {
    	if (n != null) {
    		List<Dom.Xmlnode> ns = n.getChildElements();
    		if (ns != null && !ns.isEmpty()) { 
                for (Dom.Xmlnode node : ns) {
                	System.debug(n.getName()+ ':' + node.getName());
                	if (node.getName().equalsIgnoreCase(s)) {
                		return node;
                	}
                }
    		}
    	}
    	return null;
    }
}
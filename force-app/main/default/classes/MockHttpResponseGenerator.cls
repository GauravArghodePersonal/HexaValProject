@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
        global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"animals": ["majestic badger", "fluffy bunny", "scary bear", "chicken", "mighty moose"]}');
        response.setStatusCode(201);
        return response; 
    }
}
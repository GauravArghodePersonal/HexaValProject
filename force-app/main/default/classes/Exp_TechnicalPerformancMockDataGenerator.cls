/**
 * @description Generates mock response for a IoT Cumulocity API Callouts
 */
@isTest
global class Exp_TechnicalPerformancMockDataGenerator  implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        String mockResponse = '[ { '
                            + '"siteId" : 123, '
                            + '"siteName" : "Site 1", '
                            + '"deviceCount" : 12, '
                            + '"siteUrl" : "http://cloud.iot.solenis/groupObject/123", '
                            + '"alarm" : [ { '
                            + '  "severity" : "CRITICAL", '
                            + '  "count" : 1'
                            + '}, { '
                            + '  "severity" : "MAJOR", '
                            + '  "count" : 0'
                            + '}, { '
                            + '  "severity" : "MINOR", '
                            + '  "count" : 1'
                            + '}, { '
                            + '  "severity" : "WARNING", '
                            + '  "count" : 0'
                            + '} ], '
                            + '"apps" : [ { '
                            + '  "appId" : 127890, '
                            + '  "appName" : "Tank 1", '
                            + '  "appPerformanceStatus" : 1 '
                            + '}, { '
                            + '  "appId" : 127891, '
                            + '  "appName" : "Tank 2", '
                            + '  "appPerformanceStatus" : 1 '
                            + '}, { '
                            + '  "appId" : 127892, '
                            + '  "appName" : "Cooling tower", '
                            + ' "appPerformanceStatus" : -1, '
                            + ' "appPerformanceErrorMessage" : "Weighted average is not defined" '
                            + '} ] '
                            + '}] ';
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(mockResponse);
        res.setStatusCode(200);
        return res;
    }
}
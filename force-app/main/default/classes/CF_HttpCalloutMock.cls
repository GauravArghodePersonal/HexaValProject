public with sharing class CF_HttpCalloutMock implements HttpCalloutMock {

    public HttpResponse respond( HttpRequest req ) {

        HttpResponse res = new HttpResponse();

        String endpoint = req.getEndpoint();

        if ( endpoint.containsIgnoreCase( 'ERROR' ) ) {

            res.setStatus( 'Error' );
            res.setStatusCode( 500 );

        } else if ( endpoint.containsIgnoreCase( '/tooling/query/?q=' ) ) {

            res.setStatus( 'OK' );
            res.setStatusCode( 200 );
            res.setBody( JSON.serialize( new Map<String, Object>{
                'records' => new List<Map<String, Object>>{
                    new Map<String, Object>{
                        'DeveloperName' => 'TestField',
                        'Metadata' => new Map<String, Object>{
                            'relationshipLabel' => 'Test Relationship Label',
                            'relationshipName' => 'TestRelationshipName'
                        }
                    }
                }
            }));

        }

        return res;
    }

}
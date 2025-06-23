({
	doInit: function(cmp) {
        var recordId = cmp.get("v.recordId");
        var sObjectName = cmp.get("v.sObjectName");
        
        // NOTE: Lightning is very picky about quotes.
        // JSON keys and values MUST be wrapped with double quotes.
        // See: https://salesforce.stackexchange.com/questions/120473/canvas-app-in-lightning-component        
    	var output = '{"recordId": "' + recordId + '","type":"' + sObjectName + '"}';
        console.log('output:',output);
    	cmp.set("v.getRecordId", output);  
    }
        
})
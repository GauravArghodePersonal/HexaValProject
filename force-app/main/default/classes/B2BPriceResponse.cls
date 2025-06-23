public class B2BPriceResponse {

    @AuraEnabled public cls_ZYSH_PRICING_HYBRIS ZYSH_PRICING_HYBRIS;

    public class cls_ZYSH_PRICING_HYBRIS {
        @AuraEnabled public cls_item[] item;
        @AuraEnabled public String STATUS;   //Success
    }

    public class cls_item {
        @AuraEnabled public String PRICE;    //5.93
        //enabling currency
        @AuraEnabled public String CURRENCYCODE; //EUR
        @AuraEnabled public String PRICE_UNIT;   //1
        @AuraEnabled public String MATERIAL; //000000000000819074
    }

    public static B2BPriceResponse parse(String json){
        return (B2BPriceResponse) System.JSON.deserialize(json, B2BPriceResponse.class);
    }

    /*static testMethod void testParse() {
        String json=        '{'+
        '   "ZYSH_PRICING_HYBRIS": {'+
        '       "item": [{'+
        '           "PRICE": "5.93",'+
        '           "CURRENCY": "EUR",'+
        '           "PRICE_UNIT": "1",'+
        '           "MATERIAL": "000000000000819074"'+
        '       }],'+
        '       "STATUS": "Success"'+
        '   }'+
        '}';
        B2BPriceResponse obj = parse(json);
        System.assert(obj != null);
    }*/
}
@isTest
public class Test_B2BPriceResponse {
	public static testMethod void test1(){
        
        try{
        	B2BPriceResponse.cls_ZYSH_PRICING_HYBRIS obj = new B2BPriceResponse.cls_ZYSH_PRICING_HYBRIS();
        	B2BPriceResponse.cls_item ibj1= new B2BPriceResponse.cls_item();
        	B2BPriceResponse.parse('json');    
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        
    }
}
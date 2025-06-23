@isTest
public class VI_Reward_Card_Test {

    static String prodCategory = 'PCAT';
    static String page1 = '/apex/VI_Reward_Card_Page1?promoid=';
    static PageReference pageref;
    static VI_Promotion__c promo;
    static VI_Reward_Card_Controller c;
    static VI_Reward_Card_Controller.RewardCard rc;
    
    static void createTestData() {
    	promo = new VI_Promotion__c();
        promo.Program_Code__c = 'PC1001';
        promo.Channel__c = 'Test Channel';
        promo.Program_Name__c = 'Test Promotion';
        promo.Product_Category__c = prodCategory;
        insert promo;
        
        VI_Promotion_Upsell__c ups = new VI_Promotion_Upsell__c();
        ups.Primary_Product__c = 'Prod1';
        ups.Product_Category__c = prodCategory;
        ups.Reward_Card_Value__c = '5';
        ups.Upsell_Percent__c = 30;
        insert ups;
    }
    
    static testMethod void test01() {
    	createTestData();
    	pageref = new PageReference(page1+promo.Id);
        Test.setCurrentPageReference(pageref);
        c = new VI_Reward_Card_Controller();
        rc = c.rewardCards[0]; rc.selected = true;
        c.saveRewardCards();
        c = new VI_Reward_Card_Controller();
    }
}
@isTest
private class PricingController_Test {

    static testMethod void test01() {
        Account a = new Account();
        a.Name = 'testAccount';
        a.Account_Number__c = 'testAccount';
        insert a;
        Pricing__c p = new Pricing__c();
        p.Account__c = a.Id;
        p.Pricing_Type__c = 'Ship and Bill pricing';
        p.Status__c = 'Submitted';
        p.Net_Deal_Rating__c = 'test';
        p.Number_of_Locations_Serve__c = 2;
        p.Promotions__c = 'test';
        insert p;
        ApexPages.currentPage().getParameters().put('Id', p.Id);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(p);
        PricingController pc = new PricingController(sc);
        pc.emailCc = 'solenissfdcsupport@solenis.com';
        pc.emailCcOnly = true;
        pc.submitForApproval();
        PricingFunctions.getPricing(p.Id);
        pc.setPricingPendingApproval();
        pc.gotoPageBlock3();
        pc.sendEmails();
        p.Status__c = 'Approved';
        update p;
        pc.updatePricing();
        
        Set<String> pids = new Set<String>{p.Id};
        List<PricingController.Pricing> plist = pc.getPricings(pids);
        List<PricingController.Pricing> plist2 = pc.getPricingsPendingApproval();
        pc.userComments = 'Simply';
        for (PricingController.Pricing p2 : plist) {p2.selected = true;}
        pc.approveSelectedList(); pc.rejectSelectedList();
    }
    static testMethod void test02() {
        Pricing__c PRD =[select id from Pricing__c Limit 1];
        list<string> PRL = New list<string>();
        PRL.add(PRD.id);
        PricingController PR = New PricingController();
        PR.sortByEmerName();
        //PricingController.initcons();
        PricingController.approveSelectedListLwc(PRL,'test');
        PricingController.updateApproverCommentsLwc(PRL,'test');
    }

}
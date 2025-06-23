@istest
public class ReleaseRequestReview_Ext_Test  {
     static  testMethod void testReleaseRequest(){
        ART_Release__c rc = new ART_Release__c();
        insert rc;
        ApexPages.StandardController controller = new ApexPages.StandardController(rc);    
        ReleaseRequestReview_Ext extension = new ReleaseRequestReview_Ext(controller);
        }
        }
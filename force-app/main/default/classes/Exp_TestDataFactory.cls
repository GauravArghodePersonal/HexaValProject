@isTest
public class Exp_TestDataFactory {
	public static Exp_Events__c createExp_Event(Boolean doInsert){
        Exp_Events__c e=new Exp_Events__c();
        e.Name = 'Test Event';
        e.Heading__c = 'Test Heading';
        e.Sub_Heading__c = 'Test Sub Heading';
        e.Content__c = 'Test Content';
        e.Button_Label__c = 'Test Button Label';
        e.Is_Active__c = true;
        if(doInsert)
        {
            insert e;
        }        
        return e;
    }
    public static String createNewArticleAsADraft(String title, String urlName) {
        Knowledge__kav newArticle = new Knowledge__kav();
        newArticle.Title = title;
        newArticle.UrlName = urlName;
        insert newArticle;

        return [SELECT KnowledgeArticleId FROM Knowledge__kav WHERE Id =: newArticle.Id].KnowledgeArticleId;
	}
    public static void publishArticle(String recordId) { //KnowledgeArticleId
    	KbManagement.PublishingService.publishArticle(recordId, true);
	}
    
    //Create Carousel Data in Exp_Configs__c object
    public static void createNewCarousel(String RecordType) {
        Id CarouselRecordType = Schema.SObjectType.Exp_Configs__c.getRecordTypeInfosByName().get(RecordType).getRecordTypeId();
        Exp_Configs__c newCarousel = new Exp_Configs__c();
        newCarousel.RecordtypeId= CarouselRecordType;
        newCarousel.Name = 'Test1';
        newCarousel.Order__c = 1 ;
        newCarousel.IsActive__c = true;
        insert newCarousel;
	}
    
    /**
     * @description Test Data for technical performance score
     */
    public static Technical_Performance_Score__c createTechnicalPerformanceScore(String customerId, Boolean isInsert){
        Technical_Performance_Score__c newTPS = new Technical_Performance_Score__c();
        newTPS.Application_Id__c      = '1234';
        newTPS.Application_Name__c    = 'Test App';
        newTPS.Application_Performance_Status__c = 1;
        newTPS.Customer__c     = customerId;
        newTPS.Device_Count__c = 10; 
        newTPS.Site_Id__c      = '123';
        newTPS.Site_Name__c    = 'Test Site';
        newTPS.Site_URL__c     = 'https://www.example.com/'; 
        
        if(isInsert){
            Insert newTPS;
        }
        
        return newTPS;
    }
}
public with sharing class ExpHomePageBannerHandler {
    
    @AuraEnabled(cacheable=true)
    public static ResultWrapper imageforCarousel(String recordTypeDeveloperName){
        ResultWrapper result=new ResultWrapper();
        List<carouselWrapper> carousel = new List<carouselWrapper>();
        for(Exp_Configs__c expConfig: [SELECT id,ImageCarousel__c,IsActive__c,Order__c,Label__c,Image_link__c FROM Exp_Configs__c Where RecordType.DeveloperName =: recordTypeDeveloperName AND IsActive__c = true ORDER BY Order__c]){
            carousel.add(new carouselWrapper(expConfig.IsActive__c,expConfig.ImageCarousel__c,expConfig.Order__c,expConfig.id,expConfig.Label__c,expConfig.Image_link__c));
        }
        result.carousel = carousel;
        return result;
     }

    public class ResultWrapper{
        @AuraEnabled
        public String message;
       @AuraEnabled
        public List<carouselWrapper> carousel;
    }
    
    public class carouselWrapper{
        @AuraEnabled
        public Boolean isActive;
        @AuraEnabled
        public String ImageCarousel;
        @AuraEnabled
        public decimal Order;
        @AuraEnabled
        public String Id; 
        @AuraEnabled
        public String ImageLabel ;
        @AuraEnabled
        public String ImageLink;
        public carouselWrapper(Boolean isActive, String ImageCarousel,decimal Order,String Id,String Label,String Url){
           this.isActive = isActive;
           this.ImageCarousel = ImageCarousel;
           this.Order = Order;
           this.Id = Id;
           this.ImageLabel = Label;
           this.ImageLink = Url;
        }
    }
}
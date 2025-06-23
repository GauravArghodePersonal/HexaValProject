/*

Author:Aakash Wankhede

Last Modified On: 

Description: this class is created for fetching resources to be shown/displayed on experience site home page, test class name : Exp_RecentArticlesTest.cls

*/
public class Exp_RecentArticles {
    @AuraEnabled(cacheable=true)
    public static ResultWrapper getRecentArticles(){
        ResultWrapper result=new ResultWrapper();
        try{
            /*List<Article> articles = new List<Article>();
            final String PUBLISH_STATUS_ONLINE = 'Online';
            for(Knowledge__kav article:[ SELECT Id,title FROM Knowledge__kav WHERE PublishStatus = :PUBLISH_STATUS_ONLINE LIMIT 3]){
                articles.add(new Article(article.Id,article.title,article.title));
            }
            result.articles = articles;*/
            List<ExpResource> resources = new List<ExpResource>();
            //Fetching resources configuration form Exp_Configs and adding wrapper
            for(Exp_Configs__c config: [ SELECT Id, Name, Label__c, Value__c FROM Exp_Configs__c WHERE RecordType.DeveloperName = 'Resources' AND isActive__c=TRUE]){
                resources.add(new ExpResource(config.Id,config.Label__c,config.Value__c));
            }
            result.isSuccess = true;
            result.resources = resources;
        }
        catch(Exception ex) {
            result.message = ex.getMessage();
        }
        return result;
    }
    public class ResultWrapper{
        @AuraEnabled
        public Boolean isSuccess = false;
        @AuraEnabled
        public String message;
        /*@AuraEnabled
        public List<Article> articles;*/
        @AuraEnabled
        public List<ExpResource> resources;
    }
    /*public class Article{
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String title;
        @AuraEnabled
        public String content;
        public Article(Id recordId, String title,String content){
            this.id = recordId;
            this.title = title;
            this.content = content;
        }
    }*/
    //Wrapper to hold resource details like label ,url
    public class ExpResource{
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String urlValue;
        public ExpResource(Id recordId, String label,String urlValue){
            this.id = recordId;
            this.label = label;
            this.urlValue = urlValue;
        }
    }
}
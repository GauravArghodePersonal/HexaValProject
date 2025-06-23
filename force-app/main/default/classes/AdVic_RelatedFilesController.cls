public with sharing class AdVic_RelatedFilesController {

    @AuraEnabled
    public static List<FileWrapper> getRelatedFiles(String productId, String language) {
        language = language.replace('-', '_');
        List<FileWrapper> files = new List<FileWrapper>();
        Id productIdAsId = (Id) productId;

        List<ContentDocumentLink> cdLinks = [
            SELECT ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :productIdAsId
        ];

        Set<Id> contentDocumentIds = new Set<Id>();
        for (ContentDocumentLink cdl : cdLinks) {
            contentDocumentIds.add(cdl.ContentDocumentId);
        }

        List<ContentVersion> contentVersions = [
            SELECT Title, ContentDocumentId, Language
            FROM ContentVersion
            WHERE ContentDocumentId IN :contentDocumentIds
            AND Language = :language
            AND IsLatest = true
        ];

        List<ContentDistribution> distributionsToInsert = new List<ContentDistribution>();
        Map<Id, String> contentDocumentTitleMap = new Map<Id, String>();

        for (ContentVersion cv : contentVersions) {
            ContentDistribution cd = new ContentDistribution();
            cd.Name = cv.Title;
            cd.ContentVersionId = cv.Id;
            cd.PreferencesAllowViewInBrowser = true;
            cd.PreferencesLinkLatestVersion = true;
            cd.PreferencesNotifyOnVisit = false;
            cd.PreferencesPasswordRequired = false;
            cd.PreferencesAllowOriginalDownload = true;

            distributionsToInsert.add(cd);
            contentDocumentTitleMap.put(cv.ContentDocumentId, cv.Title);
        }

        insert distributionsToInsert;

        List<ContentDistribution> insertedDistributions = [SELECT Id, Name, DistributionPublicUrl, ContentVersionId FROM ContentDistribution WHERE Id IN :distributionsToInsert];

        for (ContentDistribution cd : insertedDistributions) {
            String title = cd.Name;
            String downloadLink = cd.DistributionPublicUrl;

            files.add(new FileWrapper(title, downloadLink, language));
        }

        return files;
    }

    public class FileWrapper {
        @AuraEnabled public String title;
        @AuraEnabled public String downloadLink;
        @AuraEnabled public String language;

        public FileWrapper(String title, String downloadLink, String language) {
            this.title = title;
            this.downloadLink = downloadLink;
            this.language = language;
        }
    }
}
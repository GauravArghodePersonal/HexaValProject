public class SignatureController {
    
       
    @AuraEnabled
    public static String saveSignature(String ContentVersionData, Id recordId, String title){
        
        // Create Content Version Object and then after content document link
        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S';
        cVersion.PathOnClient = title + '.png';
        cVersion.Origin = 'H';
        cVersion.Title = title + '.png';
        cVersion.VersionData = EncodingUtil.base64Decode(ContentVersionData);
        if( Schema.sObjectType.ContentVersion.isCreateable() && cVersion!=null){
            Insert cVersion;
        }
        
        Id conDocument;
        if (Schema.sObjectType.ContentVersion.isAccessible()){  
            conDocument=[SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
        }
        ContentDocumentLink cDocLink = new ContentDocumentLink();
        cDocLink.ContentDocumentId = conDocument;
        cDocLink.LinkedEntityId = recordId;
        cDocLink.ShareType = 'I';
        cDocLink.Visibility = 'AllUsers';
        if(Schema.sObjectType.ContentDocumentLink.isCreateable() && cDocLink!=null){
            Insert cDocLink;
        }
        
        // Generate public URL by creating ContentDistribution record
        ContentDistribution cd = new ContentDistribution();
        cd.Name = 'Test';
        cd.ContentVersionId = cVersion.Id;
        cd.PreferencesAllowViewInBrowser= true;
        cd.PreferencesLinkLatestVersion=true;
        cd.PreferencesNotifyOnVisit=false;
        cd.PreferencesPasswordRequired=false;
        cd.PreferencesAllowOriginalDownload= true;
        
        List<ContentDistribution> cdList = new List<ContentDistribution>();
        cdList.add(cd);
        
        if(cdList!=null && !cdList.isEmpty() && Schema.sObjectType.ContentDistribution.isCreateable())
            insert cdList;
        
        return cVersion.Id != null ? cVersion.Id : null;
    }
}
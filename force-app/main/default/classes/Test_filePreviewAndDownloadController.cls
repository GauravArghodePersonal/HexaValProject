@isTest
public class Test_filePreviewAndDownloadController {
    public static testMethod void Test1(){
          	String recId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Water Prospect'].Id;
        	
        	PriceFx__c p = new PriceFx__c();
        	p.allowed_recordtype_id__c = recId;
        	p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
       	 	p.Name='callAccount';
        	p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        	p.password__c='Testuser@123';
	        p.username__c='sfdctestuser';
            insert p;
        
        	Account acc = new Account();
            acc.Name = 'Test';
            acc.ShippingCity = 'Test';
            acc.ShippingCountry = 'Test';
            acc.ShippingStreet = 'Test';
            acc.ShippingPostalCode = 'Test';
            acc.ShippingState = 'Test';
            insert acc;
            
            Account acc1= new Account();
            acc1.Name = 'Test';
            acc1.ShippingCity = 'Test';
            acc1.ShippingCountry = 'Test';
            acc1.ShippingStreet = 'Test';
            acc1.ShippingPostalCode = 'Test';
            acc1.ShippingState = 'Test';
            acc1.parentId = acc.Id;
            acc1.SAP_Customer_Number__c = '12345';
            acc1.SAP_Sales_Org__c = 'test';
            acc1.SAP_DistChannel__c = '1';
            insert acc1;
            
			 Trigger__c Tr = New Trigger__c();
               Tr.Name='SentEmailToAcc';    
               Tr.Run__c=True;
               Tr.Trigger_Name__c='opportunityTriggerhandler';
           Insert Tr; 
        
            Opportunity opp     = new Opportunity();
            opp.Name        = 'test opp';
            opp.CloseDate   = System.today()+1;
            opp.StageName   = 'Initial Pitch/Demo';
         	opp.AccountId   = acc1.Id;
            insert opp;

            ContentVersion contentVersion = new ContentVersion(
            Title          = 'a picture',
            PathOnClient   = 'Pic.jpg',
            VersionData    = Blob.valueOf('Test Content'),
            IsMajorVersion = true);
            insert contentVersion;

            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

			//create ContentDocumentLink  record
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = opp.Id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            insert cdl;
        
        try{
            filePreviewAndDownloadController.getRelatedFilesByRecordId(opp.Id);
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
}
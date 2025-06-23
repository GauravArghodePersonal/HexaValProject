public class PriceBookListController {

    public Contact tempObject {get; set;}
    public List<Price_Book__c> priceBooks {get; set;}
    public Boolean renderChangeOwnerBlock {get; set;}
    public Boolean sendOwnerChangeEmail {get; set;}
    public String retURL {get; set;}

    public PriceBookListController(ApexPages.StandardSetController ssc) {
        if (ssc != null) {priceBooks = ssc.getSelected();}
        init();
    }

    public void init() {
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        tempObject = new Contact();
        ApexPages.Message msg;
        renderChangeOwnerBlock = false; sendOwnerChangeEmail = false;
        if (priceBooks != null && !priceBooks.isEmpty()) {
            Set<Id> ids = new Set<Id>();
            for (Price_Book__c pb : priceBooks) {ids.add(pb.Id);}
            priceBooks = [select Name, OwnerId from Price_Book__c where Id in :ids];
            tempObject.OwnerId = priceBooks[0].OwnerId;
            renderChangeOwnerBlock = true;
        } else {
            msg = new ApexPages.Message(
                      ApexPages.Severity.ERROR, 'Select at least one Price Book');
            ApexPages.addMessage(msg);
        }
    }

    public PageReference changeOwner() {
        ApexPages.Message msg;
        try {
            for (Price_Book__c pb : priceBooks) {
                pb.OwnerId = tempObject.OwnerId;
            }
            update priceBooks;
            if (sendOwnerChangeEmail) {sendOwnerChangeEmail(priceBooks, tempObject.OwnerId);}
            return gotoPriceBookTabPage();
        } catch(Exception e) {
            msg = new ApexPages.Message(
                      ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
        }
        return null;
    }

    public PageReference gotoPriceBookTabPage() {
        if (retURL == null) {return null;}
        return new PageReference(retURL);
    }

    public static Boolean sendOwnerChangeEmail(Price_Book__c pb, Id ownerId) {
        return sendOwnerChangeEmail(new List<Price_Book__c>{pb}, ownerId);
    }

    public static Boolean sendOwnerChangeEmail(List<Price_Book__c> pbs, Id ownerId) {
        if (pbs == null || pbs.isEmpty()) {return false;}
        User owner = null;
        try {owner = [select Email from User where Id = :ownerId];} catch(Exception e) {}
        if (owner == null) {return false;}
        String ccId = User_Functions.getLoggedInUserEmail();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {owner.Email});
        mail.setCcAddresses(new String[] {ccId});
        mail.setReplyTo(ccId);
        mail.setSubject('Price Book Ownership Transferred');
        String msg = 'The following Price Book(s) have been assigned to you. ';
        msg += 'Please click on the links to view the Price Book details.\n\n';
        for (Price_Book__c pb : pbs) {
            msg += 'Price Book Number : ' + pb.Name + ' (' + Label.OrgURL + pb.Id + ')\n\n';
        }
        mail.setPlainTextBody(msg);
        MessagingMethods.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        return true;
    }

}
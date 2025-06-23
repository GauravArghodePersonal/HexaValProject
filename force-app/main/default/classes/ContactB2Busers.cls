public class ContactB2Busers {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getconList() {
        return[select Name, Email, Phone, Account.Name, Account.AccountNumber,Account.SAP_Sales_Org__c from contact where B2B_User__c =true and Active__c = true AND Account.SAP_Sales_Org__c='0100'];
    }
    
    @AuraEnabled
    public static void sendEmail(List<Id> recordIds,String emailOfLoggedInUser) {
        List<String> namesLists = new List<String>();
        List<String> emailLists = new List<String>();
        List<Contact> contactList = new List<Contact>();
        for(Contact c : [select Name,Email from Contact where Id=:recordIds]){
            namesLists.add(c.Name);
            emailLists.add(c.Email);
            contactList.add(c);       
        }
        
        String recipientEmail = emailOfLoggedInUser; // Replace with the recipient's email address
        String subject = 'E-Shop Survey Details';
        
        // Generate table rows with data
        String tableRows = '';
        for (Integer i = 0; i < contactList.size(); i++) {
            tableRows += '<tr>' +
                '<td style="border: 1px solid black;">' + namesLists[i] + '</td>' +
                '<td style="border: 1px solid black;">' + emailLists[i] + '</td>' +
                '</tr>';
        }
        
        String body = '<p>Dear User,</p>' +
            '<p>Please find the Contact details for whom survey was sent:</p>' +
            '<table  style="border-collapse: collapse; width: 100%;">' +
            '<tr>' +
            '<th style="border: 1px solid black;">Contact Name</th>' +
            '<th style="border: 1px solid black;">Email</th>' +
            '</tr>' +
            tableRows +
            '</table>';
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { recipientEmail });
        email.setSubject(subject);
        email.setHtmlBody(body);
        
        // Add the email to a list for sending
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        emailList.add(email);
        
        // if(contactList.size() > 0) {
            // Send the email
            Messaging.sendEmail(emailList);
        // }
    }
}
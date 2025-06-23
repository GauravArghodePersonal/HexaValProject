public class EmailCallReport
{
    private final Call_Report__c callRep;
    
    public Call_Report__c cr;
            
    public String recipientTypes { get; set; }
    public String filterNameVar { get; set; }
     
    public String[] avblRecipients { get; set; }
    public String[] selRecipients { get; set; }
    public Boolean errFlag1 {get; set; }
    public Boolean errFlag2 {get; set; }
    public Boolean errFlag3 {get; set; }
    public Boolean errFlag4 {get; set; }
    public String addtnlEmails { get; set; }
    public List<User> users = new List<User>();
    public List<Contact> cons = new List<Contact>();
    List<SelectOption> avblRecipientOptions;
    List<SelectOption> selRecipientOptions = new List<SelectOption>();
    public List<String> finalSelRecipients = new List<String>();
    Map<String, String> nameByEmailMap;
    
    
    List<String> selectedUserRecipientsEmail = new List<String>();
    List<String> selectedContactRecipientsEmail = new List<String>();
    Integer size;
    String truncateName;
    
    public EmailCallReport(ApexPages.StandardController stdController)
    {
        this.callRep = (Call_Report__c) stdController.getRecord();
        
        cr = [Select Id, Name, Account__c from Call_Report__c where Id =: callRep.Id];
        
        recipientTypes = 'User';
        
        filterNameVar = '';
        
        size = 100;
        system.debug(users.size());
        users = [Select Id, Name, Email from User where IsActive = true order by Name asc limit 200];
        system.debug(users.size());
        if(users.size()<100) 
        {
            size = cons.size();
            errFlag1 = false;
        }
        
        if(users.size()>100)
        errFlag1 = true;
        
        if(users.size()>0)
        {
            avblRecipientOptions = new List<SelectOption>();
            nameByEmailMap = new Map<String, String>();
            
            for(Integer i=0; i<size; i++)
            { 
                avblRecipientOptions.add(new SelectOption(users[i].Email, 'User: ' + users[i].Name));
                nameByEmailMap.put(users[i].Email, 'User: ' + users[i].Name);
            }
        }
        else avblRecipientOptions.add(new SelectOption('--None--', '--None--'));
        
        errFlag2 = false;
        
        errFlag3 = false;
        
        errFlag4 = false;
               
        selRecipientOptions.add(new SelectOption('--None--', '--None--'));
        
        
    }
    
    public List<SelectOption> getRecipientTypeItems()
    {
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('User', 'User'));
        options.add(new SelectOption('Related Contacts', 'Related Contacts'));
        return options;
    }
    
    public List<SelectOption> getAvblRecipientItems()
    {    
        return avblRecipientOptions;
        
    }
    
    public List<SelectOption> getSelRecipientItems()
    {
                     
        return selRecipientOptions;
    }
    
    public PageReference retrieveAvblRec()
    {
                
        String queryString;
        size = 100;
        
        if(recipientTypes == 'User')
        {
            errFlag2 = false;
            queryString = 'Select Id, Name, Email from User where Name like \'%' + filterNameVar + '%\' AND Email NOT IN : selectedUserRecipientsEmail AND IsActive = True Order By Name Asc limit 200';
            users = Database.query(queryString);
                       
            if(users.size()<100) 
            {
                size = users.size();
                errFlag1 = false;
            }
            else errFlag1 = true;
            
            if(users.size()>0)
            {
                avblRecipientOptions = new List<SelectOption>();
                                
                for(Integer i=0; i<size; i++)
                { 
                    
                    avblRecipientOptions.add(new SelectOption(users[i].Email, 'User: ' + users[i].Name));
                    nameByEmailMap.put(users[i].Email, 'User: ' + users[i].Name);
                }
                System.debug(nameByEmailMap.size());
            }
            else avblRecipientOptions.add(new SelectOption('--None--', '--None--'));

        }
        else if(recipientTypes == 'Related Contacts')
        {   
            
            errFlag2 = true;
            queryString = 'Select Id, Name, Email from Contact where AccountId = \'' + cr.Account__c + '\' AND Name like \'%' + filterNameVar + '%\' AND Email != null AND Email NOT IN : selectedContactRecipientsEmail Order By Name limit 200';
            cons = Database.query(queryString);
                        
            if(cons.size()<100) 
            {
                size = cons.size();
                errFlag1 = false;
            }
            System.debug(avblRecipientOptions.size());
            
            if(cons.size()>0)
            {                
                avblRecipientOptions = new List<SelectOption>();
                                
                for(Integer i=0; i<size; i++)
                {                   
                    
                    avblRecipientOptions.add(new SelectOption(cons[i].Email, 'Contact: ' + cons[i].Name));
                    nameByEmailMap.put(cons[i].Email, 'Contact: ' + cons[i].Name);
                    
                }
            }
            else avblRecipientOptions.add(new SelectOption('--None--', '--None--'));

            
        }
        
        return null;
    }
    
    public PageReference selectedRecipients()
    {
        
        if(avblRecipients.size() > 0 && selRecipientOptions[0].getValue() == '--None--')
        {
            selRecipientOptions.clear();
        }
                
        for(String label : avblRecipients)
        {
            String name = nameByEmailMap.get(label);
            
            if(name.contains('User'))
            {
                
                selectedUserRecipientsEmail.add(label);
            }
            else if(name.contains('Contact'))
            {
                
                selectedContactRecipientsEmail.add(label);
            }
            
            selRecipientOptions.add(new SelectOption(label, name));
            
            if(selRecipientOptions.size() > 50)
            errFlag4 = true;
            
            finalSelRecipients.add(label);
        }
               
        for(String label : avblRecipients)
        {
            for(Integer j=0; j<avblRecipientOptions.size(); j++)
            {
                if('' + label == avblRecipientOptions[j].getValue())
                {
                    avblRecipientOptions.remove(j);
                    break;
                }
            }
        }
        
        if(avblRecipientOptions.size() == 0)
        {
            avblRecipientOptions.add(new SelectOption('--None--', '--None--'));
            
        }
        
        return null;
    }
    
    public PageReference deselectedRecipients()
    {
        
        if('--None--' == avblRecipientOptions[0].getValue())
        avblRecipientOptions.remove(0);
        
        for(String name : selRecipients)
        {
            if(name != '--None--')
            {
                String label = nameByEmailMap.get(name);
                
                /*if(label.contains('User'))
                {
                    selectedUserRecipientsEmail.remove(name);
                }
                else if(label.contains('Contact'))
                {
                    selectedContactRecipientsEmail.remove(name);
                }*/
                
                avblRecipientOptions.add(new SelectOption(name, label));
                    
            }
        }
        
        for(String name : selRecipients)
        {
            if(selRecipientOptions.size() > 0)
            {
                for(Integer j=0; j<selRecipientOptions.size(); j++)
                {
                    
                    if(''+ name == selRecipientOptions[j].getValue())
                        {
                            
                            selRecipientOptions.remove(j);
                            if(selRecipientOptions.size()<50)
                            errFlag4 = false;
                            finalSelRecipients.remove(j); 
                            break;
                        }
                }
            }
        }
        
        if (selRecipientOptions.size() == 0)
        {
            selRecipientOptions.add(new SelectOption('--None--','--None--'));
                
        }
        filterNameVar = '';
        return null;
    }
                    
    public PageReference sendEmail()
    {
        System.debug(isAddnEmailFormatCorrect());
        if(isAddnEmailFormatCorrect())
        {
            errFlag3 = false;
            
            /*Messaging.MassEmailMessage massEail = new Messaging.MassEmailMessage();
            
            massEmail.setTargetObjectIds();
            massEmail.setReplyTo();
            massEmail.setSenderDisplayName();
            massEmail.setTemplateId('00X50000000xuyp');
            
            Messaging.sendEmail(new Messaging.MassEmailMessage[] { massEmail });*/
            
            return null;
        }
        else 
        {
            errFlag3 = true;
            return null;
        }            
        
    }
    
    public Boolean isAddnEmailFormatCorrect()
    {
        String[] splitEmails;
        Boolean flag = true;
        if(addtnlEmails != null && addtnlEmails != '')
        {
            splitEmails = addtnlEmails.split('\n', 5);
            for(String s : splitEmails)
            {
                if(s.contains('@') && s.contains('.'))
                {
                    flag = true;
                    continue;
                }
                else
                {
                    flag = false;
                    break;
                }
            }
        }
        
        return flag;
    }
}
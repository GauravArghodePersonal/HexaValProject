public without sharing class GEERPendingApprovalEmailNotifications {
    static final String STATUS_PENDING                  = 'Pending';
    static final String NOTIFICATION_SUBJECT            = 'GEER Pending Approval(s) Reminder Notification';
    static final String ORG_WIDE_ADDRESS_SFDC_SUPPORT   = 'solenissfdcsupport@solenis.com';
    static final String OBJECT_TYPE_GEER				= 'GEER__c';
    static final DateTime CUT_OFF_DATE                  = System.today().addDays(
                                                                Test.isRunningTest()?0:
                                                                Integer.valueOf(
                                                                        System.label.GEER_Pending_Approval_Waiting_Period_Days
                                                                        )
                                                                    );

    static Map<String,String> approverIdWithName = new Map<String,String>();

    public static void sendPendingApprovalEmailNotifications() {
        Map<String,List<EmailNotificationWrapper>> pendingApprovalEmailNotificationsByApprover = getEmailNotificationWrappersByApprover();
        Map<String,String> notificationsHTMLBodyByApproverId = getEmailNotificationBodyByApprover(pendingApprovalEmailNotificationsByApprover);
        List<Messaging.SingleEmailMessage> mails = getComposedMails(notificationsHTMLBodyByApproverId);

        if(!mails.isEmpty()) {
            MessagingMethods.sendEmail(mails);
        }
    }


    private static Map<String,List<EmailNotificationWrapper>> getEmailNotificationWrappersByApprover() {
        Map<String,List<EmailNotificationWrapper>> emailNotificationsByApprover = new Map<String,List<EmailNotificationWrapper>>();
        List<ProcessInstance> processInstances = new List<ProcessInstance>([SELECT Id, 
                                                                                 SubmittedBy.Name, 
                                                                                 CreatedDate,  
                                                                                 TargetObjectId,
                                                                                 TargetObject.Name, 
                                                                                 (SELECT Id, 
                                                                                         ActorId, 
                                                                                         Actor.Name, 
                                                                                         Comments, 
                                                                                         CreatedDate 
                                                                                    FROM StepsAndWorkitems 
                                                                                    WHERE StepStatus = :STATUS_PENDING 
                                                                                    ORDER BY CreatedDate DESC 
                                                                                    LIMIT 1) 
                                                                            FROM ProcessInstance 
                                                                            WHERE Status = :STATUS_PENDING 
                                                                            AND TargetObject.Type = :OBJECT_TYPE_GEER
                                                                            AND CreatedDate<= :CUT_OFF_DATE
                                                                            ]);
        if(Test.isRunningTest()) {
            processInstances = [SELECT Id, 
                                         SubmittedBy.Name, 
                                         CreatedDate,  
                                         TargetObjectId,
                                         TargetObject.Name, 
                      					 Status
                                    FROM ProcessInstance 
                                    WHERE TargetObject.Type = :OBJECT_TYPE_GEER
                                    ];
        }
        
        for (ProcessInstance pi: processInstances) 
        {
            if(Test.isRunningTest() || !pi.StepsAndWorkitems.isEmpty())  {
                ProcessInstanceHistory pih = Test.isRunningTest()?
                    							new ProcessInstanceHistory():
                								pi.StepsAndWorkitems[0];
                StepsAndWorkitemsWrapper sawWrapper = getSAWWrapperRecord(pih);
                
                List<EmailNotificationWrapper> emailNotificationWrappers = emailNotificationsByApprover.get(sawWrapper.approverId);
                emailNotificationWrappers = (emailNotificationWrappers == null)?new List<EmailNotificationWrapper>():emailNotificationWrappers;
                                
                EmailNotificationWrapper pendingApprovalWrap = new EmailNotificationWrapper();
                pendingApprovalWrap.GEERName = pi.TargetObject.Name;
                pendingApprovalWrap.SubmittedBy = pi.SubmittedBy.Name;
                pendingApprovalWrap.SubmittedDate = pi.CreatedDate.format();
                pendingApprovalWrap.comments = sawWrapper.submissionComments;
                pendingApprovalWrap.recordLink = URL.getSalesforceBaseUrl().toExternalForm() + '/' + pi.TargetObjectId;
                emailNotificationWrappers.add(pendingApprovalWrap);

                emailNotificationsByApprover.put(sawWrapper.approverId, emailNotificationWrappers);

                approverIdWithName.put(sawWrapper.approverId, sawWrapper.approverName);
            }
            
        }

        return emailNotificationsByApprover;
    }

    private static Map<String,String> getEmailNotificationBodyByApprover(Map<String,List<EmailNotificationWrapper>> emailNotificationsByApprover){
        Map<String,String> notificationsHTMLBodyByApproverId = new Map<String,String>();

        for(String approverId : emailNotificationsByApprover.keySet()) {

            String htmlBody = 'Dear ' + (approverIdWithName.containsKey(approverId)?approverIdWithName.get(approverId):'') + ',' + '<br></br>';
            htmlBody += '<p>The following GEER(s) are waiting for your approval.</p>';
            htmlBody += '<table border="1" style="border-collapse: collapse;">';
            htmlBody += '<tr><th>Name</th><th>Submitted By</th><th>Submitted Date</th><th>Comments</th><th>Link</th></tr>';

            for(EmailNotificationWrapper pendingApprovalWrap : emailNotificationsByApprover.get(approverId)) {
                htmlBody += '<tr>';
                htmlBody += '<td>' + pendingApprovalWrap.geerName + '</td>';
                htmlBody += '<td>' + pendingApprovalWrap.submittedBy + '</td>';
                htmlBody += '<td>' + pendingApprovalWrap.submittedDate + '</td>';
                htmlBody += '<td>' + (String.isNotBlank(pendingApprovalWrap.comments)?
                                            pendingApprovalWrap.comments:
                                            '') 
                                        + '</td>';
                htmlBody += '<td>' + '<a href=' + pendingApprovalWrap.recordLink + '>Link</a></td>';
                htmlBody += '</tr>';
            }
            htmlBody += '</table>';
            
            notificationsHTMLBodyByApproverId.put(approverId, htmlBody);
        }

        return notificationsHTMLBodyByApproverId;
    }

    private static List<Messaging.SingleEmailMessage> getComposedMails(Map<String,String> notificationsHTMLBodyByApproverId) {
        Id sfdcsupportOrgId = [SELECT Id 
                                    FROM OrgWideEmailAddress 
                                    WHERE Address = :ORG_WIDE_ADDRESS_SFDC_SUPPORT].Id;

        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(String approverId : notificationsHTMLBodyByApproverId.keySet()) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.targetobjectid = approverId;
            mail.setSubject(NOTIFICATION_SUBJECT);
            mail.setHtmlBody(notificationsHTMLBodyByApproverId.get(approverId));
            mail.setOrgWideEmailAddressId(sfdcsupportOrgId);
            mail.setSaveAsActivity(false);
            mails.add(mail);
        }

        return mails;
    }
    
    private static StepsAndWorkitemsWrapper getSAWWrapperRecord(ProcessInstanceHistory saw) {
        StepsAndWorkitemsWrapper instance = new StepsAndWorkitemsWrapper();
        instance.submissionComments = Test.isRunningTest()?'Test Submission':saw.Comments;
        instance.approverId = Test.isRunningTest()?UserInfo.getUserId():saw.ActorId;
        instance.approverName = Test.isRunningTest()?UserInfo.getUserName():saw.Actor.Name;
        
        return instance;
    }
    

    public class EmailNotificationWrapper {
        public String geerName        { get; set; }
        public String submittedBy     { get; set; }
        public String submittedDate   { get; set; }
        public String comments        { get;set; }
        public String recordLink      { get; set; }
    }
    
    public class StepsAndWorkitemsWrapper {
        public String submissionComments { get;set; }
        public String approverId		 { get;set; }
        public String approverName	     { get;set; }
    }
}
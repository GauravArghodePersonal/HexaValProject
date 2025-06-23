@isTest
private class solenis_Commercial_Send_Call_ReportTests{
    @isTest 
    Private static void solenis_Commercial_Send_Call_ReportTest(){
    Test.startTest();
        contact con=TestDataFactory.createContact(false);   
        con.LastName ='Call Report Holder';
        insert con;
        user usr=TestDataFactory.createUser(true,'test@solenis.com.test','12345987689');        
        list<string> selectedid = new list<string>();
        selectedid.add(usr.id);
        solenis_Commercial_Send_Call_Report.sendEmail(selectedid,String.valueOf(con.id),'test@solenis.com.test');
          Test.stopTest();
        
        
        }
    
    

}
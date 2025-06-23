@isTest
private class PS_Lonza_SortedCaseComments_Test{
  @testSetup
  static void setupTestData(){
  
  case case_Obj= new case();
        case_Obj.Status = 'New';
        case_Obj.Description = 'This ticket has been created as a test';
        case_Obj.Subject = 'Test Case';
        insert case_Obj;
    test.startTest();
    CaseComment casecomment_Obj = new CaseComment(ParentId = case_Obj.id, IsPublished = false, CommentBody = '4');
    Insert casecomment_Obj; 
    test.stopTest();
  }
  static testMethod void test_getCaseComments_UseCase1(){
    List<CaseComment> casecomment_Obj  =  [SELECT ParentId,IsPublished,CommentBody,CreatedDate from CaseComment];
    System.assertEquals(true,casecomment_Obj.size()>0);
    PS_Lonza_SortedCaseCommentsController obj01 = new PS_Lonza_SortedCaseCommentsController();
    obj01.getCaseComments();
  }

    static testMethod void test_getCaseComments_UseCase2(){
    List<CaseComment> casecomment_Obj  =  [SELECT ParentId,IsPublished,CommentBody,CreatedDate from CaseComment];
    System.assertEquals(true,casecomment_Obj.size()>0);
    PS_Lonza_SortedCaseCommentsController obj01 = new PS_Lonza_SortedCaseCommentsController();
    //casecomment_Obj[0].Type not recognized;
    casecomment_Obj[0].IsPublished=false;
    casecomment_Obj[0].CommentBody = '0';
    //casecomment_Obj[0].CreatedDate = '2021-12-07 08:50:01';
    Update casecomment_Obj[0];
    obj01.getCaseComments();
  }
}
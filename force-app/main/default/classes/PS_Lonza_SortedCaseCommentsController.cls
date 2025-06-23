public class PS_Lonza_SortedCaseCommentsController {
  public Id     AttributeCaseId    {get; set;}

  public List<CaseComment> getCaseComments() {
    return [
      SELECT CommentBody, CreatedDate, CreatedBy.Name 
      FROM CaseComment
      WHERE ParentId = :this.AttributeCaseId
      ORDER BY CreatedDate DESC
    ];
  }

}
public with sharing class SOQLOffsetIssue {

    public Integer getSOQLRowCount() {
        return [SELECT COUNT() 
                  FROM Account 
                 WHERE (ParentId = '0015000000F8rCcAAJ' 
                    OR Parent.ParentId = '0015000000F8rCcAAJ' 
                    OR Parent.Parent.ParentId = '0015000000F8rCcAAJ' 
                    OR Parent.Parent.Parent.ParentId = '0015000000F8rCcAAJ')];
    }

    public List<Account> getSOQLDataLimit100() {
        return [SELECT Id, Name, Type, AccountNumber 
                  FROM Account 
                 WHERE (ParentId = '0015000000F8rCcAAJ' 
                    OR Parent.ParentId = '0015000000F8rCcAAJ' 
                    OR Parent.Parent.ParentId = '0015000000F8rCcAAJ' 
                    OR Parent.Parent.Parent.ParentId = '0015000000F8rCcAAJ')
                    LIMIT 100 ];
    }

  public List<Account> getSOQLDataOffset0() {
        return [SELECT Id, Name, Type, AccountNumber 
                  FROM Account 
                 WHERE (ParentId = '0015000000F8rCcAAJ' 
                    OR Parent.ParentId = '0015000000F8rCcAAJ' 
                    OR Parent.Parent.ParentId = '0015000000F8rCcAAJ' 
                    OR Parent.Parent.Parent.ParentId = '0015000000F8rCcAAJ')
                    LIMIT 10 OFFSET 0];
    }

    public List<Account> getSOQLDataOffset10() {
        return [SELECT Id, Name, Type, AccountNumber  
                  FROM Account 
                 WHERE (ParentId = '0015000000F8rCcAAJ' 
                    OR Parent.ParentId = '0015000000F8rCcAAJ' 
                    OR Parent.Parent.ParentId = '0015000000F8rCcAAJ' 
                    OR Parent.Parent.Parent.ParentId = '0015000000F8rCcAAJ')
                    LIMIT 10 OFFSET 10];
    }

    public List<Account> getSOQLDataOffset20() {
        return [SELECT Id, Name, Type, AccountNumber  
                  FROM Account 
                 WHERE (ParentId = '0015000000F8rCcAAJ' 
                    OR Parent.ParentId = '0015000000F8rCcAAJ' 
                    OR Parent.Parent.ParentId = '0015000000F8rCcAAJ' 
                    OR Parent.Parent.Parent.ParentId = '0015000000F8rCcAAJ')
                    LIMIT 10 OFFSET 20];
    }

    public List<Account> getSOQLDataOffset25() {
        return [SELECT Id, Name, Type, AccountNumber  
                  FROM Account 
                 WHERE (ParentId = '0015000000F8rCcAAJ' 
                    OR Parent.ParentId = '0015000000F8rCcAAJ' 
                    OR Parent.Parent.ParentId = '0015000000F8rCcAAJ' 
                    OR Parent.Parent.Parent.ParentId = '0015000000F8rCcAAJ')
                    LIMIT 10 OFFSET 25];
    }

    public List<Account> getSOQLDataOffset30() {
        return [SELECT Id, Name, Type, AccountNumber  
                  FROM Account 
                 WHERE (ParentId = '0015000000F8rCcAAJ' 
                    OR Parent.ParentId = '0015000000F8rCcAAJ' 
                    OR Parent.Parent.ParentId = '0015000000F8rCcAAJ' 
                    OR Parent.Parent.Parent.ParentId = '0015000000F8rCcAAJ')
                    LIMIT 10 OFFSET 30];
    }

}
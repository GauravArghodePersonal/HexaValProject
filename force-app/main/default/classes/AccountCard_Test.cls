@IsTest
public class AccountCard_Test {
    @IsTest
    static void emptyAccountCard(){
        Test.startTest();
        AccountCard eAccountCard = new AccountCard();
        Test.stopTest();
        
        System.assertEquals(null, eAccountCard.Id);
        System.assertEquals(null, eAccountCard.SourceAccountId);
    }
    
    @IsTest
    static void normalAccountCard(){
        Test.startTest();
        AccountCard normalAccountCard = new AccountCard(
            'uniqueId', 
            'sourceAccountId'
        );
        normalAccountCard.Title = 'Title';       
        normalAccountCard.CustomGroup = 'CustomGroup';
        normalAccountCard.CustomGroup1 = 'CustomGroup1';
        normalAccountCard.SalesArea = 'SalesArea';
        normalAccountCard.SalesArea1 = 'SalesArea1';
        normalAccountCard.SalesDistrict = 'SalesDistrict';
        normalAccountCard.SalesOffice = 'SalesOffice';
        normalAccountCard.SalesGroup = 'SalesGroup';
        Test.stopTest();
        
        System.assertEquals('uniqueId', normalAccountCard.Id);
        System.assertEquals('sourceAccountId', normalAccountCard.SourceAccountId);
        System.assertEquals('Title', normalAccountCard.Title);
        System.assertEquals('CustomGroup', normalAccountCard.CustomGroup);
        System.assertEquals('CustomGroup1', normalAccountCard.CustomGroup1);
        System.assertEquals('SalesArea', normalAccountCard.SalesArea);
        System.assertEquals('SalesArea1', normalAccountCard.SalesArea1);
        System.assertEquals('SalesDistrict', normalAccountCard.SalesDistrict);
        System.assertEquals('SalesOffice', normalAccountCard.SalesOffice);
        System.assertEquals('SalesGroup', normalAccountCard.SalesGroup);
    }
}
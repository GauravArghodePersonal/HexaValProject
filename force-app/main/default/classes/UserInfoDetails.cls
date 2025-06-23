public class UserInfoDetails {
@AuraEnabled
    public static list<User> getUserDetails(String recId) {
        return  [Select Id , Name ,Email from User where Id =:recId];
    }
}
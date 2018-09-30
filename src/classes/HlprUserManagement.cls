public with sharing class HlprUserManagement {

    public static final string MOVED_TEMPORARILY = 'Moved Temporarily';

    public static pageReference isUserLoggedIn(User user){
        return null;
    }

    public static user getUser(){
        User user = new User();

        for (User u : [SELECT Id, Name, FirstName, LastName, Street, City, State, PostalCode, Country, UserType
                       FROM User WHERE Id = :userInfo.getUserId() LIMIT 1]){
            user = u;
        }

        return user;
    }
}
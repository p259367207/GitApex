/*
     Objective - DAO class for CRUD-operations on the custom object CommunicationPreferencesCategory__c
*/
public with sharing class CommunicationPrefCategoryDAO extends CommunicationPreferencesDAOImpl {

    private static Integer MAX_ROWS = 20000;

    public CommunicationPrefCategoryDAO() {
        super();
    }

    public override List<sObject> getAllData(){
        List<CommunicationPreferencesCategory__c> categories = new List<CommunicationPreferencesCategory__c> ();
        try{
             categories = [SELECT Id, Active__c, AvailableMethods__c, Name FROM CommunicationPreferencesCategory__c LIMIT :CommunicationPrefCategoryDAO.MAX_ROWS];
        } catch(Exception ex){
            System.debug('EXCEPTION ' + ex.getStackTraceString());
        }
        return categories;
    }

    public override List<sObject> getDataById(String id){return null;}
}
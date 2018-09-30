/*
     Objective - DAO class for CRUD-operations on the custom object CommunicationPreferencesTopic__c
*/
public with sharing class CommunicationPrefTopicDAO extends CommunicationPreferencesDAOImpl {
    private static Integer MAX_ROWS = 50000;

    public CommunicationPrefTopicDAO() {
        super();
    }

    public override List<sObject> getAllData(){
        List<CommunicationPreferencesTopic__c> topics = new List<CommunicationPreferencesTopic__c> ();
        try{
             topics = [SELECT Id, Name, Active__c, CommunicationMethods__c,  CampaignType__c, Description__c, Frequency__c, Order__c,
                            CommunicationPreferencesCategory__r.Name, CommunicationPreferencesCategory__r.Active__c 
                        FROM CommunicationPreferencesTopic__c 
                        WHERE CommunicationPreferencesCategory__r.Active__c = true AND Active__c = true LIMIT :CommunicationPrefTopicDAO.MAX_ROWS];
        } catch(Exception ex){
            System.debug('EXCEPTION ' + ex.getStackTraceString());
        }
        return topics;
    }

    public override List<sObject> getDataById(String id) {
        return [SELECT Id, Name, Active__c, CommunicationPreferencesCategory__c,  CampaignType__c, CommunicationMethods__c, Description__c, Frequency__c, Order__c,
                    CommunicationPreferencesCategory__r.Name, CommunicationPreferencesCategory__r.Active__c 
                FROM CommunicationPreferencesTopic__c 
                WHERE Id =: id];
    }

    public Map<Id, CommunicationPreferencesTopic__c> getDataByIds(List<String> ids){
        Map<Id, CommunicationPreferencesTopic__c> topics;
        try{
             topics = new Map<Id, CommunicationPreferencesTopic__c>(
                        [SELECT Id, Name, CampaignType__c, Active__c, CommunicationMethods__c, Description__c, Frequency__c, Order__c,
                            CommunicationPreferencesCategory__r.Name, CommunicationPreferencesCategory__r.Active__c 
                        FROM CommunicationPreferencesTopic__c 
                        WHERE Id IN :ids AND CommunicationPreferencesCategory__r.Active__c = true AND Active__c = true LIMIT :CommunicationPrefTopicDAO.MAX_ROWS]
                    );
        } catch(Exception ex){
            System.debug('EXCEPTION ' + ex.getStackTraceString());
        }
        return topics;
    }

    public List<CommunicationPreferencesTopic__c> getTopicsByCategory(String categoryId) {
        return [SELECT Id, Name, Active__c, CommunicationPreferencesCategory__c, CampaignType__c, CommunicationMethods__c, Description__c, Frequency__c, Order__c,
                CommunicationPreferencesCategory__r.Name, CommunicationPreferencesCategory__r.Active__c 
                FROM CommunicationPreferencesTopic__c 
                WHERE CommunicationPreferencesCategory__c =: categoryId];
    }
}
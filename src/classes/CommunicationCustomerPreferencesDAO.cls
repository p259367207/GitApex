/*
     Objective - DAO class for CRUD-operations on the custom object CommunicationPreferencesCategory__c
*/
public with sharing class CommunicationCustomerPreferencesDAO extends CommunicationPreferencesDAOImpl {

    private static Integer MAX_ROWS = 30000;

    public CommunicationCustomerPreferencesDAO() {
        super();
    }

    public override List<sObject> getAllData(){
        List<CommunicationCustomerPreferences__c> custRefs = new List<CommunicationCustomerPreferences__c> ();
        try{
             custRefs = [SELECT Id, Name, Account__c, ReceiveTextAlert__c, ReceivePostalMail__c, ReceiveEmail__c, ReceiveAutomatedVoicemail__c, CommunicationPreferencesTopic__c,
                                CommunicationPreferencesTopic__r.Name, CommunicationPreferencesTopic__r.Active__c, CommunicationPreferencesTopic__r.CommunicationMethods__c,
                                CommunicationPreferencesTopic__r.Description__c, CommunicationPreferencesTopic__r.Frequency__c,
                                CommunicationPreferencesTopic__r.CommunicationPreferencesCategory__r.Name, 
                                CommunicationPreferencesTopic__r.CommunicationPreferencesCategory__r.Active__c,
                                CommunicationPreferencesTopic__r.CampaignType__c
                        FROM CommunicationCustomerPreferences__c 
                        WHERE CommunicationPreferencesTopic__r.CommunicationPreferencesCategory__r.Active__c = true
                            AND CommunicationPreferencesTopic__r.Active__c = true 
                        LIMIT :CommunicationCustomerPreferencesDAO.MAX_ROWS];
        } catch(Exception ex){
            System.debug('EXCEPTION ' + ex.getStackTraceString());
        }
        return custRefs;
    }

    /*
         @param - Account Id
         @return - List Actual Data for CommunicationCustomerPreferences__c
     */
    public override List<sObject> getDataById(String id) {
        List<CommunicationCustomerPreferences__c> custRefs = new List<CommunicationCustomerPreferences__c> ();
        try{
             custRefs = [SELECT Id, Account__c, ReceiveTextAlert__c, ReceivePostalMail__c, ReceiveEmail__c, ReceiveAutomatedVoicemail__c, CommunicationPreferencesTopic__c,
                                CommunicationPreferencesTopic__r.Name, CommunicationPreferencesTopic__r.Active__c, CommunicationPreferencesTopic__r.CommunicationMethods__c,
                                CommunicationPreferencesTopic__r.Description__c, CommunicationPreferencesTopic__r.Frequency__c,
                                CommunicationPreferencesTopic__r.CommunicationPreferencesCategory__r.Name, 
                                CommunicationPreferencesTopic__r.CommunicationPreferencesCategory__r.Active__c,
                                CommunicationPreferencesTopic__r.CampaignType__c
                        FROM CommunicationCustomerPreferences__c 
                        WHERE Account__c =: id 
                            AND CommunicationPreferencesTopic__r.CommunicationPreferencesCategory__r.Active__c = true
                            AND CommunicationPreferencesTopic__r.Active__c = true];
        } catch(Exception ex){
            System.debug('EXCEPTION ' + ex.getStackTraceString());
        }
        return custRefs;
    }

    public List<CommunicationCustomerPreferences__c> getDataByMRNs(List<String> accountMRNs) {
        List<CommunicationCustomerPreferences__c> custRefs = new List<CommunicationCustomerPreferences__c> ();
        try{
             custRefs = [SELECT Id, Account__r.Mrn__c, ReceiveTextAlert__c, ReceivePostalMail__c, ReceiveEmail__c, ReceiveAutomatedVoicemail__c, CommunicationPreferencesTopic__c
                        FROM CommunicationCustomerPreferences__c 
                        WHERE Account__r.Mrn__c IN : accountMRNs];
        } catch(Exception ex){
            System.debug('EXCEPTION ' + ex.getStackTraceString());
        } 
        return custRefs;
    }

    public List<CommunicationCustomerPreferences__c> getDataById(Set<Id> accountIds) {
        List<CommunicationCustomerPreferences__c> custRefs = new List<CommunicationCustomerPreferences__c> ();
        try{
             custRefs = [SELECT Id, Account__c, ReceiveTextAlert__c, ReceivePostalMail__c, ReceiveEmail__c, ReceiveAutomatedVoicemail__c, CommunicationPreferencesTopic__c,
                                CommunicationPreferencesTopic__r.Name, CommunicationPreferencesTopic__r.Active__c, CommunicationPreferencesTopic__r.CommunicationMethods__c,
                                CommunicationPreferencesTopic__r.Description__c, CommunicationPreferencesTopic__r.Frequency__c,
                                CommunicationPreferencesTopic__r.CommunicationPreferencesCategory__r.Name, 
                                CommunicationPreferencesTopic__r.CommunicationPreferencesCategory__r.Active__c,
                                CommunicationPreferencesTopic__r.CampaignType__c
                        FROM CommunicationCustomerPreferences__c 
                        WHERE Account__c IN : accountIds 
                            AND CommunicationPreferencesTopic__r.CommunicationPreferencesCategory__r.Active__c = true
                            AND CommunicationPreferencesTopic__r.Active__c = true];
        } catch(Exception ex){
            System.debug('EXCEPTION ' + ex.getStackTraceString());
        } 
        return custRefs;
    }

    public List<CommunicationCustomerPreferences__c> getDataById(Set<String> accountMrns, Set<String> topicPreferencesId) {
        List<CommunicationCustomerPreferences__c> custRefs = new List<CommunicationCustomerPreferences__c> ();
        try{
             custRefs = [SELECT Id, Account__c, Account__r.Mrn__c, ReceiveTextAlert__c, ReceivePostalMail__c, ReceiveEmail__c, ReceiveAutomatedVoicemail__c, CommunicationPreferencesTopic__c,
                                CommunicationPreferencesTopic__r.Name, CommunicationPreferencesTopic__r.Active__c, CommunicationPreferencesTopic__r.CommunicationMethods__c,
                                CommunicationPreferencesTopic__r.Description__c, CommunicationPreferencesTopic__r.Frequency__c,
                                CommunicationPreferencesTopic__r.CommunicationPreferencesCategory__r.Name, 
                                CommunicationPreferencesTopic__r.CommunicationPreferencesCategory__r.Active__c,
                                CommunicationPreferencesTopic__r.CampaignType__c
                        FROM CommunicationCustomerPreferences__c 
                        WHERE Account__r.Mrn__c IN: accountMrns AND Account__r.DeceasedIndicator__c = false
                            AND CommunicationPreferencesTopic__r.CampaignType__c IN :topicPreferencesId
                            AND CommunicationPreferencesTopic__r.CommunicationPreferencesCategory__r.Active__c = true
                            AND CommunicationPreferencesTopic__r.Active__c = true];
        } catch(Exception ex){
            System.debug('EXCEPTION ' + ex.getStackTraceString());
        } 
        return custRefs;
    }

    public List<CommunicationCustomerPreferences__c> findDataByTopic(String accountId, String topicId) {
        List<CommunicationCustomerPreferences__c> custRefs = new List<CommunicationCustomerPreferences__c> ();
        try{
             custRefs = [SELECT Id, Account__c, ReceiveTextAlert__c, ReceivePostalMail__c, ReceiveEmail__c, ReceiveAutomatedVoicemail__c, CommunicationPreferencesTopic__c,
                                CommunicationPreferencesTopic__r.Name, CommunicationPreferencesTopic__r.Active__c, CommunicationPreferencesTopic__r.CommunicationMethods__c,
                                CommunicationPreferencesTopic__r.Description__c, CommunicationPreferencesTopic__r.Frequency__c,
                                CommunicationPreferencesTopic__r.CommunicationPreferencesCategory__r.Name, 
                                CommunicationPreferencesTopic__r.CommunicationPreferencesCategory__r.Active__c,
                                CommunicationPreferencesTopic__r.CampaignType__c 
                        FROM CommunicationCustomerPreferences__c 
                        WHERE Account__c =: accountId
                            AND CommunicationPreferencesTopic__c =: topicId 
                            AND CommunicationPreferencesTopic__r.CommunicationPreferencesCategory__r.Active__c = true
                            AND CommunicationPreferencesTopic__r.Active__c = true];
        } catch(Exception ex){
            System.debug('EXCEPTION ' + ex.getStackTraceString());
        } 
        return custRefs;
    }

    public List<CommunicationCustomerPreferences__c> findDataByType(List<String> campaignType) {
        List<CommunicationCustomerPreferences__c> custRefs = new List<CommunicationCustomerPreferences__c> ();
        try{
             custRefs = [SELECT Id, Account__c, Account__r.PersonContactLookup__c, ReceiveTextAlert__c, ReceivePostalMail__c, ReceiveEmail__c, ReceiveAutomatedVoicemail__c, CommunicationPreferencesTopic__c,
                                CommunicationPreferencesTopic__r.Name, CommunicationPreferencesTopic__r.Active__c, CommunicationPreferencesTopic__r.CommunicationMethods__c,
                                CommunicationPreferencesTopic__r.Description__c, CommunicationPreferencesTopic__r.Frequency__c,
                                CommunicationPreferencesTopic__r.CommunicationPreferencesCategory__r.Name, 
                                CommunicationPreferencesTopic__r.CommunicationPreferencesCategory__r.Active__c,
                                CommunicationPreferencesTopic__r.CampaignType__c
                        FROM CommunicationCustomerPreferences__c 
                        WHERE CommunicationPreferencesTopic__r.CampaignType__c IN: campaignType
                            AND CommunicationPreferencesTopic__r.CommunicationPreferencesCategory__r.Active__c = true
                            AND CommunicationPreferencesTopic__r.Active__c = true];
        } catch(Exception ex){
            System.debug('EXCEPTION ' + ex.getStackTraceString());
        } 
        return custRefs;
    }}
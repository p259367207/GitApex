/*
     Objective - DAO class for CRUD-operations on the custom object CommunicationPreferencesChangesHistory__c
*/
public with sharing class CommunicationPrefHistoryDAO extends CommunicationPreferencesDAOImpl {
    private static Integer MAX_ROWS = 50000;
    private static final List<String> FIELD_NAMES = new List<String> {
                                                                        'ReceiveTextAlert__c',
                                                                        'ReceivePostalMail__c',
                                                                        'ReceiveEmail__c',
                                                                        'ReceiveAutomatedVoicemail__c'
                                                                    };

    public CommunicationPrefHistoryDAO() {
        super();
    }

    public override List<sObject> getAllData(){
        List<CommunicationPreferencesChangesHistory__c> changeHistories = new List<CommunicationPreferencesChangesHistory__c> ();
        try{
            changeHistories = [SELECT Id, UserName__c, APIFieldName__c, NewValue__c, OldValue__c, CreatedDate
                                FROM CommunicationPreferencesChangesHistory__c LIMIT :CommunicationPrefHistoryDAO.MAX_ROWS];
        } catch(Exception ex){
            System.debug('EXCEPTION ' + ex.getStackTraceString());
        }
        return changeHistories;
    }

    public override List<sObject> getDataById(String id){return null;}

    public void saveLog(List<CommunicationCustomerPreferences__c> oldValues, List<CommunicationCustomerPreferences__c> newValues, String userName) {
        List<CommunicationPreferencesChangesHistory__c> historyList = new List<CommunicationPreferencesChangesHistory__c>();
        for (CommunicationCustomerPreferences__c newValue : newValues) {
            Boolean hasOldValue = false;
            for (CommunicationCustomerPreferences__c oldValue: oldValues) {
                if (oldValue.id == newValue.id) {
                    historyList.addAll(getChanges(oldValue, newValue));
                    hasOldValue = true;
                    break;
                }
            }
            if (!hasOldValue) {
                historyList.addAll(getChanges(new CommunicationCustomerPreferences__c(), newValue));
            }
        }

        for (CommunicationPreferencesChangesHistory__c tmp :historyList) {
            tmp.UserName__c = userName;
        }
        if (!historyList.isEmpty()) {
            insert historyList;
        }
    }

    private List<CommunicationPreferencesChangesHistory__c> getChanges(CommunicationCustomerPreferences__c oldValue, CommunicationCustomerPreferences__c newValue) {
        List<CommunicationPreferencesChangesHistory__c> output = new List<CommunicationPreferencesChangesHistory__c>();
        for (String field: FIELD_NAMES) {
            String tempOld = oldValue.get(field) == null? '': String.valueOf(oldValue.get(field));
            String tempNew = newValue.get(field) == null? '': String.valueOf(newValue.get(field));

            if (!tempOld.equalsIgnoreCase(tempNew)) {
                output.add(getHistoryObject(field, tempOld, tempNew, newValue.get('Id')));
            }
        }
        return output;
    }

    private CommunicationPreferencesChangesHistory__c getHistoryObject(String field, String oldValue, String newValue, Object id) {
        CommunicationPreferencesChangesHistory__c output = new CommunicationPreferencesChangesHistory__c();
        output.APIFieldName__c = field;
        output.OldValue__c = oldValue;
        output.NewValue__c = newValue;
        output.CommunicationCustomerPreferences__c = String.valueOf(id);
        return output;
    }

    public CommunicationPreferencesChangesHistory__c getHistoryObject(String field, String oldValue, String newValue, Object id, String userName) {
        CommunicationPreferencesChangesHistory__c output = getHistoryObject(field, oldValue, newValue, id);
        output.UserName__c = userName;
        return output;
    }
}
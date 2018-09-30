public with sharing class CommunicationPreferencesHelper {

    public static Map<String, List<CommunicationPreferenceWrapper>> getPreferences(List<CommunicationCustomerPreferences__c> customerPreferences) {
        Map<String, List<CommunicationPreferenceWrapper>> output = new Map<String, List<CommunicationPreferenceWrapper>>();
        // populate standard fields for all topics
        for (CommunicationPreferencesTopic__c topic: (List<CommunicationPreferencesTopic__c>)CommPrefDAOFactory.getDAO(CommunicationPreferencesEnum.TOPIC).getAllData()) {
            CommunicationPreferenceWrapper aTopic = new CommunicationPreferenceWrapper(topic);
            List<CommunicationPreferenceWrapper> preferences = output.get(aTopic.categoryName);
            if (preferences == null) {
                preferences = new List<CommunicationPreferenceWrapper>();
            }
            preferences.add(aTopic);
            preferences.sort();
            output.put(aTopic.categoryName, preferences);
        }
        // add user fields for all existing topics
        for (CommunicationCustomerPreferences__c userPreference: customerPreferences) {
            for (CommunicationPreferenceWrapper aTopic: output.get(userPreference.CommunicationPreferencesTopic__r.CommunicationPreferencesCategory__r.Name)) {
                if (aTopic.topicId.equals(String.valueOf(userPreference.CommunicationPreferencesTopic__c))) {
                    populateUserPreferences(aTopic, userPreference);
                    break;
                }
            }
        }

        return output;
    }

    public static List<CommunicationCustomerPreferences__c> getUpdatedCustomerPreferences(List<CommunicationCustomerPreferences__c> customerPreferences, Map<String, List<CommunicationPreferenceWrapper>> wrappersMap, String userId) {
        List<CommunicationCustomerPreferences__c> output = new List<CommunicationCustomerPreferences__c>();
        Map<String, CommunicationPreferenceWrapper> tempMap = new Map<String, CommunicationPreferenceWrapper>();
        // create new 
        for (List<CommunicationPreferenceWrapper> wrappers: wrappersMap.values()) {
            for (CommunicationPreferenceWrapper wrapper: wrappers) {
                if (!String.isBlank(wrapper.Id)) {
                    tempMap.put(wrapper.Id, wrapper);
                } else {
                    CommunicationCustomerPreferences__c item = new CommunicationCustomerPreferences__c();
                    mapWrapper(wrapper, item, userId);
                    output.add(item);
                }
            }
        }
        // update old
        for (CommunicationCustomerPreferences__c preference: customerPreferences) {
            mapWrapper(tempMap.get(preference.Id), preference, userId);
            output.add(preference);
        }
        return output;
    }

    public static void populateUserPreferences(CommunicationPreferenceWrapper incWrapper, CommunicationCustomerPreferences__c incObjec) {
        incWrapper.Id = incObjec.Id;

        if (incWrapper.isTextAlertAvailable) {
            incWrapper.isTextAlert = incObjec.ReceiveTextAlert__c;
        }
        if (incWrapper.isEmailAvailable) {
            incWrapper.isEmail = incObjec.ReceiveEmail__c;  
        }
        if (incWrapper.isAutomatedVoicemailAvailable) {
            incWrapper.isAutomatedVoicemail = incObjec.ReceiveAutomatedVoicemail__c;
        }
        if (incWrapper.isPostalMailAvailable) {
            incWrapper.isPostalMail = incObjec.ReceivePostalMail__c;
        }
    }

    public static void mapWrapper(CommunicationPreferenceWrapper wrapper, CommunicationCustomerPreferences__c preference, String userId) {
        if(wrapper != null){
            if (String.isBlank(wrapper.Id)) {
                preference.CommunicationPreferencesTopic__c = wrapper.topicId;
                preference.Account__c = userId;
            }
            preference.ReceiveTextAlert__c = wrapper.isTextAlert;
            preference.ReceivePostalMail__c = wrapper.isPostalMail;
            preference.ReceiveEmail__c = wrapper.isEmail;
            preference.ReceiveAutomatedVoicemail__c = wrapper.isAutomatedVoicemail;
        }
    }

    public static List<CommunicationCustomerPreferences__c> outAllCustomerPreferences(List<CommunicationCustomerPreferences__c> currentCustomerPreferences){
        for(CommunicationCustomerPreferences__c cust : currentCustomerPreferences){
            if(cust.ReceiveTextAlert__c){
                cust.ReceiveTextAlert__c = false;
            }
            if(cust.ReceivePostalMail__c){
                cust.ReceivePostalMail__c = false;
            }
            if(cust.ReceiveEmail__c){
                cust.ReceiveEmail__c = false;
            }
            if(cust.ReceiveAutomatedVoicemail__c){
                cust.ReceiveAutomatedVoicemail__c = false;
            }
        }
        return currentCustomerPreferences;
    }

    public static String getAvailableMethodsForUser() {
        CommunicationPrefCategoryDAO commPrefCategoryDAO = (CommunicationPrefCategoryDAO) CommPrefDAOFactory.getDAO(CommunicationPreferencesEnum.CATEGORY);
        List<CommunicationPreferencesCategory__c> categories = commPrefCategoryDAO.getAllData();

        String output = '';
        if (!categories.isEmpty()) {
            if (!String.isBlank(categories.get(0).AvailableMethods__c)) {
                output = categories.get(0).AvailableMethods__c;
            }
        }
        return output;
    }
}
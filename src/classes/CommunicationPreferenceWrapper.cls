global with sharing class CommunicationPreferenceWrapper implements Comparable {
    public String categoryName {get; set;}
    public String id {get; set;}
    public String topicId {get; set;}
    public Integer topicOrder {get; set;}
    public String topicName {get; set;}
    public String topicDescription {get; set;}
    public String topicFrequency {get; set;}
    public String type {get; set;}
    public Boolean active {get;set;}
    
    public Boolean isTextAlertAvailable {get; set;}
    public Boolean isEmailAvailable {get; set;}
    public Boolean isAutomatedVoicemailAvailable {get; set;}
    public Boolean isPostalMailAvailable {get; set;}

    public Boolean isTextAlert {get; set;}
    public Boolean isEmail {get; set;}
    public Boolean isAutomatedVoicemail {get; set;}
    public Boolean isPostalMail {get; set;}

    public CommunicationPreferenceWrapper() {
        
    }

    public CommunicationPreferenceWrapper(CommunicationPreferencesTopic__c t) {
        this.topicId = t.Id;
        this.topicOrder = t.Order__c == null? 0: Integer.valueOf(t.Order__c);
        this.categoryName = t.CommunicationPreferencesCategory__r.Name;
        this.topicName = t.Name;
        this.topicDescription = t.Description__c;
        this.topicFrequency = t.Frequency__c;
        this.type = t.CampaignType__c;

        this.isTextAlertAvailable = isAvailable(getTextAlertPicklistValue(), t.CommunicationMethods__c);
        this.isEmailAvailable = isAvailable(getEmailPicklistValue(), t.CommunicationMethods__c);
        this.isAutomatedVoicemailAvailable = isAvailable(getVoiceMailPicklistValue(), t.CommunicationMethods__c);
        this.isPostalMailAvailable = isAvailable(getPostalmailPicklistValue(), t.CommunicationMethods__c);

        this.isTextAlert = false;
        this.isEmail = false;
        this.isAutomatedVoicemail = false;
        this.isPostalMail = false;
    }

    private Boolean isAvailable(String fieldName, String value) {
        Boolean output = false;
        if (!String.isBlank(value)) {
            output = value.contains(fieldName);
        }
        return output;
    }

    public static String getTextAlertPicklistValue() {
        return 'Text Alert';
    }

    public static String getEmailPicklistValue() {
        return 'Email';
    }

    public static String getVoiceMailPicklistValue() {
        return 'Automated Voicemail';
    }

    public static String getPostalmailPicklistValue() {
        return 'Postal Mail';
    }

    global Integer compareTo(Object compareTo) {
        CommunicationPreferenceWrapper compareToDTO = (CommunicationPreferenceWrapper)compareTo;
        Integer returnValue = 0;
        if (compareToDTO.topicOrder == null || this.topicOrder == null) {
            return -1;
        }
        if (this.topicOrder > compareToDTO.topicOrder) {
            returnValue = -1;
        } else if (this.topicOrder < compareToDTO.topicOrder) {
            returnValue = 1;
        }
        return returnValue;
    }
}
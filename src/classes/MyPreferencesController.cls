public with sharing class MyPreferencesController {

    private User user = null;
    private Account account = null;
    private CommunicationPreferencesDAOImpl communcationCustomerDAO = null;
    private List<CommunicationCustomerPreferences__c> currentCustomerPreferences = null;
    private List<CommunicationCustomerPreferences__c> cachedCustomerPreferences = null;
    public Boolean isOutOfAll {get; set;}

    public Boolean preferenceVoicemail { get; set; }
    public Boolean preferenceMail { get; set; }
    public Boolean preferenceText { get; set; }

    public Map<String, List<CommunicationPreferenceWrapper>> userPreferences {get; set;}
    public String availableMethods {get; private set;}

    public MyPreferencesController() {
        this.communcationCustomerDAO = CommPrefDAOFactory.getDAO(CommunicationPreferencesEnum.CUSTOMER_PREFERENCES);
        this.currentCustomerPreferences = new List<CommunicationCustomerPreferences__c>();
        this.cachedCustomerPreferences = new List<CommunicationCustomerPreferences__c>();
        this.user = HlprUserManagement.getUser();
    }

    public Pagereference initAction() {
        PageReference page = HlprUserManagement.isUserLoggedIn(user);
        if (page != null) {
            return page;
        }
        this.availableMethods = CommunicationPreferencesHelper.getAvailableMethodsForUser();
        this.currentCustomerPreferences = (List<CommunicationCustomerPreferences__c>)communcationCustomerDAO.getDataById(user.AccountId__c);
        this.cachedCustomerPreferences = (List<CommunicationCustomerPreferences__c>)communcationCustomerDAO.getDataById(user.AccountId__c);
        this.userPreferences = CommunicationPreferencesHelper.getPreferences(currentCustomerPreferences);
        for (Account acc: [
                //SELECT Id, PersonHasOptedOutOfEmail, HIPAA_Consent__c, HIPAA_Consent_Last_Activity__c
                SELECT Id, PersonHasOptedOutOfEmail__c
                FROM Account
                WHERE Id =: user.AccountId__c
        ]) {
            this.account = acc;
        }
        return null;
    }

    public PageReference saveAction() {
        List<CommunicationCustomerPreferences__c> customerPreferencesToUpsert = CommunicationPreferencesHelper.getUpdatedCustomerPreferences(currentCustomerPreferences, userPreferences, user.AccountId__c);
        if(isOutOfAll){
            customerPreferencesToUpsert = CommunicationPreferencesHelper.outAllCustomerPreferences(customerPreferencesToUpsert);
            isOutOfAll = false;
        }
        try {
            if (account.PersonHasOptedOutOfEmail__c) {
                account.PersonHasOptedOutOfEmail__c = false;
                update account;
            }
            account.HIPAA_Consent_Last_Activity__c = Datetime.now();
            upsert customerPreferencesToUpsert;
            CommunicationPrefHistoryDAO historyDAO = (CommunicationPrefHistoryDAO)CommPrefDAOFactory.getDAO(CommunicationPreferencesEnum.HISTORY);
            historyDAO.saveLog(cachedCustomerPreferences, customerPreferencesToUpsert,  user.FirstName + ' ' +user.LastName);
        } catch (DmlException e) {
            system.debug(LoggingLevel.ERROR, 'e: ' + e.getMessage() + '\n' + e.getStackTraceString());
        }
        initAction();
        return null;
    }
}
/*
     Objective - Factory Class for Create Communication Preferences DAO
*/
public with sharing class CommPrefDAOFactory {

    private static CommunicationPrefTopicDAO commPrefTopicDAO = null;
    private static CommunicationPrefCategoryDAO commPrefCategoryDAO = null;
    private static CommunicationCustomerPreferencesDAO commCustomerPreferencesDAO = null;
    private static CommunicationPrefHistoryDAO commPrefHistoryDAO = null;

    public CommPrefDAOFactory(){}

     /*
         @param - Enum Communication Preferences strategy
         @return - instance DAO-class 
     */
     public static CommunicationPreferencesDAOImpl getDAO(CommunicationPreferencesEnum factoryToObject) {
        if(factoryToObject == CommunicationPreferencesEnum.TOPIC){
            if(commPrefTopicDAO == null){ commPrefTopicDAO = new CommunicationPrefTopicDAO(); }
            return commPrefTopicDAO;
        } else if(factoryToObject == CommunicationPreferencesEnum.CATEGORY){
            if(commPrefCategoryDAO == null){ commPrefCategoryDAO = new CommunicationPrefCategoryDAO(); }
            return commPrefCategoryDAO;
        } else if(factoryToObject == CommunicationPreferencesEnum.CUSTOMER_PREFERENCES){
            if(commCustomerPreferencesDAO == null){ commCustomerPreferencesDAO = new CommunicationCustomerPreferencesDAO(); }
            return commCustomerPreferencesDAO;
        } else if(factoryToObject == CommunicationPreferencesEnum.HISTORY){
            if(commPrefHistoryDAO == null){ commPrefHistoryDAO = new CommunicationPrefHistoryDAO(); }
            return commPrefHistoryDAO;
        } else {
          return null;
        }
    }
  
}
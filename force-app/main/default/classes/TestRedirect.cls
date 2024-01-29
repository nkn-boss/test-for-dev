/*public with sharing class TestRedirect {

    @InvocableMethod(label='Test Dyanamic')
    public static List<List<ConversationDefinitionDialog>> getOpenAppointments() {
  
  
      // Get the list of new and scheduled ConversationDefinitionDialog
      List<ConversationDefinitionDialog> dialougeList1 = [SELECT Id,DeveloperName, MasterLabel  FROM ConversationDefinitionDialog LIMIT 5];
  
      // Create a list for the ConversationDefinitionDialog
      // NOTE: This is a list of lists in order to handle bulk calls...
      List<List<ConversationDefinitionDialog>> dialougeList = new List<List<ConversationDefinitionDialog>>();
  
      // Add all the new and ConversationDefinitionDialog to the list
      dialougeList.add(dialougeList1);
  
      return dialougeList;
    }
  }*/

public with sharing class TestRedirect {

    @InvocableMethod(label='Test Dyanamic')
    public static List<List<wrapperrr>> getOpenAppointments() {
  
    List<List<wrapperrr>> dialougeList = new List<List<wrapperrr>>();
      // Get the list of new and scheduled ConversationDefinitionDialog
      List<wrapperrr> wp1 = new List<wrapperrr>();
  
      // Create a list for the ConversationDefinitionDialog
      // NOTE: This is a list of lists in order to handle bulk calls...
      
        for(ConversationDefinitionDialog cd : [SELECT Id,DeveloperName, MasterLabel  FROM ConversationDefinitionDialog LIMIT 8]){
            wrapperrr wp = new wrapperrr();
            wp.cdd = cd;
            wp1.add(wp);
        }
        dialougeList.add(wp1);
      
  
      return dialougeList;
    }

    public class wrapperrr {
        @InvocableVariable
        public ConversationDefinitionDialog cdd;
    }
}
/**
 * @Project : Primark
 * @Author  : Devendra Villa
 * @Date    : 20/01/2023
 * @description : To get the locale specific value from the chatbot embedded script
 */
public without sharing class GetTranscriptVariables {
  /**
    * @description  : Class to have the input parameter of routable id
    * @author       : Devendra Villa
    **/		
  public class TranscriptInput {
    @InvocableVariable(required=true)
    public ID routableID;
  }
  /**
    * @description  : Class to have the output parameter of locale
    * @author       : Devendra Villa
    **/
  public class VisitorNameOutput {
    @InvocableVariable(required=true)
    public String userLocale;
  }

  @InvocableMethod(label='Get Locale')
  public static List<VisitorNameOutput> getUserLocale(List<TranscriptInput> transcripts) {

    List<VisitorNameOutput> localeValues = new List<VisitorNameOutput>();
  
    for (TranscriptInput transcript : transcripts) {
    
      // Query for the transcript record based on the ID
      LiveChatTranscript transcriptRecord = [SELECT LocationURL__c
                                             FROM LiveChatTranscript 
                                             WHERE Id = :transcript.routableID 
                                             LIMIT 1];
      // Store the first name in an output variable
      VisitorNameOutput nameData = new VisitorNameOutput();
      nameData.userLocale = transcriptRecord.LocationURL__c;
      
      // Add the name to the list of outputs
      localeValues.add(nameData);
    }
    
    return localeValues;
  }
}
public with sharing class ChatBotCopyTextUpdateController {

    // wrapper class with @AuraEnabled and {get;set;} properties 
    
    public class ChatBotCopyTextWrapper{
        @AuraEnabled
        public Set<String> dialogues{get;set;}
        @AuraEnabled
        public Map<String,List<Chatbot_Copy_Text__c>> chatBotCopyTextMap{get;set;}
    }

    @AuraEnabled(cacheable=false)
    public static ChatBotCopyTextWrapper getCoptTexts(String locale){
        try {
                ChatBotCopyTextWrapper cctw = new ChatBotCopyTextWrapper();
                cctw.chatBotCopyTextMap = new Map<String,List<Chatbot_Copy_Text__c>>();

                for(Chatbot_Copy_Text__c cct : [SELECT id,Dialogue_Name__c,Text__c,Previous_Text__c,Last_Updated_By__c,LastModifiedDate FROM Chatbot_Copy_Text__c WHERE Locale__c = :locale ORDER BY Dialogue_Name__c ]){
                    if(cctw.chatBotCopyTextMap != null && !cctw.chatBotCopyTextMap.isEmpty() && cctw.chatBotCopyTextMap.containsKey(cct.Dialogue_Name__c)){
                        List<Chatbot_Copy_Text__c> cc = cctw.chatBotCopyTextMap.get(cct.Dialogue_Name__c);
                        cc.add(cct);
                        cctw.chatBotCopyTextMap.put(cct.Dialogue_Name__c,cc);
                    }else{
                        cctw.chatBotCopyTextMap.put(cct.Dialogue_Name__c,new List<Chatbot_Copy_Text__c>{cct});
                    }
                }

                if(!cctw.chatBotCopyTextMap.isEmpty()){
                    cctw.dialogues = cctw.chatBotCopyTextMap.keySet();
                }
                return cctw;
        } catch (Exception e) {
            System.debug('Exception: '+e.getMessage());
            return null;
        }
    }
}
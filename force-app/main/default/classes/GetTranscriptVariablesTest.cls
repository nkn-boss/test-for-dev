@isTest
private class GetTranscriptVariablesTest {
     
    @isTest 
    static void getUserLocaleTest() {
        TestDataFactory.createLiveChatTranscript(TestDataFactory.createLiveChatVisitor());
        GetTranscriptVariables.TranscriptInput input = new GetTranscriptVariables.TranscriptInput();
        LiveChatTranscript tscript=[select id,LocationURL__C from LiveChatTranscript where LocationURL__C !=null];
        input.routableID= tscript.id;
        list<GetTranscriptVariables.TranscriptInput > lstinput = new list<GetTranscriptVariables.TranscriptInput >(); 
        lstinput.add(input);    
        GetTranscriptVariables.VisitorNameOutput output = new GetTranscriptVariables.VisitorNameOutput();
		list<GetTranscriptVariables.VisitorNameOutput > lstoutput = new list<GetTranscriptVariables.VisitorNameOutput >(); 
		output.userLocale= tscript.LocationURL__c;
        lstoutput.add(output); 
		 GetTranscriptVariables.getUserLocale(lstinput);
        
    }

}
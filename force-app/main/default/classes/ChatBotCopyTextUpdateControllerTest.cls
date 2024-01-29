@IsTest
public class ChatBotCopyTextUpdateControllerTest {

    @IsTest
    static void testGetCoptTexts() {
        // Create test data
        TestDataFactory.createChatbotCopyTexts();

        // Call the method under test
        ChatBotCopyTextUpdateController.ChatBotCopyTextWrapper result = ChatBotCopyTextUpdateController.getCoptTexts('en-gb');

        // Verify the result
        System.assertEquals(2, result.dialogues.size(), 'Incorrect number of dialogues');
        System.assertEquals(2, result.chatBotCopyTextMap.get('Dialogue 1').size(), 'Incorrect number of copy texts for Dialogue 1');
        System.assertEquals(1, result.chatBotCopyTextMap.get('Dialogue 2').size(), 'Incorrect number of copy texts for Dialogue 2');
    }
}
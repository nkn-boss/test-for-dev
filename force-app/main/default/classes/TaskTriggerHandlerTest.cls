@IsTest(SeeAllData = false)
class TaskTriggerHandlerTest {

  @IsTest 
    static void testOnDelete() {
         Task task = TestDataFactory.createCaseWIthTask();
         DELETE task;
    }
    
}
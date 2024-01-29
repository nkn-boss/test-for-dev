@isTest
private class CaseEscalationTriggerHelperTest{
    
    @isTest static void routeCases() {
        /*
        List<Case> caseList = new List<Case>();
        Group grp=[Select id,developerName from Group where name='UK Support'];
        Case cse = new Case();
        cse.Subject = 'This is Test for Data Protection';
        cse.Description = 'Test';
        cse.Consent_To_Deal_With_Query__c = true;
        
        caseList.add(cse);
        
        Case cs = new Case();
        cs.Subject = 'Test';
        cs.Description = 'This is GDPR';
        cs.Consent_To_Deal_With_Query__c = true;
        cs.OwnerId = grp.Id;
        
        caseList.add(cs);
        
        insert caseList;
        */
        Case[] caseList = TestDataFactory.createCasesEscalation(5);
        Test.startTest();
        CaseEscalationTriggerHelper.routeCases(caseList);
        Test.stopTest();
        
        
    }
    /*
    @isTest static void routeCasewithnullDesc(){
        List<Case> caseList = new List<Case>();
        Group grp=[Select id,developerName from Group where name='UK Support'];
        Case cse = new Case();
        cse.Subject = 'GDPR';
        cse.Description = 'Test';
        cse.Consent_To_Deal_With_Query__c = true;
        
        caseList.add(cse);
        
        Case cs = new Case();
        cs.Subject = 'This is GDPR';
        cs.Description = '';
        cs.Consent_To_Deal_With_Query__c = true;
        cs.OwnerId = grp.Id;
        
        caseList.add(cs);
        
        insert caseList;
        
        Test.startTest();
        CaseEscalationTriggerHelper.routeCases(caseList);
        Test.stopTest();
        
        System.assert(cse.IsEscalated,'Case is Escalated');
        System.assert(cs.IsEscalated,'Case is Escalated');
    }
    
    @isTest static void routeCase2(){
        List<Case> caseList = new List<Case>();
        Group grp=[Select Id, DeveloperName from Group where Type='Queue' AND Name='UK Support'];
        Case cse = new Case();
        cse.Subject = 'GDPR';
        cse.Description = 'Test';
        cse.Consent_To_Deal_With_Query__c = true;
        
        caseList.add(cse);
        
        Case cs = new Case();
        cs.Subject = 'This is #GDPR';
        cs.Description = 'test';
        cs.Consent_To_Deal_With_Query__c = true;
        cs.OwnerId = grp.Id;
        
        caseList.add(cs);
        
        Case cse2 = new Case();
        cse2.Subject = 'test';
        cse2.Description = 'This is Test for Data Protection';
        cse2.Consent_To_Deal_With_Query__c = true;
        caseList.add(cse2);
        
        insert caseList;
        
        Test.startTest();
        CaseEscalationTriggerHelper.routeCases(caseList);
        Test.stopTest();
        System.assert(cse.IsEscalated,'Case is Escalated');
        System.assert(cse2.IsEscalated, 'Case is Escalated');
        System.assertEquals(false, cs.IsEscalated,'Case is not Escalated');
    }
*/
    
    
}
@isTest
public  class TestDataFactory {
    
     public static void createCustomSetting(){
        List<Marketing_Cloud_REST_API_Config__c> marketingCustomSettings = new List<Marketing_Cloud_REST_API_Config__c>();
        Marketing_Cloud_REST_API_Config__c customSetting = new Marketing_Cloud_REST_API_Config__c();
        customSetting.ClientId__c = '0ccgccgc';
        customSetting.Client_Secret__c= 'hgahjsdghgahgdh';
        customSetting.Data_Extension_Key__c = '88GHGGH-GHGHGJ';
        customSetting.Auth_URL__c = 'https://test.com';
        customSetting.Post_URL__c = 'https://test.com';
         marketingCustomSettings.add(customSetting);
         
        insert marketingCustomSettings;

    }
    public static Case createCasesWithRelatedCases(Account[] acc){
        List<Case> casesList = new List<Case>();
           	Case newCase = new Case(
            Subject = 'Test Case Creation',
            Status = 'Closed',
            Origin = 'Email',
            Tier__c = 'Tier 1',
            Priority = 'Normal',
            Reason = 'Customer Service General Enquiry',
            SuppliedEmail = 'test@epam.com',
            Is_Anonymised__c = False,
            Child__C = False,
            AccountId=acc[0].Id,
            ClosedDate= Date.newInstance(2016, 08, 1),
            CreatedDate=Date.newInstance(2015, 05, 1)
        );
            casesList.add(newCase);
        Case newRelatedCase = new Case(
            Subject = 'Test Case Creation',
            Status = 'Closed',
            Origin = 'Email',
            Tier__c = 'Tier 1',
            Priority = 'Normal',
            Reason = 'Customer Service General Enquiry',
            SuppliedEmail = 'test@epam.com',
            Is_Anonymised__c = False,
            Child__C = False,
            AccountId=acc[0].Id,
            ParentId=newCase.Id,
            ClosedDate= Date.newInstance(2016, 08, 1),
            CreatedDate=Date.newInstance(2015, 05, 1)
        );
        	casesList.add(newRelatedCase);
            insert casesList;
        return newCase;
    }
    public static List<Account> createPersonAccounts(Integer numAccts) {
        PS_Process_Deactivation__c setting = new PS_Process_Deactivation__c();
		insert setting;
        List<Account> accts = new List<Account>();
        for(Integer i=0;i<numAccts;i++) { 
        Account a = new Account(
            LastName='Test LName'+i,
            FirstName='Test FName'+i,
            PersonEmail = 'test'+i+'@maildev1.com',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId()
        );
            accts.add(a);
        }
        insert accts;
        return accts;
    }
    public static List<Account> createPersonAccountsForAnonymisation(Integer numAccts) {
        PS_Process_Deactivation__c setting = new PS_Process_Deactivation__c();
		insert setting;
        List<Account> accts = new List<Account>();
        for(Integer i=0;i<numAccts;i++) { 
        Account a = new Account(
            LastName='Test LName'+i,
            FirstName='Test FName'+i,
            PersonEmail = 'test'+i+'@maildev1.com',
            CreatedDate=Date.newInstance(2015, 03, 1),
            Is_CS_Anonymised__c= True,
            Last_Activity_Date__c=Date.newInstance(2015,07,1),
            LastModifiedDate=Date.newInstance(2015, 05, 1),
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId()
        );
            accts.add(a);
        }
        insert accts;
        return accts;
    }

	
            
    
    public static List<Contact> createAccountsWithContacts(Integer numAccts,Integer numContacts) {
        List<Account> accList = new List<Account>();
       
        for(Integer i=0;i<numAccts;i++) { 
        Account newAccount = new Account(
        Name='Test Account'+ i  
        );
        accList.add(newAccount);    
        }
        insert accList;
         List<Contact> conList = new List<Contact>();
        for(Integer j=0;j<numAccts;j++) {
            Account acct = accList[j];
            for (Integer k=0;k<numContacts;k++) {
                conList.add(new Contact(lastname='Test Contact1',
                                        AccountId=acct.Id,
                                        primary_Contact__c= true));
        
            }
        }
        insert conList;
        return conList;
        
    }
    
    
    
    public static List<Lead> createLeads(Integer numLeads) {
        List<Lead> leadsList = new List<Lead>();
        for(Integer i=0;i<numLeads;i++) {
            Lead newLead = new Lead(
            FirstName = 'Test Firstname'+ i,
            Lastname = 'Test Lastname'+i,
            Status = 'Unqualified',    
            Email = 'test@mail'+i+'.com'
                
            
        );
            leadsList.add(newLead);
        }
        insert leadsList;
        return leadsList;
        
    }
    public static List<Lead> createLeadsForAnonymisation(Integer numLeads) {
        List<Lead> leadsList = new List<Lead>();
        for(Integer i=0;i<numLeads;i++) {
            Lead newLead = new Lead(
            FirstName = 'Test Firstname'+ i,
            Lastname = 'Test Lastname'+i,
            Status = 'Unqualified',    
            Email = 'test@mail'+i+'.com',
            CreatedDate=Date.newInstance(2015, 03, 1),
            Last_Activity_Date__c=Date.newInstance(2015,07,1),
            LastModifiedDate=Date.newInstance(2015, 05, 1)
                
            
        );
            leadsList.add(newLead);
        }
        insert leadsList;
        return leadsList;
        
    }
    public static List<Lead> createDuplicateLeads(Integer numLeads, String country) {
        List<Lead> leadsList = new List<Lead>();
        for(Integer i=0;i<numLeads;i++) {
            Lead newLead = new Lead(
            FirstName = 'Test'+country,
            Lastname = 'LastName'+i,
            Status = 'Unqualified',
            Email = 'test'+i+'@mail.com',
            Country__c=country    
            
        );
            leadsList.add(newLead);
        }
        insert leadsList;
        return leadsList;
        
    }
    public static Individual createIndividuals(Id acctId, Id leadId, integer numOfInd){
       Individual ind= new Individual(LastName='Ind_LName'+numOfInd,Account_Name__c = acctId,Country__c = 'India',Lead__c = leadId);
        return  ind;
    }
    public static List<Case> createCasesEscalation(Integer numOfCases){
        Group grp=[Select Id, DeveloperName from Group where  Name='UK Support'];
        List<Case> caseList = new List<Case>();
        for(Integer i=0;i<numOfCases;i++) { 
            Case cs = new Case();
            cs.OwnerId = grp.Id;
            if(Math.mod(i,2) ==0 )
            {
            cs.Description = 'This is GDPR '+i; 
            cs.Subject = 'This is Test for Data Protection '+i;    
            }
            else{
                cs.Description = '';
                cs.Subject = 'This is Test GDPR '+i;
            }
            cs.Consent_To_Deal_With_Query__c = true;
            caseList.add(cs);
        }
        insert caseList;
        return caseList;
    }
    
    public static List<Case> createCases(Integer numOfCases){
        //Test Data Setup
        PS_Process_Deactivation__c ppd = PS_Process_Deactivation__c.getInstance();
        ppd.PS_Disable_Flows__c = true;
        UPSERT ppd;
        List<Case> caseList = new List<Case>();
        for(Integer i=0;i<numOfCases;i++) { 
        Case newCase = new Case(
            Subject = 'Test Case Creation '+i,
            Status = 'New',
            Origin = 'Email',
            Tier__c = 'Tier 1',
            Priority = 'Normal',
            Reason = 'Customer Service General Enquiry',
            SuppliedEmail = 'test'+i+ '@epam.com'
        );
            caseList.add(newCase);
        
        }
        insert caseList;
        return caseList;
        
    }
    public static CaseComment createCaseComments(Id caseId){
        CaseComment cc = new CaseComment();
        cc.CommentBody = 'heyy';
        cc.ParentId = caseId;
        INSERT cc;
        return cc;
    }
    public static Task createCaseWIthTask(){
        case newcase = new case(
        Status = 'New',
        Origin = 'Email',
        Tier__c ='Tier 1',
        Reason ='Product Enquiry',
        Case_Subreason__c ='Recall',
        RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Live Chat').getRecordTypeId(),
        Priority='Normal',
        Subject='Check',
        Consent_To_Deal_With_Query__c = true
        );
        insert newcase;
        
        String caseid=newcase.Id;
        newcase.Status = 'In Progress';
        update newcase;
        

        Task newTask = new Task(
        subject='test',
        Priority='Normal',
        Status='Open',
        WhatId = caseid
        
        );
         insert newTask;
         return newTask;
    }
    public static Id createLiveChatVisitor(){
    LiveChatVisitor lv = new LiveChatVisitor();
        INSERT lv;
        return lv.Id;
    }
    public static Id createLiveChatTranscript( Id lcvId){
    LiveChatTranscript lc = new LiveChatTranscript ();
        lc.Body = 'heyeheyeh';
        lc.Status = 'Completed';
        lc.LiveChatVisitorId = lcvId;
        lc.LocationURL__c='en-ie';
        lc.Web_First_Name__c='Test First'; 
        lc.Web_Last_Name__c ='Test Last';   
		lc.Web_Email__c ='testfirstlast@gmail.com'; 
        INSERT lc;
        return lc.Id;
    }
    
    public static StoreAccountManager.StoreInformation getStoreInformationTestRecordErrorNoId() {
        StoreAccountManager.StoreInformation newAcc = new StoreAccountManager.StoreInformation();
        
        newAcc.storeAccount = new Account(
            BillingStreet='East Gate',
            Phone='441865240899',
            Display_Hours__c='Monday 9am-8pm Tuesday 9am-8pm Wednesday 9am-8pm Thursday 9am-8pm Friday 9am-8pm Saturday 9am-8pm Sunday 11am-5pm',
            Website='https://www.primark.com/en-gb/',
            Additional_Hours_Text__c='Additional',Store_Locale__c='en-gb');
        
        return newAcc;
    }
    
    public static StoreAccountManager.StoreInformation getStoreInformationTestRecordError() {
        StoreAccountManager.StoreInformation newAcc = new StoreAccountManager.StoreInformation();
        
        newAcc.storeAccount = new Account(
            BillingStreet='East Gate',
            Phone='441865240899',
            Display_Hours__c='Monday 9am-8pm Tuesday 9am-8pm Wednesday 9am-8pm Thursday 9am-8pm Friday 9am-8pm Saturday 9am-8pm Sunday 11am-5pm',
            Website='https://www.primark.com/en-gb/',
            Additional_Hours_Text__c='Additional',
        	Store_Id__c='dbn',Store_Locale__c='en-gb'
        );
        
        return newAcc;
    }
	
    public static StoreAccountManager.StoreInformation getStoreInformationTestRecord() {
        StoreAccountManager.StoreInformation newAcc = new StoreAccountManager.StoreInformation();
        
        newAcc.storeAccount = new Account(
            Store_Name__c='TestStoreDummy', 
            BillingCity='Oxford', 
            BillingCountry='GBR',
            Store_Id__c='123', 
            Store_Locale_ID__c='123 # en-gb',
            BillingPostalCode='OX1 1PE',
            City__c='London',
            BillingStreet='East Gate',
            Phone='441865240899',
            Display_Hours__c='Monday 9am-8pm Tuesday 9am-8pm Wednesday 9am-8pm Thursday 9am-8pm Friday 9am-8pm Saturday 9am-8pm Sunday 11am-5pm',
            Website='https://www.primark.com/en-gb/',
            Additional_Hours_Text__c='Additional');
        
        return newAcc;
    } 
    
    public static StorefrontAccountManager.AccountInformation getAccountInformationTestRecord() {
    StorefrontAccountManager.AccountInformation newAcc = new StorefrontAccountManager.AccountInformation();
	newAcc.accountInfo = new Account(
			FirstName='TestFirstName', 
			LastName='LastNameeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee', 
			PersonEmail='demo@demo.com',
			Preferred_Store__pc='dummy',
			UID__c='random123', 
			Country__pc='en-gb',
			Marketing_Communication_Opt_in__pc=true,
			PersonHasOptedOutOfEmail=true);
            return newAcc;
    }	
    public static StorefrontAccountManager.AccountInformation getAccountInformationTestUIDRecord(String uid) {
        StorefrontAccountManager.AccountInformation newErrorAcc = new StorefrontAccountManager.AccountInformation();
        newErrorAcc.accountInfo = new Account(
            	FirstName='TestFirstName', 
                LastName='LastName',
                PersonEmail='demo@demo.com',
                Preferred_Store__pc='dummy',
                UID__c=uid, 
                Marketing_Communication_Opt_in__pc=true,
                PersonHasOptedOutOfEmail=true);
        return newErrorAcc;
    }
    
        public static StorefrontAccountManager.AccountInformation getAccountInformationTestApi(String apiOperation) {
               StorefrontAccountManager.AccountInformation newAcc = new StorefrontAccountManager.AccountInformation();
                newAcc.accountInfo = new Account(
                    FirstName='TestFirstName', 
                    LastName='LastName', 
                    PersonEmail='demo@demo.com',
                    Preferred_Store__pc='dummy',
                    UID__c='random123', 
                    Country__pc='en-gb',
                    Marketing_Communication_Opt_in__pc=true,
                    PersonHasOptedOutOfEmail=true,
                    API_Operation__c= apiOperation);
            return newAcc;
    }
    
    public static void createEmail(Id caseId){
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'test@abc.org';
        email.Incoming = True;
        email.ToAddress= 'test@xyz.org';
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body 1234-4556-7899-8756';
        email.textBody = 'test body for test';
        email.ParentId = caseId; 
        insert email;
    }

    public static Id createContent(){
        ContentVersion content=new ContentVersion(); 
        content.Title='Sample doc'; 
        content.PathOnClient='/' + content.Title + '.csv'; 
        Blob bodyBlob=Blob.valueOf('Unit Test sample'); 
        content.VersionData=bodyBlob; 
        insert content;
        return content.Id;
    }

    public static void createContentLink(Id caseId, Id contentId){
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=caseId;
        //contentlink.ShareType= 'I';
        //contentlink.LinkedEntityId = q.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: contentId].contentdocumentid;  
        insert contentlink;

    }

    public static void createChatbotCopyTexts(){
        List<Chatbot_Copy_Text__c> copyTextList = new List<Chatbot_Copy_Text__c>();
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Dialogue 1', Text__c = 'Text 1', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Dialogue 1', Text__c = 'Text 2', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Dialogue 2', Text__c = 'Text 3', Locale__c = 'en-gb'));
        insert copyTextList;
    }
    
    public static void createChatbotCopyTextsWithDIalogs(){
        List<Chatbot_Copy_Text__c> copyTextList = new List<Chatbot_Copy_Text__c>();
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'ChangeMindMsg', Text__c = 'Change your mind message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'ChkBalanceMsg', Text__c = 'Check balance message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'ConfusedFAQLink', Text__c = 'Confused FAQ link', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'ContactUsLink', Text__c = 'Contact us link', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'ExampleCityMsg', Text__c = 'Example city message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'ExampleLocationQues', Text__c = 'Example location question', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'ExpireCardMsg', Text__c = 'Card expired message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'FAQLink', Text__c = 'FAQ link', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'FaultyMsg', Text__c = 'Faulty message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'GiftCardLink', Text__c = 'Gift card link', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'GiftCardMsg', Text__c = 'Gift card message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'InfluencerLink', Text__c = 'Influencer link', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'LocationLink', Text__c = 'Location link', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'OpeningCityMsg', Text__c = 'Opening city message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'PrimarkCaresLink', Text__c = 'Primark Cares link', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'PrivacyDataMessage', Text__c = 'Privacy data message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'SubscribeLink', Text__c = 'Sale link', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'SizeGuideLink', Text__c = 'Size guide link', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'StoreCreditLink', Text__c = 'Store credit link', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'StoreOpeningMsg', Text__c = 'Store opening message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'StyleInspirationLink', Text__c = 'Style inspiration link', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'SubscribeNewsletterLink', Text__c = 'Subscribe to newsletter link', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'PrivacyPolicyLink', Text__c = 'Privacy Policy Link', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'TrackRefundMsg', Text__c = 'Track Refund Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'WelcomeMsg', Text__c = 'Welcome Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'OrderCollection1', Text__c = 'Order Collection Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'UncollectedItems1', Text__c = 'Uncollected Items Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'Additional_Purchase1', Text__c = 'Additional Purchase Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'Collection1', Text__c = 'Collection Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'Click_Collect_Stores1', Text__c = 'Click Collect Stores Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'Covid_Restrictions1', Text__c = 'Covid Restrictions Message', Locale__c = 'en-gb'));
        // Add more records for other variables
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'GiftCardsReturns1', Text__c = 'Gift Card Return Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'LostGiftCard1', Text__c = 'Lost Gift Card Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'SpendGiftCard1', Text__c = 'Spend Gift Card Return Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'RefundExchange1', Text__c = 'Refund Exchange Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'StoreInformation1', Text__c = 'Store Information Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'StockQueries1', Text__c = 'Stock Query Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'Unsubscribe1', Text__c = 'Unsubscribe Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'EmailNotReceived1', Text__c = 'Email Not Recieved1 Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'EmailNotReceived2', Text__c = 'Email Not Recieved2 Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'SignUp1', Text__c = 'Sign Up Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'MyAccountSupport1', Text__c = 'My Account support Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'MarketingEmails1', Text__c = 'Marketing Emails', Locale__c = 'en-gb'));
		copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'Preferences1', Text__c = 'Preferences', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'ShoppingList1', Text__c = 'Shopping List', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'ResetPassword1', Text__c = 'Reset password', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'PreferredStore1', Text__c = 'Preferred Store', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'EmailNotLoading1', Text__c = 'Email Not Loading', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'LostEmailConfirmation1', Text__c = 'Lost Email Confirmation', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'RestrictedNumbers1', Text__c = 'Restricted Numbers', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'MissingItems1', Text__c = 'Missing Items Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'WrongItems1', Text__c = 'Wrong Items Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'OnlineOrderPlacement1', Text__c = 'Online Order Placement1 Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'GuestCheckout1', Text__c = 'Guest Checkout1 Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'ExpectedDeliveryTime1', Text__c = 'Expected Delivery Time1 Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'Location1', Text__c = 'Location1 Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'ContactDetails1', Text__c = 'Contact Details1 Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'MinimumSpend1', Text__c = 'Minimum Spend1 Message', Locale__c = 'en-gb'));
        
        //Add more records for other variables
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'StoreOpeningHours1', Text__c = 'Store Opening hours', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'VATNumber1', Text__c = 'Vat Number', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'StoreStockAvailability1', Text__c = 'Store Stock Availability', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'StoreReservation1', Text__c = 'Store Reservation', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'Restocks1', Text__c = 'Restock Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'LowStock1', Text__c = 'Low stock Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'TransferToAgent1', Text__c = 'Transfer to Agent1 Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'TransferToAgent2', Text__c = 'Transfer to Agent2 Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'TransferToAgent3', Text__c = 'Transfer to Agent3 Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'TransferToAgent4', Text__c = 'Transfer to Agent4 Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'EndChat1', Text__c = 'End Chat Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'NoAgent1', Text__c = 'No Agent Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'ErrorHandler1', Text__c = 'Error handler Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'ContactUsOutsideBH1', Text__c = 'Contact Us OutsideBH1', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'ContactUsMaxWT1', Text__c = 'Contact Us MaxWT1', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'ContactUsLast15Min1', Text__c = 'Contact Us Last15Min1', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'MultipleStoresLocation1', Text__c = 'Multiple Stores Location1 Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'MultipleStoresOpeningHrs1', Text__c = 'Multiple Stores OpeningHrs1 Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'Sizing', Text__c = 'Sizing Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'ReceiptSurvey', Text__c = 'Receipt Survey Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'PaymentMethods', Text__c = 'Payment Methods Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'SeasonalSales', Text__c = 'Seasonal Sales Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'GiftsCardsPin', Text__c = 'Gifts Cards Pin Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'ItemNotFound', Text__c = 'Item Not Found Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'BulkWholesale', Text__c = 'Bulk Wholesale Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'FillingBasket', Text__c = 'Filling Basket Message', Locale__c = 'en-gb'));
        copyTextList.add(new Chatbot_Copy_Text__c(Dialogue_Name__c = 'Test1', Dialogue_Variable_Name__c = 'LostReceipt', Text__c = 'Lost Receipt Message', Locale__c = 'en-gb'));

        
        
        insert copyTextList;

     }
}
@IsTest
public class ChatBotCopyTextUtilityTest {
     
    @IsTest
    static void testGetDialogueTexts1() {
        // Create test data
       TestDataFactory.createChatbotCopyTextsWithDIalogs();
        

        // Create input variables
        ChatBotCopyTextUtility.InputVariables inputVar = new ChatBotCopyTextUtility.InputVariables();
        inputVar.locale = 'en-gb';
        List<ChatBotCopyTextUtility.InputVariables> inputVarList = new List<ChatBotCopyTextUtility.InputVariables>();
        inputVarList.add(inputVar);
        
        

        // Call the method under test
        List<ChatBotCopyTextUtility.OutputVariables1> result = ChatBotCopyTextUtility.getDialogueTexts1(inputVarList);
 

        // Verify the result
        System.assertEquals(1, result.size(), 'Incorrect number of output variables');
        ChatBotCopyTextUtility.OutputVariables1 outVars = result[0];
        System.assertEquals('Change your mind message', outVars.ChangeMindMsg, 'Incorrect value for ChangeMindMsg');
        System.assertEquals('Check balance message', outVars.ChkBalanceMsg, 'Incorrect value for ChkBalanceMsg');
        System.assertEquals('Confused FAQ link', outVars.ConfusedFAQLink, 'Incorrect value for ConfusedFAQLink');
        System.assertEquals('Contact us link', outVars.ContactUsLink, 'Incorrect value for ContactUsLink');
        System.assertEquals('Example city message', outVars.ExampleCityMsg, 'Incorrect value for ExampleCityMsg');
        System.assertEquals('Example location question', outVars.ExampleLocationQues, 'Incorrect value for ExampleLocationQues');
        System.assertEquals('Card expired message', outVars.ExpireCardMsg, 'Incorrect value for ExpireCardMsg');
        System.assertEquals('FAQ link', outVars.FAQLink, 'Incorrect value for FAQLink');
        System.assertEquals('Faulty message', outVars.FaultyMsg, 'Incorrect value for FaultyMsg');
        System.assertEquals('Gift card link', outVars.GiftCardLink, 'Incorrect value for GiftCardLink');
        System.assertEquals('Gift card message', outVars.GiftCardMsg, 'Incorrect value for GiftCardMsg');
        System.assertEquals('Influencer link', outVars.InfluencerLink, 'Incorrect value for InfluencerLink');
        System.assertEquals('Location link', outVars.LocationLink, 'Incorrect value for LocationLink');
        System.assertEquals('Opening city message', outVars.OpeningCityMsg, 'Incorrect value for OpeningCityMsg');
        System.assertEquals('Primark Cares link', outVars.PrimarkCaresLink, 'Incorrect value for PrimarkCaresLink');
        System.assertEquals('Privacy data message', outVars.PrivacyDataMessage, 'Incorrect value for PrivacyDataMessage');
        System.assertEquals('Privacy Policy Link', outVars.PrivacyPolicyLink, 'Incorrect value for PrivacyPolicyLink');
        System.assertEquals('Track Refund Message', outVars.TrackRefundMsg, 'Incorrect value for TrackRefundMsg');
        System.assertEquals('Welcome Message', outVars.WelcomeMsg, 'Incorrect value for WelcomeMsg');
        System.assertEquals('Order Collection Message', outVars.OrderCollection1, 'Incorrect value for OrderCollection1');
        System.assertEquals('Uncollected Items Message', outVars.UncollectedItems1, 'Incorrect value for UncollectedItems1');
        System.assertEquals('Additional Purchase Message', outVars.Additional_Purchase1, 'Incorrect value for Additional_Purchase1');
        System.assertEquals('Collection Message', outVars.Collection1, 'Incorrect value for Collection1');
        System.assertEquals('Click Collect Stores Message', outVars.Click_Collect_Stores1, 'Incorrect value for Click_Collect_Stores1');
        System.assertEquals('Covid Restrictions Message', outVars.Covid_Restrictions1, 'Incorrect value for Covid_Restrictions1');
        
        
    }
    
    @isTest
    static void testGetDialogueTexts2() {
        
        TestDataFactory.createChatbotCopyTextsWithDIalogs();
        // Create input variables
        ChatBotCopyTextUtility2.InputVariables inputVar2 = new ChatBotCopyTextUtility2.InputVariables();
        inputVar2.locale = 'en-gb';
        List<ChatBotCopyTextUtility2.InputVariables> inputVarList2 = new List<ChatBotCopyTextUtility2.InputVariables>();
        inputVarList2.add(inputVar2);
        
        List<ChatBotCopyTextUtility2.OutputVariables2> result2 = ChatBotCopyTextUtility2.getDialogueTexts2(inputVarList2);
        
        // Verify the result
        System.assertEquals(1, result2.size(), 'Incorrect number of output variables');
        ChatBotCopyTextUtility2.OutputVariables2 outVars2 = result2[0];
        System.assertEquals('Gift Card Return Message', outVars2.GiftCardsReturns1, 'Incorrect value for GiftCardsReturns1');
        System.assertEquals('Lost Gift Card Message', outVars2.LostGiftCard1, 'Incorrect value for LostGiftCard1');
        System.assertEquals('Spend Gift Card Return Message', outVars2.SpendGiftCard1, 'Incorrect value for SpendGiftCard1');
        System.assertEquals('Refund Exchange Message', outVars2.RefundExchange1, 'Incorrect value for RefundExchange1');
        System.assertEquals('Store Information Message', outVars2.StoreInformation1, 'Incorrect value for StoreInformation1');
        System.assertEquals('Stock Query Message', outVars2.StockQueries1, 'Incorrect value for StockQueries1');
        System.assertEquals('Unsubscribe Message', outVars2.Unsubscribe1, 'Incorrect value for Unsubscribe1');
        System.assertEquals('Email Not Recieved1 Message', outVars2.EmailNotReceived1, 'Incorrect value for EmailNotReceived1');
        System.assertEquals('Email Not Recieved2 Message', outVars2.EmailNotReceived2, 'Incorrect value for EmailNotReceived2');
        System.assertEquals('Sign Up Message', outVars2.SignUp1, 'Incorrect value for SignUp1');
        System.assertEquals('My Account support Message', outVars2.MyAccountSupport1, 'Incorrect value for MyAccountSupport1');
        System.assertEquals('Marketing Emails', outVars2.MarketingEmails1, 'Incorrect value for MarketingEmails1');
        System.assertEquals('Preferences', outVars2.Preferences1, 'Incorrect value for Preferences1');
        System.assertEquals('Shopping List', outVars2.ShoppingList1, 'Incorrect value for ShoppingList1');
        System.assertEquals('Reset password', outVars2.ResetPassword1, 'Incorrect value for ResetPassword1');
        System.assertEquals('Preferred Store', outVars2.PreferredStore1, 'Incorrect value for PreferredStore1');
        System.assertEquals('Email Not Loading', outVars2.EmailNotLoading1, 'Incorrect value for EmailNotLoading1');
        System.assertEquals('Lost Email Confirmation', outVars2.LostEmailConfirmation1, 'Incorrect value for LostEmailConfirmation1');
        System.assertEquals('Restricted Numbers', outVars2.RestrictedNumbers1, 'Incorrect value for RestrictedNumbers1');
        System.assertEquals('Missing Items Message', outVars2.MissingItems1, 'Incorrect value for MissingItems1');
        System.assertEquals('Wrong Items Message', outVars2.WrongItems1, 'Incorrect value for WrongItems1');
        System.assertEquals('Online Order Placement1 Message', outVars2.OnlineOrderPlacement1, 'Incorrect value for OnlineOrderPlacement1');
        System.assertEquals('Guest Checkout1 Message', outVars2.GuestCheckout1, 'Incorrect value for GuestCheckout1');
        System.assertEquals('Expected Delivery Time1 Message', outVars2.ExpectedDeliveryTime1, 'Incorrect value for ExpectedDeliveryTime1');
        System.assertEquals('Location1 Message', outVars2.Location1, 'Incorrect value for Location1');
        System.assertEquals('Contact Details1 Message', outVars2.ContactDetails1, 'Incorrect value for ContactDetails1');
        System.assertEquals('Minimum Spend1 Message', outVars2.MinimumSpend1, 'Incorrect value for MinimumSpend1');
        
        
    }
    
    @isTest
    static void testGetDialogueTexts3(){
        TestDataFactory.createChatbotCopyTextsWithDIalogs();
        
         // Create input variables
        ChatBotCopyTextUtility3.InputVariables inputVar3 = new ChatBotCopyTextUtility3.InputVariables();
        inputVar3.locale = 'en-gb';
        List<ChatBotCopyTextUtility3.InputVariables> inputVarList3 = new List<ChatBotCopyTextUtility3.InputVariables>();
        inputVarList3.add(inputVar3);
        
        List<ChatBotCopyTextUtility3.OutputVariables3> result3 = ChatBotCopyTextUtility3.getDialogueTexts3(inputVarList3);
        
          // Verify the result
        System.assertEquals(1, result3.size(), 'Incorrect number of output variables');
        ChatBotCopyTextUtility3.OutputVariables3 outVars3 = result3[0];
        System.assertEquals('Store Opening hours', outVars3.StoreOpeningHours1, 'Incorrect value for StoreOpeningHours1');
        System.assertEquals('Vat Number', outVars3.VATNumber1, 'Incorrect value for VATNumber1');
        System.assertEquals('Store Stock Availability', outVars3.StoreStockAvailability1, 'Incorrect value for StoreStockAvailability1');
        System.assertEquals('Store Reservation', outVars3.StoreReservation1, 'Incorrect value for StoreReservation1');
        System.assertEquals('Restock Message', outVars3.Restocks1, 'Incorrect value for Restocks1');
        System.assertEquals('Low stock Message', outVars3.LowStock1, 'Incorrect value for LowStock1');
        System.assertEquals('Transfer to Agent1 Message', outVars3.TransferToAgent1, 'Incorrect value for TransferToAgent1');
        System.assertEquals('Transfer to Agent2 Message', outVars3.TransferToAgent2, 'Incorrect value for TransferToAgent2');
        System.assertEquals('Transfer to Agent3 Message', outVars3.TransferToAgent3, 'Incorrect value for TransferToAgent3');
        System.assertEquals('Transfer to Agent4 Message', outVars3.TransferToAgent4, 'Incorrect value for TransferToAgent4');
        System.assertEquals('End Chat Message', outVars3.EndChat1, 'Incorrect value for EndChat1');
        System.assertEquals('No Agent Message', outVars3.NoAgent1, 'Incorrect value for NoAgent1');
        System.assertEquals('Error handler Message', outVars3.ErrorHandler1, 'Incorrect value for ErrorHandler1');
        System.assertEquals('Contact Us OutsideBH1', outVars3.ContactUsOutsideBH1, 'Incorrect value for ContactUsOutsideBH1');
        System.assertEquals('Contact Us MaxWT1', outVars3.ContactUsMaxWT1, 'Incorrect value for ContactUsMaxWT1');
        System.assertEquals('Contact Us Last15Min1', outVars3.ContactUsLast15Min1, 'Incorrect value for ContactUsLast15Min1');
        System.assertEquals('Sizing Message', outVars3.Sizing, 'Incorrect value for Sizing');
        System.assertEquals('Receipt Survey Message', outVars3.ReceiptSurvey, 'Incorrect value for ReceiptSurvey');
        System.assertEquals('Multiple Stores OpeningHrs1 Message', outVars3.MultipleStoresOpeningHrs1, 'Incorrect value for MultipleStoresOpeningHrs1');
        System.assertEquals('Payment Methods Message', outVars3.PaymentMethods, 'Incorrect value for PaymentMethods');
        System.assertEquals('Seasonal Sales OpeningHrs1 Message', outVars3.SeasonalSales, 'Incorrect value for SeasonalSales');
        System.assertEquals('Gifts Cards Pin Message', outVars3.GiftsCardsPin, 'Incorrect value for GiftsCardsPin');
        System.assertEquals('Item Not Found Message', outVars3.ItemNotFound, 'Incorrect value for ItemNotFound');
        System.assertEquals('Bulk Wholesale Message', outVars3.BulkWholesale, 'Incorrect value for BulkWholesale');
        System.assertEquals('Filling Basket Message', outVars3.FillingBasket, 'Incorrect value for FillingBasket');
        System.assertEquals('Lost Receipt Message', outVars3.LostReceipt, 'Incorrect value for LostReceipt');
        
        
        
        
    }
        
}
public with sharing class ChatBotCopyTextUtility2 {
    
    public class OutputVariables2 {
      
        @InvocableVariable(required=true)
        public string GiftCardsReturns1;
        @InvocableVariable(required=true)
        public string LostGiftCard1;
        @InvocableVariable(required=true)
        public string SpendGiftCard1;
        @InvocableVariable(required=true)
        public string RefundExchange1;
        @InvocableVariable(required=true)
        public string StoreInformation1;
        @InvocableVariable(required=true)
        public string StockQueries1;
        @InvocableVariable(required=true)
        public string Unsubscribe1;
        @InvocableVariable(required=true)
        public string EmailNotReceived1;
        @InvocableVariable(required=true)
        public string EmailNotReceived2;
        @InvocableVariable(required=true)
        public string SignUp1;
        @InvocableVariable(required=true)
        public string MyAccountSupport1;
        @InvocableVariable(required=true)
        public string MarketingEmails1;
        @InvocableVariable(required=true)
        public string Preferences1;
        @InvocableVariable(required=true)
        public string ShoppingList1;
        @InvocableVariable(required=true)
        public string ResetPassword1;
        @InvocableVariable(required=true)
        public string PreferredStore1;
        @InvocableVariable(required=true)
        public string EmailNotLoading1;
        @InvocableVariable(required=true)
        public string LostEmailConfirmation1;
        @InvocableVariable(required=true)
        public string RestrictedNumbers1;
        @InvocableVariable(required=true)
        public string MissingItems1;
        @InvocableVariable(required=true)
        public string WrongItems1;
        @InvocableVariable(required=true)
        public string OnlineOrderPlacement1;
        @InvocableVariable(required=true)
        public string OnlineOrderPlacement2;
        @InvocableVariable(required=true)
        public string OnlineOrderPlacement3;
        @InvocableVariable(required=true)
        public string GuestCheckout1;
        @InvocableVariable(required=true)
        public string ExpectedDeliveryTime1;
        @InvocableVariable(required=true)
        public string Location1;
        @InvocableVariable(required=true)
        public string Location2;
        @InvocableVariable(required=true)
        public string ContactDetails1;
        @InvocableVariable(required=true)
        public string MinimumSpend1;
        @InvocableVariable(required=true)
        public string UpdateOrder1;
        @InvocableVariable(required=true)
        public string ChangeofMind1;
        @InvocableVariable(required=true)
        public string FaultyItems1;
        @InvocableVariable(required=true)
        public string UnderwearReturns1;
        @InvocableVariable(required=true)
        public string NoReceipt1;
        @InvocableVariable(required=true)
        public string NoReceipt2;
        @InvocableVariable(required=true)
        public string StoreContactDetails1;
        @InvocableVariable(required=true)
        public string StoreLocation1;
        @InvocableVariable(required=true)
        public string StoreLocation2;
        
      }

      
  
    public class InputVariables {
        @InvocableVariable(required=true)
        public String locale;
    }

      @InvocableMethod(label='Get Dialogue Texts 2')
      public static List<OutputVariables2> getDialogueTexts2(List<InputVariables> inputVarList) {
  
        List<OutputVariables2> outVarsList = new List<OutputVariables2>();
        Set<String> localeSet = new Set<String>();
  
        for(InputVariables inVar : inputVarList){
          localeSet.add(inVar.locale);
        }
  
        if(localeSet != null && !localeSet.isEmpty()){
          List<Chatbot_Copy_Text__c> cctList = [SELECT id,Dialogue_Name__c,Text__c,Dialogue_Variable_Name__c FROM Chatbot_Copy_Text__c WHERE Locale__c in :localeSet];
          
          OutputVariables2 outVars = new OutputVariables2();
  
          for(Chatbot_Copy_Text__c cct : cctList){
            if(cct.Dialogue_Variable_Name__c  == 'GiftCardsReturns1'){
              outVars.GiftCardsReturns1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'LostGiftCard1'){
              outVars.LostGiftCard1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'SpendGiftCard1'){
              outVars.SpendGiftCard1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'RefundExchange1'){
              outVars.RefundExchange1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'StoreInformation1'){
              outVars.StoreInformation1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'StockQueries1'){
              outVars.StockQueries1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'Unsubscribe1'){
              outVars.Unsubscribe1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'EmailNotReceived1'){
              outVars.EmailNotReceived1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'EmailNotReceived2'){
              outVars.EmailNotReceived2 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'SignUp1'){
              outVars.SignUp1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'MyAccountSupport1'){
              outVars.MyAccountSupport1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'MarketingEmails1'){
              outVars.MarketingEmails1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'Preferences1'){
              outVars.Preferences1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'ShoppingList1'){
              outVars.ShoppingList1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'ResetPassword1'){
              outVars.ResetPassword1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'PreferredStore1'){
              outVars.PreferredStore1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'EmailNotLoading1'){
              outVars.EmailNotLoading1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'LostEmailConfirmation1'){
              outVars.LostEmailConfirmation1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'RestrictedNumbers1'){
              outVars.RestrictedNumbers1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'MissingItems1'){
              outVars.MissingItems1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'WrongItems1'){
              outVars.WrongItems1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'OnlineOrderPlacement1'){
              outVars.OnlineOrderPlacement1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'OnlineOrderPlacement2'){
              outVars.OnlineOrderPlacement2 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'OnlineOrderPlacement3'){
              outVars.OnlineOrderPlacement3 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'GuestCheckout1'){
              outVars.GuestCheckout1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'ExpectedDeliveryTime1'){
              outVars.ExpectedDeliveryTime1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'Location1'){
              outVars.Location1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'Location2'){
              outVars.Location2 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'ContactDetails1'){
              outVars.ContactDetails1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'MinimumSpend1'){
              outVars.MinimumSpend1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'UpdateOrder1'){
              outVars.UpdateOrder1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'ChangeofMind1'){
              outVars.ChangeofMind1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'FaultyItems1'){
              outVars.FaultyItems1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'UnderwearReturns1'){
              outVars.UnderwearReturns1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'NoReceipt1'){
              outVars.NoReceipt1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'NoReceipt2'){
              outVars.NoReceipt2 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'StoreContactDetails1'){
              outVars.StoreContactDetails1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'StoreLocation1'){
              outVars.StoreLocation1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'StoreLocation2'){
              outVars.StoreLocation2 =  cct.Text__c;
              }
          }
          outVarsList.add(outVars);
        }
        return outVarsList; 
      }
    
}
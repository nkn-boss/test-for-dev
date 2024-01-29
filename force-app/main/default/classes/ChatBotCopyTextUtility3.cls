public with sharing class ChatBotCopyTextUtility3 {

    
    public class OutputVariables3 {
        @InvocableVariable(required=true)
        public string StoreOpeningHours1;
        @InvocableVariable(required=true)
        public string VATNumber1;
        @InvocableVariable(required=true)
        public string StoreStockAvailability1;
        @InvocableVariable(required=true)
        public string StoreStockAvailability2;
        @InvocableVariable(required=true)
        public string StoreReservation1;
        @InvocableVariable(required=true)
        public string StoreReservation2;
        @InvocableVariable(required=true)
        public string Restocks1;
        @InvocableVariable(required=true)
        public string Restocks2;
        @InvocableVariable(required=true)
        public string LowStock1;
        @InvocableVariable(required=true)
        public string LowStock2;
        @InvocableVariable(required=true)
        public string TransferToAgent1;
        @InvocableVariable(required=true)
        public string TransferToAgent2;
        @InvocableVariable(required=true)
        public string TransferToAgent3;
        @InvocableVariable(required=true)
        public string TransferToAgent4;
        @InvocableVariable(required=true)
        public string TransferToAgent5;
        @InvocableVariable(required=true)
        public string TransferToAgent6;
        @InvocableVariable(required=true)
        public string TransferToAgent7;
        @InvocableVariable(required=true)
        public string TransferToAgent8;
        @InvocableVariable(required=true)
        public string EndChat1;
        @InvocableVariable(required=true)
        public string NoAgent1;
        @InvocableVariable(required=true)
        public string ErrorHandler1;
        @InvocableVariable(required=true)
        public string ContactUsOutsideBH1;
        @InvocableVariable(required=true)
        public string ContactUsMaxWT1;
        @InvocableVariable(required=true)
        public string ContactUsLast15Min1;
        @InvocableVariable(required=true)
        public string MultipleStoresLocation1;
        @InvocableVariable(required=true)
        public string MultipleStoresOpeningHrs1;
        @InvocableVariable(required=true)
        public string MultipleStoresPhoNum1;
        @InvocableVariable(required=true)
        public string Sizing;
        @InvocableVariable(required=true)
        public string ReceiptSurvey;
        @InvocableVariable(required=true)
        public string PaymentMethods;
        @InvocableVariable(required=true)
        public string SeasonalSales;
        @InvocableVariable(required=true)
        public string GiftsCardsPin;
        @InvocableVariable(required=true)
        public string ItemNotFound;
        @InvocableVariable(required=true)
        public string BulkWholesale;
        @InvocableVariable(required=true)
        public string FillingBasket;
        @InvocableVariable(required=true)
        public string LostReceipt;
      }
            
    
    public class InputVariables {
        @InvocableVariable(required=true)
        public String locale;
    }

    
    @InvocableMethod(label='Get Dialogue Texts 3')
    public static List<OutputVariables3> getDialogueTexts3(List<InputVariables> inputVarList) {

      List<OutputVariables3> outVarsList = new List<OutputVariables3>();
      Set<String> localeSet = new Set<String>();

      for(InputVariables inVar : inputVarList){
        localeSet.add(inVar.locale);
      }

      if(localeSet != null && !localeSet.isEmpty()){
        List<Chatbot_Copy_Text__c> cctList = [SELECT id,Dialogue_Name__c,Text__c,Dialogue_Variable_Name__c FROM Chatbot_Copy_Text__c WHERE Locale__c in :localeSet];
        
        OutputVariables3 outVars = new OutputVariables3();

        for(Chatbot_Copy_Text__c cct : cctList){
              
              if(cct.Dialogue_Variable_Name__c  == 'StoreOpeningHours1'){
              outVars.StoreOpeningHours1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'VATNumber1'){
              outVars.VATNumber1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'StoreStockAvailability1'){
              outVars.StoreStockAvailability1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'StoreStockAvailability2'){
              outVars.StoreStockAvailability2 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'StoreReservation1'){
              outVars.StoreReservation1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'StoreReservation2'){
              outVars.StoreReservation2 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'Restocks1'){
              outVars.Restocks1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'Restocks2'){
              outVars.Restocks2 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'LowStock1'){
              outVars.LowStock1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'LowStock2'){
              outVars.LowStock2 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'TransferToAgent1'){
              outVars.TransferToAgent1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'TransferToAgent2'){
              outVars.TransferToAgent2 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'TransferToAgent3'){
              outVars.TransferToAgent3 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'TransferToAgent4'){
              outVars.TransferToAgent4 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'TransferToAgent5'){
              outVars.TransferToAgent5 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'TransferToAgent6'){
              outVars.TransferToAgent6 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'TransferToAgent7'){
              outVars.TransferToAgent7 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'TransferToAgent8'){
              outVars.TransferToAgent8 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'EndChat1'){
              outVars.EndChat1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'NoAgent1'){
              outVars.NoAgent1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'ErrorHandler1'){
              outVars.ErrorHandler1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'ContactUsOutsideBH1'){
              outVars.ContactUsOutsideBH1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'ContactUsMaxWT1'){
              outVars.ContactUsMaxWT1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'ContactUsLast15Min1'){
              outVars.ContactUsLast15Min1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'MultipleStoresLocation1'){
              outVars.MultipleStoresLocation1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'MultipleStoresOpeningHrs1'){
              outVars.MultipleStoresOpeningHrs1 =  cct.Text__c;
              }
              if(cct.Dialogue_Variable_Name__c  == 'MultipleStoresPhoNum1'){
                outVars.MultipleStoresPhoNum1 =  cct.Text__c;
                }
              if(cct.Dialogue_Variable_Name__c  == 'Sizing'){
              outVars.Sizing =  cct.Text__c;
              }    
              if(cct.Dialogue_Variable_Name__c  == 'ReceiptSurvey'){
                outVars.ReceiptSurvey =  cct.Text__c;
                }  
              if(cct.Dialogue_Variable_Name__c  == 'PaymentMethods'){
                outVars.PaymentMethods =  cct.Text__c;
                }  
              if(cct.Dialogue_Variable_Name__c  == 'SeasonalSales'){
                outVars.SeasonalSales =  cct.Text__c;
                }   
              if(cct.Dialogue_Variable_Name__c  == 'GiftsCardsPin'){
                outVars.GiftsCardsPin =  cct.Text__c;
                }  

              if(cct.Dialogue_Variable_Name__c  == 'ItemNotFound'){
                outVars.ItemNotFound =  cct.Text__c;
                }  
              if(cct.Dialogue_Variable_Name__c  == 'BulkWholesale'){
                outVars.BulkWholesale =  cct.Text__c;
                }  
              if(cct.Dialogue_Variable_Name__c  == 'FillingBasket'){
                outVars.FillingBasket =  cct.Text__c;
                }  
              if(cct.Dialogue_Variable_Name__c  == 'LostReceipt'){
                  outVars.LostReceipt =  cct.Text__c;
                  }  
          }
        outVarsList.add(outVars);
      }

      return outVarsList; 
    }

}
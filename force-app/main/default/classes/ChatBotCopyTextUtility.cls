public with sharing class ChatBotCopyTextUtility {

    public class OutputVariables1 {
      @InvocableVariable(required=true)
      public string ChangeMindMsg;
      @InvocableVariable(required=true)
      public string ChkBalanceMsg;
      @InvocableVariable(required=true)
      public string ConfusedFAQLink;
      @InvocableVariable(required=true)
      public string ContactUsLink;
      @InvocableVariable(required=true)
      public string ExampleCityMsg;
      @InvocableVariable(required=true)
      public string ExampleLocationQues;
      @InvocableVariable(required=true)
      public string ExpireCardMsg;
      @InvocableVariable(required=true)
      public string FAQLink;
      @InvocableVariable(required=true)
      public string FaultyMsg;
      @InvocableVariable(required=true)
      public string GiftCardLink;
      @InvocableVariable(required=true)
      public string GiftCardMsg;
      @InvocableVariable(required=true)
      public string InfluencerLink;
      @InvocableVariable(required=true)
      public string LocationLink;
      @InvocableVariable(required=true)
      public string OpeningCityMsg;
      @InvocableVariable(required=true)
      public string PrimarkCaresLink;
      @InvocableVariable(required=true)
      public string PrivacyDataMessage;
      @InvocableVariable(required=true)
      public string PrivacyPolicyLink;
      @InvocableVariable(required=true)
      public string SubscribeLink;
      @InvocableVariable(required=true)
      public string TrackRefundMsg;
      @InvocableVariable(required=true)
      public string WelcomeMsg;

      @InvocableVariable(required=true)
      public string OrderCollection1;
      @InvocableVariable(required=true)
      public string OrderCollection2;
      @InvocableVariable(required=true)
      public string UncollectedItems1;
      @InvocableVariable(required=true)
      public string UncollectedItems2;
      @InvocableVariable(required=true)
      public string Additional_Purchase1;
      @InvocableVariable(required=true)
      public string Collection1;
      @InvocableVariable(required=true)
      public string Collection2;
      @InvocableVariable(required=true)
      public string Click_Collect_Stores1;
      @InvocableVariable(required=true)
      public string Click_Collect_Stores2;
      @InvocableVariable(required=true)
      public string Covid_Restrictions1;
      @InvocableVariable(required=true)
      public string Covid_Restrictions2;
      @InvocableVariable(required=true)
      public string Covid_Restrictions3;
      @InvocableVariable(required=true)
      public string Covid_Fitting_Rooms1;
      @InvocableVariable(required=true)
      public string Covid_Face_Coverings1;
      @InvocableVariable(required=true)
      public string Online_Shopping1;
      @InvocableVariable(required=true)
      public string Online_Shopping2;
      @InvocableVariable(required=true)
      public string RecruitmentCareer1;
      @InvocableVariable(required=true)
      public string PrimarkCares1;
      @InvocableVariable(required=true)
      public string One4All1;


    }
  
    public class InputVariables {
      @InvocableVariable(required=true)
      public String locale;
    }

    @InvocableMethod(label='Get Dialogue Texts 1')
    public static List<OutputVariables1> getDialogueTexts1(List<InputVariables> inputVarList) {

      List<OutputVariables1> outVarsList = new List<OutputVariables1>();
      Set<String> localeSet = new Set<String>();

      for(InputVariables inVar : inputVarList){
        localeSet.add(inVar.locale);
      }

      if(localeSet != null && !localeSet.isEmpty()){
        List<Chatbot_Copy_Text__c> cctList = [SELECT id,Dialogue_Name__c,Text__c,Dialogue_Variable_Name__c FROM Chatbot_Copy_Text__c WHERE Locale__c in :localeSet];
        
        OutputVariables1 outVars = new OutputVariables1();

        for(Chatbot_Copy_Text__c cct : cctList){
          if(cct.Dialogue_Variable_Name__c  == 'ChangeMindMsg'){
            outVars.ChangeMindMsg =  cct.Text__c;
          }
          if(cct.Dialogue_Variable_Name__c  == 'ChkBalanceMsg'){
            outVars.ChkBalanceMsg =  cct.Text__c;
          }
          if(cct.Dialogue_Variable_Name__c  == 'ConfusedFAQLink'){
            outVars.ConfusedFAQLink =  cct.Text__c;
          }
          if(cct.Dialogue_Variable_Name__c  == 'ContactUsLink'){
            outVars.ContactUsLink =  cct.Text__c;
          }
          if(cct.Dialogue_Variable_Name__c  == 'ExampleCityMsg'){
            outVars.ExampleCityMsg =  cct.Text__c;
          }
          if(cct.Dialogue_Variable_Name__c  == 'ExampleLocationQues'){
            outVars.ExampleLocationQues =  cct.Text__c;
          }
          if(cct.Dialogue_Variable_Name__c  == 'ExpireCardMsg'){
            outVars.ExpireCardMsg =  cct.Text__c;
          }
          if(cct.Dialogue_Variable_Name__c  == 'FAQLink'){
            outVars.FAQLink =  cct.Text__c;
          }
          if(cct.Dialogue_Variable_Name__c  == 'FaultyMsg'){
            outVars.FaultyMsg =  cct.Text__c;
          }
          if(cct.Dialogue_Variable_Name__c  == 'GiftCardLink'){
            outVars.GiftCardLink =  cct.Text__c;
          }
          if(cct.Dialogue_Variable_Name__c  == 'GiftCardMsg'){
            outVars.GiftCardMsg =  cct.Text__c;
          }
          if(cct.Dialogue_Variable_Name__c  == 'InfluencerLink'){
            outVars.InfluencerLink =  cct.Text__c;
          }
          if(cct.Dialogue_Variable_Name__c  == 'LocationLink'){
            outVars.LocationLink =  cct.Text__c;
          }
          if(cct.Dialogue_Variable_Name__c  == 'OpeningCityMsg'){
            outVars.OpeningCityMsg =  cct.Text__c;
          }
          if(cct.Dialogue_Variable_Name__c  == 'PrimarkCaresLink'){
            outVars.PrimarkCaresLink =  cct.Text__c;
          }
          if(cct.Dialogue_Variable_Name__c  == 'PrivacyDataMessage'){
            outVars.PrivacyDataMessage =  cct.Text__c;
          }
          if(cct.Dialogue_Variable_Name__c  == 'PrivacyPolicyLink'){
            outVars.PrivacyPolicyLink =  cct.Text__c;
          }
          if(cct.Dialogue_Variable_Name__c  == 'SubscribeLink'){
            outVars.SubscribeLink =  cct.Text__c;
          }
          if(cct.Dialogue_Variable_Name__c  == 'TrackRefundMsg'){
            outVars.TrackRefundMsg =  cct.Text__c;
          }
          if(cct.Dialogue_Variable_Name__c  == 'WelcomeMsg'){
            outVars.WelcomeMsg =  cct.Text__c;
          }

          if(cct.Dialogue_Variable_Name__c  == 'OrderCollection1'){
            outVars.OrderCollection1 =  cct.Text__c;
            }
            if(cct.Dialogue_Variable_Name__c  == 'OrderCollection2'){
            outVars.OrderCollection2 =  cct.Text__c;
            }
            if(cct.Dialogue_Variable_Name__c  == 'UncollectedItems1'){
            outVars.UncollectedItems1 =  cct.Text__c;
            }
            if(cct.Dialogue_Variable_Name__c  == 'UncollectedItems2'){
            outVars.UncollectedItems2 =  cct.Text__c;
            }
            if(cct.Dialogue_Variable_Name__c  == 'Additional_Purchase1'){
            outVars.Additional_Purchase1 =  cct.Text__c;
            }
            if(cct.Dialogue_Variable_Name__c  == 'Collection1'){
            outVars.Collection1 =  cct.Text__c;
            }
            if(cct.Dialogue_Variable_Name__c  == 'Collection2'){
            outVars.Collection2 =  cct.Text__c;
            }
            if(cct.Dialogue_Variable_Name__c  == 'Click_Collect_Stores1'){
            outVars.Click_Collect_Stores1 =  cct.Text__c;
            }
            if(cct.Dialogue_Variable_Name__c  == 'Click_Collect_Stores2'){
            outVars.Click_Collect_Stores2 =  cct.Text__c;
            }
            if(cct.Dialogue_Variable_Name__c  == 'Covid_Restrictions1'){
            outVars.Covid_Restrictions1 =  cct.Text__c;
            }
            if(cct.Dialogue_Variable_Name__c  == 'Covid_Restrictions2'){
            outVars.Covid_Restrictions2 =  cct.Text__c;
            }
            if(cct.Dialogue_Variable_Name__c  == 'Covid_Restrictions3'){
            outVars.Covid_Restrictions3 =  cct.Text__c;
            }
            if(cct.Dialogue_Variable_Name__c  == 'Covid_Fitting_Rooms1'){
            outVars.Covid_Fitting_Rooms1 =  cct.Text__c;
            }
            if(cct.Dialogue_Variable_Name__c  == 'Covid_Face_Coverings1'){
            outVars.Covid_Face_Coverings1 =  cct.Text__c;
            }
            if(cct.Dialogue_Variable_Name__c  == 'Online_Shopping1'){
            outVars.Online_Shopping1 =  cct.Text__c;
            }
            if(cct.Dialogue_Variable_Name__c  == 'Online_Shopping2'){
            outVars.Online_Shopping2 =  cct.Text__c;
            }
            if(cct.Dialogue_Variable_Name__c  == 'RecruitmentCareer1'){
            outVars.RecruitmentCareer1 =  cct.Text__c;
            }
            if(cct.Dialogue_Variable_Name__c  == 'PrimarkCares1'){
            outVars.PrimarkCares1 =  cct.Text__c;
            }
            if(cct.Dialogue_Variable_Name__c  == 'One4All1'){
            outVars.One4All1 =  cct.Text__c;
            }
        }
        outVarsList.add(outVars);
      }
      return outVarsList; 
    }

  }
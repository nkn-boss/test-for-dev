/**
 * @Project : Primark
 * @Author  : DimitarMilev
 * @Date    : 19/04/2022
 * @description : invocable method convert lead to account
 * ************************************************************************************************
 * Name                     Date            Comments
 * Nitin K Nayan (EPAM)     26-DEC-2022     CRM-619 - as part of the Code Refatroring for Salesfroce Code Analyzer
 */
global without sharing class LeadInvocableHandler {

    /**
    * @description Invocable Mehtod called from FLOW to Convert the Lead.
    * @author DimitarMilev
    * @param  accounts 
    **/
    @InvocableMethod(label='Convert Leads' description='convert existing leads to person accounts')
    global static void convertLeads(List<String> accounts) {
    
        //System.debug(accounts);
        List<Lead> dupLeads = [SELECT Id,Email FROM Lead WHERE IsConverted = false and Id IN :accounts WITH SECURITY_ENFORCED ];
        //System.debug(dupLeads);  
        List<Individual> leadIndividuals = [SELECT Id,Account_Name__c,Country__c,Lead__c from Individual where Lead__c IN:dupLeads WITH SECURITY_ENFORCED ];
        Set<Id> leadIds = new Set<Id>();
        if(!dupLeads.isEmpty()) {

            List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
            for(Lead lead : dupLeads){
                Database.LeadConvert lc = new database.LeadConvert();
                lc.setLeadId(lead.Id);
                lc.convertedStatus = 'Qualified';
                lc.setDoNotCreateOpportunity(true);
                leadConverts.add(lc);
            }
        
            //Convert the existing leads
            Database.LeadConvertResult[] lcrList = null;
            try{
                lcrList = Database.convertLead(leadConverts);
            } 
            catch(Exception e) {
                CustomException.logException(e);
            }
            
            if(lcrList != null) {                
                for(Database.LeadConvertResult lctemp : lcrList) {
                    Id acc = lctemp.getLeadId();
                    leadIds.add(acc);
                }       
            }
        }
        updateExistingIndividuals(leadIndividuals,leadIds);
    }

    /**
    * @description To Updated the Existing Individuals linked with the Lead.
    * @author DimitarMilev
    * @param  leadInd 
    *@param   convertedLeads
    **/
    public static void updateExistingIndividuals (List<Individual> leadInd,Set<Id> convertedLeads) {  
        try{
            List<Individual> updInd = new List<Individual>();
            if(!leadInd.isEmpty() && !convertedLeads.isEmpty()) {
                for(Lead ld : [SELECT Id, ConvertedAccountId from Lead where Id IN: convertedLeads WITH SECURITY_ENFORCED]) {
                    for(Individual ind : leadInd) {
                        if(Ind.Lead__c == ld.Id) {
                            Ind.Account_Name__c = ld.ConvertedAccountId;
                            updInd.add(Ind);
                        }
                    }
                }
                if(!updInd.isEmpty()){
                    //update updInd; REMOVED AS PART OF THE CODE REFACTROING.
                    //Added as part of the CODE REFACTORING. 
                    DML_CRUDEnforce_Utility.dmlUpdate(updInd);
                }
            }
        } catch(Exception e) {
            CustomException.logException(e);
        }

    } 

}
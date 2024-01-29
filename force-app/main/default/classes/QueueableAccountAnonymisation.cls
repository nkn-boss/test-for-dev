public with sharing class QueueableAccountAnonymisation implements System.Queueable, Database.AllowsCallouts{
   
    
        /*public String objectname;
        public QueueableAccountAnonymisation( String objectname){
            objectname=objectname;
      
        }*/

        
     Map<Id,String> idEmailMap = new Map<Id,String>();
     List<Account> accountsToUpdate = new List<Account>();

    
    public void execute(System.QueueableContext context){
        DateTime dateToday = DateTime.now();
        Datetime retentionDate = dateToday.addYears(-2);
        String formattedDate = retentionDate.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
        System.debug(formattedDate);
       // String query = 'SELECT Id, (SELECT Id FROM Cases) FROM Account WHERE LastModifiedDate < ' + formattedDate + ' LIMIT 1';
       String query = 'SELECT Id,Is_CS_Anonymised__c,Phone, Is_MC_Anonymised__c,PersonEmail,Date_of_Birth__c,PersonBirthdate,MiddleName,FirstName,PersonMobilePhone,LastName,(SELECT Id FROM Cases) FROM Account WHERE LastModifiedDate < 2023-08-22T10:47:00.891+0100  ORDER BY LastModifiedDate  Desc  limit 1';

        List<Account> accountList=Database.query(query); 
       
        Map<Id, List<Case>> accountIdToCasesMap = new Map<Id, List<Case>>();

        try{
            for (Account acc: accountList){
                accountIdToCasesMap.put(acc.Id, acc.Cases);
            }
            for (Account acc: accountList){
                List<Case> associatedCases = accountIdToCasesMap.get(acc.Id);
                    if(acc.Is_CS_Anonymised__c ==True){
                    acc.PersonEmail	= '';
                    acc.PersonMobilePhone ='';
                    acc.Phone='';
                    acc.LastName	= acc.Id+'@noreply@primark.com';
                    acc.FirstName='';
                    acc.MiddleName='';
                    acc.PersonBirthdate=null;
                    acc.Date_of_Birth__c=null;
                    acc.Is_MC_Anonymised__c = true;
                }
                else{
                    if (associatedCases == null || associatedCases.isEmpty()){
                        acc.PersonEmail	= '';
                        acc.PersonMobilePhone ='';
                        acc.Phone='';
                        acc.LastName	= acc.Id+'noreply@primark.com';
                        acc.FirstName='';
                        acc.MiddleName='';
                        acc.PersonBirthdate=null;
                        acc.Date_of_Birth__c=null;
                        acc.Is_MC_Anonymised__c = true;

                }
                else{
                    acc.Is_MC_Anonymised__c = true;

                }
                
            }
            accountsToUpdate.add(acc);
            idEmailMap.put(acc.Id,acc.PersonEmail);
        }
            if (!idEmailMap.isEmpty()) {
                MarketingCloudIntegrationUtility.sendRequest(idEmailMap);
            }

            if(!accountsToUpdate.isEmpty()){
                Database.update(accountsToUpdate, true);
                }
        }
        catch(Exception e){
            CustomException.logException(e);

        }
    }
        


}
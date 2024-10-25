public with sharing class handlerOppCLosedOnAccount {

    public static void handleClosedOpportunity(List<Account> lstAcc , Map<Id,Account> accMap){
        Set<Id> acIds =new Set<Id>();
        if (!lstAcc.isEmpty()) {
            for(Account acc : lstAcc){
                if(acc.Close_All_Opp__c == true && accMap.containsKey(acc.Id) && accMap.get(acc.Id).Close_All_Opp__c == false) {
                    acIds.add(acc.Id);
                }
            }
        }
       
    List<Opportunity> oppList =[SELECT Id,Probability,StageName
                                     FROM Opportunity 
                                     WHERE 
                                     AccountId IN: acIds AND Probability >=70 
                                     AND StageName!='Closed Won'];
         List<Opportunity> opp = new  List<Opportunity>();
          for(Opportunity opps : oppList) {
                opps.StageName = 'Closed Won';
                opps.CloseDate = Date.today();
                opp.add(opps);
            }

            if (!opp.isEmpty()) {
                update opp;
            }
    }
}
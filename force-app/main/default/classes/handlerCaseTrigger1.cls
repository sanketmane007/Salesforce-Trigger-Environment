/*
  Here we can handle Case Trigger- Update Account Fies as case Field when record is inserted.

*/
public with sharing class handlerCaseTrigger1 {  
   public static void methodToUpdate(List<Case> caseList){
    Set<Id> accIds =new Set<Id>();
    if(!caseList.isEmpty())
    for (Case caseVal : caseList) {
        if (caseVal.AccountId != null) {
            accIds.add(caseVal.AccountId);  
        }
    }

    Map<Id,Account> mapAcc =new Map<Id,Account>([SELECT Id,Latest_Created_Case_Number__c
    FROM Account WHERE Id IN: accIds]);

    Map<Id,Account> updateAccount =new Map<Id,Account>();
      if(!caseList.isEmpty()){

          for(Case cs : caseList){
            Account ac =mapAcc.get(cs.AccountId);
            
            if (ac.Latest_Created_Case_Number__c !=cs.Id ) {
              ac.Latest_Created_Case_Number__c = cs.Id;
              updateAccount.put(ac.Id, ac);
            } 
          }
      }

      if (!updateAccount.isEmpty()) {
        update updateAccount.values();
      }

   }
}
// This Class Called From AllCaseTrigger 
public with sharing class HandlerUpdateAccountRatingFromCases {

    public static void hadleUpdateAccount(List<Case> lstCase,Map<Id,Case> oldMapCase){

        Set<Id> accIds = new Set<Id>();

        for (Case cas : lstCase) {
            
            if (oldMapCase != null) {
                if (cas.AccountId != oldMapCase.get(cas.Id).AccountId) {
                    accIds.add(cas.AccountId);
                    accIds.add(oldMapCase.get(cas.Id).AccountId);
                    
                }else {
                    accIds.add(cas.AccountId);
                }
            }else {
                accIds.add(cas.AccountId);
            }
        }
    
    Map<Id,Integer> accIdandInteger = new Map<Id,Integer>();
    List<Account> acclistUpdate =new List<Account>();
    List<AggregateResult> lstAggr =[SELECT Count(Id) caseIds,AccountId accids FROM Case 
                                    WHERE AccountId IN: accIds AND Is_Closed__c = true  
                                    GROUP BY AccountId];
       
    for (AggregateResult caseValue : lstAggr) {
        Id accId = (Id)caseValue.get('accids');
        Integer caseCount = (Integer)caseValue.get('caseIds');
        accIdandInteger.put(accId,caseCount);
    }

    List<Account> accIdsList = [SELECT Id,Rating FROM Account WHERE 
                                Id IN: accIds];

        if (!accIdsList.isEmpty()) {
                for (Account acc : accIdsList) {
                    String ratingValue;
                    if (accIdandInteger.get(acc.Id) <2) {
                        ratingValue = 'Cold';
                    }else if(accIdandInteger.get(acc.Id) > 2){
                        ratingValue = 'Warm';
                    }else if(accIdandInteger.get(acc.Id) > 5){
                        ratingValue = 'Hot';
                    }

                    Account acc1 =new Account();
                    acc1.id = acc.Id;
                    acc1.Rating = ratingValue;
                    acclistUpdate.add(acc1);

                }
        }

        if (!acclistUpdate.isEmpty()) {
            update acclistUpdate;
        }
    }
}
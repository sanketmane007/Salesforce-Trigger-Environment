//THis Calll Called from  AllOpportunitiesTrigger   =====================
/*
 When an opportunities linked to an Account are closed worn, 
 update the Account STatus as Closed. id f any opportunity  is not closed won update the account
 status as Open
*/
public with sharing class HandleOppAccountStatus {
   
    public static void updateAccountStatus(List<Opportunity> oppList,Map<Id,Opportunity> oldMap){
        System.debug('HandleOppAccountStatus Start Here ==>>');
        Set<Id> accIds =new Set<Id>();

        for(Opportunity opp : oppList) {            
          if (oldMap!=null) {
                if (opp.AccountId != oldMap.get(opp.Id).AccountId) {
                    accIds.add(opp.AccountId);
                    accIds.add(oldMap.get(opp.Id).AccountId);
                }else {
                    accIds.add(opp.AccountId);
                }
          }else {
            accIds.add(opp.AccountId);
          }
        }

        List<Opportunity> oppLists = [SELECT Id,AccountId,StageName FROM Opportunity
                                     WHERE AccountId IN:accIds ];

        Map<Id,List<Opportunity>> lstAccMap =new Map<Id,List<Opportunity>>();
        List<Account> lstUpdate =new List<Account>();

        for (Opportunity opp : oppLists) {

            if (!lstAccMap.containskey(opp.AccountId)) {
                 lstAccMap.put(opp.AccountId,new List<Opportunity>());   
            }
            lstAccMap.get(opp.AccountId).add(opp);

        }   

        for (Id keyMap : lstAccMap.keySet()) {
            
            List<Opportunity> lstOpp = lstAccMap.get(keyMap);
            if (!lstOpp.isEmpty()) {

                Boolean allClosedOpp = true;
                for (Opportunity opp : lstOpp) {
                    if (!opp.StageName.equals('Closed Won')) {
                        allClosedOpp = false;
                        break;
                    }
                }

                if (allClosedOpp) {
                    Account acc = new Account();
                    acc.Id = keyMap;
                    acc.Rating = 'Hot';
                    lstUpdate.add(acc);

                }else {
                    Account acc = new Account();
                    acc.Id = keyMap;
                    acc.Rating = 'Cold';
                    lstUpdate.add(acc);
                }

            }
        }


        if (!lstUpdate.isEmpty()) {
          update lstUpdate;
        }

    }
}
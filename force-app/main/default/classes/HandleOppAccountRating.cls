//This Class Called From  AllOpportunitiesTrigger  =====================
public with sharing class HandleOppAccountRating {
   
    public static void updateReatingInAccount(List<Opportunity> lstOpp,Map<Id,Opportunity> oldMapOpp){

        Set<Id> accIds =new Set<Id>();
        Map<Id,Decimal> mapData =new Map<Id,Decimal>();
        List<Account> lstUpdateAccount = new List<Account>();
        for (Opportunity opp : lstOpp) {

            if (oldMapOpp!=null) {

                if (opp.AccountId != oldMapOpp.get(opp.Id).AccountId) {
                    accIds.add(opp.AccountId);
                    accIds.add(oldMapOpp.get(opp.Id).AccountId);
                }else {
                    accIds.add(opp.AccountId);
                }
            }else {
                accIds.add(opp.AccountId);
            }
        }

       

        if (!accIds.isEmpty()) {
                List<Opportunity> oppList =[SELECT id,Amount,AccountId FROM Opportunity 
                                            WHERE AccountId IN:accIds ];
                
                    if (!oppList.isEmpty()) {
                        for (Opportunity opp : oppList) {
                            if (opp.AccountId != null) {
                        
                                if (mapData.containsKey(opp.AccountId)) {
                                    mapData.put(opp.AccountId, mapData.get(opp.AccountId)+opp.Amount);
                                }else {
                                    mapData.put(opp.AccountId, opp.Amount);
                                }
                        
                            }
                        }

                        if (!mapData.isEmpty()) {
                             for (Id idValue : mapData.keySet()) {
                                
                                       Decimal toatalAmount = mapData.get(idValue);
                                        String rating;

                                        Decimal coldValue = 50000;
                                        Decimal warmValue = 100000;

                                        if (toatalAmount <=  coldValue) {
                                            rating = 'Cold';
                                        }else if (toatalAmount <=  warmValue){
                                            rating = 'Warm';
                                        }else {
                                            rating = 'Hot';
                                        }

                                        Account acc =new Account();
                                        acc.Id = idValue;
                                        acc.Rating = rating;
                                        lstUpdateAccount.add(acc);

                             }
                        }
                    }

                    if (!lstUpdateAccount.isEmpty()) {
                        update lstUpdateAccount;
                    }
        }
    }
}
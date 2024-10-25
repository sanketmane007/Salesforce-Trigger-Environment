//=== This Is Handler class call from ==>>> AllOpportunityLineItemTrigger
public with sharing class HandlerOpportunityLineItem1 {
 
    public static void oppLineCallMethod(List<OpportunityLineItem> oopList){

        Set<Id> ParentOppIds =new Set<Id>();
        for (OpportunityLineItem oppl : oopList) {
            ParentOppIds.add(oppl.OpportunityId);
        }

        List<Opportunity> oppList =[SELECT Id,AccountId
                                     FROM Opportunity 
                                    WHERE Id IN: ParentOppIds];

        Map<Id,Integer> accMapValue = new Map<Id,Integer>();
        List<Account> accListUpdate = new List<Account>();
        if (!oppList.isEmpty()) {
            set<Id> AccountIds =new Set<Id>();
            for (Opportunity oopValue : oppList) {
                AccountIds.add(oopValue.AccountId);
            }

            List<AggregateResult> aggr =[SELECT Count(Id) idsOppline,Opportunity.AccountId accIds
                                        FROM OpportunityLineItem WHERE 
                                        Opportunity.AccountId IN:AccountIds
                                        GROUP BY  Opportunity.AccountId];
            for (AggregateResult aggValue : aggr) {
                accMapValue.put((Id)aggValue.get('accIds'), (Integer)aggValue.get('idsOppline'));
            }

            for (Id addValue : AccountIds) {
                Account acc = new Account();
                acc.Id = addValue;
                acc.Opp_Line_Items__c = accMapValue.get(addValue);
                accListUpdate.add(acc);
            }
            if (!accListUpdate.isEmpty()) {
                update accListUpdate;
            }
        }
    }
}
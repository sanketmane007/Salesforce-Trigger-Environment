// This Class Called From AllOpportunityLineItemTrigger
public with sharing class HandlerOPLUpdateCountOnAccount {
   
    public static void handleUpdateAccountCount(List<OpportunityLineItem> oppList){

        Set<Id> oppIds = new Set<Id>();
        Set<Id> accIds = new Set<Id>();
        if (!oppList.isEmpty()) {
            for (OpportunityLineItem oppLine : oppList) {
                oppIds.add(oppLine.OpportunityId);
            }
        }

        if (!oppIds.isEmpty()) {
            List<Opportunity> lstOpp =[SELECT Id,AccountId
                                         FROM Opportunity WHERE Id IN:oppIds ];
            for (Opportunity opp : lstOpp) {
                if (opp.AccountId!= null) {
                        accIds.add(opp.AccountId);
                }
            }



            List<AggregateResult> lstAgg =[SELECT count(id) cnIds,Opportunity.AccountId accIds FROM OpportunityLineItem
                                            WHERE Opportunity.AccountId != null AND
                                            Opportunity.AccountId IN: accIds
                                            AND UnitPrice>50000 GROUP BY Opportunity.AccountId];
            List<Account> accUpdate = new List<Account>();
                    for (AggregateResult lst : lstAgg) {
                        Account acc =new Account();
                        acc.Id = (Id)lst.get('accIds');
                        acc.opportunity_Line_Item_Count__c = (Decimal)lst.get('cnIds');
                        accUpdate.add(acc);
                    }

                    if (!accUpdate.isEmpty()) {
                        update accUpdate;
                    }
        }


    }
}
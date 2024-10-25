//====== This is AllOpportunitiesTrigger Handler class
public with sharing class handlerOpportunitiesTrigger {
    
    public static void handleAmountMethod(List<Opportunity> oppList,Map<Id,Opportunity> oppMap){

        Set<Id> ollIds =new Set<Id>();

        for (Opportunity opp : oppList) {
         
            if (oppMap!=null) {

                if (opp.AccountId != oppMap.get(opp.Id).AccountId) {
                    ollIds.add(opp.AccountId);
                    ollIds.add(oppMap.get(opp.Id).AccountId);  
                }else {
                    ollIds.add(opp.AccountId);
                }
               
            }else {
                ollIds.add(opp.AccountId);
            }
        }

        List<Account> accListUpdate =new List<Account>();
        List<Account> acc =[SELECT id,HIghest_Opportunity_Name__c,
        (SELECT Id,Name FROM Opportunities ORDER BY Amount DESC LIMIT 1 ) 
                        FROM Account WHERE id IN: ollIds];


            for (Account accValue : acc) {
            if (!accValue.Opportunities.isEmpty()) {
                Account accup =new Account();
                accup.Id = accValue.Id;
                accup.HIghest_Opportunity_Name__c = accValue.Opportunities[0].Name;
                accListUpdate.add(accup);
            }
            }   
            
            if (!accListUpdate.isEmpty()) {
            update accListUpdate;
            }
    }

}
public with sharing class helperupdateOpportunityTrigger_6 {
    Public static Boolean firstcall=false;
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, Account> oldOpps;
    Map<Id, Account> newOpps;
    
    // This is the constructor
    // A map of the old and new records is expected as inputs
    public helperupdateOpportunityTrigger_6(
        Map<Id, Account> oldTriggerOpps, 
        Map<Id, Account> newTriggerOpps) {
            oldOpps = oldTriggerOpps;
            newOpps = newTriggerOpps;
        }
    
    public void updateOpportunity(){
        
       // if (firstRun == true) {
            //     private static boolean flagvalue = false;       
            Set<Id> accId =new Set<Id>();
            List<Opportunity> oopListUpdate =new List<Opportunity>();
            
            if (!newOpps.isEmpty()) {
                for (Account acc : newOpps.values()) {
                    accId.add(acc.Id);
                    System.debug('acc.Id==>> 27'+acc.Id);
                }
                
                Date checkDate = date.today() - 30;
                List<Opportunity> sOPList =[SELECT Id,AccountId,Custom_Created_Date__c,StageName
                                            FROM Opportunity WHERE AccountId IN:accId];
                System.debug('sOPList==>> 34'+sOPList);
                
                System.debug('sOPList  14==>>>'+sOPList);
                if (!sOPList.isEmpty()) {
                    for (Opportunity opp : sOPList) {
                        if (opp.StageName != 'Closed Won' && opp.Custom_Created_Date__c < checkDate ) {
                            Opportunity opp1 = new Opportunity();
                            opp1.Id = opp.Id;
                            opp1.StageName = 'CLosed Lost';
                            oopListUpdate.add(opp1);
                        }
                    }                    
                    if (!oopListUpdate.isEmpty()) {
                        System.debug('oopListUpdate ==>>>'+oopListUpdate);
                        update oopListUpdate;                       
                    }
                }
            }
    }
    
}
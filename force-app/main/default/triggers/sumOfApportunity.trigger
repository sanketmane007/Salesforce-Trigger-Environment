trigger sumOfApportunity on Opportunity (after insert,after update,after delete,after undelete) {
    Set<Id> accIds =new Set<Id>();
    
    if(trigger.isAfter && (trigger.isInsert || trigger.isUndelete)){
        if(!trigger.new.isEmpty()){
            for(Opportunity opp : trigger.new){
                accIds.add(opp.AccountId);
            }
        }
    }
    
    if(trigger.isAfter && trigger.isUpdate){
        if(!trigger.new.isEmpty()){
            for(Opportunity opp1 : trigger.new){
                if(opp1.AccountId != trigger.oldMap.get(opp1.Id).AccountId){
                    accIds.add(opp1.AccountId);
                    accIds.add(trigger.oldMap.get(opp1.Id).AccountId);
                }else {
                    accIds.add(opp1.AccountId);
                }
            }
        }
    }
    
    if(trigger.isAfter && trigger.isDelete){
        if (!trigger.oldMap.isEmpty()) {
            for(Opportunity opp1 : trigger.old){
                if (opp1.AccountId!=null) {
                    accIds.add(opp1.AccountId);
                }
            }
        }
    }
    List<Account> accList =new List<Account>();
    if (!accIds.isEmpty()) {
        List<AggregateResult> aggResult =[SELECT AccountId ids,SUM(Amount) totalAm FROM Opportunity 
                                          WHERE AccountId IN: accIds GROUP BY AccountId];
        
        for (AggregateResult oppVal : aggResult) {
            Account acc =new Account();
            acc.id = (Id)oppVal.get('ids');
            acc.Total_Amount_Opp__c = String.valueOf(oppVal.get('totalAm'));
            accList.add(acc);
        }
    }
    if (!accList.isEmpty()) {
        update accList;
    }
    
}
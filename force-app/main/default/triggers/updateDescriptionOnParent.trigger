trigger updateDescriptionOnParent on Contact (after update) {
    Map<Id,Contact> conMap =new Map<Id,Contact>();
    set<Id> accountIds =new set<Id>();
    if(trigger.isUpdate && trigger.isAfter){
        for(Contact con : trigger.new){
            if((con.Description != trigger.oldMap.get(con.Id).Description) && con.AccountId !=null){
                accountIds.add(con.AccountId);
            }
        }
    }
    if(!accountIds.isEmpty()){
        System.debug('accountIds ==>>>'+accountIds);
        Map<Id,Account> accMap =new Map<Id,Account>([SELECT Id,Description FROM Account WHERE Id IN:accountIds]);
        List<Account> updateList = new List<Account>();
        
        if(!trigger.new.isEmpty()){
            for(Contact con : trigger.new){
                Account acc = accMap.get(con.AccountId);
                acc.Description = con.Description;
                updateList.add(acc);
            }
        }
        System.debug('updateListAccount ==>>>'+updateList);
        if(!updateList.isEmpty()){
            update updateList;
        }    
    }
}
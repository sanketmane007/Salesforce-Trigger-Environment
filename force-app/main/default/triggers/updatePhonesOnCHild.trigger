trigger updatePhonesOnCHild on Account (after update) {
    Map<Id,Account> accMap =new Map<Id,Account>();
    if(trigger.isUpdate && trigger.isAfter)
    {
        if(!trigger.new.isEmpty()){
            for(Account acc : trigger.new){
                System.debug('acc'+acc);
                if(acc.Phone != trigger.oldMap.get(acc.Id).Phone){
                    accMap.put(acc.Id, acc);
                    
                }
            }
        }
    }
    System.debug('accMap'+accMap);
    List<Contact> conList =new List<Contact>();
    conList = [SELECT Id,Phone,AccountId FROM Contact WHERE AccountId IN: accMap.keySet()];
    System.debug('conList'+conList);
    List<Contact> conUpdatedList =new List<Contact>();
    if(!conList.isEmpty()){
        for(Contact con : conList){
            con.Phone = accMap.get(con.AccountId).Phone;
            conUpdatedList.add(con);
        }
    }
    
    System.debug('conUpdatedList ==>>>>'+conUpdatedList);
    if(!conUpdatedList.isEmpty()){
        update conUpdatedList;
    }
}
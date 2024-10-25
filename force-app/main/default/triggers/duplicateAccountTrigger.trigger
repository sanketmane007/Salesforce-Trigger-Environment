trigger duplicateAccountTrigger on Account (before insert,before update) {
    Set<String> ListName =new Set<String>();
    if((trigger.isUpdate || trigger.IsInsert) && trigger.isBefore){
        if(!trigger.new.isEmpty()){
            for(Account acc : trigger.new){
                if (acc.Name != trigger.oldMap.get(acc.Id).Name) {
                    ListName.add(acc.Name);
                }
                
            }
            
        }   
    }
    List<Account> accList = [SELECT Id,Name FROM Account WHERE Name IN:ListName];
    Map<String,Account> lstMapAccount =new Map<String,Account>();
    if(!accList.isEmpty()){
        for(Account acc : accList){
            lstMapAccount.put(acc.Name, acc);
        }
        
        if(!trigger.new.isEmpty()){
            for(Account acc : trigger.new){
                if(lstMapAccount.containsKey(acc.Name)){
                    acc.addError('Record Is Duplicate =Duplication Error Occured From trigger -->'+acc.Name);
                }
            }
        }
    }
}
trigger getChildCountOnParentTrigger on Contact (after insert,after update,after undelete, after delete) {
    Set<Id> accIds =new Set<Id>();
    if(trigger.isAfter && (trigger.isInsert || trigger.isUndelete)){
        if(!trigger.new.isEmpty()){
            for(Contact con : trigger.new){
                accIds.add(con.AccountId);	
            }
        }
    }
    
    if(trigger.isUpdate && trigger.isAfter){
        if(!trigger.new.isEmpty()){
            for(Contact con : trigger.new){
                if(con.AccountId != trigger.oldMap.get(con.Id).AccountId){
                    if(trigger.oldMap.get(con.Id).AccountId != null){
                        accIds.add(trigger.oldMap.get(con.Id).AccountId);
                    }
                    if(con.AccountId != null){
                        accIds.add(con.AccountId);
                    }
                }
                
            }
            
        }
    }
    
    if(trigger.isDelete && trigger.isAfter){
        if(!trigger.oldMap.isEmpty()){
            for(Contact con : trigger.old){
                if(con.AccountId != null){
                    accIds.add(con.AccountId);
                }
            }
        }
    }
    
    if(!accIds.isEmpty()){
        List<Account> accList = [SELECT Id,Number_of_Contacts__c,
                                 (SELECT Id FROM Contacts)
                                 FROM Account WHERE Id IN:accIds];
        List<Account> accUpdate =new List<Account>();        
        if(!accList.isEmpty()){
            for(Account acc : accList){
                Account accUpdateValue =new Account();
                accUpdateValue.Id = acc.Id;
                accUpdateValue.Number_of_Contacts__c = String.ValueOf(acc.Contacts.size()); //acc.Contacts.size();//
                accUpdate.add(accUpdateValue);
            }
        }
        if(!accUpdate.isEmpty()){
            update accUpdate;
        }
    }
    
    
}
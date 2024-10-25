//== This is Handler Class of AllContactTrigger
public with sharing class handlerSetPrimaryContact {
 
    public static void handlerPirmaryContactMethod(List<Contact> lstCon,Map<Id,Contact> oldMapCOn){
        
        Set<Id> accIds =new Set<Id>();

        if (!lstCon.isEmpty()) {
            for (Contact con : lstCon) {                
                if (!oldMapCOn.isEmpty()) {                    
                        if (con.AccountId != oldMapCOn.get(con.Id).AccountId) {
                            accIds.add(con.AccountId);
                            accIds.add(oldMapCOn.get(con.Id).AccountId);
                        }else {
                            accIds.add(con.AccountId);
                        }
                }else {
                    accIds.add(con.AccountId);
                }
            }
        }
        Map<Id,Integer> primaryCount = new Map<Id,Integer>();
        List<Contact> conList =[SELECT Id,AccountId FROM Contact WHERE AccountId IN:accIds AND 
                                 Is_Primary_Contact__c = true];

        for (Contact con : conList) {
            if(primaryCount.get(con.AccountId)!= null){
                primaryCount.put(con.AccountId,(Integer)primaryCount.get(con.AccountId)+1);
            }else {
                primaryCount.put(con.AccountId, 1);
            }
        }

        System.debug('primaryCount===>>>>'+primaryCount);

        // if (!lstCon.isEmpty()) {
        //     for (Contact con : lstCon) {
        //         if (con.Is_Primary_Contact__c == true && primaryCount.get(con.AccountId) > 0  ) {
                    
        //         }
        //     }
        // }

        //===== This Is Implement on From Youtube  ==>>> https://www.youtube.com/watch?v=JzFvtqqLiMo
        // if(errorCon.Primary_Contact__c == true && conMap.containsKey(errorCon.AccountId)
        // && conMap.get(errorCon.AccountId) > 0 && oldMap == null)
        // {
        //     errorCon.addError('This account cannot have more than one Primary Contact');
        // }
        
        // else if((errorCon.Primary_Contact__c == true && conMap.containsKey(errorCon.AccountId)
        // && conMap.get(errorCon.AccountId) > 0) &&  oldMap.get(errorCon.Id).AccountId != errorCon.AccountId)
        // {
        //     errorCon.addError('This account cannot have more than one Primary Contact');
        // }
        
        // else if((errorCon.Primary_Contact__c == true && conMap.containsKey(errorCon.AccountId)
        // && conMap.get(errorCon.AccountId) > 0) &&  oldMap.get(errorCon.Id).Primary_Contact__c != errorCon.Primary_Contact__c )
        // {
        //     errorCon.addError('This account cannot have more than one Primary Contact');
        // }
    
    }
}
//===  AllCaseTrigger Call From Trigger ==>>>
//Calculate number of cases for each account based on their status(New, Working, Escalates)
public with sharing class HandleCaseUpdateAccount {

    public static void handleCaseUpdateAccount(List<Case> lstCase,Map<Id,Case> lsOldMap){
        Set<Id> lstCaseAccId = new Set<Id>();
        Map<Id,Integer> newMapValue =new Map<Id,Integer>();
        Map<Id,Integer> workingMapValue =new Map<Id,Integer>();
        Map<Id,Integer> escalatesMapValue =new Map<Id,Integer>();
List<Account> accUpdate =new List<Account>();
        for (Case cas : lstCase) {
           if (lsOldMap != null) {
                if (cas.AccountId != lsOldMap.get(cas.Id).AccountId) {
                    lstCaseAccId.add(cas.AccountId);
                    lstCaseAccId.add(lsOldMap.get(cas.Id).AccountId);
                }else {
                    lstCaseAccId.add(cas.AccountId);
                }
           }else {
            lstCaseAccId.add(cas.AccountId);
           }
        }

        if (!lstCaseAccId.isEmpty()) {
            
            //List<Case> casList =[SELECT Id,Status FROM Case WHERE AccountId IN: lstCaseAccId];
            List<Account> accList =[SELECT Id,Number_Escalated_Cases__c,Number_of_New_Cases__c,Number_of_working_cases__c,
                                    (SELECT Id,Status FROM Cases) 
                                    FROM Account WHERE Id IN: lstCaseAccId];
            if (!accList.isEmpty()) {
                for (Account acc : accList) {
                        newMapValue.put(acc.Id, 0);
                        workingMapValue.put(acc.Id, 0);
                        escalatesMapValue.put(acc.Id, 0);

                        for (Case caseObj : acc.Cases) {
                        if (caseObj.Status == 'New' ) {
                            newMapValue.put(acc.Id, newMapValue.get(acc.Id)+1);
                        }
                        if (caseObj.Status == 'Working' ) {
                            workingMapValue.put(acc.Id, newMapValue.get(acc.Id)+1);
                        }
                        if (caseObj.Status == 'Escalated' ) {
                            escalatesMapValue.put(acc.Id, newMapValue.get(acc.Id)+1);
                        }
                        }

                        Account acc1 =new Account();
                        acc1.Id =  acc.Id;
                        acc1.Number_Escalated_Cases__c = escalatesMapValue.get(acc1.Id);
                        acc1.Number_of_New_Cases__c = newMapValue.get(acc1.Id);
                        acc1.Number_of_working_cases__c = workingMapValue.get(acc1.Id);
                        accUpdate.add(acc1);
                }
            }

        }
        if (!accUpdate.isEmpty()) {
            update accUpdate;
        }

    }
    
}
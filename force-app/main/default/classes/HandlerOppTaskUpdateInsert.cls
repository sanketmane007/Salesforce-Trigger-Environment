public with sharing class HandlerOppTaskUpdateInsert {
    public static void updateInsertTaskMethod(List<Opportunity> lstOpp,Map<Id,Opportunity> olsMap){

        Set<Id> oppIds =new Set<Id>();
        Map<Id,Task> taskMap =new Map<Id,Task>();
        List<Task> tskList = new List<Task>();
        List<Task> updateTaskList =new List<Task>();
        List<Task> insertTaskList =new List<Task>();
      
        for(Opportunity opp : lstOpp) {
            if (opp.StageName != olsMap.get(opp.Id).StageName) {
                oppIds.add(opp.Id);
            }
        }
    
        if (!oppIds.isEmpty()) {
            tskList =[SELECT Id,OwnerId,Description,WhatId
                                 FROM Task WHERE WhatId IN: oppIds];
        }

        if (!tskList.isEmpty()) {
            for (Task tsk : tskList) {
                taskMap.put(tsk.WhatId,tsk);
            }
           
        }

        if (!lstOpp.isEmpty()) {
           for (Opportunity opp : lstOpp) {
                if (opp.StageName != olsMap.get(opp.Id).StageName) {
                   Task tsk;
                    if (taskMap.containsKey(opp.Id)) {
                        tsk = taskMap.get(opp.Id);
                        tsk.Description = opp.Name+' StageName = '+opp.StageName+' This Is New Update Value From Trigger';
                        updateTaskList.add(tsk);
                    }else {
                        tsk = new Task();
                        tsk.Priority = 'Normal';
                        tsk.Subject  = 'Follow up Opportunity - '+opp.Name;
                        tsk.Description = opp.Name+' StageName = '+opp.StageName+' This Is New Insert Value From Trigger';
                        tsk.Status   = 'In Progress';
                        tsk.WhatId  = opp.Id;
                        insertTaskList.add(tsk);
                    }
                }
           }
        }

        if (!updateTaskList.isEmpty()) {
            update updateTaskList;
        }
        
        if (!insertTaskList.isEmpty()) {
            insert insertTaskList;
        }
    }
}
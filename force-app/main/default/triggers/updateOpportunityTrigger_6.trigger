trigger updateOpportunityTrigger_6 on Account (after update) {
 
    if(!helperupdateOpportunityTrigger_6.firstcall) {
       
    if(trigger.isUpdate && trigger.isAfter){
        helperupdateOpportunityTrigger_6.firstcall = true;
        
                System.debug('helperupdateOpportunityTrigger_6 Call =====>>>');
                helperupdateOpportunityTrigger_6 opUp =new helperupdateOpportunityTrigger_6(Trigger.oldMap, Trigger.newMap);
                opUp.updateOpportunity();
                helperupdateOpportunityTrigger_6.firstcall = true;
    }   
}
}
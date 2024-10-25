trigger AllOpportunitiesTrigger on Opportunity (after insert,after update,after undelete,after delete) {

    if (trigger.isAfter && (trigger.isInsert || trigger.isUndelete)) {
        handlerOpportunitiesTrigger.handleAmountMethod(trigger.new,null);
    }else if(trigger.isAfter && trigger.isUpdate){
        handlerOpportunitiesTrigger.handleAmountMethod(trigger.new,trigger.oldMap);
    }else if(trigger.isAfter && trigger.isDelete){
        handlerOpportunitiesTrigger.handleAmountMethod(trigger.old,null);
    }

    if (trigger.isAfter && trigger.isUpdate) {
        HandlerOppTaskUpdateInsert.updateInsertTaskMethod(trigger.new, trigger.oldMap);
    }

    //== This Scenario Work need to Update Rating Again Scenario
    // if (trigger.isUpdate && trigger.isUpdate) {
    //     HandleOppAccountStatus.updateAccountStatus(trigger.new, trigger.oldMap);   
    // }

    // if (trigger.isAfter && (trigger.isInsert || trigger.isUndelete)) {
    //     HandleOppAccountStatus.updateAccountStatus(trigger.new,null);  
    // }


    if (trigger.isUpdate && trigger.isAfter ) {
        HandleOppAccountRating.updateReatingInAccount(trigger.new, trigger.oldMap);   
    }

    if (trigger.isAfter && (trigger.isInsert || trigger.isUndelete)) {
        HandleOppAccountRating.updateReatingInAccount(trigger.new,null);  
    }

    

}
trigger AllCaseTrigger on Case (after insert,after update,after delete,after undelete) {

    // if (trigger.isInsert && trigger.isAfter) {
    //     handlerCaseTrigger1.methodToUpdate(trigger.new);
    // }

    // if ((trigger.isUndelete || trigger.isInsert) && trigger.isAfter) {
    //     HandleCaseUpdateAccount.handleCaseUpdateAccount(trigger.new,null);
    // }
    // if (trigger.isUpdate && trigger.isAfter) {
    //     HandleCaseUpdateAccount.handleCaseUpdateAccount(trigger.new,trigger.oldMap);
    // }
    // if (trigger.isDelete && trigger.isAfter) {
    //     HandleCaseUpdateAccount.handleCaseUpdateAccount(trigger.old,null);
    // }

    if ((trigger.isInsert || trigger.isUndelete) && trigger.isAfter) {
        HandlerUpdateAccountRatingFromCases.hadleUpdateAccount(trigger.new, null);
    }   
    if (trigger.isUpdate && trigger.isAfter) {
        HandlerUpdateAccountRatingFromCases.hadleUpdateAccount(trigger.new, trigger.oldMap);
    }

    if (trigger.isDelete && trigger.isAfter) {
        HandlerUpdateAccountRatingFromCases.hadleUpdateAccount(trigger.old, null);
    }


}
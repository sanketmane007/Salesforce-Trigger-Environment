trigger AllAccountTrigger on Account (before delete,after update,after insert) {
    if(trigger.isDelete && trigger.isBefore){
        if(handlerBeforeDelete.firstcall == false) {
            handlerBeforeDelete del =new handlerBeforeDelete(trigger.oldMap);
            del.deleteCheckInAccount();
        }
    }

    if (trigger.isUpdate && trigger.isAfter) {
        System.debug('Email Send Trigger Start=========>>>>>>>>>>');
        handlerSendEmailTrigger.sendEMailMethod(trigger.new, trigger.oldMap);
    }

    if (trigger.isUpdate && trigger.isAfter) {
        handlerOppCLosedOnAccount.handleClosedOpportunity(trigger.new, trigger.oldMap);
    }
    
}
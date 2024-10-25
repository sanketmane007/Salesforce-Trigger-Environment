trigger AllContactTrigger on Contact (before insert,before update,after update,after insert) {
 
    if(trigger.isBefore && trigger.isInsert){
        if (!trigger.new.isEmpty()) {
            System.debug('trigger.new ===>>>>'+trigger.new);
            handlerContactData con = new handlerContactData(trigger.new);
            con.checkRecordData();
        }
    }

    //===== Prevent Duplication record Start Here
    if(trigger.isInsert && trigger.isBefore){
        handlerDuplicateContact.checkBeforeInsert(trigger.new);
    }

    if(trigger.isUpdate && trigger.isBefore){
        System.debug('Call Before Update====>>>>>>>>');
        handlerDuplicateContact.checkBeforeUpdate(trigger.new,trigger.old);
    }

    //==== Set Only one Primary COntact on Account =================
    if (trigger.isBefore && trigger.isUpdate) {
        System.debug('handlerSetPrimaryContact Apex class Call ==>> handlerPirmaryContactMethod');
        handlerSetPrimaryContact.handlerPirmaryContactMethod(trigger.new,trigger.oldMap);
    }





}
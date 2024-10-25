trigger AllEmployeeTrigger on Employee__c (after insert,after update, after undelete,after delete) {

    if (trigger.isAfter && (trigger.isInsert || trigger.IsUndelete)) {
        handlerEmployeeTrigger.handlerSalaryData(trigger.new,null);
    }else if(trigger.isUpdate && trigger.isAfter){
        handlerEmployeeTrigger.handlerSalaryData(trigger.new,trigger.oldMap);
    }else if(trigger.isDelete && trigger.isAfter){
        handlerEmployeeTrigger.handlerSalaryData(trigger.old,null);
    }


}
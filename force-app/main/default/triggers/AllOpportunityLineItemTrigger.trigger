trigger AllOpportunityLineItemTrigger on OpportunityLineItem (after insert,after update,after delete) {

    if (trigger.isAfter && trigger.isInsert) {
        HandlerOpportunityLineItem1.oppLineCallMethod(trigger.new);
    }
    if (trigger.isAfter && trigger.isDelete) {
        HandlerOpportunityLineItem1.oppLineCallMethod(trigger.old);
    }

    if (trigger.isAfter && trigger.isInsert) {
        HandlerOppLineItemAssetCreate2.craeteAssetMethod(trigger.new);
    }

    if (trigger.isUpdate && trigger.isAfter) {
        HandlerOPLUpdateCountOnAccount.handleUpdateAccountCount(trigger.new);
    }

}
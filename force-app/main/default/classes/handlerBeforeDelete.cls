public class handlerBeforeDelete {
    
    Public static Boolean firstcall=false;    
   
    Map<Id, Account> oldacc;
   // Map<Id, Account> newOpps;    
    public handlerBeforeDelete(
        Map<Id, Account> oldTriggeracc) {
            oldacc = oldTriggeracc;
         //   newOpps = newTriggerOpps;
        }

    public void deleteCheckInAccount(){

        if (!oldacc.isEmpty()) {
            for (Account acc : oldacc.values()) {
               if (acc.Is_Active__c == true) {
                  acc.addError('You Cant Delete Active Account');
                  System.debug('You Cant Delete Active Account');
               }
               
            }
        }

    }
}
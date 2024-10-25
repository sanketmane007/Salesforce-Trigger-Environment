//==== This Class in Call from Apex Trigger ===========AllAccountTrigger==========
public with sharing class handlerSendEmailTrigger {
    
    public static void sendEMailMethod(List<Account> accList,Map<Id,Account> oldAccMap){
        System.debug('Email Send Handler Start=========>>>>>>>>>>');
        System.debug('accList=========>>>>>>>>>>'+accList);
        System.debug('oldAccMap=========>>>>>>>>>>'+oldAccMap);
        Set<Id> accIds =new Set<Id>();
        for (Account acc : accList) {
            if (acc.Type !=oldAccMap.get(acc.Id).Type ) {
                accIds.add(acc.id);
            }
        }
        System.debug('accIds=========>>>>>>>>>>'+accIds);
       
            System.debug('Here Mail Method Start0');
            List<Contact> conList =[SELECT id,Email,LastName FROM Contact WHERE AccountId IN: accIds];
            List<Messaging.SingleEmailMessage> senEMailList = new List<Messaging.SingleEmailMessage>();
            if (!conList.isEmpty()) {
            for (Contact con : conList) {
                if (con.Email != null) {
                    System.debug('Here Mail Method Start 1');
                    Messaging.SingleEmailMessage sm =new Messaging.SingleEmailMessage();
                    sm.setTargetObjectId(con.id);
                    sm.setSenderDisplayName('Send EMail WHEN Account Update test');
                    sm.setSubject('Account Update Info');
    
                    String body = 'hi '+con.LastName+' '+'Account is Update Test Mail'+',</br>';
                    body += 'Your Account Type has been updated Successfully';
    
                    sm.setHtmlBody(body);
                    sm.toaddresses = new String[]{'work.surajmane@gmail.com'};
                   
                    senEMailList.add(sm);

                //    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {sm};
                //     Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                   // System.debug('results===>>'+results);
                }  
            }
        }
           // System.debug('senEMailList=========>>>>>>>>>>'+senEMailList);
            if (!senEMailList.isEmpty()) {
                System.debug('Mail Send=========>>>>>>>>>>');
                Messaging.sendEmail(senEMailList);
            }
          
        
           }
}
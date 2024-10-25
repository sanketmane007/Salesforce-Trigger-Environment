public with sharing class handlerDuplicateContact {
    // Handler Trigger Class
    public static void checkBeforeInsert(List<Contact> lstCon){

        Map<String,Contact> mapEmail =new Map<String,Contact>();
      
        for (Contact con : lstCon) {
            
            if (con.Email != null && mapEmail.get(con.Email)!=null) {
                con.addError('EMail ALrady Exist 10 !!'); 
            }else if(con.Email != null){
                mapEmail.put(con.Email, con);
            }
        }

        List<Contact> conList =[SELECT Id,Email,Phone FROM COntact 
                                WHERE 
                                Email IN:mapEmail.keySet()
                               // OR Phone IN: mapPhone.keySet()
                                 ];

            for (Contact cls : conList) {
             Contact con = mapEmail.get(cls.Email);
             con.addError('Email Alredy Exist In Insert Scenario!!!');
            }

    }

    public static void checkBeforeUpdate(List<Contact> lstCon,List<Contact> lstOld){
System.debug('Update Handler Calss Call====>>>>>>>>');
    Map<Id,Contact> lstOldMap =new Map<Id,Contact>();

        for (Contact con :lstOld ) {
            lstOldMap.put(con.Id,con);
        }

        Set<String> emailVal =new Set<String>();
        Map<String,Contact> conMap =new Map<String,Contact>();
        for (Contact con : lstCon) {
            System.debug('lstOldMap.get(con.Id).Email ===>>>'+lstOldMap.get(con.Id).Email);
            if(con.Email !=null && lstOldMap.get(con.Id).Email != con.Email){
                emailVal.add(con.Email);
                conMap.put(con.Email, con);
            }
        }

        
        Map<String,Contact> conMap2 =new Map<String,Contact>([SELECT Id,Email 
                                                            FROM Contact
                                                            WHERE Email IN:emailVal]);
     

        for (Contact con : conMap2.values()) {
             //Contact con = conMap.get(con.Email);
             if(conMap.get(con.Email) !=null) {
                Contact con1 = conMap.get(con.Email);
                con1.addError('Email Duplication Error In Update');
             }
             
        }

    }
}
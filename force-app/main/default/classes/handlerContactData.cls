public with sharing class handlerContactData {
     // Handler Trigger Class
    List<Contact> conMap;
    public handlerContactData(List<Contact> con) {
        conMap = con;
    }

    public void checkRecordData(){

        set<Id> accIds =new Set<Id>();
        System.debug('accIds==>>>'+accIds);
        if (!conMap.isEmpty()) {
            for (Contact con : conMap) {
                if(con.AccountId != null){
                    accIds.add(con.AccountId);
                }
            }   
        }

        Map<Id,Integer> conMap2 =new Map<Id,Integer>();
        if (!accIds.isEmpty()) {
            List<AggregateResult> lstAggr =[SELECT AccountId,Count(Id) contactCount 
                                            FROM Contact  
                                            WHERE AccountId IN:accIds GROUP BY AccountId];

          for(AggregateResult agg : lstAggr){
              conMap2.put((Id)agg.get('AccountId'),(Integer)agg.get('contactCount'));
            }


            for (Contact con1 : conMap) {
                if (con1.AccountId != null && conMap2.get(con1.AccountId)>2) {
                    con1.addError('You Can Not Add New Contact on one Account = Limit 2 Alredy Exceed');
                }
            }
        }
    }
}
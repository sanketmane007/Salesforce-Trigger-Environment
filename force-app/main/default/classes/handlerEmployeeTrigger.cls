public with sharing class handlerEmployeeTrigger {
 
    ///========== This handler Method Call From AllEmployeeTrigger Trigger =======================
    public static void handlerSalaryData(List<Employee__c> empList, Map<Id,Employee__c> empMap){

        Set<Id> empIds =new Set<Id>();

      for (Employee__c emp : empList) {
            if (empMap!=null) {

                if (empMap.get(emp.Id).Tech_Firm__c != emp.Tech_Firm__c ) {
                    empIds.add(empMap.get(emp.Id).Tech_Firm__c);
                    empIds.add(emp.Tech_Firm__c);
                }else {
                    empIds.add(emp.Tech_Firm__c);
                }

            }else {
                empIds.add(emp.Tech_Firm__c);
            }
      }

      List<AggregateResult> lstAggregate = [SELECT Tech_Firm__c techFirm,
                                            min(Salary__c) minSalary,max(Salary__c) maxSalary 
                                            FROM Employee__c WHERE 
                                            Tech_Firm__c IN:empIds GROUP BY Tech_Firm__c];
    List<Tech_Firm__c> lstUpdateTech = new List<Tech_Firm__c>();
        for (AggregateResult lstAgg : lstAggregate) {
            
            Tech_Firm__c tech = new Tech_Firm__c();
            tech.Id = (Id)lstAgg.get('techFirm');
            tech.Max_Salary__c = String.valueOf(lstAgg.get('maxSalary'));
            tech.Min_Salary__c = String.valueOf(lstAgg.get('minSalary'));
            lstUpdateTech.add(tech);

        }
        if (!lstUpdateTech.isEmpty()) {
            update lstUpdateTech;
        }

    }

}
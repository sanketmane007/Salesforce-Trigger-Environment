public with sharing class CustomEmployeeController {
   
    public static void handlerMethod(){

        List<Employee__c> lstEmp = [SELECT Id FROM Employee__c LIMIT 1];

    }
}
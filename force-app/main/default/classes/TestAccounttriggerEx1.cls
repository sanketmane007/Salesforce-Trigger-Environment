@isTest //Annotation so that salesforce can undertand this is test class
public class TestAccounttriggerEx1 {
    //Defind testmethod keyword while defining method 
    public static testMethod void testInsert(){
        //Defind variables
        String addError;
        String myname = 'SalesforceKid';
        //Create an instance of an object on which you want to check this trigger is working or not. 
        Account a2 = new Account(name = myname);
        //Query 
        List<Account> x =[SELECT Id, Name FROM Account WHERE Name=:myname];
        if(x.size() < 1){
            //Check if list is empty  
            System.assertEquals(0, x.size());
            //Insert the record
            Insert a2;
        }else{
            //Otherwise show error if there is something in the list with same name
            addError ='Existing';
        }
        //Check whether the error you are getting is similar to the one you added
        System.assertEquals('Existing', addError);
    }
}
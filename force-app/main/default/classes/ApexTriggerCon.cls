public class ApexTriggerCon {

    // Use case 8: Whenever a Contact is created without an associated Account, prevent the insertion and display an error message "Add Account".
    public static void beforeIns(List<Contact> newCon){
        for(Contact c : newCon){
            if(c.AccountId== null){
				c.addError('Add Account');
            }
        }
    }

    // Use case 14: Whenever a Contact is created, check for duplicates based on Last Name, Email, and Phone. If a duplicate is found, prevent the insertion and display an error message "Duplicate Contact found with same Last Name, Email, or Phone."
    public static void checkDuplicateCon(List<Contact> newCon){
        List<Contact> conList=[SELECT Id, LastName, Email, Phone FROM Contact LIMIT 50000];
        for(Contact c : newCon){
            for(Contact existingC : conList){
                if(c.LastName == existingC.LastName && 
                   c.Email == existingC.Email && 
                   c.Phone == existingC.Phone){
                    c.addError('Duplicate Contact found with same Last Name, Email, or Phone.');
                }
            }
        }
    }
}
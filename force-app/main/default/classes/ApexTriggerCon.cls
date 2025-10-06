public class ApexTriggerCon {
    public static void beforeIns(List<Contact> newCon){
        for(Contact c : newCon){
            if(c.AccountId== null){
				c.addError('Add Account');
            }
        }
    }

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
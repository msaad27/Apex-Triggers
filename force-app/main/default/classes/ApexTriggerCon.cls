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

    // Use case 17 : Share the contact record with a public group as soon as a record is created
    public static void shareCon(List<Contact> newCon){
        Id conPublicGroup = [SELECT Id FROM Group WHERE Name='Contact Public Group' LIMIT 1].Id;
         List<ContactShare> conShareList = new List<ContactShare>();
        for(Contact con : newCon){
            ContactShare conShare = new ContactShare();
            conShare.ContactId = con.Id;
            conShare.RowCause = 'Manual';
            conShare.UserOrGroupId = conPublicGroup;
            conShare.ContactAccessLevel = 'Edit';
            conShareList.add(conShare);
        }
        if (!conShareList.isEmpty()) {
            insert conShareList;
            
        }
             
        }
    
}
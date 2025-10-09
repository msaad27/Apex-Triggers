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

            // Use case 21 : Whenever a Contact record is created, copy BillingAddress of Account to MailingAddress on Contact
            List<Id> accId=new List<Id>();
            for(Contact con : newCon){
                accId.add(con.AccountId);
            }
            Map<Id,Account> accMap=new Map<Id,Account>([SELECT Id,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry FROM Account WHERE Id IN :accId]);
            for(Contact con: newCon){
                if(accMap.containsKey(con.AccountId)){
                    con.MailingStreet=accMap.get(con.AccountId).BillingStreet;
                    con.MailingCity=accMap.get(con.AccountId).BillingCity;
                    con.MailingState=accMap.get(con.AccountId).BillingState;
                    con.MailingPostalCode=accMap.get(con.AccountId).BillingPostalCode;
                    con.MailingCountry=accMap.get(con.AccountId).BillingCountry;
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


        // Use case 20 : Send an email to the Account Owner when email or phone of a child contact is modified
        public static void sendEmail(List<Contact> newCon,Map<Id,Contact> oldMap){
            List<Id> accIds = new List<Id>();
            for(Contact con : newCon){
                if(con.AccountId != null){
                    if(con.Email != oldMap.get(con.Id).Email || con.Phone != oldMap.get(con.Id).Phone){
                        accIds.add(con.AccountId);
                    }
                }
            }
            if (!accIds.isEmpty()) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> toAddresses = new List<String>();
                List<Account> accounts = [SELECT Owner.Email FROM Account WHERE Id IN :accIds];
                for(Account acc : accounts){
                    toAddresses.add(acc.Owner.Email);
                }
                mail.setToAddresses(toAddresses);
                mail.setSubject('Contact Information Updated');
                mail.setPlainTextBody('The email or phone number of a child contact has been modified.');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

            }
        }
}
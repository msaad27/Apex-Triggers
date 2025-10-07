public class ApexTriggerAcc {

    // Use case 9: Whenever an Account's Industry is 'Agriculture', Type is 'Prospect', and Ownership is 'Private', prevent any changes to the Ownership field and display an error message "Can't change".
    public static void handleActivity(List<Account> newAcc,Map<Id,Account> oldMap){
        for(Account acc : newAcc){
            if(acc.Industry=='Agriculture' && acc.Type=='Prospect' && acc.Ownership=='Private'){
                if(oldMap.get(acc.Id).OwnerShip != acc.Ownership){
                    acc.addError('Cant change');
                }
            }
        }
    }

    // Use case 10: Whenever an Account's Website field is updated, update the Website__c field on all related Contacts to match the new Website value.
    public static void updatefield(List<Account> accRec,Map<Id,Account> oldMap){
        Map<Id,String> accToWebsite = new Map<Id,String>();
        for(Account acc : accRec){
            if(acc.Website != oldMap.get(acc.Id).Website){
                accToWebsite.put(acc.Id,acc.Website);
            }
            
        }
        if(accToWebsite.keySet().size()>0){
            List<Contact> conToUpdate = new List<Contact>();
            List<Contact> conRec=[Select Id,FirstName,Website__c,AccountId FROM Contact Where AccountID IN :accToWebsite.keyset()];
            for(Contact con : conRec){
                con.Website__c = accToWebsite.get(con.AccountId);
                conToUpdate.add(con);
            }
            if(conToUpdate.size()>0){
                update conToUpdate;
            }
        }
    }  

    // Use case 11: Whenever an Account is created, create a number of Contacts equal to the value in the Create_Contact__c field. Each Contact's Last Name should be set to the Account's Name followed by a unique number (e.g., "AccountName 1", "AccountName 2", etc.).
    public static void insertCon(List<Account> newAcc){
        List<Contact> conList = new List<Contact>();
        for(Account acc : newAcc){
            for(Integer i=1; i<= acc.Create_Contact__c;i++){
			Contact con = new Contact();
               con.AccountId=acc.Id;
                con.LastName=acc.Name+' '+i;
                conList.add(con);
            }
        }
        if(!conList.isEmpty()){
            insert conList;
        }
    }
}
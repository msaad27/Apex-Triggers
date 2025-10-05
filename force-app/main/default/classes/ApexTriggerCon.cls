public class ApexTriggerCon {
    public static void beforeIns(List<Contact> newCon){
        for(Contact c : newCon){
            if(c.AccountId== null){
				c.addError('Add Account');
            }
        }
    }
}
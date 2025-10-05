public class ApexTriggerLead {
    public static void updateStatus(List<Lead> updateLeadStatus){
        for(Lead newlead:updateLeadStatus ){
		newlead.Status='Working - Contacted';
        }
    }
    public static void updateSource(List<Lead> leadRec){
        for(Lead newLeadRec:leadRec ){

            if(newLeadRec.Industry=='Healthcare'){
			newLeadRec.LeadSource='Purchase List';
            newLeadRec.SICCode__c='1100';
            newLeadRec.Primary__c='Yes';
            }
            else {
                // Clear fields if Industry is NOT Healthcare
                newLeadRec.LeadSource = '';
                newLeadRec.SICCode__c = '';
                newLeadRec.Primary__c = '';
            }
        }
    }
    public static void createTask(List<Lead> newRec){
        List<Task> insertTask=new List<Task>();
        
        for(Lead l: newRec){
		Task taskRec = new Task();
            taskRec.OwnerId=l.OwnerId;
            taskRec.Description='Follow up';
            taskRec.WhoId=l.Id;
			insertTask.add(taskRec);           
        }
        if(!insertTask.isEmpty()){
            insert insertTask;
        }
    }
}
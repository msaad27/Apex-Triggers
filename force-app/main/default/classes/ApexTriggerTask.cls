public class ApexTriggerTask {
    // Use case 1 : Whenever a Task is created, set the Priority to High
    public static void setPriority(List<Task> newTask){
        for(Task t:newTask){
		t.Priority='High';
        t.Status='In Progress';
        }
    }

    //Use case 19: Whenever a Task is created, increment a custom field 'Task_Count__c' on the User object by 1 for the User who is the Owner of the Task.
    public static void incrementTaskCount(List<Task> newTask){
        Map<Id,Integer> conCountMap=new Map<Id,Integer>();
        for(Task t: newTask){
            if(String.valueOf(t.WhoId).startsWith('003')){
                if(conCountMap.containsKey(t.WhoId)){
                    Integer countVar=conCountMap.get(t.WhoId)+1;
                    conCountMap.put(t.WhoId,countVar);
                }
                else{
                    conCountMap.put(t.WhoId,1);
                }
            }
        }
        List<Contact> conToUpdate=new List<Contact>();
        List<Contact> conList =[SELECT Id, Number_of_Tasks__c FROM Contact WHERE Id IN :conCountMap.keySet()];
        for(Contact con: conList){
            if(con.Number_of_Tasks__c != null){
                con.Number_of_Tasks__c=con.Number_of_Tasks__c+conCountMap.get(con.Id);

            }
            else{
                con.Number_of_Tasks__c=conCountMap.get(con.Id);
            }
            conToUpdate.add(con);
        }
        if(!conToUpdate.isEmpty()){
            update conToUpdate;
        }
    }
}
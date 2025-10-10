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

    //Use case 22 : Allow updating the Task record only if the parent Contact’s Account has the Permission checked
    public static void handleBeforeUpdate(List<Task> newTask){
        List<Id> conIdList=new List<Id>();
        Map<Id,Id> taskvsconMMap=new Map<Id,Id>();
        Map<Id,Id> conVsAccMap=new Map<Id,Id>();
        for(Task t:newTask){
            if(String.valueOf(t.WhoId).startsWith('003')){
                conIdList.add(t.WhoId);
                taskvsconMMap.put(t.Id,t.WhoId);
            }
        }
     Map<Id,Account> accRecMap=new Map<Id,Account>([SELECT Id,Modify_Task__c FROM Account WHERE ID IN (SELECT AccountId FROM Contact WHERE Id IN :conIdList )]);
    List<Contact> conList=[SELECT Id,AccountId FROM Contact WHERE Id IN :conIdList];
    for(Contact con:conList){
        conVsAccMap.put(con.Id,con.AccountId);
     }
     for(Task t:newTask){
        if(!accRecMap.get(conVsAccMap.get(taskvsconMMap.get(t.Id))).Modify_Task__c){
            t.addError('You cannot modify this Task as the parent Account does not have permission to modify Tasks.');

        }
     }
    }
     

}
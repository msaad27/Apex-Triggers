public class ApexTriggerTask {
    // Use case 1 : Whenever a Task is created, set the Priority to High
    public static void setPriority(List<Task> newTask){
        for(Task t:newTask){
		t.Priority='High';
        t.Status='In Progress';
        }
    }
}
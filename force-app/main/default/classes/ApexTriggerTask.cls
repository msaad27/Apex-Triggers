public class ApexTriggerTask {
    public static void setPriority(List<Task> newTask){
        for(Task t:newTask){
		t.Priority='High';
        t.Status='In Progress';
        }
    }
}
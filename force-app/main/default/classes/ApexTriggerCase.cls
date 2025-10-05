public class ApexTriggerCase {
    public static void changePriority(List<Case> cases){
        for(Case c: cases){
            
            if(c.Origin=='Phone'){
				c.Priority='High';
            }
            else c.Priority='Low';
        }
    }
 
}
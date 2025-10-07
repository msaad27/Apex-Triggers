public class ApexTriggerCase {
    // Use case 3 : Whenever a Case is created & Case Origin is Phone, Set Priority as High, else set Priority as Low
    public static void changePriority(List<Case> cases){
        for(Case c: cases){
            
            if(c.Origin=='Phone'){
				c.Priority='High';
            }
            else c.Priority='Low';
        }
    }
 
}
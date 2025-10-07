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

    //Use case 16 : Allow Case Deletion only by System Admin users
    public static void preventCaseDel(List<Case> caseRec){
        Id currentUserId=UserInfo.getUserId();
        Id sysAdminProfileId=[SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1].Id;
        if(currentUserId!=sysAdminProfileId){
            for(Case c : caseRec){
                c.addError('Only System Admin can delete Case');
            }
        }
    }
        
}
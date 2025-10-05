public class ApexTriggerOpp {
   public static void createTask(List<Opportunity> newOpp){
        List<Task> insertTask=new List<Task>();
        for(Opportunity opp: newOpp){
            if(opp.StageName=='Closed Won'){
                
              Task taskRec=new Task();
                taskRec.Priority='High';
                taskRec.OwnerId= opp.OwnerId;
                taskRec.Description='Split Revenue';
                taskRec.Status='Not Started';
                taskRec.WhatId=opp.Id;
                
                insertTask.add(taskRec);
            }
        }
        if(!insertTask.isEmpty()){
		insert insertTask;
        }
    }
    public static void modifyOpp(List<Opportunity> oppRec,Map<Id,Opportunity> oldMap){
        for(Opportunity opp : oppRec){
            if(oldMap.get(opp.Id).StageName != opp.StageName){
                opp.Amount=opp.Probability*opp.ExpectedRevenue;
            }
        }
    }
}
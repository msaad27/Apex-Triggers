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
    public static void createTaskForOwner(List<Opportunity> oppRec) {
        Set<Id> accId = new Set<Id>();
        Map<Id, Id> oppvsAccId = new Map<Id, Id>();
        Map<Id, Id> accIdvsOwnerId = new Map<Id, Id>();
        for(Opportunity opp : oppRec){
            accId.add(opp.AccountId);
            oppvsAccId.put(opp.Id, opp.AccountId);
        }
        List<Account> accountRecords = [SELECT Id, OwnerId FROM Account WHERE Id IN :accId];
        for(Account acc: accountRecords){
            accIdvsOwnerId.put(acc.Id, acc.OwnerId);
        }
       List<Task> taskRecList = new List<Task>();
        for(Opportunity opp : oppRec){
        Task taskRec = new Task();
        taskRec.Description = 'Opportunity Deleted';
        taskRec.OwnerId=oppvsAccId.get(accIdvsOwnerId.get(opp.Id));
        taskRec.Priority = 'High';
        taskRec.Status = 'Not Started';
        taskRec.Subject = 'Opportunity Deletion Alert';
        taskRecList.add(taskRec);
       }
         if(!taskRecList.isEmpty()){
          insert taskRecList;
         }
    }
}
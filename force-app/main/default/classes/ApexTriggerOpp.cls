public class ApexTriggerOpp {


    // Use case 5: Whenever an Opportunity is created with StageName as 'Closed Won', create a Task with Priority as 'High', Status as 'Not Started', Description as 'Split Revenue', and assign it to the Opportunity Owner.
   public static void createTask(List<Opportunity> newOpp){
        List<Task> insertTask=new List<Task>();
        List<OpportunityTeamMember> deleteMember=new List<OpportunityTeamMember>();
        List<Id> oppIds=new List<Id>();
        for(Opportunity opp: newOpp){
            oppIds.add(opp.Id);
        }

        List<OpportunityTeamMember> teamMembers=[SELECT Id,OpportunityId FROM OpportunityTeamMember WHERE OpportunityId IN :oppIds];
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

         // Use case 15 : Whenever an Opportunity is Closed Lost, remove all Opportunity Team Members from the Opportunity
            else if(opp.StageName=='Closed Lost'){
                for(OpportunityTeamMember member: teamMembers){
                    if(member.OpportunityId==opp.Id){
                        deleteMember.add(member);
                    }
                }

            }
        }
        if(!insertTask.isEmpty()){
		insert insertTask;
        }
        if(!deleteMember.isEmpty()){
            delete deleteMember;
        }
    }

    // Use case 7: Whenever an Opportunity's StageName is changed, update the Amount field to be the product of Probability and ExpectedRevenue.
    public static void modifyOpp(List<Opportunity> oppRec,Map<Id,Opportunity> oldMap){
        for(Opportunity opp : oppRec){
            if(oldMap.get(opp.Id).StageName != opp.StageName){
                opp.Amount=opp.Probability*opp.ExpectedRevenue;
            }
        }
    }

    //use case 13: Whenever an Opportunity is deleted, create a Task with Description as 'Opportunity Deleted' and assign it to the Account Owner associated with the deleted Opportunity. Set the Task's Priority to 'High', Status to 'Not Started', and Subject to 'Opportunity Deletion Alert'.
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

    //Use case 18 : As soon as Opportunity Stage reaches Needs Analysis, add all users of role Opportunists to the Team.
    public static void addTeamMembers(List<Opportunity> oppRec, Map<Id, Opportunity> oldMap){
        List<OpportunityTeamMember> oppMemberList = new List<OpportunityTeamMember>();
        List<User> userList = [SELECT Id FROM User WHERE isActive=true AND UserRole.Name = 'Opportunists'];
        for(Opportunity opp : oppRec){
            if(opp.StageName == 'Needs Analysis' && opp.StageName!= oldMap.get(opp.Id).StageName){
                for(User userRec : userList){
                    OpportunityTeamMember oppTeamMember = new OpportunityTeamMember();
                    oppTeamMember.OpportunityId = opp.Id;
                    oppTeamMember.UserId = userRec.Id;
                    oppTeamMember.OpportunityAccessLevel = 'Edit';
                    oppMemberList.add(oppTeamMember);
                }
            }
        }
        if(!oppMemberList.isEmpty()){
            insert oppMemberList;
        }
    }
        

   
}
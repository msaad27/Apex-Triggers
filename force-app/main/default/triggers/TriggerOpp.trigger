trigger TriggerOpp on Opportunity (after update,before update,after delete) {
    if(trigger.isAfter && trigger.isUpdate){
		ApexTriggerOpp.createTask(Trigger.new);
    }
    if(trigger.isBefore && trigger.isUpdate){
        ApexTriggerOpp.modifyOpp(trigger.new,trigger.oldMap);
    }
    if(trigger.isAfter && trigger.isDelete){
        ApexTriggerOpp.createTaskForOwner(Trigger.old);
    }

  }
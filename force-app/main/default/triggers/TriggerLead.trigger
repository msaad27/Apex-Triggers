trigger TriggerLead on Lead (before update,after insert,before delete) {
    if(Trigger.isBefore && Trigger.isUpdate){
		ApexTriggerLead.updateStatus(Trigger.new);
        ApexTriggerLead.updateSource(Trigger.new);
    }
    if(trigger.isAfter && trigger.isInsert){
        ApexTriggerLead.createTask(trigger.new);
    }
    if(trigger.isBefore && trigger.isDelete){
       ApexTriggerLead.preventDel(trigger.old);
    }
    if(trigger.isBefore && trigger.isUpdate){
        ApexTriggerLead.validIndustry(trigger.new);
    }
}
trigger TriggerLead on Lead (before update,after insert) {
    if(Trigger.isBefore && Trigger.isUpdate){
		ApexTriggerLead.updateStatus(Trigger.new);
        ApexTriggerLead.updateSource(Trigger.new);
    }
    if(trigger.isAfter && trigger.isInsert){
        ApexTriggerLead.createTask(trigger.new);
    }
}
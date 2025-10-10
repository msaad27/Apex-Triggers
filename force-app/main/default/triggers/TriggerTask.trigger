trigger TriggerTask on Task (before insert,after insert,before update) {
	if(Trigger.isBefore&& Trigger.isInsert)

        {
            ApexTriggerTask.setPriority(Trigger.new);
        }
    if(Trigger.isAfter && Trigger.isInsert) {
        ApexTriggerTask.incrementTaskCount(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate) {
        ApexTriggerTask.handleBeforeUpdate(Trigger.new);
    }
}
trigger TriggerTask on Task (before insert,after insert) {
	if(Trigger.isBefore&& Trigger.isInsert)

        {
            ApexTriggerTask.setPriority(Trigger.new);
        }
    if(Trigger.isAfter && Trigger.isInsert) {
        ApexTriggerTask.incrementTaskCount(Trigger.new);
    }
}
trigger TriggerTask on Task (before insert) {
	if(Trigger.isBefore&& Trigger.isInsert)

        {
            ApexTriggerTask.setPriority(Trigger.new);
        }
}